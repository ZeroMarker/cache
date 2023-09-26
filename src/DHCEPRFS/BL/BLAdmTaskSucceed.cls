Class DHCEPRFS.BL.BLAdmTaskSucceed Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod Create(AEAdmTaskExec As DHCEPRFS.Entity.EAdmTaskExec) As %String
{
	s obj = ##Class(DHCEPRFS.INST.AdmTaskSucceed).%New()
	s obj.SysCode = AEAdmTaskExec.SysCode
	s obj.PatientID = AEAdmTaskExec.PatientID
	s obj.EpisodeID = AEAdmTaskExec.EpisodeID
	s obj.MedRecordNo = AEAdmTaskExec.MedRecordNo
	s obj.RegNo = AEAdmTaskExec.RegNo
	s obj.IPRecordNo = AEAdmTaskExec.IPRecordNo
	s obj.OPRecordNo = AEAdmTaskExec.OPRecordNo
	s obj.EPRecordNo = AEAdmTaskExec.EPRecordNo
	s obj.Priority = AEAdmTaskExec.Priority
	s obj.AdmDate = AEAdmTaskExec.AdmDate
	s obj.CandidateDate = AEAdmTaskExec.CandidateDate
	s obj.CandidateTime = AEAdmTaskExec.CandidateTime
	s obj.TaskDate = AEAdmTaskExec.TaskDate
	s obj.TaskTime = AEAdmTaskExec.TaskTime
	//s obj.TaskRemark = ""
	s obj.SucceedDate = $p($h,",",1)
	s obj.SucceedTime = $p($h,",",2)
	s obj.IP = AEAdmTaskExec.IP
	s obj.UserID = AEAdmTaskExec.UserID
	s obj.SchemeType = AEAdmTaskExec.SchemeType
	s obj.TaskType = AEAdmTaskExec.TaskType
	s obj.VersionTypeCode = AEAdmTaskExec.VersionTypeCode
	s obj.SpecialFlag = AEAdmTaskExec.SpecialFlag
	s obj.SpecialParam = AEAdmTaskExec.SpecialParam
	s obj.AdmType = AEAdmTaskExec.AdmType
	s obj.CreateCount = AEAdmTaskExec.CreateCount
	
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

/// Desc:	重新生成，即将选中的执行队列项移动到待生成队列
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskSucceed).Recreate()
ClassMethod Recreate(AAdmTaskSucceedID As %String) As %String
{
	q:(AAdmTaskSucceedID = "") ""	
	s entity = ..GetAdmTaskSucceedByID(AAdmTaskSucceedID)
	q:(entity = "") ""
	s status = ..MoveTaskSucceedToQueue(entity)
	
	s ASpecialFlag = entity.SpecialFlag
	if (ASpecialFlag = "IMPORTSCAN")
	{
		//b "s"
		s importScanID = $o(^DHCEPRFS.INST.ImportScanI("IdxAdmTaskSucceed"," "_AAdmTaskSucceedID,""))
		s importScanID = $tr(importScanID," ","")	
		d ##class(DHCEPRFS.BL.BLImportScan).UpdateAdmTaskQueue(importScanID,status)
	}
	
	q status
}

/// Desc:	重新生成，发送到绿色通道
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmTaskSucceed).RecreateSend2GreenChannel("35760")
ClassMethod RecreateSend2GreenChannel(AAdmTaskSucceedID As %String) As %String
{
	q:(AAdmTaskSucceedID = "") ""	
	s entity = ..GetAdmTaskSucceedByID(AAdmTaskSucceedID)
	q:(entity = "") ""
	s queueRowID = ..MoveTaskSucceedToQueue(entity)
	d ##Class(DHCEPRFS.BL.BLAdmTaskQueue).PriorityOperation(queueRowID,"send2greenchannel")
	q queueRowID
}

