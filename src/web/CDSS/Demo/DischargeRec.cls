/// Description：住院Demo-出院记录
/// Table：WDT.CDSS.DEMODischargeRec
Class web.CDSS.Demo.DischargeRec Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2021-02-04
/// Description:保存患者基础信息及出院记录
/// Table: WDT.CDSS.DEMOPatMaster、WDT.CDSS.DEMODischargeRec
/// Input: eobj 出院记录实体对象
/// others:w ##class(web.CDSS.Demo.DischargeRec).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Demo.DischargeRec)
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
		s bobj.Age = obj.Age
		s bobj.AgeUnit = obj.AgeUnit
		s bobj.AdmisTime = obj.AdmisTime
		s bobj.HospDays = obj.HospDays
		s bobj.DischargeTime = obj.DischargeTime
		
		s obj.Name = eobj.Name
		s obj.Sex = eobj.Sex
		s obj.Age = eobj.Age
		s obj.AgeUnit = eobj.AgeUnit
		s obj.AdmisTime = eobj.AdmisTime
		s obj.HospDays = eobj.HospDays
		s obj.DischargeTime = eobj.DischargeTime
		
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
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-出院记录","web.CDSS.Demo.DischargeRec","SaveData",eobj)
       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
		
		//出院记录表保存
		s RowId=$o(^WDT.CDSS.DEMODischargeRecI("PatIndex",eobj.PatDR,"")) //出院记录Id
		if (RowId="")  //如果RowId未赋值则增加
		{
			s objRec=##class(WDT.CDSS.DEMODischargeRec).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s objRec=##class(WDT.CDSS.DEMODischargeRec).%OpenId(RowId)
			
			s bobjRec = ##class(web.CDSSEntity.Demo.DischargeRec).%New()
			s bobjRec.PatDR = objRec.PatDR.%Id()
			s bobjRec.AdmisComplexion = objRec.AdmisComplexion
			s bobjRec.AdmisDisease = objRec.AdmisDisease
			s bobjRec.TreateProcess = objRec.TreateProcess
			s bobjRec.OperaName = objRec.OperaName
			s bobjRec.WoundHealing = objRec.WoundHealing
			s bobjRec.DischargeDiag = objRec.DischargeDiag
			s bobjRec.DischargeSituation = objRec.DischargeSituation
			s bobjRec.DischargeOrder = objRec.DischargeOrder
			s bobjRec.DischargeGuide = objRec.DischargeGuide
			s bobjRec.RehospitalPlan = objRec.RehospitalPlan
			s bobjRec.DoctorSign = objRec.DoctorSign
			s bobjRec.RecordTime = objRec.RecordTime
			
		}
		d objRec.PatDRSetObjectId(eobj.PatDR)
		s objRec.AdmisComplexion = eobj.AdmisComplexion
		s objRec.AdmisDisease = eobj.AdmisDisease
		s objRec.TreateProcess = eobj.TreateProcess
		s objRec.OperaName = eobj.OperaName
		s objRec.WoundHealing = eobj.WoundHealing
		s objRec.DischargeDiag = eobj.DischargeDiag
		s objRec.DischargeSituation = eobj.DischargeSituation
		s objRec.DischargeOrder = eobj.DischargeOrder
		s objRec.DischargeGuide = eobj.DischargeGuide
		s objRec.RehospitalPlan = eobj.RehospitalPlan
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
		    d:RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMODischargeRec","WDT.CDSS.DEMODischargeRec","住院Demo-出院记录",id,eobj.AdmisComplexion,"A",eobj)
		 	d:RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMODischargeRec","WDT.CDSS.DEMODischargeRec","住院Demo-出院记录",eobj.RowId,eobj.AdmisComplexion,"U",eobj,bobjRec)    
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scRec)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-出院记录","web.CDSS.Demo.DischargeRec","SaveData",eobj)
       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scRec)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-24小时入出院记录","web.CDSS.Demo.DischargeRec","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze 
 q result
}

