
#ifndef UTIL_H_
#define UTIL_H_



uint64_t random_64(void);

void generate_id_uint8(uint8_t* uuid);

void generate_id_and_save_to_flash() ;


void update_status_to_normal();
#endif // 