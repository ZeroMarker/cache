Class DHCEPRFS.ThirdParty.WebService.XingHe.WLRMXingHeWebServicePort Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://10.160.28.194:49616/pdbg/WebService.asmx";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org/";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "WebService";

/// This service supports both SOAP 1.1 and SOAP 1.2.
Parameter SOAPVERSION;

Method CheckReport(AInput As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("CheckReport").Invoke($this,"http://tempuri.org/CheckReport",.AInput)
}

}
