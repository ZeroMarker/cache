/// Description: 操作识别词触发任务集详情
/// Creator: 杨继鸿
/// CreatDate： 2022-03-17
/// Table： WDT.CDSS.TriggTasksDetail
Class web.CDSS.Demo.TriggTasksDetail Extends %RegisteredObject
{

/// Creator：杨继鸿
/// CreatDate: 2022-03-17
/// Description：查询方法
/// Input： rowid tasksid 任务集详情ID
/// Output: RowId,PatientDR,TaskDR,State,OperatorUser,OperationTime
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.Demo.TriggTasksDetail","GetList","","1")
Query GetList(rowid, tasksid As %String) As %Query(ROWSPEC = "RowId,PatientDR,TaskDR,State,OperatorUser,OperationTime,IDNO")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, tasksid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (tasksid="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
		d OutputRow
	}
	if (rowid'="") //根据rowid返回该条记录
	{
		//RowId,PatientDR,TaskDR,State,OperatorUser,OperationTime
		s RowId=rowid
		s PatientDR=$LISTGET($G(^WDT.CDSS.TriggTasksDetailD(RowId)),2)	// 患者基础信息表ID
		s TaskDR=$LISTGET($G(^WDT.CDSS.TriggTasksDetailD(RowId)),3)		// 任务集ID
		s State=$LISTGET($G(^WDT.CDSS.TriggTasksDetailD(RowId)),4)		// 状态
		s OperatorUser=$LISTGET($G(^WDT.CDSS.TriggTasksDetailD(RowId)),5)			// 操作人员
		s OperationTime=$LISTGET($G(^WDT.CDSS.TriggTasksDetailD(RowId)),6)			// 操作时间
		s IDNO = $LISTGET($G(^WDT.CDSS.DEMOPatMasterD(PatientDR)),2)	// 患者基础信息表的患者主索引IDNO

		d OutputRow
	}
	else
	{
		s patId=0
		for
		{
			s patId=$o(^WDT.CDSS.TriggTasksDetailI("PatientIndex",tasksid,patId))
			q:patId=""
			
			s RowId=$o(^WDT.CDSS.TriggTasksDetailI("PatientIndex",tasksid,patId,0))
			s PatientDR=$LISTGET($G(^WDT.CDSS.TriggTasksDetailD(RowId)),2)	// 患者基础信息表ID
			s TaskDR=$LISTGET($G(^WDT.CDSS.TriggTasksDetailD(RowId)),3)		// 任务集ID
			s State=$LISTGET($G(^WDT.CDSS.TriggTasksDetailD(RowId)),4)		// 状态
			s OperatorUser=$LISTGET($G(^WDT.CDSS.TriggTasksDetailD(RowId)),5)			// 操作人员
			s OperationTime=$LISTGET($G(^WDT.CDSS.TriggTasksDetailD(RowId)),6)			// 操作时间
			s IDNO = $LISTGET($G(^WDT.CDSS.DEMOPatMasterD(PatientDR)),2)	// 患者基础信息表的患者主索引IDNO
			d OutputRow

		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowId,PatientDR,TaskDR,State,OperatorUser,OperationTime,IDNO)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 k ^TempDataHandle($ZNAME,repid,$JOB)
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
/// Input： flag 数据来源 0-批量选定 1-用户新增 web.CDSSEntity.Demo.TriggTasksDetail
/// Output: success 成功true,失败false id 任务集ID errorinfo 错误原因
/// Other: d ##class(web.CDSS.Demo.TriggTasksDetail).SaveData("")
ClassMethod SaveData(flag As %String = "0", eobj As web.CDSSEntity.Demo.TriggTasksDetail) As %String
{
	//s ^tempTaskDetailData=eobj.PatientDR_" "_eobj.TaskDR
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(WDT.CDSS.TriggTasksDetail).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(WDT.CDSS.TriggTasksDetail).%OpenId(eobj.RowId)
		    s bobj = ##class(web.CDSSEntity.Demo.TriggTasksDetail).%New()
		    s bobj.PatientDR = obj.PatientDR.%Id()
			s bobj.TaskDR = obj.TaskDR.%Id()
			s bobj.State = obj.State
			s bobj.OperationTime = obj.OperationTime
			s bobj.OperatorUser = obj.OperatorUser
		}
		d obj.PatientDRSetObjectId(eobj.PatientDR)
		d obj.TaskDRSetObjectId(eobj.TaskDR)
		s obj.State = eobj.State
		//若操作时间和人员不为空，则更新数据
		s:eobj.OperationTime'="" obj.OperationTime = eobj.OperationTime
		s:eobj.OperatorUser'="" obj.OperatorUser = eobj.OperatorUser
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:true,id:'"_id_"'}" //返回RowId
			//仅对用户新增的数据，保存日志
			if flag="1"
			{
				d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TriggTasksDetail","WDT.CDSS.TriggTasksDetail","识别词触发任务集详情",id,eobj.PatientDR,"A",eobj)
			}
		}
		else
		{
			Trollback
			s result = "{success:false,errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词触发任务集详情","web.CDSS.Demo.TriggTasksDetail","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}		
	}
	q result
ERROR
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词触发任务集详情","web.CDSS.Demo.TriggTasksDetail","SaveData",eobj)
	s ^ERRORLOGINFO(logid)=$ze
	s result= "{success:false,errorinfo:'保存失败！'}"
	q result
}

