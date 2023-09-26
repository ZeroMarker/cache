/// CHSSWeb.MyService1
Class CHSSWeb.MyService1 Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "MyService1";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://localhost/csp/websrcwf";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// TODO: add arguments and implementation.
/// Test
ClassMethod Test() As %String [ WebMethod ]
{
	Quit "Test"
}

}
