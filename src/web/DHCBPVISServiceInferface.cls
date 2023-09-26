Class web.DHCBPVISServiceInferface Extends %SOAP.WebClient [ ClassType = "", Not ProcedureBlock ]
{

/// 登记病人接口
Method RisSendRegQueue(PatientInfo As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	Quit ..WebMethod("RisSendRegQueue").Invoke(##this,"http://www.dhcc.com.cn/web.DHCVISService.RisSendRegQueue",.PatientInfo)
}

/// 病人状态接口
Method RisUpdatePatStatus(PatientInfo As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	Quit ..WebMethod("RisUpdatePatStatus").Invoke(##this,"http://www.dhcc.com.cn/web.DHCVISService.RisUpdatePatStatus",.PatientInfo)
}

/// 病人呼叫接口
Method RisSendVoice(PatientInfo As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	Quit ..WebMethod("RisSendVoice").Invoke(##this,"http://www.dhcc.com.cn/web.DHCVISService.RisSendVoice",.PatientInfo)
}

/// Name of the WebService.
Parameter SERVICENAME = "DHCVISService";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://10.160.16.92/dthealth/web/web.DHCVISService.cls";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn";

}
