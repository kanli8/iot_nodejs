
#ifndef ROUTER_H_
#define ROUTER_H_



void setRoute(
    int recivId ,
    void(*Sender)(char* a, int len));

void sendData(char* a ,int len);
#endif // 