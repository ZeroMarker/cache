Class DHCEPRFS.BL.BLAdmTaskQueue Extends %RegisteredObject [ ProcedureBlock ]
{

/// Debug:	d ##Class(DHCEPRFS.BL.BLAdmTaskQueue).CreateByMREpisodeID("112922")	
ClassMethod CreateByMREpisodeID(AMREpisodeID As %String, APriority As %String = "60") As %String
{
	s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	s episodeID = obj.EpisodeID
	
	//历史病案录入的就诊，不能重新生成，直接返回-3
	if ($e(episodeID,1,2) = "VE")
	{
		q "-3"
	}
	
	s ret = ..Create("DHC",episodeID,APriority)
	q ret
}

/// Desc:	创建一条待生成的任务队列
/// Input:	ASysCode : HIS系统编码
/// 		AEpisodeID : 就诊RowID
/// Output：AdmTaskQueueID 生成的任务队列ID  
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC","436","50")
ClassMethod Create(ASysCode As %String, AEpisodeID As %String, APriority As %Integer, ASchemeType As %String = "", ATaskType As %String = "N", AVersionTypeCode As %String = "", ASpecialFlag As %String = "", ASpecialParam As %String = "") As %String
{
	q:(AEpisodeID = "") ""
	
	s rowID = ""
	//在加入生成队列前会做一个排重处理，如果已经存在于等待队列或者正在生成队列就只更新不新增，如果不存在就增加
	s rowID = ##class(DHCEPRFS.BL.BLAdmTaskQueue).CheckRedundancies(AEpisodeID,APriority,ASchemeType,ATaskType,AVersionTypeCode,ASpecialFlag,ASpecialParam)
	
	q:(rowID '="") rowID
	s obj = ##Class(DHCEPRFS.INST.AdmTaskQueue).%New()
	s obj.SysCode = ASysCode
	s patientID = ""
	s obj.MedRecordNo = ""
	s obj.RegNo = ""
	s obj.AdmDate = ""
	if (AEpisodeID '= "")
	{
		s patientID = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientID(AEpisodeID)
		// 恢复MedRecordNo 2018.3.6 yangpeng
		s obj.MedRecordNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(patientID,"",AEpisodeID)
		s obj.RegNo = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNo(patientID)
		s obj.AdmDate = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmDate(AEpisodeID)
	}
	
	s obj.PatientID = patientID
	s obj.EpisodeID = AEpisodeID
	s obj.IPRecordNo = ""
	s obj.OPRecordNo = ""
	s obj.EPRecordNo = ""
	s obj.Priority = APriority
	s obj.CandidateDate = $p($h,",",1)
	s obj.CandidateTime = $p($h,",",2)
	s obj.SchemeType = ASchemeType
	s obj.TaskType = ATaskType
	//用来表示生成版本类别
	s obj.VersionTypeCode = AVersionTypeCode
	s obj.SpecialFlag = ASpecialFlag
	s obj.SpecialParam = ASpecialParam
	s obj.CreateCount = 0
	s obj.AdmType = $p(##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmType(AEpisodeID),"^",1)
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

/// Desc:	在加入生成队列前会做一个排重处理，如果已经存在于等待队列或者正在生成队列就只更新不新增，如果不存在就增加
/// Input:  ASchemeType:生成方案
/// 		AEpisodeID : 就诊RowID
/// Output：AdmTaskQueueID 生成的任务队列ID
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).RemoveRedundancies("436","50","CREATEFPTOP")
ClassMethod CheckRedundancies(AEpisodeID As %String, APriority As %Integer, ASchemeType As %String = "", ATaskType As %String = "N", AVersionTypeCode As %String = "", ASpecialFlag As %String = "", ASpecialParam As %String = "") As %String
{
	s rowID = ""
	s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxEpisode"," "_AEpisodeID,rowID))
	if (rowID = "")
	{
		s rowID =  $o(^DHCEPRFS.INST.AdmTaskExecI("IdxEpisode"," "_AEpisodeID,rowID))
		q:(rowID = "") ""
		s obj = ##class(DHCEPRFS.INST.AdmTaskExec).%OpenId(rowID)
		//意思是需要增加的生成任务类型为正常生成方案
		if (ASchemeType = "")
		{
			//生成队列有生成任务，且方案类型为正常方案，这种情况不重复增加
			if (obj.SchemeType = ASchemeType)
			{
				s obj.CandidateDate = $p($h,",",1)
				s obj.CandidateTime = $p($h,",",2)
				s obj.Priority = APriority
				s obj.TaskType = ATaskType
				s obj.SchemeType = ASchemeType
				//用来表示生成版本类别
				s obj.VersionTypeCode = AVersionTypeCode
				s obj.SpecialFlag = ASpecialFlag
				s obj.SpecialParam = ASpecialParam
			
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
			else
			{
				//生成队列有生成任务，且方案类型为单项生成方案，那么正常生成任务应该覆盖单项生成，所以增加
				q ""
			}
		}
		else
		{
			//生成队列有生成任务，且方案类型为单项生成，要加入的生成任务与此单项生成一致，所以不增加
			if (obj.SchemeType = ASchemeType)
			{
				s obj.CandidateDate = $p($h,",",1)
				s obj.CandidateTime = $p($h,",",2)
				s obj.Priority = APriority
				s obj.TaskType = ATaskType
				s obj.SchemeType = ASchemeType
				//用来表示生成版本类别
				s obj.VersionTypeCode = AVersionTypeCode
				s obj.SpecialFlag = ASpecialFlag
				s obj.SpecialParam = ASpecialParam
			
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
			elseif (obj.SchemeType = "")
			{
				//生成队列有生成任务，且方案类型为正常生成，要加入为单项生成，所以不增加
				q obj.%Id()
			}
			else
			{
				//生成队列有生成任务，方案类型为单项生成，且与要加入的单项生成不一致，所以增加
				q ""
			}
		}
	}
	else
	{
		s obj = ##class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(rowID)
		//意思是需要增加的生成任务类型为正常生成方案
		if (ASchemeType = "")
		{
			//生成队列有生成任务，且方案类型为正常方案，这种情况不重复增加
			if (obj.SchemeType = ASchemeType)
			{
				s obj.CandidateDate = $p($h,",",1)
				s obj.CandidateTime = $p($h,",",2)
				s obj.Priority = APriority
				s obj.TaskType = ATaskType
				s obj.SchemeType = ASchemeType
				//用来表示生成版本类别
				s obj.VersionTypeCode = AVersionTypeCode
				s obj.SpecialFlag = ASpecialFlag
				s obj.SpecialParam = ASpecialParam
			
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
			else    //生成队列有生成任务，且方案类型为单项生成方案，那么正常生成任务应该覆盖单项生成，所以增加
			{
				q ""
			}
		}
		else
		{
			//生成队列有生成任务，且方案类型为单项生成，要加入的生成任务与此单项生成一致，所以不增加
			if (obj.SchemeType = ASchemeType)
			{
				s obj.CandidateDate = $p($h,",",1)
				s obj.CandidateTime = $p($h,",",2)
				s obj.Priority = APriority
				s obj.TaskType = ATaskType
				s obj.SchemeType = ASchemeType
				//用来表示生成版本类别
				s obj.VersionTypeCode = AVersionTypeCode
				s obj.SpecialFlag = ASpecialFlag
				s obj.SpecialParam = ASpecialParam
			
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
			elseif (obj.SchemeType = "")
			{
				//生成队列有生成任务，且方案类型为正常生成，要加入为单项生成，所以不增加
				q obj.%Id()
			}
			else
			{
				//生成队列有生成任务，方案类型为单项生成，且与要加入的单项生成不一致，所以增加
				q ""
			}
		}
	}
}

/// debug: w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).CreatePrivacyLevel01("DHC","4602474","52")
ClassMethod CreatePrivacyLevel01(ASysCode As %String, AEpisodeID As %String, APriority As %Integer, ATaskType As %String = "N")
{
	s schemeType = ##class(DHCEPRFS.Const.SchemeType).CreatePrivacy01()
	s ret = ..Create(ASysCode,AEpisodeID,APriority,schemeType,ATaskType,schemeType)
	q ret
}

ClassMethod CreateByExec(entity As DHCEPRFS.Entity.EAdmTaskExec) As %String
{
	s obj = ##Class(DHCEPRFS.INST.AdmTaskQueue).%New()
	s obj.SysCode = entity.SysCode
	s obj.PatientID = entity.PatientID
	s obj.EpisodeID = entity.EpisodeID
	s obj.MedRecordNo = entity.MedRecordNo
	s obj.RegNo = entity.RegNo
	s obj.IPRecordNo = entity.IPRecordNo
	s obj.OPRecordNo = entity.OPRecordNo
	s obj.EPRecordNo = entity.EPRecordNo
	s obj.Priority = entity.Priority
	s obj.AdmDate = entity.AdmDate
	s obj.CandidateDate = $p($h,",",1)
	s obj.CandidateTime = $p($h,",",2)
	s obj.SchemeType = entity.SchemeType
	s obj.TaskType = entity.TaskType
	s obj.VersionTypeCode = entity.VersionTypeCode
	s obj.SpecialFlag = entity.SpecialFlag
	s obj.SpecialParam = entity.SpecialParam
	s obj.CreateCount = 0
	s obj.AdmType = entity.AdmType
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

ClassMethod CreateBySucceed(entity As DHCEPRFS.Entity.EAdmTaskSucceed) As %String
{
	s obj = ##Class(DHCEPRFS.INST.AdmTaskQueue).%New()
	s obj.SysCode = entity.SysCode
	s obj.PatientID = entity.PatientID
	s obj.EpisodeID = entity.EpisodeID
	s obj.MedRecordNo = entity.MedRecordNo
	s obj.RegNo = entity.RegNo
	s obj.IPRecordNo = entity.IPRecordNo
	s obj.OPRecordNo = entity.OPRecordNo
	s obj.EPRecordNo = entity.EPRecordNo
	s obj.Priority = entity.Priority
	s obj.AdmDate = entity.AdmDate
	s obj.CandidateDate = $p($h,",",1)
	s obj.CandidateTime = $p($h,",",2)
	s obj.SchemeType = entity.SchemeType
	s obj.TaskType = entity.TaskType
	s obj.VersionTypeCode = entity.VersionTypeCode
	s obj.SpecialFlag = entity.SpecialFlag
	s obj.SpecialParam = entity.SpecialParam
	s obj.CreateCount = 0
	s obj.AdmType = entity.AdmType
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

/// Desc:	获取优先级最高的一条待生成队列
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).GetTopPriorityTask()
ClassMethod GetTopPriorityTask() As DHCEPRFS.Entity.EAdmTaskQueue
{
	s rowID = ..GetTopPriorityTaskID()
	q:(rowID = "") ""
	s entity = ..GetAdmTaskQueueByID(rowID)
	q entity
}

/// Desc:	获取优先级大于100并且最高的项目到绿色通道生成
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).GetGreenChannelTask()
ClassMethod GetGreenChannelTask() As DHCEPRFS.Entity.EAdmTaskQueue
{
	s rowID = ..GetGreenChannelTaskID()
	q:(rowID = "") ""
	
	s entity = ..GetAdmTaskQueueByID(rowID)
	q entity
}

/// Desc:	获取优先级大于1000并且最高的项目到老病历生成
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).GetOldTask()
ClassMethod GetOldTask() As DHCEPRFS.Entity.EAdmTaskQueue
{
	s rowID = ..GetOldTaskID()
	q:(rowID = "") ""
	
	s entity = ..GetAdmTaskQueueByID(rowID)
	q entity
}

/// Desc:	获取优先级大于2000并且最高的项目到特殊病历生成
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).GetSpecialTask()
ClassMethod GetSpecialTask(ASpecialFlag As %String = "") As DHCEPRFS.Entity.EAdmTaskQueue
{
	s rowID = ..GetSpecialTaskID(ASpecialFlag)
	q:(rowID = "") ""
	
	s entity = ..GetAdmTaskQueueByID(rowID)
	q entity
}

ClassMethod GetSpecialTaskID(ASpecialFlag As %String = "") As %String
{
	s ret = ..GetTopPriorityByTaskType("S",ASpecialFlag)
	q ret
}

ClassMethod GetOldTaskID() As %String
{
	s ret = ..GetTopPriorityByTaskType("O")
	q ret
}

ClassMethod GetGreenChannelTaskID() As %String
{
	s ret = ..GetTopPriorityByTaskType("G")
	q ret
}

ClassMethod GetTopPriorityTaskID() As %String
{
	s ret = ..GetTopPriorityByTaskType("N")
	q ret
}

ClassMethod GetTopPriorityByTaskType(ATaskType As %String, ASpecialFlag As %String = "") As %String
{
	s priority = ""
	s rowID = ""
	
	if (ASpecialFlag '= "")
	{
		s priority = $O(^DHCEPRFS.INST.AdmTaskQueueI("IdxTaskType", " "_ATaskType, " "_ASpecialFlag, priority),-1)
		q:(priority="") ""
		s rowID = $O(^DHCEPRFS.INST.AdmTaskQueueI("IdxTaskType", " "_ATaskType, " "_ASpecialFlag, priority, ""))
	}
	else
	{
		s priority = $O(^DHCEPRFS.INST.AdmTaskQueueI("IdxPriorityTaskType", " "_ATaskType, priority),-1)
		q:(priority="") ""
		s rowID = $O(^DHCEPRFS.INST.AdmTaskQueueI("IdxPriorityTaskType", " "_ATaskType, priority, ""))
	}
	q rowID
}

ClassMethod GetAdmTaskQueueByID(AAdmTaskQueueID As %String) As DHCEPRFS.Entity.EAdmTaskQueue
{
	q:(AAdmTaskQueueID = "") ""
	
	s objAdmTaskQueue = ##Class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(AAdmTaskQueueID)
	q:(objAdmTaskQueue="") ""
	
	s entity = ##Class(DHCEPRFS.Entity.EAdmTaskQueue).%New()
	s entity.ID = objAdmTaskQueue.%Id()
	s entity.SysCode = objAdmTaskQueue.SysCode
	s entity.PatientID = objAdmTaskQueue.PatientID
	s entity.EpisodeID = objAdmTaskQueue.EpisodeID
	s entity.MedRecordNo = objAdmTaskQueue.MedRecordNo
	s entity.RegNo = objAdmTaskQueue.RegNo
	s entity.IPRecordNo = objAdmTaskQueue.IPRecordNo
	s entity.OPRecordNo = objAdmTaskQueue.OPRecordNo
	s entity.EPRecordNo = objAdmTaskQueue.EPRecordNo
	s entity.Priority = objAdmTaskQueue.Priority
	s entity.AdmDate = objAdmTaskQueue.AdmDate
	s entity.CandidateDate = objAdmTaskQueue.CandidateDate
	s entity.CandidateTime = objAdmTaskQueue.CandidateTime
	s entity.SchemeType = objAdmTaskQueue.SchemeType
	s entity.TaskType = objAdmTaskQueue.TaskType
	s entity.VersionTypeCode = objAdmTaskQueue.VersionTypeCode
	s entity.SpecialFlag = objAdmTaskQueue.SpecialFlag
	s entity.SpecialParam = objAdmTaskQueue.SpecialParam
	s entity.CreateCount = objAdmTaskQueue.CreateCount
	s entity.AdmType = objAdmTaskQueue.AdmType
	q entity
}

ClassMethod DeleteByID(AAdmTaskQueueID As %String) As %Boolean
{
}

ClassMethod CheckCondition(ATaskQueueID As %String, APatientName As %String = "", AAdmLocID As %String = "", ADisLocID As %String = "")
{
	s obj = ##class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(ATaskQueueID)
	if ((APatientName '= "") && (APatientName '= $c(0)))
	{
		s patientID = obj.PatientID
		s Name = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetName(patientID) 
		if (Name '= APatientName)
		{
			q "0"
		}
	}
	
	if ((AAdmLocID '= "") && (AAdmLocID '= $c(0)))
	{
		s episodeID = obj.EpisodeID	
		q:(episodeID = "") "0"
		s AdmDept = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).AdmDept(episodeID)
		if ((AdmDept '= "") && (AdmDept '= $c(0)))
		{
			s AdmDept = $P(AdmDept,"^",1)
			if (AdmDept '= AAdmLocID)
			{
				q "0"
			}
		}
	}
	
	if ((ADisLocID '= "") && (ADisLocID '= $c(0)))
	{
		s episodeID = obj.EpisodeID	
		q:(episodeID = "") "0"
		s DisDept = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDept(episodeID)
		if ((DisDept '= "") && (DisDept '= $c(0)))
		{
			s DisDept = $P(DisDept,"^",1)
			if (DisDept '= ADisLocID)
			{
				q "0"
			}
		}
	}
	
	q "1"
}

ClassMethod GetAdmTaskQueueTotalCount(ARegNo As %String, AMedRecordNo As %String, AStartDate As %String, AEndDate As %String, AType As %String = "", AEpisodeID As %String = "", APatientName As %String = "", AAdmLocID As %String = "", ADisLocID As %String = "", AObservedNo As %String = "", AAdmType As %String = "ALL") As %String
{
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)
	s date = endDate+1
	
	s count = 0
	
	if (ARegNo '= "")&&(ARegNo '= $c(0))
	{
		s ARegNo=##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).AddZero(ARegNo)
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxRegNo", " "_ARegNo, rowID))
			q:(rowID = "")
			continue:(..CheckCondition(rowID,APatientName,AAdmLocID,ADisLocID) = "0")
			if (AAdmType '= "ALL")
			{
				s objAdmTaskQueue = ##class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(rowID)
				continue:(AAdmType '= objAdmTaskQueue.AdmType)
			}
			s count = count + 1
		}
	}
	elseif (AMedRecordNo '= "")&&(AMedRecordNo '= $c(0))
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxMedRecordNo", " "_AMedRecordNo, rowID))
			q:(rowID = "")
			continue:(..CheckCondition(rowID,APatientName,AAdmLocID,ADisLocID) = "0")
			if (AAdmType '= "ALL")
			{
				s objAdmTaskQueue = ##class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(rowID)
				continue:(AAdmType '= objAdmTaskQueue.AdmType)
			}
			s count = count + 1
		}	
	}
	elseif (AEpisodeID '= "")&&(AEpisodeID '= $c(0))
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxEpisode", " "_AEpisodeID, rowID))
			q:(rowID = "")
			continue:(..CheckCondition(rowID,APatientName,AAdmLocID,ADisLocID) = "0")
			if (AAdmType '= "ALL")
			{
				s objAdmTaskQueue = ##class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(rowID)
				continue:(AAdmType '= objAdmTaskQueue.AdmType)
			}
			s count = count + 1
		}	
	}
	elseif (AObservedNo '= "")&&(AObservedNo '= $c(0))
	{
		s mrPatientID = ""
		for {
			s mrPatientID  = $o(^DHCEPRFS.INST.MRPatientI("IdxObservedNo", " "_AObservedNo,mrPatientID))
			q:(mrPatientID="")
			s obj = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
			s regNo = obj.RegNo
			if (regNo '= "")
			{
				s rowID = ""
				for {
					s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxRegNo", " "_regNo, rowID))
					q:(rowID = "")
					continue:(..CheckCondition(rowID,APatientName,AAdmLocID,ADisLocID) = "0")
					if (AAdmType '= "ALL")
					{
						s objAdmTaskQueue = ##class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(rowID)
						continue:(AAdmType '= objAdmTaskQueue.AdmType)
					}
					s count = count + 1
				}
			}
		}
	}
	elseif (AType '= "")&&(AType '= $c(0))
	{
 		for {
			s date =  $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxTypeCandidateDateTime", " "_AType,date),-1)
			q:(date = "")
			q:(date<startDate)
			s time = ""

			for {
				s time =  $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxTypeCandidateDateTime", " "_AType,date, time),-1)
				q:(time = "")

				s rowID = ""
				for {
					s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxTypeCandidateDateTime", " "_AType,date, time, rowID))
					q:(rowID = "")
					continue:(..CheckCondition(rowID,APatientName,AAdmLocID,ADisLocID) = "0")
					if (AAdmType '= "ALL")
					{
						s objAdmTaskQueue = ##class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(rowID)
						continue:(AAdmType '= objAdmTaskQueue.AdmType)
					}
					s count = count + 1
				}
			}
		}
	}
	else
	{
 		for {
			s date =  $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxCandidateDateTime", date),-1)
			//b "s"
			q:(date = "")
			q:(date<startDate)
			s time = ""

			for {
				s time =  $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxCandidateDateTime", date, time),-1)
				q:(time = "")

				s rowID = ""
				for {
					s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxCandidateDateTime", date, time, rowID))
					q:(rowID = "")
					continue:(..CheckCondition(rowID,APatientName,AAdmLocID,ADisLocID) = "0")
					if (AAdmType '= "ALL")
					{
						s objAdmTaskQueue = ##class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(rowID)
						continue:(AAdmType '= objAdmTaskQueue.AdmType)
					}
					s count = count + 1
				}
			}
		}
	}
	q count
}

/// 获取待执行队列列表
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLAdmTaskQueue","GetAdmTaskQueueList","","","2014-01-06","2014-1-6")
Query GetAdmTaskQueueList(ARegNo As %String, AMedRecordNo As %String, AStartDate As %String, AEndDate As %String, AType As %String = "", APageStart As %String = "", APageSize As %String = "", AEpisodeID As %String = "", APatientName As %String = "", AAdmLocID As %String = "", ADisLocID As %String = "", AObservedNo As %String = "", AAdmType As %String = "ALL") As %Query(ROWSPEC = "ID:%String,SysCode:%String,PatientID:%String,EpisodeID:%String,MedRecordNo:%String,IPRecordNo:%String,OPRecordNo:%String,EPRecordNo:%String,RegNo:%String,Name:%String,Gender:%String,AdmDate:%String,DisDate:%String,AdmDept:%String,DisDept:%String,Priority:%String,CandidateDate:%String,CandidateTime:%String,SchemeType:%String,TaskType:%String,VersionTypeCode:%String,SpecialFlag:%String,SpecialParam:%String,CreateCount:%String,IsAdvancedSecurity:%String")
{
}

ClassMethod GetAdmTaskQueueListExecute(ByRef qHandle As %Binary, ARegNo As %String, AMedRecordNo As %String, AStartDate As %String, AEndDate As %String, AType As %String = "", APageStart As %String = "", APageSize As %String = "", AEpisodeID As %String = "", APatientName As %String = "", AAdmLocID As %String = "", ADisLocID As %String = "", AObservedNo As %String = "", AAdmType As %String = "ALL") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)
	s date = endDate+1
	
	s count = 0
	
	if (ARegNo '= "")&&(ARegNo '= $c(0))
	{
		s ARegNo=##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).AddZero(ARegNo)
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxRegNo", " "_ARegNo, rowID))
			q:(rowID = "")
			s ret = $$OutPutRow(rowID,count,APageStart,APageSize)
			q:(ret = "q")
			s count = ret
		}
	}
	elseif (AMedRecordNo '= "")&&(AMedRecordNo '= $c(0))
	{
		s AMedRecordNo =  $zcvt(AMedRecordNo,"U")
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxMedRecordNo", " "_AMedRecordNo, rowID))
			q:(rowID = "")
			s ret = $$OutPutRow(rowID,count,APageStart,APageSize)
			q:(ret = "q")
			s count = ret
		}	
	}
	elseif (AEpisodeID '= "")&&(AEpisodeID '= $c(0))
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxEpisode", " "_AEpisodeID, rowID))
			q:(rowID = "")
			s ret = $$OutPutRow(rowID,count,APageStart,APageSize)
			q:(ret = "q")
			s count = ret
		}	
	}
	elseif (AObservedNo '= "")&&(AObservedNo '= $c(0))
	{
		s mrPatientID = ""
		for {
			s mrPatientID  = $o(^DHCEPRFS.INST.MRPatientI("IdxObservedNo", " "_AObservedNo,mrPatientID))
			q:(mrPatientID="")
			s obj = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
			s regNo = obj.RegNo
			if (regNo '= "")
			{
				s rowID = ""
				for {
					s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxRegNo", " "_regNo, rowID))
					q:(rowID = "")
					s ret = $$OutPutRow(rowID,count,APageStart,APageSize)
					q:(ret = "q")
					s count = ret
				}
			}
		}
	}
	elseif (AType '= "")&&(AType '= $c(0))
	{
 		for {
			s date =  $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxTypeCandidateDateTime", " "_AType,date),-1)
			q:(date = "")
			q:(date<startDate)
			s time = ""

			for {
				s time =  $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxTypeCandidateDateTime", " "_AType,date, time),-1)
				q:(time = "")

				s rowID = ""
				for {
					s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxTypeCandidateDateTime", " "_AType,date, time, rowID))
					q:(rowID = "")
					s ret = $$OutPutRow(rowID,count,APageStart,APageSize)
					q:(ret = "q")
					s count = ret
				}
			}
		}
	}
	else
	{
 		for {
			s date =  $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxCandidateDateTime", date),-1)
			//b "s"
			q:(date = "")
			q:(date<startDate)
			s time = ""

			for {
				s time =  $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxCandidateDateTime", date, time),-1)
				q:(time = "")

				s rowID = ""
				for {
					s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxCandidateDateTime", date, time, rowID))
					q:(rowID = "")
					s ret = $$OutPutRow(rowID,count,APageStart,APageSize)
					q:(ret = "q")
					s count = ret
				}
			}
		}
	}
	Quit $$$OK
OutPutRow(rowID,count,APageStart,APageSize)
	s ID = rowID
	s obj = ##class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(rowID)
	if (AAdmType '= "ALL")
	{
		q:(AAdmType '= obj.AdmType) count
	}
	s SysCode = obj.SysCode
	s PatientID = obj.PatientID
	s EpisodeID = obj.EpisodeID
	
	s:(AAdmLocID = $c(0)) AAdmLocID = ""
	if (AAdmLocID '= "")
	{
		q:(EpisodeID = "") count	
	}
	s:(ADisLocID = $c(0)) ADisLocID = ""
	if (ADisLocID '= "")
	{
		q:(EpisodeID = "") count	
	}
	
	s MedRecordNo = obj.MedRecordNo
	s IPRecordNo = obj.IPRecordNo
	s OPRecordNo = obj.OPRecordNo
	s EPRecordNo = obj.EPRecordNo
	s Priority = obj.Priority
	s AdmDate = $zd(obj.AdmDate,3)
	s CandidateDate = $zd(obj.CandidateDate,3)
	s CandidateTime = $zt(obj.CandidateTime,1)
	s SchemeType = obj.SchemeType
	s TaskType = obj.TaskType
	s VersionTypeCode = obj.VersionTypeCode
	s SpecialFlag = obj.SpecialFlag
	s SpecialParam = obj.SpecialParam
	s CreateCount = obj.CreateCount
	
	s RegNo = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNo(PatientID)
	s Name = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetName(PatientID) 
	q:((APatientName '= "") && (APatientName '= $c(0)) && (APatientName '= Name)) count
	s Gender = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetGender(PatientID)
	s Gender = $p(Gender,"^",3)
	
	s AdmDept = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).AdmDept(EpisodeID)
	if ((AdmDept '= "") && (AdmDept '= $c(0)))
	{
		s AdmDeptID = $P(AdmDept,"^",1)
		s AdmDept = $P(AdmDept,"^",3)
		
		q:((AAdmLocID '= "") && (AAdmLocID '= $c(0)) && (AAdmLocID '= AdmDeptID)) count
	}
	s DisDept = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDept(EpisodeID)
	if ((DisDept '= "") && (DisDept '= $c(0)))
	{
		s DisDeptID = $P(DisDept,"^",1)
		s DisDept = $P(DisDept,"^",3)
		
		q:((ADisLocID '= "") && (ADisLocID '= $c(0)) && (ADisLocID '= DisDeptID)) count
	}
	
	s AdmDate = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmDate(EpisodeID)
	if ((AdmDate '= "") && (AdmDate '= $c(0)))
	{
		s AdmDate = $zd(AdmDate,3)
	}
	s DisDate = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTime(EpisodeID)
	s DisDate = $p(DisDate,",",1)
	if ((DisDate '= "") && (DisDate '= $c(0)))
	{
		s DisDate = $zd(DisDate,3)
	}
	else
	{
		//没出院不显示出院科室
		s DisDeptID = ""
		s DisDept = ""
	}
	
	s count = count + 1
	if (APageStart '= "")
	{
		q:(count < (+APageStart)) count
		q:(count >= (+APageStart+(+APageSize))) "q"
	}
	
	//IsAdvancedSecurity
    s ASrowID = ""
	s ASrowID = $o(^DHCEPRRBAC.META.ASecurityI("IdxUnique"," DHC", " "_EpisodeID,ASrowID))
	if (ASrowID="")
	{	s IsAdvancedSecurity="N" }
	else
	{	s IsAdvancedSecurity="Y"}
	 
 	s data = $lb(ID,SysCode,PatientID,EpisodeID,MedRecordNo,IPRecordNo,OPRecordNo,EPRecordNo,RegNo,Name,Gender,AdmDate,DisDate,AdmDept,DisDept,Priority,CandidateDate,CandidateTime,SchemeType,TaskType,VersionTypeCode,SpecialFlag,SpecialParam,CreateCount,IsAdvancedSecurity)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q count
}

ClassMethod GetAdmTaskQueueListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmTaskQueueListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAdmTaskQueueListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmTaskQueueListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// 	提高降低优先级
ClassMethod PriorityOperation(AdmTaskQueueID As %String, OpType As %String, APriority As %String = "") As %String
{
	q:(AdmTaskQueueID = "") ""
	q:(OpType = "") ""
	
	s objAdmTaskQueue = ##Class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(AdmTaskQueueID)
	q:(objAdmTaskQueue="") ""
	
	s priority = objAdmTaskQueue.Priority
	s taskType = objAdmTaskQueue.TaskType
	
	if (OpType = "increase")
	{
		s priority = priority + 1	
	}
	elseif (OpType = "decrease")
	{
		if (priority > 1)
		{
			s priority = priority - 1	
		}	
	}
	elseif (OpType = "send2greenchannel")
	{
		s priority = 150 	
		s taskType = "G"
	}
	elseif (OpType = "send2normal")
  	{
    	s priority = 50   
    	s taskType = "N"
  	}
	elseif (OpType = "setpriority")
	{
		s priority = +APriority 	
	}
	
	s objAdmTaskQueue.Priority = priority
	s objAdmTaskQueue.TaskType = taskType
	s status = objAdmTaskQueue.%Save()
	q:($$$ISOK(status)) "1"
	q "-1"
}

/// 	检查是否已经生成过
ClassMethod CheckCreated(AEpisodeID As %String, ASchemeType As %String = "") As %String
{
	s ret = ""
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxEpisodeID"," "_AEpisodeID,rowID))
		q:(rowID = "")	
		
		s admTaskSucceedObj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)
		s succeedDate = admTaskSucceedObj.SucceedDate
		s succeedTime = admTaskSucceedObj.SucceedTime
		s schemeType = admTaskSucceedObj.SchemeType
		continue:(schemeType '= "")
		continue:((ASchemeType '= "") && (schemeType '= ASchemeType))
		s succeedDateTime = $zd(succeedDate,3)_" "_$zt(succeedTime,3)
		if (ret = "")
		{
			s ret = succeedDateTime	
		}
		else
		{
			s ret = ret_"^"_succeedDateTime	
		}
	}
	
	q ret
}

ClassMethod CreateSealUpTask(ID As %String) As %String
{
	s ret = ID
	q "1"
}

/// w ##class(DHCEPRFS.BL.BLAdmTaskQueue).Test123("2017-8-23","2017-8-24")
ClassMethod Test123(AStartDate As %String, AEndDate As %String) As %String
{
	s count =0
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)
	for date = startDate:1:endDate
	{
		s time =""
		for {
			s time = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxSucceedDateTime" ,date,time))
			q:(time = "")
			s rowID =""
			for {
				s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxSucceedDateTime" ,date,time,rowID))
				q:(rowID = "")
				s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)
				s sysCode = obj.SysCode
				s episodeID = obj.EpisodeID
				s priority = obj.Priority
				s schemeType = obj.SchemeType
				s taskType = obj.TaskType
				s versionTypeCode = obj.VersionTypeCode
				s specialFlag = obj.SpecialFlag
				s specialParam = obj.SpecialParam
				s sc = ..Create(sysCode,episodeID,priority,schemeType,taskType,versionTypeCode,specialFlag,specialParam)
				if (sc'="")
				{
					s count = count +1
				}
			}
		}
	}
	q count
}

/// Desc:此需求针对温岭市第一人民医院，对延迟队列的就诊重新生成
/// Return:	count是加入队列的总数。
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).AutoComplete()
ClassMethod AutoComplete() As %String
{
	s count = 0
	
	s AutoDate = $p($h,",",1)-3
	for {
		s AutoDate = $o(^DHCEPRFS.INST.AdmMRQueueI("IdxMain"," 0",AutoDate),-1)
		q:(AutoDate="")
		
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.INST.AdmMRQueueI("IdxMain"," 0",AutoDate,rowID))
			q:(rowID ="")
			s obj = ##class(DHCEPRFS.INST.AdmMRStatusQueue).%OpenId(rowID)
			s episodeID = ""
			s episodeID = obj.EpisodeID
			s userID = obj.UserID
			s schemeType  = obj.SchemeType
			s result = ..Create("DHC",episodeID,"50",schemeType,"N","","","")
			if (result '= "")
			{	
				s obj.CreateFlag = "1"
				s sc = obj.%Save()
				if ($$$ISOK(sc))
				{			
					s count = count +1
				}
			}
		}
	}
	q count
}

/// Desc: 加入延迟队列
/// Return: 0-失败, 1-成功
/// Debug: w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).AddStatusQueue("581","CREATELIS")
ClassMethod AddStatusQueue(AEpisodeID As %String, ASchemeType As %String = "", AUserID As %String = "") As %String
{
	s rowID = ""
	s rowID = $o(^DHCEPRFS.INST.AdmMRQueueI("IdxEpisodeID"," "_AEpisodeID,rowID))
	if (rowID = "")
	{
		s obj = ##class(DHCEPRFS.INST.AdmMRStatusQueue).%New()
	}
	else
	{
		s obj = ##class(DHCEPRFS.INST.AdmMRStatusQueue).%OpenId(rowID)
	}
	s obj.EpisodeID = AEpisodeID
	s obj.ActDate = $p($h,",",1)
	s obj.ActTime = $p($h,",",2)
	s obj.CreateFlag = "0"
	s obj.UserID = AUserID
	s obj.SchemeType = ASchemeType
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// Desc: 重新生成，在待生成列表中插入记录
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).ReCreate2TaskType("queuelist","79","D")
ClassMethod ReCreate2TaskType(AListType As %String, ARecordID As %String, ATaskType As %String) As %String
{
	//待生成队列
	if (AListType = "queuelist")
	{
		s objAdmTaskQueue=##class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(ARecordID)
		if (objAdmTaskQueue '= "")
		{
			s objAdmTaskQueue.TaskType = ATaskType
			s sc = objAdmTaskQueue.%Save()
		}
		q "1"
	}
	
	//正在生成队列
	if (AListType = "executelist")
	{
		s entityAdmTaskExec=##class(DHCEPRFS.BL.BLAdmTaskExec).GetAdmTaskExecByID(ARecordID)
		if (entityAdmTaskExec = "")
		{
			q "1"
		}
		else
		{
			s entityAdmTaskExec.TaskType = ATaskType
			d ##class(DHCEPRFS.BL.BLAdmTaskExec).MoveTaskExecToQueue(entityAdmTaskExec)
			q "1"
		}
	}
		
	//正在生成队列
	if (AListType = "successlist")
	{
		s entityAdmTaskSucceed=##class(DHCEPRFS.BL.BLAdmTaskSucceed).GetAdmTaskSucceedByID(ARecordID)
		if (entityAdmTaskSucceed = "")
		{
			q "1"	
		}
		else
		{
			s entityAdmTaskSucceed.TaskType = ATaskType
			d ##class(DHCEPRFS.BL.BLAdmTaskSucceed).MoveTaskSucceedToQueue(entityAdmTaskSucceed)
			q "1"
		}
		
	}
}

/// Desc: 根据任务类型获取队列中最优先任务的就诊号
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).CheckAdmQueueByTaskType("N")
ClassMethod CheckAdmQueueByTaskType(ATaskType As %String) As %String
{
	s queueRowID = ..GetTopPriorityByTaskType(ATaskType)
	q:(queueRowID="") ""
	
	s entity = ..GetAdmTaskQueueByID(queueRowID)
	q entity.EpisodeID
}

}
