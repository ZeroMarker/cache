/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.hisHvLabelWeb Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "hisHvLabelWeb";

Parameter XMLSEQUENCE = 1;

Property hopIncCode As %String(MAXLEN = "", XMLNAME = "hopIncCode");

Property hopVendorCode As %String(MAXLEN = "", XMLNAME = "hopVendorCode");

Property label As %String(MAXLEN = "", XMLNAME = "label");

Property ordDate As %TimeStamp(XMLNAME = "ordDate");

Property qty As %xsd.float(XMLNAME = "qty");

Property rp As %xsd.float(XMLNAME = "rp");

}
