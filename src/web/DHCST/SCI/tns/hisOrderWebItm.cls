/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.hisOrderWebItm Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "hisOrderWebItm";

Parameter XMLSEQUENCE = 1;

Property demandDate As %TimeStamp(XMLNAME = "demandDate");

Property desction As %String(MAXLEN = "", XMLNAME = "desction");

Property emflag As %String(MAXLEN = "", XMLNAME = "emflag");

Property hisId As %String(MAXLEN = "", XMLNAME = "hisId");

Property hisno As %String(MAXLEN = "", XMLNAME = "hisno");

Property hopBarCode As %String(MAXLEN = "", XMLNAME = "hopBarCode");

Property location As %String(MAXLEN = "", XMLNAME = "location");

Property planDate As %TimeStamp(XMLNAME = "planDate");

Property purloc As %String(MAXLEN = "", XMLNAME = "purloc");

Property qty As %xsd.float(XMLNAME = "qty");

Property recloc As %String(MAXLEN = "", XMLNAME = "recloc");

Property remark As %String(MAXLEN = "", XMLNAME = "remark");

Property rp As %xsd.float(XMLNAME = "rp");

Property vendorBarCode As %String(MAXLEN = "", XMLNAME = "vendorBarCode");

}
