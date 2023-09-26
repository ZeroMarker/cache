/// dhc.pa.web.MyService
Class dhc.pa.web.MyService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "MyService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// TODO: add arguments and implementation.
/// Test
Method Test() As %String [ WebMethod ]
{
	Quit "Test"
}

/// This method returns tomorrow's price for the requested stock
Method Forecast(str As %String) As %String [ WebMethod ]
{
    // apply patented, nonlinear, heuristic to find new price
  
	s resultString = ##class(dhc.pa.udata.uAdjust).UnitList(0,20,"")
	;s end = start+limit

	q resultString
}

}
