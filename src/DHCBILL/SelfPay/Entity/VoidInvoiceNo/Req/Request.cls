Class DHCBILL.SelfPay.Entity.VoidInvoiceNo.Req.Request Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// TradeCode	交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// HospitalID	院区ID
Property HospitalID As %String(TRUNCATE = 1);

/// InvoiceType	票据类型
Property InvoiceType As %String(TRUNCATE = 1);

/// BatchNo	批次号码
Property BatchNo As %String(TRUNCATE = 1);

/// StartNo	本批次起始票号
Property StartNo As %String(TRUNCATE = 1);

/// EndNo	本批次结束票号
Property EndNo As %String(TRUNCATE = 1);

/// OutNo	自助机当前票号
Property OutNo As %String(TRUNCATE = 1);

/// VoidNum	跳号调整张数
Property VoidNum As %String(TRUNCATE = 1);

/// UserCode	用户代码
Property UserCode As %String(TRUNCATE = 1);

/// ExpStr	扩展
Property ExpStr As %String(TRUNCATE = 1);

}
