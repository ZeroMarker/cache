Class DHCDoc.DHCDocCure.WordReport Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 治疗预约统计查询
Query QryWorkReport(DateType As %String, StartDate As %String, EndDate As %String, UserID As %String, queryLoc As %String = "", queryStatus As %String = "", queryArcim As %String = "", queryGroup As %String = "", queryOrderLoc As %String = "", UserHospID As %String = "") As %Query(ROWSPEC = "DCARowId:%String,PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatTel:%String,AdmType:%String,AdmDep:%String,ArcimDesc:%String,OrdQty:%String,OrdBillUOM:%String,OrdReLoc:%String,ApplyStatus:%String,ApplyUser:%String,ApplyDateTime:%String,ApplyAppedTimes:%String,ApplyNoAppTimes:%String,ApplyFinishTimes:%String,ApplyNoFinishTimes:%String,OrdPrice:%String,OrdBilled:%String,UnitPrice:%String,ApplyFinishUser:%String,Job:%String,CureDate:%String,ApplyCureRecord:%String,OrderAddDept:%String,CureApplyNo:%String")
{
}

ClassMethod QryWorkReportExecute(ByRef qHandle As %Binary, DateType As %String, StartDate As %String, EndDate As %String, UserID As %String, queryLoc As %String = "", queryStatus As %String = "", queryArcim As %String = "", queryGroup As %String = "", queryOrderLoc As %String = "", UserHospID As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","QryWorkReport","APPLY","8/1/2017","8/14/2017","1")
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","QryWorkReport","APPOINT","2018-12-15","2018-12-15","662","31","ALL","","")
	s ^TMP("QryWorkReport")=DateType_","_StartDate_","_EndDate_","_UserID_","_queryLoc_","_queryStatus_","_queryArcim_","_queryGroup_","_queryOrderLoc
	Set repid=$I(^CacheTemp)
	if DateType=""{
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}
	Set ind=1
	Set myind=1
	if StartDate'="" S StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	else  s StartDate=+$h
	if EndDate'="" S EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	else  s EndDate=+$h
	
	if queryLoc'="" s queryLoc="^"_queryLoc_"^"
	s Job=$j
	k OutputArr(UserID)
	k ^TMPQryWorkReport("DHCDOCCURE",UserID)
	if queryStatus="ALL" s queryStatus=""
	if DateType="APPLY"{
		For QueryDate=StartDate:1:EndDate Do
		.s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"ApplyDate",QueryDate,DCARowId)) q:DCARowId=""  d
		..s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
		..s CureOrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
		..Q:CureOrderId=""
		..s CureOrdReLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",6)
		..Q:(queryLoc'="")&&(queryLoc'[("^"_CureOrdReLocId_"^"))
		..s CureOrdRecHospId=$p(^CTLOC(CureOrdReLocId),"^",22)	
		..Q:(queryLoc="")&&(UserHospID'="")&&(UserHospID'=CureOrdRecHospId)
		..s CureOrdArcimId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",2)
		..q:CureOrdArcimId=""
		..q:(queryArcim'="")&&(CureOrdArcimId'=queryArcim)
		..set OrderAddDeptDr="",HospID=""
		..Set OrderAddDeptDr=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),7)),"^",2)
		..if OrderAddDeptDr'="" d
		...s HospID=$p(^CTLOC(OrderAddDeptDr),"^",22)	
		..s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(CureOrdArcimId,HospID)
		..q:DDCISRowid=""
		..s ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
		..Q:(queryGroup'="")&&(ServiceGroupDR'=queryGroup)
		..;Q:(queryStatus'="")&&(queryStatus'=ApplyStatus)
		..Q:((queryStatus="C")!(queryStatus="F"))&&(queryStatus'=ApplyStatus)
		..s DCARtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
		..Q:DCARtn="" 
		..d ReserveVar
		..d OutputRowWorkReport
	}else{
		s SericeGroup=""
		for  set SericeGroup=$o(^DHCDocCureRBCResSchdule(0,"SericeGroup",SericeGroup)) q:SericeGroup=""  d
		.Q:(queryGroup'="")&&(SericeGroup'=queryGroup)
		.For QueryDate=StartDate:1:EndDate Do
		..s DDCRSRowID=0
		..for  s DDCRSRowID=$o(^DHCDocCureRBCResSchdule(0,"SericeGroup",SericeGroup,QueryDate,DDCRSRowID)) q:DDCRSRowID=""  d
		...s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"RBAS",DDCRSRowID,DCARowId)) q:DCARowId=""  d
		....Q:$d(OutputArr(UserID,DDCRSRowID,DCARowId))
		....s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
		....s CureOrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
		....Q:CureOrderId=""
		....s CureOrdReLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",6)
		....Q:(queryLoc'="")&&(queryLoc'[("^"_CureOrdReLocId_"^"))
		....s CureOrdRecHospId=$p(^CTLOC(CureOrdReLocId),"^",22)	
		....Q:(queryLoc="")&&(UserHospID'="")&&(UserHospID'=CureOrdRecHospId)
		....s CureOrdArcimId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",2)
		....q:CureOrdArcimId=""
		....q:(queryArcim'="")&&(CureOrdArcimId'=queryArcim)
		....Q:((queryStatus="C")!(queryStatus="F"))&&(queryStatus'=ApplyStatus)
		....s DCARtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
		....Q:DCARtn="" 
		....s DCAAChildSubRowID=0 for  s DCAAChildSubRowID=$o(^DHCDocCure(0,"RBAS",DDCRSRowID,DCARowId,DCAAChildSubRowID)) q:DCAAChildSubRowID=""  d
		.....d ReserveVar
		.....d OutputRowWorkReport
		....s OutputArr(UserID,DDCRSRowID,DCARowId)=""
		s myDDCRSDate=""
		f  s myDDCRSDate=$o(^||TMPQryWorkReport("DHCDOCCURE_SORT",myDDCRSDate)) q:myDDCRSDate=""  d
		.s myDDCRSStartTime=""
		.f  s myDDCRSStartTime=$o(^||TMPQryWorkReport("DHCDOCCURE_SORT",myDDCRSDate,myDDCRSStartTime)) q:myDDCRSStartTime=""  d
		..s myDCAAppointRowID1=""
		..f  s myDCAAppointRowID1=$o(^||TMPQryWorkReport("DHCDOCCURE_SORT",myDDCRSDate,myDDCRSStartTime,myDCAAppointRowID1)) q:myDCAAppointRowID1=""  d
		...set Data1=^||TMPQryWorkReport("DHCDOCCURE_SORT",myDDCRSDate,myDDCRSStartTime,myDCAAppointRowID1)
		...Set ^CacheTemp(repid,ind)=Data1
 		...Set ind=ind+1
	}
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowWorkReport
	s Adm=$p(^DHCDocCure(DCARowId),"^",1)
	if Adm'="" d
	.s AdmType=$P(^PAADM(Adm),"^",2)
	.s AdmType=$case(AdmType,"O":"门诊","E":"急诊","I":"住院",:"门诊")
	.s AdmDepId=$p($g(^PAADM(Adm)),"^",4)
	.s:AdmDepId'="" AdmDep=$p($g(^CTLOC(AdmDepId)),"^",2)
	s OrderAddDeptDr=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),7)),"^",2)
	Q:(queryOrderLoc'="")&&(queryOrderLoc'=OrderAddDeptDr)
	s PatientInfo=$p(DCARtn,$c(1),1)
	s PatientNo=$p(PatientInfo,"^",2)
	s PatientName=$p(PatientInfo,"^",3)
	s PatientSex=$p(PatientInfo,"^",4)
	s PatientAge=$p(PatientInfo,"^",5)
	s PatientTel=$p(PatientInfo,"^",25)
	s CureAppInfo=$p(DCARtn,$c(1),2)
	s ArcimDesc=$p(CureAppInfo,"^")
	s ArcimDesc=##class(ext.util.String).EvalJSON(ArcimDesc)
	s OrderStatus=$p(CureAppInfo,"^",2)
	s OrderQty=$p(CureAppInfo,"^",3)
	s BillingUOM=$p(CureAppInfo,"^",4)
	s OrderReLoc=$p(CureAppInfo,"^",5)
	s OrdReLocId=$p(CureAppInfo,"^",6)
	s ApplyStatus=$p(CureAppInfo,"^",7)
	s ApplyUser=$p(CureAppInfo,"^",8)
	s ApplyDate=$p(CureAppInfo,"^",9)
	s CureDate=$p(ApplyDate," ")
	s ApplyAppedTimes=$p(CureAppInfo,"^",10) ;已预约次数
	s ApplyNoAppTimes=$p(CureAppInfo,"^",11) ;未预约次数
	s ApplyFinishTimes=$p(CureAppInfo,"^",12) ;已治疗次数
	s ApplyNoFinishTimes=$p(CureAppInfo,"^",13) ;未治疗次数
	;"ANA"_$c(1)_"申请未预约"_"^"_"ANC"_$c(1)_"预约未治疗"_"^"_"AC"_$c(1)_"在治疗"
	s myApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	if (myApplyStatus'="C")&&(myApplyStatus'="F"){
		i (ApplyAppedTimes=0) s myApplyStatus="ANA"
		else  if (ApplyFinishTimes=0)&&(ApplyAppedTimes>0) s myApplyStatus="ANC"
		else  if ApplyNoFinishTimes>0 s myApplyStatus="AC"
		else  if ApplyFinishTimes=OrderQty s myApplyStatus="F" ;已治疗次数=总次数但是未有进行完成操作认为已治疗完成
	}
	q:(queryStatus'="")&&(queryStatus'="F")&&(queryStatus'="C")&&(queryStatus'="A")&&(queryStatus'=myApplyStatus)
	q:(queryStatus="A")&&(myApplyStatus'="ANC")&&(myApplyStatus'="AC")
	s OrdPrice=$p(CureAppInfo,"^",17) 
	s OrdBilled=$p(CureAppInfo,"^",18) 
	s UnitPrice=$p(CureAppInfo,"^",19) 
	s ApplyFinishUser="" ;$p(CureAppInfo,"^",20)
	s ServiceGroupDR=$p(CureAppInfo,"^",21)
	s OrderAddDept=$p(CureAppInfo,"^",26)
	s ApplyNo=$p(CureAppInfo,"^",31)
	s myDCAAppointRowID=""
	s:DateType="APPOINT" myDCAAppointRowID=DCARowId_"||"_DCAAChildSubRowID
	s ApplyCureRecord=..GetCureAppointByApply(DCARowId,myDCAAppointRowID)
	Q:(ApplyCureRecord="")&&(DateType="APPOINT")
	set Data=$lb(DCARowId,PatientNo,PatientName,PatientSex,PatientAge,PatientTel,$g(AdmType),$g(AdmDep),ArcimDesc,OrderQty,BillingUOM,OrderReLoc,ApplyStatus,ApplyUser,ApplyDate,ApplyAppedTimes,ApplyNoAppTimes,ApplyFinishTimes,ApplyNoFinishTimes,OrdPrice,OrdBilled,UnitPrice,ApplyFinishUser,Job,CureDate,ApplyCureRecord,OrderAddDept,ApplyNo)
	if DateType="APPOINT"{
		s AppData=$g(^DHCDocCure(+myDCAAppointRowID,"Arrive",$p(myDCAAppointRowID,"||",2)))
		s DCAARBASDR=$p(AppData,"^",1)  //资源排班ID
		s ResData=$g(^DHCDocCureRBCResSchdule(DCAARBASDR))
		s DDCRSDate=$p(ResData,"^",4)  //出诊日期
		s DDCRSStartTime=$p(ResData,"^",6)  //开始时间
		s ^||TMPQryWorkReport("DHCDOCCURE_SORT",DDCRSDate,DDCRSStartTime,myDCAAppointRowID)=Data
		s ^TMPQryWorkReport("DHCDOCCURE",UserID,Job,myind)=DCARowId_"^"_PatientNo_"^"_PatientName_"^"_PatientSex_"^"_PatientAge_"^"_PatientTel_"^"_$g(AdmType)_"^"_$g(AdmDep)_"^"_ArcimDesc_"^"_OrderQty_"^"_BillingUOM_"^"_OrderReLoc_"^"_ApplyStatus_"^"_ApplyUser_"^"_ApplyDate_"^"_ApplyAppedTimes_"^"_ApplyNoAppTimes_"^"_ApplyFinishTimes_"^"_ApplyNoFinishTimes_"^"_OrdPrice_"^"_OrdBilled_"^"_UnitPrice_"^"_ApplyFinishUser_"^"_CureDate_"^"_ApplyCureRecord
 		s ^TMPQryWorkReport("DHCDOCCURE",UserID,Job,"num")=myind
 		s myind=myind+1
		quit
	}else{
		s ApplyFinishUser=""
		s ^TMPQryWorkReport("DHCDOCCURE",UserID,Job,ind)=DCARowId_"^"_PatientNo_"^"_PatientName_"^"_PatientSex_"^"_PatientAge_"^"_PatientTel_"^"_$g(AdmType)_"^"_$g(AdmDep)_"^"_ArcimDesc_"^"_OrderQty_"^"_BillingUOM_"^"_OrderReLoc_"^"_ApplyStatus_"^"_ApplyUser_"^"_ApplyDate_"^"_ApplyAppedTimes_"^"_ApplyNoAppTimes_"^"_ApplyFinishTimes_"^"_ApplyNoFinishTimes_"^"_OrdPrice_"^"_OrdBilled_"^"_UnitPrice_"^"_ApplyFinishUser_"^"_CureDate_"^"_ApplyCureRecord
 		s ^TMPQryWorkReport("DHCDOCCURE",UserID,Job,"num")=ind
		Set ^CacheTemp(repid,ind)=Data
 		Set ind=ind+1
 		quit	
	}
ReserveVar
 	set (PatientNo,PatientName,PatientSex,PatientAge,PatientTel,AdmType,AdmDep,ArcimDesc,OrderQty,BillingUOM,OrderReLoc,ApplyStatus,ApplyUser,ApplyDate,ApplyAppedTimes,ApplyNoAppTimes,ApplyFinishTimes,ApplyNoFinishTimes,OrdPrice,OrdBilled,UnitPrice,ApplyFinishUser,CureDate,ApplyCureRecord)=""
 	quit
}

ClassMethod QryWorkReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWorkReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryWorkReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWorkReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetWorkReportNum(ProcessNo As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	s num=+$g(^TMPQryWorkReport("DHCDOCCURE",USERID,ProcessNo,"num"))
	q num
}

ClassMethod GetWorkReportInfo(ProcessNo As %String, Num As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	q $g(^TMPQryWorkReport("DHCDOCCURE",USERID,ProcessNo,Num))
}

/// 获取某个申请单下所有的预约治疗记录情况
/// Creator:nikang
/// CreateDate:2017-08-24
ClassMethod GetCureAppointByApply(AppRowID As %String, DCAAppointRowID As %String = "")
{
	q:AppRowID="" ""
	s ret=""
	s count=0
	s DCAAChildSub=0
	for  s DCAAChildSub=$o(^DHCDocCure(AppRowID,"Arrive",DCAAChildSub)) q:DCAAChildSub=""  d
	.s DCAARowID=AppRowID_"||"_DCAAChildSub
	.Q:(DCAAppointRowID'="")&&(DCAAppointRowID'=DCAARowID)
	.s DCAAStatus=$p(^DHCDocCure(AppRowID,"Arrive",DCAAChildSub),"^",7)
	.Q:DCAAStatus="C"
	.s Appointment=##class(DHCDoc.DHCDocCure.Appointment).GetCureAppointment(DCAARowID)
	.s AppResInfo=$p(Appointment,$c(1))
	.s AppAppointInfo=$p(Appointment,$c(1),2)
	.s count=count+1
	.s AppDate=$p(AppResInfo,"^",5)
	.s AppointRegDate=$p(AppAppointInfo,"^",5)
	.s AppResStr=AppDate_" "_$p(AppResInfo,"^",8)_"-"_$p(AppResInfo,"^",9)_"("_$p(AppResInfo,"^",2)_" "_$p(AppResInfo,"^",4)_")"
	.s myStr=AppResStr ;_" "_AppAppointStr_CureRecordStr
	.i ret="" s ret=myStr
	.else  s ret=ret_"<br>"_myStr
	q ret
}

Query QryRecordReport(StartDate As %String, EndDate As %String, UserID As %String, queryLoc As %String = "", queryDoc As %String = "", queryArcim As %String = "", queryAdmID As %String = "", queryPatID As %String = "", queryApplyNo As %String = "", ExpStr As %String = "") As %Query(ROWSPEC = "OEORERowID:%String,OrderRecLoc:%String,FinishUser:%String,CureDate:%String,ArcimDesc:%String,UnitPrice:%String,OrderQty:%String,OrdBillUOM:%String,OrdPrice:%String,Job:%String,PatientNo:%String,PatientName:%String,OrderLoc:%String,PatientTel:%String,ExcuteRet:%String,OrderDate:%String,DCRResponse:%String,DCREffect:%String,ApplyNo:%String,Adm:%String,DCRRowID:%String,DCRMapID:%String,CreateUserDR:%String")
{
}

