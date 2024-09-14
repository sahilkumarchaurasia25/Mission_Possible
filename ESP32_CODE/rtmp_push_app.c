/* RTMP push application to publish data to RTMP server

   This example code is in the Public Domain (or CC0 licensed, at your option.)

   Unless required by applicable law or agreed to in writing, this
   software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
   CONDITIONS OF ANY KIND, either express or implied.
*/

#include <string.h>
#include "esp_timer.h"
#include "rtmp_push_app.h"
#include "esp_rtmp_push.h"
#include "av_record.h"
#include "esp_log.h"
#include "media_lib_os.h"
#include "rtmp_app_setting.h"

#define TAG                         "RTMP Push_App"
#define RTMP_PUSH_CHUNK_SIZE        (1024 * 4)

#define RTMP_PUSH_VIDEO_SRC         RECORD_SRC_TYPE_SPI_CAM
#define MAX_RETRY_COUNT 5

static esp_rtmp_video_codec_t map_video_codec(av_record_video_fmt_t codec)
{
    switch (codec) {
        case AV_RECORD_VIDEO_FMT_MJPEG:
            return RTMP_VIDEO_CODEC_MJPEG;
        case AV_RECORD_VIDEO_FMT_H264:
            return RTMP_VIDEO_CODEC_H264;
        default:
            return RTMP_VIDEO_CODEC_NONE;
    }
}

int rtmp_push_data_received(av_record_data_t *frame, void *ctx)
{
    esp_media_err_t ret = ESP_MEDIA_ERR_OK;
    rtmp_push_handle_t rtmp_push = (rtmp_push_handle_t) ctx;
    switch (frame->stream_type) {
        case AV_RECORD_STREAM_TYPE_VIDEO: {
            esp_rtmp_video_data_t video_data = {
                .pts = frame->pts,
                .key_frame = true,
                .data = frame->data,
                .size = frame->size,
            };
            ret = esp_rtmp_push_video(rtmp_push, &video_data);
            if (ret != ESP_MEDIA_ERR_OK) {
                ESP_LOGE(TAG, "Add video packet return %d", ret);
            }
            break;
        }
        default:
            break;
    }
    return (int) ret;
}

int rtmp_push_app_run(char *uri)
{
    int ret;
    media_lib_tls_cfg_t ssl_cfg;
    rtmp_push_cfg_t cfg = {
        .url = uri,
        .chunk_size = RTMP_PUSH_CHUNK_SIZE,
        .thread_cfg = {.priority = 10, .stack_size = 10*1024},
    };
    if (strncmp(uri, "rtmps://", 8) == 0) {
        cfg.ssl_cfg = &ssl_cfg;
        rtmp_setting_get_client_ssl_cfg(uri, &ssl_cfg);
    }
    ESP_LOGI(TAG, "Start to push to %s", uri);
    rtmp_push_handle_t rtmp_push = esp_rtmp_push_open(&cfg);
    if (rtmp_push == NULL) {
        ESP_LOGE(TAG, "Fail to open rtmp Pusher\n");
        return -1;
    }
    ret = record_src_register_default();
    esp_rtmp_video_info_t video_info = {
        .fps = rtmp_setting_get_video_fps(),
        .codec = map_video_codec(rtmp_setting_get_video_fmt()),
    };
    av_record_get_video_size(rtmp_setting_get_video_quality(), &video_info.width, &video_info.height);
    ret = esp_rtmp_push_set_video_info(rtmp_push, &video_info);
    ESP_LOGI(TAG, "Add video stream return %d", ret);
    int retry_count = 0;
    while ((ret = esp_rtmp_push_connect(rtmp_push)) != 0 && retry_count < MAX_RETRY_COUNT) {
    ESP_LOGE(TAG, "Fail to connect, ret %d. Retrying... (%d/%d)", ret, retry_count + 1, MAX_RETRY_COUNT);
    esp_rtmp_push_close(rtmp_push);
    retry_count++;
    media_lib_thread_sleep(1000); // Sleep for 1 second before retrying
    }
    if (ret == 0) {
        av_record_cfg_t record_cfg = {
            .video_src = RTMP_PUSH_VIDEO_SRC,
            .video_fmt = rtmp_setting_get_video_fmt(),
            .video_fps = rtmp_setting_get_video_fps(),
            .sw_jpeg_enc = rtmp_setting_get_sw_jpeg(),
            .video_quality = rtmp_setting_get_video_quality(),
            .data_cb = rtmp_push_data_received,
            .ctx = rtmp_push,
        };
        av_record_start(&record_cfg);
        while (av_record_running() && rtmp_setting_get_allow_run()) {
            media_lib_thread_sleep(1000);
        }
        av_record_stop();
    } else {
        ESP_LOGE(TAG, "Failed to connect after %d retries", MAX_RETRY_COUNT);
    }

    ret = esp_rtmp_push_close(rtmp_push);
    record_src_unregister_all();
    ESP_LOGI(TAG, "Close rtmp return %d\n", ret);
    return ret;
}
