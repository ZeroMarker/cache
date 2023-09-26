Class DHCEPRRBAC.web.eprajax.Log Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action",1),"")
	s pageSize = $g(%request.Data("rows",1),"")
	s pageNum = $g(%request.Data("page",1),"")
	s startRow = (pageNum -1)*pageSize + 1
	s endRow = startRow + pageSize -1
	
	s userID = $g(%request.Data("UserID",1),"")
	s episodeID = $g(%request.Data("EpisodeID",1),"") 
	s logType = $g(%request.Data("LogType",1),"") 
	s authorizationID = $g(%request.Data("AuthorizationID",1),"")
	s authorizationGroupID = $g(%request.Data("AuthorizationGroupID",1),"")
	
	s startDate = $g(%request.Data("StartDate",1),"")
	s endDate = $g(%request.Data("EndDate",1),"")
	s viewType = $g(%request.Data("ViewType",1),"")
	
	if (action = "addlog")
	{
		d ..AddLog(userID,episodeID,logType,authorizationID,authorizationGroupID)
	}
	elseif (action = "historylist")
	{
		d ..GetHistoryListJSON(userID,logType,startDate,endDate,viewType,startRow,endRow)
	}
	elseif (action = "historylistsummary")
	{
		d ..GetHistoryListJSON("",logType,startDate,endDate,viewType,startRow,endRow)
	}
	
	Quit $$$OK
}

/// Debug: d ##Class(DHCEPRRBAC.web.eprajax.Log).AddLog("159","610","VIEW","1","1||1")
ClassMethod AddLog(AUserID As %String, AEpisodeID As %String, ALogType As %String, AAuthorizationID As %String, AAuthorizationGroupID As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.BLLog).AddLog(AUserID,AEpisodeID,ALogType,AAuthorizationID,AAuthorizationGroupID)
	w ret
}

/// Debug: d ##class(DHCEPRRBAC.web.eprajax.Log).GetHistoryListJSON("2776","VIEW","2015-7-1","2015-7-2","A",1,20)
ClassMethod GetHistoryListJSON(AUserID As %String, ALogType As %String, AStartDate As %String, AEndDate As %String, AViewType As %String, AIdxStart As %Integer, AIdxLast As %Integer) As %String
{
	s result = ##Class(%ResultSet).%New("DHCEPRRBAC.BL.BLLog:GetHistoryList")
	s sc = result.Execute(AUserID, ALogType, AStartDate, AEndDate, AViewType)
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
	While (result.Next())
	{
		s count = count + 1
		if (count >= AIdxStart) && (count <= AIdxLast)
		{
			if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""UserID"":"""_$g(result.Data("UserID"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""UserName"":"""_$g(result.Data("UserName"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""AppointStatus"":"""_$g(result.Data("AppointStatus"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""AppointStatusDesc"":"""_$g(result.Data("AppointStatusDesc"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""AuthorizationID"":"""_$g(result.Data("AuthorizationID"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""AuthorizationGroupID"":"""_$g(result.Data("AuthorizationGroupID"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""LogDate"":"""_$g(result.Data("LogDate"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""LogTime"":"""_$g(result.Data("LogTime"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAStatusType"":"""_$g(result.Data("PAStatusType"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAAdmType"":"""_$g(result.Data("PAAdmType"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAPMIAge"":"""_$g(result.Data("PAPMIAge"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAAdmDate"":"""_$g(result.Data("PAAdmDate"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAAdmTime"":"""_$g(result.Data("PAAdmTime"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAAdmWard"":"""_$g(result.Data("PAAdmWard"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAAdmLoc"":"""_$g(result.Data("PAAdmLoc"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PADischgeDate"":"""_$g(result.Data("PADischgeDate"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PADischgeTime"":"""_$g(result.Data("PADischgeTime"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAAdmDoc"":"""_$g(result.Data("PAAdmDoc"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PayMode"":"""_$g(result.Data("PayMode"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PatientID"":"""_$g(result.Data("PatientID"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PatientID"":"""_$g(result.Data("PatientID"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""MedRecordNo"":"""_$g(result.Data("MedRecordNo"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""RegNo"":"""_$g(result.Data("RegNo"))_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

}
