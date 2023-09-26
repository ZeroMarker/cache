/// Created from: http://bswg2.95105813.cn:8080/AGW/services/AGWService?wsdl
Class dhcserviceclient.CA.GDCA.ax21.HashResp Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", CompileAfter = , Inheritance = right, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://service.agw/xsd";

Parameter XMLNAME = "HashResp";

Parameter XMLSEQUENCE = 1;

Property hashData As %String(MAXLEN = "", XMLNAME = "hashData");

Property result As %xsd.int(XMLNAME = "result");

}
