/// web.DHCAnOperationInterface
Class web.DHCAnOperationInterface Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "AnInterface";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://10.1.1.42//TrakCare/trak/web/";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// 取科室字典信息
ClassMethod GetDeptDict(inPut As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCInterfaceAnOperation).GetDeptDict(inPut)
}

/// 取工作人员字典信息
ClassMethod GetHisUsers(inPut As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCInterfaceAnOperation).GetHisUsers(inPut)
}

/// 取病人基本信息
ClassMethod GetPatientMasterIndex(PatientID As %String) As %String [ WebMethod ]
{
	Quit ##class(web.DHCInterfaceAnOperation).GetPatientMasterIndex(PatientID)
}

/// 取在院病人信息
ClassMethod GetInPatientInfor(VisitID As %String) As %String [ WebMethod ]
{
	Quit ##class(web.DHCInterfaceAnOperation).GetInPatientInfor(VisitID)
}

/// 取手术申请预约信息
/// ScheduleDateStart 20080517
ClassMethod GetOperationSchedule(ScheduleDateStart As %String, ScheduleDateStop As %String, PerformedCode As %String, OperStatus As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCInterfaceAnOperation).GetOperationSchedule(ScheduleDateStart, ScheduleDateStop, PerformedCode, OperStatus)
}

/// 取申请手术名称信息
ClassMethod GetOperationScheduleName(ScheduleID As %String) As %String [ WebMethod ]
{
	Quit ##class(web.DHCInterfaceAnOperation).GetOperationScheduleName(ScheduleID)
}

/// 更新手术状态信息
ClassMethod UpdateOperStatus(ScheduleID As %String, OperStatus As %String) As %String [ WebMethod ]
{
	Quit ##class(web.DHCInterfaceAnOperation).UpdateOperStatus(ScheduleID, OperStatus)
}

}
