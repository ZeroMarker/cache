/// Description：住院Demo-术后首次病程
/// Table：WDT.CDSS.DEMOPostFstCuz
Class web.CDSS.Demo.PostFstCuz Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2021-03-02
/// Description:获得术后首次病程表内容
/// Table: WDT.CDSS.DEMOPostFstCuz
/// Input: 
/// Return:返回所有术后首次病程表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Demo.PostFstCuz","GetList")
Query GetList() As %Query(ROWSPEC = "RowId,PatDR,CreateTime,PatientInfo,PreOperaDiag,OperaTime,OperName,PostOperaDiag,OperaProcess,OperaMethod,AnesthesiaMethod,PostOperaMeasure,PostOperaAttention,OperaGeneral,DoctorSign,RecordTime")
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
		s RowId = $o(^WDT.CDSS.DEMOPostFstCuzI("PatIndex",PatDR,RowId),-1)
		q:RowId=""
		s CreateTime = $lg($g(^WDT.CDSS.DEMOPostFstCuzD(RowId)),3)
		s PatientInfo = $lg($g(^WDT.CDSS.DEMOPostFstCuzD(RowId)),4)
		s PreOperaDiag = $lg($g(^WDT.CDSS.DEMOPostFstCuzD(RowId)),5)
		s OperaTime = $lg($g(^WDT.CDSS.DEMOPostFstCuzD(RowId)),6)
		s OperName = $lg($g(^WDT.CDSS.DEMOPostFstCuzD(RowId)),7)
		s PostOperaDiag = $lg($g(^WDT.CDSS.DEMOPostFstCuzD(RowId)),8)
		s OperaProcess = $lg($g(^WDT.CDSS.DEMOPostFstCuzD(RowId)),9)
		s OperaMethod = $lg($g(^WDT.CDSS.DEMOPostFstCuzD(RowId)),10)
		s AnesthesiaMethod = $lg($g(^WDT.CDSS.DEMOPostFstCuzD(RowId)),11)
		s PostOperaMeasure = $lg($g(^WDT.CDSS.DEMOPostFstCuzD(RowId)),12)
		s PostOperaAttention = $lg($g(^WDT.CDSS.DEMOPostFstCuzD(RowId)),13)
		s OperaGeneral = $lg($g(^WDT.CDSS.DEMOPostFstCuzD(RowId)),14)
		s DoctorSign = $lg($g(^WDT.CDSS.DEMOPostFstCuzD(RowId)),15)
		s RecordTime = $lg($g(^WDT.CDSS.DEMOPostFstCuzD(RowId)),16)

		d OutputRow
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,PatDR,CreateTime,PatientInfo,PreOperaDiag,OperaTime,OperName,PostOperaDiag,OperaProcess,OperaMethod,AnesthesiaMethod,PostOperaMeasure,PostOperaAttention,OperaGeneral,DoctorSign,RecordTime)
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
/// Description:保存术后首次病程
/// Table: WDT.CDSS.DEMOPostFstCuz
/// Input: eobj 术后首次病程记录实体对象
/// others:w ##class(web.CDSS.Demo.PostFstCuz).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Demo.PostFstCuz)
{
	s $zt="ERROR"
	Ts
	s result=""
	if $IsObject(eobj)
	{
		q:eobj.PatDR="" "{success:'false',errorinfo:'请选择患者'}"
		
		//术后首次病程记录表保存
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s objRec=##class(WDT.CDSS.DEMOPostFstCuz).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s objRec=##class(WDT.CDSS.DEMOPostFstCuz).%OpenId(eobj.RowId)
			
			s bobjRec = ##class(web.CDSSEntity.Demo.PostFstCuz).%New()
			s bobjRec.PatDR = objRec.PatDR.%Id()
			s bobjRec.CreateTime = objRec.CreateTime
			s bobjRec.PatientInfo = objRec.PatientInfo
			s bobjRec.PreOperaDiag = objRec.PreOperaDiag
			s bobjRec.OperaTime = objRec.OperaTime
			s bobjRec.OperName = objRec.OperName
			s bobjRec.PostOperaDiag = objRec.PostOperaDiag
			s bobjRec.OperaProcess = objRec.OperaProcess
			s bobjRec.OperaMethod = objRec.OperaMethod
			s bobjRec.AnesthesiaMethod = objRec.AnesthesiaMethod
			s bobjRec.PostOperaMeasure = objRec.PostOperaMeasure
			s bobjRec.PostOperaAttention = objRec.PostOperaAttention
			s bobjRec.OperaGeneral = objRec.OperaGeneral
			s bobjRec.DoctorSign = objRec.DoctorSign
			s bobjRec.RecordTime = objRec.RecordTime
		}
		d objRec.PatDRSetObjectId(eobj.PatDR)
		s objRec.CreateTime = eobj.CreateTime
		s objRec.PatientInfo = eobj.PatientInfo
		s objRec.PreOperaDiag = eobj.PreOperaDiag
		s objRec.OperaTime = eobj.OperaTime
		s objRec.OperName = eobj.OperName
		s objRec.PostOperaDiag = eobj.PostOperaDiag
		s objRec.OperaProcess = eobj.OperaProcess
		s objRec.OperaMethod = eobj.OperaMethod
		s objRec.AnesthesiaMethod = eobj.AnesthesiaMethod
		s objRec.PostOperaMeasure = eobj.PostOperaMeasure
		s objRec.PostOperaAttention = eobj.PostOperaAttention
		s objRec.OperaGeneral = eobj.OperaGeneral
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
		    d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOPostFstCuz","WDT.CDSS.DEMOPostFstCuz","住院Demo-术后首次病程",id,eobj.PatientInfo,"A",eobj)
		 	d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOPostFstCuz","WDT.CDSS.DEMOPostFstCuz","住院Demo-术后首次病程",eobj.RowId,eobj.PatientInfo,"U",eobj,bobjRec)    
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scRec)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-术后首次病程","web.CDSS.Demo.PostFstCuz","SaveData",eobj)
       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scRec)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-术后首次病程","web.CDSS.Demo.PostFstCuz","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze 
 q result
}

