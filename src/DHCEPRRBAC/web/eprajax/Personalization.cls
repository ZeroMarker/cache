Class DHCEPRRBAC.web.eprajax.Personalization Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action","1"),"")
	
	s episodeID = $g(%request.Data("EpisodeID","1"),"")	
	
	if (action = "linkparam")
	{
		d ..GetLinkParam(episodeID)	
	}
	
	Quit $$$OK
}

ClassMethod GetLinkParam(AEpisodeID As %String) As %String
{
	s ret = ##class(DHCEPRRBAC.BL.BLPersonalization).GetLinkInfo(AEpisodeID)
	w ret
}

}
