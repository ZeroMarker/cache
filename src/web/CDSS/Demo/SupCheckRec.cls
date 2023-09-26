/// Description：住院Demo-上级医师查房记录
/// Table：WDT.CDSS.DEMOSupCheckRec
Class web.CDSS.Demo.SupCheckRec Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2021-02-22
/// Description:获得上级医师查房记录表内容
/// Table: WDT.CDSS.DEMOSupCheckRec
/// Input: 
/// Return:返回所有上级医师查房记录表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Demo.SupCheckRec","GetList")
Query GetList() As %Query(ROWSPEC = "RowId,PatDR,CreateTime,CheckRecord,DoctorSign,RecordTime")
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
		s RowId = $o(^WDT.CDSS.DEMOSupCheckRecI("PatIndex",PatDR,RowId),-1)
		q:RowId=""
		s CreateTime = $lg($g(^WDT.CDSS.DEMOSupCheckRecD(RowId)),3)
		s CheckRecord = $lg($g(^WDT.CDSS.DEMOSupCheckRecD(RowId)),4)
		s DoctorSign = $lg($g(^WDT.CDSS.DEMOSupCheckRecD(RowId)),5)
		s RecordTime = $lg($g(^WDT.CDSS.DEMOSupCheckRecD(RowId)),6)

		d OutputRow
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,PatDR,CreateTime,CheckRecord,DoctorSign,RecordTime)
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
/// CreatDate:2021-02-22
/// Description:保存上级医师查房记录
/// Table: WDT.CDSS.DEMOSupCheckRec
/// Input: eobj 上级医师查房记录记录实体对象
/// others:w ##class(web.CDSS.Demo.SupCheckRec).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Demo.SupCheckRec)
{
	s $zt="ERROR"
	Ts
	s result=""
	if $IsObject(eobj)
	{
		q:eobj.PatDR="" "{success:'false',errorinfo:'请选择患者'}"
		
		//上级医师查房记录记录表保存
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s objRec=##class(WDT.CDSS.DEMOSupCheckRec).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s objRec=##class(WDT.CDSS.DEMOSupCheckRec).%OpenId(eobj.RowId)
			
			s bobjRec = ##class(web.CDSSEntity.Demo.SupCheckRec).%New()
			s bobjRec.PatDR = objRec.PatDR.%Id()
			s bobjRec.CreateTime = objRec.CreateTime
			s bobjRec.CheckRecord = objRec.CheckRecord
			s bobjRec.DoctorSign = objRec.DoctorSign
			s bobjRec.RecordTime = objRec.RecordTime
		}
		d objRec.PatDRSetObjectId(eobj.PatDR)
		s objRec.CreateTime = eobj.CreateTime
		s objRec.CheckRecord = eobj.CheckRecord
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
		    d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOSupCheckRec","WDT.CDSS.DEMOSupCheckRec","住院Demo-上级医师查房记录",id,eobj.CheckRecord,"A",eobj)
		 	d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOSupCheckRec","WDT.CDSS.DEMOSupCheckRec","住院Demo-上级医师查房记录",eobj.RowId,eobj.CheckRecord,"U",eobj,bobjRec)    
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scRec)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-上级医师查房记录","web.CDSS.Demo.SupCheckRec","SaveData",eobj)
       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scRec)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-上级医师查房记录","web.CDSS.Demo.SupCheckRec","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze 
 q result
}

/// Creator:高姗姗
/// CreatDate:2021-02-22
/// Description:校验上级医师查房记录
/// Table: WDT.CDSS.DEMOSupCheckRec
/// Input: eobj 上级医师查房记录记录实体对象
/// others:w ##class(web.CDSS.Demo.SupCheckRec).ValidateData(eobj)
ClassMethod ValidateData(eobj As web.CDSSEntity.Demo.SupCheckRec)
{
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则校验是否为空
		{
			if ((eobj.CheckRecord="")&&(eobj.DoctorSign="")&&(eobj.RecordTime="")){
				s result = "{success:'true'}"
			}else{
				s result = "{success:'false'}"
			}
		}
		else  //如果RowId已赋值则校验是否一致
		{
			s objRec=##class(WDT.CDSS.DEMOSupCheckRec).%OpenId(eobj.RowId)
			
			s bobjRec = ##class(web.CDSSEntity.Demo.SupCheckRec).%New()
			s bobjRec.RowId = eobj.RowId
			s bobjRec.PatDR = objRec.PatDR.%Id()
			s bobjRec.CreateTime = objRec.CreateTime
			s bobjRec.CheckRecord = objRec.CheckRecord
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
/// CreatDate: 2021-02-22
/// Description：数据打开方法
/// Table：WDT.CDSS.DEMOSupCheckRec
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.SupCheckRec).OpenData()
ClassMethod OpenData(id) As %String
{
	s str=""
	s eobj = ##class(web.CDSSEntity.Demo.SupCheckRec).%New()
	s PatDR=##class(web.CDSS.Demo.PatMaster).GetPatId() //患者Id
	s eobj.PatDR=PatDR
	if (id'=""){
		s robj = ##class(WDT.CDSS.DEMOSupCheckRec).%OpenId(id)
		s eobj.CreateTime = robj.CreateTime
		s eobj.CheckRecord = robj.CheckRecord
		s eobj.DoctorSign = robj.DoctorSign
		s eobj.RecordTime = robj.RecordTime
		
		d robj.%Close()	
		k robj	
	}

	s str = eobj.JsonS()	
	q str
}

/// Creator:高姗姗
/// CreatDate:2021-02-22
/// Description:删除上级医师查房记录
/// Table: WDT.CDSS.DEMOSupCheckRec
/// others:w ##class(web.CDSS.Demo.SupCheckRec).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	s obj=##class(WDT.CDSS.DEMOSupCheckRec).%OpenId(id)	
	s bobj = ##class(web.CDSSEntity.Demo.SupCheckRec).%New()
	s bobj.PatDR = obj.PatDR.%Id()
	s bobj.CreateTime = obj.CreateTime
	s bobj.CheckRecord = obj.CheckRecord
	s bobj.DoctorSign = obj.DoctorSign
	s bobj.RecordTime = obj.RecordTime
	
	Ts
	s sc=##class(WDT.CDSS.DEMOSupCheckRec).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOSupCheckRec","WDT.CDSS.DEMOSupCheckRec","住院Demo-上级医师查房记录",id,bobj.CheckRecord,"D",bobj)
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
/// CreatDate: 2021-05-07
/// Description：获取上级医师查房记录及患者信息JSON，对接CDSS2.0
/// Table：WDT.CDSS.DEMOSupCheckRec
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.SupCheckRec).GetJSONData("1")
ClassMethod GetJSONData(RowId) As %String
{
	s ResJSON={}
	s robj = ##class(WDT.CDSS.DEMOSupCheckRec).%OpenId(RowId)
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
	s ProgressType="12" //病历类型 上级医师查房记录12
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
	/*s MessageArr("主诉")=robj.ChiefCompSum
	
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
