/// 该类停用，保存日志在dll中完成 -- 2009/11/17 by houj 
Class web.eprajax.logs.save Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	set episodeID = $Get(%request.Data("episodeID", 1), "-1")
	set eprDocID = $Get(%request.Data("printTemplateDocId", 1), "-1")
	set eprNum = $Get(%request.Data("EPRNum", 1), "-1")
	set templateDocID = $Get(%request.Data("templateDocId", 1), "-1")
	
	set happenDate =  $ZDH($Get(%request.Data("happenDate", 1), "-1"), 3)		
	set happenTime = $ZTH($Get(%request.Data("happenTime", 1), "-1"), 1)		
		
	//根据唯一界面模板所属病历类型判断其EPRNum
	//1 表示属于科研病历和可重复打印病历
	//2 表示属于唯一打印病历
	//s eprNum = ##class(EPRservice.BOEPRLogs).GetSingleEPRNumByDocType(printTemplateDocId)
	set printType = ##class(EPRservice.EPRDoc.DocCategoryFunSet).GetPrtDocType(eprDocID)
	if (printType="")||(printType="Multiple")
	{
		//挂载在科研病历或可重复打印病历下
		s eprNum = "0"
	}
	else
	{
		//挂载在唯一打印病历下
		s eprNum = "1"
	}
	
	if (printType="Multiple")
	{
		//挂载在可重复打印病历下的所有唯一模板都为非必填，状态直接设为"complete"
		s action = "complete"
	}
	else
	{
		set action = ##class(EPRmeta.EPRAction).GetSaveType(episodeID, eprDocID)
		set:(action = 1) action = "complete"
		set:(action = 0) action = "save"
	}	
	
	set IP = $ZUtil(67, 15, $Job)
	set userID = %session.Get("LOGON.USERID")
	set type = "Single"
		
	set logID = ##class(EPRinstance.EPRLogs).GetLogID(episodeID, eprDocID, eprNum)
	if (logID = "")		//若为保存第一个界面模板
	{
			
		if eprNum = "1"	
		{	set logID = ##class(EPRinstance.EPRLogs).CreateEPRLog(episodeID,eprDocID,action,IP,userID,happenDate,happenTime)}
		else
		{	set logID = ##class(EPRinstance.EPRLogs).CreateSpecialEPRLog(episodeID,eprDocID,action,IP,userID,happenDate,happenTime)}
		if logID = "0"
		{
			write "Create Log Error"
			Quit $$$OK
		}
	}
	else
	{
		s status = ##class(EPRinstance.EPRLogs).UpdateEPRLogForSaveAction(logID,action,IP,userID,type,"","")
		if (status = "0")
		{
			w "Update Log Error"
			Quit $$$OK
		}	
		
	}
	
	s currState = ##class(EPRinstance.EPRLogs).GetEPRStatus(episodeID, eprDocID, eprNum)
	
	s divStateServer = ##class(EPRinstance.EPRLogs).GetCurrStatus(episodeID, eprDocID, eprNum)
	w "success^"_divStateServer_"^"_logID_"^"_currState
	Quit $$$OK
}

}