/// Creator：      杨继鸿
/// CreatDate：    2022-04-14
/// Description:：   更新任务编辑状态
/// Input：            taskid WDT.CDSS.TriggTasksDetail的ID
/// Output：          result json字符串
/// Return：         成功 "{success:'true',count:删除的数量}"；失败 "{success:'false',errorinfo:'...'}"
/// Others：        w ##class(web.CDSS.Demo.TriggTasksDetail).UpdateState("1")
ClassMethod UpdateState(taskid)
{
	s result=""
	s obj=##class(WDT.CDSS.TriggTasksDetail).%OpenId(taskid)
	if obj'=""
	{
	    s eobj = ##class(web.CDSSEntity.Demo.TriggTasksDetail).%New()
	    s eobj.RowId=taskid
	    s eobj.PatientDR = obj.PatientDR.%Id()
		s eobj.TaskDR = obj.TaskDR.%Id()
		s eobj.OperatorUser = obj.OperatorUser
		//更新编辑状态
		s eobj.State = "1"	//继续编辑
		s eobj.OperationTime = $zdt($h,3)
		s:$d(%session) eobj.OperatorUser = $g(%session.Data("LOGON.USERNAME"))	//有session时，更新操作人员
		s result=..SaveData("0",eobj)
	}
	else
	{
		s result="{success:'false',errorinfo:'数据不存在！'}"
	}
	q result
}

