Class DHCBILL.SelfPay.Entity.AddOPDeposit.Res.Response Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// ResultCode 结果标志
Property ResultCode As %String(TRUNCATE = 1);

/// ResultMsg 结果描述
Property ResultMsg As %String(TRUNCATE = 1);

/// SerialNo 充值流水号
Property SerialNo As %String(TRUNCATE = 1);

/// AccountID 院内账户号
Property AccountID As %String(TRUNCATE = 1);

/// BeforeBalAmt 充值前余额
Property BeforeBalAmt As %String(TRUNCATE = 1);

/// BalanceAmt 当前余额
Property BalanceAmt As %String(TRUNCATE = 1);

/// LimitAmt 充值限额
Property LimitAmt As %String(TRUNCATE = 1);

/// 退款记录
Property RefundDepID As %String(TRUNCATE = 1);

/// IsNeedRefund 第三方是否需要退款标识(1:是，<>1:否。HIS明确返回需退款时，第三方才退款，其他情况都不能主动退款)
Property IsNeedRefund As %String(TRUNCATE = 1);

}
