Class DHCVISService.DHCVISServiceSoap Extends %SOAP.WebClient [ ClassType = "", Not ProcedureBlock ]
{

Method RisSendRegQueue(PatientInfo As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("RisSendRegQueue").Invoke(##this,"http://www.dhcc.com.cn/web.DHCVISService.RisSendRegQueue",.PatientInfo)
}

Method RisSendVoice(PatientInfo As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("RisSendVoice").Invoke(##this,"http://www.dhcc.com.cn/web.DHCVISService.RisSendVoice",.PatientInfo)
}

Method Test() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Test").Invoke(##this,"http://www.dhcc.com.cn/web.DHCVISService.Test")
}

/// This is the URL used to access the web service.
Parameter LOCATION = "http://10.8.1.29/dthealth/web/web.DHCVISService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.dhcc.com.cn";

/// This is the name of the Service
Parameter SERVICENAME = "DHCVISService";

}
