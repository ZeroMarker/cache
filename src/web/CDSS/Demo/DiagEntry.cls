/// Description: 住院Demo-诊断系统维护
/// Creator: 高姗姗
/// Date: 2021-10-29
Class web.CDSS.Demo.DiagEntry Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2021-10-29
/// Description:获得诊断录入内容
/// Table: WDT.CDSS.DEMODiagEntry
/// Input: PatDR 患者基础信息表RowID
/// Return:返回所有诊断录入表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DiagEntry","GetList",182,"")
Query GetList(Id As %String, PatDR As %String, desc As %String) As %Query(ROWSPEC = "RowId,Diag,DiagCode,DiagDesc,ICD,ICDCode,MainDiagFlag,DiagType,DiagState,OnsetDate,DiagDate,DiagRemark,Recorder,DiagnosisClass")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, Id As %String, PatDR As %String, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if (PatDR="") q ""
 	s:desc'="" desc=$ZCONVERT(desc,"U")  //转换成大写
 	s:desc'="" desc=$tr(desc," ","")     //过滤空格
 	if (Id'=""){
	 	s RowId=Id
	 	s DiagCode = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),3)
		s Diag = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),4)
		s DiagDesc = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),4)
		s ICD = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),5)
		s ICDCode = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),5)
		s MainDiagFlag = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),6)
		s DiagType = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),7)
		s DiagState = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),8)
		s OnsetDate = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),9)
		s DiagDate = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),10)
		s DiagRemark = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),11)
		s Recorder = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),12)
		s DiagnosisClass = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),14)
		d OutputRow
	}else{
		s RowId = 0
		for
		{
			s RowId = $o(^WDT.CDSS.DEMODiagEntryI("PatIndex",PatDR,RowId)) q:RowId=""
			s DiagCode = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),3)
			s Diag = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),4)
			s DiagDesc = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),4)
			s PINYIN=""
			s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DiagDesc) 
			s ICD = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),5)
			s ICDCode = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),5)
			s MainDiagFlag = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),6)
			s DiagType = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),7)
			s DiagState = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),8)
			s OnsetDate = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),9)
			s DiagDate = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),10)
			s DiagRemark = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),11)
			s Recorder = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),12)
			s DiagnosisClass = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),14)
			if ($ZCONVERT(DiagDesc,"U")[desc)||(PINYIN[desc)||(desc="")
			{
				d OutputRow
			}
		}
	}
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,Diag,DiagCode,DiagDesc,ICD,ICDCode,MainDiagFlag,DiagType,DiagState,OnsetDate,DiagDate,DiagRemark,Recorder,DiagnosisClass)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:高姗姗
/// CreatDate:2021-10-29
/// Description:保存诊断录入表
/// Table: WDT.CDSS.DEMODiagEntry
/// Input: eobj 诊断录入表实体对象
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// others:w ##class(web.CDSS.Demo.DiagEntry).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Demo.DiagEntry)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(WDT.CDSS.DEMODiagEntry).%New()	
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(WDT.CDSS.DEMODiagEntry).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.Demo.DiagEntry).%New()
			if $IsObject(obj.PatDR)
			{
			 	s bobj.PatDR = obj.PatDR.%Id()
			}
			s bobj.DiagCode = obj.DiagCode
			s bobj.DiagDesc = obj.DiagDesc
			s bobj.ICDCode = obj.ICDCode
			s bobj.MainDiagFlag = obj.MainDiagFlag
			s bobj.DiagType = obj.DiagType
			s bobj.DiagState = obj.DiagState
			s bobj.OnsetDate = obj.OnsetDate
			s bobj.DiagDate = obj.DiagDate
			s bobj.DiagRemark = obj.DiagRemark
			s bobj.Recorder = obj.Recorder
			s bobj.OriginalContent = obj.OriginalContent
			s bobj.DiagnosisClass = obj.DiagnosisClass
			
		}
		d:eobj.PatDR'="" obj.PatDRSetObjectId(eobj.PatDR)
		s obj.DiagCode = eobj.DiagCode
		s obj.DiagDesc = eobj.DiagDesc
		s obj.ICDCode = eobj.ICDCode
		s obj.MainDiagFlag = eobj.MainDiagFlag
		s obj.DiagType = eobj.DiagType
		s obj.DiagState = eobj.DiagState
		s obj.OnsetDate = eobj.OnsetDate
		s obj.DiagDate = eobj.DiagDate
		s obj.DiagRemark = eobj.DiagRemark
		s obj.Recorder = eobj.Recorder
		s obj.OriginalContent = eobj.OriginalContent
		s obj.DiagnosisClass = eobj.DiagnosisClass
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			
			//保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMODiagEntry","WDT.CDSS.DEMODiagEntry","诊断录入",id,eobj.DiagDesc,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMODiagEntry","WDT.CDSS.DEMODiagEntry","诊断录入",eobj.RowId,eobj.DiagDesc,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊断录入","web.CDSS.Demo.DiagEntry","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
			
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊断录入","web.CDSS.Demo.DiagEntry","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator: 高姗姗
/// CreatDate:2021-10-29
/// Description:删除诊断录入表
/// Table: WDT.CDSS.DEMODiagEntry
/// Input: id 诊断录入的id
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.Demo.DiagEntry).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Ts
	s obj=##class(WDT.CDSS.DEMODiagEntry).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.Demo.DiagEntry).%New()
	if $IsObject(obj.PatDR)
	{
	 	s bobj.PatDR = obj.PatDR.%Id()
	}
	s bobj.DiagCode = obj.DiagCode
	s bobj.DiagDesc = obj.DiagDesc
	s bobj.ICDCode = obj.ICDCode
	s bobj.MainDiagFlag = obj.MainDiagFlag
	s bobj.DiagType = obj.DiagType
	s bobj.DiagState = obj.DiagState
	s bobj.OnsetDate = obj.OnsetDate
	s bobj.DiagDate = obj.DiagDate
	s bobj.DiagRemark = obj.DiagRemark
	s bobj.Recorder = obj.Recorder
	s bobj.OriginalContent = obj.OriginalContent
	s bobj.DiagnosisClass = obj.DiagnosisClass
			
	s sc=##class(WDT.CDSS.DEMODiagEntry).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMODiagEntry","WDT.CDSS.DEMODiagEntry","诊断录入",id,bobj.DiagDesc,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("诊断录入","web.CDSS.Demo.DiagEntry","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator: 高姗姗
