/* esp_event (event loop library) basic example

   This example code is in the Public Domain (or CC0 licensed, at your option.)

   Unless required by applicable law or agreed to in writing, this
   software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
   CONDITIONS OF ANY KIND, either express or implied.
*/

#ifndef EVENT_SOURCE_H_
#define EVENT_SOURCE_H_

#include "esp_event.h"
#include "esp_timer.h"

#ifdef __cplusplus
extern "C" {
#endif

// Declarations for the event source
#define TASK_ITERATIONS_COUNT        10      // number of times the task iterates
#define TASK_PERIOD                  500     // period of the task loop in milliseconds

ESP_EVENT_DECLARE_BASE(TASK_EVENTS);         // declaration of the task events family

enum {
    TASK_ITERATION_EVENT,                     // raised during an iteration of the loop within the task
    TASK_UART_REVICER,     //uart 接收到数据，非事件循环
    TASK_UART_SENDER,      //uart 发送数据
    WEBSOCKET_STATUS_CHANGE,  //websocket 状态发生变化
    WEBSOCKET_REVICER,    //websocket 接收到数据
    WEBSOCKET_SENDER,     //websocket 发送数据
    WIFI_STATUS_CHANGE
};


// Event loops
esp_event_loop_handle_t send_data_to_uart_task;
esp_event_loop_handle_t loop_without_task;

#ifdef __cplusplus
}
#endif



#endif // #ifndef EVENT_SOURCE_H_
