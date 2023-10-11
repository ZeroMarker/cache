var mydll;
var SignBase64 = "";
var FingerBase64 = "";
var SignFingerBase64 = "";

function HeBCASignCallbackFunc(ret, backData){    
    $('#cancelSign').linkbutton('enable');
    $('#confirmSign').linkbutton('enable');
    if (ret == 1) {
        var obj = eval('(' + backData + ')');
        var sealResult = obj.SignInfo.sealResult;
        var source = obj.SignInfo.source;
        
        //签名图
        try {
            var sealPic = obj.SignInfo.sealImage;
        } catch(err) {
            var sealPic = "";
        }

        SignFingerBase64 = sealPic;
        SignFingerBase64 = SignFingerBase64.replace(/[\n]/g,"");    
        try {
            $("#handscript").attr('src', 'data:image/png;base64, ' + SignFingerBase64);
        } catch(err) {}
        evidence.Evidence[0].Content = SignFingerBase64;
    } else {
        alert("采集签名图片失败");
    }
}

var ConnectComClient = ConnectComClient || {};
function initHebCAComClient() {
    (function ($c) {
        //JS库版本相关信息
        var VersionInfo = {
            version: "2.0.1",
            versionInt: 0x020001,
            productName: "ConnectComObject",
            productNameCn: "证信签3.0 ConnectCom服务",
            getInfo: function () {
                return this.productName + " V"+this.version;
            }
        };
        
        //错误描述定义的变量定义
        var EnvVar={
            CLIENT_NAME: { name: "CLIENT_NAME", value: "河北CA数字证书助手一证通用版" },
            WEB_HOST: { name: "WEB_HOST", value: "www.hebca.com"},
            CLIENT_DOWNLOAD_URL: {name: "CLIENT_DOWNLOAD_URL", value: "http://helper.pasiatec.com/client/HEBCA-helper.exe"}
        };

        //JS库使用的错误定义
        var ErrorMapping={
            ERR_NO_SELECT_CERT: { err: 1000,  message: "未选择证书" },
            ERR_NO_SELECT_SIGN_CERT: { err: 1001,  message: "未选择签名证书" },
            ERR_NO_SELECT_CRYPT_CERT: { err: 1002,  message: "未选择加密证书" },
            ERR_CREATE_CONNCOM_IE: { err: 1003, message: "没有安装河北CA证书助手客户端软件或IE阻止其运行" },
            ERR_OPEN_CONNCOM_SERVICE: { err: 1004, message: '打开河北CA证书服务失败'},
            ERR_NOT_FIND_CERT: { err: 1005, message: '没有找到对应的证书' },
            ERR_NOT_CRYPT_CERT: { err: 1006, message: '请添加接收者证书' },
            ERR_NOT_SUPPORT_FUN: { err: 1007, message: '不支持此功能' },
            ERR_NOT_CERT_SELECTOR: { err: 1008, message: '没有指定选择项' },
            ERR_WEBSOCKET_NO_RESPONES: { err: 1009, message: 'P11服务没有回应' }
        };

        //自定义错误描述，适合hebca，以文本方式显示
        function errorStyle_hebca_text(client) {
            //没有安装河北CA证书助手客户端软件或IE阻止其运行
            client.defineError(1003,"$ORG_MESSAGE，请确认：\n1.检查您的电脑中是否安装了$CLIENT_NAME，如没有安装，请到河北CA网站$WEB_HOST下载安装；\n2.如已安装助手，请打开助手执行故障检测，然后重新浏览器后重试.");
            //打开河北CA证书服务失败,crhome
            client.defineError(1004,"$ORG_MESSAGE\n1.如果您还没有安装$CLIENT_NAME，请到河北CA网站$WEB_HOST下载安装；\n 2.如已安装助手，请在弹出的对话框中，点击“打开或者允许”，然后刷新页面重试.");
            //数字证书不存在
            client.defineError(-536145917, "$ORG_MESSAGE，请确认您已经将河北CA数字证书USB Key插入电脑中，或者将数字证书USB Key拔插后重试");
            //程序执行失败， 请拔插key后重试
            client.defineError(-536145887, "$ORG_MESSAGE，请将数字证书USB Key拔插后重试");
            client.defineError("other","$ORG_MESSAGE，请联系河北CA客服，客服电话：400-707-3355");
        }

        function errorStyle_hebca_html(client) {
            //没有安装河北CA证书助手客户端软件或IE阻止其运行
            client.defineError(1003,"$ORG_MESSAGE，请确认：<br /> 1.检查您的电脑中是否安装$CLIENT_NAME，如没有安装，请<a herf='$CLIENT_DOWNLOAD_URL'>点击这里</a>下载安装；<br />2.如已安装助手，请打开助手执行故障检测，然后重新浏览器后重试.");
            //打开河北CA证书服务失败,crhome
            client.defineError(1004,"$ORG_MESSAGE<br />1.如果您还没有安装$CLIENT_NAME，请<a href='$CLIENT_DOWNLOAD_URL' target='_blank'>点击这里</a>下载安装； <br /> 2.如已安装助手，请在弹出的对话框中，点击“打开或者允许”，然后刷新页面重试.");
            //数字证书不存在
            client.defineError(-536145917, "$ORG_MESSAGE，请确认您已经将河北CA数字证书USB Key插入电脑中，或者将数字证书USB Key拔插后重试");
            //程序执行失败， 请拔插key后重试
            client.defineError(-536145887, "$ORG_MESSAGE，请将数字证书USB Key拔插后重试");
            client.defineError("other","$ORG_MESSAGE(错误号:$ERR)，请联系河北CA客服，客服电话：400-707-3355, 或者<a href='http://v1.live800.com/live800/chatClient/chatbox.jsp?companyID=551849&configID=42419&jid=7440845194&s=1' target='_blank'>点击这里</a>联系在线客服");
        }

        /**
         * ConnectComObject
         * @constructor
         * @param param 初始化参数，可以接收初始化或者后续使用的错误事件，可选。如果缺省此函数，在初始化失败时，直接抛出异常。
         *              如果提供了此函数，并包含相应的回调函数，在初始化失败时，进行回调。
         * {
         *        debug: true|false, default false
         *        errorStyle: "hebca/text | hebca/html | default"
         *        errorDivId:
         *        defaultErrorShow:
         *     success: function(){}
         *     fail: function(e){}  在无法初始化Hebca控件或者服务时将回调此函数
         * }
         */
        function ConnectComObject(param){
            this.initParam= param || {};

            this.isIE = window.ActiveXObject !== undefined;
            var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
            this.isEdge = userAgent.indexOf("Edge") > -1; //判断是否IE的Edge浏览器

            //IE的com控件，或者npapi插件
            this.connCom = null;

            //高版本chrome，websocket服务模式
            this.socket = null;
            this.host = "ws://localhost:17215/test";

            this.redefineErrorMapping={};
            if(this.initParam){
                this._setErrorStyle(this.initParam.errorStyle);
            }

            //this.debug("ConnectCom Object begin init ( isIE = "+this.isIE+", isEdge = "+ this.isEdge+" )");
            this._initConnectComObject();
        }

        ConnectComObject.prototype._setErrorStyle=function(style){
            style=style||"default";
            if(style==="hebca/text"){
                errorStyle_hebca_text(this);
            }
            else if(style==="hebca/html"){
                errorStyle_hebca_html(this);
            }
            else{
                //default
                //do nothing
            }
        };

        ConnectComObject.prototype._runEnvVar=function(message, envVar){
            return message.replace("$"+envVar.name, envVar.value);
        };

        ConnectComObject.prototype.defineError=function(errNum,message){
            message=this._runEnvVar(message,EnvVar.CLIENT_NAME);
            message=this._runEnvVar(message,EnvVar.CLIENT_DOWNLOAD_URL);
            message=this._runEnvVar(message,EnvVar.WEB_HOST);

            if(typeof errNum === "number"){
                this.redefineErrorMapping[errNum.toString()]=message;
            }
            else {
                this.redefineErrorMapping[errNum]=message;
            }
        };

        ConnectComObject.prototype._getErrorMessage=function(errNum,origMessage){
            if(errNum===undefined || errNum===null ){
                return origMessage
            }

            var redefine = this.redefineErrorMapping[errNum.toString()];
            if(redefine===undefined){
                var other=this.redefineErrorMapping["other"];
                if(other!==undefined){
                    other = other.replace("$ORG_MESSAGE",origMessage);
                    other = other.replace("$ERR", errNum.toString());
                    return other;
                }
                else{
                    return origMessage;
                }
            }
            else{
                redefine = redefine.replace("$ORG_MESSAGE",origMessage);
                redefine = redefine.replace("$ERR", errNum.toString());
                return redefine;
            }
        };

        ConnectComObject.prototype._createError=function(err){
            var e = new Error(this._getErrorMessage(err.err,err.message));
            e.err = err.err;
            e.mapped=true;
            return e;
        };

        ConnectComObject.prototype._createErrorConnnectComObjectIE=function(e){
            var error = new Error(this._getErrorMessage(e.number,e.message));
            error.err = e.number;
            e.mapped=true;
            return error;
        };

        ConnectComObject.prototype._createErrorConnnectComService=function(ret,message){
            var e = new Error(this._getErrorMessage(ret,message));
            e.err = ret;
            e.mapped=true;
            return e;
        };

        ConnectComObject.prototype._showError=function(e,param){
            if(param && param.ignoreError){
                return;  //忽略错误，不显示
            }

            if(this.initParam && this.initParam.errorDivId){
                //在应用的div中显示错误信息
                var div=document.getElementById(this.initParam.errorDivId);
                if(div){
                    div.innerHTML=e.message;
                }
            }
            else{
                if(this.initParam && (this.initParam.defaultErrorShow===undefined || this.initParam.defineErrorShow===true) ){
                    this._showErrorInDefaultPane(e);
                }
            }
        };

        ConnectComObject.prototype._showErrorInDefaultPane=function(e){
            var hebca_errorPaneContainer=document.getElementById("hebca_errorPaneContainer");
            if(!hebca_errorPaneContainer)
            {
                var cssContainer="position:fixed; top:1px; padding: 10px; background-color: lightpink; width: 100%; text-align: left; visibility: hidden";
                var cssClose1="position:fixed; top:15px; right: 10px; display: inline-block; width: 15px; height: 4px; background: #CCCCCC; transform: rotate(45deg);";
                var cssClose2="position:fixed; top:15px; right: 10px; display: block; width: 15px; height: 4px; background: #CCCCCC; transform: rotate(-45deg);";
                var onclick="javascript: document.getElementById('hebca_errorPaneContainer').style.visibility='hidden';";

                if(navigator && navigator.userAgent.match(/msie/i)){
                    //ie
                    var errorPaneContainer = document.createElement("div");
                    errorPaneContainer.setAttribute("id", "hebca_errorPaneContainer");
                    errorPaneContainer.setAttribute("style", cssContainer);
                    errorPaneContainer.style.backgroundColor = "lightpink";
                    errorPaneContainer.style.padding = "10px";
                    errorPaneContainer.style.width = "100%";
                    errorPaneContainer.style.textAlign="left";
                    errorPaneContainer.style.visibility="hidden";

                    var errorPane = document.createElement('span');
                    errorPane.setAttribute('id','hebca_errorPane');
                    errorPaneContainer.appendChild(errorPane);

                    var close = document.createElement('span');
                    close.setAttribute('id','close');
                    close.onclick=function(){
                        document.getElementById('hebca_errorPaneContainer').style.visibility='hidden';
                    };
                    close.innerText="点击关闭提示框";
                    close.style.textAlign="left";
                    //close.style.position = "fixed";
                    //close.style.top = "15px";
                    close.style.paddingLeft = "30px";
                    close.style.textDecoration="underline";
                    errorPaneContainer.appendChild(close);

                    document.body.insertBefore(errorPaneContainer, document.body.children[0]);
                }
                else
                {
                    var pane='<div id="hebca_errorPane"></div><span id="close1" style="'+cssClose1+'" onclick="'+onclick+'"></span><span id="close2" style="'+cssClose2+'" onclick="'+onclick+'"></span>';
                    var errorPane = document.createElement("div");
                    errorPane.setAttribute("id", "hebca_errorPaneContainer");
                    errorPane.setAttribute("style", cssContainer);
                    errorPane.innerHTML=pane;
                    document.body.appendChild(errorPane);
                }

                hebca_errorPaneContainer=document.getElementById("hebca_errorPaneContainer");
            }

            hebca_errorPaneContainer.style.backgroundColor="lightcoral";
            hebca_errorPaneContainer.style.visibility="visible";

            if(navigator && navigator.userAgent.match(/msie/i)){
                var p=document.getElementById("hebca_errorPane");
                p.innerHTML=e.message;
            }
            else{
                var p=document.getElementById("hebca_errorPane");
                p.innerHTML=e.message;
            }

        };

        ConnectComObject.prototype._createConnectComObjectIE=function(){
            if (null != this.connCom){
                return this.connCom;
            }

            if (this.isIE){
                // IE 浏览器创建插件
                try{
                    this.connCom=new ActiveXObject("ConnCom.ID");
                    //this.debug("Create ConnCom.ID Object Success");
                }
                catch(e){
                    //this.debug("Create ConnCom.ID Object Failed: "+e.message);
                    var ex=this._createError(ErrorMapping.ERR_CREATE_CONNCOM_IE);
                    this._showError(ex,param);
                    if(this.initParam && this.initParam.fail){
                        this.initParam.fail(ex);
                    }
                    else{
                        //如果没有定义回调函数接收错误，则直接抛出异常
                        throw ex;
                    }
                }
            }
        };

        ConnectComObject.prototype._connectConnectComWebSocketService=function (successCallback) {
            try{
                var that=this;
                this.socket = new WebSocket(this.host);
                //this.debug("WebSocket begin connect...");
                this.socket.onopen = function(){
                    //that.debug("WebSocket onopen success");
                    that.socket.send('0|'+  new Date().getTime());
                };
                this.socket.onclose = function(){
                    //that.debug("WebSocket onclose");
                    var ex=that._createError(ErrorMapping.ERR_OPEN_CONNCOM_SERVICE);
                    that._showError(ex);
                    if(that.initParam && that.initParam.fail){
                        that.initParam.fail(ex);
                    }
                    document.location.href="P11://";
                    that.socket=null;
                };
                this.socket.onerror = function(e){
                    //that.debug("WebSocket onerror");
                    var ex=that._createError(ErrorMapping.ERR_OPEN_CONNCOM_SERVICE);
                    that._showError(ex);
                    if(that.initParam && that.initParam.fail){
                        that.initParam.fail(ex);
                    }
                    //document.location.href="P11://";
                    that.socket=null;
                };
                this.socket.onmessage = function(msg){
                    //that.debug("WebSocket onmessage success");
                    var args  = msg.data.split('|');
                    if(args[0] === "0" && args[1].indexOf("Welcome")!== -1){
                        //that.debug("Webscoket Welcome");
                        if(that.initParam && that.initParam.success){
                            that.initParam.success(that);
                        }

                        if(successCallback){
                            successCallback();
                        }
                    }
                }
            } catch(e){
                //this.debug("WebSocket excpetion:"+e.message);
                document.location.href="P11://";

                var ex=this._createError(ErrorMapping.ERR_OPEN_CONNCOM_SERVICE);
                this._showError(ex);
                if(this.initParam && this.initParam.fail){
                    this.initParam.fail(ex);
                }
                else{
                    //如果没有定义回调函数接收错误，则直接抛出异常
                    throw ex;
                }
            }
        };
        
        ConnectComObject.prototype._connectConnectComNPAPI=function (successCallback) {
            try{
                var hebcaMimeType = "application/hebca-npconnectcom-plugin";
                if (!(navigator.mimeTypes && navigator.mimeTypes[hebcaMimeType] && navigator.mimeTypes[hebcaMimeType].enabledPlugin))
                {
                    throw Error("请检查是否安装河北CA采集控件多浏览器客户端或被浏览器禁用!\r\n安装或启用后重新打开浏览器再试！");
                    return null;
                }

                var plugin_embed = document.createElement("embed"); 
                plugin_embed.setAttribute("id", "npConnectComplugin");  
                plugin_embed.setAttribute("type", hebcaMimeType);  
                plugin_embed.setAttribute("width", 0);  
                plugin_embed.setAttribute("height", 0);  
                document.body.appendChild(plugin_embed); 

                this.connCom = document.getElementById("npConnectComplugin");
                
                try{
                    //检测是否安装成功, 若被浏览器阻止, 会抛出异常.
                    this.connCom.CheckBlockedByBrowser();
                } catch(e) {
                    throw Error("插件未安装或被浏览器阻止.");
                    return null;
                }
                
                // 检测ConnectCom是否安装
                var bIsConnectComInstall = this.connCom.CheckConnectComInstalled();
                if(false == bIsConnectComInstall)
                {
                    throw Error("ConnectCom控件未安装");
                    this.connCom = null;
                }
            } catch(e) {
                throw Error("插件未安装或被浏览器阻止.");
                return null;
            }
        };


        ConnectComObject.prototype._initConnectComObject=function(){
            var that=this;
            if(this.isIE){
                this._createConnectComObjectIE();
            }else {
                //this._connectConnectComWebSocketService(function () {    });
                this._connectConnectComNPAPI(function () {    });
            }
        };


        ConnectComObject.prototype._webSocketSend=function(fun,param,success,fail){
            if(this.socket===null){
                var that=this;
                this._connectConnectComWebSocketService(function () {
                    that._webSocketSendImp(fun,param,success,fail);
                });
            }
            else{
                this._webSocketSendImp(fun,param,success,fail);
            }
        };

        ConnectComObject.prototype._webSocketSendImp=function(fun,param,success,fail){
            var msgSend ='1|'+fun;
            if(param){
                msgSend+="|"+param;
            }

            //this.debug("WebSocket Send: "+msgSend);
            this.socket.send(msgSend);
            var that=this;

            this.socket.onmessage = function(msg){

                //that.debug("WebSocket Recieve: "+msg.data);
                var args  = msg.data.split('|');
                if(args[1] == fun){
                    var json = eval("("+args[2]+")");
                    if(json.ret == 0){
                        if(success){
                            success(json);
                        }
                    }else{
                        if(fail){
                            fail(that._createErrorConnnectComService(json.ret, json.msg));
                        }
                    }
                }
            }
        };

        ConnectComObject.prototype._onSuccess=function(name,param,ret,value){
            if(param && param.success){
                param.success(ret,value);
            }
        };

        ConnectComObject.prototype._onFail=function(name,param,e){
            var errNum=0;
            if(typeof e.err!=="undefined"){
                errNum=e.err
            }
            else if(typeof e.number!=="undefined"){
                errNum=e.number;
            }
            //this.debug(name + " failed: ",e, "err:", errNum );

            if(e.mapped)
            {
                //do nothing
            }
            else{
                var message = this._getErrorMessage(errNum, e.message);
                e=new Error(message);
                e.err=errNum;
                e.mapped=true;
            }
            this._showError(e,param);

            if(param && param.fail){
                param.fail(e);
            }
        };

        ConnectComObject.prototype.getSignImage=function(param){
            
            var name="getSignImage";
            if(this.isIE){
                try{
                    this.connCom.GetSignImage(param.imageType, param.px, param.py, param.success);
                }catch(e){
                    this._onFail(name,param,e);
                }
            }else{
                var that=this;
                this._webSocketSend('GetSignImageSyn','{"imageType":"'+ param.imageType +'","px":' + param.px + ',"py":' + param.py +'}',function (json) {
                    that._onSuccess(name,param,json.ret,json.signImage);
                },function (e) {
                    that._onFail(name,param,e);
                });
            }
            
        };

        ConnectComObject.prototype.comGetGradeWithInfo=function(param) {
            var name="comGetGradeWithInfo";
            if(this.isIE){
                try{
                    this.connCom.ComGetGradeWithInfo(param.obj, param.name, param.workerID, param.b64Photo, param.success);
                }catch(e){
                    this._onFail(name,param,e);
                }
            }else{
                var that=this;
                var b64= new $c.Base64();
                
                var objB64 = b64.encode(param.obj);
                var nameB64 = b64.encode(param.name);
                var workerIDB64 = b64.encode(param.workerID);

                this._webSocketSend('ComGetGradeWithInfoSyn','{"objB64":"'+ objB64 +'","nameB64":"' + nameB64 + '","workerIDB64":"' + workerIDB64 + '","b64Photo":"' + param.b64Photo + '"}',function (json) {
                    var gradeInfo = b64.decode(json.gradeInfoB64);
                    that._onSuccess(name,param,json.ret,gradeInfo);
                },function (e) {
                    that._onFail(name,param,e);
                });
            }
        };
        
        ConnectComObject.prototype.comTransmitData=function(param) {
            var name="comTransmitData";
            if(this.isIE){
                try{
                    this.connCom.ComTransmitData(param.inData, param.success);
                }catch(e){
                    this._onFail(name,param,e);
                }
            }else{
                this.connCom.ComTransmitData(param.inData, param.success);
            }
        };
        
        function Base64() {
            // private property
            _keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

            // public method for encoding
            this.encode = function (input) {
                var output = "";
                var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
                var i = 0;
                input = _utf8_encode(input);
                while (i < input.length) {
                    chr1 = input.charCodeAt(i++);
                    chr2 = input.charCodeAt(i++);
                    chr3 = input.charCodeAt(i++);
                    enc1 = chr1 >> 2;
                    enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
                    enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
                    enc4 = chr3 & 63;
                    if (isNaN(chr2)) {
                        enc3 = enc4 = 64;
                    } else if (isNaN(chr3)) {
                        enc4 = 64;
                    }
                    output = output +
                        _keyStr.charAt(enc1) + _keyStr.charAt(enc2) +
                        _keyStr.charAt(enc3) + _keyStr.charAt(enc4);
                }
                return output;
            };

            // public method for decoding
            this.decode = function (input) {
                var output = "";
                var chr1, chr2, chr3;
                var enc1, enc2, enc3, enc4;
                var i = 0;
                input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
                while (i < input.length) {
                    enc1 = _keyStr.indexOf(input.charAt(i++));
                    enc2 = _keyStr.indexOf(input.charAt(i++));
                    enc3 = _keyStr.indexOf(input.charAt(i++));
                    enc4 = _keyStr.indexOf(input.charAt(i++));
                    chr1 = (enc1 << 2) | (enc2 >> 4);
                    chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
                    chr3 = ((enc3 & 3) << 6) | enc4;
                    output = output + String.fromCharCode(chr1);
                    if (enc3 != 64) {
                        output = output + String.fromCharCode(chr2);
                    }
                    if (enc4 != 64) {
                        output = output + String.fromCharCode(chr3);
                    }
                }
                output = _utf8_decode(output);
                return output;
            };

            // private method for UTF-8 encoding
            _utf8_encode = function (string) {
                string = string.replace(/\r\n/g,"\n");
                var utftext = "";
                for (var n = 0; n < string.length; n++) {
                    var c = string.charCodeAt(n);
                    if (c < 128) {
                        utftext += String.fromCharCode(c);
                    } else if((c > 127) && (c < 2048)) {
                        utftext += String.fromCharCode((c >> 6) | 192);
                        utftext += String.fromCharCode((c & 63) | 128);
                    } else {
                        utftext += String.fromCharCode((c >> 12) | 224);
                        utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                        utftext += String.fromCharCode((c & 63) | 128);
                    }

                }
                return utftext;
            };

            // private method for UTF-8 decoding
            _utf8_decode = function (utftext) {
                var string = "";
                var i = 0;
                var c = c1 = c2 = 0;
                while ( i < utftext.length ) {
                    c = utftext.charCodeAt(i);
                    if (c < 128) {
                        string += String.fromCharCode(c);
                        i++;
                    } else if((c > 191) && (c < 224)) {
                        c2 = utftext.charCodeAt(i+1);
                        string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                        i += 2;
                    } else {
                        c2 = utftext.charCodeAt(i+1);
                        c3 = utftext.charCodeAt(i+2);
                        string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                        i += 3;
                    }
                }
                return string;
            };
        }

        $c.ConnectComObject=ConnectComObject;
        $c.Base64=Base64;
        $c.VersionInfo=VersionInfo;
    })(ConnectComClient);
}


