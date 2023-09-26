/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.hisInGdRecItm Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "hisInGdRecItm";

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property arriveDate As %TimeStamp(XMLNAME = "arriveDate", XMLTIMEZONE = "IGNORE");

Property batNo As %String(MAXLEN = "", XMLNAME = "batNo");

Property expdate As %TimeStamp(XMLNAME = "expdate", XMLTIMEZONE = "IGNORE");

Property hisNo As %String(MAXLEN = "", XMLNAME = "hisNo");

Property incBarCode As %String(MAXLEN = "", XMLNAME = "incBarCode");

Property ingdrecId As %Integer(XMLNAME = "ingdrecId");

Property invDate As %TimeStamp(XMLNAME = "invDate", XMLTIMEZONE = "IGNORE");

Property invNo As %String(MAXLEN = "", XMLNAME = "invNo");

Property labels As list Of %String(MAXLEN = "", XMLNAME = "labels", XMLPROJECTION = "ELEMENT");

Property orderDetailSubId As %String(MAXLEN = "", XMLNAME = "orderDetailSubId");

Property orderno As %String(MAXLEN = "", XMLNAME = "orderno");

Property purLocCode As %String(MAXLEN = "", XMLNAME = "purLocCode");

Property qty As %xsd.float(XMLNAME = "qty");

Property recLocCode As %String(MAXLEN = "", XMLNAME = "recLocCode");

Property rp As %xsd.float(XMLNAME = "rp");

Property vendorCode As %String(MAXLEN = "", XMLNAME = "vendorCode");

}
