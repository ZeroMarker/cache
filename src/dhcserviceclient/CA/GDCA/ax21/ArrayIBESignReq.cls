/// Created from: http://bswg2.95105813.cn:8080/AGW/services/AGWService?wsdl
Class dhcserviceclient.CA.GDCA.ax21.ArrayIBESignReq Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", CompileAfter = , Inheritance = right, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://service.agw/xsd";

Parameter XMLNAME = "ArrayIBESignReq";

Parameter XMLSEQUENCE = 1;

Property appID As %String(MAXLEN = "", XMLNAME = "appID");

Property fpItems As list Of dhcserviceclient.CA.GDCA.ax21.FingerprintItem(XMLNAME = "fpItems", XMLPROJECTION = "ELEMENT");

Property isTimeAttached As %xsd.int(XMLNAME = "isTimeAttached");

Property operID As %String(MAXLEN = "", XMLNAME = "operID");

Property orgData As %xsd.base64Binary(XMLNAME = "orgData");

Property userInfo As %String(MAXLEN = "", XMLNAME = "userInfo");

}
