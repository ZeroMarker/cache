
function ajaxPOSTCommon(data, onSuccess, onError, isAsync) {
    isAsync = isAsync || false;
    if ("undefined" != typeof data.params){
        data.params.langID = langID;
    }else{
        data.params = {
            langID: langID
        };
    }
    $.ajax({
        type: "POST",
        dataType: "json",
        url: "../EMR.DOC.SRV.RequestCommon.cls?MWToken="+getMWToken(),
        async: isAsync,
        cache: false,
        contentType: "text/plain",
        processData: false,
        data: JSON.stringify(data),
        success: function (ret) {
            if("true" === ret.success){
                if (!onSuccess) {}
                else {
                    if (ret.errorCode){
                        $.messager.alert("数据请求失败提示", ret.errorMessage, "info");
                        onSuccess("");
                    }else{
                        onSuccess(ret.data);
                    }
                }
            }else{
                $.messager.alert("失败", "ajaxPOSTCommon:请求失败", "error");
            }
        },
        error: function (ret) {
            if (!onError) {
                $.messager.alert("发生请求错误", "ajaxPOSTCommon error:"+JSON.stringify(ret), "error");
            }else {
                onError(ret);
            }
        }
    });
}

function ajaxGETCommon(data, onSuccess, onError, isAsync) {
    isAsync = isAsync || false;
    if ("undefined" != typeof data.params){
        data.params.langID = langID;
    }else{
        data.params = {
            langID: langID
        };
    }
    $.ajax({
        type: "GET",
        dataType: "json",
        url: "../EMR.DOC.SRV.RequestCommon.cls?MWToken="+getMWToken(),
        async: isAsync,
        cache: false,
        data: {"paramdata":JSON.stringify(data)},
        success: function (ret) {
            if("true" === ret.success){
                if (!onSuccess) {}
                else {
                    if (ret.errorCode){
                        $.messager.alert("数据请求失败提示", ret.errorMessage, "info");
                        onSuccess("");
                    }else{
                        onSuccess(ret.data);
                    }
                }
            }else{
                $.messager.alert("失败", "ajaxGETCommon:请求失败", "error");
            }
        },
        error: function (ret) {
            if (!onError) {
                $.messager.alert("发生请求错误", "ajaxGETCommon error:"+JSON.stringify(ret), "error");
            }else {
                onError(ret);
            }
        }
    });
}

//获取客户端IP地址
function getIpAddress() {
    var clientInfo = getClientInfo();   //调平台组接口获取客户端信息
    if (clientInfo) {
        return clientInfo.ipAddress;
    }else{
        try {
            var locator = new ActiveXObject("WbemScripting.SWbemLocator");
            var service = locator.ConnectServer(".");
            var properties = service.ExecQuery("Select * from Win32_NetworkAdapterConfiguration Where IPEnabled =True");
            var e = new Enumerator(properties); {
                var p = e.item();
                var ip = p.IPAddress(0);
                return ip
            }
        } catch (err) {
            return "";
        }
    }
}

//调用平台组接口获取客户端信息
function getClientInfo()
{
    var rtn = "";
    var data = {
        action: "GET_CLIENTINFO",
        params: {
            loginID: loginID
        },
        product: envVar.product
    };
    ajaxGETCommon(data, function(ret){
        rtn = ret;
    }, function (error) {
        $.messager.alert("发生错误", "getClientInfo error:"+error, "error");
    }, false);
    return rtn;
}

// 有实际含义的变量才执行方法，变量null，undefined和""空串都为false
// 初始promise 或 promise.then返回的
function isPromise(obj) {
  return !!obj && (typeof obj === "object" || typeof obj === "function") && typeof obj.then === "function";
}

//是否存在指定函数
function isExistFunc(funcName) {
    try {
        if (typeof(eval(funcName)) == "function") {
            return true;
        }
    } catch (e) {}
    return false;
}
//是否存在指定变量
function isExistVar(variableName) {
    try {
        if (typeof(variableName) == "undefined") {
            return false;
        } else {
            return true;
        }
    } catch (e) {}
    return false;
}

//国际化改造获取翻译
function emrTrans(value)
{
    if (typeof $g == "function") 
    {
        value = $g(value)
    }
    return value;
}

//封装基础平台websys_getMWToken()方法
function getMWToken()
{
    try{
        if (typeof(websys_getMWToken) != "undefined")
            return websys_getMWToken();
        return "";
    }catch(e) {
        return "";
    }
}

/// 创建HISUI-Dialog弹窗
function createModalDialog(dialogId, dialogTitle, width, height, iframeId, iframeContent,callback){
    $("body").append("<div id='"+dialogId+"'</div>");
    if (isNaN(width)) width = 800;
    if (isNaN(height)) height = 500;
    $HUI.dialog('#'+dialogId,{ 
        title: emrTrans(dialogTitle),
        width: width,
        height: height,
        cache: false,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        isTopZindex: true,
        content: iframeContent,
        onBeforeClose:function(){
            var tempFrame = $("#"+iframeId)[0].contentWindow;
            if (tempFrame && isExistVar(tempFrame.returnValue)){
                returnValue = tempFrame.returnValue;
                if (isExistFunc(callback)){
                    callback(returnValue);
                }
            }
        },
        onClose:function(){
            $("#"+dialogId).dialog("destroy");
        }
    });
}
//关闭dialog,子页面调用
function closeDialog(dialogId)
{
    $HUI.dialog("#"+dialogId).close();
}

function judgeIsIE() { //ie?
    if (!!window.ActiveXObject || "ActiveXObject" in window)
        return true;
    else
        return false;
}

// 锁定页面右键
document.oncontextmenu = function(e){
    return false;
}
