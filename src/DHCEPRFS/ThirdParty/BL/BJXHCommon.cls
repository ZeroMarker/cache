Class DHCEPRFS.ThirdParty.BL.BJXHCommon Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 获取有问题的第三方生成
/// Debug: w ##class(%ResultSet).RunQuery("DHCEPRFS.ThirdParty.BL.BJXHCommon","GetScanLog","2015-1-1","2016-12-31")
Query GetScanLog(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "MedRecordNo:%String,AdmDate:%String,AdmTime:%String,ActPage:%String,ActDate:%String,ActTime:%String")
{
}

ClassMethod GetScanLogExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	k ^CacheTemp(repid,"DHCEPRFS","ThirdParty","BJXHCommon","GetScanLog")
 	
 	q:(AStartDate="") $$$OK
 	q:(AEndDate="") $$$OK
 	s AStartDate = $zdh(AStartDate,3)
 	s AEndDate = $zdh(AEndDate,3)
 	
 	for date = AStartDate:1:AEndDate
 	{
	 	s time = ""
	 	for {
	 		s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," SCAN",date,time))
	 		q:(time ="")
	 	
	 		s mrLogID = ""
	 		for {
		 		s mrLogID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," SCAN",date,time,mrLogID))
	 			q:(mrLogID ="")
	 			
	 			s actDate = ""
	 			s actTime =""
	 			s subID = ""
	 			for {
		 			s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," SCAN",date,time,mrLogID,subID))
		 			q:(subID="")
		 			
		 			s mrLogDetailID = mrLogID_"||"_subID

	 				s objDetailLogFinal = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogDetailID)
	 				continue:(objDetailLogFinal="")
	 			
	 				s mrEpisodeID = objDetailLogFinal.MREpisodeID
	 				
	 				s actDateTemp = objDetailLogFinal.ActDate
	 				if (actDateTemp > actDate)
	 				{	 				
		 				s actDate = actDateTemp
		 				s actTime = objDetailLogFinal.ActTime
	 				}
	 				elseif (actDateTemp = actDate)
	 				{
		 				if (actTime < objDetailLogFinal.ActTime)
		 				{
			 				s actTime = objDetailLogFinal.ActTime
		 				}
	 				}
	 				
	 				 				 			
	 				s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
    				q:(objEpisode = "")
    				s AdmDate = objEpisode.AdmDate
    				if (AdmDate '= "")
    				{
    			 		s AdmDate = $zd(AdmDate,3)
    				}
    				s AdmTime = objEpisode.AdmTime
    				if (AdmTime '= "")
    				{
    			 		s AdmTime = $zt(AdmTime,1)
    				}
    				s MedRecordNo = objEpisode.MedRecordNo
    				if (MedRecordNo = "")
    				{
	    				s MrPatientID = objEpisode.MRPatientID
    					s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MrPatientID)
    					s MedRecordNo = objPatient.MedRecordNo
    				}
	 				if ('$d(^CacheTemp(repid,"DHCEPRFS","ThirdParty","BJXHCommon","GetScanLog",MedRecordNo,mrEpisodeID)))
	 				{
		 				s ^CacheTemp(repid,"DHCEPRFS","ThirdParty","BJXHCommon","GetScanLog",MedRecordNo,mrEpisodeID)=MedRecordNo_"|"_AdmDate_"|"_AdmTime_"|"_mrEpisodeID_"|"_actDate_"|"_actTime
	 				}
	 			}
	 		}
	 	}
 	}
 	
 	s rowMedRecordID = ""
 	for
 	{
	 	s rowMedRecordID = 	$o(^CacheTemp(repid,"DHCEPRFS","ThirdParty","BJXHCommon","GetScanLog",rowMedRecordID))
	 	q:(rowMedRecordID = "")
	 	s ActPageTotal = ""
	 	s rowEpisodeID = ""
	 	for {
		 	s rowEpisodeID = $o(^CacheTemp(repid,"DHCEPRFS","ThirdParty","BJXHCommon","GetScanLog",rowMedRecordID,rowEpisodeID))
		 	q:(rowEpisodeID="")
		 	
		 	s MREpisodeID = $p(^CacheTemp(repid,"DHCEPRFS","ThirdParty","BJXHCommon","GetScanLog",rowMedRecordID,rowEpisodeID),"|",4)
		 	continue:(MREpisodeID = "")
		 	s rowIDMREpisode = ""
		 	for {
			 	s rowIDMREpisode = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMREpisodeID"," "_MREpisodeID," SCAN",rowIDMREpisode))
			 	q:(rowIDMREpisode ="")
			 	s rowIDMREpisodeSub = ""
			 	for {
				 	s rowIDMREpisodeSub = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMREpisodeID"," "_MREpisodeID," SCAN",rowIDMREpisode,rowIDMREpisodeSub))
				 	q:(rowIDMREpisodeSub ="")
			 		s objMREpisode = ##class(DHCEPRFS.INST.MRLogDetail).%OpenId(rowIDMREpisode_"||"_rowIDMREpisodeSub)
			 		s actPage = objMREpisode.ActPages
			 		if (ActPageTotal = "")
			 		{
				 		s ActPageTotal = actPage
			 		}
			 		else
			 		{
				 		s ActPageTotal = ActPageTotal+actPage
			 		}
			 	}
		 	}
			s AdmDate = $p(^CacheTemp(repid,"DHCEPRFS","ThirdParty","BJXHCommon","GetScanLog",rowMedRecordID,rowEpisodeID),"|",2)
			s AdmTime = $p(^CacheTemp(repid,"DHCEPRFS","ThirdParty","BJXHCommon","GetScanLog",rowMedRecordID,rowEpisodeID),"|",3)
			s ActDate = $p(^CacheTemp(repid,"DHCEPRFS","ThirdParty","BJXHCommon","GetScanLog",rowMedRecordID,rowEpisodeID),"|",5)
			s ActTime = $p(^CacheTemp(repid,"DHCEPRFS","ThirdParty","BJXHCommon","GetScanLog",rowMedRecordID,rowEpisodeID),"|",6)
			if (ActDate '= "")
    		{
    			 s ActDate = $zd(ActDate,3)
    		}
	 		if (ActTime '= "")
    		{
    			 s ActTime = $zt(ActTime,1)
    		}
			s ^CacheTemp(repid,ind) = $lb(rowMedRecordID,AdmDate,AdmTime,ActPageTotal,ActDate,ActTime)
			s ind = ind + 1
	 	}
 	}
 	
 	k ^CacheTemp(repid,"DHCEPRFS","ThirdParty","BJXHCommon","GetScanLog")
 	q $$$OK
}

ClassMethod GetScanLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScanLogExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetScanLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScanLogExecute ]
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

ClassMethod AddCreateLIS(AEpisodeID As %String) As %String [ WebMethod ]
{
	q:(AEpisodeID = "") "0"
	s sysCode = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("SysCode")
	s priority = "50"
	s admTaskQueueID = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create(sysCode, AEpisodeID, priority,"CreateLIS")
	if (admTaskQueueID = "")
	{
		q "0"
	}
	else
	{
		q "1"
	}
}

}
