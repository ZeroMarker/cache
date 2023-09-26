/// Description：住院Demo-死亡讨论记录
/// Table：WDT.CDSS.DEMODthDiscuzRec
Class web.CDSS.Demo.DthDiscuzRec Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2021-02-07
/// Description:保存死亡讨论记录
/// Table: WDT.CDSS.DEMODthDiscuzRec
/// Input: eobj 死亡讨论记录实体对象
/// others:w ##class(web.CDSS.Demo.DthDiscuzRec).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Demo.DthDiscuzRec)
{
	s $zt="ERROR"
	
	s result=""
	if $IsObject(eobj)
	{
		q:eobj.PatDR="" "{success:'false',errorinfo:'请选择患者'}"
		
		//死亡讨论记录表保存
		s RowId=$o(^WDT.CDSS.DEMODthDiscuzRecI("PatIndex",eobj.PatDR,"")) //死亡讨论记录Id
		if (RowId="")  //如果RowId未赋值则增加
		{
			s objRec=##class(WDT.CDSS.DEMODthDiscuzRec).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s objRec=##class(WDT.CDSS.DEMODthDiscuzRec).%OpenId(RowId)
			
			s bobjRec = ##class(web.CDSSEntity.Demo.DthDiscuzRec).%New()
			s bobjRec.PatDR = objRec.PatDR.%Id()
			s bobjRec.CreateTime = objRec.CreateTime
			s bobjRec.DiscussTime = objRec.DiscussTime
			s bobjRec.Host = objRec.Host
			s bobjRec.Participant = objRec.Participant
			s bobjRec.DeathTime = objRec.DeathTime
			s bobjRec.DeathCause = objRec.DeathCause
			s bobjRec.DeathDiag = objRec.DeathDiag
			s bobjRec.RecordSummary = objRec.RecordSummary
			s bobjRec.FirstAidAndTreat = objRec.FirstAidAndTreat
			s bobjRec.DiscussResult = objRec.DiscussResult
			s bobjRec.HostSummary = objRec.HostSummary
			s bobjRec.DoctorSign = objRec.DoctorSign
			s bobjRec.RecordTime = objRec.RecordTime
		}
		d objRec.PatDRSetObjectId(eobj.PatDR)
		s objRec.CreateTime = eobj.CreateTime
		s objRec.DiscussTime = eobj.DiscussTime
		s objRec.Host = eobj.Host
		s objRec.Participant = eobj.Participant
		s objRec.DeathTime = eobj.DeathTime
		s objRec.DeathCause = eobj.DeathCause
		s objRec.DeathDiag = eobj.DeathDiag
		s objRec.RecordSummary = eobj.RecordSummary
		s objRec.FirstAidAndTreat = eobj.FirstAidAndTreat
		s objRec.DiscussResult = eobj.DiscussResult
		s objRec.HostSummary = eobj.HostSummary
		s objRec.DoctorSign = eobj.DoctorSign
		s objRec.RecordTime = eobj.RecordTime
		Ts
		s scRec=objRec.%Save()
		d objRec.%Close()
		If $$$ISOK(scRec)
		{
			Tc
			s id = objRec.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			
			 //保存日志
		    d:RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMODthDiscuzRec","WDT.CDSS.DEMODthDiscuzRec","住院Demo-死亡讨论记录",id,eobj.HostSummary,"A",eobj)
		 	d:RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMODthDiscuzRec","WDT.CDSS.DEMODthDiscuzRec","住院Demo-死亡讨论记录",eobj.RowId,eobj.HostSummary,"U",eobj,bobjRec)    
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scRec)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-死亡讨论记录","web.CDSS.Demo.DthDiscuzRec","SaveData",eobj)
       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scRec)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-死亡讨论记录","web.CDSS.Demo.DthDiscuzRec","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze 
 q result
}

