Class DHCEPRFS.BL.BLAdmTaskExec Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	检查生成队列里是否有出错的数据（出错指超过正常时间还在生成队列而没有移动到完成队列）
/// Debug：w ##Class(DHCEPRFS.BL.BLAdmTaskExec).CheckErrorAdmTaskExec("180000")	
ClassMethod CheckErrorAdmTaskExec(ATimeOutInterval As %String) As %String
{
	s eAdmTaskExec = ..GetErrorAdmTaskExec(ATimeOutInterval,"false")
	q:(eAdmTaskExec="") ""

	q eAdmTaskExec.EpisodeID
}

ClassMethod GetErrorAdmTaskExec(ATimeOutInterval As %String, AFlag As %String) As DHCEPRFS.Entity.EAdmTaskExec
{
	s ErrorMaxCreateCount = ##Class(DHCEPRFS.BL.BLSysOption).GetValueByName("ErrorMaxCreateCount")
	s ErrorMaxCreateCount = (+ErrorMaxCreateCount)
	if (ErrorMaxCreateCount < 1)
	{
		s ErrorMaxCreateCount = ##Class(DHCEPRFS.Const.DefaultSysOption).ErrorMaxCreateCount()
	}	
		
	s flag = "false"
	s createCount = ""
	for {
		s createCount = $O(^DHCEPRFS.INST.AdmTaskExecI("IdxPriorityCreateCount",createCount))
		q:(createCount="")

		s priority = ""
		for {
			s priority = $O(^DHCEPRFS.INST.AdmTaskExecI("IdxPriorityCreateCount",createCount,priority),-1)
			q:(priority="")

			s rowID = ""
			for {
				s rowID = $O(^DHCEPRFS.INST.AdmTaskExecI("IdxPriorityCreateCount",createCount,priority,rowID))
				q:(rowID="")

				s objAdmTaskExec = ##Class(DHCEPRFS.INST.AdmTaskExec).%OpenId(rowID)
				q:(objAdmTaskExec="")
				continue:(objAdmTaskExec.TaskType = "S")
			
				s timeInterval = (($p($h,",",1) - objAdmTaskExec.TaskDate)*24*3600 + ($p($h,",",2) - objAdmTaskExec.TaskTime))*1000
			
				//未超时，还在生成中，跳过
				continue:(timeInterval < +ATimeOutInterval)
				
				//超过最低优先级，则不处理，需人工干预
				//s minPriority = ##Class(DHCEPRFS.BL.BLSysOption).GetValueByName("ErrorRecreateMinPriority")
				//continue:(objAdmTaskExec.Priority < (+minPriority))
				//使用最大生成次数来控制是否可以继续尝试错误生成处理
				continue:(objAdmTaskExec.CreateCount > ErrorMaxCreateCount)
				
				//超时
				s flag = "true"
				s entity = ##Class(DHCEPRFS.Entity.EAdmTaskExec).%New()
				s entity.ID = objAdmTaskExec.%Id()
				s entity.SysCode = objAdmTaskExec.SysCode
				s entity.PatientID = objAdmTaskExec.PatientID
				s entity.EpisodeID = objAdmTaskExec.EpisodeID
				s entity.MedRecordNo = objAdmTaskExec.MedRecordNo
				s entity.RegNo = objAdmTaskExec.RegNo
				s entity.IPRecordNo = objAdmTaskExec.IPRecordNo
				s entity.OPRecordNo = objAdmTaskExec.OPRecordNo
				s entity.EPRecordNo = objAdmTaskExec.EPRecordNo
				s entity.Priority = objAdmTaskExec.Priority
				s entity.AdmDate = objAdmTaskExec.AdmDate
				s entity.CandidateDate = objAdmTaskExec.CandidateDate
				s entity.CandidateTime = objAdmTaskExec.CandidateTime
				s entity.TaskDate = objAdmTaskExec.TaskDate
				s entity.TaskTime = objAdmTaskExec.TaskTime
				s entity.TaskRemark = objAdmTaskExec.TaskRemark
				s entity.IP = objAdmTaskExec.IP
				s entity.UserID = objAdmTaskExec.UserID
				s entity.SchemeType = objAdmTaskExec.SchemeType
				s entity.VersionTypeCode = objAdmTaskExec.VersionTypeCode
				s entity.SpecialFlag = objAdmTaskExec.SpecialFlag
				s entity.SpecialParam = objAdmTaskExec.SpecialParam
				s entity.AdmType = objAdmTaskExec.AdmType
				s entity.CreateCount = objAdmTaskExec.CreateCount + 1
				
				//重新生成后把priority降低1并更新生成时间
				if (AFlag = "true")
				{
					s objAdmTaskExec.Priority = objAdmTaskExec.Priority - 1
					s objAdmTaskExec.CreateCount = objAdmTaskExec.CreateCount + 1
					s objAdmTaskExec.TaskDate = $p($h,",",1)
					s objAdmTaskExec.TaskTime = $p($h,",",2)
					s status = objAdmTaskExec.%Save()
				}
				d objAdmTaskExec.%Close()
				q
			}
			q:(flag = "true")
		}
		q:(flag = "true")
	}
	//没有不在生成的错误数据
	q:(flag = "false") ""
	//有不在生成的错误数据
	q entity
}

