/// Desc:新版治疗预约,预约时不产生预约记录，产生治疗预约队列记录
/// Date:20220413
Class DHCDoc.DHCDocCure.AppointmentV2 Extends DHCDoc.Util.RegisteredObject
{

Query FindAppList(StartDate As %String, EndDate As %String, PatientID As %String, LogLocID As %String = "", LogUserID As %String = "", queryOrderLoc As %String = "", queryExpStr As %String = "", SessionStr As %String = "") As %Query(ROWSPEC = "DCARowIdStr:%String,HasLong:%String,PatientId:%String,PatientNo:%String,PatientName:%String,PatientSex:%String,OrdRecLocDr:%String,OrdRecLocLocDesc:%String,ServiceGroupDr:%String,ServiceGroup:%String")
{
}

ClassMethod FindAppListExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, PatientID As %String, LogLocID As %String = "", LogUserID As %String = "", queryOrderLoc As %String = "", queryExpStr As %String = "", SessionStr As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.AppointmentV2","FindAppList","2022-04-25","2022-06-06","","8","18881","","")
	s ^TMP("FindAppList")=$lb(StartDate,EndDate,PatientID,LogLocID,LogUserID,queryOrderLoc, queryExpStr,SessionStr)
	s:StartDate'="" StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s LogLocIDStr=##class(DHCDoc.DHCDocCure.Apply).GetLinkLoc(LogLocID)
	s cspName=$p(SessionStr,"^",1)
	s LogUserID=$p(SessionStr,"^",2)	
	s LogLocID=$p(SessionStr,"^",4)	
	s HospID=$p(SessionStr,"^",5)	
	s langid=$p(SessionStr,"^",7)	
	s:langid="" langid=..%LanguageID()
	s:LogLocID="" LogLocID=%session.Get("LOGON.CTLOCID")
	s:LogUserID="" LogUserID=%session.Get("LOGON.USERID")
	s:HospID="" HospID=%session.Get("LOGON.HOSPID")
	s (QryPatName,QryPatMedNo,QrySGroupID)=""
	if queryExpStr'=""{
		s QryPatName=$p(queryExpStr,"^",1)
		s QryPatMedNo=$p(queryExpStr,"^",2)
		s QrySGroupID=$p(queryExpStr,"^",3)
	}
	s DHCDocCureNeedTriage=##class(DHCDoc.DHCDocCure.Config).GetCureLocConfig("","CureLocNeedTriage",LogLocID,HospID)
	k DataList
	if PatientID'=""{
		;按登记号查询
		s PAAdmType="" 
		for{
			s PAAdmType=$O(^PAPERdr(PatientID,"ADM",PAAdmType)) Quit:PAAdmType=""
			s PAAdm=0
			for{
				s PAAdm=$O(^PAPERdr(PatientID,"ADM",PAAdmType,PAAdm)) Quit:PAAdm="" 
				continue:'$d(^DHCDocCure(0,"Adm",PAAdm))
				s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
				continue:AdmVisitStatus="C"
				s DCARowId=0
				for{
					s DCARowId=$o(^DHCDocCure(0,"Adm",PAAdm,DCARowId)) q:DCARowId=""
					s ApplyDate=$p(^DHCDocCure(DCARowId),"^",5)
					continue:((StartDate'="")&&(ApplyDate<StartDate))!((EndDate'="")&&(ApplyDate>EndDate))
					s QuitFlag=$$CheckQuit()
					continue:QuitFlag'=0
					d GetOutputRowData
				}
			}
		}
	}
	elseif QryPatName'=""{
		;按姓名查询
		s QryPatName=$tr(QryPatName," ","")
		s QryPatName=$zcvt(QryPatName,"U")
		s PersonRowId=""
		for{
			s PersonRowId=$o(^PAPERi("PAPER_PatName",QryPatName,PersonRowId)) q:PersonRowId=""
			s PAAdmType="" 
			for{
				s PAAdmType=$O(^PAPERdr(PersonRowId,"ADM",PAAdmType)) Quit:PAAdmType=""
				s PAAdm=0
				for{
					s PAAdm=$O(^PAPERdr(PersonRowId,"ADM",PAAdmType,PAAdm)) Quit:PAAdm="" 
					continue:'$d(^DHCDocCure(0,"Adm",PAAdm))
					s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
					continue:AdmVisitStatus="C"
					s DCARowId=0
					for{
						s DCARowId=$o(^DHCDocCure(0,"Adm",PAAdm,DCARowId)) q:DCARowId=""
						s ApplyDate=$p(^DHCDocCure(DCARowId),"^",5)
						continue:((StartDate'="")&&(ApplyDate<StartDate))!((EndDate'="")&&(ApplyDate>EndDate))
						s QuitFlag=$$CheckQuit()
						continue:QuitFlag'=0
						d GetOutputRowData
					}
				}
			}
		}
	}
	else{
		s:StartDate="" StartDate=+$h
		s:EndDate="" EndDate=+$h
		for looploc=1:1:$l(LogLocIDStr,"^"){
			s LogLocID=$p(LogLocIDStr,"^",looploc)
			for QueryDate=StartDate:1:EndDate{
				s DCARowId=""
				for{
					s DCARowId=$o(^DHCDocCure(0,"RecDate",LogLocID,QueryDate,DCARowId))
					Q:DCARowId=""
					s QuitFlag=$$CheckQuit()
					Set CureData=$g(^DHCDocCure(DCARowId))
					s ApplyNo=$p(CureData,"^",18)
					;s ^tmplog("QuitFlag",ApplyNo)=QuitFlag
					continue:QuitFlag'=0
					d GetOutputRowData
				}
			}
		}
	}
	d OutputRowData
	Quit $$$OK
