/// 名称:     web.CDSS.Demo.EvalWordTrigg
/// 描述:     识别词触发效果评测界面后台
/// 编写者：  杨继鸿
/// 编写日期: 2022-03-23
Class web.CDSS.Demo.EvalWordTrigg Extends %RegisteredObject
{

/// Creator：      杨继鸿
/// CreatDate：    2021-12-06
/// Description:   获取患者基本信息
/// Table：        WDT.CDSS.DEMOPatMaster
/// Input：        patid 患者ID, documentType
/// Output：       PatientDR,IDNO,Department,Sex,Age
/// Return：       与任务集关联的患者基本信息
/// Others：       d ##class(%ResultSet).RunQuery("web.CDSS.Demo.EvalWordTrigg","GetPatMasterList","2","入院记录") 
Query GetPatMasterList(patid As %String, documentType As %String) As %Query(ROWSPEC = "PatientDR,IDNO,Department,Sex,Age,AgeUnit")
{
}

ClassMethod GetPatMasterListExecute(ByRef qHandle As %Binary, patid As %String, documentType As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (patid'="")
    {       
        s PatientDR=patid	// 患者基础信息表ID
        
        s IDNO=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatientDR)),2)	// 患者主索引
        s Department=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatientDR)),14)	// 科室
        s Sex=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatientDR)),9)	// 性别
        s Age=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatientDR)),11)	// 年龄
		s AgeUnit=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatientDR)),12)	// 年龄单位
        d OutputPatMasterRow
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputPatMasterRow
    set Data=$lb(PatientDR,IDNO,Department,Sex,Age,AgeUnit)
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
/// CreatDate：    2022-03-31
/// Description:   更新患者的临床信息表
/// Input：        patid 患者ID
/// Return：       与任务集关联的患者基本信息
/// Others：       d ##class(web.CDSS.Demo.EvalWordTrigg).UpdateClinicInfo(1^2) 
ClassMethod UpdateClinicInfo(patidStr As %String) As %String
{
	s patid=0
	for i=1:1:$l(patidStr,"^")
	{
		s patid=$p(patidStr,"^",i)
		q:patid=""
		d ##class(web.CDSS.Demo.EvalWordTrigg).ParseAdmRec(patid)
		d ##class(web.CDSS.Demo.EvalWordTrigg).ParseDischargeRec(patid)
		//检查报告
		d ##class(web.CDSS.MachineLearning.Inteplatform).SaveExamJsonInfo(^TMP("KYXExam"))
	}
}

