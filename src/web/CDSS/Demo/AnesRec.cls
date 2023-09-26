/// Description：住院Demo-麻醉记录
/// Table：WDT.CDSS.DEMOAnesRec
Class web.CDSS.Demo.AnesRec Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2021-03-02
/// Description:获得麻醉记录表内容
/// Table: WDT.CDSS.DEMOAnesRec
/// Input: 
/// Return:返回所有麻醉记录表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Demo.AnesRec","GetList")
Query GetList() As %Query(ROWSPEC = "RowId,PatDR,CreateTime,PreOperaDiag,PostOperaDiag,OperName,PerOperaName,OperaType,OperaTime,SurDoctor,AnesDoctorName,AnesthesiaMethod,AnesStartTime,AnesEndTime,DoctorSign,RecordTime")
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
		s RowId = $o(^WDT.CDSS.DEMOAnesRecI("PatIndex",PatDR,RowId),-1)
		q:RowId=""
		s CreateTime = $lg($g(^WDT.CDSS.DEMOAnesRecD(RowId)),3)
		s PreOperaDiag = $lg($g(^WDT.CDSS.DEMOAnesRecD(RowId)),4)
		s PostOperaDiag = $lg($g(^WDT.CDSS.DEMOAnesRecD(RowId)),5)
		s OperName = $lg($g(^WDT.CDSS.DEMOAnesRecD(RowId)),6)
		s PerOperaName = $lg($g(^WDT.CDSS.DEMOAnesRecD(RowId)),7)
		s OperaType = $lg($g(^WDT.CDSS.DEMOAnesRecD(RowId)),8)
		s OperaTime = $lg($g(^WDT.CDSS.DEMOAnesRecD(RowId)),9)
		s SurDoctor = $lg($g(^WDT.CDSS.DEMOAnesRecD(RowId)),10)
		s AnesDoctorName = $lg($g(^WDT.CDSS.DEMOAnesRecD(RowId)),11)
		s AnesthesiaMethod = $lg($g(^WDT.CDSS.DEMOAnesRecD(RowId)),12)
		s AnesStartTime = $lg($g(^WDT.CDSS.DEMOAnesRecD(RowId)),13)
		s AnesEndTime = $lg($g(^WDT.CDSS.DEMOAnesRecD(RowId)),14)
		s DoctorSign = $lg($g(^WDT.CDSS.DEMOAnesRecD(RowId)),15)
		s RecordTime = $lg($g(^WDT.CDSS.DEMOAnesRecD(RowId)),16)

		d OutputRow
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,PatDR,CreateTime,PreOperaDiag,PostOperaDiag,OperName,PerOperaName,OperaType,OperaTime,SurDoctor,AnesDoctorName,AnesthesiaMethod,AnesStartTime,AnesEndTime,DoctorSign,RecordTime)
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
/// CreatDate:2021-03-02
/// Description:保存麻醉记录
/// Table: WDT.CDSS.DEMOAnesRec
/// Input: eobj 麻醉记录记录实体对象
/// others:w ##class(web.CDSS.Demo.AnesRec).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Demo.AnesRec)
{
	s $zt="ERROR"
	Ts
	s result=""
	if $IsObject(eobj)
	{
		q:eobj.PatDR="" "{success:'false',errorinfo:'请选择患者'}"
		
		//麻醉记录记录表保存
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s objRec=##class(WDT.CDSS.DEMOAnesRec).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s objRec=##class(WDT.CDSS.DEMOAnesRec).%OpenId(eobj.RowId)
			
			s bobjRec = ##class(web.CDSSEntity.Demo.AnesRec).%New()
			s bobjRec.PatDR = objRec.PatDR.%Id()
			s bobjRec.CreateTime = objRec.CreateTime
			s bobjRec.PreOperaDiag = objRec.PreOperaDiag
			s bobjRec.PostOperaDiag = objRec.PostOperaDiag
			s bobjRec.OperName = objRec.OperName
			s bobjRec.PerOperaName = objRec.PerOperaName
			s bobjRec.OperaType = objRec.OperaType
			s bobjRec.OperaTime = objRec.OperaTime
			s bobjRec.SurDoctor = objRec.SurDoctor
			s bobjRec.AnesDoctorName = objRec.AnesDoctorName
			s bobjRec.AnesthesiaMethod = objRec.AnesthesiaMethod
			s bobjRec.AnesStartTime = objRec.AnesStartTime
			s bobjRec.AnesEndTime = objRec.AnesEndTime
			s bobjRec.DoctorSign = objRec.DoctorSign
			s bobjRec.RecordTime = objRec.RecordTime
		}
		d objRec.PatDRSetObjectId(eobj.PatDR)
		s objRec.CreateTime = eobj.CreateTime
		s objRec.PreOperaDiag = eobj.PreOperaDiag
		s objRec.PostOperaDiag = eobj.PostOperaDiag
		s objRec.OperName = eobj.OperName
		s objRec.PerOperaName = eobj.PerOperaName
		s objRec.OperaType = eobj.OperaType
		s objRec.OperaTime = eobj.OperaTime
		s objRec.SurDoctor = eobj.SurDoctor
		s objRec.AnesDoctorName = eobj.AnesDoctorName
		s objRec.AnesthesiaMethod = eobj.AnesthesiaMethod
		s objRec.AnesStartTime = eobj.AnesStartTime
		s objRec.AnesEndTime = eobj.AnesEndTime
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
		    d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOAnesRec","WDT.CDSS.DEMOAnesRec","住院Demo-麻醉记录",id,eobj.PreOperaDiag,"A",eobj)
		 	d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOAnesRec","WDT.CDSS.DEMOAnesRec","住院Demo-麻醉记录",eobj.RowId,eobj.PreOperaDiag,"U",eobj,bobjRec)    
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scRec)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-麻醉记录","web.CDSS.Demo.AnesRec","SaveData",eobj)
       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scRec)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-麻醉记录","web.CDSS.Demo.AnesRec","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze 
 q result
}

