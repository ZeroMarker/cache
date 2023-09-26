/// Description：住院Demo-转出记录
/// Table：WDT.CDSS.DEMOTransOutRec
Class web.CDSS.Demo.TransOutRec Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2021-03-03
/// Description:获得转出记录表内容
/// Table: WDT.CDSS.DEMOTransOutRec
/// Input: 
/// Return:返回所有转出记录表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Demo.TransOutRec","GetList")
Query GetList() As %Query(ROWSPEC = "RowId,PatDR,CreateTime,ChiefCompSum,AdmisComplexion,AdmisDisease,TreateProcess,CurrentSituation,CurrentDiag,TransPurpose,DoctorSign,RecordTime")
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
		s RowId = $o(^WDT.CDSS.DEMOTransOutRecI("PatIndex",PatDR,RowId),-1)
		q:RowId=""
		s CreateTime = $lg($g(^WDT.CDSS.DEMOTransOutRecD(RowId)),3)
		s ChiefCompSum = $lg($g(^WDT.CDSS.DEMOTransOutRecD(RowId)),4)
		s AdmisComplexion = $lg($g(^WDT.CDSS.DEMOTransOutRecD(RowId)),5)
		s AdmisDisease = $lg($g(^WDT.CDSS.DEMOTransOutRecD(RowId)),6)
		s TreateProcess = $lg($g(^WDT.CDSS.DEMOTransOutRecD(RowId)),7)
		s CurrentSituation = $lg($g(^WDT.CDSS.DEMOTransOutRecD(RowId)),8)
		s CurrentDiag = $lg($g(^WDT.CDSS.DEMOTransOutRecD(RowId)),9)
		s TransPurpose = $lg($g(^WDT.CDSS.DEMOTransOutRecD(RowId)),10)
		s DoctorSign = $lg($g(^WDT.CDSS.DEMOTransOutRecD(RowId)),11)
		s RecordTime = $lg($g(^WDT.CDSS.DEMOTransOutRecD(RowId)),12)

		d OutputRow
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,PatDR,CreateTime,ChiefCompSum,AdmisComplexion,AdmisDisease,TreateProcess,CurrentSituation,CurrentDiag,TransPurpose,DoctorSign,RecordTime)
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
/// CreatDate:2021-03-03
/// Description:保存转出记录
/// Table: WDT.CDSS.DEMOTransOutRec
/// Input: eobj 转出记录记录实体对象
/// others:w ##class(web.CDSS.Demo.TransOutRec).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Demo.TransOutRec)
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
		
		s obj.Name = eobj.Name
		s obj.Sex = eobj.Sex
		s obj.Age = eobj.Age
		s obj.AgeUnit = eobj.AgeUnit
		
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
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-转出记录","web.CDSS.Demo.TransOutRec","SaveData",eobj)
       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
		
		//转出记录记录表保存
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s objRec=##class(WDT.CDSS.DEMOTransOutRec).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s objRec=##class(WDT.CDSS.DEMOTransOutRec).%OpenId(eobj.RowId)
			
			s bobjRec = ##class(web.CDSSEntity.Demo.TransOutRec).%New()
			s bobjRec.PatDR = objRec.PatDR.%Id()
			s bobjRec.CreateTime = objRec.CreateTime
			s bobjRec.ChiefCompSum = objRec.ChiefCompSum
			s bobjRec.AdmisComplexion = objRec.AdmisComplexion
			s bobjRec.AdmisDisease = objRec.AdmisDisease
			s bobjRec.TreateProcess = objRec.TreateProcess
			s bobjRec.CurrentSituation = objRec.CurrentSituation
			s bobjRec.CurrentDiag = objRec.CurrentDiag
			s bobjRec.TransPurpose = objRec.TransPurpose
			s bobjRec.DoctorSign = objRec.DoctorSign
			s bobjRec.RecordTime = objRec.RecordTime
		}
		d objRec.PatDRSetObjectId(eobj.PatDR)
		s objRec.CreateTime = eobj.CreateTime
		s objRec.ChiefCompSum = eobj.ChiefCompSum
		s objRec.AdmisComplexion = eobj.AdmisComplexion
		s objRec.AdmisDisease = eobj.AdmisDisease
		s objRec.TreateProcess = eobj.TreateProcess
		s objRec.CurrentSituation = eobj.CurrentSituation
		s objRec.CurrentDiag = eobj.CurrentDiag
		s objRec.TransPurpose = eobj.TransPurpose
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
		    d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOTransOutRec","WDT.CDSS.DEMOTransOutRec","住院Demo-转出记录",id,eobj.ChiefCompSum,"A",eobj)
		 	d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOTransOutRec","WDT.CDSS.DEMOTransOutRec","住院Demo-转出记录",eobj.RowId,eobj.ChiefCompSum,"U",eobj,bobjRec)    
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scRec)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-转出记录","web.CDSS.Demo.TransOutRec","SaveData",eobj)
       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scRec)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-转出记录","web.CDSS.Demo.TransOutRec","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze 
 q result
}