ClassMethod QryRecordReportExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, UserID As %String, queryLoc As %String = "", queryDoc As %String = "", queryArcim As %String = "", queryAdmID As %String = "", queryPatID As %String = "", queryApplyNo As %String = "", ExpStr As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","QryRecordReport","2021-05-03","2021-05-13","12618","","","","","202105070002")
	s ^TMP("QryRecordReport")=$lb(StartDate,EndDate,UserID,queryLoc,queryDoc,queryArcim,queryAdmID,queryPatID,queryApplyNo)
	s repid=$I(^CacheTemp)

	s ind=1
	if StartDate'="" S StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	if EndDate'="" S EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	s LogLocID=$p(ExpStr,"^",4)
	s HospID=$p(ExpStr,"^",5)
	s langid=$p(ExpStr,"^",7)
	s cspName=$p(ExpStr,"^",1)
	s:($g(langid)="") langid=..%LanguageID()
	s GCAExpStr=HospID_"^"_langid_"^"_cspName
	s LogLocIDStr=##CLASS(DHCDoc.DHCDocCure.Apply).GetLinkLoc(LogLocID)
	s Job=$j
	k OutputArr(UserID)
	k ^TMPQryRecordReport("DHCDOCCURE",UserID)
	s TotalPrice=0
	if queryApplyNo'=""{
		s DCARowId=0 
		for{
			s DCARowId=$o(^DHCDocCure(0,"AppNo",queryApplyNo,DCARowId))
			q:DCARowId=""
			d GetOneDCA
		}
	}elseif queryAdmID'=""{
		s DCARowId=0
		for {
			s DCARowId=$o(^DHCDocCure(0,"Adm",queryAdmID,DCARowId))
			Quit:DCARowId=""
			d GetOneDCA
		}
	}elseif queryPatID'=""{
		s PAAdmType="" 
		For{
			s PAAdmType=$O(^PAPERdr(queryPatID,"ADM",PAAdmType))
			Quit:PAAdmType=""
			s PAAdm=0
			for{
				s PAAdm=$O(^PAPERdr(queryPatID,"ADM",PAAdmType,PAAdm))
				Quit:PAAdm=""
				continue:'$d(^DHCDocCure(0,"Adm",PAAdm))
				s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
				continue:AdmVisitStatus="C"
				s DCARowId=0
				for {
					s DCARowId=$o(^DHCDocCure(0,"Adm",PAAdm,DCARowId))
					Quit:DCARowId=""
					d GetOneDCA
				}
			}
		}
	}else{
		s:StartDate="" StartDate=+$h
		s:EndDate="" EndDate=+$h
		//按照治疗日期进行查询
		k FindDCAAry
		for QryDate=StartDate:1:EndDate{
			s DCARowId=0
			for{
				s DCARowId=$o(^DHCDocCure(0,"ExecDate",QryDate,DCARowId))
				Q:DCARowId=""
				continue:$d(FindDCAAry(DCARowId))
				s FindDCAAry(DCARowId)=""
				d GetOneDCA
			}
		}
		k FindDCAAry
	}
	s qHandle=$lb(0,repid,0) 
	Quit $$$OK
GetOneDCA
	s Adm=$p(^DHCDocCure(DCARowId),"^",1)
	s DCARtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId,"",GCAExpStr)
	Q:DCARtn="" 
	s OrdRowID=$p($g(^DHCDocCure(DCARowId)),"^",2)
	Q:OrdRowID=""
	s CureOrdArcimId=$p($g(^OEORD(+OrdRowID,"I",$p(OrdRowID,"||",2),1)),"^",2)
	Q:(queryArcim'="")&&(CureOrdArcimId'=queryArcim)
	s OEOREOrdID=+OrdRowID
	s OEOREOrdChild=$p(OrdRowID,"||",2)
	s CureOrderId=OrdRowID
	s OEOREChild=0
	for{
		s OEOREChild=$o(^OEORD(OEOREOrdID,"I",OEOREOrdChild,"X",OEOREChild))
		Quit:OEOREChild=""
		d GetCureExec
	}
	quit
GetCureExec	
	s CureOrdReLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",6)
	s CureOrdLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",3)
	
	s ChangeDate=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",19)
	s ChangeStatus=""
	s ChangeType=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",16)
	s:ChangeType'="" ChangeStatus=$p(^OEC("STAT",ChangeType),"^",1)
	q:ChangeStatus'="F"
	s ChangeCP=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",15)
	s ChangeUser=$o(^SSU("SSUSR",0,"CTPCP",ChangeCP,0))
	s OEOREQty=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",4)
	s OEOREAdminQty=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",5)
	s UserCTLOCDR=$p($G(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild,"NUR")),"^",30)
	s OEOREQty=##class(DHCDoc.DHCDocCure.ExecApply).GetQtyByExecID(CureOrderId_"||"_OEOREChild)
	s ChangeNum=OEOREQty
	q:(StartDate'="")&&(ChangeDate<StartDate)
	q:(EndDate'="")&&(ChangeDate>EndDate)
	q:ChangeNum=0
	q:(queryDoc'="")&&(queryDoc'=ChangeUser)
	q:(UserCTLOCDR'="")&&(LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_UserCTLOCDR_"^"))
	q:(UserCTLOCDR'="")&&(LogLocIDStr="")&&(LogLocID'=UserCTLOCDR)
	q:(UserCTLOCDR="")&&(LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_CureOrdReLocId_"^"))
	q:(UserCTLOCDR="")&&(LogLocIDStr="")&&(LogLocID'=CureOrdReLocId)
	s DCRRowID=##class(DHCDoc.DHCDocCure.Record).GetDCRRowID("",CureOrderId_"||"_OEOREChild)
	q:DCRRowID=""
	d ReserveVarRecord
	d OutputRowRecordReport
	Quit
OutputRowRecordReport
	s PatientInfo=$p(DCARtn,$c(1),1)
	s PatientNo=$p(PatientInfo,"^",2)
	s PatientName=$p(PatientInfo,"^",3)
	s PatientSex=$p(PatientInfo,"^",4)
	s PatientAge=$p(PatientInfo,"^",5)
	s PatientTel=$p(PatientInfo,"^",25)
	s CureAppInfo=$p(DCARtn,$c(1),2)
	s ArcimDesc=$p(CureAppInfo,"^")
	s OrdDate=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",7) ;开单日期 
	s OrdDate=##class(websys.Conversions).DateLogicalToHtml(OrdDate)
	s OrderStatus=$p(CureAppInfo,"^",2)
	s OrderQty=$p(CureAppInfo,"^",3)
	s OrdBillUOM=$p(CureAppInfo,"^",4)
	s OrderReLoc=$p(CureAppInfo,"^",5)
	s OrdReLocId=$p(CureAppInfo,"^",6)
	s ApplyStatus=$p(CureAppInfo,"^",7)
	s ApplyUser=$p(CureAppInfo,"^",8)
	s ApplyDate=$p(CureAppInfo,"^",9)
	s ApplyNo=$p(CureAppInfo,"^",31) 
	s CureDate=##class(websys.Conversions).DateLogicalToHtml(ChangeDate) 
	s OrderQty=ChangeNum
	s UnitPrice=$p(CureAppInfo,"^",19)
	s OrdPrice=$j($g(UnitPrice)*ChangeNum,10,2)
	i CureOrdLocId'=""{
		s OrderLoc=..GetLocDesc(CureOrdLocId,langid)
	}
	s TotalPrice=TotalPrice+(+$g(UnitPrice)*ChangeNum)
	s ExcuteRet="正常"
	s (CreateUserDR,DCRResponse,DCREffect,DCRMapID)=""
	if ChangeUser'=""{
		s CreateUserDR=ChangeUser
		s FinishUser=$P(^SSU("SSUSR",ChangeUser),"^",2)
		s FinishUser=##class(DHCDoc.Common.Translate).GetTransUser(FinishUser,langid)
	}
	s RecordStr=##class(DHCDoc.DHCDocCure.Record).GetCureRecord(DCRRowID)
	if RecordStr'=""{
		s ExcuteRet=$p(RecordStr,"^",4)
		s CreateUserDR=$p(RecordStr,"^",5)
		s FinishUser=$p(RecordStr,"^",6)
		s CureDate=$p(RecordStr,"^",7)
		s DCRCureDate=$p(RecordStr,"^",12)
		s:DCRCureDate'="" CureDate=DCRCureDate
		s DCRResponse=$p(RecordStr,"^",13)
		s DCREffect=$p(RecordStr,"^",14)
		s DCRMapID=$p(RecordStr,"^",22)
	}
	s Data=$lb(CureOrderId_"||"_OEOREChild,OrderReLoc,FinishUser,CureDate,ArcimDesc,UnitPrice,OrderQty,OrdBillUOM,OrdPrice,Job,PatientNo,PatientName,OrderLoc,PatientTel,ExcuteRet,ApplyDate,DCRResponse,DCREffect,ApplyNo,Adm,DCRRowID,DCRMapID,CreateUserDR)
 	s ^TMPQryRecordReport("DHCDOCCURE",UserID,Job,ind)=CureOrderId_"||"_OEOREChild_"^"_OrderReLoc_"^"_FinishUser_"^"_CureDate_"^"_ArcimDesc_"^"_UnitPrice_"^"_OrderQty_"^"_OrdBillUOM_"^"_OrdPrice_"^"_PatientNo_"^"_PatientName_"^"_OrderLoc_"^"_PatientTel_"^"_OrdDate_"^"_ExcuteRet_"^"_DCRResponse_"^"_DCREffect_"^"_ApplyNo
 	s ^TMPQryRecordReport("DHCDOCCURE",UserID,Job,"num")=ind
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	quit
ReserveVarRecord
 	set (OrderReLoc,FinishUser,CureDate,ArcimDesc,UnitPrice,OrderQty,OrdBillUOM,OrdPrice,PatientNo,PatientName,OrderLoc,PatientTel,OrdDate,CreateUserDR)=""
 	quit
}

ClassMethod QryRecordReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRecordReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRecordReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRecordReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetQryRecordReportNum(ProcessNo As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	s num=+$g(^TMPQryRecordReport("DHCDOCCURE",USERID,ProcessNo,"num"))
	q num
}

ClassMethod GetQryRecordReportInfo(ProcessNo As %String, Num As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	q $g(^TMPQryRecordReport("DHCDOCCURE",USERID,ProcessNo,Num))
}

ClassMethod GetLocDesc(LocID, langid)
{
	q:LocID="" ""
	s LocDesc=$p(^CTLOC(LocID),"^",2)
	s LocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",LocDesc,langid)
	if LocDesc["-" s LocDesc=$p(LocDesc,"-",2)
	q LocDesc
}

ClassMethod QryWorkReportForExecute(ByRef qHandle As %Binary, query As %String, StartDate As %String, EndDate As %String, UserID As %String, queryDoc As %String = "", queryLoc As %String = "", queryArcim As %String = "", ExpStr As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","QryWorkReportFor","dept","2023-02-09","2023-02-09","17473","","13","","doccure.workreport.dept.hui.csp^17473^275^13^2^^20")
	s ^TMP("QryWorkReportFor")=$lb(query,StartDate,EndDate,UserID,queryDoc,queryLoc,queryArcim,ExpStr)
	s repid=$I(^CacheTemp)
	s ind=1
	if StartDate'="" S StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	else  s StartDate=+$h
	if EndDate'="" S EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	else  s EndDate=+$h
	s LogLocID=queryLoc
	s HospID=$p(ExpStr,"^",5)
	s langid=$p(ExpStr,"^",7)
	s cspName=$p(ExpStr,"^",1)
	s:$g(langid)="" langid=..%LanguageID()
	s:($g(queryLoc)="")&&($d(%session)) LogLocID=%session.Get("LOGON.CTLOCID")
	s TransExp=HospID_"^"_langid_"^"_cspName
	s LogLocIDStr=##CLASS(DHCDoc.DHCDocCure.Apply).GetLinkLoc(LogLocID)
	s Job=$j
	k OutputArr(UserID)
	k ^TMPQryWorkReportFor("DHCDOCCURE",UserID)
	s TotalPrice=0
	
	for QryDate=StartDate:1:EndDate{
		s DCARowId=0
		for{
			s DCARowId=$o(^DHCDocCure(0,"ExecDate",QryDate,DCARowId))
			Q:DCARowId=""
			s OrdRowID=$p($g(^DHCDocCure(DCARowId)),"^",2)
			s CureOrderId=OrdRowID
			s CureOrdReLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",6)
			s CureOrdArcimId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",2)
			s CureOrdPHFreqDR=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),2)),"^",4)
			continue:(queryArcim'="")&&(CureOrdArcimId'=queryArcim)
			s DCAData=##class(DHCDoc.DHCDocCure.Apply).GetSimpleCureApply(DCARowId,"",TransExp)
			continue:DCAData="" 
			s OEOREOrdID=+OrdRowID
			s OEOREOrdChild=$p(OrdRowID,"||",2)
			s OEOREChild=0
			for{
				s OEOREChild=$o(^OEORDi(0,"DateExecute",QryDate,OEOREOrdID,OEOREOrdChild,OEOREChild))
				Q:OEOREChild=""
			 	s ChangeDate=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",19)
				s ChangeStatus=""
				s ChangeType=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",16)
				s:ChangeType'="" ChangeStatus=$p(^OEC("STAT",ChangeType),"^",1)
				continue:ChangeStatus'="F"
				s ChangeCP=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",15)
				s ChangeUser=$o(^SSU("SSUSR",0,"CTPCP",ChangeCP,0))
				continue:(StartDate'="")&&(ChangeDate<StartDate)
				continue:(EndDate'="")&&(ChangeDate>EndDate)
				continue:(queryDoc'="")&&(queryDoc'=ChangeUser)
				s OEOREQty=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",4)
				s OEOREAdminQty=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",5)
				s UserCTLOCDR=$p($G(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild,"NUR")),"^",30)
				s:(CureOrdPHFreqDR="")||(OEOREQty=0) OEOREQty=OEOREAdminQty
				s OEOREQty=##class(DHCDoc.DHCDocCure.ExecApply).GetQtyByExecID(CureOrderId_"||"_OEOREChild)
				s ChangeNum=OEOREQty
				continue:ChangeNum=0
				continue:(UserCTLOCDR'="")&&(LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_UserCTLOCDR_"^"))
				continue:(UserCTLOCDR'="")&&(LogLocIDStr="")&&(LogLocID'=UserCTLOCDR)
				continue:(UserCTLOCDR="")&&(LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_CureOrdReLocId_"^"))
				continue:(UserCTLOCDR="")&&(LogLocIDStr="")&&(LogLocID'=CureOrdReLocId)
				d ReserveVarWorkReportFor
				d GetWorkReportFor
			}
		}
	}
	if query="dept"{
		s LocId=""
		for{
			s LocId=$o(^||TMPSort("QryWorkReportForDept",LocId))
			q:LocId=""
			s myCureOrdArcimId=""
			s TotalOrderQty=0,TotalOrdPrice=0
			for{
				s myCureOrdArcimId=$o(^||TMPSort("QryWorkReportForDept",LocId,myCureOrdArcimId))
				q:myCureOrdArcimId=""
				d ReserveVarWorkReportFor
				s TLocDesc=..GetLocDesc(LocId,langid)
				s myData=^||TMPSort("QryWorkReportForDept",LocId,myCureOrdArcimId)
				s TDCARowId=$p(myData,"^")
				s TArcimDesc=$p(myData,"^",2)
				s TUnitPrice=$p(myData,"^",3)
				s TOrderQty=$p(myData,"^",4)
				s TOrdBillUOM=$p(myData,"^",5)
				s TOrdPrice=$p(myData,"^",6)
				s TotalOrderQty=TotalOrderQty+TOrderQty
				s TotalOrdPrice=TotalOrdPrice+TOrdPrice
				s TOrdPrice=$j(TOrdPrice,10,2)
				d OutputRowWorkReportFor
			}
			s TLocDesc=..GetLocDesc(LocId,langid)
			s TDCARowId=""
			s TFinishUser=""
			s TLocDesc=##class(websys.Translation).Get(cspName,"合计")
			s TUnitPrice="-",TOrdBillUOM="-",TArcimDesc="-"
			s TOrderQty=TotalOrderQty
			s TOrdPrice=$j(TotalOrdPrice,10,2)
			d OutputRowWorkReportFor
		}
	}elseif query="doc"{
		s myChangeUser=""
		for{
			s myChangeUser=$o(^||TMPSort("QryWorkReportForUser",myChangeUser))
			q:myChangeUser=""
			s myCureOrdArcimId=""
			s TotalOrderQty=0,TotalOrdPrice=0
			for{
				s myCureOrdArcimId=$o(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId))
				q:myCureOrdArcimId=""
				d ReserveVarWorkReportFor
				s TDCARowId=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^")
				s TFinishUser=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^",2)
				s TArcimDesc=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^",3)
				s TUnitPrice=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^",4)
				s TOrderQty=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^",5)
				s TOrdBillUOM=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^",6)
				s TOrdPrice=$p(^||TMPSort("QryWorkReportForUser",myChangeUser,myCureOrdArcimId),"^",7)
				s TotalOrderQty=TotalOrderQty+TOrderQty
				s TotalOrdPrice=TotalOrdPrice+TOrdPrice
				s TOrdPrice=$j(TOrdPrice,10,2)
				d OutputRowWorkReportFor
			}
			s TDCARowId=""
			s TFinishUser=##class(websys.Translation).Get(cspName,"合计")
			s TArcimDesc="-",TUnitPrice="-",TOrdBillUOM="-"
			s TOrderQty=TotalOrderQty
			s TOrdPrice=$j(TotalOrdPrice,10,2)
			d OutputRowWorkReportFor
		}
	}

	s qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowWorkReportFor
	s Data=$lb(ind,TDCARowId,TArcimDesc,TUnitPrice,TOrderQty,TOrdBillUOM,TOrdPrice,TFinishUser,Job,TLocDesc)
 	s ^TMPQryWorkReportFor("DHCDOCCURE",UserID,Job,ind)=TDCARowId_"^"_TArcimDesc_"^"_TUnitPrice_"^"_TOrderQty_"^"_TOrdBillUOM_"^"_TOrdPrice_"^"_TFinishUser_"^"_TLocDesc
 	s ^TMPQryWorkReportFor("DHCDOCCURE",UserID,Job,"num")=ind
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	quit
GetWorkReportFor
	s Adm=$p(^DHCDocCure(DCARowId),"^",1)
	s DCAppData=$p(DCAData,$c(1),2)
	s ArcimDesc=$p(DCAppData,"^")
	s OrderStatus=$p(DCAppData,"^",3)
	s OrderQty=$p(DCAppData,"^",4)
	s OrdBillUOM=$p(DCAppData,"^",5)
	s OrderQty=ChangeNum
	s UnitPrice=$p(DCAppData,"^",6)
	s OrdPrice=$g(UnitPrice)*ChangeNum
	if query="doc"{
		s:ChangeUser'="" FinishUser=$P(^SSU("SSUSR",ChangeUser),"^",2) ;$p(CureAppInfo,"^",20)
		s FinishUser =##class(DHCDoc.Common.Translate).GetTransUser(FinishUser,langid)
		if '$d(^||TMPSort("QryWorkReportForUser",ChangeUser,CureOrdArcimId)){
			s ^||TMPSort("QryWorkReportForUser",ChangeUser,CureOrdArcimId)=DCARowId_"^"_FinishUser_"^"_ArcimDesc_"^"_UnitPrice_"^"_OrderQty_"^"_OrdBillUOM_"^"_OrdPrice
		}else{
			s ChangeNums=$p(^||TMPSort("QryWorkReportForUser",ChangeUser,CureOrdArcimId),"^",5)+OrderQty
			s OrdPrices=$p(^||TMPSort("QryWorkReportForUser",ChangeUser,CureOrdArcimId),"^",7)+OrdPrice
			s ^||TMPSort("QryWorkReportForUser",ChangeUser,CureOrdArcimId)=DCARowId_"^"_FinishUser_"^"_ArcimDesc_"^"_UnitPrice_"^"_ChangeNums_"^"_OrdBillUOM_"^"_OrdPrices
		}
	}elseif query="dept"{
		if '$d(^||TMPSort("QryWorkReportForDept",CureOrdReLocId,CureOrdArcimId)){
			s ^||TMPSort("QryWorkReportForDept",CureOrdReLocId,CureOrdArcimId)=DCARowId_"^"_ArcimDesc_"^"_UnitPrice_"^"_OrderQty_"^"_OrdBillUOM_"^"_OrdPrice
		}else{
			s ChangeNums=$p(^||TMPSort("QryWorkReportForDept",CureOrdReLocId,CureOrdArcimId),"^",4)+OrderQty
			s OrdPrices=$p(^||TMPSort("QryWorkReportForDept",CureOrdReLocId,CureOrdArcimId),"^",6)+OrdPrice
			s ^||TMPSort("QryWorkReportForDept",CureOrdReLocId,CureOrdArcimId)=DCARowId_"^"_ArcimDesc_"^"_UnitPrice_"^"_ChangeNums_"^"_OrdBillUOM_"^"_OrdPrices
		}
	}
	
 	quit
