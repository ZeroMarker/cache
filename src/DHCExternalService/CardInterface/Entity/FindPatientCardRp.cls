/// 就诊卡查询
Class DHCExternalService.CardInterface.Entity.FindPatientCardRp Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property TradeCode As %String(TRUNCATE = 1);

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(MAXLEN = 256, TRUNCATE = 1);

Property CardDepositAmt As %String(TRUNCATE = 1);

Property CardTypeCode As %String(TRUNCATE = 1);

Property PatientCard As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

}
