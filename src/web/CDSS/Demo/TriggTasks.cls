/// Description: 操作识别词触发任务集表
/// Creator: 杨继鸿
/// CreatDate： 2022-03-17
/// Table： WDT.CDSS.TriggTasks
Class web.CDSS.Demo.TriggTasks Extends %RegisteredObject
{

/// Creator：杨继鸿
/// CreatDate: 2022-03-17
/// Description：查询方法
/// Input： rowid taskname tasktarget createtime 创建时间 
/// Output: RowId,TaskName,TaskTarget,CreateUser,CreateTime,DocumentType
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.Demo.TriggTasks","GetList","","","","")
Query GetList(rowid, taskname As %String, tasktarget As %String, createtime As %String) As %Query(ROWSPEC = "RowId,TaskName,TaskTarget,CreateUser,CreateTime,DocumentType")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, taskname As %String, tasktarget As %String, createtime As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if (rowid'="") //根据rowid返回该条记录
	{
		//RowId,SynSAbbre,SynSAbbrePYCode,SynSFullName,Operator,OperateTime,State,Remarks
		s RowId=rowid
		s TaskName=$LISTGET($G(^WDT.CDSS.TriggTasksD(RowId)),2)	// 任务名称
		s TaskTarget=$LISTGET($G(^WDT.CDSS.TriggTasksD(RowId)),3)		// 任务目的
		s CreateUser=$LISTGET($G(^WDT.CDSS.TriggTasksD(RowId)),4)		// 创建人员
		s CreateTime=$LISTGET($G(^WDT.CDSS.TriggTasksD(RowId)),5)			// 创建时间
		s DocumentType=$LISTGET($G(^WDT.CDSS.TriggTasksD(RowId)),6)			// 数据类型

		d OutputRow
	}
	else
	{
		s:taskname'="" taskname=$ZCONVERT(taskname,"U") //转换成大写
		s:tasktarget'="" tasktarget=$ZCONVERT(tasktarget,"U") //转换成大写
		s starttime=""
		s endtime=""
		if createtime'=""
		{
			s starttime=$p(createtime,"^",1)
			s endtime=$p(createtime,"^",2)
		}
		s CreateTime=""
		for
		{
			
			s CreateTime=$o(^WDT.CDSS.TriggTasksI("CreateTimeIndex",CreateTime),-1) q:CreateTime=""
			s RowId=""
			for {
				s RowId = $o(^WDT.CDSS.TriggTasksI("CreateTimeIndex",CreateTime,RowId)) q:RowId=""			
				s TaskName=$LISTGET($G(^WDT.CDSS.TriggTasksD(RowId)),2)		// 任务名称			
				continue:((taskname'="")&&($ZCONVERT(TaskName,"U")'[taskname))
				s TaskTarget=$LISTGET($G(^WDT.CDSS.TriggTasksD(RowId)),3)		// 任务目的
				continue:((tasktarget'="")&&($ZCONVERT(TaskTarget,"U")'[tasktarget))
				s CreateUser=$LISTGET($G(^WDT.CDSS.TriggTasksD(RowId)),4)		// 创建人员
				s CreateTime=$LISTGET($G(^WDT.CDSS.TriggTasksD(RowId)),5)			// 创建时间
				continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateTime,3)))
				continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateTime,3)))
				s DocumentType=$LISTGET($G(^WDT.CDSS.TriggTasksD(RowId)),6)			// 数据类型
				d OutputRow
			}
			
		}
	}
	

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowId,TaskName,TaskTarget,CreateUser,CreateTime,DocumentType)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
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

/// Creator：杨继鸿
/// CreatDate: 2022-03-17
/// Description：保存方法
/// Input： web.CDSSEntity.Demo.TriggTasks PatIDStr 选定的患者ID（ID,...,ID）
/// Output: success 成功true,失败false id 任务集ID errorinfo 错误原因
/// Other: d ##class(web.CDSS.Demo.TriggTasks).SaveData("")
ClassMethod SaveData(eobj As web.CDSSEntity.Demo.TriggTasks, PatIDStr As %String = "") As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(WDT.CDSS.TriggTasks).%New()	
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(WDT.CDSS.TriggTasks).%OpenId(eobj.RowId)
		    s bobj = ##class(web.CDSSEntity.Demo.TriggTasks).%New()
		    s bobj.TaskName = obj.TaskName
			s bobj.TaskTarget = obj.TaskTarget
			s bobj.CreateUser = obj.CreateUser
			s bobj.CreateTime = obj.CreateTime
			s bobj.DocumentType = obj.DocumentType
		}
		s obj.TaskName = eobj.TaskName
		s obj.TaskTarget = eobj.TaskTarget
		s obj.DocumentType = eobj.DocumentType
		s:$d(%session) obj.CreateUser=$g(%session.Data("LOGON.USERNAME"))
		s:'$d(%session) obj.CreateUser="Demo Group"
		s obj.CreateTime=$zdt($h,3)
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s id = obj.%Id()
			s savedetailrs=""
			s:PatIDStr'="" savedetailrs=##class(web.CDSS.Demo.TriggTasksDetail).BatchSaveData(id, PatIDStr) //保存患者任务集详情
			if savedetailrs["false"
			{
				TRO
				s result = "{success:'false',errorinfo:'"_savedetailrs_"'}"
			}
			else
			{
				Tc
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				//保存日志			
				d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TriggTasks","WDT.CDSS.TriggTasks","识别词触发任务集",id,eobj.TaskName,"A",eobj)
				d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TriggTasks","WDT.CDSS.TriggTasks","识别词触发任务集",eobj.RowId,eobj.TaskName,"U",eobj,bobj)
			}
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词触发任务集","web.CDSS.Demo.TriggTasks","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}		
	}
	q result
