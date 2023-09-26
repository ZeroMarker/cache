Class dhcinterface.BankReturnMsg Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 银行代码
Property BankCode As %String(TRUNCATE = 1);

/// 银行业务流水号
Property TransactionId As %String(TRUNCATE = 1);

/// 交易代码
Property ActionCode As %String(TRUNCATE = 1);

/// 交易日期
Property TxDate As %String(TRUNCATE = 1);

/// 病人唯一主索引
Property PatientID As %String(TRUNCATE = 1);

/// 姓名
Property Name As %String(TRUNCATE = 1);

/// 证件类型
Property IDType As %String(TRUNCATE = 1);

/// 证件号
Property IDNo As %String(TRUNCATE = 1);

/// 工作密钥
Property TransferKey As %String(TRUNCATE = 1);

/// 结果标志
Property ResultCode As %String(TRUNCATE = 1);

/// 错误信息
Property ErrorMsg As %String(MAXLEN = 32768, TRUNCATE = 1);

/// 信息校验
Property MAC As %String(TRUNCATE = 1);

}
