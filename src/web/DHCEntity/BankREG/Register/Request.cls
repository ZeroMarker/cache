/// 
Class web.DHCEntity.BankREG.Register.Request Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 交易代码
Property ActionCode As %String(TRUNCATE = 1);

/// 银行代码
Property BankCode As %String(TRUNCATE = 1);

/// 患者信息 
Property PatientDetails As web.DHCEntity.BankREG.PatientInfo;

/// 银行业务流水号
Property TransactionId As %String(TRUNCATE = 1);

}