OutputRowData
	s PatId="" 
	for {
		s PatId=$o(DataList(PatId))
		q:PatId=""
		s SGId="" 
		for{
			s SGId=$o(DataList(PatId,SGId))
			q:SGId=""
			s qHandle($I(ind))=$g(DataList(PatId,SGId))
		}
	}
	Quit
CheckQuit()
	s QuitFlag=1
	s OrderId=$p(^DHCDocCure(DCARowId),"^",2)
	if OrderId=""{
		s QuitFlag=10
		Q QuitFlag
	}
	s Adm=$p(^DHCDocCure(DCARowId),"^",1)
	s AdmType=$P(^PAADM(Adm),"^",2)
	s AdmLocId=$P(^PAADM(Adm),"^",4)
	s PapmiDr=$p($g(^PAADM(Adm)),"^",1)
	if (PatientID'="")&&(PatientID'=PapmiDr){
		s QuitFlag=11
		Q QuitFlag
	}
	
	s PapmiName=$zcvt($P(^PAPER(PapmiDr,"ALL"),"^",1),"U")
	s PapmiName2=$zcvt($P(^PAPER(PapmiDr,"ALL"),"^",2),"U")
	if (QryPatName'="")&&(PapmiName'=QryPatName)&&(PapmiName2'=QryPatName){
		s QuitFlag=12
		Q QuitFlag
	}
	
	if (QryPatMedNo'=""){
		s PatientMedicare=##class(web.DHCDocOrderCommon).GetMrNo("",PapmiDr,AdmType,"")
		if (PatientMedicare'=QryPatMedNo){
			s QuitFlag=13
			Q QuitFlag
		}
	}
	s OrderAddDeptDr=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),7)),"^",2)
	if (queryOrderLoc'="")&&(queryOrderLoc'=OrderAddDeptDr){
		s QuitFlag=14
			Q QuitFlag	
	}
	s OrderAddDocDr=""
	s OrderAddUserDr=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),7)),"^",1)
	if OrderAddUserDr'=""{
		s OrderAddDocDr=$p($g(^SSU("SSUSR",OrderAddUserDr)),"^",14)
	}
	
	s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByOrd(OrderId,HospID)
	if DDCISRowid=""{
		s QuitFlag=15
		Q QuitFlag
	}
	s ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
	if ServiceGroupDR=""{
		s QuitFlag=16
		Q QuitFlag
	}
	if (QrySGroupID'="")&&(ServiceGroupDR'=QrySGroupID){
		s QuitFlag=16
		Q QuitFlag
	}
	s OrdReLocId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3)),"^",6)
	if (LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_OrdReLocId_"^")){
		s QuitFlag=17
		Q QuitFlag
	}
	
	s AppChkFlag=..CheckAppByDCA(DCARowId,"",HospID)
	if AppChkFlag'=0{
		s QuitFlag=AppChkFlag
		Q QuitFlag
	}
	
	s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	s QuitFlag=0
	s ApplyPermission=##class(DHCDoc.DHCDocCure.Apply).CheckCureApplyPermission(DCARowId,OrdReLocId,LogUserID,LogLocIDStr)
	s:'(ApplyPermission) QuitFlag=18

	;已撤销、已完成 均未勾选
	if (DHCDocCureNeedTriage=1){
		s ChkApplyStatus="^D^"
	}else{
		s ChkApplyStatus="^A^D^"
	}
	s:(ChkApplyStatus'[ApplyStatus) QuitFlag=19
	q QuitFlag
GetOutputRowData
	s RowId=DCARowId
	s Priority=$p(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1),"^",8)
	s IsLong=##class(appcom.OEOrdItem).ISLongOrderPrior(Priority)
	s PatSex=""
	s PatNo=##class(web.PAPatMas).GetRegistration(PapmiDr)
	s PatName=$p(^PAPER(PapmiDr,"ALL"),"^",1)
	s PatSexDr=$p(^PAPER(PapmiDr,"ALL"),"^",7)
	s:PatSexDr'="" PatSex=$p(^CT("SEX",PatSexDr),"^",2)
	s PatSex =##class(User.CTSex).GetTranByDesc("CTSEXDesc",PatSex,langid)
	s ServiceGroup=$p(^DHCDocCureRBCServiceGroupSet(ServiceGroupDR),"^",2)
	s ServiceGroup =##class(User.DHCDocCureRBCServiceGroupSet).GetTranByDesc("DDCSGSDesc",ServiceGroup,langid)
	s OrdReLocDesc=$p(^CTLOC(OrdReLocId),"^",2)	
	s OrdReLocDesc =##class(User.CTLoc).GetTranByDesc("CTLOCDesc",OrdReLocDesc,langid)
	if $d(DataList(PapmiDr,ServiceGroupDR)) {
		s Info=$g(DataList(PapmiDr,ServiceGroupDR))
		s RowIdStr=$lg(Info,1)_"!"_RowId
		s HasLong=$lg(Info,2)
		s:IsLong HasLong=IsLong
		s DataList(PapmiDr,ServiceGroupDR)=$lb(RowIdStr,HasLong,PapmiDr,PatNo,PatName,PatSex,OrdReLocId,OrdReLocDesc,ServiceGroupDR,ServiceGroup)
	}else{
		s DataList(PapmiDr,ServiceGroupDR)=$lb(RowId,IsLong,PapmiDr,PatNo,PatName,PatSex,OrdReLocId,OrdReLocDesc,ServiceGroupDR,ServiceGroup)
	}
	Quit
}

ClassMethod FindAppListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAppListExecute ]
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

