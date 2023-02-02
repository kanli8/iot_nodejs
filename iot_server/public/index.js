(function(){
    const loginButton = document.querySelector('#login');
    const logoutButton = document.querySelector('#logout');
    const wsButton = document.querySelector('#wsButton');
    const wsSendButton = document.querySelector('#wsSendButton');
    const clearButton = document.querySelector('#clear');


    let isLogin = false;
    let ws;

    fetch('/userinfo', {
        method: "POST",
        headers: { "Content-Type": "application/json" }
    }).then(res => res.json())
    .then(data => {
        console.log(data)
        if(data && data.result == "OK") {
            isLogin = true;
            showMessage(`Hello, ${data.userInfo.username}`)
        } else {
        }
    })

    function showMessage(message, ...others){
        console.log(message)
        if(typeof message === 'object'){
            try {
                message = JSON.stringify(message)
            } catch (error) {
            }
        }
        if(others){
            message += others.join(' ')
        }
        let showMessage = document.getElementById("showMessage").innerHTML;
        document.getElementById("showMessage").innerHTML = `${message}<br/>${showMessage}`
    }

    clearButton.onclick = function () {
        document.getElementById("showMessage").innerHTML = "";
    }

    loginButton.onclick = function () {
        if(isLogin){
            showMessage("用户已登录")
            return ;
        }
        const username = document.getElementsByName("username")[0].value.trim();
        const password = document.getElementsByName("password")[0].value.trim();
        if(!username) {
            showMessage("请输出用户名")
            return;
        }

        if(!password) {
            showMessage("请输入密码")
        }

        fetch('/login', {
            method: "POST",
            headers: { "Content-Type": "application/json"},
            body: JSON.stringify({ username, password })
        }).then(res => res.json())
        .then(data => {
            console.log(data)
            if(data && data.result == "OK") {
                isLogin = true;
                showMessage(`Hello, ${data.userInfo.username}`)
            } else {
                showMessage("登录失败")
            }
        })
    }

    logoutButton.onclick = function () {
        if(!isLogin) {
            showMessage("当前未登录")
            return
        }

        fetch('/logout', {
            method: "DELETE",
            headers: {"Content-Type": "application/json"}
        }).then(res => res.json())
        .then(data => {
            console.log(data)
            if(data.result == "OK") {
                isLogin = false;
                showMessage(data.message)
            } else {
                showMessage("退出登录失败")
            }
        })

    }

    wsButton.onclick = function() {
        if(ws) {
            ws.onerror = ws.onopen = ws.onclose = null;
            ws.close();
        }

        ws = new WebSocket('ws://localhost:8008/wr')
        ws.onerror = function () {
            showMessage("[WEBSOCKET] ERROR - WebSocket error");
        };
        ws.onopen = function () {
            showMessage("[WEBSOCKET] onOpen - WebSocket connection established");
        };
        ws.onclose = function () {
            showMessage("[WEBSOCKET] closed - WebSocket connection closed");
            ws = null;
        };
        ws.onmessage = function (data) {
            showMessage("[WEBSOCKET] onmessage - ", data.data);
        };
    }

    wsSendButton.onclick = function() {
        if (!ws) {
            showMessage("No WebSocket connection");
            return;
          }
        const message = document.getElementsByName("message")[0].value.trim();
        ws.send(message)
    }
})();