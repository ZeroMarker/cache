Class web.eprajax.qualitycheck Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s $zt = "ErrorHandler"
	s episodeId = $Get(%request.Data("EpisodeID",1),"")
	s eventType = $Get(%request.Data("EventType",1),"")
	s templateId = $Get(%request.Data("TemplateID",1),"")
	s instanceId = $Get(%request.Data("InstanceID",1),"")
	w ..GetQualityCheck(episodeId,eventType,templateId,instanceId)
	Quit $$$OK
ErrorHandler
	w $zerror
}

/// Desc:       前台取病历操作质控结构Creator:    Candy
/// CreateDate: 2014-9-29
/// Input:      AEpisodeID 就诊号            AEventType 事件类型(Save^SSgoupID^LocID)
///             ATemplateID 模板ID 
/// Output:     result 控制类型^触犯条目(多条用"^"分隔)
/// Debug:      w ##Class(web.eprajax.qualitycheck).GetQualityCheck(4065867,"Print^100^33",20,"1||8")
ClassMethod GetQualityCheck(AEpisodeID As %String, AEventType As %String, ATemplateID As %String, AInstanceIDs As %String) As %String
{
	s result = ""
	q:((AEpisodeID="")||(AEventType="")||((ATemplateID="")&&'(AEventType [ "Confirm"))) result
	s job = ##Class(EPRservice.Quality.BORunTimeQuality).GetRunTimeQuality(AEpisodeID,ATemplateID,AEventType,AInstanceIDs,"")
	q:job="" result
	s RuleDR = $O(^CacheTemp("DHCEPRQQuality",job,AEpisodeID,""))
	q:(RuleDR = "") result
	
	s RuleInfo = ^CacheTemp("DHCEPRQQuality",job,AEpisodeID,RuleDR)
    s ControlType = $p(RuleInfo,"^",1)
    s result = ControlType_"^"
	s PhaseID = ""
	for {
		s PhaseID = $O(^CacheTemp("DHCEPRQQuality",job,AEpisodeID,RuleDR,PhaseID))
		q:(PhaseID = "")
		s EntryDR = ""
	    for 
	    {
		    s EntryDR = $O(^CacheTemp("DHCEPRQQuality",job,AEpisodeID,RuleDR,PhaseID,EntryDR))
		    q:(EntryDR = "")
		    s EntryName = $p($g(^CacheTemp("DHCEPRQQuality",job,AEpisodeID,RuleDR,PhaseID,EntryDR)),"^",1)
		    s result = result_EntryName_";"
	    }
	}
	k ^CacheTemp("DHCEPRQQuality",job)
	q result
}

/// Desc:       前台取病历批量打印操作质控结构
/// Input:      AEpisodeID 就诊号            AEventType 事件类型(Save^SSgoupID^LocID)
///             ATemplateID 模板ID 
/// Output:     result 控制类型^触犯条目(多条用"^"分隔)
/// Debug:      w ##Class(web.eprajax.qualitycheck).GetQualityCheck(4065867,"Print^100^33",20,"1||8")
ClassMethod GetQualityCheckBatch(AEpisodeID As %String, AEventType As %String, ATemplateID As %String, AInstanceIDs As %String) As %String
{
	
	s result = ""
	q:((AEpisodeID="")||(AEventType="")||((ATemplateID="")&&'(AEventType [ "Confirm"))) result
	s job = ##Class(EPRservice.Quality.BORunTimeQuality).GetRunTimeQuality(AEpisodeID,ATemplateID,AEventType,AInstanceIDs,"")
	q:job="" result
	s RuleDR = $O(^CacheTemp("DHCEPRQQuality",job,AEpisodeID,""))
	q:(RuleDR = "") result
	
	s RuleInfo = ^CacheTemp("DHCEPRQQuality",job,AEpisodeID,RuleDR)
    s ControlType = $p(RuleInfo,"^",1)
    s result = ControlType_"^"
	s PhaseID = ""
	for {
		s PhaseID = $O(^CacheTemp("DHCEPRQQuality",job,AEpisodeID,RuleDR,PhaseID))
		q:(PhaseID = "")
		s EntryDR = ""
	    for 
	    {
		    s EntryDR = $O(^CacheTemp("DHCEPRQQuality",job,AEpisodeID,RuleDR,PhaseID,EntryDR))
		    q:(EntryDR = "")
		    s EntryName = $p($g(^CacheTemp("DHCEPRQQuality",job,AEpisodeID,RuleDR,PhaseID,EntryDR)),"^",1)
		    s result = "-1^"_EntryName_";"
	    }
	}
	k ^CacheTemp("DHCEPRQQuality",job)
	q result
}

}
