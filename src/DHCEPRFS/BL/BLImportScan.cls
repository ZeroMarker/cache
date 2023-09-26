Class DHCEPRFS.BL.BLImportScan Extends %RegisteredObject
{

/// Debug: w ##class(DHCEPRFS.BL.BLImportScan).GetImportScanParam("5687272")
ClassMethod GetImportScanParam(AEpisodeID As %String) As %String
{
	//<patientno>00858465</patientno><patname>时文生</patname><indate></indate><outdate>2011-04-28</outdate>
	//<patientno>00858217</patientno><patname>吴秀华</patname><indate></indate><outdate>2012-03-05</outdate>
	s patientID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPapmiDR(AEpisodeID)
	s medRecordNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(patientID,"",AEpisodeID)	
	//s admDate = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmDate(AEpisodeID)
	//s:((admDate '= "") && (admDate '= $c(0))) admDate = $zd(admDate,3)
	s disDate = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTime(AEpisodeID)
	s:((disDate '= "") && (disDate '= $c(0))) disDate = $zd($p(disDate,",",1),3)
	s name = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetName(patientID)
	
	s ret = "<request><patientno>"_medRecordNo_"</patientno><patname>"_name_"</patname><indate></indate><outdate>"_disDate_"</outdate></request>"
	q ret
}

/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLImportScan","GetImportHistory","5687272")
Query GetImportHistory(AEpisodeID As %String) As %Query(ROWSPEC = "ImportScanID:%String,AdmTaskStatus:%String,AdmTaskStatusDesc:%String,AdmTaskQueueID:%String,AdmTaskQueueDateTime:%String,AdmTaskExecuteID:%String,AdmTaskExecuteDateTime:%String,AdmTaskSucceedID:%String,AdmTaskSucceedDateTime:%String")
{
}

ClassMethod GetImportHistoryExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

	s rowID = ""
	for {
		s rowID = $O(^DHCEPRFS.INST.ImportScanI("IdxEpisodeID"," "_AEpisodeID,rowID))
		q:(rowID = "")
		 		
		d Output(rowID) 
 	}
 	q $$$OK

Output(rowID)
	s obj = ##Class(DHCEPRFS.INST.ImportScan).%OpenId(rowID)
    q:(obj = "")
	
	s admTaskStatus = obj.AdmTaskStatus
	s admTaskStatusDesc = ""
	if (admTaskStatus = "Q")
	{
		s admTaskStatusDesc = "待生成"	
	}
	elseif (admTaskStatus = "E")
	{
		s admTaskStatusDesc = "生成"	
	}
	elseif (admTaskStatus = "S")
	{
		s admTaskStatusDesc = "完成"	
	}
	
	s admTaskQueueID = obj.AdmTaskQueueID
	s admTaskQueueDate = obj.AdmTaskQueueDate
	s:((admTaskQueueDate '= "") && (admTaskQueueDate '= $c(0))) admTaskQueueDate = $zd(admTaskQueueDate,3)
	s admTaskQueueTime = obj.AdmTaskQueueTime
	s:((admTaskQueueTime '= "") && (admTaskQueueTime '= $c(0))) admTaskQueueTime = $zt(admTaskQueueTime,3)
	s admTaskQueueDateTime = admTaskQueueDate_" "_admTaskQueueTime
	
	s admTaskExecuteID = obj.AdmTaskExecuteID
	s admTaskExecuteDate = obj.AdmTaskExecuteDate
	s:((admTaskExecuteDate '= "") && (admTaskExecuteDate '= $c(0))) admTaskExecuteDate = $zd(admTaskExecuteDate,3)
	s admTaskExecuteTime = obj.AdmTaskExecuteTime
	s:((admTaskExecuteTime '= "") && (admTaskExecuteTime '= $c(0))) admTaskExecuteTime = $zt(admTaskExecuteTime,3)
	s admTaskExecuteDateTime = admTaskExecuteDate_" "_admTaskExecuteTime
	
	s admTaskSucceedID = obj.AdmTaskSucceedID
	s admTaskSucceedDate = obj.AdmTaskSucceedDate
	s:((admTaskSucceedDate '= "") && (admTaskSucceedDate '= $c(0))) admTaskSucceedDate = $zd(admTaskSucceedDate,3)
	s admTaskSucceedTime = obj.AdmTaskSucceedTime
	s:((admTaskSucceedTime '= "") && (admTaskSucceedTime '= $c(0))) admTaskSucceedTime = $zt(admTaskSucceedTime,3)
	s admTaskSucceedDateTime = admTaskSucceedDate_" "_admTaskSucceedTime
    
    s ^CacheTemp(repid,ind) = $lb(rowID,admTaskStatus,admTaskStatusDesc,admTaskQueueID,admTaskQueueDateTime,admTaskExecuteID,admTaskExecuteDateTime,admTaskSucceedID,admTaskSucceedDateTime)
	s ind = ind + 1
	
	q
}

