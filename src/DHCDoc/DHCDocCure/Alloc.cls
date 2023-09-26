Class DHCDoc.DHCDocCure.Alloc Extends DHCDoc.Util.RegisteredObject
{

/// Creator:nk
/// CreateDate:20221215
/// Description:更新队列状态 报到，取消报到
/// Input:
/// Output:
/// Debug:w ##class(DHCDoc.DHCDocCure.Alloc).UpdateCureQue(2,"Report",17473)
ClassMethod UpdateCureQue(QueId As %String, StatusCode As %String, UserId As %String) As %String
{
	s $zt="UpdateErr"
	s ^tmplog("Update")=$lb(QueId,StatusCode,UserId)
	if (QueId="")!(StatusCode="")!(UserId="") q "-100"
	s CurrDate=..%SysDate()
	s CurrTime=..%SysTime()
	s QueNo=+$lg(^User.DHCDocCureQueueD(QueId),4)
	s QueRBASDr=$lg(^User.DHCDocCureQueueD(QueId),2)
	s ret=##class(DHCDoc.DHCDocCure.ScheduleTR).GetTimeRangeInfo(QueRBASDr,QueNo)
	s TimeRange=$p(ret,"^",2)
	/*
	if TimeRange'="",StatusCode="Wait" {
		s StTime=$p(TimeRange,"-",1)
		s:StTime'="" StTime=$zth(StTime)
		if StTime-900>CurrTime {
			q "未到报道时间，请提前15分钟左右前来报到"
		}
	}
	*/
	&sql(select DDCPS_RowID into :StatusDr from SQLUser.DHC_DocCurePerState where DDCPS_Code=:StatusCode)
	if $g(StatusDr)="" q "-1"
	s CallStatus=$lg(^User.DHCDocCureQueueD(QueId),19)
	if StatusCode="Complete"{
		s CallStatus=""	
	}
	&sql(update SQLUser.DHC_DocCure_Queue set DDCQ_Status_Dr=:StatusDr,DDCQ_StatusDate=:CurrDate,
		DDCQ_StatusTime=:CurrTime,DDCQ_StatusUser_Dr=:UserId,DDCQ_CallStatus=:CallStatus where ID=:QueId)
	q SQLCODE ;_","_$g(%msg)
	
UpdateErr
	s $zt=""
	q "-99^"_$ze
}

/// Creator:nk
/// CreateDate:
/// Description:批量更新队列状态
/// Input:
/// Output:
/// Debug:w ##class(DHCDoc.DHCDocCure.Alloc).UpdateBatch(para)
ClassMethod UpdateBatch(QueStr As %String, StatusCode As %String, UserId As %String) As %String
{
	s ErrInfo=""
	for i=1:1:$l(QueStr,"^") {
		s QueId=$p(QueStr,"^",i)
		continue:QueId=""
		s ret=..UpdateCureQue(QueId, StatusCode, UserId)
		if +ret'=0 {
			s PatName=$lg(^User.DHCDocCureQueueD(QueId),3)	
			if ErrInfo="" s ErrInfo=PatName_":"_ret
			else  s ErrInfo=ErrInfo_"、"_PatName_":"_ret
		}
	}
	q ErrInfo
}

Query FindCureAllocList(qPatientID As %String, qStatus As %String, qQueDate As %String, qTimeRange As %String, qResource As %String, qExpStr As %String, SessionStr As %String) As %Query(ROWSPEC = "Rowid:%String,PatId:%String,PatNo:%String,PatName:%String,PatOther:%String,QueNo:%String,QueStatus:%String,QueStatusCode:%String,QueDate:%String,QueRBASDr:%String,QueLocDr:%String,QueLocDesc:%String,ResourceDesc:%String,TimeRangeDesc:%String,QueOperUser:%String,QueInsertDate:%String,QueStatusUser:%String,QueStatusDate:%String,CallStatusCode:%String,QueRBASServiceGroupDR:%String,QueRBASServiceGroupDesc:%String,QueCallStatus:%String")
{
}

