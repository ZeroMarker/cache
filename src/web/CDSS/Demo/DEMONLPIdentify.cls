/// 名称:     web.CDSS.Demo.DEMONLPIdentify.cls
/// 描述:     操作【NLP识别表】，操作【疑似诊断评测记录表】，操作【疑似诊断评测记录详情表】
/// 编写者：  杨继鸿
/// 编写日期: 2021-11-10
Class web.CDSS.Demo.DEMONLPIdentify Extends %RegisteredObject
{

/// Creator：      杨继鸿
/// CreatDate：    2021-12-06
/// Description:   获取患者基本信息
/// Table：        WDT.CDSS.DEMOPatMaster
/// Input：        tasksdetailDR 病历任务集详情表ID, documentType
/// Output：       PatientDR,IDNO,Department,Sex,Age
/// Return：       与任务集关联的患者基本信息
/// Others：       d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DEMONLPIdentify","GetPatMasterList","1","入院记录") 
Query GetPatMasterList(tasksdetailID As %String, documentType As %String) As %Query(ROWSPEC = "PatientDR,IDNO,Department,Sex,Age")
{
}

ClassMethod GetPatMasterListExecute(ByRef qHandle As %Binary, tasksdetailID As %String, documentType As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (tasksdetailID'="")
    {
        s ID=tasksdetailID
        
        s PatientID=$lg($g(^WDT.CDSS.DEMOTasksDetailD(ID)),2)	// 患者基础信息表ID
        
        s IDNO=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatientID)),2)	// 患者主索引
        s PatientDR=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatientID)),3) //3-20
        s Department=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatientID)),14)	// 科室
        s Sex=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatientID)),9)	// 性别
        s Age=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatientID)),11)	// 年龄

        d OutputPatMasterRow
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputPatMasterRow
    set Data=$lb(PatientDR,IDNO,Department,Sex,Age)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetPatMasterListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatMasterListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetPatMasterListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatMasterListExecute ]
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

/// Creator：      杨继鸿
/// CreatDate：    2021-12-06
/// Description:   获取患者住院记录数据，和创建的任务的文书类型
/// Table：        WDT.CDSS.DEMOAdmRec, WDT.CDSS.DEMOTasks，WDT.CDSS.DEMOTasksDetail
/// Input：        tasksdetailID 病历任务集详情表ID, documentType
/// Output：       PatientDR,AdmRecordID,RecordTime,OriginalContent
/// Return：       与任务集关联的患者病历信息
/// Others：       d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DEMONLPIdentify","GetAdmRecList","4","入院记录") 
Query GetAdmRecList(tasksdetailID As %String, documentType As %String) As %Query(ROWSPEC = "PatientDR,AdmRecordID,RecordTime,DocumentType,OriginalContent")
{
}

ClassMethod GetAdmRecListExecute(ByRef qHandle As %Binary, tasksdetailID As %String, documentType As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s OriginalContent=""	// 病历原文内容
    if (tasksdetailID'="")
    {
        s ID=tasksdetailID
        
        s PatientDR=$lg($g(^WDT.CDSS.DEMOTasksDetailD(ID)),2)	// 患者基础信息表ID
        s TaskDR=$lg($g(^WDT.CDSS.DEMOTasksDetailD(ID)),3)	//病历任务集ID
        
        s DocumentType=$lg($g(^WDT.CDSS.DEMOTasksD(TaskDR)),4)	//文书类型
        
        s AdmRecordID=0	//患者住院-入院记录表ID
        
        s AdmRecordID=$o(^WDT.CDSS.DEMOAdmRecI("PatIndex",PatientDR,AdmRecordID))
        s RecordTime=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),20)	// 记录日期
        
        s ChiefCompSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),3)	//主诉概述
        s OriginalContent="<strong>主诉概述：</strong>"_ChiefCompSum_"<br>"
        s CurrentMedHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),4)	//现病史概述
        s OriginalContent=OriginalContent_"<strong>现病史概述：</strong>"_CurrentMedHisSum_"<br>"
        s PastDiagnosisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),5)	//既往史概述
        s OriginalContent=OriginalContent_"<strong>既往史概述：</strong>"_PastDiagnosisSum_"<br>"
        s AllergyHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),6)	//过敏史概述
        s OriginalContent=OriginalContent_"<strong>过敏史概述：</strong>"_AllergyHisSum_"<br>"
        s PersonalHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),7)	//个人史概述
        s OriginalContent=OriginalContent_"<strong>个人史概述：</strong>"_PersonalHisSum_"<br>"
        s MarryHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),8)	//婚育史概述
        s OriginalContent=OriginalContent_"<strong>婚育史概述：</strong>"_MarryHisSum_"<br>"
        s MenstrualHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),9)	//月经史概述
        s OriginalContent=OriginalContent_"<strong>月经史概述：</strong>"_MenstrualHisSum_"<br>"
        s FamilyHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),10)	//家族史概述
        s OriginalContent=OriginalContent_"<strong>家族史概述：</strong>"_FamilyHisSum_"<br>"
        s PhysicalExamSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),11)	//体格检查概述
        s OriginalContent=OriginalContent_"<strong>体格检查概述：</strong>"_PhysicalExamSum_"<br>"
        s SpecExamSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),12)	//专科检查概述
        s OriginalContent=OriginalContent_"<strong>专科检查概述：</strong>"_SpecExamSum_"<br>"
        s AssisExam=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),13)	//辅助检查
        s OriginalContent=OriginalContent_"<strong>辅助检查：</strong>"_AssisExam_"<br>"
        s PreliminaryDiag=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),15)	//初步诊断
        s OriginalContent=OriginalContent_"<strong>初步诊断：</strong>"_PreliminaryDiag_"<br>"
        s ConfirmDiag=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),16)	//确诊诊断
        s OriginalContent=OriginalContent_"<strong>确诊诊断：</strong>"_ConfirmDiag
        
        d OutputAdmRecRow
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputAdmRecRow
    set Data=$lb(PatientDR,AdmRecordID,RecordTime,DocumentType,OriginalContent)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetAdmRecListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmRecListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetAdmRecListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmRecListExecute ]
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

