/// Creator:		yankai
/// Description:	日志服务类
Class DHCMA.CPW.LOG.LogTableSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	yankai
/// Desc:		自动清理日志任务(只保留最近一个月内的记录)
/// w ##class(DHCMA.CPW.LOG.LogTableSrv).AutoCleanLogTask()
ClassMethod AutoCleanLogTask() As %String
{
	Set sttDate = (+$h)-30
	Set xDate = ""
	For {
		Set xDate = $o(^DHCMA.CPW.LOG.LogTableI("IdxofOperDate",xDate))
		Quit:xDate>=sttDate
		
		Set xLogID = ""
		For {
			Set xLogID = $o(^DHCMA.CPW.LOG.LogTableI("IdxofOperDate",xDate,xLogID))
			Quit:xLogID=""
			
			&sql(DELETE FROM DHCMA_CPW_LOG.LogTable WHERE ID = :xLogID)	
		}
	}
	
	Quit "OK"
}

}