/// Creator:高姗姗
/// CreatDate:2021-02-04
/// Description:校验患者基础信息及出院记录
/// Table: WDT.CDSS.DEMOPatMaster、WDT.CDSS.DEMODischargeRec
/// Input: eobj 出院记录实体对象
/// others:w ##class(web.CDSS.Demo.DischargeRec).ValidateData(eobj)
ClassMethod ValidateData(eobj As web.CDSSEntity.Demo.DischargeRec)
{
	q:eobj.PatDR="" "{success:'true'}"
	s result=""
	if $IsObject(eobj)
	{
		s RowId=$o(^WDT.CDSS.DEMODischargeRecI("PatIndex",eobj.PatDR,"")) //出院记录Id
		if (RowId="")  //如果RowId未赋值则校验是否为空
		{
			if ((eobj.AdmisComplexion="")&&(eobj.AdmisDisease="")&&(eobj.TreateProcess="")&&(eobj.OperaName="")&&(eobj.WoundHealing="")&&(eobj.DischargeDiag="")&&(eobj.DischargeSituation="")&&(eobj.DischargeOrder="")&&(eobj.DischargeGuide="")&&(eobj.RehospitalPlan="")&&(eobj.DoctorSign="")&&(eobj.RecordTime="")){
				s result = "{success:'true'}"
			}else{
				s result = "{success:'false'}"
			}
		}
		else  //如果RowId已赋值则校验是否一致
		{
			s obj=##class(WDT.CDSS.DEMOPatMaster).%OpenId(eobj.PatDR)	
			s objRec=##class(WDT.CDSS.DEMODischargeRec).%OpenId(RowId)
			
			s bobjRec = ##class(web.CDSSEntity.Demo.DischargeRec).%New()
			s bobjRec.RowId = eobj.RowId
			s bobjRec.Name = obj.Name
			s bobjRec.Sex = obj.Sex
			s bobjRec.Age = obj.Age
			s bobjRec.AgeUnit = obj.AgeUnit
			s bobjRec.AdmisTime = obj.AdmisTime
			s bobjRec.HospDays = obj.HospDays
			s bobjRec.DischargeTime = obj.DischargeTime
			s bobjRec.PatDR = objRec.PatDR.%Id()
			s bobjRec.AdmisComplexion = objRec.AdmisComplexion
			s bobjRec.AdmisDisease = objRec.AdmisDisease
			s bobjRec.TreateProcess = objRec.TreateProcess
			s bobjRec.OperaName = objRec.OperaName
			s bobjRec.WoundHealing = objRec.WoundHealing
			s bobjRec.DischargeDiag = objRec.DischargeDiag
			s bobjRec.DischargeSituation = objRec.DischargeSituation
			s bobjRec.DischargeOrder = objRec.DischargeOrder
			s bobjRec.DischargeGuide = objRec.DischargeGuide
			s bobjRec.RehospitalPlan = objRec.RehospitalPlan
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
/// CreatDate: 2021-02-04
/// Description：数据打开方法
/// Table：WDT.CDSS.DEMODischargeRec
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.DischargeRec).OpenData()
ClassMethod OpenData() As %String
{
	s str=""
	s eobj = ##class(web.CDSSEntity.Demo.DischargeRec).%New()
	s PatDR=##class(web.CDSS.Demo.PatMaster).GetPatId() //患者Id
	if (PatDR'=""){
		s pobj = ##class(WDT.CDSS.DEMOPatMaster).%OpenId(PatDR)
		s eobj.Name = pobj.Name
		s eobj.Sex = pobj.Sex
		s eobj.Age = pobj.Age
		s eobj.AgeUnit = pobj.AgeUnit
		s eobj.AdmisTime = pobj.AdmisTime
		s eobj.HospDays = pobj.HospDays
		s eobj.DischargeTime = pobj.DischargeTime
		
		d pobj.%Close()	
		k pobj	
	}
	s eobj.PatDR=PatDR
	s RowId=$o(^WDT.CDSS.DEMODischargeRecI("PatIndex",PatDR,"")) //出院记录Id
	if (RowId'=""){
		s robj = ##class(WDT.CDSS.DEMODischargeRec).%OpenId(RowId)
		s eobj.AdmisComplexion = robj.AdmisComplexion
		s eobj.AdmisDisease = robj.AdmisDisease
		s eobj.TreateProcess = robj.TreateProcess
		s eobj.OperaName = robj.OperaName
		s eobj.WoundHealing = robj.WoundHealing
		s eobj.DischargeDiag = robj.DischargeDiag
		s eobj.DischargeSituation = robj.DischargeSituation
		s eobj.DischargeOrder = robj.DischargeOrder
		s eobj.DischargeGuide = robj.DischargeGuide
		s eobj.RehospitalPlan = robj.RehospitalPlan
		s eobj.DoctorSign = robj.DoctorSign
		s eobj.RecordTime = robj.RecordTime
		
		d robj.%Close()	
		k robj	
	}
	s str = eobj.JsonS()	
	q str
}

/// Creator：高姗姗
/// CreatDate: 2021-05-07
/// Description：获取出院记录及患者信息JSON，对接CDSS2.0
/// Table：WDT.CDSS.DEMODischargeRec
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.DischargeRec).GetJSONData("1")
ClassMethod GetJSONData(RowId) As %String
{
	s ResJSON={}
	s robj = ##class(WDT.CDSS.DEMODischargeRec).%OpenId(RowId)
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
	s ProgressType="9" //病历类型 出院记录9
	s ProgressTempleateID="" //模板唯一标示
	s ProgressTemplateName="" //模板名称
	s MsgType="2" //病历内容传递格式 2 传递键值对内容
	s Message="" //病历内容
	d ProgressNoteList.%Set("ProgressId",ProgressId)
	d ProgressNoteList.%Set("ProgressType",ProgressType)
	d ProgressNoteList.%Set("ProgressTempleateID",ProgressTempleateID)
	d ProgressNoteList.%Set("ProgressTemplateName",ProgressTemplateName)
	d ProgressNoteList.%Set("MsgType",MsgType)
	d ProgressNoteList.%Set("Message",Message)
	
	s MessageList=[]
	s MessageArr("入院情况")=robj.AdmisComplexion
	s MessageArr("入院诊断")=robj.AdmisDisease
	s MessageArr("诊疗经过")=robj.TreateProcess
	s MessageArr("出院诊断")=robj.DischargeDiag
	s MessageArr("出院情况")=robj.DischargeSituation
	s MessageArr("出院医嘱")=robj.DischargeOrder
	
	s key=""
	for {
		s key=$o(MessageArr(key)) q:key=""
		continue:(MessageArr(key)="")
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