/// CreatDate:2021-2-23
/// Description:批量删除诊断录入表
/// Table: WDT.CDSS.DEMODiagEntry
/// Input: idstr 诊断录入的id串
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.Demo.DiagEntry).DeleteData("")
ClassMethod BatchDeleteData(idstr As %String)
{
	s result=""
	// 需要删除的id串
	if (idstr'="")
	{
		Ts
		s idlen=$Length(idstr,"^")
		//保存
		for j=1:1:idlen
		{
		    
		    s DiagEntryid=$p(idstr,"^",j)
			s resultstr=..DeleteData(DiagEntryid)
			s:result'="" result=result_","_resultstr
			s:result="" result=resultstr
		}
		
	}
	if (result["false")
	{
		tro
		s result="{success:'false',info:'删除失败！'}"
	}
	else
	{
		tc
		s result= "{success:'true',info:'删除成功！'}"
	}
	
	q result
}

/// Creator:高姗姗
/// CreatDate:2021-10-29
/// Description:通过id获取诊断录入内容
/// Table: WDT.CDSS.DEMODiagEntry
/// Input: id 诊断录入id
/// Return: 诊断录入内容
/// others:w ##class(web.CDSS.Demo.DiagEntry).OpenData("1")
ClassMethod OpenData(id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.Demo.DiagEntry).%New()
	s eobj.RowId= id
	s obj=##class(WDT.CDSS.DEMODiagEntry).%OpenId(id)
	if $IsObject(obj.PatDR)
	{
	 	s eobj.PatDR = obj.PatDR.%Id()
	}
	s eobj.DiagCode = obj.DiagCode
	s eobj.DiagDesc = obj.DiagDesc
	s eobj.ICDCode = obj.ICDCode
	s eobj.MainDiagFlag = obj.MainDiagFlag
	s eobj.DiagType = obj.DiagType
	s eobj.DiagState = obj.DiagState
	s eobj.OnsetDate = obj.OnsetDate
	s eobj.DiagDate = obj.DiagDate
	s eobj.DiagRemark = obj.DiagRemark
	s eobj.Recorder = obj.Recorder
	s eobj.OriginalContent = obj.OriginalContent
	s eobj.DiagnosisClass = obj.DiagnosisClass
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator：高姗姗
/// CreatDate: 2021-11-05
/// Description：获取诊断及患者信息JSON，对接CDSS2.0
/// Table：WDT.CDSS.DEMODiagEntry
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.DiagEntry).GetJSONData("998","")
ClassMethod GetJSONData(PatDR, RowId = "") As %String
{
	;诊断增删改时调病历保存接口，(1)获取入院记录中的诊断信息NLP结构化(2)文虎调..GetDiagList(IDNO)获取诊断录入中诊断
	s ResJSON={}
	
	s pobj = ##class(WDT.CDSS.DEMOPatMaster).%OpenId(PatDR)
	s AdmRowId=$o(^WDT.CDSS.DEMOAdmRecI("PatIndex",PatDR,""))
   	s robj = ##class(WDT.CDSS.DEMOAdmRec).%OpenId(AdmRowId)
   	
	s IDNO =pobj.IDNO //患者主索引
	s PatientDR =pobj.PatientDR //病人标识
	s VisitID =pobj.AdmissionCount //就诊次
	s VisitType ="3" //就诊类型 1急诊，2门诊，3住院
	s Name =pobj.Name //患者姓名
	s UserID ="" //医生ID 
	s:AdmRowId'="" UserName =robj.DoctorSign //医生姓名
	s:AdmRowId="" UserName=""
	s DeptCode ="" //科室编码
	s DeptName =pobj.Department //科室名称
	s HospCode ="" //医院编码
	s HospName =pobj.Hospital //医院名称
	d ResJSON.%Set("IDNO",IDNO)
	d ResJSON.%Set("PatientDR",PatientDR)
	d ResJSON.%Set("VisitID",VisitID)
	d ResJSON.%Set("VisitType",VisitType)
	d ResJSON.%Set("Name",Name)
	d ResJSON.%Set("UserID",$g(%session.Data("LOGON.USERID")))
	d ResJSON.%Set("UserName",$g(%session.Data("LOGON.USERNAME")))
	d ResJSON.%Set("DeptCode",$g(%session.Data("LOGON.CTLOCID")))
	d ResJSON.%Set("DeptName",$g(%session.Data("LOGON.CTLOCDESC")))
	d ResJSON.%Set("HospCode",HospCode)
	d ResJSON.%Set("HospName",HospName)
	
	s PatientInfo={}
	s Sex=pobj.Sex //性别
	s Gender="2"
	s:Sex="女" Gender="0"
	s:Sex="男" Gender="1"
	s BirthDate=pobj.Birthday //出生日期
	s PregnancyStatus="" //妊娠状态
	d PatientInfo.%Set("Gender",Gender)
	d PatientInfo.%Set("BirthDate",BirthDate)
	d PatientInfo.%Set("PregnancyStatus",PregnancyStatus)
	d ResJSON.%Set("PatientInfo",PatientInfo)

	s ProgressNoteList={}
	s ProgressId=AdmRowId //病历唯一标识
	s ProgressType="1" //病历类型 入院记录1
	s ProgressTempleateID="" //模板唯一标示
	s ProgressTemplateName="" //模板名称
	s MsgType="2" //病历内容传递格式 2 传递键值对内容
	//s Message="" //病历内容
	s Message="姓名:"_pobj.Name_",科室:"_pobj.Department_",性别:"_pobj.Sex_",年龄:"_pobj.Age_",床号:"_pobj.BedNumber_",住院号:"_pobj.AdmissionCount_",出生地:"_pobj.BirthPlace_",联系地址:"_pobj.Address_",婚姻:"_pobj.Marriage
			_",工作单位:"_pobj.WorkUnitName_",陈述人:"_pobj.Representor_",入院日期:"_pobj.AdmisTime_",记录日期:"_pobj.RecordTime_",主诉:"_robj.ChiefCompSum_",现病史:"_robj.CurrentMedHisSum_",既往史:"_robj.PastDiagnosisSum
			_",过敏史:"_robj.AllergyHisSum_",个人史:"_robj.PersonalHisSum_",婚育史:"_robj.MarryHisSum_",月经史:"_robj.MenstrualHisSum_",家族史:"_robj.FamilyHisSum_",体格检查:"_robj.PhysicalExamSum_",专科情况:"_robj.SpecExamSum
			_",辅助检查:"_robj.AssisExam_",初步诊断:"_robj.PreliminaryDiag_",确诊诊断:"_robj.ConfirmDiag_",补充诊断:"_robj.ComplementaryDiag_",修正诊断:"_robj.DiagnosisCorrecting_",医师签名:"_robj.DoctorSign_",记录日期"_robj.RecordTime 
	d ProgressNoteList.%Set("ProgressId",ProgressId)
	d ProgressNoteList.%Set("ProgressType",ProgressType)
	d ProgressNoteList.%Set("ProgressTempleateID",ProgressTempleateID)
	d ProgressNoteList.%Set("ProgressTemplateName",ProgressTemplateName)
	d ProgressNoteList.%Set("MsgType",MsgType)
	d ProgressNoteList.%Set("Message",Message)
	
	s MessageList=[]
	if (AdmRowId'=""){
		s MessageArr("主诉")=robj.ChiefCompSum
		s MessageArr("现病史")=robj.CurrentMedHisSum
		s MessageArr("既往史")=robj.PastDiagnosisSum
		s MessageArr("过敏史")=robj.AllergyHisSum
		s MessageArr("个人史")=robj.PersonalHisSum
		s MessageArr("婚育史")=robj.MarryHisSum
		s MessageArr("月经史")=robj.MenstrualHisSum
		s MessageArr("家族史")=robj.FamilyHisSum
		s MessageArr("体格检查")=robj.PhysicalExamSum
		s MessageArr("专科情况")=robj.SpecExamSum
		s MessageArr("辅助检查")=robj.AssisExam
		s MessageArr("初步诊断")=robj.PreliminaryDiag
		s MessageArr("确诊诊断")=robj.ConfirmDiag
		s MessageArr("补充诊断")=robj.ComplementaryDiag
		s MessageArr("修正诊断")=robj.DiagnosisCorrecting
		s key=""
		for {
			s key=$o(MessageArr(key)) q:key=""
			if ((key'="初步诊断")&(key'="确诊诊断")&(key'="补充诊断")&(key'="修正诊断")){
				continue:(MessageArr(key)="")
			}
			s MessageJson={}
			d MessageJson.%Set("key",key)
			d MessageJson.%Set("value",MessageArr(key))
			d MessageList.%Push(MessageJson)	
		}
	}
	d ProgressNoteList.%Set("MessageList",MessageList)
	
	s DoctorId="" //开立医生ID
	s:AdmRowId'="" DoctorName=robj.DoctorSign //医生姓名
	s:AdmRowId="" DoctorName=""
	s CreateDeptCode="" //开立科室代码
	s CreatDeptName=pobj.Department //开立科室名称
	s:AdmRowId'="" RecordTime=robj.RecordTime //病历记录时间
	s:AdmRowId="" RecordTime=""
	d ProgressNoteList.%Set("DoctorId",DoctorId)
	d ProgressNoteList.%Set("DoctorName",DoctorName)
	d ProgressNoteList.%Set("CreateDeptCode",CreateDeptCode)
	d ProgressNoteList.%Set("CreatDeptName",CreatDeptName)
	d ProgressNoteList.%Set("RecordTime",RecordTime)
	d ResJSON.%Set("ProgressNoteList",ProgressNoteList)
	q ResJSON.%ToJSON()
}

/// Creator：高姗姗
/// CreatDate: 2021-11-09
/// Description：提供接口-获取诊断
/// Table：WDT.CDSS.DEMODiagEntry
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.DiagEntry).GetDiagList("DM000003")
ClassMethod GetDiagList(PatDR) As %String
{
	s ResJSON={}
	s pobj = ##class(WDT.CDSS.DEMOPatMaster).%OpenId(PatDR)
	s AdmRowId=$o(^WDT.CDSS.DEMOAdmRecI("PatIndex",PatDR,""))
   	s robj = ##class(WDT.CDSS.DEMOAdmRec).%OpenId(AdmRowId)
   	
	s IDNO =pobj.IDNO //患者主索引
	s PatientDR =pobj.PatientDR //病人标识
	s VisitID =pobj.AdmissionCount //就诊次
	s VisitType ="3" //就诊类型 1急诊，2门诊，3住院
	s Name =pobj.Name //患者姓名
	s UserID ="" //医生ID 
	s:AdmRowId'="" UserName =robj.DoctorSign //医生姓名
	s:AdmRowId="" UserName=""
	s DeptCode ="" //科室编码
	s DeptName =pobj.Department //科室名称
	s HospCode ="" //医院编码
	s HospName =pobj.Hospital //医院名称
	d ResJSON.%Set("IDNO",IDNO)
	d ResJSON.%Set("PatientDR",PatientDR)
	d ResJSON.%Set("VisitID",VisitID)
	d ResJSON.%Set("VisitType",VisitType)
	d ResJSON.%Set("Name",Name)
	d ResJSON.%Set("UserID",$g(%session.Data("LOGON.USERID")))
	d ResJSON.%Set("UserName",$g(%session.Data("LOGON.USERNAME")))
	d ResJSON.%Set("DeptCode",$g(%session.Data("LOGON.CTLOCID")))
	d ResJSON.%Set("DeptName",$g(%session.Data("LOGON.CTLOCDESC")))
	d ResJSON.%Set("HospCode",HospCode)
	d ResJSON.%Set("HospName",HospName)
	
	s PatientInfo={}
	s Sex=pobj.Sex //性别
	s Gender="2"
	s:Sex="女" Gender="0"
	s:Sex="男" Gender="1"
	s BirthDate=pobj.Birthday //出生日期
	s PregnancyStatus="" //妊娠状态
	d PatientInfo.%Set("Gender",Gender)
	d PatientInfo.%Set("BirthDate",BirthDate)
	d PatientInfo.%Set("PregnancyStatus",PregnancyStatus)
	d ResJSON.%Set("PatientInfo",PatientInfo)

	
	s DiagList=[]
	s PatDRs=$o(^WDT.CDSS.DEMOPatMasterI("IDNOIndex",IDNO,""))
	if (PatDRs'=""){
		s RowId = 0
		for
		{
			s RowId = $o(^WDT.CDSS.DEMODiagEntryI("PatIndex",PatDRs,RowId)) q:RowId=""
			s DiagCode = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),3)
			s Diag = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),4)
			s DiagDesc = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),4)
			s ICD = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),5)
			s ICDCode = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),5)	
			s DiagType = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),7)
			s DiagDate = $lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),10)
			s DiagClass=$lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),14) //诊断分类
			s MainDiagFlag=$lg($g(^WDT.CDSS.DEMODiagEntryD(RowId)),6)
			if (MainDiagFlag="是"){
				s MainDiagFlag=0
			}elseif(MainDiagFlag="否"){
				s MainDiagFlag=1	
			}
			s Diag={}
			d Diag.%Set("DiagnosisId",RowId)
			d Diag.%Set("DiagnosisType",DiagType)
			d Diag.%Set("DiagnosisSequence","")
			d Diag.%Set("DiagnosisCode",ICDCode)
			d Diag.%Set("DiagnosisName",DiagDesc)
			d Diag.%Set("DiagnosisClass",DiagClass)
			d Diag.%Set("DiagnosisTime",DiagDate)
			d Diag.%Set("DiagFlag","1")
			//d Diag.%Set("ChildDiagnosisFlag","1")
			d Diag.%Set("ChildDiagnosisFlag",MainDiagFlag)
			d DiagList.%Push(Diag)
		}
	}
	d ResJSON.%Set("DiagnosisList",DiagList)
	q ResJSON.%ToJSON()
}

