#include <nvs_flash.h>
#include "esp_log.h"
#include <string.h>
#include "esp_random.h"

static const char* TAG = "_util_";
uint64_t random_64(void){
    uint64_t r = esp_random();
    r <<= 32;
    r |= esp_random();
    return r;
}


uint64_t uint8_array_to_uint64(uint8_t *array){
    uint64_t r = 0;
    for (int i = 0; i < 8; i++) {
        r <<= 8;
        r |= array[i];
    }
    return r;
}

char* uint64_to_hex_string(uint64_t num){
    char* str = malloc(17);
    /**
     * The description of fprintf() in the C99 Standard tells us that the conversion specification is made up of%016llx
    *  the mandatory character%
     *   a flag for padding0
      *  the as "minimum field width"16
       * the as "length modifiers"ll
       * the conversion specifierx
       * So, in whole it means to write a unsigned long long int in hexadecimal notation occupying a minimum of 16 positions, padded with 0.
     */

    sprintf(str, "%016llx", num);
    return str;
}

//uint8_t array to hex string
char* uint8_array_to_hex_string(uint8_t *array, int len){
    char* str = malloc(len * 2 + 1);
    for (int i = 0; i < len; i++) {
        sprintf(str + i * 2, "%02x", array[i]);
    }
    return str;
}





void save_id_to_flash(uint8_t* id){
    //save id to flash and update status to flash
    nvs_handle my_handle;
    esp_err_t err = nvs_open("storage", NVS_READWRITE, &my_handle);
    uint64_t u_id = uint8_array_to_uint64(id);
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "Error (%s) opening NVS handle!\r","save_id_to_flash");
        } else {
        ESP_LOGI(TAG, "save id to flash\r");
        err = nvs_set_u64(my_handle, "id", u_id);
        err = nvs_set_u8(my_handle, "device_status", 1); //1:id saved; 0:normal
        if (err != ESP_OK) {
            ESP_LOGE(TAG, "Error (%s) nvs_set_blob!\r","save_id_to_flash");
        }
        err = nvs_commit(my_handle);
        if (err != ESP_OK) {
            ESP_LOGE(TAG, "Error (%s) nvs_commit!\r","save_id_to_flash");
        }
        nvs_close(my_handle);
    }

    //
}

void generate_id_uint8(uint8_t* id){
    uint64_t r = random_64();
    memcpy(id, &r, 8);
    //save id to flash
    save_id_to_flash(id);
}


void generate_id_and_save_to_flash(){
    uint8_t id[8];
    generate_id_uint8(id);
    save_id_to_flash(id);
}


void update_status_to_normal(){
    nvs_handle my_handle;
    esp_err_t err = nvs_open("storage", NVS_READWRITE, &my_handle);
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "Error (%s) opening NVS handle!\r","update_status");
        } else {
        ESP_LOGI(TAG, "update status to flash\r");
        err = nvs_set_u8(my_handle, "device_status", 0); //1:id saved; 0:normal
        if (err != ESP_OK) {
            ESP_LOGE(TAG, "Error (%s) nvs_set_blob!\r","update_status");
        }
        err = nvs_commit(my_handle);
        if (err != ESP_OK) {
            ESP_LOGE(TAG, "Error (%s) nvs_commit!\r","update_status");
        }
        nvs_close(my_handle);
    }
}
