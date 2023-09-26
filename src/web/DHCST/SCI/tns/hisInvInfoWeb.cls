/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.hisInvInfoWeb Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "hisInvInfoWeb";

Parameter XMLSEQUENCE = 1;

Property hisInvInfoItmWebs As list Of web.DHCST.SCI.tns.hisInvInfoItmWeb(XMLNAME = "hisInvInfoItmWebs", XMLPROJECTION = "ELEMENT");

Property resultCode As %String(MAXLEN = "", XMLNAME = "resultCode");

Property resultContent As %String(MAXLEN = "", XMLNAME = "resultContent");

}
