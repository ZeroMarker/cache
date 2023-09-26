Class dhc.sync.HRWebServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method AddBaseData(piSource As %String, piData As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("AddBaseData").Invoke($this,"http://tempuri.org/AddBaseData",.piSource,.piData)
}

Method GetWebUrl(pibIsInnerNet As %Boolean) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
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

/// This is the URL used to access the web service.
Parameter LOCATION = "http://192.168.14.37/HRService/HRWebService.asmx";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org/";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "HRWebService";

/// This service supports both SOAP 1.1 and SOAP 1.2.
Parameter SOAPVERSION;

}