ClassMethod FindCureAllocListExecute(ByRef qHandle As %Binary, qPatientID As %String, qStatus As %String, qQueDate As %String, qTimeRange As %String, qResource As %String, qExpStr As %String, SessionStr As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Alloc","FindCureAllocList","","","","","","","doccure.alloc.triage.hui.csp^17473^275^92^2^^20")
	s ^tmplog("FindAllCureAllocList")=$lb(qPatientID,qStatus,qQueDate,qTimeRange,qResource ,qExpStr,SessionStr)
	s cspName=$p(SessionStr,"^",1)	
	s LogUserID=$p(SessionStr,"^",2)	
	s LogLocID=$p(SessionStr,"^",4)	
	s HospID=$p(SessionStr,"^",5)	
	s langid=$p(SessionStr,"^",7)	
	s:langid="" langid=..%LanguageID()
	s:LogLocID="" LogLocID=%session.Get("LOGON.CTLOCID")
	s:LogUserID="" LogUserID=%session.Get("LOGON.USERID")
	s LogLocIDStr=##class(DHCDoc.DHCDocCure.Apply).GetLinkLoc(LogLocID)
	s ReportFlag=$p(qExpStr,"^",1)	;报到界面查询
	s qPatName=$p(qExpStr,"^",2)	
	s qPatMedNo=$p(qExpStr,"^",3)	
	s ChkResRowId=""
	if ReportFlag'="Y"{
		s DoctorId=##class(web.SSUser).GetDefaultCareProvider(LogUserID)
		if DoctorId="" Quit $$$OK
		s DHCDocCureWorkQrySelf=##class(DHCDoc.DHCDocCure.Config).GetCureLocConfig("","CureLocWorkQrySelf",LogLocID,HospID)
		if (DHCDocCureWorkQrySelf=1){
			s ChkResRowId=$o(^RB("RES",0,"CTPCP",DoctorId,LogLocID,""))
			if ChkResRowId="" Quit $$$OK
		}
	}
	
	k AllocListAry
	s CurrDate=..%SysDate()
	s CurrTime=..%SysTime()
	if qQueDate'=""{
		s qQueDate=##class(websys.Conversions).DateHtmlToLogical(qQueDate)	
		s CurrDate=qQueDate
	}
		
	s ReportStatusCode="Report"
	s ReportStatusDr="",ReportStatus=""
	&sql(select DDCPS_RowID,DDCPS_Desc into :ReportStatusDr,:ReportStatus from SQLUser.DHC_DocCurePerState where DDCPS_Code=:ReportStatusCode)
	
	for loop=1:1:$l(LogLocIDStr){
		s Loc=$p(LogLocIDStr,"^",loop)
		continue:Loc=""
		s QueId=0 
		for{
			s QueId=$o(^User.DHCDocCureQueueI("IndexDateDep",CurrDate,Loc,QueId))
			q:QueId=""
			s PatientID=$lg(^User.DHCDocCureQueueD(QueId),13)
			continue:(qPatientID'="")&&(qPatientID'=PatientID)
			s PatientName=$P($G(^PAPER(PatientID,"ALL")),"^",1)
			continue:(qPatName'="")&&(PatientName'[qPatName)
			if (qPatMedNo'=""){
				s PatientMedicare=##class(web.DHCDocOrderCommon).GetMrNo("",PatientID,"I","")
				continue:(PatientMedicare'=qPatMedNo)
			}
			s QueStatusDr=$lg(^User.DHCDocCureQueueD(QueId),9)
			continue:(qStatus'="")&&(qStatus'=QueStatusDr)
			s QueStatusCode=$p($g(^DHCDocCurePS(QueStatusDr)),"^",1)
			;continue:(QueStatusCode="Cancel")
			s QueRBASDr=$lg(^User.DHCDocCureQueueD(QueId),2)	
			continue:QueRBASDr=""
			s QueResSourceDr=$p(^DHCDocCureRBCResSchdule(QueRBASDr),"^",3)
			continue:(ChkResRowId'="")&&(QueResSourceDr'=ChkResRowId) ;登录医生-仅显示预约到本人的记录
			continue:(qResource'="")&&(QueResSourceDr'=qResource) ;界面选择的治疗资源
			s TimeRange=$p($g(^DHCDocCureRBCResSchdule(QueRBASDr)),"^",5)			
			continue:(qTimeRange'="")&&(qTimeRange'=TimeRange)
			s QueNo=+$lg(^User.DHCDocCureQueueD(QueId),4)
			s QueStatusPriority=$p($g(^DHCDocCurePS(QueStatusDr)),"^",3)
			s CallStatusFlag=$lg(^User.DHCDocCureQueueD(QueId),19)
			s CallSort=$case(CallStatusFlag,"Y":"1","N":"9",:"2")
			s Sort=CallSort_QueRBASDr_TimeRange_""_QueStatusPriority
			s AllocListAry(Sort,QueNo,QueId)=""
		}
	}
	s SortNo="" 
	for {
		s SortNo=$o(AllocListAry(SortNo))
		q:SortNo=""
		s No=""
		for {
			s No=$o(AllocListAry(SortNo,No))
			q:No=""
			s QueId=""
			for { 
				s QueId=$o(AllocListAry(SortNo,No,QueId))
				q:QueId=""
				s PatientID=$lg(^User.DHCDocCureQueueD(QueId),13)
				s PatNo=##Class(web.PAPatMas).GetRegistration(PatientID)
				s PatName=$P($G(^PAPER(PatientID,"ALL")),"^",1)
				s PatSexDr=$P($G(^PAPER(PatientID,"ALL")),"^",7)
				if PatSexDr'="" s PatSex=$P($G(^CT("SEX",PatSexDr)),"^",2)
				else  s PatSex=""
				s PatSex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",PatSex,langid)
				s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",HospID)
				s PatientTel=$p($g(^PAPER(PatientID,"PER",1)),"^",11)
				s:PatientTel="" PatientTel="-"
				s PatOther=PatSex_" | "_PatAge_" | "_PatientTel
				s QueAry=..GetQueueAry(QueId,SessionStr)
				if QueAry.%Size()>0 {
					s QueRBASDr=QueAry.Get("QueRBASDr")
					s QueNo=QueAry.Get("QueNo")
					s QueStatusDr=QueAry.Get("QueStatusDr")
					s QueStatusDesc=QueAry.Get("QueStatusDesc")
					s QueStatusShowDesc=QueAry.Get("QueStatusShowDesc")
					s:QueStatusShowDesc'="" QueStatusDesc=QueStatusShowDesc
					s QueStatusCode=QueAry.Get("QueStatusCode")
					s QueDeptDr=QueAry.Get("QueDeptDr")
					s QueDept=QueAry.Get("QueDept")
					s ResourceDesc=QueAry.Get("QueRBASDesc")
					s QueDate=QueAry.Get("QueDate")
					s QueTime=QueAry.Get("QueTime")
					s QueDate=QueDate ;_" "_QueTime
					s QueOperUser=QueAry.Get("QueOperUser")
					s QueInsertDate=QueAry.Get("QueInsertDate")
					s QueInsertTime=QueAry.Get("QueInsertTime")
					s QueInsertDate=QueInsertDate_" "_QueInsertTime
					s QueStatusUser=QueAry.Get("QueStatusUser")
					s QueStatusDate=QueAry.Get("QueStatusDate")
					s QueStatusTime=QueAry.Get("QueStatusTime")
					s QueStatusDate=QueStatusDate_" "_QueStatusTime
					s QueTimeRangeInfo=QueAry.Get("QueTimeRangeInfo")
					s TimeRangeDesc=$p(QueTimeRangeInfo, " ",2)
					s TimeRange=$p($g(^DHCDocCureRBCResSchdule(QueRBASDr)),"^",5)
					s QueResSourceDr=QueAry.Get("QueResSourceDr")
					s QueCallStatus=QueAry.Get("QueCallStatus")
					s QueCallUserDr=QueAry.Get("QueCallUserDr")
					s QueRBASServiceGroupDR=QueAry.Get("QueRBASServiceGroupDR")
					s QueRBASServiceGroupDesc=QueAry.Get("QueRBASServiceGroupDesc")
					s QueCallStatus=QueAry.Get("QueCallStatus")
				}else {
					s QueRBASDr=""
					s QueNo=""
					s QueDate=""
					s QueStatusDr=ReportStatusDr
					s QueStatusDesc=ReportStatus
					s QueStatusCode=ReportStatusCode
					s (QueResSourceDr,ResourceDesc)=""
					s (TimeRangeDesc,TimeRange)=""
					s (QueRBASServiceGroupDesc,QueRBASServiceGroupDR)=""
					s (QueDeptDr,QueDept,QueOperUser,QueInsertDate,QueStatusUser,QueStatusDate,QueCallStatus)=""
				}				
				d OutputRow
			}
		}
	}
	Quit $$$OK
OutputRow
	s Data=$lb(QueId,PatientID,PatNo,PatName,PatOther,QueNo,QueStatusDesc,QueStatusCode,QueDate,QueRBASDr,QueDeptDr,QueDept,ResourceDesc,TimeRangeDesc,QueOperUser,QueInsertDate,QueStatusUser,QueStatusDate,QueCallStatus,QueRBASServiceGroupDR,QueRBASServiceGroupDesc,QueCallStatus)
	s qHandle($I(ind))=Data	
	q
}

ClassMethod FindCureAllocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureAllocListExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

/// W ##class(DHCDoc.DHCDocCure.Alloc).GetQueueInfo(1)
ClassMethod GetQueueInfo(QueId As %String) As %String
{
	s RetAry=..GetQueueAry(QueId)
	s JsonStr=##class(DHCDoc.Util.FromXML).Arr2Json(RetAry).Read()
	Q JsonStr
}

/// W ##class(DHCDoc.DHCDocCure.Alloc).GetQueueAry(2)
ClassMethod GetQueueAry(QueId As %String, SessionStr As %String) As DHCDoc.Util.ArrayData
{
	s RetAry=##class(DHCDoc.Util.ArrayData).%New()
	Q:QueId="" RetAry
	Q:'$d(^User.DHCDocCureQueueD(QueId)) RetAry
	
	s cspName=$p(SessionStr,"^",1)	
	s LogUserID=$p(SessionStr,"^",2)	
	s LogLocID=$p(SessionStr,"^",4)	
	s HospID=$p(SessionStr,"^",5)	
	s langid=$p(SessionStr,"^",7)	
	s:langid="" langid=..%LanguageID()

	s (QueResSourceDr,QueRBASDesc,QueRBASServiceGroupDR,QueRBASServiceGroupDesc,QueOperUser,QueDept,QueStatusCode,QueStatusDesc,QueStatusPriority,QueStatusShowDesc,QueStatusUser,QueDoc)=""
	s QueRBASDr=$lg(^User.DHCDocCureQueueD(QueId),2)
	if QueRBASDr'=""{
		s QueResSourceDr=$p(^DHCDocCureRBCResSchdule(QueRBASDr),"^",3)
		s:QueResSourceDr'="" QueRBASDesc=$p($g(^RB("RES",QueResSourceDr)),"^",17)
		s:QueResSourceDr'="" QueRBASDocDr=$p($g(^RB("RES",QueResSourceDr)),"^",2)
		s:QueRBASDocDr'="" QueRBASDesc=$p($g(^CTPCP(QueRBASDocDr,1)),"^",2)
		s QueRBASDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",QueRBASDesc,langid)
		s QueRBASServiceGroupDR=$p($g(^DHCDocCureRBCResSchdule(QueRBASDr)),"^",8)  //服务组ID
		i QueRBASServiceGroupDR'=""{
			s QueRBASServiceGroupDesc=$P($G(^DHCDocCureRBCServiceGroupSet(QueRBASServiceGroupDR)),"^",2)
			s QueRBASServiceGroupDesc=##class(User.DHCDocCureRBCServiceGroupSet).GetTranByDesc("DDCSGSDesc",QueRBASServiceGroupDesc,langid)
		}
	}
	s QuePatName=$lg(^User.DHCDocCureQueueD(QueId),3)
	s QueNo=$lg(^User.DHCDocCureQueueD(QueId),4)
	s QueDate=$lg(^User.DHCDocCureQueueD(QueId),5)
	s QueTime=$lg(^User.DHCDocCureQueueD(QueId),6)
	s QueOperUserDr=$lg(^User.DHCDocCureQueueD(QueId),7)
	if QueOperUserDr'=""{
		s QueOperUser=$p($g(^SSU("SSUSR",QueOperUserDr)),"^",2)
		s QueOperUser =##class(User.SSUser).GetTranByDesc("SSUSRName",QueOperUser,langid)
	}
	s QueDeptDr=$lg(^User.DHCDocCureQueueD(QueId),8)
	if QueDeptDr'=""{
		s QueDept=$p($g(^CTLOC(QueDeptDr)),"^",2)
		s QueDept =##class(User.CTLoc).GetTranByDesc("CTLOCDesc",QueDept,langid)
	}
	s QueStatusDr=$lg(^User.DHCDocCureQueueD(QueId),9)
	if QueStatusDr'=""{
		s QueStatusCode=$p($g(^DHCDocCurePS(QueStatusDr)),"^",1)
		s QueStatusDesc=$p($g(^DHCDocCurePS(QueStatusDr)),"^",2)
		s QueStatusDesc=##class(User.DHCDocCurePerState).GetTranByDesc("DDCPSDesc",QueStatusDesc,langid)
		s QueStatusPriority=$p($g(^DHCDocCurePS(QueStatusDr)),"^",3)
		s QueStatusShowDesc=$p($g(^DHCDocCurePS(QueStatusDr)),"^",4)
		s QueStatusShowDesc=##class(User.DHCDocCurePerState).GetTranByDesc("DDCPSShowName",QueStatusShowDesc,langid)
	}
	s QueStatusDate=$lg(^User.DHCDocCureQueueD(QueId),10)
	s QueStatusTime=$lg(^User.DHCDocCureQueueD(QueId),11)
	s QueStatusUserDr=$lg(^User.DHCDocCureQueueD(QueId),12)
	if QueStatusUserDr'=""{
		s QueStatusUser=$p($g(^SSU("SSUSR",QueStatusUserDr)),"^",2)
		s QueStatusUser =##class(User.SSUser).GetTranByDesc("SSUSRName",QueStatusUser,langid)
	}
	s QuePAPMIDr=$lg(^User.DHCDocCureQueueD(QueId),13)
	s QueDocDr=$lg(^User.DHCDocCureQueueD(QueId),14)
	if QueDocDr'=""{
		s QueDoc=$p($g(^CTPCP(QueDocDr,1)),"^",2)
		s QueDoc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",QueDoc,langid)
	}
	s QueInsertDate=$lg(^User.DHCDocCureQueueD(QueId),15)
	s QueInsertTime=$lg(^User.DHCDocCureQueueD(QueId),16)
	s QueDCApplyDr=$lg(^User.DHCDocCureQueueD(QueId),17)
	s QueReportNo=$lg(^User.DHCDocCureQueueD(QueId),18)
	s CallStatusFlag=$lg(^User.DHCDocCureQueueD(QueId),19)
	s CallUserDr=$lg(^User.DHCDocCureQueueD(QueId),20)
	
	s TimeRangeInfo=##class(DHCDoc.DHCDocCure.ScheduleTR).GetTimeRangeInfo(QueRBASDr,QueNo,SessionStr)
					
	s:QueDate'="" QueDate=..%ZD(QueDate)
	s:QueTime'="" QueTime=..%ZT(QueTime)
	s:QueStatusDate'="" QueStatusDate=..%ZD(QueStatusDate)
	s:QueStatusTime'="" QueStatusTime=..%ZT(QueStatusTime)
	s:QueInsertDate'="" QueInsertDate=..%ZD(QueInsertDate)
	s:QueInsertTime'="" QueInsertTime=..%ZT(QueInsertTime)
	d RetAry.SetAt(QueId,"QueId")
	d RetAry.SetAt(QueRBASDr,"QueRBASDr")
	d RetAry.SetAt(QueResSourceDr,"QueResSourceDr")
	d RetAry.SetAt(QueRBASDesc,"QueRBASDesc")
	d RetAry.SetAt(QueRBASServiceGroupDR,"QueRBASServiceGroupDR")
	d RetAry.SetAt(QueRBASServiceGroupDesc,"QueRBASServiceGroupDesc")
	d RetAry.SetAt(QuePatName,"QuePatName")
	d RetAry.SetAt(QueNo,"QueNo")
	d RetAry.SetAt(QueDate,"QueDate") ;预约日期
	d RetAry.SetAt(QueTime,"QueTime")
	d RetAry.SetAt(QueInsertDate,"QueInsertDate") ;队列新增日期
	d RetAry.SetAt(QueInsertTime,"QueInsertTime")
	d RetAry.SetAt(QueOperUserDr,"QueOperUserDr")
	d RetAry.SetAt(QueOperUser,"QueOperUser")
	d RetAry.SetAt(QueDeptDr,"QueDeptDr")
	d RetAry.SetAt(QueDept,"QueDept")
	d RetAry.SetAt(QueStatusDr,"QueStatusDr")
	d RetAry.SetAt(QueStatusCode,"QueStatusCode")
	d RetAry.SetAt(QueStatusDesc,"QueStatusDesc")
	d RetAry.SetAt(QueStatusPriority,"QueStatusPriority")
	d RetAry.SetAt(QueStatusShowDesc,"QueStatusShowDesc")
	d RetAry.SetAt(QueStatusDate,"QueStatusDate") ;队列最后更新日期
	d RetAry.SetAt(QueStatusTime,"QueStatusTime")
	d RetAry.SetAt(QueStatusUserDr,"QueStatusUserDr")
	d RetAry.SetAt(QueStatusUser,"QueStatusUser")
	d RetAry.SetAt(QuePAPMIDr,"QuePAPMIDr")
	d RetAry.SetAt(QueDocDr,"QueDocDr")
	d RetAry.SetAt(QueDoc,"QueDoc")
	d RetAry.SetAt(QueDCApplyDr,"QueDCApplyDr")
	d RetAry.SetAt(QueReportNo,"QueReportNo")
	d RetAry.SetAt(TimeRangeInfo,"QueTimeRangeInfo")
	d RetAry.SetAt(CallStatusFlag,"QueCallStatus")
	d RetAry.SetAt(CallUserDr,"QueCallUserDr")
	Q RetAry
}

