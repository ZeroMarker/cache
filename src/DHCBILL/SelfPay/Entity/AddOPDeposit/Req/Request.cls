Class DHCBILL.SelfPay.Entity.AddOPDeposit.Req.Request Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// TradeCode	交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// HospitalID	院区ID
Property HospitalID As %String(TRUNCATE = 1);

/// CardNo	卡号
Property CardNo As %String(TRUNCATE = 1);

/// CardType	卡类型
Property CardType As %String(TRUNCATE = 1);

/// SecrityNo	校验码
Property SecrityNo As %String(TRUNCATE = 1);

/// PassWord 密码
Property PassWord As %String(TRUNCATE = 1);

/// PatientID	患者ID(HIS登记号)
Property PatientID As %String(TRUNCATE = 1);

/// UserCode 用户代码
Property UserCode As %String(TRUNCATE = 1);

/// TerminalID 终端号（自助机编号）
Property TerminalID As %String(TRUNCATE = 1);

/// TradeChannel 接入方代码
Property TradeChannel As %String(TRUNCATE = 1);

/// AccountID 院内账户号
Property AccountID As %String(TRUNCATE = 1);

/// RefundAmt 退款金额
Property RefundAmt As %String(TRUNCATE = 1);

/// 退款方式
Property RefundMode As %String(TRUNCATE = 1);

/// RefundDepositDr 退款原纪录
Property RefundDepositDr As %String(TRUNCATE = 1);

/// 退款记录
Property RefundDepID As %String(TRUNCATE = 1);

Property HisTradeNo As %String(TRUNCATE = 1);

Property CommitFlag As %String(TRUNCATE = 1);

/// PayDetails	就诊信息列表
Property PayDetails As DHCBILL.SelfPay.Entity.AddOPDeposit.Req.PayDetails;

/// ExpStr	扩展信息
Property ExpStr As %String(TRUNCATE = 1);

}
