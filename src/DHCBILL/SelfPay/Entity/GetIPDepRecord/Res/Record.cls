Class DHCBILL.SelfPay.Entity.GetIPDepRecord.Res.Record Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// PayDate 交押金时间
Property PayDate As %String(TRUNCATE = 1);

/// PayTime 交押金时间
Property PayTime As %String(TRUNCATE = 1);

/// PayAmout 支付金额
Property PayAmout As %String(TRUNCATE = 1);

/// PayMode 支付方式
Property PayMode As %String(TRUNCATE = 1);

/// PayFlag 押金状态
Property PayFlag As %String(TRUNCATE = 1);

/// ReceiptNo 收据号
Property ReceiptNo As %String(TRUNCATE = 1);

/// PayUserCode 收款员工号
Property PayUserCode As %String(TRUNCATE = 1);

/// PayUserName 收款员名字
Property PayUserName As %String(TRUNCATE = 1);

/// PayDept 押金科室
Property PayDept As %String(TRUNCATE = 1);

/// PayWard 押金病区
Property PayWard As %String(TRUNCATE = 1);

/// Remark
Property Remark As %String(TRUNCATE = 1);

}
