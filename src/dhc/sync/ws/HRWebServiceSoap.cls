Class dhc.sync.ws.HRWebServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.19.19.3:808/hrtbservice/HRWebService.asmx";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org/";

/// This is the name of the Service
Parameter SERVICENAME = "HRWebService";

/// This service supports both SOAP 1.1 and SOAP 1.2.
Parameter SOAPVERSION;

Method GetWebUrl(pibIsInnerNet As %Boolean(REQUIRED=1)) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetWebUrl").Invoke($this,"http://tempuri.org/GetWebUrl",.pibIsInnerNet)
}

Method IsServiceEnabled() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("IsServiceEnabled").Invoke($this,"http://tempuri.org/IsServiceEnabled")
}

Method getHzPy(hzStr As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getHzPy").Invoke($this,"http://tempuri.org/getHzPy",.hzStr)
}

Method getPYString(str As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getPYString").Invoke($this,"http://tempuri.org/getPYString",.str)
}

Method saveData(piSource As %String, piData As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("saveData").Invoke($this,"http://tempuri.org/saveData",.piSource,.piData)
}

}
