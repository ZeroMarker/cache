/// Description：住院Demo-手术记录
/// Table：WDT.CDSS.DEMOOperaRec
Class web.CDSS.Demo.OperaRec Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2021-03-01
/// Description:获得手术记录表内容
/// Table: WDT.CDSS.DEMOOperaRec
/// Input: 
/// Return:返回所有手术记录表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Demo.OperaRec","GetList")
Query GetList() As %Query(ROWSPEC = "RowId,PatDR,CreateTime,PreOperaDiag,PerOperaName,PerOperaDate,OperaName,OperaStartTime,OperaEndTime,AnesthesiaMethod,AnesStartTime,AnesEndTime,OperaProcess,OperaGeneral,OperaCondition,SurgicalStaff,PostOperaDiag,SurDoctorCode,SurDoctorName,AnesDoctorCode,AnesDoctorName,DoctorSign,RecordTime")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s PatDR=##class(web.CDSS.Demo.PatMaster).GetPatId() //患者Id
	s RowId = ""
	for
	{
		s RowId = $o(^WDT.CDSS.DEMOOperaRecI("PatIndex",PatDR,RowId),-1)
		q:RowId=""
		s CreateTime = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),3)
		s PreOperaDiag = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),4)
		s PerOperaName = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),5)
		s PerOperaDate = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),6)
		s OperaName = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),7)
		s OperaStartTime = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),8)
		s OperaEndTime = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),9)
		s AnesthesiaMethod = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),10)
		s AnesStartTime = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),11)
		s AnesEndTime = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),12)
		s OperaProcess = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),13)
		s OperaGeneral = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),14)
		s OperaCondition = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),15)
		s SurgicalStaff = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),16)
		s PostOperaDiag = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),17)
		s SurDoctorCode = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),18)
		s SurDoctorName = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),19)
		s AnesDoctorCode = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),20)
		s AnesDoctorName = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),21)
		s DoctorSign = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),22)
		s RecordTime = $lg($g(^WDT.CDSS.DEMOOperaRecD(RowId)),23)

		d OutputRow
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,PatDR,CreateTime,PreOperaDiag,PerOperaName,PerOperaDate,OperaName,OperaStartTime,OperaEndTime,AnesthesiaMethod,AnesStartTime,AnesEndTime,OperaProcess,OperaGeneral,OperaCondition,SurgicalStaff,PostOperaDiag,SurDoctorCode,SurDoctorName,AnesDoctorCode,AnesDoctorName,DoctorSign,RecordTime)
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
/// CreatDate:2021-03-01
/// Description:保存手术记录
/// Table: WDT.CDSS.DEMOOperaRec
/// Input: eobj 手术记录记录实体对象
/// others:w ##class(web.CDSS.Demo.OperaRec).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Demo.OperaRec)
{
	s $zt="ERROR"
	Ts
	s result=""
	if $IsObject(eobj)
	{
		q:eobj.PatDR="" "{success:'false',errorinfo:'请选择患者'}"
		
		//手术记录记录表保存
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s objRec=##class(WDT.CDSS.DEMOOperaRec).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s objRec=##class(WDT.CDSS.DEMOOperaRec).%OpenId(eobj.RowId)
			
			s bobjRec = ##class(web.CDSSEntity.Demo.OperaRec).%New()
			s bobjRec.PatDR = objRec.PatDR.%Id()
			s bobjRec.CreateTime = objRec.CreateTime
			s bobjRec.PreOperaDiag = objRec.PreOperaDiag
			s bobjRec.PerOperaName = objRec.PerOperaName
			s bobjRec.PerOperaDate = objRec.PerOperaDate
			s bobjRec.OperaName = objRec.OperaName
			s bobjRec.OperaStartTime = objRec.OperaStartTime
			s bobjRec.OperaEndTime = objRec.OperaEndTime
			s bobjRec.AnesthesiaMethod = objRec.AnesthesiaMethod
			s bobjRec.AnesStartTime = objRec.AnesStartTime
			s bobjRec.AnesEndTime = objRec.AnesEndTime
			s bobjRec.OperaProcess = objRec.OperaProcess
			s bobjRec.OperaGeneral = objRec.OperaGeneral
			s bobjRec.OperaCondition = objRec.OperaCondition
			s bobjRec.SurgicalStaff = objRec.SurgicalStaff
			s bobjRec.PostOperaDiag = objRec.PostOperaDiag
			s bobjRec.SurDoctorCode = objRec.SurDoctorCode
			s bobjRec.SurDoctorName = objRec.SurDoctorName
			s bobjRec.AnesDoctorCode = objRec.AnesDoctorCode
			s bobjRec.AnesDoctorName = objRec.AnesDoctorName
			s bobjRec.DoctorSign = objRec.DoctorSign
			s bobjRec.RecordTime = objRec.RecordTime
		}
		d objRec.PatDRSetObjectId(eobj.PatDR)
		s objRec.CreateTime = eobj.CreateTime
		s objRec.PreOperaDiag = eobj.PreOperaDiag
		s objRec.PerOperaName = eobj.PerOperaName
		s objRec.PerOperaDate = eobj.PerOperaDate
		s objRec.OperaName = eobj.OperaName
		s objRec.OperaStartTime = eobj.OperaStartTime
		s objRec.OperaEndTime = eobj.OperaEndTime
		s objRec.AnesthesiaMethod = eobj.AnesthesiaMethod
		s objRec.AnesStartTime = eobj.AnesStartTime
		s objRec.AnesEndTime = eobj.AnesEndTime
		s objRec.OperaProcess = eobj.OperaProcess
		s objRec.OperaGeneral = eobj.OperaGeneral
		s objRec.OperaCondition = eobj.OperaCondition
		s objRec.SurgicalStaff = eobj.SurgicalStaff
		s objRec.PostOperaDiag = eobj.PostOperaDiag
		s objRec.SurDoctorCode = eobj.SurDoctorCode
		s objRec.SurDoctorName = eobj.SurDoctorName
		s objRec.AnesDoctorCode = eobj.AnesDoctorCode
		s objRec.AnesDoctorName = eobj.AnesDoctorName
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
		    d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOOperaRec","WDT.CDSS.DEMOOperaRec","住院Demo-手术记录",id,eobj.OperaName,"A",eobj)
		 	d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOOperaRec","WDT.CDSS.DEMOOperaRec","住院Demo-手术记录",eobj.RowId,eobj.OperaName,"U",eobj,bobjRec)    
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scRec)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-手术记录","web.CDSS.Demo.OperaRec","SaveData",eobj)
       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scRec)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-手术记录","web.CDSS.Demo.OperaRec","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze 
 q result
}

