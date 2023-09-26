Class DHCEPRFS.web.eprajax.AjaxEpisodeViewYZ Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("Action",1),"")
	s regNo = $Get(%request.Data("RegNo",1),"")
	s idCard = $Get(%request.Data("IDCard",1),"")
	s startDate = $Get(%request.Data("StartDate",1),"")
	s endDate = $Get(%request.Data("EndDate",1),"")
	s admTypeID = $Get(%request.Data("AdmTypeID",1),"")
	s locID = $Get(%request.Data("LocID",1),"")
	
	if (action = "episodelist")
	{
		d ..GetEPREpisodeListJSON(startDate,endDate,admTypeID,locID,regNo,idCard)
	}
	Quit $$$OK
}

ClassMethod TrimEnter(AInput As %String) As %String
{
	s ret = $TR(AInput,$C(13),"")
	s ret = $TR(ret,$C(10),"")
	q ret
}

/// Debug:w ##class(%ResultSet).RunQuery("DHCEPRFS.web.eprajax.AjaxEpisodeViewYZ","GetPatientList","0000000029","")
Query GetPatientList(ARegNo As %String, AIDCard As %String) As %Query(ROWSPEC = "AdmDate:%String,AdmTime:%String,AdmType:%String,AdmTypeID:%String,AdmLoc:%String,AdmLocID:%String,EpisodeID:%String,Name:%String,Gender:%String,Birthday:%String,Age:%String,DisDate:%String,DisTime:%String,AdmWard:%String,DisLoc:%String,DisWard:%String,MainDoctor:%String,InHospitlDoc:%String,RegNo:%String,IDCard:%String")
{
}

