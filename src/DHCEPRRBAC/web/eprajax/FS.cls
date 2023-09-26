Class DHCEPRRBAC.web.eprajax.FS Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action",1),"")
	
	s episodeID = $g(%request.Data("EpisodeID",1),"")
	s items = $g(%request.Data("Items",1),"")
    
	if (action = "getveritem")
	{
		d ..GetVerItem(episodeID, items)
	}
			
	Quit $$$OK
}

/// Debug:	d ##Class(DHCEPRRBAC.web.eprajax.FS).GetViewParam("573","4")
ClassMethod GetVerItem(AEpisodeID As %String, AItems As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.FSInfo.BLScheme).GetVerItemByVersionItemsString(AEpisodeID,AItems)
	w ret
}

}