ReserveVarWorkReportFor
 	set (TFinishUser,TArcimDesc,TUnitPrice,TOrderQty,TOrdBillUOM,TOrdPrice,TLocDesc)=""
 	quit
}

Query QryWorkReportFor(query As %String, StartDate As %String, EndDate As %String, UserID As %String, queryDoc As %String = "", queryLoc As %String = "", queryArcim As %String = "", ExpStr As %String = "") As %Query(ROWSPEC = "seqno:%String,DCARowId:%String,ArcimDesc:%String,UnitPrice:%String,OrderQty:%String,OrdBillUOM:%String,OrdPrice:%String,FinishUser:%String,Job:%String,TLocDesc:%String")
{
}

ClassMethod QryWorkReportForClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWorkReportForExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryWorkReportForFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWorkReportForExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetQryWorkReportForNum(ProcessNo As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	s num=+$g(^TMPQryWorkReportFor("DHCDOCCURE",USERID,ProcessNo,"num"))
	q num
}

ClassMethod GetQryWorkReportForInfo(ProcessNo As %String, Num As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	q $g(^TMPQryWorkReportFor("DHCDOCCURE",USERID,ProcessNo,Num))
}

Query QryWorkReportForDocApp(StartDate As %String, EndDate As %String, UserID As %String, queryDoc As %String = "", queryArcim As %String = "") As %Query(ROWSPEC = "seqno:%String,DCARowId:%String,CureAppUser:%String,ArcimDesc:%String,UnitPrice:%String,OrderQty:%String,OrdBillUOM:%String,OrdPrice:%String,Job:%String")
{
}

/// 治疗站医师申请工作量统计
ClassMethod QryWorkReportForDocAppExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, UserID As %String, queryDoc As %String = "", queryArcim As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","QryWorkReportForDocApp","2018-07-01","2018-07-11","4852")
	s ^TMP("QryWorkReportForDocApp")=StartDate_","_EndDate_","_UserID_","_queryDoc_","_queryArcim
	Set repid=$I(^CacheTemp)

	Set ind=1
	if StartDate'="" S StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	else  s StartDate=+$h
	if EndDate'="" S EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	else  s EndDate=+$h
	
	s LogLocID=%session.Get("LOGON.CTLOCID")
	s LogLocIDStr=##CLASS(DHCDoc.DHCDocCure.Apply).GetLinkLoc(LogLocID)
	s LangId=..%LanguageID()
	;if queryLoc'="" s queryLoc="^"_queryLoc_"^"
	s Job=$j
	k OutputArr(UserID)
	k ^TMPQryWorkReportForDocApp("DHCDOCCURE",UserID)
	s TotalPrice=0
	for Date=StartDate:1:EndDate{
		s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"ApplyDate",Date,DCARowId)) q:DCARowId=""  d
		.s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
		.Q:ApplyStatus="C"
		.s CureOrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
		.Q:CureOrderId=""
		.s CureAppUserDr=$p($g(^DHCDocCure(DCARowId)),"^",4)
		.s CureOrdReLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",6)
		.s CureOrdAddLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),7)),"^",2)
		.s CureOrdLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",3)
		.s CureOrdArcimId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",2)
		.q:(queryArcim'="")&&(CureOrdArcimId'=queryArcim)
		.Q:(LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_CureOrdAddLocId_"^"))
		.Q:(LogLocIDStr="")&&(LogLocID'=CureOrdReLocId)
		.Q:(queryDoc'="")&&(queryDoc'=CureAppUserDr)
		.d ReserveVarWorkReportForDocApp
		.d GetWorkReportForDocApp
	}
	s myCureAppUser=""
	for  s myCureAppUser=$o(^||TMPSort("QryWorkReportForDocApp",myCureAppUser)) q:myCureAppUser=""  d
	.s myCureOrdArcimId=""
	.s TotalOrderQty=0,TotalOrdPrice=0
	.for  s myCureOrdArcimId=$o(^||TMPSort("QryWorkReportForDocApp",myCureAppUser,myCureOrdArcimId)) q:myCureOrdArcimId=""  d
	..d ReserveVarWorkReportForDocApp
	..s TDCARowId=$p(^||TMPSort("QryWorkReportForDocApp",myCureAppUser,myCureOrdArcimId),"^")
	..s TCureAppUser=$p(^||TMPSort("QryWorkReportForDocApp",myCureAppUser,myCureOrdArcimId),"^",2)
	..s TCureAppUser = ##class(DHCDoc.Common.Translate).GetTransUser(TCureAppUser,LangId)
	..s TArcimDesc=$p(^||TMPSort("QryWorkReportForDocApp",myCureAppUser,myCureOrdArcimId),"^",3)
	..s TUnitPrice=$p(^||TMPSort("QryWorkReportForDocApp",myCureAppUser,myCureOrdArcimId),"^",4)
	..s TOrderQty=$p(^||TMPSort("QryWorkReportForDocApp",myCureAppUser,myCureOrdArcimId),"^",5)
	..s TOrdBillUOM=$p(^||TMPSort("QryWorkReportForDocApp",myCureAppUser,myCureOrdArcimId),"^",6)
	..s TOrdPrice=$p(^||TMPSort("QryWorkReportForDocApp",myCureAppUser,myCureOrdArcimId),"^",7)
	..s TotalOrderQty=TotalOrderQty+TOrderQty
	..s TotalOrdPrice=TotalOrdPrice+TOrdPrice
	..s TOrdPrice=$j(TOrdPrice,10,2)
	..d OutputRowWorkReportForDocApp
	.s TDCARowId=""
	.s TCureAppUser=##class(websys.Translation).Get("doccure.workreport.docapp.hui.csp","合计")
	.s TArcimDesc="-",TUnitPrice="-",TOrdBillUOM="-"
	.s TOrderQty=TotalOrderQty
	.s TOrdPrice=$j(TotalOrdPrice,10,2)
	.d OutputRowWorkReportForDocApp

	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowWorkReportForDocApp
	set Data=$lb(ind,TDCARowId,TCureAppUser,TArcimDesc,TUnitPrice,TOrderQty,TOrdBillUOM,TOrdPrice,Job)
 	s ^TMPQryWorkReportForDocApp("DHCDOCCURE",UserID,Job,ind)=TDCARowId_"^"_TCureAppUser_"^"_TArcimDesc_"^"_TUnitPrice_"^"_TOrderQty_"^"_TOrdBillUOM_"^"_TOrdPrice
 	s ^TMPQryWorkReportForDocApp("DHCDOCCURE",UserID,Job,"num")=ind
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
GetWorkReportForDocApp
	s Adm=$p(^DHCDocCure(DCARowId),"^",1)
	s rtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
	Q:rtn="" 
	s CureAppInfo=$p(rtn,$c(1),2)
	s ArcimDesc=$p(CureAppInfo,"^")
	s ArcimDesc=##class(ext.util.String).EvalJSON(ArcimDesc)
	s OrderStatus=$p(CureAppInfo,"^",2)
	s OrderQty=+$p(CureAppInfo,"^",3)
	if OrderQty=0 s OrderQty=1
	s OrdBillUOM=$p(CureAppInfo,"^",4)
	s UnitPrice=$p(CureAppInfo,"^",19)
	s OrdPrice=$g(UnitPrice)*OrderQty
	s CureAppUser=""
	s:CureAppUserDr'="" CureAppUser=$P(^SSU("SSUSR",CureAppUserDr),"^",2) ;$p(CureAppInfo,"^",20)
	if '$d(^||TMPSort("QryWorkReportForDocApp",CureAppUserDr,CureOrdArcimId)){
		s ^||TMPSort("QryWorkReportForDocApp",CureAppUserDr,CureOrdArcimId)=DCARowId_"^"_CureAppUser_"^"_ArcimDesc_"^"_UnitPrice_"^"_OrderQty_"^"_OrdBillUOM_"^"_OrdPrice
	}else{
		s ChangeNums=$p(^||TMPSort("QryWorkReportForDocApp",CureAppUserDr,CureOrdArcimId),"^",5)+OrderQty
		s OrdPrices=$p(^||TMPSort("QryWorkReportForDocApp",CureAppUserDr,CureOrdArcimId),"^",7)+OrdPrice
		s ^||TMPSort("QryWorkReportForDocApp",CureAppUserDr,CureOrdArcimId)=DCARowId_"^"_CureAppUser_"^"_ArcimDesc_"^"_UnitPrice_"^"_ChangeNums_"^"_OrdBillUOM_"^"_OrdPrices
	}
	
 	quit

ReserveVarWorkReportForDocApp
 	set (TCureAppUser,TArcimDesc,TUnitPrice,TOrderQty,TOrdBillUOM,TOrdPrice)=""
 	quit
}

ClassMethod QryWorkReportForDocAppClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWorkReportForDocAppExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryWorkReportForDocAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWorkReportForDocAppExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetQryWorkReportForDocAppNum(ProcessNo As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	s num=+$g(^TMPQryWorkReportForDocApp("DHCDOCCURE",USERID,ProcessNo,"num"))
	q num
}

ClassMethod GetQryWorkReportForDocAppInfo(ProcessNo As %String, Num As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	q $g(^TMPQryWorkReportForDocApp("DHCDOCCURE",USERID,ProcessNo,Num))
}

/// 治疗服务组预约表
/// w ##class(DHCDoc.DHCDocCure.WordReport).MonthAppReport("2018-06-1","2018-06-30",49,4852)
ClassMethod MonthAppReport(StartDate As %String, EndDate As %String, queryGroup As %String, USERID As %String, HospID As %String = "")
{
	K ^TMPMonthAppReport("DHCDOCCURE",USERID)
	k MonthAppReportArr
	s SericeGroup=queryGroup
	s TimeCount=0
	if StartDate'="" S StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	else  s StartDate=+$h
	if EndDate'="" S EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	else  s EndDate=+$h
	For QueryDate=StartDate:1:EndDate Do
	.s DDCRSRowID=""
	.for  s DDCRSRowID=$o(^DHCDocCureRBCResSchdule(0,"SericeGroup",SericeGroup,QueryDate,DDCRSRowID)) q:DDCRSRowID=""  d
	..s QueryDay=+$p($zd(QueryDate,3),"-",3)
	..s Data=$g(^DHCDocCureRBCResSchdule(DDCRSRowID))
	..s DDCRSLocDr=$p(Data,"^",2)
	..s DDCRSHospDr=$p(^CTLOC(DDCRSLocDr),"^",22)
	..q:(HospID'="")&&(HospID'=DDCRSHospDr)
	..s DDCRSDate=$p(Data,"^",4)  //出诊日期
	..s DDCRSTimeRangeDR=$p(Data,"^",5)  //排程出诊时段
	..s DDCRSStartTime=$p(Data,"^",6)  //开始时间
	..s DDCRSEndTime=$p(Data,"^",7)  //结束时间
	..s RSStartTime=$zt(DDCRSStartTime,2)
	..s RSEndTime=$zt(DDCRSEndTime,2)
	..s AppedSum=+$p($g(MonthAppReportArr(DDCRSStartTime,QueryDay)),"^",2)
	..s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"RBAS",DDCRSRowID,DCARowId)) q:DCARowId=""  d
	...s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	...Q:(ApplyStatus="C")
	...s DCAAChildSubRowID=0 for  s DCAAChildSubRowID=$o(^DHCDocCure(0,"RBAS",DDCRSRowID,DCARowId,DCAAChildSubRowID)) q:DCAAChildSubRowID=""  d
	....s Data=$g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSubRowID))
	....q:Data=""
	....s DCAAStatus=$p(Data,"^",7)   //预约状态
	....q:(DCAAStatus'="I")&&(DCAAStatus'="A")
    ....s AppedSum=AppedSum+1
    ..s TimeCount=TimeCount+1
    ..s MonthAppReportArr(DDCRSStartTime,QueryDay)=RSStartTime_"-"_RSEndTime_"^"_AppedSum
    s myDDCRSStartTime=""
    s mysortno=0
    for  s myDDCRSStartTime=$o(MonthAppReportArr(myDDCRSStartTime)) q:myDDCRSStartTime=""  d
    .s myQueryDay=""
    .s mysortno=mysortno+1
    .for  s myQueryDay=$o(MonthAppReportArr(myDDCRSStartTime,myQueryDay)) q:myQueryDay=""  d
    ..s ^TMPMonthAppReport("DHCDOCCURE",USERID,mysortno,myQueryDay)=MonthAppReportArr(myDDCRSStartTime,myQueryDay)
    ..s ^TMPMonthAppReport("DHCDOCCURE",USERID,mysortno)=$p(MonthAppReportArr(myDDCRSStartTime,myQueryDay),"^",1)
    q mysortno
}

ClassMethod GetMonthAppInfo(QueryDay As %String, TimeCount As %String, USERID As %String)
{
	Q $g(^TMPMonthAppReport("DHCDOCCURE",USERID,TimeCount,QueryDay))
}

ClassMethod GetMonthAppTimeInfo(TimeCount As %String, USERID As %String)
{
	Q $g(^TMPMonthAppReport("DHCDOCCURE",USERID,TimeCount))
}

Query QryCureProcess(StartDate As %String, EndDate As %String, UserID As %String, queryLoc As %String = "", queryStatus As %String = "", queryArcim As %String = "", queryGroup As %String = "", EpisodeID As %String = "", SessionStr As %String = "") As %Query(ROWSPEC = "DCAARowId:%String,PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatTel:%String,AdmType:%String,AdmDep:%String,ArcimDesc:%String,OrdReLoc:%String,ApplyStatus:%String,ApplyUser:%String,ApplyDateTime:%String,Job:%String,ApplyAppInfo:%String,RecordInfo:%String,IStatusInfo:%String,CStatusInfo:%String,AStatusInfo:%String,ApplyInfo:%String,ApplyNo:%String,PAAdmWard:%String,PAAdmBed:%String,AppointStatus:%String")
{
}

