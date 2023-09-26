Class DHCExternalService.RegInterface.Entity.ServiceBookRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLNAME = "ServiceBookRt";

Parameter XMLIGNOREINVALIDTAG = 1;

Property TradeCode As %String(TRUNCATE = 1, XMLNAME = "TradeCode");

Property ClientType As %String(TRUNCATE = 1, XMLNAME = "ClientType");

Property HospitalId As %String(TRUNCATE = 1, XMLNAME = "HospitalID");

Property ExtUserID As %String(TRUNCATE = 1, XMLNAME = "ExtUserID");

Property BankID As %String(TRUNCATE = 1, XMLNAME = "BankID");

Property TerminalID As %String(TRUNCATE = 1, XMLNAME = "TerminalID");

Property BankDate As %String(TRUNCATE = 1, XMLNAME = "BankDate");

Property BankTradeNo As %String(TRUNCATE = 1, XMLNAME = "BankTradeNo");

Property TransactionId As %String(TRUNCATE = 1, XMLNAME = "OrgHISTradeNo");

Property CredTypeCode As %String(TRUNCATE = 1, XMLNAME = "CredTypeCode");

Property IDCardNo As %String(TRUNCATE = 1, XMLNAME = "IDCardNo");

Property TelePhoneNo As %String(TRUNCATE = 1, XMLNAME = "TelePhoneNo");

Property MobileNo As %String(TRUNCATE = 1, XMLNAME = "MobileNo");

Property PatientName As %String(TRUNCATE = 1, XMLNAME = "PatientName");

Property PayFlag As %String(TRUNCATE = 1, XMLNAME = "PayFlag");

Property PayModeCode As %String(TRUNCATE = 1, XMLNAME = "PayModeCode");

Property PayBankCode As %String(TRUNCATE = 1, XMLNAME = "PayBankCode");

/// ERROR: Duplicate Property name in Schema. 
Property PayCardNo As %String(TRUNCATE = 1, XMLNAME = "PayCardNo");

Property CardNo As %String(TRUNCATE = 1, XMLNAME = "CardNo");

Property PayFee As %String(TRUNCATE = 1, XMLNAME = "PayFee");

Property PayInsuFee As %String(TRUNCATE = 1, XMLNAME = "PayInsuFee");

Property PayTradeNo As %String(TRUNCATE = 1, XMLNAME = "PayTradeNo");

Property LockQueueNo As %String(TRUNCATE = 1, XMLNAME = "LockQueueNo");

Property Gender As %String(TRUNCATE = 1, XMLNAME = "Gender");

Property Address As %String(TRUNCATE = 1, XMLNAME = "Address");

Property HISApptID As %String(TRUNCATE = 1, XMLNAME = "HISApptID");

Property SeqCode As %String(TRUNCATE = 1, XMLNAME = "SeqCode");

Property AdmitRange As %String(TRUNCATE = 1, XMLNAME = "AdmitRange");

Property ExtOrgCode As %String(TRUNCATE = 1, XMLNAME = "ExtOrgCode");

Property BankAccDate As %String(TRUNCATE = 1, XMLNAME = "BankAccDate");

Property ChangeFlg As %String(TRUNCATE = 1, XMLNAME = "ChangeFlg");

Property ScheduleItemCode As %String(TRUNCATE = 1, XMLNAME = "ScheduleItemCode");

Property AnticipantStartDate As %Date(XMLNAME = "AnticipantStartDate");

Property AnticipantEndDate As %Date(XMLNAME = "AnticipantEndDate");

Property StartTime As %Time(XMLNAME = "StartTime");

Property EndTime As %Time(XMLNAME = "EndTime");

Property OrganizationCode As %String(TRUNCATE = 1, XMLNAME = "OrganizationCode");

Property DepartmentCode As %String(TRUNCATE = 1, XMLNAME = "DepartmentCode");

Property ServiceProviderCode As %String(TRUNCATE = 1, XMLNAME = "ServiceProviderCode");

Property ServiceCode As %String(TRUNCATE = 1, XMLNAME = "ServiceCode");

Property Fee As %String(TRUNCATE = 1, XMLNAME = "Fee");

Property PersonCode As %String(TRUNCATE = 1, XMLNAME = "PersonCode");

Property BookingOrgCode As %String(TRUNCATE = 1, XMLNAME = "BookingOrgCode");

Property OperatorCode As %String(TRUNCATE = 1, XMLNAME = "OperatorCode");

Property PreliminaryDiagnosisResult As DHCExternalService.RegInterface.Entity.PreDiagResult(XMLNAME = "PreliminaryDiagnosisResult");

Property CardTypeCode As %String(TRUNCATE = 1, XMLNAME = "CardTypeCode");

}