/// w ##class(DHCDoc.DHCDocCure.Appointment).CheckAppByDCA("622","937","M","12618","2")
ClassMethod CheckAppByDCA(DCARowId As %String, RBASId As %String, LogHospID As %String, TRTimeRange As %String = "", ByRef ErrMsg As %String = "")
{
	s rtn=100
	;检查基本参数
	if (DCARowId=""){
		s ErrMsg="治疗申请ID为空"
		Q rtn
	}
	s DCAOEORIDR="",Adm="",DCAStatus=""
	Set object = ##class(User.DHCDocCureApp).%OpenId(DCARowId,0,.sc)
	i $IsObject(object) {
		Set DCAOEORIDR=object.DCAOEORIDR.%Id()
		Set Adm=object.DCAAdmDR.%Id()
		Set DCAStatus=object.DCAStatus
		Set DCAApplyExecFlag=object.DCAApplyExec
	}
	d object.%Close()
	if DCAOEORIDR=""{
		s ErrMsg="治疗申请医嘱错误"
		Q rtn
	}
	
	s ArcimId=$p(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),1),"^",2)
	s OrderBilled=$p(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),3),"^",5)
	s PriorityDR=$p($g(^OEORD(+DCAOEORIDR,"I",+$p(DCAOEORIDR,"||",2),1)),"^",8)
	s OrderAddDeptDr="",HospID=""
	s OrderAddDeptDr=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),7)),"^",2)
	if OrderAddDeptDr'="" {
		s HospID=$p($g(^CTLOC(OrderAddDeptDr)),"^",22)	
	}
	s:HospID'="" LogHospID=HospID
	
	;就诊类型检查
	s rtn=##class(DHCDoc.DHCDocCure.Appointment).CheckAdmType(Adm,DCAOEORIDR)
	if rtn'=0{
		if rtn="108"{
			s ErrMsg="该申请医嘱未缴费,无法预约"
		}elseif rtn="1081"{
			s ErrMsg="该患者已出院,无法预约"
		}elseif rtn="1082"{
			s ErrMsg="该患者就诊已退号,无法预约"
		}
		Q rtn
	}
	
	;检查医嘱信息，目前只有临时医嘱可预约
	s ISShortFlag=##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR)
	if ('ISShortFlag){
		;s rtn="109",ErrMsg="非临时医嘱,无法预约"
		;Q rtn
	}
	
	;检查治疗申请单信息	
	;撤销的不可预约
	if DCAStatus="C"{
		s rtn="-1101",ErrMsg="治疗申请已撤消,无法预约"
		Q rtn
	}
	;未配置治疗医嘱项的不可预约
	s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(ArcimId,LogHospID)
	if DDCISRowid=""{
		s rtn="-1102",ErrMsg="非治疗医嘱项目,无法预约"
		Q rtn
	}
	;直接执行的不允许预约
	if (DCAApplyExecFlag="Y"){
		s rtn="-1103",ErrMsg="直接执行的治疗医嘱项目,无法预约"
		Q rtn
	}else{
		s OrderStatus="",OrderStatusCode=""
		s OrdStatusDR=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),1)),"^",13)
		s:OrdStatusDR'="" OrderStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1),OrderStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2)
		if (OrderStatusCode'="V") && (OrderStatusCode'="E") {
			s rtn="-1104",ErrMsg="医嘱非核实状态,无法预约"
			Q rtn
		}	
	}
	
	;判断申请单已经预约的数量
	if ISShortFlag{
		s DCAOrderDoseQty=##class(DHCDoc.DHCDocCure.Appointment).GetDCADoseAppQty(DCARowId,LogHospID)
		s ActiveQtyStr=##class(DHCDoc.DHCDocCure.Apply).GetOrderActiveQty(DCAOEORIDR)
		s OrderQty=$p(ActiveQtyStr,"^",1)
		s ApplyAppInfo=##class(DHCDoc.DHCDocCure.Appointment).GetApplyAppInfo(DCARowId)
		s ApplyAppedTimes=+$p(ApplyAppInfo,"^",1)
		s ApplyNoAppTimes=+OrderQty-ApplyAppedTimes
		if +ApplyNoAppTimes=0
		{
			s rtn="-1105",ErrMsg="该申请单包含的项目数量已经约完,无法预约"
			Q rtn
		}
		if ApplyNoAppTimes<DCAOrderDoseQty
		{
			s rtn="-1106",ErrMsg="该申请单可预约数量不足,无法预约"
			Q rtn
		}
	}
	//如果执行记录都执行了 就不显示
	s execflag = 0
	s ordexecsub = 0 
	for{
		s ordexecsub = $o(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),"X",ordexecsub)) 
		q:(ordexecsub="")||(execflag=1)
		s OEOREStatus = $p(^(ordexecsub),"^",16)
		s OEOREStatusCode=""
		s:OEOREStatus'="" OEOREStatusCode=$p(^OEC("STAT",OEOREStatus),"^",1),OEOREStatus=$p(^OEC("STAT",OEOREStatus),"^",2)
		if (OEOREStatusCode="")!(OEOREStatusCode="C"){
			s execflag=1	
		}
	}
	if (execflag = 0) {
		s rtn="-1107",ErrMsg="执行记录已全部执行完成,无法预约"
		Q rtn
	}
	if RBASId'=""{
		s ChkRet=..CheckAppSchedule(RBASId,TRTimeRange,"",.ErrMsg)
		if ChkRet'=0{
			Q ChkRet	
		}
	}
    
	Q 0
}

/// 查询预约记录
/// ;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.AppointmentV2","FindAppointmentList","143","Y","")
Query FindAppointmentList(PatientId As %String, OnlyApp As %String = "", AppDate As %String = "", ResSchduleId As %String = "", SessionStr As %String = "", ExpStr As %String = "") As %Query(ROWSPEC = "QueId:%String,QueDept:%String,QueDate:%String,ResDesc:%String,ASDate:%String,TimeRange:%String,SchedStTime:%String,SchedEdTime:%String,DDCRSStatus:%String,QueOperUser:%String,QueStatusDate:%String,DCAAStatus:%String,PatNo:%String,PatName:%String,QueNo:%String")
{
}

