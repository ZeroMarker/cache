Class DHCExternalService.CardInterface.Entity.OPAcc.AddOPDepositRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLSEQUENCE = 0;

Property TradeCode As %String(TRUNCATE = 1);

Property TransactionId As %String(TRUNCATE = 1);

Property TerminalID As %String(TRUNCATE = 1);

Property HospitalId As %String(TRUNCATE = 1);

Property ExtUserID As %String(TRUNCATE = 1);

Property PatientCard As %String(TRUNCATE = 1);

Property CardTypeCode As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property AccountID As %String(TRUNCATE = 1);

Property Amount As %String(TRUNCATE = 1);

Property PayModeCode As %String(TRUNCATE = 1);

Property BankCode As %String(TRUNCATE = 1);

Property BankAccDate As %String(TRUNCATE = 1);

Property BankTransactionId As %String(TRUNCATE = 1);

Property BankCardNo As %String(TRUNCATE = 1);

Property AccountPassword As %String(TRUNCATE = 1);

}
