#ifndef GW_MODEM_H
#define GW_MODEM_H

#define MODEM_CONNECT_BIT BIT0
#define MODEM_GOT_DATA_BIT BIT2
#define MODEM_GOT_IMEI_BIT BIT3

EventGroupHandle_t modem_eventgroup (void);
void modem_setup (void);
void modem_deinit (void);
// void modem_imei(void);
#endif
