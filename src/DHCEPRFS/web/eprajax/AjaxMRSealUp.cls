Class DHCEPRFS.web.eprajax.AjaxMRSealUp Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	//s ^AAA("dhceprfs-debug-2016-7-20","0") = "111"
	s action = $Get(%request.Data("Action",1),"")
	s admNo = $Get(%request.Data("AdmNo",1),"")
	s name = $Get(%request.Data("Name",1),"")
	s regNo = $Get(%request.Data("RegNo",1),"")
	s medRecordID = $Get(%request.Data("MedRecordID",1),"")
	
	s patientName = $Get(%request.Data("PatientName",1),"")
	s patientPhone = $Get(%request.Data("PatientPhone",1),"")
	s patientAgent = $Get(%request.Data("PatientAgent",1),"")
	s agentPhone = $Get(%request.Data("AgentPhone",1),"")
	s relationship = $Get(%request.Data("Relationship",1),"")
	s remarks = $Get(%request.Data("Remarks",1),"")
	s doc = $Get(%request.Data("Doc",1),"")
	s medDepartment = $Get(%request.Data("MedDepartment",1),"")
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	
	
	//s ^AAA("dhceprfs-debug-2016-7-20","1") = action_"^"_admNo_"^"_regNo_"^"_name
	
	if (action = "Doc")
	{
		d ..GetDocListJSON()
	}
	elseif (action = "MedDepartment")
	{
		d ..GetMedListJSON()
	}
	elseif (action = "episodelist")
	{
		//s ^CacheTemp("dhceprfs-debug-2016-7-20","1") = admNo_"^"_regNo_"^"_name
		d ..GetEPREpisodeListJSON(admNo, regNo,name,medRecordID)
	}
	elseif (action = "sealUp")
	{
		s ^CacheTemp("dhceprfs-debug-2016-7-21","2")= episodeID_"^"_doc_"^"_remarks_"^"_medDepartment
		d ..SealUpByAdm(episodeID,doc,remarks,patientAgent,relationship,medDepartment,agentPhone,patientName,patientPhone)
	}
	elseif (action = "sealSec")
	{
		d ..SealSecByAdm(episodeID)
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

/// debug: d ##class(DHCEPRFS.web.eprajax.AjaxMRSealUp).GetDocListJSON()
ClassMethod GetDocListJSON() As %String
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLQueryUser:GetUsers")
	s sc =  result.Execute("HIS")
	
	s count = 0
 	s first = 1
 	w "{""rows"":["
 	
	While (result.Next())
 	{
	 	s count = count + 1		

		if ((count > 1)&&(first '= 1)) w ","
		if ($g(result.Data("IsAvailable"))= "1")
		{
			w "{"
			w ..TrimEnter("""id"":"""_$g(result.Data("SSUserID"))_""",")
			w ..TrimEnter("""code"":"""_$g(result.Data("Code"))_""",")
			w ..TrimEnter("""name"":"""_$g(result.Data("Name"))_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

/// debug: d ##class(DHCEPRFS.web.eprajax.AjaxMRSealUp).GetDocListJSON()
ClassMethod GetMedListJSON() As %String
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLQueryUser:GetUsers")
	s sc =  result.Execute("HIS")
	
	s count = 0
 	s first = 1
 	w "{""rows"":["
 	
	While (result.Next())
 	{
	 	s count = count + 1		

		if ((count > 1)&&(first '= 1)) w ","
		if ($g(result.Data("IsAvailable"))= "1")
		{
			w "{"
			w ..TrimEnter("""id"":"""_$g(result.Data("SSUserID"))_""",")
			w ..TrimEnter("""code"":"""_$g(result.Data("Code"))_""",")
			w ..TrimEnter("""name"":"""_$g(result.Data("Name"))_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

/// debug: d ##class(DHCEPRFS.web.eprajax.AjaxMRSealUp).SealUpByAdm("583","131","其他","张二","父子","133","110","张二","112")
ClassMethod SealUpByAdm(AEpisodeID As %String, ADoc As %String, ARemarksAs As %String, APatientAgent As %String, ARelationship As %String, AMedDepartment As %String, AAgentPhone As %String, APatientName As %String, APatientPhone As %String) As %String
{
	s ret = ##Class(DHCEPRFS.BL.BLSealUp).RegSealUpByAdm(AEpisodeID,ADoc,ARemarksAs,APatientAgent,ARelationship,AMedDepartment,AAgentPhone,APatientName,APatientPhone)
	if (ret'="-9")&&(ret'="-1")&&(ret'="-2")&&(ret'="-3")
	{
		//b "s"
		s obj = ##Class(DHCEPRFS.INST.MRSealUp).%OpenId(ret)
		s episodeID = obj.MREpisodeID
		s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLSealUp:GetSealListByAdm")
		s sc =  result.Execute(episodeID)
		
		s count = 0
 		s first = 1
 		w "{""rows"":["
 	
		While (result.Next())
 		{
	 		s count = count + 1		

			if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ..TrimEnter("""PAStatusType"":"""_$g(result.Data("sealStatus"))_""",")
			w ..TrimEnter("""PADoc"":"""_$g(result.Data("sealUpDoc"))_""",")
			w ..TrimEnter("""PAMedDepartment"":"""_$g(result.Data("sealUpDept"))_""",")
			w ..TrimEnter("""PAPatientName"":"""_$g(result.Data("sealUpPatientName"))_""",")
			w ..TrimEnter("""PAPatientPhone"":"""_$g(result.Data("sealUpPatientPhone"))_""",")
			w ..TrimEnter("""PAPatientAgent"":"""_$g(result.Data("sealUpName"))_""",")
			w ..TrimEnter("""PAAgentPhone"":"""_$g(result.Data("sealUpPhone"))_""",")
			w ..TrimEnter("""PARelationship"":"""_$g(result.Data("sealUpRelation"))_""",")
			w ..TrimEnter("""PASealDate"":"""_$g(result.Data("sealUpDate"))_""",")
			w ..TrimEnter("""PASealTime"":"""_$g(result.Data("sealUpTime"))_"""")
			w "}"
			s first = 0
		}
		
		w "],""total"":"_count_"}"
	}
}

/// debug: d ##class(DHCEPRFS.web.eprajax.AjaxMRSealUp).SealSecByAdm("583")
ClassMethod SealSecByAdm(AEpisodeID As %String) As %String
{
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(AEpisodeID,"DHC")
	if (mrEpisodeID'="")
	{
		s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLSealUp:GetSealListByAdm")
		s sc =  result.Execute(mrEpisodeID)
		
		s count = 0
 		s first = 1
 		w "{""rows"":["
 		While (result.Next())
 		{
	 		s count = count + 1		

			if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ..TrimEnter("""PAStatusType"":"""_$g(result.Data("sealStatus"))_""",")
			w ..TrimEnter("""PADoc"":"""_$g(result.Data("sealUpDoc"))_""",")
			w ..TrimEnter("""PAMedDepartment"":"""_$g(result.Data("sealUpDept"))_""",")
			w ..TrimEnter("""PAPatientName"":"""_$g(result.Data("sealUpPatientName"))_""",")
			w ..TrimEnter("""PAPatientPhone"":"""_$g(result.Data("sealUpPatientPhone"))_""",")
			w ..TrimEnter("""PAPatientAgent"":"""_$g(result.Data("sealUpName"))_""",")
			w ..TrimEnter("""PAAgentPhone"":"""_$g(result.Data("sealUpPhone"))_""",")
			w ..TrimEnter("""PARelationship"":"""_$g(result.Data("sealUpRelation"))_""",")
			w ..TrimEnter("""PASealDate"":"""_$g(result.Data("sealUpDate"))_""",")
			w ..TrimEnter("""PASealTime"":"""_$g(result.Data("sealUpTime"))_"""")
			w "}"
			s first = 0
		}	
		w "],""total"":"_count_"}"	
	}
}

}