ClassMethod GetPatientListExecute(ByRef qHandle As %Binary, ARegNo As %String, AIDCard As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s:(ARegNo =$c(0)) ARegNo =""
 	s:(AIDCard = $c(0)) AIDCard =""
 	s ^CacheTemp("dhceprfs","web","ajaxepisodeviewyz","GetPatientList")=ARegNo
 	if (ARegNo '="")
 	{
	 	s mrPatientID = ""
	 	for {
	 		s mrPatientID =$o(^DHCEPRFS.INST.MRPatientI("IdxRegNo"," "_ARegNo,mrPatientID))
	 		q:(mrPatientID ="")
	 		s objMRPaitent = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
	 		s Name = objMRPaitent.Name
	 		s Gender = objMRPaitent.Gender
	 		s Birthday = objMRPaitent.Birthday
	 		s:(Birthday '="") Birthday =$zd(Birthday,3)
	 		s Age = objMRPaitent.Age
	 		s RegNo=ARegNo
	 		s IDCard = AIDCard
	 		s:(IDCard ="") IDCard = objMRPaitent.IDCard
	 		s mrEpisodeID =""
	 		for {
		 		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_mrPatientID,mrEpisodeID))
		 		q:(mrEpisodeID ="")
		 		s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
		 		s AdmDate = obj.AdmDate
		 		s:(AdmDate '="") AdmDate =$zd(AdmDate,3)
		 		s AdmTime = obj.AdmTime
		 		s:(AdmTime '="") AdmTime =$zt(AdmTime,1)
		 		s AdmType = obj.AdmType
		 		s AdmTypeID = obj.AdmTypeID
		 		s AdmLoc = obj.AdmLoc
		 		s AdmLocID = obj.AdmLocID
		 		s EpisodeID = obj.EpisodeID
		 		s DisDate = obj.DisDate
		 		s:(DisDate '="") DisDate =$zd(DisDate,3)
		 		s DisTime = obj.DisTime
		 		s:(DisTime '="") DisTime =$zt(DisTime,1)
		 		s AdmWard = obj.AdmWard
		 		s DisLoc = obj.DisLoc
		 		s DisWard = obj.DisWard
		 		s MainDoctor = obj.MainDoctor
		 		s InHospitlDoc = obj.InHospitlDoc
		 		
		 		s data = $lb(AdmDate,AdmTime,AdmType,AdmTypeID,AdmLoc,AdmLocID,EpisodeID,Name,Gender,Birthday,Age,DisDate,DisTime,AdmWard,DisLoc,DisWard,MainDoctor,InHospitlDoc,RegNo,IDCard)
				s ^CacheTemp(repid,ind)=data
				s ind=ind+1
	 		}
	 	}	
 	}
 	elseif (AIDCard '="")&&(ARegNo = "")
 	{
	 	s mrPatientID = ""
	 	for {
	 		s mrPatientID =$o(^DHCEPRFS.INST.MRPatientI("IdxIDCard"," "_AIDCard,mrPatientID))
	 		q:(mrPatientID ="")
	 		s objMRPaitent = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
	 		s Name = objMRPaitent.Name
	 		s Gender = objMRPaitent.Gender
	 		s Birthday = objMRPaitent.Birthday
	 		s:(Birthday '="") Birthday =$zd(Birthday,3)
	 		s Age = objMRPaitent.Age
	 		s RegNo=ARegNo
	 		s:(RegNo ="") RegNo =objMRPaitent.RegNo
	 		s IDCard = AIDCard
	 		s mrEpisodeID =""
	 		for {
		 		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_mrPatientID,mrEpisodeID))
		 		q:(mrEpisodeID ="")
		 		s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
		 		s AdmDate = obj.AdmDate
		 		s:(AdmDate '="") AdmDate =$zd(AdmDate,3)
		 		s AdmTime = obj.AdmTime
		 		s:(AdmTime '="") AdmTime =$zt(AdmTime,1)
		 		s AdmType = obj.AdmType
		 		s AdmTypeID = obj.AdmTypeID
		 		s AdmLoc = obj.AdmLoc
		 		s AdmLocID = obj.AdmLocID
		 		s EpisodeID = obj.EpisodeID
		 		s DisDate = obj.DisDate
		 		s:(DisDate '="") DisDate =$zd(DisDate,3)
		 		s DisTime = obj.DisTime
		 		s:(DisTime '="") DisTime =$zt(DisTime,1)
		 		s AdmWard = obj.AdmWard
		 		s DisLoc = obj.DisLoc
		 		s DisWard = obj.DisWard
		 		s MainDoctor = obj.MainDoctor
		 		s InHospitlDoc = obj.InHospitlDoc
		 		
		 		s data = $lb(AdmDate,AdmTime,AdmType,AdmTypeID,AdmLoc,AdmLocID,EpisodeID,Name,Gender,Birthday,Age,DisDate,DisTime,AdmWard,DisLoc,DisWard,MainDoctor,InHospitlDoc,RegNo,IDCard)
				s ^CacheTemp(repid,ind)=data
				s ind=ind+1
	 		}
	 	}
 	}
	

	Quit $$$OK
}

ClassMethod GetPatientListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientListExecute ]
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

/// debug: w ##class(DHCEPRFS.web.eprajax.AjaxEpisodeViewYZ).GetEPREpisodeListJSON("63210","63211","","","0000000029","")
ClassMethod GetEPREpisodeListJSON(AStartDate As %String, AEndDate As %String, AAdmTypeID As %String, ALocID As %String, ARegNo As %String, AIDCard As %String) As %String
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.web.eprajax.AjaxEpisodeViewYZ:GetPatientList")
	s sc = result.Execute(ARegNo,AIDCard)
	
	s:(AStartDate '="") AStartDate=$zdh(AStartDate,3)
	s:(AEndDate '="") AEndDate=$zdh(AEndDate,3)
 	s count = 0
 	s first = 1
 	w "{""rows"":["
 	
	While (result.Next())
 	{
	 	if (AAdmTypeID '="")
	 	{
		 	continue:($g(result.Data("AdmTypeID")) '= AAdmTypeID )
	 	}
	 	if (ALocID '= "")
	 	{
		 	s flag = "0"
		 	for i=1:1:$l(ALocID,",")
		 	{
			 	s oneLocID = $p(ALocID,",",i)
			 	if ($g(result.Data("AdmLocID")) = oneLocID)
			 	{
				 	s flag ="1"
			 	}
		 	}
		 	continue:(flag ="0")
	 	}
	 	if (AStartDate'="")&&(AEndDate '="")
	 	{
		 	s admDate =$g(result.Data("AdmDate"))
		 	s:(admDate '="") admDate =$zdh(admDate,3)
		 	continue:(admDate <AStartDate)||(admDate>AEndDate)
	 	} 
	 	
	 	s count = count + 1	
        s ^CacheTemp("dhceprfs","web","ajaxepisodeviewyz","GetPatientList")="1"
		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""AdmDate"":"""_$g(result.Data("AdmDate"))_""",")
		w ..TrimEnter("""AdmTime"":"""_$g(result.Data("AdmTime"))_""",")
		w ..TrimEnter("""AdmType"":"""_$g(result.Data("AdmType"))_""",")
		w ..TrimEnter("""AdmLoc"":"""_$g(result.Data("AdmLoc"))_""",")
		w ..TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
		w ..TrimEnter("""Name"":"""_$g(result.Data("Name"))_""",")					
		w ..TrimEnter("""Gender"":"""_$g(result.Data("Gender"))_""",")
		w ..TrimEnter("""Birthday"":"""_$g(result.Data("Birthday"))_""",")
		w ..TrimEnter("""Age"":"""_$g(result.Data("Age"))_""",")
		w ..TrimEnter("""DisDate"":"""_$g(result.Data("DisDate"))_""",")
		w ..TrimEnter("""DisTime"":"""_$g(result.Data("DisTime"))_""",")
		w ..TrimEnter("""DisLoc"":"""_$g(result.Data("DisLoc"))_""",")
		w ..TrimEnter("""MainDoctor"":"""_$g(result.Data("MainDoctor"))_""",")
		w ..TrimEnter("""InHospitlDoc"":"""_$g(result.Data("InHospitlDoc"))_""",")
		w ..TrimEnter("""RegNo"":"""_$g(result.Data("RegNo"))_""",")
		w ..TrimEnter("""IDCard"":"""_$g(result.Data("IDCard"))_"""")					
		w "}"
		s first = 0
	}
	w "],""total"":"_count_"}"
}

}
