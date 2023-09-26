/// Description：住院Demo-LIS报告
/// Table：WDT.CDSS.DEMOLISReport
Class web.CDSS.Demo.LISReport Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2021-03-04
/// Description:获得LIS报告表内容
/// Table: WDT.CDSS.DEMOLISReport
/// Input: 
/// Return:返回所有LIS报告表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Demo.LISReport","GetList")
Query GetList() As %Query(ROWSPEC = "RowId,PatDR,CreateTime,Laboratory,LabNumber,CurrentDiag,SpecReceiveTime,OperatorSign,ReviewerSign,RecordTime,OrderContent")
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
		s RowId = $o(^WDT.CDSS.DEMOLISReportI("PatIndex",PatDR,RowId),-1)
		q:RowId=""
		s CreateTime = $lg($g(^WDT.CDSS.DEMOLISReportD(RowId)),3)
		s Laboratory = $lg($g(^WDT.CDSS.DEMOLISReportD(RowId)),4)
		s LabNumber = $lg($g(^WDT.CDSS.DEMOLISReportD(RowId)),5)
		s CurrentDiag = $lg($g(^WDT.CDSS.DEMOLISReportD(RowId)),6)
		s SpecReceiveTime = $lg($g(^WDT.CDSS.DEMOLISReportD(RowId)),7)
		s OperatorSign = $lg($g(^WDT.CDSS.DEMOLISReportD(RowId)),8)
		s ReviewerSign = $lg($g(^WDT.CDSS.DEMOLISReportD(RowId)),9)
		s RecordTime = $lg($g(^WDT.CDSS.DEMOLISReportD(RowId)),10)
		s OrdersDR = $lg($g(^WDT.CDSS.DEMOLISReportD(RowId)),12)
		s OrderContent=""
		s:OrdersDR'="" OrderContent= $lg($g(^WDT.CDSS.DEMOLabOrdersD(OrdersDR)),6)

		d OutputRow
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,PatDR,CreateTime,Laboratory,LabNumber,CurrentDiag,SpecReceiveTime,OperatorSign,ReviewerSign,RecordTime,OrderContent)
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
/// CreatDate:2021-03-04
/// Description:保存LIS报告
/// Table: WDT.CDSS.DEMOLISReport
/// Input: eobj LIS报告记录实体对象
/// others:w ##class(web.CDSS.Demo.LISReport).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Demo.LISReport)
{
	s $zt="ERROR"
	Ts
	s result=""
	if $IsObject(eobj)
	{
		q:eobj.PatDR="" "{success:'false',errorinfo:'请选择患者'}"
		
		//LIS报告记录表保存
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s objRec=##class(WDT.CDSS.DEMOLISReport).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s objRec=##class(WDT.CDSS.DEMOLISReport).%OpenId(eobj.RowId)
			
			s bobjRec = ##class(web.CDSSEntity.Demo.LISReport).%New()
			s bobjRec.PatDR = objRec.PatDR.%Id()
			s bobjRec.CreateTime = objRec.CreateTime
			s bobjRec.Laboratory = objRec.Laboratory
			s bobjRec.LabNumber = objRec.LabNumber
			s bobjRec.CurrentDiag = objRec.CurrentDiag
			s bobjRec.SpecReceiveTime = objRec.SpecReceiveTime
			s bobjRec.OperatorSign = objRec.OperatorSign
			s bobjRec.ReviewerSign = objRec.ReviewerSign
			s bobjRec.RecordTime = objRec.RecordTime
			s:objRec.OrdersDR'="" bobjRec.OrdersDR = objRec.OrdersDR.%Id()
			s:objRec.OrdersDR="" bobjRec.OrdersDR = ""
		}
		d objRec.PatDRSetObjectId(eobj.PatDR)
		s objRec.CreateTime = eobj.CreateTime
		s objRec.Laboratory = eobj.Laboratory
		s objRec.LabNumber = eobj.LabNumber
		s objRec.CurrentDiag = eobj.CurrentDiag
		s objRec.SpecReceiveTime = eobj.SpecReceiveTime
		s objRec.OperatorSign = eobj.OperatorSign
		s objRec.ReviewerSign = eobj.ReviewerSign
		s objRec.RecordTime = eobj.RecordTime
		d:eobj.OrdersDR'="" objRec.OrdersDRSetObjectId(eobj.OrdersDR)
		d:eobj.OrdersDR="" objRec.OrdersDRSetObjectId("")
		
		s scRec=objRec.%Save()
		d objRec.%Close()
		If $$$ISOK(scRec)
		{
			s id = objRec.%Id()
			s resDetail=##class(web.CDSS.Demo.LISReportDetail).SaveData(id, eobj.Detail)
			if (resDetail="true"){
				Tc
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
			
				 //保存日志
			    d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOLISReport","WDT.CDSS.DEMOLISReport","住院Demo-LIS报告",id,eobj.SpecReceiveTime,"A",eobj)
			 	d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOLISReport","WDT.CDSS.DEMOLISReport","住院Demo-LIS报告",eobj.RowId,eobj.SpecReceiveTime,"U",eobj,bobjRec)    
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'检验明细保存失败'}"  //返回错误信息
			}
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scRec)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-LIS报告","web.CDSS.Demo.LISReport","SaveData",eobj)
       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scRec)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("住院Demo-LIS报告","web.CDSS.Demo.LISReport","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze 
 q result
}

