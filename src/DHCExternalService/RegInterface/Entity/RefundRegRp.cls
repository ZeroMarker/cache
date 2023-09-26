Class DHCExternalService.RegInterface.Entity.RefundRegRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLNAME = "RefundRegRp";

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1, XMLNAME = "ResultCode");

Property ResultContent As %String(TRUNCATE = 1, XMLNAME = "ResultContent");

Property TradeCode As %String(TRUNCATE = 1, XMLNAME = "TradeCode");

Property HospitalID As %String(TRUNCATE = 1, XMLNAME = "HospitalID");

Property HISDate As %String(TRUNCATE = 1, XMLNAME = "HISDate");

Property HISTradeNo As %String(TRUNCATE = 1, XMLNAME = "HISTradeNo");

Property OrgOrderCode As %String(TRUNCATE = 1, XMLNAME = "OrgOrderCode");

Property ExtOrgCode As %String(TRUNCATE = 1, XMLNAME = "ExtOrgCode");

Property OrgHISTradeNo As %String(TRUNCATE = 1, XMLNAME = "OrgHISTradeNo");

}
