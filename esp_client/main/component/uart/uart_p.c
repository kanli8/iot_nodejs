/* UART Echo Example

   This example code is in the Public Domain (or CC0 licensed, at your option.)

   Unless required by applicable law or agreed to in writing, this
   software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
   CONDITIONS OF ANY KIND, either express or implied.
*/
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

#include "esp_event_base.h"

#include "../../event_source.h"

#include "../websocket/p_websocket.h"

#include "component/sys/sys.h"

/**
 * This is an example which echos any data it receives on configured UART back to the sender,
 * with hardware flow control turned off. It does not use UART driver event queue.
 *
 * - Port: configured UART
 * - Receive (Rx) buffer: on
 * - Transmit (Tx) buffer: off
 * - Flow control: off
 * - Event queue: off
 * - Pin assignment: see defines below (See Kconfig)
 */

#define ECHO_TEST_TXD (GPIO_NUM_23)
#define ECHO_TEST_RXD (GPIO_NUM_22)
#define ECHO_TEST_RTS (UART_PIN_NO_CHANGE)
#define ECHO_TEST_CTS (UART_PIN_NO_CHANGE)

#define ECHO_UART_PORT_NUM      (UART_NUM_1)
#define ECHO_UART_BAUD_RATE     (115200)
#define ECHO_TASK_STACK_SIZE    (2048)

#define BUF_SIZE (128)
#define MAX_SEND_QUEUE_SIZE 5

const char* TAG = "UART";

ESP_EVENT_DEFINE_BASE(TASK_EVENTS);


uint8_t *send_data[MAX_SEND_QUEUE_SIZE] ;
int send_data_size[MAX_SEND_QUEUE_SIZE]= {0, 0, 0, 0, 0};
int serials =0;

static void echo_task(void *arg)
{

    // Configure a temporary buffer for the incoming data
    uint8_t *data = (uint8_t *) malloc(BUF_SIZE);

    while (1) {
        // Read data from the UART
        int len = 
            uart_read_bytes(
                ECHO_UART_PORT_NUM, 
                data, 
                BUF_SIZE, 
                20 / portTICK_RATE_MS);

        // uart_write_bytes(ECHO_UART_PORT_NUM,data, len);
        if(len>0){

            bool isysEvent = do_sys_event(data, len);
            if(!isysEvent){
                send_data_to_websocket(data, len);
            }
            
        }
        
        // Write data back to the UART
        //printf("revi...");

        // ESP_LOGI(TAG, "revice data len is %d",len);
        // send_data_to_uart(data,len);
        // for(int i=serials+1;i<MAX_SEND_QUEUE_SIZE;i++){
        //     if( send_data_size[i] <= 0){
        //         continue;
        //     }
        //     // uart_write_bytes(ECHO_UART_PORT_NUM,send_data[i], send_data_size[i]);
        //     send_data_to_uart();
        //     send_data_size[i]=0;
        //     free(send_data[i]);

        // }
        // ESP_ERROR_CHECK(
        //     esp_event_post_to(
        //         send_data_to_uart_task, 
        //         TASK_EVENTS, 
        //         TASK_ITERATION_EVENT, 
        //         b, 
        //         len, 
        //         portMAX_DELAY));
        // ESP_LOGI(TAG, "revice data len22 is %d",len);
        // 
    }
}


void send_data_to_uart(uint8_t* data ,int len){
    uart_write_bytes(ECHO_UART_PORT_NUM,data, len);
}


// static void send_data_handler(
//     void* handler_args, 
//     esp_event_base_t base, 
//     int32_t id, 
//     void* event_data)
// {   
   
//     // uart_write_bytes(ECHO_UART_PORT_NUM, (const char *) event_data, sizeof((const char *) event_data));
// }





void start_uart(void)
{
    ESP_LOGI(TAG, "setting up");

    //初始化串口
    /* Configure parameters of an UART driver,
    * communication pins and install the driver */
    uart_config_t uart_config = {
        .baud_rate = ECHO_UART_BAUD_RATE,
        .data_bits = UART_DATA_8_BITS,
        .parity    = UART_PARITY_DISABLE,
        .stop_bits = UART_STOP_BITS_1,
        .flow_ctrl = UART_HW_FLOWCTRL_DISABLE,
        .source_clk = UART_SCLK_APB,
    };
    int intr_alloc_flags = 0;

    #if CONFIG_UART_ISR_IN_IRAM
        intr_alloc_flags = ESP_INTR_FLAG_IRAM;
    #endif

    ESP_ERROR_CHECK(
        uart_driver_install(
            ECHO_UART_PORT_NUM, 
            BUF_SIZE * 2, 
            0, 
            0,
             NULL, 
             intr_alloc_flags));
    ESP_ERROR_CHECK(
        uart_param_config(ECHO_UART_PORT_NUM, 
        &uart_config));

    ESP_ERROR_CHECK(
        uart_set_pin(
            ECHO_UART_PORT_NUM, 
            ECHO_TEST_TXD, 
            ECHO_TEST_RXD, 
            ECHO_TEST_RTS, 
            ECHO_TEST_CTS));

    // esp_event_loop_args_t send_data_to_uart_task_args = {
    //     .queue_size = 15,
    //     .task_name = "uart_send_task", // task will be created
    //     .task_priority = uxTaskPriorityGet(NULL),
    //     .task_stack_size = 2048,
    //     .task_core_id = tskNO_AFFINITY
    // };



    // ESP_ERROR_CHECK(
    //     esp_event_loop_create(
    //         &send_data_to_uart_task_args, 
    //         &send_data_to_uart_task));



    // ESP_ERROR_CHECK(
    //     esp_event_handler_instance_register_with(
    //         send_data_to_uart_task, 
    //         TASK_EVENTS, 
    //         TASK_ITERATION_EVENT, 
    //         send_data_handler, 
    //         send_data_to_uart_task, 
    //         NULL));
  

    xTaskCreate(echo_task, "uart_echo_task", ECHO_TASK_STACK_SIZE, NULL, 10, NULL);
   
}
