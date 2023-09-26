//缓存检验打印参数
var LISSYSPrintParam = "";
//缓存Webservice地址
var LISSYSPrintWebServicAddress = "";

//LIS给HIS端提供的统一打印处理,非检验web调用*****************************zlz
//是谷歌的话先尝试HIS中间件调用，没有发布服务的话尝试LIS监听程序调用。IE用clickone调用
//Param:打印参数printFlag + "@" + WebServicAddress + "@" + labNo + "@" + userCode + "@" + printType + "@" + paramList + "@HIS.DHCReportPrintBarCodeForAll@QueryPrintData"
function HISBasePrint(Param) {
    LISSYSPrintParam = Param;
    //检测是否是谷歌浏览器
    var isChrome = window.navigator.userAgent.indexOf("Chrome") !== -1;
    //如果是谷歌浏览器尝试调用插件驱动创建用户
    if (isChrome) {
        var paraArr = Param.split("@");
        if (paraArr.length < 6) {
            alert("打印参数少于6位");
        }
        var rowids = paraArr[2];
        var userCode = paraArr[3];
        var printType=paraArr[4];
        var paramList = paraArr[5];
        var connectString = paraArr[1];
        var rowids = paraArr[2];
        var className = "";
        var funName = "";
        if (paraArr.length >= 8) {
            className = paraArr[6];
            funName = paraArr[7];
        }
        if (connectString != "") {
            LISSYSPrintWebServicAddress = connectString;
        }
        if (LISSYSPrintWebServicAddress == "") {
            //没传地址的查询获取
            $.ajaxRunServerMethod({ ClassName: "DHCLIS.DHCOrderList", MethodName: "GetConnectString", ID: "1" },
                function (rtn) {
                    if (rtn != "") {
                        LISSYSPrintWebServicAddress = rtn;
                        if (printType == "PrintPreview") {
                            LISPrint.PrintPreview(rowids, userCode, paramList, LISSYSPrintWebServicAddress, className, funName);
                        }
                        else {
                            LISPrint.PrintOut(rowids, userCode, paramList, LISSYSPrintWebServicAddress, className, funName);
                        }
                    }
                });	
        }
        else {
            if (printType == "PrintPreview") {
                LISPrint.PrintPreview(rowids, userCode, paramList, LISSYSPrintWebServicAddress, className, funName);
            }
            else {
                LISPrint.PrintOut(rowids, userCode, paramList, LISSYSPrintWebServicAddress, className, funName);
            }
        }
        
    }
    else {
        //没传地址的查询获取
        $.ajaxRunServerMethod({ ClassName: "DHCLIS.DHCOrderList", MethodName: "GetConnectString", ID: "1", async: false },
            function (result) {
                if (result != "") {
                    var webIP = result.split("//")[1].split("/")[0];
                    var arrp = Param.split('@');
                    var paramNew = "";
                    for (var i = 0; i < arrp.length; i++) {
                        if (i == 0) {
                            paramNew += arrp[i];
                        }
                        else if (i == 1) {
                            paramNew += "@" + result;
                        }
                        else {
                            paramNew += "@" + arrp[i];
                        }

                    }
                    Param = paramNew;
                    var printUrl = "http://" + webIP + "/imedicallis/lisprint/print2HIS/ResultPrintForHis.application?Param=" + Param;
                    document.location.href = printUrl;
                }
         });
    }
}


