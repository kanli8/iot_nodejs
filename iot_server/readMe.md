http://192.168.128.206:1080/

http://192.168.128.206:9000/
admin/sunmi168

router.get('/newRoute', filter,async function(req, res, next) {
    
    
    let user =await mongodb.doMongoDbQuery();

    res.send(user);



  });


  docker run   \
    -u root   \
    -d --expose 3000  \
    -p 8190:3000  \
    192.168.128.206:1080/summit/all_node:1.0   \
    nodejs /root/simApi/bin/www 


--单docker 
 docker run 
    --name project_name
    -u root   
    -d 
    --cpu_limit 1
    --memory_limit 1G
    --file_space 50G
    -env MANAGER_PK=TEST_MANAGER_PK MANAGER_SK=TEST_MANAGER_SK
    -v /home/data/project_id:/mnt/data
    --expose 3000  
    -p 8189:3000   //每个docker 映射端口都是不同的
    192.168.128.206:1080/summit/all_node:1.0  
    nodejs /root/simApi/bin/www


  docker run   \
    -u root   \
    -d --expose 3000  \
    -p 8190:3000  \
    192.168.128.206:1080/summit/all_node:1.0   \
    nodejs /root/simApi/bin/www 

docker run \
    --name sim-001 \
    -u root   \
    -d  \
    --cpus 1 \
    --memory 1G \
    -env MANAGER_PK=TEST_MANAGER_PK MANAGER_SK=TEST_MANAGER_SK \
    -v /home/data/sim-001:/mnt/data \
    --expose 3000   \
    -p 8190:3000   \
    192.168.128.206:1080/summit/all_node:1.0   \
    nodejs /root/simApi/bin/www  \


-- 双docker

-- 弹性资源

-http://127.0.0.1:8189/ping
--post insert code

-- 改nginx的redis指向
-- 
