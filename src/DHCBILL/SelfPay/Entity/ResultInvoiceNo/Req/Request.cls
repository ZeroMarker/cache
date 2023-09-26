Class DHCBILL.SelfPay.Entity.ResultInvoiceNo.Req.Request Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
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

/// BatchNo 票据代码
Property BatchNo As %String(TRUNCATE = 1);

/// InvNo	发票号
Property InvNo As %String(TRUNCATE = 1);

/// UserCode	用户代码
Property UserCode As %String(TRUNCATE = 1);

/// ResultFlag	打印结果标志
Property ResultFlag As %String(TRUNCATE = 1);

}
