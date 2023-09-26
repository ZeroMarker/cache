Class DHCEPRFS.BL.BLMonitoring Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:更新生成服务器状态
/// Debug: w ##Class(DHCEPRFS.BL.BLMonitoring).UpdateServerStatue("192.168.0.10","OLD","CREATE","WORKING")
ClassMethod UpdateServerStatue(AIP As %String, ATaskType As %String, AServer As %String, AType As %String) As %String
{
	s result = -1
	s:(ATaskType = $c(0)) ATaskType = ""
	q:(AIP = "") result
	s rowID = $o(^DHCEPRFS.META.CreateServersI("IdxIP"," "_AIP,""))
	if (rowID = "")
	{
		s obj = ##Class(DHCEPRFS.META.CreateServers).%New()
	}
	else
	{
		s obj = ##Class(DHCEPRFS.META.CreateServers).%OpenId(rowID)	
	}
	s now = $h
	s obj.TaskDate = $P(now, ",", 1)
	s obj.TaskTime = $P(now, ",", 2)
	s obj.TaskType = ATaskType
	s obj.ServerType = AServer
	s obj.IP = AIP
	s obj.Type = AType
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = 1
	q result
}

/// Desc:记录服务器工作日志
/// Debug: w ##Class(DHCEPRFS.BL.BLMonitoring).AddServerLog("127.0.0.1","NORMAL","500306","CREATE","START")
ClassMethod AddServerLog(AIP As %String, ATaskType As %String, AEpisodeID As %String, AServer As %String, AStatus As %String) As %String
{
	s result = -1
	s:(ATaskType = $c(0)) ATaskType = ""
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	s:(AServer = $c(0)) AServer = ""
	s:(AStatus = $c(0)) AStatus = ""
	q:(AIP = "") result
	
	s obj = ##Class(DHCEPRFS.INST.CreateServersLog).%New()
	s now = $h
	s obj.TaskDate = $P(now, ",", 1)
	s obj.TaskTime = $P(now, ",", 2)
	s obj.TaskType = ATaskType
	s obj.EpisodeID = AEpisodeID
	s obj.ServerType = AServer
	s obj.IP = AIP
	s obj.ServerStatus = AStatus
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = 1
	q result
}

/// 获取执行成功队列列表
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMonitoring","GetAllIPList","CREATE")
Query GetAllIPList(AServerAction As %String) As %Query(ROWSPEC = "IP:%String,TaskType:%String,TaskDateDiff:%String,TaskTimeDiff:%String,TaskDate:%String,TaskTime:%String,Type:%String")
{
}

ClassMethod GetAllIPListExecute(ByRef qHandle As %Binary, AServerAction As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	q:(AServerAction="") $$$OK
 	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.META.CreateServersI("IdxServerType"," "_AServerAction,rowID))
		q:(rowID="")
		
			//b "s"
		s obj = ##class(DHCEPRFS.META.CreateServers).%OpenId(rowID)
		s IP = obj.IP
		s TaskType = obj.TaskType
		s TaskDateDiff = $P($h, ",", 1)-obj.TaskDate
		s TaskTimeDiff = $P($h, ",", 2)-obj.TaskTime
		s TaskDate = $zd(obj.TaskDate,3)
		s TaskTime = $zt(obj.TaskTime,1)
		s Type = obj.Type
		
		s data = $lb(IP,TaskType,TaskDateDiff,TaskTimeDiff,TaskDate,TaskTime,Type)
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	Quit $$$OK
}

ClassMethod GetAllIPListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllIPListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllIPListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllIPListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// 获取执行成功队列列表
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMonitoring","GetIPLogList","127.0.0.1")
Query GetIPLogList(AIP As %String) As %Query(ROWSPEC = "IP:%String,TaskDate:%String,TaskTime:%String,TaskType:%String,ServerType:%String,EpisodeID:%String,Status:%String")
{
}

