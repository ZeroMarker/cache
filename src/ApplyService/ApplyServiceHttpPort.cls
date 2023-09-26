Class ApplyService.ApplyServiceHttpPort Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.19.19.3//services/ApplyService";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://service.apply.webservice.dhcc.com";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "ApplyService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method ThirdSysApply(in0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("ThirdSysApply").Invoke($this,"",.in0)
}

}
