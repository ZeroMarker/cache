/// Created from: http://bswg2.95105813.cn:8080/AGW/services/AGWService?wsdl
Class dhcserviceclient.CA.GDCA.ax21.CertOIDReq Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", CompileAfter = , Inheritance = right, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://service.agw/xsd";

Parameter XMLNAME = "CertOIDReq";

Parameter XMLSEQUENCE = 1;

Property cert As %String(MAXLEN = "", XMLNAME = "cert");

Property oid As %String(MAXLEN = "", XMLNAME = "oid");

}
