var JQueryTool = new Object();

JQueryTool.GetHttpRequest = function() {
    var ajaxHttpRequest = null;
    if (window.XMLHttpRequest) { //Mozilla, Opera, ...
        ajaxHttpRequest = new XMLHttpRequest();
        if (ajaxHttpRequest.overrideMimeType) {
            ajaxHttpRequest.overrideMimeType("text/xml");
        }
    } else if (window.ActiveXObject) { //IE
        try {
            ajaxHttpRequest = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
            try {
                ajaxHttpRequest = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e) {}
        }
    }
    if (!ajaxHttpRequest) {
        throw new Error(999, "Fail to init AJAX");
    }
    return ajaxHttpRequest;
};

JQueryTool.GetMethodSignature = function() {
    var objRequest = JQueryTool.GetHttpRequest();
    var strURL = "./csp/web.DHCClinic.ClassMethodServiceHelper.cls";

    objRequest.open("POST", strURL, false);
    objRequest.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    var strArg = "?a=a&Rnd=" + Math.random();
    objRequest.send(strArg);
    if (objRequest.status == 200) {
        return objRequest.responseText;//.replace("\r\n", "");
    }
    else {
        throw new Error(500, objRequest.responseText);
    }

};

function cspRunServerMethod(method) {
    if (cspFindXMLHttp(false) == null) {
        err='Unable to locate XMLHttpObject.';
        if (typeof cspRunServerMethodError == 'function')
            return cspRunServerMethodError(err);
        alert(err);
        return null;
    }
    return cspIntHttpServerMethod(method,cspRunServerMethod.arguments,false);
    //return cspHttpServerMethod(method,cspRunServerMethod.arguments);
}

JQueryTool.MethodSignature = JQueryTool.GetMethodSignature();

JQueryTool.RunServerMethod = function(ClassName,MethodName) {
    var strMethodSign = JQueryTool.MethodSignature;
    var strExpression = "var strResult = cspRunServerMethod(strMethodSign,ClassName,MethodName";
    for (var i = 2; i < arguments.length; i++) {
        strExpression += ",arguments[" + i + "]"
    }
    strExpression += ");"
    eval(strExpression);
    if (strResult != null) {
        if (strResult.indexOf("<RESULT>OK</RESULT>") == 0) {
            strResult = strResult.replace("<RESULT>OK</RESULT>", "");
            if (strResult.indexOf("<ResultObject>") == 0) {
                strResult = strResult.replace("<ResultObject>", "");
                eval(strResult);
                return objTmp;
            } else {
                return strResult;
            }
        } else {
            /*Ext.Msg.show({
                       title: '程序运行错误',
                       msg: "<div style='overflow:scroll;height=300px;width:500px;text-align:left'>"+strResult+"</div>",
                       buttons: Ext.MessageBox.OK,
                       icon: Ext.MessageBox.ERROR
                    });*/
            throw new Error(9999, strResult);
        }
    } else {
        //window.location.reload(true);
        /**/
        var strMsg = strResult + "<BR/>";
        strMsg += "调用类：" + ClassName + "<BR/>";
        strMsg += "调用类方法：" + MethodName + "<BR/>";
        for (var i = 2; i < arguments.length; i++) {
            strMsg += "参数" + i + "：‘" + arguments[i] + "’<BR/>";
        }

        /*Ext.Msg.show({
                       title: '程序运行错误',
                       msg: "<div style='overflow:scroll;height=300px;width:500px;text-align:left'>"+strMsg+"</div>",
                       buttons: Ext.MessageBox.OK,
                       icon: Ext.MessageBox.ERROR
                    });*/
        throw new Error(500, strMsg);

    }
};

JQueryTool.RunServerMethod1 = function(ClassName,Method,Args)
{
    var strExp = "var ret=JQueryTool.RunServerMethod(ClassName,Method";
    for(var i = 0; i < Args.length; i ++)
    {
        strExp += ",Args[" + i + "]"
    }
    strExp += ");"
    window.eval(strExp);
    return ret;
}

JQueryTool.GetMethodSignature = function() {
    var objRequest = JQueryTool.GetHttpRequest();
    var strURL = "./csp/web.DHCClinic.ClassMethodServiceHelper.cls";

    objRequest.open("POST", strURL, false);
    objRequest.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    var strArg = "?a=a&Rnd=" + Math.random();
    objRequest.send(strArg);
    if (objRequest.status == 200) {
        return objRequest.responseText; //.replace("\r\n", "");
    } else {
        throw new Error(500, objRequest.responseText);
    }

};

JQueryTool.StaticServerObject = function(ClassName) {
    var strResult = JQueryTool.RunServerMethod("web.DHCClinic.ClassMethodService", "JStaticObject", ClassName);
    eval(strResult);
    return objTmp;

};

var JQueryToolSetting=new Object();
//运行Query的Page
JQueryToolSetting.RunQueryPageURL = "dhcclinic.jquery.csp";  

//运行类方法的Page
JQueryToolSetting.RunServerMethodPageURL = "dhcclinic.jquery.method.csp";

//操作类的Page
JQueryToolSetting.ObjectOperationPageURL = "dhcclinic.object.csp";

JQueryToolSetting.TreeQueryPageURL = "dhcclinic.tree.query.csp";