ClassMethod GetImportHistoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetImportHistoryExecute ]
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

ClassMethod GetImportHistoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetImportHistoryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Debug:  w ##class(DHCEPRFS.BL.BLImportScan).GetMRItemID("病案首页")
ClassMethod GetMRItemID(AThirdPartyName As %String) As %String
{
	s mrItemID = ""
	s mrItemID = $o(^DHCEPRFS.META.ImportSortMPI("IdxThirdPartyName"," "_AThirdPartyName,mrItemID))	
	s mrItemID = $tr(mrItemID," ","")
	q:(mrItemID = "") "^^"
	s obj = ##class(DHCEPRFS.META.MRItem).%OpenId(mrItemID)
	s param = obj.TypeParams
	s mrItemName = obj.Name
	q mrItemID_"^"_mrItemName_"^"_param
}

/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GeCheckScanList","2015-11-16","2015-11-16")
Query GetImportList(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "MedRecordNo:%String,PatientName:%String,AdmDate:%String,DisDate:%String,ParamXML:%String,ActDateTime:%String,EpisodeID:%String,AdmTaskStatus:%String,AdmTaskStatusDesc:%String,AdmTaskQueueID:%String,AdmTaskQueueDateTime:%String,AdmTaskExecuteID:%String,AdmTaskExecuteDateTime:%String,AdmTaskSucceedID:%String,AdmTaskSucceedDateTime:%String")
{
}

ClassMethod GetImportListExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

	
 	for date = AStartDate:1:AEndDate
 	{
		s time = ""
		for {
	 		s time = $O(^DHCEPRFS.INST.ImportScanI("IdxActDateTime",date,time))
	 		q:(time = "")
	 		s rowID = ""
	 		for {
		 		s rowID = $O(^DHCEPRFS.INST.ImportScanI("IdxActDateTime",date,time,rowID))
		 		q:(rowID = "")
		 		
		 		d Output(rowID,date,time) 
		 		
	 		}
		}
 	}
 	q $$$OK

