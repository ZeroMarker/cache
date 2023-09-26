Class DHCExternalService.CardInterface.Entity.PartientCardReissueRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock, SoapBodyUse = literal ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 操作员代码
Property ExtUserID As %String(TRUNCATE = 1);

/// 卡类型
Property CardTypeCode As %String(TRUNCATE = 1);

/// 证件类型
Property PatientCard As %String(TRUNCATE = 1);

/// 证件类型
Property IDCardType As %String(TRUNCATE = 1);

/// 证件号
Property IDNo As %String(TRUNCATE = 1);

/// 病人姓名
Property PatientName As %String(TRUNCATE = 1);

/// 手机号
Property Mobile As %String(TRUNCATE = 1);

/// 帐户密码
Property AccountPassword As %String(TRUNCATE = 1);

/// 老卡类型
Property OldCardType As %String(TRUNCATE = 1);

/// 老卡号
Property OldPatientCard As %String(TRUNCATE = 1);

/// 卡费用金额
Property CardDepositAmt As %String(TRUNCATE = 1);

/// 支付方式
Property PayModeCode As %String(TRUNCATE = 1);

/// 终端编号
Property TerminalID As %String(TRUNCATE = 1);

/// 院区ID
Property HospitalId As %String(TRUNCATE = 1);

/// PayDetails	支付宝、微信接口支付信息
Property PayDetails As DHCBILL.SelfPay.Entity.CompleteCharge.Req.PayDetails;

}
