Class DHCExternalService.RegInterface.Entity.SelfAppt.OPAppArriveRq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 医院唯一编号
Property HospitalId As %String(TRUNCATE = 1);

/// 预约时的交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// 预约单号
Property OrderCode As %String(TRUNCATE = 1);

/// 取号日期(YYYY-MM-DD)
Property PayDate As %String(TRUNCATE = 1);

/// 取号人
Property PatientID As %String(TRUNCATE = 1);

/// 操作员
Property ExtUserID As %String(TRUNCATE = 1);

/// 取号时间(HH:MM)
Property PayTime As %String(TRUNCATE = 1);

/// 支付方式代码(1:现金2:银行卡3:POS4:预交金)
Property PayModeCode As %String(TRUNCATE = 1);

/// 支付交易信息串（应该包括银行代码、支付卡号、银行交易日期、银行交易流水号）
Property PayTradeStr As %String(TRUNCATE = 1);

Property BankTradeInfo As %String(TRUNCATE = 1);

/// PayDetails	支付宝、微信接口支付信息
Property PayDetails As DHCBILL.SelfPay.Entity.CompleteCharge.Req.PayDetails;

/// 医保支付信息串
Property PayInsuFeeStr As %String(TRUNCATE = 1);

}
