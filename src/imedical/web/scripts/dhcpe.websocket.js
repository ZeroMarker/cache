/**
 * ���websocketͨ��  dhcpe.websocket.js
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
    upgrading: false, //��������
    sendMsg: function(msg, callFunc) { //������Ϣ
        if (this.upgrading) {
            $.messager.alert("��ʾ", "�ͻ����������������Ժ����ԣ�", "info");
            return false;
        }
        if (this.socket == null) {
            $.messager.alert("��ʾ", "δ��ʼ�����ӣ�", "info");
            return false;
        }
        try {
            switch (this.socket.readyState) {
                case 0:
                case 1:
                    this.onresponse = { //ע��ص�
                        param: msg,
                        callFunc: callFunc
                    };
                    this.socket.send(msg);
                    break;
                default:
                    $.messager.alert("��ʾ", "����δ�������ѹر�,�������ͻ��˷����Ƿ�����", "info");
                    break;
            }
        } catch (e) {
            $.messager.alert("��ʾ", "����ʧ�ܣ�<br><span style='color:red;'>����δ�������ѹر�,�������ͻ��˷����Ƿ���!", "error");
        }
    },
    onresponse: {
        param: "",
        callFunc: null
    },
    init: function() {
        console.log("��ʼ��");
        var protocol = document.location.protocol;
        var wsurl = 'ws://' + this.ip + ':' + this.port;
        // if (protocol.toLowerCase() == "https:") {
        // 	wsurl = 'wss://' + this.ip + ':' + this.ssl_port + this.ssl_path;
        // }
        this.socket = new WebSocket(wsurl);
        var self = this;
        this.socket.onopen = function(event) {
            console.log("��������");
            self.chkVersion();
            //���ӳɹ�
            self.heartCheck.start(); //�����������
        };
        //��������˷��͹�������Ϣ
        this.socket.onmessage = function(event) {
            self.heartCheck.reset(true); //��������
            //console.log(event.data);
            if (typeof self.onresponse.callFunc == "function" && event.data != "ResponseHeart") { //����˷�����Ϣʱ�����÷���ʱע��Ļص�
                self.onresponse.callFunc(self.onresponse.param, event);
            }
        };
        this.socket.onclose = function(event) {
            //console.log('websocket�Ͽ�: ' + event.code + ' ԭ��' + event.reason + ' �����Ͽ���' + event.wasClean);
            //���ӹر�
            if (self.keeplive && !self.upgrading) self.init();
        };
        this.socket.onerror = function(event) {
            if (!self.keeplive && !self.upgrading) {
                var oldOk = $.messager.defaults.ok;
                var oldCancel = $.messager.defaults.cancel;
                $.messager.defaults.ok = "����";
                $.messager.defaults.cancel = "����";
                var btns = $.messager.confirm("��ʾ", "��⵽��δ�������ͻ��ˣ�<p>\
					���ܵ�ԭ��<ul style='color:red'><li> 1. δ��װ�ͻ���</li><li> 2. �Ѱ�װδ����</li></ul></p><hr>\
					<p>�밲װ������ˢ�½�������ԣ�</p><hr>\
					<p><b>��װ��ʾ��</b></p><p>��װ��ɣ����滻�����ļ�����������</p>", function(r) {
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
                                $.messager.alert("��ʾ", URLArr.msg, "error");
                                return false;
                            }
                        });
                    } else {
                        self.keeplive = true; //��������Ҳ���ʾ
                        self.init();
                    }
                    $.messager.defaults.ok = oldOk;
                    $.messager.defaults.cancel = oldCancel;
                }).children("div.messager-button");
                btns.children("a:eq(0)").addClass('green');
            }
        };
    },
    heartCheck: { //������⣬����ʱ��������
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
                //���﷢��һ������������յ��󣬷���һ��������Ϣ��
                ws.send("ClientHeart");
                //console.log("����������ClientHeart");
                self.serverTimeoutObj = setTimeout(function() {
                    ws.close(); //�����ر� �����߼�
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
        $.messager.confirm("��ʾ", "�������ѷ����°汾���Ƿ�����������", function(r) {
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