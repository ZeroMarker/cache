/// Created from: http://192.168.1.113:8972/csp/ditan/DHC.BS.PHABAIYAOJI.cls?WSDL
Class Ensemble.Web.Baiyao.chead.CSPCHD Extends (%SerialObject, %XML.Adaptor) [ ClassType = serial, Inheritance = right ]
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
<StreamLocation>^Ensemble.Web.Baiyao91D.CSPCHDS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