/// Creator:高姗姗
/// CreatDate:2021-03-02
/// Description:校验术后首次病程
/// Table: WDT.CDSS.DEMOPostFstCuz
/// Input: eobj 术后首次病程记录实体对象
/// others:w ##class(web.CDSS.Demo.PostFstCuz).ValidateData(eobj)
ClassMethod ValidateData(eobj As web.CDSSEntity.Demo.PostFstCuz)
{
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则校验是否为空
		{
			if ((eobj.PatientInfo="")&&(eobj.PreOperaDiag="")&&(eobj.OperaTime="")&&(eobj.OperName="")&&(eobj.PostOperaDiag="")&&(eobj.OperaProcess="")&&(eobj.OperaMethod="")&&(eobj.AnesthesiaMethod="")&&(eobj.PostOperaMeasure="")&&(eobj.PostOperaAttention="")&&(eobj.OperaGeneral="")&&(eobj.DoctorSign="")&&(eobj.RecordTime="")){
				s result = "{success:'true'}"
			}else{
				s result = "{success:'false'}"
			}
		}
		else  //如果RowId已赋值则校验是否一致
		{
			s objRec=##class(WDT.CDSS.DEMOPostFstCuz).%OpenId(eobj.RowId)
			
			s bobjRec = ##class(web.CDSSEntity.Demo.PostFstCuz).%New()
			s bobjRec.RowId = eobj.RowId
			s bobjRec.PatDR = objRec.PatDR.%Id()
			s bobjRec.CreateTime = objRec.CreateTime
			s bobjRec.PatientInfo = objRec.PatientInfo
			s bobjRec.PreOperaDiag = objRec.PreOperaDiag
			s bobjRec.OperaTime = objRec.OperaTime
			s bobjRec.OperName = objRec.OperName
			s bobjRec.PostOperaDiag = objRec.PostOperaDiag
			s bobjRec.OperaProcess = objRec.OperaProcess
			s bobjRec.OperaMethod = objRec.OperaMethod
			s bobjRec.AnesthesiaMethod = objRec.AnesthesiaMethod
			s bobjRec.PostOperaMeasure = objRec.PostOperaMeasure
			s bobjRec.PostOperaAttention = objRec.PostOperaAttention
			s bobjRec.OperaGeneral = objRec.OperaGeneral
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
/// Table：WDT.CDSS.DEMOPostFstCuz
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.PostFstCuz).OpenData()
ClassMethod OpenData(id) As %String
{
	s str=""
	s eobj = ##class(web.CDSSEntity.Demo.PostFstCuz).%New()
	s PatDR=##class(web.CDSS.Demo.PatMaster).GetPatId() //患者Id
	s eobj.PatDR=PatDR
	if (id'=""){
		s robj = ##class(WDT.CDSS.DEMOPostFstCuz).%OpenId(id)
		s eobj.CreateTime = robj.CreateTime
		s eobj.PatientInfo = robj.PatientInfo
		s eobj.PreOperaDiag = robj.PreOperaDiag
		s eobj.OperaTime = robj.OperaTime
		s eobj.OperName = robj.OperName
		s eobj.PostOperaDiag = robj.PostOperaDiag
		s eobj.OperaProcess = robj.OperaProcess
		s eobj.OperaMethod = robj.OperaMethod
		s eobj.AnesthesiaMethod = robj.AnesthesiaMethod
		s eobj.PostOperaMeasure = robj.PostOperaMeasure
		s eobj.PostOperaAttention = robj.PostOperaAttention
		s eobj.OperaGeneral = robj.OperaGeneral
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
/// Description:删除术后首次病程
/// Table: WDT.CDSS.DEMOPostFstCuz
/// others:w ##class(web.CDSS.Demo.PostFstCuz).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	s obj=##class(WDT.CDSS.DEMOPostFstCuz).%OpenId(id)	
	s bobj = ##class(web.CDSSEntity.Demo.PostFstCuz).%New()
	s bobj.PatDR = obj.PatDR.%Id()
	s bobj.CreateTime = obj.CreateTime
	s bobj.PatientInfo = obj.PatientInfo
	s bobj.PreOperaDiag = obj.PreOperaDiag
	s bobj.OperaTime = obj.OperaTime
	s bobj.OperName = obj.OperName
	s bobj.PostOperaDiag = obj.PostOperaDiag
	s bobj.OperaProcess = obj.OperaProcess
	s bobj.OperaMethod = obj.OperaMethod
	s bobj.AnesthesiaMethod = obj.AnesthesiaMethod
	s bobj.PostOperaMeasure = obj.PostOperaMeasure
	s bobj.PostOperaAttention = obj.PostOperaAttention
	s bobj.OperaGeneral = obj.OperaGeneral
	s bobj.DoctorSign = obj.DoctorSign
	s bobj.RecordTime = obj.RecordTime
	
	Ts
	s sc=##class(WDT.CDSS.DEMOPostFstCuz).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOPostFstCuz","WDT.CDSS.DEMOPostFstCuz","住院Demo-术后首次病程",id,bobj.PatientInfo,"D",bobj)
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
/// Description：获取术后首次病程及患者信息JSON，对接CDSS2.0
/// Table：WDT.CDSS.DEMOPostFstCuz
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.PostFstCuz).GetJSONData("1")
ClassMethod GetJSONData(RowId) As %String
{
	s ResJSON={}
	s robj = ##class(WDT.CDSS.DEMOPostFstCuz).%OpenId(RowId)
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
	s ProgressType="6" //病历类型 术后首次病程6
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