/// Desc:	检查是否有一条待执行的任务队列
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskExec).CheckAdmTaskExec()
ClassMethod CheckAdmTaskExec() As %String
{
	s eAdmTaskQueue = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).GetTopPriorityTask()
	q:(eAdmTaskQueue="") ""

	q eAdmTaskQueue.EpisodeID
}

/// Desc:	检查绿色通道是否有一条待执行的任务队列
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskExec).CheckGreenChannelAdmTaskExec()
ClassMethod CheckGreenChannelAdmTaskExec() As %String
{
	s eAdmTaskQueue = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).GetGreenChannelTask()
	q:(eAdmTaskQueue="") ""

	q eAdmTaskQueue.EpisodeID
}

/// Desc:	检查老病历是否有一条待执行的任务队列
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskExec).CheckOldAdmTaskExec()
ClassMethod CheckOldAdmTaskExec() As %String
{
	s eAdmTaskQueue = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).GetOldTask()
	q:(eAdmTaskQueue="") ""

	q eAdmTaskQueue.EpisodeID
}

/// Desc:	检查特殊是否有一条待执行的任务队列
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskExec).CheckSpecialAdmTaskExec()
ClassMethod CheckSpecialAdmTaskExec(ASpecialFlag As %String = "") As %String
{
	s eAdmTaskQueue = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).GetSpecialTask(ASpecialFlag)
	q:(eAdmTaskQueue="") ""

	q eAdmTaskQueue.SpecialParam
}

/// Desc:	重新生成，即将选中的执行队列项移动到待生成队列
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskExec).Recreate("94")
ClassMethod Recreate(AAdmTaskExecID As %String) As %String
{
	q:(AAdmTaskExecID = "") ""	
	s entity = ..GetAdmTaskExecByID(AAdmTaskExecID)
	q:(entity = "") ""
	s status = ..MoveTaskExecToQueue(entity)
	
	s ASpecialFlag = entity.SpecialFlag
	if (ASpecialFlag = "IMPORTSCAN")
	{
		//b "s"
		s importScanID = $o(^DHCEPRFS.INST.ImportScanI("IdxAdmTaskExecute"," "_AAdmTaskExecID,""))
		s importScanID = $tr(importScanID," ","")	
		d ##class(DHCEPRFS.BL.BLImportScan).UpdateAdmTaskQueue(importScanID,status)
	}
	q status
}

/// Desc:	重新生成，发送到绿色通道
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskExec).Recreate("1")
ClassMethod RecreateSend2GreenChannel(AAdmTaskExecID As %String) As %String
{
	q:(AAdmTaskExecID = "") ""	
	s entity = ..GetAdmTaskExecByID(AAdmTaskExecID)
	q:(entity = "") ""
	s queueRowID = ..MoveTaskExecToQueue(entity)
	d ##Class(DHCEPRFS.BL.BLAdmTaskQueue).PriorityOperation(queueRowID,"send2greenchannel")
	q queueRowID
}

