Class CIS.AN.SRV.Assembler.MS.Message Extends %RegisteredObject
{

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

ClassMethod Query(params As CIS.AN.DTO.ENS.Request.Arguments) As %ListOfObjects
{
	if ..VerifyInput(params)
	{
	}
}

ClassMethod VerifyInput(params As CIS.AN.DTO.ENS.Request.Arguments) As %Boolean
{
	quit 1
}

/// w ##class(CIS.AN.SRV.Assembler.Base.CareProvider).GetInstance(2323)
ClassMethod GetInstance(rowId As %String) As CIS.AN.DTO.ENS.Message
{
	set instance.PAADMVisitNumber=model.EpisodeID
	set instance.Context="测试消息"
	set instance.ActionTypeCode="1"
	set instance.FromUserRowId=""
	set instance.ToUserRowId=##class(CIS.AN.BL.Admission).GetUserIDByCareProv("37")
	quit instance
}

ClassMethod GetMessagesOnArrange(opsId As %String) As %ListOfObjects
{
	set appointment=##class(CIS.AN.SRV.Assembler.OP.Appointment).GetInstance(opsId)
	set arrangement=##class(CIS.AN.SRV.Assembler.OP.Arrangement).GetInstance(opsId)
	
	set messageList=##class(%ListOfObjects).%New()
	while(appointment.PlanOperations.GetNext(.key))
	{
		set operation=appointment.PlanOperations.GetAt(key)
		set instance=##class(CIS.AN.DTO.ENS.Message).Create()
		do instance.Default()
		
		set content=##class(CIS.AN.DTO.ENS.Message.Content).%New()
		set content.PAADMVisitNumber=appointment.Admission.EpisodeID
		set content.Context="患者 "_appointment.Patient.Name_" 在"_appointment.OperDate_"的 "_operation.OperName_"安排在"_appointment.OperatingDepartment_" 的"_arrangement.OperRoom_" 第 "_arrangement.OperSeq_"台"
		set content.ActionTypeCode="1039"
		set content.FromUserRowId=arrangement.SubmitUserID
		set content.ToUserRowId=##class(CIS.AN.BL.Admission).GetUserIDByCareProv(operation.Surgeon.RowId)
		do instance.Compose(content)
		
		do messageList.Insert(instance)
	}
	
	quit messageList
}

}
