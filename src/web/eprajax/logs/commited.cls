Class web.eprajax.logs.commited Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	set userID = %session.Get("LOGON.USERID")
	if (userID = "")
	{
		w "sessionTimedOut"
		Quit $$$OK
	}
	set episodeID = $Get(%request.Data("EpisodeID", 1), "-1")		
	set eprDocID = $Get(%request.Data("EPRDocID", 1), "-1")
	set eprNum = $Get(%request.Data("EPRNum", 1), "-1")
	set templateDocID = $Get(%request.Data("templateDocId", 1), "-1")
	
	set action = "commit"
	set IP = $ZUtil(67, 15, $Job)					//操作机器的ip地址	
	
	
	set logID = ##class(EPRinstance.EPRLogs).GetLogID(episodeID, eprDocID, eprNum)
	if (logID = "")
	{
		w "NoLog"
		Quit $$$OK
	}
	
	set status = ##class(EPRinstance.EPRLogs).UpdateEPRLogByID(logID,action,IP,userID)
	if status = "0"
	{
		w "Update Log Error"
		Quit $$$OK
	}
	s currState = ##class(EPRinstance.EPRLogs).GetEPRStatus(episodeID, eprDocID, eprNum)
	s divStateServer = ##class(EPRinstance.EPRLogs).GetCurrStatus(episodeID, eprDocID, eprNum)
	
	w "success^"_divStateServer_"^"_currState
	Quit $$$OK
}

}
