/// 返回到 银行的类
Class web.DHCEntity.BankREG.BankReturnCode Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 错误信息（当ResultCode=1时有值）
Property ErrorMsg As %String(TRUNCATE = 1);

/// 姓
Property FirstName As %String(TRUNCATE = 1);

/// 身份证号
Property IDCode As %String(TRUNCATE = 1);

/// 名
Property LastName As %String(TRUNCATE = 1);

/// MAC(信息校验)
Property MAC As %String(TRUNCATE = 1);

/// 病人唯一主索引
Property PatientID As %String(TRUNCATE = 1);

/// 结果标志（000-成功、001-失败）
Property ResultCode As %String(TRUNCATE = 1);

Property ActionCode As %String(TRUNCATE = 1);

Property BankCode As %String(TRUNCATE = 1);

Property TransactionId As %String(TRUNCATE = 1);

}
