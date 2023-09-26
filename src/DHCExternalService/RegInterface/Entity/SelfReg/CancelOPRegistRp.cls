Class DHCExternalService.RegInterface.Entity.SelfReg.CancelOPRegistRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易结果：0：需要进行医保挂号；100:不需要医保挂号；其他
Property ResultCode As %String(TRUNCATE = 1);

/// 详细描述信息
Property ResultContent As %String(TRUNCATE = 1);

/// 退现金金额（需第三方执行）
Property CashAmt As %String(TRUNCATE = 1);

/// 退银行卡金额（需第三方执行）
Property BankCardAmt As %String(TRUNCATE = 1);

/// 退返预交金额（HIS方执行）
Property CardPrepayAmt As %String(TRUNCATE = 1);

/// 医保就医信息（内容视项目制定，不为空时需医保退号，一般由第三方执行）
Property InsuInfo As %String(TRUNCATE = 1);

/// 银行代码
Property BankCode As %String(TRUNCATE = 1);

/// 原银行流水号
Property BankTradeNo As %String(TRUNCATE = 1);

/// 客户银行账号，银行卡卡号
Property BankCardNO As %String(TRUNCATE = 1);

}