/// 治疗过程状态查询
ClassMethod QryCureProcessExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, UserID As %String, queryLoc As %String = "", queryStatus As %String = "", queryArcim As %String = "", queryGroup As %String = "", EpisodeID As %String = "", SessionStr As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","QryCureProcess","2019-08-01","2019-08-20","10652","40","","6433||1","")
	s ^TMP("QryQryCureProcess")=$lb(StartDate,EndDate,UserID,queryLoc,queryStatus,queryArcim,queryGroup,SessionStr)
	s HospID=$p(SessionStr,"^",5)
	s langid=$p(SessionStr,"^",7)
	s cspName=$p(SessionStr,"^",1)
	s:cspName="" cspName="doccure.workreport.processqry.hui.csp"
	s:$g(langid)="" langid=..%LanguageID()
	s:$g(HospID)="" HospID=$P(^CTLOC(queryLoc),"^",22)
	s CureAppVersion=##Class(DHCDoc.DHCDocCure.Config).GetCureConfigPara("CureAppVersion",HospID)
	if CureAppVersion="V1"{
		;旧版预约模式的查询
		Q ..QryCureProcessV1Execute(StartDate,EndDate,UserID,queryLoc,queryStatus,queryArcim,queryGroup)
	}
	
	s repid=$I(^CacheTemp)
	s ind=1
	s myind=1
	if StartDate'="" S StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	if EndDate'="" S EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	if queryStatus="ALL" s queryStatus=""
	
	s LogLocIDStr=##CLASS(DHCDoc.DHCDocCure.Apply).GetLinkLoc(queryLoc)
	;if LogLocIDStr'="" s LogLocIDStr="^"_LogLocIDStr_"^"
	
	s langid=..%LanguageID()
	s TransExpStr=langid_"^"_cspName
	s Job=$j
	k ^TMPQryCureProcessReport("DHCDOCCURE",UserID)
	if EpisodeID'=""{
		s DCARowId=0
		for{
			s DCARowId=$o(^DHCDocCure(0,"Adm",EpisodeID,DCARowId))
			q:DCARowId=""
			s ApplyDate=$p($g(^DHCDocCure(DCARowId)),"^",5)
			continue:(StartDate'="")&&(ApplyDate<StartDate)
			continue:(EndDate'="")&&(ApplyDate>EndDate)
			d GetProcessByDCA
		}
	}else{
		s:StartDate="" StartDate=+$h
		s:EndDate="" EndDate=+$h
		for looploc=1:1:$l(LogLocIDStr,"^"){
			s LogLocID=$p(LogLocIDStr,"^",looploc)
			for QueryDate=StartDate:1:EndDate{
				s DCARowId=""
				for{
					s DCARowId=$o(^DHCDocCure(0,"RecDate",LogLocID,QueryDate,DCARowId))
					Q:DCARowId=""
					d GetProcessByDCA
				}
			}
		}
	}
					
	s myDDCRSDate=""
	for{
		s myDDCRSDate=$o(^||TMPQryCureProcessReport("DHCDOCCURE_SORT",myDDCRSDate))
		q:myDDCRSDate=""
		s myDDCRSStartTime=""
		for{
			s myDDCRSStartTime=$o(^||TMPQryCureProcessReport("DHCDOCCURE_SORT",myDDCRSDate,myDDCRSStartTime))
			q:myDDCRSStartTime=""
			s myDCAAppointRowID1=""
			for{
				s myDCAAppointRowID1=$o(^||TMPQryCureProcessReport("DHCDOCCURE_SORT",myDDCRSDate,myDDCRSStartTime,myDCAAppointRowID1))
				q:myDCAAppointRowID1=""
				s Data1=^||TMPQryCureProcessReport("DHCDOCCURE_SORT",myDDCRSDate,myDDCRSStartTime,myDCAAppointRowID1)
				s ^CacheTemp(repid,ind)=Data1
				s ind=ind+1
			}
		}
	}
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
GetProcessByDCA
	s CureOrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
	Q:CureOrderId=""
	s CureOrdArcimId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",2)
	Q:(queryArcim'="")&&(CureOrdArcimId'=queryArcim)
	d ReserveVarCureProcess
	s DCAData=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
	Q:(DCAData="")
	s ServiceGroupDR=$p($p(DCAData,$c(1),2),"^",21)
	Q:(queryGroup'="")&&(ServiceGroupDR'=queryGroup)
	d GetCureProcessData
	quit
GetCureProcessData
	s Adm=$p(^DHCDocCure(DCARowId),"^",1)
	if Adm'=""{
		s AdmType=$P(^PAADM(Adm),"^",2)
		s AdmType=$case(AdmType,"O":"门诊","E":"急诊","I":"住院",:"门诊")
		s AdmDepId=$p($g(^PAADM(Adm)),"^",4)
		s:AdmDepId'="" AdmDep=$p($g(^CTLOC(AdmDepId)),"^",2)
	}
	s CureAppInfo=$p(DCAData,$c(1),2)
	s ServiceGroupDR=$p(CureAppInfo,"^",21)
	s ArcimDesc=$p(CureAppInfo,"^")
	s OrderReLoc=$p(CureAppInfo,"^",5)
	s OrdReLocId=$p(CureAppInfo,"^",6)
	s ApplyStatus=$p(CureAppInfo,"^",7)
	s ApplyUser=$p(CureAppInfo,"^",8)
	s ApplyDate=$p(CureAppInfo,"^",9)
	s ApplyInfo=ApplyDate_##class(websys.Translation).Get(cspName,"由")_ApplyUser_##class(websys.Translation).Get(cspName,"登记")
	s PatientInfo=$p(DCAData,$c(1),1)
	s PatientNo=$p(PatientInfo,"^",2)
	s PatientName=$p(PatientInfo,"^",3)
	s PatientSex=$p(PatientInfo,"^",4)
	s PatientAge=$p(PatientInfo,"^",5)
	s PatientTel=$p(PatientInfo,"^",25)
	s ApplyNo=$p(CureAppInfo,"^",31)
	s PAAdmWard=$p(CureAppInfo,"^",32)
	s PAAdmBed=$p(CureAppInfo,"^",33)
	
	s OEOREChild=0
	for{
		s OEOREChild=$o(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild))
		Q:OEOREChild=""
		s ExecStatCode=""
		s ExecStatDr=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild)),"^",16)
		s:ExecStatDr'="" ExecStatCode=$p(^OEC("STAT",ExecStatDr),"^",1)
		continue:(queryStatus'="")&&(queryStatus'=ExecStatCode)
		s OEORERowID=CureOrderId_"||"_OEOREChild
		s DCAARowID=""
		s ExecData=$g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild))
		s ChangeDate=$p(ExecData,"^",19)
		s AppointStatus=##class(websys.Translation).Get(cspName,"未执行")
		s ChangeType=$p(ExecData,"^",16)
		s:ChangeType'="" AppointStatus=$p(^OEC("STAT",ChangeType),"^",2)
		s AppointStatus=##class(User.OECOrderAdminStatus).GetTranByDesc("STATDesc",AppointStatus,langid)
		s ApplyAppInfo=##class(websys.Translation).Get(cspName,"直接执行") //直接执行无预约记录
		s RecordInfo=""
		s RecordInfoRet=##class(DHCDoc.DHCDocCure.Record).GetCureRecordByDCA("",1,OEORERowID)
		if RecordInfoRet'=""{
			s DCAARowID=$p(RecordInfoRet,"^",1)
			s RecordInfo=$p(RecordInfoRet,"^",4)
		}
		s IStatusInfo="-" ;..GetStatsuInfo(myDCAAppointRowID,"I")
		s CStatusInfo=..GetStatsuInfo("","C",OEORERowID,TransExpStr)
		s DStatusInfo=..GetStatsuInfo("","D",OEORERowID,TransExpStr)
		if DStatusInfo'="-"{
			s CStatusInfo=$case(CStatusInfo,"-":DStatusInfo,:CStatusInfo_";"_DStatusInfo)
		}
		s AStatusInfo=..GetStatsuInfo("","F",OEORERowID,TransExpStr)
		s DDCRSDate=$p(ExecData,"^",1) //执行开始日期
		s DDCRSStartTime=$p(ExecData,"^",2) //执行开始时间
			
		if DCAARowID'=""{
			s ApplyAppInfo=..GetCureAppointByApply(DCARowId,DCAARowID)
			s IStatusInfo=..GetStatsuInfo(DCAARowID,"I","",TransExpStr)
		}
		s Data=$lb(OEORERowID,PatientNo,PatientName,PatientSex,PatientAge,PatientTel,$g(AdmType),$g(AdmDep),ArcimDesc,OrderReLoc,ApplyStatus,ApplyUser,ApplyDate,Job,ApplyAppInfo,RecordInfo,IStatusInfo,CStatusInfo,AStatusInfo,ApplyInfo,ApplyNo,PAAdmWard,PAAdmBed,AppointStatus)
		
		s ^||TMPQryCureProcessReport("DHCDOCCURE_SORT",DDCRSDate,DDCRSStartTime,OEORERowID)=Data
		s ^TMPQryCureProcessReport("DHCDOCCURE",UserID,Job,myind)=OEORERowID_"^"_PatientNo_"^"_PatientName_"^"_PatientSex_"^"_PatientAge_"^"_PatientTel_"^"_$g(AdmType)_"^"_$g(AdmDep)_"^"_ArcimDesc_"^"_OrderReLoc_"^"_ApplyStatus_"^"_ApplyUser_"^"_ApplyDate_"^"_ApplyAppInfo_"^"_RecordInfo_"^"_IStatusInfo_"^"_CStatusInfo_"^"_AStatusInfo_"^"_ApplyInfo
		s ^TMPQryCureProcessReport("DHCDOCCURE",UserID,Job,myind)=^TMPQryCureProcessReport("DHCDOCCURE",UserID,Job,myind)_"^"_ApplyNo_"^"_PAAdmWard_"^"_PAAdmBed_"^"_AppointStatus
		s ^TMPQryCureProcessReport("DHCDOCCURE",UserID,Job,"num")=myind
		s myind=myind+1
	}
	quit
ReserveVarCureProcess
 	set (PatientNo,PatientName,PatientSex,PatientAge,PatientTel,AdmType,AdmDep,ArcimDesc,OrderQty,BillingUOM,OrderReLoc,ApplyStatus,ApplyUser,ApplyDate,ApplyAppedTimes,ApplyNoAppTimes,ApplyFinishTimes,ApplyNoFinishTimes,OrdPrice,OrdBilled,UnitPrice,ApplyFinishUser,ApplyCureRecord,RecordInfo,IStatusInfo,CStatusInfo,AStatusInfo,ApplyInfo,ApplyNo,PAAdmWard,PAAdmBed,AppointStatus)=""
 	quit
}

/// 治疗过程状态查询
ClassMethod QryCureProcessV1Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, UserID As %String, queryLoc As %String = "", queryStatus As %String = "", queryArcim As %String = "", queryGroup As %String = "", SessionStr As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","QryCureProcess","2019-08-01","2019-08-20","10652","40","","6433||1","")
	s ^TMP("QryQryCureProcess")=$lb(StartDate,EndDate,UserID,queryLoc,queryStatus,queryArcim,queryGroup)
	s repid=$I(^CacheTemp)
	s ind=1
	s myind=1
	if StartDate'="" S StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	else  s StartDate=+$h
	if EndDate'="" S EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	else  s EndDate=+$h
	if queryStatus="ALL" s queryStatus=""
	if queryLoc'="" s queryLoc="^"_queryLoc_"^"
	s cspName="doccure.workreport.processqry.hui.csp"
	s langid=..%LanguageID()
	s TransExpStr=langid_"^"_cspName
	s Job=$j
	k ^TMPQryCureProcessReport("DHCDOCCURE",UserID)
	For QueryDate=StartDate:1:EndDate Do
	.s DCARowId=""
	.for  s DCARowId=$o(^DHCDocCure(0,"ApplyDate",QueryDate,DCARowId)) q:DCARowId=""  d
	..s CureOrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
	..Q:CureOrderId=""
	..s CureOrdReLocId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",6)
	..Q:(queryLoc'="")&&(queryLoc'[("^"_CureOrdReLocId_"^"))
	..s CureOrdArcimId=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",2)
	..q:(queryArcim'="")&&(CureOrdArcimId'=queryArcim)
	..s DCAApplyExec=$p($g(^DHCDocCure(DCARowId)),"^",19)
	..Q:(queryStatus="E")&&(DCAApplyExec'="Y")
	..Q:(queryStatus'="")&&(queryStatus'="E")&&(DCAApplyExec="Y")
	..d ReserveVarCureProcess
	..s DCAData=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
	..Q:DCAData=""
	..s ServiceGroupDR=$p($p(DCAData,$c(1),2),"^",21)
	..Q:(queryGroup'="")&&(ServiceGroupDR'=queryGroup)
	..d GetCureBaseData
	..if DCAApplyExec="Y" d
	...;直接执行
	...s OEOREChild=0
	...for  s OEOREChild=$o(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild)) Q:OEOREChild=""  d
	....d GetCureProcessData
	..else  d
	...;非直接执行 预约的
	...s DCAAChildSubRowID=0 for  s DCAAChildSubRowID=$o(^DHCDocCure(DCARowId,"Arrive",DCAAChildSubRowID)) Q:DCAAChildSubRowID=""  d
	....s DCAAStatus=$p($g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSubRowID)),"^",7)
	....q:(queryStatus'="")&&(DCAAStatus'=queryStatus)
	....d GetCureProcessData
	
	s myDDCRSDate=""
	f  s myDDCRSDate=$o(^||TMPQryCureProcessReport("DHCDOCCURE_SORT",myDDCRSDate)) q:myDDCRSDate=""  d
	.s myDDCRSStartTime=""
	.f  s myDDCRSStartTime=$o(^||TMPQryCureProcessReport("DHCDOCCURE_SORT",myDDCRSDate,myDDCRSStartTime)) q:myDDCRSStartTime=""  d
	..s myDCAAppointRowID1=""
	..f  s myDCAAppointRowID1=$o(^||TMPQryCureProcessReport("DHCDOCCURE_SORT",myDDCRSDate,myDDCRSStartTime,myDCAAppointRowID1)) q:myDCAAppointRowID1=""  d
	...set Data1=^||TMPQryCureProcessReport("DHCDOCCURE_SORT",myDDCRSDate,myDDCRSStartTime,myDCAAppointRowID1)
	...Set ^CacheTemp(repid,ind)=Data1
	...Set ind=ind+1
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
GetCureBaseData
	s Adm=$p(^DHCDocCure(DCARowId),"^",1)
	if Adm'=""{
		s AdmType=$P(^PAADM(Adm),"^",2)
		s AdmType=$case(AdmType,"O":"门诊","E":"急诊","I":"住院",:"门诊")
		s AdmDepId=$p($g(^PAADM(Adm)),"^",4)
		s:AdmDepId'="" AdmDep=$p($g(^CTLOC(AdmDepId)),"^",2)
	}
	s CureAppInfo=$p(DCAData,$c(1),2)
	s ServiceGroupDR=$p(CureAppInfo,"^",21)
	s ArcimDesc=$p(CureAppInfo,"^")
	s ArcimDesc=##class(ext.util.String).EvalJSON(ArcimDesc)
	s OrderReLoc=$p(CureAppInfo,"^",5)
	s OrdReLocId=$p(CureAppInfo,"^",6)
	s ApplyStatus=$p(CureAppInfo,"^",7)
	s ApplyUser=$p(CureAppInfo,"^",8)
	s ApplyDate=$p(CureAppInfo,"^",9)
	s ApplyInfo=ApplyDate_##class(websys.Translation).Get(cspName,"由")_ApplyUser_##class(websys.Translation).Get(cspName,"登记")
	s PatientInfo=$p(DCAData,$c(1),1)
	s PatientNo=$p(PatientInfo,"^",2)
	s PatientName=$p(PatientInfo,"^",3)
	s PatientSex=$p(PatientInfo,"^",4)
	s PatientAge=$p(PatientInfo,"^",5)
	s PatientTel=$p(PatientInfo,"^",25)
	s ApplyNo=$p(CureAppInfo,"^",31)
	s PAAdmWard=$p(CureAppInfo,"^",32)
	s PAAdmBed=$p(CureAppInfo,"^",33)
	quit

GetCureProcessData
	if DCAApplyExec="Y"{
		s OEORERowID=CureOrderId_"||"_OEOREChild
		s ExecData=$g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild))
		s ChangeDate=$p(ExecData,"^",19)
		s AppointStatus=##class(websys.Translation).Get(cspName,"未执行")
		s ChangeType=$p(ExecData,"^",16)
		s:ChangeType'="" AppointStatus=$p(^OEC("STAT",ChangeType),"^",2)
		s AppointStatus=##class(User.OECOrderAdminStatus).GetTranByDesc("STATDesc",AppointStatus,langid)
		s ApplyAppInfo="<font style='color:red'>"_##class(websys.Translation).Get(cspName,"直接执行")_"</font>" //直接执行无预约记录
		s RecordInfo=""
		s RecordInfoRet=##class(DHCDoc.DHCDocCure.Record).GetCureRecordByDCA("",1,OEORERowID)
		if RecordInfoRet'="" s RecordInfo=$p(RecordInfoRet,"^",4)
		s IStatusInfo="-" ;..GetStatsuInfo(myDCAAppointRowID,"I")
		s CStatusInfo=..GetStatsuInfo("","C",OEORERowID,TransExpStr)
		s DStatusInfo=..GetStatsuInfo("","D",OEORERowID,TransExpStr)
		if DStatusInfo'="-" s CStatusInfo=CStatusInfo_";"_DStatusInfo
		s AStatusInfo=..GetStatsuInfo("","F",OEORERowID,TransExpStr)
		s myDCAAppointRowID=OEORERowID
		s DDCRSDate=$p(ExecData,"^",1) //执行开始日期
		s DDCRSStartTime=$p(ExecData,"^",2) //执行开始时间
	}else{
		s myDCAAppointRowID=""
		s myDCAAppointRowID=DCARowId_"||"_DCAAChildSubRowID
		s AppointStatus=$case(DCAAStatus,
		"I":##class(websys.Translation).Get(cspName,"预约"),
		"A":##class(websys.Translation).Get(cspName,"完成"),
		"C":##class(websys.Translation).Get(cspName,"取消预约"),
		:"")
		s ApplyAppInfo=..GetCureAppointByApply(DCARowId,myDCAAppointRowID)
		s RecordInfo=""
		s RecordInfoRet=##class(DHCDoc.DHCDocCure.Record).GetCureRecordByDCA(myDCAAppointRowID,1)
		if RecordInfoRet'="" s RecordInfo=$p(RecordInfoRet,"^",4)
		s IStatusInfo=..GetStatsuInfo(myDCAAppointRowID,"I","",TransExpStr)
		s CStatusInfo=..GetStatsuInfo(myDCAAppointRowID,"C","",TransExpStr)
		s AStatusInfo=..GetStatsuInfo(myDCAAppointRowID,"A","",TransExpStr)
		s AppData=$g(^DHCDocCure(+myDCAAppointRowID,"Arrive",$p(myDCAAppointRowID,"||",2)))
		s DCAARBASDR=$p(AppData,"^",1)  //资源排班ID
		s ResData=$g(^DHCDocCureRBCResSchdule(DCAARBASDR))
		s DDCRSDate=$p(ResData,"^",4)  //出诊日期
		s DDCRSStartTime=$p(ResData,"^",6)  //开始时间
	}
	set Data=$lb(myDCAAppointRowID,PatientNo,PatientName,PatientSex,PatientAge,PatientTel,$g(AdmType),$g(AdmDep),ArcimDesc,OrderReLoc,ApplyStatus,ApplyUser,ApplyDate,Job,ApplyAppInfo,RecordInfo,IStatusInfo,CStatusInfo,AStatusInfo,ApplyInfo,ApplyNo,PAAdmWard,PAAdmBed,AppointStatus)
	
	s ^||TMPQryCureProcessReport("DHCDOCCURE_SORT",DDCRSDate,DDCRSStartTime,myDCAAppointRowID)=Data
	s ^TMPQryCureProcessReport("DHCDOCCURE",UserID,Job,myind)=myDCAAppointRowID_"^"_PatientNo_"^"_PatientName_"^"_PatientSex_"^"_PatientAge_"^"_PatientTel_"^"_$g(AdmType)_"^"_$g(AdmDep)_"^"_ArcimDesc_"^"_OrderReLoc_"^"_ApplyStatus_"^"_ApplyUser_"^"_ApplyDate_"^"_ApplyAppInfo_"^"_RecordInfo_"^"_IStatusInfo_"^"_CStatusInfo_"^"_AStatusInfo_"^"_ApplyInfo
	s ^TMPQryCureProcessReport("DHCDOCCURE",UserID,Job,myind)=^TMPQryCureProcessReport("DHCDOCCURE",UserID,Job,myind)_"^"_ApplyNo_"^"_PAAdmWard_"^"_PAAdmBed_"^"_AppointStatus
	s ^TMPQryCureProcessReport("DHCDOCCURE",UserID,Job,"num")=myind
	s myind=myind+1
	quit
 	
