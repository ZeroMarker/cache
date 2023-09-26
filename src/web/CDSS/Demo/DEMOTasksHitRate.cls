/// 名称:     web.CDSS.Demo.DEMOTasksHitRate.cls
/// 描述:     疑似诊断评测工具-目录界面-任务集命中率
/// 编写者：  杨继鸿
/// 编写日期: 2022-02-15
Class web.CDSS.Demo.DEMOTasksHitRate Extends %RegisteredObject
{

/// id 任务集ID号 hitRate 命中率
/// w ##class(web.CDSS.Demo.DEMOTasksHitRate).SaveData("2", "0.6")
/// 可以加入Entity，做保存日志所用
ClassMethod SaveData(taskid As %String = "", hitRate As %String) As %String
{
	s $zt="ERROE"
	s result={}
	
	s nowDate=$p($h,",",1)	//当前日期对应数字
	
	if (taskid="") & (hitRate="")
	{
		d result.%Set("success", 0)
		d result.%Set("errorinfo", "传入的任务集ID或命中率为空！")
	}
	else
	{
		s id=0
		s hasRecordFlag=0
		//查找是否有同一天数据
		for
		{
			s id=$o(^WDT.CDSS.DEMOTasksHitRateI("TaskIndex", taskid, id), 1)
			q:id=""
			
			s preTime=$lg($g(^WDT.CDSS.DEMOTasksHitRateD(id)),4)	//时间
			if preTime=nowDate
			{
				s hasRecordFlag=1
				q 
			}
		}
		if hasRecordFlag=1
		{
			//修改数据
			s obj=##class(WDT.CDSS.DEMOTasksHitRate).%OpenId(id)
		}
		else
		{
			//新增数据
			s obj=##class(WDT.CDSS.DEMOTasksHitRate).%New()
			
			d obj.TaskDRSetObjectId(taskid)	//指向病历任务集WDT.CDSS.DEMOTasks
			s obj.PrevHitRateTime=nowDate	//保存当前日期
		}
		s obj.PrevHitRate=hitRate	//命中率
		
		
		TS
		
		s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
	        s rowid=obj.%Id()
	        TC
	        d result.%Set("success", 1)
	        d result.%Set("id", rowid)
        }
        else
        {
	        TRO
	        d result.%Set("success", 0)
	        d result.%Set("errorinfo", "保存命中率记录失败，原因如下：<br>"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc))
        }
	}
	q result.%ToJSON()
ERROE
	d result.%Set("success", 0)
	d result.%Set("errorinfo", "ERROR数据保存失败！")
	q result.%ToJSON()
}

/// w ##class(web.CDSS.Demo.DEMOTasksHitRate).DeleteData("1")
/// taskid 任务集ID rowid 任务集命中率ID
ClassMethod DeleteData(taskid As %String, rowid As %String = "") As %String
{
	s $zt="DeleteDataERROE"
	s result={}
	s id=""
	s flag=0
	
	TS
	for
	{
		s id=$o(^WDT.CDSS.DEMOTasksHitRateI("TaskIndex", taskid, id), 1)
		q:id=""
		
		s sc=##class(WDT.CDSS.DEMOTasksHitRate).%DeleteId(id)
	    if $$$ISOK(sc)
	    {
		    continue
	    }
	    else
	    {
		    s flag=1
		    d result.%Set("errorinfo", "删除命中率记录失败，原因如下：<br>"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc))
		    Quit
	    }
	}
	if flag=1
	{
		TRO
		d result.%Set("success", 0)
	}
	else
	{
		TC
		d result.%Set("success", 1)
	}
	q result.%ToJSON()
DeleteDataERROE
	d result.%Set("success", 0)
	d result.%Set("errorinfo", "DeleteDataERROE删除数据失败！")
	q result.%ToJSON()
}

/// Creator：      杨继鸿
/// CreatDate：    2022-02-16
/// Description:   默认返回最新的一条记录、查询病历任务集命中率最近一次的数据
/// Table：        WDT.CDSS.DEMOTasksHitRate
/// Input：        time 既往时间yyyy-mm-dd
/// Output：       ID,TaskID,PrevHitRate,PrevHitRateTime
/// Return：       任务集命中率数据
/// Others：       d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DEMOTasksHitRate","GetDataList","35","")
Query GetDataList(taskid As %String, time As %String = "") As %Query(ROWSPEC = "ID,TaskID,PrevHitRate,PrevHitRateTime,HitRate,HitRateTime,Effect")
{
}