/// Creator:杨继鸿
/// CreatDate:2022-03-17
/// Description: 删除方法
/// Table: WDT.CDSS.TriggTasksDetail
/// Input: flag 删除来源 0-关联删除 1-用户删除 rowid
/// Return: 删除成功返回{success:true}，失败返回{success:false,errorinfo:""}
/// others: w ##class(web.CDSS.Demo.TriggTasksDetail).DeleteData("0","12")
ClassMethod DeleteData(flag As %String = "0", rowid As %String) As %String
{
	s result=""
	
	s obj=##class(WDT.CDSS.TriggTasksDetail).%OpenId(rowid)
	if $IsObject(obj)
	{
	    s bobj = ##class(web.CDSSEntity.Demo.TriggTasksDetail).%New()
	    s bobj.PatientDR = obj.PatientDR.%Id()
		s bobj.TaskDR = obj.TaskDR.%Id()
		s bobj.State = obj.State
		s bobj.OperationTime = obj.OperationTime
		s bobj.OperatorUser = obj.OperatorUser
		
		s falseFlag=0
		Ts
	   	//删除关联表
	   	//WDT.CDSS.TriggNLPIdentify
	   	s delNLP=##class(web.CDSS.Demo.TriggNLPIdentify).BatchDeleteData(rowid)
	   	//WDT.CDSS.TriggIWRecord
	   	s delWord=##class(web.CDSS.Demo.TriggIWRecord).BatchDeleteData(rowid)
		
		if (delNLP["false")
		{
			s result=delNLP, falseFlag=1
		}
		elseif (delWord["false")
		{
			s result=delWord, falseFlag=1
		}
		else
		{
			// 删除关联数据后，再删除WDT.CDSS.TriggTasksDetail
			s sc=##class(WDT.CDSS.TriggTasksDetail).%DeleteId(rowid)
			if $$$ISOK(sc)
			{
				s result = "{success:'true'}"	
				
				//保存日志
				d:flag="1" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TriggTasksDetail","WDT.CDSS.TriggTasksDetail","识别词触发任务集详情",rowid,bobj.PatientDR,"D",bobj)
				d bobj.%Close()
			}
			else
			{
				s falseFlag=1
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
				
		       	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词触发任务集详情","web.CDSS.Demo.TriggTasksDetail","DeleteData",bobj)
		       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		       	d bobj.%Close()
			}
		}
		if falseFlag=1
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
		s result = "{success:'false',errorinfo:'数据不存在！'}"
	}
    
	q result
}

/// Creator：      杨继鸿
/// CreatDate：    2022-04-13
/// Description:：   批量保存数据
/// Input：            taskid WDT.CDSS.TriggTasks的ID；PatIDStr 患者ID串；
/// Output：          result json字符串
/// Return：         成功 "{success:true,count:'保存的数据'}"；失败 "{success:'false',errorinfo:'...'}"
/// Others：        w ##class(web.CDSS.Demo.TriggTasksDetail).BatchSaveData("2","2022-4-13 14:30:29","Demo Group","965,966")
ClassMethod BatchSaveData(taskID, PatIDStr As %String = "") As %String
{
	s result=""
	s count=0
	s length=$length(PatIDStr,",")
	
	TS
	for i=1:1:length
	{
		s patID=$p(PatIDStr,",",i)
	    s eobj = ##class(web.CDSSEntity.Demo.TriggTasksDetail).%New()
	    s eobj.PatientDR = patID
		s eobj.TaskDR = taskID
		s eobj.State = "0"
		s:$d(%session) eobj.OperatorUser=$g(%session.Data("LOGON.USERNAME"))
		s:'$d(%session) eobj.OperatorUser="Demo Group"
		s eobj.OperationTime=$zdt($h,3)
		
		s rs=..SaveData("0", eobj)
		if rs["false"
		{
			s result=rs	//错误信息赋值
			quit
		}
		else
		{
			s count=count+1
		}
	}
	if result["false"
	{
		TRO
	}
	else
	{
		TC
		s result="{success:true,count:'"_count_"'}"
	}
	q result
}

/// Creator：      杨继鸿
/// CreatDate：    2022-04-13
/// Description:：   批量删除数据
/// Input：            taskID WDT.CDSS.TriggTasks的ID
/// Output：          result json字符串
/// Return：         成功 "{success:'true',count:删除的数量}"；失败 "{success:'false',errorinfo:'...'}"
/// Others：        w ##class(web.CDSS.Demo.TriggTasksDetail).BatchDeleteData("1")
ClassMethod BatchDeleteData(taskID) As %String
{
	s result=""
	s count=0
	
	s ID=""
	TS
	for
	{
		s ID=$o(^WDT.CDSS.TriggTasksDetailI("TaskIndex",taskID,ID))
		q:ID=""
		
		s rs=..DeleteData("0",ID)
		if rs["false"
		{
			s result=rs	//错误信息赋值
			quit
		}
		else
		{
			s count=count+1
		}
		//测试父级的错误处理
#;		if count=2
#;		{
#;			b ;2
#;			s result="false"
#;			quit
#;		}
	}
	if result["false"
	{
		TRO
	}
	else
	{
		TC
		s result="{success:true,count:'"_count_"'}"
	}
	q result
}

/// w ##class(web.CDSS.Demo.TriggTasksDetail).Test()
ClassMethod Test()
{
    s eobj = ##class(web.CDSSEntity.Demo.TriggTasksDetail).%New()
    s eobj.PatientDR = "956"
	s eobj.TaskDR = "2"
	s eobj.State = "0"
	//格式化时间
#;	s Mdatetime=$zdth(OperationTime,3)
#;	s Mdatetime=$zdt(Mdatetime,3)
#;	s eobj.OperationTime = Mdatetime
	s eobj.OperationTime = "2022-4-1 12:00:00"
	s eobj.OperatorUser = "Demo Group"
	
	s rs=..SaveData("0", eobj)
	q rs
}

/// Creator：      杨继鸿
/// CreatDate：    2022-04-18
/// Description:   切换任务集详情；调用初始化NLP识别结果，识别词记录接口
/// Table：        WDT.CDSS.DEMOTasksDetail
/// Input：        detailID 任务集ID，direction 向上/下（-1/1）取ID的方向
/// Output：       id 新的任务ID；idno 患者IDNO；state 编辑状态；patid 患者ID
/// Return：       下（上）一个任务集详情ID
/// Others：       w ##class(web.CDSS.Demo.TriggTasksDetail).SwitchDetail("9","1")
ClassMethod SwitchDetail(detailID As %String, direction As %String) As %String
{
	s result=""
	s obj=##class(WDT.CDSS.TriggTasksDetail).%OpenId(detailID)
	if obj'=""
	{
		s taskDR=obj.TaskDR.%Id()
		s patid=obj.PatientDR.%Id()
		s nextPatId=$o(^WDT.CDSS.TriggTasksDetailI("PatientIndex",taskDR,patid),direction)
		if nextPatId=""
		{
			// 空表示当前任务是任务集的第一个或者最后一个任务
			s info="0^^^"
			s result="{success:'true',info:'"_info_"'}"
		}
		else
		{	
			s id=$o(^WDT.CDSS.TriggTasksDetailI("PatientIndex",taskDR,nextPatId,0))
			s state=$lg($g(^WDT.CDSS.TriggTasksDetailD(id)),4)	//状态		
			s PatientDR=$lg($g(^WDT.CDSS.TriggTasksDetailD(id)),2)	//指向患者基本信息
			s IDNO=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatientDR)),2)
			s info=id_"^"_IDNO_"^"_state_"^"_PatientDR
			if state="0"
			{
				// 调用初始化接口
				s initData=##class(web.CDSS.Demo.EvalWordTrigg).InitAllData(id,PatientDR)
				if initData["false"
				{
					// 初始化数据失败
					s result=initData
				}
				else
				{
					s result="{success:'true',info:'"_info_"'}"
				}
			}
			else
			{
				s result="{success:'true',info:'"_info_"'}"
			}
			if result'["false"
			{
				// 切换演示评测系统的当前患者
				d ##class(web.CDSS.Demo.PatMaster).SavePatId(PatientDR)			
			}
		}		
		d obj.%Close()
	}
	else
	{
		s result="{success:'false',info:'数据不存在！'}"
	}
	q result
}

/// Creator：赵文伟
/// CreatDate: 2022-08-03
/// Description：根据患者RowId获取INDO
/// Input： RowId
/// Output: IDNO
/// Other: w ##class(web.CDSS.Demo.TriggTasksDetail).GetIDNO("101")
ClassMethod GetIDNO(RowId) As %String
{
	s IDNO =""
	s:RowId'="" IDNO = $LISTGET($G(^WDT.CDSS.DEMOPatMasterD(RowId)),2)	// 患者基础信息表的患者主索引IDNO
	q IDNO
}

/// Creator：赵文伟
/// CreatDate: 2022-08-03
/// Description：获取表中最大ID
/// Input： 
/// Output: id
/// Other: w ##class(web.CDSS.Demo.TriggTasksDetail).GetMaxID()
ClassMethod GetMaxID() As %String
{

	&sql(SELECT MAX(ID) INTO:id FROM WDT_CDSS.TriggTasksDetail)  //使用指定一个或多个主机变量的INTO 子句 返回结果
	
	q id
}

}