/// Desc:	获取一条待执行的任务队列，将其放入当前执行队列
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskExec).GetAdmTaskExec()
ClassMethod GetAdmTaskExec(IP As %String, UserID As %String) As DHCEPRFS.Entity.EAdmTaskExec
{
	s eAdmTaskQueue = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).GetTopPriorityTask()
	q:(eAdmTaskQueue="") ""
	
	s admTaskExecID = ..MoveTaskQueueToExec(eAdmTaskQueue,IP,UserID)
	q:(admTaskExecID="") ""

	s entity = ..GetAdmTaskExecByID(admTaskExecID)
	q entity
}

/// Desc:	获取绿色通道一条待执行的任务队列，将其放入当前执行队列
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskExec).GetGreenChannelAdmTaskExec()
ClassMethod GetGreenChannelAdmTaskExec(IP As %String, UserID As %String) As DHCEPRFS.Entity.EAdmTaskExec
{
	s eAdmTaskQueue = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).GetGreenChannelTask()
	q:(eAdmTaskQueue="") ""
	
	s admTaskExecID = ..MoveTaskQueueToExec(eAdmTaskQueue,IP,UserID)
	q:(admTaskExecID="") ""

	s entity = ..GetAdmTaskExecByID(admTaskExecID)
	q entity
}

/// Desc:	获取老病历一条待执行的任务队列，将其放入当前执行队列
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskExec).GetOldAdmTaskExec()
ClassMethod GetOldAdmTaskExec(IP As %String, UserID As %String) As DHCEPRFS.Entity.EAdmTaskExec
{
	s eAdmTaskQueue = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).GetOldTask()
	q:(eAdmTaskQueue="") ""
	
	s admTaskExecID = ..MoveTaskQueueToExec(eAdmTaskQueue,IP,UserID)
	q:(admTaskExecID="") ""

	s entity = ..GetAdmTaskExecByID(admTaskExecID)
	q entity
}

/// Desc:	获取特殊一条待执行的任务队列，将其放入当前执行队列
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskExec).GetSpecialAdmTaskExec("192.168.0.1","13","IMPORTSCAN")
ClassMethod GetSpecialAdmTaskExec(IP As %String, UserID As %String, ASpecialFlag As %String = "") As DHCEPRFS.Entity.EAdmTaskExec
{
	s eAdmTaskQueue = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).GetSpecialTask(ASpecialFlag)
	q:(eAdmTaskQueue="") ""
	
	s admTaskExecID = ..MoveTaskQueueToExec(eAdmTaskQueue,IP,UserID)
	q:(admTaskExecID="") ""

	s entity = ..GetAdmTaskExecByID(admTaskExecID)
	
	if (ASpecialFlag = "IMPORTSCAN")
	{
		//b "s"
		s importScanID = $o(^DHCEPRFS.INST.ImportScanI("IdxAdmTaskQueue"," "_eAdmTaskQueue.ID,""))
		s importScanID = $tr(importScanID," ","")	
		s entity.TaskRemark = importScanID
		d ##class(DHCEPRFS.BL.BLImportScan).UpdateAdmTaskExec(importScanID,admTaskExecID)
	}
	q entity
}

/// Desc:	将任务从等待队列中转至执行队列中
/// Return:	新建AdmTaskExec的RowID
ClassMethod MoveTaskQueueToExec(AEAdmTaskQueue As DHCEPRFS.Entity.EAdmTaskQueue, IP As %String, UserID As %String) As %String
{
	//校验入参
	q:(AEAdmTaskQueue.ID = "") ""
	
	TSTART
	
	s $zt = "OnMoveErrorHandler"
	
	s rowID = ..Create(AEAdmTaskQueue,IP,UserID)
	if (rowID = "") 
	{
		TROLLBACK
		q ""
	}
	
	s status = ##Class(DHCEPRFS.INST.AdmTaskQueue).%DeleteId(AEAdmTaskQueue.ID)
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

ClassMethod MoveTaskExecToQueue(AEAdmTaskExec As DHCEPRFS.Entity.EAdmTaskExec) As %String
{
	TSTART
	
	s $zt = "OnMoveErrorHandler"
	
	s rowID = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).CreateByExec(AEAdmTaskExec)
	if (rowID = "") 
	{
		TROLLBACK
		q ""
	}
	
	s status = ##Class(DHCEPRFS.INST.AdmTaskExec).%DeleteId(AEAdmTaskExec.ID)
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
	B
	TROLLBACK
	q ""
}

