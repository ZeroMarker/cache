Class DHCEPRSearch.Tool.AdmQueueMgr Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc: 按日期批量添加待索引队列
/// Debug: d ##class(DHCEPRSearch.Tool.AdmQueueMgr).AddSearchQueueByDate("2015-1-1","2015-12-31")
ClassMethod AddSearchQueueByDate(AStartDate As %String, AEndDate As %String)
{
	q:(AStartDate = "") "0"
	q:(AEndDate = "") "0"
	
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)
	s count = 0
	s date = startDate - 1
	f {
		s date = $o(^DHCEPRFS.INST.MREpisodeI("IdxCreateDate",date))
		q:((date = "")||(date > endDate))
		s mrEpisodeID = ""
		f {
			s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxCreateDate",date,mrEpisodeID))
			q:(mrEpisodeID = "")
			s searchSucID = ""
			s searchSucID = $o(^DHCEPRSearch.INST.SearchSucI("IdxMREpisodeID"," "_mrEpisodeID,searchSucID))
			s searchQueueID = ""
			s searchQueueID = $o(^DHCEPRSearch.INST.SearchQueueI("IdxMREpisodeID"," "_mrEpisodeID,searchQueueID))
			if ((searchSucID = "")&&(searchQueueID = ""))
			{
				s ret = ##class(DHCEPRSearch.BL.BLSearch).Create(mrEpisodeID,"50")
				if (ret '= "")
				{
					s count = count + 1
				}
			}
		}
	}
	w "Total Added MREpisodeID:"_count,!
}

}