ReserveVarCureProcess
 	set (PatientNo,PatientName,PatientSex,PatientAge,PatientTel,AdmType,AdmDep,ArcimDesc,OrderQty,BillingUOM,OrderReLoc,ApplyStatus,ApplyUser,ApplyDate,ApplyAppedTimes,ApplyNoAppTimes,ApplyFinishTimes,ApplyNoFinishTimes,OrdPrice,OrdBilled,UnitPrice,ApplyFinishUser,ApplyCureRecord,RecordInfo,IStatusInfo,CStatusInfo,AStatusInfo,ApplyInfo,ApplyNo,PAAdmWard,PAAdmBed,AppointStatus)=""
 	quit
}

ClassMethod QryCureProcessClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCureProcessExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCureProcessFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCureProcessExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetQryCureProcessNum(ProcessNo As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	s num=+$g(^TMPQryCureProcessReport("DHCDOCCURE",USERID,ProcessNo,"num"))
	q num
}

ClassMethod GetQryCureProcessInfo(ProcessNo As %String, Num As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	q $g(^TMPQryCureProcessReport("DHCDOCCURE",USERID,ProcessNo,Num))
}

/// w ##class(DHCDoc.DHCDocCure.WordReport).GetStatsuInfo("","I")
ClassMethod GetStatsuInfo(DCAARowID As %String, Status As %String, OEORERowID As %String = "", TransExpStr As %String = "")
{
	s langid=$p(TransExpStr,"^",1)
	s cspName=$p(TransExpStr,"^",2)
	s StatsuInfoRet=""
	if DCAARowID'=""{
		s DCAASTATChild=""
		s DCAAStatus=$p($g(^DHCDocCure(+DCAARowID,"Arrive",$p(DCAARowID,"||",2))),"^",7)
		Q:(DCAAStatus'="A")&&(Status="A") "-"
		for  s DCAASTATChild=$o(^DHCDocCureAASTAT(DCAARowID,DCAASTATChild)) q:DCAASTATChild=""  d
		.s Update=$p(^DHCDocCureAASTAT(DCAARowID,DCAASTATChild),"^",2)
		.s Update=##class(websys.Conversions).DateLogicalToHtml(Update) ;$zd(Update,3)
		.s Uptime=$p(^DHCDocCureAASTAT(DCAARowID,DCAASTATChild),"^",3)
		.s Uptime=$zt(Uptime,2)
		.s UpStat=$p(^DHCDocCureAASTAT(DCAARowID,DCAASTATChild),"^",4)
		.Q:Status'=UpStat
		.s UpStat=$case(UpStat,"I":"预约","A":"治疗完成","C":"取消预约",:"")
		.s UpUserID=$p(^DHCDocCureAASTAT(DCAARowID,DCAASTATChild),"^",5)
		.s:UpUserID'="" UpUser=$p(^SSU("SSUSR",UpUserID),"^",2)
		.s UpUser = ##class(DHCDoc.Common.Translate).GetTransUser(UpUser,langid)
		.s info=Update_" "_Uptime_##class(websys.Translation).Get(cspName,"由")_$g(UpUser)_##class(websys.Translation).Get(cspName,UpStat)
		.if (Status="I") d ;预约只取第一条
		..s:StatsuInfoRet="" StatsuInfoRet=info
		.else  if (Status="A") d ;治疗完成取最后一条
		..s StatsuInfoRet=info
		.else  d
		..if StatsuInfoRet="" s StatsuInfoRet=info
		..else  s StatsuInfoRet=info_","_StatsuInfoRet
	}elseif OEORERowID'=""{
		s STCHChildsub=0
		for  s STCHChildsub=$o(^OEORD(+OEORERowID,"I",$p(OEORERowID,"||",2),"X",$p(OEORERowID,"||",3),"STCH",STCHChildsub)) Q:STCHChildsub=""  d
		.s Data=$g(^OEORD(+OEORERowID,"I",$p(OEORERowID,"||",2),"X",$p(OEORERowID,"||",3),"STCH",STCHChildsub))
		.s UpStat=$p(Data,"^",1)
		.s Update=$p(Data,"^",3)
		.s Update=##class(websys.Conversions).DateLogicalToHtml(Update)
		.s Uptime=$p(Data,"^",4)
		.s Uptime=$zt(Uptime,2)
		.s UpUserID=$p(Data,"^",5)
		.s UpStatCode=""
		.s:UpStat'="" UpStatCode=$p(^OEC("STAT",UpStat),"^",1)
		.Q:Status'=UpStatCode
		.s UpStat=$p(^OEC("STAT",UpStat),"^",2)
		.s UpUser=$p(^SSU("SSUSR",UpUserID),"^",2)
		.s UpUser = ##class(DHCDoc.Common.Translate).GetTransUser(UpUser,langid)
		.s info=Update_" "_Uptime_##class(websys.Translation).Get(cspName,"由")_UpUser_##class(websys.Translation).Get(cspName,UpStat)
		.if (Status="I") d ;预约只取第一条
		..s:StatsuInfoRet="" StatsuInfoRet=info
		.else  if (Status="F") d ;治疗完成取最后一条
		..s StatsuInfoRet=info
		.else  d
		..if StatsuInfoRet="" s StatsuInfoRet=info
		..else  s StatsuInfoRet=info_","_StatsuInfoRet
	}
	if StatsuInfoRet="" s StatsuInfoRet="-"
	q StatsuInfoRet
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","OPDoclookup","221","")
ClassMethod OPDoclookupExecute(ByRef qHandle As %Binary, locid As %String, RDocdesc As %String) As %Status
{
	s OPDocdesc="",rowid="0",OtherName=""
	s RDocdesc=$zcvt(RDocdesc,"U")
	if locid'=""{
		s LogLocIDStr=##CLASS(DHCDoc.DHCDocCure.Apply).GetLinkLoc(locid)
		for loccount=1:1:$l(LogLocIDStr,"^"){
			s mylocid=$p(LogLocIDStr,"^",loccount)
			continue:mylocid=""
			s RowId=0
			for{
				s RowId=$o(^RB("RES",0,"CTLOC",mylocid,RowId)) quit:RowId=""
				d GetOneDoc
			}
		}
	}else{
		for{
			s locid=$o(^RB("RES",0,"CTLOC",locid)) quit:locid=""
			s RowId=0
			for{
				s RowId=$o(^RB("RES",0,"CTLOC",locid,RowId)) quit:RowId=""
				d GetOneDoc
			}
		}
	}
	Quit $$$OK
GetOneDoc
	s DocDr=""
	if ($D(^RB("RES",RowId))){
		s DocDr=$p(^RB("RES",RowId),"^",2)
	}
	Q:DocDr=""
	s ActiveFrom=$p(^RB("RES",RowId),"^",22)
    Q:(ActiveFrom'="")&&(ActiveFrom>+$h)
    s ActiveTo=$p(^RB("RES",RowId),"^",23)
    Q:(ActiveTo'="")&&(ActiveTo<=+$h)
    s UserActive="Y"
	s Userdr=$O(^SSU("SSUSR",0,"CTPCP",DocDr,"0"))
	if Userdr'=""{
		s UserActive=$P(^SSU("SSUSR",Userdr),"^",19)
		s UserActiveDateF=$P(^SSU("SSUSR",Userdr),"^",96)
		if (UserActiveDateF'="")&&(UserActiveDateF>+$H){
			;s UserActive="N"	
		}
		s UserActiveDateT=$P(^SSU("SSUSR",Userdr),"^",97)
		if (UserActiveDateT'="")&&(UserActiveDateT'>+$H){
			;s UserActive="N"	
		}
	}
	Q:UserActive'="Y"		
	s OPDocdesc=$p(^CTPCP(DocDr,1),"^",2)
	s OPDocCode=$p(^CTPCP(DocDr,1),"^",1)
	&sql(select CTPCP_OtherName into :OtherName from SQLUser.CT_CareProv where CTPCP_RowId=:DocDr )
	s OtherName=$zcvt(OtherName,"U")
	Q:(OPDocdesc'[RDocdesc)&&(OPDocCode'=RDocdesc)&&(OtherName'=RDocdesc)&&(RDocdesc'="")
	s rowid=$O(^SSU("SSUSR",0,"CTPCP",DocDr,0))
	Q:rowid=""
	Q:$d(^||tmpOutPutArr(rowid))
	s ^||tmpOutPutArr(rowid)=""
 	d OutputRowDoc
 	Quit
OutputRowDoc
	set OPDocdesc=##class(DHCDoc.Common.Translate).GetTransDoc(OPDocdesc)
 	set qHandle($I(ind))=$lb(OPDocdesc,rowid)
	quit
}

ClassMethod OPDoclookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPDoclookupExecute ]
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

Query OPDoclookup(locid As %String, RDocdesc As %String) As %Query(ROWSPEC = "OPLocdesc:%String,rowid:%String")
{
}