//签字+指纹
function getSignFinger(){
    var inData = "{\"signType\":3,\"type\":1,\"MetaInfo\":{\"version\":1,\"id\": 1234556666777},\"AppInfo\":{\"title\": \"患者签名页面\",\"reason\": \"请您签字确认。\",\"info\": {\"type\":\"text\",\"content\":\"\"}},\"SignInfo\":{\"source\":\""+111111+"\"}}"
    mydll.comTransmitData({inData:inData,success:HeBCASignCallbackFunc});
}

// 停止签字
function stopSign(){
    //应该实现一个发了签名命令，然后医生这要停止重新发的功能
}

var HSign_DLG;
var initB64_1 = 'iVBORw0KGgoAAAANSUhEUgAAANIAAABuCAYAAABSkU1MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAAEnQAABJ0Ad5mH3gAAAFASURBVHhe7dMhAQAgEAAx+id7iaAPhODkxCJsnT0X+CMSBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIsG3uQ9K330ha9r2zQAAAABJRU5ErkJggg==';
//var initB64_2 = 'iVBORw0KGgoAAAANSUhEUgAAAKAAAADGCAYAAABVYotqAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAAEnQAABJ0Ad5mH3gAAAISSURBVHhe7dIhAcAwEMDAX/0LGxyYn5bUQ8gdiYE8//fugci6hYQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZDQzAFdxAT3GhjiSgAAAABJRU5ErkJggg==';
var evidence = {
    "Evidence": [{
            "Content": "",
            "ImageType": "png",
            "Type": "0"
        }, {
            "Content": "",
            "ImageType": "png",
            "Type": "1"
        }
    ],
    "Feature": ""
};

