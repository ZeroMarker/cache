var ca_key = (function() {
    var bjca_method = {};
    
    //常量定义
    var Const_Vender_Code = "BJCA";
    var Const_Sign_Type = "UKEY";
    var Global_Last_Login_CertInfo = "";
    var Global_Last_Login_SealInfo = "";
    var Global_Last_Login_Token = "";
    var Global_Last_Error_Code = "";
    var Global_Last_Error_Msg = "";
    
    // 日期类型格式化方法的定义
    Date.prototype.Format = function(fmt) { 
        //author: meizz 
        var o = { 
            "M+" : this.getMonth()+1,                 //月份 
            "d+" : this.getDate(),                    //日 
            "h+" : this.getHours(),                   //小时 
            "m+" : this.getMinutes(),                 //分 
            "s+" : this.getSeconds(),                 //秒 
            "q+" : Math.floor((this.getMonth()+3)/3), //季度 
            "S" : this.getMilliseconds()             //毫秒 
        }; 
        if(/(y+)/.test(fmt)) {
            fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
        }
        for(var k in o) {
            if(new RegExp("("+ k +")").test(fmt)) {
                fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length))); 
            }
        }
        return fmt; 
    }
    
    ///////////CA常量//////////////
    // 证书和密钥类型标识
    var KEY_SIGNOREXCHANGE = 0; // 签名或加密 先获取签名 不成功再获取加密
    var KEY_SIGNATURE = 1; // 签名位置
    var KEY_KEYEXCHANGE = 2; // 加密位置

    // 获取的证书信息类型
    var CERT_VERSION = 1; // 证书版本 返回V1 V2 V3
    var CERT_SERIAL = 2; // 证书序列号
    var CERT_SIGN_METHOD = 3; // 获取证书类型 返回 rsa或sm2
    var CERT_ISSUER_C = 4; // 证书发放者国家名 多个之间用&&&隔开
    var CERT_ISSUER_O = 5; // 证书发放者组织名
    var CERT_ISSUER_OU = 6; // 证书发放者部门名
    var CERT_ISSUER_ST = 7; // 证书发放者省州名
    var CERT_ISSUER_CN = 8; // 证书发放者通用名
    var CERT_ISSUER_L = 9; // 证书发放者城市名
    var CERT_ISSUER_E = 10; // 证书发放者EMAIL地址
    var CERT_NOT_BEFORE = 11; // 证书有效期起始 格式YYYYMMDDHHMMSS
    var CERT_NOT_AFTER = 12; // 证书有效期截止 格式YYYYMMDDHHMMSS
    var CERT_SUBJECT_C = 13; // 用户国家名
    var CERT_SUBJECT_O = 14; // 用户组织名
    var CERT_SUBJECT_OU = 15; // 用户部门名
    var CERT_SUBJECT_ST = 16; // 用户省州名
    var CERT_SUBJECT_CN = 17; // 用户通用名
    var CERT_SUBJECT_L = 18; // 用户城市名
    var CERT_SUBJECT_E = 19; // 用户EMAIL地址
    var CERT_PUBKEY = 20; // 证书公钥
    var CERT_SUBJECT_DN = 33; // 用户DN
    var CERT_ISSUER_DN = 34; // 颁发者DN
    var CERT_UNIQUEID = 35; // 唯一实体ID    

    var CERT_TYPE_HARD = 1;
    var CERT_TYPE_SOFT = 2;
    var CERT_TYPE_ALL  = 3;
    
    //初始化控件变量
    (function() {
        if (typeof xtxsync === 'undefined') {
            xtxsync = {};
        }
    })();

    // initialize xtxsync hashMap object
    (function() {
        function xtxsyncHashMap(){
            this.map = {};
        }

        xtxsyncHashMap.prototype = {
            put : function(key , value){
                this.map[key] = value;
            },
            get : function(key){
                if(this.map.hasOwnProperty(key)){
                    return this.map[key];
                }
                return null;
            },
            remove : function(key){
                if(this.map.hasOwnProperty(key)){
                    return delete this.map[key];
                }
                return false;
            },
            removeAll : function(){
                this.map = {};
            }, 
            keySet : function(){
                var _keys = [];
                for(var i in this.map){
                    _keys.push(i);
                }
                return _keys;
            }
        };
        xtxsyncHashMap.prototype.constructor = xtxsyncHashMap;
        xtxsync.HashMap = xtxsyncHashMap;
    })();

    // initialize xtxsync util object
    (function() {
        function initUtilObject(xtxsync) {
            var util = xtxsync.util = xtxsync.util || {};
            util.checkBrowserISIE = function() {
                return (!!window.ActiveXObject || 'ActiveXObject' in window) ? true : false;
            }
            util.checkLocationIsHttps = function() {
                return 'https:' == document.location.protocol ? true: false;
            }
            util.evalFunction = function (func) {
                if (typeof func === 'function') {
                    return func;
                } else if (typeof func === 'string') {
                    cb = eval(func);
                } else {
                    return null;
                }
            }
            util.consolelog = function(param) {
                if (window.console == undefined || window.console.log == undefined) {
                    return;
                }
                //console.log(param);
            }
            util.isEmpty = function(param) {
                if (!param) {
                    return true;
                }
                if (typeof param == 'string' && param == "") {
                    return true;
                }
                
                return false;
            }
            util.loadIECtl = function(clsid, ctlName, checkFunc) {
                if (!util.checkBrowserISIE()) {
                    return null;
                }
                var ctl = document.getElementById(ctlName);
                if (ctl) {
                    return ctl;
                }
                try {
                    var loadObjString = '<object id="' + ctlName + '" classid="CLSID:' + clsid + '" style="HEIGHT:0px; WIDTH:0px">';
                    loadObjString += '</object>';
                    document.write(loadObjString);
                    if (checkFunc != null && checkFunc != "" && eval(ctlName + "." + checkFunc) == undefined) {
                        return null; 
                    }
                } catch (e) {
                    alert(e);
                    return null;
                }
                return document.getElementById(ctlName);
            }
            util.getAutoExecFunctionString = function (func) {
                var ret = "(";
                ret += func.toString();
                ret += ")()";
                
                return ret;
            }
            util.attachIEEvent = function(ctlName, eventName, eventFunc) {
                var ctl;
                if (typeof ctlName === 'string') {
                    ctl = eval(ctlName);
                } else {
                    ctl = ctlName;
                }
                eventName = eventName.toLowerCase();
                var cb = util.evalFunction(eventFunc);
                if (cb == null) {
                    return;
                }

                if (ctl.attachEvent) {
                    ctl.attachEvent(eventName, cb);
                } else { // IE11 not support attachEvent, and addEventListener do not work well, so addEvent ourself
                    var handler = document.createElement("script");
                    handler.setAttribute("for", ctlName);
                    handler.setAttribute("event", eventName);
                    var eventScript = util.getAutoExecFunctionString(eventFunc);
                    handler.appendChild(document.createTextNode(eventScript));
                    document.getElementsByTagName("head")[0].appendChild(handler);
                }
            }

            util.loadWebSocketCtl = function(wsUrl, wssUrl) {
                if (xtxsync.wsObject) {
                    return xtxsync.wsObject;
                }
                var url;
                if (util.checkLocationIsHttps()) {
                    url = "wss://" + wssUrl;
                } else {
                    url = "ws://" + wsUrl;
                }
                var wsObject = {
                    socket            : undefined,
                    wsEventQueue      : new xtxsync.HashMap(),
                    wsURL             : url
                };
                xtxsync.wsObject = wsObject;
                xtxsync.wsObject.wsEventQueue.put("onusbkeychange", util.evalFunction(xtxsync.custom.defaultUsbkeyChange));
                try {
                    wsObject.socket = new WebSocket(url); 
                } catch (e) {
                    alert(e);
                    return null;
                }
                wsObject.socket.onopen = function(evt) {
                    //xtxsync.util.consolelog("open websocket[" + url + "] ok...");
                    //xtxsync.util.consolelog("SOF_GetVersion:(" + xtxsync.SOF_GetVersion() + ")");
                }
                wsObject.socket.onclose = function(evt) {
                    //util.consolelog("websocket[" + url + "] closed, reopen it...");
                    xtxsync.wsObject = undefined;
                    xtxsync.XTXAppWebSocket = xtxsync.util.loadWebSocketCtl(wsUrl, wssUrl);
                };
                wsObject.socket.onmessage = function(evt) {
                    var eventCmd = false;
                    if (xtxsync.util.isEmpty(evt.data)) {
                        alert("onmessage evt.data is NULL or empty!!!");
                        return;
                    }
                    try {
                        var res = JSON.parse(evt.data);
                        var cmdId = undefined;
                        if (res['call_cmd_id']) {
                            cmdId = res['call_cmd_id'];
                        } else {
                            alert("return JSON not include call_cmd_id!!!");
                            return;
                        }
                        var retVal = "";
                        if (res['retVal']) {
                            retVal = res['retVal'];
                        } else if (res['retValue']) {
                            retVal = res['retValue'];
                        }
                        
                        var execFunc = xtxsync.wsObject.wsEventQueue.get(cmdId.toLowerCase());
                        if (execFunc && typeof execFunc == 'function') { // event
                            execFunc(retVal);
                        }
                    } catch (e) {
                        return;
                    }
                };
                wsObject.socket.onerror = function(evt) { 
                    //alert(evt.data);
                };
                return wsObject;
            }
            util.attachWebSocketEvent = function(wsObject, eventName, eventFunc) {
                if (wsObject == null) {
                    return;
                }
                wsObject.wsEventQueue.put(eventName.toLowerCase(), util.evalFunction(eventFunc));
            }
            util.createHttpRequest = function() {
                if (window.XMLHttpRequest) {
                   return new XMLHttpRequest();
                } else {
                   return new ActiveXObject("Microsoft.XMLHTTP");
                }
            }
            util.ajaxSyncall = function(clsid, methodName, outPramType, argsArray) {
                var defaultErrRet;
                if (outPramType == 'bool') {
                    defaultErrRet = false;
                } else if (outPramType == 'number') {
                    defaultErrRet = -1;
                } else {
                    defaultErrRet = "";
                }
                try {
                    var xhr = xtxsync.util.createHttpRequest();
                    var strUrl = "http://127.0.0.1:21051/synctl";
                    if (util.checkLocationIsHttps()) {
                        strUrl = "https://127.0.0.1:21061/synctl";
                    }
                    xhr.open("POST", strUrl, false);
                    xhr.setRequestHeader("Content-type","application/json");
                    var sendArray = {
                        url:window.location.href, 
                        clsid:clsid, 
                        func:methodName,
                        param:argsArray
                    };
                    var token = xtxsync.custom.getToken();
                    if (token != "") {
                        sendArray.token = token;
                    }
                    xhr.send(JSON.stringify(sendArray));
                    if (xhr.status != 200) {
                        if (methodName == 'SOF_Login' || methodName == 'SOF_LoginEx') {
                            xtxsync.custom.setToken("");
                        }
                        return defaultErrRet;
                    }
                    var res = JSON.parse(xhr.responseText);
                    if (res.token) {
                        xtxsync.custom.setToken(res.token);
                    }
                    var ret = defaultErrRet;
                    if (res.hasOwnProperty('retValue')) {
                        ret = res.retValue;
                    } else if (res.hasOwnProperty('retVal')) {
                        if (outPramType == "bool"){
                            if (typeof(res.retVal) == 'string') {
                                ret = res.retVal == "true" ? true : false;
                            } else {
                                ret = res.retVal;
                            }
                        } else if (outPramType == "number"){
                            if (typeof(res.retVal) == 'string') {
                                ret = Number(res.retVal);
                            } else {
                                ret = res.retVal;
                            }
                        } else{
                            ret = res.retVal;
                        }
                    }
                    if (ret == undefined) {
                        ret = defaultErrRet;
                    }
                    if (((methodName == 'SOF_Login' || methodName == 'SOF_LoginEx') && !ret) || (methodName == 'SOF_Logout' && ret)) {
                        xtxsync.custom.setToken("");
                    }
                    return ret;
                } catch (e) {
                    return defaultErrRet;
                }
            }
        }
        return initUtilObject(xtxsync);
    })();

    // initialize index page and other custom action
    (function() {
        function initCustomActions(xtxsync) {
            var custom = xtxsync.custom = xtxsync.custom || {};
            custom.softCertListID = "";
            custom.hardCertListID = "";
            custom.allCertListID = "";
            custom.loginCertID = "";
            custom.logoutFunc = null;
            custom.UsbkeyChangeFunc = null;
            custom.loginToken = "";
            custom.errorReportFunc = function(msg) {
                alert(msg);
            }
            custom.setAutoLogoutParameter = function(strCertID, logoutFunc) {
                var custom = xtxsync.custom;
                custom.loginCertID = strCertID;
                custom.logoutFunc = logoutFunc;
            }
            custom.clearDropList = function(dropListId) {
                if (dropListId == "") {
                    return;
                }
                var obj = document.getElementById(dropListId);
                if (obj == undefined) {
                    obj = eval(dropListId);
                } 
                if (obj == undefined) {
                    return;
                }
                var i, n = obj.length;
                for (i = 0; i < n; i++) {
                    obj.remove(0);
                }
            }
            custom.pushOneDropListBox = function(userListArray, strListID) 
            {
                var obj = document.getElementById(strListID);
                if (obj == undefined) {
                    obj = eval(strListID);
                } 
                if (obj == undefined) {
                    return;
                }
                for (var i = 0; i < userListArray.length; i++) {
                    var certObj = userListArray[i];
                    var objItem = new Option(certObj.certName, certObj.certID);
                    obj.options.add(objItem);
                }
                return;
            }
            custom.pushUserListToAllDroplist = function(strUserList) {
                var custom = xtxsync.custom;
                custom.clearDropList(custom.softCertListID);
                custom.clearDropList(custom.hardCertListID);
                custom.clearDropList(custom.allCertListID);
                var allListArray = [];
                while (true) {
                    var i = strUserList.indexOf("&&&");
                    if (i <= 0 ) {
                        break;
                    }
                    var strOneUser = strUserList.substring(0, i);
                    var strName = strOneUser.substring(0, strOneUser.indexOf("||"));
                    var strCertID = strOneUser.substring(strOneUser.indexOf("||") + 2, strOneUser.length);
                    allListArray.push({certName:strName, certID:strCertID});
                    
                    if (custom.hardCertListID != "") {
                        var devType = xtxsync.GetDeviceInfo(strCertID, 7);
                        if (devType == "HARD") {
                            custom.pushOneDropListBox([{certName:strName, certID:strCertID}], custom.hardCertListID);
                        }
                    }
                    if (custom.softCertListID != "") {
                        var devType = xtxsync.GetDeviceInfo(strCertID, 7);
                        if (devType == "SOFT") {
                            custom.pushOneDropListBox([{certName:strName, certID:strCertID}], custom.softCertListID);
                        }
                    }
                    var len = strUserList.length;
                    strUserList = strUserList.substring(i + 3, len);
                }
                if (custom.allCertListID != "") {
                    custom.pushOneDropListBox(allListArray, custom.allCertListID);
                }
            }
            custom.setUserCertList = function(certListId, certType) {
                var custom = xtxsync.custom;
                if (certType == CERT_TYPE_ALL || certType == undefined) {
                    custom.allCertListID = certListId;
                }
                if (certType == CERT_TYPE_HARD) {
                    custom.hardCertListID = certListId;
                }
                if (certType == CERT_TYPE_SOFT) {
                    custom.softCertListID = certListId;
                }
                custom.pushUserListToAllDroplist(xtxsync.SOF_GetUserList());
            }
            custom.setOnUsbKeyChangeCallBack = function(callback) {
                xtxsync.custom.UsbkeyChangeFunc = callback;
            }
            custom.setErrorReportFunc = function(errFunc) {
                xtxsync.custom.errorReportFunc = errFunc;
            }
            custom.autoLogoutCallBack = function(strUserList) {
                var custom = xtxsync.custom;
                if (strUserList.indexOf(custom.loginCertID) <= 0) {
                    custom.logoutFunc();
                }
            }
            custom.defaultUsbkeyChange = function() {
                var custom = xtxsync.custom;
                custom.pushUserListToAllDroplist(xtxsync.SOF_GetUserList());
                if (typeof custom.UsbkeyChangeFunc == 'function') {
                    custom.UsbkeyChangeFunc();
                }
                if (custom.loginCertID != "" && typeof custom.logoutFunc == 'function') {
                    custom.autoLogoutCallBack(xtxsync.SOF_GetUserList());
                }
            }
            custom.getToken = function() {
                return custom.loginToken;
            }
            custom.setToken = function(token) {
                custom.loginToken = token;
            }
        }
        return initCustomActions(xtxsync);
    })();

    // initialize xtxappcom object
    (function() {
        function initXTXAppCOM(xtxsync) {
            var util = xtxsync.util;
            var custom = xtxsync.custom;  
            xtxsync.XTXAppCOM = util.loadIECtl(xtxsync.xtx_clsid, "XTXAppObj", "SOF_GetVersion()");
            if (xtxsync.XTXAppCOM == null) {
                alert("加载XTXAppCOM控件失败，请确认已正确安装BJCA证书应用环境!");
                return false;
            }
            var XTXAppCOM = xtxsync.XTXAppCOM;
            util.attachIEEvent("XTXAppObj", "onUsbkeyChange", xtxsync.custom.defaultUsbkeyChange);
            // get key pic interface
  
            // xtxversion interface
            var XTXVersionOBJ = util.loadIECtl(xtxsync.xtx_version_clsid, "XTXVersionOBJ", "GetEnvVersion()");
            if (XTXVersionOBJ == null) {
                alert("加载XTXVersion控件失败，请确认已正确安装证书应用环境!");
            } else {
                XTXAppCOM.GetEnvVersion = function() {
                    return XTXVersionOBJ.GetEnvVersion();
                }
            }   
            return true;
        }

        function initXTXAppWebSocket(xtxsync) {
            xtxsync.XTXAppWebSocket = xtxsync.util.loadWebSocketCtl("127.0.0.1:21051/xtxapp/", "127.0.0.1:21061/xtxapp/");
            if (xtxsync.XTXAppWebSocket == null) {
                alert("连接XTXAppCOM服务失败，请确认已正确安装BJCA证书应用环境!");
                return false;
            }
            return true;
        }

        //设置clsid
        function initXTXAppObject(xtxsync) {
            var util = xtxsync.util;
            xtxsync.xtx_clsid = "3F367B74-92D9-4C5E-AB93-234F8A91D5E6";
            xtxsync.getpic_clsid = "3BC3C868-95B5-47ED-8686-E0E3E94EF366";
            xtxsync.xtx_version_clsid = "574887FB-22A5-488B-A49C-2CF25F56BE68";
            var getImplmentFunction;
            if (util.checkBrowserISIE()) { // IE
                if (!initXTXAppCOM(xtxsync)) {
                    return false;
                }
                getImplmentFunction = function(methodInfo) {
                    if (methodInfo.inParams == '') { // 0 input param
                        bjca_method[methodInfo.funcName] = new Function('return xtxsync.XTXAppCOM.' + methodInfo.funcName + '();');
                    } else {
                        bjca_method[methodInfo.funcName] = new Function(methodInfo.inParams,
                            'return xtxsync.XTXAppCOM.' + methodInfo.funcName + '(' + methodInfo.inParams + ');');
                    }
                }
            } else { // other brower
                if (!initXTXAppWebSocket(xtxsync)) {
                    return false;
                }
                getImplmentFunction = function(methodInfo) {
                    if (methodInfo.inParams == '') { // 0 input param
                        bjca_method[methodInfo.funcName] = new Function(
                        "return xtxsync.util.ajaxSyncall('" + 
                        methodInfo.clsid + "', '" + methodInfo.funcName + "', '" + methodInfo.outParamType + "');");
                    } else {
                        bjca_method[methodInfo.funcName] = new Function(methodInfo.inParams,
                            "return xtxsync.util.ajaxSyncall('" + methodInfo.clsid + "', '" + 
                            methodInfo.funcName + "','" + methodInfo.outParamType + "', [" + methodInfo.inParams + "]);");
                    }
                }
            }

            var export_functions = [
                {funcName:'SOF_SetSignMethod', inParams:'SignMethod', outParamType:'number', clsid:xtxsync.xtx_clsid, aliasName:'SetSignMethod'},
                {funcName:'SOF_GetSignMethod', inParams:'', outParamType:'number', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_SetEncryptMethod', inParams:'EncryptMethod', outParamType:'number', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_GetEncryptMethod', inParams:'', outParamType:'number', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_GetUserList', inParams:'', outParamType:'string', clsid:xtxsync.xtx_clsid, aliasName:'GetUserList'},
                {funcName:'SOF_ExportUserCert', inParams:'CertID', outParamType:'string', clsid:xtxsync.xtx_clsid, aliasName:'GetSignCert'},
                {funcName:'SOF_Login', inParams:'CertID, PassWd', outParamType:'bool', clsid:xtxsync.xtx_clsid, aliasName:'VerifyUserPIN'},
                {funcName:'SOF_GetPinRetryCount', inParams:'CertID', outParamType:'number', clsid:xtxsync.xtx_clsid, aliasName:'GetUserPINRetryCount'},
                {funcName:'SOF_ChangePassWd', inParams:'CertID, oldPass, newPass', outParamType:'bool', clsid:xtxsync.xtx_clsid, aliasName:'ChangeUserPassword'},
                {funcName:'SOF_GetCertInfo', inParams:'Cert, type', outParamType:'string', clsid:xtxsync.xtx_clsid, aliasName:'GetCertBasicinfo'},
                {funcName:'SOF_GetCertInfoByOid', inParams:'Cert, Oid', outParamType:'string', clsid:xtxsync.xtx_clsid, aliasName:'GetExtCertInfoByOID'},
                {funcName:'SOF_SignData', inParams:'CertID, InData', outParamType:'string', clsid:xtxsync.xtx_clsid, aliasName:'SOF_SignData'},
                {funcName:'SOF_VerifySignedData', inParams:'Cert, InData, SignValue', outParamType:'bool', clsid:xtxsync.xtx_clsid, aliasName:'VerifySignedData'},
                {funcName:'SOF_SignFile', inParams:'CertID, InFile', outParamType:'string', clsid:xtxsync.xtx_clsid, aliasName:'SOF_SignFile'},
                {funcName:'SOF_VerifySignedFile', inParams:'Cert, InFile, SignValue', outParamType:'bool', clsid:xtxsync.xtx_clsid, aliasName:'VerifySignFile'},
                {funcName:'SOF_EncryptData', inParams:'Cert, InData', outParamType:'string', clsid:xtxsync.xtx_clsid, aliasName:'EncodeP7Enveloped'},
                {funcName:'SOF_DecryptData', inParams:'CertID, InData', outParamType:'string', clsid:xtxsync.xtx_clsid, aliasName:'DecodeP7Enveloped'},
                {funcName:'SOF_EncryptFile', inParams:'Cert, InFile, OutFile', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_DecryptFile', inParams:'CertID, InFile, OutFile', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_SignMessage', inParams:'dwFlag, CertID, InData', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_VerifySignedMessage', inParams:'MessageData, InData', outParamType:'bool', clsid:xtxsync.xtx_clsid, aliasName:'VerifyDatabyP7'},
                {funcName:'SOF_GetInfoFromSignedMessage', inParams:'SignedMessage, type', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_SignDataXML', inParams:'CertID, InData', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_VerifySignedDataXML', inParams:'InData', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_GetXMLSignatureInfo', inParams:'XMLSignedData, type', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_GenRandom', inParams:'RandomLen', outParamType:'string', clsid:xtxsync.xtx_clsid, aliasName:'GenerateRandom'},
                {funcName:'SOF_PubKeyEncrypt', inParams:'Cert, InData', outParamType:'string', clsid:xtxsync.xtx_clsid, aliasName:'PubKeyEncrypt'},
                {funcName:'SOF_PriKeyDecrypt', inParams:'CertID, InData', outParamType:'string', clsid:xtxsync.xtx_clsid, aliasName:'PriKeyDecrypt'},
                {funcName:'SOF_SecertSegment', inParams:'Secert, m, n, k', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_SecertRecovery', inParams:'Seg', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_GetLastError', inParams:'', outParamType:'number', clsid:xtxsync.xtx_clsid},
                {funcName:'GetDeviceCount', inParams:'', outParamType:'number', clsid:xtxsync.xtx_clsid},
                {funcName:'GetAllDeviceSN', inParams:'', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'GetDeviceSNByIndex', inParams:'iIndex', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'GetDeviceInfo', inParams:'sDeviceSN, iType', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'ChangeAdminPass', inParams:'sDeviceSN, sOldPass, sNewPass', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'UnlockUserPass', inParams:'sDeviceSN, sAdminPass, sNewUserPass', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'GenerateKeyPair', inParams:'sDeviceSN, sContainerName, iKeyType, bSign', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'ExportPubKey', inParams:'sDeviceSN, sContainerName, bSign', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'ImportSignCert', inParams:'sDeviceSN, sContainerName, sCert', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'ImportEncCert', inParams:'sDeviceSN, sContainerName, sCert, sPriKeyCipher', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'ReadFile', inParams:'sDeviceSN, sFileName', outParamType:'string', clsid:xtxsync.xtx_clsid, aliasName:'readFile'},
                {funcName:'WriteFile', inParams:'sDeviceSN, sFileName, sContent, bPrivate', outParamType:'bool', clsid:xtxsync.xtx_clsid, aliasName:'writeFile'},
                {funcName:'IsContainerExist', inParams:'sDeviceSN, sContainerName', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'DeleteContainer', inParams:'sDeviceSN, sContainerName', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'ExportPKCS10', inParams:'sDeviceSN, sContainerName, sDN, bSign', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'InitDevice', inParams:'sDeviceSN, sAdminPass', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'AddSignInfo', inParams:'sUserPass', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_GetVersion', inParams:'', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_ExportExChangeUserCert', inParams:'CertID', outParamType:'string', clsid:xtxsync.xtx_clsid, aliasName:'GetExchCert'},
                {funcName:'SOF_ValidateCert', inParams:'Cert', outParamType:'number', clsid:xtxsync.xtx_clsid, aliasName:'ValidateCert'},
                {funcName:'GetENVSN', inParams:'sDeviceSN', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SetENVSN', inParams:'sDeviceSN, sEnvsn', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'IsDeviceExist', inParams:'sDeviceSN', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'GetContainerCount', inParams:'sDeviceSN', outParamType:'number', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_SymEncryptData', inParams:'sKey, indata', outParamType:'string', clsid:xtxsync.xtx_clsid, aliasName:'EncryptData'},
                {funcName:'SOF_SymDecryptData', inParams:'sKey, indata', outParamType:'string', clsid:xtxsync.xtx_clsid, aliasName:'DecryptData'},
                {funcName:'SOF_SymEncryptFile', inParams:'sKey, inFile, outFile', outParamType:'bool', clsid:xtxsync.xtx_clsid, aliasName:'EncryptFile'},
                {funcName:'SOF_SymDecryptFile', inParams:'sKey, inFile, outFile', outParamType:'bool', clsid:xtxsync.xtx_clsid, aliasName:'DecryptFile'},
                {funcName:'SOF_GetLastErrMsg', inParams:'', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_Base64Encode', inParams:'sIndata', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_Base64Decode', inParams:'sIndata', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_HashData', inParams:'hashAlg, sInData', outParamType:'string', clsid:xtxsync.xtx_clsid,aliasName:'SOF_HashData'},
                {funcName:'SOF_HashFile', inParams:'hashAlg, inFile', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'UnlockUserPassEx', inParams:'sDeviceSN, sAdminPin, sNewUserPass', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'DeleteOldContainer', inParams:'sDeviceSN', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'WriteFileEx', inParams:'sDeviceSN, sFileName, sContent', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'ReadFileEx', inParams:'sDeviceSN, sFileName', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'WriteFileBase64', inParams:'sDeviceSN, sFileName, sContent', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'DeleteFile', inParams:'sDeviceSN, sFileName', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_EncryptDataEx', inParams:'Cert, InData', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'Base64EncodeFile', inParams:'sInFile', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_GetRetryCount', inParams:'CertID', outParamType:'number', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_GetAllContainerName', inParams:'sDeviceSN', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'CreateSoftDevice', inParams:'sDeviceSN, sLabel', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'DeleteSoftDevice', inParams:'sDeviceSN, sPasswd', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'EnableSoftDevice', inParams:'enable, sDeviceSN', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SoftDeviceBackup', inParams:'sDeviceSN, sPasswd', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SoftDeviceRestore', inParams:'sDeviceSN, sPasswd, sInFilePath', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_Logout', inParams:'CertID', outParamType:'bool', clsid:xtxsync.xtx_clsid, aliasName:'Logout'},
                {funcName:'SetUserConfig', inParams:'type, strConfig', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_SignByteData', inParams:'CertID, byteLen', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_VerifySignedByteData', inParams:'Cert, byteLen, SignValue', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'OTP_GetChallengeCode', inParams:'sCertID', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'ImportEncCertEx', inParams:'sDeviceSN, sContainerName, sCert, sPriKeyCipher, ulSymAlg', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_GetCertEntity', inParams:'sCert', outParamType:'string', clsid:xtxsync.xtx_clsid, aliasName:'GetCertEntity'},
                {funcName:'SOF_HMAC', inParams:'hashid, key, indata', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_SignDataByPriKey', inParams:'sPriKey, sCert, sInData', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'ImportKeyCertToSoftDevice', inParams:'sDeviceSN, sContainerName, sPriKey, sCert, bSign', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'InitDeviceEx', inParams:'sDeviceSN, sAdminPass, sUserPin, sKeyLabel, adminPinMaxRetry, userPinMaxRetry', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SelectFile', inParams:'', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_SignHashData', inParams:'CertID, b64ashData, hashAlg', outParamType:'string', clsid:xtxsync.xtx_clsid, aliasName:'SignHashData'},
                {funcName:'SOF_VerifySignedHashData', inParams:'Cert, b64ashData, SignValue, hashAlg', outParamType:'bool', clsid:xtxsync.xtx_clsid, aliasName:'VerifySignedHashData'},
                {funcName:'CheckSoftDeviceEnv', inParams:'', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'ImportPfxToDevice', inParams:'sDeviceSN, sContainerName, bSign, strPfx, strPfxPass', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_HashDataEx', inParams:'hashAlg, sInData, sCert, sID', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_HashFileEx', inParams:'hashAlg, inFile, sCert, sID', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'GetDeviceCountEx', inParams:'type', outParamType:'number', clsid:xtxsync.xtx_clsid},
                {funcName:'GetAllDeviceSNEx', inParams:'type', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_UpdateCert', inParams:'CertID, type', outParamType:'number', clsid:xtxsync.xtx_clsid},
                {funcName:'OpenSpecifiedFolder', inParams:'backupFilePath', outParamType:'', clsid:xtxsync.xtx_clsid},
                {funcName:'OTP_GetChallengeCodeEx', inParams:'sCertID, szAccount, money', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'Base64DecodeFile', inParams:'sInData, sFilePath', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'EnumFilesInDevice', inParams:'sDeviceSN', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'OTP_Halt', inParams:'sCertID', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_TSGenREQ', inParams:'b64Hash, hashAlg, bReqCert, policyID, b64Nonce, b64Extension', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_TSCompareNonce', inParams:'b64TSReq, b64TSAResp', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_TSGenPDFSignature', inParams:'b64TSAResp, b64OriPDFSignature', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_TSVerifyPDFSignature', inParams:'b64TSPDFSignature', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_TSGetPDFSignatureInfo', inParams:'b64TSPDFSignature, iType', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'OTP_GetState', inParams:'sCertID, bCert', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'OTP_GetSyncCode', inParams:'sCertID, ChallengeCode', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_IsLogin', inParams:'CertID', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_LoginEx', inParams:'CertID, PassWd, updateFlag', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'EnumSupportDeviceList', inParams:'', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'ExportPfxFromDevice', inParams:'sDeviceSN, sContainerName, bSign, strPfxPass', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_SignHashMessage', inParams:'CertID, InHashData, hashAlg', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'ExportPfxToFile', inParams:'sDeviceSN, sContainerName, bSign, strPfxPass', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_SignAPK', inParams:'CertID, strOriSignature', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'YZT_GenerateKeyPair', inParams:'sDeviceSN, sContainerName, iKeyTypeRSA, iKeyTypeSM2', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'YZT_ExportPubKey', inParams:'sDeviceSN, sContainerName, bSign', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'YZT_ImportSignCert', inParams:'sDeviceSN, sContainerName, sRSACert, sSM2Cert', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'YZT_ImportEncCert', inParams:'sDeviceSN, sContainerName, sRSACert, sRSAPriKeyCipher, ulRSASymAlg, sSM2Cert, sSM2PriKeyCipher, ulSM2SymAlg', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_ListenUKey', inParams:'Parm', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_EnableLoginWindow', inParams:'Parm', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_SignEnvelope', inParams:'CertID, Cert, InData', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_UnSignEnvelope', inParams:'CertID, InData', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'BIO_MAKExportPKCS10', inParams:'sDeviceSN, iKeyType, sDN', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'BIO_MAKImportSignEncCert', inParams:'sDeviceSN, sSignCert, sEncCert, sPriKeyCipher', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'BIO_IssueDAKCert', inParams:'sDeviceSN, iKeyType, sDN', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'BIO_InfoCollect', inParams:'', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'BIO_GetBioInfo', inParams:'sDeviceSN', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_GetLastLoginCertID', inParams:'', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_ReadESealData', inParams:'CertID, ulKeyIndex, ulKeyAlgId, ulFlags', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_ReadKFXESealData', inParams:'CertID, ulKeyIndex, ulKeyAlgId, ulFlags', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_SymDecryptFileToData', inParams:'sKey, inFile', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_SignMessageBase64', inParams:'dwFlag, CertID, InData', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_VerifySignedMessageBase64', inParams:'MessageData, InData', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_VerifySignedHashMessage', inParams:'MessageData, InHashData', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_SignDataBase64', inParams:'CertID, InData', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_VerifySignedDataBase64', inParams:'Cert, InData, SignValue', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_HashDataExBase64', inParams:'hashAlg, sInData, sCert, sID', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_GetProductVersion', inParams:'', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_UpdateCertEx', inParams:'CertID, PassWd', outParamType:'number', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_GetLastSignDataCertID', inParams:'CertID', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'BIO_SetUserConfig', inParams:'CertID, type, strConfig', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'BIO_InvokeCommand', inParams:'CertID, bstrCommand', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_ImportSymmKey', inParams:'CertID, ulKeyIndex, InData, ulFlags', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_WriteESealData', inParams:'CertID, InData, ulFlags', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_EPS_Encrypt', inParams:'CertID, ulKeyIndex, ulKeyAlgId, IVData, DivCount, DivComponent, InData, ulFlags', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_EPS_Decrypt', inParams:'CertID, ulKeyIndex, ulKeyAlgId, IVData, DivCount, DivComponent, InData, ulFlags', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_EPS_Mac', inParams:'CertID, ulKeyIndex, ulKeyAlgId, IVData, DivCount, DivComponent, InData, ulFlags', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_PriKeyDecryptEx', inParams:'CertID, InData', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_EPS_ReadESealData', inParams:'CertID, ulKeyIndex, ulKeyAlgId, ulFlags', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_EPS_WriteESealData', inParams:'CertID, InData, ulFlags', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'EnumESeal', inParams:'sDeviceSN', outParamType:'string', clsid:xtxsync.xtx_clsid},
                {funcName:'GetPicture', inParams:'bstrConName', outParamType:'string', clsid:xtxsync.xtx_clsid,aliasName:'SOF_GetPicture'},
                {funcName:'SOF_SignEnvelopeFile', inParams:'CertID, Cert, InFile, OutFile', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOF_UnSignEnvelopeFile', inParams:'CertID, InFile, OutFile', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOFX_EncryptFile', inParams:'CertID, Cert, InFile, OutFile, ulFlags', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'SOFX_DecryptFile', inParams:'CertID, InFile, OutFile, ulFlags', outParamType:'bool', clsid:xtxsync.xtx_clsid},
                {funcName:'GetPic', inParams:'bstrConName', outParamType:'string', clsid:xtxsync.getpic_clsid},
                {funcName:'Hash', inParams:'inData', outParamType:'string', clsid:xtxsync.getpic_clsid},
                {funcName:'ConvertPicFormat', inParams:'inData, type', outParamType:'string', clsid:xtxsync.getpic_clsid},
                {funcName:'ConvertGif2Jpg', inParams:'inData', outParamType:'string', clsid:xtxsync.getpic_clsid},
                {funcName:'GetPic1', inParams:'bstrConName', outParamType:'string', clsid:xtxsync.getpic_clsid},
                {funcName:'ConvertPicSize', inParams:'bstrPic, w, h', outParamType:'string', clsid:xtxsync.getpic_clsid},
                {funcName:'GetEnvVersion', inParams:'', outParamType:'string', clsid:xtxsync.xtx_version_clsid}
            ];

            for (var i = 0; i < export_functions.length; i++) {
                getImplmentFunction(export_functions[i]);
                xtxsync[export_functions[i].funcName] = bjca_method[export_functions[i].funcName];
                if (export_functions[i].aliasName) {
                    xtxsync[export_functions[i].aliasName] = bjca_method[export_functions[i].funcName];
                }
            }
            return true;
        }
        return initXTXAppObject(xtxsync);
    })();

    ///////////////////////////////////////初始化控件结束/////////////////////////////////////////////

    ////////////////////////////////////////封装接口//////////////////////////////////////////////////    
    // 获取用户列表 并填充到证书列表
    function FillUserList(strListID) {
        var objListID = eval(strListID);
        //var strUserList = SOF_GetUserList();
        var strUserList = GetUserList();
        while (1) {
            var i = strUserList.indexOf("&&&");
            if (i <= 0) {
                break;
            }
            var strOneUser = strUserList.substring(0, i);
            var strName = strOneUser.substring(0, strOneUser.indexOf("||"));
            var strUniqueID = strOneUser.substring(strOneUser.indexOf("||") + 2,
                    strOneUser.length);
            var objItem = new Option(strName, strUniqueID);
            objListID.add(objItem);
            var len = strUserList.length;
            strUserList = strUserList.substring(i + 3, len);
        }
        var objListID = null;
        return;
    }
    
    // 清空证书列表
    function RemoveUserList(strListID) {
        var objListID = eval(strListID);
        var i;
        var n = objListID.length;
        for (i = 0; i < n; i++) {
            objListID.remove(0);
        }
    }
    
    // 重新填充用户列表
    function ChangeUserList(strListID) {
        RemoveUserList(strListID);
        FillUserList(strListID);
    }

    // 非IE浏览器下用到的函数
    function OnUsbKeyChange() {
        // alert("OnUsbKeyChange called!");
        ChangeUserList("LoginForm.UserList");
    }

    // 获取用户列表
    function SOF_GetUserList() {
        return xtxsync.SOF_GetUserList();
    }

    // 导出用户证书
    function SOF_ExportUserCert(CertID, certType) {
        if (certType == KEY_SIGNOREXCHANGE) {
            return xtxsync.SOF_ExportUserCert(CertID);
        } else if (certType == KEY_SIGNATURE) {
            var signCert = xtxsync.SOF_ExportUserCert(CertID);
            var encCert = xtxsync.SOF_ExportExChangeUserCert(CertID);
            if (signCert != encCert) {
                return signCert;
            } else { /* 不存在签名证书 */
                return "";
            }
        } else if (certType == KEY_KEYEXCHANGE) {
            return xtxsync.SOF_ExportExChangeUserCert(CertID);
        } else {
            return "";
        }
    }

    // 校验用户口令
    function SOF_Login(CertID, passwd) {
        var ret = xtxsync.SOF_Login(CertID, passwd);
        if (ret) {
            return true;
        } else {
            return false;
        }
    }

    // 获取密码重试次数
    function SOF_GetPinRetryCount(CertID) {
        return xtxsync.SOF_GetPinRetryCount(CertID);
    }

    // 获取证书信息
    function XTXAPP_GetCertDetail(sCert, type) {
        if (type == CERT_UNIQUEID) {
            var ret = xtxsync.SOF_GetCertInfoByOid(sCert, "1.2.86.11.7.1.8");
            if (ret != "") {
                return ret;
            } else {
                ret = xtxsync.SOF_GetCertInfoByOid(sCert, "2.16.840.1.113732.2");
                if (ret != "") {
                    return ret;
                } else {
                    return xtxsync.SOF_GetCertInfoByOid(sCert,
                            "1.2.156.112562.2.1.1.1");
                }
            }
        } else {
            return xtxsync.SOF_GetCertInfo(sCert, type);
        }
    }

    // 数据签名
    function SOF_SignedData(CertID, inData) {
        return xtxsync.SOF_SignData(CertID, inData);
    }

    // 数据验签
    function SOF_VerifySignedData(sCert, inData, signValue) {
        var ret = xtxsync.SOF_VerifySignedData(sCert, inData, signValue);
        if (ret) {
            return true;
        } else {
            return false;
        }
    }

    function SOF_GetLastError() {
        return xtxsync.SOF_GetLastError();
    }

    function SOF_GetLastErrorMsg() {
        var code = xtxsync.SOF_GetLastError();
        var msg = xtxsync.SOF_GetLastErrMsg();
        return "错误码[" + code + "] 错误描述[" + msg + "]"
    }
    
    // 验证证书有效性
	// 入参：@cert ： 证书base64
	// 返回值：0 表示成功，-1 证书不被信任，-2 为超过有效期，-3 证书已作废，-4 证书已冻结，-5 证书未生效 -6 其他错误
	function SOF_ValidateCert(cert) {
		var ret = xtxsync.SOF_ValidateCert(cert);
		if (ret == "0") {
			return "";
		} else if (ret == "-1") {
			return "-1 证书不被信任";
		} else if (ret == "-2") {
			return "-2 证书超过有效期";
		} else if (ret == "-3") {
			return "-3 证书已作废";
		} else if (ret == "-4") {
			return "-4 证书已冻结";
		} else if (ret == "-5") {
			return "-5 证书未生效";
		} else if (ret == "-6") {
			return "-6 验证证书有效性失败、其他错误";
		} else {
			return "验证证书有效性失败，未知错误：" + ret;
		}
	}

    function CheckValid(userCert) {
        var sc = SOF_ValidateCert(userCert);
		if (sc != "") {
			alert(sc);
			return false;
		}

        // 检查证书有效期
        var strNotBefore = XTXAPP_GetCertDetail(userCert, CERT_NOT_BEFORE);
        var strNotBefore_year = strNotBefore.substring(0, 4);
        var strNotBefore_month = strNotBefore.substring(4, 6);
        var strNotBefore_day = strNotBefore.substring(6, 8);
        var notBeforeDate = strNotBefore_year + "/" + strNotBefore_month + "/" + strNotBefore_day;
        var nowDate = new Date().Format("yyyy/MM/dd");
        var days = (Date.parse(notBeforeDate) - Date.parse(nowDate)) / (1000 * 60 * 60 * 24);
        if (days > 0) {
            alert("您的证书尚未生效!距离生效日期还剩" + days + "天!");
            return false;
        }

        var strNotAfter = XTXAPP_GetCertDetail(userCert, CERT_NOT_AFTER);
        var strNotAfter_year = strNotAfter.substring(0, 4);
        var strNotAfter_month = strNotAfter.substring(4, 6);
        var strNotAfter_day = strNotAfter.substring(6, 8);
        var notAfterDate = strNotAfter_year + "/" + strNotAfter_month + "/" + strNotAfter_day;
        var nowDate = new Date().Format("yyyy/MM/dd");
        days = (Date.parse(notAfterDate) - Date.parse(nowDate)) / (1000 * 60 * 60 * 24);

        if (days <= -45) {
            alert("您的证书已过期 " + -days + " 天，超过了最后使用期限！\n请到北京数字证书认证中心办理证书更新手续。");
            return false;
        }

        if (days >= 0 && days <= 60) {
            alert("您的证书还有" + days + "天过期，\n请您尽快到北京数字证书认证中心办理证书更新手续。");
            return true;
        }

        if (days < 0) {
            alert("您的证书已过期 " + -days + " 天，\n请尽快到北京数字证书认证中心办理证书更新手续。");
            return false;
        }

        return true;
    }

    // 用户登录
    function Login(strFormName, strCertID, strPin, forceCheck) {
        // 导出客户端证书
        var userCert = SOF_ExportUserCert(strCertID, KEY_SIGNOREXCHANGE);
        if (userCert == null || userCert == "") {
            alert("导出用户证书失败!");
            return false;
        }

        // 检查证书有效期
        if (!CheckValid(userCert)) {
            return false;
        }
        
        strPin = strPin || "";
        if (iKeyExist(strCertID) && (SOF_IsLogin(strCertID)) && (strPin == "") && (!forceCheck)) {
            return true;
        }
            
        var objForm = eval(strFormName);
        if (objForm == null) {
            alert("表单错误");
            return false;
        }
        if (strCertID == null || strCertID == "") {
            alert("获取用户信息失败");
            return false;
        }
        if (strPin == null || strPin == "") {
            alert("请输入证书密码");
            return false;
        }
        if (strPin.length < 6 || strPin.length > 16) {
            alert("密码长度应该在4-16位之间");
            return false;
        }

        // 校验密码
        var ret = SOF_Login(strCertID, strPin);
        if (!ret) {
            var retryCount = SOF_GetPinRetryCount(strCertID);
            if (retryCount > 0) {
                alert("校验证书密码失败!您还有" + retryCount + "次机会重试!");
                return false;
            } else if (retryCount == 0) {
                alert("您的证书密码已被锁死,请联系BJCA进行解锁!");
                return false;
            } else {
                alert("登录失败!");
                return false;
            }
        }
       
        // 验证服务端签名
        /*
        ret = SOF_VerifySignedData(strServerCert, strServerRan, strServerSignedData)
        if (!ret) {
            alert("验证服务器端信息失败!");
            return false;
        }
        */
        // 对随机数做签名
        var strClientSignedData = SOF_SignedData(strCertID, strServerRan);
        if (strClientSignedData == null || strClientSignedData == "") {
            alert("客户端签名失败!");
            return false;
        }
        // Add a hidden item ...
        var strSignItem = "<input type=\"hidden\" name=\"UserSignedData\" value=\"\">";
        if (objForm.UserSignedData == null) {
            objForm.insertAdjacentHTML("BeforeEnd", strSignItem);
        }
        
        var strCertItem = "<input type=\"hidden\" name=\"UserCert\" value=\"\">";
        if (objForm.UserCert == null) {
            objForm.insertAdjacentHTML("BeforeEnd", strCertItem);
        }
        
        var strContainerItem = "<input type=\"hidden\" name=\"ContainerName\" value=\"\">";
        if (objForm.ContainerName == null) {
            objForm.insertAdjacentHTML("BeforeEnd", strContainerItem);
        }

        objForm.UserSignedData.value = strClientSignedData;
        objForm.UserCert.value = userCert;
        objForm.ContainerName.value = strCertID;
    
        return true;
    }

    ////////////////////////////////////////对外接口//////////////////////////////////////////////////    
    function GetUserList() {
        var strUserList = "";
        var ret = "";
        try {
            strUserList = SOF_GetUserList();
            
            var arr = strUserList.split("&&&");
            for (var i =0; i < arr.length; i++) {
                var strOneUser = arr[i];
                if (strOneUser == "") continue;
                
                var strName = strOneUser.split("||")[0];
                var strUniqueID = strOneUser.split("||")[1];
                
                if (strName == "易签盾证书") continue;
                
                if (ret == "") {
                    ret = strOneUser;
                } else {
                    ret = ret + "&&&" + strOneUser;
                }
            }
            
            return ret;
        } catch (e) {
            return "";
        }
    }

    function getUserList_pnp() {
        return GetUserList();
    }
    
    function SignedData(content, key) {
        return SOF_SignedData(key, content);

    }
    function SignedOrdData(content, key) {
        return SOF_SignedData(key, content);
    }
    
    // 获取身份证号
    function GetIdentityID(key) {
        var oid = "2.16.840.1.113732.2"; // RSA key
        // var oid = "1.2.156.112562.2.1.1.1";//SM2 key
        var cert;
        cert = SOF_ExportUserCert(key, KEY_SIGNATURE);
        var sf_id = xtxsync.SOF_GetCertInfoByOid(cert, oid);
        return sf_id;
    }

    function GetSignCert(key) {
        return SOF_ExportUserCert(key, KEY_SIGNATURE);
    }

    function GetCertSN(cert) {
        return XTXAPP_GetCertDetail(cert, CERT_SERIAL);
    }

    function GetKeySN(key) {
        if (key != "") {
            var strs = new Array(); // 定义一数组
            strs = key.split("/"); // 字符分割
            var keysn = strs[1];
            return keysn;

        } else {
            return null;
        }
    }

    function GetPicBase64Data(key) {
        try {
            var picture = xtxsync.GetPicture(key);
        } catch (e) {
            var picture = "";
        }
        return picture;
    }
    
    function HashData(InData) {
        //兼容新老驱动
        try {
            var hashdata = xtxsync.SOF_HashData(1,InData);
        } catch (e) {
            var hashdata = "";
        }
        return hashdata;
    }

    // 证书标识符，用于区分证书,放置用户证书唯一标识
    function GetUniqueID(cert) {
        // var oid = "1.2.156.112562.2.1.4.1"; // SM2 key
        //var oid = "1.2.156.112562.2.1.1.4"; // SM2 key
        //var uniqueID = XTXAPP.SOF_GetCertInfoByOid(cert, oid);
        //泰和肿瘤时修改为不通过拓展oid获取，可以匹配通用项目
        var uniqueID = xtxsync.SOF_GetCertEntity(cert);
        return uniqueID;
    }

    function GetCertCNName(cert) {
        return XTXAPP_GetCertDetail(cert, CERT_SUBJECT_CN);
    }

    function GetCertNo(key) {
        var par = key.split('/');
        return par[0];
    }

    function getUsrSignatureInfo(key) {
        var usrSignatureInfo = new Array();
        usrSignatureInfo["identityID"] = GetIdentityID(key);
        var cert = GetSignCert(key);
        usrSignatureInfo["certificate"] = cert;
        usrSignatureInfo["certificateNo"] = GetCertNo(key);
        usrSignatureInfo["CertificateSN"] = GetCertSN(cert);
        usrSignatureInfo["uKeyNo"] = GetKeySN(key);
        //由于ca的问题，必须先hash，才能取到图片,2012年8月份以后新项目可以不加该语句。
        //HashData("test");  
        usrSignatureInfo["signImage"] = GetPicBase64Data(key);
        usrSignatureInfo["UsrCertCode"] = GetUniqueID(cert);
        usrSignatureInfo["CertName"] = GetCertCNName(cert);
        return usrSignatureInfo;
    }

    //校验输入的密码 正确返回空
    function CheckPWD(strCertID, strPin) {
        if (strCertID == null || strCertID == "") {
            return "获取用户信息失败";
        }
        if (strPin == null || strPin == "") {
            return "请输入证书密码";
        }
        if (strPin.length < 6 || strPin.length > 16) {
            return "密码长度应该在4-16位之间";
        }

        // 校验密码
        var ret = SOF_Login(strCertID, strPin);
        if (!ret) {
            var retryCount = SOF_GetPinRetryCount(strCertID);
            if (retryCount > 0) {
                return "校验证书密码失败!您还有" + retryCount + "次机会重试!";
            } else if (retryCount == 0) {
                return "您的证书密码已被锁死,请联系BJCA进行解锁!";
            } else {
                return "登录失败!";
            }
        }
        
        return "";
    }

    //校验随机数
    function CheckForm(strCertID, strServerCert, strServerRan, strServerSignedData) {

        var result = {};

        // 导出客户端证书
        //var userCert = SOF_ExportUserCert(strCertID, KEY_SIGNOREXCHANGE);
        var userCert = GetSignCert(strCertID, KEY_SIGNOREXCHANGE);
        if (userCert == null || userCert == "") {
            result.errMsg = "导出用户证书失败!";
            return result;
        }

        // 验证服务端签名
        ret = SOF_VerifySignedData(strServerCert, strServerRan, strServerSignedData)
        if (!ret) {
            result.errMsg = '验证服务器端信息失败!';
            return result;
        }

        // 对随机数做签名
        //var strClientSignedData = SOF_SignData(strCertID, strServerRan);
        var strClientSignedData = SignedData(strServerRan,strCertID);
        if (strClientSignedData == null || strClientSignedData == '') {
            result.errMsg = '客户端签名失败!';
            return result;
        }

        result.errMsg = '';
        result.UserSignedData = strClientSignedData;
        result.UserCert = userCert;
        result.ContainerName = strCertID;
   
        return result;
    }

    function SOF_IsLogin(strKey) {
        return xtxsync.SOF_IsLogin(strKey);
    }

    function oGetLastError() {
        return SOF_GetLastErrorMsg();
    }
    
    function iGetLoginedInfo() {
        var result = iGetData("GetLoginedInfo");
          return result;
    }
    
    function iKeyExist(key) {
        var strUserList = GetUserList();
        var arrUsers = strUserList.split('&&&');
        for (var i = 0; i < arrUsers.length; i++) {
            var user = arrUsers[i];
            if (user != "") {
                if (key == user.split('||')[1]) return true;
            }
        }
        return false;
    }
    
    function oLoginForm(paraObj) {
        paraObj = paraObj||"";
        var forceLogin = paraObj.forceLogin||false;

        if ((!forceLogin)) {
            var loginedCert = iGetLoginedInfo();
            if ((loginedCert.retCode == 0)&&(loginedCert.certContainer != "")) {
                if (iKeyExist(loginedCert.certContainer)&&(SOF_IsLogin(loginedCert.certContainer))) {
                    loginedCert.signCert = GetSignCert(loginedCert.certContainer);
                    loginedCert.userCertCode = GetUniqueID(loginedCert.signCert);
                    loginedCert.certNo = GetCertNo(loginedCert.certContainer);
                    Global_Last_Login_CertInfo = loginedCert;
                    return Global_Last_Login_CertInfo;
                }
            }    
        }
        
        var url = "../csp/dhc.certauth.login.ukey.csp?venderCode=" + Const_Vender_Code + "&signType=" + Const_Sign_Type;
        var para = {
            GetUserList: function() {
                return GetUserList();
            },
            CheckPWD: function(key, pin) {
                return CheckPWD(key, pin);
            },
            GetSignCert: function(key) {
                return GetSignCert(key);
            },
            GetCertNo: function(key) {
                return GetCertNo(key);
            },
            GetUniqueID: function(cert,key) {
                return GetUniqueID(cert);
            }
        };
        var rtnStr = window.showModalDialog(url,para,"dialogWidth:350px;dialogHeight:350px;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;fullscreen=no");
        
        if ((typeof(rtnStr) == "undefined")||(rtnStr == "")) {
            return {retCode:"-2",retMsg:"登录失败"};
        }
        
        var rtn = $.parseJSON(rtnStr);
        if ((rtn)&&(rtn.retCode == "0")&&(rtn.hisUserName != "")) {
            Global_Last_Login_CertInfo = rtn;
        }
        
        return rtn||{retCode:"-2",retMsg:"登录失败"};
    }
    
    
    function iGetData(Func,P1,P2,P3,P4,P5,P6,P7,P8,P9) {
        
        var result = "";
        var para = {
              CAFunc: Func,
              CAVenderCode:Const_Vender_Code,
              CASignType:Const_Sign_Type,
              P1:P1||"",
              P2:P2||"",
              P3:P3||"",
              P4:P4||"",
              P5:P5||"",
              P6:P6||"",
              P7:P7||"",
              P8:P8||"",
              P9:P9||""
          };
          
          $.ajax({
            url: "../CA.Ajax.DS.cls",
            type: "POST",
            dataType: "JSON",
            async: false,
            global:false,
            data: para,
            success: function(ret) {
                if (ret && ret.retCode == "0") {
                    result = ret;
                } else {
                    alert(ret.retMsg);
                }
            },
            error: function(err) {
                alert(err.retMsg || err);
            }
          });
          
          return result;
    }
    
    return {
        OCX: xtxsync,
        VenderCode:Const_Vender_Code,
        SignType:Const_Sign_Type,
        GetRealKey: function(key) {
            return key;
        },
        CheckPWD: function(key, pwd) {
            return CheckPWD(key, pwd);
        },
        CheckForm: function(key, strServerCert, strServerRan, strServerSignedData) {
            return CheckForm(key, strServerCert, strServerRan, strServerSignedData);
        },
        Login: function(strFormName, strCertID, strPin, forceCheck) {
            return Login(strFormName, strCertID, strPin, forceCheck);
        },
        IsLogin: function(strKey) {
            if ('undefined' != SOF_IsLogin) {
                return SOF_IsLogin(strKey);
            }
            return false;
        },
        GetUserList: function() {
            return GetUserList();
        },
        getUserList2: function() {
            return GetUserList();
        },
        GetSignCert: function(key) {
            return GetSignCert(key);
        },
        GetUniqueID: function(cert, key) {
            return GetUniqueID(cert, key);
        },
        GetCertNo: function(key) {
            return GetCertNo(key);
        },
        SignedData: function(contentHash, key) {
            return SignedData(contentHash, key)
        },
        SignedOrdData: function(contentHash, key) {
            return SignedOrdData(contentHash, key)
        },
        getUsrSignatureInfo: function(key) {
            return getUsrSignatureInfo(key);
        },
        HashData:function(content){
            return HashData(content)  
        },
        LoginForm:function(paraObj) {
            return oLoginForm(paraObj);
        },
          GetPicBase64Data:function(key) {
            return GetPicBase64Data(key);
        },
        GetLastError:function() {
            return oGetLastError();
        }
    }
})();

///1.登录相关
///登录验证
function Login(strFormName, key, pin, forceCheck) {
    return ca_key.Login(strFormName, key, pin, forceCheck);
}
///是否登陆过
function IsLogin(key) {
    return ca_key.IsLogin(key);
}
function SOF_IsLogin(key) {
    return ca_key.IsLogin(key);
}

///2.证书列表
///获取证书列表
function GetUserList() {
    return ca_key.GetUserList();
}
function GetList_pnp() {
    return ca_key.GetUserList();
}
function getUserList2() {
    return ca_key.GetUserList();
}
function getUserList_pnp() {
    return ca_key.GetUserList();
}

///3.证书信息
///获取containerName
function GetRealKey(key) {
    return ca_key.GetRealKey(key);
}
///获取证书base64编码
function GetSignCert(key) {
    return ca_key.GetSignCert(key);
}
///获取CA用户唯一标识
function GetUniqueID(cert,key) {
    return ca_key.GetUniqueID(cert,key);
}
///获取证书唯一标识
function GetCertNo(key) {
    return ca_key.GetCertNo(key);
}
///获取证书信息集合
function getUsrSignatureInfo(key) {
    return ca_key.getUsrSignatureInfo(key);
}

///4.签名相关
///对待签数据做Hash
function HashData(content){
    return ca_key.HashData(content) 
}
///对待签数据的Hash值做签名
function SignedData(contentHash, key) {
    return ca_key.SignedData(contentHash, key)
}
function SignedOrdData(contentHash, key) {
    return ca_key.SignedOrdData(contentHash, key)
}

///5.其他
function CheckPWD(key, pwd) {
    return ca_key.CheckPWD(key, pwd);
}
function CheckForm(key, strServerCert, strServerRan, strServerSignedData) {
    return ca_key.CheckForm(key, strServerCert, strServerRan, strServerSignedData);
}
function LoginForm(paraObj) {
    return ca_key.LoginForm(paraObj);
}
function GetLastError() {
    return ca_key.GetLastError();
}

///兼容基础平台的判断是否登录逻辑
window.XTXAPP = {};
window.XTXAPP.SOF_IsLogin = SOF_IsLogin;