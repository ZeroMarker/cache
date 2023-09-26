Class DHCMed.Test Extends (%SOAP.WebService, %XML.Adaptor) [ Inheritance = right ]
{

/// SERVICENAME - Should be the name of the service for which this is a proxy.
/// Override this parameter in the subclass.
Parameter SERVICENAME = "DtHealthService";

/// NAMESPACE specifies the XML namespace to be used when projecting the
/// class to XML.  if NAMESPACE - "", the default namespace is used for the XML schema
/// is used as the namespace for his class.
Parameter NAMESPACE = "127.0.0.1/dthealth/web";

ClassMethod NewMethod1(productId As %Integer) As %String [ WebMethod ]
{
	set ret=##class(DHCMed.SS.Products).GetStringById(productId)
	quit ret
}

}
