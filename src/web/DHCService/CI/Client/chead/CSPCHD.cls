/// Created from: http://10.1.1.56:8972/csp/ditan/DHC.BS.DocToCardiogram.cls?WSDL
Class web.DHCService.CI.Client.chead.CSPCHD Extends (%SerialObject, %XML.Adaptor) [ ClassType = serial, Inheritance = right ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://www.intersystems.com/SOAPheaders";

Parameter XMLNAME = "CSPCHD";

Parameter XMLSEQUENCE = 1;

Property id As %String(MAXLEN = "", XMLNAME = "id") [ Required ];

Storage Default
{
<Data name="CSPCHDState">
<Value name="1">
<Value>id</Value>
</Value>
</Data>
<State>CSPCHDState</State>
<StreamLocation>^web.DHCService.CI.ClA76.CSPCHDS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
