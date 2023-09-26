Class DHCEPRFS.web.eprajax.AjaxIntegrityCheck Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("Action",1),"")
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	s userID = $Get(%request.Data("UserID",1),"")
	//s ruleCode = $Get(%request.Data("RuleCode",1),"")
	s ruleCode = "EPRRule002"
	s categoryCode = $Get(%request.Data("CategoryCode",1),"")
	
	if (action = "saveresult")
	{
		d ..SaveCheckResult(episodeID,userID,ruleCode)
	}
	elseif (action = "showresult")
	{
		d ..GetCheckResultJSON(episodeID)
	}
	elseif (action = "showdetail")
	{
		d ..GetCheckRetDtlJSON(episodeID,categoryCode)
	}
	
	Quit $$$OK
}

/// Debug: d ##Class(DHCEPRFS.web.eprajax.AjaxIntegrityCheck).SaveReviewedStatus("596","159","EPRRule003")
ClassMethod SaveCheckResult(AEpisodeID As %String, AUserID As %String, ARuleCode As %String)
{
    s ret = ##class(DHCEPRFS.BL.BLIntegrityCheck).SaveCheckResult(AEpisodeID,AUserID,ARuleCode)
    w ret
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxIntegrityCheck).GetCheckResultJSON("592")
ClassMethod GetCheckResultJSON(AEpisodeID As %String)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLIntegrityCheck:GetCheckResultByEpisode")
	s sc = result.Execute(AEpisodeID)
	
 	s count = 0
 	s first = 1
 	w "{""rows"":["
 	
	While (result.Next())
 	{
	 	s count = count + 1		
		
		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""CategoryCode"":"""_$g(result.Data("CategoryCode"))_""",")
		w ..TrimEnter("""CategoryName"":"""_$g(result.Data("CategoryName"))_""",")
		w ..TrimEnter("""CheckResult"":"""_$g(result.Data("CheckResult"))_""",")
		w ..TrimEnter("""IsNeeded"":"""_$g(result.Data("IsNeeded"))_"""")
		w "}"
		s first = 0
	}
	w "],""total"":"_count_"}"
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxIntegrityCheck).GetCheckRetDtlJSON("588","Category001")
ClassMethod GetCheckRetDtlJSON(AEpisodeID As %String, ACategoryCode As %String)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLIntegrityCheck:GetCheckRetDtlByCategory")
	s sc = result.Execute(AEpisodeID,ACategoryCode)
	
 	s count = 0
 	s first = 1
 	w "{""rows"":["
 	
	While (result.Next())
 	{
	 	s count = count + 1		
		
		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""MRItemName"":"""_$g(result.Data("MRItemName"))_""",")
		w ..TrimEnter("""CheckResult"":"""_$g(result.Data("CheckResult"))_""",")
		w ..TrimEnter("""IsNeeded"":"""_$g(result.Data("IsNeeded"))_"""")
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
