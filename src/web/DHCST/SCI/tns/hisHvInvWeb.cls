/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.hisHvInvWeb Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "hisHvInvWeb";

Parameter XMLSEQUENCE = 1;

Property invDate As %TimeStamp(XMLNAME = "invDate");

Property invNo As %String(MAXLEN = "", XMLNAME = "invNo");

Property resultCode As %String(MAXLEN = "", XMLNAME = "resultCode");

Property resultContent As %String(MAXLEN = "", XMLNAME = "resultContent");

}
