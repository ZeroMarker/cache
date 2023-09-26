Import SQLUser

Class web.DHCBPPatRegister Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 优先级：1.按登记号、病案号、姓名查无时间限制。2.needBpprStatus为"N"查找当前治疗病人。3.其它按登记日期范围查。
/// D ##class(%ResultSet).RunQuery("web.DHCBPPatRegister","FindBPPatRegister","","","","N","","","","00006","N")
Query FindBPPatRegister(fromDate As %String, toDate As %String, regNo As %String = "", needBpprStatus As %String = "", papmiMedicare As %String = "", papmiName As %String = "", registerId As %String = "", bpNo As %String = "", patType As %String = "", locId As %String = "", dialysisMethodID As %String = "") As %Query(ROWSPEC = "PatientID,RegNo,PatientName,PersonID,MedicareNo,Gender,DOB,Age,Diagnosis,BloodPurificationNo,BloodPurificationCount,HouseAddress,ContactNumber,FamilyMember,Introducer,MainDoctorId,MainDoctorName,MainNurseId,MainNurseName,StartDate,EndDate,Status,VisitStatusId,VisitStatus,DeceaseReasonId,DeceaseReasonDesc,OtherDeceaseReason,IsContinueTherapy,Id,RegisterDate,RegisterTime,ClinicTypeCode,ClinicType,PatientSource,SourceDeptId,SourceDept,Infection,PatientType,PatientTypeDesc,EpisodeID,SourceTelephone,DialysisReasonId,DialysisReasonDesc,DeadDiseaseId,DeadDiseaseDesc,PatNation,SecCode,PatLevel")
{
}

