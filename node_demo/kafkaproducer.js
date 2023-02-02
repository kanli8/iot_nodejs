const { Kafka } = require('kafkajs')
const {Base64} = require('js-base64');

const kafka = new Kafka({
  clientId: 'my-app-producer',
  brokers: ['localhost:9092'],
})


async function produt(){
    let u8s   =  new Uint8Array([100,97,110,107,111,103,97,105]);
    var base64 = Base64.fromUint8Array(u8s);       // ZGFua29nYWk=
    let nu8s = Base64.toUint8Array(base64);
    console.log(nu8s);
    console.log(u8s);
    // const producer = kafka.producer() ;
    // await producer.connect()
    // await producer.send({
    // topic: 'm2m',
    // // compression: CompressionTypes.GZIP,
    // messages: [
    //     {value:base64}
    // ],
    // })

    // await producer.disconnect()
}

produt() ;
