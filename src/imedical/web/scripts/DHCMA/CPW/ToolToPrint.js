Ext.BLANK_IMAGE_URL='../scripts_lib/ext3.1.0/resources/images/default/s.gif';
var ExtTool = new Object();

ExtTool.GetHttpRequest = function() 
{
    var ajaxHttpRequest = null;
    if (window.XMLHttpRequest) { //Mozilla, Opera, ...
        ajaxHttpRequest = new XMLHttpRequest();
        if (ajaxHttpRequest.overrideMimeType) {
            ajaxHttpRequest.overrideMimeType("text/xml");
        }
    }
    else if (window.ActiveXObject) { //IE
        try {
            ajaxHttpRequest = new ActiveXObject("Msxml2.XMLHTTP");
        }
        catch (e) {
            try {
                ajaxHttpRequest = new ActiveXObject("Microsoft.XMLHTTP");
            }
            catch (e) {
            }
        }
    }
    if (!ajaxHttpRequest) {
        throw new Error(999,"Fail to init AJAX");
    }
    return ajaxHttpRequest;
};

ExtTool.RunServerMethod = function(ClassName,MethodName) {
    //var objMethodSign = document.getElementById("MethodRunClassMethod");
    var strMethodSign = ExtTool.MethodSignature;
    /*if(objMethodSign == null)
    {
        	Ext.Msg.show({
					   title: '程序运行错误',
					   msg: "<div style='overflow:scroll;height=300px;width:500px;text-align:left'>请在CSP文件中增加'<input type=\"hidden\" id=\"MethodRunClassMethod\" value=\"<%=##Class(%CSP.Page).Encrypt($LB(\"DHCMed.ClassMethodService.RunClassMethod\"))%>\"/>\').RunClassMethod</div>",
					   buttons: Ext.MessageBox.OK,
					   icon: Ext.MessageBox.ERROR
					});
					return null;
    }
    else
    {
    		strMethodSign = objMethodSign.value;
    }*/

    var strExpression = "var strResult = cspRunServerMethod(strMethodSign,ClassName,MethodName";
    for(var i = 2; i < arguments.length; i ++)
    {
			strExpression += ",arguments[" + i + "]"
    }
    strExpression += ");"
    eval(strExpression);
    try
    {
    	var tmpStr = ""
    	tmpStr += "调用类:" + ClassName + "\n";
    	tmpStr += "调用方法名:" + MethodName + "\n";
    	for(var i = 2; i < arguments.length; i ++)
    	{
    		tmpStr += "调用参数" + (i - 1) + ":" + arguments[i] + "\n";
    	}
    	var tmpResult = strResult;
    	if(tmpResult == null)
    		tmpResult = "";
    	if(tmpResult.indexOf("<RESULT>OK</RESULT>") > -1)
    	{
    		tmpStr += "返回结果:【" + tmpResult.replace("<RESULT>OK</RESULT>", "") + "】\n";
    		window.console.info(tmpStr);
    	}else
    	{
    		tmpStr += "此函数调用出错！返回结果:【" + tmpResult + "】\n";
    		window.console.error(tmpStr);
    	}
    }catch(err)
    {
    }    
    if (strResult != null) {
        if (strResult.indexOf("<RESULT>OK</RESULT>") == 0)
        {
        	strResult = strResult.replace("<RESULT>OK</RESULT>", "");
        	if(strResult.indexOf("<ResultObject>") == 0)
        	{
        		strResult = strResult.replace("<ResultObject>", "");
        		eval(strResult);
        		return objTmp;
        	}
        	else
        	{
        		return strResult;
        	}
        }
        else
        {	
        	Ext.Msg.show({
					   title: '程序运行错误',
					   msg: "<div style='overflow:scroll;height=300px;width:500px;text-align:left'>"+strResult+"</div>",
					   buttons: Ext.MessageBox.OK,
					   icon: Ext.MessageBox.ERROR
					});
        	throw new Error(9999, strResult);
        }
    }
    else {
    	//window.location.reload(true);
    	/**/
    		var strMsg = strResult + "<BR/>";
    		strMsg += "调用类：" + ClassName + "<BR/>";
    		strMsg += "调用类方法：" + MethodName + "<BR/>";
    		for(var i = 2; i < arguments.length; i ++)
    		{
    			strMsg += "参数" + i + "：‘" + arguments[i] + "’<BR/>";
    		}
    		Ext.Msg.show({
					   title: '程序运行错误',
					   msg: "<div style='overflow:scroll;height=300px;width:500px;text-align:left'>"+strMsg+"</div>",
					   buttons: Ext.MessageBox.OK,
					   icon: Ext.MessageBox.ERROR
					});
        throw new Error(500, strMsg);
        
    }

};

ExtTool.RunServerMethod1 = function(ClassName,Method,Args)
{
	var strExp = "var ret=ExtTool.RunServerMethod(ClassName,Method";
	for(var i = 0; i < Args.length; i ++)
	{
		strExp += ",Args[" + i + "]"
	}
	strExp += ");"
	eval(strExp);
	return ret;
}

ExtTool.GetMethodSignature = function() {
    var objRequest = ExtTool.GetHttpRequest();
    var strURL = "./csp/DHCMed.ClassMethodServiceHelper.cls";
	
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

ExtTool.StaticServerObject = function(ClassName) {
	var strResult = ExtTool.RunServerMethod("DHCMed.ClassMethodService", "StaticObject", ClassName);
	eval(strResult);
	return objTmp;
	
};


//Add By LiYang 2013-01-08 运行Query的方法
//QueryInfo:query的说明
//      ClassName:类名
//      Arg1--ArgN:参数
//      ArgCnt:参数个数
//callback:query运行成功后的回调函数，它需要接受query的结果。结果是返回行的数组
//objScope:callback函数的作用域。
//extraArg : 希望传给callback函数的自定义参数
ExtTool.RunQuery = function(QueryInfo, callback, objScope, extraArg)
{
	var arryArgs = new Array();
	var params = new Object();
	params.ClassName = QueryInfo.ClassName;
	params.QueryName = QueryInfo.QueryName;
	for(var i = 0; i < QueryInfo.ArgCnt ; i ++)
	{
		params["Arg" + (i + 1)] = QueryInfo["Arg" + (i + 1)];
	}
	params.ArgCnt = QueryInfo.ArgCnt;
	Ext.Ajax.request({   
		params : params,
		url: ExtToolSetting.RunQueryPageURL,
	    success: function(response, params) {
		  var obj = Ext.decode(response.responseText);
		  
		  var arryResult = new Array();
		  for(var i = 0; i < obj.total; i ++)
		  {
			arryResult[arryResult.length] = obj.record[i];
		  }
		  callback.call(objScope, arryResult, extraArg);
		},
	    failure: function(response, params) {
		  ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	});	
}

//update by zf 2014-09-02 IE11兼容模式报错，Session超时
ExtTool.MethodSignature = typeof RunClassMethodEncrypt != "undefined" ? RunClassMethodEncrypt : ExtTool.GetMethodSignature();
