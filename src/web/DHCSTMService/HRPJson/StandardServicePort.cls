Class web.DHCSTMService.HRPJson.StandardServicePort Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method syncApi(opCode As %String, data As %String, dataFormat As %String) As %String(ELEMENTQUALIFIED=1,XMLNAME="String") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("syncApi").Invoke($this,"",.opCode,.data,.dataFormat)
}

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// This is the URL used to access the web service.
Parameter LOCATION = "http://IP:Port/ESB/services/sys/mat/standardService";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://mat.sys.service.webservice.esb.hrp.dhcc.com/";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "StandardServiceService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

/// Overrides default handling of string arguments.
Parameter XMLIGNORENULL = 1;

}
