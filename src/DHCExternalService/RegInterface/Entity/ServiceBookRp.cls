Class DHCExternalService.RegInterface.Entity.ServiceBookRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLNAME = "ServiceBookRp";

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1, XMLNAME = "ResultCode");

Property ResultContent As %String(TRUNCATE = 1, XMLNAME = "ResultContent");

Property TradeCode As %String(TRUNCATE = 1, XMLNAME = "TradeCode");

Property HospitalID As %String(TRUNCATE = 1, XMLNAME = "HospitalID");

Property HISDate As %String(TRUNCATE = 1, XMLNAME = "HISDate");

Property HISTradeNo As %String(TRUNCATE = 1, XMLNAME = "HISTradeNo");

Property SeqCode As %String(TRUNCATE = 1, XMLNAME = "SeqCode");

Property OrderCode As %String(TRUNCATE = 1, XMLNAME = "OrderCode");

Property AdmitRange As %String(TRUNCATE = 1, XMLNAME = "AdmitRange");

Property RegFee As %String(TRUNCATE = 1, XMLNAME = "RegFee");

Property AdmitAddress As %String(TRUNCATE = 1, XMLNAME = "AdmitAddress");

Property OrderContent As %String(TRUNCATE = 1, XMLNAME = "OrderContent");

Property ExtOrgCode As %String(TRUNCATE = 1, XMLNAME = "ExtOrgCode");

Property ScheduleItemCode As %String(TRUNCATE = 1, XMLNAME = "ScheduleItemCode");

Property AdmitDate As %String(TRUNCATE = 1, XMLNAME = "AdmitDate");

Property Items As list Of DHCExternalService.RegInterface.Entity.ServiceScheduleVisit(XMLITEMNAME = "Schedule", XMLNAME = "Items", XMLPROJECTION = "COLLECTION");

}
