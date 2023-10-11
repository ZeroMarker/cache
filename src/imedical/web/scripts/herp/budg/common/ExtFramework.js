Ext.BLANK_IMAGE_URL='../scripts_lib/ext3.1.0/resources/images/default/s.gif';
var ExtTool = new Object();
ExtTool.MethodSignature = RunClassMethodEncrypt;
ExtTool.RunServerMethod = function(ClassName,MethodName) {
	var strMethodSign = ExtTool.MethodSignature;
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


ExtTool.StaticServerObject = function(ClassName) {
	var strResult = ExtTool.RunServerMethod("DHCMed.ClassMethodService", "StaticObject", ClassName);
	eval(strResult);
	return objTmp;
	
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
