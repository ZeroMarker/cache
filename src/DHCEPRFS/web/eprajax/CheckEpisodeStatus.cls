Class DHCEPRFS.web.eprajax.CheckEpisodeStatus Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
    s episodeID = $Get(%request.Data("EpisodeID",1),"")
    s action = $Get(%request.Data("Action",1),"")
	
	if (action = "disdatetime")
	{
		w ..CheckDisDateTime(episodeID)
	}
	elseif (action = "checkcreated")
	{
		s isOn = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("IsEPRBrowserOn")
		if (isOn = "Y")
		{
			s ret = ##Class(DHCEPRFS.BL.BLMRLog).IsRecordCreated(episodeID)	
			w ret
		}
		else
		{
			w "-1"	
		}
	}
	Quit $$$OK
}

/// 查询是否已经进行了护士最终结算
ClassMethod CheckDisDateTime(AEpisodeID As %String) As %String
{
	q:((AEpisodeID = "") || (AEpisodeID = $c(0))) "0"
	
	s PAAdmType = $p($g(^PAADM(AEpisodeID)),"^",2)
	///判读是否是"门诊"就诊
	if (PAAdmType '= "O")
	{
		s ret = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTime(AEpisodeID)
		q:(ret = "") "0"
	}
	
	q "1"
}

}
