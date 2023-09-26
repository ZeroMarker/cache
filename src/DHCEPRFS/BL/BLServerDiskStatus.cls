Class DHCEPRFS.BL.BLServerDiskStatus Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Debug w ##class(DHCEPRFS.BL.BLServerDiskStatus).Estimation("2")
ClassMethod Estimation(ADiskID As %String) As %String
{
	s rowIDList = ""
	//当前最后一条记录
	s sequenceNow = ""
	s sequenceNow = $o(^DHCEPRFS.INST.ServerDiskSI("IdxSequence"," "_ADiskID,sequenceNow),-1)
	q:(sequenceNow = "") ""
	s rowIDNow = $o(^DHCEPRFS.INST.ServerDiskSI("IdxSequence"," "_ADiskID,sequenceNow,""))
	
	//从有记录开始，取记录总数，(rowID连续)从中平分取10次记录，计算每日增长平均值
	//第一次记录
	s sequenceFirst = ""
	s sequenceFirst = $o(^DHCEPRFS.INST.ServerDiskSI("IdxSequence"," "_ADiskID,sequenceFirst))
	q:(sequenceFirst = "") ""
	
	s sequenceRange = (+sequenceNow) - (+sequenceFirst)
	//除10取整
	s oneSequenceRange = +((+sequenceRange)\10)
	s sequence = ""
	for {
		s sequence = $o(^DHCEPRFS.INST.ServerDiskSI("IdxSequence"," "_ADiskID,sequence))
		q:(sequence = "")
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.INST.ServerDiskSI("IdxSequence"," "_ADiskID,sequence,rowID))
			q:(rowID = "")
			if (rowIDList = "")
			{
				s rowIDList = rowID
			}
			else
			{
				s rowIDList = rowIDList_"^"_rowID
			}
			q
		}
		s sequence = sequence + (+oneSequenceRange)
	}
	s rowIDList = rowIDList_"^"_rowIDNow
	
	s count = $l(rowIDList,"^")
	s averageDay = 0
	s average = 0
	s dateLast = 0
	s usedLast = 0
	for index=1:1:count
	{
		s oneRowID = $p(rowIDList,"^",index)
		s obj = ##class(DHCEPRFS.INST.ServerDiskStatus).%OpenId(oneRowID)
		s used = obj.DiskUsed
		s date = obj.RecordDate	
		//b "s"
		if (dateLast '= 0)
		{
			if ((date - dateLast) > 0)
			{
				s averageDay = (((+used) - (+usedLast))/(date-dateLast)) 
				if (average = 0)
				{
					s average = averageDay
				}
				else
				{
					s average = ((average + averageDay)/2)
				}	
			}
		}
		s dateLast = date
		s usedLast = used
	}
	
	s objNow = ##class(DHCEPRFS.INST.ServerDiskStatus).%OpenId(rowIDNow)
	s free = objNow.DiskFreeSpace
	
	s days = 0
	s date = 0
	if (average >0)
	{
		//取整天
		s days = free \average
		s date = $zd(($p($h,",",1) + days),3)
	}
	q days_"^"_date
}

/// Debug do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLServerDiskStatus","GetTrend","2","year","2014-05-01|2014-05-31^2014-06-01|2014-06-30^2014-07-01|2014-07-31^2014-08-01|2014-08-31^2014-09-01|2014-09-30^2014-10-01|2014-10-31^2014-11-01|2014-11-30^2014-12-01|2014-12-31^2015-01-01|2015-01-31^2015-02-01|2015-02-28^2015-03-01|2015-03-31^2015-04-01|2015-04-11")
Query GetTrend(ADiskID As %String, AType As %String, ADay As %String) As %Query(ROWSPEC = "X:%String,Y:%String")
{
}

