Class dhc.qm.service.DrgsServiceImplPort Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method dataExtraction(xmlString As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("dataExtraction").Invoke($this,"",.xmlString)
}

Method depCMI(arg0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("depCMI").Invoke($this,"",.arg0)
}

Method depDRGsInfo(arg0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("depDRGsInfo").Invoke($this,"",.arg0)
}

Method depEfficiency(arg0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("depEfficiency").Invoke($this,"",.arg0)
}

Method depInfAndLRM(arg0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("depInfAndLRM").Invoke($this,"",.arg0)
}

Method depXHCMI(arg0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("depXHCMI").Invoke($this,"",.arg0)
}

Method hospitalCMI(arg0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("hospitalCMI").Invoke($this,"",.arg0)
}

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// This is the URL used to access the web service.
Parameter LOCATION = "http://10.160.28.204:8888/DRGsHosp-web/ws/drgService";

/// This is the namespace used by the Service
Parameter NAMESPACE = "DrgsService";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "DrgsService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

}