/// 治疗站个人工作量报表导出
Query QryWorkReportForExport(query As %String, StartDate As %String, EndDate As %String, UserID As %String, queryDoc As %String = "", queryLoc As %String = "", queryArcim As %String = "", ExpStr As %String = "") As %Library.Query(ROWSPEC = "FinishUser:%String:执行人,ArcimDesc:%String:治疗项目,UnitPrice:%String:单价(元),OrderQty:%String:执行数量,OrdPrice:%String:总金额")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocIPBookingCtl","QryWorkReportForExport","2019-12-30","2020-01-20","","","","",10209,2,"")
ClassMethod QryWorkReportForExportExecute(ByRef qHandle As %Library.Binary, query As %String, StartDate As %String, EndDate As %String, UserID As %String, queryDoc As %String = "", queryLoc As %String = "", queryArcim As %String = "", ExpStr As %String = "") As %Library.Status
{
	s repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s cspName=$p(ExpStr,"^",3)
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.WordReport:QryWorkReportFor")
	d rset.Execute(query,StartDate,EndDate,UserID,queryDoc,queryLoc,queryArcim,ExpStr)
	While (rset.Next()) {
		s ArcimDesc=rset.Data("ArcimDesc")
		s UnitPrice=rset.Data("UnitPrice")
		if (UnitPrice'="-") s UnitPrice=UnitPrice_##class(websys.Translation).Get(cspName,"元")
		s OrdBillUOM=rset.Data("OrdBillUOM")
		if (OrdBillUOM'="")&(OrdBillUOM'="-") s OrdBillUOM="/"_OrdBillUOM
		if (OrdBillUOM="-") s OrdBillUOM=""
		s OrderQty=rset.Data("OrderQty")_OrdBillUOM
		s OrdPrice=rset.Data("OrdPrice")_##class(websys.Translation).Get(cspName,"元")
		s FinishUser=rset.Data("FinishUser")
		s OutputList=$lb(FinishUser,ArcimDesc,UnitPrice,OrderQty,OrdPrice)
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

ClassMethod QryWorkReportForExportFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryWorkReportForExportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryWorkReportForExportClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryWorkReportForExportFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 治疗站科室工作量报表导出
Query QryWorkReportForLocExport(query As %String, StartDate As %String, EndDate As %String, UserID As %String, queryDoc As %String = "", queryLoc As %String = "", queryArcim As %String = "") As %Library.Query(ROWSPEC = "ArcimDesc:%String:治疗项目,UnitPrice:%String:单价(元),OrderQty:%String:执行数量,OrdPrice:%String:总金额,LocDesc:%String:科室")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocIPBookingCtl","QryWorkReportForExport","2019-12-30","2020-01-20","","","","",10209,2,"")
ClassMethod QryWorkReportForLocExportExecute(ByRef qHandle As %Library.Binary, query As %String, StartDate As %String, EndDate As %String, UserID As %String, queryDoc As %String = "", queryLoc As %String = "", queryArcim As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.WordReport:QryWorkReportFor")
	d rset.Execute(query,StartDate,EndDate,UserID,queryDoc,queryLoc,queryArcim)
	While (rset.Next()) {
		s ArcimDesc=rset.Data("ArcimDesc")
		s UnitPrice=rset.Data("UnitPrice")
		if (UnitPrice'="-") s UnitPrice=UnitPrice_"元"	
		s OrdBillUOM=rset.Data("OrdBillUOM")
		if (OrdBillUOM'="")&(OrdBillUOM'="-") s OrdBillUOM="/"_OrdBillUOM
		if (OrdBillUOM="-") s OrdBillUOM=""
		s OrderQty=rset.Data("OrderQty")_OrdBillUOM
		s OrdPrice=rset.Data("OrdPrice")_"元"
		s LocDesc=rset.Data("TLocDesc")
		s OutputList=$lb(ArcimDesc,UnitPrice,OrderQty,OrdPrice,LocDesc)
		d OutputRow15
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow15
	set Data=OutputList
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryWorkReportForLocExportFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryWorkReportForLocExportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryWorkReportForLocExportClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryWorkReportForLocExportFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 治疗结果纪录导出
Query QryRecordReportExport(StartDate As %String, EndDate As %String, UserID As %String, queryLoc As %String = "", queryDoc As %String = "", queryArcim As %String = "", queryAdmID As %String = "", queryPatID As %String = "", queryApplyNo As %String = "", ExpStr As %String = "") As %Library.Query(ROWSPEC = "PatientNo:%String:登记号,PatientName:%String:患者姓名,ApplyNo:%String:申请单号,ArcimDesc:%String:治疗项目,OrderDate:%String:开单日期,OrderLoc:%String:开单科室,OrderRecLoc:%String:接收科室,FinishUser:%String:执行人,ExcuteRet:%String:执行结果,DCRResponse:%String:治疗反应,DCREffect:%String:治疗效果,DCRCureDate:%String:治疗日期,DCRCureTime:%String:治疗时间,UnitPrice:%String:单价(元),OrderQty:%String:执行数量,OrdBillUOM:%String:单位,OrdPrice:%String:总金额(元),CreateUserDR:%String:用户编号")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","QryRecordReportExport","2021-03-02","2021-03-20","","","","",10209,2,"")
ClassMethod QryRecordReportExportExecute(ByRef qHandle As %Library.Binary, StartDate As %String, EndDate As %String, UserID As %String, queryLoc As %String = "", queryDoc As %String = "", queryArcim As %String = "", queryAdmID As %String = "", queryPatID As %String = "", queryApplyNo As %String = "", ExpStr As %String = "") As %Library.Status
{
	Set ind=0
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.WordReport:QryRecordReport")
	d rset.Execute(StartDate,EndDate,UserID,queryLoc,queryDoc,queryArcim,queryAdmID,queryPatID,queryApplyNo,ExpStr)
	While (rset.Next()) {
		s PatientNo=rset.Data("PatientNo")
		s PatientName=rset.Data("PatientName")	
		s ApplyNo=rset.Data("ApplyNo")
		s ArcimDesc=rset.Data("ArcimDesc")
		s OrderDate=rset.Data("OrderDate")
		s OrderLoc=rset.Data("OrderLoc")
		s OrderRecLoc=rset.Data("OrderRecLoc")
		s CreateUserDR=rset.Data("CreateUserDR")
		s FinishUser=rset.Data("FinishUser")
		s ExcuteRet=rset.Data("ExcuteRet")
		s DCRResponse=rset.Data("DCRResponse")
		s DCREffect=rset.Data("DCREffect")
		s CureDate=rset.Data("CureDate")
		s UnitPrice=rset.Data("UnitPrice")
		s OrderQty=rset.Data("OrderQty")
		s OrdBillUOM=rset.Data("OrdBillUOM")
		s OrdPrice=rset.Data("OrdPrice")
		s (DCRCureDate,DCRCureTime)=""
		if CureDate'=""{
			s DCRCureDate=$p(CureDate," ",1)	
			s DCRCureTime=$p(CureDate," ",2)	
		}
		s ExcuteRet=##class(ext.util.String).Replace(ExcuteRet,$c(10),";")
		s DCRResponse=##class(ext.util.String).Replace(DCRResponse,$c(10),";")
		s DCREffect=##class(ext.util.String).Replace(DCREffect,$c(10),";")
		s OutputList=$lb(PatientNo,PatientName,ApplyNo,ArcimDesc,OrderDate,OrderLoc,OrderRecLoc,FinishUser,ExcuteRet,DCRResponse,DCREffect,DCRCureDate,DCRCureTime,UnitPrice,OrderQty,OrdBillUOM,OrdPrice,CreateUserDR)
		d OutputRow16
	}
	Quit $$$OK
	
OutputRow16
	set Data=OutputList
	Set qHandle($I(ind))=Data
	quit
}

ClassMethod QryRecordReportExportFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryRecordReportExportExecute ]
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

/// 治疗预约统计查询导出
Query QryWorkReportExport(DateType As %String, StartDate As %String, EndDate As %String, UserID As %String, queryLoc As %String = "", queryStatus As %String = "", queryArcim As %String = "", queryGroup As %String = "", queryOrderLoc As %String = "") As %Library.Query(ROWSPEC = "PatNo:%String:登记号,PatName:%String:姓名,PatSex:%String:性别,PatAge:%String:年龄,CureDate:%String:申请日期,ArcimDesc:%String:治疗项目,UnitPrice:%String:单价(元),OrdQty:%String:数量,OrdPrice:%String:总金额,OrdBilled:%String:是否缴费,OrdReLoc:%String:接收科室,ApplyStatus:%String:申请单状态,ApplyAppedTimes:%String:已预约次数,ApplyNoAppTimes:%String:未预约次数,ApplyFinishTimes:%String:已治疗次数,ApplyNoFinishTimes:%String:未治疗次数,ApplyCureRecord:%String:预约明细")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocIPBookingCtl","QryWorkReportExport","2019-12-30","2020-01-20","","","","",10209,2,"")
ClassMethod QryWorkReportExportExecute(ByRef qHandle As %Library.Binary, DateType As %String, StartDate As %String, EndDate As %String, UserID As %String, queryLoc As %String = "", queryStatus As %String = "", queryArcim As %String = "", queryGroup As %String = "", queryOrderLoc As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.WordReport:QryWorkReport")
	d rset.Execute(DateType,StartDate,EndDate,UserID,queryLoc,queryStatus,queryArcim,queryGroup,queryOrderLoc)
	While (rset.Next()) {
		s PatNo=rset.Data("PatNo")
		s PatName=rset.Data("PatName")	
		s PatSex=rset.Data("PatSex")
		s PatAge=rset.Data("PatAge")
		s CureDate=rset.Data("CureDate")
		s ArcimDesc=rset.Data("ArcimDesc")
		s UnitPrice=rset.Data("UnitPrice")
		s OrdBillUOM=rset.Data("OrdBillUOM")
		s OrdQty=rset.Data("OrdQty")_OrdBillUOM
		s OrdPrice=rset.Data("OrdPrice")
		s OrdBilled=rset.Data("OrdBilled")
		s OrdReLoc=rset.Data("OrdReLoc")
		s ApplyStatus=rset.Data("ApplyStatus")
		s ApplyAppedTimes=rset.Data("ApplyAppedTimes")
		s ApplyNoAppTimes=rset.Data("ApplyNoAppTimes")
		s ApplyFinishTimes=rset.Data("ApplyFinishTimes")
		s ApplyNoFinishTimes=rset.Data("ApplyNoFinishTimes")
		s ApplyFinishUser=rset.Data("ApplyFinishUser")
		s ApplyCureRecord=rset.Data("ApplyCureRecord")
		s ApplyCureRecord=$tr(ApplyCureRecord,"<br>",";")
		s OutputList=$lb(PatNo,PatName,PatSex,PatAge,CureDate,ArcimDesc,UnitPrice,OrdQty,OrdPrice,OrdBilled,OrdReLoc,ApplyStatus,ApplyAppedTimes,ApplyNoAppTimes,ApplyFinishTimes,ApplyNoFinishTimes,ApplyCureRecord)
		d OutputRow17
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow17
	set Data=OutputList
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryWorkReportExportFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryWorkReportExportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryWorkReportExportClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryWorkReportExportFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

Query QueryWardCureAppoint(StartDate As %String, EndDate As %String, qWardID As %String = "", PatientNo As %String = "", qRecLocID As %String = "", qResGroupID As %String = "", qCureStatus As %String = "", SessionStr As %String = "") As %Query(ROWSPEC = "QueId:%String,QueDept:%String,QueDate:%String,ResDesc:%String,ASDate:%String,TimeRange:%String,SchedStTime:%String,SchedEdTime:%String,DDCRSStatus:%String,QueOperUser:%String,QueStatusDate:%String,DCAAStatus:%String,PatNo:%String,PatName:%String,QueNo:%String")
{
}

/// qDateType="A" 按照预约时间查询 qDateType="" 按照申请时间查询
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","QueryWardCureAppoint","2022-12-26","2023-02-21","8","","","","","doccure.workreport.wardappoint.hui.csp^18885^23^13^2^8^20") 
ClassMethod QueryWardCureAppointExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, qWardID As %String = "", PatientNo As %String = "", qRecLocID As %String = "", qResGroupID As %String = "", qCureStatus As %String = "", SessionStr As %String = "") As %Status
{
	s ^tmplog("QueryWardCureAppoint")=$lb(StartDate, EndDate , qWardID, PatientNo , qRecLocID , qResGroupID , qCureStatus,SessionStr)
	s cspName=$p(SessionStr,"^",1)	
	s LogLocID=$p(SessionStr,"^",4)
	s HospID=$p(SessionStr,"^",5)	
	s langid=$p(SessionStr,"^",7)	
	s:HospID="" HospID=$g(%session.Get("LOGON.HOSPID"))
	s:langid="" langid=..%LanguageID()
	
	if StartDate'="" S StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	else  s StartDate=+$H
	if EndDate'="" S EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	else  s EndDate=+$H
	s qCureStatus=$case(qCureStatus,"I":"^Report^Wait^Pass^","C":"^Cancel^","A":"^Complete^",:"")
	K FindPatAry
 	if PatientNo'=""{
		;传入患者ID按照患者查询
		s PatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))
		if (PatientID=""){
			Quit $$$OK
		}
		s FindCurrWard=0
		s PAAdmType="" 
		for{
			s PAAdmType=$O(^PAPERdr(PatientID,"ADM",PAAdmType)) Quit:PAAdmType=""
			continue:PAAdmType'="I"
			Q:FindCurrWard=1
			s PAAdm=0
			for{
				s PAAdm=$O(^PAPERdr(PatientID,"ADM",PAAdmType,PAAdm)) Quit:PAAdm=""
				Q:FindCurrWard=1
				s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
				continue:(AdmVisitStatus="C")||(AdmVisitStatus="D") //退号、已经出院的不再展示
				s AdmWardID=$P($g(^PAADM(PAAdm)),"^",20)
				continue:(qWardID="")&&(AdmWardID=qWardID)
				s FindCurrWard=1
			}
		}
		if FindCurrWard=1{
			d GetQueByPat
		}
	}
	elseif (qWardID'="") {
		set roomID=""
		for{
			s roomID=$o(^PAADMi("CurrWard",qWardID,roomID)) q:roomID=""
			s PAAdm=""
			for{
			  	s PAAdm=$o(^PAADMi("CurrWard",qWardID,roomID,PAAdm)) q:PAAdm=""
				s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
				continue:(AdmVisitStatus="C")||(AdmVisitStatus="D") //退号、已经出院的不再展示
				s PatientID=$P($G(^PAADM(PAAdm)),"^",1)
				continue:($d(FindPatAry(PatientID)))
				s FindPatAry(PatientID)=""
			}
		}
		if $d(FindPatAry){
			s PatientID=""
			for{
				s PatientID=$o(FindPatAry(PatientID))
				Q:PatientID=""
				d GetQueByPat
			}
		}
	}else{
		for QueryDate=StartDate:1:EndDate{
			if qRecLocID'=""{
				s QueryLocID=qRecLocID
				d GetQueByLoc
			}else{
				s QueryLocID=""
				for{
					s QueryLocID=$o(^User.DHCDocCureQueueI("IndexDateDep",QueryDate,QueryLocID))
					q:QueryLocID=""
					d GetQueByLoc
				}
			}
		}
	}
	
 	Quit $$$OK
GetQueByPat
 	s QueId=0
	for{
		s QueId=$o(^User.DHCDocCureQueueI("IndexPAPMI",PatientID,QueId))
		q:QueId=""
		s OutputFlag=$$CheckIfOutput()
		continue:OutputFlag=0
		d OutPutOneQue
	}
	q
GetQueByLoc
 	s QueId=0 
	for{
		s QueId=$o(^User.DHCDocCureQueueI("IndexDateDep",QueryDate,QueryLocID,QueId))
		q:QueId=""
		s OutputFlag=$$CheckIfOutput()
		continue:OutputFlag=0
		d OutPutOneQue
	}
	q
CheckIfOutput()
	s OutputFlag=1
	s QueDate=$lg(^User.DHCDocCureQueueD(QueId),5)
	s:(StartDate'="")&&(QueDate<StartDate) OutputFlag=0
	s:(EndDate'="")&&(QueDate>EndDate) OutputFlag=0
	s QueRBASDr=$lg(^User.DHCDocCureQueueD(QueId),2)	
	s:QueRBASDr="" OutputFlag=0
	if qResGroupID'=""{
		s QueRBASServiceGroupDR=$p($g(^DHCDocCureRBCResSchdule(QueRBASDr)),"^",8) 
		s:qResGroupID'=QueRBASServiceGroupDR OutputFlag=0
	}
	if qRecLocID'=""{
		s QueDept=$lg(^User.DHCDocCureQueueD(QueId),8)
		s:qRecLocID'=QueDept OutputFlag=0
	}
	if qCureStatus'=""{
		s QueStatusDr=$lg(^User.DHCDocCureQueueD(QueId),9)
		s QueStatusCode=$p($g(^DHCDocCurePS(QueStatusDr)),"^",1)
		s:(qCureStatus'[QueStatusCode) OutputFlag=0
	}
	q OutputFlag
OutPutOneQue
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
		
		s SortDate=$lg(^User.DHCDocCureQueueD(QueId),5)
		s QueRBASDr=$lg(^User.DHCDocCureQueueD(QueId),2)	
		s SortTimeRange=$p($g(^DHCDocCureRBCResSchdule(QueRBASDr)),"^",5)			
		s SortNo=+$lg(^User.DHCDocCureQueueD(QueId),4)
		s SortVal=SortDate_SortTimeRange
		s Data=$lb(QueId,QueDept,QueDate,ResDesc,ASDate,TimeRange,SchedStTime,SchedEdTime,DDCRSStatus,QueOperUser,QueStatusDate,DCAAStatus,PatNo,PatName,QueNo)
	 	s qHandle(SortVal,SortNo,$I(ind))=Data
	}
 	quit
}

ClassMethod QueryWardCureAppointFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWardCureAppointExecute ]
{
	s SortVal=$O(qHandle(""))
	if SortVal'=""{
		s SortNo=$O(qHandle(SortVal,""))
		if SortNo'=""{
			s ind=$O(qHandle(SortVal,SortNo,""))
			if ind'=""{
				s Row=qHandle(SortVal,SortNo,ind)
				k qHandle(SortVal,SortNo,ind)
				Quit $$$OK
			}
		}
	}
	s AtEnd=1
	Quit $$$OK
}

Query QueryWardCureAppointV1(StartDate As %String, EndDate As %String, qWardID As %String = "", PatientNo As %String = "", qArcimID As %String = "", qRecLocID As %String = "", qResGroupID As %String = "", qCureStatus As %String = "", qDateType As %String = "", qExpStr As %String = "") As %Query(ROWSPEC = "DCAARowId:%String,PatientNo:%String,PatientName:%String,ApplyStatus:%String,ApplyDate:%String,ApplyUser:%String,DDCRSLoc:%String,CTCareProv:%String,DDCRSDate:%String,TimeRangeDesc:%String,StartTime:%String,EndTime:%String,ServiceGroupDesc:%String,DDCRSStatus:%String,ReqUser:%String,ReqDate:%String,DCAAStatus:%String,LastUpdateUser:%String,LastUpdateDate:%String,OEOREDR:%String,ArcimDesc:%String,PatOther:%String,CureApplyNo:%String,DCASeqNo:%String,AdmRowID:%String,DCAAQty:%String,PAAdmWard:%String,OrderReLoc:%String")
{
}

/// qDateType="A" 按照预约时间查询 qDateType="" 按照申请时间查询
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","QueryWardCureAppoint","2020-06-30","2020-08-04","21","","","","","","") 
ClassMethod QueryWardCureAppointV1Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, qWardID As %String = "", PatientNo As %String = "", qArcimID As %String = "", qRecLocID As %String = "", qResGroupID As %String = "", qCureStatus As %String = "", qDateType As %String = "", qExpStr As %String = "") As %Status
{
	s ^tmplog("QueryWardCureAppoint")=$lb(StartDate, EndDate , qWardID, PatientNo , qArcimID , qRecLocID , qResGroupID , qCureStatus, qDateType,qExpStr)
	s AppStartDate=""
	s AppEndDate=""
	
	if StartDate'="" S StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	if EndDate'="" S EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	if qDateType="A"{
		s AppStartDate=StartDate
		s AppEndDate=EndDate
		s StartDate=""
		s EndDate=""
	}
	s HospID="",langid=""
	if qExpStr'=""{
		s HospID=$p(qExpStr,"^",1)	
		s langid=$p(qExpStr,"^",2)	
	}
	;s qRecLocIDStr=##class(DHCDoc.DHCDocCure.Apply).GetLinkLoc(qRecLocID)
 	if PatientNo'=""{
		;传入患者ID按照患者查询订单
		s PatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))
		if (PatientID=""){
			Quit $$$OK
		}
		s PAAdmType="" 
		for{
			s PAAdmType=$O(^PAPERdr(PatientID,"ADM",PAAdmType)) Quit:PAAdmType=""
			continue:PAAdmType'="I"
			s PAAdm=0
			for{
				s PAAdm=$O(^PAPERdr(PatientID,"ADM",PAAdmType,PAAdm)) Quit:PAAdm=""
				s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
				continue:(AdmVisitStatus="C")||(AdmVisitStatus="D") //退号、已经出院的不再展示
				s AdmWardID=$P($g(^PAADM(PAAdm)),"^",20)
				continue:(qWardID="")&&(AdmWardID=qWardID)
				d GetDCAByAdm
			}
		}	
	}
	elseif (qWardID'="") {
		set roomID=""
		for{
			s roomID=$o(^PAADMi("CurrWard",qWardID,roomID)) q:roomID=""
			s PAAdm=""
			for{
			  	s PAAdm=$o(^PAADMi("CurrWard",qWardID,roomID,PAAdm)) q:PAAdm=""
				s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
				continue:(AdmVisitStatus="C")||(AdmVisitStatus="D") //退号、已经出院的不再展示
				d GetDCAByAdm
			}
		}
	}else{
		if qDateType="A"{
			if AppStartDate="" s AppStartDate=+$h
			if AppEndDate="" s AppEndDate=+$h	
			s ResLocID=""
			for {
				s ResLocID=$o(^DHCDocCureRBCResSchdule(0,"LocId-Res-Date",ResLocID)) q:ResLocID=""
				s ResRowId=""
				for{
					s ResRowId=$o(^DHCDocCureRBCResSchdule(0,"LocId-Res-Date",ResLocID,ResRowId)) q:ResRowId=""
					for QueryDate=AppStartDate:1:AppEndDate{
						s RSRowId=""
						for{
							s RSRowId=$o(^DHCDocCureRBCResSchdule(0,"LocId-Res-Date",ResLocID,ResRowId,QueryDate,RSRowId)) q:RSRowId=""
							s DDCRSStatus=$p($g(^DHCDocCureRBCResSchdule(RSRowId)),"^",9)
							continue:DDCRSStatus'="N"
							s DCARowId=""
							for{
								s DCARowId=$o(^DHCDocCure(0,"RBAS",RSRowId,DCARowId))  Q:DCARowId=""
								continue:$$CheckQuitApply(DCARowId)=1
								d GetCureApplyData
								s DCAAChildSub=0
								for{
									s DCAAChildSub=$o(^DHCDocCure(0,"RBAS",RSRowId,DCARowId,DCAAChildSub)) q:DCAAChildSub=""
									s DCAARowId=DCARowId_"||"_DCAAChildSub
									s DCAAStatus=$p($g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2))),"^",7)
									continue:(qCureStatus'="")&&(qCureStatus'[DCAAStatus)
									d GetCureAppointData
								}
							}
						}
					}
				}
			}
		}else{
			if StartDate="" s StartDate=+$h
			if EndDate="" s EndDate=+$h
			for QueryDate=StartDate:1:EndDate{
				s DCARowId=0
				for{
					s DCARowId=$o(^DHCDocCure(0,"ApplyDate",QueryDate,DCARowId)) q:DCARowId=""
					continue:$$CheckQuitApply(DCARowId)=1
					s OnePerson(DCARowId)=""
				}
			}
		}
	}
	
	if $d(OnePerson){
		s DCARowId=""
		for{
			s DCARowId=$o(OnePerson(DCARowId)) Q:DCARowId=""
			d GetCureApplyData
			s DCAAChildSub=0
			for{
				s DCAAChildSub=$o(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)) q:DCAAChildSub=""
				s DCAARowId=DCARowId_"||"_DCAAChildSub
				s DCAAStatus=$p($g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2))),"^",7)
				continue:(qCureStatus'="")&&(qCureStatus'[DCAAStatus)
				s DCAARBASDR=$p($g(^DHCDocCure(+DCARowId,"Arrive",DCAAChildSub)),"^",1)
				continue:DCAARBASDR=""
				s DDCRSDate=$p($g(^DHCDocCureRBCResSchdule(DCAARBASDR)),"^",4)
				continue:(AppStartDate'="")&&(DDCRSDate<AppStartDate)
				continue:(AppEndDate'="")&&(DDCRSDate>AppEndDate)
				d GetCureAppointData
			}
		}
	}
 	Quit $$$OK
