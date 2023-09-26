/// 账户预缴金信息
Class DHCExternalService.BillInterface.DHCEntity.AccPreDeposit Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 退款原因
Property BackReason As %String(TRUNCATE = 1);

/// 银行的RowID
Property Bank As %String(TRUNCATE = 1);

/// 银行卡的RowID
Property BankCardType As %String(TRUNCATE = 1);

Property CardChequeNo As %String(TRUNCATE = 1);

Property ChequeDate As %String(TRUNCATE = 1);

Property PayAccNo As %String(TRUNCATE = 1);

Property PayCompany As %String(TRUNCATE = 1);

/// 支付方式的RowID
Property PayMode As %String(TRUNCATE = 1);

/// 预交金日期
Property PreDate As %Date;

/// 预交金时间
Property PreTime As %Time;

/// 预交金打印的票据号码
Property ReceiptsNo As %String(TRUNCATE = 1);

Property Remark As %String(TRUNCATE = 1);

/// 操作人员
Property UserDR As %String(TRUNCATE = 1);

/// 预交金金额
Property amt As %String(TRUNCATE = 1);

}
