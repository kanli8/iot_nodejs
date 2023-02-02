# 编译镜像
docker build -t summit/sim-api:版本号 .

# 查看所有镜像
docker images

# 运行镜像
docker run -p 49160:8008 -d summit/sim-api:版本号

curl -i localhost:49160

docker run   \
    -u root   \
    --cpus 1 \
    -d \
    -p 8190:8008  \
    summit/sim-api:版本号

curl -i localhost:8190


# 构建镜像
unzip simApi.zip -d .
cd simApi
docker login 192.168.128.206:1080
docker build -t summit/sim-api .
docker images | grep summit/sim-api

docker tag summit/sim-api 192.168.128.206:1080/summit/sim-api
docker tag summit/sim-api 192.168.128.206:1080/summit/sim-api:版本号

docker push 192.168.128.206:1080/summit/sim-api
docker push 192.168.128.206:1080/summit/sim-api:版本号
docker images | grep summit/sim-api

