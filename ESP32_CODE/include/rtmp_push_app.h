#ifndef _RTMP_PUSH_APP_H
#define _RTMP_PUSH_APP_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief        Run RTMP push application
 * @param        url: RTMP server url pattern rtmp://ipaddress:port/app_name/stream_name
 * @return       - 0: On success
 *               - Others: Fail to run
 */
int rtmp_push_app_run(char *uri);

#ifdef __cplusplus
}
#endif

#endif
