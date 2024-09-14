#include "globals.h"

uint8_t uart_num_matrix = 2;
uint8_t mqttReconnectCount = 0;
bool modemReset;
char rtmp_server_url[100];
char Txdata[BUF_SIZE];
char lteModemImei[20]; 
json_message_t jsonMessage;
char json_str[2048]; 
char txbuff[50];
QueueHandle_t xQueue;
bool connectionFailed = false;