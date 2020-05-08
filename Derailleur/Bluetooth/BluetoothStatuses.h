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
