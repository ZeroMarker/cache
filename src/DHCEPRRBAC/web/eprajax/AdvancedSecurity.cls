Class DHCEPRRBAC.web.eprajax.AdvancedSecurity Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action",1),"")
	
	s pageSize = $g(%request.Data("rows",1),"")
	s pageNum = $g(%request.Data("page",1),"")
	s startRow = (pageNum -1)*pageSize + 1
	s endRow = startRow + pageSize -1
	
	s sysCode=$g(%request.Data("SysCode",1),"")	//增加系统标识 
	s episodeID = $g(%request.Data("EpisodeID",1),"")
	s userID = $g(%request.Data("UserID",1),"")
	
	if (action = "episodelist")
	{
		d ..GetEpisodeListJSON(startRow,endRow)
	}
	elseif (action = "add")
	{
		d ..AddAS(sysCode,episodeID,userID)
	}
	elseif (action = "remove")
	{
		d ..RemoveAS(sysCode,episodeID,userID)
	}
	
	Quit $$$OK
}

ClassMethod RemoveAS(ASysCode As %String, AEpisodeID As %String, AUserID As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.BLAdvancedSecurity).RemoveAS(ASysCode,AEpisodeID,AUserID)
	w ret
}

ClassMethod AddAS(ASysCode As %String, AEpisodeID As %String, AUserID As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.BLAdvancedSecurity).AddAS(ASysCode,AEpisodeID,AUserID)
	w ret
}

/// debug: w ##class(DHCEPRRBAC.web.eprajax.AdvancedSecurity).GetEpisodeListJSON(1,12)
ClassMethod GetEpisodeListJSON(AIdxStart As %Integer, AIdxLast As %Integer) As %String
{
	s result = ##Class(%ResultSet).%New("DHCEPRRBAC.BL.BLAdvancedSecurity:GetASecurityList")
	s sc = result.Execute()
	
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
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ActDate"":"""_$g(result.Data("ActDate"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ActTime"":"""_$g(result.Data("ActTime"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAStatusType"":"""_$g(result.Data("PAStatusType"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAAdmType"":"""_$g(result.Data("PAAdmType"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAPMINO"":"""_$g(result.Data("PAPMINO"))_""",")
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
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PatientID"":"""_$g(result.Data("PatientID"))_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

}
