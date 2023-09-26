Class DHCEPRFS.Srv.SrvMonitoring Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvMonitoring";

/// Desc:	更新生成服务器的状态
/// Input:	IP、TaskDate、TaskTime、TaskType
ClassMethod UpdateServerStatue(AIP As %String, ATaskType As %String, AServer As %String, AType As %String) As %String [ WebMethod ]
{
	s sc = ##class(DHCEPRFS.BL.BLMonitoring).UpdateServerStatue(AIP, ATaskType,AServer,AType)
	q sc
}

/// Desc:	记录生成服务器的日志
/// Input:	IP、CreateDate、CreateTime、CreateType、AEpisodeID
ClassMethod AddServerLog(AIP As %String, ACreateType As %String, AEpisodeID As %String, AServer As %String, AStatus As %String) As %String [ WebMethod ]
{
	s sc = ##class(DHCEPRFS.BL.BLMonitoring).AddServerLog(AIP, ACreateType,AEpisodeID,AServer,AStatus)
	q sc
}

/// Desc:	获取所有IP
ClassMethod GetAllIPList(AServerAction As %String) As %XML.DataSet [ WebMethod ]
{
	s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLMonitoring:GetAllIPList")
	d ds.SetArgs(AServerAction)
	q ds
}

/// Desc:	获取IP的日志
/// Input:  要查询的IP--AIP
ClassMethod GetIPLogList(AIP As %String) As %XML.DataSet [ WebMethod ]
{
	s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLMonitoring:GetIPLogList")
	d ds.SetArgs(AIP)
	q ds
}

/// Desc:	通过时间段获取IP的日志
/// Input:  要查询的IP--AIP   AStartDate --起始时间    AEndDate --结束时间 
ClassMethod GetIPLogListByDate(AIP As %String, AStartDate As %String, AEndDate As %String) As %XML.DataSet [ WebMethod ]
{
	s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLMonitoring:GetIPLogListByDate")
	d ds.SetArgs(AIP,AStartDate,AEndDate)
	q ds
}

/// Desc:把服务器类型更新到指定类型，比如把正常生成服务器改成绿色通道服务器
/// Debug: w ##Class(DHCEPRFS.BL.BLMonitoring).ChangeTaskType("127.0.0.1","NORMAL")
ClassMethod ChangeTaskType(AIP As %String, ATaskType As %String) As %String [ WebMethod ]
{
	s sc = ##class(DHCEPRFS.BL.BLMonitoring).ChangeTaskType(AIP, ATaskType)
	q sc
}

/// Desc:把服务器类型更新到指定类型，比如把正常生成服务器改成绿色通道服务器
/// Debug: w ##Class(DHCEPRFS.BL.BLMonitoring).ChangeTask("127.0.0.1","NORMAL","CREEN")
ClassMethod ChangeTask(AIP As %String, AOldType As %String, ANewType As %String) As %String [ WebMethod ]
{
	s sc = ##class(DHCEPRFS.BL.BLMonitoring).ChangeTask(AIP, AOldType, ANewType)
	q sc
}

}