ClassMethod Create(AEAdmTaskQueue As DHCEPRFS.Entity.EAdmTaskQueue, IP As %String, UserID As %String) As %String
{
	s obj = ##Class(DHCEPRFS.INST.AdmTaskExec).%New()
	s obj.SysCode = AEAdmTaskQueue.SysCode
	s obj.PatientID = AEAdmTaskQueue.PatientID
	s obj.EpisodeID = AEAdmTaskQueue.EpisodeID
	s obj.MedRecordNo = AEAdmTaskQueue.MedRecordNo
	s obj.RegNo = AEAdmTaskQueue.RegNo
	s obj.IPRecordNo = AEAdmTaskQueue.IPRecordNo
	s obj.OPRecordNo = AEAdmTaskQueue.OPRecordNo
	s obj.EPRecordNo = AEAdmTaskQueue.EPRecordNo
	s obj.Priority = AEAdmTaskQueue.Priority
	s obj.AdmDate = AEAdmTaskQueue.AdmDate
	s obj.CandidateDate = AEAdmTaskQueue.CandidateDate
	s obj.CandidateTime = AEAdmTaskQueue.CandidateTime
	s obj.TaskDate = $p($h,",",1)
	s obj.TaskTime = $p($h,",",2)
	s obj.TaskRemark = ""
	s obj.IP = IP
	s obj.UserID = UserID
	s obj.SchemeType = AEAdmTaskQueue.SchemeType
	s obj.TaskType = AEAdmTaskQueue.TaskType
	s obj.VersionTypeCode = AEAdmTaskQueue.VersionTypeCode
	s obj.SpecialFlag = AEAdmTaskQueue.SpecialFlag
	s obj.SpecialParam = AEAdmTaskQueue.SpecialParam
	s obj.AdmType = AEAdmTaskQueue.AdmType
	s obj.CreateCount = AEAdmTaskQueue.CreateCount + 1
	
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

/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskExec).GetAdmTaskExecByID("1")
ClassMethod GetAdmTaskExecByID(AAdmTaskExecID As %String) As DHCEPRFS.Entity.EAdmTaskExec
{
	s obj = ##Class(DHCEPRFS.INST.AdmTaskExec).%OpenId(AAdmTaskExecID)
	q:(obj = "") ""
	
	s entity = ##Class(DHCEPRFS.Entity.EAdmTaskExec).%New()
	s entity.ID = obj.%Id()
	s entity.SysCode = obj.SysCode
	s entity.PatientID = obj.PatientID
	s entity.EpisodeID = obj.EpisodeID
	s entity.MedRecordNo = obj.MedRecordNo
	s entity.RegNo = obj.RegNo
	s entity.IPRecordNo = obj.IPRecordNo
	s entity.OPRecordNo = obj.OPRecordNo
	s entity.EPRecordNo = obj.EPRecordNo
	s entity.Priority = obj.Priority
	s entity.AdmDate = obj.AdmDate
	s entity.CandidateDate = obj.CandidateDate
	s entity.CandidateTime = obj.CandidateTime
	s entity.TaskDate = obj.TaskDate
	s entity.TaskTime = obj.TaskTime
	s entity.TaskRemark = obj.TaskRemark
	s entity.IP = obj.IP
	s entity.UserID = obj.UserID
	s entity.SchemeType = obj.SchemeType
	s entity.TaskType = obj.TaskType
	s entity.VersionTypeCode = obj.VersionTypeCode
	s entity.SpecialFlag = obj.SpecialFlag
	s entity.SpecialParam = obj.SpecialParam
	s entity.AdmType = obj.AdmType
	s entity.CreateCount = obj.CreateCount
	
	q entity
}

