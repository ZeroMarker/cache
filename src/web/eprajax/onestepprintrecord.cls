Class web.eprajax.onestepprintrecord Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s start = $g(%request.Data("start",1),1)
	s limit = $g(%request.Data("limit",1),20)
	
	s PapmiNo = $g(%request.Data("papmiNo",1),"")
	s PatientID = ""
	if (PapmiNo '= "")
	{
		s PatientID = $o(^PAPERi("PAPMI_PatNo",PapmiNo,PatientID))
	}
	s PatientName = $g(%request.Data("patientName",1),"")
	
	w "{data:["
	
	s totalCount = ##Class(EPRservice.BLL.BLOneStepPrintRecord).GetRecordTotalCount(PatientID,PatientName)
	d ..GetPrintRecordJson(PatientID,PatientName,start,limit)
	
	w "],totalCount:"_totalCount_"}"
	
	Quit $$$OK
}

/// debug: d ##class(web.eprajax.onestepprintrecord).GetPrintRecordJson("1","20")
ClassMethod GetPrintRecordJson(APatientID As %String, APatientName As %String, AStart As %String, ALimit As %String) As %String
{

	s result = ##Class(%ResultSet).%New("EPRservice.BLL.BLOneStepPrintRecord:GetPrintRecord")
	s sc = result.Execute(APatientID,APatientName,AStart,ALimit)	
	
 	s count = 0

	While (result.Next())
 	{
	 	s count = count + 1
		s userID = result.Data("UserID")
		s userCTLocID = result.Data("UserCTLocID")
		s episodeID = result.Data("EpisodeID")
		s patientID = result.Data("PatientID")
		s patientName = result.Data("PatientName")
		s printTempName = result.Data("PrintTempName")	
		s finishDate = result.Data("FinishDate")
		s finishTime = result.Data("FinishTime")
		
		s userName = ##class(EPRmeta.Privilege.PowerUser).GetUserName(userID)
 		s finishDateTime = $ZD(finishDate,3)_" "_$ZT(finishTime)
 		
 		s userCTLoc = ""
		if (userCTLocID '= "")
		{
			s userCTLoc = $P($g(^CTLOC(userCTLocID)),"^",2)
			s num = $L(userCTLoc,"-")
			if (num = 2)
			{
				s userCTLoc = $P(userCTLoc,"-",2)
			}
		}
 		
		s PAAdmDate = $p($g(^PAADM(episodeID)),"^",6)
		if (PAAdmDate '= "")
		{
			s PAAdmDate = $zd(PAAdmDate,3)
		}
		s PAAdmTime = $p($g(^PAADM(episodeID)),"^",7)
		if (PAAdmTime '= "")
		{
			s PAAdmTime = $zt(PAAdmTime,3)
		}
		s PADischgeDate=$P($g(^PAADM(episodeID)),"^",17)
		if (PADischgeDate '= "")
		{
			s PADischgeDate = $zd(PADischgeDate,3)
		}
		s PADischgeTime=$P($g(^PAADM(episodeID)),"^",18)
		if (PADischgeTime '= "")
		{
			s PADischgeTime = $zt(PADischgeTime,3)
		}
		
		if (count>1) w ","
		w "{"
		w "UserName:'"_userName_"'"
		w ",UserID:'"_userID_"'"
		w ",UserCTLoc:'"_userCTLoc_"'"
		w ",PatientName:'"_patientName_"'"
		w ",PatientID:'"_patientID_"'"
		w ",EpisodeID:'"_episodeID_"'"
		w ",FinishDateTime:'"_##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",finishDateTime)_"'"
		w ",PrintTempName:'"_printTempName_"'"
		w ",PAAdmDate:'"_##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PAAdmDate)_"'"
		w ",PADischgeDate:'"_##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PADischgeDate)_"'"
		w "}"	
 	}
}

}
