Class DHCExternalService.RegInterface.Entity.RemoveLockOrderRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLNAME = "RemoveLockOrderRt";

Parameter XMLIGNOREINVALIDTAG = 1;

Property TradeCode As %String(TRUNCATE = 1, XMLNAME = "TradeCode");

Property ClientType As %String(TRUNCATE = 1, XMLNAME = "ClientType");

Property HospitalId As %String(TRUNCATE = 1, XMLNAME = "HospitalID");

Property ExtUserID As %String(TRUNCATE = 1, XMLNAME = "ExtUserID");

Property BankID As %String(TRUNCATE = 1, XMLNAME = "BankID");

Property TerminalID As %String(TRUNCATE = 1, XMLNAME = "TerminalID");

Property BankDate As %String(TRUNCATE = 1, XMLNAME = "BankDate");

Property BankTradeNo As %String(TRUNCATE = 1, XMLNAME = "BankTradeNo");

Property ScheduleItemCode As %String(TRUNCATE = 1, XMLNAME = "ScheduleItemCode");

Property CardNo As %String(TRUNCATE = 1, XMLNAME = "PayCardNo");

Property CredTypeCode As %String(TRUNCATE = 1, XMLNAME = "CredTypeCode");

Property IDCardNo As %String(TRUNCATE = 1, XMLNAME = "IDCardNo");

Property LockQueueNo As %String(TRUNCATE = 1, XMLNAME = "LockQueueNo");

Property PatientName As %String(TRUNCATE = 1, XMLNAME = "PatientName");

Property PatientID As %String(TRUNCATE = 1, XMLNAME = "PatientID");

Property ExtOrgCode As %String(TRUNCATE = 1, XMLNAME = "ExtOrgCode");

}
