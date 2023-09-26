Class EPRservice.Quality.BLRecordQCLog Extends %RegisteredObject
{

ClassMethod RegQCLog2(AParams As %String) As %String
{
	s ret = ..RegQCLog($p(AParams,"^",1),$p(AParams,"^",2),$p(AParams,"^",3),$p(AParams,"^",4))
	q ret
}

/// w ##Class(EPRservice.Quality.BLRecordQCLog).RegQCLog("17","RUNTIME","2")
ClassMethod RegQCLog(AEpisodeID As %String, AAction As %String, AActUserID As %String, AActStatus As %String = "") As %String
{
	s:(AActStatus '= "0") AActStatus = "1"
	
	s id = ..GetQCLogID(AEpisodeID, AAction)
	if (id = "")
	{
		s id = ..CreateQCLog(AEpisodeID, AAction, AActUserID, AActStatus)
	}
	else
	{
		do ..UpdateQCLog(id, AActUserID, AActStatus)
	}
	
	q id
}

/// w ##Class(EPRservice.Quality.BLRecordQCLog).GetQCLogID("17","RUNTIME")
ClassMethod GetQCLogID(AEpisodeID As %String, AAction As %String) As %String
{
	s id = $O(^DHCEPRQ.RecordQCLogI("IdxOnMain"," "_AEpisodeID, " "_AAction, ""))
	q id
}

ClassMethod GetLastQCLogID(AEpisodeID As %String) As %String
{
	s date = $O(^DHCEPRQ.RecordQCLogI("IdxOnActDateTime"," "_AEpisodeID, ""),-1)
	q:(date = "") ""
	
	s time = $O(^DHCEPRQ.RecordQCLogI("IdxOnActDateTime"," "_AEpisodeID, date, ""),-1)
	q:(time = "") ""
	
	s id = $O(^DHCEPRQ.RecordQCLogI("IdxOnActDateTime"," "_AEpisodeID, date, time, ""),-1)
	q id
}

ClassMethod CreateQCLog(AEpisodeID As %String, AAction As %String, AActUserID As %String, AActStatus As %String) As %String
{
	s obj = ##Class(EPRinstance.Quality.RecordQCLog).%New()
	s obj.EpisodeID = AEpisodeID
	s obj.ActionCode = AAction
	s obj.ActUserID = AActUserID
	s obj.ActDate = $p($h,",",1)
	s obj.ActTime = $p($h,",",2)
	s obj.ActStatus = AActStatus
	
	s sc =  obj.%Save()
	
	s objDetail = ##Class(EPRinstance.Quality.RecordQCLogDetail).%New()
	s objDetail.EpisodeID = obj.EpisodeID
	s objDetail.ActionCode = obj.ActionCode
	s objDetail.ActUserID = obj.ActUserID
	s objDetail.ActDate = obj.ActDate
	s objDetail.ActTime = obj.ActTime
	s objDetail.ActStatus = obj.ActStatus
	s objDetail.TheRecordQCLog = obj
	
	s sc =  obj.%Save()
	
	if ($$$ISOK(sc))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

ClassMethod UpdateQCLog(AQCLogID As %String, AActUserID As %String, AActStatus As %String) As %Boolean
{
	s obj = ##Class(EPRinstance.Quality.RecordQCLog).%OpenId(AQCLogID)
	s obj.ActUserID = AActUserID
	s obj.ActDate = $p($h,",",1)
	s obj.ActTime = $p($h,",",2)
	s obj.ActStatus = AActStatus
	
	s objDetail = ##Class(EPRinstance.Quality.RecordQCLogDetail).%New()
	s objDetail.EpisodeID = obj.EpisodeID
	s objDetail.ActionCode = obj.ActionCode
	s objDetail.ActUserID = obj.ActUserID
	s objDetail.ActDate = obj.ActDate
	s objDetail.ActTime = obj.ActTime
	s objDetail.ActStatus = obj.ActStatus
	
	s objDetail.TheRecordQCLog = obj
	
	s sc =  obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

ClassMethod GetQCLogInfo(AEpisodeID As %String, AQCAction As %String) As %List
{
	if (AQCAction = "")
	{
		s id = ..GetLastQCLogID(AEpisodeID)
	}
	else
	{
		s id = ..GetQCLogID(AEpisodeID,AQCAction)
	}
	q:(id = "") ""
	
	s obj = ##Class(EPRinstance.Quality.RecordQCLog).%OpenId(id)
	q:(obj = "") ""
	
	q $lb(obj.ActDate, obj.ActTime, obj.ActUserID, obj.ActStatus, obj.ActionCode)
}

/// w ##Class(EPRservice.Quality.BLRecordQCLog).GetQCLogDateTime("17","RUNTIME")
ClassMethod GetQCLogDateTime(AEpisodeID As %String, AQCAction) As %String
{
	if (AQCAction = "")
	{
		s id = ..GetLastQCLogID(AEpisodeID)
	}
	else
	{
		s id = ..GetQCLogID(AEpisodeID,AQCAction)
	}
	q:(id = "") ""
	
	s obj = ##Class(EPRinstance.Quality.RecordQCLog).%OpenId(id)
	q:(obj = "") ""
	
	q obj.ActDate_","_obj.ActTime
}

/// w ##Class(EPRservice.Quality.BLRecordQCLog).IsRecordModified("17","RUNTIME")
ClassMethod IsRecordModified(AEpisodeID As %String, AQCAction) As %String
{
	//没有质控操作信息，所有病历都是未质控过的
	s qcDateTime = ..GetQCLogDateTime(AEpisodeID,AQCAction)
	q:(qcDateTime = "") "1"
	
	s hasModified = ##Class(EPRservice.Quality.BLRecordModifyLog).HasModifyRecord(AEpisodeID,$p(qcDateTime,",",1),$p(qcDateTime,",",2))
	q hasModified
}

/// w ##Class(EPRservice.Quality.BLRecordQCLog).GetModifyCount("17","RUNTIME")
ClassMethod GetModifyCount(AEpisodeID As %String, AQCAction As %String) As %String
{
	//没有质控操作信息，所有病历都是未质控过的
	s qcDateTime = ..GetQCLogDateTime(AEpisodeID,AQCAction)
	
	s list = ##Class(EPRservice.Quality.BLRecordModifyLog).GetModifyList(AEpisodeID,$p(qcDateTime,",",1),$p(qcDateTime,",",2))
	q list.Count()
}

/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BLRecordQCLog","GetModifyList","15","RUNTIME")
Query GetModifyList(AEpisodeID As %String, AQCAction As %String) As %Query(ROWSPEC = "PrintDocID,EPRNum,RecordName,RecordTitle,HappenDate,HappenTime,ModifyDate,ModifyTime,ModifyUser")
{
}

ClassMethod GetModifyListExecute(ByRef qHandle As %Binary, AEpisodeID As %String, AQCAction As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s qcDateTime = ..GetQCLogDateTime(AEpisodeID,AQCAction)
	
	s list = ##Class(EPRservice.Quality.BLRecordModifyLog).GetModifyList(AEpisodeID,$p(qcDateTime,",",1),$p(qcDateTime,",",2))
	q:(list.Count() = 0) $$$OK
	
	s count = list.Count()
	for i = 1:1:count
	{
		//b "s"
		s id = list.GetAt(i)
		continue:(id="")
		
		s obj = ##Class(EPRinstance.Quality.RecordModifyLog).%OpenId(id)
		continue:(obj="")
		
		s PrintDocID = obj.EPRDocID
		s EPRNum = obj.EPRNum
		s recordInfo = ..GetRecordInfo(AEpisodeID, PrintDocID, EPRNum)
		s RecordName = $listget(recordInfo, 1)
		s RecordTitle = $listget(recordInfo, 2)
		s HappenDate = $listget(recordInfo, 3)
		s HappenTime = $listget(recordInfo, 4)
		s ModifyDate = $zd(obj.ActDate,3)
		s ModifyTime = $zt(obj.ActTime,1)
		s:(obj.ActUserID '= "") ModifyUser = $p($g(^SSU("SSUSR",obj.ActUserID)),"^",2) 
	
		s ^CacheTemp(repid,ind) = $LB(PrintDocID,EPRNum,RecordName,RecordTitle,HappenDate,HappenTime,ModifyDate,ModifyTime,ModifyUser)
		s ind = ind + 1
	}
	
	Quit $$$OK
}

ClassMethod GetModifyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetModifyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetModifyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetModifyListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetRecordInfo(AEpisodeID, APrintDocID, AEPRNum) As %List
{
	s (RecordName,RecordTitle,HappenDate,HappenTime) = ""
	
	s eprLogsID = $O(^DHCEPRI.EPRLogsI("IdxMain"," "_AEpisodeID," "_APrintDocID, AEPRNum, ""))
	q:(eprLogsID = "") ""
	
	s logs = ##Class(EPRinstance.EPRLogs).%OpenId(eprLogsID)
	q:(logs = "") ""
	
	
	s objEPRTplCate = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(APrintDocID)
	q:(objEPRTplCate="") $LB(RecordName,RecordTitle,HappenDate,HappenTime)
	
	s objParentCate = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(objEPRTplCate.ParentCategoryID)
	if (objParentCate '= "")
	{	s RecordName = objParentCate.CategoryName}
		
	s printTplID = objEPRTplCate.BindPrnTemplateID
	q:(printTplID = "")||(printTplID = $c(0)) $LB(RecordName,RecordTitle,HappenDate,HappenTime)
	
	s objPrintTemplate = ##Class(EPRmeta.PrintTemplate).%OpenId(printTplID)
	q:(objPrintTemplate = "") $LB(RecordName,RecordTitle,HappenDate,HappenTime)
	
	s chartType = objPrintTemplate.ChartItemType
	if (chartType '= "Single")
	{
		s HappenDate = $zd(logs.HappenDate,3)
		s HappenTime = $zt(logs.HappenTime,1)
	
		s ecRecordID = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID", " "_AEpisodeID, " ML"_APrintDocID, ""))
		q:(ecRecordID = "") $LB(RecordName,RecordTitle,HappenDate,HappenTime) 
		
		s childSub = $o(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo", ecRecordID, " "_AEPRNum, ""))
		q:(childSub = "") $LB(RecordName,RecordTitle,HappenDate,HappenTime)
		
		s instanceDataID = ecRecordID_"||"_childSub
		s objEPRInstance = ##Class(EPRinstance.InstanceData).%OpenId(instanceDataID)
		q:(objEPRInstance = "") $LB(RecordName,RecordTitle,HappenDate,HappenTime)
		
		s RecordTitle = objEPRInstance.Title
	}
	
	q $LB(RecordName,RecordTitle,HappenDate,HappenTime)
}

}
