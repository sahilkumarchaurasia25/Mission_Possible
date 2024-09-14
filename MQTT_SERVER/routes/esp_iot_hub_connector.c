#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "esp_log.h"
#include "nvs_flash.h"
#include "protocol_examples_common.h"
#include "azure_iot.h"
#include "iothub.h"
#include "iothub_device_client_ll.h"
#include "iothub_message.h"
#include "iothubtransportmqtt.h"

static const char *TAG = "azure_iot_example";
static const char *connectionString = "HostName=Colossus.azure-devices.net;DeviceId=ESP_EZ;SharedAccessKey=Ro4uCdnZs1F8oEnro5A5VMK9ZP3RtHoYgAIoTGaE8+U=";

void message_callback(IOTHUB_MESSAGE_HANDLE message, void *user_context) {
    const char *message_data = IoTHubMessage_GetString(message);
    ESP_LOGI(TAG, "Message received: %s", message_data);

    // Process the message and publish to the actual IoT device under the topic 'properties'
    // Example: mqtt_publish("properties", message_data);
}

void app_main(void) {
    ESP_ERROR_CHECK(nvs_flash_init());
    ESP_ERROR_CHECK(esp_netif_init());
    ESP_ERROR_CHECK(esp_event_loop_create_default());
    ESP_ERROR_CHECK(example_connect());

    IOTHUB_DEVICE_CLIENT_LL_HANDLE client_handle = IoTHubDeviceClient_LL_CreateFromConnectionString(connectionString, MQTT_Protocol);
    if (client_handle == NULL) {
        ESP_LOGE(TAG, "Failed to create client handle");
        return;
    }

    IoTHubDeviceClient_LL_SetMessageCallback(client_handle, message_callback, NULL);

    while (true) {
        IoTHubDeviceClient_LL_DoWork(client_handle);
        vTaskDelay(100 / portTICK_PERIOD_MS);
    }

    IoTHubDeviceClient_LL_Destroy(client_handle);
}