ClassMethod FindAppointmentListExecute(ByRef qHandle As %Binary, PatientId As %String, OnlyApp As %String = "", AppDate As %String = "", ResSchduleId As %String = "", SessionStr As %String = "", ExpStr As %String = "") As %Status
{
	if (PatientId="")&&(ResSchduleId=""){
		Quit $$$OK
	}
	
	if AppDate'="" s AppDate=##class(websys.Conversions).DateHtmlToLogical(AppDate)
	else  s AppDate="" ;+$h
	s cspName=$p(SessionStr,"^",1)	
	s LogLocID=$p(SessionStr,"^",4)
	s HospID=$p(SessionStr,"^",5)	
	s langid=$p(SessionStr,"^",7)	
	s:langid="" langid=..%LanguageID()
	s inTimeRange=$p(ExpStr,"^",1)
	s LogLocIDStr=""
	s QueId=0 
	if PatientId'=""{
		s LogLocIDStr=##class(DHCDoc.DHCDocCure.Apply).GetLinkLoc(LogLocID)
		for{
			s QueId=$o(^User.DHCDocCureQueueI("IndexPAPMI",PatientId,QueId))
			q:QueId=""
			d GetOneQue
		}
	}else{
		for{
			s QueId=$o(^User.DHCDocCureQueueI("IndexRBAS",ResSchduleId,QueId))
			q:QueId=""
			d GetOneQue
		}
	}
		
	Quit $$$OK
GetOneQue
	s PatientID=$lg(^User.DHCDocCureQueueD(QueId),13)
	s QueDate=$lg(^User.DHCDocCureQueueD(QueId),5)
	s QueDeptDr=$lg(^User.DHCDocCureQueueD(QueId),8)
	s QueStatusDr=$lg(^User.DHCDocCureQueueD(QueId),9)
	s QueStatusCode=""
	if QueStatusDr'=""{
		s QueStatusCode=$p($g(^DHCDocCurePS(QueStatusDr)),"^",1)
		s QueStatusDesc=$p($g(^DHCDocCurePS(QueStatusDr)),"^",2)
	}
	Q:(LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_QueDeptDr_"^"))
	Q:(AppDate'="")&&(QueDate'=AppDate)
	Q:(OnlyApp="Y")&&("Cancel Complete"[QueStatusCode)
	if inTimeRange'=""{
		s QueRBASDr=$lg(^User.DHCDocCureQueueD(QueId),2)
		s QueNo=$lg(^User.DHCDocCureQueueD(QueId),4)
		s QueTimeRangeInfo=##class(DHCDoc.DHCDocCure.ScheduleTR).GetTimeRangeInfo(QueRBASDr,QueNo)
		s getTimeRange=$p(QueTimeRangeInfo, " ",2)
		if getTimeRange'=""{
			s getTimeRange=$p(getTimeRange, "(",1)
			s inSttTime=$zth($p(inTimeRange, "-",1),1)
			s inEndTime=$zth($p(inTimeRange, "-",2),1)
			s getSttTime=$zth($p(getTimeRange, "-",1),1)
			s getEndTime=$zth($p(getTimeRange, "-",2),1)
			if (getSttTime>inSttTime)!(getEndTime<inEndTime){
				Q	
			}
		}
	}
	d OutputAppoint
	Q
OutputAppoint
	s QueAry=##class(DHCDoc.DHCDocCure.Alloc).GetQueueAry(QueId,SessionStr)
	if QueAry.%Size()>0 {
		s PatNo=$P($g(^PAPER(PatientID,"PAT",1)),"^",1)
		s PatName=QueAry.Get("QuePatName")
		s QueDate=QueAry.Get("QueDate")
		s QueTime=QueAry.Get("QueTime")
		s QueNo=QueAry.Get("QueNo")
		s QueDeptDr=QueAry.Get("QueDeptDr")
		s QueRBASDr=QueAry.Get("QueRBASDr")
		s QueDept=QueAry.Get("QueDept")
		s QueStatusDr=QueAry.Get("QueStatusDr")
		s QueStatusCode=QueAry.Get("QueStatusCode")
		s ResId=QueAry.Get("QueResSourceDr")
		s ResDesc=QueAry.Get("QueRBASDesc")
		s QueTimeRangeInfo=QueAry.Get("QueTimeRangeInfo")
		s TimeRange=$p(QueTimeRangeInfo, " ",2)
		s ASDate=$p(QueTimeRangeInfo, " ",1)
		s ASData=##class(DHCDoc.DHCDocCure.RBCResSchdule).GetResApptSchuldeInfo(QueRBASDr,langid)
		s SchedStTime=$p(ASData,"^",8)
		s SchedEdTime=$p(ASData,"^",9)
		s DDCRSStatus=$p(ASData,"^",12)
		s DCAAStatus=$case(QueStatusCode,
		"Cancel":..%Translate(cspName,"取消预约",langid),
		"Complete":..%Translate(cspName,"已治疗",langid),
		:..%Translate(cspName,"已预约",langid))
		s QueOperUserDr=QueAry.Get("QueOperUserDr")
		s QueOperUser=QueAry.Get("QueOperUser")
		s QueStatusDate=QueAry.Get("QueStatusDate")
		s QueStatusTime=QueAry.Get("QueStatusTime")
		s QueStatusDate=QueStatusDate_" "_QueStatusTime
		s Data=$lb(QueId,QueDept,QueDate,ResDesc,ASDate,TimeRange,SchedStTime,SchedEdTime,DDCRSStatus,QueOperUser,QueStatusDate,DCAAStatus,PatNo,PatName,QueNo)
	 	s qHandle($I(ind))=Data
	}
 	quit
}

