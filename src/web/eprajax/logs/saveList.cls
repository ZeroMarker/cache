/// 该类停用，保存日志在dll中完成 -- 2009/11/17 by houj
Class web.eprajax.logs.saveList Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	set episodeID = $Get(%request.Data("episodeID", 1), "-1")
	set eprDocID = $Get(%request.Data("printTemplateDocId", 1), "-1")	
	set happenDate =  $ZDH($Get(%request.Data("happenDate", 1), "-1"), 3)		
	set happenTime = $ZTH($Get(%request.Data("happenTime", 1), "-1"), 1)
	set eprNum =  $Get(%request.Data("EPRNum", 1), "-1")
	
			
	;set action = ##class(EPRmeta.EPRAction).GetSaveType(episodeID, eprDocID)
	;set:(action = 1) action = "complete"
	;set:(action = 0) action = "save"
	set action = "complete"
	
	set IP = $ZUtil(67, 15, $Job)
	set userID = %session.Get("LOGON.USERID")
	set type = "Multiple"
	
	set logID = ""
	
	if (eprNum = "-1")
	{
		set logID = ##class(EPRinstance.EPRLogs).CreateEPRLog(episodeID,eprDocID,action,IP,userID,happenDate,happenTime)
		if logID = "0"
		{
			write "Create Log Error"
			Quit $$$OK
		}
	}
	else
	{
		set logID = ##class(EPRinstance.EPRLogs).GetLogID(episodeID, eprDocID, eprNum)
		s status = ##class(EPRinstance.EPRLogs).UpdateEPRLogForSaveAction(logID,action,IP,userID,type,happenDate,happenTime)
		if (status = "0")
		{
			w "Update Log Error"
			Quit $$$OK
		}	
	}
	s eprLogs = ##class(EPRinstance.EPRLogs).%OpenId(logID)
	s eprNum = eprLogs.EPRNum
	d eprLogs.%Close()	
	s divStateServer = ##class(EPRinstance.EPRLogs).GetCurrStatus(episodeID, eprDocID, eprNum)
	w "success^"_logID_"^"_eprNum_"^"_divStateServer
	Quit $$$OK
}

}
