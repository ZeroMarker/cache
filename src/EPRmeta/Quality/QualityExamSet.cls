Class EPRmeta.Quality.QualityExamSet Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetQuaExamResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQuaExamResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetQuaExamResultExecute(ByRef qHandle As %Binary, job As %String) As %Status
{
	//电子病历的质控
	Set repid=$I(^CacheTemp)
	Set ind=1
	
	Set (SectionDr,SectionDesc,ExamItem,ACRDesc)=""
	Set EpisodeID=$O(^CacheTemp("DHCEPRQQuality",job,0))
	While(EpisodeID'="")
	{
		Set PatInPreFix=""
		Set PapmiDr=##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
		Set PatInPreFix=##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDr)
		Set PatInPreFix=PatInPreFix_"  "_##Class(EPRservice.HISInterface.PatientInfoAssist).Name(PapmiDr)
		Set RuleDR=$O(^CacheTemp("DHCEPRQQuality",job,EpisodeID,0))
		While(RuleDR'="")
		{
			Set RuleName=$G(^CacheTemp("DHCEPRQQuality",job,EpisodeID,RuleDR))
			set PhaseID = ""
			for {
				set PhaseID = $O(^CacheTemp("DHCEPRQQuality",job,EpisodeID,RuleDR,PhaseID))
				q:(PhaseID = "")
				Set EntryDR=$O(^CacheTemp("DHCEPRQQuality",job,EpisodeID,RuleDR,PhaseID,0))
			    While(EntryDR'="")
			    {
				    Set EntryName=$p($g(^CacheTemp("DHCEPRQQuality",job,EpisodeID,RuleDR,PhaseID,EntryDR)),"^",1)
				    Do BuildTmp
				    Set EntryDR=$O(^CacheTemp("DHCEPRQQuality",job,EpisodeID,RuleDR,PhaseID,EntryDR))
			    }
			}
			Set RuleDR=$O(^CacheTemp("DHCEPRQQuality",job,EpisodeID,RuleDR))
		}
		Set EpisodeID=$O(^CacheTemp("DHCEPRQQuality",job,EpisodeID))
	}
	Set qHandle=$LB(0,repid,0)
	Kill ^CacheTemp("DHCEPRQQuality",job)
	Quit $$$OK
	
BuildTmp
    Set EntryName=PatInPreFix_" "_EntryName      
	set Data=$LB(RuleDR,RuleName,SectionDr,SectionDesc,EntryDR,EntryName,ExamItem,ACRDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	Quit

	/* 医政组的质控
	Set repid=$I(^CacheTemp)
	s ind=1
    s EpisoId="0"
	f  s EpisoId=$o(^CacheTemp("DHCWMRQuality",job,EpisoId)) q:EpisoId=""  d
	.s PatInPreFix=""
	.s PapmiDr=##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisoId)
	.s PatInPreFix=##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDr)
	.s PatInPreFix=PatInPreFix_"  "_##Class(EPRservice.HISInterface.PatientInfoAssist).Name(PapmiDr)
	.s RuleDr="0"	
	.f  s RuleDr=$o(^CacheTemp("DHCWMRQuality",job,EpisoId,RuleDr)) q:RuleDr=""  d
	..s RuleDesc=$g(^CacheTemp("DHCWMRQuality",job,EpisoId,RuleDr))
	..s SectionDr="0"
	..f  s SectionDr=$o(^CacheTemp("DHCWMRQuality",job,EpisoId,RuleDr,SectionDr)) q:SectionDr=""  d
	...s SectionDesc=$g(^CacheTemp("DHCWMRQuality",job,EpisoId,RuleDr,SectionDr))
	...s EntryDr="0"
	...f  s EntryDr=$o(^CacheTemp("DHCWMRQuality",job,EpisoId,RuleDr,SectionDr,EntryDr)) q:EntryDr=""  d
	....s EntryDesc=^CacheTemp("DHCWMRQuality",job,EpisoId,RuleDr,SectionDr,EntryDr)
	....;s ExamItem="0"
	....;f  s ExamItem=$o(^CacheTemp("DHCWMRQuality",job,EpisoId,RuleDr,SectionDr,EntryDr,ExamItem)) q:ExamItem=""  d
	.....;s ACRDesc=$g(^CacheTemp("DHCWMRQuality",job,EpisoId,RuleDr,SectionDr,EntryDr,ExamItem))
	....d BuildTmp
	Set qHandle=$lb(0,repid,0)
	k ^CacheTemp("DHCWMRQuality",job)
	Quit $$$OK
BuildTmp
    s EntryDesc=PatInPreFix_" "_EntryDesc      
	set Data=$lb(RuleDr,RuleDesc,SectionDr,SectionDesc,EntryDr,EntryDesc,ExamItem,ACRDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
 	*/
}

ClassMethod GetQuaExamResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQuaExamResultExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// d ##Class(%ResultSet).RunQuery("EPRmeta.Quality.QualityExamSet","GetQuaExamResult",5000)
Query GetQuaExamResult(job As %String) As %Query(ROWSPEC = "RuleDr:%String,RuleDesc:%String,SectionDr:%String,SectionDesc:%String,EntryDr:%String,EntryDesc:%String,ExamItem:%String,ACRDesc:%String")
{
}

ClassMethod QuaSendMsgToUser(strMsg As %String, UserDr As %String) As %String
{
	s objSSMessage=##Class(User.SSMessage).%New()
	d objSSMessage.MESSUserCreatedDRSetObjectId(UserDr)
	d objSSMessage.%Save()
	s objSSMessageDr=objSSMessage.%Id()
	s ^SST("MESS",objSSMessageDr,"TXT",0)=1
	s ^SST("MESS",objSSMessageDr,"TXT",1)=strMsg
	s objSSMessageRecipient=##Class(User.SSMessageRecipient).%New()
	d objSSMessageRecipient.MESSRECMessageDRSetObjectId(objSSMessageDr)
	d objSSMessageRecipient.MESSRECUserDRSetObjectId(UserDr)
	d objSSMessageRecipient.%Save()
	q objSSMessageRecipient.%Id()
}

}