//http请求根地址
var WEBSYSHTTPSERVERURL = "http://localhost:11996/websys/";
var myXmlHttp = null, debuggerflag = false, isUseGetMethod = false, isMozilla = false;
//ajax
function websysAjax(bizUrl, data, async) {
    var url = WEBSYSHTTPSERVERURL + bizUrl;
    var cspXMLHttp = null;
    if (window.XMLHttpRequest) {
        isMozilla = true;
        cspXMLHttp = new XMLHttpRequest();
    }
    else if (window.ActiveXObject) {
        isMozilla = false;
        try
        {
            cspXMLHttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
        catch (e)
        {
            try
            {
                cspXMLHttp = new ActiveXObject("Msxml2.XMLHTTP");
            }
            catch (E) {
                //失败后尝试监听
                LISBasePrint(LISSYSPrintParam);
                cspXMLHttp = null;
            }
        }
    }
    var req = cspXMLHttp;
    req.onreadystatechange = invkProcessReq;
    var dataArr = [],
        dataStr = data;
    if ("object" == typeof data) {
        if (data.slice) {
            for (var i = 0; i < data.length; i++) {
                for (var j in data[i]) {
                    dataArr.push(j + "=" + encodeURIComponent(data[i][j]));
                }
            }
        }
        else
        {
            for (var k in data) {
                dataArr.push(k + "=" + encodeURIComponent(data[k]));
            }
        }
        dataStr = dataArr.join("&");
    }
    if (isUseGetMethod)
    {
        req.open("GET", url + "?" + dataStr, async);
        if (isMozilla)
        {
            req.send(null);
        }
        else
        {
            req.send();
        }
    }
    else
    {
        req.open("POST", url, async);
        req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        try
        {
            req.send(dataStr);
        }
        catch (e)
        {
            //失败后尝试监听
            LISBasePrint(LISSYSPrintParam);
            return invkProcessResponse(e);
        }
    }
    return invkProcessResponse(req);
}
function invkProcessResponse(req) {
    if (debuggerflag) {
        debugger;
    }
    if ("undefined" == typeof req.status) {
        var err = req.name + '(' + req.message + ')'; /*alert(err);*/
        return {
            "msg": err, "status": 404, "rtn": null
        };
    }
    if (req.status != 200) {
        var err = req.statusText + ' (' + req.status + ')';
        return { "msg": err, "status": req.status, "rtn": null };
    }
    var result = req.responseText;
    return result;
}
function invkProcessReq(req) { }
function invokeDll(mode, ass, cls, q, callback)
{
    return websysAjax(ass + '/' + cls, q, false);
};

function ICls()
{
    this.data = [];
    this.mode = 0;
    this.ass = "";
    this.cls = "";
}
ICls.prototype.constructor = ICls;
ICls.prototype.invk = function (c)
{
    var rtn = invokeDll(this.mode, this.ass, this.cls, this.data, c);
    return rtn;
};
ICls.prototype.clear = function ()
{
    this.data.length = 2;
    return this;
};
ICls.prototype.prop = function (k, v) {
    var o = {};
    o[k] = v;
    this.data.push(o);
    return this;
};
ICls.prototype.getMthParam = function (arg)
{
    if (!arg.length) {
        return "";
    } 
    var param = "";
    if (arg.length > 0)
    {
        param = "P_COUNT=" + arg.length;
        for (var i = 0; i < arg.length; i++)
        {
            param += "&P_" + i + "=" + encodeURIComponent(arg[i]);
        }
    }
    return param;
};
ICls.AssDirList = [];
/*检验打印*/
ICls.LISPrint = function () {
    var curPageUrl = window.document.location.href;
    var thisfun = this;
    if (LISSYSPrintWebServicAddress == "") {
        //没传地址的查询获取
        $.ajaxRunServerMethod({ ClassName: "DHCLIS.DHCOrderList", MethodName: "GetConnectString", ID: "1", async: false },
            function (rtn) {
                if (rtn != "") {
                    LISSYSPrintWebServicAddress = rtn;
                    curPageUrl = LISSYSPrintWebServicAddress;
                    var rootPath = curPageUrl.split("//")[0] + "//" + curPageUrl.split("//")[1].split("/")[0];
                    if (curPageUrl.toLowerCase().indexOf("/imedicallis") > -1) {
                        rootPath = rootPath + "/" + curPageUrl.split("//")[1].split("/")[1];
                    }
                    var defaultDllDir = rootPath + "/lisprint/addins/plugin";
                    thisfun.ass = "DHCLabtrakReportPrint.dll"; thisfun.cls = "DHCLabtrakReportPrint.DHCLabtrakReportPrint"; thisfun.data.push({ "_dllDir": defaultDllDir + "/DHCLabtrakReportPrint.dll,lisprint.zip" }); thisfun.data.push({ "_version": "8.4" });
                    thisfun.PrintOut = function () { thisfun.clear(); thisfun.data.push({ "M_PrintOut": thisfun.getMthParam(arguments) }); return thisfun.invk(); }
                    thisfun.PrintPreview = function () { thisfun.clear(); thisfun.data.push({ "M_PrintPreview": thisfun.getMthParam(arguments) }); return thisfun.invk(); }
                }
            });
    }
    else {
        var rootPath = curPageUrl.split("//")[0] + "//" + curPageUrl.split("//")[1].split("/")[0];
        if (curPageUrl.toLowerCase().indexOf("/imedicallis") > -1) {
            rootPath = rootPath + "/" + curPageUrl.split("//")[1].split("/")[1];
        }
        var defaultDllDir = rootPath + "/lisprint/addins/plugin";
        thisfun.ass = "DHCLabtrakReportPrint.dll"; thisfun.cls = "DHCLabtrakReportPrint.DHCLabtrakReportPrint"; thisfun.data.push({ "_dllDir": defaultDllDir + "/DHCLabtrakReportPrint.dll,lisprint.zip" }); thisfun.data.push({ "_version": "8.4" });
        thisfun.PrintOut = function () { thisfun.clear(); thisfun.data.push({ "M_PrintOut": thisfun.getMthParam(arguments) }); return thisfun.invk(); }
        thisfun.PrintPreview = function () { thisfun.clear(); thisfun.data.push({ "M_PrintPreview": thisfun.getMthParam(arguments) }); return thisfun.invk(); }
    }
}
ICls.LISPrint.prototype = new ICls();
ICls.LISPrint.prototype.constructor = ICls.LISPrint;
var LISPrint = new ICls.LISPrint();


//检验基础打印,调插件的统一入口
function LISBasePrint(para) {
    var paraArr = para.split("@");
    var paratmp = "";
    for (var i = 0; i < paraArr.length; i++) {
        if (i == 0) {
            paratmp = paraArr[i];
        }
        else {
            if (i == 1 && paraArr[1]=="") {
                paratmp = paratmp + "@" + LISSYSPrintWebServicAddress;
            }
            else {
                paratmp = paratmp + "@" + paraArr[i];
            }
            
        }
    }
    para = paratmp;
    if (para.length > 500 || (para.indexOf('"') > -1)) {
        //往后台提交数据
        $.ajax({
            type: "post",
            dataType: "text",
            cache: false, //
            async: false, //为true时，异步，不等待后台返回值，为false时强制等待；-asir
            url: '../../lisprint/ashx/ashLisPrintDesigner.ashx?Method=SavePTTMPPara',
            data: para,
            success: function (result, status) {
                if (result != "-1") {
                    LisBaseMsg.Subscribe("print#iMedicalLIS://DOWNLOADDATA@" + result, null, function () {
                        try {
                            localStorage["iMedicalLISPrintExtend"] = "";
                            var evt = document.createEvent("CustomEvent");
                            evt.initCustomEvent('myCustomEvent', true, false, para);
                            // fire the event
                            document.dispatchEvent(evt);
                            if (localStorage["iMedicalLISPrintExtend"] == undefined || localStorage["iMedicalLISPrintExtend"] == null || localStorage["iMedicalLISPrintExtend"] == "") {
                                throw new Error("未能驱动插件LIS谷歌打印插件！");
                            }
                        }
                        catch (e) {
                            if (localStorage["iMedicalLISPrintExtendFlag"] == "2") {
                                var iframeName = "zPrintIframe" + zPrintIframeIndex;
                                zPrintIframeIndex++;
                                //添加一个弹窗依托的div，作为弹出消息框
                                $(document.body).append('<iframe id="' + iframeName + '" src="' + "iMedicalLIS://DOWNLOADDATA@" + result + '" style="display:none;"><iframe>');
                                setTimeout(function () {
                                    $("#" + iframeName).remove();
                                }, 1500);
                            }
                            else {
                                var win = window.open("iMedicalLIS://DOWNLOADDATA@" + result, "打印等待", "height=750,width=650,top=10,left=10,titlebar =no,toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no, status=no,alwaysLowered=no");
                                if (localStorage["iMedicalLISPrintExtendFlag"] == "" || isNaN(localStorage["iMedicalLISPrintExtendFlag"])) {
                                    //调用标识
                                    localStorage["iMedicalLISPrintExtendFlag"] = "1";
                                }
                                else {
                                    //调用标识
                                    localStorage["iMedicalLISPrintExtendFlag"] = parseInt(localStorage["iMedicalLISPrintExtendFlag"]) + 1;
                                }
                            }
                        }
                    }, true);
                }
            }
        });
    }
    else {
        LisBaseMsg.Subscribe("print#iMedicalLIS://" + para, null, function () {
            try {
                localStorage["iMedicalLISPrintExtend"] = ""
                var evt = document.createEvent("CustomEvent");
                evt.initCustomEvent('myCustomEvent', true, false, para);
                // fire the event
                document.dispatchEvent(evt);
                if (localStorage["iMedicalLISPrintExtend"] == undefined || localStorage["iMedicalLISPrintExtend"] == null || localStorage["iMedicalLISPrintExtend"] == "") {
                    throw new Error("未能驱动插件LIS谷歌打印插件！");
                }
            }
            catch (e) {
                if (localStorage["iMedicalLISPrintExtendFlag"] == "3") {
                    var iframeName = "zPrintIframe" + zPrintIframeIndex;
                    zPrintIframeIndex++;
                    //添加一个弹窗依托的div，作为弹出消息框
                    $(document.body).append('<iframe id="' + iframeName + '" src="' + "iMedicalLIS://" + para + '" style="display:none;"><iframe>');
                    setTimeout(function () {
                        $("#" + iframeName).remove();
                    }, 1500);
                }
                else {
                    var win = window.open("iMedicalLIS://" + para, "打印等待", "height=750,width=650,top=10,left=10,titlebar =no,toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no, status=no,alwaysLowered=no");
                    if (localStorage["iMedicalLISPrintExtendFlag"] == "" || isNaN(localStorage["iMedicalLISPrintExtendFlag"])) {
                        //调用标识
                        localStorage["iMedicalLISPrintExtendFlag"] = "1";
                    }
                    else {
                        //调用标识
                        localStorage["iMedicalLISPrintExtendFlag"] = parseInt(localStorage["iMedicalLISPrintExtendFlag"]) + 1;
                    }
                }
            }
        }, true, true);
    }
}


var LisBaseMsg = {
    wsImpl: window.WebSocket || window.MozWebSocket,
    //标志用户是否登陆
    isuserlogined: false,
    //暂存回调和消息类型的对象
    callBackMsgTypeObj: {},
    //记录回复
    reply: null,
    ws: null,
    //消息是否能使用
    CanUse: false,
    //连接失败回调
    noConnCallBack: null,
    //调用失败回调后是否清除回调
    clearnoConnCallBack: false,
    //端口
    port: localStorage["CanUserMsgPort"],
    portIndex: 0,
    portList: ["8082", "10210", "19910", "19902"],
    tryNum: 0,
    state: false,
    //订阅一个消息
    //msg:订阅后要发送的消息
    //callBack:回调方法，有一个消息参数
    //noConnCallBack:没连接成功回调
    //clearnoConnCallBack:调用失败回调后是否清除回调
    //isSend:是否主要发送数据，为true就不重复连接了，只连接一次
    Subscribe: function (msg, callBack, noConnCallBack, clearnoConnCallBack, isSend) {
        if (isSend == true && LisBaseMsg.ws != null && LisBaseMsg.state != false) {
            if (LisBaseMsg.state == false) {
                if (noConnCallBack != null) {
                    noConnCallBack();
                }
                return;
            }
            LisBaseMsg.Send(msg);
            return;
        }
        else if (isSend == true) {
            LisBaseMsg.port == ""
            LisBaseMsg.ws = null;
        }
        //默认8082端口
        if (LisBaseMsg.port == null || LisBaseMsg.port == "") {
            LisBaseMsg.port = "8082";
        }
        LisBaseMsg.noConnCallBack = noConnCallBack;
        LisBaseMsg.clearnoConnCallBack = clearnoConnCallBack;
        //有消息就不创建了
        if (LisBaseMsg.ws != null) {
            if (LisBaseMsg.state == false) {
                if (noConnCallBack != null) {
                    noConnCallBack();
                }
                return;
            }
            //有消息就发
            if (msg != null) {
                LisBaseMsg.Send(msg);
                if (LisBaseMsg.ws.readyState == "1") {
                    LisBaseMsg.state = true;
                    msg = null;
                    LisBaseMsg.noConnCallBack = null;
                    return;
                }
            }
        }
        LisBaseMsg.ws = new LisBaseMsg.wsImpl("ws://127.0.0.1:" + LisBaseMsg.port);
        // 收到消息
        LisBaseMsg.ws.onmessage = function (evt) {
            if (callBack != null) {
                //调用回调方法
                callBack(evt.data);
            }
            LisBaseMsg.CanUse = true;
        };
        // 连接上
        LisBaseMsg.ws.onopen = function () {
            LisBaseMsg.CanUse = true;
            localStorage["CanUserMsgPort"] = LisBaseMsg.port;
            //有消息就发
            if (msg != null) {
                LisBaseMsg.Send(msg);
                msg = null;
                if (LisBaseMsg.ws.readyState == "1") {
                    LisBaseMsg.state = true;
                    LisBaseMsg.noConnCallBack = null;
                }
            }
        };
        // 断开连接
        LisBaseMsg.ws.onclose = function (notconn) {
            LisBaseMsg.state = false;
            LisBaseMsg.ws = null;
            console.info("消息已断开连接，即将为您重连");
            if (LisBaseMsg.tryNum < 4 && LisBaseMsg.CanUse == false) {
                LisBaseMsg.portIndex++;
                LisBaseMsg.portIndex = LisBaseMsg.portIndex % 4;
                LisBaseMsg.port = LisBaseMsg.portList[LisBaseMsg.portIndex];
                LisBaseMsg.ws = null;
                LisBaseMsg.tryNum++;
                setTimeout(function () {
                    LisBaseMsg.Subscribe(msg, callBack, LisBaseMsg.noConnCallBack, LisBaseMsg.clearnoConnCallBack);
                }, 400);
                return;
            }
            msg = null;
            if (LisBaseMsg.noConnCallBack != null) {
                LisBaseMsg.noConnCallBack();
                if (LisBaseMsg.clearnoConnCallBack == true) {
                    LisBaseMsg.noConnCallBack = null;
                }
            }
            LisBaseMsg.CanUse = false;
            if (notconn != true) {
                setTimeout(function () {
                    LisBaseMsg.Subscribe(msg, callBack, LisBaseMsg.noConnCallBack, LisBaseMsg.clearnoConnCallBack);
                }, 10000);
            }
        }
        //发生了错误事件
        LisBaseMsg.ws.onerror = function () {
            console.info("发生了错误");
        }
        //连接服务失败
        if (LisBaseMsg.ws.readyState == "3") {
            if (LisBaseMsg.ws != null) {
                LisBaseMsg.ws.onclose(true);
            }
            LisBaseMsg.ws = null;
        }
    },
    //发送消息
    //msg:消息
    Send: function (msg) {
        if (LisBaseMsg.ws == null) {
            LisBaseMsg.ws = new LisBaseMsg.wsImpl("ws://127.0.0.1:8082");
            console.info("警告：没有订阅消息就发送消息");
        }
        if (LisBaseMsg.state == true) {
            LisBaseMsg.ws.send(msg);
        }
        else {
            LisBaseMsg.MsgQuen.push(msg);
            if (LisBaseMsg.QuenTime == null) {
                LisBaseMsg.QuenTime = window.setInterval(LisBaseMsg.QuenSend, 1000);
            }
        }

    },
    QuenTime: null,
    MsgQuen: [],
    QuenSend: function () {
        if (LisBaseMsg.state == true) {
            for (var mi = 0; mi < LisBaseMsg.MsgQuen.length; mi++) {
                if (LisBaseMsg.MsgQuen.length > 0) {
                    var msg = LisBaseMsg.MsgQuen.splice(0, 1);
                    LisBaseMsg.ws.send(msg);
                }
            }
            if (LisBaseMsg.MsgQuen.length == 0) {
                clearInterval(LisBaseMsg.QuenTime);
                LisBaseMsg.QuenTime = null;
            }
        }
    }

}