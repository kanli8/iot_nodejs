/* esp_event (event loop library) basic example

   This example code is in the Public Domain (or CC0 licensed, at your option.)

   Unless required by applicable law or agreed to in writing, this
   software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
   CONDITIONS OF ANY KIND, either express or implied.
*/
#define LOG_LOCAL_LEVEL ESP_LOG_VERBOSE
#include "esp_log.h"

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include <nvs_flash.h>

#include "esp_event_base.h"
#include "component/uart/uart_p.h"
#include "component/eventloop/eventloop.h"
#include "component/wifi/wifi_main.h"
#include "component/websocket/p_websocket.h"

static const char* TAG = "main";



/* Example main */
void app_main(void)
{
    // wifi_start();
    
    ESP_LOGI(TAG, "setting up");
    ESP_ERROR_CHECK(nvs_flash_init());
    nvs_handle_t my_handle;
    esp_err_t err = nvs_open("storage", NVS_READWRITE, &my_handle);
    
     uint64_t uid = 0; // value will default to 0, if not set yet in NVS
    err = nvs_get_u64(my_handle, "uid", &uid);
    if(err==ESP_ERR_NVS_NOT_FOUND){
        ESP_LOGI(TAG, "init set uid...");
        start_uart();
        // wifi_start();
    }else{
        start_uart();
        wifi_start();
        start_websocket(); 
        start_loop();
    }
  
}