ClassMethod FindAppointmentListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAppointmentListExecute ]
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

ClassMethod CheckAppSchedule(RBASId As %String, TRTimeRange As %String, LongFlag As %String = "", ByRef ErrMsg As %String = "")
{
	s rtn=0
	if '$d(^DHCDocCureRBCResSchdule(RBASId)){
		s rtn="-1000",ErrMsg="无效排班"
		Q rtn
	}
	s RBCResSchData=$g(^DHCDocCureRBCResSchdule(RBASId))
	s DDCRSDate=$p(RBCResSchData,"^",4)
	s DDCRSStatus=$p(RBCResSchData,"^",9)
	s DDCRSMaxNumber=$p(RBCResSchData,"^",10)
	s DDCRSTimeRangeDR=$p(RBCResSchData,"^",5)
	s DDCRSSeqNoStr=$p(RBCResSchData,"^",21)
	s DDCRSEndAppointTime=$p(RBCResSchData,"^",22)
	s StartTime=$p($g(^DHCDocCureRBCTimePeriodSet(DDCRSTimeRangeDR)),"^",3)
	s EndTime=$p($g(^DHCDocCureRBCTimePeriodSet(DDCRSTimeRangeDR)),"^",4)
	s EndAppointTime=$p($g(^DHCDocCureRBCTimePeriodSet(DDCRSTimeRangeDR)),"^",7)
	if DDCRSEndAppointTime'="" s EndAppointTime=DDCRSEndAppointTime
	if EndAppointTime="" s EndAppointTime=EndTime
	if LongFlag="1",DDCRSDate'=+$h {
		s rtn="-1001",ErrMsg="存在长期医嘱,只能预约当天的排班."
		Q rtn
	}
	
	;停诊的资源则不能预约
	if (DDCRSStatus'="N")
	{ 
		s rtn="-1002",ErrMsg="该治疗资源排程已停诊,无法预约"
		Q rtn
	}
	if (DDCRSDate<+$h)||((EndAppointTime'="")&&(DDCRSDate=+$h)&&(EndAppointTime<$p($h,",",2)))
	{
		s rtn="-1003",ErrMsg="该治疗资源排程已过截止预约时间,无法预约"
		Q rtn
	}
	;判断最大预约数是否已经预约完
	s AppedNumber=##class(DHCDoc.DHCDocCure.Appointment).GetRBCResSchduleAppedNum(RBASId)
	if DDCRSMaxNumber=$l(DDCRSSeqNoStr,","),DDCRSSeqNoStr'="" {
		s rtn="-1004",ErrMsg="该治疗资源排程已预约完,无法预约"
		Q rtn
	}
	
	if +AppedNumber=DDCRSMaxNumber{
		s rtn="-1004",ErrMsg="该治疗资源排程已预约完,无法预约"
		Q rtn
	}
    if (TRTimeRange '= "") {
        s trAvailQty = ##class(DHCDoc.DHCDocCure.ScheduleTR).GetOneTRAvailQty(RBASId, TRTimeRange)
        // 当前时段无可预约号序
        if (trAvailQty = 0) {
            s rtn = "-1005",ErrMsg="该治疗资源排程所选择的分时段已预约完,无法预约"
            q rtn
        }
    }
    Q rtn
}

/// w ##class(DHCDoc.DHCDocCure.Appointment).CheckBeforeAppInsert("622","937","M","12618","2")
ClassMethod CheckBeforeAppInsert(PatientID As %String, RBASId As %String, LogHospID As %String, LongFlag As %String = "", TRTimeRange As %String = "", ByRef ErrMsg As %String = "")
{
	s rtn=100,ErrMsg=""
	;检查基本参数
	if (PatientID="")||(RBASId=""){
		s ErrMsg="缺少必要参数"
		Q rtn
	}
	
	s ChkRet=..CheckAppSchedule(RBASId,TRTimeRange,LongFlag,.ErrMsg)
	if ChkRet'=0{
		Q ChkRet	
	}
    
    s QueId=..GetAppQueID(PatientID,RBASId)
	if QueId'="" {
		s rtn="-1006",ErrMsg="该患者已预约过该排班,无法预约"
		Q rtn
	}
	Q 0
}

/// w ##class(DHCDoc.DHCDocCure.AppointmentV2).AppInsertBroker("")
ClassMethod AppInsertBroker(InsJson)
{
	s InsAry=##class(DHCDoc.Util.FromXML).Json2Arr(InsJson)
	s PatientID=InsAry.Get("PatientID")
	s RBASId=InsAry.Get("RBASId")
	s RegType=InsAry.Get("RegType")
	s LongFlag=InsAry.Get("LongFlag")
	s TimeRange=InsAry.Get("TimeRange")
	s DCARowID=InsAry.Get("DCARowID")
	s ExpStr=InsAry.Get("ExpStr")
	s ret=..AppInsert(PatientID,RBASId,RegType,LongFlag, TimeRange, DCARowID,ExpStr,.ErrMsg)
	s RowId=$p(ret,"^",2)
	s ret=$p(ret,"^",1)
	s RetAry=##class(DHCDoc.Util.ArrayData).%New()
	d RetAry.SetAt(RowId,"RowId")
	d RetAry.SetAt(ret,"ret")
	d RetAry.SetAt(ErrMsg,"ErrMsg")
	
	s JsonStr=##class(DHCDoc.Util.FromXML).Arr2Json(RetAry).Read()
	
	Q JsonStr
}

