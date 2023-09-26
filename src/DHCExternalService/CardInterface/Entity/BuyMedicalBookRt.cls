Class DHCExternalService.CardInterface.Entity.BuyMedicalBookRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLSEQUENCE = 0;

Property TradeCode As %String(TRUNCATE = 1);

Property CardTypeCode As %String(TRUNCATE = 1);

Property PatientCard As %String(TRUNCATE = 1);

Property SecurityNo As %String(TRUNCATE = 1);

Property PayModeCode As %String(TRUNCATE = 1);

Property ExtUserID As %String(TRUNCATE = 1);

}
