Class DHCEPRFS.BL.BLMRLogView Extends %RegisteredObject
{

/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLogView).AddLog("1","1","127.0.0.1")
ClassMethod AddLog(AMREpisodeID As %String, AActUserID As %String, AClientIP) As %String
{
	s obj = ##Class(DHCEPRFS.INST.MRLogView).%New()
	s obj.MREpisodeID = AMREpisodeID
	s obj.ActUserID = AActUserID
	s obj.ClientIP = AClientIP
	s obj.ActDate = $p($h,",",1)
	s obj.ActTime = $p($h,",",2)
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLogView","GetViewLogByDate","2015-11-18","2015-11-18","刘杰")
Query GetViewLogByDate(AStartDate As %String, AEndDate As %String, AActUserName As %String) As %Query(ROWSPEC = "ActDateTime:%String,ActUser:%String,ClientIP:%String,MREpisodeID:%String,RecordNo:%String,RegNo:%String,PatName:%String,AdmDate:%String,AdmLoc:%String,AdmWard:%String,DisDate:%String,DisLoc:%String,DisWard:%String,MianDoc:%String")
{
}

ClassMethod GetViewLogByDateExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AActUserName As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s:(AActUserName = $c(0)) AActUserName = ""
 	s startDate = $zdh(AStartDate,3)
 	s endDate = $zdh(AEndDate,3)
 
 	if (AActUserName '= "")
	{
 		s type = ""
		for {
			s type = $o(^DHCEPRFS.META.QueryUserI("IdxTypeUserName",type))
			q:(type = "")
			s userID = ""
			for {
				s userID = $o(^DHCEPRFS.META.QueryUserI("IdxTypeUserName",type," "_AActUserName,userID))
				q:(userID = "")
			
				for date = startDate:1:endDate
 				{
	 				s time = ""
	 				for {
		 				s time = $O(^DHCEPRFS.INST.MRLogViewI("IdxOnUserID"," "_userID,date,time))
		 				q:(time="")
		 	
		 				s rowID = ""
						for {
							//b "s"
			 				s rowID = $O(^DHCEPRFS.INST.MRLogViewI("IdxOnUserID"," "_userID,date,time,rowID))
			 				q:(rowID="")
			 	
		 					s obj = ##Class(DHCEPRFS.INST.MRLogView).%OpenId(rowID)
		 					continue:(obj="")
		 					d OutputInfo(rowID)
						}
		 			}
	 			}
 			}
		}
	}
 	else
 	{
 		for date = startDate:1:endDate
 		{
	 		s time = ""
	 		for {
		 		s time = $O(^DHCEPRFS.INST.MRLogViewI("IdxOnDateTime",date,time))
		 		q:(time="")
		 	
		 		s rowID = ""
		 		for {
			 		s rowID = $O(^DHCEPRFS.INST.MRLogViewI("IdxOnDateTime",date,time,rowID))
			 		q:(rowID="")
			 	
		 			s obj = ##Class(DHCEPRFS.INST.MRLogView).%OpenId(rowID)
		 			continue:(obj="")
		 			d OutputInfo(rowID)
		 		}
	 		}
 		}
 	}
 	
 	quit $$$OK
 	
OutputInfo(logViewID)
	s objLog = ##Class(DHCEPRFS.INST.MRLogView).%OpenId(logViewID)
	q:(objLog="")
	
	s (ActDateTime,ActUser,ClientIP,MREpisodeID,RecordNo,RegNo,PatName,AdmDate,AdmLoc,AdmWard,DisDate,DisLoc,DisWard,MianDoc)=""
	
	s ActDate = $zd(objLog.ActDate,3)
	s ActTime = $zt(objLog.ActTime,1)
	s ActDateTime = ActDate_" "_ActTime
	s ActUser = objLog.ActUserID
	

	s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId(ActUser)
	s ActUser = objUser.UserName    

	
	s ClientIP = objLog.ClientIP
	s MREpisodeID = objLog.MREpisodeID
			
	s objMREpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(objLog.MREpisodeID)
	if (objMREpisode '= "")
	{
		s RecordNo = objMREpisode.MedRecordNo
		s AdmDate = objMREpisode.AdmDate
		s:(AdmDate'="") AdmDate = $zd(AdmDate,3)
		s AdmLoc = objMREpisode.AdmLoc
		s AdmWard = objMREpisode.AdmWard
		s DisDate = objMREpisode.DisDate
		s:(DisDate'="") DisDate = $zd(DisDate,3)
		s DisLoc = objMREpisode.DisLoc
		s DisWard = objMREpisode.DisWard
		s MainDoc = objMREpisode.MainDoctor
		
		s objPat = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(objMREpisode.MRPatientID)
		if (objPat '= "")
		{
			s RegNo = objPat.RegNo
			s PatName = objPat.Name
		}
	}
	
	s ^CacheTemp(repid,ind) = $lb(ActDateTime,ActUser,ClientIP,MREpisodeID,RecordNo,RegNo,PatName,AdmDate,AdmLoc,AdmWard,DisDate,DisLoc,DisWard,MainDoc)
	s ind = ind + 1
	q
}

ClassMethod GetViewLogByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetViewLogByDateExecute ]
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

ClassMethod GetViewLogByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetViewLogByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
