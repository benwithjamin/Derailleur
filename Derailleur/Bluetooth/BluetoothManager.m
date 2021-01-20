//
//	Derailleur
//	Copyright (c) 2020 Ben Smith
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//

#import "BluetoothManager.h"
#import "BikeData.h"

@implementation BluetoothManager
{
	/* CoreBluetooth properties */
	CBCentralManager *_centralManager;
	CBPeripheral *_connectedPeripheral;
	CBCharacteristic *_dataCharacteristic;
	CBCharacteristic *_commandCharacteristic;

	/* Connection timer */
	NSTimer *_pollTimer;
}

/* General properties */
int dataPacketLength;
int dataPacketIndex;
DecoderErrorState errorState;
DecoderRXState rxState;
BikeDataframe bikeData;

bool calibrationInProgress = false;

NSURL *logURL;

- (instancetype) init
{
	self = [super init];
	if (self) {
		_centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
	}
	return self;
}

- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central
{
	switch (central.state) {
		case CBManagerStateUnsupported:
			[_delegate didUpdateStatus:BLUETOOTH_UNSUPPORTED];
			break;
			
		case CBManagerStateUnauthorized:
			[_delegate didUpdateStatus:BLUETOOTH_UNAUTHORISED];
			break;
			
		case CBManagerStatePoweredOff:
			[_delegate didUpdateStatus:BLUETOOTH_POWERED_OFF];
			break;
			
		case CBManagerStatePoweredOn:
			[self startConnectAttempt];
			break;
			
		default:
			break;
	}
}

- (void)setDebugMode:(BOOL)debugMode
{
	_debugMode = debugMode;
	
	if (debugMode)
	{
		NSSavePanel *savePanel = [NSSavePanel savePanel];
		[savePanel setNameFieldStringValue:@"derailleur.log"];
		[savePanel setMessage:@"Select where you'd like Derailleur to save its log file"];
		[savePanel setShowsTagField:NO];
		
		[savePanel beginWithCompletionHandler:^(NSModalResponse result) {
			if (result == NSModalResponseOK)
			{
				logURL = [savePanel URL];
				[[NSFileManager defaultManager] createFileAtPath:[logURL path] contents:nil attributes:nil];
			}
		}];
	}
}

/* Start to try to connect to Flywheel bikes. Times out after 60 seconds. */
- (void)startConnectAttempt
{
	[_delegate didUpdateStatus:BLUETOOTH_POWERED_ON_SCANNING];
	[_centralManager scanForPeripheralsWithServices:nil options:nil];
	
	_pollTimer = [NSTimer scheduledTimerWithTimeInterval:SCAN_TIMEOUT target:self selector:@selector(didTimeoutWhileScanning) userInfo:nil repeats:NO];
}

/* Disconnect from the Flywheel bike, if it is connected */
- (void)disconnectBike
{
	if (_connectedPeripheral != nil)
	{
		[_delegate didUpdateStatus:BIKE_DISCONNECT_REQUEST];
		[_centralManager cancelPeripheralConnection:_connectedPeripheral];
		_connectedPeripheral = nil;
	}
}

/* Called if and when the Bluetooth scan does not find a Flywheel bike */
- (void)didTimeoutWhileScanning
{
	[_delegate didUpdateStatus:BIKE_UNABLE_TO_DISCOVER];
	[_pollTimer invalidate];
	
	[_centralManager stopScan];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
	NSString *deviceName;
	if (peripheral.name != NULL) {
		deviceName = peripheral.name;
	} else {
		deviceName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
	}
	
	if ([[deviceName lowercaseString] containsString:@"flywheel"]) {
		[_pollTimer invalidate];
		[_centralManager stopScan];
		
		_connectedPeripheral = peripheral;
		_connectedPeripheral.delegate = self;
		
		[_centralManager connectPeripheral:_connectedPeripheral options:nil];
		_pollTimer = [NSTimer scheduledTimerWithTimeInterval:CONNECT_TIMEOUT target:self selector:@selector(didTimeoutWhileConnecting) userInfo:nil repeats:NO];
		
		[_delegate didUpdateStatus:BIKE_DISCOVERED];
	} else {
		/* TODO: Let's log this so we can see what devices were found other than Flywheel bikes... */
	}
}

- (void)didTimeoutWhileConnecting
{
	[_delegate didUpdateStatus:BIKE_UNABLE_TO_CONNECT];
	[_pollTimer invalidate];
	
	[_centralManager cancelPeripheralConnection:_connectedPeripheral];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
	if (peripheral == _connectedPeripheral) {
		[_connectedPeripheral discoverServices: @[[CBUUID UUIDWithString:ICG_SERVICE_UUID]]];
		[_delegate didUpdateStatus:BIKE_CONNECTED];
		[_pollTimer invalidate];
	}
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
	for (CBService* currentService in peripheral.services)
	{
		if ([[currentService.UUID UUIDString] isEqual:ICG_SERVICE_UUID]) {
			[peripheral discoverCharacteristics:nil forService:currentService];
			return;
		}
	}
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
	for (CBCharacteristic* characteristic in service.characteristics)
	{
		if (characteristic.properties & CBCharacteristicPropertyNotify) {
			/** This is the characteristic where we get data from the bike */
			if ([[characteristic.UUID UUIDString] isEqual:ICG_DATA_CHARACTERISTIC_UUID]) {
				_dataCharacteristic = characteristic;
				[peripheral setNotifyValue:YES forCharacteristic:characteristic];
			}
		} else if (characteristic.properties & CBCharacteristicPropertyWrite) {
			/** This is the characteristic where we can send commands to the bike */
			if ([[characteristic.UUID UUIDString] isEqual:ICG_CMD_CHARACTERISTIC_UUID]) {
				_commandCharacteristic = characteristic;
			}
		}
	}
	
	/** Only if both characteristics are found should we connect, otherwise there should be an error */
	if (_dataCharacteristic != nil && _commandCharacteristic != nil) {
		[_delegate didUpdateStatus:BIKE_CONNECTED_RECEIVING];
		
		[self queryCalibrationState];
	}
}