/// Creator：      杨继鸿
/// CreatDate：    2022-04-11
/// Description:：   初始化NLP识别结果、触发的识别词的入口
/// Input：            patid WDT.CDSS.DEMOPatMaster的ID；taskid WDT.CDSS.TriggTasksDetail的ID
/// Output：          result json字符串
/// Return：         成功 "{'success':'true', 'id':'taskid'}"；失败 "{success:'false',errorinfo:'...'}"
/// Others：        w ##class(web.CDSS.Demo.EvalWordTrigg).InitAllData("43","1")
ClassMethod InitAllData(taskid, patid)
{
	s $zt="InitAllDataERROR"
	s result=""
	s flag=0
	TS
	// 获取NLP识别结果
	s initNLP=##class(web.CDSS.Demo.TriggNLPIdentify).InitNLPIdentify(taskid,patid)
	if initNLP'["false"
	{
		// 获取触发的识别词
		s getIWords=##class(web.CDSS.Demo.TriggIWRecord).InitIWRecords(taskid,patid)
		s:getIWords["false" result=getIWords
		s:getIWords["false" flag=1
	}
	else
	{
		s flag=1
		s result=initNLP
	}
	if flag=1
	{
		// 失败
		TRO
	}
	else
	{
		TC
		// 切换当前患者
		d ##class(web.CDSS.Demo.PatMaster).SavePatId(patid)
		s result="{'success':'true', 'id':'"_taskid_"'}"
	}
	q result
InitAllDataERROR
	if (($d(%session)>0) & (($g(%session.Data("SERVER_NAME"))="127.0.0.1") || ($g(%session.Data("SERVER_NAME"))["localhost")))
	{
		s result="{'success':'false', 'errorinfo':'检查本地是否能运行NLP算法和触发识别词算法！'}"
	}
	q result
}

/// Creator：      杨继鸿
/// CreatDate：    2022-03-28
/// Description:   获取入院记录、出院记录的病历记录的数据，目前仅有入院记录、出院记录
/// 默认获取患者的第一份病历
/// Table：        WDT.CDSS.DEMOAdmRec, WDT.CDSS.DEMODischargeRec
/// Input：        patid DEMO患者ID
/// Output：       PatientDR,RowId,DocumentType,OriginalContent
/// Return：       {"rows":[{PatientDR,RowId,DocumentType,OriginalContent}],"total":number}
/// Others：       d ##class(%ResultSet).RunQuery("web.CDSS.Demo.EvalWordTrigg","GetRecordsList","1") 
Query GetRecordsList(patid As %String) As %Query(ROWSPEC = "RowId,PatientDR,DocumentType,OriginalContent")
{
}

ClassMethod GetRecordsListExecute(ByRef qHandle As %Binary, patid As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    if (##class(WDT.CDSS.DEMOPatMaster).%ExistsId(patid))
    {
	    s PatientDR=patid
	    //入院记录
	    s admRecID=$o(^WDT.CDSS.DEMOAdmRecI("PatIndex",patid,0))
	    s RowId=admRecID
	    s DocumentType="入院记录"
	    // 打开当前演示系统选定的患者入院记录
	    s OriginalContent=##class(web.CDSS.Demo.AdmRec).OpenData()
	    d OutputRecords
	    
	    //出院记录
	    s dischargeRecID=$o(^WDT.CDSS.DEMODischargeRecI("PatIndex",patid,0))
	    s RowId=dischargeRecID
	    s DocumentType="出院记录"
	    // 打开当前演示系统选定的患者出院记录
	    s OriginalContent=##class(web.CDSS.Demo.DischargeRec).OpenData()
	    d OutputRecords
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRecords
    set Data=$lb(RowId,PatientDR,DocumentType,OriginalContent)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetRecordsListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRecordsListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetRecordsListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRecordsListExecute ]
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

/// Creator: 杨继鸿
/// CreatDate: 2022-04-26
/// Description: 解析出院记录，出院诊断、出院情况保存到诊断、现病史中
/// Input: patid DEMO患者基础信息表ID
/// Return: 0 数据不存在；1 成功
/// Others: d ##class(web.CDSS.Demo.EvalWordTrigg).ParseDischargeRec("969")
ClassMethod ParseDischargeRec(patid As %String)
{
	s data={}
	s IDNO=$lg($g(^WDT.CDSS.DEMOPatMasterD(patid)),2)
	q:IDNO="" 0
	
	s data.IDNO=IDNO	// 患者主索引
	s data.PatientDR=$lg($g(^WDT.CDSS.DEMOPatMasterD(patid)),3)	// 病人标识（就诊医院id)

	s data.VisitID=$lg($g(^WDT.CDSS.DEMOPatMasterD(patid)),5)		// 就诊次数编号（第几次）
	s data.VisitType="3"	// 就诊类型：3 住院
	
	s data.Name=$lg($g(^WDT.CDSS.DEMOPatMasterD(patid)),8)	// 姓名
	s data.UserID=""	// 医生ID
	s data.UserName=""	// 医生姓名
	s data.DeptCode=""	// 科室编码
	s data.DeptName=$lg($g(^WDT.CDSS.DEMOPatMasterD(patid)),14)	// 科室名称
	s data.HospCode=""	// 医院编码
	s data.HospName=""	// 医院名称
	
	s PatientInfo={}
	s Sex=$lg($g(^WDT.CDSS.DEMOPatMasterD(patid)),9)
	if (Sex = "女") 
	{
		s Gender = 0
	} 
	elseif (Sex = "男") 
	{
		s Gender = 1
	} 
	else
	{ 
		s Gender = 2
	}
	s PatientInfo.Gender=Gender	// 性别
	s PatientInfo.BirthDate=$lg($g(^WDT.CDSS.DEMOPatMasterD(patid)),10)	// 出生日期
	s PatientInfo.PregnancyStatus=""	// 妊娠/产后状态（通过入院诊断等通过识别词来判断）
	
	s data.PatientInfo=PatientInfo	
	
	s ProgressNoteList={}
	s ProgressNoteList.ProgressType="1"	// 病历类型
	s ProgressNoteList.ProgressTempleateID=""	// 模板唯一标示
	s ProgressNoteList.ProgressTemplateName=""	// 模板名称
	s ProgressNoteList.MsgType="2"	// 病历内容传递格式
	s ProgressNoteList.Message=""	// 病历内容
	
	s recid=$o(^WDT.CDSS.DEMODischargeRecI("PatIndex",patid,0))
	q:recid="" 0
	s MessageList=[]
	s DischargeDiag={}
	s DischargeDiag.key="出院诊断"	// 诊断类型：出院诊断
	s DischargeDiag.value=$lg($g(^WDT.CDSS.DEMODischargeRecD(recid)),8)	// 出院诊断
	s DischargeSituation={}
	s DischargeSituation.key="出院情况"	// 诊断类型：出院情况
	s DischargeSituation.value=$lg($g(^WDT.CDSS.DEMODischargeRecD(recid)),9)	// 出院情况
	d:DischargeDiag.value'="" MessageList.%Push(DischargeDiag)
	d:DischargeSituation.value'="" MessageList.%Push(DischargeSituation)
	
	
	s ProgressNoteList.ProgressId=recid	// 病历唯一标识
	s ProgressNoteList.MessageList=MessageList	
	
	s ProgressNoteList.DoctorId=""	// 开立医生ID
	s ProgressNoteList.DoctorName=$lg($g(^WDT.CDSS.DEMODischargeRecD(recid)),13)	// 医生姓名
	s ProgressNoteList.CreateDeptCode=""	// 开立科室代码
	s ProgressNoteList.CreatDeptName=""	// 开立科室名称
	s ProgressNoteList.RecordTime=$lg($g(^WDT.CDSS.DEMODischargeRecD(recid)),14)	// 病历记录时间
	
	s data.ProgressNoteList=ProgressNoteList
	//s ^TMPDICRDATA=data.%ToJSON()
	d ##class(web.CDSS.MachineLearning.PatientInfoRenew).DHCHisInterface("SAVE_MEDICAL_RECORD_INFORMATION",data.%ToJSON())
	q 1
}

/// Creator: 杨继鸿
/// CreatDate: 2022-04-13
/// Description: 入院记录过NLP解析
/// Input: patid DEMO患者基础信息ID
/// Others: w ##class(web.CDSS.Demo.EvalWordTrigg).ParseAdmRec("")
ClassMethod ParseAdmRec(patid As %String)
{
	s PatDR=patid
	s PatientDR=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),3)			//PatientDR
	s AdmissionCount=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),5)		//住院次
	s Name=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),8)				//姓名
	s Department=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),14)			//科室
	s Hospital=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),30)			//医院
	s Sex=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),9)					//性别
	s Birthday=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),10)		
	
	s AdmID=$o(^WDT.CDSS.DEMOAdmRecI("PatIndex",PatDR,0))
	s ChiefCompSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),3)		//主诉
	s CurrentMedHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),4)	//现病史
	s PastDiagnosisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),5)
	s AllergyHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),6)
	s PersonalHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),7)
	s MarryHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),8)
	s MenstrualHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),9)
	s FamilyHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),10)
	s PhysicalExamSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),11)
	s SpecExamSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),12)
	s AssisExam=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),13)
	s CurrentTreatMedication=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),14)
	s PreliminaryDiag=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),15)		//初步
	s ConfirmDiag=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),16)			//确诊
	s ComplementaryDiag=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),17)		//补充
	s DiagnosisCorrecting=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),18)	//修正
	s RecordTime=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),20)				//记录时间

    s record={}
    d record.%Set("IDNO",IDNO)
    d record.%Set("PatientDR",PatientDR)
    d record.%Set("VisitID",AdmissionCount)
    d record.%Set("VisitType","3")
    d record.%Set("Name",Name)
    d record.%Set("UserID","XXX")
    d record.%Set("UserName","XXX")
    d record.%Set("DeptCode","XXX")
    d record.%Set("DeptName",Department)
    d record.%Set("HospCode","XXX")
    d record.%Set("HospName",Hospital)
    s PatientInfo={}
    if (Sex = "女") 
    {
        s Gender = 0
    } 
    elseif (Sex = "男") 
    {
        s Gender = 1
    } 
    else
    { 
        s Gender = 2
    }
    d PatientInfo.%Set("Gender",Gender)
    d PatientInfo.%Set("BirthDate",Birthday)
    d PatientInfo.%Set("PregnancyStatus",0)
    d record.%Set("PatientInfo",PatientInfo)
    s ProgressNoteList={}
    d ProgressNoteList.%Set("ProgressId","Patient"_1)
    d ProgressNoteList.%Set("ProgressType",0)
    d ProgressNoteList.%Set("ProgressTempleateID","Patient"_1)
    d ProgressNoteList.%Set("ProgressTemplateName","")
    d ProgressNoteList.%Set("MsgType",2)
    d ProgressNoteList.%Set("Message","")
	s MessageList=[]
	s MessageArr("1","主诉")=ChiefCompSum
	s MessageArr("2","现病史")=CurrentMedHisSum
	s MessageArr("3","既往史")=PastDiagnosisSum
	s MessageArr("4","个人史")=PersonalHisSum
	s MessageArr("5","婚育史")=MarryHisSum
	s MessageArr("6","其他史")=""
	s MessageArr("7","过敏史")=AllergyHisSum
	s MessageArr("8","家族史")=FamilyHisSum
	s MessageArr("9","月经史")=MenstrualHisSum
	s MessageArr("10","体格检查")=PhysicalExamSum
	s MessageArr("11","专科检查")=SpecExamSum
	s MessageArr("12","初步诊断")=PreliminaryDiag
	s MessageArr("13","确诊诊断")=ConfirmDiag
	s MessageArr("14","补充诊断")=ComplementaryDiag
	s MessageArr("15","修正诊断")=DiagnosisCorrecting
    s idNum=""
    for 
    {
    	s idNum=$o(MessageArr(idNum)) q:idNum=""
    	s key=$o(MessageArr(idNum,""))
    	s value=$g(MessageArr(idNum,key))
    	s message={}
    	d message.%Set("key",key)  
    	d message.%Set("value",value)    
    	d MessageList.%Push(message)
    }
    d ProgressNoteList.%Set("MessageList",MessageList)
    d ProgressNoteList.%Set("DoctorId","XXX")
    d ProgressNoteList.%Set("DoctorName","XXX")
    d ProgressNoteList.%Set("CreateDeptCode","XXX")
    d ProgressNoteList.%Set("CreateDeptName",Department)
    d ProgressNoteList.%Set("RecordTime",RecordTime)
   	d record.%Set("ProgressNoteList",ProgressNoteList)
   	s jsonRecord=record.%ToJSON()
   	s scHis=##class(web.CDSS.MachineLearning.InteractiveInterface).DHCHisInterface("SAVE_MEDICAL_RECORD_INFORMATION",jsonRecord)
}

