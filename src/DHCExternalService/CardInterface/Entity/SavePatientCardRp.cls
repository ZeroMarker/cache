/// 发就诊卡
Class DHCExternalService.CardInterface.Entity.SavePatientCardRp Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNORENULL = 1;

Property TradeCode As %String(TRUNCATE = 1);

Property CardTypeCode As %String(TRUNCATE = 1);

Property PatientCard As %String(TRUNCATE = 1);

Property SecurityNo As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(MAXLEN = 256, TRUNCATE = 1);

Property ActiveFlag As %String(TRUNCATE = 1);

Property TransactionId As %String(TRUNCATE = 1);

Property DepositAmount As %String(TRUNCATE = 1);

}
