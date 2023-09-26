/// Description：住院Demo-入院记录
/// Table：WDT.CDSS.DEMOAdmRec
Class web.CDSS.Demo.AdmRec Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2021-02-03
/// Description:保存患者基础信息及入院记录
/// Table: WDT.CDSS.DEMOPatMaster、WDT.CDSS.DEMOAdmRec
/// Input: eobj 入院记录实体对象
/// others:w ##class(web.CDSS.Demo.AdmRec).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Demo.AdmRec)
{
	s $zt="ERROR"
	Ts
	s result=""
	if $IsObject(eobj)
	{
		q:eobj.PatDR="" "{success:'false',errorinfo:'请选择患者'}"
		
		s obj=##class(WDT.CDSS.DEMOPatMaster).%OpenId(eobj.PatDR)	
		s bobj = ##class(web.CDSSEntity.Demo.PatMaster).%New()
		s bobj.Name = obj.Name
		s bobj.Sex = obj.Sex
		s bobj.BirthPlace = obj.BirthPlace
		s bobj.Marriage = obj.Marriage
		s bobj.Address = obj.Address
		s bobj.WorkUnitName = obj.WorkUnitName
		s bobj.AdmisTime = obj.AdmisTime
		s bobj.Representor = obj.Representor
		s bobj.RecordTime = obj.RecordTime
		
		s obj.Name = eobj.Name
		s obj.Sex = eobj.Sex
		s obj.BirthPlace = eobj.BirthPlace
		s obj.Marriage = eobj.Marriage
		s obj.Address = eobj.Address
		s obj.WorkUnitName = eobj.WorkUnitName
		s obj.AdmisTime = eobj.AdmisTime
		s obj.Representor = eobj.Representor
		s obj.RecordTime = eobj.PatRecordTime
	
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s id = obj.%Id()
			
			 //保存日志
		    d:eobj.PatDR="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOPatMaster","WDT.CDSS.DEMOPatMaster","住院Demo-患者基础信息",id,eobj.Name,"A",eobj)
		 	d:eobj.PatDR'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOPatMaster","WDT.CDSS.DEMOPatMaster","住院Demo-患者基础信息",eobj.RowId,eobj.Name,"U",eobj,bobj)    
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-入院记录","web.CDSS.Demo.AdmRec","SaveData",eobj)
       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
		
		//入院记录表保存
		s RowId=$o(^WDT.CDSS.DEMOAdmRecI("PatIndex",eobj.PatDR,"")) //入院记录Id
		if (RowId="")  //如果RowId未赋值则增加
		{
			s objRec=##class(WDT.CDSS.DEMOAdmRec).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s objRec=##class(WDT.CDSS.DEMOAdmRec).%OpenId(RowId)
			
			s bobjRec = ##class(web.CDSSEntity.Demo.AdmRec).%New()
			s bobjRec.PatDR = objRec.PatDR.%Id()
			s bobjRec.ChiefCompSum = objRec.ChiefCompSum
			s bobjRec.CurrentMedHisSum = objRec.CurrentMedHisSum
			s bobjRec.PastDiagnosisSum = objRec.PastDiagnosisSum
			s bobjRec.AllergyHisSum = objRec.AllergyHisSum
			s bobjRec.PersonalHisSum = objRec.PersonalHisSum
			s bobjRec.MarryHisSum = objRec.MarryHisSum
			s bobjRec.MenstrualHisSum = objRec.MenstrualHisSum
			s bobjRec.FamilyHisSum = objRec.FamilyHisSum
			s bobjRec.PhysicalExamSum = objRec.PhysicalExamSum
			s bobjRec.SpecExamSum = objRec.SpecExamSum
			s bobjRec.AssisExam = objRec.AssisExam
			s bobjRec.CurrentTreatMedication = objRec.CurrentTreatMedication
			s bobjRec.PreliminaryDiag = objRec.PreliminaryDiag
			s bobjRec.ConfirmDiag = objRec.ConfirmDiag
			s bobjRec.ComplementaryDiag = objRec.ComplementaryDiag
			s bobjRec.DiagnosisCorrecting = objRec.DiagnosisCorrecting
			s bobjRec.DoctorSign = objRec.DoctorSign
			s bobjRec.RecordTime = objRec.RecordTime
			
		}
		d objRec.PatDRSetObjectId(eobj.PatDR)
		s objRec.ChiefCompSum = eobj.ChiefCompSum
		s objRec.CurrentMedHisSum = eobj.CurrentMedHisSum
		s objRec.PastDiagnosisSum = eobj.PastDiagnosisSum
		s objRec.AllergyHisSum = eobj.AllergyHisSum
		s objRec.PersonalHisSum = eobj.PersonalHisSum
		s objRec.MarryHisSum = eobj.MarryHisSum
		s objRec.MenstrualHisSum = eobj.MenstrualHisSum
		s objRec.FamilyHisSum = eobj.FamilyHisSum
		s objRec.PhysicalExamSum = eobj.PhysicalExamSum
		s objRec.SpecExamSum = eobj.SpecExamSum
		s objRec.AssisExam = eobj.AssisExam
		s objRec.CurrentTreatMedication = eobj.CurrentTreatMedication
		s objRec.PreliminaryDiag = eobj.PreliminaryDiag
		s objRec.ConfirmDiag = eobj.ConfirmDiag
		s objRec.ComplementaryDiag = eobj.ComplementaryDiag
		s objRec.DiagnosisCorrecting = eobj.DiagnosisCorrecting
		s objRec.DoctorSign = eobj.DoctorSign
		s objRec.RecordTime = eobj.RecordTime
		
		s scRec=objRec.%Save()
		d objRec.%Close()
		If $$$ISOK(scRec)
		{
			Tc
			s id = objRec.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			
			 //保存日志
		    d:RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOAdmRec","WDT.CDSS.DEMOAdmRec","住院Demo-入院记录",id,eobj.ChiefCompSum,"A",eobj)
		 	d:RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOAdmRec","WDT.CDSS.DEMOAdmRec","住院Demo-入院记录",eobj.RowId,eobj.ChiefCompSum,"U",eobj,bobjRec)    
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scRec)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-入院记录","web.CDSS.Demo.AdmRec","SaveData",eobj)
       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scRec)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-入院记录","web.CDSS.Demo.AdmRec","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze 
 q result
}

