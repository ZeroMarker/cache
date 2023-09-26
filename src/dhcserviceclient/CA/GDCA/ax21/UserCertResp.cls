/// Created from: http://bswg2.95105813.cn:8080/AGW/services/AGWService?wsdl
Class dhcserviceclient.CA.GDCA.ax21.UserCertResp Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", CompileAfter = , Inheritance = right, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://service.agw/xsd";

Parameter XMLNAME = "UserCertResp";

Parameter XMLSEQUENCE = 1;

Property encCert As %String(MAXLEN = "", XMLNAME = "encCert");

Property result As %xsd.int(XMLNAME = "result");

Property sigCert As %String(MAXLEN = "", XMLNAME = "sigCert");

}
