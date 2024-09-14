#ifndef RFID_HANDLER_H
#define RFID_HANDLER_H

void rc522_init();
void RFIDRead();
void jsonifyRFIDTag(char *event,char *token);
#endif