/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.hisOrderItmWebVo Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "hisOrderItmWebVo";

Parameter XMLSEQUENCE = 1;

Property hopIncCode As %String(MAXLEN = "", XMLNAME = "hopIncCode");

Property qty As %xsd.float(XMLNAME = "qty");

Property rp As %xsd.float(XMLNAME = "rp");

}
