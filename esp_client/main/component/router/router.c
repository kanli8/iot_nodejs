
#include "esp_log.h"

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

#include "esp_event_base.h"



void setRoute(
    int recivId ,
    void(*Sender)(char* a, int len)){
    
    
}

void sendData(char* a ,int len){
    //检查是否是系统事件
    // 0x6F 0x58 开头
}


