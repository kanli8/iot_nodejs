/* ESP HTTP Client Example

   This example code is in the Public Domain (or CC0 licensed, at your option.)

   Unless required by applicable law or agreed to in writing, this
   software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
   CONDITIONS OF ANY KIND, either express or implied.
*/


#include <stdio.h>
#include "esp_wifi.h"
#include "esp_system.h"
#include "nvs_flash.h"
#include "esp_event.h"

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/semphr.h"
#include "freertos/event_groups.h"
#include "mbedtls/md5.h"

#include "esp_log.h"
#include "esp_websocket_client.h"
#include "esp_http_client.h"
#include "esp_event.h"

#include "../uart/uart_p.h"
#include "../util/util.h"
#include "../sys/sys.h"

#define NO_DATA_TIMEOUT_SEC 60   //无数据，停止websocket服务
#define WEBSOCKET_TASK_STACK_SIZE    (2048)
static const char *TAG = "WEBSOCKET";

static TimerHandle_t shutdown_signal_timer;
static SemaphoreHandle_t shutdown_sema;

static uint16_t reConnectCount = 0;

esp_websocket_client_handle_t client ;
esp_websocket_client_config_t websocket_cfg = {};
void websocket_app_start(void) ;
void send_auth() ;
void send_auth2() ;
static bool isAuth = false ;
static bool updateId = false ;

static char* get_md5(char* str) {
    char* md5 = (char*)malloc(33);
    mbedtls_md5_context ctx;
    mbedtls_md5_init(&ctx);
    // mbedtls_md5_starts(&ctx);
    mbedtls_md5_update(&ctx, (unsigned char*)str, strlen(str));
    unsigned char digest[16];
    mbedtls_md5_finish(&ctx, digest);
    mbedtls_md5_free(&ctx);
    for (int i = 0; i < 16; i++) {
        sprintf(md5 + i * 2, "%02x", digest[i]);
    }
    return md5;
}

static uint8_t* get_md5_byte(uint8_t* str,int len) {
    uint8_t* md5 = (uint8_t*)malloc(16);
    mbedtls_md5_context ctx;
    mbedtls_md5_init(&ctx);
    // mbedtls_md5_starts(&ctx);
    mbedtls_md5_update(&ctx, (unsigned char*)str, len);
    unsigned char digest[16];
    mbedtls_md5_finish(&ctx, digest);
    mbedtls_md5_free(&ctx);
    for (int i = 0; i < 16; i++) {
        md5[i] = digest[i];
    }
    return md5;
}



static void shutdown_signaler(TimerHandle_t xTimer)
{
    ESP_LOGI(TAG, "No data received for %d seconds, signaling shutdown", NO_DATA_TIMEOUT_SEC);
    xSemaphoreGive(shutdown_sema);
}

#if CONFIG_WEBSOCKET_URI_FROM_STDIN
static void get_string(char *line, size_t size)
{
    int count = 0;
    while (count < size) {
        int c = fgetc(stdin);
        if (c == '\n') {
            line[count] = '\0';
            break;
        } else if (c > 0 && c < 127) {
            line[count] = c;
            ++count;
        }
        vTaskDelay(10 / portTICK_PERIOD_MS);
    }
}

#endif /* CONFIG_WEBSOCKET_URI_FROM_STDIN */






