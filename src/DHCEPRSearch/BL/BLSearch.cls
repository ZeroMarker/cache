Class DHCEPRSearch.BL.BLSearch Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	创建一条待索引的任务队列
/// Input:	AMREpisodeID : 归档MREpisodeID
/// 		APriority : 加入的优先级
/// Debug:	w ##Class(DHCEPRSearch.BL.BLSearch).Create("436","50")
ClassMethod Create(AMREpisodeID As %String, APriority As %Integer) As %String
{
	s obj = ##Class(DHCEPRSearch.INST.SearchQueue).%New()
	s obj.MREpisodeID = AMREpisodeID
	s obj.Priority = APriority
	s obj.CandidateDate = $p($h,",",1)
	s obj.CandidateTime = $p($h,",",2)
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// Desc:	检查是否有一条待执行的任务队列
/// Debug:	w ##Class(DHCEPRSearch.BL.BLSearch).CheckMREpisodeTask()
ClassMethod CheckMREpisodeTask() As %String
{
	s MREpisodeID = ..GetTopPriorityAndLastTask()
	q MREpisodeID
}

/// Desc:	获取一条待执行的任务队列，将其放入当前成功队列
/// Debug:	w ##Class(DHCEPRSearch.BL.BLSearch).GetMREpisodeTask()
ClassMethod GetMREpisodeTask() As %String
{
	s rowID = ..GetTopPriorityAndLastTaskID()
	q:(rowID = "") ""
	//b "s"
	s obj = ##class(DHCEPRSearch.INST.SearchQueue).%OpenId(rowID)
	q:(obj = "") ""
	s MREpisodeID = obj.MREpisodeID
	s Priority = obj.Priority
	s CandidateDate = obj.CandidateDate
	s CandidateTime = obj.CandidateTime
	
	s status = ..MoveTaskQueueToSuc(rowID,MREpisodeID,Priority,CandidateDate,CandidateTime)
	q:(status="") ""
	
	q MREpisodeID
}

ClassMethod MoveTaskQueueToSuc(AQueueID As %String, AMREpisodeID As %String, APriority As %String, ACandidateDate As %String, ACandidateTime As %String) As %String
{
	TSTART
	
	s $zt = "OnMoveErrorHandler"
	//b "s"
	s obj = ##Class(DHCEPRSearch.INST.SearchSuc).%New()
	s obj.MREpisodeID = AMREpisodeID
	s obj.Priority = APriority
	s obj.CandidateDate = ACandidateDate
	s obj.CandidateTime = ACandidateTime
	s obj.SucceedDate = $p($h,",",1)
	s obj.SucceedTime = $p($h,",",2)
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
	}
	else
	{
		TROLLBACK
		q ""	
	}
	
	s rowID = obj.%Id()
	if (rowID = "") 
	{
		TROLLBACK
		q ""
	}
	
	s status = ##Class(DHCEPRSearch.INST.SearchQueue).%DeleteId(AQueueID)
	if ($$$ISOK(status))
	{
		TCOMMIT
		q rowID
	}
	else
	{
		TROLLBACK
		q ""
	}	
	
OnMoveErrorHandler
	TROLLBACK
	q ""
}

/// Desc:	获取优先级最高的时间最近的一条待索引的MREpisodeID
/// Debug:	w ##Class(DHCEPRSearch.BL.BLSearch).GetTopPriorityAndLastTask()
ClassMethod GetTopPriorityAndLastTask() As %String
{
	s rowID = ..GetTopPriorityAndLastTaskID()
	q:(rowID = "") ""
	
	s obj = ##class(DHCEPRSearch.INST.SearchQueue).%OpenId(rowID)
	q:(obj = "") ""
	s MREpisodeID = obj.MREpisodeID
	d obj.%Close()
	q MREpisodeID
}

ClassMethod GetTopPriorityAndLastTaskID() As %String
{
	s priority = ""
	s rowID = ""
	for {
		s priority = $O(^DHCEPRSearch.INST.SearchQueueI("IdxPriorityAndDateTime",priority),-1)
		q:(priority="")
		s date = ""
		s date = $O(^DHCEPRSearch.INST.SearchQueueI("IdxPriorityAndDateTime",priority,date),-1)
		s time = ""
		s time = $O(^DHCEPRSearch.INST.SearchQueueI("IdxPriorityAndDateTime",priority,date,time),-1)
		
		for {
			s rowID = $O(^DHCEPRSearch.INST.SearchQueueI("IdxPriorityAndDateTime",priority,date,time,rowID))
			q 
		}
	}
	q rowID
}

}
