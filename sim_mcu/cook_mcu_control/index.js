const readline = require('readline');
const fetch = require('node-fetch');

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




function machineInput(){
    ask("请输入运行模式(action|name):",async (mode)=>{
        console.log('machineInput....'+mode);
        chars = mode.split("|");
        var url = new URL("http://127.0.0.1:9001/"),
        params = {action:chars[0], name:chars[1]};
        Object.keys(params).forEach(key => url.searchParams.append(key, params[key]))
        fetch(url).then(/* … */)
        const response = await fetch( url );
        console.log(response);
        machineInput();
    });
}


function main(){
    machineInput();
}



main();