/// Creator:		杨继鸿
/// CreatDate:		2021-10-29
/// Description:	保存【NLP识别表】数据
/// Table:			WDT.CDSS.DEMONLPIdentify
/// Input:			rowid 病历任务集NLP识别表ID, NLPInfo NLP识别数据, TasksDetailID 病历任务集详情表ID, documentType 文书类型
/// Output:			JSON串：success（成功与否0失败、1成功）；id/ids(修改或新增数据ID串)；errorinfo 错误信息
/// Return:			成功返回{"success":1,["ids":"id^id"],["errorinfo":""]}，失败返回{"success":0,"errorinfo":""}
/// Others:			d ##class(web.CDSS.Demo.DEMONLPIdentify).SaveNLPIdentifyNew("", "{""1***肺炎"": ""胸腔积液，肺部感染(以收入)***现病史"", ""2***腹痛"": ""反复腹痛(归一词)腹痛、腰腹痛、腹部隐痛、腰腹胀痛、全腹胀痛、胸腹部疼痛、腹部不适(上位词)***主诉""}", "2", "入院记录")
/// d ##class(web.CDSS.Demo.DEMONLPIdentify).SaveNLPIdentifyNew("", "{""DocumentType"":""入院记录"",""IdentifyInfo"":""用户新增测试"",""NLPRecognition"":""用户新增测试"",""NLPSource"":""用户新增"",""ProblemType"":""未识别"",""TagContent"":""测试""}", "3")
/// d ##class(web.CDSS.Demo.DEMONLPIdentify).SaveNLPIdentifyNew("2", "{""DocumentType"":""入院记录"",""IdentifyInfo"":""用户新增测试"",""NLPRecognition"":""用户新增测试"",""NLPSource"":""用户新增"",""ProblemType"":""未识别"",""TagContent"":""测试""}", "1")
/// 
/// UpdateDate: 2021-12-27
/// 添加书写错误日志代码
ClassMethod SaveNLPIdentifyNew(rowid As %String = "", NLPInfo As %String, TasksDetailID As %String, documentType As %String = "") As %String
{
	s $zt="SaveNLPIdenERROE"
	s result={}
	s user=$g(%session.Data("LOGON.USERNAME"))
	//s user="yjh"
	//病历任务集NLP识别表JSON对象
	s jsonObj={"ID":"","TasksDetailDR":"","DocumentType":"","IdentifyInfo":"","NLPRecognition":"","NLPSource":"","ProblemType":"","TagContent":"","OperatorUser":"","OperationTime":"","IsOutput":"","IsSolve":""}
	s jsonObj.TasksDetailDR=TasksDetailID	// 指向病历任务集详情ID
	s jsonObj.ID=rowid
	s jsonObj.DocumentType=documentType	// 文书类型
	// 修改数据
	if rowid'=""
	{
		// 解析数据，对数据库数据进行修改
		s idenObj={}.%FromJSON(NLPInfo)		
		s obj=##class(WDT.CDSS.DEMONLPIdentify).%OpenId(rowid)		
		
		if (obj'="")
		{
			// 备份旧数据
			s jsonObj.IdentifyInfo=obj.IdentifyInfo			// 识别信息
			s jsonObj.NLPRecognition=obj.NLPRecognition		// NLP识别结果
			s jsonObj.NLPSource=obj.NLPSource				// 识别来源:主诉/现病史/用户新增
			s jsonObj.ProblemType=obj.ProblemType			// 问题类型：识别错误/未识别
			s jsonObj.TagContent=obj.TagContent				// 标记内容
			s jsonObj.OperatorUser=obj.OperatorUser
			s jsonObj.OperationTime=obj.OperationTime
			
			s obj.IdentifyInfo=idenObj.IdentifyInfo
			s obj.NLPRecognition=idenObj.NLPRecognition
			s obj.ProblemType=idenObj.ProblemType
			s obj.TagContent=idenObj.TagContent
			s obj.OperatorUser=user
			s obj.OperationTime=$ZDATETIME($H,3)		
			
			TS
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				// 更新任务集详情表的状态，和操作时间		
				s tasksdetailre=##class(web.CDSS.Demo.DEMOTasks).SaveTasksDetail(TasksDetailID,"","",user)
				s tasksdetailre={}.%FromJSON(tasksdetailre)
				if (tasksdetailre.success)
				{
					TC
					d result.%Set("success",1)
					d result.%Set("id",rowid)
					//保存修改日志
					d ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("WDT_CDSS.DEMONLPIdentify","WDT.CDSS.DEMONLPIdentify","病历任务集NLP识别表",rowid,jsonObj.IdentifyInfo,"U",idenObj.%ToJSON(),jsonObj.%ToJSON())
				}
				else
				{
					//更新任务集详情失败，回滚保存NLP信息
					TRO
					d result.%Set("success",0)
					d result.%Set("errorinfo","保存NLP识别结果失败！原因如下：<br>"+tasksdetailre.errorinfo)
				}
			}
			else
			{
				Tro
				d result.%Set("success",0)
				d result.%Set("errorinfo","保存NLP识别结果失败！原因如下：<br>"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc))
				s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("病历任务集NLP识别表","web.CDSS.Demo.DEMONLPIdentify","SaveNLPIdentifyNew",idenObj.%ToJSON())
	   	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			}
		}
		else
		{
			d result.%Set("success",0)
			d result.%Set("errorinfo","保存NLP识别结果失败！原因如下：<br>数据不存在！")
		}
	}
	// 新增数据
	else
	{
		s idenObj={}.%FromJSON(NLPInfo)	// 解析JSON串
		// 用户自定义识别信息数据
		if idenObj.NLPSource="用户新增"
		{
			Ts
			s obj=##class(WDT.CDSS.DEMONLPIdentify).%New()
			
			d obj.TasksDetailDRSetObjectId(TasksDetailID)
			s obj.DocumentType=idenObj.DocumentType
			s obj.IdentifyInfo=idenObj.IdentifyInfo
			s obj.NLPRecognition=idenObj.NLPRecognition
			s obj.NLPSource=idenObj.NLPSource
			s obj.ProblemType=idenObj.ProblemType
			s obj.TagContent=idenObj.TagContent
			s obj.OperatorUser=user
			s obj.OperationTime=$ZDATETIME($H,3)
			
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				// 更新任务集详情表的状态，和操作时间
				s tasksdetailre=##class(web.CDSS.Demo.DEMOTasks).SaveTasksDetail(TasksDetailID,"","",user)
				s tasksdetailre={}.%FromJSON(tasksdetailre)
				if (tasksdetailre.success)
				{
					TC
					s id = obj.%Id()
					d result.%Set("success",1)
					d result.%Set("id",id)
					//保存新增日志
					d ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("WDT_CDSS.DEMONLPIdentify","WDT.CDSS.DEMONLPIdentify","病历任务集NLP识别表",id,idenObj.IdentifyInfo,"A",NLPInfo)
				}
				else
				{
					//更新任务集详情失败，回滚保存NLP信息
					TRO
					d result.%Set("success",0)
					d result.%Set("errorinfo","保存NLP识别结果失败！原因如下：<br>"+tasksdetailre.errorinfo)
				}				
			}
			else
			{
				Tro
				d result.%Set("success",0)
				s errorinfo=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				d result.%Set("errorinfo","保存NLP识别结果失败！原因如下：<br>"_errorinfo)
				
				//保存错误日志
				s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("病历任务集NLP识别表","web.CDSS.Demo.DEMONLPIdentify","SaveNLPIdentifyNew",idenObj.%ToJSON())
   	    		s ^ERRORLOGINFO(logid)=errorinfo
			}
		}
		// 初始化任务集中的NLP信息数据
		else
		{
			s flag=0
			s ids=""
			TStart
			s iter=idenObj.%GetIterator()
			while(iter.%GetNext(.key,.value))
			{
				s IdentifyInfo=$p(key, "***", 2)	// 识别信息
				s NLPRecognition=$p(value, "***", 1)	// NLP识别结果
				s NLPSource=$p(value, "***", 2)	// 识别来源:主诉/现病史
				
				s jsonObj.IdentifyInfo=IdentifyInfo	// 识别信息
				s jsonObj.NLPRecognition=NLPRecognition	// NLP识别结果
				s jsonObj.NLPSource=NLPSource	// 识别来源:主诉/现病史
				
				s obj=##class(WDT.CDSS.DEMONLPIdentify).%New()
				
				d obj.TasksDetailDRSetObjectId(TasksDetailID)
				s obj.IdentifyInfo=IdentifyInfo
				s obj.NLPRecognition=NLPRecognition
				s obj.NLPSource=NLPSource
				s obj.OperatorUser=user	//操作人员
				s obj.OperationTime=$ZDATETIME($H,3)					//操作时间
				s obj.DocumentType=documentType
				
		        s sc=obj.%Save()
		        d obj.%Close()
		        If $$$ISOK(sc)
		        {
		            if (ids="")
		            {
			            s ids=obj.%Id()
		            }
		            else
		            {
			            s ids=ids_"^"_obj.%Id()
		            }
		        }
		        else
		        {
			        s flag=1
					d result.%Set("errorinfo","保存NLP识别结果失败！原因如下：<br>"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc))
					//保存错误日志
					s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("病历任务集NLP识别表","web.CDSS.Demo.DEMONLPIdentify","SaveNLPIdentifyNew",jsonObj.%ToJSON())
	   	    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	   	    		Quit
		        }
			}
			if (flag=1)
			{
				TRO
				d result.%Set("success",0)
			}
			else
			{
				TC
				d result.%Set("success",1)
				d result.%Set("ids",ids)
			}
		}
	}
	q result.%ToJSON()
	
SaveNLPIdenERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("病历任务集NLP识别表","web.CDSS.Demo.DEMONLPIdentify","SaveNLPIdentifyNew",jsonObj.%ToJSON())
 	s ^ERRORLOGINFO(logid)=$ze 
	d result.%Set("success",0)
	d result.%Set("errorinfo","保存NLP识别结果失败！原因如下：<br>ERROR保存失败！")
    q result.%ToJSON()
}

/// Creator:		杨继鸿
/// CreatDate:		2022-01-24
/// Description:	删除NLP识别结果
/// Table:			WDT.CDSS.DEMONLPIdentify
/// Input:			id NLP识别数据ID，tasksdetailid 病历任务集详情ID OPUser 操作人员
/// Output:			json串 success 成功标志，id 记录ID，errorinfo 错误信息
/// Return:			成功返回 {"success":1,"id":id}，失败返回{"success":0,"errorinfo":"错误信息"}
/// Others:			d ##class(web.CDSS.Demo.DEMONLPIdentify).DeleteNLPIdentify("","513","yjh")
ClassMethod DeleteNLPIdentify(id As %String = "", tasksdetailid As %String = "", OPUser As %String = "", documenttype As %String = "入院记录") As %String
{
	s $zt="ERROE"
	s json={"ID":"","TasksDetailDR":"","DocumentType":"","IdentifyInfo":"","NLPRecognition":"","NLPSource":"","ProblemType":"","TagContent":"","OperatorUser":"","OperationTime":"","IsOutput":"","IsSolve":""}
    s result={"success":0}
    s user=OPUser
    s ids=""
	
    // id空，tasksdetailid不为空，说明正在批量删除
    if ((id="") & (tasksdetailid'=""))
    {
	    s flag=0
    	s ID=0
    	
    	TS
    	for
	    {
		    s ID=$o(^WDT.CDSS.DEMONLPIdentifyI("DocumentIndex",tasksdetailid,documenttype,ID))
		    q:ID=""
		    
			s obj=##class(WDT.CDSS.DEMONLPIdentify).%OpenId(ID)
			if (obj'="")
			{
				//备份数据，写日志
				s json.ID=ID
				s json.TasksDetailDR=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),2)
				s json.DocumentType=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),3) // 文书类型：入院记录/首次病程/日常记录/查房记录
				s json.IdentifyInfo=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),4)	// 识别信息
				s json.NLPRecognition=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),5)
				s json.NLPSource=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),6)
				s json.ProblemType=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),7)
				s json.TagContent=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),8)
				s json.IsOutput=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),11)
				s json.IsSolve=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),12)
				s json.OperationTime=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),10)
				s json.OperatorUser=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),9)
				
			   	s sc=##class(WDT.CDSS.DEMONLPIdentify).%DeleteId(ID)
			    if $$$ISOK(sc)
			    {			    
				    if (ids="")
				    {
						s ids=ID
				    }
				    else
				    {
					    s ids=ids_"^"_ID
				    }
			    }
			    else
			    {
				    s flag=1
			        s result.errorinfo="删除NLP识别结果失败！原因如下：<br>"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)	//返回错误信息
			        s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("病历任务集NLP识别表","web.CDSS.Demo.DEMONLPIdentify","DeleteNLPIdentify",json.%ToJSON())
			        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			        Quit
			    }
			}
		    else
		    {
			    continue
		    } 
	    }
	    if (flag=1)
	    {
		    TRO
		    s result.success=0
	    }
	    else
	    {
		    // 更新病历任务集详情的操作状态、时间、人员
		    // 任务集详情已经删除，不需要再保存
		    TC
		    s result.success=1
		    s result.ids=ids
	    }
    }
    // 单独删除某个NLP识别结果
    else
    {
	    s obj=##class(WDT.CDSS.DEMONLPIdentify).%OpenId(id)
	    
	    if obj'=""
	    {
		    // 备份数据，写日志
		    s json.ID=id
			s json.TasksDetailDR=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(id)),2)
			s json.DocumentType=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(id)),3) // 文书类型：入院记录/首次病程/日常记录/查房记录
			s json.IdentifyInfo=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(id)),4)	// 识别信息
			s json.NLPRecognition=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(id)),5)
			s json.NLPSource=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(id)),6)
			s json.ProblemType=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(id)),7)
			s json.TagContent=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(id)),8)
			s json.IsOutput=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(id)),11)
			s json.IsSolve=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(id)),12)
			s json.OperationTime=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(id)),10)
			s json.OperatorUser=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(id)),9)				
			
			d obj.%Close()
		    k obj
		    Tstart
		    s sc=##class(WDT.CDSS.DEMONLPIdentify).%DeleteId(id)
		    if $$$ISOK(sc)
		    {
		        // 更新病历任务集详情的操作状态、时间、人员
			    s re=##class(web.CDSS.Demo.DEMOTasks).SaveTasksDetail(tasksdetailid,"","",user)
			    s re={}.%FromJSON(re)
			    if (re.success)
			    {
				    TC
				    s result.success=1
				    s result.id=id
				    
				    //保存删除日志
					d ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("WDT_CDSS.DEMONLPIdentify","WDT.CDSS.DEMONLPIdentify","病历任务集NLP识别表",id,json.IdentifyInfo,"D",json.%ToJSON())
			    }
			    else
			    {
				    TRO
				    s result.success=0
				    s result.errorinfo="删除NLP识别结果失败！原因如下：<br>"_re.errorinfo
			    }		        
		    }
		    else 
		    {
		        Trollback
		        s result.success=0
		        
		        s result.errorinfo=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)	//返回错误信息
		        s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("病历任务集NLP识别表","web.CDSS.Demo.DEMONLPIdentify","DeleteNLPIdentify",json.%ToJSON())
		        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)		        
		    }
	    }
	    else
	    {
		    s result.success=0
		    s result.errorinfo="删除NLP识别结果失败！原因如下：<br>数据不存在！"
	    }
    }    
    q result.%ToJSON()
    
ERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("病历任务集NLP识别表","web.CDSS.Demo.DEMONLPIdentify","DeleteNLPIdentify",json.%ToJSON())
 	s ^ERRORLOGINFO(logid)=$ze 	    
 	s result.success=0
	s result.errorinfo="删除NLP识别结果失败！原因如下：<br>ERROR保存失败！"
    q result.%ToJSON()
}

/// Creator：      杨继鸿
/// CreatDate：    2021-10-29
/// Description:   查询【病历任务集NLP识别表】
/// Table：        WDT.CDSS.DEMONLPIdentify, WDT.CDSS.DEMOTasksDetail, WDT.CDSS.DEMOPatMaster, WDT.CDSS.DEMOTasks
/// Input：        rowid 病历任务集NLP识别表ID,tasksdetailDR 病历任务集详情表ID,documentType 文书类型
/// Output：       ID,TasksDetailDR,DocumentType,IdentifyInfo,NLPRecognition,NLPSource,ProblemType,TagContent,OperatorUser,OperationTime,IsOutput,IsSolve
/// Return：       返回符合条件的NLP识别表数据
/// Others：       d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DEMONLPIdentify","GetList","34","","")
Query GetList(rowid As %String, tasksdetailDR As %String, documentType As %String) As %Query(ROWSPEC = "ID:%String,TasksDetailDR:%String,DocumentType:%String,IdentifyInfo:%String,NLPRecognition:%String,NLPSource:%String,ProblemType:%String,TagContent:%String,OperatorUser:%String,OperationTime:%String,IsOutput:%String,IsSolve:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, tasksdetailDR As %String, documentType As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s ID=rowid
        
        s TasksDetailDR=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),2) // 病历任务集详情表DR
        
        s DocumentType=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),3) // 文书类型：入院记录/首次病程/日常记录/查房记录
        s IdentifyInfo=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),4)	// 识别信息
        s NLPRecognition=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),5)	// NLP识别结果
        s NLPSource=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),6)	// 识别来源:主诉/现病史
        s ProblemType=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),7)	// 问题类型：识别错误/未识别
        s TagContent=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),8)	// 标记内容
        s OperatorUser=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),9)	// 操作人员
        s OperationTime=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),10)	// 操作时间
        
        s IsOutput=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),11)	// 是否导出 0-否 1-是
        s:IsOutput=0 IsOutput="否"
        s:IsOutput=1 IsOutput="是"
        
        s IsSolve=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),12) // 是否解决 0-否 1-是
        s:IsSolve=0 UseFlag="否"
        s:IsSolve=1 UseFlag="是"

        d OutputNLPIdenRow
    }
    else
    {
		s ID=0
		for 
		{
			s ID=$o(^WDT.CDSS.DEMONLPIdentifyI("DocumentIndex",tasksdetailDR,documentType,ID))
			q:ID=""
			
			s TasksDetailDR=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),2) // 病历任务集详情表DR
			s DocumentType=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),3) // 文书类型：入院记录/首次病程/日常记录/查房记录
	        s IdentifyInfo=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),4)	// 识别信息
	        s NLPRecognition=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),5)	// NLP识别结果
	        s NLPSource=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),6)	// 识别来源:主诉/现病史
	        s ProblemType=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),7)	// 问题类型：识别错误/未识别
	        s TagContent=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),8)	// 标记内容
	        s OperatorUser=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),9)	// 操作人员
	        s OperationTime=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),10)	// 操作时间
	        
	        s IsOutput=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),11)	// 是否导出 0-否 1-是
	        s:IsOutput=0 IsOutput="否"
	        s:IsOutput=1 IsOutput="是"
	        
	        s IsSolve=$lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),12) // 是否解决 0-否 1-是
	        s:IsSolve=0 UseFlag="否"
	        s:IsSolve=1 UseFlag="是"
	        
	        d OutputNLPIdenRow
		}
		
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputNLPIdenRow
    set Data=$lb(ID,TasksDetailDR,DocumentType,IdentifyInfo,NLPRecognition,NLPSource,ProblemType,TagContent,OperatorUser,OperationTime,IsOutput,IsSolve)
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

