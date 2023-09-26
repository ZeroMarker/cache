Class web.eprajax.EPRSetManualFlag Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s EpisodeID = $Get(%request.Data("EpisodeID",1),"")
	s SignUserID = $Get(%request.Data("SignUserID",1),"")
	s Action = $Get(%request.Data("Action",1),"")
	s Status = $Get(%request.Data("Status",1),"")
	s Flag = $Get(%request.Data("Flag",1),"")
	s SSGroupID = $Get(%request.Data("SSGroupID",1),"")
	s IsMessage = $Get(%request.Data("IsMessage",1),"")
	if (Status["S")
	{
		s SMsgFlag = ##Class(EPRservice.Quality.DataAccess.BOQualityMessage).GetSMessageFlagByEpisodeID(EpisodeID,Status)
		if (SMsgFlag=-1)||(SMsgFlag=0)
		{
			
		    s:(Action="Set") ret = ##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).BatchSetManualCheck(EpisodeID,SignUserID,Status,SSGroupID,IsMessage,Flag)
		    s:(Action="Cancel") ret = ##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).BatchCancelManualCheck(EpisodeID,Status)
	    }
	    else
	    {
		    s ret=2
	    }
	}
    else
	{
	    s:(Action="Set") ret = ##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).BatchSetManualCheck(EpisodeID,SignUserID,Status,SSGroupID,IsMessage,Flag)
	    s:(Action="Cancel") ret = ##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).BatchCancelManualCheck(EpisodeID,Status)
	}
	w ret
	Quit $$$OK
}

}