var handSignInterface = {
    openWindow : function () {
        SignBase64 = "";
        FingerBase64 = "";
        SignFingerBase64 = "";
        evidence.Evidence[0].Content = "";
        //evidence.Evidence[1].Content = "";
        $("#handscript").attr('src', 'data:image/png;base64, ' + initB64_1);
        evidence.Feature = "";
    },
    closeWindow : function () {
        SignBase64 = "";
        FingerBase64 = "";
        SignFingerBase64 = "";
        $("#fpFeature").val('');
        $("#handscript").attr('src', 'data:image/png;base64, ' + initB64_1);
        stopSign();
        if(document.getElementById("editor"))
            document.getElementById("editor").style.visibility="visible"; //隐藏插件
        HSign_DLG.dialog('close');
    },
    checkStatus : function () {
        return true;
    },
    getEvidenceData : function () {
        evidence.Evidence[0].Content = $("#handscript")[0].href.split(",")[1];
        evidence.Evidence[0].ImageType = "png";
        evidence.Evidence[0].Type = "0";
        //evidence.Evidence[1].Content = $("#fingerprint")[0].href.split(",")[1];
        //evidence.Evidence[1].ImageType = "jpg";
        //evidence.Evidence[1].Type = "1";
        evidence.Feature = $("#fpFeature").val();
        return evidence;
    },
    isGetSignAndFinger : function () {
        if ((evidence.Evidence[0].Content == ""))
        {
            alert("未获取到实际签名笔迹和指纹图。")
            return false;
        }
        return true;
    },
    getSignScript : function () {
        return evidence.Evidence[0].Content;
    },
    getSignPhoto : function () {
        return '';
    },
    getFingerprint : function (evidenceData) {
        return '';
    },
    getAlgorithm : function () {
        return '';
    },
    getVersion : function (signValue) {
        return '';
    },
    getBioFeature : function () {
        return '';
    },
    getTSValue : function (signValue) {
        return '';
    },
    getSignData : function (signValue) {
        return '';
    },
    getCert: function (signValue) {
        return '';
    },
    getErrorMessage : function (errCode) {
        var errInfo = "";
        switch (errCode) {
            case 0:
                errInfo = '操作正常';
                break;
            case 1:
                errInfo = '输入json为空';
                break;
            default:
                errInfo = "未知错误" + errCode;
                break;
        }
        return errInfo;
    },
    getSignedData: function (toSignValue,callback) {
        var inData = "{\"source\":\""+toSignValue+"\"}";
        mydll.comTransmitData({inData:inData,success:callback});
    }
};

