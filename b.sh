#/bin/bash
cd ~
nohup ./clash > clash.log &

cd ~/iot_nodejs

cd iot_task
code .

cd ../iot_front
code .

cd ../esp_client
code .

cd ../flutter_app/flutter_demo
code .

sleep 10

wmctrl -i -r `wmctrl -l | grep flutter_demo | awk '{print $1}'`  -t 1
wmctrl -i -r `wmctrl -l | grep iot_front | awk '{print $1}'`  -t 2
wmctrl -i -r `wmctrl -l | grep iot_task | awk '{print $1}'`  -t 3
wmctrl -i -r `wmctrl -l | grep esp_client | awk '{print $1}'`  -t 4
scrcpy