/// Desc:治疗预约,插入对列表，不产生预约表
/// Input:PatientID 患者ID;RBASId 排程ID;RegType 预约途径;UserId 用户ID;TimeRange 分时段信息;ExpStr 扩展信息
/// w ##class(DHCDoc.DHCDocCure.AppointmentV2).AppInsert("143","2110","0","0","","391","17473^275^2")
ClassMethod AppInsert(PatientID As %String, RBASId As %String, RegType As %String, LongFlag As %String, TimeRange As %String = "", DCARowID As %String = "", ExpStr As %String = "", ByRef ErrMsg As %String = "") As %String
{
	s ^tmplog("AppInsert")=$lb(PatientID, RBASId, RegType, LongFlag, TimeRange, DCARowID,ExpStr)
	s (UserId,LogGroupId,LogHospID)=""
	if ExpStr'=""{
		s UserId=$p(ExpStr,"^",1)	
		s LogGroupId=$p(ExpStr,"^",2)
		s LogHospID=$p(ExpStr,"^",3)
	}
	if (PatientID="")&&(DCARowID'=""){
		s PAAdmID=$p($g(^DHCDocCure(DCARowID)),"^",1)
		s PatientID=$P($G(^PAADM(PAAdmID)),"^",1)	
	}
	s rtn=0
	s rtn=..CheckBeforeAppInsert(PatientID,RBASId,LogHospID,LongFlag,TimeRange,.ErrMsg)
	if rtn'=0{
		Q rtn	
	}
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)
	s DDCRSDate=$p($g(^DHCDocCureRBCResSchdule(RBASId)),"^",4)
	s ResId=$p($g(^DHCDocCureRBCResSchdule(RBASId)),"^",3)
	s DDCRSDate=$p($g(^DHCDocCureRBCResSchdule(RBASId)),"^",4)
	s DDCRSLocID=$p(^RB("RES",ResId),"^",1)
	s CurrDate=..%SysDate()
	s CurrTime=..%SysTime()
	
	s ReportStateId=""
	s LocNeedReport=##class(DHCDoc.DHCDocCure.Config).GetCureLocConfig("","CureLocNeedReport",DDCRSLocID,LogHospID)
	s CureAppCurDateWait=##Class(DHCDoc.DHCDocCure.Config).GetCureConfigPara("CureAppCurDateWait",LogHospID)
	if LocNeedReport="1" {
		if (DDCRSDate=+$h)&&(CureAppCurDateWait=1){
			;预约当日直接置等候,可走配置
			s ReportStateCode="Wait"
		}else{
			s ReportStateCode="Report"
		}
	}else {
		s ReportStateCode="Wait"
	}
	s ReportStateId=##class(DHCDoc.DHCDocCure.CureCall).GetCurePerStateId(ReportStateCode)
	if ReportStateId=""{
		s rtn="-1101",ErrMsg="获取队列状态失败"
		Q rtn
	}
	
	s DDCRSSeqNoStr=$p($g(^DHCDocCureRBCResSchdule(RBASId)),"^",21)
	s SeqNo=0
	Lock +^DHCDocCureRBCResSchduleLOCK(RBASId):10
    if $test {
		s SeqNo=##class(DHCDoc.DHCDocCure.ScheduleTR).GetSeqNo(RBASId,TimeRange,RegType)
    }
    if SeqNo=0 {
		Lock -^DHCDocCureRBCResSchduleLOCK(RBASId)
		s rtn="-1102",ErrMsg="取号失败"
		Q rtn
	}else {
        s DDCRSSeqNoStr=$s(DDCRSSeqNoStr="" : SeqNo, 1 : DDCRSSeqNoStr_","_SeqNo)
    }
    Ts
	s RowId=""
	k QueList
	s QueList(2)=RBASId
	s QueList(3)=PatName
	s QueList(4)=SeqNo
	s QueList(5)=DDCRSDate
	s QueList(6)=CurrTime
	s QueList(7)=UserId
	s QueList(8)=DDCRSLocID
	s QueList(9)=ReportStateId
	s QueList(10)=CurrDate
	s QueList(11)=CurrTime
	s QueList(12)=UserId
	s QueList(13)=PatientID
	s QueList(14)=""
	s QueList(15)=CurrDate
	s QueList(16)=CurrTime
	s QueList(17)=DCARowID
	&sql(insert into SQLUser.DHC_DocCure_Queue values :QueList())

	if SQLCODE {
		Tro
		s rtn="-1103",ErrMsg="插入队列表失败!"_SQLCODE
	}else{
		s RowId=%ROWID
		//更新排班资源号源
		&sql(Update SQLUser.DHC_DocCureRBCResSchdule set DDCRS_SeqNoStr=:DDCRSSeqNoStr where DDCRS_RowID=:RBASId)
		if SQLCODE
		{
			Tro
			s rtn=SQLCODE
			s rtn="-1104",ErrMsg="更新排班资源号源是新失败!"_SQLCODE
		}
	
	}
	Lock -^DHCDocCureRBCResSchduleLOCK(RBASId)
	if rtn=0{
		Tc	
	}
	
	s Para=PatientID_"^^"_$g(RowId)_"^"_"CUREBK"_"^"_UserId
	Job ##class(DHCDoc.DHCDocCure.Invoke).InputDataToCDR(Para)
	q rtn_"^"_RowId
}

/// w ##class(DHCDoc.DHCDocCure.AppointmentV2).AppInsertBroker("")
ClassMethod AppCancelBatch(RowIdStr As %String, UserDR As %String, SessionStr As %String)
{
	s retStr=""
	s cspName=$p(SessionStr,"^",1)	
	s HospID=$p(SessionStr,"^",5)	
	s langid=$p(SessionStr,"^",7)	
	s:langid="" langid=..%LanguageID()
	s IdStrLen=$l(RowIdStr,"^")
	for count=1:1:IdStrLen{
		s QueId=$p(RowIdStr,"^",count)
		s ErrMsg=""
		s ret=..AppCancel(QueId,UserDR,.ErrMsg)
		if ret'=0{	
			s QueDate=$lg(^User.DHCDocCureQueueD(QueId),5)
			s QueDate=..%ZD(QueDate)
			s ErrMsg=..%Translate(cspName,"预约治疗日期:",langid)_QueDate_" "_..%Translate(cspName,ErrMsg,langid)
			if retStr="" s retStr=ErrMsg
			else  s retStr=retStr_";<br>"_ErrMsg
		}
	}
	q retStr
}

