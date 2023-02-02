
#ifndef SYS_H_
#define SYS_H_

#define ESP_IS_NORMAL 0x00 //normal
#define ESP_IS_PROVISIONING 0x01 //provisioning
#define ESP_IS_PROVISIONED 0x02 //provisioned
#define ESP_IS_CONNECTED 0x03 //connected
#define ESP_IS_DISCONNECTED 0x04 //disconnected
#define ESP_UID_NOT_FOUND 0x05 //uid not found
#define ESP_ID_NOT_FOUND 0x06
#define ESP_SK_NOT_FOUND 0x07
#define ESP_IS_ERROR 0xFF //error


bool do_sys_event(uint8_t* data ,int len);
void set_esp_status(uint8_t status) ;
#endif // 