Output(rowID,date,time)
	s obj = ##Class(DHCEPRFS.INST.ImportScan).%OpenId(rowID)
    q:(obj = "")
	
	s patientName = obj.PatientName
	s medRecordNo = obj.MedRecordNo
	s admDate = obj.AdmDate
	s:((admDate '= "") && (admDate '= $c(0))) admDate = $zd(admDate,3)
	s disDate = obj.DisDate
	s:((disDate '= "") && (disDate '= $c(0))) disDate = $zd(disDate,3)
	s paramXML = obj.ParamXML
	s episodeID = obj.EpisodeID
	
	s admTaskStatus = obj.AdmTaskStatus
	s admTaskStatusDesc = ""
	if (admTaskStatus = "Q")
	{
		s admTaskStatusDesc = "待生成"	
	}
	elseif (admTaskStatus = "E")
	{
		s admTaskStatusDesc = "生成"	
	}
	elseif (admTaskStatus = "S")
	{
		s admTaskStatusDesc = "完成"	
	}
	
	s admTaskQueueID = obj.AdmTaskQueueID
	s admTaskQueueDate = obj.AdmTaskQueueDate
	s:((admTaskQueueDate '= "") && (admTaskQueueDate '= $c(0))) admTaskQueueDate = $zd(admTaskQueueDate,3)
	s admTaskQueueTime = obj.AdmTaskQueueTime
	s:((admTaskQueueTime '= "") && (admTaskQueueTime '= $c(0))) admTaskQueueTime = $zt(admTaskQueueTime,3)
	s admTaskQueueDateTime = admTaskQueueDate_" "_admTaskQueueTime
	
	s admTaskExecuteID = obj.AdmTaskExecuteID
	s admTaskExecuteDate = obj.AdmTaskExecuteDate
	s:((admTaskExecuteDate '= "") && (admTaskExecuteDate '= $c(0))) admTaskExecuteDate = $zd(admTaskExecuteDate,3)
	s admTaskExecuteTime = obj.AdmTaskExecuteTime
	s:((admTaskExecuteTime '= "") && (admTaskExecuteTime '= $c(0))) admTaskExecuteTime = $zt(admTaskExecuteTime,3)
	s admTaskExecuteDateTime = admTaskExecuteDate_" "_admTaskExecuteTime
	
	s admTaskSucceedID = obj.AdmTaskSucceedID
	s admTaskSucceedDate = obj.AdmTaskSucceedDate
	s:((admTaskSucceedDate '= "") && (admTaskSucceedDate '= $c(0))) admTaskSucceedDate = $zd(admTaskSucceedDate,3)
	s admTaskSucceedTime = obj.AdmTaskSucceedTime
	s:((admTaskSucceedTime '= "") && (admTaskSucceedTime '= $c(0))) admTaskSucceedTime = $zt(admTaskSucceedTime,3)
	s admTaskSucceedDateTime = admTaskSucceedDate_" "_admTaskSucceedTime
    
    s actDateTime = $zd(date,3)_" "_$zt(time,3)
    
    s ^CacheTemp(repid,ind) = $lb(medRecordNo,patientName,admDate,disDate,paramXML,actDateTime,episodeID,admTaskStatus,admTaskStatusDesc,admTaskQueueID,admTaskQueueDateTime,admTaskExecuteID,admTaskExecuteDateTime,admTaskSucceedID,admTaskSucceedDateTime)
	s ind = ind + 1
	
	q
}

ClassMethod GetImportListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetImportListExecute ]
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

