#include <stdio.h>
#include <string.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/uart.h"
#include "driver/gpio.h"
#include "sdkconfig.h"
#include <nvs_flash.h>
#include "esp_log.h"

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

#include "esp_event_base.h"

#include "component/uart/uart_p.h"
#include "component/eventloop/eventloop.h"
#include "component/wifi/wifi_main.h"
#include "component/websocket/p_websocket.h"
#include "component/uart/uart_p.h"
#include "component/util/util.h"
#include "component/sys/sys.h"
static const char* TAG = "_sys_";

//ESP status





// static const uint8_t ESP_IS_DISCONNECTED = 0x04; //disconnected
// static const uint8_t ESP_IS_RECONNECTING = 0x05; //reconnecting
// static const uint8_t ESP_IS_RECONNECTED = 0x06; //reconnected
// static const uint8_t ESP_IS_RECONNECT_FAILED = 0x07; //reconnect failed
// static const uint8_t ESP_IS_RESTARTING = 0x08; //restarting
// static const uint8_t ESP_IS_RESTARTED = 0x09;
// static const uint8_t ESP_IS_RESTART_FAILED = 0x0A;
// static const uint8_t ESP_IS_RESETTING = 0x0B; //resetting
// static const uint8_t ESP_IS_RESETED = 0x0C;
// static const uint8_t ESP_IS_RESET_FAILED = 0x0D;
// static const uint8_t ESP_IS_UPDATING = 0x0E;
// static const uint8_t ESP_IS_UPDATED = 0x0F;
// static const uint8_t ESP_IS_UPDATE_FAILED = 0x10; 
// static const uint8_t ESP_IS_NOT_INTERNET = 0x11; //not internet
// static const uint8_t ESP_IS_SERVER_NOT_CONNECT = 0x12;
// static const uint8_t ESP_IS_WIFI_NOT_FOUND = 0x13; //wifi not found
// static const uint8_t ESP_IS_ERROR = 0xFF; //unknown error


static uint8_t esp_status = ESP_IS_NORMAL;


void set_esp_status(uint8_t status)
{

    esp_status = status;
    uint8_t data[] = {0x23,0x2A,0x80,0x01,esp_status,0x2A,0x23};
    send_data_to_uart(
         data,
        sizeof(data)
    );
    
}


//set init config to nvs
bool setInitConf(uint8_t* data ,int len){
     ESP_LOGI(TAG, "do_sys_event....set uid,sk ,model.....");
        uint8_t uid[8];
        uid[0] = data[4];
        uid[1] = data[5];
        uid[2] = data[6];
        uid[3] = data[7];
        uid[4] = data[8];
        uid[5] = data[9];
        uid[6] = data[10];
        uid[7] = data[11];
        
        uint64_t u_uid=0;
        memcpy(&u_uid, uid, sizeof uid);


     

        uint8_t sre1[8];
        sre1[0] = data[12];
        sre1[1] = data[13];
        sre1[2] = data[14];
        sre1[3] = data[15];
        sre1[4] = data[16];
        sre1[5] = data[17];

        sre1[6] = data[18];
        sre1[7] = data[19];
        uint64_t u_sre1=0;
        memcpy(&u_sre1, sre1, sizeof sre1);

        uint8_t sre2[8];
        sre2[0] =  data[20];
        sre2[1] = data[21];
        sre2[2] = data[22];
        sre2[3] = data[23];
        sre2[4] = data[24];
        sre2[5] = data[25];
        sre2[6] = data[26];
        sre2[7] = data[27];
        uint64_t u_sre2=0;
        memcpy(&u_sre2, sre2, sizeof sre2);

        uint8_t model[4];
        model[0] = data[28];
        model[1] = data[29];
        model[2] = data[30];
        model[3] = data[31];
        uint32_t u_model=0;
        memcpy(&u_model, model, sizeof model);

        //test code 
        uint8_t *puid = (uint8_t *)&u_uid;
        uint8_t *pser1 = (uint8_t *)&u_sre1;
        uint8_t *pser2 = (uint8_t *)&u_sre2;

        send_data_to_uart(puid,8);
        send_data_to_uart(pser1,8);
        send_data_to_uart(pser2,8);
        //test code end

        nvs_handle_t my_handle;
        esp_err_t err = nvs_open("storage", NVS_READWRITE, &my_handle);
    
        
        err = nvs_set_u64(my_handle, "uid", u_uid);
        err = nvs_set_u64(my_handle, "sk1", u_sre1);
        err = nvs_set_u64(my_handle, "sk2", u_sre2);
        err = nvs_set_u32(my_handle, "model", u_model);
        err = nvs_set_u8(my_handle, "status", 1);
        // ESP_LOGI(TAG, "do_sys_event....set uid...end..");
        err = nvs_commit(my_handle);
        
        reset_wifi();
        return true ;
}


