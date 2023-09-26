Class DHCExternalService.RegInterface.Entity.ServiceScheduleVisit Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLNAME = "ServiceScheduleVisit";

Parameter XMLIGNOREINVALIDTAG = 1;

Property Fee As %String(TRUNCATE = 1, XMLNAME = "Fee");

Property RegFee As %String(TRUNCATE = 1, XMLNAME = "RegFee");

Property CheckupFee As %String(TRUNCATE = 1, XMLNAME = "CheckupFee");

Property ServiceFee As %String(TRUNCATE = 1, XMLNAME = "ServiceFee");

Property OtherFee As %String(TRUNCATE = 1, XMLNAME = "OtherFee");

Property ScheduleItemCode As %String(TRUNCATE = 1, XMLNAME = "ScheduleItemCode");

Property ServiceDate As %String(TRUNCATE = 1, XMLNAME = "ServiceDate");

Property WeekDay As %String(TRUNCATE = 1, XMLNAME = "WeekDay");

Property SessionCode As %String(TRUNCATE = 1, XMLNAME = "SessionCode");

Property SessionName As %String(TRUNCATE = 1, XMLNAME = "SessionName");

Property StartTime As %String(TRUNCATE = 1, XMLNAME = "StartTime");

Property EndTime As %String(TRUNCATE = 1, XMLNAME = "EndTime");

Property DepartmentCode As %String(TRUNCATE = 1, XMLNAME = "DepartmentCode");

Property DepartmentName As %String(TRUNCATE = 1, XMLNAME = "DepartmentName");

Property ClinicRoomCode As %String(TRUNCATE = 1, XMLNAME = "ClinicRoomCode");

Property ClinicRoomName As %String(TRUNCATE = 1, XMLNAME = "ClinicRoomName");

Property DoctorCode As %String(TRUNCATE = 1, XMLNAME = "DoctorCode");

Property DoctorName As %String(TRUNCATE = 1, XMLNAME = "DoctorName");

Property DoctorSpec As %String(TRUNCATE = 1, XMLNAME = "DoctorSpec");

Property DoctorTitle As %String(TRUNCATE = 1, XMLNAME = "DoctorTitle");

Property DoctorTitleCode As %String(TRUNCATE = 1, XMLNAME = "DoctorTitleCode");

Property DoctorSessTypeCode As %String(TRUNCATE = 1, XMLNAME = "DoctorSessTypeCode");

Property DoctorSessType As %String(TRUNCATE = 1, XMLNAME = "DoctorSessType");

Property ServiceCode As %String(TRUNCATE = 1, XMLNAME = "ServiceCode");

Property ServiceName As %String(TRUNCATE = 1, XMLNAME = "ServiceName");

Property AvailableNum As %String(TRUNCATE = 1, XMLNAME = "AvailableNum");

Property AdmitAddress As %String(TRUNCATE = 1, XMLNAME = "AdmitAddress");

Property AdmitTimeRange As %String(TRUNCATE = 1, XMLNAME = "AdmitTimeRange");

Property Note As %String(TRUNCATE = 1, XMLNAME = "Note");

}