/// Creator:高姗姗
/// CreatDate:2021-02-03
/// Description:校验患者基础信息及入院记录
/// Table: WDT.CDSS.DEMOPatMaster、WDT.CDSS.DEMOAdmRec
/// Input: eobj 入院记录实体对象
/// others:w ##class(web.CDSS.Demo.AdmRec).ValidateData(eobj)
ClassMethod ValidateData(eobj As web.CDSSEntity.Demo.AdmRec)
{
	q:eobj.PatDR="" "{success:'true'}"
	s result=""
	if $IsObject(eobj)
	{
		s RowId=$o(^WDT.CDSS.DEMOAdmRecI("PatIndex",eobj.PatDR,"")) //入院记录Id
		if (RowId="")  //如果RowId未赋值则校验是否为空
		{
			if ((eobj.ChiefCompSum="")&&(eobj.CurrentMedHisSum="")&&(eobj.PastDiagnosisSum="")&&(eobj.AllergyHisSum="")&&(eobj.PersonalHisSum="")&&(eobj.MarryHisSum="")&&(eobj.MenstrualHisSum="")&&(eobj.FamilyHisSum="")&&(eobj.PhysicalExamSum="")&&(eobj.SpecExamSum="")&&(eobj.AssisExam="")&&(eobj.CurrentTreatMedication="")&&(eobj.PreliminaryDiag="")&&(eobj.ConfirmDiag="")&&(eobj.ComplementaryDiag="")&&(eobj.DiagnosisCorrecting="")&&(eobj.DoctorSign="")&&(eobj.RecordTime="")){
				s result = "{success:'true'}"
			}else{
				s result = "{success:'false'}"
			}
		}
		else  //如果RowId已赋值则校验是否一致
		{
			s obj=##class(WDT.CDSS.DEMOPatMaster).%OpenId(eobj.PatDR)	
			s objRec=##class(WDT.CDSS.DEMOAdmRec).%OpenId(RowId)
			
			s bobjRec = ##class(web.CDSSEntity.Demo.AdmRec).%New()
			s bobjRec.RowId = eobj.RowId
			s bobjRec.Name = obj.Name
			s bobjRec.Sex = obj.Sex
			s bobjRec.BirthPlace = obj.BirthPlace
			s bobjRec.Marriage = obj.Marriage
			s bobjRec.Address = obj.Address
			s bobjRec.WorkUnitName = obj.WorkUnitName
			s bobjRec.AdmisTime = obj.AdmisTime
			s bobjRec.Representor = obj.Representor
			s bobjRec.RecordTime = obj.RecordTime
			s bobjRec.PatDR = objRec.PatDR.%Id()
			s bobjRec.ChiefCompSum = objRec.ChiefCompSum
			s bobjRec.CurrentMedHisSum = objRec.CurrentMedHisSum
			s bobjRec.PastDiagnosisSum = objRec.PastDiagnosisSum
			s bobjRec.AllergyHisSum = objRec.AllergyHisSum
			s bobjRec.PersonalHisSum = objRec.PersonalHisSum
			s bobjRec.MarryHisSum = objRec.MarryHisSum
			s bobjRec.MenstrualHisSum = objRec.MenstrualHisSum
			s bobjRec.FamilyHisSum = objRec.FamilyHisSum
			s bobjRec.PhysicalExamSum = objRec.PhysicalExamSum
			s bobjRec.SpecExamSum = objRec.SpecExamSum
			s bobjRec.AssisExam = objRec.AssisExam
			s bobjRec.CurrentTreatMedication = objRec.CurrentTreatMedication
			s bobjRec.PreliminaryDiag = objRec.PreliminaryDiag
			s bobjRec.ConfirmDiag = objRec.ConfirmDiag
			s bobjRec.ComplementaryDiag = objRec.ComplementaryDiag
			s bobjRec.DiagnosisCorrecting = objRec.DiagnosisCorrecting
			s bobjRec.DoctorSign = objRec.DoctorSign
			s bobjRec.RecordTime = objRec.RecordTime
			if (eobj.JsonS()=bobjRec.JsonS()){
				s result = "{success:'true'}"
			}else{
				s result = "{success:'false'}"
			}
		}
	}
	else
	{
		s result = "{success:'false'}"
	}
 	q result
}

