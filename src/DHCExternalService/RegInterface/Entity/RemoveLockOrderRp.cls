Class DHCExternalService.RegInterface.Entity.RemoveLockOrderRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLNAME = "RemoveLockOrderRp";

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1, XMLNAME = "ResultCode");

Property ResultContent As %String(TRUNCATE = 1, XMLNAME = "ResultContent");

Property TradeCode As %String(TRUNCATE = 1, XMLNAME = "TradeCode");

Property HospitalID As %String(TRUNCATE = 1, XMLNAME = "HospitalID");

Property HISDate As %String(TRUNCATE = 1, XMLNAME = "HISDate");

Property HISTradeNo As %String(TRUNCATE = 1, XMLNAME = "HISTradeNo");

Property ExtOrgCode As %String(TRUNCATE = 1, XMLNAME = "ExtOrgCode");

}
