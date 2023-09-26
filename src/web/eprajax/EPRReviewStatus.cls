Class web.eprajax.EPRReviewStatus Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s EpisodeIDs = $Get(%request.Data("EpisodeIDs",1),"")
	s EpisodeID = $Get(%request.Data("EpisodeID",1),"")
	s Action = $Get(%request.Data("Action",1),"")
	
	if (Action = "DEPTREVIEW")
	{
		s ret = ..PassResult(EpisodeIDs,Action)
	}
	elseif (Action = "DOCDEPTQCBACK")
	{
		s ret = ..DocResult(EpisodeIDs,"DEPTQCBACK")
	}
	elseif (Action = "NUSDEPTQCBACK")
	{
		s ret = ..NusResult(EpisodeIDs,"NUSDEPTQCBACK")
	}
	elseif (Action = "DOCCANCOMMIT")
	{
		s ret = ..CheckDocCanCommit(EpisodeID)	
	}
	w ret
	Quit $$$OK
}

ClassMethod CheckDocCanCommit(AEpisodeID As %String)
{
	s ret = "0"
	s ret = ##class(DHCEPRFS.BL.BLPrivilege).CheckDocCommitPrivilege(AEpisodeID)
	q ret
}

ClassMethod PassResult(AEpisodeIDs As %String, Action As %String)
{
	q:AEpisodeIDs="" ""
	for count = 1:1:$l(AEpisodeIDs,"&")
	{
		s EpisodeID = $p(AEpisodeIDs,"&",count)
		s MREpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(EpisodeID, "DHC")
		s ret = ##Class(DHCEPRFS.BL.BLMRLog).AddMRLogDetail(MREpisodeID,Action,"","10","0","0")

	}
	q ret
}

ClassMethod DocResult(AEpisodeIDs As %String, Action As %String)
{
	q:AEpisodeIDs="" "0"
	for count = 1:1:$l(AEpisodeIDs,"&")
	{
		s EpisodeID = $p(AEpisodeIDs,"&",count)
		s MREpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(EpisodeID, "DHC")
		s ret = ##Class(DHCEPRFS.BL.BLMRLog).AddMRLogDetail(MREpisodeID,Action,"","10","0","0")
		//无需调用病案退回，科室退回和病案退回是两个状态
		//if (ret'="")
		//{
		//	s ret = ##Class(DHCEPRFS.BI.BIToWMR).SetCheckFailFlag(EpisodeID,0,1,"","")
		//}
	}
	q ret
}

ClassMethod NusResult(AEpisodeIDs As %String, Action As %String)
{
	q:AEpisodeIDs="" "0"
	for count = 1:1:$l(AEpisodeIDs,"&")
	{
		s EpisodeID = $p(AEpisodeIDs,"&",count)
		s MREpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(EpisodeID, "DHC")
		s ret = ##Class(DHCEPRFS.BL.BLMRLog).AddMRLogDetail(MREpisodeID,Action,"","10","0","0")
		//无需调用病案退回，科室退回和病案退回是两个状态
		//if (ret'="")
		//{
		//	s ret = ##Class(DHCEPRFS.BI.BIToWMR).SetCheckFailFlag(EpisodeID,1,0,"","")
		//}
	}
	q ret
}

}
