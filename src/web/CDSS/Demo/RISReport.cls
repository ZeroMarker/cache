/// Description：住院Demo-RIS报告
/// Table：WDT.CDSS.DEMORISReport
Class web.CDSS.Demo.RISReport Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2021-03-03
/// Description:获得RIS报告表内容
/// Table: WDT.CDSS.DEMORISReport
/// Input: 
/// Return:返回所有RIS报告表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Demo.RISReport","GetList")
Query GetList() As %Query(ROWSPEC = "RowId,PatDR,CreateTime,ExamLoc,ExamNumber,CurrentDiag,ExamItem,ExamResult,DoctorSign,RecordTime,OrderContent")
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
	set Data=$lb(RowId,PatDR,CreateTime,ExamLoc,ExamNumber,CurrentDiag,ExamItem,ExamResult,DoctorSign,RecordTime,OrderContent)
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
/// Description:保存RIS报告
/// Table: WDT.CDSS.DEMORISReport
/// Input: eobj RIS报告记录实体对象
/// others:w ##class(web.CDSS.Demo.RISReport).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Demo.RISReport)
{
	s $zt="ERROR"
	Ts
	s result=""
	if $IsObject(eobj)
	{
		q:eobj.PatDR="" "{success:'false',errorinfo:'请选择患者'}"
		
		//RIS报告记录表保存
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s objRec=##class(WDT.CDSS.DEMORISReport).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s objRec=##class(WDT.CDSS.DEMORISReport).%OpenId(eobj.RowId)
			
			s bobjRec = ##class(web.CDSSEntity.Demo.RISReport).%New()
			s bobjRec.PatDR = objRec.PatDR.%Id()
			s bobjRec.CreateTime = objRec.CreateTime
			s bobjRec.ExamLoc = objRec.ExamLoc
			s bobjRec.ExamNumber = objRec.ExamNumber
			s bobjRec.CurrentDiag = objRec.CurrentDiag
			s bobjRec.ExamItem = objRec.ExamItem
			s bobjRec.ExamResult = objRec.ExamResult
			s bobjRec.DoctorSign = objRec.DoctorSign
			s bobjRec.RecordTime = objRec.RecordTime
			s:objRec.OrdersDR'="" bobjRec.OrdersDR = objRec.OrdersDR.%Id()
			s:objRec.OrdersDR="" bobjRec.OrdersDR = ""
		}
		d objRec.PatDRSetObjectId(eobj.PatDR)
		s objRec.CreateTime = eobj.CreateTime
		s objRec.ExamLoc = eobj.ExamLoc
		s objRec.ExamNumber = eobj.ExamNumber
		s objRec.CurrentDiag = eobj.CurrentDiag
		s objRec.ExamItem = eobj.ExamItem
		s objRec.ExamResult = eobj.ExamResult
		s objRec.DoctorSign = eobj.DoctorSign
		s objRec.RecordTime = eobj.RecordTime
		d:eobj.OrdersDR'="" objRec.OrdersDRSetObjectId(eobj.OrdersDR)
		d:eobj.OrdersDR="" objRec.OrdersDRSetObjectId("")
		
		s scRec=objRec.%Save()
		d objRec.%Close()
		If $$$ISOK(scRec)
		{
			Tc
			s id = objRec.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			
			 //保存日志
		    d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMORISReport","WDT.CDSS.DEMORISReport","住院Demo-RIS报告",id,eobj.ExamItem,"A",eobj)
		 	d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMORISReport","WDT.CDSS.DEMORISReport","住院Demo-RIS报告",eobj.RowId,eobj.ExamItem,"U",eobj,bobjRec)    
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scRec)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-RIS报告","web.CDSS.Demo.RISReport","SaveData",eobj)
       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scRec)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-RIS报告","web.CDSS.Demo.RISReport","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze 
 q result
}