/// Creator：高姗姗
/// CreatDate: 2021-02-02
/// Description：数据打开方法
/// Table：WDT.CDSS.DEMOAdmRec
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.AdmRec).OpenData()
ClassMethod OpenData() As %String
{
	s str=""
	s eobj = ##class(web.CDSSEntity.Demo.AdmRec).%New()
	s PatDR=##class(web.CDSS.Demo.PatMaster).GetPatId() //患者Id
	if (PatDR'=""){
		s pobj = ##class(WDT.CDSS.DEMOPatMaster).%OpenId(PatDR)
		s eobj.Name = pobj.Name
		s eobj.Sex = pobj.Sex
		s eobj.BirthPlace = pobj.BirthPlace
		s eobj.Marriage = pobj.Marriage
		s eobj.Address = pobj.Address
		s eobj.WorkUnitName = pobj.WorkUnitName
		s eobj.AdmisTime = pobj.AdmisTime
		s eobj.Representor = pobj.Representor
		s eobj.PatRecordTime = pobj.RecordTime
		d pobj.%Close()	
		k pobj	
	}
	s eobj.PatDR=PatDR
	s RowId=$o(^WDT.CDSS.DEMOAdmRecI("PatIndex",PatDR,"")) //入院记录Id
	if (RowId'=""){
		s robj = ##class(WDT.CDSS.DEMOAdmRec).%OpenId(RowId)
		s eobj.ChiefCompSum = robj.ChiefCompSum
		s eobj.CurrentMedHisSum = robj.CurrentMedHisSum
		s eobj.PastDiagnosisSum = robj.PastDiagnosisSum
		s eobj.AllergyHisSum = robj.AllergyHisSum
		s eobj.PersonalHisSum = robj.PersonalHisSum
		s eobj.MarryHisSum = robj.MarryHisSum
		s eobj.MenstrualHisSum = robj.MenstrualHisSum
		s eobj.FamilyHisSum = robj.FamilyHisSum
		s eobj.PhysicalExamSum = robj.PhysicalExamSum
		s eobj.SpecExamSum = robj.SpecExamSum
		s eobj.AssisExam = robj.AssisExam
		s eobj.CurrentTreatMedication = robj.CurrentTreatMedication
		s eobj.PreliminaryDiag = robj.PreliminaryDiag
		s eobj.ConfirmDiag = robj.ConfirmDiag
		s eobj.ComplementaryDiag = robj.ComplementaryDiag
		s eobj.DiagnosisCorrecting = robj.DiagnosisCorrecting
		s eobj.DoctorSign = robj.DoctorSign
		s eobj.RecordTime = robj.RecordTime
		d robj.%Close()	
		k robj	
	}

	s str = eobj.JsonS()	
	q str
}

