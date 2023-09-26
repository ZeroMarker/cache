/// Created from: http://bswg2.95105813.cn:8080/AGW/services/AGWService?wsdl
Class dhcserviceclient.CA.GDCA.ax21.HashReq Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", CompileAfter = , Inheritance = right, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://service.agw/xsd";

Parameter XMLNAME = "HashReq";

Parameter XMLSEQUENCE = 1;

Property appID As %String(MAXLEN = "", XMLNAME = "appID");

Property hashAlgo As %String(MAXLEN = "", XMLNAME = "hashAlgo");

Property operID As %String(MAXLEN = "", XMLNAME = "operID");

Property orgDate As %String(MAXLEN = "", XMLNAME = "orgDate");

}