// 编辑器
var isSigned  = false;
var parEditor = null;
function emrEditorIF() {
    try {
        // 获取图片
        var isGetSignAndFinger = handSignInterface.isGetSignAndFinger();
        if (!isGetSignAndFinger)
            return;

        var signLevel = 'Patient';
        var signUserId = 'Patient';
        var userName = 'Patient';
        var actionType = parEditor.actionType || 'Append';
        var description = '患者';
        var img = handSignInterface.getSignScript();
        var headerImage = handSignInterface.getSignPhoto();
        var fingerImage = handSignInterface.getFingerprint();
        // 获取编辑器hash
        var signInfo = parEditor.signDocument(parEditor.instanceId, 'Graph', signLevel, signUserId, userName, img, actionType, description, headerImage, fingerImage);
        if (signInfo.result == 'OK') {
            isSigned = true;
            
            
            var tmpCallBachFunc = function(ret, backData){
                debugger;
                var sealResult = "";
                if (ret == 1) {
                    //var obj = eval('(' + backData + ')');
                    //var sealResult = obj.SignInfo.sealResult;
                    sealResult = backData; ///obj.SignInfo.sealResult;
                } else {
                    alert("数据签名失败");
                }

                if ('' == sealResult){
                    parEditor.unSignedDocument();   
                    return; 
                }
                
                // 向后台保存
                var argsData = {
                    Action: 'SaveSignInfo',
                    InsID: parEditor.instanceId,
                    Algorithm: handSignInterface.getAlgorithm(),
                    BioFeature: handSignInterface.getBioFeature(),
                    EventCert: handSignInterface.getCert(),
                    SigValue: sealResult,
                    TSValue: handSignInterface.getTSValue(),
                    Version: handSignInterface.getVersion(),
                    SignScript: img,
                    HeaderImage: headerImage,
                    Fingerprint: fingerImage,
                    PlainText: signInfo.Digest,
                    SignData: backData
                };
                $.ajax({
                    type: 'POST',
                    dataType: 'text',
                    url: '../EMRservice.Ajax.anySign.cls',
                    async: false,
                    cache: false,
                    data: argsData,
                    success: function (ret) {
                        ret = JSON.parse(ret);
                        if (ret.Err || false) {
                            throw { message: 'SaveSignInfo 失败！' + ret.Err };
                        }
                        else {
                            if ('-1' == ret.Value) {
                                throw { message: 'SaveSignInfo 失败！' };
                            }
                            else {
                                var signId = ret.Value;
                                parEditor.saveSignedDocument(parEditor.instanceId, signUserId, signLevel, signId, signInfo.Digest, 'AnySign', signInfo.Path, actionType);
                                handSignInterface.closeWindow();
                            }
                        }
                    },
                    error: function (err) {
                        throw { message: 'SaveSignInfo error:' + err };
                    }
                });
            }
            debugger;
            handSignInterface.getSignedData(signInfo.Digest,tmpCallBachFunc);
        }
        else {
            throw { message: '签名失败' };
        }
    }
    catch (err) {
        if (isSigned) {
            parEditor.unSignedDocument();
        }
        alert(err.message);
    }
}

