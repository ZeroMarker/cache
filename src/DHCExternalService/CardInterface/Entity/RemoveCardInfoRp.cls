Class DHCExternalService.CardInterface.Entity.RemoveCardInfoRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLSEQUENCE = 0;

Property TradeCode As %String(TRUNCATE = 1);

Property TransactionId As %String(TRUNCATE = 1);

Property ResultCode As %String(TRUNCATE = 1);

Property ErrorMsg As %String(TRUNCATE = 1);

}
