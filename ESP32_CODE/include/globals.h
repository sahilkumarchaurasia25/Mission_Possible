#ifndef GLOBALS_H
#define GLOBALS_H

#include "defines.h"
#include "stdint.h"
#include "stdbool.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"

extern char Txdata[BUF_SIZE];
extern uint8_t uart_num_matrix;
extern char lteModemImei[20];
extern uint8_t mqttReconnectCount;
extern bool modemReset;
extern char rtmp_server_url[100];

typedef struct {
    char event[20];
    char type[20];
    char message[2000];
}json_message_t;
extern json_message_t jsonMessage;
extern char txbuff[50];
// Create a queue handle
extern QueueHandle_t xQueue;
extern char json_str[2048]; 
extern bool connectionFailed;
#endif