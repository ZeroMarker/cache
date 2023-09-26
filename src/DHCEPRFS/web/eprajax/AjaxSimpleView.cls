Class DHCEPRFS.web.eprajax.AjaxSimpleView Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("Action",1),"")
	s admNo = $Get(%request.Data("AdmNo",1),"")
	s name = $Get(%request.Data("Name",1),"")
	s regNo = $Get(%request.Data("RegNo",1),"")
	s medRecordID = $Get(%request.Data("MedRecordID",1),"")
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	
	if (action = "episodelist")
	{
		//s ^CacheTemp("dhceprfs-debug-2016-7-20","1") = admNo_"^"_regNo_"^"_name
		d ..GetEPREpisodeListJSON(admNo, regNo,name,medRecordID)
	}
	Quit $$$OK
}

/// debug: d ##class(DHCEPRFS.web.eprajax.AjaxMRSealUp).GetEPREpisodeListJSON("","000000202","","500307")
ClassMethod GetEPREpisodeListJSON(AAdmNo As %String, ARegNo As %String, AName As %String, AmedRecordID As %String) As %String
{
	s param = "^"_AName_"^"_AmedRecordID_"^"_AAdmNo_"^"_ARegNo
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLEpisodeInfo:GetEpisodeList")
	s sc = result.Execute(param)
	
 	s count = 0
 	s first = 1
 	w "{""rows"":["
 	
	While (result.Next())
 	{
	 	s count = count + 1		

		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""PAStatusType"":"""_$g(result.Data("PAStatusType"))_""",")
		w ..TrimEnter("""PAAdmType"":"""_$g(result.Data("PAAdmType"))_""",")
		w ..TrimEnter("""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""",")
		w ..TrimEnter("""PAPMINO"":"""_$g(result.Data("PAPMINO"))_""",")			
		w ..TrimEnter("""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""",")
		w ..TrimEnter("""PAPMIAge"":"""_$g(result.Data("PAPMIAge"))_""",")
		w ..TrimEnter("""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""",")
		w ..TrimEnter("""PAAdmDateTime"":"""_$g(result.Data("PAAdmDateTime"))_""",")
		w ..TrimEnter("""PAAdmWard"":"""_$g(result.Data("PAAdmWard"))_""",")
		w ..TrimEnter("""PAAdmRoom"":"""_$g(result.Data("PAAdmRoom"))_""",")
		w ..TrimEnter("""PAAdmBed"":"""_$g(result.Data("PAAdmBed"))_""",")
		w ..TrimEnter("""PAAdmLoc"":"""_$g(result.Data("PAAdmLoc"))_""",")			
		w ..TrimEnter("""PADischgeDateTime"":"""_$g(result.Data("PADischgeDateTime"))_""",")
		w ..TrimEnter("""PAAdmDoc"":"""_$g(result.Data("PAAdmDoc"))_""",")
		w ..TrimEnter("""PayMode"":"""_$g(result.Data("PayMode"))_""",")
		w ..TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
		w ..TrimEnter("""PatientID"":"""_$g(result.Data("PatientID"))_"""")
		w "}"
		s first = 0
	}
	w "],""total"":"_count_"}"
}

ClassMethod TrimEnter(AInput As %String) As %String
{
	s ret = $TR(AInput,$C(13),"")
	s ret = $TR(ret,$C(10),"")
	q ret
}

}
