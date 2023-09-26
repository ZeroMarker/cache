/// Created from: http://bswg2.95105813.cn:8080/AGW/services/AGWService?wsdl
Class dhcserviceclient.CA.GDCA.ax21.VeStampReq Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", CompileAfter = , Inheritance = right, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://service.agw/xsd";

Parameter XMLNAME = "VeStampReq";

Parameter XMLSEQUENCE = 1;

Property appID As %String(MAXLEN = "", XMLNAME = "appID");

Property operID As %String(MAXLEN = "", XMLNAME = "operID");

Property orgData As %String(MAXLEN = "", XMLNAME = "orgData");

Property sealData As %String(MAXLEN = "", XMLNAME = "sealData");

Property tsaCert As %String(MAXLEN = "", XMLNAME = "tsaCert");

}
