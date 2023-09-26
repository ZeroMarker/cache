Class DHCBILL.SelfPay.Entity.AddIPDeposit.Res.Response Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// ResultCode 结果标志
Property ResultCode As %String(TRUNCATE = 1);

/// ResultMsg 结果描述
Property ResultMsg As %String(TRUNCATE = 1);

/// SerialNo 登记号
Property SerialNo As %String(TRUNCATE = 1);

Property ReceiptNo As %String(TRUNCATE = 1);

/// DepositAmount 押金总额
Property DepositAmount As %String(TRUNCATE = 1);

/// DepositBalance 押金余额
Property DepositBalance As %String(TRUNCATE = 1);

/// IsNeedRefund 第三方是否需要退款标识(1:是，<>1:否。HIS明确返回需退款时，第三方才退款，其他情况都不能主动退款)
Property IsNeedRefund As %String(TRUNCATE = 1);

}
