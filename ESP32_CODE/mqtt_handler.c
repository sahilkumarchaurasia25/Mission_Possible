#include <stdio.h>
#include "mqtt_handler.h"
#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include "esp_system.h"
#include "esp_event.h"
#include "freertos/event_groups.h"
#include "freertos/semphr.h"
#include "freertos/queue.h"
#include "lwip/dns.h"
#include "esp_log.h"
#include "mqtt_client.h"
#include "defines.h"
#include "globals.h"

const char *TAG_MQTT = "MQTTWSS";

extern const uint8_t mqtt_server_cert_io_pem_start[]   asm("_binary_server_cert_pem_start");
extern const uint8_t mqtt_server_cert_io_pem_end[]   asm("_binary_server_cert_pem_end");
esp_mqtt_client_handle_t client;
static esp_err_t mqtt_event_handler_cb(esp_mqtt_event_handle_t event)
{
    esp_mqtt_client_handle_t client = event->client;
    int msg_id;
    // your_context_t *context = event->context;
    switch (event->event_id) {
    case MQTT_EVENT_CONNECTED:
        ESP_LOGI(TAG_MQTT, "MQTT_EVENT_CONNECTED");
        msg_id = esp_mqtt_client_subscribe(client,lteModemImei,0);
        ESP_LOGI(TAG_MQTT, "sent subscribe successful, msg_id=%d", msg_id);
        break;
    case MQTT_EVENT_DISCONNECTED:
        ESP_LOGI(TAG_MQTT, "MQTT_EVENT_DISCONNECTED");
        break;
    case MQTT_EVENT_SUBSCRIBED:
        ESP_LOGI(TAG_MQTT, "MQTT_EVENT_SUBSCRIBED, msg_id=%d", event->msg_id);
        break;
    case MQTT_EVENT_UNSUBSCRIBED:
        ESP_LOGI(TAG_MQTT, "MQTT_EVENT_UNSUBSCRIBED, msg_id=%d", event->msg_id);
        break;
    case MQTT_EVENT_PUBLISHED:
        ESP_LOGI(TAG_MQTT, "MQTT_EVENT_PUBLISHED, msg_id=%d", event->msg_id);
        break;
    case MQTT_EVENT_DATA:
        ESP_LOGI(TAG_MQTT, "MQTT_EVENT_DATA");
        printf("DATA=%.*s\r\n", event->data_len, event->data);
        dejsonify(event->data);
        break;
    case MQTT_EVENT_ERROR:
        ESP_LOGI(TAG_MQTT, "MQTT_EVENT_ERROR");
        esp_err_t err = esp_mqtt_client_reconnect(client);
        if(err!=ESP_OK) mqttReconnectCount++;
        else mqttReconnectCount = 0;
        if(mqttReconnectCount>10) modemReset = true;
        break;
    default:
        ESP_LOGI(TAG_MQTT, "Other event id:%d", event->event_id);
        break;
    }
    return ESP_OK;
}

int sendDataToServer(char *data){
    return esp_mqtt_client_publish(client,lteModemImei, data, strlen(data), 0, 0);
}

static void mqtt_event_handler(void *handler_args, esp_event_base_t base, int32_t event_id, void *event_data)
{
    /* The argument passed to esp_mqtt_client_register_event can de accessed as handler_args*/
    ESP_LOGD(TAG_MQTT, "Event dispatched from event loop base=%s, event_id=%" PRIi32, base, event_id);
    mqtt_event_handler_cb(event_data);
}

void mqtt_app_start(void)
{   
    char client_id[128];
    sprintf(client_id,"/%s%s%s",lteModemImei,DELIMITER,KEY);
    const esp_mqtt_client_config_t mqtt_cfg = {
        .broker.address.uri = HOST_NAME,
        .broker.verification.certificate = (const char *)mqtt_server_cert_io_pem_start,
        .session.protocol_ver = MQTT_PROTOCOL_V_3_1_1,
        .credentials.client_id  = client_id,
    };

    ESP_LOGI(TAG_MQTT, "[APP] Free memory: %" PRIu32 " bytes", esp_get_free_heap_size());
    client = esp_mqtt_client_init(&mqtt_cfg);
    /* The last argument may be used to pass data to the event handler, in this example mqtt_event_handler */
    esp_mqtt_client_register_event(client, ESP_EVENT_ANY_ID, mqtt_event_handler, NULL);
    ESP_ERROR_CHECK(esp_mqtt_client_start(client));
}

void mqtt_disconnect(){
    ESP_LOGI(TAG_MQTT, "Disconnecting MQTT client");
    esp_err_t err = esp_mqtt_client_stop(client);
    if (err != ESP_OK) {
        ESP_LOGE(TAG_MQTT, "Failed to disconnect MQTT client. Error code: %d", err);
    } else {
        ESP_LOGI(TAG_MQTT, "MQTT client disconnected successfully");
    }
}

void jsonifyResStreaming(char *event,char *type, char* message){
    snprintf(json_str,sizeof(json_str),"{\"event\":\"%s\",\"type\":\"%s\",\"message\":{status\":%s\"}}",event,type,message);
}

void dejsonify(char *json_str) {
    // Look for key-value pairs in the JSON string and extract their values
    const char *event_start = strstr(json_str, "\"event\":");
    if (event_start != NULL) {
        sscanf(event_start, "\"event\":\"%19[^\"]\"", jsonMessage.event);
    }

    const char *type_start = strstr(json_str, "\"type\":");
    if (type_start != NULL) {
        sscanf(type_start, "\"type\":\"%19[^\"]\"", jsonMessage.type);
    }

    const char *message_start = strstr(json_str, "\"message\":");
    if (message_start != NULL) {
        sscanf(message_start, "\"message\":\"%1999[^\"]\"", jsonMessage.message);
    }
}