void websocket_event_handler(void *handler_args, esp_event_base_t base, int32_t event_id, void *event_data)
{
    esp_websocket_event_data_t *data = (esp_websocket_event_data_t *)event_data;
    switch (event_id) {
    case WEBSOCKET_EVENT_CONNECTED:
        // send_auto_to_websocket();
        // xTaskCreate(
        //     send_auth, 
        //     "send_auth", 
        //     2048, 
        //     NULL, 
        //     uxTaskPriorityGet(NULL), 
            // NULL);
        send_auth2();
        ESP_LOGI(TAG, "WEBSOCKET_EVENT_CONNECTED");
        break;
    case WEBSOCKET_EVENT_DISCONNECTED:
        //  set_new_header();
        // esp_websocket_client_set_config(client,&websocket_cfg);
        isAuth = false ;
        ESP_LOGI(TAG, "WEBSOCKET_EVENT_DISCONNECTED");

        
        break;
    case WEBSOCKET_EVENT_DATA:
        ESP_LOGI(TAG, "WEBSOCKET_EVENT_DATA");
        ESP_LOGI(TAG, "Received opcode=%d", data->op_code);
        if (data->op_code == 0x08 && data->data_len == 2) {
            ESP_LOGW(TAG, "Received closed message with code=%d", 256*data->data_ptr[0] + data->data_ptr[1]);
        }else if(data->op_code == 0x0A){
            // ESP_LOGI(TAG, "Received ping msg");
            // if(!isAuth){
            //     send_auth();
            // }
        }  else {
            ESP_LOGW(TAG, "Received=%.*s", data->data_len, (char *)data->data_ptr);
            if(updateId){
                updateId = false ;
                //update status to flash
                update_status_to_normal();
            }
            if(data->data_len > 0){
                send_data_to_uart(data->data_ptr,data->data_len);
            }
        }
        ESP_LOGW(TAG, "Total payload length=%d, data_len=%d, current payload offset=%d\r\n", data->payload_len, data->data_len, data->payload_offset);

        xTimerReset(shutdown_signal_timer, portMAX_DELAY);
        break;
    case WEBSOCKET_EVENT_ERROR:
        ESP_LOGI(TAG, "WEBSOCKET_EVENT_ERROR");
        break;
    }
}




char sid[8] ;
void websocket_app_start(void)
{
 
    
    shutdown_signal_timer = xTimerCreate("Websocket shutdown timer", NO_DATA_TIMEOUT_SEC * 1000 / portTICK_PERIOD_MS,
                                         pdFALSE, NULL, shutdown_signaler);
    shutdown_sema = xSemaphoreCreateBinary();

#if CONFIG_WEBSOCKET_URI_FROM_STDIN
    char line[128];

    ESP_LOGI(TAG, "Please enter uri of websocket endpoint");
    get_string(line, sizeof(line));

    websocket_cfg.uri = line;
    ESP_LOGI(TAG, "Endpoint uri: %s\n", line);

#else
    websocket_cfg.uri = CONFIG_WEBSOCKET_URI;

#endif /* CONFIG_WEBSOCKET_URI_FROM_STDIN */
     
    nvs_handle_t my_handle;
    esp_err_t err = nvs_open("storage", NVS_READWRITE, &my_handle);
    ESP_ERROR_CHECK( err );
    int32_t websocket_searils = 1; // value will default to 0, if not set yet in NVS
    err = nvs_get_i32(my_handle, "websocket_searils", &websocket_searils);
    if(err==ESP_ERR_NVS_NOT_FOUND){
        websocket_searils = 1 ;
    }
    websocket_searils++;
    nvs_set_i32(my_handle, "websocket_searils", websocket_searils);
    // char headers[200];
    esp_fill_random(sid, 8);
    char randstr[6];
    esp_fill_random(randstr, 6);
    char *header="sec-websocket-protocol: echo-protocol\r\n";

    
        

    websocket_cfg.headers = header ;
    if(!websocket_cfg.headers){
        ESP_LOGI(TAG, "header is null...");
    }  
    // ESP_LOGI(TAG, "Connecting to %s...", websocket_cfg.uri);
    // esp_http_client_handle_t
    client = esp_websocket_client_init(&websocket_cfg);
    esp_websocket_register_events(client, WEBSOCKET_EVENT_ANY, websocket_event_handler, (void *)client);

    esp_websocket_client_start(client);
    xTimerStart(shutdown_signal_timer, portMAX_DELAY);


    xSemaphoreTake(shutdown_sema, portMAX_DELAY);
    esp_websocket_client_close(client, portMAX_DELAY);
    ESP_LOGI(TAG, "Websocket Stopped");
    esp_websocket_client_destroy(client);
}


