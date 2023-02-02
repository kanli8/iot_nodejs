#include <stdio.h>
#include<string.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/uart.h"
#include "driver/gpio.h"
#include "sdkconfig.h"

#include "esp_log.h"

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"



#include "../../event_source.h"

static void application_task(void* args)
{
    while(1) {
        esp_event_loop_run(loop_without_task, 100);
        vTaskDelay(20);
    }
}

static void without_handler(
    void* handler_args, 
    esp_event_base_t base, 
    int32_t id, 
    void* event_data,
    size_t event_data_size)
{   

}

void start_loop(void){
    esp_event_loop_args_t loop_without_task_args = {
        .queue_size = 5,
        .task_name = NULL // no task will be created
    };

    ESP_ERROR_CHECK(
        esp_event_loop_create(
            &loop_without_task_args, 
            &loop_without_task));

    ESP_ERROR_CHECK(
        esp_event_handler_instance_register_with(
            loop_without_task, 
            TASK_EVENTS, 
            TASK_ITERATION_EVENT, 
            without_handler, 
            loop_without_task, NULL));

    xTaskCreate(
        application_task, 
        "application_task", 
        2048, 
        NULL, 
        uxTaskPriorityGet(NULL), 
        NULL);


}

