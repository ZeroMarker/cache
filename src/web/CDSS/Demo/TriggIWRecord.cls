/// Description: 操作识别词触发测评记录表
/// Creator: 杨继鸿
/// CreatDate： 2022-03-21
/// Table： WDT.CDSS.TriggIWRecord
Class web.CDSS.Demo.TriggIWRecord Extends %RegisteredObject
{

/// Creator：杨继鸿
/// CreatDate: 2022-03-21
/// Description：查询方法
/// Input： rowid tasksid 任务集详情ID
/// Output: RowId,TasksDetailDR,IdentifyWordsDR,PTableNameStr,PFiledNameStr,PFiledValueStr,ProblemType,ProblemDesc,OperatorUser,OperationTime
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.Demo.TriggIWRecord","GetList","","17")
Query GetList(rowid, tasksid As %String) As %Query(ROWSPEC = "RowId,TasksDetailDR,IdentifyWordsDR,WordsType,WordsDesc,PTableNameStr,PFiledNameStr,PFiledValueStr,ProblemType,ProblemDesc,OperatorUser,OperationTime")
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
		// RowId,TasksDetailDR,IdentifyWordsDR,PTableNameStr,PFiledNameStr,PFiledValueStr,ProblemType,ProblemDesc,OperatorUser,OperationTime
		s RowId=rowid
		s TasksDetailDR=$LISTGET($G(^WDT.CDSS.TriggIWRecordD(RowId)),2)	// 识别词触发任务集详情表DR
		s IdentifyWordsDR=$LISTGET($G(^WDT.CDSS.TriggIWRecordD(RowId)),3)		// 识别词id
		if ##class(CT.WDT.CDSS.IdentifyWords).%ExistsId(IdentifyWordsDR)
		{
			s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(IdentifyWordsDR)),3)	//识别名称
			s WordsType=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(IdentifyWordsDR)),4)	//识别类型
		}
		else
		{
			s WordsType=""	//识别类型
			s WordsDesc=""	//识别名称
		}
		s PTableNameStr=$LISTGET($G(^WDT.CDSS.TriggIWRecordD(RowId)),4)		// 触发识别词的患者信息表
		s PFiledNameStr=$LISTGET($G(^WDT.CDSS.TriggIWRecordD(RowId)),5)			// 触发识别词的患者信息表字段
		s PFiledValueStr=$LISTGET($G(^WDT.CDSS.TriggIWRecordD(RowId)),6)			// 触发识别词的患者信息表项目名称字段值
		s ProblemType = $LISTGET($G(^WDT.CDSS.TriggIWRecordD(RowId)),7)	// 问题分类
		s ProblemDesc = $LISTGET($G(^WDT.CDSS.TriggIWRecordD(RowId)),8)	// 问题描述
		s OperatorUser = $LISTGET($G(^WDT.CDSS.TriggIWRecordD(RowId)),9)	// 操作人员
		s OperationTime = $LISTGET($G(^WDT.CDSS.TriggIWRecordD(RowId)),10)	// 操作时间

		d OutputRow
	}
	else
	{
		/*
		k ^TempDataHandle($ZNAME,repid,$JOB)
		
		s ID=0
		for 
		{
			s ID=$o(^WDT.CDSS.TriggIWRecordI("TasksDetailIndex",tasksid,ID))
			q:ID=""
			s OperationTime = $LISTGET($G(^WDT.CDSS.TriggIWRecordD(ID)),10)	// 操作时间
			s ^TempDataHandle($ZNAME,repid,$JOB,"OperationTime",OperationTime,ID)=""
		}
		//s ID=0
		s optime=""
		for
		{
			s optime=$o(^TempDataHandle($ZNAME,repid,$JOB,"OperationTime",optime),-1)
			q:optime=""
			
			s RowId=""
			for
			{
				s RowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"OperationTime",optime,RowId))
				q:RowId=""
				
		*/
		s OperationTime=""
		for
		{
			
			s OperationTime=$o(^WDT.CDSS.TriggIWRecordI("OperationTimeIndex",OperationTime),-1) q:OperationTime=""
			s RowId=""
			for {
				s RowId = $o(^WDT.CDSS.TriggIWRecordI("TasksTimeIndex",tasksid,OperationTime,RowId)) q:RowId=""
				s TasksDetailDR=$LISTGET($G(^WDT.CDSS.TriggIWRecordD(RowId)),2)	// 识别词触发任务集详情表DR
				s IdentifyWordsDR=$LISTGET($G(^WDT.CDSS.TriggIWRecordD(RowId)),3)		// 识别词id
				if ##class(CT.WDT.CDSS.IdentifyWords).%ExistsId(IdentifyWordsDR)
				{
					s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(IdentifyWordsDR)),3)	//识别名称
					s WordsType=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(IdentifyWordsDR)),4)	//识别类型
				}
				else
				{
					s WordsType=""	//识别类型
					s WordsDesc=""	//识别名称
				}
				s PTableNameStr=$LISTGET($G(^WDT.CDSS.TriggIWRecordD(RowId)),4)		// 触发识别词的患者信息表
				s PFiledNameStr=$LISTGET($G(^WDT.CDSS.TriggIWRecordD(RowId)),5)			// 触发识别词的患者信息表字段
				s PFiledValueStr=$LISTGET($G(^WDT.CDSS.TriggIWRecordD(RowId)),6)			// 触发识别词的患者信息表项目名称字段值
				
				s ProblemType = $LISTGET($G(^WDT.CDSS.TriggIWRecordD(RowId)),7)	// 问题分类
				s ProblemDesc = $LISTGET($G(^WDT.CDSS.TriggIWRecordD(RowId)),8)	// 问题描述
				s OperatorUser = $LISTGET($G(^WDT.CDSS.TriggIWRecordD(RowId)),9)	// 操作人员
				s OperationTime = $LISTGET($G(^WDT.CDSS.TriggIWRecordD(RowId)),10)	// 操作时间
				if (PFiledValueStr'=""){	//过滤命中条件为空的数据 ZWW 
					d OutputRow
				}
				
			}
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowId,TasksDetailDR,IdentifyWordsDR,WordsType,WordsDesc,PTableNameStr,PFiledNameStr,PFiledValueStr,ProblemType,ProblemDesc,OperatorUser,OperationTime)
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
/// CreatDate: 2022-03-21
/// Description：保存方法
/// Input： flag 调用接口来源标志 0-关联操作 1-用户操作 web.CDSSEntity.Demo.TriggIWRecord
/// Output: success 成功true,失败false id 任务集ID errorinfo 错误原因
/// Other: d ##class(web.CDSS.Demo.TriggIWRecord).SaveData("")
ClassMethod SaveData(flag As %String = "1", eobj As web.CDSSEntity.Demo.TriggIWRecord) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="") & (flag="1") //用户新增，添加识别词ID
		{
			//找IWordID
			s wordDesc=$p(eobj.WordsDesc,"（",1)
			s wordType=$p($p(eobj.WordsDesc,"（",2),"）",1)
			s:wordDesc'="" wordDesc=$ZCONVERT(wordDesc,"U")	//转换为大写 2022-07-27
			s:wordType="" eobj.IdentifyWordsDR=$o(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_wordDesc,0))
			
			s:wordType'="" eobj.IdentifyWordsDR=$o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",wordDesc,wordType,0))
			
		}
		elseif (eobj.RowId'="") & (flag="1") //用户修改，更新识别词ID
		{
			s WordDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsI(eobj.IdentifyWordsDR)),3)
			s WordType=$lg($g(^CT.WDT.CDSS.IdentifyWordsI(eobj.IdentifyWordsDR)),4)
			if (WordDesc'=eobj.WordsDesc)||(eobj.WordType'=WordType)
			{
				//识别词被修改
				//找IWordID
				s wordDesc=$p(eobj.WordsDesc,"（",1)
				s wordType=$p($p(eobj.WordsDesc,"（",2),"）",1)
				s:wordType="" eobj.IdentifyWordsDR=$o(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_wordDesc,0))
				s:wordType'="" eobj.IdentifyWordsDR=$o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",wordDesc,wordType,0))
			}
		}
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(WDT.CDSS.TriggIWRecord).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(WDT.CDSS.TriggIWRecord).%OpenId(eobj.RowId)
		    s bobj = ##class(web.CDSSEntity.Demo.TriggIWRecord).%New()
		    s bobj.TasksDetailDR = obj.TasksDetailDR.%Id()
			s bobj.IdentifyWordsDR = obj.IdentifyWordsDR
			s bobj.PTableNameStr = obj.PTableNameStr
			s bobj.PFiledNameStr=obj.PFiledNameStr
			s bobj.PFiledValueStr=obj.PFiledValueStr
			s bobj.ProblemType=obj.ProblemType
			s bobj.ProblemDesc=obj.ProblemDesc
			s bobj.OperationTime = obj.OperationTime
			s bobj.OperatorUser = obj.OperatorUser
		}
		// 处理&
		s pFiledValueStr=""
		for i=1:1:$length(eobj.PFiledValueStr,"&")
		{
			s v=$P(eobj.PFiledValueStr,"&",i)
			if (v'="")
			{
				if (pFiledValueStr'="")
				{
					s pFiledValueStr=pFiledValueStr_"，"_v
				}
				else
				{
					s pFiledValueStr=v
				}
			}
		}
		d obj.TasksDetailDRSetObjectId(eobj.TasksDetailDR)
		s obj.IdentifyWordsDR = eobj.IdentifyWordsDR
		s obj.PTableNameStr = eobj.PTableNameStr
		s obj.PFiledNameStr=eobj.PFiledNameStr
		s obj.PFiledValueStr=pFiledValueStr
		s obj.ProblemType=eobj.ProblemType
		s obj.ProblemDesc=eobj.ProblemDesc
		s obj.OperationTime = $zdt($h,3)
		s:$d(%session) obj.OperatorUser=$g(%session.Data("LOGON.USERNAME"))
		s:'$d(%session) obj.OperatorUser="Demo Group"
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			//仅对用户新增的数据，保存日志
			if flag="1"
			{
				d ##class(web.CDSS.Demo.TriggTasksDetail).UpdateState(eobj.TasksDetailDR)
				d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TriggIWRecord","WDT.CDSS.TriggIWRecord","识别词触发测评记录表",id,eobj.IdentifyWordsDR,"A",eobj)
				d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TriggIWRecord","WDT.CDSS.TriggIWRecord","识别词触发测评记录表",id,eobj.IdentifyWordsDR,"U",eobj,bobj)
			}
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词触发测评记录表","web.CDSS.Demo.TriggIWRecord","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}		
	}
	q result