uint8_t calculateChecksum(uint8_t buffer[], int size)
{
	uint8_t checksum = 0;
	
	for (int i = 1; i < size; i++) {
		checksum = (uint8_t) (buffer[i] ^ checksum);
	}
	
	return checksum;
}

/** Wrapper for sending a command to the bike */
- (void) sendCommand:(ICGMessageType)commandType withData:(NSData *)data
{
	NSMutableData *messageData = [[NSMutableData alloc] init];
	
	uint8_t messageHeader[] = { -1, data.length + 2, commandType };
	uint8_t checksum[] = { calculateChecksum(messageHeader, sizeof(messageHeader)) };
	uint8_t endOfMessage[] = { 0x55 };
	
	[messageData appendBytes:messageHeader length:sizeof(messageHeader)];
	[messageData appendBytes:checksum length:1];
	[messageData appendBytes:endOfMessage length:1];
	
	[_connectedPeripheral writeValue:messageData forCharacteristic:_commandCharacteristic type:CBCharacteristicWriteWithResponse];
}

/** Send a message to the bike asking whether it is calibrated or not */
- (void) queryCalibrationState
{
	[self sendCommand:BRAKE_CAL_DATA withData:nil];
}

/** Send a message to the bike asking to reset calibration */
- (void) resetBikeCalibration
{
	[self sendCommand:BRAKE_CALIBRATION_RESET withData:nil];
}

/** Send a message to the bike setting the minimum brake calibration level */
- (void) setMinimumCalibrationLevel
{
	[self sendCommand:BRAKE_CAL_MIN withData:nil];
}

/** Send a message to the bike setting the maximum brake calibration level */
- (void) setMaximumCalibrationLevel
{
	[self sendCommand:BRAKE_CAL_MAX withData:nil];
}

/** DEBUG FUNC */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	NSLog(@"wrote value");
}

void decodeReceivedData(char buffer[], int size)
{
	for (int i = 0; i < size; ++i) {
		byte b = buffer[i];
		
		switch (rxState) {
			case WFSYNC_1:
                if (b == -1) {
                    flushDataframe(&bikeData);
                    errorState = NO_ERROR;
                    rxState = WFLENGTH;
                } else {
					errorState = NO_ERROR;
                    rxState = WFSYNC_1;
                }
                break;
            case WFLENGTH:
				if (b == 0) {
                    errorState = MSG_WFSIZE;
                    rxState = WFSYNC_1;
                } else {
                    dataPacketIndex = 0;
                    dataPacketLength = b;
                    bikeData.len = b - 2;
                    rxState = WFID;
                }
                break;
            case WFID:
                if (b >= 0) {
                    bikeData.message_id = b;
                    if (dataPacketLength != 0) {
                        rxState = DATA;
                    } else {
                        rxState = CHECKSUM;
                    }
                } else {
                    errorState = MSG_UNKNOWN_ID;
                    rxState = WFSYNC_1;
                }
                break;
            case DATA:
                if (dataPacketLength == 0) {
                    rxState = CHECKSUM;
                }

                bikeData.buffer[dataPacketIndex] = b;
                dataPacketIndex++;
                dataPacketLength--;
                break;
            case CHECKSUM:
                /* TODO: Implement checksum */
                rxState = EOF_1;
                break;
            case EOF_1:
                /* End of frame byte is 0x55 */
                if (b == 0x55) {
                    errorState = MSG_COMPLETE;
                    rxState = WFSYNC_1;
                }
                break;
		}
	}
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	NSData *receivedData = characteristic.value;
	
	decodeReceivedData((char *)receivedData.bytes, (int)receivedData.length);
	
	if (_debugMode) {
		NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:[logURL path]];
		[handle seekToEndOfFile];
		[handle writeData:receivedData];
		[handle closeFile];
	}
	
	if (errorState == MSG_COMPLETE) {
		/** The bike is sending exercise data */
		if (bikeData.message_id == SEND_ICG_LIVE_STREAM_DATA) {
			ICGLiveStreamData *parsedData = (ICGLiveStreamData*) bikeData.buffer;
			[_delegate didReceiveData:parsedData];
			return;
		}
		
		/** The bike is responding with calibration data */
		if (bikeData.message_id == BRAKE_CAL_DATA) {
			if ((bikeData.buffer[4] & 255) == 0) {
				[_delegate didUpdateStatus:BIKE_NEEDS_CALIBRATION];
			}
			return;
		}
		
		if (bikeData.message_id == REQUEST_DISCONNECT) {
			[self disconnectBike];
			return;
		}
		
		[_delegate didUpdateStatus:BIKE_MESSAGE_UNKNOWN];
	}
}

@end