ClassMethod GetDataListExecute(ByRef qHandle As %Binary, taskid As %String, time As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if time=""
	{
		s id=0
		for{
		s id=$o(^WDT.CDSS.DEMOTasksHitRateI("TaskIndex",taskid,id))
		q:id=""
		s PrevHitRateTime=$lg($g(^WDT.CDSS.DEMOTasksHitRateD(id)),4)	//时间
		//s id=$o(^WDT.CDSS.DEMOTasksHitRateI("TaskIndex", taskid, ""), -1)	//此任务集的最新一条数据
		if id'=""
		{
			/*s ID=id
			s TaskID=$lg($g(^WDT.CDSS.DEMOTasksHitRateD(id)),2)	//任务集ID
			s PrevHitRate=$lg($g(^WDT.CDSS.DEMOTasksHitRateD(id)),3)	//命中率
			s PrevHitRateTime=$lg($g(^WDT.CDSS.DEMOTasksHitRateD(id)),4)	//时间
			s PrevHitRateTime=$zd(PrevHitRateTime,3)
			s HitRate=PrevHitRate
			s HitRateTime=PrevHitRateTime
			s Effect="0%"*/
			
			s ID=id
			s TaskID=$lg($g(^WDT.CDSS.DEMOTasksHitRateD(id)),2)	//任务集ID
			s PrevHitRate=$lg($g(^WDT.CDSS.DEMOTasksHitRateD(id)),3)	//命中率
			s PrevHitRateTime=$zd(PrevHitRateTime,3)
				
			s latestID=$o(^WDT.CDSS.DEMOTasksHitRateI("TaskIndex", taskid, ""), -1)
			s HitRate=$lg($g(^WDT.CDSS.DEMOTasksHitRateD(latestID)),3)	//获取最新命中率
			s HitRateTime=$zd($lg($g(^WDT.CDSS.DEMOTasksHitRateD(latestID)),4),3)
				
			s Effect=(HitRate-PrevHitRate)*100_"%"
			d OutputTasksHitRateRow	
		}
		}	
	}
	else
	{
		s getDataFlag=0
		s time=$zdh(time, 3)
		s id=""
		for
		{
			s id=$o(^WDT.CDSS.DEMOTasksHitRateI("TaskIndex", taskid, id), -1)
			q:((id="") || (getDataFlag=1))
			
			s PrevHitRateTime=$lg($g(^WDT.CDSS.DEMOTasksHitRateD(id)),4)	//时间
			
			if (PrevHitRateTime<=time)
			{
				s ID=id
				s TaskID=$lg($g(^WDT.CDSS.DEMOTasksHitRateD(id)),2)	//任务集ID
				s PrevHitRate=$lg($g(^WDT.CDSS.DEMOTasksHitRateD(id)),3)	//命中率
				s PrevHitRateTime=$zd(PrevHitRateTime,3)
				
				s latestID=$o(^WDT.CDSS.DEMOTasksHitRateI("TaskIndex", taskid, ""), -1)
				s HitRate=$lg($g(^WDT.CDSS.DEMOTasksHitRateD(latestID)),3)	//获取最新命中率
				s HitRateTime=$zd($lg($g(^WDT.CDSS.DEMOTasksHitRateD(latestID)),4),3)
				
				s Effect=(HitRate-PrevHitRate)*100_"%"
				d OutputTasksHitRateRow
				s getDataFlag=1
			}
		}
		if getDataFlag=0
		{
			//遍历了所有记录，还没有数据；说明选定时间早于所有记录的数据，选择第一条数据返回
			s id=$o(^WDT.CDSS.DEMOTasksHitRateI("TaskIndex", taskid, ""), 1)
			if id'=""
			{
				s ID=id
				s TaskID=$lg($g(^WDT.CDSS.DEMOTasksHitRateD(id)),2)	//任务集ID
				s PrevHitRate=$lg($g(^WDT.CDSS.DEMOTasksHitRateD(id)),3)	//命中率
				s PrevHitRateTime=$lg($g(^WDT.CDSS.DEMOTasksHitRateD(id)),4)	//时间
				s PrevHitRateTime=$zd(PrevHitRateTime,3)
				
				s latestID=$o(^WDT.CDSS.DEMOTasksHitRateI("TaskIndex", taskid, ""), -1)
				s HitRate=$lg($g(^WDT.CDSS.DEMOTasksHitRateD(latestID)),3)	//获取最新命中率
				s HitRateTime=$zd($lg($g(^WDT.CDSS.DEMOTasksHitRateD(latestID)),4),3)
				
				s Effect=(HitRate-PrevHitRate)*100_"%"				
				d OutputTasksHitRateRow
			}
		}
	}
 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputTasksHitRateRow
    set ^CacheTemp(repid,ind)=$lb(ID,TaskID,PrevHitRate,PrevHitRateTime,HitRate,HitRateTime,Effect)
    Set ind=ind+1
    quit
}

