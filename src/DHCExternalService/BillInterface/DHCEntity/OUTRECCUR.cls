Class DHCExternalService.BillInterface.DHCEntity.OUTRECCUR Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// OUTCHECKDATE	对账日期
Property PayDate As %String(TRUNCATE = 1);

/// OUTRECEIVERNO	操作员编码
Property ExtUserID As %String(TRUNCATE = 1);

/// OUTMESSAGETYPE	4位消息类别H010-挂号 H020-缴费
Property FairType As %String(TRUNCATE = 1);

/// OUTMESSAGETYPEDESC	消息类别描述 挂号；缴费
Property TradeType As %String(TRUNCATE = 1);

/// OUTDATETIME	14位交易时间
Property TradeDate As %String(TRUNCATE = 1);

/// OUTCARDNO	登记号
Property PatientId As %String(TRUNCATE = 1);

/// OUTRCPTNO	发票ID
Property PrtStr As %String(TRUNCATE = 1);

/// OUTJEALL	账户交易金额（以分为单位）
Property TradeAmt As %String(TRUNCATE = 1);

/// OUTSTREAMNO	自助机交易流水号
Property HisTradeNo As %String(TRUNCATE = 1);

/// OUTYHTNo	银行交易流水号
Property OrderTradeId As %String(TRUNCATE = 1);

}
