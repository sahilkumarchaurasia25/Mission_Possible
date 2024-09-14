#include <stdio.h>
#include <string.h>
#include "globals.h"
#include "freertos/event_groups.h"
#include "media_lib_adapter.h"
#include "nvs_flash.h"
#include "esp_log.h"
#include "esp_err.h"
#include "esp_event.h"
#include "esp_netif.h"
#include "gw_modem.h"
#include "rtmp_push_app.h"
#include "rtmp_app_setting.h"
#include "rtmp_handler.h"
#include "mqtt_handler.h"
#include "driver/uart.h"
#include "soc/uart_struct.h"
#include <inttypes.h>
#include "rc522.h"
#include "board_pins.h"
#include "rfid_handler.h"

char *TAG_MAIN = "MAIN";

TaskHandle_t RFIDReaderHandler = NULL;
TaskHandle_t blinkTaskHandler = NULL;
TaskHandle_t mqttTaskHandler = NULL;
TaskHandle_t rtmpStopTaskHandler = NULL;
TaskHandle_t mainOperationHandler = NULL;
void set_default_var(){
    uart_num_matrix = UART_NUM_2;
}

void MatrixUartInit(void) {
    const uart_config_t uart_config = {
        .baud_rate = 115200,
        .data_bits = UART_DATA_8_BITS,
        .parity = UART_PARITY_DISABLE,
        .stop_bits = UART_STOP_BITS_1,
        .flow_ctrl = UART_HW_FLOWCTRL_DISABLE,
        .source_clk = UART_SCLK_DEFAULT,
    };
    // We won't use a buffer for sending data.
    uart_driver_install(uart_num_matrix, BUF_SIZE * 2, 0, 0, NULL, 0);
    uart_param_config(uart_num_matrix, &uart_config);
    uart_set_pin(uart_num_matrix, MATRIX_TXD_PIN, MATRIX_RXD_PIN, UART_PIN_NO_CHANGE, UART_PIN_NO_CHANGE);
}

int sendDataToMatrix(char* data)
{
    const int len = strlen(data);
    const int txBytes = uart_write_bytes(uart_num_matrix, data, len);
    ESP_LOGI("TX TASK", "Wrote %d bytes", txBytes);
    return txBytes;
}

void sendToSpeaker(char *data){

}

void blink_task(){
    gpio_set_direction(D13,GPIO_MODE_OUTPUT);
    while(1){
        gpio_set_level(D13,1);
        vTaskDelay(5000/portTICK_PERIOD_MS);
        gpio_set_level(D13,0);
        vTaskDelay(5000/portTICK_PERIOD_MS);
    }
    vTaskDelete(NULL);
}

#define SIM7672S_RESET_PIN D10
#define RTMP_STOP_BUTTON D14
#define DEBOUNCE_TIME_MS 100

void configure_reset_pin(void)
{
    gpio_config_t io_conf;
    io_conf.intr_type = GPIO_INTR_DISABLE;
    io_conf.mode = GPIO_MODE_OUTPUT;
    io_conf.pin_bit_mask = (1ULL << SIM7672S_RESET_PIN);
    io_conf.pull_down_en = 0;
    io_conf.pull_up_en = 0;
    gpio_config(&io_conf);
    // Initially set the pin high (assuming active-low reset)
    gpio_set_level(SIM7672S_RESET_PIN, 1);
}

void configure_rtmp_stop_pin(void)
{
    gpio_config_t io_conf;
    io_conf.intr_type = GPIO_INTR_DISABLE;
    io_conf.mode = GPIO_MODE_INPUT;
    io_conf.pin_bit_mask = (1ULL << RTMP_STOP_BUTTON);
    io_conf.pull_down_en = 0;
    io_conf.pull_up_en = 1;
    gpio_config(&io_conf);
}

void reset_sim7672s(void)
{
    // Pull the reset pin low
    gpio_set_level(SIM7672S_RESET_PIN, 0);
    // Wait for the required duration (e.g., 100 milliseconds)
    vTaskDelay(pdMS_TO_TICKS(100));
    // Pull the reset pin high
    gpio_set_level(SIM7672S_RESET_PIN, 1);
}

void button_task(void *arg) {
    int last_state = 1;  // Assuming the button is not pressed initially
    int stable_state = 1;
    int debounce_counter = 0;
    
    while (1) {
        int current_state = gpio_get_level(RTMP_STOP_BUTTON);

        if (current_state != last_state) {
            debounce_counter = 0; // Reset debounce counter if state changes
        } else if (debounce_counter < DEBOUNCE_TIME_MS / portTICK_PERIOD_MS) {
            debounce_counter++; // Increment counter if state is stable
        }

        if (debounce_counter >= DEBOUNCE_TIME_MS / portTICK_PERIOD_MS) {
            if (stable_state != current_state) {
                stable_state = current_state;
                if (stable_state == 0) { // Active low, button pressed
                    ESP_LOGI(TAG_MAIN, "Button pressed");
                    rtmp_stop_cli();
                }
            }
        }

        last_state = current_state;
        vTaskDelay(pdMS_TO_TICKS(10)); // Check every 10 ms
    }
}

