Class web.DHCPE.CallVoice.DHCVISServiceSoap Extends %SOAP.WebClient
{

Method DHCRisSendVoice(voiceContent As %String, userId As %String, clientIP As %String, type As %String, sound As %String, repeat As %String, ZHScreenStr As %String, CKScreenStr As %String, WaitList As %String, Note As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("DHCRisSendVoice").Invoke(##this,"http://www.dhcc.com.cn/web.DHCVISService.DHCRisSendVoice",.voiceContent,.userId,.clientIP,.type,.sound,.repeat,.ZHScreenStr,.CKScreenStr,.WaitList,.Note)
}

Method RisClearReport(PatientInfo As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("RisClearReport").Invoke(##this,"http://www.dhcc.com.cn/web.DHCVISService.RisClearReport",.PatientInfo)
}

Method RisSendRegQueue(PatientInfo As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("RisSendRegQueue").Invoke(##this,"http://www.dhcc.com.cn/web.DHCVISService.RisSendRegQueue",.PatientInfo)
}

Method RisSendReport(PatientInfo As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("RisSendReport").Invoke(##this,"http://www.dhcc.com.cn/web.DHCVISService.RisSendReport",.PatientInfo)
}

Method RisSendVoice(PatientInfo As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("RisSendVoice").Invoke(##this,"http://www.dhcc.com.cn/web.DHCVISService.RisSendVoice",.PatientInfo)
}

Method SendAnOpList(AnOpListInfo As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SendAnOpList").Invoke(##this,"http://www.dhcc.com.cn/web.DHCVISService.SendAnOpList",.AnOpListInfo)
}

Method SendTipVoice(voiceContent As %String, clientIP As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SendTipVoice").Invoke(##this,"http://www.dhcc.com.cn/web.DHCVISService.SendTipVoice",.voiceContent,.clientIP)
}

Method Test() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Test").Invoke(##this,"http://www.dhcc.com.cn/web.DHCVISService.Test")
}

Method UpdateAnOpState(AnOpListInfo As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("UpdateAnOpState").Invoke(##this,"http://www.dhcc.com.cn/web.DHCVISService.UpdateAnOpState",.AnOpListInfo)
}

Method test1(testparm As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("test1").Invoke(##this,"http://www.dhcc.com.cn/web.DHCVISService.test1",.testparm)
}

/// This is the URL used to access the web service.
Parameter LOCATION = "http://10.160.16.92/dthealth/web/web.DHCVISService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.dhcc.com.cn";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "DHCVISService";

}
