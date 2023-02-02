const { Kafka } = require('kafkajs')

const kafka = new Kafka({
  clientId: 'my-app-customer',
  brokers: ['localhost:9092'],
})

const consumer = kafka.consumer({ groupId: 'iot_customer' })

async function main(){


    await consumer.connect()
    await consumer.subscribe({ topic: 'm2m', fromBeginning: true })
    await consumer.run({
        eachMessage: async ({ topic, partition, message }) => {
            //处理MQ 数据

            //暂时转发回去，串起来
            console.log({
                value: message.value.toString(),
            })
        },
    }) ;
}

main();