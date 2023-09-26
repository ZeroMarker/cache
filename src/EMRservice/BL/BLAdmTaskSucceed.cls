Class EMRservice.BL.BLAdmTaskSucceed Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod Create(AEAdmTaskExec As EMRservice.entity.EAdmTaskExec) As %String
{
	s obj = ##Class(EMRinstance.AdmTaskSucceed).%New()
	s obj.EpisodeID = AEAdmTaskExec.EpisodeID
	s obj.AdmDate = AEAdmTaskExec.AdmDate
	s obj.Priority = AEAdmTaskExec.Priority
	s obj.TaskType = AEAdmTaskExec.TaskType
	s obj.CreateCount = AEAdmTaskExec.CreateCount + 1
	s obj.CandidateDate = AEAdmTaskExec.CandidateDate
	s obj.CandidateTime = AEAdmTaskExec.CandidateTime
	s obj.TaskDate = AEAdmTaskExec.TaskDate
	s obj.TaskTime = AEAdmTaskExec.TaskTime
	s obj.TaskRemark = AEAdmTaskExec.TaskRemark
	s obj.RemarkDate = AEAdmTaskExec.RemarkDate
	s obj.RemarkTime = AEAdmTaskExec.RemarkTime
	s obj.SucceedDate = $p($h,",",1)
	s obj.SucceedTime = $p($h,",",2)
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

}
