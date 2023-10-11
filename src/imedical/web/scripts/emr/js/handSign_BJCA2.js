//IE下加载IE所需环境
if(!!window.ActiveXObject || "ActiveXObject" in window) {
    try {
        document.writeln('<OBJECT classid="clsid:D3C5BDC4-CE65-48D8-8DE0-C3DB1DF84962" id="anysign" style="height:1px;width:1px"></OBJECT>');
    } catch (e) {
        alert(e.message);
    }
}
//否则加载医为浏览器环境变量
else
{
    (function() {
        var CERT_TYPE_HARD = 1;
        var CERT_TYPE_SOFT = 2;
        var CERT_TYPE_ALL  = 3;
         
        // const var
        var CERT_OID_VERSION     = 1; 
        var CERT_OID_SERIAL      = 2;
        var CERT_OID_SIGN_METHOD = 3; 
        var CERT_OID_ISSUER_C    = 4;
        var CERT_OID_ISSUER_O    = 5;
        var CERT_OID_ISSUER_OU   = 6;  
        var CERT_OID_ISSUER_ST   = 7;  
        var CERT_OID_ISSUER_CN   = 8;  
        var CERT_OID_ISSUER_L    = 9;  
        var CERT_OID_ISSUER_E    = 10; 
        var CERT_OID_NOT_BEFORE  = 11; 
        var CERT_OID_NOT_AFTER   = 12; 
        var CERT_OID_SUBJECT_C   = 13; 
        var CERT_OID_SUBJECT_O   = 14; 
        var CERT_OID_SUBJECT_OU  = 15; 
        var CERT_OID_SUBJECT_ST  = 16; 
        var CERT_OID_SUBJECT_CN  = 17; 
        var CERT_OID_SUBJECT_L   = 18; 
        var CERT_OID_SUBJECT_E   = 19; 
        var CERT_OID_PUBKEY      = 20; 
        var CERT_OID_SUBJECT_DN  = 33; 
        var CERT_OID_ISSUER_DN   = 34;

        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////// EXPORT VAR AND FUNCTIONS ///////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////
        (function() {
        //axc is the short name of ActiveX Caller
            if (typeof axc === 'undefined') {
                axc = {};
            }
        })();

        // initialize axc hashMap object
        (function() {

            function AxcHashMap(){
                this.map = {};
            }
            AxcHashMap.prototype = {
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
            AxcHashMap.prototype.constructor = AxcHashMap;

            axc.HashMap = AxcHashMap;
        })();

        // initialize axc util object
        (function() {
            
            function initUtilObject(axc) {
                
                var util = axc.util = axc.util || {};
                
                util.checkBrowserISIE = function() {
                    return (!!window.ActiveXObject || 'ActiveXObject' in window) ? true : false;
                }
                
                util.loadIEControl = function(CLSID, ControlName, testFuncName, controlParam) { // test function must has 0 parameter
                    if (!util.checkBrowserISIE()) {
                        return null;
                    }
                    var control = document.getElementById(ControlName);
                    if (control) {
                        return control;
                    }
                    
                    try {
                        var loadObjString = '<object id="' + ControlName + '" classid="CLSID:' + CLSID + '" style="HEIGHT:0px; WIDTH:0px">';
                        if (controlParam) {
                            loadObjString += controlParam;
                        }
                        loadObjString += '</object>';
                        document.write(loadObjString);
                        if (testFuncName != null && testFuncName != "" && eval(ControlName + "." + testFuncName) == undefined) {
                            return null; 
                        }    
                    } catch (e) {
                        return null;
                    }
                    
                    return document.getElementById(ControlName);
                }
                
                util.getAutoExecFunctionString = function (func) {
                    var ret = "(";
                    ret += func.toString();
                    ret += ")()";
                    
                    return ret;
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
                
                util.attachIEEvent = function(ControlName, EventName, OnEventFunction) {
                    var control;
                    if (typeof ControlName === 'string') {
                        control = eval(ControlName);
                    } else {
                        control = ControlName;
                    }
                    
                    var eventFunc;
                    if (typeof OnEventFunction === 'function') {
                        eventFunc = OnEventFunction;
                    } else if (typeof OnEventFunction === 'string') {
                        eventFunc = eval(OnEventFunction);
                    } else {
                        return false;
                    }
                    
                    if (control.attachEvent) { 
                        control.attachEvent(EventName, eventFunc);
                    } else {// IE11 not support attachEvent, and addEventListener do not work well, so addEvent ourself
                        var handler = document.createElement("script");
                        handler.setAttribute("for", control.id);
                        handler.setAttribute("event", EventName);
                        var eventScript = util.getAutoExecFunctionString(eventFunc);
                        handler.appendChild(document.createTextNode(eventScript));
                        document.getElementsByTagName("head")[0].appendChild(handler);
                
                    }   
                }
                
                util.checkLocationIsHttps = function() {
                    return 'https:' == document.location.protocol ? true: false;
                }
                
                util.consolelog = function(param) {
                    if (window.console == undefined || window.console.log == undefined) {
                        return;
                    }
                    console.log(param);
                }
                
                util.loadWebSocket = function(wsUrl, wssUrl, testFuncName) {
                    // testFuncName will use for heartBeat, so it must be very simple and does not occupy resources
                    var wsObject = {
                        socket:undefined,
                        wsHeartBeatId : 0,
                        wsEventQueue : new axc.HashMap()
                    };
                    
                    var url;
                    if (util.checkLocationIsHttps()) {
                        url = "wss://" + wssUrl;
                    } else {
                        url = "ws://" + wsUrl;
                    }
                    
                    try {
                        wsObject.socket = new WebSocket(url); 
                    } catch (e) {
                        util.consolelog(e);
                        return null;
                    }
                    /*
                    wsObject.socket.onopen = function(evt) {
                        clearInterval(wsObject.wsHeartBeatId);            
                        wsObject.wsHeartBeatId = setInterval(function () {
                            var sendArray = {'xtx_func_name':testFuncName, 'call_cmd_id':'1'};
                            if (wsObject.socket.readyState == WebSocket.OPEN) {
                                wsObject.socket.send(JSON.stringify(sendArray))
                            }
                        }, 10 * 1000);
                    }
                       
                    wsObject.socket.onclose = function(evt) { 
                        util.consolelog(evt.data);
                    }; 
                        
                    wsObject.socket.onmessage = function(evt) {
                        var eventCmd = false;
                        if (axc.util.isEmpty(evt.data)) {
                            util.consolelog("onmessage evt.data is NULL!!!");
                            return;
                        }
                        try {
                            var res = JSON.parse(evt.data);
                            if (!res['call_cmd_id']) {
                                util.consolelog("return JSON not include call_cmd_id field!!!");
                                return;
                            }
                            var eventName = res['call_cmd_id'];
                            var execParam = wsObject.wsEventQueue.get(eventName);
                            if (!execParam || !execParam.cb || typeof execParam.cb != 'function') {
                                return;
                            }
                            execParam.cb();            
                        } catch (e) {
                            return;
                        }
                    }; 
                        
                    wsObject.socket.onerror = function(evt) { 
                        util.consolelog(evt.data);
                    };
                    */
                    return wsObject;
                }
                
                util.attachWebSocketEvent = function(wsObject, EventName, OnEventFunction) {
                    var eventFunc;
                    if (typeof OnEventFunction === 'function') {
                        eventFunc = OnEventFunction;
                    } else if (typeof OnEventFunction === 'string') {
                        eventFunc = eval(OnEventFunction);
                    } else {
                        return false;
                    }
                    
                    wsObject.wsEventQueue.put(EventName, {cb:OnEventFunction});    
                }
                
                util.createHttpRequest = function() {
                    if (window.XMLHttpRequest) {
                       return new XMLHttpRequest();
                    } else {
                       return new ActiveXObject("Microsoft.XMLHTTP");
                    }
                }
                
                util.ajaxSyncall = function(clsid, methodName, argsArray) {
                    try {
                        var xhr = util.createHttpRequest();
                        var strUrl = "http://127.0.0.1:22001/ajax_echo";
                        if (util.checkLocationIsHttps()) {
                            strUrl = "https://127.0.0.1:22002/ajax_echo";
                        }
                        xhr.open("POST", strUrl, false);
                        xhr.setRequestHeader("Content-type","application/json");
                        var sendArray = {
                            url:window.location.href, 
                            clsid:clsid, 
                            func:methodName,
                            param:argsArray
                        };
                        
                        xhr.send(JSON.stringify(sendArray));
                        if (xhr.status != 200) {
                            return;
                        }

                        var res = JSON.parse(xhr.responseText);

                        return res.retVal;
                    } catch (e) {
                        return;
                    }
                }
            }   

            return initUtilObject(axc);
        })();

        // initialize asappcom object
        (function() {
            
            function initASAppCOM(axc) {
                var util = axc.util;

                axc.ASAppCOM = util.loadIEControl("BA878047-4D57-40FA-BB43-C20BA6AB4175", "ASAppObj", "AS_GetVersion()");
                if (axc.ASAppCOM == null) {
                    //alert("加载ASAppCOM控件失败，请确认已正确安装信手书插件!");
                    return false;
                }
                
                return true;
            }

            function initASAppWebSocket(axc) { // used for listen usbkeychange
                var util = axc.util;
                var ASAppWebSocket = axc.ASAppWebSocket = axc.ASAppWebSocket || {};
                /*    
                ASAppWebSocket = util.loadWebSocket("127.0.0.1:22001/anysign2", "", "AS_GetVersion");
                if (ASAppWebSocket == null) {
                    custom.errorReportFunc("连接ASAppCOM服务失败，请确认已正确安装合适版本的信手书插件!");
                    return false;
                }
                */
                return true;
            }

            function initASAppAjax(axc) {    
                var util = axc.util;
                var ASAppAjax = axc.ASAppAjax = axc.ASAppAjax || {};
                
                ASAppAjax._call = function(methodName, params) {
                    return util.ajaxSyncall("{BA878047-4D57-40FA-BB43-C20BA6AB4175}", methodName, params);
                }
                
                // the following code is generate by golang and ASAppCom.idl
                //1
                ASAppAjax.AS_InitSign = function(signType) {
                    return ASAppAjax._call('AS_InitSign', [signType]);
                }
                //2
                ASAppAjax.AS_SetBusinessParam = function(ParamType,Param) {
                    return ASAppAjax._call('AS_SetBusinessParam', [ParamType,Param]);
                }
                //3
                ASAppAjax.AS_SetSignerInfo = function(name,IDType,ID) {
                    return ASAppAjax._call('AS_SetSignerInfo', [name,IDType,ID]);
                }
                //4
                ASAppAjax.AS_SetSignEvidenceData = function(dataJson) {
                    return ASAppAjax._call('AS_SetSignEvidenceData', [dataJson]);
                }
                //5
                ASAppAjax.AS_AddSignEvidenceData = function() {
                    return ASAppAjax._call('AS_AddSignEvidenceData', []);
                }
                //6
                ASAppAjax.AS_GetSignGUID = function() {
                    return ASAppAjax._call('AS_GetSignGUID', []);
                }
                //7
                ASAppAjax.AS_AddMulWord = function(content,mergeNum) {
                    return ASAppAjax._call('AS_AddMulWord', [content,mergeNum]);
                }
                //8
                ASAppAjax.AS_GetSignEvidenceData = function(dataType) {
                    return ASAppAjax._call('AS_GetSignEvidenceData', [dataType]);
                }
                //9
                ASAppAjax.AS_DeleteSign = function(SignGUID) {
                    return ASAppAjax._call('AS_DeleteSign', [SignGUID]);
                }
                //10
                ASAppAjax.AS_ReusedSign = function(SignGUID) {
                    return ASAppAjax._call('AS_ReusedSign', [SignGUID]);
                }
                //11
                ASAppAjax.AS_SetTimeout = function(nTimeout) {
                    return ASAppAjax._call('AS_SetTimeout', [nTimeout]);
                }
                //12
                ASAppAjax.AS_SetDlgPos = function(left,top){
                    return ASAppAjax._call('AS_SetDlgPos', [left,top]);
                }
                //13
                ASAppAjax.AS_AddEvidenceHash = function(evidenceDataBase64,mimeType,bioType){
                    return ASAppAjax._call('AS_AddEvidenceHash', [evidenceDataBase64,mimeType,bioType]);
                }
                //14
                ASAppAjax.AS_GetBusinessString = function(){
                    return ASAppAjax._call('AS_GetBusinessString', []);
                }
                //15
                ASAppAjax.AS_GetSignPackage = function(businessString){
                    return ASAppAjax._call('AS_GetSignPackage', [businessString]);
                }
                //16
                ASAppAjax.AS_SetPdfGenerateData = function(type,data,dataID){
                    return ASAppAjax._call('AS_SetPdfGenerateData', [type,data,dataID]);
                }
                //17
                ASAppAjax.AS_SetPosKW = function(kw,kwIndex,XOffset,YOffset,width,height){
                    return ASAppAjax._call('AS_SetPosKW', [kw,kwIndex,XOffset,YOffset,width,height]);
                }
                //18
                ASAppAjax.AS_SetPosXY = function(left,bottom,right,top,pageNo){
                    return ASAppAjax._call('AS_SetPosXY', [left,bottom,right,top,pageNo]);
                }
                //19
                ASAppAjax.AS_SetPosRule = function(ruleNo){
                    return ASAppAjax._call('AS_SetPosRule', [ruleNo]);
                }
                //20
                ASAppAjax.AS_AddUnitSign = function(imageBase,appName){
                    return ASAppAjax._call('AS_AddUnitSign', [imageBase,appName]);
                }
                //21
                ASAppAjax.AS_SetSignPlain = function(signPackage){
                    return ASAppAjax._call('AS_SetSignPlain', [signPackage]);
                }
                //22
                ASAppAjax.AS_GetSignatureCount = function(signPackage){
                    return ASAppAjax._call('AS_GetSignatureCount', [signPackage]);
                }
                //23
                ASAppAjax.AS_GetIndexSignature = function(signPackage,signIndex){
                    return ASAppAjax._call('AS_GetIndexSignature', [signPackage,signIndex]);
                }
                //24
                ASAppAjax.AS_VerifySign = function(tsValue,plainBase64){
                    return ASAppAjax._call('AS_VerifySign', [tsValue,plainBase64]);
                }
                //25
                ASAppAjax.AS_VerifyTimeStamp = function(tsValue,tsPlainData){
                    return ASAppAjax._call('AS_VerifyTimeStamp', [tsValue,tsPlainData]);
                }
                //26
                ASAppAjax.AS_GetDataFromSignValue = function(signValue,plainBase64,dataType){
                    return ASAppAjax._call('AS_GetDataFromSignValue', [signValue,plainBase64,dataType]);
                }
                //27
                ASAppAjax.AS_ConnectDev = function(){
                    return ASAppAjax._call('AS_ConnectDev', []);
                }
                //28
                ASAppAjax.AS_DisConnectDev = function(){
                    return ASAppAjax._call('AS_DisConnectDev', []);
                }
                //29
                ASAppAjax.AS_GetExtendScreenPos = function(){
                    return ASAppAjax._call('AS_GetExtendScreenPos', []);
                }
                
                //30
                ASAppAjax.AS_ReadFile = function(base64FileName){
                    return ASAppAjax._call('AS_ReadFile', [base64FileName]);
                }
                //31
                ASAppAjax.AS_SaveFile = function(base64FileName,base64FileContent){
                    return ASAppAjax._call('AS_SaveFile', [base64FileName,base64FileContent]);
                }
                //32
                ASAppAjax.AS_HashFile = function(hashFileName,hashAlg){
                    return ASAppAjax._call('AS_HashFile', [hashFileName,hashAlg]);
                }
                //33
                ASAppAjax.AS_HashData = function(plainData, hashAlg){
                    return ASAppAjax._call('AS_HashData', [plainData, hashAlg]);
                }
                //34
                ASAppAjax.AS_Base64Encode = function(strData,strType){
                    return ASAppAjax._call('AS_Base64Encode', [strData,strType]);
                }
                //35
                ASAppAjax.AS_Base64Decode = function(strBase64){
                    return ASAppAjax._call('AS_Base64Decode', [strBase64]);
                }
                //36
                ASAppAjax.AS_GetVersion = function(){
                    return ASAppAjax._call('AS_GetVersion', []);
                }
                //37
                ASAppAjax.AS_GetLastError = function(){
                    return ASAppAjax._call('AS_GetLastError', []);
                }
                //38
                ASAppAjax.AS_MoveTo = function(dlg_left,dlg_top,dlg_width,dlg_height){
                    return ASAppAjax._call('AS_MoveTo', [dlg_left,dlg_top,dlg_width,dlg_height]);
                }
                //39
                ASAppAjax.AS_SetConfig = function(strKey,strValue){
                    return ASAppAjax._call('AS_SetConfig', [strKey,strValue]);
                }
                //40
                ASAppAjax.AS_ResizeImage = function(strImageData,lImageWidth,imageFormat){
                    return ASAppAjax._call('AS_ResizeImage', [strImageData,lImageWidth,imageFormat]);
                }
                //41
                ASAppAjax.AS_TakePhoto = function(){
                    return ASAppAjax._call('AS_TakePhoto', []);
                }
                ASAppAjax.AS_SetDlgSize = function(width,height){
                    return ASAppAjax._call('AS_SetDlgSize', [width,height]);
                }
                //47
                ASAppAjax.AS_OpenIDCardDlg = function(){
                    return ASAppAjax._call('AS_OpenIDCardDlg', []);
                }
                //48
                ASAppAjax.AS_SetServerIP = function(mainIP,mainPort,spareIP,sparePort,timeout){
                    return ASAppAjax._call('AS_SetServerIP', [mainIP,mainPort,spareIP,sparePort,timeout]);
                }
                //49
                ASAppAjax.AS_PdfSign = function(){
                    return ASAppAjax._call('AS_PdfSign', []);
                }
                //50
                ASAppAjax.AS_SetHWRModel = function(RecognizeNum){
                    return ASAppAjax._call('AS_SetHWRModel', [RecognizeNum]);
                }
                //51
                ASAppAjax.AS_GetHWRResult = function(){
                    return ASAppAjax._call('AS_GetHWRResult', []);
                }
                //52
                ASAppAjax.AS_MoveByTitle = function(title, left, top, width, height){
                    return ASAppAjax._call('AS_MoveByTitle', [title, left, top, width, height]);
                }
                //53
                ASAppAjax.AS_MoveToMonitorByTitle = function(title, monitorId){
                    return ASAppAjax._call('AS_MoveToMonitorByTitle', [title, monitorId]);
                }
                //54
                ASAppAjax.AS_SetSignAlg = function(SignAlg,IsTS){
                    return ASAppAjax._call('AS_SetSignAlg', [SignAlg,IsTS]);
                }
                //55
                ASAppAjax.AS_SetPenAttr = function(Type,Color,Width){
                    return ASAppAjax._call('AS_SetPenAttr', [Type,Color,Width]);
                }
                //56
                ASAppAjax.AS_SetEvidenceCollectionModel = function(Modal){
                    return ASAppAjax._call('AS_SetEvidenceCollectionModel', [Modal]);
                }
                //57
                ASAppAjax.AS_Sign = function(BusinessData){
                    return ASAppAjax._call('AS_Sign', [BusinessData]);
                }
                //58
                ASAppAjax.AS_GetErrMsg = function(errorNo){
                    return ASAppAjax._call('AS_GetErrMsg', [errorNo]);
                }
                //59
                ASAppAjax.AS_GetInfoFromSignValue = function(signValue, dataType){
                    return ASAppAjax._call('AS_GetInfoFromSignValue', [signValue, dataType]);
                }
                //60
                ASAppAjax.AS_CloseDlg = function(){
                    return ASAppAjax._call('AS_CloseDlg', []);
                }
                //61
                ASAppAjax.AS_SetPdfSignPos = function(posJson,index){
                    return ASAppAjax._call('AS_SetPdfSignPos', [posJson,index]);
                }
                //62
                ASAppAjax.AS_MultSign = function(data, docName){
                    return ASAppAjax._call('AS_MultSign', [data, docName]);
                }
                //63
                ASAppAjax.AS_IdentityVerification = function(){
                    return ASAppAjax._call('AS_IdentityVerification', []);
                }
                //64
                ASAppAjax.AS_DevPreviewPC = function(){
                    return ASAppAjax._call('AS_DevPreviewPC', []);
                }
                //65
                ASAppAjax.AS_PCPreviewDev = function(){
                    return ASAppAjax._call('AS_PCPreviewDev', []);
                }
                //66
                ASAppAjax.AS_StopDevOperate = function(){
                    return ASAppAjax._call('AS_StopDevOperate', []);
                }
                //67
                ASAppAjax.AS_DocPush = function(filePath,fileType,timeOut,leftBtn,leftBtnTxt,midBtn,midBtnTxt,rightBtn,rightBtnTxt){
                    return ASAppAjax._call('AS_DocPush', [filePath,fileType,timeOut,leftBtn,leftBtnTxt,midBtn,midBtnTxt,rightBtn,rightBtnTxt]);
                }
                //69
                ASAppAjax.AS_OpenWindowCopy = function(param){
                    return ASAppAjax._call('AS_OpenWindowCopy', [param]);
                }
                //70
                ASAppAjax.AS_CloseWindowCopy = function(){
                    return ASAppAjax._call('AS_CloseWindowCopy', []);
                }
                //71
                ASAppAjax.AS_TellerInfoDisplay = function(name,number,photoPath){
                    return ASAppAjax._call('AS_TellerInfoDisplay', [name,number,photoPath]);
                }
                //72
                ASAppAjax.AS_StartEvaluator = function(name,number,photoPath,timeOut){
                    return ASAppAjax._call('AS_StartEvaluator', [name,number,photoPath,timeOut]);
                }
                //73
                ASAppAjax.AS_AddEvidenceBase64 = function(evidenceDataBase64,mimeType,bioType){
                    return ASAppAjax._call('AS_AddEvidenceBase64', [evidenceDataBase64,mimeType,bioType]);
                }
                //74
                ASAppAjax.AS_UpdateAD = function(){
                    return ASAppAjax._call('AS_UpdateAD', []);
                }
                //75
                ASAppAjax.AS_SetImageFormat = function(dataType,imgFormat){
                    return ASAppAjax._call('AS_SetImageFormat', [dataType,imgFormat]);
                }
                //76
                ASAppAjax.AS_OpenURL = function(url){
                    return ASAppAjax._call('AS_OpenURL', [url]);
                }
                //77
                ASAppAjax.AS_DigitKeyboard = function(msg,numlen,isHidenum){
                    return ASAppAjax._call('AS_DigitKeyboard', [msg,numlen,isHidenum]);
                }
                //78
                ASAppAjax.AS_GetDeviceStatus = function(){
                    return ASAppAjax._call('AS_GetDeviceStatus', []);
                }

                return true;
            }
            
            function initASAppComObject(axc) {
                var util = axc.util;

                if (util.checkBrowserISIE()) { // IE
                    if (!initASAppCOM(axc)) {
                        return false;
                    }
                    axc.ASAPP = axc.ASAppCOM;
                } else { // other brower
                    if (!initASAppWebSocket(axc)) {
                        return false;
                    }
                    if (!initASAppAjax(axc)) {
                        return false;
                    }
                    axc.ASAPP = axc.ASAppAjax;
                }
                
                return true;
            }
            return initASAppComObject(axc);
        })();
    })();
}

//1
function AS_InitSign(signType) {
    return axc.ASAPP.AS_InitSign(signType);
}
//2
function AS_SetBusinessParam(ParamType, Param) {
    return axc.ASAPP.AS_SetBusinessParam(ParamType, Param);
}
//3
function AS_SetSignerInfo(name, IDType, ID) {
    return axc.ASAPP.AS_SetSignerInfo(name, IDType, ID);
}
//4
function AS_SetSignEvidenceData(dataJson) {
    return axc.ASAPP.AS_SetSignEvidenceData(dataJson);
}
//5
function AS_AddSignEvidenceData() {
    return axc.ASAPP.AS_AddSignEvidenceData();
}
//6
function AS_GetSignGUID() {
    return axc.ASAPP.AS_GetSignGUID();
}
//7
function AS_AddMulWord(content, megerNum) {
    return axc.ASAPP.AS_AddMulWord(content, megerNum);
}
//8
function AS_GetSignEvidenceData(dataType) {
    return axc.ASAPP.AS_GetSignEvidenceData(dataType);
}
//9
function AS_DeleteSign(SignGUID) {
    return axc.ASAPP.AS_DeleteSign(SignGUID);
};
//10
function AS_ReusedSign(SignGUID) {
    return axc.ASAPP.AS_ReusedSign(SignGUID);
}
//11
function AS_SetTimeout(nTimeout) {
    return axc.ASAPP.AS_SetTimeout(nTimeout);
}
//12
function AS_SetDlgPos(left, top1 ) {
    return axc.ASAPP.AS_SetDlgPos(left, top1 );
}
//13
function AS_AddEvidenceHash(evidenceDataBase64, mimeType,  bioType) {
    return axc.ASAPP.AS_AddEvidenceHash(evidenceDataBase64, mimeType,  bioType);
}
//14
function AS_GetBusinessString() {
    return axc.ASAPP.AS_GetBusinessString();
}
//15
function AS_GetSignPackage(businessString) {
    return axc.ASAPP.AS_GetSignPackage(businessString);   
}
//16
function AS_SetPdfGenerateData(type, data, dataID) {
    return axc.ASAPP.AS_SetPdfGenerateData(type, data, dataID); 
}
//17
function AS_SetPosKW(kw, kwIndex, XOffset, YOffset, width, height) {
    return axc.ASAPP.AS_SetPosKW(kw, kwIndex, XOffset, YOffset, width, height);   
}
//18
function AS_SetPosXY(left, bottom, right, top, pageNo) {
    return axc.ASAPP.AS_SetPosXY(left, bottom, right, top, pageNo); 
}
//19
function AS_SetPosRule(ruleNo) {
    return axc.ASAPP.AS_SetPosRule(ruleNo);   
}
//20
function AS_AddUnitSign(imageBase, appName) {
    return axc.ASAPP.AS_AddUnitSign(imageBase, appName);
}
//21
function AS_SetSignPlain(plainBase) {
    return axc.ASAPP.AS_SetSignPlain(plainBase);  
}
//22
function AS_GetSignatureCount(signPackage) {
    return axc.ASAPP.AS_GetSignatureCount(signPackage);   
}
//23
function AS_GetIndexSignature(signPackage, index) {
    return axc.ASAPP.AS_GetIndexSignature(signPackage, index);  
}
//24
function AS_VerifySign(signValue, plainBase64) {
    return axc.ASAPP.AS_VerifySign(signValue, plainBase64);   
}
//25
function AS_VerifyTimeStamp(tsValue, tsPlainData) {
    return axc.ASAPP.AS_VerifyTimeStamp(tsValue, tsPlainData);
}
//26
function AS_GetDataFromSignValue(signValue, plainBase64, dataType) {
    return axc.ASAPP.AS_GetDataFromSignValue(signValue, plainBase64, dataType);
}
//27
function AS_ConnectDev() {
    return axc.ASAPP.AS_ConnectDev();
}
//28
function AS_DisConnectDev() {
    return axc.ASAPP.AS_DisConnectDev();
}
//29
function AS_GetExtendScreenPos() {
    return axc.ASAPP.AS_GetExtendScreenPos();
}
//30
function AS_ReadFile(base64FileName) {
    return axc.ASAPP.AS_ReadFile(base64FileName);
}
//31
function AS_SaveFile(base64FileName, base64FileContent) {
    return axc.ASAPP.AS_SaveFile(base64FileName, base64FileContent);
}
//32
function AS_HashFile(hashFileName, hashAlg) {
    return axc.ASAPP.AS_HashFile(hashFileName, hashAlg);
}
//33
function AS_HashData(plainData, hashAlg) {
    return axc.ASAPP.AS_HashData(plainData, hashAlg);
}
//34
function AS_Base64Encode(strData, strType){
    return axc.ASAPP.AS_Base64Encode(strData, strType);
}
//35
function AS_Base64Decode(strBase64) {
    return axc.ASAPP.AS_Base64Decode(strBase64);
}
//36
function AS_GetVersion() {
    return axc.ASAPP.AS_GetVersion();
} 
//37
function AS_GetLastError() {
    return axc.ASAPP.AS_GetLastError();
}
//38
function AS_MoveTo(dlg_left, dlg_top, dlg_width, dlg_height) {
    return axc.ASAPP.AS_MoveTo(dlg_left, dlg_top, dlg_width, dlg_height);
}
//39
function AS_SetConfig(strKey, strValue) {
    return axc.ASAPP.AS_SetConfig(strKey, strValue);
}
//40
function AS_ResizeImage(strBase64,imgW,imgType) {
    return axc.ASAPP.AS_ResizeImage(strBase64,imgW,imgType);
}
//41
function AS_TakePhoto() {
    return axc.ASAPP.AS_TakePhoto();
}
//46
function AS_SetDlgSize(width, height) {
    return axc.ASAPP.AS_SetDlgSize(width, height);
}
//47
function AS_OpenIDCardDlg() {
    return axc.ASAPP.AS_OpenIDCardDlg();
}
//48
function AS_SetServerIP(mainIP,mainPort,spareIP,sparePort,timeout){
    return axc.ASAPP.AS_SetServerIP(mainIP,mainPort,spareIP,sparePort,timeout);
}
//49
function AS_PdfSign() {
    return axc.ASAPP.AS_PdfSign();
}
//50
function AS_SetHWRModel(RecognizeNum){
    return axc.ASAPP.AS_SetHWRModel(RecognizeNum);
}
//51
function AS_GetHWRResult(){
    return axc.ASAPP.AS_GetHWRResult();
}
//52
function AS_MoveByTitle(title, left, top, width, height) {
    return axc.ASAPP.AS_MoveByTitle(title, left, top, width, height);
}
//53
function AS_MoveToMonitorByTitle(title, monitorId) {
    return axc.ASAPP.AS_MoveToMonitorByTitle(title, monitorId);
}
//54
function AS_SetSignAlg(SignAlg,IsTS){
    return axc.ASAPP.AS_SetSignAlg(SignAlg,IsTS);
}
//55
function AS_SetPenAttr(Type,Color,Width){
    return axc.ASAPP.AS_SetPenAttr(Type,Color,Width);
}
//56
function AS_SetEvidenceCollectionModel(Modal){
    return axc.ASAPP.AS_SetEvidenceCollectionModel(Modal);
}
//57
function AS_Sign(BusinessData){
    return axc.ASAPP.AS_Sign(BusinessData);
}
//58
function AS_GetErrMsg(errorNo){
    return axc.ASAPP.AS_GetErrMsg(errorNo);
}
//59
function AS_GetInfoFromSignValue(signValue, dataType) {
    return axc.ASAPP.AS_GetInfoFromSignValue(signValue, dataType);
}
//60
function AS_CloseDlg(){
    return axc.ASAPP.AS_CloseDlg();
}
//61
function AS_SetPdfSignPos(posJson, index) {
    return axc.ASAPP.AS_SetPdfSignPos(posJson, index);
}
//62
function AS_MultSign(data, docName) {
    return axc.ASAPP.AS_MultSign(data, docName);   
}
//63
function AS_IdentityVerification() {
    return axc.ASAPP.AS_IdentityVerification();
}
//64
function AS_PCPreviewDev() {
    return axc.ASAPP.AS_PCPreviewDev();
}
//65
function AS_DevPreviewPC() {
    return axc.ASAPP.AS_DevPreviewPC();
}
//66
function AS_StopDevOperate() {
    return axc.ASAPP.AS_StopDevOperate();
}
//67
function AS_DocPush(filePath,fileType,timeOut,leftBtn,leftBtnTxt,midBtn,midBtnTxt,rightBtn,rightBtnTxt){
    return axc.ASAPP.AS_DocPush(filePath,fileType,timeOut,leftBtn,leftBtnTxt,midBtn,midBtnTxt,rightBtn,rightBtnTxt);
}
//68
//function AS_GetPushButton(){
//    return axc.ASAPP.AS_GetPushButton();
//}
//69
function AS_OpenWindowCopy(param){
    return axc.ASAPP.AS_OpenWindowCopy(param);
}
//70
function AS_CloseWindowCopy(){
    return axc.ASAPP.AS_CloseWindowCopy();
}
//71
function AS_TellerInfoDisplay(name,number,photoPath){
    return axc.ASAPP.AS_TellerInfoDisplay(name,number,photoPath);
}
//72
function AS_StartEvaluator(name,number,photoPath,timeout){
    return axc.ASAPP.AS_StartEvaluator(name,number,photoPath,timeout);
}
//73
function AS_AddEvidenceBase64(evidenceDataBase64, mimeType, bioType){
    return axc.ASAPP.AS_AddEvidenceBase64(evidenceDataBase64, mimeType, bioType);
}
//74
function AS_UpdateAD(){
    return axc.ASAPP.AS_UpdateAD();
}
//75
function AS_SetImageFormat(dataType,imgFormat){
    return axc.ASAPP.AS_SetImageFormat(dataType,imgFormat);
}
//76
function AS_OpenURL(url){
    return axc.ASAPP.AS_OpenURL(url);
}
//77
function AS_DigitKeyboard(msg,numlen,isHidenum){
    return axc.ASAPP.AS_DigitKeyboard(msg,numlen,isHidenum);
}
//78
function AS_GetDeviceStatus(){
    return axc.ASAPP.AS_GetDeviceStatus();
}

function getErrorMessage(ErrorCode)
{
    var errcode;
    var Message = "";
    if(typeof(ErrorCode) == 'string')
    {
        errcode = parseInt(ErrorCode);    
    }
    else
    {
        errcode = ErrorCode;    
    }
    switch (errcode)
    {
        case 0:
            Message = "成功";
            break;
        case 1:
            Message = '数据的json为空';
            break;
        case 2:
            Message = '输入的json解析失败';
            break;
        case 3:
            Message = 'IDCard解析失败';
            break;
        case 4:
            Message = 'IDCard不是object';
            break;
        case 5:
            Message = '证件类型不是字符串';
            break;
        case 6:
            Message = '证件号码不是字符串';
            break;
        case 7:
            Message = '指纹图片数据为空';
            break;
        case 8:
            Message = '手写轨迹图片为空';
            break;
        case 9:
            Message = 'DeviceID为空';
            break;
        case 10:
            Message = '获取手写图片失败';
            break;
        case 11:
            Message = '获取指纹图片失败';
            break;
        case 12:
            Message = '加密后BIO_FEATURE数据为空';
            break;
        case 13:
            Message = '加密BIO_FEATURE数据失败';
            break;
        case 14:
            Message = '签名人不是字符串';
            break;
        case 15:
            Message = 'init_XTX失败';
            break;
        case 16:
            Message = '获取的签名值为空';
            break;
        case 17:
            Message = '获取签名值失败';
            break;
        case 18:
            Message = '申请证书失败';
            break;
        case 19:
            Message = '时间戳为空';
            break;
        case 20:
            Message = '请求时间戳失败';
            break;
        case 21:
            Message = '打开安全签名板失败';
            break;
        case 22:
            Message = '事件证书为空';
            break;
        case 23:
            Message = '证书请求数据为空';
            break;
        case 24:
            Message = 'Init AnySignClient失败';
            break;
        case 25:
            Message = '手写轨迹数据为空';
            break;
        case 26:
            Message = '签名包数据为空';
            break;
        case 27:
            Message = '对称解密失败';
            break;
        case 28:
            Message = '对称解密返回数据为空';
            break;
        case 29:
            Message = '解析BioFeature失败';
            break;
        case 30:
            Message = '输入的签名包为空';
            break;
        case 31:
            Message = '输入的原文为空';
            break;
        case 32:
            Message = '解析输入的签名包数据格式错误';
            break;
        case 33:
            Message = '签名值验证失败';
            break;
        case 34:
            Message = '获取证书内容数据失败';
            break;
        case 35:
            Message = '使用不支持的图片格式';
            break;
        case 36:
            Message = '设置笔迹宽度和颜色失败';
            break;
        case 37:
            Message = '设置signDevice失败';
            break;
        case 38:
            Message = 'showdialog失败';
            break;
        case 39:
            Message = '获取手写指纹信息失败';
            break;
        case 40:
            Message = '设置adaptor对象失败';
            break;
        case 41:
            Message = '设置证件类型失败';
            break;
        case 42:
            Message = '设置证件号码失败';
            break;
        case 43:
            Message = '设置签名人姓名失败';
            break;
        case 44:
            Message = '设置原文数据失败';
            break;
        case 45:
            Message = '设置crypto对象失败';
            break;
        case 46:
            Message = '构造证书请求格式json失败';
            break;
        case 47:
            Message = '获取证书请求失败';
            break;
        case 48:
            Message = '签名包中EventCert为空';
            break;
        case 49:
            Message = '签名包中TSValue为空';
            break;
        case 50:
            Message = '输入的签名算法不是有效参数';
            break;
        case 51:
            Message = '获取签名包数据中指纹图片为空';
            break;
        case 52:
            Message = '获取签名包手写轨迹图片为空';
            break;
        case 53:
            Message = '计算Biofeature哈希失败';
            break;
        case 54:
            Message = 'Biofeatur哈希值为空';
            break;
        case 55:
            Message = '设置bio_hash失败';
            break;
        case 56:
            Message = '获取证书中BIO_HASH失败';
            break;
        case 57:
            Message = '或者证书BIO_HASH内容为空';
            break;
        case 58:
            Message = '比较证书BIO_HASH失败';
            break;
        case 59:
            Message = '没有检测到签名设备';
            break;
        case 60:
            Message = '签名设备不是安全签名板,当前只支持安全签名板';
            break;
        case 61:
            Message = '用户取消签名';
            break;
        case 62:
            Message = '获取证书签名人失败';
            break;
        case 63:
            Message = '获取证书签名人为空';
            break;
        case 64:
            Message = '证件类型不正确';
            break;
        case 65:
            Message = '解析后的json不是json object';
            break;
        case 66:
            Message = '签名时间数据为空';
            break;
        case 67:
            Message = '创建签名句柄失败';
            break;
        case 68:
            Message = '输入的签名句柄为空';
            break;
        case 69:
            Message = '调用sign_begin接口失败';
            break;
        case 70:
            Message = '输入的文件名为空';
            break;
        case 71:
            Message = 'base64解码失败';
            break;
        case 72:
            Message = '输入的文件太大，无法签名或者验证。';
            break;
        case 73:
            Message = '未输入签名人姓名';
            break;
        case 74:
            Message = '未输入签名人证件信息';
            break;
        case 75:
            Message = '输入的时间戳签名值为空';
            break;
        case 76:
            Message = '输入的时间戳原文为空';
            break;
        case 77:
            Message = '格式化时间戳时间失败';
            break;
        case 78:
            Message = '验证时间戳签名失败';
            break;
        case 79:
            Message = '读取文件内容失败';
            break;
        case 80:
            Message = '验证证书有效性失败（三级根配置不正确也会导致此错误）';
            break;
        case 81:
            Message = '获取时间戳原文为空';
            break;
        case 82:
            Message = '对图像进行缩放发生错误';
            break;
        case 83:
            Message = '对图像进行格式转换发生错误';
            break;
        case 84:
            Message = '未连接扩展屏';
            break;
        case 85:
            Message = '不支持的扩展屏型号';
            break;
        case 86:
            Message = '解析证书中的哈希值失败';
            break;
        case 87:
            Message = '比较证书中的哈希与手写笔迹哈希失败';
            break;
        case 88:
            Message = '设置签名对话框宽度不正确';
            break;
        case 89:
            Message = '加载UI的配置文件错误';
            break;
        case 90:
            Message = '获取照片失败';
            break;
        case 91:
            Message = '获取视频失败';
            break;
        case 92:
            Message = '打开摄像头失败';
            break;
        case 93:
            Message = '拍照失败';
            break;
        case 94:
            Message = '拍照路径确认失败';
            break;
        case 95:
            Message = '录音路径失败';
            break;
        case 96:
            Message = '录像存储路径获取失败';
            break;
        case 97:
            Message = '打开麦克风失败';
            break;
        case 98:
            Message = '未找到编码器xvid';
            break;
        case 99:
            Message = '签名板未打开';
            break;
        case 100:
            Message = '签名板已经打开';
            break;
        case 101:
            Message = '访问签名板失败';
            break;
        case 102:
            Message = '签名板服务程序未启动';
            break;
        case 103:
            Message = '签名板服务程序错误';
            break;
        case 104:
            Message = '签名板被移除';
            break;
        case 105:
            Message = '缺少证据信息';
            break;
        case 106:
            Message = '控件窗口句柄为空';
            break;
        case 107:
            Message = '未检测到加密芯片(签字板560/370  汉王签名屏9011)';
            break;
        case 108:
            Message = '设置的配置项参数为空';
            break;
        case 109:
            Message = '不支持的修改的配置项';
            break;
        case 110:
            Message = '本次签名证据hash信息不正确';
            break;
        case 119:
            Message = '签名人"不同意"协议，拒绝签名';
            break;
        case 1079:
            Message = "通常是网络问题";
            break;
        case 16790018:
            Message = "签名人'不同意'协议，拒绝签名";
            break;
        case 16777217:
            Message = "传入的参数为空值";
            break;
        case 16777218:
            Message = "生成guid出错";
            break;
        case 16777219:
            Message = "找不到guid";
            break;
        case 16777220:
            Message = "暂时还没有成功的签名，guid为空";
            break;
        case 16777221:
            Message = "没有设置工单号";
            break;
        case 16777222:
            Message = "没有设置渠道号";
            break;
        case 16777223:
            Message = "没有设置生成pdf的数据";
            break;
        case 16777224:
            Message = "外设签名信息，数据包中没有签名信息。";
            break;
        case 16777225:
            Message = "外设签名信息，数据包中签名信息太多，超过了一张。";
            break;
        case 16777226:
            Message = "json对象不是string类型";
            break;
        case 16777227:
            Message = "签名类型出错，0为pdf签名，1位数据签名，用户输入了错误的类型";
            break;
        case 16777228:
            Message = "签名规则为空";
            break;
        case 16777229:
            Message = "设置业务类型出错";
            break;
        case 16777230:
            Message = "设置超时时长小于等于0";
            break;
        case 16777231:
            Message = "设置签名坐标错误";
            break;
        case 16777232:
            Message = "签名证据数据为空";
            break;
        case 16777233:
            Message = "输入的证据哈希为空";
            break;
        case 16777234:
            Message = "输入的证据哈希对应的原文mime类型为空";
            break;
        case 16777235:
            Message = "输入的证据哈希对应的原文mime类型不支持";
            break;
        case 16777236:
            Message = "输入的证据类型为空";
            break;
        case 16777237:
            Message = "手写图片格式不对";
            break;
        case 16777238:
            Message = "手写签名图片内容为空";
            break;
        case 16777239:
            Message = "批注图片格式不对";
            break;
        case 16777240:
            Message = "批注图片错误";
            break;
        case 16777241:
            Message = "指纹图片格式错误";
            break;
        case 16777242:
            Message = "指纹图片内容为空";
            break;
        case 16777243:
            Message = "拍照图片格式错误";
            break;
        case 16777244:
            Message = "照片为空";
            break;
        case 16777245:
            Message = "视频为空";
            break;
        case 16777246:
            Message = "音频为空";
            break;
        case 16777247:
            Message = "解压缩手写轨迹时失败";
            break;
        case 16777248:
            Message = "获取手写签名图片失败";
            break;
        case 16777249:
            Message = "获取指纹图片失败";
            break;
        case 16777250:
            Message = "获取手写和指纹相关信息失败";
            break;
        case 16777251:
            Message = "获取照片证据失败";
            break;
        case 16777252:
            Message = "获取音频证据失败";
            break;
        case 16777253:
            Message = "获取视频证据失败";
            break;
        case 16777254:
            Message = "手写签名轨迹数据为空";
            break;
        case 16777255:
            Message = "批注内容为空";
            break;
        case 16777256:
            Message = "批注合并数目错误";
            break;
        case 16777257:
            Message = "批注图片为空";
            break;
        case 16777258:
            Message = "设置批注坐标错误";
            break;
        case 16777259:
            Message = "获取采集到的批注图片失败";
            break;
        case 16777260:
            Message = "没有添加手写签名";
            break;
        case 16777261:
            Message = "加密包为空";
            break;
        case 16777262:
            Message = "签名值中的数据类型出错";
            break;
        case 16777263:
            Message = "签名值为空";
            break;
        case 16777264:
            Message = "压缩数据为空";
            break;
        case 16777265:
            Message = "内部证据数据为空";
            break;
        case 16777266:
            Message = "用户取消签名";
            break;
        case 16777267:
            Message = "显示签名对话框失败";
            break;
        case 16777268:
            Message = "获取加密包数据失败";
            break;
        case 16777269:
            Message = "输入文件路径错误";
            break;
        case 16777270:
            Message = "base64解码失败";
            break;
        case 16777271:
            Message = "读取文件失败";
            break;
        case 16777272:
            Message = "输入的数据内容为空";
            break;
        case 16777273:
            Message = "输入的数据长度为0";
            break;
        case 16777274:
            Message = "没有输入签名人姓名";
            break;
        case 16777275:
            Message = "没有输入签名人的证件类型";
            break;
        case 16777276:
            Message = "没有输入签名人的证件号码";
            break;
        case 16777277:
            Message = "输入的证据MimeType不支持";
            break;
        case 16777278:
            Message = "没有输入证据数据";
            break;
        case 16777279:
            Message = "用户操作超时";
            break;
        case 16777280:
            Message = "获取扩展屏坐标失败";
            break;
        case 16777281:
            Message = "渠道号长度超过限制，最多20个字符";
            break;
        case 16777282:
            Message = "渠道号必须由数字组成";
            break;
        case 16777283:
            Message = "签名控件窗口未能创建，非IE浏览器不支持此接口";
            break;
        case 16777284:
            Message = "UTF-8转换到Ansi失败";
            break;
        case 16777285:
            Message = "不支持的编码类型";
            break;
        case 16777286:
            Message = "不支持的哈希算法";
            break;
        case 16777287:
            Message = "输入签名文件名为空";
            break;
        case 16777288:
            Message = "输入文件内容为空";
            break;
        case 16777289:
            Message = "输入文件内容长度为0";
            break;
        case 16777290:
            Message = "输入的路径名不合法";
            break;
        case 16777291:
            Message = "输入的路径不存在";
            break;
        case 16777292:
            Message = "写文件出现错误";
            break;
        case 16777293:
            Message = "目录不具有写权限";
            break;
        case 16777294:
            Message = "打开摄像头失败";
            break;
        case 16777295:
            Message = "拍照失败";
            break;
        case 16777296:
            Message = "访问照片存储路径失败";
            break;
        case 16777297:
            Message = "访问音频存储路径失败";
            break;
        case 16777298:
            Message = "访问视频存储路径失败";
            break;
        case 16777299:
            Message = "打开Mic失败，请查看设备是否正常连接";
            break;
        case 16777300:
            Message = "没有安装相应的视屏编码器";
            break;
        case 16777301:
            Message = "输入的工单号为空";
            break;
        case 16777302:
            Message = "输入的工单号信息无内容";
            break;
        case 16777303:
            Message = "输入的渠道号为空";
            break;
        case 16777304:
            Message = "输入的渠道号信息无内容";
            break;
        case 16777305:
            Message = "输入的关键字为空";
            break;
        case 16777306:
            Message = "输入的关键字信息无内容";
            break;
        case 16777307:
            Message = "输入了错误的PDF数据类型";
            break;
        case 16777308:
            Message = "输入的PDF数据为空";
            break;
        case 16777309:
            Message = "签名笔迹轨迹为空";
            break;
        case 16777310:
            Message = "输入的服务器应用名为空";
            break;
        case 16777311:
            Message = "输入的单位签章图片为空";
            break;
        case 16777312:
            Message = "设置的对话框窗口无效，已超出屏幕范围";
            break;
        case 16777313:
            Message = "加载对话框界面出现错误";
            break;
        case 16777314:
            Message = "关键字长度超出限制";
            break;    
        case 16777315:
            Message = "拍照路径不可写";
            break;    
        case 16777316:
            Message = "录音路径不可写";
            break;
        case 16777317:
            Message = "录像路径不可写";
            break;
        case 16777318:
            Message = "设置的配置项参数为空";
            break;
        case 16777319:
            Message = "不支持的修改的配置项";
            break;
        case 16777320:
            Message = "获取操作系统信息失败";
            break;
        case 16777321:
            Message = "计算哈希值失败";
            break;
        case 16777322:
            Message = "释放签名或批注窗口失败";
            break;
        case 16777323:
            Message = "连接手写签名设备失败";
            break;
        case 16777324:
            Message = "断开手写签名设备失败";
            break;    
        case 16777325:
            Message = "获取手写签名设备状态失败";
            break;    
        case 16777326:
            Message = "获取指纹仪设备状态失败";
            break;
        case 16777327:
            Message = "设置窗口句柄失败";
            break;
        case 16777328:
            Message = "数据的json为空";
            break;
        case 16777329:
            Message = "输入的json解析失败";
            break;
        case 16777330:
            Message = "获取签名值失败";
            break;
        case 16777331:
            Message = "申请证书失败";
            break;
        case 16777332:
            Message = "解析BioFeature失败";
            break;
        case 16777333:
            Message = "输入的签名包为空";
            break;
        case 16777334:
            Message = "输入的原文为空";
            break;    
        case 16777335:
            Message = "解析输入的签名包数据格式错误";
            break;    
        case 16777336:
            Message = "签名值验证失败";
            break;
        case 16777337:
            Message = "获取证书内容数据失败";
            break;
        case 16777338:
            Message = "签名包中EventCert为空";
            break;
        case 16777339:
            Message = "签名包中TSValue为空";
            break;
        case 16777340:
            Message = "输入的签名算法不是有效参数";
            break;
        case 16777341:
            Message = "获取签名包数据中指纹图片为空";
            break;
        case 16777342:
            Message = "获取签名包手写图片为空";
            break;
        case 16777343:
            Message = "Biofeatur哈希值为空";
            break;
        case 16777344:
            Message = "获取证书扩展项失败";
            break;    
        case 16777345:
            Message = "比较证书BIO_HASH失败";
            break;    
        case 16777346:
            Message = "获取证书签名人失败";
            break;
        case 16777347:
            Message = "证件类型不正确";
            break;
        case 16777348:
            Message = "解析后的json不是json object";
            break;
        case 16777349:
            Message = "输入的文件太大，无法签名或者验证。";
            break;
        case 16777350:
            Message = "输入的时间戳签名值为空";
            break;
        case 16777351:
            Message = "输入的时间戳原文为空";
            break;
        case 16777352:
            Message = "格式化时间戳时间失败";
            break;
        case 16777353:
            Message = "验证时间戳签名失败";
            break;
        case 16777354:
            Message = "验证证书有效性失败（三级根配置不正确也会导致此错误）";
            break;    
        case 16777355:
            Message = "获取时间戳原文为空";
            break;    
        case 16777356:
            Message = "解析证书中的哈希值失败";
            break;
        case 16777357:
            Message = "比较证书中的哈希与手写笔迹哈希失败";
            break;
        case 16777358:
            Message = "指纹和照片必须存在一种";
            break;
        case 16777359:
            Message = "设置任意内容签字时，初始界面显示行数错误，取值范围在1~10之间 ";
            break;
        case 16777360:
            Message = "获取签名包数据中拍照图片为空";
            break;
        case 16777361:
            Message = "手写签名设备已连接，不能重复连接";
            break;
        case 16777362:
            Message = "对图像进行缩放发生错误";
            break;
        case 16777363:
            Message = "对图像进行格式转换发生错误";
            break;
        case 16777364:
            Message = "获取签名包数据中批注数据为空";
            break;
        case 16777365:
            Message = "获取证书ID失败";
            break;
        case 16777366:
            Message = "本次签名证据hash信息不正确";
            break;
        case 16777367:
            Message = "外设手写轨迹格式错误";
            break;
        case 16777368:
            Message = "不支持的外设证据类型";
            break;
        case 16777369:
            Message = "签名图片宽高设置错误";
            break;
        case 16777370:
            Message = "输入的索引号错误，签名包中找不到对应的签名值";
            break;    
        case 16777371:
            Message = "输入的加密包格式错误";
            break;    
        case 16777372:
            Message = "加密包中的签名超过数量";
            break;    
        case 16777373:
            Message = "加密包中的批注超过数量";
            break;    
        case 16777374:
            Message = "身份证信息为空";
            break;    
        case 16777375:
            Message = "答题信息为空";
            break;    
        case 16777376:
            Message = "设置签名框大小";    
            break;    
        case 16777377:
            Message = "工单号超过最大长度";
            break;    
        case 16777378:
            Message = "签名人姓名超过最大长度";    
            break;    
        case 16777379:
            Message = "证件号码超过最大长度";
            break;    
        case 16777380:
            Message = "外设签名证据数据超过最大长度";
            break;                    
        case 16777381:
            Message = "批注内容数据超过最大长度";
            break;    
        case 16777382:
            Message = "获取签名证据类型错误";    
            break;    
        case 16777383:
            Message = "guid超过最大长度";
            break;    
        case 16777384:
            Message = "添加的证据哈希超过最大长度";    
            break;    
        case 16777385:
            Message = "添加的证据哈希MIMETYPE超过最大长度";
            break;    
        case 16777386:
            Message = "添加的证据哈希BIOTYPE超过最大长度";
            break;                    
        case 16777387:
            Message = "加密包超过最大长度";
            break;    
        case 16777388:
            Message = "PDF生成数据的模板号超过最大长度";
            break;                    
        case 16777389:
            Message = "单位签章图片超过最大长度";
            break;    
        case 16777390:
            Message = "服务器应用名超过最大长度";    
            break;    
        case 16777391:
            Message = "签名包超过最大长度";
            break;    
        case 16777392:
            Message = "时间戳签名值超过最大长度";    
            break;    
        case 16777393:
            Message = "时间戳原文超过最大长度";
            break;    
        case 16777394:
            Message = "输入文件路径超过最大长度";
            break;    
        case 16777395:
            Message = "设置窗口大小错误";
            break;    
        case 16777396:
            Message = "配置项数据超过最大长度";
            break;    
        case 16777397:
            Message = "展示文件类型错误";
            break;    
        case 16777398:
            Message = "图片宽度设置错误，要大于0";                
            break;
        case 16777399:
            Message = "设置服务器地址失败";                
            break;
        case 16777400:
            Message = "创建pdfcom组件失败";                
            break;
        case 16777401:
            Message = "获取P7数据失败";                
            break;
        case 16777402:
            Message = "pdf签名合章失败";                
            break;
        case 16777403:
            Message = "pdf签名获取hash失败";                
            break;
        case 16777404:
            Message = "写临时文件失败";                
            break;
        case 16777405:
            Message = "pdf签名获取hash失败";                
            break;
        case 16777406:
            Message = "手写轨迹ocr识别模式设置失败";                
            break;
        case 16777407:
            Message = "获取手写轨迹文字结果失败";                
            break;
        case 16777408:
            Message = "启用ocr识别失败";                
            break;
        case 16777409:
            Message = "未找到要移动的窗口";                
            break;
        case 16777410:
            Message = "算法参数错误";                
            break;
        case 16777411:
            Message = "笔类型参数错误";                
            break;
        case 16777412:
            Message = "证据采集模式参数错误";                
            break;
        case 16777413:
            Message = "合规检查功能调用错误";                
            break;
        case 16777414:
            Message = "入参越界";                
            break;
        case 16777415:
            Message = "用户未同意签名前告知条款";                
            break;
        case 16785417:
            Message = "批注对话框超时";                
            break;
        case 16789764:
            Message = "用户取消了签名";                
            break;
        case 16789774:
            Message = "ocr请求发送失败 ";                
            break;
        case 16789775:
            Message = "未启用ocr识别";    
            break;
        case 16789776:
            Message = "客户端输入签名人姓名与服务器返回的识别文字匹配失败";                
            break;
        case 16789777:
            Message = "ocr服务器返回错误";                
            break;
        case 16789778:
            Message = "服务器返回的业务号与客户端匹配失败";                
            break;    
        case 16789765:
            Message = "对话框超时";                
            break;                
        case 16789779:
            Message = "ocr识别次数设置错误";                
            break;
        case 16789780:
            Message = "获取到的识别文字为空";                
            break;
        case 16793601:
            Message = "没有检测到设备";    
            break;
        case 16777416:
            Message = "统一签名接口解析json入参失败,请确认是否漏传数据";    
            break;
        case 16777416:
            Message = "统一签名接口解析json入参失败,请确认是否漏传数据";    
            break;
        case 16789518:
            Message = "身份核验失败";                
            break;
        default:
            Message = "未知错误：";
            break;
    }
    return Message + " 错误码：" + ErrorCode;
}

///////////////////////////////////////////////////////////上面为CA所需环境或支持方法初始化/////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////下面为病历所需逻辑方法封装////////////////////////////////////////////////////////////

///医为浏览器逻辑
var handSignInterface_CHROME = {
    checkStatus: function () {
        if (typeof(axc.ASAPP) == "undefined")
	    {
		    alert("加载ASAppCOM控件失败，请确认已正确安装信手书插件!");
		    return false;
		}
        
        var rv = AS_GetVersion();
        if ("" == rv) {
            var ret = AS_GetLastError();
            alert("患者签名本地服务接口异常：" + getErrorMessage(ret));
            return false;
        }
        AS_CloseDlg();
        return true;
    },
    getEvidenceData: function (signerInfo, imgType) {
        
        //初始化所有签名数据并声明签名类型
        var signType = "1";
        var ret = AS_InitSign(signType);
        if (0 != ret) {
            alert("初始化所有签名数据并声明签名类型失败");
            return "";
        }
        
        //设置超时时间
        var timeOut = 60;
        var rv = AS_SetTimeout(timeOut);
        if (0 != rv) {
            alert("设置签名对话框的超时时间失败 ：" + getErrorMessage(rv));
            return "";
        } 
        
        //设置渠道号
        var tChannel = "999999";    //999999 测试渠道号
        var ret = AS_SetBusinessParam(2, tChannel);
        if (0 != ret) {
            alert("设置渠道号失败");
            return "";
        }
        
        //设置原文数据
        var plain = "准备采集签名证据";
        var charCoding = "GBK";
        var ret = AS_Base64Encode(plain, charCoding);
        if(ret==""){
            ret = AS_GetLastError();
            alert("原文内容为空 : " + getErrorMessage(ret));
            return "";
        }
        ret = AS_SetSignPlain(ret);
        if(ret!=0){
            alert("设置签名数据原文错误 : " + getErrorMessage(ret));
            return "";
        }
        
        //设置签名图片格式
        //0>GIF 1>JPG
        var _imgType = (imgType || 'GIF') === 'JPG' ? 1 : 0;
        var dataType = "0";   // 0 手写签名   1 批注
        var result = AS_SetImageFormat(dataType, _imgType);
        if (result != 0) {
            GetLastError("SetScriptImageFormat_res", "设置手写图片格式失败");
            return "";
        }
        
        //设置签名人信息数据
        signerInfo = signerInfo || {
            'Signer': 'Patient',
            'IDCard': {
                'Type': '1',
                'Number': '0'
            }
        };
        var tUName = signerInfo.Signer;
        var tIDType = signerInfo.IDCard.Type;
        var tIDNumber = signerInfo.IDCard.Number;
        var rv = AS_SetSignerInfo(tUName, tIDType, tIDNumber);
        if (0 != rv) {
            alert("设置签名人信息错误 : " + getErrorMessage(rv));
            return;
        }
        
        //采集签名证据
        var rv = AS_AddSignEvidenceData();
        if (0 != rv) {
            alert("采集签名证据数据错误 : " + getErrorMessage(rv));
            return "";
        } 
        
        //获取证据数据
        var evidenceType = "0"; //签名图
        var signScript = AS_GetSignEvidenceData(evidenceType);
        evidenceType = "2"; //指纹图
        var fingerPrint = AS_GetSignEvidenceData(evidenceType);
        evidenceType = "3"; //拍照图
        var headerImage = AS_GetSignEvidenceData(evidenceType);
        
        //alert("signScript:" + signScript.length);
        //alert("fingerPrint" + fingerPrint.length);
        
        return {
            signScript: signScript,
            fingerPrint: fingerPrint,
            signPhoto: headerImage||"",
            evidenceHash: ""
        };
    },
    getSignDataValue: function (evidenceHash, plainData) {
        if(plainData==""){
            alert("待签原文内容不能为空");
            return "";
        }
        
        var charCoding = "GBK";
        var toSignBase64 = AS_Base64Encode(plainData, charCoding);
        if(toSignBase64==""){
            ret = AS_GetLastError();
            alert("原文内容Base64编码失败 : " + getErrorMessage(ret));
            return "";
        }
        
        ret = AS_SetSignPlain(toSignBase64);
        if(ret!=0){
            alert("设置签名数据原文错误 : " + getErrorMessage(ret));
            return "";
        }
        
        //获取加密包
        var tStrEnPkg = AS_GetBusinessString();
        if (tStrEnPkg == "") {
            var rv = AS_GetLastError();
            alert("获取加密包失败 : " + getErrorMessage(rv));
            return "";
        } 
        //alert("tStrEnPkg:"+tStrEnPkg.length);
        
        //获取签名包
        var tStrSignPackage = AS_GetSignPackage(tStrEnPkg);
        if ("" == tStrSignPackage) {
            var rv = AS_GetLastError();
            alert("获取服务端签名包失败 : " + getErrorMessage(rv));
            return "";
        } 
        ///alert("SignPackage:"+tStrSignPackage.length);
        
        //验证签名包
        var status = AS_VerifySign(tStrSignPackage, toSignBase64);
        if ("0" != status) {
            var rv = AS_GetLastError();
            alert("验证签名包失败 : " + getErrorMessage(rv));
            return "";
        } 
        ///alert("验证签名包结果:" + status);
        return tStrSignPackage;
    },
    getNotation: function(content,imgType) {
        try {
	        
	        //初始化所有签名数据并声明签名类型
	        var signType = "1";
	        var ret = AS_InitSign(signType);
	        if (0 != ret) {
	            throw {
                    name: 'AS_SetTimeout',
                    message: "初始化所有签名数据并声明签名类型失败"
                }
	        }
	        
            //设置超时时间
            var timeOut = 60;
            var rv = AS_SetTimeout(timeOut);
            if (0 != rv) {
                throw {
                    name: 'AS_SetTimeout',
                    message: "设置签名对话框的超时时间失败 : " + getErrorMessage(rv)
                }
            } 
            
            //设置渠道号
	        var tChannel = "999999";    //999999 测试渠道号
	        var ret = AS_SetBusinessParam(2, tChannel);
	        if (0 != ret) {
	            throw {
                    name: 'AS_SetBusinessParam',
                    message: "设置渠道号失败 : " + getErrorMessage(ret)
                }
	        }
            
            //设置签名图片格式
            //0>GIF 1>JPG
            var _imgType = (imgType || 'GIF') === 'JPG' ? 1 : 0;
            var dataType = "1";   // 0 手写签名   1 批注
            var result = AS_SetImageFormat(dataType, _imgType);
            if (result != 0) {
                throw {
                    name: 'AS_SetImageFormat',
                    message: "设置手写图片格式失败 : " + getErrorMessage(result)
                }
            }
            
            var imageNumber = 2;
            var contentLength = content.length
            if (contentLength <= 20) {
	        	imageNumber = contentLength;   
	        }else {
		    	imageNumber = 20;      
		    }
            
            if(content!="") {
                var rv = AS_AddMulWord(content, imageNumber);
            } else { //非抄写模式不能使用太高的图片合成张数，一般与行数相等即可
                var rv = AS_AddMulWord('', 3);
            }
            if (0 != rv) {
                throw {
                    name: 'AS_AddMulWord',
                    message: "采集批注数据错误 : " + getErrorMessage(rv)
                }
			}
        } catch(e) { //alert(e.message);
            throw {
                name: '一般性错误',
                message: e.message
            }
        }

        var retNotation =  AS_GetSignEvidenceData(1);  //批注
        if (retNotation == "") {
            if (AS_GetLastError() == 61) { 
                throw {
                    name: '61',
                    message: "用户取消添加意见"
                }
            } else {
                throw {
                    name: AS_GetLastError(),
                    message: getErrorMessage(AS_GetLastError())
                }
            }
            return "";
        }
        return retNotation;
    },
    getSignScript: function (evidenceData) {
        if (evidenceData.signScript) {
            var ret = AS_ResizeImage(evidenceData.signScript, 100, 0)    ////图片格式 0:gif 1:jpg 2：png 
            if ("" == ret) {
            var rv = AS_GetLastError();
	            alert("压缩图片大小失败 : " + getErrorMessage(rv));
	            return "";
	        } 
            return ret;
        } else {
            return '';
        }
    },
    getSignFingerprint: function (evidenceData) {
        if (evidenceData.fingerPrint) {
	        if (evidenceData.fingerPrint == "") return "";
	        
            var ret = AS_ResizeImage(evidenceData.fingerPrint, 100, 0)    ////图片格式 0:gif 1:jpg 2：png 
            if ("" == ret) {
            var rv = AS_GetLastError();
	            alert("压缩图片大小失败 : " + getErrorMessage(rv));
	            return "";
	        } 
            return ret;
        } else {
            return '';
        }
    },
    getSignPhoto: function (evidenceData) {
        if (evidenceData.signPhoto) {
            if (evidenceData.signPhoto == "") return "";
	        
            var ret = AS_ResizeImage(evidenceData.signPhoto, 100, 0)    ////图片格式 0:gif 1:jpg 2：png 
            if ("" == ret) {
            var rv = AS_GetLastError();
	            alert("压缩图片大小失败 : " + getErrorMessage(rv));
	            return "";
	        } 
            return ret;
        } else {
            return '';
        }
    },
    getSignHash: function (evidenceData) {
        if (evidenceData.evidenceHash) {
            return evidenceData.evidenceHash;
        } else {
            return '';
        }
    },
    getAlgorithm: function (signValue) {
        return signValue.SigValue[0].Algorithm;
    },
    getBioFeature: function (signValue) {
        return signValue.SigValue[0].BioFeature;
    },
    getEventCert: function (signValue) {
        return signValue.SigValue[0].EventCert;
    },
    getSigValue: function (signValue) {
        return signValue.SigValue[0].SigValue;
    },
    getTSValue: function (signValue) {
        return signValue.SigValue[0].TSValue;
    },
    getVersion: function (signValue) {
        return signValue.SigValue[0].Version;
    },
    getUsrID: function (evidenceData) {
        return this.getSignHash(evidenceData) + (new Date()).getTime();
    },
    setDlgPos : function() {
        //获取扩展屏幕坐标
        //var tStrPos = anysign.get_extend_screen_pos();
        var tStrPos = AS_GetExtendScreenPos();
        if ('' === tStrPos) {
            //兼容大屏设备和wcom设备
            //var rv = anysign.getLastError();
            var rv = AS_GetLastError();
            alert("AS_GetExtendScreenPos error : " + rv + getErrorMessage(rv));
            return;

            var width = screen.availWidth;
            var height = screen.availHeight;
            tStrPos = '{"bottom" : ' + height + ',"left" : 0,"right" : ' + width + ',"top" : 0}';
        }
        var tJsonPos = JSON.parse(tStrPos);

        var posX = (tJsonPos.right - tJsonPos.left - 1230) / 2 + tJsonPos.left;
        var posY = (tJsonPos.bottom - tJsonPos.top - 478) / 2 + tJsonPos.top;
        if (posX <= 0) { posX = 100; }
        if (posY <= 0) { posY = 100; }

        //var rv = anysign.set_dlg_pos(posX, posY);
        var rv = AS_SetDlgPos(posX, posY);
        if (rv !== 0) {
            errMsg = getErrorMessage(rv);
            if ('' !== errMsg)
                throw {
                    name: 'set_dlg_pos',
                    message: errMsg
                }
        }
    }
};

///IE浏览器逻辑
var handSignInterface_IE = {
    checkStatus: function () {
        if (!anysign)
            return false;
        return true;
    },
    getEvidenceData: function (signerInfo, imgType) {

        signerInfo = signerInfo || {
            'Signer': 'Patient',
            'IDCard': {
                'Type': '1',
                'Number': '0'
            }
        };
        var _signerInfo = JSON.stringify(signerInfo);
        //0>GIF 1>JPG
        var _imgType = (imgType || 'GIF') === 'JPG' ? 1 : 0;

        var errMsg = '';
        var rv;
        //连接设备
        rv = anysign.connect_sign_device();
        if (rv == -1) {
            throw {
                name: 'connect_sign_device',
                message: '连接设备失败！'
            }
        }
        
        //设置对话框显示位置：
        //this.setDlgPos();

        rv = anysign.set_script_type(_imgType);

        //签名
        var evidenceValue = anysign.get_evidence_data(_signerInfo);
        if ('' == evidenceValue) {
            errMsg = getErrorMessage(anysign.getLastError());
            if ('' != errMsg)
                throw {
                    name: 'get_evidence_data',
                    message: errMsg
                }
        } else {
            //alert('获取成功！');
            return JSON.parse(evidenceValue);
        }
    },
    setDlgPos : function() {
        //获取扩展屏幕坐标
        var tStrPos = anysign.get_extend_screen_pos();
        if ('' === tStrPos) {
            //兼容大屏设备和wcom设备
            var rv = anysign.getLastError();
            alert("get_extend_screen_pos error : " + rv + getErrorMessage(rv));
            return;

            var width = screen.availWidth;
            var height = screen.availHeight;
            tStrPos = '{"bottom" : ' + height + ',"left" : 0,"right" : ' + width + ',"top" : 0}';
        }
        var tJsonPos = JSON.parse(tStrPos);

        var posX = (tJsonPos.right - tJsonPos.left - 1230) / 2 + tJsonPos.left;
        var posY = (tJsonPos.bottom - tJsonPos.top - 478) / 2 + tJsonPos.top;
        if (posX <= 0) { posX = 100; }
        if (posY <= 0) { posY = 100; }

        var rv = anysign.set_dlg_pos(posX, posY);
        if (rv !== 0) {
            errMsg = getErrorMessage(rv);
            if ('' !== errMsg)
                throw {
                    name: 'set_dlg_pos',
                    message: errMsg
                }
        }
    },
    getSignDataValue: function (evidenceHash, plainData) {

        var errMsg = '';
        evidenceHash = evidenceHash || '';
        plainData = plainData || '';
        if ('' == evidenceHash) {
            throw {
                name: 'evidenceHash',
                message: '证据hash不能为空！'
            };
        }
        if ('' == plainData) {
            throw {
                name: 'plainData',
                message: '签名原文不能为空！'
            };
        }
        plainData = anysign.Base64Encode(plainData, 'GBK');

        var sign_value = anysign.get_sign_data_value(evidenceHash, plainData);
        if ('' == sign_value) {
            errMsg = getErrorMessage(anysign.getLastError());
            if ('' != errMsg)
                throw {
                    name: 'get_sign_data_value',
                    message: errMsg
                };
        }
        //alert('签名成功');
        return sign_value;
    },
    getNotation: function(content,imgType) {
        try {
            //0>GIF 1>JPG
            //var _imgType = (imgType || 'GIF') === 'JPG' ? 1 : 0;
            var _imgType = 1;
            var errMsg = '';
            var rv;
            //连接设备
            rv = anysign.connect_sign_device();
            if (rv == -1) {
                throw {
                    name: 'connect_sign_device',
                    message: '连接设备失败！'
                }
            }
            
            //设置对话框显示位置：
        	//this.setDlgPos();

        	//设置对话框显示位置：
        	rv = anysign.set_script_type(_imgType);
            var _content = content||"";
            
            var imageNumber = 2;
            var contentLength = content.length
            if (contentLength <= 20) {
	        	imageNumber = contentLength;   
	        }else {
		    	imageNumber = 20;      
		    }
            
            if(_content!="") {
                anysign.set_notation_content(_content);
                anysign.set_megerimage_number(imageNumber);
            } else { //非抄写模式不能使用太高的图片合成张数，一般与行数相等即可
                anysign.set_megerimage_number(3);
            }
            anysign.set_line_count(3);
        } catch(e) { //alert(e.message);
            throw {
                name: '一般性错误',
                message: e.message
            }
        }
        var retNotation =  anysign.add_script_notation();
        if (retNotation == "") {
            if (anysign.getLastError()==61) { 
                //alert("用户取消添加意见"); 
                throw {
                    name: '61',
                    message: "用户取消添加意见"
                }
            } else {
                //alert(this.getErrorMessage(anysign.getLastError()));
                throw {
                    name: anysign.getLastError(),
                    message: this.getErrorMessage(anysign.getLastError())
                }
            }
            return "";
        }
        return retNotation;
    },
    getSignScript: function (evidenceData) {
        for (var i = 0, max = evidenceData.Evidence.length; i < max; i++) {
            if (evidenceData.Evidence[i].Type === '0')
                return evidenceData.Evidence[i].Content;
        }
        return '';
    },
    getSignFingerprint: function (evidenceData) {
        for (var i = 0, max = evidenceData.Evidence.length; i < max; i++) {
            if (evidenceData.Evidence[i].Type === '1')
                return evidenceData.Evidence[i].Content;
        }
        return '';
    },
    getSignPhoto: function (evidenceData) {
        for (var i = 0, max = evidenceData.Evidence.length; i < max; i++) {
            if (evidenceData.Evidence[i].Type === '2')
                return evidenceData.Evidence[i].Content;
        }
        return '';
    },
    getSignHash: function (signValue) {
        return signValue.Hash;
    },
    getAlgorithm: function (signValue) {
        return signValue.SigValue[0].Algorithm;
    },
    getBioFeature: function (signValue) {
        return signValue.SigValue[0].BioFeature;
    },
    getEventCert: function (signValue) {
        signValue = JSON.stringify(signValue);
        return anysign.get_sign_cert(signValue);
    },
    getSigValue: function (signValue) {
        return signValue.SigValue[0].SigValue;
    },
    getTSValue: function (signValue) {
        //return signValue.SigValue.TSValue;
        signValue = JSON.stringify(signValue)
        return anysign.get_ts_value(signValue);
    },
    getVersion: function (signValue) {
        return anysign.get_version();
    },
    getUsrID: function (evidenceData) {
        return this.getSignHash(evidenceData) + (new Date()).getTime();
    }
};

var handSignInterface = "";
if(!!window.ActiveXObject || "ActiveXObject" in window) {
    handSignInterface = handSignInterface_IE;
} else {
    handSignInterface = handSignInterface_CHROME;
}

var handSign = {
    getIDInfo: function(episodeID) {
		var result = {idType:"",idNumber:"",Name:""};
		$.ajax({
			type: 'GET',
			dataType: 'text',
			url: '../EMRservice.Ajax.common.cls',
			async: false,
			cache: false,
			data: {
				"OutputType":"String",
				"Class":"EMRservice.Ajax.anySign",
				"Method":"GetIDInfo",
				"p1":episodeID
			},
			success: function (ret) {
				if (ret.split('^').length == 3)
				{
					result.idType = ret.split('^')[1];
					result.idNumber = ret.split('^')[0];
					result.Name = ret.split('^')[2];
				}
			},
			error: function (ret) {
				alert("获取患者证件信息失败！");
			}
		});
		return result;
	},
    transIDType: function(idType) {
		//居民身份证
		//居民户口簿
		//护照
		//军官证
		//驾驶证
		//港澳居民来往内地通行证
		//台湾居民来往内地通行证
		//监护人证件号
		//患者无法提供任何有效证件
		//患者登记号
		if (idType == "居民身份证") {
			return "1";
		} else if (idType == "居民户口簿") {
			return "4";
		} else if (idType == "护照") {
			return "3";
		} else if (idType == "军官证") {
			return "2";
		} else if (idType == "驾驶证") {
			return "0";
		} else if (idType == "港澳居民来往内地通行证") {
			return "5";
		} else if (idType == "台湾居民来往内地通行证") {
			return "5";
		} else if (idType == "监护人证件号") {
			return "0";
		} else if (idType == "患者登记号") {
			return "0";
		} else {
			return idType;
		}
	},
    getSignerInfo: function(parEditor) {
		var episodeID = parEditor.episodeID || "";
		
		if (episodeID == '') return "";
		
		var cardInfo = this.getIDInfo(episodeID);
		cardInfo.idType = this.transIDType(cardInfo.idType);
		
		var name = cardInfo.Name === '' ? 'Patient': cardInfo.Name;
		if ((cardInfo.idNumber != "")&&(cardInfo.idType != "")) {
			return {
	            'Signer': name,
	            'IDCard': {
	                'Type':cardInfo.idType,
	                'Number': cardInfo.idNumber
	            }
	        };
		}
		return "";
	},
    getnotation: function(content) {
        if (!handSignInterface && !handSignInterface.checkStatus()) {
            alert('请配置手写签名设备');
            return;
        }
        var notation = "";
        try {
            notation = handSignInterface.getNotation(content);
        } catch(e) {
            alert("患者意见获取失败："+e.message);
            return "";
        }
        return notation;
    },
    sign: function (parEditor) {
        var isSigned = false;
        if (!handSignInterface || !handSignInterface.checkStatus()) {
            alert('请配置手写签名设备');
            return;
        }

        try {
            // 获取图片
            var signerInfo;
            var signerInfo = this.getSignerInfo(parEditor);
            if (signerInfo == "") {
                alert("患者证件信息不能为空!");
                return;
            }
            var evidenceData = handSignInterface.getEvidenceData(signerInfo);
           
            if ((typeof evidenceData === 'undefined')||(evidenceData == ""))
                return;
            //evidenceData = $.parseJSON(evidenceData);

            var signLevel = 'Patient';
            var signUserId = parEditor.userId || handSignInterface.getUsrID(evidenceData);
            var userName = 'Patient';
            var actionType = parEditor.actionType || 'Append';
            var description = '患者';
            var img = handSignInterface.getSignScript(evidenceData);
            var headerImage = handSignInterface.getSignPhoto(evidenceData);
            var fingerImage = handSignInterface.getSignFingerprint(evidenceData);
            var evidenceHash = handSignInterface.getSignHash(evidenceData);
            var path = parEditor.path || '';
            // 获取编辑器hash
            var signInfo = parEditor.signDocument(parEditor.instanceId, 'Graph', signLevel, signUserId, userName, img, actionType, description, headerImage, fingerImage, path);

            if (signInfo.result == 'OK') {
                isSigned = true;
                // 签名
                var signValue = handSignInterface.getSignDataValue(evidenceHash, signInfo.Digest);
                if ('' == signValue)
                {
                    throw {
                        message : '获取签名值为空！'
                    };
                    return;
                }
                
                var signValueObj = $.parseJSON(signValue);
                // 向后台保存
                var argsData = {
                    Action: 'SaveSignInfo',
                    InsID: parEditor.instanceId,
                    Algorithm: handSignInterface.getAlgorithm(signValueObj),
                    BioFeature: handSignInterface.getBioFeature(signValueObj),
                    EventCert: handSignInterface.getEventCert(signValueObj),
                    SigValue: handSignInterface.getSigValue(signValueObj),
                    TSValue: handSignInterface.getTSValue(signValueObj),
                    Version: handSignInterface.getVersion(signValueObj),
                    SignScript: img,
                    HeaderImage: headerImage,
                    Fingerprint: fingerImage,
                    PlainText: signInfo.Digest,
                    SignData: signValue
                };

                $.ajax({
                    type: 'POST',
                    dataType: 'text',
                    url: '../EMRservice.Ajax.anySign.cls',
                    async: false,
                    cache: false,
                    data: argsData,
                    success: function (ret) {
                        ret = $.parseJSON(ret);
                        if (ret.Err || false) {
                            throw {
                                message : 'SaveSignInfo 失败！' + ret.Err
                            };
                        } else {
                            if ('-1' == ret.Value) {
                                throw {
                                    message : 'SaveSignInfo 失败！'
                                };
                            } else {
                                var signId = ret.Value;
                                parEditor.saveSignedDocument(parEditor.instanceId, signUserId, signLevel, signId, signInfo.Digest, 'AnySign', signInfo.Path, actionType);
                            }
                        }
                    },
                    error: function (err) {
                        throw {
                            message : 'SaveSignInfo error:' + err
                        };                        
                    }
                });

            } else {
                throw {
                    message : '签名失败'
                };
            }
        } catch (err) {
            if (err.message.indexOf("'签名人'不同意'协议，拒绝签名'") != "-1") {
                return;
            }
            else if (isSigned) {
                parEditor.unSignedDocument();
            }
            alert(err.message);
        }
    },
    notationSign: function (parEditor,descContent) {
        var isSigned = false;
        // 获取图片
        var noteImg = this.getnotation(descContent);
        if (noteImg == "") {
            alert("获取批注图片为空，请检查环境是否正常");
            return;
        }

		try {
            var signLevel = 'Patient';
            var signUserId = parEditor.userId;
            var userName = 'Patient';
            var actionType = parEditor.actionType || 'Append';
            var description = '患者批注';
            var img = noteImg;
            var headerImage = '';
            var fingerImage = '';
            var evidenceHash = '';
            var path = parEditor.path || '';
            // 获取编辑器hash
            var signInfo = parEditor.signDocument(parEditor.instanceId, 'Graph', signLevel, signUserId, userName, img, actionType, description, headerImage, fingerImage, path, false);

            if (signInfo.result == 'OK') {
                isSigned = true;
                // 向后台保存
                var argsData = {
                    Action: 'SaveSignInfo',
                    InsID: parEditor.instanceId,
                    Algorithm: '',
                    BioFeature: '',
                    EventCert: '',
                    SigValue: '',
                    TSValue: '',
                    Version: '',
                    SignScript: img,
                    HeaderImage: '',
                    Fingerprint: '',
                    PlainText: signInfo.Digest,
                    SignData: ''
                };

                $.ajax({
                    type: 'POST',
                    dataType: 'text',
                    url: '../EMRservice.Ajax.anySign.cls',
                    async: false,
                    cache: false,
                    data: argsData,
                    success: function (ret) {
                        ret = $.parseJSON(ret);
                        if (ret.Err || false) {
                            throw {
                                message : 'SaveSignInfo 失败！' + ret.Err
                            };
                        } else {
                            if ('-1' == ret.Value) {
                                throw {
                                    message : 'SaveSignInfo 失败！'
                                };
                            } else {
                                var signId = ret.Value;
                                parEditor.saveSignedDocument(parEditor.instanceId, signUserId, signLevel, signId, signInfo.Digest, 'AnySign', signInfo.Path, actionType);
                            }
                        }
                    },
                    error: function (err) {
                        throw {
                            message : 'SaveSignInfo error:' + err
                        };                        
                    }
                });

            } else {
                throw {
                    message : '签名失败'
                };
            }
        } catch (err) {
            if (err.message.indexOf("'签名人'不同意'协议，拒绝签名'") != "-1") {
                return;
            }
            else if (isSigned) {
                parEditor.unSignedDocument();
            }
            alert(err.message);
        }
    }
};