ClassMethod GetIPLogListExecute(ByRef qHandle As %Binary, AIP As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	q:(AIP="") $$$OK
 	
	s rowIDDate = ""
	for {
		s rowIDDate = $o(^DHCEPRFS.INST.CreateServersLogI("IdxMain"," "_AIP,rowIDDate),-1)
		q:(rowIDDate="")
		s rowIDTime = ""
		for {
			s rowIDTime = $o(^DHCEPRFS.INST.CreateServersLogI("IdxMain"," "_AIP,rowIDDate,rowIDTime),-1)
			q:(rowIDTime = "")
			
			s rowID = ""
			for {
				s rowID = $o(^DHCEPRFS.INST.CreateServersLogI("IdxMain"," "_AIP,rowIDDate,rowIDTime,rowID))
				q:(rowID ="")
		
				s obj = ##class(DHCEPRFS.INST.CreateServersLog).%OpenId(rowID)
				s TaskDate = obj.TaskDate
				if (TaskDate '= "") 
				{
					s TaskDate = $zd(TaskDate,3)
				}
				s TaskTime = obj.TaskTime
				if (TaskTime '= "") 
				{
					s TaskTime = $zt(TaskTime,1)
				}
				s TaskType = obj.TaskType
				if (TaskType = "ERROR")
				{
					s TaskType = "错误重生成"
				}
				elseif (TaskType = "OLD")
				{
					s TaskType = "老病历生成"
				}
				elseif (TaskType = "GREEN")
				{
					s TaskType = "绿色通道生成"
				}
				elseif (TaskType = "SPECIAL")
				{
					s TaskType = "特殊生成"
				}
				elseif (TaskType = "NORMAL")
				{
					s TaskType = "正常生成"
				}
				s ServerType = obj.ServerType
				if (ServerType ="CREATE")
				{
					s ServerType ="生成"
				}
				s EpisodeID = obj.EpisodeID
				s IP = obj.IP
				s Status = obj.ServerStatus
				if (Status = "START")
				{
					s Status = "开始"
				}
				elseif (Status = "FALSE")
				{
					s Status = "错误"
				}	
				elseif (Status = "FINISH")
				{
					s Status = "结束"
				}
				s data = $lb(IP,TaskDate,TaskTime,TaskType,ServerType,EpisodeID,Status)
				s ^CacheTemp(repid,ind)=data
				s ind=ind+1 
			}
		}
	}
	Quit $$$OK
}

ClassMethod GetIPLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIPLogListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetIPLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIPLogListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// 获取某时间段的生成服务器的工作日志
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMonitoring","GetIPLogListByDate","127.0.0.1","2016-03-03","2017-05-05")
Query GetIPLogListByDate(AIP As %String, AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "IP:%String,TaskDate:%String,TaskTime:%String,TaskType:%String,ServerType:%String,EpisodeID:%String,Status:%String")
{
}

ClassMethod GetIPLogListByDateExecute(ByRef qHandle As %Binary, AIP As %String, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	q:(AIP="") $$$OK
 	q:(AStartDate="") $$$OK
 	q:(AEndDate="") $$$OK
 	s AEndDate = $zdh(AEndDate,3)
 	s AStartDate = $zdh(AStartDate,3)
	
	for rowIDDate = AEndDate:-1:AStartDate
	{
		s rowIDTime = ""
		for {
			s rowIDTime = $o(^DHCEPRFS.INST.CreateServersLogI("IdxMain"," "_AIP,rowIDDate,rowIDTime),-1)
			q:(rowIDTime = "")
			
			s rowID = ""
			for {				
				s rowID = $o(^DHCEPRFS.INST.CreateServersLogI("IdxMain"," "_AIP,rowIDDate,rowIDTime,rowID))
				q:(rowID ="")
		
				s obj = ##class(DHCEPRFS.INST.CreateServersLog).%OpenId(rowID)
				s TaskDate = obj.TaskDate
				if (TaskDate '= "") 
				{
					s TaskDate = $zd(TaskDate,3)
				}
				s TaskTime = obj.TaskTime
				if (TaskTime '= "") 
				{
					s TaskTime = $zt(TaskTime,1)
				}
				s TaskType = obj.TaskType
				if (TaskType = "ERROR")
				{
					s TaskType = "错误重生成"
				}
				elseif (TaskType = "OLD")
				{
					s TaskType = "老病历生成"
				}
				elseif (TaskType = "GREEN")
				{
					s TaskType = "绿色通道生成"
				}
				elseif (TaskType = "SPECIAL")
				{
					s TaskType = "特殊生成"
				}
				elseif (TaskType = "NORMAL")
				{
					s TaskType = "正常生成"
				}
				s ServerType = obj.ServerType
				if (ServerType ="CREATE")
				{
					s ServerType ="生成"
				}
				s EpisodeID = obj.EpisodeID
				s IP = obj.IP
				s Status = obj.ServerStatus
				if (Status = "START")
				{
					s Status = "开始"
				}
				elseif (Status = "FALSE")
				{
					s Status = "错误"
				}	
				elseif (Status = "FINISH")
				{
					s Status = "结束"
				}
				s data = $lb(IP,TaskDate,TaskTime,TaskType,ServerType,EpisodeID,Status)
				s ^CacheTemp(repid,ind)=data
				s ind=ind+1 
			}
		}
	}
	Quit $$$OK
}

ClassMethod GetIPLogListByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIPLogListByDateExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetIPLogListByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIPLogListByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:把服务器类型更新到指定类型，比如把正常生成服务器改成绿色通道服务器
/// Debug: w ##Class(DHCEPRFS.BL.BLMonitoring).ChangeTaskType("127.0.0.1","NORMAL")
ClassMethod ChangeTaskType(AIP As %String, ATaskType As %String) As %String
{
	s:(AIP = $c(0)) AIP = ""
	q:(AIP="") ""
	s rowID = ""
	s rowID = $o(^DHCEPRFS.META.CreateServersI("IdxIP"," "_AIP,rowID))
	q:(rowID="")
	s obj = ##class(DHCEPRFS.META.CreateServers).%OpenId(rowID)
	s taskType = obj.TaskType
	s now = $h
	s obj.TaskDate = $P(now, ",", 1)
	s obj.TaskTime = $P(now, ",", 2)
	s obj.TaskType = ATaskType
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q taskType
	}
	else
	{
		q "-1"
	}
}

/// Desc:把服务器类型更新到指定类型，比如把正常生成服务器改成绿色通道服务器
/// Debug: w ##Class(DHCEPRFS.BL.BLMonitoring).ChangeTask("127.0.0.1","NORMAL","CREEN")
ClassMethod ChangeTask(AIP As %String, AOldType As %String, ANewType As %String) As %String
{
	s $ZTRAP = "OnChangeTaskError"
	
	TSTART
	s:(AIP = $c(0)) AIP = ""
	q:(AIP="") ""
	s rowID = ""
	s rowID = $o(^DHCEPRFS.META.CreateServersI("IdxIP"," "_AIP,rowID))
	q:(rowID="")
	s obj = ##class(DHCEPRFS.META.CreateServers).%OpenId(rowID)
	s taskType = obj.TaskType
	s now = $h
	s obj.TaskDate = $P(now, ",", 1)
	s obj.TaskTime = $P(now, ",", 2)
	s obj.TaskType = ANewType
	s sc = obj.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q "0"
	}
	else
	{
		//修改系统参数
		s greenIPs = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("GreenChannelIP")
		s:(greenIPs = $c(0)) greenIPs = ""
		s greenIPs = ..DeleteIP(greenIPs, AIP)
		
		s errorIPs = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("ErrorRecreateIP")
		s:(errorIPs = $c(0)) errorIPs = ""
		s errorIPs = ..DeleteIP(errorIPs, AIP)
		
		s oldIPs = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("OldIP")
		s:(oldIPs = $c(0)) oldIPs = ""
		s oldIPs = ..DeleteIP(oldIPs, AIP)

		if (ANewType = "GREEN")
		{
			if (greenIPs = "")
			{
				s greenIPs = AIP	
			}	
			else
			{
				s greenIPs = greenIPs_"^"_AIP	
			}
			d ##class(DHCEPRFS.BL.BLSysOption).UpdateValueByName("GreenChannelIP",greenIPs)
		}
		elseif (ANewType = "ERROR")
		{
			if (errorIPs = "")
			{
				s errorIPs = AIP	
			}	
			else
			{
				s errorIPs = errorIPs_"^"_AIP	
			}
			d ##class(DHCEPRFS.BL.BLSysOption).UpdateValueByName("ErrorRecreateIP",errorIPs)
		}
		elseif (ANewType = "OLD")
		{
			if (oldIPs = "")
			{
				s oldIPs = AIP	
			}	
			else
			{
				s oldIPs = oldIPs_"^"_AIP	
			}
			d ##class(DHCEPRFS.BL.BLSysOption).UpdateValueByName("OldIP",oldIPs)
		}
		TCOMMIT
		q "1"
	}
OnChangeTaskError
	TROLLBACK
	q "0"
}

ClassMethod DeleteIP(AIPS As %String, AIP As %String) As %String
{
	s ret = ""
	for i=1:1:$l(AIPS,"^")
	{
		s oneIP = $p(AIPS,"^",i)
		if (oneIP '= AIP)
		{
			if (ret = "")
			{
				s ret = oneIP	
			}	
			else
			{
				s ret = ret_"^"_oneIP	
			}
		}
	}
	
	q ret
}

}
