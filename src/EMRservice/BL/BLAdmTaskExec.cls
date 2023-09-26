Class EMRservice.BL.BLAdmTaskExec Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	获取一条待执行的任务队列，将其放入当前执行队列
/// Debug:	s a = ##Class(EMRservice.BL.BLAdmTaskExec).FetchTask("FP")
ClassMethod FetchTask(ATaskType As %String) As EMRservice.entity.EAdmTaskExec
{
	s eAdmTaskQueue = ##Class(EMRservice.BL.BLAdmTaskQueue).GetTopPriorityTask(ATaskType)
	q:(eAdmTaskQueue="") ""
	
	s admTaskExecID = ..MoveTaskQueueToExec(eAdmTaskQueue)
	q:(admTaskExecID="") ""

	s entity = ..GetAdmTaskExecByID(admTaskExecID)
	q entity
}

/// Debug:	w ##Class(EMRservice.BL.BLAdmTaskExec).CompleteTask("13")
ClassMethod CompleteTask(AAdmTaskExecID As %String) As %String
{
	q:(AAdmTaskExecID = "") ""
	
	s entity = ..GetAdmTaskExecByID(AAdmTaskExecID)
	q:(entity = "") ""
	
	s status = ..MoveTaskExecToSucceed(entity)
	q status
}

/// Desc:	检查是否有一条待执行的任务队列
/// Debug:	w ##Class(EMRservice.BL.BLAdmTaskExec).CheckAdmTaskExec()
ClassMethod CheckAdmTaskExec(ATaskType As %String) As %String
{
	s eAdmTaskQueue = ##Class(EMRservice.BL.BLAdmTaskQueue).GetTopPriorityTask(ATaskType)
	q:(eAdmTaskQueue="") ""

	q eAdmTaskQueue.EpisodeID
}

/// Desc:	将任务从等待队列中转至执行队列中
/// Return:	新建AdmTaskExec的RowID
ClassMethod MoveTaskQueueToExec(AEAdmTaskQueue As EMRservice.entity.EAdmTaskQueue) As %String
{
	//校验入参
	q:(AEAdmTaskQueue.ID = "") ""
	
	TSTART
	
	s $zt = "OnMoveErrorHandler"
	
	s rowID = ..Create(AEAdmTaskQueue)
	if (rowID = "") 
	{
		TROLLBACK
		q ""
	}
	
	s status = ##Class(EMRinstance.AdmTaskQueue).%DeleteId(AEAdmTaskQueue.ID)
	if ($$$ISOK(status))
	{
		TCOMMIT
		q rowID
	}
	else
	{
		TROLLBACK
		q ""
	}	
	
OnMoveErrorHandler
	TROLLBACK
	q ""
}

ClassMethod Create(AEAdmTaskQueue As EMRservice.entity.EAdmTaskQueue) As %String
{
	s obj = ##Class(EMRinstance.AdmTaskExec).%New()
	s obj.EpisodeID = AEAdmTaskQueue.EpisodeID
	s obj.AdmDate = AEAdmTaskQueue.AdmDate
	s obj.Priority = AEAdmTaskQueue.Priority
	s obj.TaskType = AEAdmTaskQueue.TaskType
	s obj.CreateCount = AEAdmTaskQueue.CreateCount + 1
	s obj.CandidateDate = AEAdmTaskQueue.CandidateDate
	s obj.CandidateTime = AEAdmTaskQueue.CandidateTime
	s obj.TaskDate = $p($h,",",1)
	s obj.TaskTime = $p($h,",",2)
	s obj.TaskRemark = ""
	
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

/// Debug:	w ##Class(EMRservice.BL.BLAdmTaskExec).GetAdmTaskExecByID("1")
ClassMethod GetAdmTaskExecByID(AAdmTaskExecID As %String) As EMRservice.entity.EAdmTaskExec
{
	s obj = ##Class(EMRinstance.AdmTaskExec).%OpenId(AAdmTaskExecID)
	q:(obj = "") ""
	
	s entity = ##Class(EMRservice.entity.EAdmTaskExec).%New()
	s entity.ID = obj.%Id()
	s entity.EpisodeID = obj.EpisodeID
	s entity.AdmDate = obj.AdmDate
	s entity.Priority = obj.Priority
	s entity.TaskType = obj.TaskType
	s entity.CreateCount = obj.CreateCount
	s entity.CandidateDate = obj.CandidateDate
	s entity.CandidateTime = obj.CandidateTime
	s entity.TaskDate = obj.TaskDate
	s entity.TaskTime = obj.TaskTime
	s entity.TaskRemark = obj.TaskRemark
	
	q entity
}

ClassMethod MoveTaskExecToSucceed(AEAdmTaskExec As EMRservice.entity.EAdmTaskExec) As %String
{
	TSTART
	
	s $zt = "OnMoveErrorHandler"
	
	s rowID = ##Class(EMRservice.BL.BLAdmTaskSucceed).Create(AEAdmTaskExec)
	if (rowID = "") 
	{
		TROLLBACK
		q ""
	}
	
	s status = ##Class(EMRinstance.AdmTaskExec).%DeleteId(AEAdmTaskExec.ID)
	if ($$$ISOK(status))
	{
		s episodeID = AEAdmTaskExec.EpisodeID
		TCOMMIT
		q rowID
	}
	else
	{
		TROLLBACK
		q ""
	}	
	
OnMoveErrorHandler
	TROLLBACK
	q ""
}

ClassMethod UpdateRemark(AAdmTaskExecID As %String, ATaskRemark As %String) As %Boolean
{
	s obj = ##Class(EMRinstance.AdmTaskExec).%OpenId(AAdmTaskExecID)
	q:(obj = "") "0"
	
	s obj.TaskRemark = ATaskRemark
	s obj.RemarkDate = $p($h,",",1)
	s obj.RemarkTime = $p($h,",",2)
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// Desc:	使用队列的示例方法
/// Debug:	d ##Class(EMRservice.BL.BLAdmTaskExec).DemoDoTaskFP()
ClassMethod DemoDoTaskFP()
{
	
	//请更换为对应产品组约定的编码
	s taskType = "TEST"  //FP 医政组， FPBI  BI组
	
	s maxCount = 10000
	
	
	s count = 0
	for {
		//获取待执行队列
		s entity = ##Class(EMRservice.BL.BLAdmTaskExec).FetchTask(taskType)
		q:(entity = "")
		
		s count = count + 1
		q:(count > maxCount)
		
		s episodeID = entity.EpisodeID
		s taskID = entity.ID
		
		//进行数据抽取和质控评价
		//todo
		
		//将队列置为完成
		s sc = ##Class(EMRservice.BL.BLAdmTaskExec).CompleteTask(taskID)
		w !, "EpisodeID:"_episodeID_", TaskExec:"_taskID_", TaskSucceed:"_sc
	}
}

}