ClassMethod AppCancel(QueId As %String, UserId As %String, ByRef ErrMsg As %String = "") As %String
{
	s ^tmplog("AppCancel")=$lb(QueId,UserId)
	s ErrMsg=""
	if UserId="",$d(%session) s UserId=%session.Data("LOGON.USERID")
	if (QueId="")!(UserId="") {
		s ErrMsg="缺少必要参数"
		q "-101"
	}
	s QueInfo=$g(^User.DHCDocCureQueueD(QueId))
	s QueNo=$lg(QueInfo,4)
	s QueASRowId=$lg(QueInfo,2)
	s QueDate=$lg(QueInfo,5)
	s QueDeptDr=$lg(QueInfo,8)
	s QueStateDr=$lg(QueInfo,9)
	s QueStateCode=$p($g(^DHCDocCurePS(QueStateDr)),"^",1)
	if QueStateCode="Cancel" {
		s ErrMsg="该预约记录已取消预约"
		q "-102"
	}
	if QueStateCode="Complete" {
		s ErrMsg="该预约记录已完成"
		q "-102"
	}
	
	s LocNeedReport=##class(DHCDoc.DHCDocCure.Config).GetCureLocConfig("","CureLocNeedReport",QueDeptDr)
	if LocNeedReport="1",QueStateCode'="Report",QueDate=+$h {
		s ErrMsg="该预约记录已报到，请先取消报到"
		q "-103"
	}
	s CancelState=##class(DHCDoc.DHCDocCure.CureCall).GetCurePerStateId("Cancel")
	if $g(CancelState)="" {
		s ErrMsg="获取取消队列状态失败"
		q "-104"
	}
	s CurrDate=..%SysDate()
	s CurrTime=..%SysTime()
	Ts
	;修改状态
	&sql(update SQLUser.DHC_DocCure_Queue 
		set DDCQ_Status_Dr=:CancelState,DDCQ_StatusDate=:CurrDate,DDCQ_StatusTime=:CurrTime,DDCQ_StatusUser_Dr=:UserId 
		where ID=:QueId)
	if SQLCODE {
		Tro
		s ErrMsg="更新队列状态失败_"_SQLCODE
		q "-105"
	}
	;回归号源池
	s ResRet=##class(DHCDoc.DHCDocCure.ScheduleTR).RestoreSeqNo(QueASRowId,QueNo)
	if ResRet'=0 {
		Tro
		s ErrMsg="回归号源失败_"_ResRet
		q "-106"
	}
	Tc
	q 0
}

ClassMethod GetAppQueID(PatientId As %String, ASRowId As %String) As %String
{
	s HasQueId=""
	s QueId=0 
	for{
		s QueId=$o(^User.DHCDocCureQueueI("IndexPAPMI",PatientId,QueId))
		q:QueId=""
		s SchedId=$lg(^User.DHCDocCureQueueD(QueId),2)
		continue:SchedId'=ASRowId
		s StateDr=$lg(^User.DHCDocCureQueueD(QueId),9)
		s State=$p(^DHCDocCurePS(StateDr),"^",1)
		continue:State="Cancel"
		s HasQueId=QueId
		q
	}
	q HasQueId
}

ClassMethod GetRBResAppCount(ARBASDR As %String)
{
	s Appcount=0
	Q:ARBASDR="" Appcount
	s QueId=0 
	for{
		s QueId=$o(^User.DHCDocCureQueueI("IndexRBAS",ARBASDR,QueId))
		q:QueId=""
		s QueStatusDr=$lg(^User.DHCDocCureQueueD(QueId),9)
		s QueStatusCode=$p($g(^DHCDocCurePS(QueStatusDr)),"^",1)
		continue:QueStatusCode="Cancel"
		s Appcount=Appcount+1
	}
	q Appcount
}

