/// Created from: http://127.0.0.1:8972/csp/dhcens/DHC.LIS.Common.BS.Web.CLS?WSDL=1
Class DHCENS.LIS.EnsSoap.chead.CSPCHD Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://www.intersystems.com/SOAPheaders";

Parameter XMLNAME = "CSPCHD";

Parameter XMLSEQUENCE = 1;

Property id As %String(MAXLEN = "", XMLNAME = "id") [ Required ];

}
