Class DHCBILL.SelfPay.Entity.VoidInvoiceNo.Res.Response Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// ResultCode 结果标志
Property ResultCode As %String(TRUNCATE = 1);

/// ResultMsg 结果描述
Property ResultMsg As %String(TRUNCATE = 1);

/// InvoiceType 票据类型
Property InvoiceType As %String(TRUNCATE = 1);

/// BatchNo 批次号
Property BatchNo As %String(TRUNCATE = 1);

/// StartNo 起始票号
Property StartNo As %String(TRUNCATE = 1);

/// EndNo 结束票号
Property EndNo As %String(TRUNCATE = 1);

/// CurrentNo 当前可用号
Property CurrentNo As %String(TRUNCATE = 1);

}
