Class DHCExternalService.RegInterface.Entity.SelfReg.OPRapidRegistRq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// 预约机构
Property ExtOrgCode As %String(TRUNCATE = 1);

/// 客户端类型
Property ClientType As %String(TRUNCATE = 1);

/// 医院唯一编号
Property HospitalId As %String(TRUNCATE = 1);

/// 终端编码
Property TerminalID As %String(TRUNCATE = 1);

/// 门诊排班项记录标识
Property ScheduleItemCode As %String(TRUNCATE = 1);

/// 操作员代码
Property ExtUserID As %String(TRUNCATE = 1);

/// 卡号
Property PatientCard As %String(TRUNCATE = 1);

/// 卡类型
Property CardType As %String(TRUNCATE = 1);

/// 病人ID
Property PatientID As %String(TRUNCATE = 1);

/// 银行代码
Property PayBankCode As %String(TRUNCATE = 1);

/// 银行卡号
Property PayCardNo As %String(TRUNCATE = 1);

/// 支付方式代码(2:银医卡,1:现金)
Property PayModeCode As %String(TRUNCATE = 1);

/// 个人支付费用
Property PayFee As %String(TRUNCATE = 1);

/// 医保支付信息串
Property PayInsuFeeStr As %String(TRUNCATE = 1);

/// 支付交易号
Property PayTradeNo As %String(TRUNCATE = 1);

/// 银行支付交易信息
Property PayTradeStr As %String(MAXLEN = 32767, TRUNCATE = 1);

/// 银行支付交易信息
Property BankTradeInfo As %String(MAXLEN = 32767, TRUNCATE = 1);

/// 移动订单号
Property PayOrderId As %String(TRUNCATE = 1);

/// 交易时间
Property PayTime As %String(TRUNCATE = 1);

/// PayDetails	支付宝、微信接口支付信息
Property PayDetails As DHCBILL.SelfPay.Entity.CompleteCharge.Req.PayDetails;

/// 费别ID
Property BillTypeID As %String(TRUNCATE = 1);

}