ERROR
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词触发测评记录表","web.CDSS.Demo.TriggIWRecord","SaveData",eobj)
	s ^ERRORLOGINFO(logid)=$ze
	s result= "{success:'false',errorinfo:'保存失败！'}"
	q result
}

/// Creator:杨继鸿
/// CreatDate:2022-03-17
/// Description: 删除方法
/// Table: WDT.CDSS.TriggIWRecord
/// Input: flag 删除来源 0-批量删除 1-用户删除 rowid
/// Return: 删除成功返回{success:'true'}，失败返回{success:'false',errorinfo:""}
/// others: w ##class(web.CDSS.Demo.TriggIWRecord).DeleteData("1","1")
ClassMethod DeleteData(flag As %String = "1", rowid As %String) As %String
{
	s result=""
	
	s obj=##class(WDT.CDSS.TriggIWRecord).%OpenId(rowid)
	if (obj'="")
	{
		s bobj = ##class(web.CDSSEntity.Demo.TriggIWRecord).%New()
	    s bobj.TasksDetailDR = obj.TasksDetailDR.%Id()
		s bobj.IdentifyWordsDR = obj.IdentifyWordsDR
		s bobj.PTableNameStr = obj.PTableNameStr
		s bobj.PFiledNameStr=obj.PFiledNameStr
		s bobj.PFiledValueStr=obj.PFiledValueStr
		s bobj.ProblemType=obj.ProblemType
		s bobj.ProblemDesc=obj.ProblemDesc
		s bobj.OperationTime = obj.OperationTime
		s bobj.OperatorUser = obj.OperatorUser

		Ts	
			
		s sc=##class(WDT.CDSS.TriggIWRecord).%DeleteId(rowid)
		if $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true'}"
			
			if flag="1"
			{
				d ##class(web.CDSS.Demo.TriggTasksDetail).UpdateState(bobj.TasksDetailDR)
				//保存日志
				d:flag="1" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TriggIWRecord","WDT.CDSS.TriggIWRecord","识别词触发测评记录表",rowid,bobj.IdentifyWordsDR,"D",bobj)
			}
	    	
			d bobj.%Close()
		}
		else
		{
			Tro
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			
	       	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词触发测评记录表","web.CDSS.Demo.TriggIWRecord","DeleteData",bobj)
	       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	       	d bobj.%Close()
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'数据不存在'}"  //返回错误信息
	}    
	q result
}

