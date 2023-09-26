/// Creator:赵文伟
/// CreatDate: 2022-09-14
/// Description：文献触发评测工具——任务集界面
Class web.CDSS.Demo.DocuTasks Extends %RegisteredObject
{

/// Creator：赵文伟
/// CreatDate: 2022-09-14
/// Description：查询任务集
/// Table： WDT.CDSS.DocTasks
/// Input：rowid, desc, startTime开始日期, endTime截止日期
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DocuTasks","GetTaskList","","","","")
Query GetTaskList(rowid As %String, desc As %String, startTime As %String, endTime As %String) As %Query(ROWSPEC = "RowId,TaskName,TriggerRate,CreateUser,CreateTime")
{
}

ClassMethod GetTaskListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, startTime As %String, endTime As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 if $g(ind)="" s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
	s RowId=rowid
	s TaskName = $lg($g(^WDT.CDSS.DocTasksD(RowId)),2) 		//任务名称
	s TriggerRate = $lg($g(^WDT.CDSS.DocTasksD(RowId)),3) 	//触发率
	s CreateUser = $lg($g(^WDT.CDSS.DocTasksD(RowId)),4) 	//创建人员
	s CreateTime = $lg($g(^WDT.CDSS.DocTasksD(RowId)),5) 	//创建时间
	s:CreateTime'="" CreateTime=$p(CreateTime," ",1)
	d OutputRowCmb
 }
 else
 {
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	
	s RowId=""
	for{  
		s RowId=$o(^WDT.CDSS.DocTasksD(RowId),-1) q:RowId=""  
		s TaskName = $lg($g(^WDT.CDSS.DocTasksD(RowId)),2) 		//任务名称
		s TriggerRate = $lg($g(^WDT.CDSS.DocTasksD(RowId)),3) 	//触发率
		s CreateUser = $lg($g(^WDT.CDSS.DocTasksD(RowId)),4) 	//创建人员
		s CreateTime = $lg($g(^WDT.CDSS.DocTasksD(RowId)),5) 	//创建时间
		s:CreateTime'="" CreateTime=$p(CreateTime," ",1)	//2022-09-21
		
		continue:((startTime'="")&&($ZDH(startTime,3)>$ZDH(CreateTime,3)))
        continue:((endTime'="")&&($ZDH(endTime,3)<$ZDH(CreateTime,3)))
		s PINYINDesc=""
		s:TaskName'="" PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(TaskName)  

		if ((($ZCONVERT(TaskName,"U")[desc)||(PINYINDesc[desc))) {
			d OutputRowCmb
		}
	}
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(RowId,TaskName,TriggerRate,CreateUser,CreateTime)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetTaskListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTaskListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetTaskListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTaskListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:赵文伟
/// CreatDate:2022-09-14
/// Description:生成最新任务集名称
/// Table: WDT.CDSS.DocTasks
/// others:w ##class(web.CDSS.Demo.DocuTasks).GetNewTaskName()
ClassMethod GetNewTaskName()
{
	s TaskName="文献触发测试 "_$ZDATETIME($H,3)	//文献触发测试 2022-09-14 17:07:59
	q TaskName
}

/// Creator:赵文伟
/// CreatDate:2022-09-14
/// Description:创建任务集
/// Table: WDT.CDSS.DocTasks
/// others:w ##class(web.CDSS.Demo.DocuTasks).SaveDocuTasks()
ClassMethod SaveDocuTasks(user)
{
	s result=""
	s obj=##class(WDT.CDSS.DocTasks).%New()
	s obj.TaskName = ..GetNewTaskName()
	//s obj.TriggerRate = TriggerRate
	s obj.CreateTime=$zd($h,3)	//2022-09-14
	s obj.CreateUser=user
	TS
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
        { 
            TC
            s result=obj.%Id() ///保存成功的数据ID
		}
		else
		{
			TRO
			s result=0
		}
	q result
}

/// Creator:赵文伟
/// CreatDate:2022-09-14
/// Description:前台导入测试数据【检索字段+目标指南】
/// Table: WDT.CDSS.DocTasks
/// others:w ##class(web.CDSS.Demo.DocuTasks).ImportRetrieveXLSData("荨麻疹[N]中国荨麻疹诊疗指南(2018版)[N][N]","1")
ClassMethod ImportRetrieveXLSData(dataStr, taskid)
{
	s result=""
	s flag=0
	q:dataStr="[N][N][N]" "true" 
	//s Dept=	$p(dataStr,"[N]",1)
	s RetrieveDesc=$p(dataStr,"[N]",1)
	q:RetrieveDesc="" 
	s DocuDesc=$p(dataStr,"[N]",2)
	s flagDesc=$p(dataStr,"[N]",3)
	
	s RetrieveRusult=##class(web.CDSS.TreatDecision.RatingScale).DocumentRetrieval(RetrieveDesc)
	if (RetrieveRusult[DocuDesc){
		s flag=1
	}
	s flagDesc=$CASE(flag ,0:"否",1:"是",:"否")
	
	s bobj=##class(WDT.CDSS.DocTasksDetail).%New()
	d bobj.TaskDRSetObjectId(taskid)
	//s bobj.TaskDR = taskid
	s bobj.SearchFields = RetrieveDesc	//检索字段
	s bobj.TargetGuide=DocuDesc			//目标指南
	s bobj.HitFlag=flagDesc				//目标指南是否推出（是/否）
	TS
	s sc=bobj.%Save()
	d bobj.%Close()
	If $$$ISOK(sc)
    { 
        TC
        //s result=bobj.%Id() //保存成功的数据ID
        s result="true"
	}
	else
	{
		TRO
		s result="false"
	}
	q result_"^"_flagDesc
}

/// Creator:赵文伟
/// CreatDate:2022-09-14
/// Description:保存触发率
/// Table: WDT.CDSS.DocTasks
/// others:w ##class(web.CDSS.Demo.DocuTasks).SaveTriggerRate()
ClassMethod SaveTriggerRate(taskid, triggerRate)
{
	s result=""
	s obj=##class(WDT.CDSS.DocTasks).%OpenId(taskid)	
	TS
	s obj.TriggerRate = triggerRate
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		s id = obj.%Id()
		s result="true"_id
		TC
	}else{
		TRO
		s result="false"
	}
	q result
}

}
