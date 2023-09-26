Class web.eprajax.logs.switch Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod SwithcLog(episodeID As %String, eprDocID As %String, eprNum As %String, userID As %String) As %String
{
	
	set action = "switch"
	
	set IP = $ZUtil(67, 15, $Job)				//操作机器的ip地址	
	
	set logID = ##class(EPRinstance.EPRLogs).GetLogID(episodeID, eprDocID, eprNum)
	if (logID = "")	
	{
		q "NoLog"		
	}
	
	set status = ##class(EPRinstance.EPRLogs).UpdateEPRLogByID(logID,action,IP,userID)
	if status = "0"
	{
		q "Update Log Error"
	}
	
	q "success"
}

ClassMethod OnPage() As %Status
{
	//方法已经写入后台，不需前台直接调用
	/*
	set episodeID = $Get(%request.Data("EpisodeID", 1), "-1")		
	set eprDocID = $Get(%request.Data("EPRDocID", 1), "-1")
	set eprNum = $Get(%request.Data("EPRNum", 1), "-1")
	//set templateDocID = $Get(%request.Data("templateDocId", 1), "-1")
	
	s status = SwithcLog(episodeID, eprDocID, eprNum)
	w status
	*/
}

}
