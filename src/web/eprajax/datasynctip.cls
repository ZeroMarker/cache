Class web.eprajax.datasynctip Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s ActionCode = $Get(%request.Data("ActionCode",1),"")
	s EpisodeID  = $Get(%request.Data("EpisodeID",1),"")
	s UserID = $Get(%request.Data("UserID",1),"")
	s SessionID = %session.SessionId
 
 	if (ActionCode = "SetTipUser")
 	{
	 	s flag = ..SetDataSyncUser(UserID,EpisodeID,SessionID)
	 	w flag
 	}
 	
 	q $$$OK
}

ClassMethod SetDataSyncUser(UserID, EpisodeID, SessionID) As %String
{
	s id = $O(^DHCEPRI.DataSyncTipUserI("IdxUserID"," "_UserID,""))
	if (id = "")
	{
		s obj = ##Class(EPRinstance.DataSyncTipUser).%New()
	}
	else
	{
		s obj = ##Class(EPRinstance.DataSyncTipUser).%OpenId(id)
	}
	
	s obj.UserID = UserID
	s obj.TipCode = "02"
	s obj.LogonSession = SessionID
	
	s sc = obj.%Save()
	q sc
}

}
