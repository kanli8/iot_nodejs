#start
export KAFKA_HEAP_OPTS="-Xmx128M -Xms128M"
nohup ./bin/zookeeper-server-start.sh config/zookeeper.properties > /dev/null &

#dev no run
export KAFKA_HEAP_OPTS="-Xmx512M -Xms128M"

nohup ./bin/kafka-server-start.sh config/server.properties > /dev/null &
#stop



./bin/kafka-topics.sh --describe --topic m2m --bootstrap-server localhost:9092

./bin/kafka-topics.sh --create --topic m2m --bootstrap-server localhost:9092
