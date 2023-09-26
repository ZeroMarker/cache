Class DHCExternalService.RegInterface.Entity.UpdateNotifyStatusRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLNAME = "UpdateNotifyStatusRt";

Parameter XMLIGNOREINVALIDTAG = 1;

Property UserID As %String(TRUNCATE = 1, XMLNAME = "UserID");

Property TradeCode As %String(TRUNCATE = 1, XMLNAME = "TradeCode");

Property ClientType As %String(TRUNCATE = 1, XMLNAME = "ClientType");

Property HospitalId As %String(TRUNCATE = 1, XMLNAME = "HospitalId");

Property ExtOrgCode As %String(TRUNCATE = 1, XMLNAME = "ExtOrgCode");

Property ExtUserID As %String(TRUNCATE = 1, XMLNAME = "ExtUserID");

Property OrderCode As %String(TRUNCATE = 1, XMLNAME = "OrderCode");

Property NotifyStatus As %String(TRUNCATE = 1, XMLNAME = "NotifyStatus");

}
