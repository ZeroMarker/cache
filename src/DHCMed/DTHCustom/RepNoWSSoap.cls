Class DHCMed.DTHCustom.RepNoWSSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://10.193.10.128:1972/csp/websource/DHCMed.DTHCustom.RepNoWS.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "RepNoWS";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

/// s obj=##class(DHCMed.DTHCustom.RepNoWSSoap).%New()
/// w obj.GetNewDeathNo("400012916")
Method GetNewDeathNo(aDTHHospCode As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetNewDeathNo").Invoke($this,"http://tempuri.org/DHCMed.DTHCustom.RepNoWS.GetNewDeathNo",.aDTHHospCode)
}

}