ClassMethod UpdateRemark(AAdmTaskExecID As %String, ATaskRemark As %String) As %Boolean
{
	s obj = ##Class(DHCEPRFS.INST.AdmTaskExec).%OpenId(AAdmTaskExecID)
	q:(obj = "") "0"
	
	s obj.TaskRemark = ATaskRemark
	
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

/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskExec).CompleteTask("13")
ClassMethod CompleteTask(AAdmTaskExecID As %String, AInputParam As %String = "") As %String
{
	q:(AAdmTaskExecID = "") ""
	s entity = ..GetAdmTaskExecByID(AAdmTaskExecID)
	q:(entity = "") ""
	s status = ..MoveTaskExecToSucceed(entity)
	if (status '= "") d ..SetSucceedstatus(entity, AInputParam)
	
	s SpecialFlag = entity.SpecialFlag
	if (SpecialFlag = "IMPORTSCAN")
	{
		s importScanID = $o(^DHCEPRFS.INST.ImportScanI("IdxAdmTaskExecute"," "_AAdmTaskExecID,""))
		s importScanID = $tr(importScanID," ","")
		d ##class(DHCEPRFS.BL.BLImportScan).UpdateAdmTaskSucceed(importScanID,status)
	}
	q status
}

ClassMethod MoveTaskExecToSucceed(AEAdmTaskExec As DHCEPRFS.Entity.EAdmTaskExec) As %String
{
	TSTART
	
	s $zt = "OnMoveErrorHandler"
	
	s rowID = ##Class(DHCEPRFS.BL.BLAdmTaskSucceed).Create(AEAdmTaskExec)
	if (rowID = "") 
	{
		TROLLBACK
		q ""
	}
	
	s status = ##Class(DHCEPRFS.INST.AdmTaskExec).%DeleteId(AEAdmTaskExec.ID)
	if ($$$ISOK(status))
	{
		s episodeID = AEAdmTaskExec.EpisodeID
		//d ..UpdateIndex(episodeID)
		TCOMMIT
		q rowID
	}
	else
	{
		TROLLBACK
		q ""
	}	
	
OnMoveErrorHandler
	B
	TROLLBACK
	q ""
}

/// debug: d ##class(DHCEPRFS.BL.BLAdmTaskExec).UpdateIndex()
ClassMethod UpdateIndex(AEpisodeID As %String)
{
	s rowID = ""
	s rowID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_AEpisodeID,rowID))
	q:(rowID = "") ""
	
	d ##Class(DHCEPRSearch.BL.BLSearch).Create(rowID,"50")
}

ClassMethod SetSucceedstatus(AEAdmTaskExec As DHCEPRFS.Entity.EAdmTaskExec, AInputParam As %String = "") As %String
{
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEAdmTaskExec.EpisodeID,AEAdmTaskExec.SysCode)
	s pageCount = ##Class(DHCEPRFS.BL.BLMRVerItem).GetTotalCreateItemCount(mrEpisodeID,0)
	//s Flag = ##Class(DHCEPRFS.BL.BLMRLog).AddCreateLogDetail(mrEpisodeID,AEAdmTaskExec.UserID,pageCount)
	s Flag = ##Class(DHCEPRFS.BL.BLMRLog).AddCreateLogAll(AInputParam,AEAdmTaskExec.UserID,pageCount,AEAdmTaskExec.SchemeType)
    q Flag
}

