#移除磁盘
docker volume ls
docker volume rm appwrite_kafka_data
docker volume rm appwrite_zookeeper_data
docker volume rm appwrite_appwrite-redis


# 查看网络
docker network ls
docker network inspect appwrite_appwrite

#get mysql ip
"Name": "appwrite-mariadb",
"EndpointID": "3144dab50fb75bf675bd94289fd0f1194808a9bd6a80611a7da7fe4ada9e9683",
"MacAddress": "02:42:c0:a8:00:02",
"IPv4Address": "192.168.0.2/20",

#login mysql
mysql -uuser -h 192.168.0.2 -p

"Name": "appwrite-influxdb",
                "EndpointID": "ab0216da86585c3f3edda92a79c41e3daf4f146bb7db92377ba451526e462851",
                "MacAddress": "02:42:c0:a8:00:05",
                "IPv4Address": "192.168.0.5/20",
                "IPv6Address": ""



172.21.0.5

# Usage
#   Start:          docker compose up -d
docker compose up -d
#   With helpers:   docker-compose -f docker-compose.yml -f ./dev/docker-compose.dev.yml up
#   Stop:           docker compose down
docker compose down
#   Destroy:        docker-compose -f docker-compose.yml -f ./dev/docker-compose.dev.yml down -v --remove-orphans
#                   docker compose -f docker-compose.yml down -v --remove-orphans
