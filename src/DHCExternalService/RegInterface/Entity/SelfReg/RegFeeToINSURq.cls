Class DHCExternalService.RegInterface.Entity.SelfReg.RegFeeToINSURq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
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

/// 终端编码
Property TerminalID As %String(TRUNCATE = 1);

/// 医院唯一编号
Property HospitalId As %String(TRUNCATE = 1);

/// 操作员代码
Property ExtUserID As %String(TRUNCATE = 1);

/// 就诊id
Property AdmNo As %String(TRUNCATE = 1);

/// 支付方式code
Property PayModeCode As %String(TRUNCATE = 1);

/// 医疗类别
Property InsuYLLB As %String(TRUNCATE = 1);

/// 参保类别
Property InsuCBLB As %String(TRUNCATE = 1);

/// 银行卡号
Property PayCardNo As %String(TRUNCATE = 1);

/// 医保支付信息串
Property PayInsuFeeStr As %String(TRUNCATE = 1);

/// 支付交易号
Property PayTradeNo As %String(TRUNCATE = 1);

/// 个人支付费用
Property PayFee As %String(TRUNCATE = 1);

}
