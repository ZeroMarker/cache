Class EMRservice.BL.BLAdmTaskQueue Extends %RegisteredObject [ ProcedureBlock ]
{

/// Debug:	w ##Class(EMRservice.BL.BLAdmTaskQueue).RegTaskFP("256012||1")
ClassMethod RegTaskFP(AInstanceDataID As %String) As %String
{
	s $zt = "OnRegTaskFP"
	
	//b "s"
	s obj = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceDataID)
	q:(obj = "") ""
	
	//校验系统参数配置，是否开启了首页数据推送任务队列功能
	s TaskFPDocID = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("TaskFPDocID","NULL")
	q:(TaskFPDocID = "NULL") ""
	s docID = obj.TheECRecord.RealChartItemID
	q:(TaskFPDocID '= docID) ""
	
	//完成打印操作之后，才开启任务队列
	s hasPrinted = ##Class(EMRservice.BL.BLEMRLogs).RecHasAction(obj.RealEpisodeID, AInstanceDataID, "print")
	q:(hasPrinted '= "1") ""
	
	s taskIDList = ""
	s TaskFPType = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("TaskFPType","FP")
	s taskCount = $L(TaskFPType, "^")
	for i = 1:1:taskCount
	{
		s tmpType = $p(TaskFPType,"^",i)
		s tmpType = $tr(tmpType,$c(0),"")
		continue:(tmpType="")
		
		s taskID = ..RegTask(obj.RealEpisodeID, tmpType)
		continue:(taskID = "")
		
		if (taskIDList = "")
		{	s taskIDList = taskID}
		else
		{	s taskIDList = taskIDList_"^"_taskID}
	}
	
	q taskIDList

OnRegTaskFP
	q ""
}

/// Debug:	w ##Class(EMRservice.BL.BLAdmTaskQueue).RegTask("15","FP")
ClassMethod RegTask(AEpisodeID As %String, ATaskType As %String) As %String
{
	s id = ..GetTaskID(AEpisodeID, ATaskType)
	if (id = "")
	{
		s id = ..CreateTask(AEpisodeID, ATaskType, 100)
	}
	
	q id
}

ClassMethod GetTaskID(AEpisodeID As %String, ATaskType As %String) As %String
{
	s id = $O(^DHCEMRI.AdmTaskQueueI("IdxMain", " "_AEpisodeID, " "_ATaskType, ""))
	q id
}

/// Desc:	创建一条待生成的任务队列
/// Input:	
/// 		AEpisodeID : 就诊RowID
/// Output：AdmTaskQueueID 生成的任务队列ID
/// Debug:	w ##Class(EMRservice.BL.BLAdmTaskQueue).CreateTask("436","FP","100")
ClassMethod CreateTask(AEpisodeID As %String, ATaskType As %String, APriority As %Integer = "100") As %String
{
	q:(AEpisodeID = "") ""
	
	s obj = ##Class(EMRinstance.AdmTaskQueue).%New()
	
	s obj.EpisodeID = AEpisodeID
	s obj.AdmDate = $P($G(^PAADM(AEpisodeID)),"^",6)
	s obj.Priority = APriority
	s obj.TaskType = ATaskType
	s obj.CreateCount = 0
	s obj.CandidateDate = $p($h,",",1)
	s obj.CandidateTime = $p($h,",",2)
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

ClassMethod GetTopPriorityTaskID(ATaskType As %String) As %String
{
	s priority = $O(^DHCEMRI.AdmTaskQueueI("IdxPriorityTaskType", " "_ATaskType, ""),-1)
	q:(priority="") ""
	
	s rowID = $O(^DHCEMRI.AdmTaskQueueI("IdxPriorityTaskType", " "_ATaskType, priority, ""))
	q rowID
}

ClassMethod GetTopPriorityTask(ATaskType As %String) As EMRservice.entity.EAdmTaskQueue
{
	s id = ..GetTopPriorityTaskID(ATaskType)
	q:(id = "") ""
	
	s obj = ##Class(EMRinstance.AdmTaskQueue).%OpenId(id)
	q:(obj = "") ""
	
	s entity = ##Class(EMRservice.entity.EAdmTaskQueue).%New()
	s entity.ID = obj.%Id()
	s entity.EpisodeID = obj.EpisodeID
	s entity.AdmDate = obj.AdmDate
	s entity.Priority = obj.Priority
	s entity.TaskType = obj.TaskType
	s entity.CreateCount = obj.CreateCount
	s entity.CandidateDate = obj.CandidateDate
	s entity.CandidateTime = obj.CandidateTime
	
	q entity
}

/// Desc:  		打印病案首页成功后，调用平台接口，对外提供访问出院患者列表
/// Creator:    董璐璐
/// CreateDate: 2021-8-6
/// Input:      AInstanceID 实例ID
/// Output:     
/// Debug:      d ##Class(EMRservice.BL.BLAdmTaskQueue).SendMedicalRecord("118||24")
ClassMethod SendMedicalRecord(AInstanceID As %String)
{
	q:(AInstanceID = "")
	s obj = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(obj = "")
	
	//获取系统参数MedicalRecordDocID，判断是否开启此功能
	s medicalRecordDocID = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("MedicalRecordDocID","NULL")
	q:(medicalRecordDocID = "NULL")
	s docID = obj.TheECRecord.RealChartItemID
	s length = $l(medicalRecordDocID,"^")
    for I=1:1:length
	{
		s tmpDocID = $p(medicalRecordDocID,"^",I)
		if (tmpDocID = docID)
		{
			s episodeID = obj.TheECRecord.RealEpisodeID
			d ##Class(EMRservice.BL.BLAdmTaskQueue).SendDischargedPatient(episodeID)
			q
		}
	}	
	q
}

/// Desc:  		调用平台接口，对外提供访问出院患者列表
/// Creator:    董璐璐
/// CreateDate: 2021-8-6
/// Input:      AEpisodeID 就诊号
/// Output:     
/// Debug:      d ##Class(EMRservice.BL.BLAdmTaskQueue).SendDischargedPatient("")
ClassMethod SendDischargedPatient(AEpisodeID As %String)
{
	q:(AEpisodeID = "")
	q:(##class(%Dictionary.CompiledClass).%ExistsId("web.DHCENS.EnsHISService") = "0") result
	q:(##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCENS.EnsHISService||DHCHisInterface") = "0") result
	s result = ##Class(web.DHCENS.EnsHISService).DHCHisInterface("SENDINHOSPITALADMFIRSTPAGEINFO",AEpisodeID)
}

}
