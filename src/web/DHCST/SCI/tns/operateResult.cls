/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.operateResult Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "operateResult";

Parameter XMLSEQUENCE = 1;

Property resultCode As %String(MAXLEN = "", XMLNAME = "resultCode");

Property resultContent As %String(MAXLEN = "", XMLNAME = "resultContent");

Property resultValue As %String(MAXLEN = "", XMLNAME = "resultValue");

}
