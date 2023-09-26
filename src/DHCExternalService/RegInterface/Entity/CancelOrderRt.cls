Class DHCExternalService.RegInterface.Entity.CancelOrderRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLNAME = "CancelOrderRt";

Parameter XMLIGNOREINVALIDTAG = 1;

Property UserID As %String(TRUNCATE = 1, XMLNAME = "UserID");

Property TradeCode As %String(TRUNCATE = 1, XMLNAME = "TradeCode");

Property ClientType As %String(TRUNCATE = 1, XMLNAME = "ClientType");

Property HospitalId As %String(TRUNCATE = 1, XMLNAME = "HospitalId");

Property ExtOrgCode As %String(TRUNCATE = 1, XMLNAME = "ExtOrgCode");

Property ExtUserID As %String(TRUNCATE = 1, XMLNAME = "ExtUserID");

Property TransactionId As %String(TRUNCATE = 1, XMLNAME = "TransactionId");

Property OrderCode As %String(TRUNCATE = 1, XMLNAME = "OrderCode");

Property OrderTypeCode As %String(TRUNCATE = 1, XMLNAME = "OrderTypeCode");

}
