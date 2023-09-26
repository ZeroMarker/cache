/// dhcservice.DHCTest
Class dhcservice.DHCTest Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCTest";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// TODO: add arguments and implementation.
/// Test
Method wsTest(p1 As %String, p2 As %String) As %String [ WebMethod ]
{
	Quit "后台返回:"_p1_","_p2
}

}
