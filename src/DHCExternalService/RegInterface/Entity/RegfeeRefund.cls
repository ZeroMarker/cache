Class DHCExternalService.RegInterface.Entity.RegfeeRefund Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// TradeCode	2002	交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// HospitalId		医院唯一编号
Property HospitalId As %String(TRUNCATE = 1);

/// TransactionId		退费产生交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// OrderCode		预约单号
Property OrderCode As %String(TRUNCATE = 1);

/// PayBankCode		银行代码
Property PayBankCode As %String(TRUNCATE = 1);

/// PayCardNo		银行卡号
Property PayCardNo As %String(TRUNCATE = 1);

/// PayFee		支付费用
Property PayFee As %String(TRUNCATE = 1);

/// PayTradeNo		支付交易号
Property PayTradeNo As %String(TRUNCATE = 1);

/// PayDate		支付日期(YYYY-MM-DD)
Property PayDate As %String(TRUNCATE = 1);

/// PayTime		支付时间(HH:MM)
Property PayTime As %String(TRUNCATE = 1);

/// RefundDate		退费操作日期(YYYY-MM-DD)
Property RefundDate As %String(TRUNCATE = 1);

/// RefundTime		退费操作时间(HH:MM)
Property RefundTime As %String(TRUNCATE = 1);

/// PaidTransactionId		支付交易流水号
Property PaidTransactionId As %String(TRUNCATE = 1);

}
