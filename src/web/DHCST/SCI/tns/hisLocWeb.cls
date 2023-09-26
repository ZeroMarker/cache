/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.hisLocWeb Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "hisLocWeb";

Parameter XMLSEQUENCE = 1;

Property hisLocItmWebs As list Of web.DHCST.SCI.tns.hisLocItmWeb(XMLNAME = "hisLocItmWebs", XMLPROJECTION = "ELEMENT");

Property passWord As %String(MAXLEN = "", XMLNAME = "passWord");

Property userName As %String(MAXLEN = "", XMLNAME = "userName");

}
