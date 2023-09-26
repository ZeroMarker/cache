Class DHCEPRFS.BL.BLWorkFlow Extends %RegisteredObject [ ProcedureBlock ]
{

/// Debug:	w ##Class(DHCEPRFS.BL.BLWorkFlow).GetPatInfo("1")	
ClassMethod GetPatInfo(AMREpisodeID As %String) As DHCEPRFS.Entity.EWorkFlowPatInfo
{
	s entity = ##class(DHCEPRFS.Entity.EWorkFlowPatInfo).%New()
	
	s objMREpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	q:(objMREpisode="") entity 
	
	s entity.MREpisodeID = AMREpisodeID
	s entity.MedRecordNo = objMREpisode.MedRecordNo
	s entity.EpisodeID = objMREpisode.EpisodeID
	s entity.AdmDate = objMREpisode.AdmDate
	s:(entity.AdmDate '= "") entity.AdmDate = $zd(entity.AdmDate,3)
	s entity.AdmLoc = objMREpisode.AdmLoc
	s entity.AdmWard = objMREpisode.AdmWard
	s entity.DisDate = objMREpisode.DisDate
	s:(entity.DisDate '= "") entity.DisDate = $zd(entity.DisDate,3)
	s entity.DisLoc = objMREpisode.DisLoc
	s entity.DisWard = objMREpisode.DisWard
	
	s objMRPat = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(objMREpisode.MRPatientID)
	if (objMRPat '= "")
	{
		s entity.MRPatientID = objMREpisode.MRPatientID
		s entity.PatientID = objMRPat.PatientID
		s entity.Name = objMRPat.Name
		s entity.RegNo = objMRPat.RegNo
	}
	
	s logID = ##Class(DHCEPRFS.BL.BLMRLog).GetMRLogID(AMREpisodeID)
	s objLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(logID)
	if (objLog '= "")
	{
		s entity.MRStatus = ##Class(DHCEPRFS.BL.BLMRStatus).GetDesc(objLog.MRStatus)
		s entity.PageStatus = ##Class(DHCEPRFS.BL.BLMRStatus).GetDesc(objLog.PageStatus)
	}

	q entity
}

/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLWorkFlow","GetOpeationList","1")
Query GetOpeationList(AMREpisodeID As %String) As %Query(ROWSPEC = "ActionCode:%String,ActionDesc:%String")
{
}

ClassMethod GetOpeationListExecute(ByRef qHandle As %Binary, AMREpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
	s orderNo = ""
	for {
		s orderNo = $O(^DHCEPRFS.META.MRActionI("IdxActiveAction","1",orderNo))
		q:(orderNo="")
		
		s id = ""
		for {
			s id =  $O(^DHCEPRFS.META.MRActionI("IdxActiveAction","1",orderNo,id))
			q:(id="")
			
			s obj = ##Class(DHCEPRFS.META.MRAction).%OpenId(id)
			
			s actionCode = obj.ActionCode
			s actionDesc = obj.ActionName
			
			s ^CacheTemp(repid,ind) = $lb(actionCode,actionDesc)
			s ind = ind + 1
		}
	}
 	
	quit $$$OK
}

ClassMethod GetOpeationListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpeationListExecute ]
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

ClassMethod GetOpeationListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpeationListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Debug:	w ##Class(DHCEPRFS.BL.BLWorkFlow).DoOperation("1","1","0","","2011")	
ClassMethod DoOperation(AMREpisodeID As %String, ACanelFinalAccount As %String, ACanelMRCompletion As %String, ARemark As %String, AUserID As %String) As %String
{
	s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	q:(objMREpisode="") "0"
	
	s episodeID = objMREpisode.EpisodeID
	q:(episodeID="")||(episodeID=$c(0)) "0"
	
	s sc = ##class(DHCEPRFS.BL.BLAdmMRStatus).CancelMRStatusFlagDHC(episodeID, ACanelFinalAccount, ACanelMRCompletion, ARemark, AUserID)
	q sc
}

}