/// Creator:高姗姗
/// CreatDate:2021-03-02
/// Description:校验麻醉记录
/// Table: WDT.CDSS.DEMOAnesRec
/// Input: eobj 麻醉记录记录实体对象
/// others:w ##class(web.CDSS.Demo.AnesRec).ValidateData(eobj)
ClassMethod ValidateData(eobj As web.CDSSEntity.Demo.AnesRec)
{
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则校验是否为空
		{
			if ((eobj.PreOperaDiag="")&&(eobj.PostOperaDiag="")&&(eobj.OperName="")&&(eobj.PerOperaName="")&&(eobj.OperaType="")&&(eobj.OperaTime="")&&(eobj.SurDoctor="")&&(eobj.AnesDoctorName="")&&(eobj.AnesthesiaMethod="")&&(eobj.AnesStartTime="")&&(eobj.AnesEndTime="")&&(eobj.DoctorSign="")&&(eobj.RecordTime="")){
				s result = "{success:'true'}"
			}else{
				s result = "{success:'false'}"
			}
		}
		else  //如果RowId已赋值则校验是否一致
		{
			s objRec=##class(WDT.CDSS.DEMOAnesRec).%OpenId(eobj.RowId)
			
			s bobjRec = ##class(web.CDSSEntity.Demo.AnesRec).%New()
			s bobjRec.RowId = eobj.RowId
			s bobjRec.PatDR = objRec.PatDR.%Id()
			s bobjRec.CreateTime = objRec.CreateTime
			s bobjRec.PreOperaDiag = objRec.PreOperaDiag
			s bobjRec.PostOperaDiag = objRec.PostOperaDiag
			s bobjRec.OperName = objRec.OperName
			s bobjRec.PerOperaName = objRec.PerOperaName
			s bobjRec.OperaType = objRec.OperaType
			s bobjRec.OperaTime = objRec.OperaTime
			s bobjRec.SurDoctor = objRec.SurDoctor
			s bobjRec.AnesDoctorName = objRec.AnesDoctorName
			s bobjRec.AnesthesiaMethod = objRec.AnesthesiaMethod
			s bobjRec.AnesStartTime = objRec.AnesStartTime
			s bobjRec.AnesEndTime = objRec.AnesEndTime
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
/// CreatDate: 2021-03-02
/// Description：数据打开方法
/// Table：WDT.CDSS.DEMOAnesRec
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.AnesRec).OpenData()
ClassMethod OpenData(id) As %String
{
	s str=""
	s eobj = ##class(web.CDSSEntity.Demo.AnesRec).%New()
	s PatDR=##class(web.CDSS.Demo.PatMaster).GetPatId() //患者Id
	s eobj.PatDR=PatDR
	if (id'=""){
		s robj = ##class(WDT.CDSS.DEMOAnesRec).%OpenId(id)
		s eobj.CreateTime = robj.CreateTime
		s eobj.PreOperaDiag = robj.PreOperaDiag
		s eobj.PostOperaDiag = robj.PostOperaDiag
		s eobj.OperName = robj.OperName
		s eobj.PerOperaName = robj.PerOperaName
		s eobj.OperaType = robj.OperaType
		s eobj.OperaTime = robj.OperaTime
		s eobj.SurDoctor = robj.SurDoctor
		s eobj.AnesDoctorName = robj.AnesDoctorName
		s eobj.AnesthesiaMethod = robj.AnesthesiaMethod
		s eobj.AnesStartTime = robj.AnesStartTime
		s eobj.AnesEndTime = robj.AnesEndTime
		s eobj.DoctorSign = robj.DoctorSign
		s eobj.RecordTime = robj.RecordTime
		
		d robj.%Close()	
		k robj	
	}

	s str = eobj.JsonS()	
	q str
}

/// Creator:高姗姗
/// CreatDate:2021-03-02
/// Description:删除麻醉记录
/// Table: WDT.CDSS.DEMOAnesRec
/// others:w ##class(web.CDSS.Demo.AnesRec).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	s obj=##class(WDT.CDSS.DEMOAnesRec).%OpenId(id)	
	s bobj = ##class(web.CDSSEntity.Demo.AnesRec).%New()
	s bobj.PatDR = obj.PatDR.%Id()
	s bobj.CreateTime = obj.CreateTime
	s bobj.PreOperaDiag = obj.PreOperaDiag
	s bobj.PostOperaDiag = obj.PostOperaDiag
	s bobj.OperName = obj.OperName
	s bobj.PerOperaName = obj.PerOperaName
	s bobj.OperaType = obj.OperaType
	s bobj.OperaTime = obj.OperaTime
	s bobj.SurDoctor = obj.SurDoctor
	s bobj.AnesDoctorName = obj.AnesDoctorName
	s bobj.AnesthesiaMethod = obj.AnesthesiaMethod
	s bobj.AnesStartTime = obj.AnesStartTime
	s bobj.AnesEndTime = obj.AnesEndTime
	s bobj.DoctorSign = obj.DoctorSign
	s bobj.RecordTime = obj.RecordTime
	
	Ts
	s sc=##class(WDT.CDSS.DEMOAnesRec).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOAnesRec","WDT.CDSS.DEMOAnesRec","住院Demo-麻醉记录",id,bobj.PreOperaDiag,"D",bobj)
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
/// Description：获取麻醉记录及患者信息JSON，对接CDSS2.0
/// Table：WDT.CDSS.DEMOAnesRec
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.AnesRec).GetJSONData("1")
ClassMethod GetJSONData(RowId) As %String
{
	s ResJSON={}
	s robj = ##class(WDT.CDSS.DEMOAnesRec).%OpenId(RowId)
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
