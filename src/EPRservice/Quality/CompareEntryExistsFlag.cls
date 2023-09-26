Class EPRservice.Quality.CompareEntryExistsFlag Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s RuleID=$Get(%request.Data("RuleID",1),"")
	s EpisodeID=$Get(%request.Data("EpisodeID",1),"")
	s SSGroupID=$Get(%request.Data("SSGroupID",1),"")
	s CTLocatID=$Get(%request.Data("CTLocatID",1),"")
	s Action=$Get(%request.Data("Action",1),"")
    s SelectData = $Get(%request.Data("SelectData",1),"")
 
    s ret = ..EntryExistsFlag(RuleID,EpisodeID,SSGroupID,CTLocatID,Action,SelectData)
	w ret
	Quit $$$OK
}

/// Creator:	    HKY
/// Create Date:	2021-01-13
/// Description:	判定选中的质控点中是否有已经评价过的
/// Return:         0：不存在  1：存在
/// Debug:  w ##class(EPRservice.Quality.CompareEntryExistsFlag).EntryExistsFlag("1","162","118","334","A","708^")
ClassMethod EntryExistsFlag(ARuleID As %String, AEpisodeID As %String, ASSGroupID As %String, ACTLocatID As %String, AAction As %String, ASelectData As %String)
{
	S ret=0
	s repid=$i(^CacheTemp)
	k ^CacheTemp("EPRQuality","SelectEntryInfo",repid)
	k ^CacheTemp("EPRQuality","EntryResult",repid)
	q:(ARuleID="")||(AEpisodeID="")||(ASSGroupID="")||(ACTLocatID="")||(AAction="")||(ASelectData="") ret
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.BOManualCheck:GetManualResult")
	d result.Execute(AEpisodeID,ASSGroupID,ACTLocatID,AAction)
	while result.Next()
	{
		s EntryID=result.Data("EntryDR")
		s ResumeText=result.Data("ResumeText")
		s:(ResumeText="") ResumeText="1"
		s ^CacheTemp("EPRQuality","EntryResult",repid,EntryID,ResumeText)=""
	}
	q:($d(^CacheTemp("EPRQuality","EntryResult",repid))'=10) ret
	for count = 1:1:$l(ASelectData,"&")
	{
		s selectdata = $p(ASelectData,"&",count)
	    s selectEntry=$p(selectdata,"^",1)
	    s selectResumeText=$p(selectdata,"^",2)
	    s:(selectResumeText="") selectResumeText="1"
	    s ^CacheTemp("EPRQuality","SelectEntryInfo",repid,selectEntry,selectResumeText)=""
	    
	}
	s TmpEntry=""
	for
	{
		s TmpEntry=$o(^CacheTemp("EPRQuality","SelectEntryInfo",repid,TmpEntry))
		q:(TmpEntry="")
		continue:($d(^CacheTemp("EPRQuality","EntryResult",repid,TmpEntry))'=10)
		s TmpResumeText=""
		for
		{
			s TmpResumeText=$o(^CacheTemp("EPRQuality","SelectEntryInfo",repid,TmpEntry,TmpResumeText))
			q:(TmpResumeText="")
			s ResultResumeText=""
			for
			{
				s ResultResumeText=$o(^CacheTemp("EPRQuality","EntryResult",repid,TmpEntry,ResultResumeText))
				q:(ResultResumeText="")
				if ($ZSTRIP(ResultResumeText,"*p")=$ZSTRIP(TmpResumeText,"*p"))
				{
					
				  s EntryTitle = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetTitleByEntryID(TmpEntry)
				  s ret=EntryTitle
				}
				
				q:(ret'=0) 
			}	
		}
		
	}
	k ^CacheTemp("EPRQuality","SelectEntryInfo",repid)
	k ^CacheTemp("EPRQuality","EntryResult",repid)
	q ret
}

}
