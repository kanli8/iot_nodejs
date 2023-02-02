
#ifndef UART_H_
#define UART_H_

// #include <stdio.h>
// #include "freertos/FreeRTOS.h"
// #include "freertos/task.h"
// #include "driver/uart.h"
// #include "driver/gpio.h"
// #include "sdkconfig.h"
// #include "esp_event.h"
// #include "esp_timer.h"
// #include "esp_log.h"


// esp_event_loop_handle_t send_data_task;

// #define ECHO_TEST_TXD (GPIO_NUM_26)
// #define ECHO_TEST_RXD (GPIO_NUM_25)
// #define ECHO_TEST_RTS (UART_PIN_NO_CHANGE)
// #define ECHO_TEST_CTS (UART_PIN_NO_CHANGE)

// #define ECHO_UART_PORT_NUM      3
// #define ECHO_UART_BAUD_RATE     115200
// #define ECHO_TASK_STACK_SIZE    1024

// #define BUF_SIZE (128)

// // Declarations for the event source
// #define TASK_ITERATIONS_COUNT        10      // number of times the task iterates
// #define TASK_PERIOD                  500     // period of the task loop in milliseconds


// ESP_EVENT_DECLARE_BASE(TASK_EVENTS);   

// enum {
//     TASK_ITERATION_EVENT                     // raised during an iteration of the loop within the task
// };

// void startUartTaskAndEvent();
void start_uart(void);

void send_data_to_uart(uint8_t* data ,int len);
#endif // 