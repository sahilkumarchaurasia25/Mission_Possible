#include "rfid_handler.h"
#include "globals.h"
#include "string.h"
#include <esp_log.h>
#include <inttypes.h>
#include "rc522.h"
#include "board_pins.h"
#include "mqtt_handler.h"
#include "driver/gpio.h"

char *TAG_RFID = "RFID_MAIN";

static rc522_handle_t scanner;

static void rc522_handler(void* arg, esp_event_base_t base, int32_t event_id, void* event_data)
{
    rc522_event_data_t* data = (rc522_event_data_t*) event_data;

    switch(event_id) {
        case RC522_EVENT_TAG_SCANNED: {
                rc522_tag_t* tag = (rc522_tag_t*) data->ptr;
                sprintf(txbuff,"%lld",tag->serial_number);
                xQueueSend(xQueue, (void *)txbuff, portMAX_DELAY);
                ESP_LOGI(TAG_RFID, "Tag scanned (sn: %" PRIu64 ")", tag->serial_number);
            }
            break;
    }
}

void rc522_init(){
    gpio_set_direction(RESET_PIN,GPIO_MODE_OUTPUT);
    gpio_set_level(RESET_PIN,1);
    rc522_config_t config = {
        .spi.host = SPI3_HOST,
        .spi.miso_gpio = MISO_PIN,
        .spi.mosi_gpio = MOSI_PIN,
        .spi.sck_gpio = SCK_PIN,
        .spi.sda_gpio = SDA_PIN,
        .scan_interval_ms = 100,
        .transport = RC522_TRANSPORT_SPI,
        .spi.clock_speed_hz = RC522_DEFAULT_SPI_CLOCK_SPEED_HZ * 2,
    };

    rc522_create(&config, &scanner);
    rc522_register_events(scanner, RC522_EVENT_ANY, rc522_handler, NULL);
    rc522_start(scanner);
}

void RFIDRead(){
    char rxBuff[50];
    while(1){
        if(xQueueReceive(xQueue, &rxBuff, portMAX_DELAY) == pdPASS){
            jsonifyRFIDTag(SCAN_RFID_EVENT, rxBuff);
            printf("%s",rxBuff);
            // sendDataToServer(json_str);
            memset(json_str, 0, sizeof(json_str)); // Clear json_str buffer
        }
    }
}

void jsonifyRFIDTag(char *event,char *token){
    snprintf(json_str, sizeof(json_str), "{\"event\":\"%s\",\"token\":\"%s\"}",
             event,token);
}