/// Creator：高姗姗
/// CreatDate: 2021-04-30
/// Description：获取入院记录及患者信息JSON，对接CDSS2.0
/// Table：WDT.CDSS.DEMOAdmRec
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.AdmRec).GetJSONData("1")
ClassMethod GetJSONData(RowId) As %String
{
	s ResJSON={}
	s robj = ##class(WDT.CDSS.DEMOAdmRec).%OpenId(RowId)
	s PatDR=robj.PatDR.%Id()
	s pobj = ##class(WDT.CDSS.DEMOPatMaster).%OpenId(PatDR)
	s IDNO =pobj.IDNO //患者主索引
	s PatientDR =pobj.PatientDR //病人标识
	s VisitID =pobj.AdmissionCount //就诊次
	s VisitType ="3" //就诊类型 1急诊，2门诊，3住院
	s Name =pobj.Name //患者姓名
	s UserID ="" //医生ID 
	s UserName =robj.DoctorSign //医生姓名
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
	s ProgressId=RowId //病历唯一标识
	s ProgressType="1" //病历类型 入院记录1
	s ProgressTempleateID="" //模板唯一标示
	s ProgressTemplateName="" //模板名称
	s MsgType="2" //病历内容传递格式 2 传递键值对内容
	//病历内容
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
		s MessageJson={}
		d MessageJson.%Set("key",key)
		d MessageJson.%Set("value",MessageArr(key))
		d MessageList.%Push(MessageJson)	
	}
	d ProgressNoteList.%Set("MessageList",MessageList)
	
	s DoctorId="" //开立医生ID
	s DoctorName=robj.DoctorSign //医生姓名
	s CreateDeptCode="" //开立科室代码
	s CreatDeptName=pobj.Department //开立科室名称
	s RecordTime=robj.RecordTime //病历记录时间
	d ProgressNoteList.%Set("DoctorId",DoctorId)
	d ProgressNoteList.%Set("DoctorName",DoctorName)
	d ProgressNoteList.%Set("CreateDeptCode",CreateDeptCode)
	d ProgressNoteList.%Set("CreatDeptName",CreatDeptName)
	d ProgressNoteList.%Set("RecordTime",RecordTime)
	d ResJSON.%Set("ProgressNoteList",ProgressNoteList)
	q ResJSON.%ToJSON()
}

}
