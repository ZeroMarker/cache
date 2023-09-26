Class DHCExternalService.CardInterface.Entity.OPAcc.NewOPAccountRp Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNORENULL = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(MAXLEN = 256, TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property AccountID As %String(TRUNCATE = 1);

Property DepositAmount As %String(TRUNCATE = 1);

}
