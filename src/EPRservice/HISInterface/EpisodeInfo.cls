Class EPRservice.HISInterface.EpisodeInfo Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：      Candy
/// CreateDate：   2011-05-25
/// Description:： 根据APatientID,就诊开始日期AStartDate，就诊结束日期EEpisodeDate 查询患者的就诊信息
/// Table： PA_ADM
/// Input： 病人APatientID，就诊开始日期AStartDate，就诊结束日期AEndDate
/// Output：EpisodeDate:就诊日期,EpisodeDepCodeDR就诊科室,EpisodeDocCodeDR:就诊医生,EpisodeType:就诊类型,
///         EpisodeReason:病人类型,DischargeDate:出院日期,Diagnosis:诊断,EpisodeID:就诊号
/// Return：
/// Others：do ##class(%ResultSet).RunQuery("EPRservice.HISInterface.EpisodeInfo","GetEpisodeListByPID","126053")   ,"2008-10-10","2009-10-10") 
/// , AStartDate As %String, AEndDate As %String
Query GetEpisodeListByPID(APatientID As %String) As %Query(ROWSPEC = "EpisodeID:%String,EpisodeDate:%String,DeptDesc:%String,MainDocName:%String,EpisodeType:%String,EpisodeReason:%String,DischargeDate:%String,Diagnosis:%String")
{
}

ClassMethod GetEpisodeListByPIDExecute(ByRef qHandle As %Binary, APatientID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	q:(APatientID="") $$$OK
 	;set startDate = $ZDateH(AStartDate,3)
    ;set endDate = $ZDateH(AEndDate,3)
	
	set typeRowID = "0" 
	for {
	 	set typeRowID = $o(^PAPERdr(APatientID,"ADM",typeRowID))
	 	q:(typeRowID = "")
	 	
	 	set episodeID = "0"
	 	for {
		 	s episodeID = $o(^PAPERdr(APatientID,"ADM",typeRowID,episodeID))
		 	q:(episodeID = "")
		 	
		 	set episodeDate = $p($g(^PAADM(episodeID)),"^",6)
		 	;continue:(episodeDate < startDate)||(episodeDate > endDate)
		 	
		 	set episodeDate = $ZD(episodeDate,3)
			   
			;set dept = ##Class(EPRservice.HISInterface.PatientInfoAssist).AdmDept(episodeID)
			;set deptDesc = $P(dept, "^", 3)
			set deptId=$p(^PAADM(episodeID),"^",4)
			if (deptId'="") set deptDesc=$p(^CTLOC(deptId),"^",1) else  set deptDesc=""
			
			set mainDoc = ##Class(EPRservice.HISInterface.PatientInfoAssist).MainDoc(episodeID)
			set mainDocName = $P(mainDoc, "^", 3) 
			   
			set episodeType= $p(^PAADM(episodeID),"^",2)
			if episodeType="I" Set episodeType="住院"
	        if episodeType="O" Set episodeType="门诊"
	        if episodeType="E" Set episodeType="急诊"
			
	        set episodeReason = ##Class(EPRservice.HISInterface.PatientInfoAssist).PayType(episodeID)
	               
	        set dischargeDate = ##Class(EPRservice.HISInterface.PatientInfoAssist).DisDateTime(episodeID)
		    set dischargeDate = $P(dischargeDate, ",", 1)
		    if (dischargeDate '= "") set dischargeDate = $ZD(dischargeDate,3)
		       
	           
	        set diagnosis= ##Class(EPRservice.HISInterface.PatientInfoAssist).DiagnosInfo(episodeID)
	        set diagnosis = $P(diagnosis, "^", 3)
	           
			set data= $lb(episodeID,episodeDate,deptDesc,mainDocName,episodeType,episodeReason,dischargeDate,diagnosis)
		 	set ^CacheTemp(repid,ind)=data
		 	set ind=ind+1  	
	 	}
	}
	
 	Quit $$$OK
}

ClassMethod GetEpisodeListByPIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEpisodeListByPIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetEpisodeListByPIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEpisodeListByPIDExecute ]
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
