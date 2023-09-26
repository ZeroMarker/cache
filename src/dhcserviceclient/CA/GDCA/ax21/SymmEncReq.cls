/// Created from: http://bswg2.95105813.cn:8080/AGW/services/AGWService?wsdl
Class dhcserviceclient.CA.GDCA.ax21.SymmEncReq Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", CompileAfter = , Inheritance = right, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://service.agw/xsd";

Parameter XMLNAME = "SymmEncReq";

Parameter XMLSEQUENCE = 1;

Property appID As %String(MAXLEN = "", XMLNAME = "appID");

Property key As %String(MAXLEN = "", XMLNAME = "key") [ SqlFieldName = _key ];

Property operID As %String(MAXLEN = "", XMLNAME = "operID");

Property orgDate As %String(MAXLEN = "", XMLNAME = "orgDate");

Property symmAlgo As %String(MAXLEN = "", XMLNAME = "symmAlgo");

}