bool get_uid(){
    nvs_handle_t my_handle;
    esp_err_t err = nvs_open("storage", NVS_READWRITE, &my_handle);
    uint64_t uid = 0;
    err = nvs_get_u64(my_handle, "uid", &uid);
    if (err != ESP_OK) {
        ESP_LOGI(TAG, "do_sys_event....get uid...error..");
        return false;
    }
    uint8_t *puid = (uint8_t *)&uid;
    send_data_to_uart(puid,8);
    return true;
}

bool get_sk(){
    nvs_handle_t my_handle;
    esp_err_t err = nvs_open("storage", NVS_READWRITE, &my_handle);
    uint64_t sk1 = 0;
    err = nvs_get_u64(my_handle, "sk1", &sk1);
    if (err != ESP_OK) {
        ESP_LOGI(TAG, "do_sys_event....get sk1...error..");
        return false;
    }
    uint8_t *psk1 = (uint8_t *)&sk1;
    send_data_to_uart(psk1,8);

    uint64_t sk2 = 0;
    err = nvs_get_u64(my_handle, "sk2", &sk2);
    if (err != ESP_OK) {
        ESP_LOGI(TAG, "do_sys_event....get sk2...error..");
        return false;
    }
    uint8_t *psk2 = (uint8_t *)&sk2;
    send_data_to_uart(psk2,8);
    return true;
}


//#*action_code{2} params *#
bool do_sys_event(uint8_t* data ,int len){
    
    if(len < 6){
        return false ;
    }

    if(data[0]!='#' || data[1]!='*'|| data[len-2]!='*' || data[len-1]!='#'){
        return false ;
    }
     ESP_LOGI(TAG, "do_sys_event....");
    if(data[2]==0x00 && data[3]==0x01){
        ESP_LOGI(TAG, "do_sys_event....reset_wifi.....");
        

       //清除wifi信息 ，并重新发起配网
       reset_wifi();
       return true ;
    }

    if(data[2]==0x00 && data[3]==0x02){
        ESP_LOGI(TAG, "do_sys_event....reset_ble.....");
       //重启ESP
       esp_restart();
       return true ;
    }

    if(data[2]==0x00 && data[3]==0x03){
        ESP_LOGI(TAG, "do_sys_event....reset_ble.....");
       //获取ESP的状态
       
       return true ;
    }

    

    //set uuid id,sk ,model
    if(data[2]==0x00 && data[3]==0xFE){
       setInitConf(data,len);
    }   



    //reset id 
    if(data[2]==0x00 && data[3]==0xFE){
        ESP_LOGI(TAG, "do_sys_event....reset id.....");
       //清除wifi信息 ，并重新发起配网
       
       return true ;
    }

    //get sk
    if(data[2]==0x00 && data[3]==0xC1){
        ESP_LOGI(TAG, "do_sys_event....get sk.....");
       //获取ESP的状态
       get_sk();
       return true ;
    }


   
    return false ;

}