/// Creator：      杨继鸿
/// CreatDate：    2022-04-14
/// Description:：   保存病历
/// Input：            doctype 文书类型；rowid 病历ID；patid 患者ID；jsonstr 病历数据；taskid WDT.CDSS.TriggTasksDetail的ID；
/// Output：          result json字符串
/// Return：         成功 "{success:'true',count:删除的数量}"；失败 "{success:'false',errorinfo:'...'}"
/// Others：        d ##class(web.CDSS.Demo.EvalWordTrigg).SaveRecords("入院记录","{}")
ClassMethod SaveRecords(doctype, rowid, patid, jsonstr, taskid) As %String
{
	s result=""
	s data={}.%FromJSON(jsonstr)
	s PatDR=patid
	
	if (##class(WDT.CDSS.DEMOPatMaster).%ExistsId(patid))
	{
		s falseFlag=0
		TS
		
		s obj=##class(WDT.CDSS.DEMOPatMaster).%OpenId(PatDR)
		if (doctype="入院记录")
		{
			s eobj=##class(web.CDSSEntity.Demo.AdmRec).%New()
			s eobj.Name = obj.Name
			s eobj.Sex = obj.Sex
			s eobj.BirthPlace = obj.BirthPlace
			s eobj.Marriage = obj.Marriage
			s eobj.Address = obj.Address
			s eobj.WorkUnitName = obj.WorkUnitName
			s eobj.AdmisTime = obj.AdmisTime
			s eobj.Representor = obj.Representor
			s eobj.RecordTime = obj.RecordTime
			s eobj.RowId=rowid
			s eobj.PatDR=PatDR
			s eobj.ChiefCompSum = data.ChiefCompSum
			s eobj.CurrentMedHisSum = data.CurrentMedHisSum
			s eobj.PastDiagnosisSum = data.PastDiagnosisSum
			s eobj.AllergyHisSum = data.AllergyHisSum
			s eobj.PersonalHisSum = data.PersonalHisSum
			s eobj.MarryHisSum = data.MarryHisSum
			s eobj.MenstrualHisSum = data.MenstrualHisSum
			s eobj.FamilyHisSum = data.FamilyHisSum
			s eobj.PhysicalExamSum = data.PhysicalExamSum
			s eobj.SpecExamSum = data.SpecExamSum
			s eobj.AssisExam = data.AssisExam
			s eobj.CurrentTreatMedication = data.CurrentTreatMedication
			s eobj.PreliminaryDiag = data.PreliminaryDiag
			s eobj.ConfirmDiag = data.ConfirmDiag
			s eobj.ComplementaryDiag = data.ComplementaryDiag
			s eobj.DiagnosisCorrecting = data.DiagnosisCorrecting
			s eobj.DoctorSign = data.DoctorSign
			s eobj.RecordTime = data.RecordTime
		    //调用保存
		    s result=##class(web.CDSS.Demo.AdmRec).SaveData(eobj)
		    // 取文本Id
		    s docId=$p($p(result,"id",2),"'",2)
		    s nlpResult=..GetAdmRecNLPResult(docId)
		}
		elseif (doctype="出院记录")
		{
			s eobj = ##class(web.CDSSEntity.Demo.DischargeRec).%New()
			s eobj.Name = obj.Name
			s eobj.Sex = obj.Sex
			s eobj.Age = obj.Age
			s eobj.AgeUnit = obj.AgeUnit
			s eobj.AdmisTime = obj.AdmisTime
			s eobj.HospDays = obj.HospDays
			s eobj.DischargeTime = obj.DischargeTime
			s eobj.RowId=rowid
			s eobj.PatDR=PatDR
			s eobj.AdmisComplexion = data.AdmisComplexion
			s eobj.AdmisDisease = data.AdmisDisease
			s eobj.TreateProcess = data.TreateProcess
			s eobj.OperaName = data.OperaName
			s eobj.WoundHealing = data.WoundHealing
			s eobj.DischargeDiag = data.DischargeDiag
			s eobj.DischargeSituation = data.DischargeSituation
			s eobj.DischargeOrder = data.DischargeOrder
			s eobj.DischargeGuide = data.DischargeGuide
			s eobj.RehospitalPlan = data.RehospitalPlan
			s eobj.DoctorSign = data.DoctorSign
			s eobj.RecordTime = data.RecordTime
		    //调用保存
		    s result=##class(web.CDSS.Demo.DischargeRec).SaveData(eobj)
		    // 取文本Id
		    s docId=$p($p(result,"id",2),"'",2)
		    s nlpResult=..GetDischargeRecNLPResult(docId)
		}
		else
		{
			s result = "{success:'false',errorinfo:'目前不支持此类病历记录'}"
			s falseFlag=1
		}
		if result'["false"
		{
			s updateNLPinfo=##class(web.CDSS.Demo.TriggNLPIdentify).UpdateNLPInfo("0",docId,taskid,doctype,nlpResult.%ToJSON())
			if updateNLPinfo["false"
			{
				s result=updateNLPinfo
				s falseFlag=1
				q
			}
		}
		else
		{
			s falseFlag=1
		}
		//更新任务编辑状态
		d ##class(web.CDSS.Demo.TriggTasksDetail).UpdateState(taskid)
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
		s result = "{success:'false',errorinfo:'患者不存在'}"
	}
	q result
}

/// Creator: 杨继鸿
/// CreatDate: 2022-04-13
/// Description: 获得RIS报告表内容
/// Table: WDT.CDSS.DEMORISReport
/// Input: patid 患者id
/// Return: 返回患者的所有RIS报告表内容
/// Others: d ##class(%ResultSet).RunQuery("web.CDSS.Demo.EvalWordTrigg","GetRISList","")
Query GetRISList(patid As %String) As %Query(ROWSPEC = "RowId,PatDR,CreateTime,ExamLoc,ExamNumber,CurrentDiag,ExamItem,ExamResult,DoctorSign,RecordTime,OrderContent,OrdersDR")
{
}

ClassMethod GetRISListExecute(ByRef qHandle As %Binary, patid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s PatDR=patid //患者Id
 	if PatDR=""
 	{
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
	s RowId = ""
	for
	{
		s RowId = $o(^WDT.CDSS.DEMORISReportI("PatIndex",PatDR,RowId),-1)
		q:RowId=""
		s CreateTime = $lg($g(^WDT.CDSS.DEMORISReportD(RowId)),3)
		s ExamLoc = $lg($g(^WDT.CDSS.DEMORISReportD(RowId)),4)
		s ExamNumber = $lg($g(^WDT.CDSS.DEMORISReportD(RowId)),5)
		s CurrentDiag = $lg($g(^WDT.CDSS.DEMORISReportD(RowId)),6)
		s ExamItem = $lg($g(^WDT.CDSS.DEMORISReportD(RowId)),7)
		s ExamResult = $lg($g(^WDT.CDSS.DEMORISReportD(RowId)),8)
		s DoctorSign = $lg($g(^WDT.CDSS.DEMORISReportD(RowId)),9)
		s RecordTime = $lg($g(^WDT.CDSS.DEMORISReportD(RowId)),10)
		s OrdersDR = $lg($g(^WDT.CDSS.DEMORISReportD(RowId)),12)
		s OrderContent=""
		s:OrdersDR'="" OrderContent= $lg($g(^WDT.CDSS.DEMOExamOrdersD(OrdersDR)),6)

		d OutputRow
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,PatDR,CreateTime,ExamLoc,ExamNumber,CurrentDiag,ExamItem,ExamResult,DoctorSign,RecordTime,OrderContent,OrdersDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetRISListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRISListExecute ]
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

ClassMethod GetRISListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRISListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      杨继鸿
/// CreatDate：    2022-04-14
/// Description:：   保存检查报告，并新增医嘱
/// Input: taskid　任务集详情ID, patid 患者ID datastr　检查报告数据
/// Output：          result json字符串
/// Return：         成功 "{success:'true',count:删除的数量}"；失败 "{success:'false',errorinfo:'...'}"
/// Others: w ##class(web.CDSS.Demo.EvalWordTrigg).SaveRISReport(1,284,"{""RowId"":""87"",""OrderContent"":""胃镜"",""OrdersDR"":"""",""ExamItem"":"""",""ExamResult"":""""}")
ClassMethod SaveRISReport(taskid, patid, datastr As %String) As %String
{
	s result=""
	s risdata={}.%FromJSON(datastr)
	s reportid=risdata.RowId
	
	// 根据当前的检查医嘱文本，关联检查医嘱的ID
	s rs=##class(%ResultSet).%New("web.CDSS.Demo.ExamOrders"_":"_"GetList")
	s sc=rs.Execute(patid,"")
	for 
	{
		quit:rs.Next(.sc)=0
		if $$$ISOK(sc) 
		{
			if risdata.OrderContent=rs.GetData(5)
			{
				s risdata.OrdersDR=rs.GetData(1)
			}
		}
		else
		{
			quit
		}
	}
	if risdata.OrdersDR=""
	{
		s result="{success:'false',errorinfo:'检查医嘱ID为空！'}"
	}
	else
	{
		s eobjRec = ##class(web.CDSSEntity.Demo.RISReport).%New()
		s objRec=##class(WDT.CDSS.DEMORISReport).%OpenId(reportid)
		// 修改检查报告
		if (objRec'="")
		{
			//修改检查报告
			s eobjRec.RowId=reportid
			s eobjRec.PatDR = objRec.PatDR.%Id()
			s eobjRec.CreateTime = objRec.CreateTime
			s eobjRec.ExamLoc = objRec.ExamLoc
			s eobjRec.ExamNumber = objRec.ExamNumber
			s eobjRec.CurrentDiag = objRec.CurrentDiag
			s eobjRec.ExamItem = objRec.ExamItem
			s eobjRec.ExamResult = objRec.ExamResult
			s eobjRec.DoctorSign = objRec.DoctorSign
			s eobjRec.RecordTime = objRec.RecordTime
			s:objRec.OrdersDR'="" eobjRec.OrdersDR = objRec.OrdersDR.%Id()
			s:objRec.OrdersDR="" eobjRec.OrdersDR = ""
		}
		// 新增检查报告
		else
		{
			s eobjRec.PatDR = patid
			s eobjRec.CreateTime = $zdt($h,3)	// 创建时间
		}
		
		//赋新值
		s eobjRec.OrdersDR=risdata.OrdersDR	// 检查医嘱ID
		s eobjRec.ExamItem=risdata.ExamItem	// 检查项目
		s eobjRec.ExamResult=risdata.ExamResult	// 检查结果		

		TS
		s saveRS=##class(web.CDSS.Demo.RISReport).SaveData(eobjRec)
		if saveRS["false"
		{
			s result=saveRS
		}
		else
		{			
			s result=saveRS
			// 检查报告ID
			s id=$p($p(saveRS,"id",2),"'",2)
			// 重新过NLP解析
			s nlpresult=..GetRISRNLPResult(id)
			s updateReportNLP=##class(web.CDSS.Demo.TriggNLPIdentify).UpdateNLPInfo("0",id,taskid,"检查报告",nlpresult.%ToJSON())
			if updateReportNLP["false"
			{
				s result=updateReportNLP
			}
#;			s iter=nlpresult.%GetIterator()
#;			while iter.%GetNext(.k,.v)
#;			{
#;				s reportNLPSave=##class(web.CDSS.Demo.TriggNLPIdentify).UpdateNLPResult("0",id,taskid,"检查报告",k,v)
#;				if reportNLPSave["false"
#;				{
#;					s result=reportNLPSave
#;					q
#;				}
#;			}
		}

		if result["false"
		{
			TRO
		}
		else
		{
			TC
			d ##class(web.CDSS.Demo.TriggTasksDetail).UpdateState(taskid)
		}
	}
	
	q result
}

/// Creator: 杨继鸿
/// CreatDate: 2022-04-19
/// Description: 获取检查结果NLP结果
/// Input: taskid WDT.CDSS.TriggTasksDetail的ID
/// Output: nlpresult json对象
/// Return: {"检查结果"}
/// Others: w ##class(web.CDSS.Demo.EvalWordTrigg).GetRISRNLPResult("40")
ClassMethod GetRISRNLPResult(reportid) As %DynamicArray
{
	s nlpresult={}
	
	s obj=##class(WDT.CDSS.DEMORISReport).%OpenId(reportid)
	if obj'=""
	{
		s risResult=$lg($g(^WDT.CDSS.DEMORISReportD(reportid)),8)		
		q:risResult="" nlpresult
		s json=##class(web.CDSS.MachineLearning.Inteplatform).GetStructedDataAPI(risResult)
		s:json'="" rs=..CollectResultToNLP(json)
		
		s RISNLPResult={}
		s length=$length(rs,";")
		for i=1:1:length
		{
			s onedata=$p(rs,";",i)
			q:onedata=""
			s key=$p(onedata,",",1)
			s value=""
			s value="formal:"_$p(onedata,",",2)_","
			s value=value_"core:"_$p(onedata,",",3)_","
			s value=value_"symproperty:"_$p(onedata,",",4)_","
			s value=value_"stand_body:"_$p(onedata,",",5)_","
			s value=value_"position:"_$p(onedata,",",6)
			//w key,!,value
			d RISNLPResult.%Set(key,value)
		}		
	}
	d nlpresult.%Set("检查结果",RISNLPResult)
	q nlpresult
}

/// Creator: 杨继鸿
/// CreatDate: 2022-04-19
/// Description: 获取入院记录过NLP的结果
/// Input: taskid WDT.CDSS.TriggTasksDetail的ID
/// Output: result json对象
/// Return: {主诉：{识别信息:识别结果，识别信息：识别结果}，现病史：{识别信息，识别结果}...}
/// Others: d ##class(web.CDSS.Demo.EvalWordTrigg).GetAdmRecNLPResult("1")
ClassMethod GetAdmRecNLPResult(recordid) As %DynamicObject
{
	s result={}
	
	s obj=##class(WDT.CDSS.DEMOAdmRec).%OpenId(recordid)
	if obj'=""
	{
        s AdmRecordID=recordid
        
        s ChiefCompSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),3)	//主诉概述
        s CurrentMedHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),4)	//现病史概述
        s PastDiagnosisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),5)	//既往史概述
        s AllergyHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),6)	//过敏史概述
        s PersonalHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),7)	//个人史概述
        s MarryHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),8)	//婚育史概述
        s MenstrualHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),9)	//月经史概述
        s FamilyHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),10)	//家族史概述
        s PhysicalExamSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),11)	//体格检查概述
        s PreliminaryDiag=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),15)	//初步诊断
        s ConfirmDiag=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),16)	//确诊诊断
        s ComplementaryDiag=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),17)	//补充诊断
        s DiagnosisCorrecting=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmRecordID)),18)	//修正诊断
        
        k MessageArr
		s MessageArr("1","主诉")=ChiefCompSum
		s MessageArr("2","现病史")=CurrentMedHisSum
		s MessageArr("3","既往史")=PastDiagnosisSum
		s MessageArr("4","个人史")=PersonalHisSum
		s MessageArr("5","婚育史")=MarryHisSum
		s MessageArr("6","过敏史")=AllergyHisSum
		s MessageArr("7","家族史")=FamilyHisSum
		s MessageArr("8","月经史")=MenstrualHisSum
		s MessageArr("9","体格检查")=PhysicalExamSum
		s MessageArr("10","初步诊断")=PreliminaryDiag
		s MessageArr("11","确诊诊断")=ConfirmDiag
		s MessageArr("12","补充诊断")=ComplementaryDiag
		s MessageArr("13","修正诊断")=DiagnosisCorrecting
	    s idNum=""
	    for 
	    {
	    	s idNum=$o(MessageArr(idNum)) q:idNum=""
	    	s key=$o(MessageArr(idNum,""))
	    	s value=$g(MessageArr(idNum,key))
	    	continue:value=""	//文本为空，则无此类数据不过NLP
	    	if key="月经史"
	    	{
		    	s key="婚育史"
		    	s message=result.%Get("婚育史")
	    	}
	    	elseif ((key="初步诊断") || (key="确诊诊断") || (key="补充诊断") || (key="修正诊断"))
	    	{
		    	s key="诊断"
		    	s message=result.%Get("诊断")
	    	}
	    	else
	    	{
		    	s message={}
	    	}
	    	if (message="")
	    	{
		    	s message={}
	    	}
	    	s nlpResult=##class(web.CDSS.MachineLearning.PatientInfoRenew).MedicalRecordToNlp(value)
	    	s length=$length(nlpResult,"，")
	    	for i=1:1:length
	    	{
		    	s onedata=$p(nlpResult,"，",i)
		    	//取出formal前的文本，给value赋值，如果无formal，就用value
		    	s name=$p($p($p(onedata,"formal:",1),":",2),",",1)
		    	d:name'="" message.%Set(name,onedata)
		    	d:name="" message.%Set(value,onedata)
	    	}
	    	d result.%Set(key, message)
	    }
	}
	q result
}

