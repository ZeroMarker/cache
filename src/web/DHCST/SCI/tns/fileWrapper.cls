/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.fileWrapper Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "fileWrapper";

Parameter XMLSEQUENCE = 1;

Property file As %xsd.base64Binary(XMLNAME = "file");

Property fileExtension As %String(MAXLEN = "", XMLNAME = "fileExtension");

Property fileName As %String(MAXLEN = "", XMLNAME = "fileName");

Property resultCode As %String(MAXLEN = "", XMLNAME = "resultCode");

Property resultContent As %String(MAXLEN = "", XMLNAME = "resultContent");

}