/// Creator:高姗姗
/// CreatDate:2021-02-07
/// Description:校验死亡讨论记录
/// Table: WDT.CDSS.DEMODthDiscuzRec
/// Input: eobj 死亡讨论记录实体对象
/// others:w ##class(web.CDSS.Demo.DthDiscuzRec).SaveData(eobj)
ClassMethod ValidateData(eobj As web.CDSSEntity.Demo.DthDiscuzRec)
{
	q:eobj.PatDR="" "{success:'true'}"
	s result=""
	if $IsObject(eobj)
	{
		s RowId=$o(^WDT.CDSS.DEMODthDiscuzRecI("PatIndex",eobj.PatDR,"")) //死亡讨论记录Id
		if (RowId="")  //如果RowId未赋值则校验是否为空
		{
			if ((eobj.DiscussTime="")&&(eobj.Host="")&&(eobj.Participant="")&&(eobj.DeathTime="")&&(eobj.DeathCause="")&&(eobj.DeathDiag="")&&(eobj.RecordSummary="")&&(eobj.FirstAidAndTreat="")&&(eobj.DiscussResult="")&&(eobj.HostSummary="")&&(eobj.DoctorSign="")&&(eobj.RecordTime="")){
				s result = "{success:'true'}"
			}else{
				s result = "{success:'false'}"
			}
		}
		else  //如果RowId已赋值则校验是否一致
		{
			s objRec=##class(WDT.CDSS.DEMODthDiscuzRec).%OpenId(RowId)
			
			s bobjRec = ##class(web.CDSSEntity.Demo.DthDiscuzRec).%New()
			s bobjRec.RowId = eobj.RowId
			s bobjRec.PatDR = objRec.PatDR.%Id()
			s bobjRec.DiscussTime = objRec.DiscussTime
			s bobjRec.Host = objRec.Host
			s bobjRec.Participant = objRec.Participant
			s bobjRec.DeathTime = objRec.DeathTime
			s bobjRec.DeathCause = objRec.DeathCause
			s bobjRec.DeathDiag = objRec.DeathDiag
			s bobjRec.RecordSummary = objRec.RecordSummary
			s bobjRec.FirstAidAndTreat = objRec.FirstAidAndTreat
			s bobjRec.DiscussResult = objRec.DiscussResult
			s bobjRec.HostSummary = objRec.HostSummary
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
/// CreatDate: 2021-02-07
/// Description：数据打开方法
/// Table：WDT.CDSS.DEMODthDiscuzRec
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.DthDiscuzRec).OpenData()
ClassMethod OpenData() As %String
{
	s str=""
	s eobj = ##class(web.CDSSEntity.Demo.DthDiscuzRec).%New()
	s PatDR=##class(web.CDSS.Demo.PatMaster).GetPatId() //患者Id
	s eobj.PatDR=PatDR
	s RowId=$o(^WDT.CDSS.DEMODthDiscuzRecI("PatIndex",PatDR,"")) //死亡讨论记录Id
	if (RowId'=""){
		s robj = ##class(WDT.CDSS.DEMODthDiscuzRec).%OpenId(RowId)
		s eobj.CreateTime = robj.CreateTime
		s eobj.DiscussTime = robj.DiscussTime
		s eobj.Host = robj.Host
		s eobj.Participant = robj.Participant
		s eobj.DeathTime = robj.DeathTime
		s eobj.DeathCause = robj.DeathCause
		s eobj.DeathDiag = robj.DeathDiag
		s eobj.RecordSummary = robj.RecordSummary
		s eobj.FirstAidAndTreat = robj.FirstAidAndTreat
		s eobj.DiscussResult = robj.DiscussResult
		s eobj.HostSummary = robj.HostSummary
		s eobj.DoctorSign = robj.DoctorSign
		s eobj.RecordTime = robj.RecordTime
		
		d robj.%Close()	
		k robj	
	}

	s str = eobj.JsonS()	
	q str
}

/// Creator：高姗姗
/// CreatDate: 2021-05-08
/// Description：获取死亡讨论记录及患者信息JSON，对接CDSS2.0
/// Table：WDT.CDSS.DEMODthDiscuzRec
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.DthDiscuzRec).GetJSONData("1")
ClassMethod GetJSONData(RowId) As %String
{
	s ResJSON={}
	s robj = ##class(WDT.CDSS.DEMODthDiscuzRec).%OpenId(RowId)
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
	s ProgressType="23" //病历类型 死亡讨论记录23
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
	/*s MessageArr("入院情况")=robj.AdmisComplexion
	
	s key=""
	for {
		s key=$o(MessageArr(key)) q:key=""
		continue:(MessageArr(key)="")
		s MessageJson={}
		d MessageJson.%Set("key",key)
		d MessageJson.%Set("value",MessageArr(key))
		d MessageList.%Push(MessageJson)	
	}*/
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
