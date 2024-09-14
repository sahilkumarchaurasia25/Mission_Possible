#ifndef MQTT_HANDLER_H
#define MQTT_HANDLER_H

void jsonifyResStreaming(char *event,char *type,char *tag);
void dejsonify(char *json_str); 
void mqtt_app_start(void);
int sendDataToServer(char *data);
#endif