ClassMethod GetDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)

	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取任务集ID、关联任务集详情ID、关联的IDNO
/// w ##class(web.CDSS.Demo.DEMOTasksHitRate).GetAllTaskDetails("3")
ClassMethod GetAllTaskDetails(taskid As %String = "") As %String
{
	s id=""
	s result={}
	
	if taskid'=""
	{
		for
		{
			s id=$o(^WDT.CDSS.DEMOTasksDetailI("TaskIndex", taskid, id), 1)
			q:id=""
			
			s taskDR=$lg($g(^WDT.CDSS.DEMOTasksDetailD(id)), 3)
			s patientDR=$lg($g(^WDT.CDSS.DEMOTasksDetailD(id)), 2)
			s idno=$lg($g(^WDT.CDSS.DEMOPatMasterD(patientDR)), 2)
			
			s tempValue=result.%Get(taskDR)
			if tempValue=""
			{
				d result.%Set(taskDR, id_":"_idno)
			}
			else
			{
				d result.%Set(taskDR, tempValue_"^"_id_":"_idno)
			}
		}
	}
	else
	{
		for
		{
			s id=$o(^WDT.CDSS.DEMOTasksDetailD(id), 1)
			q:id=""
			
			s taskDR=$lg($g(^WDT.CDSS.DEMOTasksDetailD(id)), 3)
			s patientDR=$lg($g(^WDT.CDSS.DEMOTasksDetailD(id)), 2)
			s idno=$lg($g(^WDT.CDSS.DEMOPatMasterD(patientDR)), 2)

			s tempValue=result.%Get(taskDR)
			if tempValue=""
			{
				d result.%Set(taskDR, id_":"_idno)
			}
			else
			{
				d result.%Set(taskDR, tempValue_"^"_id_":"_idno)
			}
		}
	}
	q result.%ToJSON()
}

/// Creator：      杨继鸿
/// CreatDate：    2022-02-17
/// Description:   导出所有任务集命中率变化
/// Table：        WDT.CDSS.DEMOTasksHitRate
/// Output：       ID,TaskID,PrevHitRate,PrevHitRateTime
/// Return：       任务集命中率数据
/// Others：       d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DEMOTasksHitRate","ExportDataList","")
Query ExportDataList(taskid As %String = "") As %Query(ROWSPEC = "TaskName,TaskTarget,InitialHitRate,HitRate,Effect,CreateTime,CreateUser")
{
}

ClassMethod ExportDataListExecute(ByRef qHandle As %Binary, taskid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1


	s ID=0
	for
	{
		s ID=$o(^WDT.CDSS.DEMOTasksD(ID))
		q:ID=""
		s TaskName=$lg($g(^WDT.CDSS.DEMOTasksD(ID)),2)
		s TaskTarget=$lg($g(^WDT.CDSS.DEMOTasksD(ID)),3)
		s CreateTime=$lg($g(^WDT.CDSS.DEMOTasksD(ID)),6)
		
		s HitRate=$lg($g(^WDT.CDSS.DEMOTasksD(ID)),7)	//命中率
		s InitialHitRate=$lg($g(^WDT.CDSS.DEMOTasksD(ID)),8)	//命中率
		
		s Effect=(HitRate-InitialHitRate)*100_"%"
		
		if (ID=taskid) || (taskid="")
		{
			s CreateUser=$lg($g(^WDT.CDSS.DEMOTasksD(ID)),5)	// 创建人员
			d OutputTaskEffect
		}
	} 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputTaskEffect
    set ^CacheTemp(repid,ind)=$lb(TaskName,TaskTarget,InitialHitRate,HitRate,Effect,CreateTime,CreateUser)
    Set ind=ind+1
    quit
}

ClassMethod ExportDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ExportDataListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)

	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ExportDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ExportDataListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
