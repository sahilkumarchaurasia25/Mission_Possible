#ifndef RTMP_HANDLER_H
#define RTMP_HANDLER_H

typedef enum {
    RTMP_APP_TYPE_PUSHER = 1,
    RTMP_APP_TYPE_SRC = 2,
    RTMP_APP_TYPE_SERVER = 4,
} rtmp_app_type_t;


void rtmp_start_app();
int rtmp_stop_cli();

#endif