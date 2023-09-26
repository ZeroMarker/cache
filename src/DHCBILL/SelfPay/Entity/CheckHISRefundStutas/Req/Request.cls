Class DHCBILL.SelfPay.Entity.CheckHISRefundStutas.Req.Request Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
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

/// PatientID	患者ID(HIS登记号)
Property PatientID As %String(TRUNCATE = 1);

/// UserCode 用户代码
Property UserCode As %String(TRUNCATE = 1);

/// TerminalID 终端号（自助机编号）
Property TerminalID As %String(TRUNCATE = 1);

/// TradeChannel 接入厂商
Property TradeChannel As %String(TRUNCATE = 1);

/// StartDate	开始日期
Property PrtInvID As %String(TRUNCATE = 1);

/// 发票金额
Property PrtAmt As %String(TRUNCATE = 1);

/// 原订单号
Property OrderNo As %String(TRUNCATE = 1);

/// 退款金额
Property RefAmt As %String(TRUNCATE = 1);

Property ExpStr As %String(TRUNCATE = 1);

}
