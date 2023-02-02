const readline = require('readline');
var http = require('http');
const url = require('url');
const { SerialPort } = require('serialport')
const {
    getPresetbyName,
    getPresetbyCommand
    }= require('./presetList')



//手动运行，模拟设备实体按键
var server = http.createServer(function(request, response) {
    var data = url.parse(request.url,true).query ;
    console.log(data.name+"---"+data.action);

    if(data.action=="STOP"){
        clearTimeout(runnerTimeout);
        response.end("success");  
        return ;
    }

    if(data.action=="START"){
        machineRuner(data.name,null,0);
    }
    if(data.action=="PAUSE"){
        clearTimeout(runnerTimeout);
    }

    if(data.action=="CONTINUE"){
        machineRuner(presetName,null,stepId);
    }
    
    response.end("success");  

});

server.listen(9001, async function() {

});


const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });


let port ;


function ask(question,callback){
    rl.question(question+" ", function (name) {
    console.log('commond:'+name);
    if(name=="exit"){
        console.log('\nBYE BYE !!!');
        process.exit(0);
    }
    callback(name);
    // ask();
});
      
}

function portListener(){
    port.on('data', function (data) {
        console.log('Data:', data)
      }) ;
      
}

var isRunner
var runnerTimeout ;
var stepId ;
var presetName ;
function machineRuner(mode,runcomand,step){
    presetName = mode ;
    console.log("machineRuner..."+step+":::"+mode+":::"+runcomand);
    var perlist ;
    if(mode==null){
        perlist = getPresetbyCommand(runcomand);
    }else{
        perlist = getPresetbyName(mode);
    }

    if(perlist==null){
        return  ;
    }
    var upComand = perlist.upList ;
    if(step>=upComand.length){
        isRunner = false ;
        stepId = 0;
        clearTimeout(runnerTimeout);
        return ;
    }
    stepId = step ;
    console.log("向ESP写入： "+upComand[step].buffer);
    console.log(upComand[step].buffer);
    port.write(upComand[step].buffer, function(err) {
        if (err) {
          return console.log('Error on write: ', err.message)
        }
        console.log('message written')
      })
    runnerTimeout = setTimeout(
        ()=>{
            // mode,runcomand,step
            machineRuner(mode,runcomand,step+1) ;
        },
        upComand[step].timeout
    );
}

function main(){
    SerialPort.list().then((ports, err) => {
        console.log('扫描到下面端口:');
        ports.forEach(
            element =>{
                console.log(element.path);
            }
        );
        
      })

      ask("请输入需要连接的端口:",(portname)=>{
        
        ask("请输入波特率:",(brand)=>{
            port = new SerialPort({
                path: portname,
                baudRate: Number(brand),
              });
            //   machineRuner(0,0);
              portListener();
        });
      });
}



main();