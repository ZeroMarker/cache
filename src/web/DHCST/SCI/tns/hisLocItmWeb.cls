/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.hisLocItmWeb Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "hisLocItmWeb";

Parameter XMLSEQUENCE = 1;

Property code As %String(MAXLEN = "", XMLNAME = "code");

Property id As %String(MAXLEN = "", XMLNAME = "id");

Property name As %String(MAXLEN = "", XMLNAME = "name");

}
