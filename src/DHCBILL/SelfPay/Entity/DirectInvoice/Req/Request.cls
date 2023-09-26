/// / Creator:TianZJ
/// / CreatDate:2022-04-14
/// / Description:获取导诊单打印数据入参类
Class DHCBILL.SelfPay.Entity.DirectInvoice.Req.Request Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// InvoiceNo	发票号
Property InvoiceNo As %String(TRUNCATE = 1);

/// UserCode 用户代码
Property UserCode As %String(TRUNCATE = 1);

/// ExpStr	扩展信息
Property ExpStr As %String(TRUNCATE = 1);

}