/// Creator:		杨继鸿
/// CreatDate:		2021-10-29
/// Description:	保存【疑似诊断评测记录表】数据
/// Table:			WDT.CDSS.DEMOSuspDiseRec
/// Input:			rowid 疑似诊断评测记录表ID串, SuspDiseInfo 疑似疾病信息, TasksDetailID 病历任务集详情表ID, State 更新推荐诊断记录
/// Output:			成功返回 result={"success":1,"ids":"id^id"}，失败返回{"success":0,"errorinfo":"错误信息"}
/// Return:			返回保存信息，success（成功与否0失败、1成功），ids ID串，errorinfo 错误信息
/// Others:			d ##class(web.CDSS.Demo.DEMONLPIdentify).SaveSuspDiseRec("41^42")
/// d ##class(web.CDSS.Demo.DEMONLPIdentify).SaveSuspDiseRec("",[{""DiseaseDetail"": {""就诊科室：呼吸科"": ""常见科室：胸外科,呼吸科,肿瘤科"", ""胸腔积液"": ""等级三(实体词--现病史)(以‘’收入院)""}, ""DiseaseID"": ""985"",""DiseaseName"": ""胸腔积液"", ""Symptom"": [""胸腔积液""], ""Weight"": ""0.672""},{...}])
/// 
/// UpdateDate:		2021-12-27
/// 添加书写知识库日志代码、书写错误日志代码
/// {DieaseName: "创伤类", Symptom: "外伤", Weight: "不推疾病"}
ClassMethod SaveSuspDiseRec(rowid As %String, SuspDiseInfo, TasksDetailID As %String, State As %String = "0") As %String
{
	s $zt="SaveSuspDiseERROE"
	s result={}
	s json={"ID":"","TasksDetailDR":"","SuspectedDise":"","SuspectedDiseID":"","SuspectedDiseWeight":"","SuspectedDiseOrder":"","OperatorUser":"","OperationTime":""}
	s user=$g(%session.Data("LOGON.USERNAME"))
	//s user="yjh"
	// 修改数据
	if (rowid'="")
	{
		s upID=$p(rowid, "^", 1)	//顺序上移的疑似诊断评测记录ID
		s downID=$p(rowid, "^", 2)	//顺序下移的疑似诊断评测记录ID
		
		s obj1=##class(WDT.CDSS.DEMOSuspDiseRec).%OpenId(upID)
		s obj2=##class(WDT.CDSS.DEMOSuspDiseRec).%OpenId(downID)
		
		// 备份旧数据
		s bjson1={}, bjson2={}
		s bjson1.ID=obj1.%Id(), bjson2.ID=obj2.%Id()
		s bjson1.TasksDetailDR=obj1.TasksDetailDR.%Id(), bjson2.TasksDetailDR=obj2.TasksDetailDR.%Id()
		s bjson1.SuspectedDise=obj1.SuspectedDise, bjson2.SuspectedDise=obj2.SuspectedDise
		s bjson1.SuspectedDiseID=obj1.SuspectedDiseID, bjson2.SuspectedDiseID=obj2.SuspectedDiseID
		s bjson1.SuspectedDiseWeight=obj1.SuspectedDiseWeight, bjson2.SuspectedDiseWeight=obj2.SuspectedDiseWeight
		s bjson1.SuspectedDiseOrder=obj1.SuspectedDiseOrder, bjson2.SuspectedDiseOrder=obj2.SuspectedDiseOrder
		s bjson1.OperationTime=obj1.OperationTime, bjson2.OperationTime=obj2.OperationTime
		s bjson1.OperatorUser=obj1.OperatorUser, bjson2.OperatorUser=obj2.OperatorUser
		
		// 更换推荐顺序
		s temporder1=obj1.SuspectedDiseOrder
		s temporder2=obj2.SuspectedDiseOrder
	
		s obj1.SuspectedDiseOrder=temporder2
		s obj2.SuspectedDiseOrder=temporder1	
		s obj1.OperatorUser=user
		s obj2.OperatorUser=user
		s obj1.OperationTime=$ZDATETIME($H,3)
		s obj2.OperationTime=$ZDATETIME($H,3)
		
		// 获取新数据，写日志
		s json2={}
		s json.ID=obj1.%Id(), json2.ID=obj2.%Id()
		s json.TasksDetailDR=obj1.TasksDetailDR.%Id(), json2.TasksDetailDR=obj2.TasksDetailDR.%Id()
		s json.SuspectedDise=obj1.SuspectedDise, json2.SuspectedDise=obj2.SuspectedDise
		s json.SuspectedDiseID=obj1.SuspectedDiseID, json2.SuspectedDiseID=obj2.SuspectedDiseID
		s json.SuspectedDiseWeight=obj1.SuspectedDiseWeight, json2.SuspectedDiseWeight=obj2.SuspectedDiseWeight
		s json.SuspectedDiseOrder=obj1.SuspectedDiseOrder, json2.SuspectedDiseOrder=obj2.SuspectedDiseOrder
		s json.OperationTime=obj1.OperationTime, json2.OperationTime=obj2.OperationTime
		s json.OperatorUser=obj1.OperatorUser, json2.OperatorUser=obj2.OperatorUser		
		
		TS
		s sc1=obj1.%Save()
		d obj1.%Close()
		
		s sc2=obj2.%Save()
		d obj2.%Close()
		If $$$ISOK(sc1) & $$$ISOK(sc2)
		{
			// 更新任务集详情表的状态，和操作时间		
			s tasksdetailre=##class(web.CDSS.Demo.DEMOTasks).SaveTasksDetail(TasksDetailID,"","",user)
			s tasksdetailre={}.%FromJSON(tasksdetailre)
			if (tasksdetailre.success)
			{
				TC
				s id1=obj1.%Id()
				s id2=obj2.%Id()
				d result.%Set("success",1)
				d result.%Set("ids",rowid)

				//保存修改日志
				d ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("WDT_CDSS.DEMOSuspDiseRec","WDT.CDSS.DEMOSuspDiseRec","疑似诊断评测记录表",id1,json.SuspectedDise,"U",json.%ToJSON(),bjson1.%ToJSON())
				d ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("WDT_CDSS.DEMOSuspDiseRec","WDT.CDSS.DEMOSuspDiseRec","疑似诊断评测记录表",id2,json2.SuspectedDise,"U",json2.%ToJSON(),bjson2.%ToJSON())
			}
			else
			{
				//更新任务集详情失败，回滚修改推荐顺序操作
				TRO
				d result.%Set("success",0)
				d result.%Set("errorinfo","保存推荐疑似诊断失败！原因如下：<br>"+tasksdetailre.errorinfo)
			}
		}
		else
		{
			Tro
			d result.%Set("success",0)
			s errorinfo=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			d result.%Set("errorinfo",errorinfo)
			
			//仅保存一条错误日志
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似诊断评测记录表","web.CDSS.Demo.DEMONLPIdentify","SaveSuspDiseRec",json.%ToJSON())
			
   	    	s ^ERRORLOGINFO(logid)=errorinfo
		}
	}
	// 新增数据
	else
	{
		s flag=0
		s ids=""
		
		TStart
		// 后端调试读取方式
		//s dataL=SuspDiseInfo."0"
		
		// 前端传入读取方式
		//s dataL=SuspDiseInfo(1)	// 数据长度，索引从1开始
		
		s data=[].%FromJSON(SuspDiseInfo)
		s length=data.%Size()
		
		for reps=0:1:length-1
		{
			//s jsonobj={}.%FromJSON(SuspDiseInfo(reps))
			s jsonobj={}.%FromJSON(data.%Get(reps))
			
			if (jsonobj'="")
			{
				s obj=##class(WDT.CDSS.DEMOSuspDiseRec).%New()	// 疾病
			
				s diseDetail=jsonobj.DiseaseDetail.%ToJSON()	// 诊断详情信息
				d obj.TasksDetailDRSetObjectId(TasksDetailID)
				s json.TasksDetailDR=TasksDetailID
				s obj.SuspectedDise=jsonobj.DiseaseName, json.SuspectedDise=jsonobj.DiseaseName		//诊断名称
				s obj.SuspectedDiseID=jsonobj.DiseaseID, json.SuspectedDiseID=jsonobj.DiseaseID		//诊断ID
				s obj.SuspectedDiseOrder=reps-1, json.SuspectedDiseOrder=reps-1						//推荐顺序
				s obj.SuspectedDiseWeight=jsonobj.Weight, json.SuspectedDiseWeight=jsonobj.Weight	//诊断权重
				s obj.OperatorUser=user, json.OperatorUser=user										//操作人员
				s obj.OperationTime=$ZDATETIME($H,3), json.OperationTime=$ZDATETIME($H,3)			//操作时间
				
		        s sc=obj.%Save()
		        d obj.%Close()
		        If $$$ISOK(sc)
		        {
			        s id=obj.%Id()
		            if (ids="")
		            {
			            s ids=id
		            }
		            else
		            {
			            s ids=ids_"^"_id
		            }
		            
		            // 调用保存【疑似诊断评测记录详情表】数据
		            s savedisedetailre=..SaveSDRDetail("", diseDetail, id)
		            s savedisedetailre={}.%FromJSON(savedisedetailre)
		            if ('savedisedetailre.success)
		            {
			            s flag=1
			            d result.%Set("errorinfo","保存疑似诊断记录失败，原因如下：<br>"_savedisedetailre.errorinfo)
			            Quit
		            }
		        }
		        else
		        {
			        s flag=1
					d result.%Set("errorinfo",##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc))
					
					s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似诊断评测记录表","web.CDSS.Demo.DEMONLPIdentify","SaveSuspDiseRec",jsonobj.%ToJSON())
		   	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			        Quit
		        }

			}
			else
			{
				s flag=1
				d result.%Set("errorinfo","保存疑似诊断记录失败，原因如下：<br>传入空")
				Quit
			}
		}
		if (flag=1)
		{
			TRO
			d result.%Set("success",0)
		}
		else
		{
			// 更新任务集详情表的状态，和操作时间		
			s tasksdetailre=##class(web.CDSS.Demo.DEMOTasks).SaveTasksDetail(TasksDetailID,"","",user)
			s tasksdetailre={}.%FromJSON(tasksdetailre)
			if (tasksdetailre.success)
			{
				TC
				d result.%Set("success",1)
				d result.%Set("ids",ids)
			}
			else
			{
				//更新任务集详情失败，回滚保存推荐诊断
				TRO
				d result.%Set("success",0)
				d result.%Set("errorinfo","保存推荐诊断失败，原因如下：<br>"+tasksdetailre.errorinfo)
			}
		}		
	}
	q result.%ToJSON()
SaveSuspDiseERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似诊断评测记录表","web.CDSS.Demo.DEMONLPIdentify","SaveSuspDiseRec",json.%ToJSON())
 	s ^ERRORLOGINFO(logid)=$ze
	d result.%Set("success",0)
	d result.%Set("errorinfo","保存推荐诊断失败，原因如下：<br>ERROR保存失败！")
    q result.%ToJSON()
}

/// Creator:		杨继鸿
/// CreatDate:		2021-11-11
/// Description:	删除疑似诊断数据、调用删除诊断因子的入口
/// Table:			WDT.CDSS.DEMOSuspDiseRec
/// Input:			id 疑似诊断记录ID，tasksdetailid 病历任务集详情ID, opuser 操作人员
/// Output:			json串 success 成功标志，id 记录ID，errorinfo 错误信息
/// Return:			成功返回 {"success":1,"id":id}，失败返回{"success":0,"errorinfo":"错误信息"}
/// Others:			w ##class(web.CDSS.Demo.DEMONLPIdentify).DeleteSuspDise("","2","yjh")
/// 
/// UpDateDate: 2021-12-14
/// Description: 删除疑似诊断数据，同时删除诊断因子数据
ClassMethod DeleteSuspDise(id As %String = "", tasksdetailid As %String = "", opuser As %String = "") As %String
{
	s $zt="DelSuspDiseERROE"
	s json={"ID":"","TasksDetailDR":"","SuspectedDise":"","SuspectedDiseID":"","SuspectedDiseWeight":"","SuspectedDiseOrder":"","OperatorUser":"","OperationTime":""}
    s result={"success":0}
    s user=""
    s ids=""
    
    if (opuser'="")
    {
	    s user=opuser
    }
    else
    {
	    s sessionuser=$g(%session.Data("LOGON.USERNAME"))
	    if (sessionuser'="")
	    {
		    s user=sessionuser
	    }
    }
    //s user="yjh"
    
    // id空，tasksdetailid不为空，说明正在批量删除
    if ((id="") & (tasksdetailid'=""))
    {
	    s flag=0
    	s ID=0
    	
    	TS
    	for
	    {	    
		    s ID=$o(^WDT.CDSS.DEMOSuspDiseRecI("TasksDetailIndex",tasksdetailid,ID))
		    q:ID=""
		    
			s obj=##class(WDT.CDSS.DEMOSuspDiseRec).%OpenId(ID)
			if (obj'="")
			{
				//先删除关联的诊断详情
			    s delDetailRS=..DeleteSDRDetail(ID)
			    s delDetailRS={}.%FromJSON(delDetailRS)	//同步删除关联的诊断因子记录
			    if ('delDetailRS.success)
			    {
				    s flag=1
				    s result.errorinfo="删除推荐疑似诊断失败，原因如下：<br>"_delDetailRS.errorinfo
				    Quit
			    }
			    else
			    {				    		    	//备份旧数据
				    s json.ID=ID
					s json.TasksDetailDR=obj.TasksDetailDR.%Id()
					s json.SuspectedDise=obj.SuspectedDise
					s json.SuspectedDiseID=obj.SuspectedDiseID
					s json.SuspectedDiseWeight=obj.SuspectedDiseWeight
					s json.SuspectedDiseOrder=obj.SuspectedDiseOrder
					s json.OperationTime=obj.OperationTime
					s json.OperatorUser=obj.OperatorUser
					
					s sc=##class(WDT.CDSS.DEMOSuspDiseRec).%DeleteId(ID)
				    if $$$ISOK(sc)
				    {			    
					    if (ids="")
					    {
							s ids=ID
					    }
					    else
					    {
						    s ids=ids_"^"_ID
						}
				    }
				    else
				    {
					    s flag=1
				        s result.errorinfo="删除推荐疑似诊断失败，原因如下：<br>"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)	//返回错误信息
				        s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似诊断评测记录表","web.CDSS.Demo.DEMONLPIdentify","DeleteSuspDise",json.%ToJSON())
				        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				        Quit
				    }
			    }
			}
		    else
		    {
			    continue
		    } 
	    }
	    if (flag=1)
	    {
		    TRO
		    s result.success=0
	    }
	    else
	    {
		    TC
			s result.success=1
			s result.ids=ids
	    }
    }
    // 单独删除某个疑似诊断记录
    else
    {
	    s obj=##class(WDT.CDSS.DEMOSuspDiseRec).%OpenId(id)
	    	    
	    if obj'=""
	    {
		    // 备份数据，写日志
		    s json.ID=id
			s json.TasksDetailDR=obj.TasksDetailDR.%Id()
			s json.SuspectedDise=obj.SuspectedDise
			s json.SuspectedDiseID=obj.SuspectedDiseID
			s json.SuspectedDiseWeight=obj.SuspectedDiseWeight
			s json.SuspectedDiseOrder=obj.SuspectedDiseOrder
			s json.OperationTime=obj.OperationTime
			s json.OperatorUser=obj.OperatorUser

		    Tstart
		    s sc=##class(WDT.CDSS.DEMOSuspDiseRec).%DeleteId(id)
		    
		    // 先删除其诊断因子
		    s delDetailRS=..DeleteSDRDetail(id)
		    s delDetailRS={}.%FromJSON(delDetailRS)	//同步删除关联的诊断因子记录
		    if (($$$ISOK(sc)) & (delDetailRS.success))
		    {
		        // 更新病历任务集详情的操作状态、时间、人员
			    s re=##class(web.CDSS.Demo.DEMOTasks).SaveTasksDetail(tasksdetailid,"","",user)
			    s re={}.%FromJSON(re)
			    if (re.success)
			    {
				    TC
				    s result.success=1
				    s result.id=id
				    
				    //保存删除日志
					d ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("WDT_CDSS.DEMOSuspDiseRec","WDT.CDSS.DEMOSuspDiseRec","疑似诊断评测记录表",id,json.SuspectedDise,"D",json.%ToJSON())
			    }
			    else
			    {
				    TRO
				    s result.success=0
				    s result.errorinfo="删除推荐疑似诊断失败，原因如下：<br>"_re.errorinfo
			    }		        
		    }
		    else 
		    {
		        Trollback
		        s result.success=0
		        // 因删除关联的诊断详情造成失败
		        if (('delDetailRS.success) & ($$$ISOK(sc)))
		        {
			        s result.errorinfo="删除推荐疑似诊断失败，原因如下：<br>"_delDetailRS.errorinfo
		        }
		        // 删除疑似诊断失败
		        else
		        {
			        s result.errorinfo="删除推荐疑似诊断失败，原因如下：<br>"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)	//返回错误信息
			        s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似诊断评测记录表","web.CDSS.Demo.DEMONLPIdentify","DeleteSuspDise",json.%ToJSON())
			        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		        }
		    }
	    }
	    else
	    {
		    s result.success=0
		    s result.errorinfo="删除推荐疑似诊断失败，原因如下：<br>ID为"_id_"的数据不存在！"
	    }
    }    
    q result.%ToJSON()
    
DelSuspDiseERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似诊断评测记录表","web.CDSS.Demo.DEMONLPIdentify","DeleteSuspDise",json.%ToJSON())
 	s ^ERRORLOGINFO(logid)=$ze 	    
 	s result.success=0
	s result.errorinfo="删除推荐疑似诊断失败，原因如下：<br>ERROE保存失败！"
    q result.%ToJSON()
}

/// Creator：      杨继鸿
/// CreatDate：    2021-11-11
/// Description:   查询【疑似诊断评测记录表】
/// Table：        WDT.CDSS.DEMOSuspDiseRec, WDT.CDSS.DEMOSDRDetail
/// Input：        rowid 疑似诊断评测记录表ID，tasksdetailID 病历任务集详情表ID
/// Output：       ID,TasksDetailDR,DocumentType,IdentifyInfo,NLPRecognition,NLPSource,ProblemType,TagContent,OperatorUser,OperationTime,IsOutput,IsSolve
/// Return：       返回疑似诊断记录，再加上记录详情表的诊断信息
/// Others：       d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DEMONLPIdentify","GetSuspDiseRecList", "591", "")
Query GetSuspDiseRecList(rowid As %String, tasksdetailID As %String) As %Query(ROWSPEC = "ID,TasksDetailDR,SuspectedDise,SuspectedDiseID,SuspectedDiseWeight,Factor,SuspectedDiseOrder,OperatorUser,OperationTime")
{
}

ClassMethod GetSuspDiseRecListExecute(ByRef qHandle As %Binary, rowid As %String, tasksdetailID As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
        
    if (rowid'="") //根据rowid返回该条记录
    {
        s ID=rowid
        
        s TasksDetailDR=$lg($g(^WDT.CDSS.DEMOSuspDiseRecD(ID)),2) // 病历任务集详情表DR
                
        s SuspectedDise=$lg($g(^WDT.CDSS.DEMOSuspDiseRecD(ID)),3) // 推荐疑似诊断名称
        s SuspectedDiseID=$lg($g(^WDT.CDSS.DEMOSuspDiseRecD(ID)),4)	// 推荐疑似诊断ID
        s SuspectedDiseWeight=$lg($g(^WDT.CDSS.DEMOSuspDiseRecD(ID)),5)	// 推荐疑似诊断权重
        s SuspectedDiseOrder=$lg($g(^WDT.CDSS.DEMOSuspDiseRecD(ID)),6)	// 推荐疑似诊断顺序
        
        s OperatorUser=$lg($g(^WDT.CDSS.DEMOSuspDiseRecD(ID)),7)	// 操作人员
        s OperationTime=$lg($g(^WDT.CDSS.DEMOSuspDiseRecD(ID)),8)	// 操作时间

        d OutputSuspDiseRow
    }
    else
    {
	    s order=""
	    for
	    {
		    s order=$o(^WDT.CDSS.DEMOSuspDiseRecI("OrderIndex", tasksdetailID, order))
		    q:order=""
		    s ID=$o(^WDT.CDSS.DEMOSuspDiseRecI("OrderIndex", tasksdetailID, order, 0))
		    
		    s TasksDetailDR=$lg($g(^WDT.CDSS.DEMOSuspDiseRecD(ID)),2) // 病历任务集详情表DR
		    
	    	s SuspectedDise=$lg($g(^WDT.CDSS.DEMOSuspDiseRecD(ID)),3) // 推荐疑似诊断名称
	        s SuspectedDiseID=$lg($g(^WDT.CDSS.DEMOSuspDiseRecD(ID)),4)	// 推荐疑似诊断ID
	        s SuspectedDiseWeight=$lg($g(^WDT.CDSS.DEMOSuspDiseRecD(ID)),5)	// 推荐疑似诊断权重
	        
	        s Factor=""	// 从【记录详情表】获取所有的诊断因子
	        
	        s SDRDetailID=0	//疑似诊断测评记录详情表ID
	        for
	        {
		        s SDRDetailID=$o(^WDT.CDSS.DEMOSDRDetailI("SuspDiseRecIndex",ID,SDRDetailID))
		        q:SDRDetailID=""
		        
		        s Factor=Factor_"，"_$lg($g(^WDT.CDSS.DEMOSDRDetailD(SDRDetailID)),3)
	        }
	        s Factor=$EXTRACT(Factor,2,*)	//从第2个位置取字符串
	        
	        s SuspectedDiseOrder=$lg($g(^WDT.CDSS.DEMOSuspDiseRecD(ID)),6)	// 推荐疑似诊断顺序
	        
	        s OperatorUser=$lg($g(^WDT.CDSS.DEMOSuspDiseRecD(ID)),7)	// 操作人员
	        s OperationTime=$lg($g(^WDT.CDSS.DEMOSuspDiseRecD(ID)),8)	// 操作时间
	        d OutputSuspDiseRow
	    }
		
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputSuspDiseRow
    set Data=$lb(ID,TasksDetailDR,SuspectedDise,SuspectedDiseID,SuspectedDiseWeight,Factor,SuspectedDiseOrder,OperatorUser,OperationTime)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetSuspDiseRecListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSuspDiseRecListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetSuspDiseRecListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSuspDiseRecListExecute ]
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

/// Creator:		杨继鸿
/// CreatDate:		2021-10-29
/// Description:	保存【疑似诊断评测记录详情表】数据
/// Table:			WDT.CDSS.DEMOSDRDetail
/// Input:			rowid 疑似诊断评测记录详情表ID, SDRDetailInfo 疑似疾病诊断因子信息, SuspDiseRecID 疑似诊断评测记录表ID, TasksDetailID 病历任务集详情表ID
/// Output:			result={"success":0,"id"/"ids":id,"errorinfo":"错误信息"}
/// Return:			返回保存信息，success（成功与否0失败、1成功）；id/ids ID串；errorinfo 错误信息
/// Others:			d ##class(web.CDSS.Demo.DEMONLPIdentify).SaveSDRDetail("","{""就诊科室：呼吸科"": ""常见科室：胸外科,呼吸科,肿瘤科"", ""胸腔积液"": ""等级三(实体词--现病史)(以‘’收入院)""}","108")
/// d ##class(web.CDSS.Demo.DEMONLPIdentify).SaveSDRDetail("75","{""NLPSource"":""测试""}","","3")
/// 
/// UpdateDate:		2021-12-27
/// 添加写错误日志代码
ClassMethod SaveSDRDetail(rowid As %String, SDRDetailInfo, SuspDiseRecID As %String, TasksDetailID As %String) As %String
{
	s $zt="SaveSDRDetailERROE"
	s result={}
	s ids=""	//疑似诊断评测记录详情ID串
	
	// 疑似诊断评测记录详情JSON对象
	s json={"ID":"","SuspDiseRecDR":"","Factor":"","FactorType":"","NLPSource":"","OperatorUser":"","OperationTime":""}
	s json.SuspDiseRecDR=SuspDiseRecID	// 指向疑似诊断记录ID
	
	s user=$g(%session.Data("LOGON.USERNAME"))
	//s user="yjh"
	
	// 修改数据
	if (rowid'="")
	{		
		s factorObj={}.%FromJSON(SDRDetailInfo)
		s obj=##class(WDT.CDSS.DEMOSDRDetail).%OpenId(rowid)	
	
		s json.ID=obj.SuspDiseRecDR.%Id()
		s json.Factor=obj.Factor
		s json.FactorType=obj.FactorType
		s json.NLPSource=obj.NLPSource
	
		s obj.NLPSource=factorObj.NLPSource
		s obj.OperatorUser=user
		s obj.OperationTime=$ZDATETIME($H,3)
		
		TS
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			// 更新任务集详情表的状态，和操作时间		
			s tasksdetailre=##class(web.CDSS.Demo.DEMOTasks).SaveTasksDetail(TasksDetailID,"","",user)
			s tasksdetailre={}.%FromJSON(tasksdetailre)
			if (tasksdetailre.success)
			{
				TC
				d result.%Set("success",1)
				d result.%Set("id",rowid)
				//保存修改日志
				d ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("WDT_CDSS.DEMOSDRDetail","WDT.CDSS.DEMOSDRDetail","疑似诊断评测记录详情表",rowid,json.Factor,"U",SDRDetailInfo,json.%ToJSON())
			}
			else
			{
				//更新任务集详情失败，回滚保存NLP信息
				TRO
				d result.%Set("success",0)
				d result.%Set("errorinfo","保存诊断因子失败！原因如下：<br>"_tasksdetailre.errorinfo)
			}
		}
		else
		{
			Tro
			d result.%Set("success",0)
			d result.%Set("errorinfo","保存诊断因子失败！原因如下：<br>"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc))
			
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似诊断评测记录详情表","web.CDSS.Demo.DEMONLPIdentify","SaveSDRDetail",SDRDetailInfo)
   	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s flag=0
		TStart
		s idenObj={}.%FromJSON(SDRDetailInfo)
		s iter=idenObj.%GetIterator()
		while(iter.%GetNext(.key,.value))
		{
			s json.Factor=key	// 诊断因子名称
			s json.FactorType=value	// 诊断因子种类
			s obj=##class(WDT.CDSS.DEMOSDRDetail).%New()
			
			d obj.SuspDiseRecDRSetObjectId(SuspDiseRecID)
			s obj.Factor=key
			s obj.FactorType=value
			s obj.OperatorUser=user	//操作人员
			s obj.OperationTime=$ZDATETIME($H,3)					//操作时间
			
	        s sc=obj.%Save()
	        d obj.%Close()
	        If $$$ISOK(sc)
	        {
	            s id = obj.%Id()	// 评测记录表ID
	            if (ids="")
	            {
		            s ids=id
	            }
	            else
	            {
		            s ids=ids_"^"_id
	            }
	        }
	        else
	        {
		        s flag=1
				d result.%Set("errorinfo","保存诊断因子失败！原因如下：<br>"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc))
		        s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似诊断评测记录详情表","web.CDSS.Demo.DEMONLPIdentify","SaveSDRDetail",json.%ToJSON())
	       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		        quit
	        }
		}
		if (flag=1)
		{
			TRO
			d result.%Set("success",0)
		}
		else
		{
			TC
			d result.%Set("success",1)
			d result.%Set("ids",ids)
		}
	}
	q result.%ToJSON()
SaveSDRDetailERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似诊断评测记录详情表","web.CDSS.Demo.DEMONLPIdentify","SaveSDRDetail",SDRDetailInfo)
 	s ^ERRORLOGINFO(logid)=$ze 
	d result.%Set("success",0)
	d result.%Set("errorinfo","保存诊断因子失败！原因如下：<br>ERROR保存失败！")
    q result.%ToJSON()
}

/// Creator:		杨继鸿
/// CreatDate:		2021-12-14
/// Description:	删除诊断因子数据
/// Table:			WDT.CDSS.DEMOSDRDetail
/// Input:			suspDiseRecID疑似诊断测评记录详情表ID
/// Output:			json串 success 成功标志，ids 删除的诊断因子ID串，errorinfo 错误信息
/// Return:			成功返回 {"success":1,"ids":"id^id^id"},失败返回 {"success":0,"errorinfo":"错误信息"}
/// Others:			d ##class(web.CDSS.Demo.DEMONLPIdentify).DeleteSDRDetail("1")
ClassMethod DeleteSDRDetail(suspDiseRecID As %String) As %String
{
	s $zt="DelSDRDetailERROE"
    s result={}
    s ids=""
    
    s flag=0
    s id=0
    TS
    for
    {	    
	    s id=$o(^WDT.CDSS.DEMOSDRDetailI("SuspDiseRecIndex",suspDiseRecID,id))
	    q:id=""
	    
		s obj=##class(WDT.CDSS.DEMOSDRDetail).%OpenId(id)
		if (obj'="")
		{
			d obj.%Close()
	    	k obj
		   	s sc=##class(WDT.CDSS.DEMOSDRDetail).%DeleteId(id)
		    if $$$ISOK(sc)
		    {
			    if (ids="")
			    {
					s ids=id
			    }
			    else
			    {
				    s ids=ids_"^"_id
			    }
		    }
		    else 
		    {
			    s flag=1
			    s result.success=0
		        s result.errorinfo="删除诊断因子失败！原因如下：<br>"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)	//返回错误信息
		        s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似诊断测评记录详情表","web.CDSS.Demo.DEMONLPIdentify","DeleteSDRDetail",suspDiseRecID)
		        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		        Quit
		    }
		}
	    else
	    {
		    continue
	    }	     
    }
    if (flag=1)
    {
	    TRO
    }
    else
    {
	    TC
	    s result.success=1
	    s result.ids=ids
    }
    q result.%ToJSON()
    
DelSDRDetailERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似诊断测评记录详情表","web.CDSS.Demo.DEMONLPIdentify","DeleteSDRDetail",suspDiseRecID)
 	s ^ERRORLOGINFO(logid)=$ze
 	d result.%Set("success", 0)
 	d result.%Set("errorinfo", "删除诊断因子失败，原因如下：<br>ERROE删除失败！")
    q result.%ToJSON()
}

/// Creator：      杨继鸿
/// CreatDate：    2021-11-11
/// Description:   查询【疑似诊断评测记录详情表】
/// Table：        WDT.CDSS.DEMOSDRDetail
/// Input：        rowid,suspDiseRecDR
/// Output：       ID,SuspDiseRecDR,Factor,FactorType,NLPSource,OperatorUser,OperationTime,FactorWeight
/// Return：       与疑似诊断记录关联的诊断因子数据
/// Others：       d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DEMONLPIdentify","GetSDRDetailList","","591") 
Query GetSDRDetailList(rowid As %String, suspDiseRecDR As %String) As %Query(ROWSPEC = "ID,SuspDiseRecDR,Factor,FactorType,NLPSource,OperatorUser,OperationTime,FactorWeight")
{
}

ClassMethod GetSDRDetailListExecute(ByRef qHandle As %Binary, rowid As %String, suspDiseRecDR As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
        
    if (rowid'="") //根据rowid返回该条记录
    {
        s ID=rowid
        
        s SuspDiseRecDR=$lg($g(^WDT.CDSS.DEMOSDRDetailD(ID)),2) // 病历任务集详情表DR
                
        s Factor=$lg($g(^WDT.CDSS.DEMOSDRDetailD(ID)),3) // 推荐疑似诊断名称
        s FactorType=$lg($g(^WDT.CDSS.DEMOSDRDetailD(ID)),4)	// 推荐疑似诊断ID
        
        s NLPSource=$lg($g(^WDT.CDSS.DEMOSDRDetailD(ID)),5)	// 推荐疑似诊断ID
        
        s OperatorUser=$lg($g(^WDT.CDSS.DEMOSDRDetailD(ID)),6)	// 操作人员
        s OperationTime=$lg($g(^WDT.CDSS.DEMOSDRDetailD(ID)),7)	// 操作时间
        
        s FactorWeight=##class(web.CDSS.Demo.DEMOTasks).GetFactorWeight(FactorType)	//诊断权重

        d OutputSDRDetailRow
    }
    else
    {
		s ID=0
		for 
		{
			s ID=$o(^WDT.CDSS.DEMOSDRDetailI("SuspDiseRecIndex",suspDiseRecDR,ID))
			q:ID=""	
			                
			s SuspDiseRecDR=$lg($g(^WDT.CDSS.DEMOSDRDetailD(ID)),2) // 病历任务集详情表DR
	        s Factor=$lg($g(^WDT.CDSS.DEMOSDRDetailD(ID)),3) // 推荐疑似诊断名称
	        s FactorType=$lg($g(^WDT.CDSS.DEMOSDRDetailD(ID)),4)	// 推荐疑似诊断ID
	        s NLPSource=$lg($g(^WDT.CDSS.DEMOSDRDetailD(ID)),5)	// 推荐疑似诊断ID
	        s OperatorUser=$lg($g(^WDT.CDSS.DEMOSDRDetailD(ID)),6)	// 操作人员
	        s OperationTime=$lg($g(^WDT.CDSS.DEMOSDRDetailD(ID)),7)	// 操作时间
	        s FactorWeight=##class(web.CDSS.Demo.DEMOTasks).GetFactorWeight(FactorType)	//诊断权重	        
	        
	        d OutputSDRDetailRow
		}
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputSDRDetailRow
    set Data=$lb(ID,SuspDiseRecDR,Factor,FactorType,NLPSource,OperatorUser,OperationTime,FactorWeight)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetSDRDetailListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSDRDetailListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetSDRDetailListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSDRDetailListExecute ]
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

/// Creator：      杨继鸿
/// CreatDate：    2021-12-15
/// Description:   切换任务集详情
/// Table：        WDT.CDSS.DEMOTasksDetail
/// Input：        taskDR 病历任务集ID，detailID 当前病历任务集详情表ID，direction 向上/下（-1/1）取ID的方向
/// Output：       id 病历任务集详情ID idno 患者IDNO state 任务的编辑状态 isHit 是否命中
/// Return：       下（上）一个任务集详情ID
/// Others：       w ##class(web.CDSS.Demo.DEMONLPIdentify).GetDetailID("162","4952","1")
ClassMethod GetDetailID(taskDR As %String, detailID As %String, direction As %String) As %String
{
	s id="", idno="", state="", isHit="",PatientDR=""
	if ##class(WDT.CDSS.DEMOTasksDetail).%ExistsId(detailID)
	{
		s patientID=$lg($g(^WDT.CDSS.DEMOTasksDetailD(detailID)),2)	// 患者ID
		s taskID=$lg($g(^WDT.CDSS.DEMOTasksDetailD(detailID)),3)	// 任务集ID
		
		s nextPatient=$o(^WDT.CDSS.DEMOTasksDetailI("PatientIndex",taskID,patientID),direction)
		if nextPatient=""
		{
			s id=0
		}
		else
		{
			s id=$o(^WDT.CDSS.DEMOTasksDetailI("PatientIndex",taskID,nextPatient,0))
			s PatientnextID=$lg($g(^WDT.CDSS.DEMOTasksDetailD(id)),2)
			s state=$lg($g(^WDT.CDSS.DEMOTasksDetailD(id)),4)	//状态
			s IsHit=$lg($g(^WDT.CDSS.DEMOTasksDetailD(id)),7)	//是否命中
			
			s IDNO=$lg($g(^WDT.CDSS.DEMOPatMasterD(nextPatient)),2)
			s PatientDR=$LISTGET($G(^WDT.CDSS.DEMOPatMasterD(PatientnextID)),3)
			
			s:IDNO'="" idno=IDNO
			s:IsHit="0" isHit="未命中"
			s:IsHit="1" isHit="命中"
			s:IsHit="" IsHit="未统计是否命中"
		}
	}
	else
	{
		s id=0
	}
	q id_"^"_idno_"^"_state_"^"_isHit_"^"_PatientDR
}

/// Creator：      杨继鸿
/// CreatDate：    2022-02-28
/// Description:   更新所有疑似疾病记录（含罕见病）
/// Table：        WDT.CDSS.DEMOTasksDetail
/// Input：        taskDR 病历任务集ID，detailID 当前病历任务集详情表ID，direction 向上/下（-1/1）取ID的方向
/// Output：       id 病历任务集详情ID
/// Return：       下（上）一个任务集详情ID
/// Others：       d ##class(web.CDSS.Demo.DEMONLPIdentify).GetDetailID("10","472","1")
/// w ##class(web.CDSS.Demo.DEMONLPIdentify).UpdateAllSuspectedDisease("2","","","[""{\""DiseaseDetail\"":{\""癫痫\"":\""等级一(实体词--主诉)\""},\""DiseaseID\"":\""910\"",\""DiseaseName\"":\""多发性硬化\"",\""Symptom\"":[\""癫痫\""],\""Weight\"":\""0.033\""}""]")
/// "[""{\""DiseaseDetail\"":{\""癫痫\"":\""等级一(实体词--主诉)\""},\""DiseaseID\"":\""910\"",\""DiseaseName\"":\""多发性硬化\"",\""Symptom\"":[\""癫痫\""],\""Weight\"":\""0.033\""}""]"
ClassMethod UpdateAllSuspectedDisease(taskDetailID As %String, idno As %String, SuspDiseInfo, RareDiseInfo) As %String
{
	s $zt="UpdateAllERROE"
	s user=$g(%session.Data("LOGON.USERNAME"))
	//s user="yjh"
	s result={}
	
	s flag=0
	TS
	//先更新这个患者，注意本地不能更新
	s updateResult=##class(web.CDSS.Demo.DEMOTasks).UpdateData(idno)
	s updateResult={}.%FromJSON(updateResult)
	if (updateResult.success)
	{
		//再删除该患者的所有推荐记录
		s delSuspdiseResult=..DeleteSuspDise("",taskDetailID,user)
		s delSuspdiseResult={}.%FromJSON(delSuspdiseResult)
		if (delSuspdiseResult.success)
		{
			s delRarediseResult=##class(web.CDSS.Demo.DEMORareDiseRec).DeleteData("",taskDetailID,user)
			s delRarediseResult={}.%FromJSON(delRarediseResult)
			if (delRarediseResult.success)
			{
				s saveSuspDiseResult=..SaveSuspDiseRec("",SuspDiseInfo,taskDetailID,"0")
				s saveSuspDiseResult={}.%FromJSON(saveSuspDiseResult)
				if (saveSuspDiseResult.success)
				{
					s saveRareDiseResult=##class(web.CDSS.Demo.DEMORareDiseRec).SaveData("",RareDiseInfo,taskDetailID)
					s saveRareDiseResult={}.%FromJSON(saveRareDiseResult)
					if saveRareDiseResult.success
					{
						s flag=1
					}
					else
					{
						s errorinfo="更新推荐疑似诊断失败！原因如下：<br>"_saveRareDiseResult.errorinfo
					}
				}
				else
				{
					s errorinfo="更新推荐疑似诊断失败！原因如下：<br>"_saveSuspDiseResult.errorinfo
				}
			}
			else
			{
				s errorinfo="更新推荐疑似诊断失败！原因如下：<br>"_delRarediseResult.errorinfo
			}
		}
		else
		{
			s errorinfo="更新推荐疑似诊断失败！原因如下：<br>"_delSuspdiseResult.errorinfo
		}
	}
	else
	{
		s errorinfo="更新推荐疑似诊断失败！原因如下：<br>"_"更新患者信息错误！"
	}
	if (flag=1)
	{
		//1，表示所有调用都成功
		TC
		d result.%Set("success",1)
		d result.%Set("id",taskDetailID)
	}
	else
	{
		TRO
		d result.%Set("success",0)
		d result.%Set("errorinfo",errorinfo)
	}
	q result.%ToJSON()
	
UpdateAllERROE
	s data={}
	d data.%Set("TaskDetailID",taskDetailID)
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("推荐疑似诊断记录表","web.CDSS.Demo.DEMONLPIdentify","UpdateAllSuspectedDisease",data.%ToJSON())
 	s ^ERRORLOGINFO(logid)=$ze 
	d result.%Set("success",0)
	d result.%Set("errorinfo","更新推荐疑似诊断失败！原因如下：<br>ERROR保存失败！")
    q result.%ToJSON()
}

/// Creator：      杨继鸿
/// CreatDate：    2022-03-01
/// Description:   保存NLP、推荐疑似诊断、推荐罕见病
/// Table：        WDT.CDSS.DEMOTasksDetail
/// Input：        taskDR 病历任务集ID，detailID 当前病历任务集详情表ID，direction 向上/下（-1/1）取ID的方向
/// Output：       id 病历任务集详情ID
/// Return：       下（上）一个任务集详情ID
/// Others：       d ##class(web.CDSS.Demo.DEMONLPIdentify).GetDetailID("10","472","1")
/// w ##class(web.CDSS.Demo.DEMONLPIdentify).UpdateAllSuspectedDisease("2","","","[""{\""DiseaseDetail\"":{\""癫痫\"":\""等级一(实体词--主诉)\""},\""DiseaseID\"":\""910\"",\""DiseaseName\"":\""多发性硬化\"",\""Symptom\"":[\""癫痫\""],\""Weight\"":\""0.033\""}""]")
/// "[""{\""DiseaseDetail\"":{\""癫痫\"":\""等级一(实体词--主诉)\""},\""DiseaseID\"":\""910\"",\""DiseaseName\"":\""多发性硬化\"",\""Symptom\"":[\""癫痫\""],\""Weight\"":\""0.033\""}""]"
ClassMethod SaveAllData(taskDetailID As %String = "", documentType As %String, NLPInfo As %String, SuspDiseInfo, RareDiseInfo) As %String
{
	s $zt="SaveAllDataERROE"
	s flag=0
	s result={}
	
	TS
	if (taskDetailID="")
	{
		s errorinfo="保存任务集详情的数据失败！原因如下：<br>taskDetailID不能空"
	}
	else
	{
		s user=$g(%session.Data("LOGON.USERNAME"))
		//s user="yjh"
		
		//先保存NLP
		s saveNLPResult=..SaveNLPIdentifyNew("", NLPInfo, taskDetailID, documentType)
		s saveNLPResult={}.%FromJSON(saveNLPResult)
		if (saveNLPResult.success)
		{
			//再保存推荐疑似诊断
			s saveSuspdiseResult=..SaveSuspDiseRec("", SuspDiseInfo, taskDetailID)
			s saveSuspdiseResult={}.%FromJSON(saveSuspdiseResult)
			if (saveSuspdiseResult.success)
			{
				//再保存推荐罕见病
				s saveRarediseResult=##class(web.CDSS.Demo.DEMORareDiseRec).SaveData("", RareDiseInfo, taskDetailID)
				s saveRarediseResult={}.%FromJSON(saveRarediseResult)
				if (saveRarediseResult.success)
				{
					s flag=1
				}
				else
				{
					s errorinfo="保存任务集详情的数据失败！原因如下：<br>"_saveRarediseResult.errorinfo
				}
			}
			else
			{
				s errorinfo="保存任务集详情的数据失败！原因如下：<br>"_saveSuspdiseResult.errorinfo
			}
		}
		else
		{
			s errorinfo="保存任务集详情的数据失败！原因如下：<br>"_saveNLPResult.errorinfo
		}
	}

	if (flag=1)
	{
		//1，表示所有调用都成功
		TC
		d result.%Set("success",1)
		d result.%Set("id",taskDetailID)
	}
	else
	{
		TRO
		d result.%Set("success",0)
		d result.%Set("errorinfo",errorinfo)
	}
	q result.%ToJSON()
	
SaveAllDataERROE
	s data={}
	d data.%Set("TaskDetailID",taskDetailID)
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("病历任务集详情表","web.CDSS.Demo.DEMONLPIdentify","SaveAllData",data.%ToJSON())
 	s ^ERRORLOGINFO(logid)=$ze 
	d result.%Set("success",0)
	d result.%Set("errorinfo","保存任务集详情的数据失败！原因如下：<br>ERROR保存失败！")
    q result.%ToJSON()
}

ClassMethod testSaveSusp()
{
	d ##class(web.CDSS.Demo.DEMONLPIdentify).SaveSuspDiseRec("","[1,{""DiseaseDetail"": {""就诊科室：呼吸科"": ""常见科室：胸外科,呼吸科,肿瘤科"", ""胸腔积液"": ""等级三(实体词--现病史)(以‘’收入院)""}, ""DiseaseID"": ""985"",""DiseaseName"": ""胸腔积液"", ""Symptom"": [""胸腔积液""], ""Weight"": ""0.672""}]")
	//[{"DiseaseDetail":{"构音障碍":"等级一(实体词--主诉)","癫痫":"等级一(实体词--主诉)"},"DiseaseID":"2010","DiseaseName":"朊蛋白病","Symptom":["癫痫","构音障碍"],"Weight":"0.036"}
}

/// WDT.CDSS.DEMONLPIdentify
/// d ##class(web.CDSS.Demo.DEMONLPIdentify)ExportData("")
ClassMethod ExportData(source As %String) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"疑似诊断评测工具数据.txt"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\DataExport\"
		s file=Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/DataExport/"
		s file=Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){d ##class(%File).CreateDirectoryChain(DirName)}
	
	o file:"NWS"
	u file
	w "识别信息	问题类型	标记内容"
	//d file.WriteLine()
		s ID=""
		for 
	    {
			s ID=$o(^WDT.CDSS.DEMONLPIdentifyD(ID))
			q:ID=""
			s IdentifyInfo= $lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),4)       
			s ProblemType= $lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),7)       
	   		s TagContent= $lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),8)       
	    	
	    	s NLPSource= $lg($g(^WDT.CDSS.DEMONLPIdentifyD(ID)),6)
	    	continue:(($ZCONVERT(NLPSource,"U")'[source)&&(source="用户新增"))
	    	
			w !,IdentifyInfo_"	"_ProblemType_"	"_TagContent
		}
	
	c file
	q fileName
}

/// Creator：胡宜良
/// CreatDate：2023-3-15
/// Description: 更新NLP，
/// Table：WDT.CDSS.DEMONLPIdentify
/// Input：NLPInfo(NLP串), TasksDetailID, documentType
/// Output："success","false"/"success","true"
/// Others：d ##class(web.CDSS.Demo.DEMONLPIdenwtify).UpdataNLPIdentify("","312","入院记录")
/// d ##class(web.CDSS.Demo.DEMONLPIdentify).UpdataNLPIdentify("{""1***肺炎"": ""胸腔积液，肺部感染(以收入)***现病史"", ""2***腹痛"": ""反复腹痛(归一词)腹痛、腰腹痛、腹部隐痛、腰腹胀痛、全腹胀痛、胸腹部疼痛、腹部不适(上位词)***主诉""}", "301", "入院记录")
ClassMethod UpdataNLPIdentify(NLPInfo As %String, TasksDetailID As %String, documentType As %String = "") As %String
{
	//测试方法
#;	s ^TMP("LG")=NLPInfo
#;	s NLPInfo=^TMP("LG")

	s result={}
	s user=$g(%session.Data("LOGON.USERNAME"))
	s NLPflag=""
	s NLPflagOne=""
	s flag=""
	//病历任务集NLP识别表JSON对象
	s jsonObj={"ID":"","TasksDetailDR":"","DocumentType":"","IdentifyInfo":"","NLPRecognition":"","NLPSource":"","ProblemType":"","TagContent":"","OperatorUser":"","OperationTime":"","IsOutput":"","IsSolve":""}
	s jsonObj.TasksDetailDR=TasksDetailID	// 指向病历任务集详情ID
	s jsonObj.DocumentType=documentType	// 文书类型

	if NLPInfo'=""
	{
		s idenObj={}.%FromJSON(NLPInfo)	// 解析JSON串
	}
	else
	{
		s res={"success":"false"}
		q res.%ToJSON()
	}
	
	
    // 初始化任务集中的NLP信息数据
	s flag=0
	s ids=""
	TStart
	s iter=idenObj.%GetIterator()
	while(iter.%GetNext(.key,.value))
	{
		s IdentifyInfo=$p(key, "***", 2)	// 识别信息
		s NLPRecognition=$p(value, "***", 1)	// NLP识别结果
		s NLPSource=$p(value, "***", 2)	// 识别来源:主诉/现病史

		s jsonObj.IdentifyInfo=IdentifyInfo	// 识别信息
		s jsonObj.NLPRecognition=NLPRecognition	// NLP识别结果
		s jsonObj.NLPSource=NLPSource	// 识别来源:主诉/现病史
		
		//s NLPflagTwo=$o(^WDT.CDSS.DEMONLPIdentifyI("IdentifyInfoIndex",TasksDetailID,IdentifyInfo,0))
		if ((IdentifyInfo="")) //识别信息为空新增数据
		{
			s NLPflagOne=$o(^WDT.CDSS.DEMONLPIdentifyI("NLPRecognitionIndex",TasksDetailID,NLPRecognition,0))
		
			if (NLPflagOne="") //NLP识别结果为存入的情况
			{
				s obj=##class(WDT.CDSS.DEMONLPIdentify).%New()
				d obj.TasksDetailDRSetObjectId(TasksDetailID)
				s obj.IdentifyInfo=IdentifyInfo
				s obj.NLPRecognition=NLPRecognition
				s obj.NLPSource=NLPSource
				s obj.OperatorUser=user	//操作人员
				s obj.OperationTime=$ZDATETIME($H,3)					//操作时间
				s obj.DocumentType=documentType
			}
			else
			{
				continue
			}
		}
		else
		{
			s NLPflag=$o(^WDT.CDSS.DEMONLPIdentifyI("IdentifyInfoIndex",TasksDetailID,IdentifyInfo,0))
			if (NLPflag="")  //新增数据
			{
				s obj=##class(WDT.CDSS.DEMONLPIdentify).%New()
				d obj.TasksDetailDRSetObjectId(TasksDetailID)
				s obj.IdentifyInfo=IdentifyInfo
				s obj.NLPRecognition=NLPRecognition
				s obj.NLPSource=NLPSource
				s obj.OperatorUser=user	//操作人员
				s obj.OperationTime=$ZDATETIME($H,3)					//操作时间
				s obj.DocumentType=documentType
			}
			else
			{	
				s obj=##class(WDT.CDSS.DEMONLPIdentify).%OpenId(NLPflag)
				// 备份旧数据
				s jsonObj.IdentifyInfo=obj.IdentifyInfo			// 识别信息
				s jsonObj.NLPRecognition=obj.NLPRecognition		// NLP识别结果
				s jsonObj.NLPSource=obj.NLPSource				// 识别来源:主诉/现病史/用户新增
				s jsonObj.ProblemType=obj.ProblemType			// 问题类型：识别错误/未识别
				s jsonObj.TagContent=obj.TagContent				// 标记内容
				s jsonObj.OperatorUser=obj.OperatorUser
				s jsonObj.OperationTime=obj.OperationTime
				if ((obj.NLPSource="用户新增")&(IdentifyInfo[jsonObj.IdentifyInfo))  //用户新增的类型被nlp识别
				{
					
					s obj.NLPSource=NLPSource	
					s obj.NLPRecognition=NLPRecognition
					
					//s obj.IdentifyInfo=IdentifyInfo
					//s obj.ProblemType=idenObj.ProblemType
					//s obj.TagContent=idenObj.TagContent		
				}
				
			}
		}
		s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            if (ids="")
            {
	            s ids=obj.%Id()
	        }
            else
            {
	            s ids=ids_"^"_obj.%Id()
	        }
        }
        else
        {
	        s flag=1
			d result.%Set("errorinfo","保存NLP识别结果失败！原因如下：<br>"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc))
			//保存错误日志
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("病历任务集NLP识别表","web.CDSS.Demo.DEMONLPIdentify","SaveNLPIdentifyNew",jsonObj.%ToJSON())
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    		Quit
        }
	}
	if (flag=1)
	{
		TRO
		d result.%Set("success","false")
	}
	else
	{
		TC
		d result.%Set("success","true")
		d result.%Set("ids",ids)
	}
	q result.%ToJSON()
	
SaveUpdataNLPIdenERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("病历任务集NLP识别表","web.CDSS.Demo.DEMONLPIdentify","UpdataNLPIdentifyNew",jsonObj.%ToJSON())
 	s ^ERRORLOGINFO(logid)=$ze 
	d result.%Set("success","false")
	d result.%Set("errorinfo","保存NLP识别结果失败！原因如下：<br>ERROR保存失败！")
    q result.%ToJSON()
}

}
