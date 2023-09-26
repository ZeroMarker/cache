Class DHCEPRFS.ThirdParty.BL.BLGetEpisodeInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.ThirdParty.BL.BLGetEpisodeInfo","GetEpisodeByMedRecord","500306")
Query GetEpisodeByMedRecord(AMedRecordNo As %String, AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "EpisodeID:%String,MedRecordNo:%String,Name:%String,Gender:%String,DisDate:%String,DisLoc:%String")
{
}

ClassMethod GetEpisodeByMedRecordExecute(ByRef qHandle As %Binary, AMedRecordNo As %String, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s:(AMedRecordNo = $c(0)) AMedRecordNo = ""

	if (AMedRecordNo '= "")
	{
		s AMedRecordNo =  $zcvt(AMedRecordNo,"U")
		s mrPatientID = ""
		for {
			s mrPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxMedRecordNo", " "_AMedRecordNo, mrPatientID))
			q:(mrPatientID = "")
			d GetPatientInfo
			
			s mrEpisodeID = ""
	        for {
	            s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_mrPatientID,mrEpisodeID))
	            q:(mrEpisodeID = "")
	        	d GetEpisodeInfo
	        	d OutputRow
	        }
		}	
	}
	else
	{
		q:(AStartDate = "") $$$OK
		q:(AEndDate = "") $$$OK
		s startDate = $zdh(AStartDate,3)
		s endDate = $zdh(AEndDate,3)
		s date = startDate - 1
 		for {
			s date =  $o(^DHCEPRFS.INST.MREpisodeI("IdxDisDate", date))
			q:(date = "")
			q:(date>endDate)
			s mrPatientIDBlank = ""

			for {
				s mrPatientIDBlank =  $o(^DHCEPRFS.INST.MREpisodeI("IdxDisDate", date, mrPatientIDBlank))
				q:(mrPatientIDBlank = "")
				s mrPatientID = $tr(mrPatientIDBlank," ","")
				d GetPatientInfo
				
				s mrEpisodeID = ""
	       		for {
	            	s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxDisDate", date, mrPatientIDBlank, mrEpisodeID))
	            	q:(mrEpisodeID = "")
	        		d GetEpisodeInfo
	        		d OutputRow
	        	}
			}
		}
	}
	Quit $$$OK
GetPatientInfo
	s objMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
	s MedRecordNo = objMRPatient.MedRecordNo
	s Name = objMRPatient.Name
	s Gender = objMRPatient.Gender
	q
	
GetEpisodeInfo
	s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
	s EpisodeID = objMREpisode.EpisodeID
	s DisDate = objMREpisode.DisDate
	s:(DisDate '= "") DisDate = $zd(DisDate,3)
	s DisLoc = objMREpisode.DisLoc
	q
	
OutputRow
 	s data = $lb(EpisodeID,MedRecordNo,Name,Gender,DisDate,DisLoc)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
}

ClassMethod GetEpisodeByMedRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEpisodeByMedRecordExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetEpisodeByMedRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEpisodeByMedRecordExecute ]
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