/// Creator:nk
/// CreateDate:20221215
/// Description:获取报到数据进行打印数据提取
/// Input:
/// Output:
/// Debug:w ##class(DHCDoc.DHCDocCure.Alloc).GetPrintData(11,92,17473)
ClassMethod GetPrintData(QueId As %String, LogLocID As %String, LogUserID As %String) As %String
{
	s PrintData=""
	if QueId="" Q PrintData
	s HospID=$p($g(^CTLOC(LogLocID)),"^",22)	
	s PatientID=$lg(^User.DHCDocCureQueueD(QueId),13)
	s QueRBASDr=$lg(^User.DHCDocCureQueueD(QueId),2)
	s QueNo=$lg(^User.DHCDocCureQueueD(QueId),4)
	s QueStatusDr=$lg(^User.DHCDocCureQueueD(QueId),9)
	s:QueStatusDr'="" PerState=$p(^DHCDocCurePS(QueStatusDr),"^",1)
	S TimeRangeInfo=""
	if QueRBASDr'="" {
		s TimeRangeInfo=##class(DHCDoc.DHCDocCure.ScheduleTR).GetTimeRangeInfo(QueRBASDr,QueNo)
	}
	s QueDeptDr=$lg(^User.DHCDocCureQueueD(QueId),8)
	s QueDept=$p(^CTLOC(QueDeptDr),"^",2)
	s PatNo=##class(web.PAPatMas).GetRegistration(PatientID)
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)
	s PatSex=$p(^PAPER(PatientID,"ALL"),"^",7)
	s:PatSex'="" PatSex=$p(^CT("SEX",PatSex),"^",2)
	s PatDob=$p(^PAPER(PatientID,"ALL"),"^",6)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",HospID)

	s Param="PatNo"_$c(2)_PatNo
	s Param=Param_"^"_"PatName"_$c(2)_PatName
	s Param=Param_"^"_"PatSex"_$c(2)_PatSex
	s Param=Param_"^"_"PatNoBar"_$c(2)_"*"_PatNo_"*"
	s Param=Param_"^"_"PatientCode"_$c(2)_PatNo
	s Param=Param_"^"_"PatAge"_$c(2)_PatAge
	s Param=Param_"^"_"QueNo"_$c(2)_QueNo
	s Param=Param_"^"_"RecLoc"_$c(2)_QueDept
	s Param=Param_"^"_"TimeRangeInfo"_$c(2)_$g(TimeRangeInfo)

	
	s list=""
	s rs=##class(%ResultSet).%New("DHCDoc.DHCDocCure.Apply:FindAllCureApplyListHUI")
	if rs.QueryIsValid() {
		s Status=rs.Execute(PatientID,"","","","","","",LogLocID,LogUserID,"","","","","","")
		if 'Status Q
		while rs.Next() {
			s DCARowId=rs.GetDataByName("DCARowId")
			continue:DCARowId=""
			s OrderID=$p(^DHCDocCure(DCARowId),"^",2)
			continue:OrderID=""
			s OrdStateDr=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),1),"^",13)
			s OrdState=$p(^OEC("OSTAT",OrdStateDr),"^",1)
			continue:(OrdState="D")!(OrdState="C")!(OrdState="U")
			;continue:'$$GetNoRunExecFlag(OrderID)
			s AppChkFlag=##class(DHCDoc.DHCDocCure.AppointmentV2).CheckAppByDCA(DCARowId,"","")
			continue:AppChkFlag'=0
			s ArcimDesc=rs.GetDataByName("ArcimDesc")
			s ApplyNo=rs.GetDataByName("ApplyNo")
			s OrderOtherInfo=##class(DHCDoc.DHCDocCure.Apply).GetOrderOtherInfo(OrderID)
			s OrdDoesQty=$p(OrderOtherInfo,"^",1)
			s OrdDoesUom=$p(OrderOtherInfo,"^",3)
			s:(OrdDoesQty'="")&&(OrdDoesUom'="") OrdDoesQty=OrdDoesQty_OrdDoesUom
			s OrdFreq=$p(OrderOtherInfo,"^",7)
			s OrdDuration=$p(OrderOtherInfo,"^",11)
			if list="" s list="^"_ArcimDesc_"^"_OrdDoesQty_"^"_OrdFreq_"^"_OrdDuration_"^" ;_ ApplyNo
			else  s list=list_$c(2)_"^"_ArcimDesc_"^"_OrdDoesQty_"^"_OrdFreq_"^"_OrdDuration ;_"^"_ApplyNo
		}
	}
	if list="" q PrintData
	s PrintData=Param_$c(1)_list
	q PrintData
}

