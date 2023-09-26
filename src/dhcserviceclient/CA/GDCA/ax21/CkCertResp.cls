/// Created from: http://bswg2.95105813.cn:8080/AGW/services/AGWService?wsdl
Class dhcserviceclient.CA.GDCA.ax21.CkCertResp Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", CompileAfter = , Inheritance = right, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://service.agw/xsd";

Parameter XMLNAME = "CkCertResp";

Parameter XMLSEQUENCE = 1;

Property appID As %String(MAXLEN = "", XMLNAME = "appID");

Property certID As %String(MAXLEN = "", XMLNAME = "certID");

Property result As %xsd.int(XMLNAME = "result");

}
