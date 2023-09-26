/// 专门针对发 补 卡的收费记录
Class DHCExternalService.BillInterface.DHCEntity.CardINVPRT Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 卡收费金额
Property CardFareCost As %String(TRUNCATE = 1);

/// 银行的RowID
Property Bank As %String(TRUNCATE = 1);

/// PA_PatMas 表的RowID 
Property PAPMIRowID As %String(TRUNCATE = 1);

/// 支票号码/ 卡号码
Property CardChequeNo As %String(TRUNCATE = 1);

Property Flag As %String(TRUNCATE = 1);

/// 银行卡的RowID
/// 不是DHC_CardRef的RowID
Property BankCardType As %String(TRUNCATE = 1);

Property ChequeDate As %String(TRUNCATE = 1);

/// 操作用户
Property UserDR As %String(TRUNCATE = 1);

/// 生成发票的日期
Property Date As %Date;

Property PayAccNo As %String(TRUNCATE = 1);

/// 发票号码
Property ReceiptNO As %String(TRUNCATE = 1);

/// 打印发票时间
Property Time As %Time;

/// 支付模式的RowID
Property PayMode As %String(TRUNCATE = 1);

/// 支付单位
Property PayCompany As %String(TRUNCATE = 1);

Property Remark As %String(TRUNCATE = 1);

}
