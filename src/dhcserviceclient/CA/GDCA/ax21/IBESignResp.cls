/// Created from: http://bswg2.95105813.cn:8080/AGW/services/AGWService?wsdl
Class dhcserviceclient.CA.GDCA.ax21.IBESignResp Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", CompileAfter = , Inheritance = right, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://service.agw/xsd";

Parameter XMLNAME = "IBESignResp";

Parameter XMLSEQUENCE = 1;

Property result As %xsd.int(XMLNAME = "result");

Property serialNo As %String(MAXLEN = "", XMLNAME = "serialNo");

Property signValue As %String(MAXLEN = "", XMLNAME = "signValue");

Property timeString As %String(MAXLEN = "", XMLNAME = "timeString");

}
