/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.hisOrderWebVo Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "hisOrderWebVo";

Parameter XMLSEQUENCE = 1;

Property deliverdate As %TimeStamp(XMLNAME = "deliverdate");

Property desction As %String(MAXLEN = "", XMLNAME = "desction");

Property emflag As %String(MAXLEN = "", XMLNAME = "emflag");

Property hisOrderItmWebVos As list Of web.DHCST.SCI.tns.hisOrderItmWebVo(XMLNAME = "hisOrderItmWebVos", XMLPROJECTION = "ELEMENT");

Property hopname As %String(MAXLEN = "", XMLNAME = "hopname");

Property orderno As %String(MAXLEN = "", XMLNAME = "orderno");

Property planDate As %TimeStamp(XMLNAME = "planDate");

Property purloc As %String(MAXLEN = "", XMLNAME = "purloc");

Property recloc As %String(MAXLEN = "", XMLNAME = "recloc");

Property remark As %String(MAXLEN = "", XMLNAME = "remark");

Property vendorname As %String(MAXLEN = "", XMLNAME = "vendorname");

}