/// Creator:高姗姗
/// CreatDate:2021-03-01
/// Description:校验手术记录
/// Table: WDT.CDSS.DEMOOperaRec
/// Input: eobj 手术记录记录实体对象
/// others:w ##class(web.CDSS.Demo.OperaRec).ValidateData(eobj)
ClassMethod ValidateData(eobj As web.CDSSEntity.Demo.OperaRec)
{
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则校验是否为空
		{
			if ((eobj.PreOperaDiag="")&&(eobj.PerOperaName="")&&(eobj.PerOperaDate="")&&(eobj.OperaName="")&&(eobj.OperaStartTime="")&&(eobj.OperaEndTime="")&&(eobj.AnesthesiaMethod="")&&(eobj.AnesStartTime="")&&(eobj.AnesEndTime="")&&(eobj.OperaProcess="")&&(eobj.OperaGeneral="")&&(eobj.OperaCondition="")&&(eobj.SurgicalStaff="")&&(eobj.PostOperaDiag="")&&(eobj.SurDoctorCode="")&&(eobj.SurDoctorName="")&&(eobj.AnesDoctorCode="")&&(eobj.AnesDoctorName="")&&(eobj.DoctorSign="")&&(eobj.RecordTime="")){
				s result = "{success:'true'}"
			}else{
				s result = "{success:'false'}"
			}
		}
		else  //如果RowId已赋值则校验是否一致
		{
			s objRec=##class(WDT.CDSS.DEMOOperaRec).%OpenId(eobj.RowId)
			
			s bobjRec = ##class(web.CDSSEntity.Demo.OperaRec).%New()
			s bobjRec.RowId = eobj.RowId
			s bobjRec.PatDR = objRec.PatDR.%Id()
			s bobjRec.CreateTime = objRec.CreateTime
			s bobjRec.PreOperaDiag = objRec.PreOperaDiag
			s bobjRec.PerOperaName = objRec.PerOperaName
			s bobjRec.PerOperaDate = objRec.PerOperaDate
			s bobjRec.OperaName = objRec.OperaName
			s bobjRec.OperaStartTime = objRec.OperaStartTime
			s bobjRec.OperaEndTime = objRec.OperaEndTime
			s bobjRec.AnesthesiaMethod = objRec.AnesthesiaMethod
			s bobjRec.AnesStartTime = objRec.AnesStartTime
			s bobjRec.AnesEndTime = objRec.AnesEndTime
			s bobjRec.OperaProcess = objRec.OperaProcess
			s bobjRec.OperaGeneral = objRec.OperaGeneral
			s bobjRec.OperaCondition = objRec.OperaCondition
			s bobjRec.SurgicalStaff = objRec.SurgicalStaff
			s bobjRec.PostOperaDiag = objRec.PostOperaDiag
			s bobjRec.SurDoctorCode = objRec.SurDoctorCode
			s bobjRec.SurDoctorName = objRec.SurDoctorName
			s bobjRec.AnesDoctorCode = objRec.AnesDoctorCode
			s bobjRec.AnesDoctorName = objRec.AnesDoctorName
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
/// CreatDate: 2021-03-01
/// Description：数据打开方法
/// Table：WDT.CDSS.DEMOOperaRec
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.OperaRec).OpenData()
ClassMethod OpenData(id) As %String
{
	s str=""
	s eobj = ##class(web.CDSSEntity.Demo.OperaRec).%New()
	s PatDR=##class(web.CDSS.Demo.PatMaster).GetPatId() //患者Id
	s eobj.PatDR=PatDR
	if (id'=""){
		s robj = ##class(WDT.CDSS.DEMOOperaRec).%OpenId(id)
		s eobj.CreateTime = robj.CreateTime
		s eobj.PreOperaDiag = robj.PreOperaDiag
		s eobj.PerOperaName = robj.PerOperaName
		s eobj.PerOperaDate = robj.PerOperaDate
		s eobj.OperaName = robj.OperaName
		s eobj.OperaStartTime = robj.OperaStartTime
		s eobj.OperaEndTime = robj.OperaEndTime
		s eobj.AnesthesiaMethod = robj.AnesthesiaMethod
		s eobj.AnesStartTime = robj.AnesStartTime
		s eobj.AnesEndTime = robj.AnesEndTime
		s eobj.OperaProcess = robj.OperaProcess
		s eobj.OperaGeneral = robj.OperaGeneral
		s eobj.OperaCondition = robj.OperaCondition
		s eobj.SurgicalStaff = robj.SurgicalStaff
		s eobj.PostOperaDiag = robj.PostOperaDiag
		s eobj.SurDoctorCode = robj.SurDoctorCode
		s eobj.SurDoctorName = robj.SurDoctorName
		s eobj.AnesDoctorCode = robj.AnesDoctorCode
		s eobj.AnesDoctorName = robj.AnesDoctorName
		s eobj.DoctorSign = robj.DoctorSign
		s eobj.RecordTime = robj.RecordTime
		
		d robj.%Close()	
		k robj	
	}

	s str = eobj.JsonS()	
	q str
}

/// Creator:高姗姗
/// CreatDate:2021-03-01
/// Description:删除手术记录
/// Table: WDT.CDSS.DEMOOperaRec
/// others:w ##class(web.CDSS.Demo.OperaRec).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	s obj=##class(WDT.CDSS.DEMOOperaRec).%OpenId(id)	
	s bobj = ##class(web.CDSSEntity.Demo.OperaRec).%New()
	s bobj.PatDR = obj.PatDR.%Id()
	s bobj.CreateTime = obj.CreateTime
	s bobj.PreOperaDiag = obj.PreOperaDiag
	s bobj.PerOperaName = obj.PerOperaName
	s bobj.PerOperaDate = obj.PerOperaDate
	s bobj.OperaName = obj.OperaName
	s bobj.OperaStartTime = obj.OperaStartTime
	s bobj.OperaEndTime = obj.OperaEndTime
	s bobj.AnesthesiaMethod = obj.AnesthesiaMethod
	s bobj.AnesStartTime = obj.AnesStartTime
	s bobj.AnesEndTime = obj.AnesEndTime
	s bobj.OperaProcess = obj.OperaProcess
	s bobj.OperaGeneral = obj.OperaGeneral
	s bobj.OperaCondition = obj.OperaCondition
	s bobj.SurgicalStaff = obj.SurgicalStaff
	s bobj.PostOperaDiag = obj.PostOperaDiag
	s bobj.SurDoctorCode = obj.SurDoctorCode
	s bobj.SurDoctorName = obj.SurDoctorName
	s bobj.AnesDoctorCode = obj.AnesDoctorCode
	s bobj.AnesDoctorName = obj.AnesDoctorName
	s bobj.DoctorSign = obj.DoctorSign
	s bobj.RecordTime = obj.RecordTime
	
	Ts
	s sc=##class(WDT.CDSS.DEMOOperaRec).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOOperaRec","WDT.CDSS.DEMOOperaRec","住院Demo-手术记录",id,bobj.OperaName,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2021-05-08
/// Description：获取手术记录及患者信息JSON，对接CDSS2.0
/// Table：WDT.CDSS.DEMOOperaRec
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.OperaRec).GetJSONData("1")
ClassMethod GetJSONData(RowId, Flag) As %String
{
	s ResJSON={}
	s robj = ##class(WDT.CDSS.DEMOOperaRec).%OpenId(RowId)
	s PatDR=robj.PatDR.%Id()
	s pobj = ##class(WDT.CDSS.DEMOPatMaster).%OpenId(PatDR)
	s IDNO =pobj.IDNO //患者主索引
	s PatientDR =pobj.PatientDR //病人标识
	s VisitID =pobj.AdmissionCount //就诊次
	s VisitType ="3" //就诊类型 1急诊，2门诊，3住院
	
	d ResJSON.%Set("IDNO",IDNO)
	d ResJSON.%Set("PatientDR",PatientDR)
	d ResJSON.%Set("VisitID",VisitID)
	d ResJSON.%Set("VisitType",VisitType)
	d ResJSON.%Set("OperNum","") //手术次数

	s OperationResultInfo=[]
	s OperaName = robj.OperaName
	s PreOperaDiag = robj.PreOperaDiag
	s OperaStartTime = robj.OperaStartTime
	s OperaEndTime = robj.OperaEndTime
	s OperationInfo={}
	d OperationInfo.%Set("OperSequence","")
	d OperationInfo.%Set("MainOperFlag","")
	d OperationInfo.%Set("OperCode",OperaName)
	d OperationInfo.%Set("OperName",OperaName)
	d OperationInfo.%Set("OperDesc",OperaName)
	d OperationInfo.%Set("OperType","")
	d OperationInfo.%Set("OperPosition","")
	d OperationInfo.%Set("IntraoperDiagnosis",PreOperaDiag)
	d OperationInfo.%Set("OperDuration","")
	d OperationInfo.%Set("OperStartTime",OperaStartTime)
	d OperationInfo.%Set("OperEndTime",OperaEndTime)
	d OperationResultInfo.%Push(OperationInfo)	
	
	d ResJSON.%Set("OperationResultInfo",OperationResultInfo)
	d ResJSON.%Set("PassFlag",Flag) //同步标记（0为同步，1为新增）
	q ResJSON.%ToJSON()
}

ClassMethod GetJSONDataBck(RowId) As %String
{
	s ResJSON={}
	s robj = ##class(WDT.CDSS.DEMOOperaRec).%OpenId(RowId)
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
	d ResJSON.%Set("UserID",UserID)
	d ResJSON.%Set("UserName",UserName)
	d ResJSON.%Set("DeptCode",DeptCode)
	d ResJSON.%Set("DeptName",DeptName)
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
	s ProgressType="10" //病历类型 手术记录10
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