/// Creator:高姗姗
/// CreatDate:2021-03-03
/// Description:校验RIS报告
/// Table: WDT.CDSS.DEMORISReport
/// Input: eobj RIS报告记录实体对象
/// others:w ##class(web.CDSS.Demo.RISReport).ValidateData(eobj)
ClassMethod ValidateData(eobj As web.CDSSEntity.Demo.RISReport)
{
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则校验是否为空
		{
			if ((eobj.ExamLoc="")&&(eobj.ExamNumber="")&&(eobj.CurrentDiag="")&&(eobj.ExamItem="")&&(eobj.ExamResult="")&&(eobj.DoctorSign="")&&(eobj.RecordTime="")&&(eobj.OrdersDR="")){
				s result = "{success:'true'}"
			}else{
				s result = "{success:'false'}"
			}
		}
		else  //如果RowId已赋值则校验是否一致
		{
			s objRec=##class(WDT.CDSS.DEMORISReport).%OpenId(eobj.RowId)
			
			s bobjRec = ##class(web.CDSSEntity.Demo.RISReport).%New()
			s bobjRec.RowId = eobj.RowId
			s bobjRec.PatDR = objRec.PatDR.%Id()
			s bobjRec.CreateTime = objRec.CreateTime
			s bobjRec.ExamLoc = objRec.ExamLoc
			s bobjRec.ExamNumber = objRec.ExamNumber
			s bobjRec.CurrentDiag = objRec.CurrentDiag
			s bobjRec.ExamItem = objRec.ExamItem
			s bobjRec.ExamResult = objRec.ExamResult
			s bobjRec.DoctorSign = objRec.DoctorSign
			s bobjRec.RecordTime = objRec.RecordTime
			s:objRec.OrdersDR'="" bobjRec.OrdersDR = objRec.OrdersDR.%Id()
			s:objRec.OrdersDR="" bobjRec.OrdersDR = ""
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
/// Table：WDT.CDSS.DEMORISReport
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.RISReport).OpenData()
ClassMethod OpenData(id) As %String
{
	s str=""
	s eobj = ##class(web.CDSSEntity.Demo.RISReport).%New()
	s PatDR=##class(web.CDSS.Demo.PatMaster).GetPatId() //患者Id
	s eobj.PatDR=PatDR
	if (id'=""){
		s robj = ##class(WDT.CDSS.DEMORISReport).%OpenId(id)
		s eobj.CreateTime = robj.CreateTime
		s eobj.ExamLoc = robj.ExamLoc
		s eobj.ExamNumber = robj.ExamNumber
		s eobj.CurrentDiag = robj.CurrentDiag
		s eobj.ExamItem = robj.ExamItem
		s eobj.ExamResult = robj.ExamResult
		s eobj.DoctorSign = robj.DoctorSign
		s eobj.RecordTime = robj.RecordTime
		s:robj.OrdersDR'="" eobj.OrdersDR = robj.OrdersDR.%Id()
		s:robj.OrdersDR="" eobj.OrdersDR = ""
		
		d robj.%Close()	
		k robj	
	}

	s str = eobj.JsonS()	
	q str
}

/// Creator:高姗姗
/// CreatDate:2021-03-03
/// Description:删除RIS报告
/// Table: WDT.CDSS.DEMORISReport
/// others:w ##class(web.CDSS.Demo.RISReport).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	s obj=##class(WDT.CDSS.DEMORISReport).%OpenId(id)	
	s bobj = ##class(web.CDSSEntity.Demo.RISReport).%New()
	s bobj.PatDR = obj.PatDR.%Id()
	s bobj.CreateTime = obj.CreateTime
	s bobj.ExamLoc = obj.ExamLoc
	s bobj.ExamNumber = obj.ExamNumber
	s bobj.CurrentDiag = obj.CurrentDiag
	s bobj.ExamItem = obj.ExamItem
	s bobj.ExamResult = obj.ExamResult
	s bobj.DoctorSign = obj.DoctorSign
	s bobj.RecordTime = obj.RecordTime
	s:obj.OrdersDR'="" bobj.OrdersDR = obj.OrdersDR.%Id()
	s:obj.OrdersDR="" bobj.OrdersDR =""
	
	Ts
	s sc=##class(WDT.CDSS.DEMORISReport).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("DHCDSSDEMORISReport","WDT.CDSS.DEMORISReport","住院Demo-RIS报告",id,bobj.ExamItem,"D",bobj)
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
/// Description：获取RIS报告及患者信息JSON，对接CDSS2.0
/// Table：WDT.CDSS.DEMORISReport
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.RISReport).DHCDSSInterface("1")
ClassMethod DHCDSSInterface(PatDR) As %String
{
	s ResJSON={}
	s content={}
	s data=[]
	d content.%Set("theme","THM00158")
	s RowId = ""
	for
	{
		s RowId = $o(^WDT.CDSS.DEMORISReportI("PatIndex",PatDR,RowId))
		q:RowId=""
		s ExamResult = $lg($g(^WDT.CDSS.DEMORISReportD(RowId)),8)
		s RecordTime = $lg($g(^WDT.CDSS.DEMORISReportD(RowId)),10)
		
		s dataJson={}
		d dataJson.%Set("hosrisorderitemid",RowId) //医嘱号
		d dataJson.%Set("risrexamdesc",ExamResult) //检查结果概述
		d dataJson.%Set("risrchecktime","") //执行时间
		d dataJson.%Set("risrreportdate",RecordTime) //报告时间
		d dataJson.%Set("risrdiagdesc","") //备注，用于存储诊断意见
		d data.%Push(dataJson)
	}
	d content.%Set("data",data)
	d ResJSON.%Set("content",content)	
	d ##class(web.CDSS.MachineLearning.InteractiveInterface).DHCHisServerInterface(ResJSON.%ToJSON())
	q ResJSON.%ToJSON()
}

