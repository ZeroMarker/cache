Class web.DHCEKGService.OAICUDevSrvSoap Extends %SOAP.WebClient [ ClassType = "", Not ProcedureBlock ]
{

Method Description() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Description").Invoke(##this,"http://www.dhcc.com.cn/Description")
}

Method RequestDevItem(opaId As %String, icuaId As %String, equipId As %String, devItemName As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("RequestDevItem").Invoke(##this,"http://www.dhcc.com.cn/RequestDevItem",.opaId,.icuaId,.equipId,.devItemName)
}

Method RequestState(opaId As %String, icuaId As %String, equipId As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("RequestState").Invoke(##this,"http://www.dhcc.com.cn/RequestState",.opaId,.icuaId,.equipId)
}

Method RequestSti(opaId As %String, icuaId As %String, equipId As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("RequestSti").Invoke(##this,"http://www.dhcc.com.cn/RequestSti",.opaId,.icuaId,.equipId)
}

Method SetDevItem(opaId As %String, icuaId As %String, equipId As %String, devItemName As %String, devItemValue As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SetDevItem").Invoke(##this,"http://www.dhcc.com.cn/SetDevItem",.opaId,.icuaId,.equipId,.devItemName,.devItemValue)
}

Method SetSti(opaId As %String, icuaId As %String, equipId As %String, sti As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SetSti").Invoke(##this,"http://www.dhcc.com.cn/SetSti",.opaId,.icuaId,.equipId,.sti)
}

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

Method GetDevInfo(equipId As %String, devIP As %String, devPort As %String, interfaceProgram As %String = "PhilipsMP", anoSource As %String = "QR") As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 	s res=..WebMethod("GetDevInfo").Invoke(##this,"http://www.dhcc.com.cn/GetDevInfo",.equipId,.anoSource)
	i res["FAILED^" d
	.s res=..WebMethod("Start").Invoke(##this,"http://www.dhcc.com.cn/Start","","",.equipId,.anoSource,"",.devIP,.devPort,"50000",.interfaceProgram,"") 
	.s res=..WebMethod("GetDevInfo").Invoke(##this,"http://www.dhcc.com.cn/GetDevInfo",.equipId,.anoSource)
	q res
}

/// This is the URL used to access the web service.
Parameter LOCATION = "http://10.160.16.110/OAICUService/OAICUDevSrv.asmx";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.dhcc.com.cn/";

/// This is the name of the Service
Parameter SERVICENAME = "OAICUDevSrv";

}
