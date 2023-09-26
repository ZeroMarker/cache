Import SQLUser

Class DHCBP.Register Extends web.DHCClinicCom
{

// s str="{""ToDate"":""2019-04-24"",""PapmiId"":""10"",""BPNO"":""00001"",""AdmId"":""5"",""Address"":""xxxxx""}"

// w ##class(DHCBP.Register).Save(str)

ClassMethod Save(paramStr)
{
	// s data={}.%FromJSON(paramStr)
	s data=..ToJsonObj(paramStr)
	s registerId=data.GetAt("RegisterId")
	s register="",result=""
	
	s patientId=data.GetAt("PatientId")
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(data.GetAt("ToDate"))
	s fromDate=toDate-3
	//s ^TMPzt(".GetPatientEpisodeID")=patientId_"/"_fromDate_"/"_toDate
	;s episodeIDList=##class(web.DHCBPCom).GetPatientEpisodeID("",patientId,fromDate,toDate)
	;q:episodeIDList="" "该次就诊记录挂号时间已超过三天，请重新挂号"
	s papmiId=data.GetAt("PapmiId")	
	b
	s patDeptDr=data.GetAt("DepartmentId")
	i patDeptDr'="" s linkLocationDr=##Class(web.DHCBPCom).GetLinkLocByLocId(patDeptDr)
	e  s linkLocationDr=""
	s status="",LocationDr="",isRegister=0
	s bpprId=""
	f  s bpprId=$o(^DHCBPPatRegister(0,"PaPatMas",papmiId,bpprId)) q:bpprId=""  d
		.s status=$lg(^DHCBPPatRegister(bpprId),14)
		.s LocationDr=$lg(^DHCBPPatRegister(bpprId),34)
		.i (status="N")&(registerId="")&(("^"_linkLocationDr_"^")[("^"_LocationDr_"^")) s isRegister=1
	i (isRegister=1) q "该病人已进行过透析登记，请勿重复登记!"
	s bpprPatBPNo=""
	i (registerId="")  d
	.s register=##class(User.DHCBPPatRegister).%New()
	.s admId=data.GetAt("AdmId")
	.i admId'="" d
	.s admType=$p($g(^PAADM(admId)),"^",2)
	.s admDeptId=$p($g(^PAADM(admId)),"^",4)
	.s register.BPPRPatClinicType=admType
	.s register.BPPRPatSourcreDeptDr=admDeptId
	e  d
	.s register=##class(User.DHCBPPatRegister).%OpenId(registerId)
	.s bpprPatBPNo=register.BPPRPatBPNo
	
	s bpNo=data.GetAt("BPNO")
	&sql(select count(*) into registerCount from DHC_BP_PatRegister where BPPR_PatBPNo=:bpNo and BPPR_Status='N' and BPPR_PatLocationDr=:linkLocationDr)
	i (bpprPatBPNo'=bpNo)&(registerCount>0)  q "此编号正在使用！"
	
	d ..SetByJson(register, paramStr,"BPPR")
	s register.BPPRPaPatMasDr=papmiId
	i patDeptDr'="" s register.BPPRPatLocationDr=##Class(web.DHCBPCom).GetLinkLocByLocId(patDeptDr)	
	d register.%Save()
	q register.%Id()
}

ClassMethod Get(paramStr)
{
	s data=..ToJsonObj(paramStr)
	s id=data.GetAt("id")
	q:id="" "id不能为空"
	s obj=##class(User.DHCBPPatRegister).%OpenId(id)
	d ..ToJSONArray(obj, .Array, preName = "")
	
	q ..ToJson(Array)
}

// w ##class(DHCBP.Register).GetBPPatRegister(8)

ClassMethod GetBPPatRegister(registerId As %String = "")
{
	q:registerId="" "registerId不能为空"
	s json=##class(%Library.ArrayOfDataTypes).%New()
	s bpprId=registerId
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	q:papmiId="" -2
	q:'$d(^PAPER(papmiId,"PAT",1)) -3
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	//s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s personID=$p($G(^PAPER(papmiId,"ALL")),"^",9)  //身份证
	s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
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
	;s bpprPatDeptDr=$lg(^DHCBPPatRegister(bpprId),30)
	s bpprPatLocationDr=$lg(^DHCBPPatRegister(bpprId),34)
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
	i bpprPatType="N" s bpprPatType="常规"
	e  s bpprPatType="临时"
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
	
	//项目串
	s tempItemStr="PatientID,RegNo,PatientName,PersonID,MedicareNo,Gender,DOB,Age,Diagnosis,BloodPurificationNo,BloodPurificationCount,HouseAddress,ContactNumber,FamilyMember,Introducer,MainDoctorId,MainDoctorName,MainNurseId,MainNurseName,StartDate,EndDate,Status,VisitStatusId,VisitStatus,DeceaseReasonId,DeceaseReasonDesc,OtherDeceaseReason,IsContinueTherapy,Id,RegisterDate,RegisterTime,ClinicTypeCode,ClinicType,PatientSource,SourceDeptId,SourceDept,Infection,PatientType,EpisodeID,SourceTelephone,DialysisReasonId,DialysisReasonDesc,DeadDiseaseId,DeadDiseaseDesc,PatNation,SecCode,PatLevel"
	//项目数据串，顺序与项目串一一对应
	s tempValueStr=papmiId_"^"_regNo_"^"_patName_"^"_personID_"^"_papmiMedicare_"^"_patSex_"^"_patBirth_"^"_patAge_"^"_bpprDiagnosis_"^"_bpprPatBPNo_"^"_bpprPatBPCount_"^"_bpprAddress_"^"_bpprTelephone_"^"_bpprContact_"^"_bpprIntroducer_"^"_bpprMainDoctorCtcpDr_"^"_bpprMainDoctorCtcpDesc_"^"_bpprMainNurseCtcpDr_"^"_bpprMainNurseCtcpDesc_"^"_bpprStartDate_"^"_bpprEndDate_"^"_bpprStatus_"^"_bpprBPCVisitStatusDr_"^"_bpprBPCVisitStatus_"^"_bpprDeceaseReasonDr_"^"_bpprDeceaseReason_"^"_bpprOtherDeceaseReason_"^"_bptIsMaintenanceTherapy_"^"_bpprId_"^"_registerDate_"^"_registerTime_"^"_bpprPatClinicTypeCode_"^"_bpprPatClinicType_"^"_bpprPatSource_"^"_bpprPatSourcreDeptDr_"^"_bpprPatSourcreDept_"^"_bpprInfection_"^"_bpprPatType_"^"_admId_"^"_sourceTelephone_"^"_mrcIcdId_"^"_mrcIcdDesc_"^"_deceaseMrcIcdId_"^"_deceaseMrcIcdDesc_"^"_patNation_"^"_SecCode_"^"_PatLevel
	for i=1:1:$l(tempItemStr,",") {
		d json.SetAt($P(tempValueStr,"^",i),$P(tempItemStr,",",i))
		}
	q ##class(Nur.JSON).Encode(json)
}

/// 优先级：1.按登记号、病案号、姓名查无时间限制。2.needBpprStatus为"N"查找当前治疗病人。3.其它按登记日期范围查。
/// D ##class(%ResultSet).RunQuery("web.DHCBPPatRegister","FindBPPatRegister","","","","N","","","","00006","N")
Query FindBPPatRegister(fromDate As %String, toDate As %String, regNo As %String = "", needBpprStatus As %String = "", papmiMedicare As %String = "", papmiName As %String = "", registerId As %String = "", bpNo As %String = "", patType As %String = "", locId As %String = "", dialysisMethodID As %String = "") As %Query(ROWSPEC = "PatientID,RegNo,PatientName,PersonID,MedicareNo,Gender,DOB,Age,Diagnosis,BloodPurificationNo,BloodPurificationCount,HouseAddress,ContactNumber,FamilyMember,Introducer,MainDoctorId,MainDoctorName,MainNurseId,MainNurseName,StartDate,EndDate,Status,VisitStatusId,VisitStatus,DeceaseReasonId,DeceaseReasonDesc,OtherDeceaseReason,IsContinueTherapy,Id,RegisterDate,RegisterTime,ClinicTypeCode,ClinicType,PatientSource,SourceDeptId,SourceDept,Infection,PatientType,EpisodeID,SourceTelephone,DialysisReasonId,DialysisReasonDesc,DeadDiseaseId,DeadDiseaseDesc,PatNation,SecCode,PatLevel")
{
}

ClassMethod FindBPPatRegisterExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, regNo As %String = "", needBpprStatus As %String = "", papmiMedicare As %String = "", papmiName As %String = "", registerId As %String = "", bpNo As %String = "", patType As %String = "", locId As %String = "", dialysisMethodID As %String = "") As %Status
{
	//s ^tempby("111")=fromDate_"^"_toDate_"^"_regNo_"^"_needBpprStatus_"^"_papmiMedicare_"^"_papmiName_"^"_registerId_"^"_bpNo  _"^"_patType_"^"_locId_"^"_dialysisMethodID
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	K ^TMPBP("PatRegister",$j) //排序的临时global
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
		.s papmiIdList=$o(^PAPERi("Medicare1",papmiMedicare,""))
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
	s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
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
	set Data=$lb(papmiId,regNo,patName,personID,papmiMedicare,patSex,patBirth,patAge,bpprDiagnosis,bpprPatBPNo,bpprPatBPCount,bpprAddress,bpprTelephone,bpprContact,bpprIntroducer,bpprMainDoctorCtcpDr,bpprMainDoctorCtcpDesc,bpprMainNurseCtcpDr,bpprMainNurseCtcpDesc,bpprStartDate,bpprEndDate,bpprStatus,bpprBPCVisitStatusDr,bpprBPCVisitStatus,bpprDeceaseReasonDr,bpprDeceaseReason,bpprOtherDeceaseReason,bptIsMaintenanceTherapy,bpprId,registerDate,registerTime,bpprPatClinicTypeCode,bpprPatClinicType,bpprPatSource,bpprPatSourcreDeptDr,bpprPatSourcreDept,bpprInfection,bpprPatType,admId,sourceTelephone,mrcIcdId,mrcIcdDesc,deceaseMrcIcdId,deceaseMrcIcdDesc,patNation,SecCode,PatLevel)
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
 	Quit $$$OK
}

}
