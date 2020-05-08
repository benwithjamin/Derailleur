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

/* CoreBluetooth properties */
CBCentralManager *_centralManager;
CBPeripheral *_connectedPeripheral;
CBCharacteristic *_currentCharacteristic;

/* General properties */
int dataPacketLength;
int dataPacketIndex;
DecoderErrorState errorState;
DecoderRXState rxState;
BikeDataframe bikeData;

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
			[_delegate didUpdateStatus:BLUETOOTH_POWERED_ON_SCANNING];
			[_centralManager scanForPeripheralsWithServices:nil options:nil];
			break;
			
		default:
			break;
	}
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
		[_centralManager stopScan];
		
		_connectedPeripheral = peripheral;
		_connectedPeripheral.delegate = self;
		
		[_centralManager connectPeripheral:_connectedPeripheral options:nil];
		
		[_delegate didUpdateStatus:BIKE_DISCOVERED];
	}
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
	if (peripheral == _connectedPeripheral) {
		[_connectedPeripheral discoverServices: @[[CBUUID UUIDWithString:ICG_SERVICE_UUID]]];
		[_delegate didUpdateStatus:BIKE_CONNECTED];
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
			[peripheral setNotifyValue:YES forCharacteristic:characteristic];
			
			if ([[characteristic.UUID UUIDString] isEqual:ICG_RX_UUID]) {
				_currentCharacteristic = characteristic;
				[_delegate didUpdateStatus:BIKE_CONNECTED_RECEIVING];
			}
		}
	}
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
	
	if (errorState == MSG_COMPLETE) {
		ICGLiveStreamData *parsedData = (ICGLiveStreamData*) bikeData.buffer;
		
		if (bikeData.message_id == SEND_ICG_LIVE_STREAM_DATA) {
			[_delegate didReceiveData:parsedData];
			return;
		}
		
		// TODO: Aggregated data and calibration
		if (bikeData.message_id == BRAKE_CALIBRATION_RESET) {
			
		}
		
		if (bikeData.message_id == SEND_ICG_AGGREGATED_STREAM_DATA) {
			
		}
		
		if (bikeData.message_id == REQUEST_DISCONNECT) {
			[_delegate didUpdateStatus:BIKE_DISCONNECT_REQUEST];
			[_centralManager cancelPeripheralConnection:_connectedPeripheral];
			_connectedPeripheral = nil;
			return;
		}
		
		[_delegate didUpdateStatus:BIKE_MESSAGE_UNKNOWN];
	}
}

@end