/// Creator:高姗姗
/// CreatDate:2021-03-03
/// Description:校验转出记录
/// Table: WDT.CDSS.DEMOTransOutRec
/// Input: eobj 转出记录记录实体对象
/// others:w ##class(web.CDSS.Demo.TransOutRec).ValidateData(eobj)
ClassMethod ValidateData(eobj As web.CDSSEntity.Demo.TransOutRec)
{
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则校验是否为空
		{
			if ((eobj.ChiefCompSum="")&&(eobj.AdmisComplexion="")&&(eobj.AdmisDisease="")&&(eobj.TreateProcess="")&&(eobj.CurrentSituation="")&&(eobj.CurrentDiag="")&&(eobj.TransPurpose="")&&(eobj.DoctorSign="")&&(eobj.RecordTime="")){
				s result = "{success:'true'}"
			}else{
				s result = "{success:'false'}"
			}
		}
		else  //如果RowId已赋值则校验是否一致
		{
			s obj=##class(WDT.CDSS.DEMOPatMaster).%OpenId(eobj.PatDR)	
			s objRec=##class(WDT.CDSS.DEMOTransOutRec).%OpenId(eobj.RowId)
			
			s bobjRec = ##class(web.CDSSEntity.Demo.TransOutRec).%New()
			s bobjRec.RowId = eobj.RowId
			s bobjRec.Name = obj.Name
			s bobjRec.Sex = obj.Sex
			s bobjRec.Age = obj.Age
			s bobjRec.AgeUnit = obj.AgeUnit
			s bobjRec.PatDR = objRec.PatDR.%Id()
			s bobjRec.CreateTime = objRec.CreateTime
			s bobjRec.ChiefCompSum = objRec.ChiefCompSum
			s bobjRec.AdmisComplexion = objRec.AdmisComplexion
			s bobjRec.AdmisDisease = objRec.AdmisDisease
			s bobjRec.TreateProcess = objRec.TreateProcess
			s bobjRec.CurrentSituation = objRec.CurrentSituation
			s bobjRec.CurrentDiag = objRec.CurrentDiag
			s bobjRec.TransPurpose = objRec.TransPurpose
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
/// CreatDate: 2021-03-03
/// Description：数据打开方法
/// Table：WDT.CDSS.DEMOTransOutRec
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.TransOutRec).OpenData()
ClassMethod OpenData(id) As %String
{
	s str=""
	s eobj = ##class(web.CDSSEntity.Demo.TransOutRec).%New()
	s PatDR=##class(web.CDSS.Demo.PatMaster).GetPatId() //患者Id
	if (PatDR'=""){
		s pobj = ##class(WDT.CDSS.DEMOPatMaster).%OpenId(PatDR)
		s eobj.Name = pobj.Name
		s eobj.Sex = pobj.Sex
		s eobj.Age = pobj.Age
		s eobj.AgeUnit = pobj.AgeUnit
		
		d pobj.%Close()	
		k pobj	
	}
	
	s eobj.PatDR=PatDR
	if (id'=""){
		s robj = ##class(WDT.CDSS.DEMOTransOutRec).%OpenId(id)
		s eobj.CreateTime = robj.CreateTime
		s eobj.ChiefCompSum = robj.ChiefCompSum
		s eobj.AdmisComplexion = robj.AdmisComplexion
		s eobj.AdmisDisease = robj.AdmisDisease
		s eobj.TreateProcess = robj.TreateProcess
		s eobj.CurrentSituation = robj.CurrentSituation
		s eobj.CurrentDiag = robj.CurrentDiag
		s eobj.TransPurpose = robj.TransPurpose
		s eobj.DoctorSign = robj.DoctorSign
		s eobj.RecordTime = robj.RecordTime
		
		d robj.%Close()	
		k robj	
	}

	s str = eobj.JsonS()	
	q str
}

/// Creator:高姗姗
/// CreatDate:2021-03-03
/// Description:删除转出记录
/// Table: WDT.CDSS.DEMOTransOutRec
/// others:w ##class(web.CDSS.Demo.TransOutRec).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	s obj=##class(WDT.CDSS.DEMOTransOutRec).%OpenId(id)	
	s bobj = ##class(web.CDSSEntity.Demo.TransOutRec).%New()
	s bobj.PatDR = obj.PatDR.%Id()
	s bobj.CreateTime = obj.CreateTime
	s bobj.ChiefCompSum = obj.ChiefCompSum
	s bobj.AdmisComplexion = obj.AdmisComplexion
	s bobj.AdmisDisease = obj.AdmisDisease
	s bobj.TreateProcess = obj.TreateProcess
	s bobj.CurrentSituation = obj.CurrentSituation
	s bobj.CurrentDiag = obj.CurrentDiag
	s bobj.TransPurpose = obj.TransPurpose
	s bobj.DoctorSign = obj.DoctorSign
	s bobj.RecordTime = obj.RecordTime
	
	Ts
	s sc=##class(WDT.CDSS.DEMOTransOutRec).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOTransOutRec","WDT.CDSS.DEMOTransOutRec","住院Demo-转出记录",id,bobj.ChiefCompSum,"D",bobj)
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
/// Description：获取转出记录及患者信息JSON，对接CDSS2.0
/// Table：WDT.CDSS.DEMOTransOutRec
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.TransOutRec).GetJSONData("1")
ClassMethod GetJSONData(RowId) As %String
{
	s ResJSON={}
	s robj = ##class(WDT.CDSS.DEMOTransOutRec).%OpenId(RowId)
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
	s ProgressType="14" //病历类型 转出记录14
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
	s MessageArr("主诉")=robj.ChiefCompSum
	s MessageArr("入院情况")=robj.AdmisComplexion
	s MessageArr("入院诊断")=robj.AdmisDisease
	s MessageArr("诊疗经过")=robj.TreateProcess
	s MessageArr("转科目的及注意事项")=robj.TransPurpose
	
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
