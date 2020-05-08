//
//  BluetoothStatuses.h
//  Derailleur
//
//  Created by Ben Smith on 06/05/2020.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//

#ifndef BluetoothStatuses_h
#define BluetoothStatuses_h

#define BLUETOOTH_POWERED_OFF			0x00
#define BLUETOOTH_POWERED_ON_SCANNING	0x01
#define BLUETOOTH_UNAUTHORISED			0x02
#define BLUETOOTH_UNSUPPORTED			0x03

#define BIKE_DISCOVERED					0x04
#define BIKE_UNABLE_TO_CONNECT			0x05
#define BIKE_UNABLE_TO_DISCOVER			0x06
#define BIKE_ERROR						0x07
#define BIKE_DISCONNECT_REQUEST			0x08
#define BIKE_MESSAGE_UNKNOWN			0x09
#define BIKE_CONNECTED					0x0A
#define BIKE_CONNECTED_RECEIVING		0x0B

static const char *STATUS_MESSAGES[] = {
	"Bluetooth is powered off. Power it on in System Preferences to continue.",
	"Bluetooth powered on. Scanning for Flywheel bikes...",
	"Bluetooth use is unauthorised. You may lack the required privileges.",
	"Bluetooth is not supported on this device.",
	"Flywheel bike discovered. Attempting to connect...",
	"Unable to connect to your Flywheel bike in 60 seconds",
	"No Flywheel bikes found. Start pedaling to activate the Bluetooth in the bike.",
	"An unknown error has occurred",
	"Received a disconnect request from your Flywheel bike",
	"Your bike sent a message that could not be understood",
	"Connected to your Flywheel bike. Waiting for data",
	"Connected to your Flywheel bike. Receiving data"
};

#endif /* BluetoothStatuses_h */