void init(){
    esp_log_level_set("*", ESP_LOG_INFO);
    media_lib_add_default_adapter();
    esp_err_t err = nvs_flash_init();
    if (err == ESP_ERR_NVS_NO_FREE_PAGES) {
        ESP_ERROR_CHECK(nvs_flash_erase());
        ESP_ERROR_CHECK(nvs_flash_init());
    }
     /* Init and register system/core components */
    // ESP_ERROR_CHECK(esp_netif_init());
    // ESP_ERROR_CHECK(esp_event_loop_create_default());
    // Set up UART for Matrix Led
    // MatrixUartInit();
    rc522_init();
    // // Create a queue with QUEUE_LENGTH items of size int
    xQueue = xQueueCreate(QUEUE_LENGTH, sizeof(txbuff));

    xTaskCreatePinnedToCore(RFIDRead,"RFID_READER", 8192, NULL, 5, &RFIDReaderHandler,0);
    // xTaskCreatePinnedToCore(button_task,"RTMP Stop Button", 2048, NULL, 5, &rtmpStopTaskHandler,0);
    // xTaskCreatePinnedToCore(blink_task,"blink task",2048,NULL,5,&blinkTaskHandler,0);
    // Configure the reset pin
    // configure_reset_pin();
    // // Reset the SIM7672S module
    // reset_sim7672s();
    // // Set up modem netif and basic event handlers
    // modem_setup();
    // BaseType_t checkIfYeildRequired;
    // checkIfYeildRequired = xTaskResumeFromISR();
    // portYIELD_FROM_ISR(checkIfYeildRequired);
    /* Wait for IP address */
    // ESP_LOGI(TAG_MAIN, "Waiting for IP address");
    // xEventGroupWaitBits (modem_eventgroup(), MODEM_CONNECT_BIT, pdFALSE, pdFALSE, portMAX_DELAY);
}

void extract_url(char *message) {
    const char *url_start = strstr(strstr(message, "url: "),"\"");
    if (url_start != NULL) {
        url_start++; // Move to the character after the double quote
        const char *url_end = strstr(url_start, "\"}");
        if (url_end != NULL) {
            size_t url_length = url_end - url_start;
            strncpy(rtmp_server_url, url_start, url_length);
            rtmp_server_url[url_length] = '\0'; // Null-terminate the string
        } else printf("URL start not found\n");
    }
}

typedef enum {
    EVENT_DEVICE_SETUP,
    EVENT_RIDES_ASSIGNED,
    EVENT_START_STREAMING,
    EVENT_STOP_STREAMING,
    EVENT_CONFIRM_RFID,
    EVENT_UNKNOWN // For unexpected events
} EventType;

EventType assignEventId(){
    // Determine event type
    EventType eventType = EVENT_UNKNOWN;
    if (strstr(jsonMessage.event, "DEVICE_SETUP")) {
        eventType = EVENT_DEVICE_SETUP;
    } else if (strstr(jsonMessage.event, "RIDES_ASSIGNED")) {
        eventType = EVENT_RIDES_ASSIGNED;
    } else if (strstr(jsonMessage.event, "START_STREAMING")) {
        eventType = EVENT_START_STREAMING;
    } else if (strstr(jsonMessage.event, "STOP_STREAMING")) {
        eventType = EVENT_STOP_STREAMING;
    } else if (strstr(jsonMessage.event, "CONFIRM_RFID")) {
        eventType = EVENT_CONFIRM_RFID;
    }
    return eventType;
}

void mainOperations(void *arg) {
    while (1) {
        if (jsonMessage.event[0] != '\0') {
            EventType eventType;
            eventType = assignEventId();
            switch (eventType) {
                case EVENT_DEVICE_SETUP:
                    if (strstr(jsonMessage.type, AUDIO_TYPE)) {
                        ESP_LOGI(TAG_MAIN,"%s", jsonMessage.message);
                        sendToSpeaker(jsonMessage.message);
                    }
                    break;
                case EVENT_RIDES_ASSIGNED:
                    if (!strstr(jsonMessage.type, SCROLL_TYPE)) {
                        strcpy(Txdata, jsonMessage.message);
                        sendDataToMatrix(Txdata);
                    }
                    break;
                case EVENT_START_STREAMING:
                    if (!strstr(jsonMessage.type, JSON_TYPE)) {
                        extract_url(jsonMessage.message);
                        rtmp_start_app();
                    }
                    break;
                case EVENT_STOP_STREAMING:
                    if (!strstr(jsonMessage.type, JSON_TYPE)) {
                        rtmp_stop_cli();
                    }
                    break;
                case EVENT_CONFIRM_RFID:
                    if (strstr(jsonMessage.type, AUDIO_TYPE)) {
                        ESP_LOGI(TAG_MAIN,"%s", jsonMessage.message);
                        sendToSpeaker(jsonMessage.message);
                    }
                    break;
                case EVENT_UNKNOWN:
                    // Handle unexpected event
                    break;
            }
            
            // Reset jsonMessage fields
            // ESP_LOGI(TAG_MAIN,"%s",jsonMessage.event);
            // ESP_LOGI(TAG_MAIN,"%s",jsonMessage.message);
            jsonMessage.event[0] = '\0';
            jsonMessage.type[0] = '\0';
            jsonMessage.message[0] = '\0';
        }
        // Add a delay to allow the watchdog to reset
        vTaskDelay(10 / portTICK_PERIOD_MS); // Delay for 10 ms
    }
}

void app_main(void)
{   
    init();
    // mqtt_app_start();
    // xTaskCreatePinnedToCore(mainOperations,"Main Operations",16*1024,NULL,6,&mainOperationHandler,0);
    // vTaskDelay(10000);
    // rtmp_start_app();
}