/// Creator: 杨继鸿
/// CreatDate: 2022-04-19
/// Description: 获取出院记录过NLP的结果
/// Output: result json对象
/// Return: {诊断：{识别信息:识别结果，识别信息：识别结果}，现病史：{识别信息，识别结果}...}
/// Others: d ##class(web.CDSS.Demo.EvalWordTrigg).GetDischargeRecNLPResult("1")
ClassMethod GetDischargeRecNLPResult(recordid)
{
	//获取出院诊断、出院情况
	s result={}
	
	s obj=##class(WDT.CDSS.DEMODischargeRec).%OpenId(recordid)
	if obj'=""
	{
		s DischargeDiag=$lg($g(^WDT.CDSS.DEMODischargeRecD(recordid)),8)	// 出院诊断
		s DischargeSituation=$lg($g(^WDT.CDSS.DEMODischargeRecD(recordid)),9)	// 出院情况
        
		k MessageArr
		s MessageArr("1","出院诊断")=DischargeDiag
		s MessageArr("2","出院情况")=DischargeSituation
		
	    s idNum=""
	    for 
	    {
	    	s idNum=$o(MessageArr(idNum)) q:idNum=""
	    	s key=$o(MessageArr(idNum,""))
	    	s value=$g(MessageArr(idNum,key))
	    	continue:value=""
	    	s message={}
	    	s nlpResult=##class(web.CDSS.MachineLearning.PatientInfoRenew).MedicalRecordToNlp(value)
	    	s length=$length(nlpResult,"，")
	    	for i=1:1:length
	    	{
		    	s onedata=$p(nlpResult,"，",i)
		    	//取出formal前的文本，给value赋值，如果无formal，就用value
		    	s name=$p($p($p(onedata,"formal:",1),":",2),",",1)
		    	d:name'="" message.%Set(name,onedata)
		    	d:name="" message.%Set(value,onedata)
	    	}
	    	if key="出院诊断"
	    	{
		    	s key="诊断"
	    	}
	    	else
	    	{
		    	s key="现病史"
	    	}
	    	d result.%Set(key, message)
	    }
	}
	q result
}

