Class DHCEPRFS.BL.BLFileCheck Extends %RegisteredObject
{

/// 获取待执行队列列表
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLFileCheck","GetCheckMREpisodeList","2013-01-06","2015-01-06","Arrange^Sacn^Replace")
Query GetCheckMREpisodeList(AStartDate As %String, AEndDate As %String, ACheckAction As %String) As %Query(ROWSPEC = "MREpisodeID:%String,SysCode:%String,PatientID:%String,EpisodeID:%String,MedRecordNo:%String,RegNo:%String,Name:%String,Gender:%String,AdmDate:%String,DisDate:%String,AdmDept:%String,DisDept:%String")
{
}

ClassMethod GetCheckMREpisodeListExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ACheckAction As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

	if (ACheckAction = "") 
	{
		s ACheckAction = "Create^Arrange^Scan^Replace"
	}
	
	
	s arrayMRLogID = ##Class(%ArrayOfDataTypes).%New()
	
	s startDate = $zdh(AStartDate,5)
	s endDate = $zdh(AEndDate,5)
	s actionCount = $L(ACheckAction,"^")
	
	for curDate = startDate:1:endDate
	{
		for iaction = 1:1:actionCount
		{
			s curAction = $P(ACheckAction,"^",iaction)
			continue:(curAction = "")
			s curAction = $zcvt(curAction,"u")
			
			s time = ""
			for {
				s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_curAction,curDate,time))
				q:(time="")
				
				s mrLogID = ""
				for {
					s mrLogID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_curAction,curDate,time,mrLogID))
					q:(mrLogID="")
					
					s childSub = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_curAction,curDate,time,mrLogID,""))
					continue:(childSub="")
					
					d arrayMRLogID.SetAt(mrLogID,mrLogID)
				}
			}
		}
	}
	
	s key = ""
	for {
		s mrLogID = arrayMRLogID.GetNext(.key)
		q:(key="")
		
		s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
		s MREpisodeID = objMRLog.MREpisodeID
		s objMRLog = ""
		
		s objMREpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
		s SysCode = objMREpisode.SysCode
		s EpisodeID = objMREpisode.EpisodeID
		s MedRecordNo = objMREpisode.MedRecordNo
		s AdmDate = objMREpisode.AdmDate
		s DisDate = objMREpisode.DisDate
		s AdmDept = objMREpisode.AdmLoc
		s DisDept = objMREpisode.DisLoc
		s:(AdmDate'="") AdmDate = $zd(AdmDate,3) 
		s:(DisDate'="") DisDate = $zd(DisDate,3) 
		
		s mrPatientID = objMREpisode.MRPatientID
		s objMREpisode = ""
		
		s objMRPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
		s PatientID = objMRPatient.PatientID
		s RegNo = objMRPatient.RegNo
		s Name = objMRPatient.Name
		s Gender = objMRPatient.Gender
		s objMRPatient = ""
		
		s ^CacheTemp(repid,ind) = $lb(MREpisodeID,SysCode,PatientID,EpisodeID,MedRecordNo,RegNo,Name,Gender,AdmDate,DisDate,AdmDept,DisDept)
		s ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod GetCheckMREpisodeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCheckMREpisodeListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCheckMREpisodeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCheckMREpisodeListExecute ]
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

/// 获取待执行队列列表
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLFileCheck","GetCheckFileList","1")
Query GetCheckFileList(AMREpisodeID As %String) As %Query(ROWSPEC = "MRVerItemDetailID:%String,FullFileLocPath:%String")
{
}

ClassMethod GetCheckFileListExecute(ByRef qHandle As %Binary, AMREpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

	q:(AMREpisodeID="") $$$OK
	
	s version = ""
	for {
		s version = $O(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_AMREpisodeID,version))
		q:(version = "")
		
		s mrVersionID = $O(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_AMREpisodeID,version,""))
		continue:(mrVersionID = "")
		
		s mrItemID = ""
		for {
			s mrItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_mrVersionID,mrItemID))
			q:(mrItemID="")
			
			s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_mrVersionID,mrItemID,""))
			continue:(mrVerItemID = "")
			
			s detailNum = ""
			for {
				s detailNum = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID,detailNum))
				q:(detailNum="")
				
				s childSub = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID,detailNum,""))
				continue:(childSub="")
				
				s mrVerItemDetailID = mrVerItemID_"||"_childSub
				
				s objMRVerItemDetail = ##class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemDetailID)
				continue:(objMRVerItemDetail="")
				
				s fileMasterID = objMRVerItemDetail.FileMasterID
				s FullFileLocPath = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(fileMasterID)
				
				s ^CacheTemp(repid,ind) = $lb(mrVerItemDetailID,FullFileLocPath)
				s ind=ind+1
			}
		}
	}
	
	q $$$OK
}

ClassMethod GetCheckFileListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCheckFileListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCheckFileListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCheckFileListExecute ]
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

}
