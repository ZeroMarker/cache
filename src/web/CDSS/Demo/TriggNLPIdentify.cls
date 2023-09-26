/// 名称:     web.CDSS.Demo.TriggNLPIdentify
/// 描述:     操作识别词触发任务集NLP识别表
/// 编写者：  杨继鸿
/// 编写日期: 2022-03-22
Class web.CDSS.Demo.TriggNLPIdentify Extends %RegisteredObject
{

/// Creator:		杨继鸿
/// CreatDate:		2022-03-25
/// Description:	保存【NLP识别表】数据
/// Table:			WDT.CDSS.TriggNLPIdentify
/// Input:			eobj web.CDSSEntity.Demo.TriggNLPIdentify；flag 0-关联操作 1-用户操作；
/// Output:			JSON串：success（成功与否0失败、1成功）；id/ids(修改或新增数据ID串)；errorinfo 错误信息
/// Return:			成功返回{"success":1,["ids":"id^id"],["errorinfo":""]}，失败返回{"success":0,"errorinfo":""}
/// Others:			d ##class(web.CDSS.Demo.TriggNLPIdentify).SaveData()
ClassMethod SaveData(eobj As web.CDSSEntity.Demo.TriggNLPIdentify, flag As %String = "1") As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(WDT.CDSS.TriggNLPIdentify).%New()	
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(WDT.CDSS.TriggNLPIdentify).%OpenId(eobj.RowId)
		    s bobj = ##class(web.CDSSEntity.Demo.TriggNLPIdentify).%New()
		    s bobj.RowId=eobj.RowId
		    //s bobj.TasksDetailDR=obj.TasksDetailDR.%Id()	// 识别词触发任务集NLP识别表详情表DR
		    s bobj.TasksDetailDR=obj.TasksDetailDRGetObjectId()
		    s bobj.DocumentType=obj.DocumentType	// 数据类型
		    s bobj.DemoDataDR=obj.DemoDataDR	// 识别内容表的ID
			s bobj.IdentifyInfo=obj.IdentifyInfo	// 识别信息
			s bobj.NLPRecognition=obj.NLPRecognition	// NLP识别结果
			s bobj.NLPSource=obj.NLPSource	// 识别来源
			s bobj.ProblemType=obj.ProblemType	// 问题类型
			s bobj.TagContent=obj.TagContent	// 标记内容
			s bobj.OperatorUser=obj.OperatorUser	// 操作人员
			s bobj.OperationTime=obj.OperationTime	// 操作时间
			s bobj.IsSolve=obj.IsSolve	// 是否解决
			s bobj.IsOutput=obj.IsOutput	// 是否导出
		}
		d obj.TasksDetailDRSetObjectId(eobj.TasksDetailDR)
		s obj.DocumentType=eobj.DocumentType
		s obj.DemoDataDR=eobj.DemoDataDR
		s obj.IdentifyInfo=eobj.IdentifyInfo
		s obj.NLPRecognition=eobj.NLPRecognition
		s obj.NLPSource=eobj.NLPSource
		s obj.ProblemType=eobj.ProblemType
		s obj.TagContent=eobj.TagContent
		s obj.OperationTime = $zdt($h,3)
		s:$d(%session) obj.OperatorUser=$g(%session.Data("LOGON.USERNAME"))
		s:'$d(%session) obj.OperatorUser="Demo Group"
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s id = obj.%Id()
			Tc
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			//保存日志
			if flag=1
			{
				d ##class(web.CDSS.Demo.TriggTasksDetail).UpdateState(eobj.TasksDetailDR)
				d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TriggNLPIdentify","WDT.CDSS.TriggNLPIdentify","识别词触发任务集NLP识别表",id,eobj.NLPRecognition,"A",eobj)
				d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TriggNLPIdentify","WDT.CDSS.TriggNLPIdentify","识别词触发任务集NLP识别表",eobj.RowId,eobj.NLPRecognition,"U",eobj,bobj)
			}
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词触发任务集NLP识别表","web.CDSS.Demo.TriggNLPIdentify","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}		
	}
	q result
ERROR
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词触发任务集NLP识别表","web.CDSS.Demo.TriggNLPIdentify","SaveData",eobj)
	s ^ERRORLOGINFO(logid)=$ze
	s result= "{success:'false',errorinfo:'保存失败！'}"
	q result
}