/// w ##class(web.CDSS.Demo.TriggIWRecord).BatchSaveData("1","2022-03-17 15:33:34","yjh","2,3")
ClassMethod BatchSaveData(taskID, OperationTime As %String, OperatorUser, PatIDStr As %String = "") As %String
{
	s result=""
	s count=0
	s length=$length(PatIDStr,",")
	
	TS
	for i=1:1:length
	{
		s patID=$p(PatIDStr,",",i)
	    s eobj = ##class(web.CDSSEntity.Demo.TriggIWRecord).%New()
	    s eobj.PatientDR = patID
		s eobj.TaskDR = taskID
		s eobj.State = "0"
		s eobj.OperationTime = OperationTime
		s eobj.OperatorUser = OperatorUser
		
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
		s result="{success:'true',count:'"_count_"'}"
	}
	q result
}

/// Creator：      杨继鸿
/// CreatDate：    2022-04-13
/// Description:：   批量删除数据
/// Input：            taskid WDT.CDSS.TriggTasksDetail的ID
/// Output：          result json字符串
/// Return：         成功 "{success:'true',count:删除的数量}"；失败 "{success:'false',errorinfo:'...'}"
/// Others：        w ##class(web.CDSS.Demo.TriggIWRecord).BatchDeleteData("1")
ClassMethod BatchDeleteData(taskID) As %String
{
	s result=""
	s count=0
	
	s ID=""
	TS
	for
	{
		s ID=$o(^WDT.CDSS.TriggIWRecordI("TasksDetailIndex",taskID,ID))
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

/// w ##class(web.CDSS.Demo.TriggIWRecord).Test()
ClassMethod Test()
{
    s bobj = ##class(web.CDSSEntity.Demo.TriggIWRecord).%New()
    s bobj.RowId="16"
    s bobj.TasksDetailDR = "1"
	s bobj.IdentifyWordsDR = "364"
	//s bobj.PTableNameStr = "&WDT.CDSS.ExamInfo"
	//s bobj.PFiledNameStr= "&ExamName"
	s bobj.WordsDesc="肺含铁血黄素沉积症（识别条件）"
	s bobj.WordsType="识别条件"
	s bobj.PFiledValueStr= ""
	s bobj.ProblemType="未触发待查因"
	s bobj.ProblemDesc="测试"
	//s bobj.OperationTime = "2022-04-11 13:36:55"
	//s bobj.OperatorUser = "Demo Group"
	
	s rs=..SaveData("0",bobj)
	q rs
}

/// Creator:杨继鸿
/// CreatDate:2022-04-11
/// Description:获取识别词(未用)
/// Input：patid WDT.CDSS.DEMOPatMaster的ID；taskid WDT.CDSS.TriggTasksDetail的ID
/// Return：成功 "{success:'true'}"；失败 "{success:'false',errorinfo:'...'}"
/// Others：d ##class(web.CDSS.Demo.TriggIWRecord).GetSatisfyIW(284,1)
ClassMethod GetSatisfyIW(patid As %String, taskid As %String) As %String
{
	// 操作人员
	s:$g(%session)'="" OpUser = $g(%session.Data("LOGON.USERNAME"))	
	s:$g(%session)="" OpUser = "Demo Group"
	if (##class(WDT.CDSS.DEMOPatMaster).%ExistsId(patid))
	{
		s IDNO=$lg($g(^WDT.CDSS.DEMOPatMasterD(patid)),2)
		s PatientDR=$lg($g(^WDT.CDSS.DEMOPatMasterD(patid)),3)
		s VisitID=$lg($g(^WDT.CDSS.DEMOPatMasterD(patid)),5)
		s VisitType="住院"	//就诊类型 1急诊，2门诊，3住院
		s Department=$lg($g(^WDT.CDSS.DEMOPatMasterD(patid)),14)	//科室
		s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
		
		s PatientInfo=IDNO_"^"_PatientDR_"^"_VisitID_"^"_VisitType_"^^"_OpUser_"^^"_Department_"^"_Config
		
		s IWArray=""  //符合索引条件的识别词
		
		K ^TempPInfoItemData(PatientInfo)
		//先获取患者模型数据，避免多次获取
		d ##class(web.CDSS.IdentifyWords.GetPatientIW).CreatePatientInfoData(PatientInfo)
		
		if (PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
		{
			//获取患者信息更新可能触发的识别词
			if ($d(^WDT.CDSS.PatPMTypeIndexI("PatVisDRUpTypeIndex",PatientDR,VisitID,"1")))
			{
				s DataType=0
				for
				{
					s DataType =$o(^WDT.CDSS.PatPMTypeIndexI("PatVisDRUpTypeIndex",PatientDR,VisitID,"1",DataType))  q:DataType=""  
					if $d(^WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType))  //存在这个数据类型的索引
					{
						if ($d(^CT.WDT.CDSS.WordsItemI("ParTypeIdx",DataType,-100000000000000))) //类型关联的识别词项目有父节点
						{
							
							s WordsItemRowId=$o(^CT.WDT.CDSS.WordsItemI("ParTypeIdx",DataType,-100000000000000,""))
						
							s FiledName=""
							s:WordsItemRowId'="" FiledName=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemRowId)),7) 
							if (FiledName'="") //类型关联的字段不为空
							{
								if (FiledName="DiagnosisName")   //评估表用到 全部诊断 单独处理
								{
									s PInfoItem=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,DataType) //取患者模型的数据
									continue:(PInfoItem="")||(PInfoItem="[]")
									s PInfoItem=[].%FromJSON(PInfoItem)
									s DataValue=(PInfoItem.%Get(0)).%Get(FiledName)
									s DataType1="全部诊断"
									if (DataValue'="")&&($d(^WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataType1)))
									{
										s IWRowId=0
										for 
										{
											s IWRowId=$o(^WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataType1,IWRowId)) q:IWRowId=""
											s IWArray(IWRowId)=""
										}
									}
									
								}
								
								if (FiledName="Sex")||(FiledName="Age")  //规则可能只用到年龄、性别，识别词表加年龄、性别的识别词 患者模型对应的值不为空即保存这两条数据
								{
									s PInfoItem=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,DataType) //取患者模型的数据
									continue:(PInfoItem="")||(PInfoItem="[]")
									s PInfoItem=[].%FromJSON(PInfoItem)
									s DataValue=(PInfoItem.%Get(0)).%Get(FiledName)
									if (DataValue'="")&&($d(^WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataType)))
									{
										s IWRowId=0
										for 
										{
											s IWRowId=$o(^WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataType,IWRowId)) q:IWRowId=""
											s IWArray(IWRowId)=""
										}
									}
									
								}
								else
								{
									s PInfoItem=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,DataType) //取患者模型的数据
									continue:(PInfoItem="")||(PInfoItem="[]")
									
									s PInfoItem=[].%FromJSON(PInfoItem)
									if (PInfoItem'="")  //患者模型取到的数据不为空
									{
										for i=0:1:(PInfoItem.%Size()-1)  //遍历条件
										{
											s lenFiledName=$length(FiledName,"&")
											for jFiled=1:1:lenFiledName
											{
												s ItemName=$p(FiledName,"&",jFiled)
												s DataValueStr=$tr((PInfoItem.%Get(i)).%Get(ItemName),"""","'")
												s lenDataValue=$l(DataValueStr,"&%")
												for ilenDataValue=1:1:lenDataValue
												{
													s DataValue=$p(DataValueStr,"&%",ilenDataValue)
													if (DataValue'="")&&($d(^WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataValue)))
													{
														s IWRowId=0
														for 
														{
															s IWRowId=$o(^WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataValue,IWRowId)) q:IWRowId=""
															s IWArray(IWRowId)=""
														}
													}
												}
												
												
											}
										}
										 
									}
								}	
							}
							elseif(DataType="体征")
							{
								s CommonTypeRowId=$o(^CT.WDT.CDSS.CommonDictTypeI("DescIndex"," "_$ZCONVERT("体征","U"),0))
								s CommonRowId=0
								for 
								{
									s CommonRowId=$o(^CT.WDT.CDSS.CommonDictI("TypeIndex",CommonTypeRowId,CommonRowId)) q:CommonRowId=""
									s DictDesc=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonRowId)),4)  
									s EnCommonName=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonRowId)),10)        //通用名英文名称 体重 Weight
									s PInfoItem=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,DictDesc) //取患者模型的数据
									continue:(PInfoItem="")||(PInfoItem="[]")
									s PInfoItem=[].%FromJSON(PInfoItem)
									if (PInfoItem'="")&&((PInfoItem.%Get(0)).%Get(EnCommonName)'="")&&($d(^WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DictDesc)))
									{
										s IWRowId=0
										for 
										{
											s IWRowId=$o(^WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DictDesc,IWRowId)) q:IWRowId=""
											s IWArray(IWRowId)=""
										}
									}
								}
							}
						}
					}
				}
			}
			//获取当前触发的识别词
			if ($d(^WDT.CDSS.PatTriggerIWI("PatVisDRIWIndex",PatientDR,VisitID)))
			{
				s IWRowId=0
				for 
				{
					s IWRowId=$O(^WDT.CDSS.PatTriggerIWI("PatVisDRIWIndex",PatientDR,VisitID,IWRowId)) q:IWRowId=""
					s IWArray(IWRowId)=""
				}
				
			}
		} 
		elseif (IDNO'="")  //患者主索引
		{
			//获取患者信息更新可能触发的识别词
			if ($d(^WDT.CDSS.PatPMTypeIndexI("IDNOUpTypeIndex",IDNO,"1")))
			{
				s DataType=0
				for
				{
					s DataType =$o(^WDT.CDSS.PatPMTypeIndexI("IDNOUpTypeIndex",IDNO,"1",DataType))  q:DataType=""  
					if $d(^WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType))  //存在这个数据类型的索引
					{
						if ($d(^CT.WDT.CDSS.WordsItemI("ParTypeIdx",DataType,-100000000000000))) //类型关联的识别词项目有父节点
						{
							
							s WordsItemRowId=$o(^CT.WDT.CDSS.WordsItemI("ParTypeIdx",DataType,-100000000000000,""))
							s FiledName=""
							s:WordsItemRowId'="" FiledName=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemRowId)),7) 
							if (FiledName'="") //类型关联的字段不为空
							{
								if (FiledName="DiagnosisName")   //评估表用到 全部诊断 单独处理
								{
									s PInfoItem=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,DataType) //取患者模型的数据
									continue:(PInfoItem="")||(PInfoItem="[]")
									s PInfoItem=[].%FromJSON(PInfoItem)
									s DataValue=(PInfoItem.%Get(0)).%Get(FiledName)
									s DataType1="全部诊断"
									if (DataValue'="")&&($d(^WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataType1)))
									{
										s IWRowId=0
										for 
										{
											s IWRowId=$o(^WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataType1,IWRowId)) q:IWRowId=""
											s IWArray(IWRowId)=""
										}
									}
									
								}
								
								if (FiledName="Sex")||(FiledName="Age")  //规则可能只用到年龄、性别，识别词表加年龄、性别的识别词 患者模型对应的值不为空即保存这两条数据
								{
									s PInfoItem=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,DataType) //取患者模型的数据
									continue:(PInfoItem="")||(PInfoItem="[]")
									s PInfoItem=[].%FromJSON(PInfoItem)
									s DataValue=(PInfoItem.%Get(0)).%Get(FiledName)
									if (DataValue'="")&&($d(^WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataType)))
									{
										s IWRowId=0
										for 
										{
											s IWRowId=$o(^WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataType,IWRowId)) q:IWRowId=""
											s IWArray(IWRowId)=""
										}
									}
									
								}
								else
								{
									s PInfoItem=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,DataType) //取患者模型的数据
									continue:(PInfoItem="")||(PInfoItem="[]")
									
									s PInfoItem=[].%FromJSON(PInfoItem)
									if (PInfoItem'="")  //患者模型取到的数据不为空
									{
										for i=0:1:(PInfoItem.%Size()-1)  //遍历条件
										{
											s lenFiledName=$length(FiledName,"&")
											for jFiled=1:1:lenFiledName
											{
												s ItemName=$p(FiledName,"&",jFiled)
												s DataValueStr=$tr((PInfoItem.%Get(i)).%Get(ItemName),"""","'")
												s lenDataValue=$l(DataValueStr,"&%")
												for ilenDataValue=1:1:lenDataValue
												{
													s DataValue=$p(DataValueStr,"&%",ilenDataValue)
													if (DataValue'="")&&($d(^WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataValue)))
													{
														s IWRowId=0
														for 
														{
															s IWRowId=$o(^WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DataValue,IWRowId)) q:IWRowId=""
															s IWArray(IWRowId)=""
														}
													}
												}	
											}
										}
									} 
								}
								
							}
							elseif(DataType="体征")
							{
								s CommonTypeRowId=$o(^CT.WDT.CDSS.CommonDictTypeI("DescIndex"," "_$ZCONVERT("体征","U"),0))
								s CommonRowId=0
								for 
								{
									s CommonRowId=$o(^CT.WDT.CDSS.CommonDictI("TypeIndex",CommonTypeRowId,CommonRowId)) q:CommonRowId=""
									s DictDesc=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonRowId)),4)  
									s EnCommonName=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonRowId)),10)        //通用名英文名称 体重 Weight
									s PInfoItem=##class(web.CDSS.IdentifyWords.GetPatientInfo).DealDataByPatientEnumI(PatientInfo,DictDesc) //取患者模型的数据
									continue:(PInfoItem="")||(PInfoItem="[]")
									s PInfoItem=[].%FromJSON(PInfoItem)
									if (PInfoItem'="")&&((PInfoItem.%Get(0)).%Get(EnCommonName)'="")&&($d(^WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DictDesc)))
									{
										s IWRowId=0
										for 
										{
											s IWRowId=$o(^WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",DataType,DictDesc,IWRowId)) q:IWRowId=""
											s IWArray(IWRowId)=""
										}
									}
								}
							}
						}
					}
				}
			}
			//获取当前触发的识别词
			if ($d(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO)))
			{
				s IWRowId=0
				for 
				{
					s IWRowId=$O(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO,IWRowId)) q:IWRowId=""
					s IWArray(IWRowId)=""
				}
				
			}
			
		}
		s result=""	//返回值
		//判断识别词是否满足条件 满足保存到患者识别词表
		s IWRowId=0
		for
		{
			s IWRowId=$o(IWArray(IWRowId)) q:IWRowId=""
			s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(IWRowId)),3)
			//年龄、性别是为了触发规则的年龄和性别条件增加的项目，全部诊断是方便有些评估表关联的诊断是全部诊断，评估表一直需要推荐的情况
			if (WordsDesc="年龄")||(WordsDesc="性别")||(WordsDesc="全部诊断")
			{
				s flag=1
			}
			else
			{
				s flag=##class(web.CDSS.IdentifyWords.GetPatientIW).DealIdentifyWords(IWRowId,PatientInfo)
			}
			if (flag=1)
			{				
				if ('$d(^WDT.CDSS.PatTriggerIWI("PatVisDRIWIndex",PatientDR,VisitID,IWRowId))&&('$d(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO,IWRowId))))
				{
					Ts
					s obj=##class(WDT.CDSS.PatTriggerIW).%New()
					s obj.IDNO=IDNO
					s obj.PatientDR=PatientDR
					s obj.VisitID=VisitID
					s obj.VisitType=VisitType
					d obj.IdentifyWordsDRSetObjectId(IWRowId)
					s obj.PTableNameStr=$g(^TMPIdentifyW(PatientInfo,"PTableName"))
					s obj.PFiledNameStr=$g(^TMPIdentifyW(PatientInfo,"PTableName","PFiledName"))
					s obj.PFiledValueStr=$g(^TMPIdentifyW(PatientInfo,"PTableName","PFiledName","PFiledValue"))
					
					s sc=obj.%Save()
	                d obj.%Close()
	                					
					s trueflag=0
	                If $$$ISOK(sc)
		            {
		                s trueflag=1
		                s id = obj.%Id()
		                /*
						//保存到WDT.CDSS.TriggIWRecord表中
					    s eobj = ##class(web.CDSSEntity.Demo.TriggIWRecord).%New()
					    s eobj.TasksDetailDR = taskid	// 识别词触发任务集详情表DR
						s eobj.IdentifyWordsDR = IWRowId	// 识别词id
						s eobj.PTableNameStr = obj.PTableNameStr
						s eobj.PFiledNameStr=obj.PFiledNameStr
						s eobj.PFiledValueStr=obj.PFiledValueStr	//命中条件
						//s eobj.ProblemType=obj.ProblemType	// 问题分类
						//s eobj.ProblemDesc=obj.ProblemDesc	// 问题描述
						s eobj.OperationTime = $zdt($h,3)	// 操作时间
						s eobj.OperatorUser=OpUser
						s rs=##class(web.CDSS.Demo.TriggIWRecord).SaveData("0",eobj)
						if rs["false"
						{
							s trueflag=0
						}
						*/
		                //保存日志
						//d ##class(web.CDSS.Config.DataChangeLog).SaveLog("DHCDSSPatTriggerIW","WDT.CDSS.PatTriggerIW","患者当前触发的识别词",id,obj.IDNO,"A",obj)
					}
		            else
		            {
		                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		                //s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("患者当前触发的识别词","web.CDSS.MedicalRule.DiagAndTreatR","SaveData",obj)
		       	    	//s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		            }
		            if trueflag=1
		            {
			            TC
		            }
		            else
		            {
			            TRO
		            }
		            k ^TMPIdentifyW(PatientInfo)
				}
			}
			else
			{
				s PatIWRowId=""
				if $d(^WDT.CDSS.PatTriggerIWI("PatVisDRIWIndex",PatientDR,VisitID,IWRowId))
				{
					s PatIWRowId=$O(^WDT.CDSS.PatTriggerIWI("PatVisDRIWIndex",PatientDR,VisitID,IWRowId,""))
				}
				elseif $d(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO,IWRowId))
				{
					s PatIWRowId=$O(^WDT.CDSS.PatTriggerIWI("IDNOIWIndex",IDNO,IWRowId,""))
				}
				if (PatIWRowId'="")
				{
					s delsc=##class(WDT.CDSS.PatTriggerIW).%DeleteId(PatIWRowId)
				}
			}
		}
		//d ##class(web.CDSS.IdentifyWords.GetPatientIW).UpdatePMTypeIndex(PatientInfo)  //更新患者汇总信息索引表
		d ##class(web.CDSS.MedicalRule.GetPatientRule).GetSatisfyRule(PatientInfo) //更新患者当前触发的规则
		s:result="" result="{success:'true'}"
	}
	else
	{
		s result="{success:'false',errorinfo:'数据不存在'}"
	}
	q result
}

