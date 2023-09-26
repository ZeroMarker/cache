/// Created from: http://bswg2.95105813.cn:8080/AGW/services/AGWService?wsdl
Class dhcserviceclient.CA.GDCA.ax21.P7SignResp Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", CompileAfter = , Inheritance = right, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://service.agw/xsd";

Parameter XMLNAME = "P7SignResp";

Parameter XMLSEQUENCE = 1;

Property result As %xsd.int(XMLNAME = "result");

Property signedData As %String(MAXLEN = "", XMLNAME = "signedData");

}