GetCureApplyData 
 	s rtn=##class(DHCDoc.DHCDocCure.Apply).GetSimpleCureApply(DCARowId,"",HospID)
	Q:rtn="" 
	s PatientInfo=$p(rtn,$c(1),1)
	s PatientID=$p(PatientInfo,"^",1)
	s PatientNo=$p(PatientInfo,"^",2)
	s PatientName=$p(PatientInfo,"^",3)
	s PatientSex=$p(PatientInfo,"^",4)
	s PatientAge=$p(PatientInfo,"^",5)
	s PatientTel=$p(PatientInfo,"^",25)
	s CureAppInfo=$p(rtn,$c(1),2)
	s ArcimDesc=$p(CureAppInfo,"^")
	s OrderReLoc=$p(CureAppInfo,"^",14)
	s ApplyStatus=$p(CureAppInfo,"^",8)
	s ApplyUser=$p(CureAppInfo,"^",9)
	s ApplyDate=$p(CureAppInfo,"^",10) 
	s CureApplyNo=$p(CureAppInfo,"^",13)
	s AdmRowID=$p($g(^DHCDocCure(DCARowId)),"^",1)
	s AdmType=$P(^PAADM(AdmRowID),"^",2)
	s AdmInfo=$p(rtn,$c(1),3)
	s AdmTypeDesc=$p(AdmInfo,"^",1)
	s AdmDep=$p(AdmInfo,"^",2)
	s PatOther=PatientSex_" | "_PatientAge_" | "_PatientTel_" | "_AdmTypeDesc_"("_AdmDep_")"
	Quit
GetCureAppointData
	s Data=##class(DHCDoc.DHCDocCure.Appointment).GetCureAppointment(DCAARowId)
	s ASData=$p(Data,$c(1),1)
	s AppData=$p(Data,$c(1),2)
	;------排班信息-------
	s DDCRSLoc=$p(ASData,"^",2)   //治疗科室
	s CTCareProv=$p(ASData,"^",4)  //预约资源
	s DDCRSDate=$p(ASData,"^",5)   //预约日期
	s TimeRangeDesc=$p(ASData,"^",7)  //预约时间段
	s StartTime=$p(ASData,"^",8)
	s SortStartTime=$zth(StartTime,3)
	s EndTime=$p(ASData,"^",9)
	s ServiceGroupDesc=$p(ASData,"^",11)  //服务组
	s DDCRSStatus=$p(ASData,"^",12)   //排班状态
	;------预约信息--------
	s OEOREDR=$p(AppData,"^",2)
	s PatientMedicare=##class(web.DHCDocOrderCommon).GetMrNo("",PatientID,AdmType,"")
	s ReqUser=$p(AppData,"^",4)
	s ReqDate=$p(AppData,"^",5)
	s ReqTime=$p(AppData,"^",6)
	s ReqDate=ReqDate_" "_ReqTime
	s ReqType=$p(AppData,"^",7)
	s DCAAStatus=$p(AppData,"^",8)
	s LastUpdateUser=$p(AppData,"^",10)
	s LastUpdateDate=$p(AppData,"^",11)
	s LastUpdateTime=$p(AppData,"^",12)
	s LastUpdateDate=LastUpdateDate_" "_LastUpdateTime
	s CallStatus=$p(AppData,"^",14)
	s DCASeqNo=$p(AppData,"^",15)
	s DCAAQty=$p(AppData,"^",16)
	s PAAdmWard=""
	s WardDr=$P($g(^PAADM(AdmRowID)),"^",70)
	if WardDr'="" {
		s PAAdmWard=$P($g(^PAWARD(WardDr)),"^",2)
		s PAAdmWard=##class(User.PACWard).GetTranByDesc("WARDDesc",PAAdmWard,langid)
	}
	
	d OutputWardCureAppointData
	quit
OutputWardCureAppointData
	set Data=$lb(DCAARowId,$g(PatientNo),$g(PatientName),ApplyStatus,ApplyDate,ApplyUser,DDCRSLoc,CTCareProv,DDCRSDate,TimeRangeDesc,StartTime,EndTime,ServiceGroupDesc,DDCRSStatus,ReqUser,ReqDate,DCAAStatus,LastUpdateUser,LastUpdateDate,OEOREDR,ArcimDesc,PatOther,CureApplyNo,DCASeqNo,AdmRowID,DCAAQty,PAAdmWard,OrderReLoc)
	set qHandle($I(ind))=Data
	quit
GetDCAByAdm
	s DCARowId=0
	for{
		s DCARowId=$o(^DHCDocCure(0,"Adm",PAAdm,DCARowId)) q:DCARowId=""
		continue:$$CheckQuitApply(DCARowId)=1
		s OnePerson(DCARowId)=""
	} 
	Quit
CheckQuitApply(DCARowId)
	Set QuitFlag=1
	Set ApplyDate=$p(^DHCDocCure(DCARowId),"^",5)
	if ((StartDate'="")&&(ApplyDate<StartDate))!((EndDate'="")&&(ApplyDate>EndDate)){
		Q QuitFlag
	}
	Set OrderId=$p(^DHCDocCure(DCARowId),"^",2)
	if OrderId=""{
		Q QuitFlag
	}
	Set ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
	if (qArcimID'="")&&(qArcimID'=ArcimId){
		Q QuitFlag
	}
	Set OrdReLocId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3)),"^",6)
	;if (qRecLocIDStr'="")&&(("^"_qRecLocIDStr_"^")'[("^"_OrdReLocId_"^")){
	if (qRecLocID'="")&&(qRecLocID'=OrdReLocId){
		Q QuitFlag	
	}
	Set HospitalId=$P(^CTLOC(OrdReLocId),"^",22)
	if (HospID'="")&&(HospID'=HospitalId){
		Q QuitFlag	
	}
	Set DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(ArcimId,HospID)
	if DDCISRowid=""{
		Q QuitFlag
	}
	Set ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
	if (qResGroupID'="")&&(qResGroupID'=ServiceGroupDR){
		Q QuitFlag
	}
	Q 0
}

ClassMethod QueryWardCureAppointV1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWardCureAppointV1Execute ]
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

ClassMethod GetAppointmentListNum(ProcessNo As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	s num=+$g(^TMPFindAppointmentList("DHCDOCCURE",USERID,ProcessNo,"num"))
	q num
}

ClassMethod GetAppointmentListInfo(ProcessNo As %String, Num As %String, USERID As %String) As %String
{
	s:USERID="" USERID=%session.Get("LOGON.USERID")
	q $g(^TMPFindAppointmentList("DHCDOCCURE",USERID,ProcessNo,Num))
}

/// 治疗站个人工作量报表导出
Query FindAppointmentListExport(DCARowId As %String, QueryState As %String = "", ResSchduleId As %String = "", ExpStr As %String = "") As %Library.Query(ROWSPEC = "CureApplyNo:%String:申请单号,PatientNo:%String:患者登记号,PatientName:%String:患者姓名,ArcimDesc:%String:治疗项目,OrderQty:%String:总数量,DCAAQty:%String:预约治疗数量,DCASeqNo:%String:排队序号,DCAAStatus:%String:预约状态")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","QryWorkReportForExport","2019-12-30","2020-01-20","","","","",10209,2,"")
ClassMethod FindAppointmentListExportExecute(ByRef qHandle As %Library.Binary, DCARowId As %String, QueryState As %String = "", ResSchduleId As %String = "", ExpStr As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.Appointment:FindAppointmentList")
	d rset.Execute(DCARowId,QueryState,ResSchduleId,ExpStr)
	While (rset.Next()) {
		;CureApplyNo_"^"_PatientNo_"^"_PatientName_"^"_ArcimDesc_"^"_OrderQty_"^"_DCAAQty_"^"_DCASeqNo_"^"_DCAAStatus
		s CureApplyNo=rset.Data("CureApplyNo")
		s PatientNo=rset.Data("PatientNo")
		s PatientName=rset.Data("PatientName")
		s ArcimDesc=rset.Data("ArcimDesc")
		
		s OrderQty=rset.Data("OrderQty")
		s DCAAQty=rset.Data("DCAAQty")
		s DCASeqNo=rset.Data("DCASeqNo")
		s DCAAStatus=rset.Data("DCAAStatus")
		s OutputList=$lb(CureApplyNo,PatientNo,PatientName,ArcimDesc,OrderQty,DCAAQty,DCASeqNo,DCAAStatus)
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
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAppointmentListExportClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAppointmentListExportExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod patnamelookupExecute(ByRef qHandle As %Binary, PatID As %String, PatName As %String, HospDr As %String = "", ExpStr As %String = "") As %Status
{
 	i (PatName="")&&(PatID="") {
      	Quit $$$OK
    }
    s HospID=$p(ExpStr,"^",1)
	s langid=$p(ExpStr,"^",2)
	s cspName=$p(ExpStr,"^",3)
    s:langid="" langid=..%LanguageID()
    s HospDr=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospDr)
	i $g(PatName)'="" s PatName=$$ALPHAUP^SSUTIL4(PatName)
	if PatID'=""{
		s PAPMIDr=PatID
		d GetAdm	
	}else{
		s PAPMIDr=0
		for{
			s PAPMIDr=$o(^PAPERi("PAPER_PatName",PatName,PAPMIDr))
			q:PAPMIDr=""
			d GetAdm
		}
	}
	Quit $$$OK
GetAdm
    s PatNo=$p($g(^PAPER(PAPMIDr,"PAT",1)),"^",1)
	s Name=$p($g(^PAPER(PAPMIDr,"ALL")),"^",1)
	s PatSexDR=$p($g(^PAPER(PAPMIDr,"ALL")),"^",7)
	s PatSex=""
	i PatSexDR'="" s PatSex=$p(^CT("SEX",PatSexDR),"^",2)
	s PatSex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",PatSex,langid)
	s Birth=+$p(^PAPER(PAPMIDr,"ALL"),"^",6) 
	s Birth=##class(websys.Conversions).DateLogicalToHtml(Birth)
	s InPatLoc=""
	s AdmType=""
	for{
		s AdmType=$o(^PAPERdr(PAPMIDr,"ADM",AdmType)) 
		Q:AdmType=""
		;$case(AdmType,"I":"住院","E":"急诊","O":"门诊",:"其他")
		s PaadmRowid=""
		for {
			s PaadmRowid=$o(^PAPERdr(PAPMIDr,"ADM",AdmType,PaadmRowid),-1) 
			q:PaadmRowid=""
			s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(PaadmRowid)
			continue:(HospDr'="")&&(AdmHospitalId'=HospDr)
			s AdmTypeDesc=##class(DHCDoc.Common.Translate).GetTransAdmType(PaadmRowid,cspName,langid)
			s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20)
			s AdmDepCodeDR=$p($g(^PAADM(PaadmRowid)),"^",4)
			if (AdmDepCodeDR'="") {
				s InPatLoc=..GetLocDesc(AdmDepCodeDR,langid)
			} 
			s VisitStatus=##class(DHCDoc.Common.Translate).GetTransAdmStat(PaadmRowid,cspName,langid)
			;$case(VisitStatus,"A":"正常","C":"退号或退院","D":"出院",:"其他")
			s PaadmNo=$P($g(^PAADM(PaadmRowid)),"^",81)
			s PaadmDate=$P($G(^PAADM(PaadmRowid)),"^",6)
			s PaadmDate=##class(websys.Conversions).DateLogicalToHtml(PaadmDate)
			Do OutputRow
		}
	}
	quit
OutputRow
	set Data=$lb(PatNo,Name,Birth,PatSex,PaadmNo,VisitStatus,InPatLoc,PaadmRowid,AdmTypeDesc,PaadmDate)
 	set qHandle($I(ind))=Data
	quit
}

ClassMethod patnamelookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = patnamelookupExecute ]
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

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","patnamelookup","","测试1","2") 
Query patnamelookup(PatID As %String, PatName As %String, HospDr As %String = "", ExpStr As %String = "") As %Query(ROWSPEC = "PatNo:%String:登记号,PatName:%String:患者姓名^80,Birth:%String:出生日期^80,PatSex:%String:性别^60,PaadmNo:%String:就诊号^80,InPatFlag:%String:状态^80,InPatLoc:%String:在院科室^120,PaadmRowid:%String,AdmTypeDesc:%String,PaadmDate:%String:就诊日期^120")
{
}

ClassMethod GetSubText(AdmID, SessionStr = "")
{
	s LocCTLocID=$p(SessionStr,"^",3)
	s HospID=$p(SessionStr,"^",4)
	s langid=$p(SessionStr,"^",6)
	s:langid="" langid=..%LanguageID()
	s cspName="doccure.workreport.recordreport.hui.csp"
    ;"科别:-  姓名:-  性别:-  年龄:-  床号:-  登记号:-";
    s SubText=""
    s LocCTLoc="-"
    if LocCTLocID'="" {
        s LocCTLoc=..GetLocDesc(LocCTLocID,langid)
    } 
    s PAAdmLocID=$P($g(^PAADM(AdmID)),"^",4)
    s PAAdmLoc="-"
    if PAAdmLocID'="" {
        s PAAdmLoc=..GetLocDesc(PAAdmLocID,langid)
    }   
    s PatientID=$P($G(^PAADM(AdmID)),"^",1)
    s PatientNo=$P($g(^PAPER(PatientID,"PAT",1)),"^",1)
    s PatientName=$P($G(^PAPER(PatientID,"ALL")),"^",1)
    s PatientSex="-"
    s PatientSexDr=$P($G(^PAPER(PatientID,"ALL")),"^",7)
    if PatientSexDr'=""{
        s PatientSex=$P($G(^CT("SEX",PatientSexDr)),"^",2)
    }
    s PatientAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,AdmID,HospID)
    s PAAdmBed="-"
    s BedId=$P($g(^PAADM(AdmID)),"^",73)
    if BedId'=""{
        s PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
    }
    s PAAdmType=$p($g(^PAADM(AdmID)),"^",2)
    s MrNo=##class(web.DHCDocOrderCommon).GetMrNo("",PatientID,PAAdmType)
    s SubText=##class(websys.Translation).Get(cspName,"就诊科别")
    _":"_PAAdmLoc_"  "_##class(websys.Translation).Get(cspName,"姓名")
    _":"_PatientName_"  "_##class(websys.Translation).Get(cspName,"性别")
    _":"_PatientSex_"  "_##class(websys.Translation).Get(cspName,"年龄")
    _":"_PatientAge_"  "_##class(websys.Translation).Get(cspName,"床号")
    _":"_PAAdmBed_"  "_##class(websys.Translation).Get(cspName,"登记号")
    _":"_PatientNo
    Q SubText
}

