Class DHCExternalService.CardInterface.Entity.RemoveCardInfoRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLSEQUENCE = 0;

Property TradeCode As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property BankCode As %String(TRUNCATE = 1);

Property IDType As %String(TRUNCATE = 1);

Property IDNo As %String(TRUNCATE = 1);

Property PatientName As %String(TRUNCATE = 1);

Property TransactionId As %String(TRUNCATE = 1);

Property CardTypeCode As %String(TRUNCATE = 1);

Property PatientCard As %String(TRUNCATE = 1);

Property ExtUserID As %String(TRUNCATE = 1);

}