ClassMethod CheckCondition(ATaskExecID As %String, APatientName As %String = "", AAdmLocID As %String = "", ADisLocID As %String = "")
{
	s obj = ##class(DHCEPRFS.INST.AdmTaskExec).%OpenId(ATaskExecID)
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

ClassMethod GetAdmTaskExecTotalCount(ARegNo As %String, AMedRecordNo As %String, AStartDate As %String, AEndDate As %String, AType As %String = "", AEpisodeID As %String = "", APatientName As %String = "", AAdmLocID As %String = "", ADisLocID As %String = "", AObservedNo As %String = "", AAdmType As %String = "ALL") As %String
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
			s rowID = $o(^DHCEPRFS.INST.AdmTaskExecI("IdxRegNo", " "_ARegNo, rowID))
			q:(rowID = "")
			continue:(..CheckCondition(rowID,APatientName,AAdmLocID,ADisLocID) = "0")
			if (AAdmType '= "ALL")
			{
				s objAdmTaskExec = ##class(DHCEPRFS.INST.AdmTaskExec).%OpenId(rowID)
				continue:(AAdmType '= objAdmTaskExec.AdmType)
			}
			s count = count + 1
		}
	}
	elseif (AMedRecordNo '= "")&&(AMedRecordNo '= $c(0))
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.INST.AdmTaskExecI("IdxMedRecordNo", " "_AMedRecordNo, rowID))
			q:(rowID = "")
			continue:(..CheckCondition(rowID,APatientName,AAdmLocID,ADisLocID) = "0")
			if (AAdmType '= "ALL")
			{
				s objAdmTaskExec = ##class(DHCEPRFS.INST.AdmTaskExec).%OpenId(rowID)
				continue:(AAdmType '= objAdmTaskExec.AdmType)
			}
			s count = count + 1
		}	
	}
	elseif (AEpisodeID '= "")&&(AEpisodeID '= $c(0))
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.INST.AdmTaskExecI("IdxEpisode", " "_AEpisodeID, rowID))
			q:(rowID = "")
			continue:(..CheckCondition(rowID,APatientName,AAdmLocID,ADisLocID) = "0")
			if (AAdmType '= "ALL")
			{
				s objAdmTaskExec = ##class(DHCEPRFS.INST.AdmTaskExec).%OpenId(rowID)
				continue:(AAdmType '= objAdmTaskExec.AdmType)
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
					s rowID = $o(^DHCEPRFS.INST.AdmTaskExecI("IdxRegNo", " "_regNo, rowID))
					q:(rowID = "")
					continue:(..CheckCondition(rowID,APatientName,AAdmLocID,ADisLocID) = "0")
					if (AAdmType '= "ALL")
					{
						s objAdmTaskExec = ##class(DHCEPRFS.INST.AdmTaskExec).%OpenId(rowID)
						continue:(AAdmType '= objAdmTaskExec.AdmType)
					}
					s count = count + 1
				}
			}
		}
	}
	elseif (AType '= "")&&(AType '= $c(0))
	{
 		for {
			s date =  $o(^DHCEPRFS.INST.AdmTaskExecI("IdxTypeTaskDateTime", " "_AType, date),-1)
			q:(date = "")
			q:(date<startDate)
			s time = ""

			for {
				s time =  $o(^DHCEPRFS.INST.AdmTaskExecI("IdxTypeTaskDateTime", " "_AType, date, time),-1)
				q:(time = "")

				s rowID = ""
				for {
					s rowID = $o(^DHCEPRFS.INST.AdmTaskExecI("IdxTypeTaskDateTime", " "_AType, date, time, rowID))
					q:(rowID = "")
					continue:(..CheckCondition(rowID,APatientName,AAdmLocID,ADisLocID) = "0")
					if (AAdmType '= "ALL")
					{
						s objAdmTaskExec = ##class(DHCEPRFS.INST.AdmTaskExec).%OpenId(rowID)
						continue:(AAdmType '= objAdmTaskExec.AdmType)
					}
					s count = count + 1
				}
			}
		}
	}
	else
	{
 		for {
			s date =  $o(^DHCEPRFS.INST.AdmTaskExecI("IdxTaskDateTime", date),-1)
			q:(date = "")
			q:(date<startDate)
			s time = ""

			for {
				s time =  $o(^DHCEPRFS.INST.AdmTaskExecI("IdxTaskDateTime", date, time),-1)
				q:(time = "")

				s rowID = ""
				for {
					s rowID = $o(^DHCEPRFS.INST.AdmTaskExecI("IdxTaskDateTime", date, time, rowID))
					q:(rowID = "")
					continue:(..CheckCondition(rowID,APatientName,AAdmLocID,ADisLocID) = "0")
					if (AAdmType '= "ALL")
					{
						s objAdmTaskExec = ##class(DHCEPRFS.INST.AdmTaskExec).%OpenId(rowID)
						continue:(AAdmType '= objAdmTaskExec.AdmType)
					}
					s count = count + 1
				}
			}
		}
	}
	q count
}

/// 获取执行队列列表
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLAdmTaskExec","GetAdmTaskExecList","","","2015-03-31","2015-03-31","")
Query GetAdmTaskExecList(ARegNo As %String, AMedRecordNo As %String, AStartDate As %String, AEndDate As %String, AType As %String = "", APageStart As %String = "", APageSize As %String = "", AEpisodeID As %String = "", APatientName As %String = "", AAdmLocID As %String = "", ADisLocID As %String = "", AObservedNo As %String = "", AAdmType As %String = "ALL") As %Query(ROWSPEC = "ID:%String,SysCode:%String,PatientID:%String,EpisodeID:%String,MedRecordNo:%String,IPRecordNo:%String,OPRecordNo:%String,EPRecordNo:%String,RegNo:%String,Name:%String,Gender:%String,AdmDate:%String,DisDate:%String,AdmDept:%String,DisDept:%String,Priority:%String,CandidateDate:%String,CandidateTime:%String,TaskDate:%String,TaskTime:%String,TaskRemark:%String,RemarkDate:%String,RemarkTime:%String,IP:%String,UserID:%String,SchemeType:%String,TaskType:%String,VersionTypeCode:%String,SpecialFlag:%String,SpecialParam:%String,CreateCount:%String,IsAdvancedSecurity:%String")
{
}

ClassMethod GetAdmTaskExecListExecute(ByRef qHandle As %Binary, ARegNo As %String, AMedRecordNo As %String, AStartDate As %String, AEndDate As %String, AType As %String = "", APageStart As %String = "", APageSize As %String = "", AEpisodeID As %String = "", APatientName As %String = "", AAdmLocID As %String = "", ADisLocID As %String = "", AObservedNo As %String = "", AAdmType As %String = "ALL") As %Status
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
			s rowID = $o(^DHCEPRFS.INST.AdmTaskExecI("IdxRegNo", " "_ARegNo, rowID))
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
			s rowID = $o(^DHCEPRFS.INST.AdmTaskExecI("IdxMedRecordNo", " "_AMedRecordNo, rowID))
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
			s rowID = $o(^DHCEPRFS.INST.AdmTaskExecI("IdxEpisode", " "_AEpisodeID, rowID))
			q:(rowID = "")
			s ret = $$OutPutRow(rowID,count,APageStart,APageSize)
			q:(ret = "q")
			s count = ret
		}	
	}
	elseif (AObservedNo '="")&&(AObservedNo '=$c(0))
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
					s rowID = $o(^DHCEPRFS.INST.AdmTaskExecI("IdxRegNo", " "_regNo, rowID))
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
			s date =  $o(^DHCEPRFS.INST.AdmTaskExecI("IdxTypeTaskDateTime", " "_AType, date),-1)
			q:(date = "")
			q:(date<startDate)
			s time = ""

			for {
				s time =  $o(^DHCEPRFS.INST.AdmTaskExecI("IdxTypeTaskDateTime", " "_AType, date, time),-1)
				q:(time = "")

				s rowID = ""
				for {
					s rowID = $o(^DHCEPRFS.INST.AdmTaskExecI("IdxTypeTaskDateTime", " "_AType, date, time, rowID))
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
			s date =  $o(^DHCEPRFS.INST.AdmTaskExecI("IdxTaskDateTime", date),-1)
			q:(date = "")
			q:(date<startDate)
			s time = ""

			for {
				s time =  $o(^DHCEPRFS.INST.AdmTaskExecI("IdxTaskDateTime", date, time),-1)
				q:(time = "")

				s rowID = ""
				for {
					s rowID = $o(^DHCEPRFS.INST.AdmTaskExecI("IdxTaskDateTime", date, time, rowID))
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
	s obj = ##class(DHCEPRFS.INST.AdmTaskExec).%OpenId(rowID)
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
	s TaskDate = $zd(obj.TaskDate,3)
	s TaskTime = $zt(obj.TaskTime,1)
	s TaskRemark = obj.TaskRemark
	s IP = obj.IP
	s UserID = obj.UserID
	s SchemeType = obj.SchemeType
	s TaskType = obj.TaskType
	s VersionTypeCode = obj.VersionTypeCode
	s CreateCount = obj.CreateCount
	s RemarkDate = obj.RemarkDate
	s RemarkTime = obj.RemarkTime
	s SpecialFlag = obj.SpecialFlag
	s SpecialParam = obj.SpecialParam
	
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
	
 	s data = $lb(ID,SysCode,PatientID,EpisodeID,MedRecordNo,IPRecordNo,OPRecordNo,EPRecordNo,RegNo,Name,Gender,AdmDate,DisDate,AdmDept,DisDept,Priority,CandidateDate,CandidateTime,TaskDate,TaskTime,TaskRemark,RemarkDate,RemarkTime,IP,UserID,SchemeType,TaskType,VersionTypeCode,SpecialFlag,SpecialParam,CreateCount,IsAdvancedSecurity)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q count
}

ClassMethod GetAdmTaskExecListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmTaskExecListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAdmTaskExecListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmTaskExecListExecute ]
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
ClassMethod PriorityOperation(AdmTaskExecID As %String, OpType As %String, APriority As %String = "") As %String
{
	q:(AdmTaskExecID = "") ""
	q:(OpType = "") ""
	
	s objAdmTaskExec = ##Class(DHCEPRFS.INST.AdmTaskExec).%OpenId(AdmTaskExecID)
	q:(objAdmTaskExec="") ""
	
	s priority = objAdmTaskExec.Priority
	
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
	elseif (OpType = "setpriority")
	{
		s priority = +APriority 	
	}
	
	s objAdmTaskExec.Priority = priority
	s status = objAdmTaskExec.%Save()
	q:($$$ISOK(status)) "1"
	q "-1"
}

ClassMethod GetAdmTaskXMLByID(AAdmTaskXMLInfoID As %String) As DHCEPRFS.Entity.EAdmTaskXmlInfo
{
    s objAdmTaskXmlInfo=##class(DHCEPRFS.INST.AdmTaskXmlInfo).%OpenId(AAdmTaskXMLInfoID)
    q:(objAdmTaskXmlInfo="") ""
    s objEntity=##class(DHCEPRFS.Entity.EAdmTaskXmlInfo).%New()
    s objEntity.EpisodeID=objAdmTaskXmlInfo.EpisodeID
    s objEntity.MRItemID=objAdmTaskXmlInfo.MRItemID
    s objEntity.OperDate=objAdmTaskXmlInfo.OperDate
    s objEntity.OperTime=objAdmTaskXmlInfo.OperTime
    s objEntity.XMLInfo=objAdmTaskXmlInfo.XMLInfo
    
    //取TypeCode
    s objMRItem=##class(DHCEPRFS.META.MRItem).%OpenId(objAdmTaskXmlInfo.MRItemID)
    if (objMRItem="")
    {
        s objEntity.TypeCode=""
    }
    else
    {
        s objEntity.TypeCode="CG"_objMRItem.Type
    }
    
    //取PatientID
    s mrEpisodeID = $O(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID", " DHC", " "_objAdmTaskXmlInfo.EpisodeID, ""))
    if (mrEpisodeID="")
    {
        s objEntity.PatientID=""
    }
    else
    {
        s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
        s objMRPatient=##class(DHCEPRFS.INST.MRPatient).%OpenId(objMREpisode.MRPatientID)
        s objEntity.PatientID=objMRPatient.PatientID
    }
    q objEntity
}

/// Desc: 重新生成，发送到正常生成队列
/// Debug:  w ##Class(DHCEPRFS.BL.BLAdmTaskExec).RecreateSend2Normal("1")
ClassMethod RecreateSend2Normal(AAdmTaskExecID As %String) As %String
{
  q:(AAdmTaskExecID = "") ""  
  s entity = ..GetAdmTaskExecByID(AAdmTaskExecID)
  q:(entity = "") ""
  s queueRowID = ..MoveTaskExecToQueue(entity)
  d ##Class(DHCEPRFS.BL.BLAdmTaskQueue).PriorityOperation(queueRowID,"send2normal")
  q queueRowID
}

/// Desc: 获取最优先的任务，并move到生成队列
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskExec).GetAdmTaskByTaskType("N","127.0.0.1","831")
ClassMethod GetAdmTaskByTaskType(ATaskType As %String, IP As %String, UserID As %String) As DHCEPRFS.Entity.EAdmTaskExec
{
	s queueRowID = ##class(DHCEPRFS.BL.BLAdmTaskQueue).GetTopPriorityByTaskType(ATaskType)
	q:(queueRowID="") ""
	
	s queueEntity = ##class(DHCEPRFS.BL.BLAdmTaskQueue).GetAdmTaskQueueByID(queueRowID)
	
	s admTaskExecID = ##class(DHCEPRFS.BL.BLAdmTaskExec).MoveTaskQueueToExec(queueEntity,IP,UserID)
	q:(admTaskExecID="") ""

	s execEntity = ##class(DHCEPRFS.BL.BLAdmTaskExec).GetAdmTaskExecByID(admTaskExecID)
	q execEntity
}

}
