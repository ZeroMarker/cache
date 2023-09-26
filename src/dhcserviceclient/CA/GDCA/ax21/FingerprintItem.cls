/// Created from: http://bswg2.95105813.cn:8080/AGW/services/AGWService?wsdl
Class dhcserviceclient.CA.GDCA.ax21.FingerprintItem Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", CompileAfter = , Inheritance = right, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://service.agw/xsd";

Parameter XMLNAME = "FingerprintItem";

Parameter XMLSEQUENCE = 1;

Property data As %xsd.base64Binary(XMLNAME = "data");

Property type As %String(MAXLEN = "", XMLNAME = "type");

}
