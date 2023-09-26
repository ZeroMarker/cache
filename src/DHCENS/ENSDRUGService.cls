Class DHCENS.ENSDRUGService Extends (%SOAP.WebService, %XML.Adaptor) [ Inheritance = right, ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "ENSDRUGService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

Parameter LOCATION = "http://114.255.135.209/dthealth/web";

ClassMethod DhcService(funName As %String, input As %String) As %String [ WebMethod ]
{
	
	s return=""
	if funName="SendDrugOp"
	{
		
		q "0"
	}
	if funName="SendDrugIp"
	{
		
		q "0"
	}
	
	q "0"
}

}
