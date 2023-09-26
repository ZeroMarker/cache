Class DHCEPRRBAC.web.eprajax.View Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action",1),"")
	
	s episodeID = $g(%request.Data("EpisodeID",1),"")
	s authorizationID = $g(%request.Data("AuthorizationID",1),"")
	s userID = $g(%request.Data("UserID",1),"")
	s ssgroupID = $g(%request.Data("SSGroupID",1),"")
	
	if (action = "getviewparam")
	{
		d ..GetViewParam(episodeID,authorizationID)
	}
	elseif (action = "getdefaultviewparam")
	{
		d ..GetDefaultViewParam(episodeID,ssgroupID)
	}
	elseif(action = "check")
	{
		d ..CheckExpire(episodeID,userID)
	}
	elseif (action = "defaultviewpermission")
	{
		d ..GetDefaultViewPermission(episodeID,ssgroupID)
	}
	elseif (action = "authviewpermission")
	{
		d ..GetAuthViewPermission(episodeID,authorizationID)
	}
	
	Quit $$$OK
}

/// Debug: d ##Class(DHCEPRRBAC.web.eprajax.View).CheckExpire("573","4")
ClassMethod CheckExpire(AEpisodeID As %String, AUserID As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.BLView).CheckExpire(AEpisodeID,AUserID,"F")
	w ret
}

/// Debug: d ##Class(DHCEPRRBAC.web.eprajax.View).GetViewParam("4698119","8")
ClassMethod GetViewParam(AEpisodeID As %String, AAuthorizationID As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.BLView).GetViewParam(AEpisodeID,AAuthorizationID)
	w ret
}

/// Debug: d ##Class(DHCEPRRBAC.web.eprajax.View).GetDefaultViewParam("5013997","500")
ClassMethod GetDefaultViewParam(AEpisodeID As %String, ASSGroupID As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.BLView).GetDefaultViewParam(AEpisodeID,ASSGroupID)
	w ret
}

/// Debug: d ##Class(DHCEPRRBAC.web.eprajax.View).GetDefaultViewPermission("5013997","500")
ClassMethod GetDefaultViewPermission(AEpisodeID As %String, ASSGroupID As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.BLView).GetDefaultViewPermission(AEpisodeID,ASSGroupID)
	w ret
}

/// Debug: d ##Class(DHCEPRRBAC.web.eprajax.View).GetAuthViewPermission("4698119","8")
ClassMethod GetAuthViewPermission(AEpisodeID As %String, AAuthorizationID As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.BLView).GetAuthViewPermission(AEpisodeID,AAuthorizationID)
	w ret
}

}