ERROR
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词触发任务集","web.CDSS.Demo.TriggTasks","SaveData",eobj)
	s ^ERRORLOGINFO(logid)=$ze
	s result= "{success:'false',errorinfo:'保存失败！'}"
	q result
}

/// Creator:杨继鸿
/// CreatDate:2022-03-17
/// Description: 删除方法
/// Table: WDT.CDSS.TriggTasks
/// Input: rowid
/// Return: 删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others: w ##class(web.CDSS.Demo.TriggTasks).DeleteData("6")
ClassMethod DeleteData(rowid As %String) As %String
{
	s result=""
	
	s obj=##class(WDT.CDSS.TriggTasks).%OpenId(rowid)
	if obj'=""
	{
		s bobj = ##class(web.CDSSEntity.Demo.TriggTasks).%New()
	    s bobj.TaskName = obj.TaskName
		s bobj.TaskTarget = obj.TaskTarget
		s bobj.CreateUser = obj.CreateUser
		s bobj.CreateTime = obj.CreateTime
		s bobj.DocumentType = obj.DocumentType
		
		s flag=0
		TS
		//先删除任务，再删除任务集
		s deldetailsrs=##class(web.CDSS.Demo.TriggTasksDetail).BatchDeleteData(rowid)
		if deldetailsrs["true"
		{
			s sc=##class(WDT.CDSS.TriggTasks).%DeleteId(rowid)
			if $$$ISOK(sc)
			{
				s result = "{success:'true'}"	
				//保存日志
				d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TriggTasks","WDT.CDSS.TriggTasks","识别词触发任务集",rowid,bobj.TaskName,"D",bobj)
				
		    	//删除关联表
		    	
				d bobj.%Close()
			}
			else
			{
				s flag=1
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
				
		       	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词触发任务集","web.CDSS.Demo.TriggTasks","DeleteData",bobj)
		       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		       	d bobj.%Close()
			}	
		}
		else
		{
			s flag=1
			s result = "{success:'false',errorinfo:'"_deldetailsrs_"'}"
		}
		if flag=1
		{
			TRO
		}
		else
		{
			TC
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'数据不存在'}"
	}
    
	q result
}

/// Creator: 杨继鸿
/// CreatDate: 2022-03-18
/// Description: 检查是否重名
/// Input: taskName 任务集名称
/// Output: isrepeated 1 重复 0 没有重复
/// Return: result={ isrepeated }
/// Other: w ##class(web.CDSS.Demo.TriggTasks).IsRepeated("yjh测试")
ClassMethod IsRepeated(taskName As %String = "") As %String
{
	s ID=0
	s result={"isrepeated":0}
	for
	{
		s ID=$o(^WDT.CDSS.TriggTasksD(ID))
		q:ID=""
		s TaskName=$lg($g(^WDT.CDSS.TriggTasksD(ID)),2)
		if (taskName=TaskName)
		{
			d result.%Set("isrepeated",1)
			Quit
		}
	}
	q result.%ToJSON()
}

/// d ##class(web.CDSS.Demo.TriggTasks).Test()
ClassMethod Test()
{
	s bobj = ##class(web.CDSSEntity.Demo.TriggTasks).%New()
    s bobj.TaskName = "测试1"
	s bobj.TaskTarget = "测试1"
	//s bobj.CreateUser = "yjh"
	//s bobj.CreateTime = "2022-3-18 10:59:4"
	s bobj.DocumentType = "病历导入"
	s idStr="1,2,3"
	w ##class(web.CDSS.Demo.TriggTasks).SaveData(bobj, idStr)

 //	s eobj=##class(web.CDSSEntity.Demo.TriggNLPIdentify).%New()
 //	s eobj.DocumentType="检查报告"
 //	
 //	w ##class(web.CDSS.Demo.TriggNLPIdentify).SaveData(eobj)
}

/// d ##class(web.CDSS.Demo.TriggTasks).GetPatList()
ClassMethod GetPatList()
{
#;	s a=..Test()
#;	b ;1
#;	w a
#;	d ##class(%ResultSet).RunQuery("web.CDSS.Demo.PatMaster","GetList","I","","","","","","")
#;	d ##class(%ResultSet).RunQuery("web.CDSS.Demo.PatMaster","GetList","O","","","","","","")
}

}
