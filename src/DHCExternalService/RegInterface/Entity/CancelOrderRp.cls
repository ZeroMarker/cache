Class DHCExternalService.RegInterface.Entity.CancelOrderRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLNAME = "CancelOrderRp";

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1, XMLNAME = "ResultCode");

Property ResultContent As %String(TRUNCATE = 1, XMLNAME = "ResultContent");

Property TransactionId As %String(TRUNCATE = 1, XMLNAME = "TransactionId");

Property OrderCode As %String(TRUNCATE = 1, XMLNAME = "OrderCode");

}
