Class web.DHCCLDevSoapInferface Extends %SOAP.WebClient [ ClassType = "", Not ProcedureBlock ]
{

Method Start(opaId As %String, icuaId As %String, equipId As %String, anoSource As %String, userId As %String, devIP As %String, devPort As %String, sti As %String, interfaceProgram As %String, extInfo As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Start").Invoke(##this,"http://www.dhcc.com.cn/Start",.opaId,.icuaId,.equipId,.anoSource,.userId,.devIP,.devPort,.sti,.interfaceProgram,.extInfo)
}

Method Stop(opaId As %String, icuaId As %String, equipId As %String, source As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Stop").Invoke(##this,"http://www.dhcc.com.cn/Stop",.opaId,.icuaId,.equipId,.source)
}

Method Suspend(opaId As %String, icuaId As %String, equipId As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Suspend").Invoke(##this,"http://www.dhcc.com.cn/Suspend",.opaId,.icuaId,.equipId)
}

Method GetDevInfo(source As %String, equipId As %String, para As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 	s res=..WebMethod("GetDevInfo").Invoke(##this,"http://www.dhcc.com.cn/GetDevInfo",.source,.equipId,.para)
	q res
}

Method StartTask(source As %String, equipId As %String, patId As %String, devIP As %String, devPort As %String, sti As %String, interfaceProgram As %String, extInfo As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("StartTask").Invoke(##this,"http://www.dhcc.com.cn/StartTask",.source,.equipId,.patId,.devIP,.devPort,.sti,.interfaceProgram,.extInfo)
}

Method StopTask(source As %String, equipId As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("StopTask").Invoke(##this,"http://www.dhcc.com.cn/StopTask",.source,.equipId)
}

ClassMethod GetDeviceState(srouce, equipId)
{
	// {deviceName:'PhilisMp',IP:'127.0.0.1',state:'netoffline',troubleSource:'网线掉落电源线掉医嘱或网络故障'}
	q "{deviceName:'PhilisMp',IP:'127.0.0.1',state:'netoffline',troubleSource:'网线掉落电源线掉医嘱或网络故障'}"
}

/// This is the URL used to access the web service.
Parameter LOCATION = "http://127.0.0.1/OAICUService/OAICUDevSrv.asmx";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.dhcc.com.cn/";

/// This is the name of the Service
Parameter SERVICENAME = "OAICUDevSrv";

}