ClassMethod GetImportListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetImportListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// debug w ##class(DHCEPRFS.BL.BLImportScan).Create("00859060","陈淑贤","","2011-05-18","<patientno>00859060</patientno><patname>陈淑贤</patname><indate></indate><outdate>2011-05-18</outdate>","13")
ClassMethod Create(AMedRecordNo As %String, APatientName As %String, AAdmDate As %String, ADisDate As %String, AParamXML As %String, AUserID As %String)
{
	q:(AMedRecordNo = "") "-1"
	s error = ""
	//从病案号获取就诊号，只取住院
	s episodeIDS = ##class(DHCEPRFS.BL.HISInfo.BLWMRInfo).IGetEpisodeIDsByMrNo(AMedRecordNo,"7")
	s InputAdmDate = ""
	s InputDisDate = ""
	s:((AAdmDate '= "") && (AAdmDate '= $c(0))) InputAdmDate = $zdh(AAdmDate,3)
	s:((ADisDate '= "") && (ADisDate '= $c(0))) InputDisDate = $zdh(ADisDate,3)
	for i=1:1:$l(episodeIDS,"^")
	{
		s oneEpisodeID = $p(episodeIDS,"^",i)	
		continue:(oneEpisodeID = "")
		//根据入院日期和出院日期判断是否是本次就诊
		s admDate = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmDate(oneEpisodeID)
		s disDate = $P(##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTime(oneEpisodeID),",",1)	

		//b "s"
		//continue:(admDate '= InputAdmDate)
		continue:(disDate '= InputDisDate)
			
		//加入队列和加入记录
		s ret =  ..Add2AdmTaskQueue(oneEpisodeID,AMedRecordNo,APatientName,AAdmDate,ADisDate,AParamXML,AUserID)	
		if (ret = "-1")
		{
			s error = AParamXML	
		}
		
		//病案号，入院出院日期确定，只有一个符合的就诊，因此已导入就诊，退出循环	
		q		
	}
	q error
}

ClassMethod Add2AdmTaskQueue(AEpisodeID As %String, AMedRecordNo As %String, APatientName As %String, AAdmDate As %String, ADisDate As %String, AParamXML As %String, AUserID As %String) As %String
{
	TSTART
	s $zt = "OnAdd2AdmTaskQueueErrorHandler"
	//加入生成队列
	s admTaskQueueID = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC",AEpisodeID,"50","IMPORTSCAN","S","","IMPORTSCAN",AParamXML)
	if (admTaskQueueID = "")
	{
		TROLLBACK
		q "-1"	
	}
	else
	{
		s objTaskQueue = ##class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(admTaskQueueID)
		//记录	
		s obj = ##class(DHCEPRFS.INST.ImportScan).%New()
		s obj.ActDate = $p($h,",",1)
		s obj.ActTime = $p($h,",",2)
		s obj.ActUserID = AUserID
		s obj.AdmDate = AAdmDate
		s obj.DisDate = ADisDate
		s obj.EpisodeID = AEpisodeID
		s obj.MedRecordNo = AMedRecordNo
		s obj.ParamXML = AParamXML
		s obj.PatientName = APatientName
		s obj.AdmTaskStatus = "Q"
		s obj.AdmTaskQueueID = admTaskQueueID
		s obj.AdmTaskQueueDate = objTaskQueue.CandidateDate
		s obj.AdmTaskQueueTime = objTaskQueue.CandidateTime
		s obj.AdmTaskExecuteID = ""
		s obj.AdmTaskExecuteDate = ""
		s obj.AdmTaskExecuteTime = ""
		s obj.AdmTaskSucceedID = ""
		s obj.AdmTaskSucceedDate = ""
		s obj.AdmTaskSucceedTime = ""
		s sc = obj.%Save()
		if ($$$ISOK(sc))
		{	
			TCOMMIT
			q obj.%Id()
	
		}
		else
		{
			TROLLBACK
			q "-1"
		}	
	}
	
OnAdd2AdmTaskQueueErrorHandler
	TROLLBACK
	q "-1"
}

/// Debug:  w ##class(DHCEPRFS.BL.BLImportScan).UpdateAdmTaskExec(AImportScanID,AExecID)
ClassMethod UpdateAdmTaskExec(AImportScanID As %String, AExecID As %String) As %String
{
	s objExec = ##class(DHCEPRFS.INST.AdmTaskExec).%OpenId(AExecID)
	
	s obj = ##class(DHCEPRFS.INST.ImportScan).%OpenId(AImportScanID)
	s obj.AdmTaskExecuteID = AExecID
	s obj.AdmTaskExecuteDate = objExec.TaskDate
	s obj.AdmTaskExecuteTime = objExec.TaskTime
	s obj.AdmTaskStatus = "E"
	s obj.ActDate = $p($h,",",1)
	s obj.ActTime = $p($h,",",2)
			
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{	
		q obj.%Id()
	
	}
	else
	{
		q "-1"
	}
}

/// Debug:  w ##class(DHCEPRFS.BL.BLImportScan).UpdateAdmTaskSucceed(AImportScanID,ASucceedID)
ClassMethod UpdateAdmTaskSucceed(AImportScanID As %String, ASucceedID As %String) As %String
{
	s objSucceed = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(ASucceedID)
	
	s obj = ##class(DHCEPRFS.INST.ImportScan).%OpenId(AImportScanID)
	s obj.AdmTaskSucceedID = ASucceedID
	s obj.AdmTaskSucceedDate = objSucceed.SucceedDate
	s obj.AdmTaskSucceedTime = objSucceed.SucceedTime
	s obj.AdmTaskStatus = "S"
	s obj.ActDate = $p($h,",",1)
	s obj.ActTime = $p($h,",",2)
			
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{	
		q obj.%Id()
	
	}
	else
	{
		q "-1"
	}
}

/// Debug:  w ##class(DHCEPRFS.BL.BLImportScan).UpdateAdmTaskSucceed(AImportScanID,ASucceedID)
ClassMethod UpdateAdmTaskQueue(AImportScanID As %String, AQueueID As %String) As %String
{
	s objQueue = ##class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(AQueueID)
	
	s obj = ##class(DHCEPRFS.INST.ImportScan).%OpenId(AImportScanID)
	s obj.AdmTaskQueueID = AQueueID
	s obj.AdmTaskQueueDate = objQueue.CandidateDate
	s obj.AdmTaskQueueTime = objQueue.CandidateTime
	s obj.AdmTaskStatus = "S"
	s obj.ActDate = $p($h,",",1)
	s obj.ActTime = $p($h,",",2)
			
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{	
		q obj.%Id()
	
	}
	else
	{
		q "-1"
	}
}

}