/// Creator:zww
/// CreatDate:2022-07-20
/// Description:获得不同诊断分类下的诊断下拉框内容
/// Table: CT.WDT.CDSS.TCMDisease、CT.WDT.CDSS.TCMSymptom、CT.WDT.CDSS.DiseaseDict
/// Input:
/// Return:返回对应诊断分类的诊断下拉框内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DiagEntry","GetDataForCmb1","","","","证型")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String, class As %String) As %Query(ROWSPEC = "DiseaseID:%String,DiseaseCode:%String,DiseaseName:%String,DiseaseDR:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String, class As %String) As %Status
{
	
 	s repid=$I(^CacheTemp)
 	s ind=1
 	if (class="中医"){
	 	if (rowid'="") //根据rowid返回该条记录
		{
			s DiseaseID=rowid
			s DiseaseCode= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(DiseaseID)),2)       //中医疾病编码
			s DiseaseName= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(DiseaseID)),3)       //中医疾病名称
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
				s ID=$o(^CT.WDT.CDSS.TCMDiseaseD(ID))
				q:ID=""
				s DiseaseDesc=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(ID)),3)		
				s length=$l(DiseaseDesc)
				s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
			}
			s le=0
			s num=0
			for
			{
				s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
				q:le=""
				s DiseaseID=0
				for
				{
					s DiseaseID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,DiseaseID))
					q:DiseaseID=""
		  			s DiseaseCode= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(DiseaseID)),2)       //中医疾病编码
				    s DiseaseName= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(DiseaseID)),3)       //中医疾病名称
		  			s State= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(DiseaseID)),7) 
					s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DiseaseName)  
		  			if (($ZCONVERT(DiseaseName,"U")[desc)||(PINYIN[desc))&($ZCONVERT(DiseaseName,"U")[q)||($ZCONVERT(DiseaseName,"U")[q)&(State=2) 
		  			{
		  				d OutputRowCmb
		  			}
					continue:(desc'=""||(q'=""))
					s num=num+1
					q:num=1000
				}
		        q:num=1000
			}
		 }
	} elseif (class="证型"){
		if (rowid'="") //根据rowid返回该条记录
	 	{
	 		s DiseaseID=rowid
			s DiseaseCode=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(DiseaseID)),2)	//中医证候编码
			s DiseaseName=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(DiseaseID)),3)	//中医证候名称
	  		d OutputRowCmb
	 	}
	 	else
	 	{
	  		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	  		s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.TCMSymptomD(ID))
				q:ID=""
				s DiseaseName=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(ID)),3)
				s length=$l(DiseaseName)
				s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
			}
			s le=0
			s num=0
			for
			{
				s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
				s:q'="" desc=$ZCONVERT(q,"U")
				s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
				q:le=""
				s DiseaseID=0
				for
				{
					s DiseaseID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,DiseaseID))
					q:DiseaseID=""
					s TCMSymDR=DiseaseID 
					s DiseaseCode=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(DiseaseID)),2)	//中医证候编码
	  				s DiseaseName=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(DiseaseID)),3)	//中医证候名称
					s State=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(DiseaseID)),8)
					s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DiseaseName) 
					if (($ZCONVERT(DiseaseName,"U")[desc)||(PINYIN[desc)&(State=2)){
						d OutputRowCmb
					}
	  				continue:(desc'="")		
					s num=num+1
					q:num=1000
				}
				q:num=1000
			}
	 	}
	} else{		//西医
		if (rowid'="") //根据rowid返回该条记录
	 	{
	 		s DiseaseID=rowid
		 	s DiseaseCode = $lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseID)),2)	//疾病编码
	  		s DiseaseName = $lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseID)),3)	//疾病名称
	  		
	  		d OutputRowCmb
	 	}
	 	else
	 	{
		 	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		 	
		 	s:q'="" desc=$ZCONVERT(q,"U")
		 	k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	  		s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.DiseaseDictD(ID))
				q:ID=""
				s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(ID)),3)		//名称
				s length=$l(DiseaseName)
				s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
			}
			s le=0
			s num=0
			for
			{
				s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
				q:le=""
				s DiseaseID=0
				for
				{
					s DiseaseID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,DiseaseID))
					q:DiseaseID=""
					
					s DiseaseDR=DiseaseID
					s DiseaseCode=$LISTGET($G(^CT.WDT.CDSS.DiseaseDictD(DiseaseID)),2)	//疾病编码
	  				s DiseaseName=$LISTGET($G(^CT.WDT.CDSS.DiseaseDictD(DiseaseID)),3)	//疾病名称
	  				s DiseaseAliasName = $lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseID)),7)
	  				s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseID)),18)
	  				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DiseaseName) 
	  				if ((($ZCONVERT(DiseaseName,"U")[desc)||(PINYIN[desc))&(UseFlag="2"))
					{
						d OutputRowCmb
					}
					continue:(desc'="")
					s num=num+1
					q:num=10000
					
				}
		        q:num=10000
		        
			}
	 	}
	}
 	
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(DiseaseID,DiseaseCode,DiseaseName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