ClassMethod OnTrigger(parref As %String, type As %String) As %Status
{
	s ^tmplog("OnTrigger")=parref_"^"_type
	s $zt="AppArriveErr"
	s rtn=1
	s ParObj=##class(User.DHCDocCureQueue).%OpenId(parref)
	if $ISOBJECT(ParObj) {
		if type="TAfterIns" {
			s Status=ParObj.DDCQStatusDrGetObjectId()
			s UpUserID=ParObj.DDCQStatusUserDrGetObjectId()
			s param=parref_"^"_Status_"^"_UpUserID
			s rtn=..InsertDHCStatus(param)
			i rtn=0 s rtn=1
			else  s rtn="ERROR"_rtn
		}
		if type="TAfterUpd" {
			s NewStatus=""
			i $g(%e(9)) {
				s OldStatus=$g(%e(9))
				s NewStatus=$g(%d(9))
			}else{
				s OldStatus=""
				s NewStatus=ParObj.DDCQStatusDrGetObjectId()
			}
			i OldStatus'=NewStatus { 
				s Status=NewStatus ;ParObj.DCAAStatus
				s UpUserID=ParObj.DDCQStatusUserDrGetObjectId()
				s param=parref_"^"_Status_"^"_UpUserID
				s rtn=..InsertDHCStatus(param)
				i rtn=0 s rtn=1
				else  s rtn="ERROR"_rtn
			}
		}
	}

	Q rtn
AppArriveErr
	Q 0
}

ClassMethod InsertDHCStatus(insertinfo)
{
	s ParRef=$p(insertinfo,"^",1)
	i ParRef="" Q -1
	s Status=$p(insertinfo,"^",2)
	s UpUserID=$p(insertinfo,"^",3)
	s Date=$P($H,",",1)
	s Time=$P($H,",",2)
	&sql(insert into sqluser.DHC_DocCure_QueueStatus(QS_ParRef,QS_Date,QS_Time,QS_Status_DR,QS_UpUserID) 
	values(:ParRef,:Date,:Time,:Status,:UpUserID))
	q SQLCODE
}

}