var handSign = (function(){    
    function showHandSignDlg() {
        if ($('#HSign_DLG').length === 0) {
            var dialogHtml = '<div id="HSign_DLG" class="hisui-dialog" title="数字签名" style="display:none;width:260px;height:320px">';
            dialogHtml += '<span id="hsCntr" style="display:inline-block;width:210px;height:200px;margin-left:20px;margin-top:20px">';
            dialogHtml += '<img id="handscript" src="data:image/png;base64, ' + initB64_1 + '"';
            dialogHtml += 'style="display:inline-block;width:210px;height:110px;/*background:lightpink;*/border:darkgray;border-style:dashed;margin-bottom:20px;"/>';
            dialogHtml += '<span id="capInfo" style="display:inline-block;height:20px;margin-bottom:10px;">患者签名采集中...</span>';
            dialogHtml += '</span>';
            dialogHtml += '</div>';
            $('body').append(dialogHtml);
            HSign_DLG = $('#HSign_DLG');
            HSign_DLG.show().dialog({
                isTopZindex: true,
                closable: true,
                modal: true
            });
            HSign_DLG.dialog('close');
        }       
        
        HSign_DLG.show().dialog({
            isTopZindex: true,
            closable: false,
            modal: true,
            buttons: [/*{
                    id: 'getHandSign',
                    text: '开始签名',
                    handler: function () {
                            getSignFinger();
                            $('#capInfo').text('患者签名采集中...');
                            return;
                    }
                },*/{
                    id: 'confirmSign',
                    text: '确定',
                    handler: function () {
                        $('#cancelSign').linkbutton('disable');
                        emrEditorIF();
                        //onCancel();
                    }
                }, {
                    id : 'cancelSign',
                    text: '结束',
                    handler: function () {
                        $('#confirmSign').linkbutton('disable');
                        handSignInterface.closeWindow();
                    }
                }
            ]
        });

        
        
        handSignInterface.openWindow();
        //调用CA接口，传入固定值获取签名图
        getSignFinger();
        $('#capInfo').text('患者签名采集中...');
        $('#cancelSign').linkbutton('disable');
        $('#confirmSign').linkbutton('disable');
        //$('#capInfo').text('点击【开始签名】按钮开始采集患者签名');
    }

    return {
        sign: function(ParEditor) {
            try {
                initHebCAComClient();
                mydll = new ConnectComClient.ConnectComObject({ debug: false, errorStyle: '', fail: function (e) {debugger;} });
            } catch(e) {
               alert(e.message);
               return;
            }
            parEditor = ParEditor;
            showHandSignDlg();
        }
    }
})();