/// Creator: 杨继鸿
/// CreatDate: 2022-04-13
/// Description: 格式化NLP解析结果
/// Input: NLPStringOld NLP解析结果
/// Output: name,formal,core,symproperty,stand_body,position;
/// Return: n源文本,归一词,上位词,属性,部位,方位;
/// Others: w ##class(web.CDSS.Demo.EvalWordTrigg).CollectResultToNLP("")
ClassMethod CollectResultToNLP(NLPStringOld As %String) As %String
{
	s NLPString=$REPLACE(NLPStringOld,"'","""")
	s formal=""
	s results=""
	if NLPString="[]"
	{
		q ""
	}
	else
	{
		s NLPArray=[].%FromJSON(NLPString)
	
	    for i=0:1:NLPArray.%Size()-1
		{
			s ItemJson=NLPArray.%Get(i)
			s result=""
			if (ItemJson.%IsDefined("name"))&(ItemJson.%Get("name")'="")
		    {
			    s result=result_ItemJson.%Get("name")
		    }
		    s result=result_","
			if (ItemJson.%IsDefined("formal"))&(ItemJson.%Get("formal")'="")
		    {
			    s result=result_ItemJson.%Get("formal")
		    }
		    s result=result_","
		    if (ItemJson.%IsDefined("core"))&(ItemJson.%Get("core")'="")
		    {
			    s result=result_ItemJson.%Get("core")
		    }
		    s result=result_","
		    ///属性：用&%拼接level，frequency，nature，day_time内容
			s SymProperty=""
			if ItemJson.%IsDefined("level")
			{
				s Level=ItemJson.%Get("level").%Get("name")  //程度
				s SymProperty=Level
			}
			if ItemJson.%IsDefined("frenquency")
			{
				s Frenquency=ItemJson.%Get("frenquency").%Get("name")  //频率
				s:SymProperty'="" SymProperty=SymProperty_"&%"_Frenquency
				s:SymProperty="" SymProperty=Frenquency
			}
			if ItemJson.%IsDefined("nature")
			{
				s Nature=""
				if ($e(ItemJson.%Get("nature").%ToJSON(),1)="[")  //"[...]"格式
				{
					for p=0:1:ItemJson.%Get("nature").%Size()-1 //$l(ItemJson.%Get("nature"))
					{
						s NatureJson=ItemJson.%Get("nature").%Get(p)
						s NatureNow=NatureJson.%Get("name")
						s:Nature'="" Nature=Nature_"&%"_NatureNow
						s:Nature="" Nature=NatureNow
					}
				}
				elseif ($e(ItemJson.%Get("nature").%ToJSON(),1)="{") //"{...}"格式
				{
					s Nature=ItemJson.%Get("nature").%Get("name")  //性质
				}
				
				//s Nature=ItemJson.%Get("nature").%Get("name")  //性质
				s:SymProperty'="" SymProperty=SymProperty_"&%"_Nature
				s:SymProperty="" SymProperty=Nature
			}
			if ItemJson.%IsDefined("day_time")
			{
				///day_time的格式区别于level和frequency，"[...]"格式
				s DayTime=""
				for y=0:1:ItemJson.%Get("day_time").%Size()-1 //$l(ItemJson.%Get("day_time"))
				{
					s DayTimeJson=ItemJson.%Get("day_time").%Get(y)
					s DayTimeNow=DayTimeJson.%Get("name")
					s:DayTime'="" DayTime=DayTime_"&%"_DayTimeNow
					s:DayTime="" DayTime=DayTimeNow
				}
				s:SymProperty'="" SymProperty=SymProperty_"&%"_DayTime
				s:SymProperty="" SymProperty=DayTime
			}
			s result=result_SymProperty_","
			//2.0的部位和方位
			if ItemJson.%IsDefined("stand_body") ///2.0的部位 CDSS2PartDR
			{
				s Body=""
				for t=0:1:ItemJson.%Get("stand_body").%Size()-1
				{
					s BodyJson=ItemJson.%Get("stand_body").%Get(t)
					s BodyNow=BodyJson.%Get("name")
					s:Body'="" Body=Body_BodyNow
					s:Body="" Body=BodyNow
				}
			}
			else
			{
				s Body=""
			}
			
			if ItemJson.%IsDefined("stand_pos")  //2.0的方位  PositionWordDR
			{
				s Pos=""
				for q=0:1:ItemJson.%Get("stand_pos").%Size()-1
				{
					s PosJson=ItemJson.%Get("stand_pos").%Get(q)
					s PosNow=PosJson.%Get("name")
					s:Pos'="" Pos=Pos_PosNow
					s:Pos="" Pos=PosNow
				}
			}
			else
			{
				s Pos=""
			}
			s result=result_Body_","_Pos_","
			if (results="")
			{
				s results=result
			}
			else
			{
				s results=results_";"_result
			}
		}
	}
	q results
}

/// Creator: 杨继鸿
/// CreatDate: 2022-04-14
/// Description: 删除检查报告
/// Input: reportid 检查报告ID；taskid WDT.CDSS.TriggTasksDetail的ID
/// Output: result json字符串
/// Return: 成功 "{success:'true'}"；失败 "{success:'false',errorinfo:'...'}"
/// Others: w ##class(web.CDSS.Demo.EvalWordTrigg).DeleteRISReport("17","1")
ClassMethod DeleteRISReport(reportid, taskid)
{
	s result=""
	s flag=0
	TS
	//先删除检查报告的NLP结果
	s delRISNLP=##class(web.CDSS.Demo.TriggNLPIdentify).BatchDeleteData(taskid,"检查报告",reportid)
	if delRISNLP["true"
	{
		s GroupFlag=$lg($g(^WDT.CDSS.DEMORISReportD(reportid)),12)	//医嘱id
		s delRISReport=##class(web.CDSS.Demo.RISReport).DeleteData(reportid)
		If (delRISReport["true")
		{
			// 更新任务编辑状态
			d ##class(web.CDSS.Demo.TriggTasksDetail).UpdateState(taskid)
			// 重置检查信息表数据
		    s ExamInfoID=0
		    s num=0
		    for
		    {
			    s ExamInfoID =$o(^WDT.CDSS.ExamInfoI("GroupFlagIndex"," "_GroupFlag,ExamInfoID))
			    q:ExamInfoID=""
			    s num=num+1
			    d:num'=1 ##class(WDT.CDSS.ExamInfo).%DeleteId(ExamInfoID)
			}
			s ExamInfoID =$o(^WDT.CDSS.ExamInfoI("GroupFlagIndex"," "_GroupFlag,""),-1)
			If (ExamInfoID'="")
			{
				s examInfoObj=##class(WDT.CDSS.ExamInfo).%OpenId(ExamInfoID)
				s examInfoObj.ExamResult=""
				s examInfoObj.ExamResultDesc=""
				s sc=examInfoObj.%Save()
				If '$$$ISOK(sc)
				{
					s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
					s flag=1
				}
			}		
		}
		Else
		{
			s result=delRISReport, flag=1
		}
	}
	else
	{
		s result=delRISNLP, flag=1
	}
	
	if flag=1
	{
		TRO
	}
	else
	{
		TC
		s result="{success:'true'}"
	}
	q result
}

}