void send_data_to_websocket(uint8_t* data ,int len){
    if(isAuth){
        esp_websocket_client_send_bin(client, (char *)data, len, portMAX_DELAY);
    }
     
    
   
}

// send auth to websocket by binary
void send_auth2(){
    ESP_LOGI(TAG, "send auth to websocket2222......");
    uint8_t auth[65];
     nvs_handle my_handle;
    esp_err_t err = nvs_open("storage", NVS_READWRITE, &my_handle);
    ESP_ERROR_CHECK( err );
    uint8_t status = 0;
    err = nvs_get_u8(my_handle, "status", &status);
    if(err==ESP_ERR_NVS_NOT_FOUND){
        status = 0 ;
    }
   
    //use uid to auth
    //uid 8 bytes
    auth[0] =status;
    uint64_t uid = 0;
    err = nvs_get_u64(my_handle, "uid", &uid);
    if(err==ESP_ERR_NVS_NOT_FOUND){
        set_esp_status(ESP_UID_NOT_FOUND);
        return ;
    }
    uint8_t *p_uid = (uint8_t *)&uid;
    for(int i=0;i<8;i++){
        auth[i+1] = p_uid[i];
    }
    //id 8 bytes
    uint64_t id = 0;
    err = nvs_get_u64(my_handle, "id", &id);
    if(err==ESP_ERR_NVS_NOT_FOUND){
        set_esp_status(ESP_ID_NOT_FOUND);
        return ;
    }
    uint8_t *p_id = (uint8_t *)&id;
    for(int i=0;i<8;i++){
        auth[i+9] = p_id[i];
    }
    //serial 4 bytes
    uint32_t serial = 0;
    err = nvs_get_u32(my_handle, "serial", &serial);
    if(err==ESP_ERR_NVS_NOT_FOUND){
        //set serial 0
        serial = 0;

    }
    serial ++;
    nvs_set_u32(my_handle, "serial", serial);
    uint8_t *p_serial = (uint8_t *)&serial;
    for(int i=0;i<4;i++){
        auth[i+17] = p_serial[i];
    }
    //oper_count 4 bytes
    uint32_t oper_count = reConnectCount;
    uint8_t *p_oper_count = (uint8_t *)&oper_count;
    for(int i=0;i<4;i++){
        auth[i+21] = p_oper_count[i];
    }
    //random 8 bytes
    uint64_t random = 0;
    esp_fill_random(&random, 8);
    uint8_t *p_random = (uint8_t *)&random;
    for(int i=0;i<8;i++){
        auth[i+25] = p_random[i];
    }
    //sk 16 bytes
    //sk1 8 bytes
    uint64_t sk1 = 0;
    err = nvs_get_u64(my_handle, "sk1", &sk1);
    if(err==ESP_ERR_NVS_NOT_FOUND){
        set_esp_status(ESP_SK_NOT_FOUND);
        return ;
    }
    uint8_t *p_sk1 = (uint8_t *)&sk1;
    for(int i=0;i<8;i++){
        auth[i+33] = p_sk1[i];
    }
    //sk2 8 bytes
    uint64_t sk2 = 0;
    err = nvs_get_u64(my_handle, "sk2", &sk2);
    if(err==ESP_ERR_NVS_NOT_FOUND){
        set_esp_status(ESP_SK_NOT_FOUND);
        return ;
    }
    uint8_t *p_sk2 = (uint8_t *)&sk2;
    for(int i=0;i<8;i++){
        auth[i+41] = p_sk2[i];
    }
    //token 16 bytes
    //generate token by md5(auth)
    uint8_t* token = (uint8_t *)malloc(16);
    token = get_md5_byte(auth, 49);
    for(int i=0;i<16;i++){
        auth[i+49] = token[i];
    }

    if(status==1){
        updateId = true;
    }

    //remove sk1 and sk2 from auth
    for(int i=0;i<16;i++){
        auth[i+33] = 0;
    }

    //send auth
    ESP_LOGI(TAG, "send auth to websocket.....auth...");
    // send_data_to_websocket(auth, 65);
    esp_websocket_client_send_bin(client, (char *)auth, 65, portMAX_DELAY);
    isAuth = true;

   
}