ClassMethod GetAdmTaskSucceedByID(AAdmTaskSucceedID As %String) As DHCEPRFS.Entity.EAdmTaskSucceed
{
	s obj = ##Class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(AAdmTaskSucceedID)
	q:(obj = "") ""
	
	s entity = ##Class(DHCEPRFS.Entity.EAdmTaskSucceed).%New()
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
	s entity.SucceedDate = obj.SucceedDate
	s entity.SucceedTime = obj.SucceedTime
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

ClassMethod MoveTaskSucceedToQueue(AEAdmTaskSucceed As DHCEPRFS.Entity.EAdmTaskSucceed) As %String
{
	TSTART
	
	s $zt = "OnMoveErrorHandler"
	
	s rowID = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).CreateByExec(AEAdmTaskSucceed)
	if (rowID = "") 
	{
		TROLLBACK
		q ""
	}
	
	s status = ##Class(DHCEPRFS.INST.AdmTaskSucceed).%DeleteId(AEAdmTaskSucceed.ID)
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

ClassMethod CheckCondition(ATaskSucceedID As %String, APatientName As %String = "", AAdmLocID As %String = "", ADisLocID As %String = "")
{
	s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(ATaskSucceedID)
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

ClassMethod GetAdmTaskSucceedTotalCount(ARegNo As %String, AMedRecordNo As %String, AStartDate As %String, AEndDate As %String, AType As %String = "", AEpisodeID As %String = "", APatientName As %String = "", AAdmLocID As %String = "", ADisLocID As %String = "", AObservedNo As %String = "", AAdmType As %String = "ALL") As %String
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
			s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxRegNo", " "_ARegNo, rowID))
			q:(rowID = "")
			continue:(..CheckCondition(rowID,APatientName,AAdmLocID,ADisLocID) = "0")
			if (AAdmType '= "ALL")
			{
				s objAdmTaskSucceed = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)
				continue:(AAdmType '= objAdmTaskSucceed.AdmType)
			}
			s count = count + 1
		}
	}
	elseif (AMedRecordNo '= "")&&(AMedRecordNo '= $c(0))
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxMedRecordNo", " "_AMedRecordNo, rowID))
			q:(rowID = "")
			continue:(..CheckCondition(rowID,APatientName,AAdmLocID,ADisLocID) = "0")
			if (AAdmType '= "ALL")
			{
				s objAdmTaskSucceed = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)
				continue:(AAdmType '= objAdmTaskSucceed.AdmType)
			}
			s count = count + 1
		}	
	}
	elseif (AEpisodeID '= "")&&(AEpisodeID '= $c(0))
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxEpisodeID", " "_AEpisodeID, rowID))
			q:(rowID = "")
			continue:(..CheckCondition(rowID,APatientName,AAdmLocID,ADisLocID) = "0")
			if (AAdmType '= "ALL")
			{
				s objAdmTaskSucceed = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)
				continue:(AAdmType '= objAdmTaskSucceed.AdmType)
			}
			s count = count + 1
		}	
	}
	elseif (AObservedNo '= "")&&(AObservedNo '= $c(0))
	{
		s mrPatientID = ""
		for {
			s mrPatientID  = $o(^DHCEPRFS.INST.MRPatientI("IdxObservedNo"," "_AObservedNo,mrPatientID))
			q:(mrPatientID="")
			s obj = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
			s regNo = obj.RegNo
			if (regNo '= "")
			{
				s rowID = ""
				for {
					s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxRegNo", " "_regNo, rowID))
					q:(rowID = "")
					continue:(..CheckCondition(rowID,APatientName,AAdmLocID,ADisLocID) = "0")
					if (AAdmType '= "ALL")
					{
						s objAdmTaskSucceed = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)
						continue:(AAdmType '= objAdmTaskSucceed.AdmType)
					}
					s count = count + 1
				}
			}
		}
	}
	elseif (AType '= "")&&(AType '= $c(0))
	{
 		for {
			s date =  $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxTypeSucceedDateTime"," "_AType, date),-1)
			q:(date = "")
			q:(date<startDate)
			s time = ""

			for {
				s time =  $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxTypeSucceedDateTime", " "_AType, date, time),-1)
				q:(time = "")

				s rowID = ""
				for {
					s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxTypeSucceedDateTime", " "_AType, date, time, rowID))
					q:(rowID = "")
					continue:(..CheckCondition(rowID,APatientName,AAdmLocID,ADisLocID) = "0")
					if (AAdmType '= "ALL")
					{
						s objAdmTaskSucceed = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)
						continue:(AAdmType '= objAdmTaskSucceed.AdmType)
					}
					s count = count + 1
				}
			}
 		}
	}
	else
	{
 		for {
			s date =  $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxSucceedDateTime", date),-1)
			q:(date = "")
			q:(date<startDate)
			s time = ""

			for {
				s time =  $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxSucceedDateTime", date, time),-1)
				q:(time = "")

				s rowID = ""
				for {
					s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxSucceedDateTime", date, time, rowID))
					q:(rowID = "")
					continue:(..CheckCondition(rowID,APatientName,AAdmLocID,ADisLocID) = "0")
					if (AAdmType '= "ALL")
					{
						s objAdmTaskSucceed = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)
						continue:(AAdmType '= objAdmTaskSucceed.AdmType)
					}
					s count = count + 1
				}
			}
 		}
	}
	q count
}

/// 获取执行成功队列列表
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLAdmTaskSucceed","GetAdmTaskSucceedList","","","2015-11-11","2015-11-11","",1,200,"")
Query GetAdmTaskSucceedList(ARegNo As %String, AMedRecordNo As %String, AStartDate As %String, AEndDate As %String, AType As %String = "", APageStart As %String = "", APageSize As %String = "", AEpisodeID As %String = "", APatientName As %String = "", AAdmLocID As %String = "", ADisLocID As %String = "", AObservedNo As %String = "", AAdmType As %String = "ALL") As %Query(ROWSPEC = "ID:%String,SysCode:%String,PatientID:%String,EpisodeID:%String,MedRecordNo:%String,IPRecordNo:%String,OPRecordNo:%String,EPRecordNo:%String,RegNo:%String,Name:%String,Gender:%String,AdmDate:%String,DisDate:%String,AdmDept:%String,DisDept:%String,Priority:%String,CandidateDate:%String,CandidateTime:%String,TaskDate:%String,TaskTime:%String,SucceedDate:%String,SucceedTime:%String,IP:%String,UserID:%String,SchemeType:%String,TaskType:%String,VersionTypeCode:%String,SpecialFlag:%String,SpecialParam:%String,CreateCount:%String,IsAdvancedSecurity:%String")
{
}

ClassMethod GetAdmTaskSucceedListExecute(ByRef qHandle As %Binary, ARegNo As %String, AMedRecordNo As %String, AStartDate As %String, AEndDate As %String, AType As %String = "", APageStart As %String = "", APageSize As %String = "", AEpisodeID As %String = "", APatientName As %String = "", AAdmLocID As %String = "", ADisLocID As %String = "", AObservedNo As %String = "", AAdmType As %String = "ALL") As %Status
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
			s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxRegNo", " "_ARegNo, rowID))
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
			s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxMedRecordNo", " "_AMedRecordNo, rowID))
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
			s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxEpisodeID", " "_AEpisodeID, rowID))
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
			s mrPatientID  = $o(^DHCEPRFS.INST.MRPatientI("IdxObservedNo"," "_AObservedNo,mrPatientID))
			q:(mrPatientID = "")

			s obj = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
			s regNo = obj.RegNo
			if (regNo '= "")
			{
				s rowID = ""
				for {
					s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxRegNo", " "_regNo, rowID))
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
			s date =  $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxTypeSucceedDateTime"," "_AType, date),-1)
			q:(date = "")
			q:(date<startDate)
			s time = ""

			for {
				s time =  $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxTypeSucceedDateTime", " "_AType, date, time),-1)
				q:(time = "")

				s rowID = ""
				for {
					s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxTypeSucceedDateTime", " "_AType, date, time, rowID))
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
			s date =  $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxSucceedDateTime", date),-1)
			q:(date = "")
			q:(date<startDate)
			s time = ""

			for {
				s time =  $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxSucceedDateTime", date, time),-1)
				q:(time = "")

				s rowID = ""
				for {
					s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxSucceedDateTime", date, time, rowID))
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
	s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)
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
	s SucceedDate = $zd(obj.SucceedDate,3)
	s SucceedTime = $zt(obj.SucceedTime,1)
	s IP = obj.IP
	s UserID = obj.UserID
	s SchemeType = obj.SchemeType
	s TaskType = obj.TaskType
	s VersionTypeCode = obj.VersionTypeCode
	s CreateCount = obj.CreateCount
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
	
 	s data = $lb(ID,SysCode,PatientID,EpisodeID,MedRecordNo,IPRecordNo,OPRecordNo,EPRecordNo,RegNo,Name,Gender,AdmDate,DisDate,AdmDept,DisDept,Priority,CandidateDate,CandidateTime,TaskDate,TaskTime,SucceedDate,SucceedTime,IP,UserID,SchemeType,TaskType,VersionTypeCode,SpecialFlag,SpecialParam,CreateCount,IsAdvancedSecurity)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q count
}

ClassMethod GetAdmTaskSucceedListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmTaskSucceedListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAdmTaskSucceedListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmTaskSucceedListExecute ]
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

/// Desc:获得生成pdf状态
/// Debug: w ##Class(DHCEPRFS.BL.BLAdmTaskSucceed).GetSucceedStatus()
ClassMethod GetSucceedStatus(AEpisode As %String) As %String
{
	s result = "0"
	if ($d(^DHCEPRFS.INST.AdmTaskSucceedI("IdxEpisodeID"," "_AEpisode))>0)
	{
		s result = "1"
	}
	q result
}

/// Desc: 重新生成，发送到正常生成队列
/// Debug:  w ##Class(DHCEPRFS.BL.BLAdmTaskSucceed).RecreateSend2Normal("35760")
ClassMethod RecreateSend2Normal(AAdmTaskSucceedID As %String) As %String
{
  q:(AAdmTaskSucceedID = "") "" 
  s entity = ..GetAdmTaskSucceedByID(AAdmTaskSucceedID)
  q:(entity = "") ""
  s queueRowID = ..MoveTaskSucceedToQueue(entity)
  d ##Class(DHCEPRFS.BL.BLAdmTaskQueue).PriorityOperation(queueRowID,"send2normal")
  q queueRowID
}

}
