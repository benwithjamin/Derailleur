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

#ifndef BikeData_h
#define BikeData_h

#import <Foundation/Foundation.h>
#import <string.h>

#define ICG_SERVICE_UUID 				@"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
#define ICG_DATA_CHARACTERISTIC_UUID	@"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
#define ICG_CMD_CHARACTERISTIC_UUID		@"6E400002-B5A3-F393-E0A9-E50E24DCCA9E"

typedef char byte;

typedef enum DecoderRXState {
    WFSYNC_1,
    WFLENGTH,
    WFID,
    DATA,
    CHECKSUM,
    EOF_1
} DecoderRXState;

typedef enum DecoderErrorState {
    NO_ERROR,
    MSG_DATA_OK,
    MSG_COMPLETE,
    MSG_WFSIZE,
    MSG_BAD_CHECKSUM,
    MSG_BAD_EOF,
    UNKNOWN_STATE,
    MSG_UNKNOWN_ID
} DecoderErrorState;

typedef struct BikeDataframe {
    byte buffer[256];
    byte crc;
    byte len;
    byte message_id;
} BikeDataframe;

typedef struct ICGLiveStreamData {
	uint16_t power;
	uint16_t ftp_percent;
	uint8_t  training_zone;
	uint8_t  heart_rate;
	uint8_t	 heart_rate_percent_of_max;
	uint8_t  power_to_heart_rate_ratio;
	uint8_t  power_to_weight_ratio;
	uint8_t  cadence;
	uint16_t speed;
	uint8_t  brake_level;
	uint8_t  current_lap;
	uint32_t current_lap_time;
	uint16_t current_lap_distance;
	uint8_t  total_laps;
	uint32_t workout_time;
	uint16_t distance;
	uint16_t calories;
} ICGLiveStreamData;

typedef enum ICGMessageType {
    ID_NULL,
    GET_ALL_USER_DATA,
    SET_ALL_USER_DATA,
    GENERAL_STREAM_DATA,
    GET_PHONE_NAME,
    SET_PHONE_NAME,
    GET_WLAN_SSID,
    SET_WLAN_SSID,
    GET_WLAN_PW,
    SET_WLAN_PW,
    GET_IP_ADDRESS,
    SET_IP_ADDRESS,
    SEND_ICG_LIVE_STREAM_DATA,
    SEND_ICG_AGGREGATED_STREAM_DATA,
    GET_FTP_TEST_RESULT,
    SET_FTP_TEST_RESULT,
    REQUEST_DISCONNECT,
    ENTER_PROGRAM_MODE,
    FLASH_PAGE_DATA,
    FLASH_PAGE_INVALID,
    FLASH_PAGE_REQ,
    FLASH_PAGE_RECV,
    CALL_APPLICATION,
    GET_PAGE_COUNT,
    SET_PAGE_COUNT,
    UPD_GET_CHECKSUM,
    UPD_SET_CHECKSUM,
    SEND_ICG_POWER_TEST_STREAM_DATA,
    REQUEST_WIFI_RESTART,
    BRAKE_CALIBRATION_RESET,
    BRAKE_CAL_MIN,
    BRAKE_CAL_MAX,
    BRAKE_CAL_DATA,
    FIRMWARE_VERSIONS,
    SET_BIKE_ID,
    GET_BIKE_ID,
    LAST_VALUE
} ICGMessageType;

void flushDataframe(BikeDataframe *dataFrame);

#endif /* BikeData_h */