/// 获取患者治疗记录(图),用于 <-- 患者治疗记录(图) -->
/// debug： w ##class(DHCDoc.DHCDocCure.Record).GetCureRecondImage("","","0009391806","","ASE")
ClassMethod GetCureRecondImage(StartDate As %String, EndDate As %String, PatientID As %String, ArcimID As %String, Sortable As %String, HospID As %String = "") As %String [ ProcedureBlock = 1 ]
{
	s ^tmplog("GetCureRecondImage")=$lb(StartDate, EndDate, PatientID, ArcimID, Sortable ,HospID)
	q:PatientID="" ""
	
	s:StartDate'="" StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s langid=..%LanguageID()
	s GetCount=0
	k ImageList,PicPathAry
	s AdmType="" 
	for {
		s AdmType=$o(^PAPERdr(PatientID,"ADM",AdmType))
		q:AdmType=""
		s AdmId="" 
		for {
			s AdmId=$o(^PAPERdr(PatientID,"ADM",AdmType,AdmId))
			q:AdmId=""
			s AdmHospID=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(AdmId)
			continue:(HospID'="")&&(HospID'=AdmHospID)
			s DCARowId=0 
			for {
				s DCARowId=$o(^DHCDocCure(0,"Adm",AdmId,DCARowId))
				q:DCARowId=""
				s AppDate=$p(^DHCDocCure(DCARowId),"^",5)
				continue:(StartDate'="")&&(StartDate>AppDate)
				continue:(EndDate'="")&&(EndDate<AppDate)
				s Status=$p(^DHCDocCure(DCARowId),"^",3)
				continue:Status="C"
				s OrderID=$p(^DHCDocCure(DCARowId),"^",2)
				continue:OrderID=""
				s CureArcimID=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),1),"^",2)
				continue:(ArcimID'="")&&(ArcimID'=CureArcimID)
				s ARCIMDesc=$p(^ARCIM(+CureArcimID,$p(CureArcimID,"||",2),1),"^",2)
				s ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)
				s ARCIMDesc=##class(ext.util.String).EvalJSON(ARCIMDesc)
				s DCRRowId=0 f {
					s DCRRowId=$o(^DHCDocCure(DCARowId,"Record",DCRRowId))
					q:DCRRowId=""
					s PicSub=0 
					for {
						s PicSub=$o(^DHCDocCure(DCARowId,"Record",DCRRowId,"Pic",PicSub))
						q:PicSub=""
						s DCRPRowId=DCARowId_"||"_DCRRowId_"||"_PicSub
						s PicObj=##class(User.DHCDocCureRecodePicture).%OpenId(DCRPRowId)
						if $IsObject(PicObj) {
							s PicDate=PicObj.DCRPDate
							s PicTime=PicObj.DCRPTime
							s PicName=PicObj.DCRPPictureName
							s PicUser=PicObj.DCRPUserDR.%Id()
							s PicDateTime=##class(websys.Conversions).DateLogicalToHtml(PicDate)_" "_$zt(PicTime)
							s:PicUser'="" PicUser=$p(^SSU("SSUSR",PicUser),"^",2)
							s PicUser =##class(DHCDoc.Common.Translate).GetTransUser(PicUser,langid)
							if $IsObject(PicObj.DCRPPictureStreamData) {
								s PicBase64Index=1
								While 'PicObj.DCRPPictureStreamData.AtEnd {
									s PicReadLine=PicObj.DCRPPictureStreamData.Read(50000)
									s PicPathAry(DCRPRowId,PicBase64Index)=PicReadLine
									s PicBase64Index=PicBase64Index+1
								}
								k DCRPBase64Stream
							}else {
								s DCRPPictureData=PicObj.DCRPPictureData
								s:DCRPPictureData'="" PicPathAry(DCRPRowId,1)=PicObj.DCRPPictureData
							}
							continue:'$d(PicPathAry(DCRPRowId))
							s GetCount=GetCount+1
							s ApplyNo=##class(DHCDoc.DHCDocCure.Apply).GetCureApplyNo(DCARowId)
							s ImageList(AppDate,DCARowId)=$lb(ARCIMDesc,ApplyNo)
							s ImageList(AppDate,DCARowId,PicDateTime,DCRPRowId)=$lb(PicDateTime,PicUser,PicName)
						}
					}
				}
			}
		}
	}
	s retObj=[]
	s SortType=$select(Sortable="DESC":-1,1:1)
	s Date="" for {
		s Date=$o(ImageList(Date),SortType)
		q:Date=""
		s ID="" f {
			s ID=$o(ImageList(Date,ID))
			q:ID=""
			s ArcimName=$lg(ImageList(Date,ID),1)
			s ApplyNo=$lg(ImageList(Date,ID),2)
			
			;s retval="InitShowHead('"_$ZCVT($zd(Date,3),"O","JS")_"','"_$ZCVT(ArcimName,"O","JS")_"','"_$ZCVT(ID,"O","JS")_"','"_$ZCVT(ApplyNo,"O","JS")_"');"
			;&javascript<#(retval)#>
			s mainObj={}
			s mainObj.InitShowHead=$ZCVT($zd(Date,3),"O","JS")_"^"_$ZCVT(ArcimName,"O","JS")_"^"_$ZCVT(ID,"O","JS")_"^"_$ZCVT(ApplyNo,"O","JS")
			s mainObj.BodyList=[]
			s ImageNum=0
			s PicDT="" f {
				s PicDT=$o(ImageList(Date,ID,PicDT))
				q:PicDT=""
				s PicID="" f {
					s PicID=$o(ImageList(Date,ID,PicDT,PicID))
					q:PicID=""
					s Data=ImageList(Date,ID,PicDT,PicID)
					s mPicID=$replace(PicID,"||","-")
					;s retval="InitShowBody('"_$ZCVT(mPicID,"O","JS")_"','"_$ZCVT($lg(Data,3),"O","JS")_"','"_$ZCVT($lg(Data,2),"O","JS")_"','"_$ZCVT($lg(Data,1),"O","JS")_"','"_$ZCVT($lg(Data,1),"O","JS")_"');"
					;&javascript<#(retval)#>
					s bodyObj={}
					s bodyObj.InitShowBody=$ZCVT(mPicID,"O","JS")_"^"_$ZCVT($lg(Data,3),"O","JS")_"^"_$ZCVT($lg(Data,2),"O","JS")_"^"_$ZCVT($lg(Data,1),"O","JS")_"^"_$ZCVT($lg(Data,1),"O","JS")
					s bodyObj.PicList=[]
					s PicBase64=""
					s loop=0
					for{
						s loop=$o(PicPathAry(PicID,loop))
						q:loop=""
						s PicBase64=$tr($g(PicPathAry(PicID,loop)),$c(10))
						;s retval="InitPicData('"_$ZCVT(PicBase64,"O","JS")_"');"
						;&javascript<#(retval)#>
						s picObj={}
						s picObj.InitPicData=PicBase64
						d bodyObj.PicList.%Push(picObj)
					}
					;s retval="InsertPicData('"_$ZCVT(mPicID,"O","JS")_"','"_$ZCVT($lg(Data,3),"O","JS")_"');"
					;&javascript<#(retval)#>
					s bodyObj.InsertPicData=$ZCVT(mPicID,"O","JS")_"^"_$ZCVT($lg(Data,3),"O","JS")
					d mainObj.BodyList.%Push(bodyObj)
					s ImageNum=ImageNum+1
				}
			}
			;s retval="InitShowFoot('"_$ZCVT(ID,"O","JS")_"','"_$ZCVT(ImageNum,"O","JS")_"');"
			;&javascript<#(retval)#>
			s mainObj.InitShowFoot=$ZCVT(ID,"O","JS")_"^"_$ZCVT(ImageNum,"O","JS")
			s mainObj.ImageNum=ImageNum
			d retObj.%Push(mainObj)
		}
	}
	s stream=##class(%Stream.GlobalCharacter).%New()
	d retObj.%ToJSON(stream) 
	do stream.OutputToDevice()
	Q ""
}

/// Input:StartDate 开始日期, EndDate 结束日期,ShowByTR 按分时段拆分显示, ShowPatInList 列表展示患者预约信息, SessionStr, SearchExpStr
Query FindScheduleApp(StartDate As %String = "", EndDate As %String = "", ShowByTR As %String = "", ShowPatInList As %String = "", SessionStr As %String = "", SearchExpStr As %String = "") As %Query(ROWSPEC = "RowId:%String,LocRowid:%String,DocRowid:%String,ServiceGroupID:%String,TimeRangeID:%String,LocDesc:%String,ResourceDesc:%String,ServiceGroupDesc:%String,TimeDesc:%String,TimeRangeDesc:%String,admDate1:%String,admDate2:%String,admDate3:%String,admDate4:%String,admDate5:%String,admDate6:%String,admDate7:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.WordReport","FindScheduleApp","2023-02-23","2023-02-23","N","Y","2^13^17473^20","13^^^Y")
ClassMethod FindScheduleAppExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", ShowByTR As %String = "", ShowPatInList As %String = "", SessionStr As %String = "", SearchExpStr As %String = "") As %Status
{
	s ^tmplog("FindScheduleApp")=$lb(StartDate, EndDate,ShowByTR, ShowPatInList, SessionStr, SearchExpStr)
	s (DCARowId,BookDate,DCARowIdStr,DDCISRowid, ArcimId)=""
	s langid=$p(SessionStr,"^",4)
	s:langid="" langid=..%LanguageID()
	s AddDay=6
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s EndDate=StartDate+AddDay
	k ArrayList
	Set rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.RBCResSchdule:QueryAvailResApptSchdule")
	do rset.Execute(DCARowId , BookDate , DCARowIdStr, StartDate, EndDate, DDCISRowid, ArcimId, SessionStr, SearchExpStr)
	While (rset.Next()) {
		;"Rowid:%String,DDCRSDate:%String,LocDesc:%String,ResourceDesc:%String,TimeDesc:%String,StartTime:%String,EndTime:%String,ServiceGroupDesc:%String,DDCRSStatus:%String,MaxNumber:%String,AutoNumber:%String,ChargeTime:%String,AvailPatType:%String,AutoAvtiveFlag:%String,AppedNumber:%String,AppedLeftNumber:%String,EndAppointTime:%String"
		s ASRowID=rset.Data("Rowid")
		s LocDesc=rset.Data("LocDesc")
		s ResourceDesc=rset.Data("ResourceDesc")
		s TimeDesc=rset.Data("TimeDesc")
		s AppedNumber=rset.Data("AppedNumber")
		s AppedLeftNumber=rset.Data("AppedLeftNumber")
		s MaxNumber=rset.Data("MaxNumber")
		s DDCRSDateHTML=rset.Data("DDCRSDate")
		s StartTime=rset.Data("StartTime")
		s:StartTime'="" StartTime=$zt($zth(StartTime,1),2)
		s EndTime=rset.Data("EndTime")
		s:EndTime'="" EndTime=$zt($zth(EndTime,1),2)
		s ServiceGroupDesc=rset.Data("ServiceGroupDesc")
		s TimeRangeFlag=rset.Data("TimeRangeFlag")
		s TRLength=rset.Data("TRLength")
		s TRReservedNum=rset.Data("TRReservedNum")
		s TRRegNumStr=rset.Data("TRRegNumStr")
		s TRRegInfoStr=rset.Data("TRRegInfoStr")
		s TRAvailQtyStr=rset.Data("TRAvailQtyStr")
		s DDCRSStatusCode=rset.Data("DDCRSStatusCode")
		s TimeRangeInfo=TimeRangeFlag_"&&"_TRLength_"&&"_TRReservedNum_"&&"_TRRegNumStr_"&&"_TRRegInfoStr_"&&"_TRAvailQtyStr
		s Data=$g(^DHCDocCureRBCResSchdule(ASRowID))
		s DDCRSLocDR=$p(Data,"^",2)  //排班科室ID
		s DDCRSResSourceDR=$p(Data,"^",3)  //排班资源ID
		s DDCRSDate=$p(Data,"^",4)  //出诊日期
		s DDCRSTimeRangeDR=$p(Data,"^",5)  //排程出诊时段
		s DDCRSServiceGroupDR=$p(Data,"^",8)  //服务组ID
		k FindQueAry
		if ShowPatInList="Y"{
			d GetPatAppAryByAS
		}
		if ShowByTR="Y",TimeRangeFlag="Y"{
			for loopTR=1:1:$l(TRRegInfoStr,","){
				;分时段重新计算【可预约数/最大预约数、已预约数】
				s TRRegInfo=$p(TRRegInfoStr,",",loopTR)
				continue:TRRegInfo=""
				s TRAvailQty=$p(TRAvailQtyStr,",",loopTR)
				s TRRegNum=$p(TRRegNumStr,",",loopTR)
				s MaxNumber=$p(TRRegNum,"-",2)-$p(TRRegNum,"-",1)+1
				s mLabel=TRAvailQty_"/"_MaxNumber
				s AppedNumber=MaxNumber-TRAvailQty
				s PatAppInfo=$$GetPatAppInfo(TRRegInfo)
				s TimeRangeInfo=TimeRangeFlag_"&&"_MaxNumber_"&&"_""_"&&"_TRRegNum_"&&"_TRRegInfo_"&&"_TRAvailQty
				s ArrayList(DDCRSLocDR,DDCRSResSourceDR,DDCRSServiceGroupDR,DDCRSTimeRangeDR,TRRegInfo,DDCRSDate)=mLabel_"^"_AppedNumber_"^"_ASRowID_"^"_DDCRSDateHTML_"^"_TimeRangeInfo_"^"_DDCRSStatusCode_"^"_PatAppInfo
				s ArrayList(DDCRSLocDR,DDCRSResSourceDR,DDCRSServiceGroupDR,DDCRSTimeRangeDR,TRRegInfo)=LocDesc_"^"_ResourceDesc_"^"_ServiceGroupDesc_"^"_TimeDesc_"^"_TRRegInfo
			}
		}else{
			s mLabel=AppedLeftNumber_"/"_MaxNumber
			s PatAppInfo=$$GetPatAppInfo("")
			s TRRegInfo=StartTime_"-"_EndTime
			s ArrayList(DDCRSLocDR,DDCRSResSourceDR,DDCRSServiceGroupDR,DDCRSTimeRangeDR,0,DDCRSDate)=mLabel_"^"_AppedNumber_"^"_ASRowID_"^"_DDCRSDateHTML_"^"_TimeRangeInfo_"^"_DDCRSStatusCode_"^"_PatAppInfo
			s ArrayList(DDCRSLocDR,DDCRSResSourceDR,DDCRSServiceGroupDR,DDCRSTimeRangeDR,0)=LocDesc_"^"_ResourceDesc_"^"_ServiceGroupDesc_"^"_TimeDesc_"^"_TRRegInfo
		}
	}
	d rset.Close()
	if $d(ArrayList){
		s mLocID=""
		for{
			s mLocID=$o(ArrayList(mLocID))	
			Q:mLocID=""
			s mResSourceID=""
			for{
				s mResSourceID=$o(ArrayList(mLocID,mResSourceID))	
				Q:mResSourceID=""
				s mServiceGroupID=""
				for{
					s mServiceGroupID=$o(ArrayList(mLocID,mResSourceID,mServiceGroupID))	
					Q:mServiceGroupID=""
					s mTimeRangeID=""
					for{
						s mTimeRangeID=$o(ArrayList(mLocID,mResSourceID,mServiceGroupID,mTimeRangeID))	
						Q:mTimeRangeID=""
						s mTRInfo=""
						for{
							s mTRInfo=$o(ArrayList(mLocID,mResSourceID,mServiceGroupID,mTimeRangeID,mTRInfo))	
							Q:mTRInfo=""
							s tmpData=ArrayList(mLocID,mResSourceID,mServiceGroupID,mTimeRangeID,mTRInfo)
							s mLocDesc=$p(tmpData,"^",1)
							s mResourceDesc=$p(tmpData,"^",2)
							s mServiceGroupDesc=$p(tmpData,"^",3)
							s mTimeRangeDesc=$p(tmpData,"^",4)
							s outTRInfo=mTRInfo
							s mTRFlag="Y"
							if outTRInfo=0{
								s outTRInfo=$p(tmpData,"^",5)
								s mTRFlag="N"
							}
		
							s RowId=mLocID_"^"_mResSourceID_"^"_mServiceGroupID_"^"_mTimeRangeID_"^"_outTRInfo_"^"_mTRFlag
							s mResourceDesc=mResourceDesc_"("_mLocDesc_")"
							s Data=$lb(RowId,mLocID,mResSourceID,mServiceGroupID,mTimeRangeID,mLocDesc,mResourceDesc,mServiceGroupDesc,mTimeRangeDesc,outTRInfo)
							for mDate=StartDate:1:EndDate{
								s Info=$g(ArrayList(mLocID,mResSourceID,mServiceGroupID,mTimeRangeID,mTRInfo,mDate))
								s Data=Data_$lb(Info)
							}
							d OutputRow
						}
					}
				}
			}
		}	
	}
	Quit $$$OK
OutputRow
	set qHandle($I(ind))=Data
    quit
GetPatAppAryByAS
	s QueNoEnd=..%Translate("doccure.workreport.appoint.v2.hui.csp","号",langid)
	s QueId=""
	for{
		s QueId=$o(^User.DHCDocCureQueueI("IndexRBAS",ASRowID,QueId))
		q:QueId=""
		s QueStatusDr=$lg(^User.DHCDocCureQueueD(QueId),9)
		s QueStatusCode=""
		if QueStatusDr'=""{
			s QueStatusCode=$p($g(^DHCDocCurePS(QueStatusDr)),"^",1)
		}
		continue:("Cancel"[QueStatusCode)
		s QueRBASDr=$lg(^User.DHCDocCureQueueD(QueId),2)
		s QueNo=$lg(^User.DHCDocCureQueueD(QueId),4)
		s QueTimeRangeInfo=##class(DHCDoc.DHCDocCure.ScheduleTR).GetTimeRangeInfo(QueRBASDr,QueNo)
		s getTimeRange=$p(QueTimeRangeInfo, " ",2)
		s getTimeRange=$p(getTimeRange, "(",1)
		s:getTimeRange="" getTimeRange=0
		s PatientID=$lg(^User.DHCDocCureQueueD(QueId),13)
		s PatientName=$lg(^User.DHCDocCureQueueD(QueId),3)
		s ShowColor=$case(QueStatusCode,"Complete":"green","Cancel":"gray",:"")
		s FindQueAry(getTimeRange,QueNo,QueId)="<span style='color:"_ShowColor_"'>"_QueNo_QueNoEnd_" "_PatientName_"</span>"
		;$lb(QueNo_"号 "_PatientName,QueStatusCode)
	}
	Q
GetPatAppInfo(inTimeRange="")
	s PatAppInfo=""	
	if '$d(FindQueAry){
		Q PatAppInfo
	}
	s myTR=""
	for{
		s myTR=$o(FindQueAry(myTR))
		q:myTR=""
		if inTimeRange'=""{
			s inSttTime=$zth($p(inTimeRange, "-",1),1)
			s inEndTime=$zth($p(inTimeRange, "-",2),1)
			s getSttTime=$zth($p(myTR, "-",1),1)
			s getEndTime=$zth($p(myTR, "-",2),1)
			if (getSttTime>inSttTime)!(getEndTime<inEndTime){
				continue	
			}
		}
			
		s myNo=""
		for{
			s myNo=$o(FindQueAry(myTR,myNo))
			Q:myNo=""
			s myQueID=""
			for{
				s myQueID=$o(FindQueAry(myTR,myNo,myQueID))
				q:myQueID=""
				s PatAppInfo=PatAppInfo_"<br>"_FindQueAry(myTR,myNo,myQueID)
			}
		}
	}
	Q PatAppInfo
}

ClassMethod FindScheduleAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindScheduleAppExecute ]
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

}
