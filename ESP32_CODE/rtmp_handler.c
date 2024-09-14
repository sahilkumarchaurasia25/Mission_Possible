#include "media_lib_os.h"
#include "rtmp_handler.h"
#include "rtmp_app_setting.h"
#include "esp_log.h"
#include "rtmp_push_app.h"
#include "DFRobot_AXP313A.h"
#include "globals.h"

int app_running = 0;
char *TAG_RTMP = "RTMP_MAIN";
rtmp_app_type_t rtmp_app_type = RTMP_APP_TYPE_PUSHER;
// #define SERVER_URL rtmp_server_url
#define SERVER_URL "rtmp://20.197.12.72:1935/live/myStream"
void app_thread(void *arg)
{
    rtmp_app_type_t app_type = (rtmp_app_type_t) (uint32_t) arg;
    if (app_type == RTMP_APP_TYPE_PUSHER) {
        rtmp_push_app_run(SERVER_URL);
        app_running--;
   
    }
    media_lib_thread_destroy(NULL);
}

void rtmp_start_app()
{
    rtmp_setting_set_allow_run(true);
    begin(0,0x36);
    enableCameraPower(OV2640);
    rtmp_app_type_t app_type = RTMP_APP_TYPE_PUSHER;
    if (app_running == 0) {
        media_lib_thread_handle_t thread_handle;
        if (app_type & RTMP_APP_TYPE_PUSHER) {
            app_running++;
            media_lib_thread_create(&thread_handle, "pusher", app_thread, (void *) RTMP_APP_TYPE_PUSHER, 64 * 1024, 10,
                                    1);
        }
        media_lib_thread_sleep(5000);
    } else {
        ESP_LOGI(TAG_RTMP, "Application still running, please wait!");
    }
}

int rtmp_stop_cli()
{
    rtmp_setting_set_allow_run(false);
    return 0;
}

// Function to extract stream key from the URL
void extract_stream_key(const char *url, char *stream_key) {
    // Define the pattern to search for
    const char *pattern = "/live/";
    char *key_start = strstr(url, pattern);
    
    if (key_start != NULL) {
        // Move the pointer to the start of the stream key
        key_start += strlen(pattern);
        
        // Copy the stream key to the provided buffer
        strcpy(stream_key, key_start);
    } else {
        // If the pattern is not found, set the stream key to an empty string
        stream_key[0] = '\0';
    }
}

// void jsonifyRtmpMessage(bool flag){
//     snprintf(json_str, sizeof(json_str), "{event: \"%s\",\ntype: \"%s\",\nmessage{}}",
//              event,token);
// }