#redis
docker run --name iot-redis -p 6379:6379 -d redis

#mysql
docker run --name iot-mariadb -p 3306:3306 -e MYSQL_ROOT_PASSWORD=iotrootpassroot -e MYSQL_DATABASE=iot -e MYSQL_USER=iot -e MYSQL_PASSWORD=iotiot -d mariadb:10.7