ClassMethod GetTrendExecute(ByRef qHandle As %Binary, ADiskID As %String, AType As %String, ADay As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	//分时图，一天24个小时，以小时为单位，取当天0点到现在的数据
	if (AType = "hour")
	{
		s date = $p($h,",",1)
		s time = ""
		s time0 = 0
		for {
			//b "s"
			s time = $o(^DHCEPRFS.INST.ServerDiskSI("IdxDateTime"," "_ADiskID,date,time))
			q:(time = "")
			if (time0 = 0)
			{
				s time0 = time	
				s rowID = $o(^DHCEPRFS.INST.ServerDiskSI("IdxDateTime"," "_ADiskID,date,time,""))
				s obj = ##class(DHCEPRFS.INST.ServerDiskStatus).%OpenId(rowID)
				s Used = obj.DiskUsed
				s Size = obj.DiskSize
				s Date = obj.RecordDate
				s Time = obj.RecordTime
				if ((Time '= "") && (Time '=$c(0)))
				{
					s Time = $zt(Time)	
				}
				s ^CacheTemp(repid,ind) = $lb(Time,Used)
	    		s ind=ind+1	
			}
			else
			{
				//小于一小时则continue
				if ((time - time0) < 3600)
				{
					continue
				}
				else
				{
					s time0 = time
					s rowID = $o(^DHCEPRFS.INST.ServerDiskSI("IdxDateTime"," "_ADiskID,date,time,""))
					s obj = ##class(DHCEPRFS.INST.ServerDiskStatus).%OpenId(rowID)
					s Used = obj.DiskUsed
					s Size = obj.DiskSize
					s Date = obj.RecordDate
					s Time = obj.RecordTime
					if ((Time '= "") && (Time '=$c(0)))
					{
						s Time = $zt(Time)	
					}
					s ^CacheTemp(repid,ind) = $lb(Time,Used)
	    			s ind=ind+1	
				}
			}
		}	
	}
	//分日图，ADay表示是最近几日
	//月的情况相同，ADay表示是最近几日
	elseif ((AType = "day")	|| (AType = "month"))
	{
		s ADay = +ADay
		s date = $p($h,",",1)
		s dateStart = date - ADay + 1
		//取当日最后一次磁盘使用情况
		for {
			q:(dateStart > date)
			//b "s"
			s time = $o(^DHCEPRFS.INST.ServerDiskSI("IdxDateTime"," "_ADiskID,dateStart,""),-1)
			if (time = "")
			{
				//当天没数据，则下一天
				s dateStart = dateStart + 1
				continue
			}
			s rowID = $o(^DHCEPRFS.INST.ServerDiskSI("IdxDateTime"," "_ADiskID,dateStart,time,""))
			q:(rowID = "")
			s obj = ##class(DHCEPRFS.INST.ServerDiskStatus).%OpenId(rowID)
			s Used = obj.DiskUsed
			s Size = obj.DiskSize
			s Date = obj.RecordDate
			s Time = obj.RecordTime
			if ((Date '= "") && (Date '=$c(0)))
			{
				s Date = $zd(Date)	
			}
			s ^CacheTemp(repid,ind) = $lb(Date,Used)
	    	s ind=ind+1	
			s dateStart = dateStart + 1
		}
	}
	//分月图，从一月开始统计，ADay表示是最近几个月，
	elseif (AType = "year")
	{
		s ADayList = ADay
		s count = $l(ADayList,"^")
		for index=1:1:count
		{
			s date = $p(ADayList,"^",index)
			s dateStart = $p(date,"|",1)
			s dateEnd = $p(date,"|",2)
			s dateStart = $zdh(dateStart,3)
			s dateEnd = $zdh(dateEnd,3)

			for {
				s time = $o(^DHCEPRFS.INST.ServerDiskSI("IdxDateTime"," "_ADiskID,dateEnd,""),-1)
				if (time = "")
				{
					//当天没数据，则上一日的，直到这个月的一日若还没有数据则当月没数据不显示
					s dateEnd = dateEnd - 1
					q:(dateEnd = dateStart)
					continue
				}
				s rowID = $o(^DHCEPRFS.INST.ServerDiskSI("IdxDateTime"," "_ADiskID,dateEnd,time,""))
				q:(rowID = "")
				s obj = ##class(DHCEPRFS.INST.ServerDiskStatus).%OpenId(rowID)
				s Used = obj.DiskUsed
				s Size = obj.DiskSize
				s Date = obj.RecordDate
				s Time = obj.RecordTime
				if ((Date '= "") && (Date '=$c(0)))
				{
					s Date = $zd(Date)	
				}
				s ^CacheTemp(repid,ind) = $lb(Date,Used)
	    		s ind=ind+1	
	    		q
			}
		}	
	}
	Quit $$$OK
}