/// Creator：      杨继鸿
/// CreatDate：    2022-03-25
/// Description:   查询【病历任务集NLP识别表】
/// Table：        WDT.CDSS.TriggNLPIdentify, CT.WDT.CDSS.DEMOTasksDetail, WDT.CDSS.DEMOPatMaster, CT.WDT.CDSS.DEMOTasks
/// Input：        rowid 病历任务集NLP识别表ID,tasksdetailDR 病历任务集详情表ID,documentType 文书类型 demoDataId 文本ID
/// Output：       RowId,TasksDetailDR,DocumentType,DemoDataDR,IdentifyInfo,NLPRecognition,NLPSource,ProblemType,TagContent,OperatorUser,OperationTime,IsOutput,IsSolve
/// Return：       返回符合条件的NLP识别表数据
/// Others：       d ##class(%ResultSet).RunQuery("web.CDSS.Demo.TriggNLPIdentify","GetList","","1","入院记录")
Query GetList(rowid As %String, tasksdetailDR As %String, documentType As %String, demoDataId As %String) As %Query(ROWSPEC = "RowId:%String,TasksDetailDR:%String,DocumentType:%String,DemoDataDR,IdentifyInfo:%String,NLPRecognition:%String,NLPSource:%String,ProblemType:%String,TagContent:%String,OperatorUser:%String,OperationTime:%String,IsOutput:%String,IsSolve:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, tasksdetailDR As %String, documentType As %String, demoDataId As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s RowId=rowid
        
        s TasksDetailDR=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),2) // 病历任务集详情表DR
        
        s DocumentType=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),3) // 文书类型：入院记录/首次病程/日常记录/查房记录
        s DemoDataDR=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),4)
        s IdentifyInfo=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),5)	// 识别信息
        s NLPRecognition=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),6)	// NLP识别结果
        s NLPSource=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),7)	// 识别来源:主诉/现病史
        s ProblemType=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),8)	// 问题类型：识别错误/未识别
        s TagContent=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),9)	// 标记内容
        s OperatorUser=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),10)	// 操作人员
        s OperationTime=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),11)	// 操作时间
        
        s IsOutput=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),12)	// 是否导出 0-否 1-是
        s:IsOutput=0 IsOutput="否"
        s:IsOutput=1 IsOutput="是"
        
        s IsSolve=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),13) // 是否解决 0-否 1-是
        s:IsSolve=0 UseFlag="否"
        s:IsSolve=1 UseFlag="是"

        d OutputNLPIdenRow
    }
    else
    {
		s RowId=0
		for 
		{
			s RowId=$o(^WDT.CDSS.TriggNLPIdentifyI("DocumentIndex",tasksdetailDR,documentType,RowId))
			q:RowId=""
			
			s TasksDetailDR=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),2) // 病历任务集详情表DR
	        s DocumentType=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),3) // 文书类型：入院记录/首次病程/日常记录/查房记录
	        s DemoDataDR=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),4)
	        continue:(demoDataId'="")&(DemoDataDR'=demoDataId)
	        s IdentifyInfo=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),5)	// 识别信息
	        s NLPRecognition=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),6)	// NLP识别结果
	        s NLPSource=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),7)	// 识别来源:主诉/现病史
	        s ProblemType=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),8)	// 问题类型：识别错误/未识别
	        s TagContent=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),9)	// 标记内容
	        s OperatorUser=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),10)	// 操作人员
	        s OperationTime=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),11)	// 操作时间
	        
	        s IsOutput=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),12)	// 是否导出 0-否 1-是
	        s:IsOutput=0 IsOutput="否"
	        s:IsOutput=1 IsOutput="是"
	        
	        s IsSolve=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(RowId)),13) // 是否解决 0-否 1-是
	        s:IsSolve=0 UseFlag="否"
	        s:IsSolve=1 UseFlag="是"
	        
	        d OutputNLPIdenRow
		}
		
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputNLPIdenRow
    set Data=$lb(RowId,TasksDetailDR,DocumentType,DemoDataDR,IdentifyInfo,NLPRecognition,NLPSource,ProblemType,TagContent,OperatorUser,OperationTime,IsOutput,IsSolve)
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