ClassMethod FindBPPatRegisterExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, regNo As %String = "", needBpprStatus As %String = "", papmiMedicare As %String = "", papmiName As %String = "", registerId As %String = "", bpNo As %String = "", patType As %String = "", locId As %String = "", dialysisMethodID As %String = "") As %Status
{
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
    s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
	i registerId'="" d
	.s bpprId=registerId
	.s isLocQuery=0
	.d GetRegister()
	.d OutputRow
	i registerId'="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	i bpNo'="" d
	.s isLocQuery=0
	.s bpprId="" 
	.f  s bpprId=$o(^DHCBPPatRegister(0,"PatBPNo",bpNo,bpprId))  q:bpprId=""  d
	..s status=$lg(^DHCBPPatRegister(bpprId),14)
	..q:(needBpprStatus'="")&&(needBpprStatus'[status)
	..;q:status="D"
	..s bpprPatBPNo=$lg(^DHCBPPatRegister(bpprId),17)
	..i bpprPatBPNo="" s bpprPatBPNo="999999"  // 编号排序
	..s ^TMPBP("PatRegister",$j,+bpprPatBPNo,bpprId)=""  //排序 global
	..;d GetRegister()
	d Output
	i bpNo'="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s isAll=0
	i (fromDate="")&(toDate="")  d
	.s isAll=1
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s papmiIdList=""
	s bpprIdList=""
	//i regNo'="" s papmiIdList=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))  wq 20170804
	i regNo'="" d
	.s regNolength=$l(regNo)
	.i regNolength=10  s papmiIdList=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	.i regNolength<10  d
	..f i=1:1:10-regNolength  d
	...s regNo="0"_regNo
	..s papmiIdList=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	b ;111
	i papmiIdList="",papmiMedicare'="" d
		.s papmiMedicare=$$ALPHAUP^SSUTIL4(papmiMedicare)		
		.s papmiId= ##class(MA.IPMR.IO.OutService).GetPatientIDByMrNo(papmiMedicare,"IP",.ErrMsg)
		.i papmiIdList'="" s papmiIdList=papmiIdList_"^"
		.s papmiIdList=papmiIdList_papmiId
		.s papmiId= ##class(MA.IPMR.IO.OutService).GetPatientIDByMrNo(papmiMedicare,"OP",.ErrMsg)
		.i papmiIdList'="" s papmiIdList=papmiIdList_"^"
		.s papmiIdList=papmiIdList_papmiId
		.s papmiId= ##class(MA.IPMR.IO.OutService).GetPatientIDByMrNo(papmiMedicare,"EP",.ErrMsg)
		.i papmiIdList'="" s papmiIdList=papmiIdList_"^"
		.s papmiIdList=papmiIdList_papmiId
		.s papmiId= ##class(MA.IPMR.IO.OutService).GetPatientIDByMrNo(papmiMedicare,"EM",.ErrMsg)
		.i papmiIdList'="" s papmiIdList=papmiIdList_"^"
		.s papmiIdList=papmiIdList_papmiId
		.//s papmiIdList=$o(^PAPERi("Medicare1",papmiMedicare,""))
		.//s papmiId="" //edit mfc 20200713病案号存在多关联患者
		.//f  s papmiId=$o(^PAPERi("Medicare1",papmiMedicare,papmiId)) q:papmiId=""  d
			..//i papmiIdList'="" s papmiIdList=papmiIdList_"^"
			..//s papmiIdList=papmiIdList_papmiId
	i papmiIdList="",papmiName'="" d
		.s papmiNameUp=$$ALPHAUP^SSUTIL4(papmiName)		
		.s papmiId=""
		.f  s papmiId=$o(^PAPERi("PAPER_PatName",papmiNameUp,papmiId)) q:papmiId=""  d
			..i papmiIdList'="" s papmiIdList=papmiIdList_"^"
			..s papmiIdList=papmiIdList_papmiId
	i (regNo'="")!(papmiMedicare'="")!(papmiName'="") s isLocQuery=0
	e  s isLocQuery=1
	i papmiIdList'="" d
	.f i=1:1:$l(papmiIdList,"^") d
	..s papmiId=$p(papmiIdList,"^",i)
	..q:papmiId=""
	..s bpprId=""
	..f  s bpprId=$o(^DHCBPPatRegister(0,"PaPatMas",papmiId,bpprId)) q:bpprId=""  d
	...q:$$GetRegister()<0
	...s bpprPatBPNo=$lg(^DHCBPPatRegister(bpprId),17)
	...i bpprPatBPNo="" s bpprPatBPNo="999999"
	...s status=$lg(^DHCBPPatRegister(bpprId),14)
	...i status="D" S bpprPatBPNo=bpprPatBPNo_"999999"
	...s ^TMPBP("PatRegister",$j,+bpprPatBPNo,bpprId)=""
	d Output
	i (regNo'="")!(papmiMedicare'="")!(papmiName'="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s bpprId=""	
	if 'isAll   
	{
	  i needBpprStatus="D" d
	  .f  s bpprId=$o(^DHCBPPatRegister(0,"Status",needBpprStatus,bpprId)) q:bpprId=""  d
	  ..q:$$GetRegister()<0
	  ..s bpprPatBPNo=$lg(^DHCBPPatRegister(bpprId),17)
	  ..i bpprPatBPNo="" s bpprPatBPNo="999999"
	  ..s status=$lg(^DHCBPPatRegister(bpprId),14)
	  ..i status="D" S bpprPatBPNo=bpprPatBPNo_"999999"
	  ..s ^TMPBP("PatRegister",$j,+bpprPatBPNo,bpprId)=""
	  .d Output
	  e  d
	  .f curDate=toDate:-1:fromDate d
	  ..s bpprId=""
	  ..f  s bpprId=$o(^DHCBPPatRegister(0,"Date",curDate,bpprId),-1) q:bpprId=""  d
	  ...q:$$GetRegister()<0
	  ...s bpprPatBPNo=$lg(^DHCBPPatRegister(bpprId),17)
	  ...i bpprPatBPNo="" s bpprPatBPNo="999999"
	  ...s status=$lg(^DHCBPPatRegister(bpprId),14)
	  ...i status="D" S bpprPatBPNo=bpprPatBPNo_"999999"
	  ...s ^TMPBP("PatRegister",$j,+bpprPatBPNo,bpprId)=""
	  .d Output
	}
	else  
	{
	   s bpprId=""
	   f  s bpprId=$o(^DHCBPPatRegister(bpprId),-1) q:(bpprId="")!(bpprId=0)  d
	   .q:$$GetRegister()<0
	   .s bpprPatBPNo=$lg(^DHCBPPatRegister(bpprId),17)
	   .i bpprPatBPNo="" s bpprPatBPNo="999999"
	   .s status=$lg(^DHCBPPatRegister(bpprId),14)
	   .i status="D" S bpprPatBPNo=bpprPatBPNo_"999999"
	   .s ^TMPBP("PatRegister",$j,+bpprPatBPNo,bpprId)=""
	  d Output
	}	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetRegister()
	q:bpprId="" -1
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	q:papmiId="" -2
	q:'$d(^PAPER(papmiId,"PAT",1)) -3
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	//s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	//q:($$ALPHAUP^SSUTIL4(papmiName)'="")&&($$ALPHAUP^SSUTIL4(papmiName)'=patName) -3
	q:($$ALPHAUP^SSUTIL4(papmiName)'="")&&(papmiName'=patName) -3
	s personID=$p($G(^PAPER(papmiId,"ALL")),"^",9)  //身份证
	//s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22) //20200515统一走病案接口
	s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s patNation=$p($g(^PAPER(papmiId,"PER",2)),"^",1)
	i patNation'="" s patNation=$p($g(^CT("NAT",patNation)),"^",2) //名族
 	s patBirth=$p($g(^PAPER(papmiId,"ALL")),"^",6)	//出生日期
	i patBirth'="" s patBirth=$zd(patBirth,3)	
	s bpprAddress=$lg(^DHCBPPatRegister(bpprId),2)
	s bpprTelephone=$lg(^DHCBPPatRegister(bpprId),3)
	s bpprContact=$lg(^DHCBPPatRegister(bpprId),4)
	s bpprIntroducer=$lg(^DHCBPPatRegister(bpprId),5)
	s bpprDiagnosis=$lg(^DHCBPPatRegister(bpprId),6)
	s admId=$lg(^DHCBPPatRegister(bpprId),26)
	s admType=""
	s admDept=""
	i admId'="" d
	.s admType=$p($g(^PAADM(admId)),"^",2)
	.s admDeptId=$p($g(^PAADM(admId)),"^",4)
	.s admDept=$p($p($g(^CTLOC(admDeptId)),"^",2),"-",2)	
	s sourceDept=admDept
	s papmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,admType,.ErrMsg)
	;s bpprPatDeptDr=$lg(^DHCBPPatRegister(bpprId),30)
	s bpprPatLocationDr=$lg(^DHCBPPatRegister(bpprId),34)
	b ;locId1
	q:((locId'="")&&(bpprPatLocationDr'="")&&($p($g(^CTLOC(locId)),"^",22)'=$p($g(^CTLOC(bpprPatLocationDr)),"^",22))) -4 //病人所在医院判断
	b ;locId2
	q:(bpprPatLocationDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_bpprPatLocationDr_"^")) -5
	s bpprDate=$lg(^DHCBPPatRegister(bpprId),8)
	s patAge=##class(web.DHCClinicCom).CalAge($zdh(patBirth,3),+$h)
	s registerDate=##class(web.DHCANOPCom).ConvertToDate(bpprDate)
	s bpprTime=$lg(^DHCBPPatRegister(bpprId),9)
	s registerTime=##class(web.DHCANOPCom).ConvertToTime(bpprTime)
	s bpprMainDoctorCtcpDr=$lg(^DHCBPPatRegister(bpprId),10)
	s bpprMainDoctorCtcpDesc=$p($g(^CTPCP(+bpprMainDoctorCtcpDr,1)),"^",2)
	s bpprMainNurseCtcpDr=$lg(^DHCBPPatRegister(bpprId),11)
	s bpprMainNurseCtcpDesc=$p($g(^CTPCP(+bpprMainNurseCtcpDr,1)),"^",2)
	s bpprStartDate=$lg(^DHCBPPatRegister(bpprId),12)
	i bpprStartDate'="" d 
	.s bpprStartDate=##class(web.DHCANOPCom).ConvertToDate(bpprStartDate)
	s bpprEndDate=$lg(^DHCBPPatRegister(bpprId),13)
	i bpprEndDate'=""  d
	.s bpprEndDate=##class(web.DHCANOPCom).ConvertToDate(bpprEndDate)
	s bpprStatus=$lg(^DHCBPPatRegister(bpprId),14)
	q:bpprStatus="" -5
	//w needBpprStatus_"/"_bpprStatus
	q:(needBpprStatus'="")&&(needBpprStatus'[bpprStatus) -6
	i bpprStatus="N" s bpprStatus="正常"
	i bpprStatus="D" s bpprStatus="转归"
	s bpprBPCVisitStatusDr=$lg(^DHCBPPatRegister(bpprId),15)
	s bpprBPCVisitStatus=$lg($g(^DHCBPC("VisitStatus",+bpprBPCVisitStatusDr)),2)
	s bpprDeceaseReasonDr=$lg(^DHCBPPatRegister(bpprId),16)
	s bpprDeceaseReason=$lg($g(^DHCBPC("DeceaseReason",+bpprDeceaseReasonDr)),2)
	s bpprOtherDeceaseReason=$lg(^DHCBPPatRegister(bpprId),22)
	s bpprPatBPNo=$lg(^DHCBPPatRegister(bpprId),17)
	s bpprPatBPCount=$lg(^DHCBPPatRegister(bpprId),18)
	;s bpprPatBPCount=##class(web.DHCBPArrange).GetBPNum("",bpprId)
	s bpprPatSource=$lg(^DHCBPPatRegister(bpprId),19)
	s bpprInfection=$lg(^DHCBPPatRegister(bpprId),20)
	s bptIsMaintenanceTherapy=$lg(^DHCBPPatRegister(bpprId),21)
	s bpprPatClinicTypeCode=$lg(^DHCBPPatRegister(bpprId),23)
	s bpprPatClinicType=""
	i bpprPatClinicTypeCode="O" s bpprPatClinicType="门诊" 
	i bpprPatClinicTypeCode="I" s bpprPatClinicType="住院"
	i bpprPatClinicTypeCode="E" s bpprPatClinicType="急诊"
	s bpprPatSourcreDeptDr=$lg(^DHCBPPatRegister(bpprId),24)
	s bpprPatSourcreDept=""
	i bpprPatSourcreDeptDr'="" d
	.;s bpprPatSourcreDept=$p($p($g(^CTLOC(bpprPatSourcreDeptDr)),"^",2),"-",2)
	.i $l($p($g(^CTLOC(bpprPatSourcreDeptDr)),"^",2),"-")>1  s bpprPatSourcreDept=$p($p($g(^CTLOC(bpprPatSourcreDeptDr)),"^",2),"-",2)
	.e   s bpprPatSourcreDept=$p($g(^CTLOC(bpprPatSourcreDeptDr)),"^",2)
	s bpprPatType=$lg(^DHCBPPatRegister(bpprId),25)
	q:(bpprPatType'=patType)&(patType'="") -7
	s bpprPatTypeDesc=""
	i bpprPatType="N" s bpprPatTypeDesc="常规"
	e  i bpprPatType="T" s bpprPatTypeDesc="临时"
	;q:(isLocQuery)&(needBpprStatus'="N")&(bpprDate'="")&(bpprDate>toDate) -11
	//w bpprDate_"/"_fromDate,!
	;q:(isLocQuery)&(needBpprStatus'="N")&(bpprDate'="")&(bpprDate<fromDate) -12
	s admId=$lg(^DHCBPPatRegister(bpprId),26)
	s sourceTelephone=$lg(^DHCBPPatRegister(bpprId),27)
	s mrcIcdDesc=""
	s mrcIcdId=$lg(^DHCBPPatRegister(bpprId),28)
	i mrcIcdId'="" d
	.s mrcIcdDesc=$p($g(^MRC("ID",mrcIcdId)),"^",2)
	s deceaseMrcIcdDesc=""
	s deceaseMrcIcdId=$lg(^DHCBPPatRegister(bpprId),29)
	i deceaseMrcIcdId'="" d
	.s deceaseMrcIcdDesc=$p($g(^MRC("ID",deceaseMrcIcdId)),"^",2)
	s startDateTime=""
	i bpprDate'="" d
		.s startDateTime=$zd(bpprDate,3)
		.s startTime=$lg(^DHCBPPatRegister(bpprId),9)
		.s startDateTime=startDateTime_" "_$zt(startTime)
	s endDate=$lg(^DHCBPPatRegister(bpprId),13)
	i endDate'="" d
		.s endDate=$zd(endDate,3)
	s tDiagDesc=""
	s SecCode="",PatLevel=""
	S SecretStr=##class(DHCMed.SSIO.FromSecSrv).GetPatEncryptLevel(papmiId,.ErrMsg)
	i SecretStr'="" s SecCode=$p(SecretStr,"^",1)   //病人密级
	i SecretStr'="" s PatLevel=$p(SecretStr,"^",2)		//病人级别	
	s isMode=0 //透析方案条件
	i dialysisMethodID'="" d	
	.s arrangeSchemeId=""
    .f  s arrangeSchemeId=$o( ^DHCBPArrangeScheme(0,"Register",bpprId,arrangeSchemeId)) q:arrangeSchemeId=""  d
     	..q:($lg(^DHCBPArrangeScheme(arrangeSchemeId),17)'="N")
     	..s bpModeDr=$lg(^DHCBPArrangeScheme(arrangeSchemeId),3)     	
		..i bpModeDr=dialysisMethodID s isMode=1 
	q:(dialysisMethodID'="")&&(isMode=0) -7
	q 0
Output
    // 编号排序
	s bpprId=""
	s tmpPatBPNo=""
	f  s tmpPatBPNo=$o(^TMPBP("PatRegister",$j,tmpPatBPNo)) q:tmpPatBPNo=""  d
	.f  s bpprId=$o(^TMPBP("PatRegister",$j,tmpPatBPNo,bpprId)) q:bpprId=""  d
	..;d GetRegister
	..q:$$GetRegister()<0
	..d OutputRow
	quit
OutputRow
	set Data=$lb(papmiId,regNo,patName,personID,papmiMedicare,patSex,patBirth,patAge,bpprDiagnosis,bpprPatBPNo,bpprPatBPCount,bpprAddress,bpprTelephone,bpprContact,bpprIntroducer,bpprMainDoctorCtcpDr,bpprMainDoctorCtcpDesc,bpprMainNurseCtcpDr,bpprMainNurseCtcpDesc,bpprStartDate,bpprEndDate,bpprStatus,bpprBPCVisitStatusDr,bpprBPCVisitStatus,bpprDeceaseReasonDr,bpprDeceaseReason,bpprOtherDeceaseReason,bptIsMaintenanceTherapy,bpprId,registerDate,registerTime,bpprPatClinicTypeCode,bpprPatClinicType,bpprPatSource,bpprPatSourcreDeptDr,bpprPatSourcreDept,bpprInfection,bpprPatType,bpprPatTypeDesc,admId,sourceTelephone,mrcIcdId,mrcIcdDesc,deceaseMrcIcdId,deceaseMrcIcdDesc,patNation,SecCode,PatLevel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPPatRegisterFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPPatRegisterExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindBPPatRegisterClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPPatRegisterExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	K ^TMPBP("PatRegister",$j) //排序的临时global add mfc 20200810
 	Quit $$$OK
}

// 保存透析登记信息

// w ##class(web.DHCBPPatRegister).SaveRegisterInfo("")

ClassMethod SaveRegisterInfo(registerInfoPara As %String, diagDataPara As %String = "") As %String
{
	//s ^TMPzt("SaveRegisterInfo")=registerInfoPara
	//s registerInfoPara=^TMPzt("SaveRegisterInfo")
	s registerId=$p(registerInfoPara,$c(3),1)
	s register="",result=""
	q:(registerInfoPara="") result
	s patientId=$p(registerInfoPara,$c(3),2)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH($p(registerInfoPara,$c(3),9))
	s fromDate=toDate-3
	//s ^TMPzt(".GetPatientEpisodeID")=patientId_"/"_fromDate_"/"_toDate
	;s episodeIDList=##class(web.DHCBPCom).GetPatientEpisodeID("",patientId,fromDate,toDate)
	;q:episodeIDList="" "该次就诊记录挂号时间已超过三天，请重新挂号"
	s papmiId=$p(registerInfoPara,$c(3),2)	
	s patDeptDr=$p(registerInfoPara,$c(3),31)
	i patDeptDr'="" s linkLocationDr=##Class(web.DHCBPCom).GetLinkLocByLocId(patDeptDr)
	e  s linkLocationDr=""
	s status="",LocationDr="",isRegister=0
	s bpprId=""
	f  s bpprId=$o(^DHCBPPatRegister(0,"PaPatMas",papmiId,bpprId)) q:bpprId=""  d
		.s status=$lg(^DHCBPPatRegister(bpprId),14)
		.s LocationDr=$lg(^DHCBPPatRegister(bpprId),34)
		.i (status="N")&(registerId="")&(("^"_linkLocationDr_"^")[("^"_LocationDr_"^")) s isRegister=1
	i (isRegister=1) q "该病人已进行过透析登记，请勿重复登记!"
	;i (bpprId'="")&(status="N")&(registerId="")&(LocationDr=linkLocationDr) q "该病人已进行过透析登记，请勿重复登记!"
	s registerCount=0
	s bpprPatBPNo=""
	i (registerId="")  d
	.s register=##class(User.DHCBPPatRegister).%New()
	.s admId=$p(registerInfoPara,$c(3),27)
	.i admId'="" d
	.s admType=$p($g(^PAADM(admId)),"^",2)
	.s admDeptId=$p($g(^PAADM(admId)),"^",4)
	.s register.BPPRPatClinicType=admType
	.s register.BPPRPatSourcreDeptDr=admDeptId
	e  d
	.s register=##class(User.DHCBPPatRegister).%OpenId(registerId)
	.s bpprPatBPNo=register.BPPRPatBPNo
	s bpNo=$p(registerInfoPara,$c(3),18)	
	&sql(select count(*) into registerCount from DHC_BP_PatRegister where BPPR_PatBPNo=:bpNo and BPPR_Status='N' and BPPR_PatLocationDr=:linkLocationDr)
	i (bpprPatBPNo'=bpNo)&(registerCount>0)  q "此编号正在使用！"
	s register.BPPRPaPatMasDr=papmiId
	s register.BPPRAddress=$p(registerInfoPara,$c(3),3)
	s register.BPPRTelephone=$p(registerInfoPara,$c(3),4)
	s register.BPPRContact=$p(registerInfoPara,$c(3),5)
	s register.BPPRIntroducer=$p(registerInfoPara,$c(3),6)
	s register.BPPRDiagnosis=$p(registerInfoPara,$c(3),7)
	i registerId="" s register.BPPRCreateUserDr=$p(registerInfoPara,$c(3),8)
	s registerDate=$p(registerInfoPara,$c(3),9)
	i registerDate'="" s register.BPPRDate=##class(web.DHCClinicCom).ConvertToDateH(registerDate)
	s registerTime=$p(registerInfoPara,$c(3),10)
	i registerTime'="" s register.BPPRTime=##class(web.DHCClinicCom).ConvertToTimeH(registerTime)
	s register.BPPRMainDoctorCtcpDr=$p(registerInfoPara,$c(3),11)
	s register.BPPRMainNurseCtcpDr=$p(registerInfoPara,$c(3),12)
	s startDate=$p(registerInfoPara,$c(3),13)
	i startDate'="" d
	.s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	.i startDate'=21915 s register.BPPRStartDate=startDate //add 过滤"0001/1/1"
	//i startDate'="" s register.BPPRStartDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=$p(registerInfoPara,$c(3),14)
	i endDate'="" s register.BPPREndDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s register.BPPRStatus=$p(registerInfoPara,$c(3),15)
	s visitStatusId=$p(registerInfoPara,$c(3),16)
	i visitStatusId'="" s register.BPPRBPCVisitStatusDr=##class(User.DHCBPCVisitStatus).%OpenId(visitStatusId)
	s deceaseReasonId=$p(registerInfoPara,$c(3),17)
	i deceaseReasonId'="" s register.BPPRBPCDeceaseReasonDr=##class(User.DHCBPCDeceaseReason).%OpenId(deceaseReasonId)
	s register.BPPRPatBPNo=$p(registerInfoPara,$c(3),18)
	s register.BPPRPatBPCount=$p(registerInfoPara,$c(3),19)
	s register.BPPRPatSource=$p(registerInfoPara,$c(3),20)
	s register.BPPRInfection=$p(registerInfoPara,$c(3),21)
	s register.BPPRIsMaintenanceTherapy=$p(registerInfoPara,$c(3),22)
	i registerId'="" d
    .s register.BPPRPatClinicType=$p(registerInfoPara,$c(3),24)
	.s register.BPPRPatSourcreDeptDr=$p(registerInfoPara,$c(3),25)
	s register.BPPRPatType=$p(registerInfoPara,$c(3),26)
	s register.BPPRAdmDr=$p(registerInfoPara,$c(3),27)
	s register.BPPRPatSouceTel=$p(registerInfoPara,$c(3),28)
	s register.BPPRMRCICDDr=$p(registerInfoPara,$c(3),29)
	s register.BPPRDeceaseMRCICDDr=$p(registerInfoPara,$c(3),30)
	i registerId="" d
	.s register.BPPRPatDeptDr=patDeptDr
	.i patDeptDr'="" s register.BPPRPatLocationDr=##Class(web.DHCBPCom).GetLinkLocByLocId(patDeptDr)	
	s register.BPPRUpdateUserDr=$p(registerInfoPara,$c(3),32)
	s updateDate=$p(registerInfoPara,$c(3),33)
	i updateDate'="" s register.BPPRUpdateDate=##class(web.DHCClinicCom).ConvertToDateH(updateDate)
	s updateTime=$p(registerInfoPara,$c(3),34)
	i updateTime'="" s register.BPPRUpdateTime=##class(web.DHCClinicCom).ConvertToTimeH(updateTime)
	d register.%Save()
	s result=register.%Id()
	s resultdiag=##class(web.DHCBPPatRegister).SaveDiagDataPara(result,diagDataPara)
	q result
}

ClassMethod SaveDiagDataPara(registerId, diagDataPara)
{
	q:registerId="0" 0
	q:diagDataPara="" 0
	s curDate=+$h
	s curTime=$p($h,",",2)
	&sql(update DHC_BP_Diagnos set BPD_IfAbandon='Y' where BPD_BPPR_Dr=:registerId)	
	i (SQLCODE'=0)&(SQLCODE'=100) q SQLCODE
    s SQLCODE=0
    s outerSpliter="^"
	f i=1:1:$l(diagDataPara,outerSpliter) q:(SQLCODE'=0)&(SQLCODE'=100)  d
	.s singleParaStr=$p(diagDataPara,outerSpliter,i)
	.s id=$p(singleParaStr,$c(3),1)
	.s patRegisterId=$p(singleParaStr,$c(3),2)
	.i patRegisterId="" s patRegisterId=registerId
	.s icdId=$p(singleParaStr,$c(3),3)
	.s description=$p(singleParaStr,$c(3),4)
	.s diagnosisType=$p(singleParaStr,$c(3),5)
	.s updateCtcpId=$p(singleParaStr,$c(3),6)
	.s updateDate=curDate
	.s updateTime=curTime
	.i id="" d
	..&sql(insert into DHC_BP_Diagnos (BPD_BPPR_Dr,BPD_ICD_Dr,BPD_Desc,BPD_Type,BPD_Ctcp_Dr,BPD_Date,BPD_Time,BPD_IfAbandon) values(:patRegisterId,:icdId,:description,:diagnosisType,:updateCtcpId,:updateDate,:updateTime,'N'))
    .e  d
    ..&sql(update DHC_BP_Diagnos set BPD_BPPR_Dr=:patRegisterId,BPD_ICD_Dr=:icdId,BPD_Desc=:description,BPD_Type=:diagnosisType,BPD_Ctcp_Dr=:updateCtcpId,BPD_Date=:updateDate,BPD_Time=:updateTime,BPD_IfAbandon='N' where ID=:id)
    i (SQLCODE'=0)&(SQLCODE'=100) q SQLCODE
	q 1
}

// w ##class(web.DHCBPPatRegister).ChangeRegisterStatus("105","D")

ClassMethod ChangeRegisterStatus(registerId, status, visitStatusId, deceaseReasonId, deadDiseaseId, otherDeceaseReason, dischargeDate, userId) As %String
{
	q:registerId="" "id为空"
	s register=##class(User.DHCBPPatRegister).%OpenId(registerId)
	q:(register.BPPRStatus="D")&(status'="D") "已转归病人不能再转回正常"
	s register.BPPRStatus=status
	i (status="D") d
	.;s register.BPPRPatBPNo=""
	.s register.BPPREndDate=##class(web.DHCClinicCom).ConvertToDateH(dischargeDate)
	e  d
	.s register.BPPREndDate=""
	.s register.BPPRBPCVisitStatusDr=""
	.s register.BPPRBPCDeceaseReasonDr=""
	.s register.BPPRDeceaseMRCICDDr=""
	.s register.BPPROtherDeceaseReason=""
	i (status="D")&&(visitStatusId'="") d
    .s register.BPPRBPCVisitStatusDr=##class(User.DHCBPCVisitStatus).%OpenId(visitStatusId)
    .s register.BPPRBPCDeceaseReasonDr=##class(User.DHCBPCDeceaseReason).%OpenId(deceaseReasonId)
    .s register.BPPRDeceaseMRCICDDr=deadDiseaseId
    .i deceaseReasonId'="" d
    ..s register.BPPROtherDeceaseReason=otherDeceaseReason   
    .k PLIST
    .s PLIST(0)=registerId
    .s PLIST(2)=visitStatusId
    .s PLIST(3)=+$h
    .s PLIST(4)=$p($h,",",2)
    .s PLIST(6)=userId
    .s PLIST(7)=+$h
    .s PLIST(8)=$p($h,",",2)
    .s PLIST(17)=$p($h,",",2)
    .&SQL(insert into sqluser.DHC_BP_PatRegVisitStatus  Values :PLIST())
	d register.%Save()
	s result=register.%Id()
	q result
}

ClassMethod GetEpisodeIdByRegisterId(registerId) As %String
{
	q:registerId="" "-1"
  	s registerObj=##class(User.DHCBPPatRegister).%OpenId(registerId)
  	s papmiId=registerObj.BPPRPaPatMasDr
  	s toDate=registerObj.BPPRDate
  	s fromDate=toDate-2
  	s EpisodeID="",adm="",quit=0,admType=""
    f  s admType=$o(^PAPERdr(papmiId,"ADM",admType),-1) q:(admType="")!(quit)  d
    .b
	.f  s adm=$o(^PAPERdr(papmiId,"ADM",admType,EpisodeID),-1) q:(adm="")!(quit)  d 
	..s paadmVisitStatus=$p($g(^PAADM(adm)),"^",20)
	..q:(paadmVisitStatus'="A")&(paadmVisitStatus'="D")
	..s admDate=$p($g(^PAADM(adm)),"^",6)
	..;q:(fromDate'="")&(admDate<fromDate)
	..;q:(toDate'="")&(admDate>toDate)
	..s EpisodeID=adm
	..s quit=1
	//s EpisodeID="5748419"
	q EpisodeID
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPPatRegister","GetDiagnosisDataList")
Query GetDiagnosisDataList(registerId As %String, diagType As %String = "") As %Query(ROWSPEC = "Id:%String,RegisterId:%String,IcdId:%String,Description:%String,DiagnosisType:%String,UpdateCtcpId:%String,UpdateDate:%String,UpdateTime:%String")
{
}

ClassMethod GetDiagnosisDataListExecute(ByRef qHandle As %Binary, registerId As %String, diagType As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	i registerId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s diagId=0,compareStr="" 
	f  s diagId=$o(^DHCBPDiagnos(0,"BPPReg",registerId,diagId)) q:diagId=""  d
	.q:'$d(^DHCBPDiagnos(diagId))	
 	.s RegisterId=$lg(^DHCBPDiagnos(diagId),1)
 	.s IcdId=$lg(^DHCBPDiagnos(diagId),2)
 	.s Description=$lg(^DHCBPDiagnos(diagId),3)
 	.s DiagnosisType=$lg(^DHCBPDiagnos(diagId),4)
 	.q:(diagType'="")&&(diagType'=DiagnosisType)
 	.s UpdateCtcpId=$lg(^DHCBPDiagnos(diagId),5)
 	.s UpdateDate=$lg(^DHCBPDiagnos(diagId),6)
 	.s UpdateTime=$lg(^DHCBPDiagnos(diagId),7)
 	.s IfAbandon=$lg(^DHCBPDiagnos(diagId),8)
 	.q:(IfAbandon="Y")
 	.s Id=diagId	    
 	.d OutputRow1	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(Id,RegisterId,IcdId,Description,DiagnosisType,UpdateCtcpId,UpdateDate,UpdateTime)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetDiagnosisDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagnosisDataListExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetDiagnosisDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagnosisDataListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 获取有效的病人编号
/// w ##class(web.DHCBPPatRegister).getEffectiveBpNo("","119","")
ClassMethod getEffectiveBpNoold(bpNo As %String = "", locId As %String = "", BpPatType As %String = "") As %String
{
	s retStr=0
	k ^dhcBpNoEffective
	s bpprId=0,EffectiveBPNo=0
	f  s bpprId=$o(^DHCBPPatRegister(bpprId)) q:bpprId=""  d 
	.s bpprPatBPNo=$lg(^DHCBPPatRegister(bpprId),17)
	.q:bpprPatBPNo=""
	.s patDeptId=$lg(^DHCBPPatRegister(bpprId),30)		
	.q:(locId'="")&&(patDeptId'=locId)	
	.s ^dhcBpNoEffective(bpprPatBPNo)=""
	.s bpprIdSub=""
	.f  s bpprIdSub=$o(^DHCBPPatRegister(0,"PatBPNo",bpprPatBPNo,bpprIdSub)) q:bpprIdSub=""  d		
	..s PatType=$lg(^DHCBPPatRegister(bpprId),25)
	..q:(BpPatType'="")&&(PatType'=BpPatType)	
	..s status=$lg(^DHCBPPatRegister(bpprIdSub),14)	
	..i (status'="N") k ^dhcBpNoEffective(bpprPatBPNo)
	..i (status="N") d
	...s ^dhcBpNoEffective(bpprPatBPNo)=""
	...if (EffectiveBPNo<bpprPatBPNo) d
	....s EffectiveBPNo=bpprPatBPNo
	///获取最小有效编号不包括字母
	s NowBPNo=EffectiveBPNo,preBPNo=EffectiveBPNo
	f  s NowBPNo=$o(^dhcBpNoEffective(preBPNo),-1) q:(NowBPNo="")  d
	.if (EffectiveBPNo-NowBPNo<=1 ) s preBPNo=NowBPNo
	.if (EffectiveBPNo-NowBPNo>1)  d
	..;b ;2
	..if preBPNo'=(NowBPNo+1)  d
	...s EffectiveBPNo=NowBPNo
	..if preBPNo=(NowBPNo+1)  d
	...s preBPNo=NowBPNo
	.;b ;3
	s EffectiveBPNo=EffectiveBPNo+1
	q EffectiveBPNo
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPPatRegister","GetAdmDiagnosisList")
Query GetAdmDiagnosisList(registerId As %String, diagType As %String = "") As %Query(ROWSPEC = "Id:%String,Description:%String,ICDCode:%String")
{
}

ClassMethod GetAdmDiagnosisListExecute(ByRef qHandle As %Binary, registerId As %String, diagType As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	i registerId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	
 	s papmiId=$lg(^DHCBPPatRegister(registerId),1)
 	s locId=$lg(^DHCBPPatRegister(registerId),30)
 	
 	s admId="",quit=0,mrAdmRowId=""
    f  s admId=$o(^PAPERdr(papmiId,"ADM","O",admId),-1) q:(admId="")!(quit)  d
	.s admDeptId=$p($g(^PAADM(admId)),"^",4)
	.q:(locId'="")&&(locId'=admDeptId)
	.s admDate=$p($g(^PAADM(admId)),"^",6)
	.q:(admDate>+$h)
	.s mrAdmRowId=$p($g(^PAADM(admId)),"^",61)
	.d GetOrder
	s qHandle=$lb(0,repid,0)
	q $$$OK
GetOrder
	w "mrAdmRowId"_mrAdmRowId,!
	s resultSet=##class(%ResultSet).%New("web.DHCDocDiagnosNew:DiagnosList")
	d resultSet.Execute(mrAdmRowId,"","","")
	while(resultSet.Next())
	{		
		s DiagnosDesc=resultSet.GetData(1)
		s DiagnosValue=resultSet.GetData(2)
		s DiagnosICDCode=resultSet.GetData(5)
		s DiagnosPrefix=resultSet.GetData(12) //前缀
		s MRDesc=resultSet.GetData(4) //备注
		i DiagnosDesc="" d
			.s DiagnosDesc=MRDesc
			.i DiagnosPrefix'="" s DiagnosDesc="("_DiagnosPrefix_")"_DiagnosDesc
		e  d
			.i DiagnosPrefix'="" s DiagnosDesc=DiagnosDesc_"("_DiagnosPrefix_")"
			.i MRDesc'="" s DiagnosDesc=DiagnosDesc_"("_MRDesc_")"
		d OutputRow1
	}
	s quit=1
	q 0
    
OutputRow1
	s Data=$lb(DiagnosValue,DiagnosDesc,DiagnosICDCode)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetAdmDiagnosisListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmDiagnosisListExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetAdmDiagnosisListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmDiagnosisListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 获取有效的病人编号
/// Input:locId：科室Id;BpPatType(N/T):N常规类型病人编号,T临时类型病人编号；subType透析类型：H血透、P腹透
/// Note: n自定义最大使用编号;sort血透获取最小有效编号，腹透获取最大编号(转归不重复利用)
/// w ##class(web.DHCBPPatRegister).getEffectiveBpNo("","15")
ClassMethod getEffectiveBpNo(bpNo As %String = "", locId As %String = "", BpPatType As %String = "N", subType As %String = "H") As %String
{
	
	k ^dhcBpNoEffective
	s i = 1,n=10000
	while(i<(n+1))
	{
	s ^dhcBpNoEffective(i)=""
	s i=i+1
	}
	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
	s bpprId=0,retStr=0
	f  s bpprId=$o(^DHCBPPatRegister(bpprId)) q:bpprId=""  d 
	.s bpprPatBPNo=$lg(^DHCBPPatRegister(bpprId),17)
	.q:bpprPatBPNo=""
	.//s patDeptId=$lg(^DHCBPPatRegister(bpprId),30)	
	.//q:(locId'="")&&(patDeptId'=locId)
	.s bpprPatLocationDr=$lg(^DHCBPPatRegister(bpprId),34) //add 20220519 改成病区ID判断
	.q:(bpprPatLocationDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_bpprPatLocationDr_"^"))	
	.s PatType=$lg(^DHCBPPatRegister(bpprId),25)
	.//q:(BpPatType'="")&&(PatType'=BpPatType)
	.s status=$lg(^DHCBPPatRegister(bpprId),14)
	.q:(subType="H")&&(status="D")
	.k ^dhcBpNoEffective(bpprPatBPNo)
	.i bpprPatBPNo>n d
	..s tmp=bpprPatBPNo
	..i tmp>retStr d
	...s retStr=tmp+1
	i (retStr'=0)&&($d(^dhcBpNoEffective)<1) q retStr
	i subType="H" s sort=1
	e  i subType="P" s sort=-1
	s sort=1
	s EffectiveBPNo=0,quit=0
	f  s EffectiveBPNo=$o(^dhcBpNoEffective(EffectiveBPNo),sort) q:(EffectiveBPNo="")||(quit=1)  d
	.s retStr=EffectiveBPNo
	.s quit=1
	q retStr
}

/// 分配透析编号
/// Input:registerId：登记Id;userId操作用户；subType透析类型：H血透、P腹透
/// 分配编号：血透获取最小有效编号(转归重复利用)，腹透获取最大编号(转归不重复利用)
/// w ##class(web.DHCBPPatRegister).ChangeRegisterNo("1","18","")
ClassMethod ChangeRegisterNo(registerId As %String, userId As %String, subType As %String = "H") As %String
{
	q:registerId="" "id为空"
	s register=##class(User.DHCBPPatRegister).%OpenId(registerId)
	q:(register.BPPRStatus="D") "已转归病人不能分配编号"
	s bpprPatDeptDr=register.BPPRPatDeptDr
	s bpprPatBPNo=..getEffectiveBpNo("",bpprPatDeptDr,"",subType)
	s updateDate=+$h
    s updateTime=$p($h,",",2)
	&sql(update DHC_BP_PatRegister set BPPR_PatBPNo=:bpprPatBPNo,BPPR_UpdateUser_Dr=:userId,BPPR_UpdateDate=:updateDate,BPPR_UpdateTime=:updateTime where BPPR_RowId=:registerId)	
	i (SQLCODE'=0)&(SQLCODE'=100) q SQLCODE
	q 1
}

/// w ##class(web.DHCBPPatRegister).GetEpisodeId(317)
ClassMethod GetEpisodeId(registerId) As %String
{
	q:registerId="" "-1"
  	s registerObj=##class(User.DHCBPPatRegister).%OpenId(registerId)
  	s papmiId=registerObj.BPPRPaPatMasDr
  	
  	s EpisodeID="",adm="",quit=0,admType=""
  	b
    s EpisodeIDList=##class(web.DHCBPCom).GetPatientEpisodeID("",papmiId,+$h,+$h,197)
    s EpisodeID=$p(EpisodeIDList,"^",1)
	q EpisodeID
}

}