ClassMethod GetTrendClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTrendExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTrendFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTrendExecute ]
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

ClassMethod GetNewestDiskByID(ADiskID As %String) As %String
{
	s rowID = ""

	s rowID = $o(^DHCEPRFS.INST.ServerDiskSI("IdxServerDiskID"," "_ADiskID,rowID),-1)
	q:(rowID = "") ""
	s obj = ##class(DHCEPRFS.INST.ServerDiskStatus).%OpenId(rowID)
	s ret = obj.DiskFreeSpace_"^"_obj.DiskSize
	q ret
}

/// Debug do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQueryUser","GetHISUser","zyys001","","","")
Query GetMonitorDiskList() As %Query(ROWSPEC = "ID:%String,DiskDesc:%String,DiskName:%String,DiskDrive:%String,ServerIP:%String,ServerDesc:%String,ServerName:%String")
{
}

ClassMethod GetMonitorDiskListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.META.ServerDiskD(rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.META.ServerDisk).%OpenId(rowID)
		s diskDesc = obj.DiskDesc
		s diskName = obj.DiskName
		s diskDrive = obj.DiskDrive
		s serverIP = obj.ServerIP
		s serverDesc = obj.ServerDesc
		s serverName = obj.ServerName	
		
		s ^CacheTemp(repid,ind) = $lb(rowID,diskDesc,diskName,diskDrive,serverIP,serverDesc,serverName)
	    s ind=ind+1	
	}	
	Quit $$$OK
}

ClassMethod GetMonitorDiskListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMonitorDiskListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMonitorDiskListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMonitorDiskListExecute ]
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

/// debug: d ##class(DHCEPRFS.BL.BLServerDiskStatus).AddServerDiskStatus
ClassMethod AddServerDiskStatus(AServerDiskID As %String, ADiskSize As %String, ADiskFreeSpace As %String, ADiskUsed As %String) As %String
{
	s sequence = ""
	s sequence = $o(^DHCEPRFS.INST.ServerDiskSI("IdxSequence"," "_AServerDiskID,sequence),-1)
	s:(sequence = "") sequence = 0
	
	s obj = ##class(DHCEPRFS.INST.ServerDiskStatus).%New()
	s obj.RecordDate = $p($h,",",1)
	s obj.RecordTime = $p($h,",",2)	
	s obj.ServerDiskID = AServerDiskID
	s obj.DiskSize = ADiskSize
	s obj.DiskFreeSpace = ADiskFreeSpace
	s obj.DiskUsed = ADiskUsed
	s obj.Sequence = (+sequence)+1
	s status = obj.%Save()
	q:($$$ISOK(status)) obj.%Id()
	q "-1"
}

/// Desc:	根据制定IP获取监控器盘符
/// Debug:	w ##class(DHCEPRFS.BL.BLServerDiskStatus).GetMonitorDiskDrive("127.0.0.1")
ClassMethod GetMonitorDiskDrive(AIPAddress As %String) As %String
{
	s rowID = ""
	s diskDrive = ""
	s rowID = $o(^DHCEPRFS.META.ServerDiskI("IdxMain"," "_AIPAddress,rowID))
	q:(rowID = "") ""
	s obj = ##class(DHCEPRFS.META.ServerDisk).%OpenId(rowID)
	s diskDrive = obj.DiskDrive
	if ((obj.DiskDrive'="")&&($e(obj.DiskDrive,*)'=":"))
	{
		s diskDrive = obj.DiskDrive_":"
	}
	s ret = rowID_"^"_diskDrive

	q ret
}

}
