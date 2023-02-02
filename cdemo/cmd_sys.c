#include <stdio.h>
#include<string.h>
#include<stdbool.h>

typedef unsigned __int8 uint8_t ;


//#*action params *#
bool do_sys_event(uint8_t* data ,int len){
    if(len < 6){
        return false ;
    }

    if(data[0]!='#' || data[1]!='*'|| data[len-2]!='*' || data[len-1]!='#'){
        return false ;
    }
    
    if(data[3]==0x05){
        printf("wifi clear");
    }
   

}

int main(){
    printf("hello word\n");
    int i ;
    uint8_t ii[10] ;
    ii[0] = '#';
    ii[1] = '*';
    ii[2] = 0;
    ii[3] = 5;        
    ii[8] = '*';
    ii[9] = '#';
    // uint8_t[] data =new uint8_t[8];
    do_sys_event(ii,10) ;
    scanf("%d",&i) ;
}