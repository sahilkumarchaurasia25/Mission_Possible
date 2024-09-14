#include <string.h>
#include "freertos/FreeRTOS.h"
#include "freertos/event_groups.h"
#include "esp_netif.h"
#include "esp_netif_ppp.h"
#include "esp_modem_api.h"
#include "esp_log.h"
#include "esp_event.h"
#include "driver/gpio.h"
#include "gw_config.h"
#include "gw_modem.h"
#include "globals.h"

static const char *TAG = "gw_modem.c";

static EventGroupHandle_t event_group = NULL;


static void on_ppp_changed(void *arg, esp_event_base_t event_base,
                           int32_t event_id, void *event_data)
{
    ESP_LOGI(TAG, "PPP state changed event %d", (int)event_id);
    if (event_id == NETIF_PPP_ERRORUSER) {
        /* User interrupted event from esp-netif */
        esp_netif_t *netif = event_data;
        ESP_LOGI(TAG, "User interrupted event from netif:%p", netif);
    }
}

static void on_ip_event(void *arg, esp_event_base_t event_base,
                        int32_t event_id, void *event_data)
{
    ESP_LOGD(TAG, "IP event! %d", (int)event_id);
    if (event_id == IP_EVENT_PPP_GOT_IP) {
        esp_netif_dns_info_t dns_info;

        ip_event_got_ip_t *event = (ip_event_got_ip_t *)event_data;
        esp_netif_t *netif = event->esp_netif;

        ESP_LOGI(TAG, "Modem Connect to PPP Server");
        ESP_LOGI(TAG, "~~~~~~~~~~~~~~");
        ESP_LOGI(TAG, "IP          : " IPSTR, IP2STR(&event->ip_info.ip));
        ESP_LOGI(TAG, "Netmask     : " IPSTR, IP2STR(&event->ip_info.netmask));
        ESP_LOGI(TAG, "Gateway     : " IPSTR, IP2STR(&event->ip_info.gw));
        esp_netif_get_dns_info(netif, 0, &dns_info);
        ESP_LOGI(TAG, "Name Server1: " IPSTR, IP2STR(&dns_info.ip.u_addr.ip4));
        esp_netif_get_dns_info(netif, 1, &dns_info);
        ESP_LOGI(TAG, "Name Server2: " IPSTR, IP2STR(&dns_info.ip.u_addr.ip4));
        ESP_LOGI(TAG, "~~~~~~~~~~~~~~");
        xEventGroupSetBits(event_group, MODEM_CONNECT_BIT);

        ESP_LOGI(TAG, "GOT ip event!!!");
    } else if (event_id == IP_EVENT_PPP_LOST_IP) {
        ESP_LOGI(TAG, "Modem Disconnect from PPP Server");
    } else if (event_id == IP_EVENT_GOT_IP6) {
        ESP_LOGI(TAG, "GOT IPv6 event!");

        ip_event_got_ip6_t *event = (ip_event_got_ip6_t *)event_data;
        ESP_LOGI(TAG, "Got IPv6 address " IPV6STR, IPV62STR(event->ip6_info.ip));
    }
}

EventGroupHandle_t modem_eventgroup (void)
{
    return event_group;
}

static esp_modem_dce_t *dce;
static esp_netif_t *esp_netif;
void modem_setup (void)
{
    ESP_ERROR_CHECK(esp_event_handler_register(IP_EVENT, ESP_EVENT_ANY_ID, &on_ip_event, NULL));
    ESP_ERROR_CHECK(esp_event_handler_register(NETIF_PPP_STATUS, ESP_EVENT_ANY_ID, &on_ppp_changed, NULL));

    /* Configure the PPP netif */
    esp_modem_dce_config_t dce_config = ESP_MODEM_DCE_DEFAULT_CONFIG("www");
    esp_netif_config_t netif_ppp_config = ESP_NETIF_DEFAULT_PPP();
    esp_netif = esp_netif_new(&netif_ppp_config);
    assert(esp_netif);

    event_group = xEventGroupCreate();

    /* Configure the DTE */
    esp_modem_dte_config_t dte_config = ESP_MODEM_DTE_DEFAULT_CONFIG();
    /* setup UART specific configuration based on kconfig options */
    dte_config.uart_config.port_num = UART_NUM_1;
    dte_config.uart_config.tx_io_num = MODEM_UART_TXD;
    dte_config.uart_config.rx_io_num = MODEM_UART_RXD;
    dte_config.uart_config.rts_io_num = MODEM_UART_RTS;
    dte_config.uart_config.cts_io_num = MODEM_UART_CTS;
    dte_config.uart_config.flow_control = ESP_MODEM_FLOW_CONTROL_NONE;
    dte_config.uart_config.rx_buffer_size = 8000;
    dte_config.uart_config.tx_buffer_size = 8000;
    dte_config.uart_config.event_queue_size = 30;
    dte_config.task_stack_size = 8192;
    dte_config.task_priority = 5;
    dte_config.dte_buffer_size = 4096;

    ESP_LOGI(TAG, "Initializing esp_modem for the SIM7600 module...");
    dce = esp_modem_new_dev(ESP_MODEM_DCE_SIM7600, &dte_config, &dce_config, esp_netif);
    assert(dce);

    xEventGroupClearBits(event_group, MODEM_CONNECT_BIT | MODEM_GOT_DATA_BIT | MODEM_GOT_IMEI_BIT);
    while(1){
    int rssi, ber;
    esp_err_t err = esp_modem_get_imei(dce,lteModemImei);
    if(err != ESP_OK){
        ESP_LOGE(TAG, "esp_modem_get_imei failed with %s", esp_err_to_name(err));
    }else if(err == ESP_OK){
    ESP_LOGI(TAG,"IMEI: %s",lteModemImei);
    }
     err = esp_modem_get_signal_quality(dce, &rssi, &ber);
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "esp_modem_get_signal_quality failed with %d %s", err, esp_err_to_name(err));
        // return;
    }else if(err == ESP_OK){
    ESP_LOGI(TAG, "Signal quality: rssi=%d, ber=%d", rssi, ber);
    // return;
    }
    err = esp_modem_set_mode(dce, ESP_MODEM_MODE_DATA);
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "esp_modem_set_mode(ESP_MODEM_MODE_DATA) failed with %d", err);
        // return;
    }else if(err==ESP_OK){
        ESP_LOGI(TAG,"esp_modem_set_data_mode_success");
        return;
    }
}
}

void modem_deinit (void)
{
    esp_err_t err = esp_modem_set_mode(dce, ESP_MODEM_MODE_COMMAND);
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "esp_modem_set_mode(ESP_MODEM_MODE_COMMAND) failed with %d", err);
        return;
    }

   // UART DTE clean-up
    esp_modem_destroy(dce);
    esp_netif_destroy(esp_netif);
}
