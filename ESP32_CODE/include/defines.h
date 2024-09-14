#ifndef DEFINES_H
#define DEFINES_H

#include "board_pins.h"
#define MATRIX_TXD_PIN  D11
#define MATRIX_RXD_PIN  D12
#define BUF_SIZE (1024)

#define SCK_PIN SCK
#define MOSI_PIN MOSI
#define MISO_PIN MISO
#define SDA_PIN D6
#define RESET_PIN D7

// Define the maximum number of items in the queue
#define QUEUE_LENGTH 10
#define HOST_NAME "wss://pingu-driver.azurewebsites.net/mqtt"
#define DELIMITER "0000"
#define KEY "4D6574726F5269646540313233"

#define MODEM_POWER_ON 0

//json message types
#define RIDES_ASSIGNED_EVENT  "get_assigned_rides"
#define START_STREAMING_EVENT "start_streaming"
#define RES_STREAMING_EVENT   "res_streaming"
#define STOP_STREAMING_EVENT  "stop_streaming"
#define SCAN_RFID_EVENT       "scan_rfid"
#define CONFIRM_RFID_EVENT    "confirm_rfid"  
#define DEVICE_SETUP_EVENT    "device-setup"
#define DEVICE_SETUP_FAILED_EVENT "Unable to connect with server. Please contact support team"
#define JSON_TYPE             "JSON"
#define SCROLL_TYPE           "scroll-text"
#define AUDIO_TYPE            "audio"
#endif