/// Creator:杨继鸿
/// CreatDate:2022-03-25
/// Description: 删除方法
/// Table: WDT.CDSS.TriggNLPIdentify
/// Input: flag 删除来源 0-关联删除 1-用户删除 rowid
/// Return: 删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others: w ##class(web.CDSS.Demo.TriggNLPIdentify).DeleteData("0","12")
ClassMethod DeleteData(flag As %String = "0", rowid As %String) As %String
{
	s result=""
	
	s obj=##class(WDT.CDSS.TriggNLPIdentify).%OpenId(rowid)
	if (obj'="")
	{
		s bobj = ##class(web.CDSSEntity.Demo.TriggNLPIdentify).%New()
	    s bobj.RowId=rowid
	    s bobj.TasksDetailDR=obj.TasksDetailDRGetObjectId()	//任务集详情id
	    s bobj.DocumentType=obj.DocumentType	// 数据类型
	    s bobj.DemoDataDR=obj.DemoDataDR	// 识别内容表的ID
		s bobj.IdentifyInfo=obj.IdentifyInfo	// 识别信息
		s bobj.NLPRecognition=obj.NLPRecognition	// NLP识别结果
		s bobj.NLPSource=obj.NLPSource	// 识别来源
		s bobj.ProblemType=obj.ProblemType	// 问题类型
		s bobj.TagContent=obj.TagContent	// 标记内容
		s bobj.OperatorUser=obj.OperatorUser	// 操作人员
		s bobj.OperationTime=obj.OperationTime	// 操作时间
		s bobj.IsSolve=obj.IsSolve	// 是否解决
		s bobj.IsOutput=obj.IsOutput	// 是否导出
		
		Ts	
			
		s sc=##class(WDT.CDSS.TriggNLPIdentify).%DeleteId(rowid)
		if $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true',info:'删除成功！'}"
			//用户操作的删除，则保存日志
			if flag="1"
			{
				d ##class(web.CDSS.Demo.TriggTasksDetail).UpdateState(bobj.TasksDetailDR)
				d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TriggNLPIdentify","WDT.CDSS.TriggNLPIdentify","识别词触发任务集NLP识别表",rowid,bobj.NLPRecognition,"D",bobj)
			}
		}
		else
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			
	       	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词触发任务集NLP识别表","web.CDSS.Demo.TriggNLPIdentify","DeleteData",bobj)
	       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',info:'数据不存在'}"  //返回错误信息
	}
    
	q result
}

