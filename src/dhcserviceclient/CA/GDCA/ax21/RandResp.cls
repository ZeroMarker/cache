/// Created from: http://bswg2.95105813.cn:8080/AGW/services/AGWService?wsdl
Class dhcserviceclient.CA.GDCA.ax21.RandResp Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", CompileAfter = , Inheritance = right, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://service.agw/xsd";

Parameter XMLNAME = "RandResp";

Parameter XMLSEQUENCE = 1;

Property randString As %String(MAXLEN = "", XMLNAME = "randString");

Property result As %xsd.int(XMLNAME = "result");

}