/// Creator: 杨继鸿
/// CreatDate: 2022-04-20
/// Description: 识别词名称下拉框query，支持首拼检索
/// Input: rowid 识别词id；desc 检索词；q 检索词
/// Others: d ##class(%ResultSet).RunQuery("web.CDSS.Demo.TriggIWRecord","GetDataForIWordComb","","xg","")
Query GetDataForIWordComb(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "IWordID,WordsDesc")
{
}

ClassMethod GetDataForIWordCombExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
 	if (rowid'="") //根据rowid返回该条记录
 	{
 		s IWordID=rowid
  		s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(IWordID)),3)	// 识别词名称
  		d OutputRowCmb
 	}
 	else
 	{
  		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  		s:q'="" q=$ZCONVERT(q,"U") //转换成大写
  		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
  		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.IdentifyWordsD(ID))
			q:ID=""
	  		s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(ID)),3)	// 识别词名称
			s length=$l(WordsDesc)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s IWordID=0
			for
			{
				s IWordID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,IWordID))
				q:IWordID=""
				//s DrugDictDR=IWordID
				//s DrugDictDR=$o(^CT.WDT.CDSS.IdentifyWordsD(DrugDictDR),-1) q:DrugDictDR=""  
		  		s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(IWordID)),3)	// 识别词名称
		  		s type=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(IWordID)),4)	// 类型		  		
		  		s hasOtherTypeFlag=0
		  		s otherType=$O(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",WordsDesc,type),1)
		  		s:otherType'="" hasOtherTypeFlag=1
		  		s otherType=$O(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",WordsDesc,type),-1)
		  		s:otherType'="" hasOtherTypeFlag=1
  				s PINYIN=""
  				s:q'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(WordsDesc)
  				s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(WordsDesc)
  				b ; w
  				s MaintainFlag=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(IWordID)),5)	// 状态（编辑中/审核中/不通过/已上线/下线）
  				//s MaintainFlag=$case(MaintainFlag,0:"编辑中",1:"已删除",2:"已审核","":"编辑中")
  				//continue:(MaintainFlag'=2)
  				if (($ZCONVERT(WordsDesc,"U")[desc)||(PINYIN[desc)&(($ZCONVERT(WordsDesc,"U")[q)||(PINYIN[q))&(MaintainFlag="已上线")) {
	  				s:hasOtherTypeFlag=1 WordsDesc=WordsDesc_"（"_type_"）"
  					d OutputRowCmb
  				}  		
  				continue:((desc'="")||(q'=""))		
				s num=num+1
				q:num=1000
			}
			q:num=1000
		}
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(IWordID,WordsDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForIWordCombFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForIWordCombExecute ]
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

ClassMethod GetDataForIWordCombClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForIWordCombExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      杨继鸿
/// CreatDate：    2022-04-12
/// Description:：   更新触发识别词
/// Input：            patid WDT.CDSS.DEMOPatMaster的ID；taskid WDT.CDSS.TriggTasksDetail的ID
/// Output：          result json字符串
/// Return：         成功 "{'success':'true', 'id':'taskid'}"；失败 "{success:'false',errorinfo:'...'}"
/// Others：        w ##class(web.CDSS.Demo.TriggIWRecord).UpdateIWRecord(29,1014)
ClassMethod UpdateIWRecord(taskid, patid)
{
	s result=""
	
	s flag=0
	TS
	// 批量删除旧数据
	s batchDel=..BatchDeleteData(taskid)
	if batchDel'["false"
	{
		// 更新识别词记录
		s getIWords=##class(web.CDSS.Demo.TriggIWRecord).InitIWRecords(taskid,patid)
		
		s:getIWords["false" result=getIWords, flag=1
	}
	else
	{
		s flag=1
		s result=batchDel
	}
	if flag=1
	{
		// 失败
		TRO
	}
	else
	{
		TC
		s result="{'success':'true', 'id':'"_taskid_"'}"
	}
	q result
}

/// Creator: 杨继鸿
/// CreatDate: 2022-04-15
/// Description: 初始化识别词触发效果记录
/// Input: taskid WDT.CDSS.TriggTasksDetail的ID；patid WDT.CDSS.DEMOPatMaster的ID；
/// Output: result json字符串
/// Return: 成功 "{success:'true',count:删除的数量}"；失败 "{success:'false',errorinfo:'...'}"
/// Others: w ##class(web.CDSS.Demo.TriggIWRecord).InitIWRecords("29",1014)
ClassMethod InitIWRecords(taskid, patid)
{
	s result=""
	
	s taskObj=##class(WDT.CDSS.TriggTasksDetail).%OpenId(taskid)
	s patObj=##class(WDT.CDSS.DEMOPatMaster).%OpenId(patid)
	if taskObj=""
	{
		s result="{success:'false',errorinfo:'任务不存在！'}"
	}
	elseif patObj=""
	{
		s result="{success:'false',errorinfo:'患者不存在！'}"
	}
	else
	{
		// 获取最新的触发识别词
		// 拼患者信息串
		s IDNO=$lg($g(^WDT.CDSS.DEMOPatMasterD(patid)),2)
		s PatientDR=$lg($g(^WDT.CDSS.DEMOPatMasterD(patid)),3)
		s VisitID=$lg($g(^WDT.CDSS.DEMOPatMasterD(patid)),5)
		s VisitType="住院"	//就诊类型 1急诊，2门诊，3住院
		s Department=$lg($g(^WDT.CDSS.DEMOPatMasterD(patid)),14)	//科室
		s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
		
		// 操作人员
		s:$g(%session)'="" OpUser = $g(%session.Data("LOGON.USERNAME"))	
		s:$g(%session)="" OpUser = "Demo Group"
		s PatientInfo=IDNO_"^"_PatientDR_"^"_VisitID_"^"_VisitType_"^^"_OpUser_"^^"_Department_"^"_Config
		
		s ^TMP("ldy")=PatientInfo
		s getNewIWords=##class(web.CDSS.IdentifyWords.GetPatientIW).GetSatisfyIW(PatientInfo)
		
		if (getNewIWords'["false")
		{
			s patIWID=0
			s flag=0	//有保存失败的标志，0-不存在，1-存在
			s count=0	//总计保存成功的数量
			TS
			for
			{
				//s patIWID=$O(^WDT.CDSS.PatTriggerIWI("IDNOIndex"," "_patObj.IDNO,patIWID))
				s patIWID=$O(^WDT.CDSS.PatTriggerIWI("IDNOIndex",patObj.IDNO,patIWID))
				q:patIWID=""
				s wordID=$lg($G(^WDT.CDSS.PatTriggerIWD(patIWID)),6)	// 识别词id
				
				// 数据重复验证
				s repeatflag=$d(^WDT.CDSS.TriggIWRecordI("IWordsIndex",taskid," "_wordID))
				if (repeatflag>0)
				{
					continue
				}
				else
				{
					//取当前患者识别词，保存到WDT.CDSS.TriggIWRecord
				    s eobj = ##class(web.CDSSEntity.Demo.TriggIWRecord).%New()
				    s eobj.TasksDetailDR = taskid	// 识别词触发任务集详情表DR
					s eobj.IdentifyWordsDR = wordID	// 识别词id
					s eobj.PTableNameStr = $lg($G(^WDT.CDSS.PatTriggerIWD(patIWID)),8)	//wordObj.PTableNameStr
					s eobj.PFiledNameStr=$lg($G(^WDT.CDSS.PatTriggerIWD(patIWID)),9)	//wordObj.PFiledNameStr
					s eobj.PFiledValueStr=$lg($G(^WDT.CDSS.PatTriggerIWD(patIWID)),10)	//命中条件
					s saveIWRecord=..SaveData("0",eobj)
					if saveIWRecord["false"
					{
						s flag=1
						s result=saveIWRecord
					}
					else
					{
						s count=count+1
					}
				}

			}
			if flag=1
			{
				TRO
			}
			else
			{
				TC
				s result="{success:'true',count:'"_count_"'}"
			}
		}
		d taskObj.%Close()
		d patObj.%Close()
	}
	q result
}

}
