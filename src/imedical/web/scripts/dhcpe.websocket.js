/**
 * 体检websocket通信  dhcpe.websocket.js
 * @Author   wangguoying
 * @DateTime 2020-11-18
 */

$PESocket = {
    ip: "127.0.0.1",
    port: 9090,
    ssl_port: 999,
    ssl_path: "/dhcpewss",
    socket: null,
    keeplive: false,
    upgrading: false, //正在升级
    sendMsg: function(msg, callFunc) { //发送消息
        if (this.upgrading) {
            $.messager.alert("提示", "客户端正在升级，请稍后再试！", "info");
            return false;
        }
        if (this.socket == null) {
            $.messager.alert("提示", "未初始化连接！", "info");
            return false;
        }
        try {
            switch (this.socket.readyState) {
                case 0:
                case 1:
                    this.onresponse = { //注册回调
                        param: msg,
                        callFunc: callFunc
                    };
                    this.socket.send(msg);
                    break;
                default:
                    $.messager.alert("提示", "链接未建立或已关闭,请检查体检客户端服务是否开启！", "info");
                    break;
            }
        } catch (e) {
            $.messager.alert("提示", "发送失败：<br><span style='color:red;'>链接未建立或已关闭,请检查体检客户端服务是否开启!", "error");
        }
    },
    onresponse: {
        param: "",
        callFunc: null
    },
    init: function() {
        console.log("初始化");
        var protocol = document.location.protocol;
        var wsurl = 'ws://' + this.ip + ':' + this.port;
        // if (protocol.toLowerCase() == "https:") {
        // 	wsurl = 'wss://' + this.ip + ':' + this.ssl_port + this.ssl_path;
        // }
        this.socket = new WebSocket(wsurl);
        var self = this;
        this.socket.onopen = function(event) {
            console.log("建立链接");
            self.chkVersion();
            //连接成功
            self.heartCheck.start(); //开启心跳检测
        };
        //监听服务端发送过来的消息
        this.socket.onmessage = function(event) {
            self.heartCheck.reset(true); //重置心跳
            //console.log(event.data);
            if (typeof self.onresponse.callFunc == "function" && event.data != "ResponseHeart") { //服务端返回消息时，调用发送时注册的回调
                self.onresponse.callFunc(self.onresponse.param, event);
            }
        };
        this.socket.onclose = function(event) {
            //console.log('websocket断开: ' + event.code + ' 原因：' + event.reason + ' 正常断开：' + event.wasClean);
            //连接关闭
            if (self.keeplive && !self.upgrading) self.init();
        };
        this.socket.onerror = function(event) {
            if (!self.keeplive && !self.upgrading) {
                var oldOk = $.messager.defaults.ok;
                var oldCancel = $.messager.defaults.cancel;
                $.messager.defaults.ok = "下载";
                $.messager.defaults.cancel = "忽略";
                var btns = $.messager.confirm("提示", "检测到您未开启体检客户端！<p>\
					可能的原因：<ul style='color:red'><li> 1. 未安装客户端</li><li> 2. 已安装未启动</li></ul></p><hr>\
					<p>请安装启动后刷新界面后再试！</p><hr>\
					<p><b>安装提示：</b></p><p>安装完成，需替换配置文件后再启动！</p>", function(r) {
                    if (r) {
                        self.heartCheck.reset(false);
                        $cm({
                            ClassName: "web.DHCPE.ClientManager",
                            MethodName: "GetDownloadUrl",
                            Type: "INSTALL",
                            ResultSetType: "array"
                        }, function(URLArr) {
                            if (Array.isArray(URLArr)) {
                                URLArr.forEach(el => {
                                    window.open(el.url);
                                });
                            } else {
                                $.messager.alert("提示", URLArr.msg, "error");
                                return false;
                            }
                        });
                    } else {
                        self.keeplive = true; //继续检测且不提示
                        self.init();
                    }
                    $.messager.defaults.ok = oldOk;
                    $.messager.defaults.cancel = oldCancel;
                }).children("div.messager-button");
                btns.children("a:eq(0)").addClass('green');
            }
        };
    },
    heartCheck: { //心跳检测，故障时触发重连
        timeout: 6000,
        timeoutObj: null,
        serverTimeoutObj: null,
        reset: function(reStart) {
            this.timeoutObj && clearTimeout(this.timeoutObj);
            this.serverTimeoutObj && clearTimeout(this.serverTimeoutObj);
            if (reStart) this.start();
        },
        start: function() {
            var self = this;
            var ws = $PESocket.socket;
            this.timeoutObj = setTimeout(function() {
                //这里发送一个心跳，后端收到后，返回一个心跳消息，
                ws.send("ClientHeart");
                //console.log("发送心跳：ClientHeart");
                self.serverTimeoutObj = setTimeout(function() {
                    ws.close(); //触发关闭 重连逻辑
                }, self.timeout);

            }, this.timeout)
        }
    },
    chkVersion: function() {
        var param = JSON.stringify({ business: "VERSIONINFO", operation: "askUpgrade" });
        $PESocket.sendMsg(param, this.versionCB);
    },
    versionCB: function(param, event) {
        var paramObj = JSON.parse(param);
        var retObj = JSON.parse(event.data);
        if (retObj.code == 0 && paramObj.operation == "askUpgrade" && retObj.msg == 1) {
            $PESocket.upgrade();
        }
    },
    upgrade: function() {
        $.messager.confirm("提示", "服务器已发布新版本，是否立即升级？", function(r) {
            if (r) {
                var param = JSON.stringify({ business: "VERSIONINFO", operation: "upgrade" });
                $PESocket.sendMsg(param, null);
                $PESocket.keeplive = true;
                $PESocket.upgrading = true;
            }
        });
    }
}

$PESocket.init();