/// Creator:nk
/// CreateDate:
/// Description:获取预约单打印数据(all)
/// Input:
/// Output:
/// Debug:w ##class(DHCDoc.DHCDocCure.AppointmentV2).GetPrintData(143,92,1)
ClassMethod GetPrintData(PatId As %String, LogLocID As %String, IDStr As %String = "") As %String
{
	k QueList
	s QueId=0 
	for{
		s QueId=$o(^User.DHCDocCureQueueI("IndexPAPMI",PatId,QueId))
		q:QueId=""
		continue:(IDStr'="")&&(("^"_IDStr_"^")'[("^"_QueId_"^"))
		s QueStatusDr=$lg(^User.DHCDocCureQueueD(QueId),9)
		continue:QueStatusDr=""
		s QueStatusCode=$p($g(^DHCDocCurePS(QueStatusDr)),"^",1)
		continue:QueStatusCode="Cancel"
		s QueDate=$lg(^User.DHCDocCureQueueD(QueId),5)
		continue:(IDStr="")&&(QueDate<+$h)
		s QueDeptDr=$lg(^User.DHCDocCureQueueD(QueId),8)
		s QueDepDesc=$p(^CTLOC(QueDeptDr),"^",2)
		s QueNo=$lg(^User.DHCDocCureQueueD(QueId),4)
		s QueASRowId=$lg(^User.DHCDocCureQueueD(QueId),2)
		s QueRBResDr=$p(^DHCDocCureRBCResSchdule(QueASRowId),"^",3)
		s ResDesc=$p(^RB("RES",QueRBResDr),"^",17)
		s TimeRange=##class(DHCDoc.DHCDocCure.ScheduleTR).GetTimeRangeInfo(QueASRowId,QueNo)
		s List="^"_QueDepDesc_"^"_ResDesc_"^"_TimeRange_"^"
		s QueList(QueDate,QueDeptDr,QueId)=List
	}
	
	if '$d(QueList){
		q ""
	}
	s HospID=$p(^CTLOC(QueDeptDr),"^",22)
	;Para 取值
	s PatName=$p(^PAPER(PatId,"ALL"),"^",1)
	s PatSex=$p(^PAPER(PatId,"ALL"),"^",7)
	s:PatSex'="" PatSex=$p(^CT("SEX",PatSex),"^",2)	
	s PatDob=$p(^PAPER(PatId,"ALL"),"^",6)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatId,"",HospID)
	s (ward,warddesc,admdoc,admdocdesc,diag)=""
	s Bed=$p($$GetBed(PatId),"^",1)
	s PaadmRowId = $p($$GetBed(PatId),"^",2)
	if PaadmRowId'=""{
		s ward = $p(^PAADM(PaadmRowId),"^",70)
		s warddesc = $p(^PAWARD(ward),"^",2)
		s admdoc = $p(^PAADM(PaadmRowId),"^",9)
		s admdocdesc = $p(^CTPCP(admdoc,1),"^",2)
		s diag = ##class(DHCDoc.Diagnos.Common).GetAdmDiagDesc(PaadmRowId)
	}
	s PatNo=##class(web.PAPatMas).GetRegistration(PatId)
	s PatTel=$p($g(^PAPER(PatId,"PER",1)),"^",11)
	s Param="Name"_$c(2)_PatName
	s Param=Param_"^"_"Sex"_$c(2)_PatSex
	s Param=Param_"^"_"Age"_$c(2)_PatAge
	s Param=Param_"^"_"Bed"_$c(2)_Bed
	s Param=Param_"^"_"AdmWard"_$c(2)_warddesc
	s Param=Param_"^"_"AdmDoc"_$c(2)_admdocdesc
	s Param=Param_"^"_"diag"_$c(2)_diag
	s Param=Param_"^"_"PatNo"_$c(2)_PatNo
	s Param=Param_"^"_"PatTel"_$c(2)_PatTel
	s Param=Param_"^"_"PatNoBar"_$c(2)_"*"_PatNo_"*"
	s Param=Param_"^"_"PatientCode"_$c(2)_PatNo
	
	;List 取值
	s List=""
	s l1="" f {
		s l1=$o(QueList(l1))
		q:l1=""
		s l2="" f {
			s l2=$o(QueList(l1,l2))
			q:l2=""
			s l3="" f {
				s l3=$o(QueList(l1,l2,l3))
				q:l3=""
				if List="" s List=$g(QueList(l1,l2,l3))
				else  s List=List_$c(2)_$g(QueList(l1,l2,l3))
			}
		}
	}
	q Param_$c(1)_List
	
GetBed(PatientID)
	s Bed=""
	s PaadmRowId="" f {
		s PaadmRowId=$O(^PAPERdr(PatientID,"ADM","I",PaadmRowId)) 
		q:PaadmRowId=""
		s PatVistiStatus=$p($g(^PAADM(PaadmRowId)),"^",20)
		continue:PatVistiStatus'="A" // 不是在院病人则退出
		s BedDr=$p($g(^PAADM(PaadmRowId)),"^",73)
		if BedDr'="" s Bed=$p(^PAWARD(+BedDr,"BED",$p(BedDr,"||",2)),"^",1)
		q:Bed'=""
	}
	q Bed_"^"_PaadmRowId
}

/// 排班资源治疗预约信息导出
Query FindAppointmentListExport(PatientId As %String, OnlyApp As %String = "", AppDate As %String = "", ResSchduleId As %String = "", SessionStr As %String = "", ExpStr As %String = "") As %Library.Query(ROWSPEC = "PatNo:%String:登记号,PatName:%String:姓名,QueDept:%String:治疗科室,ResDesc:%String:资源,ASDate:%String:预约日期,TimeRange:%String:时段,QueNo:%String:排队序号,DCAAStatus:%String:预约状态")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.AppointmentV2","QryWorkReportForExport","2019-12-30","2020-01-20","","","","",10209,2,"")
ClassMethod FindAppointmentListExportExecute(ByRef qHandle As %Library.Binary, PatientId As %String, OnlyApp As %String = "", AppDate As %String = "", ResSchduleId As %String = "", SessionStr As %String = "", ExpStr As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.AppointmentV2:FindAppointmentList")
	d rset.Execute(PatientId,OnlyApp,AppDate,ResSchduleId,SessionStr,ExpStr)
	While (rset.Next()) {
		s QueDept=rset.Data("QueDept")
		s QueDate=rset.Data("QueDate")
		s ResDesc=rset.Data("ResDesc")
		s ASDate=rset.Data("ASDate")
		s TimeRange=rset.Data("TimeRange")
		s SchedStTime=rset.Data("SchedStTime")
		s SchedEdTime=rset.Data("SchedEdTime")
		s DDCRSStatus=rset.Data("DDCRSStatus")
		s QueOperUser=rset.Data("QueOperUser")
		
		s QueStatusDate=rset.Data("QueStatusDate")
		s DCAAStatus=rset.Data("DCAAStatus")
		s PatNo=rset.Data("PatNo")
		s PatName=rset.Data("PatName")
		s QueNo=rset.Data("QueNo")
		s OutputList=$lb(PatNo,PatName,QueDept,ResDesc,ASDate,TimeRange,QueNo,DCAAStatus)
		d OutputRow14
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow14
	set Data=OutputList
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindAppointmentListExportFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindAppointmentListExportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		Set AtEnd=1
		Set Row=""
	}Else{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAppointmentListExportClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAppointmentListExportExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

}
