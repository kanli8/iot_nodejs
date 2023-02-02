# 参考example


## 用户事件循环
D:\github\esp32_env\esp_idf\examples\system\esp_event\user_event_loops

application_task是串起用户事件的关键，要不然，


## 串口通讯
D:\github\esp32_env\esp_idf\examples\peripherals\uart\uart_echo


## wifi连接

## 常用命令
- 编译
idf.py build
-
idf.py erase_flash 
- 运行
idf.py erase_flash -p /dev/ttyUSB0
idf.py -p (PORT) flash
idf.py -p COM3 flash
idf.py -p COM4 flash
idf.py flash -p /dev/ttyUSB0 -b 115200
- 诊断及日志查看
idf.py monitor -p /dev/ttyUSB0 -b 115200

## 配网

- 工具
https://github.com/espressif/esp-idf-provisioning-android/releases
- 参考项目
https://github.com/espressif/esp-jumpstart
 4_network_config

- 实际参考项目
D:\github\esp32_env\esp_idf\examples\provisioning\legacy\ble_prov


## websocket 添加header
报错 Sec-WebSocket-Accept not found
来源 esp_idf\components\tcp_transport\transport_ws.c的ws_connect
上级调用esp_transport_ws_init
上级调用esp_idf\components\esp_websocket_client\esp_websocket_client.c的esp_websocket_client_init





## Kconfig.projbuild 编写规范及获取参数值方式


## git
git config --global user.name "kanli8"
git config --global user.email "kanlipan@outlook.com"
ssh-keygen -t rsa -C "kanlipan@outlook.com"


 ## 常用指令

固定头0 0x50|版本号1 1byte|ID 4byte|模板号2 1byte|消息序号3 2byte|iot预留5 2byte|消息长度(2位)6 2byte|
消息体8 nbyte|RID 3byte|SID 1byte|校验位 1byte|固定尾0X4C

消息体一般定义
模式 1byte|状态 1byte|参数1 nbyte|参数2 nbyte|参数3 nbyte|...

- 配网(此指令不会被系统接收到)
23 2A 00 01 00 2A 23

- 测试model_id=1 的指令
|----------------------------------|--长度---|P1 | P2  | mutl2   |  mutl3    | cv |  
0x50 0x01 0x01 0x00 0x01 0x00 0x00 0x00 0x12 0x64 0x97 0x0A 0x2A 0xB2 0XB2 0XB2 0xAA 0x4C

50 01 01 00 01 00 00 00 12 64 97 0A 2A B2 B2 B2 AA 4C
                  

- 指令队列（菜谱）
IOT预留
1000 0000 0000 0000







## 周边配件

FPC 天线 带3M胶

https://item.taobao.com/item.htm?spm=a230r.1.14.106.77511aebnCbwox&id=550184058731&ns=1&abbucket=7#detail



烧录地板

https://item.taobao.com/item.htm?spm=a1z10.5-c-s.w4002-22443450244.33.261527ca9pIoL4&id=607781224985