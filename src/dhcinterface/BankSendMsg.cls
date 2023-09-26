/// 银医卡请求消息定义
Class dhcinterface.BankSendMsg Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
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

/// 用户
Property UserDR As %String(TRUNCATE = 1);

/// 校验码
Property MAC As %String(TRUNCATE = 1);

/// 病人信息集合
Property PatientDetails As list Of dhcinterface.BankPatDetail;

}