/// Creator:高姗姗
/// CreatDate:2021-03-04
/// Description:校验LIS报告
/// Table: WDT.CDSS.DEMOLISReport
/// Input: eobj LIS报告记录实体对象
/// others:w ##class(web.CDSS.Demo.LISReport).ValidateData(eobj)
ClassMethod ValidateData(eobj As web.CDSSEntity.Demo.LISReport)
{
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则校验是否为空
		{
			if ((eobj.Laboratory="")&&(eobj.LabNumber="")&&(eobj.CurrentDiag="")&&(eobj.SpecReceiveTime="")&&(eobj.OperatorSign="")&&(eobj.ReviewerSign="")&&(eobj.RecordTime="")&&(eobj.Detail="")&&(eobj.OrdersDR="")){
				s result = "{success:'true'}"
			}else{
				s result = "{success:'false'}"
			}
		}
		else  //如果RowId已赋值则校验是否一致
		{
			s objRec=##class(WDT.CDSS.DEMOLISReport).%OpenId(eobj.RowId)
			
			s bobjRec = ##class(web.CDSSEntity.Demo.LISReport).%New()
			s bobjRec.RowId = eobj.RowId
			s bobjRec.PatDR = objRec.PatDR.%Id()
			s bobjRec.CreateTime = objRec.CreateTime
			s bobjRec.Laboratory = objRec.Laboratory
			s bobjRec.LabNumber = objRec.LabNumber
			s bobjRec.CurrentDiag = objRec.CurrentDiag
			s bobjRec.SpecReceiveTime = objRec.SpecReceiveTime
			s bobjRec.OperatorSign = objRec.OperatorSign
			s bobjRec.ReviewerSign = objRec.ReviewerSign
			s bobjRec.RecordTime = objRec.RecordTime
			s:objRec.OrdersDR'="" bobjRec.OrdersDR = objRec.OrdersDR.%Id()
			s:objRec.OrdersDR="" bobjRec.OrdersDR = "" 
			
			s Detail=""
			s sub = ""
			s parref=eobj.RowId
			for
			{
				s sub = $o(^WDT.CDSS.DEMOLISReportD(parref,"ChildReport",sub))
				q:sub=""
				s Id=parref_"||"_sub
				s LabItem = $lg($g(^WDT.CDSS.DEMOLISReportD(parref,"ChildReport",sub)),2)
				s LabResult = $lg($g(^WDT.CDSS.DEMOLISReportD(parref,"ChildReport",sub)),3)
				s Unit = $lg($g(^WDT.CDSS.DEMOLISReportD(parref,"ChildReport",sub)),4)
				s RefRange = $lg($g(^WDT.CDSS.DEMOLISReportD(parref,"ChildReport",sub)),5)
				s AbnormalResult = $lg($g(^WDT.CDSS.DEMOLISReportD(parref,"ChildReport",sub)),6)
				if (Detail=""){
	 				s Detail=Id_"$"_LabItem_"$"_LabResult_"$"_Unit_"$"_RefRange_"$"_AbnormalResult
		 		} else{
		 			s Detail=Detail_"&"_Id_"$"_LabItem_"$"_LabResult_"$"_Unit_"$"_RefRange_"$"_AbnormalResult
		 		}
			}
			s bobjRec.Detail=Detail

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
/// CreatDate: 2021-03-04
/// Description：数据打开方法
/// Table：WDT.CDSS.DEMOLISReport
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.LISReport).OpenData()
ClassMethod OpenData(id) As %String
{
	s str=""
	s eobj = ##class(web.CDSSEntity.Demo.LISReport).%New()
	s PatDR=##class(web.CDSS.Demo.PatMaster).GetPatId() //患者Id
	s eobj.PatDR=PatDR
	if (id'=""){
		s robj = ##class(WDT.CDSS.DEMOLISReport).%OpenId(id)
		s eobj.CreateTime = robj.CreateTime
		s eobj.Laboratory = robj.Laboratory
		s eobj.LabNumber = robj.LabNumber
		s eobj.CurrentDiag = robj.CurrentDiag
		s eobj.SpecReceiveTime = robj.SpecReceiveTime
		s eobj.OperatorSign = robj.OperatorSign
		s eobj.ReviewerSign = robj.ReviewerSign
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
/// CreatDate:2021-03-04
/// Description:删除LIS报告
/// Table: WDT.CDSS.DEMOLISReport
/// others:w ##class(web.CDSS.Demo.LISReport).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	s obj=##class(WDT.CDSS.DEMOLISReport).%OpenId(id)	
	s bobj = ##class(web.CDSSEntity.Demo.LISReport).%New()
	s bobj.PatDR = obj.PatDR.%Id()
	s bobj.CreateTime = obj.CreateTime
	s bobj.Laboratory = obj.Laboratory
	s bobj.LabNumber = obj.LabNumber
	s bobj.CurrentDiag = obj.CurrentDiag
	s bobj.SpecReceiveTime = obj.SpecReceiveTime
	s bobj.OperatorSign = obj.OperatorSign
	s bobj.ReviewerSign = obj.ReviewerSign
	s bobj.RecordTime = obj.RecordTime
	s:obj.OrdersDR'="" bobj.OrdersDR =obj.OrdersDR.%Id()
	s:obj.OrdersDR="" bobj.OrdersDR =""
	
	Ts
	s sc=##class(WDT.CDSS.DEMOLISReport).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOLISReport","WDT.CDSS.DEMOLISReport","住院Demo-LIS报告",id,bobj.SpecReceiveTime,"D",bobj)
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
/// Description：获取LIS报告及患者信息JSON，对接CDSS2.0
/// Table：WDT.CDSS.DEMOLISReport
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.LISReport).GetJSONData("4")
ClassMethod GetJSONData(RowId) As %String
{
	/*s ResJSON={}
	s robj = ##class(WDT.CDSS.DEMOLISReport).%OpenId(RowId)
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
	;{ "GroupFlag":"医嘱号","InspectionCode":"检验编码","InspectionName":"检验名称","LabResultInfo":[{"LabItemCode":"检验小项号","LabItemName":"检验小项名称","LabResult":"检验结果","LabResultFlag":"阴性阳性","Unit":"单位","Reference":"参考范围"},{"LabItemCode":"检验小项号","LabItemName":"检验小项名称","LabResult":"检验结果","LabResultFlag":"阴性阳性","Unit":"单位","Reference":"参考范围"}],"ExecuteTime":"执行时间","ReportTime":"报告时间","Remarks":"备注"}
	s ResJSON={}
	s robj = ##class(WDT.CDSS.DEMOLISReport).%OpenId(RowId)
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
	s InspectionCode="" //检验编码
	s InspectionName="" //检验名称
	s ExecuteTime="" //执行时间
	s ReportTime=robj.RecordTime //报告时间
	d ResJSON.%Set("GroupFlag",GroupFlag)
	d ResJSON.%Set("InspectionCode",InspectionCode)
	d ResJSON.%Set("InspectionName",InspectionName)
	
	s LabResultInfo=[]
	s sub = ""
	for
	{
		s sub = $o(^WDT.CDSS.DEMOLISReportD(RowId,"ChildReport",sub))
		q:sub=""
		s LabItem = $lg($g(^WDT.CDSS.DEMOLISReportD(RowId,"ChildReport",sub)),2) //检验项目
		s LabResult = $lg($g(^WDT.CDSS.DEMOLISReportD(RowId,"ChildReport",sub)),3) //检验结果
		s Unit = $lg($g(^WDT.CDSS.DEMOLISReportD(RowId,"ChildReport",sub)),4) //单位
		s RefRange = $lg($g(^WDT.CDSS.DEMOLISReportD(RowId,"ChildReport",sub)),5) //参考范围
		s AbnormalResult = $lg($g(^WDT.CDSS.DEMOLISReportD(RowId,"ChildReport",sub)),6) //异常结果显示
		s LabDetail={}
		d LabDetail.%Set("LabItemCode",LabItem)
		d LabDetail.%Set("LabItemName",LabItem)
		d LabDetail.%Set("LabResult",LabResult)
		d LabDetail.%Set("LabResultFlag",AbnormalResult)
		d LabDetail.%Set("Unit",Unit)
		d LabDetail.%Set("Reference",RefRange)
		d LabResultInfo.%Push(LabDetail)
	}
	
	d ResJSON.%Set("LabResultInfo",LabResultInfo)
	d ResJSON.%Set("ExecuteTime",ExecuteTime)
	d ResJSON.%Set("ReportTime",ReportTime)
	d ResJSON.%Set("Remarks","")
	q ResJSON.%ToJSON()
}

}