/// Creator：      杨继鸿
/// CreatDate：    2022-04-13
/// Description:：   批量删除NLP识别数据。根据参数值，有不同的删除规则：删除某种文书类型的数据；删除某个特定记录的数据；删除任务的数据
/// Input：            taskid WDT.CDSS.TriggTasksDetail的ID；doctype 文书类型（入院记录，出院记录，检查报告）；demoDataId 文书数据id
/// Output：          result json字符串
/// Return：         成功 "{success:'true',count:删除的数量}"；失败 "{success:'false',errorinfo:'...'}"
/// Others：        w ##class(web.CDSS.Demo.TriggNLPIdentify).BatchDeleteData("3","","")
ClassMethod BatchDeleteData(taskID, doctype As %String = "", demoDataId As %String = "") As %String
{
	s result=""
	s count=0
	
	TS
	// 删除某种文书类型下的NLP结果
	if ((doctype'="") & (demoDataId=""))
	{
		s id=0
		for
		{
			s id=$o(^WDT.CDSS.TriggNLPIdentifyI("DocumentIndex",taskID,doctype,id))
			q:id=""
			s rs=..DeleteData("0",id)
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
	}
	// 删除某个特定记录下的NLP结果
	elseif ((doctype'="") & (demoDataId'=""))
	{
		s id=0
		for
		{
			s id=$o(^WDT.CDSS.TriggNLPIdentifyI("DocumentIndex",taskID,doctype,id))
			q:id=""
			
			s dataid=$lg($g(^WDT.CDSS.TriggNLPIdentifyD(id)),4)
			continue:dataid'=demoDataId
			s rs=..DeleteData("0",id)
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
	}
	// 删除任务下的所有NLP结果
	else
	{
		s documenttype=""
		for
		{
			s documenttype=$o(^WDT.CDSS.TriggNLPIdentifyI("DocumentIndex",taskID,documenttype))
			q:documenttype=""
			
			s ID=0
			for
			{
				s ID=$o(^WDT.CDSS.TriggNLPIdentifyI("DocumentIndex",taskID,documenttype,ID))
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
			}
			q:result["false"		
		}	
	}
	if result["false"
	{
		TRO
	}
	else
	{
		TC
		s result="{success:'true',count:'"_count_"'}"
	}
	q result
}

/// Creator: 杨继鸿
/// CreatDate: 2022-04-26
/// Description: 删除旧数据，保存最新识别结果
/// Input: flag 0-关联操作 1-用户操作；recordid 病历记录ID；taskid WDT.CDSS.TriggTasksDetail的ID；
///        type：入院记录/出院记录/检查报告；data NLP识别结果，{主诉:{源文本:"归一词,上位词,属性,部位,方位...",},（现病史/...出院诊断/...检查结果）}；
/// Output: result json字符串
/// Return: 成功 "{success:'true'}"；失败 "{success:'false',errorinfo:'...'}"
/// Others: w ##class(web.CDSS.Demo.TriggNLPIdentify).UpdateNLPInfo(0,"970","45","入院记录",^TMPUpdateNLPInfo)
ClassMethod UpdateNLPInfo(flag As %String = "0", recordid, taskid, type, data)
{
	s result=""
	s falseFlag=0
	TS
	s result=..BatchDeleteData(taskid, type, recordid)
	if result'["false"
	{
		s json={}.%FromJSON(data)
		s iter=json.%GetIterator()
		while iter.%GetNext(.k,.v)
		{
			s nlpSource=k	//识别来源
			s nlpData=v
			s rsIter=nlpData.%GetIterator()
			while rsIter.%GetNext(.k,.v)
			{
				//新增此条识别结果
			    s eobj = ##class(web.CDSSEntity.Demo.TriggNLPIdentify).%New()
			    s eobj.RowId=""
			    s eobj.TasksDetailDR=taskid	// 识别词触发任务集NLP识别表详情表DR
			    s eobj.DocumentType=type	// 数据类型
			    s eobj.DemoDataDR=recordid	// 识别内容表的ID
				s eobj.IdentifyInfo=k	// 识别信息
				s eobj.NLPRecognition=v	// NLP识别结果
				s eobj.NLPSource=nlpSource	// 识别来源
				s eobj.ProblemType=""	// 问题类型
				s eobj.TagContent=""	// 标记内容
				s eobj.OperatorUser=""	// 操作人员
				s eobj.OperationTime=$zdt($h,3)	// 操作时间
				s eobj.IsSolve=""	// 是否解决
				s eobj.IsOutput=""	// 是否导出
				
				s result=##class(web.CDSS.Demo.TriggNLPIdentify).SaveData(eobj,flag)
				if result["false"
				{
					s falseFlag=1
					q
				}
			}
			q:result["false"
		}
	}
	else
	{
		s falseFlag=1
	}
	if falseFlag=1
	{
		TRO
	}
	else
	{
		s result="{success:'true'}"
		TC
	}
	q result
}

/// Creator：      杨继鸿
/// CreatDate：    2022-04-11
/// Description:：   初始化NLP识别结果
/// Input：            taskid 任务集详情ID patid DEMO患者基础信息表ID
/// Return：         成功 "{""success"":""true""}"；失败 "{success:'false',errorinfo:'...'}"
/// Others：        d ##class(web.CDSS.Demo.TriggNLPIdentify).InitNLPIdentify(1,284)
ClassMethod InitNLPIdentify(taskid, patid)
{
	s result=""
	
	TS
	//入院记录ID
	s admRecID=$o(^WDT.CDSS.DEMOAdmRecI("PatIndex",patid,0))
	s admNLPRS=##class(web.CDSS.Demo.EvalWordTrigg).GetAdmRecNLPResult(admRecID)
	s admNLPSave=..UpdateNLPInfo("0",admRecID,taskid,"入院记录",admNLPRS.%ToJSON())
	if admNLPSave["false"
	{
		s result=admNLPSave
	}
	else //保存入院记录NLP识别信息成功，继续出院记录
	{
		s dischargeRecID=$o(^WDT.CDSS.DEMODischargeRecI("PatIndex",patid,0))
		s dischargeNLPRS=##class(web.CDSS.Demo.EvalWordTrigg).GetDischargeRecNLPResult(dischargeRecID)
		s dischargeNLPSave=..UpdateNLPInfo("0",dischargeRecID,taskid,"出院记录",dischargeNLPRS.%ToJSON())
		if dischargeNLPSave["false"
		{
			s result=dischargeNLPSave
		}
		else //保存出院记录NLP识别信息成功，继续检查报告
		{
			s reportID=0
			for
			{
				// 检查报告ID
				s reportID=$o(^WDT.CDSS.DEMORISReportI("PatIndex",patid,reportID))
				q:reportID=""
				
				s reportNLPRS=##class(web.CDSS.Demo.EvalWordTrigg).GetRISRNLPResult(reportID)
				s reportNLPSave=..UpdateNLPInfo("0",reportID,taskid,"检查报告",reportNLPRS.%ToJSON())
				if reportNLPSave["false"
				{
					s result=reportNLPSave
					q
				}
			}			
		}
	}
	s:result="" result="{""success"":""true""}"
	if result["false"
	{
		TRO
	}
	else
	{
		TC
	}
	q result
}

/// Creator: 杨继鸿
/// CreatDate: 2022-04-27
/// Description: 更新NLP识别数据，根据参数设置不同的过滤条件，更新特定的数据
/// Table: WDT.CDSS.TriggNLPIdentify
/// Input: taskid 任务集详情ID；type 入院记录、出院记录、检查报告；dataId 文书在数据表中的id
/// Return: 成功 "{""success"":""true""}"；失败 "{success:'false',errorinfo:'...'}"
/// Others: w ##class(web.CDSS.Demo.TriggNLPIdentify).UpdateDataByParams(1,"检查报告","90")
ClassMethod UpdateDataByParams(taskId, type, dataId)
{
	s result=""
	if (dataId'="") & ((taskId="") || (type=""))
	{
		s result="{'success':'false','errorinfo':'入参有空值！'}"
	}
	elseif (type'="") & (taskId="")
	{
		s result="{'success':'false','errorinfo':'入参有空值！'}"
	}
	elseif (taskId="")
	{
		s result="{'success':'false','errorinfo':'入参有空值！'}"
	}
	else
	{
		s taskObj=##class(WDT.CDSS.TriggTasksDetail).%OpenId(taskId)
		if taskObj=""
		{
			s result="{'success':'false','errorinfo':'任务不存在！'}"
		}
		else
		{
			s falseFlag=0	// 结束事务操作标志，0-TC；1-TRO
			TS
			if dataId'=""	// dataId不为空，说明更新某文书的NLP识别数据
			{
				s NLPRS=""
				if type="入院记录"
				{
					s NLPRS=##class(web.CDSS.Demo.EvalWordTrigg).GetAdmRecNLPResult(dataId)
				}
				elseif type="出院记录"
				{
					s NLPRS=##class(web.CDSS.Demo.EvalWordTrigg).GetDischargeRecNLPResult(dataId)
				}
				elseif type="检查报告"
				{
					s NLPRS=##class(web.CDSS.Demo.EvalWordTrigg).GetRISRNLPResult(dataId)
				}
				else
				{
					s falseFlag=1
					s result="{'success':'false','errorinfo':'"_type_"类型暂不支持！'}"
				}
				if NLPRS'=""
				{
					s NLPSave=..UpdateNLPInfo("0",dataId,taskId,type,NLPRS.%ToJSON())
					if NLPSave["false"
					{
						s result=NLPSave, falseFlag=1
					}
				}
			}
			elseif type'=""	// type不为空，说明更新某类型的NLP识别数据
			{
				s NLPSave=""
				if type="入院记录"
				{
					//入院记录ID
					s admRecID=$o(^WDT.CDSS.DEMOAdmRecI("PatIndex",taskObj.PatientDR.%Id(),0))
					s NLPRS=##class(web.CDSS.Demo.EvalWordTrigg).GetAdmRecNLPResult(admRecID)
					s NLPSave=..UpdateNLPInfo("0",dataId,taskId,type,NLPRS.%ToJSON())
				}
				elseif type="出院记录"
				{
					s dischargeRecID=$o(^WDT.CDSS.DEMODischargeRecI("PatIndex",taskObj.PatientDR.%Id(),0))
					s NLPRS=##class(web.CDSS.Demo.EvalWordTrigg).GetDischargeRecNLPResult(dischargeRecID)
					s NLPSave=..UpdateNLPInfo("0",dataId,taskId,type,NLPRS.%ToJSON())
				}
				elseif type="检查报告"
				{
					s reportID=0
					for
					{
						// 检查报告ID
						s reportID=$o(^WDT.CDSS.DEMORISReportI("PatIndex",taskObj.PatientDR.%Id(),reportID))
						q:reportID=""							
						s reportNLPRS=##class(web.CDSS.Demo.EvalWordTrigg).GetRISRNLPResult(reportID)
						s reportNLPSave=..UpdateNLPInfo("0",reportID,taskId,"检查报告",reportNLPRS.%ToJSON())
						if reportNLPSave["false"
						{
							s NLPSave=reportNLPSave
							q
						}
					}
				}
				else
				{
					s falseFlag=1
					s result="{'success':'false','errorinfo':'"_type_"类型暂不支持！'}"
				}
				if NLPSave["false"
				{						
					s result=NLPSave, falseFlag=1
				}
			}
			else	// 其余，更新任务的所有NLP识别数据
			{
				s result=..InitNLPIdentify(taskId,taskObj.PatientDR.%Id())
			}
			if falseFlag=1
			{
				TRO
			}
			else
			{
				TC
			}
			d taskObj.%Close()
		}
	}
	s:result="" result="{success:'true'}"
	q result
}

}