// send auth to websocket by text
void send_auth(){
    //发送鉴权
    ESP_LOGI(TAG, "send auth.......");
    // xPortGetFreeHeapSize() ;
    
    char authInfo[512];
    

    nvs_handle my_handle;
    esp_err_t err = nvs_open("storage", NVS_READWRITE, &my_handle);
    ESP_ERROR_CHECK( err );
    uint8_t status = 0;
    err = nvs_get_u8(my_handle, "status", &status);
    if(err==ESP_ERR_NVS_NOT_FOUND){
        status = 0 ;
    }
    if(status==1){
        //use uid
        updateId = true ;
        char *tmp="{\"uid\":\"%s\",\"id\":\"%s\",\"serial\":\"%s\",\"oper_count\":\"%s\",\"token\":\"%s\",\"randstr\":\"%s\"}";
        uint64_t uid = 0;
        err = nvs_get_u64(my_handle, "uid", &uid);
        if(err==ESP_ERR_NVS_NOT_FOUND){
            ESP_LOGE(TAG, "uid not found....");
            return ;
        }
        uint64_t id = nvs_get_u64(my_handle, "id", &id);
        if(err==ESP_ERR_NVS_NOT_FOUND){
            ESP_LOGE(TAG, "id not found....");
            return ;
        }


        uint64_t sk1 = nvs_get_u64(my_handle, "sk1", &sk1);
        if(err==ESP_ERR_NVS_NOT_FOUND){
            ESP_LOGE(TAG, "sk1 not found....");
            return ;
        }
        uint64_t sk2 = nvs_get_u64(my_handle, "sk2", &sk2);
        if(err==ESP_ERR_NVS_NOT_FOUND){
            ESP_LOGE(TAG, "sk2 not found....");
            return ;
        }

        char* uidstr = (char*)malloc(17);
        sprintf(uidstr,"%016llx",uid);
        char* idstr = (char*)malloc(17);
        sprintf(idstr,"%016llx",id);
        char* sk1str = (char*)malloc(17);
        sprintf(sk1str,"%016llx",sk1);
        char* sk2str = (char*)malloc(17);
        sprintf(sk2str,"%016llx",sk2);
        char* skstr = (char*)malloc(32);
        sprintf(skstr,"%s%s",sk1str,sk2str);
        
        free(sk1str);
        free(sk2str);

        char* token = (char*)malloc(32);
        //generate random string
        uint64_t rand_uint64 ;
        rand_uint64 = random_64();
        char* randstr = (char*)malloc(17);
        sprintf(randstr,"%016llx",rand_uint64);
        //get serial num
        uint32_t serial = nvs_get_u32(my_handle, "serial", &serial);
        if(serial > 0x7fffffff){
            serial = 0;
        }
        serial++;
        //set serial num
        nvs_set_u32(my_handle, "serial", serial);
        char* serialstr = (char*)malloc(16);
        sprintf(serialstr,"%08x",serial);
        //get oper_count
        uint16_t oper_count = reConnectCount ;
        char* oper_countstr = (char*)malloc(8);
        sprintf(oper_countstr,"%04x",oper_count);
        //generate token by md5
        char* md5str = (char*)malloc(76);
        sprintf(md5str,"%s-%s-%s-%s-%s",uidstr,skstr,randstr,serialstr,oper_countstr);
        md5str = get_md5(md5str);
        sprintf(authInfo,tmp,uidstr,idstr,serialstr,oper_countstr,md5str,randstr);
        ESP_LOGI(TAG, "authInfo:%s",authInfo);
        free(uidstr);
        free(idstr);
        free(skstr);
        free(token);
        free(randstr);
        free(serialstr);
        free(oper_countstr);
        free(md5str);

    }else{
        //use id
        char *tmp="{\"id\":%s,\"serial\":\"%s\",\"oper_count\":\"%s\",\"token\":\"%s\",\"randstr\":\"%s\"}";
    
        uint64_t id = nvs_get_u64(my_handle, "id", &id);
        if(err==ESP_ERR_NVS_NOT_FOUND){
            ESP_LOGE(TAG, "id not found....");
            return ;
        }


        uint64_t sk1 = nvs_get_u64(my_handle, "sk1", &sk1);
        if(err==ESP_ERR_NVS_NOT_FOUND){
            ESP_LOGE(TAG, "sk1 not found....");
            return ;
        }
        uint64_t sk2 = nvs_get_u64(my_handle, "sk2", &sk2);
        if(err==ESP_ERR_NVS_NOT_FOUND){
            ESP_LOGE(TAG, "sk2 not found....");
            return ;
        }

        char* idstr = (char*)malloc(17);
        sprintf(idstr,"%016llx",id);
        char* sk1str = (char*)malloc(17);
        sprintf(sk1str,"%016llx",sk1);
        char* sk2str = (char*)malloc(17);
        sprintf(sk2str,"%016llx",sk2);
        char* skstr = (char*)malloc(34);
        sprintf(skstr,"%s%s",sk1str,sk2str);
        char* token = (char*)malloc(32);
        //generate random string
        uint64_t rand_uint64 ;
        rand_uint64 = random_64();
        char* randstr = (char*)malloc(17);
        sprintf(randstr,"%016llx",rand_uint64);
        //get serial num
        uint32_t serial = nvs_get_u32(my_handle, "serial", &serial);
        if(serial > 0x7fffffff){
            serial = 0;
        }
        serial++;
        //set serial num
        nvs_set_u32(my_handle, "serial", serial);
        char* serialstr = (char*)malloc(16);
        sprintf(serialstr,"%08x",serial);
        //get oper_count
        uint16_t oper_count = reConnectCount ;
        char* oper_countstr = (char*)malloc(8);
        sprintf(oper_countstr,"%04x",oper_count);
        //generate token by md5
        char* md5str = (char*)malloc(76);
        sprintf(md5str,"%s-%s-%s-%s-%s",idstr,skstr,randstr,serialstr,oper_countstr);
        md5str = get_md5(md5str);
        sprintf(authInfo,tmp,idstr,idstr,serialstr,oper_countstr,md5str);
        ESP_LOGI(TAG, "authInfo:%s",authInfo);
        sprintf( 
            authInfo, tmp,
            CONFIG_DEVICE_ID, 
            "espesp",
            "espespsksksk" );

        free(idstr);
        free(sk1str);
        free(sk2str);
        free(skstr);
        free(token);
        free(randstr);
        free(serialstr);
        free(oper_countstr);
        free(md5str);
            
    }

    
    
    ESP_LOGI(TAG,"authInfo:::%s|||%d",authInfo,strlen(authInfo));

    send_data_to_websocket((uint8_t *)authInfo, strlen(authInfo) );
    // esp_websocket_client_send_bin(
    //     client, 
    //     (char *)authInfo, 
    //     strlen(authInfo), 
    //     portMAX_DELAY);
    ESP_LOGI(TAG,"authInfo::end");  
    isAuth = true ;
    // vTaskDelete(NULL);
    

}


void start_websocket(void)
{
    ESP_LOGI(TAG, "[APP] Free memory: %d bytes", esp_get_free_heap_size());
    ESP_LOGI(TAG, "[APP] IDF version: %s", esp_get_idf_version());
    // esp_log_level_set("*", ESP_LOG_INFO);
    // esp_log_level_set("WEBSOCKET_CLIENT", ESP_LOG_DEBUG);
    // esp_log_level_set("TRANSPORT_WS", ESP_LOG_DEBUG);
    // esp_log_level_set("TRANS_TCP", ESP_LOG_DEBUG);

    websocket_app_start();
}