/// Creator：高姗姗
/// CreatDate: 2021-05-08
/// Description：获取RIS报告及患者信息JSON，对接CDSS2.0
/// Table：WDT.CDSS.DEMORISReport
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.RISReport).GetJSONData("1")
ClassMethod GetJSONData(RowId) As %String
{
	/*s ResJSON={}
	s robj = ##class(WDT.CDSS.DEMORISReport).%OpenId(RowId)
	s PatDR=robj.PatDR.%Id()
	s pobj = ##class(WDT.CDSS.DEMOPatMaster).%OpenId(PatDR)
	s IDNO =pobj.IDNO //患者主索引
	s PatientDR =pobj.PatientDR //病人标识
	s VisitID =pobj.AdmissionCount //就诊次
	s VisitType ="3" //就诊类型 1急诊，2门诊，3住院
	s Name =pobj.Name //患者姓名
	s UserID ="" //医生ID 
	s UserName ="" //医生姓名
	s DeptCode ="" //科室编码
	s DeptName =pobj.Department //科室名称
	s HospCode ="" //医院编码
	s HospName ="" //医院名称
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
	s MessageArr("主诉")=robj.ChiefCompSum
	
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
	s CreatDeptName="" //开立科室名称
	s RecordTime=robj.RecordTime //病历记录时间
	d ProgressNoteList.%Set("DoctorId",DoctorId)
	d ProgressNoteList.%Set("DoctorName",DoctorName)
	d ProgressNoteList.%Set("CreateDeptCode",CreateDeptCode)
	d ProgressNoteList.%Set("CreatDeptName",CreatDeptName)
	d ProgressNoteList.%Set("RecordTime",RecordTime)
	d ResJSON.%Set("ProgressNoteList",ProgressNoteList)
	q ResJSON.%ToJSON()*/
	
	;{ "GroupFlag":"医嘱号","ExamCode":"检查编码","ExamName":"检查名称","ExamResult":"检查结果","PartDR":"部位,可以直接传位置或者根据部位表传id或者传空","ExecuteTime":"执行时间","ReportTime":"报告时间","Remarks":"备注"}
	s ResJSON={}
	s robj = ##class(WDT.CDSS.DEMORISReport).%OpenId(RowId)
	s PatDR=robj.PatDR.%Id()
	s pobj = ##class(WDT.CDSS.DEMOPatMaster).%OpenId(PatDR)
	s IDNO =pobj.IDNO //患者主索引
	s PatientDR =pobj.PatientDR //病人标识
	s VisitID =pobj.AdmissionCount //就诊次
	s VisitType ="3" //就诊类型 1急诊，2门诊，3住院
	s Name =pobj.Name //患者姓名
	s UserID ="" //医生ID 
	s UserName ="" //医生姓名
	s DeptCode ="" //科室编码
	s DeptName =pobj.Department //科室名称
	s HospCode ="" //医院编码
	s HospName ="" //医院名称
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
	
	s:robj.OrdersDR'="" GroupFlag=robj.OrdersDR.%Id() //医嘱号
	s:robj.OrdersDR="" GroupFlag=""
	s ExamCode="" //检查编码
	s ExamName="" //检查名称
	s ExamResult=robj.ExamResult //检查结果
	s PartDR="" //部位
	s ExecuteTime="" //执行时间
	s ReportTime=robj.RecordTime //报告时间
	d ResJSON.%Set("GroupFlag",GroupFlag)
	d ResJSON.%Set("ExamCode",ExamCode)
	d ResJSON.%Set("ExamName",ExamName)
	d ResJSON.%Set("ExamResult",ExamResult)
	d ResJSON.%Set("PartDR",PartDR)
	d ResJSON.%Set("ExecuteTime",ExecuteTime)
	d ResJSON.%Set("ReportTime",ReportTime)
	d ResJSON.%Set("Remarks","")
	q ResJSON.%ToJSON()
}

}
