Import SQLUser

Class web.DHCBPArrange Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// w ##class(web.DHCBPArrange).SaveBPArrange("6"_$c(3)_"4"_$c(3)_$c(3)_$c(3)_"2013-09-13"_$c(3)_"0:00"_$c(3)_"A"_$c(3)_"1"_$c(3)_$c(3)_"R"_$c(3)_"0"_$c(3)_"0"_$c(3)_"0"_$c(3)_"0"_$c(3)_"0"_$c(3)_"0"_$c(3)_"0"_$c(3)_"0"_$c(3)_"0"_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_"1"_$c(3)_"2"_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_"0"_$c(3)_"0"_$c(3)_"0"_$c(3)_$c(3)_$c(3)_"0"_$c(3)_"0"_$c(3)_"41"_$c(3)_"42"_$c(3)_"43"_$c(3)_"44"_$c(3)_"45"_$c(3)_$c(3)_"0"_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_"9999-12-31"_$c(3)_"23:59"_$c(3)_"338"_$c(3)_"2013-09-13"_$c(3)_"9:52")

/// Creator: ZT
/// CreatDate: 2014-10-26
/// Description: 获取安排表概要信息记录
/// Table：DHC_BP_Arrange
/// Input：
/// Return：返回安排概要记录
/// D ##class(%ResultSet).RunQuery("web.DHCBPArrange","FindBPArrangeSummary","2014-10-17","2014-11-23","",)
/// D ##class(%ResultSet).RunQuery("web.DHCBPArrange","FindBPArrangeSummary","","","","",127)
Query FindBPArrangeSummary(fromDate As %String, toDate As %String, needBpaStatus As %String = "", registerId As %String, arrangeId As %String = "", locId As %String = "", patRegStatus As %String = "") As %Query(ROWSPEC = "Id,RegisterId,SchemeDetailId,EpisodeId,RegNo,PatName,PatGender,PatAge,MedicareNo,PatBPNo,BedId,BedDesc,ArrangeDate,ArrangeTime,DayPartCode,ArrangeType,Status,DocOperateStatus,RegisterStatus,DialysisMethodId,DialysisMethodDesc,SecondDialysisMethodId,SecondDialysisMethodDesc,AllConsumable,EquipId,EquipDesc,PatType,SecCode,PatLevel,BedGroupDesc,AnticoagulantModeId,AntModeDesc,StartOperationTime,WeekSeqNoDesc,PlanReceiveTime,Infection,BedStatus")
{
}

ClassMethod FindBPArrangeSummaryExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, needBpaStatus As %String = "", registerId As %String, arrangeId As %String = "", locId As %String = "", patRegStatus As %String = "") As %Status
{
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
	i arrangeId'="" d
	.s bpaId=arrangeId
	.i '($$GetArrange()<0) d
	..d OutputRow
	i arrangeId'="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s bpaId=""
	if (registerId'="")	
	{
		f  s bpaId=$o(^DHCBPArrange(0,"PatRegister",registerId,bpaId)) q:bpaId=""  d
		.q:$$GetArrange()<0
		.d OutputRow
	}
	else
	{	
	  f curDate=fromDate:1:toDate d
	  .s bpaId=""
	  .f  s bpaId=$o(^DHCBPArrange(0,"Date",curDate,bpaId)) q:bpaId=""  d
	  ..q:$$GetArrange()<0
	  ..d OutputRow
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
GetArrange()
	q:bpaId="" -1	
	s bpprId=$lg(^DHCBPArrange(bpaId),1)
	q:bpprId="" -2
	s bpaDate=$lg(^DHCBPArrange(bpaId),4)
	s bpaTime=$lg(^DHCBPArrange(bpaId),5)
	q:(bpaDate'="")&(bpaDate>toDate)&(arrangeId="") -3
	q:(bpaDate'="")&(bpaDate<fromDate)&(arrangeId="") -4	
	s bpaStatus=$lg(^DHCBPArrange(bpaId),9)	
	q:bpaStatus="" -5	
	q:(needBpaStatus'="")&&(needBpaStatus'[bpaStatus) -6
	q:bpaStatus="D" -7
	//;s admId=$lg(^DHCBPArrange(bpaId),2)
	s admId=$lg(^DHCBPPatRegister(bpprId),26)
	q:admId="" -8
	s admDeptId=$p($g(^PAADM(admId)),"^",4)
	;s bpprPatDeptDr=$lg(^DHCBPPatRegister(bpprId),30)
	s bpprPatLocationDr=$lg(^DHCBPPatRegister(bpprId),34)	
    q:((locId'="")&&(bpprPatLocationDr'="")&&($p($g(^CTLOC(locId)),"^",22)'=$p($g(^CTLOC(bpprPatLocationDr)),"^",22))) -9 //病人所在医院判断
    q:(bpprPatLocationDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_bpprPatLocationDr_"^")) -10
    s bpsId=$lg(^DHCBPArrange(bpaId),3)
    q:bpsId="" -11   
	s bpprStatus=$lg(^DHCBPPatRegister(bpprId),14)	
	s bpprEndDate=$lg(^DHCBPPatRegister(bpprId),13)
	q:(arrangeId="")&&(bpprStatus="D")&&(bpprEndDate<bpaDate) -12.1 //转归后
	q:(arrangeId="")&&("^"_patRegStatus_"^"["D")&("^"_patRegStatus_"^"'[bpprStatus) -12.2 //包含转归过滤
	//;i bpprId=118 w bpprStatus_"/"_patRegStatus,!
	//q:(arrangeId="")&&(patRegStatus'="")&&("^"_patRegStatus_"^"'[bpprStatus) -12 //通过ArrangeId查询某个病人,不再判断方案状态
	i bpprStatus="N" s bpprStatus="治疗"
	i bpprStatus="D" s bpprStatus="转归"	
	s bpprPatBPNo=$lg(^DHCBPPatRegister(bpprId),17)
	s bpprPatType=$lg(^DHCBPPatRegister(bpprId),25)
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	q:papmiId="" -13
	q:'$d(^PAPER(papmiId,"PAT",1)) -14
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	//s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22) //病案号 20200515统一走病案接口
	s paadmtype=$p($g(^PAADM(admId)),"^",2)
	s papmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
	s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s patBirth=$p($g(^PAPER(papmiId,"ALL")),"^",6)	//出生日期
	s patAge=##class(web.DHCClinicCom).CalAge(patBirth,bpaDate)
	///病人登记时填写的已经透析次数
	s bpprBPCount=+$lg(^DHCBPPatRegister(bpprId),18)	
	s bpaDaySeqNo=""
	s bpaDaySeqNo=$lg(^DHCBPArrange(bpaId),6)	
	s bpaBPCBedDr=$lg(^DHCBPArrange(bpaId),7)
	s bpaBPCBedDesc=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),2)
	s bpcBedGroupDr=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),3)
	s bpcBedGroupDesc=$lg($g(^DHCBPC("BedGroup",+bpcBedGroupDr)),2)
	i (bpaBPCBedDr="")||(bpaBPCBedDr=0) d //绑定床位组
		.s bppId=##class(web.DHCBPPatSetUpBedGroup).GetPatSetUpBedGroupID(bpprId,bpaDaySeqNo) //病人绑定床位组记录ID
		.i bppId'="" d
			..s bpcBedGroupDr=$lg($g(^DHCBPPatSetUpBedGroup(bppId)),1) 
			..s bpcBedGroupDesc=$lg($g(^DHCBPC("BedGroup",+bpcBedGroupDr)),2)
	s bpaEquipDr=$lg(^DHCBPArrange(bpaId),25) //净化设备
	s bpaEquipDesc=$lg($g(^DHCBPC("Equip",+bpaEquipDr)),3)	
	s bpaArrangeType=$lg(^DHCBPArrange(bpaId),8)	
	s bpaDocOperateStatus=$lg(^DHCBPArrange(bpaId),55)
	s bpaBPCBPModeDr=$lg(^DHCBPArrange(bpaId),26)
	s bpaBPCBPModeDesc=$lg($g(^DHCBPC("BloodPurificationMode",+bpaBPCBPModeDr)),2)
	s bpaSecondBPCBPModeDr=$lg(^DHCBPArrange(bpaId),27)
	s bpaSecondBPCBPModeDesc=$lg($g(^DHCBPC("BloodPurificationMode",+bpaSecondBPCBPModeDr)),2)
	s effectDate="",weekSeqNo="",weekSeqNoDesc="",cycle=2,weekDay=$zd(bpaDate,10) //获取当前透析记录所属透析计划的第几周(单/双)
    &sql(select min(BPAS_EffectDate) into :effectDate from dhc_bp_arrangescheme where BPAS_BPPatRegister_Dr=:bpprId and BPAS_BPScheme_Dr=:bpsId and BPAS_BPCBPMode_Dr=:bpaBPCBPModeDr and BPAS_WeekDay=:weekDay and BPAS_DaySeqNo=:bpaDaySeqNo and (BPAS_IfAbandon='N' OR BPAS_IfAbandon is null))   
	i (effectDate'="")&&(bpaArrangeType'="T") d //安排计划生效/非临时透析
		.s effectWeekDay=$zd(effectDate,10)
		.s virtualEffectDate=effectDate-effectWeekDay+1   //虚拟开始日期，当本周使用了安排计划，相当于下周一开始就算第二周，所以将起始生效时间虚拟为本周一
		.s virWeekSeqNo=(bpaDate-virtualEffectDate)\7+1
		.s remainder=virWeekSeqNo#cycle
		.i remainder=0 s weekSeqNo=cycle, weekSeqNoDesc="第"_cycle_"周"
		.e  s weekSeqNo=remainder,weekSeqNoDesc="第"_remainder_"周"
	s planReceiveTime=##class(web.DHCBPPatSetUpBedGroup).GetCalReceptionTime(bpprId,bpaDate,bpaDaySeqNo) //根据绑定的接诊时间，算出(自动循环)当前周的接诊时间
	s bpaDateTime=""
	i bpaDate'="" d
	.s bpaDateTime=$zd(bpaDate,3)
	.s bpaDateTime=bpaDateTime_" "_$zt(bpaTime)
	i bpaDate'="" d
	.s bpaDate=##class(web.DHCClinicCom).ConvertToDate(bpaDate)
	i bpaTime'="" d
	.s bpaTime=##class(web.DHCClinicCom).ConvertToTime(bpaTime)
	s allConsumable=..GetConsumableString(bpaId,"true")
	s SecCode="",PatLevel=""
	S SecretStr=##class(DHCMed.SSIO.FromSecSrv).GetPatEncryptLevel(papmiId,.ErrMsg)
	i SecretStr'="" s SecCode=$p(SecretStr,"^",1)   //病人密级
	i SecretStr'="" s PatLevel=$p(SecretStr,"^",2)		//病人级别
	s bpaAnticoagulantModeDr=$lg(^DHCBPArrange(bpaId),77)
	i bpaAnticoagulantModeDr'="" s bpaAntModeDesc=$lg(^DHCBPC("AnticoagulantMode",bpaAnticoagulantModeDr),2)
	e  s bpaAntModeDesc=""
	s bpaStartOperationTime=$lg(^DHCBPArrange(bpaId),105) //上机时间
	i bpaStartOperationTime'="" s bpaStartOperationTime=##class(web.DHCClinicCom).ConvertToTime(bpaStartOperationTime)
	s Infection=$lg(^DHCBPPatRegister(bpprId),20)
	s bedStatus=""
	s:bpaBPCBedDr'="" bedStatus="" //##class(web.DHCBPArrangeScheme).GetBedStatus(bpaBPCBedDr,bpaDate,bpaDaySeqNo)  //这里比较影响查询效率 
	
	q 0
OutputRow           
	set Data=$lb(bpaId,bpprId,bpsId,admId,regNo,patName,patSex,patAge,papmiMedicare,bpprPatBPNo,bpaBPCBedDr,bpaBPCBedDesc,bpaDate,bpaTime,bpaDaySeqNo,bpaArrangeType,bpaStatus,bpaDocOperateStatus,bpprStatus,bpaBPCBPModeDr,bpaBPCBPModeDesc,bpaSecondBPCBPModeDr,bpaSecondBPCBPModeDesc,allConsumable,bpaEquipDr,bpaEquipDesc,bpprPatType,SecCode,PatLevel,bpcBedGroupDesc,bpaAnticoagulantModeDr,bpaAntModeDesc,bpaStartOperationTime,weekSeqNoDesc,planReceiveTime,Infection,bedStatus)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPArrangeSummaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPArrangeSummaryExecute ]
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

ClassMethod FindBPArrangeSummaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPArrangeSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator: ZT
/// CreatDate: 2014-11-18
/// Description: 根据arrangeId获取透析安排表详细信息
/// Table：DHC_BP_Arrange
/// Input：arrangeId
/// Return：透析安排表详细信息
Query GetBPArrange(arrangeId As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT BPA_StartWeight As StartWeight,
	BPA_SubtractiveWeight As SubtractiveWeight,
	BPA_PlanDewaterAmount As PlanDewaterAmount,
	BPA_DewaterAmount As DewaterAmount,
	BPA_EndWeight As EndWeight,
	BPA_PlanTherapyTime As PlanTherapyDuration,
	BPA_TherapyTime As TherapyDuration,
	BPA_ReplenishWaterAmount As ReplenishWaterAmount,
	BPA_IsolatedUltVolume As IsolatedUltrafiltrationVolume,
	BPA_VascularAccess_Dr As VascularAccessSchemeId,
	BPA_Ordered As IsOrdered,
	BPA_Na As Na,
	BPA_K As K,
	BPA_Ca2 As Ca2,
	BPA_HCO3 As HCO3,
	BPA_FilterReplaceMode As FilterReplaceMode,
	BPA_PlanFilterReplaceAmount As PlanFilterReplaceAmount,
	BPA_FilterReplaceAmount As FilterReplaceAmount,
	BPA_EquipRunEffect As EquipRunStatus,
	BPA_BPMeasurePart As BloodPressureMeasurePart,
	BPA_Temperature As Temperature,
	BPA_Grume As Grume,
	BPA_PipeGrume As PipeGrume,
	BPA_VascularAccessStatus As VascularAccessStatus,
	BPA_StartDiastolicPressure As StartDiastolicPressure,
	BPA_EndDiastolicPressure As EndDiastolicPressure,
	BPA_StartSystolicPressure As StartSystolicPressure,
	BPA_EndSystolicPressure As EndSystolicPressure,
	BPA_StartHeartRate As StartHeartRate,
	BPA_EndHeartRate As EndHeartRate,
	BPA_StartSymptom As StartSymptom,
	BPA_EndSymptom As EndSymptom,
	BPA_UrineVolume As UrineVolume,
	BPA_ClinicalEvaluationNote As ClinicalEvaluationNote,
	BPA_BFR As BFR,
	BPA_BFRNote BFRNote,
	BPA_BPCVA_Dr As VascularAccessId,
	BPA_VABodySite_Dr As BodySiteId,
	BPA_AnticoagulantMode_Dr As AnticoagulantModeId,
	BPA_ReturnSalineAmount As ReturnSalineAmount,
	BPA_BPSchemeAdjustment As BPSchemeAdjustment,
	BPA_DFR As DFR,
	BPA_DiseaseTreatment As DiseaseTreatment,
	BPA_Note As Note,
	BPA_BPNum As BPNum,
	BPA_EndDate As ArrangeEndDate,
	BPA_EndTime As ArrangeEndTime,
	BPA_CreateUser_Dr As CreateUserId,
	BPA_CreateDate As CreateDate,
	BPA_CreateTime As CreateTime,
	BPA_DocOperateStatus As DocOperateStatus,
	BPA_CheckDoc_Dr As CheckDocId,
	BPA_CheckDate As CheckDate,
	BPA_CheckTime As CheckTime,
	BPA_RecheckDoc_Dr As RecheckDocId,
	BPA_RecheckDate As RecheckDate,
	BPA_RecheckTime As RecheckTime,
	BPA_WardRoundDoc_Dr As WardRoundDocId,
	BPA_WardRoundDate  As WardRoundDate,
	BPA_WardRoundTime As WardRoundTime,
	BPA_EndUpdateDoc_Dr As EndUpdateDocId,
	BPA_DocEndUpdateDate As DocEndUpdateDate,
	BPA_DocEndUpdateTime As DocEndUpdateTime,
	BPA_StartOperationNurse_Dr As StartOperationNurseId,
	BPA_StartOperationDate As StartOperationDate,
	BPA_StartOperationTime As StartOperationTime,
	BPA_EndOperationNurse_Dr As EndOperationNurseId,
	BPA_EndOperationDate As EndOperationDate,
	BPA_EndOperationTime As EndOperationTime,
	BPA_CheckNurse_Dr As CheckNurseId,
	BPA_NurseCheckDate As NurseCheckDate,
	BPA_NurseCheckTime As NurseCheckTime,
	BPA_IntakeAmount As IntakeAmount,
	BPA_LaboratoryExamination As LaboratoryExamination,
	BPA_OtherSymptoms As OtherSymptoms,
	BPA_DialysisBeforeNote As DialysisBeforeNote
	from DHC_BP_Arrange where BPA_RowId=:arrangeId
}

// 返回透析上一次或下一次安排日期(不再使用)

ClassMethod GetArrangeDate(registerId, arrangeId, type) As %String
{
	
    s quit=0,RetDate=""
    s bpaDate=$lg(^DHCBPArrange(arrangeId),4)
	s bpaDatePre=bpaDate,bpaId=""
	i type="Pre" d
	.f  s bpaDatePre=$o(^DHCBPArrange(0,"Date",bpaDatePre),-1) q:(bpaDatePre="")!(quit)  d
	..f  s bpaId=$o(^DHCBPArrange(0,"Date",bpaDatePre,bpaId)) q:(bpaId="")!(quit)  d
	...s regId=$lg(^DHCBPArrange(bpaId),1) 
	...q:registerId'=regId
	...s status=$lg(^DHCBPArrange(bpaId),9)
	...q:(status="A")!(status="D")
    ...s quit=1
    ...s bpaDate=$lg(^DHCBPArrange(bpaId),4)
    e  d
    .f  s bpaDatePre=$o(^DHCBPArrange(0,"Date",bpaDatePre)) q:(bpaDatePre="")!(quit)  d
	..f  s bpaId=$o(^DHCBPArrange(0,"Date",bpaDatePre,bpaId)) q:(bpaId="")!(quit)  d
	...s regId=$lg(^DHCBPArrange(bpaId),1) 
	...q:registerId'=regId
	...s status=$lg(^DHCBPArrange(bpaId),9)
	...q:(status="A")!(status="D")
    ...s quit=1
    ...s bpaDate=$lg(^DHCBPArrange(bpaId),4)
	i bpaDate'="" d
	.s RetDate=$zd(bpaDate,3)
	q RetDate
}

// 返回透析上一次或下一次安排ID

ClassMethod GetArrangeIdPreOrNext(registerId, arrangeId, type, status As %String = "") As %String
{
	
    s quit=0,RetDate="",RetbpaId="",ComparisonDate=""
    s bpaDate=$lg(^DHCBPArrange(arrangeId),4)    
	s bpaDatePre=bpaDate
	i type="Pre" s bpaDatePre=bpaDatePre+1  //add mfc 20200707
	e  i type="Next" s bpaDatePre=bpaDatePre-1
	//w bpaDate,!
	s RetbpaId=##class(web.DHCBPArrange).GetArrangeIdNext(registerId,arrangeId,type)
	//w "RetbpaId:"_RetbpaId,!
	i RetbpaId'="" q RetbpaId
	s bpaId=""
	i type="Pre" d
	.f  s bpaDatePre=$o(^DHCBPArrange(0,"Date",bpaDatePre),-1) q:(bpaDatePre="")!(quit)  d
	..i RetbpaId'="" s quit=1	
	..;w "bpaDatePre:"_bpaDatePre,!
	..f  s bpaId=$o(^DHCBPArrange(0,"Date",bpaDatePre,bpaId)) q:(bpaId="")!(quit)  d
	...s regId=$lg(^DHCBPArrange(bpaId),1)	
	...q:registerId'=regId
	...q:arrangeId=bpaId
	...q:(bpaDate=bpaDatePre)&&(arrangeId<bpaId) //add mfc 20200707
	...//w bpaDatePre_"/"_bpaId,!
	...s bpaStatus=$lg(^DHCBPArrange(bpaId),9)
	...q:(status="")&&((bpaStatus="A")!(bpaStatus="D"))
	...q:(status'="")&&(status'[bpaStatus)
    ...s bpaDate=$lg(^DHCBPArrange(bpaId),4)
    ...s StOpTime=$lg(^DHCBPArrange(bpaId),105)
    ...;w StOpTime_"/"_ComparisonDate,!
    ...i ComparisonDate="" s ComparisonDate= StOpTime 
    ...i StOpTime>=ComparisonDate s RetbpaId=bpaId    
    e  d
    .f  s bpaDatePre=$o(^DHCBPArrange(0,"Date",bpaDatePre)) q:(bpaDatePre="")!(quit)  d
    ..i RetbpaId'="" s quit=1
    ..;w "bpaDatePre:"_bpaDatePre,!
	..f  s bpaId=$o(^DHCBPArrange(0,"Date",bpaDatePre,bpaId),-1) q:(bpaId="")!(quit)  d
	...s regId=$lg(^DHCBPArrange(bpaId),1) 
	...q:registerId'=regId
	...q:arrangeId=bpaId
	...q:(bpaDate=bpaDatePre)&&(arrangeId>bpaId)  //add mfc 20200707
	...s bpaStatus=$lg(^DHCBPArrange(bpaId),9)
	...q:(status="")&&((bpaStatus="A")!(bpaStatus="D")) 
	...q:(status'="")&&(status'[bpaStatus) 
    ...s bpaDate=$lg(^DHCBPArrange(bpaId),4)
    ...s StOpTime=$lg(^DHCBPArrange(bpaId),105)
    ...;w StOpTime_"/"_ComparisonDate,!
    ...i ComparisonDate="" s ComparisonDate= StOpTime 
    ...i StOpTime<=ComparisonDate s RetbpaId=bpaId    
	i bpaDate'="" d
	.s RetDate=$zd(bpaDate,3)
	;q RetDate
	q RetbpaId
}

// 获取当日多次的上一次或下一次安排ID

// w ##class(web.DHCBPArrange).GetArrangeIdList(111,35572,"Pre")

ClassMethod GetArrangeIdNext(registerId, arrangeId, type) As %String
{
	s RetbpaId="",quit=0
	q:registerId="" "登记ID不能为空！"
	q:arrangeId="" "安排ID不能为空！"
	s bpaDate=$lg(^DHCBPArrange(arrangeId),4)
	s StartOperTime=$lg(^DHCBPArrange(arrangeId),105)
	s bpaId=""
	f  s bpaId=$o(^DHCBPArrange(0,"Date",bpaDate,bpaId)) q:(bpaId="")  d
	.s status=$lg(^DHCBPArrange(bpaId),9)
	.q:(status="A")!(status="D")
	.s regId=$lg(^DHCBPArrange(bpaId),1) 
	.q:registerId'=regId
	.s StOpTime=$lg(^DHCBPArrange(bpaId),105)
	.;w StartOperTime_"/"_StOpTime,!
	.q:(StartOperTime="")||(StOpTime="")
	.q:(type="Pre")&&(StOpTime>=StartOperTime)
	.q:(type="Next")&&(StOpTime<=StartOperTime)
	.;q:arrangeId=bpaId
    .i RetbpaId="" s RetbpaId=bpaId
    q RetbpaId
}

// w ##class(web.DHCBPArrange).GetLastArrangeBPMeasurePart(31,470)

ClassMethod GetLastArrangeBPMeasurePart(registerId, arrangeId) As %String
{
	 s quit=0
	 s bpaId=arrangeId,bpMeasurePart=""
	 f  s bpaId=$o(^DHCBPArrange(0,"PatRegister",registerId,bpaId),-1) q:(bpaId="")!(quit)  d
	 .s status=$lg(^DHCBPArrange(bpaId),9)
	 .q:(status="A")!(status="D")
	 .s quit=1
	 .s bpMeasurePart=$lg(^DHCBPArrange(bpaId),59)
	 q bpMeasurePart
}

// w ##class(web.DHCBPArrange).GetConsumableString(647)

/// Creator: ZT
/// CreatDate: 2014-10-26
/// Description: 根据arrangeId获取所有透析器材 
/// Table：DHC_BP_Arrange
/// Input：arrangeId,needCount
/// Return：返回安排的所有透析器材包括数量的拼接字符串
ClassMethod GetConsumableString(arrangeId As %String, needCount As %String = "true") As %String
{
	s result=""
	K CONSUMABLE
	s id=""
	f  s id=$o(^DHCBPArrangeConsumable(0,"Arrange",arrangeId,id))  q:id=""  d
	.s ifAbandon=$lg(^DHCBPArrangeConsumable(id),6)
	.q:ifAbandon="Y"
	.s consumableId=$lg(^DHCBPArrangeConsumable(id),2)
	.q:(consumableId="")!(consumableId=0)
	.s consumableDesc=$lg($g(^DHCBPC("Consumable",+consumableId)),2)
	.s amount=$lg(^DHCBPArrangeConsumable(id),4)
	.s CONSUMABLE("Count",consumableId)=$g(CONSUMABLE("Count",consumableId))+amount
	.s CONSUMABLE("Desc",consumableId)=consumableDesc
	s result=""
	if (needCount="true")
	{
	  s consumableId=""
	  f  s consumableId=$o(CONSUMABLE("Desc",consumableId)) q:consumableId=""  d
	  .i result="" s result=CONSUMABLE("Desc",consumableId)_"("_CONSUMABLE("Count",consumableId)_")"
	  .e  s result=result_","_CONSUMABLE("Desc",consumableId)_"("_CONSUMABLE("Count",consumableId)_")"
	}
	else
	{
	  s consumableId=""
	  f  s consumableId=$o(CONSUMABLE("Desc",consumableId)) q:consumableId=""  d
	  .i result="" s result=CONSUMABLE("Desc",consumableId)
	  .e  s result=result_","_CONSUMABLE("Desc",consumableId)
	}
	q result
}

// w ##class(web.DHCBPArrange).EditBPArrange("")

/// Creator: ZT
/// CreatDate: 2014-10-30
/// Description: 编辑安排表(主要用于临时添加透析安排，修改透析安排，以及在床位图上修改透析安排)
/// Table：DHC_BP_Arrange
/// Input：要添加的arrange数据
/// Return：添加的或修改的DHC_BP_Arrange 表id
ClassMethod EditBPArrange(arrangePara As %String, consumableBusinessPara As %String) As %String
{
	s arrangeId=$p(arrangePara,$c(3),1)
	s registerId=$p(arrangePara,$c(3),2)
	q:registerId="" -1
	s schemeId=$p(arrangePara,$c(3),4)
	q:schemeId="" "未制定透析方案不能进行透析安排"
	s arrangeDate=$p(arrangePara,$c(3),5)
	s arrangeDateH=##class(web.DHCClinicCom).ConvertToDateH(arrangeDate)
	s arrangeTime=$p(arrangePara,$c(3),6)
	s arrangeTimeH=##class(web.DHCClinicCom).ConvertToTimeH(arrangeTime)
	s daySeqCode=$p(arrangePara,$c(3),7)
	s existArrangeId=""
	s bedId=""
	&sql(select BPA_RowId,BPA_BPCBed_Dr into :existArrangeId,:bedId from DHC_BP_Arrange where BPA_BPScheme_Dr=:schemeId and BPA_Date=:arrangeDateH and BPA_DaySeqNo=:daySeqCode and BPA_Status<>'D')
	s bedDesc=$lg($g(^DHCBPC("Bed",+bedId)),2)
	b ;1
	i existArrangeId'=""  d
	.i bedDesc'="" d
	..s result="该病人 "_arrangeDate_"在"_bedDesc_" 已安排透析!"
	.e  d
	..s result="该病人 "_arrangeDate_" 已安排透析!"
	q:(arrangeId'=existArrangeId)&(existArrangeId'="") result
	;q:(arrangeId'=existArrangeId)&(arrangeId'="") result
	;q:(arrangeId="")&(existArrangeId'="") result
	i (arrangeId="") s arrange=##class(User.DHCBPArrange).%New()
    e  s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)
	i (registerId'="") s arrange.BPABPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId(registerId)
    i schemeId'="" s arrange.BPABPSchemeDr=##class(User.DHCBPScheme).%OpenId(schemeId)
	s arrange.BPADate=arrangeDateH
	s arrange.BPATime=arrangeTimeH
	s arrange.BPADaySeqNo=daySeqCode
	i arrangeId="" d
	.s arrange.BPAArrangeType="T"
	e  d
	.s arrange.BPAArrangeType=$p(arrangePara,$c(3),9)
	s status=$p(arrangePara,$c(3),10)
	s arrange.BPAStatus=status
	i status="A" d
	.s arrange.BPABPCBedDr=""
	s modeId=$p(arrangePara,$c(3),27)
	i modeId'="" s arrange.BPABPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(modeId)
	i arrange.BPABPCBPModeDr.BPCBPMIsSpecial="Y" d
	.;s arrange.BPAStatus="R"
	.s bedId=$p(arrangePara,$c(3),8)
	.s bedDr=""
	.i bedId'="" s bedDr=##class(User.DHCBPCBed).%OpenId(bedId)
	.s arrange.BPABPCBedDr=bedDr
    s secondModeId=$p(arrangePara,$c(3),28)
    i secondModeId'="" s arrange.BPASecondBPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(secondModeId)
	e  s arrange.BPASecondBPCBPModeDr=""
	s StartSystolicPressure=$p(arrangePara,$c(3),65)
    i StartSystolicPressure'="" s arrange.BPAStartSystolicPressure=StartSystolicPressure
    s StartDiastolicPressure=$p(arrangePara,$c(3),63)
    i StartDiastolicPressure'="" s arrange.BPAStartDiastolicPressure=StartDiastolicPressure
    s StartHeartRate=$p(arrangePara,$c(3),67)
    i StartHeartRate'="" s arrange.BPAStartHeartRate=StartHeartRate
    s IntakeAmount=$p(arrangePara,$c(3),13)
    i IntakeAmount'="" s arrange.BPAIntakeAmount=IntakeAmount
    s PlanDewaterAmount=$p(arrangePara,$c(3),14)
    i PlanDewaterAmount'="" s arrange.BPAPlanDewaterAmount=PlanDewaterAmount 
	s arrange.BPACreateUserDr=$p(arrangePara,$c(3),89)
	s arrange.BPACreateDate=+$h
	s arrange.BPACreateTime=$p($h,",",2)
	d arrange.%Save()
    s rowId=arrange.%Id()
    q:consumableBusinessPara="" rowId
	s result=..SaveArrangeConsumableList(rowId,consumableBusinessPara)
    i +result'=1 TROLLBACK  q "保存透析耗材错误"
	q rowId
}

// w ##class(web.DHCBPArrange).SaveDocStartDiaInfo("")

/// Creator: ZT
/// CreatDate: 2014-10-30
/// Description: 保存医生透析记录单透析前填写的内容(保存和复核)
/// Table：DHC_BP_Arrange,DHC_BP_ArrangeAnticoagulantDrug,DHC_BP_ArrangeConsumable,DHC_BP_ArrangeEquipRunPara
/// Input：存放在安排表中的内容(arrangePara),透析器材(arrangeConsumablePara),设备运行参数(arrangeEquipRunParaString),抗凝方式(arrangeAnticoagulantDrugString)
/// Return：保存正确时返回 "1",错误提示相关内容
ClassMethod SaveDocStartArrangeInfo(arrangePara, consumableBusinessPara, anticoagulantDrugBusinessPara, equipRunParaBusinessPara) As %String
{
	s arrangeId=$p(arrangePara,$c(3),1)
	q:arrangeId=""
	s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)
	s oriStatus=arrange.BPAStatus
	i (oriStatus="A")!(oriStatus="R") d
	.s arrange.BPAStatus=$p(arrangePara,$c(3),10)
    s arrange.BPAStartWeight=$p(arrangePara,$c(3),11)
    s arrange.BPASubtractiveWeight=$p(arrangePara,$c(3),12)
    s arrange.BPAIntakeAmount=$p(arrangePara,$c(3),13)
    s arrange.BPAPlanDewaterAmount=$p(arrangePara,$c(3),14)
    s arrange.BPADewaterAmount=$p(arrangePara,$c(3),16)
    s arrange.BPAFoodIntakeAmount=$p(arrangePara,$c(3),17)
    s arrange.BPAResidualBloodAmount=$p(arrangePara,$c(3),18)
    s arrange.BPAPlanTherapyDuration=$p(arrangePara,$c(3),81)
    s vascularAccessSchemeId=$p(arrangePara,$c(3),25)
    i vascularAccessSchemeId'="" s arrange.BPAVascularAccessDr=##class(User.DHCBPCVascularAccess).%OpenId(vascularAccessSchemeId)
    s equipId=$p(arrangePara,$c(3),26)
    i equipId'="" s arrange.BPABPCEquipDr=##class(User.DHCBPCEquip).%OpenId(equipId)
    s modeId=$p(arrangePara,$c(3),27)
    i modeId'="" s arrange.BPABPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(modeId)
    s secondModeId=$p(arrangePara,$c(3),28)
    s arrange.BPASecondBPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(secondModeId)
    s thirdModeId=$p(arrangePara,$c(3),29)
    s arrange.BPAThirdBPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(thirdModeId)
    s consumableId=$p(arrangePara,$c(3),30)
    s arrange.BPABPCConsumableDr=##class(User.DHCBPCConsumable).%OpenId(consumableId)
    s secondConsumableId=$p(arrangePara,$c(3),31)
    s arrange.BPASecondBPCConsumableDr=##class(User.DHCBPCConsumable).%OpenId(secondConsumableId)
    s thirdConsumableId=$p(arrangePara,$c(3),32)
    s arrange.BPAThirdBPCConsumableDr=##class(User.DHCBPCConsumable).%OpenId(thirdConsumableId)
    s equipRunModeId=$p(arrangePara,$c(3),33)
    i equipRunModeId'="" s arrange.BPABPCEquipRunModeDr=equipRunModeId
    s arrange.BPAOrdered=$p(arrangePara,$c(3),34)
    s arrange.BPACt=$p(arrangePara,$c(3),35)
    s arrange.BPAAct=$p(arrangePara,$c(3),36)
    s arrange.BPAOralHematin=$p(arrangePara,$c(3),37)
    s arrange.BPAInjectHematin=$p(arrangePara,$c(3),38)
    s arrange.BPAHeparin=$p(arrangePara,$c(3),39)
    s arrange.BPANa=$p(arrangePara,$c(3),43)
    s arrange.BPAK=$p(arrangePara,$c(3),44)
    s arrange.BPACa2=$p(arrangePara,$c(3),45)
    s arrange.BPAHCO3=$p(arrangePara,$c(3),46)
    s arrange.BPAFilterReplaceMode=$p(arrangePara,$c(3),47)
    //s arrange.BPAFilterReplaceAmount=$p(arrangePara,$c(3),48) 
    s arrange.BPAPlanFilterReplaceAmount=$p(arrangePara,$c(3),82)
    s arrange.BPABPMeasurePart=$p(arrangePara,$c(3),60)
    s arrange.BPATemperature=$p(arrangePara,$c(3),61)
    //充水量 
    s arrange.BPAReplenishWaterAmount=$p(arrangePara,$c(3),62)
     // 透析前舒张压
    s arrange.BPAStartDiastolicPressure=$p(arrangePara,$c(3),63)   
    // 透析前收缩压
    s arrange.BPAStartSystolicPressure=$p(arrangePara,$c(3),65)   
    /// 透析前心率
    s arrange.BPAStartHeartRate=$p(arrangePara,$c(3),67)
    /// 透析前症状
    s arrange.BPAStartSymptom=$p(arrangePara,$c(3),69)   
    /// 尿量
    s arrange.BPAUrineVolume=$p(arrangePara,$c(3),71)
    /// 临床评估备注
    s arrange.BPAClinicalEvaluationNote=$p(arrangePara,$c(3),72)
    /// 单纯超滤量
    s arrange.BPAIsolatedUltVolume=$p(arrangePara,$c(3),73)
    /// 血流速
    s arrange.BPABFR=$p(arrangePara,$c(3),74)
    /// 血流速备注
    s arrange.BPABFRNote=$p(arrangePara,$c(3),75)
    //血管通路码表指针
    s vascularAccessId=$p(arrangePara,$c(3),76)
    i vascularAccessId'="" s arrange.BPABPCVADr=##class(User.DHCBPCVascularAccess).%OpenId(vascularAccessId)
    //血管通路建立部位指针
    s arrange.BPAVABodySiteDr=$p(arrangePara,$c(3),77)
    //抗凝方案指针
    s anticoagulantModeId=$p(arrangePara,$c(3),78)
    i anticoagulantModeId'="" s arrange.BPAAnticoagulantModeDr=##class(User.DHCBPCAnticoagulantMode).%OpenId(anticoagulantModeId)
    s docOperateStatus=$p(arrangePara,$c(3),56)
    s arrange.BPADocOperateStatus=docOperateStatus
    s saveDocDr=""
    i docOperateStatus="C" 
    {
     s arrange.BPACheckDocDr=$p(arrangePara,$c(3),92)
     s updateDate=$p(arrangePara,$c(3),93)
     i updateDate'="" s arrange.BPACheckDate=##class(web.DHCClinicCom).ConvertToDateH(updateDate)
     s updateTime=$p(arrangePara,$c(3),94)
     i updateTime'="" s arrange.BPACheckTime= ##class(web.DHCClinicCom).ConvertToTimeH(updateTime)
     s status=$p(arrangePara,$c(3),10)
     s num=..SaveBPNum(status,arrangeId)
     s saveDocDr=$p(arrangePara,$c(3),92) 
    }
    i docOperateStatus="R"
    {
     s arrange.BPARecheckDocDr=$p(arrangePara,$c(3),95)
     s updateDate=$p(arrangePara,$c(3),96)
     i updateDate'="" s arrange.BPARecheckDate=##class(web.DHCClinicCom).ConvertToDateH(updateDate)
     s updateTime=$p(arrangePara,$c(3),97)
     i updateTime'="" s arrange.BPARecheckTime= ##class(web.DHCClinicCom).ConvertToTimeH(updateTime)
     s saveDocDr=$p(arrangePara,$c(3),95)
    }
    /// 透析前治疗备注
    s arrange.BPADialysisBeforeNote=$p(arrangePara,$c(3),114)
    s result=1    
    s saveStatus=arrange.%Save()
	i +saveStatus=0 s log=##class(web.DHCCLLog).Log("BloodPurificationRecord",arrangeId,"","","透前记录，状态："_docOperateStatus_"，保存是否成功："_saveStatus,$tr(arrangePara,$c(3),"^"),saveDocDr) q "保存数据失败!"
    s rowId=arrange.%Id()
    d arrange.%Close()
    TSTART    
    s result=..SaveArrangeConsumableList(rowId,consumableBusinessPara)
    i +result'=1 TROLLBACK  s log=##class(web.DHCCLLog).Log("consumableBusinessPara",arrangeId,"","","透前耗材，状态："_docOperateStatus_"，保存是否成功："_result,$tr(consumableBusinessPara,$c(3),"^"),saveDocDr) q "保存透析耗材错误"
    TCOMMIT
    TSTART 
    s result=..SaveArrangeAntDrugList(rowId,anticoagulantDrugBusinessPara)
    i +result'=1 TROLLBACK  s log=##class(web.DHCCLLog).Log("anticoagulantDrugBusinessPara",arrangeId,"","","透前抗凝，状态："_docOperateStatus_"，保存是否成功："_result,$tr(anticoagulantDrugBusinessPara,$c(3),"^"),saveDocDr) q "保存抗凝药品错误"
    TCOMMIT
    TSTART
    s result=..SaveArrangeEquipRunParaList(rowId,equipRunParaBusinessPara)
    i +result'=1 TROLLBACK  s log=##class(web.DHCCLLog).Log("equipRunParaBusinessPara",arrangeId,"","","透前设备，状态："_docOperateStatus_"，保存是否成功："_result,$tr(equipRunParaBusinessPara,$c(3),"^"),saveDocDr) q "保存透析设备参数错误"   
    TCOMMIT
    //d ##class(web.DHCBPCom).StartEquipCollect(arrangeId)
    q rowId
}

/// Creator: ZT
/// CreatDate: 2014-10-30
/// Description: 保存透析后医生填写的内容
/// Table：DHC_BP_Arrange
/// Input：arrangePara
/// Return：所保存的arrangeId
ClassMethod SaveDocEndArrangeInfo(arrangePara As %String) As %String
{
	s arrangeId=$p(arrangePara,$c(3),1)
	q:arrangeId=""
	s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)		
	//透后体重
	s arrange.BPAEndWeight=$p(arrangePara,$c(3),15)	
    // 透析后舒张压
    s arrange.BPAEndDiastolicPressure=$p(arrangePara,$c(3),64) 
    /// 透析后收缩压
    s arrange.BPAEndSystolicPressure=$p(arrangePara,$c(3),66)   
    /// 透析后心率
    s arrange.BPAEndHeartRate=$p(arrangePara,$c(3),68)    
    //透析方案调整
    s arrange.BPABPSchemeAdjustment=$p(arrangePara,$c(3),80)   
    //病情处理记录
    s arrange.BPADiseaseTreatment=$p(arrangePara,$c(3),85)    
    s arrange.BPAEndUpdateDocDr=$p(arrangePara,$c(3),101) 
    s updateDate=$p(arrangePara,$c(3),102)
    i updateDate'="" s arrange.BPADocEndUpdateDate=##class(web.DHCClinicCom).ConvertToDateH(updateDate)
    s updateTime=$p(arrangePara,$c(3),103)
    i updateTime'="" s arrange.BPADocEndUpdateTime=##class(web.DHCClinicCom).ConvertToTimeH(updateTime)
    s saveStatus=arrange.%Save()
	q:(+saveStatus=0) "保存数据失败!"	
    s result=arrange.%Id()
    d arrange.%Close()
    d ##class(web.DHCBPCom).StopEquipCollect(arrangeId)
    q result
}

// w ##class(web.DHCBPArrange).SaveNurseArrangeInfo("")

// w ##class(web.DHCBPArrange).SaveNurseArrangeInfo("90"_$c(3)_"23"_$c(3)_"343"_$c(3)_"40"_$c(3)_"2020-07-09"_$c(3)_"16:56"_$c(3)_"A"_$c(3)_"3"_$c(3)_"T"_$c(3)_"F"_$c(3)_"67"_$c(3)_"1"_$c(3)_"0"_$c(3)_"0"_$c(3)_"69"_$c(3)_"0"_$c(3)_"0"_$c(3)_"0"_$c(3)_"121"_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_"1"_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_"0"_$c(3)_"0"_$c(3)_"0"_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_"195"_$c(3)_"3"_$c(3)_"1.25"_$c(3)_"0"_$c(3)_"前稀释"_$c(3)_"15"_$c(3)_"正常"_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_"C"_$c(3)_$c(3)_$c(3)_$c(3)_"U"_$c(3)_"35.5"_$c(3)_"0"_$c(3)_"105"_$c(3)_"106"_$c(3)_"155"_$c(3)_"150"_$c(3)_"85"_$c(3)_"80"_$c(3)_$c(3)_$c(3)_"1500"_$c(3)_$c(3)_"0"_$c(3)_"210"_$c(3)_$c(3)_"1"_$c(3)_"4"_$c(3)_"2"_$c(3)_"12"_$c(3)_"透析方案调整"_$c(3)_"120"_$c(3)_"20"_$c(3)_"0"_$c(3)_"正常"_$c(3)_"病情处理记录"_$c(3)_"透析正常"_$c(3)_"2020-07-09"_$c(3)_"0:00"_$c(3)_"12811"_$c(3)_"2020/7/9"_$c(3)_"16:53"_$c(3)_"560"_$c(3)_"2020/7/9"_$c(3)_"16:57"_$c(3)_$c(3)_"0001/1/1"_$c(3)_"0:00"_$c(3)_$c(3)_$c(3)_$c(3)_"560"_$c(3)_"2020/7/9"_$c(3)_"17:02"_$c(3)_$c(3)_$c(3)_$c(3)_"12828"_$c(3)_"2020/7/9"_$c(3)_"17:15"_$c(3)_"194"_$c(3)_"12828"_$c(3)_$c(3)_$c(3)_"信息备注","496$15$M$1&498$15$R$1")

/// Creator: ZT
/// CreatDate: 2014-10-30
/// Description: 保存透析后护士填写的内容
/// Table：DHC_BP_Arrange，DHC_BP_ArrangeConsumable
/// Input：arrangePara，arrangeConsumablePara 拼接的字符串
/// Return：所保存的arrangeId
ClassMethod SaveNurseArrangeInfo(arrangePara, consumableBusinessPara) As %String
{
	
    TSTART
	s arrangeId=$p(arrangePara,$c(3),1)
	q:arrangeId=""
	s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)	
	s arrange.BPAStatus=$p(arrangePara,$c(3),10)
	s arrange.BPATherapyDuration=$p(arrangePara,$c(3),19)
	s arrange.BPAFilterReplaceAmount=$p(arrangePara,$c(3),48)
	s arrange.BPAAVFEffect=$p(arrangePara,$c(3),52)
	s arrange.BPADindle=$p(arrangePara,$c(3),53)
	s arrange.BPAJoinDirection=$p(arrangePara,$c(3),54)
	s arrange.BPAOutletEffect=$p(arrangePara,$c(3),55)
	s arrange.BPAFlushPipeNurseCtcpDr=$p(arrangePara,$c(3),20)
    s arrange.BPAPunctureNurseCtcpDr=$p(arrangePara,$c(3),21)
    s arrange.BPACirculatingNurseCtcpDr=$p(arrangePara,$c(3),22)
    s arrange.BPAJoinPipeNurseCtcpDr=$p(arrangePara,$c(3),23)
    s arrange.BPACloseNurseCtcpDr=$p(arrangePara,$c(3),24)
    s arrange.BPAEquipRunEffect=$p(arrangePara,$c(3),49)
    s arrange.BPAGrume=$p(arrangePara,$c(3),50)
    s arrange.BPAPipeGrume=$p(arrangePara,$c(3),51)
    /// 透析后症状
    s arrange.BPAEndSymptom=$p(arrangePara,$c(3),70)
    //回输盐水总量
    s arrange.BPAReturnSalineAmount=$p(arrangePara,$c(3),79)
    s arrange.BPADFR=$p(arrangePara,$c(3),83) 
    s arrange.BPAVascularAccessStatus=$p(arrangePara,$c(3),84)
    s arrange.BPANote=$p(arrangePara,$c(3),86)
    s endDate=$p(arrangePara,$c(3),87)
    i endDate'="" s arrange.BPAEndDate=##class(DHCANOPCom).ConvertToDateH(endDate)
    s endTime=$p(arrangePara,$c(3),88)
    i endTime'="" s arrange.BPAEndTime=##class(DHCANOPCom).ConvertToTimeH(endTime)
    s arrange.BPAEndOperationNurseDr=$p(arrangePara,$c(3),107)    
    s updateDate=$p(arrangePara,$c(3),108)
    i updateDate'="" s arrange.BPAEndOperationDate=##class(DHCANOPCom).ConvertToDateH(updateDate)
    s updateTime=$p(arrangePara,$c(3),109)
    i updateTime'="" s arrange.BPAEndOperationTime= ##class(DHCANOPCom).ConvertToTimeH(updateTime)
    s saveStatus=arrange.%Save()
	i +saveStatus=0 TROLLBACK  q "保存数据失败!"
    s rowId=arrange.%Id()
    d arrange.%Close()
    TCOMMIT
    TSTART
    s result=..SaveArrangeConsumableList(rowId,consumableBusinessPara)   
    i +result'="1" TROLLBACK  q "保存透析耗材错误"
    TCOMMIT
    TSTART
    s userId=$p($g(arrangePara),$c(3),107)
    i userId="" TROLLBACK  q "操作用户不存在"
    s locId=$p($g(arrangePara),$c(3),110)
    ;s ctcpId=$p(arrangePara,$c(3),24) //?107
    ;s userId=$o(^SSU("SSUSR",0,"CTPCP",1,+ctcpId,""))
    ;s ^tmpBPStock(locId)=arrangeId_"/"_userId
    s stockResult= ##class(web.DHCBPArrangeStock).ConsumeStock(locId,arrangeId,userId) //?科室?用户
    i stockResult'=0 TROLLBACK  q "保存透析耗材错误:"_stockResult
    TCOMMIT
    s visService=##Class(web.DHCBPCom).GetIsVisServiceByLocId(locId) //是否大屏显示更新
    i (visService){
	    s bpaBPCBedDr=$lg($g(^DHCBPArrange(arrangeId)),7)
		s bpcBedGroupDr=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),3)
		//i bpcBedGroupDr<8 q rowId //临时过渡，旧病房床位组过滤, 大屏不处理
    	s RisResult= ##class(web.DHCBPVISService).RisUpdatePatStatus(arrangeId) //大屏完成显示,通过web.DHCBPVISServiceInferface调用叫号组webService接口方法
    	i RisResult'=0 q "大屏显示无法完成更新:"_RisResult   		
    }
    q rowId
}

/// Creator: ZT
/// CreatDate: 2014-10-30
/// Description: 保存透析器材列表
/// Table：DHC_BP_ArrangeConsumable
/// Input：arrangeId，arrangeConsumablePara
/// Return：正确 "1" 错误SQLCODE
ClassMethod SaveArrangeConsumableList(arrangeId, paraStr) As %String
{
	//s ^TMPzt("ArrangeConsumable")=arrangeId_"%"_paraStr
	//s arrangeId=$p(^TMPzt("ArrangeConsumable"),"%",1)
	//s paraStr=$p(^TMPzt("ArrangeConsumable"),"%",2)
	b ;consumable3
	q:+arrangeId=0 0
	s curDate=+$h
	s curTime=$p($h,",",2)
	w arrangeId,!
	&sql(update DHC_BP_ArrangeConsumable set BPAC_IfAbandon='Y' where BPAC_BPArrange_Dr=:arrangeId) //筛选一下
	;&sql(delete from DHC_BP_ArrangeEquipRunPara where BPSERP_Parref=:arrangeId)
	i (SQLCODE'=0)&(SQLCODE'=100)  q SQLCODE
	w SQLCODE,!
    s SQLCODE=0
    s outerSpliter="&",innerSpliter="$"
	f i=1:1:$l(paraStr,outerSpliter) q:(SQLCODE'=0)&(SQLCODE'=100)  d
	.s singleParaStr=$p(paraStr,outerSpliter,i)
	.s id=$p(singleParaStr,innerSpliter,1)
	.s consumableId=$p(singleParaStr,innerSpliter,2)
	.q:(consumableId="")!(consumableId=0)
	.s type=$p(singleParaStr,innerSpliter,3)
	.s amount=$p(singleParaStr,innerSpliter,4)
	.i id="" d
	..&sql(insert into DHC_BP_ArrangeConsumable (BPAC_BPArrange_Dr,BPAC_BPCConsumable_Dr,BPAC_Type,BPAC_Amount,BPAC_IfAbandon,BPAC_OperationDate,BPAC_OperationTime) values(:arrangeId,:consumableId,:type,:amount,'N',:curDate,:curTime))
    .e  d
    ..&sql(update DHC_BP_ArrangeConsumable set BPAC_BPArrange_Dr=:arrangeId,BPAC_BPCConsumable_Dr=:consumableId,BPAC_Type=:type,BPAC_Amount=:amount,BPAC_IfAbandon='N',BPAC_OperationDate=:curDate,BPAC_OperationTime=:curTime where BPAC_RowId=:id)
    i (SQLCODE'=0)&(SQLCODE'=100) q SQLCODE  
	q 1
}

/// Creator: ZT
/// CreatDate: 2014-10-30
/// Description: 获取透析器材列表
/// Table：DHC_BP_ArrangeConsumable
/// Input：arrangeId
/// Return：透析器材列表
Query GetArrangeConsumableList(arrangeId As %String) As %SQLQuery(CONTAINID = 1)
{
	 SELECT 
	 BPAC_RowId As Id,
	 BPAC_BPCConsumable_Dr As ConsumableId,
	 BPAC_Type As Type,
	 BPAC_Amount As Amount from DHC_BP_ArrangeConsumable where BPAC_BPArrange_Dr=:arrangeId and (BPAC_IfAbandon='N' or BPAC_IfAbandon is null)
}

// w ##class(web.DHCBPArrange).SaveArrangeEquipRunParaList("","")

/// Creator: ZT
/// CreatDate: 2014-10-30
/// Description: 保存设备运行参数列表
/// Table：DHC_BP_ArrangeEquipRunPara
/// Input：arrangeEquipRunPara
/// Return：正确 "1" 错误SQLCODE
ClassMethod SaveArrangeEquipRunParaList(arrangeId, paraStr) As %String
{
	//s ^TMPzt("ArrangeEquipRunPara")=arrangeId_"%"_paraStr
	//s arrangeId=$p(^TMPzt("ArrangeEquipRunPara"),"%",1)
	//s paraStr=$p(^TMPzt("ArrangeEquipRunPara"),"%",2)
	q:arrangeId="0" 0
	s curDate=+$h
	s curTime=$p($h,",",2)
	&sql(update DHC_BP_ArrangeEquipRunPara set BPAERP_IfAbandon='Y' where BPAERP_Parref=:arrangeId)
	;&sql(delete from DHC_BP_ArrangeEquipRunPara where BPSERP_Parref=:arrangeId)
	i (SQLCODE'=0)&(SQLCODE'=100) q SQLCODE	
    s SQLCODE=0
    s outerSpliter="&",innerSpliter="$"
	f i=1:1:$l(paraStr,outerSpliter) q:(SQLCODE'=0)&(SQLCODE'=100)  d
	.s singleParaStr=$p(paraStr,outerSpliter,i)
	.s id=$p(singleParaStr,innerSpliter,1)
	.s equipRunParaId=$p(singleParaStr,innerSpliter,2)
	.q:equipRunParaId=""
	.s maxValue=$p(singleParaStr,innerSpliter,3)
	.s minValue=$p(singleParaStr,innerSpliter,4)
	.s value=$p(singleParaStr,innerSpliter,5)
	.i id="" d
	..&sql(insert into DHC_BP_ArrangeEquipRunPara (BPAERP_Parref,BPAERP_BPCERP_Dr,BPAERP_MinValue,BPAERP_MaxValue,BPAERP_Value,BPAERP_IfAbandon,BPAERP_OperationDate,BPAERP_OperationTime) values(:arrangeId,:equipRunParaId,:minValue,:maxValue,:value,'N',:curDate,:curTime))
    .e  d
    ..&sql(update DHC_BP_ArrangeEquipRunPara set BPAERP_Parref=:arrangeId,BPAERP_BPCERP_Dr=:equipRunParaId,BPAERP_MinValue=:minValue,BPAERP_MaxValue=:maxValue,BPAERP_Value=:value,BPAERP_IfAbandon='N',BPAERP_OperationDate=:curDate,BPAERP_OperationTime=:curTime where BPAERP_RowId=:id)
    i (SQLCODE'=0)&(SQLCODE'=100)  q SQLCODE
	q 1
}

/// Creator: ZT
/// CreatDate: 2014-10-30
/// Description: 获取设备运行参数列表
/// Table：DHC_BP_ArrangeEquipRunPara
/// Input：arrangeId
/// Return：设备运行参数列表
Query GetArrangeEquipRunParaList(arrangeId As %String) As %SQLQuery(CONTAINID = 1)
{
	 SELECT 
	 BPAERP_RowId As Id,
	 BPAERP_BPCERP_Dr As EquipRunParaId,
	 BPAERP_MinValue As MinValue,
	 BPAERP_MaxValue As MaxValue,
	 BPAERP_Value As Value from DHC_BP_ArrangeEquipRunPara where BPAERP_Parref=:arrangeId and (BPAERP_IfAbandon='N' or BPAERP_IfAbandon is null)
}

// w ##class(web.DHCBPArrange)InsertArrangeAnticoagulantDrug(642,"")

/// Creator: ZT
/// CreatDate: 2014-10-30
/// Description: 保存抗凝方式列表
/// Table：DHC_BP_ArrangeAnticoagulantDrug
/// Input：arrangeId,AnticoagulantDrugPara
/// Return：正确 "1" 错误SQLCODE
ClassMethod SaveArrangeAntDrugList(arrangeId, paraStr) As %String
{
	//s ^TMPzt("arrangedrug")=paraStr
	//s paraStr=^TMPzt("arrangedrug")
	q:arrangeId="0" 0
	s curDate=+$h
	s curTime=$p($h,",",2)
	&sql(update DHC_BP_ArrangeAnticoagulantDrug set BPAAD_IfAbandon='Y' where BPAAD_BPArrange_Dr=:arrangeId)
	i (SQLCODE'=0)&(SQLCODE'=100) q SQLCODE
    s SQLCODE=0
    s outerSpliter="&",innerSpliter="$"
	f i=1:1:$l(paraStr,outerSpliter) q:(SQLCODE'=0)&(SQLCODE'=100)  d
	.s singleParaStr=$p(paraStr,outerSpliter,i)
	.s id=$p(singleParaStr,innerSpliter,1)
	.s anticoagulantDrugId=$p(singleParaStr,innerSpliter,2)
	.q:anticoagulantDrugId=""
	.s amount=$p(singleParaStr,innerSpliter,3)
	.s firstAmount=$p(singleParaStr,innerSpliter,4)
	.s dose=$p(singleParaStr,innerSpliter,5)
	.s frequency=$p(singleParaStr,innerSpliter,6)
	.s note=$p(singleParaStr,innerSpliter,7)
	.s duration=$p(singleParaStr,innerSpliter,8)
	.s intervalMinute=$p(singleParaStr,innerSpliter,9)
	.s lastReservation=$p(singleParaStr,innerSpliter,11)
	.&sql(insert into DHC_BP_ArrangeAnticoagulantDrug (BPAAD_BPArrange_Dr,BPAAD_BPCAD_Dr,
	 BPAAD_Amount,BPAAD_FirstAmount,BPAAD_Dose,BPAAD_Frequency,BPAAD_Note,BPAAD_IfAbandon,
	 BPAAD_OperationDate,BPAAD_OperationTime,BPAAD_Duration,BPAAD_IntervalMinute,BPAAD_LastReservation)
	 values(:arrangeId,:anticoagulantDrugId,:amount,:firstAmount,:dose,:frequency,:note,'N',:curDate,:curTime,:duration,:intervalMinute,:lastReservation))
	.;i id="" d
	..;&sql(insert into DHC_BP_ArrangeAnticoagulantDrug (BPAAD_BPArrange_Dr,BPAAD_BPCAD_Dr,
	 ;BPAAD_Amount,BPAAD_FirstAmount,BPAAD_Dose,BPAAD_Frequency,BPAAD_Note,BPAAD_IfAbandon,
	 ;BPAAD_OperationDate,BPAAD_OperationTime,BPAAD_Duration,BPAAD_IntervalMinute)
	 ;values(:arrangeId,:anticoagulantDrugId,:amount,:firstAmount,:dose,:frequency,:note,'N',:curDate,:curTime,:duration,:intervalMinute))
    .;e  d
    ..;&sql(update DHC_BP_ArrangeAnticoagulantDrug set BPAAD_BPArrange_Dr=:arrangeId,BPAAD_BPCAD_Dr=:anticoagulantDrugId,
	 ;BPAAD_Amount=:amount,BPAAD_FirstAmount=:firstAmount,BPAAD_Dose=:dose,BPAAD_Frequency=:frequency,
	 ;BPAAD_Note=:note,BPAAD_IfAbandon='N',BPAAD_OperationDate=:curDate,BPAAD_OperationTime=:curTime,
	 ;BPAAD_Duration=:duration,BPAAD_IntervalMinute=:intervalMinute  where BPAAD_RowId=:id)
    i (SQLCODE'=0)&(SQLCODE'=100)  q SQLCODE
	q 1
}

/// Creator: ZT
/// CreatDate: 2014-10-30
/// Description: 获取抗凝方式列表
/// Table：DHC_BP_ArrangeAnticoagulantDrug
/// Input：arrangeId
/// Return：抗凝方式列表
Query GetArrangeAnticoagulantDrugList(arrangeId As %String) As %SQLQuery(CONTAINID = 1)
{
	 SELECT 
	 BPAAD_RowId As Id,
	 BPAAD_BPCAD_Dr As AnticoagulantDrugId,
	 BPAAD_Amount As Amount,
	 BPAAD_FirstAmount As FirstAmount,
	 BPAAD_Dose As Dose,
	 BPAAD_Frequency As Frequency,
	 BPAAD_Note As Note,
	 BPAAD_Duration As Duration,
	 BPAAD_IntervalMinute As IntervalMinute,
	 BPAAD_LastReservation As LastReservation
	 from DHC_BP_ArrangeAnticoagulantDrug where BPAAD_BPArrange_Dr=:arrangeId and (BPAAD_IfAbandon='N' or BPAAD_IfAbandon is null)
}

// w ##class(web.DHCBPArrange).SaveSignature("")

/// Creator: ZT
/// CreatDate: 2014-10-30
/// Description: 保存签名
/// Table：DHC_BP_Arrange
/// Input：arrangeId,签名者医护人员表id，更新日期，时间拼接字符串
/// Return：SQLCODE
ClassMethod SaveSignature(paraStr As %String) As %String
{
	//s ^TMPzt("paraStr")=paraStr
	//s paraStr=^TMPzt("paraStr")
	s arrangeId=$p(paraStr,$c(3),1)
	q:arrangeId="" "无"
	s role=$p(paraStr,$c(3),5)
	s ctcpId=$p(paraStr,$c(3),2)
	s updateDate=$p(paraStr,$c(3),3)
	s updateDate=##class(web.DHCClinicCom).ConvertToDateH(updateDate)
	s updateTime=$p(paraStr,$c(3),4)
	s updateTime=##class(web.DHCClinicCom).ConvertToTimeH(updateTime)
	s res=""
	if (role="StartOperationNurse")
	{
		//s res=##class(web.DHCBPCom).StartEquipCollect(arrangeId)	//采集程序未部署，屏蔽掉 add mfc 20211116	
		//if (res=0)||(res="") 
		//{
		  &sql(update DHC_BP_Arrange set BPA_Status='M',BPA_StartOperationNurse_Dr=:ctcpId,BPA_StartOperationDate=:updateDate,
		  BPA_StartOperationTime=:updateTime where BPA_RowId=:arrangeId
		  )
		//}
		/* i SQLCODE=0 d
		.s ^tmpdebug("go")=res
		.;s res=##class(web.DHCBPCom).StartEquipCollect(arrangeId)
		.s res=0
		.s ^tmpdebug("res")=res
		*/
	}
	if (role="EditStartOperationDT")
	{

	  &sql(update DHC_BP_Arrange set BPA_StartOperationDate=:updateDate,
		BPA_StartOperationTime=:updateTime where BPA_RowId=:arrangeId
		)

	}
	if (role="CheckNurse")
	{
	  &sql(update DHC_BP_Arrange set BPA_CheckNurse_Dr=:ctcpId,BPA_NurseCheckDate=:updateDate,
		BPA_NurseCheckTime=:updateTime where BPA_RowId=:arrangeId
		)	
	}
	if (role="WardRoundDoctor")
	{
	&sql(update DHC_BP_Arrange set BPA_WardRoundDoc_Dr=:ctcpId,BPA_WardRoundDate=:updateDate,
		BPA_WardRoundTime=:updateTime where BPA_RowId=:arrangeId
		)	
	}
	i res="" s res=SQLCODE
	s bpprId=$lg($g(^DHCBPArrange(arrangeId)),1)
	s bpprPatLocationDr=$lg($g(^DHCBPPatRegister(bpprId)),34) //患者所属病区ID(护士科室ID)
	s visService=##Class(web.DHCBPCom).GetIsVisServiceByLocId(bpprPatLocationDr) //是否大屏显示更新
    i (visService){
	    s bpaBPCBedDr=$lg($g(^DHCBPArrange(arrangeId)),7)
		s bpcBedGroupDr=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),3)
		//i bpcBedGroupDr<8 q res //临时过渡，旧病房床位组过滤, 大屏不处理
    	s RisResult= ##class(web.DHCBPVISService).RisUpdatePatStatus(arrangeId) //大屏显示状态更新,通过web.DHCBPVISServiceInferface调用叫号组webService接口方法
    	i (RisResult'=0)&&(res=0) q "大屏无法显示状态更新:"_RisResult     		
    }
	q res
}

// w ##class(web.DHCBPArrange).SaveBPBedArrange("")

/// Creator: ZT
/// CreatDate: 2014-11-14
/// Description: 安排床位信息
/// Table：DHC_BP_Arrange
/// Input：要修改的关于床位安排信息
/// Return：修改的DHC_BP_Arrange 表id
ClassMethod SaveBPBedArrange(bedArrangePara As %String) As %String
{
	//s ^TMPzt("SaveBPBedArrange")=bedArrangePara
	//s bedArrangePara=^TMPzt("SaveBPBedArrange")
	q:(bedArrangePara="") "参数为空"
	s arrangeId=$p(bedArrangePara,$c(3),1)
	q:arrangeId="" "安排表id为空"
    s result="",arrange=""
    s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)
    s registerId=$p(bedArrangePara,$c(3),2)
    q:registerId="" "登记表id为空"	    
    i (registerId'="") s arrange.BPABPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId(registerId)
    s arrange.BPAAdmDr=$p(bedArrangePara,$c(3),3)
    s arrangeDate=$p(bedArrangePara,$c(3),5)    
    s daySeqNo=$p(bedArrangePara,$c(3),7)
    i $p(bedArrangePara,$c(3),7)="上午"  s daySeqNo="A"
    i $p(bedArrangePara,$c(3),7)="下午"  s daySeqNo="P"
    i $p(bedArrangePara,$c(3),7)="晚上"  s daySeqNo="E"
    s bedId=$p(bedArrangePara,$c(3),8)
    s bedIsArranged=1
    s status=$p(bedArrangePara,$c(3),10)
    i bedId'="" d
    .s bedIsArranged=..GetBedIsArranged(arrangeDate,daySeqNo,bedId)
    e  d 
    .s arrange.BPAStatus="A"  
    .s arrange.BPABPCBedDr=""  
    i 'bedIsArranged d
    .s arrange.BPABPCBedDr=##class(User.DHCBPCBed).%OpenId(bedId)
    .s bpBedEquipDr=$o(^DHCBPBedEquip(0,"Bed",+bedId,"")) //净化设备
    .s bpEquipDr=$lg($g(^DHCBPBedEquip(+bpBedEquipDr)),2)
    .s arrange.BPABPCEquipDr=##class(User.DHCBPCEquip).%OpenId(bpEquipDr)    
    .s arrange.BPAStatus=status   
    d arrange.%Save()
    s result=arrange.%Id()
    q result
}

// d ##class(web.DHCBPArrange).GetBedIsArranged("")

/// Creator: ZT
/// CreatDate: 2014-11-14
/// Description: 判断该床位是否已有人安排
/// Table：DHC_BP_Arrange
/// Input：安排时间，安排时段，床位id
/// Return：是否安排
ClassMethod GetBedIsArranged(curDate, daySeqNo, bedId) As %String
{
	s curDate=##class(DHCANOPCom).ConvertToDateH(curDate)
	s isArranged=0
	s bpaId=""
	f  s bpaId=$o(^DHCBPArrange(0,"Date",curDate,bpaId)) q:bpaId=""  d
	.s bpprId=$lg(^DHCBPArrange(bpaId),1)
	.s bpprStatus=$lg(^DHCBPPatRegister(bpprId),14)
	.q:bpprStatus="D" 
	.s bpaDaySeqNo=$lg(^DHCBPArrange(bpaId),6)
	.s bpaBPCBedDr=$lg(^DHCBPArrange(bpaId),7)
	.s bpaStatus=$lg(^DHCBPArrange(bpaId),9)
	.i (bpaBPCBedDr=bedId)&(bpaStatus'="D")&(bpaDaySeqNo=daySeqNo) s isArranged=1
	q isArranged
}

ClassMethod GetPatientIsArranged(curDate, registerId) As %String
{
	s curDate=##class(DHCANOPCom).ConvertToDateH(curDate)
	s isArranged=0
	s bpaId=""
	f  s bpaId=$o(^DHCBPArrange(0,"Date",curDate,bpaId)) q:bpaId=""  d
	.s bpaRegisterDr=$lg(^DHCBPArrange(bpaId),1)
	.s bpaStatus=$lg(^DHCBPArrange(bpaId),9)
	.i (bpaRegisterDr=registerId)&(bpaStatus'="D") s isArranged=1
	q isArranged
}

/// Creator: ZT
/// CreatDate: 2014-09-14
/// Description: 保存透析状态
/// Table：DHC_BP_Arrange,DHC_BP_PatRegister
/// Input：安排表id,透析安排表状态status
/// Return：安排表id
ClassMethod SaveStatus(arrangeId As %String, status As %String) As %String
{
	 q:arrangeId="" "id为空"
	 s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)
	 q:'$d(arrange)
	 ;q:(arrange.BPAStatus'="A")&&(status="D") "不能拒绝已安排的手术"
	 s arrange.BPAStatus=status
	 s res=..SaveBPNum(status,arrangeId)
	 d arrange.%Save()
	 s result=arrange.%Id()
     q result
}

/// Creator: ZT
/// CreatDate: 2014-11-14
/// Description: 修改透析次数
/// Table：DHC_BP_PatRegister
/// Input：透析安排表状态status,登记表Id
/// Return：count
ClassMethod SaveBPNum(status, arrangeId) As %String
{
  q:arrangeId="" "无安排表id"
  s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)
  q:'$d(arrange)
  s registerId=arrange.BPABPPatRegisterDr.%Id()
  q:registerId="" "无登记表id"
  s docOperateStatus=arrange.BPADocOperateStatus
  s bpNum=arrange.BPABPNum
  s arrangeDate=arrange.BPADate
  s arrangedNum=0
  &sql(select count(*) into:arrangedNum from dhc_bp_arrange where BPA_BPPatRegister_Dr=:registerId and  BPA_Date<:arrangeDate
   and BPA_Status!='A' and BPA_Status!='D'
   and BPA_DocOperateStatus is not null and BPA_BPNum!=0 and  BPA_BPNum is not null)
  if (status="R")	
  {
	if ((docOperateStatus="C")&&((bpNum="")!(bpNum=0)))
	{
	  s bpNum=arrangedNum+1 
	}
  }
  if (status="D")
  {
	  s bpNum=bpNum-1
  }
  s arrange.BPABPNum=bpNum
  q bpNum
}

/// w ##class(web.DHCBPArrange).GetBPNum(31074)
/// 返回透析次数，安排arrangeId和登记registerId不能都为空，modeType为获取透析方式的类型(常规、特殊、全部)
/// add mfc
ClassMethod GetBPNum(arrangeId As %String = "", registerId As %String = "", modeType As %String = "") As %String
{
	s bpprBPNum=0,bpaBPNum=0,num=0,bpcBPModeId="",bpprId="",bpaDate=""
	i arrangeId'="" d
	.&sql(select BPA_BPNum,BPA_BPPatRegister_Dr,BPA_Date,BPA_BPCBPMode_Dr into:bpaBPNum,:bpprId,:bpaDate,:bpcBPModeId from dhc_bp_arrange where bpa_rowid=:arrangeId and BPA_Status<>'D')
	i registerId'="" s bpprId=registerId
	i (modeType="")&&(bpcBPModeId'="") s modeType=$lg($g(^DHCBPC("BloodPurificationMode",bpcBPModeId)),3)
	q:bpprId="" -1
	s bpaId=""	
	f  s bpaId=$o(^DHCBPArrange(0,"PatRegister",bpprId,bpaId)) q:bpaId=""  d
	.s bpaStatus=$lg(^DHCBPArrange(bpaId),9)
	.;w bpaId_"/状态:"_bpaStatus,!	
	.q:(bpaStatus'="F")
	.s date=$lg(^DHCBPArrange(bpaId),4)
	.q:(bpaDate'="")&&(date>bpaDate)
	.;s bpaDocOperateStatus=$lg(^DHCBPArrange(bpaId),55)
	.;w bpaId_"/医生操作状态:"_bpaDocOperateStatus,!
	.;q:bpaDocOperateStatus=""	
	.s bpaBPCBPModeDr=$lg(^DHCBPArrange(bpaId),26)
	.s bpaBPCBPModeType=$lg($g(^DHCBPC("BloodPurificationMode",+bpaBPCBPModeDr)),3)
	.;w bpaId_"/透析方式:"_bpaBPCBPModeDr_"/"_bpaBPCBPModeType,!
	.q:(modeType'="")&&(bpaBPCBPModeType'=modeType)
	.;w bpaId,!
	.i modeType'="Y" d //特殊透析去除登记次数
	..s bpprBPNum=$lg(^DHCBPPatRegister(bpprId),18)
	.s num=num+1
	s num=num+bpprBPNum	
	q num
}

/*
ClassMethod GetBPNum(arrangeId) As %String
{
	s bpaBPNum=0,num=0
	&sql(select BPA_BPNum,BPA_BPPatRegister_Dr,BPA_BPCBPMode_Dr into:bpaBPNum,:bpprId,:bpcbpmodeId from dhc_bp_arrange where bpa_rowid=:arrangeId and BPA_Status<>'D')
	q:bpprId="" -1			
	s bpprBPCount=$lg(^DHCBPPatRegister(bpprId),18)
	s num=bpprBPCount+bpaBPNum
	q num
}*/
/// Creator: ZT
/// CreatDate: 2014-11-28
/// Description: 用于补录数据时添加的数据不全的安排
/// Table：DHC_BP_Arrange
/// Input：要添加的透析安排相关数据
/// Return：rowId
ClassMethod InsertMissingArrange(arrangePara) As %String
{
	s registerId=$p(arrangePara,$c(3),1)
	q:registerId="" "无透析登记id"
	s schemeId=$p(arrangePara,$c(3),2)
	s arrangeDate=$p(arrangePara,$c(3),3)
	s arrangeDateH=##class(web.DHCClinicCom).ConvertToDateH(arrangeDate)
	s arrangeTime=$p(arrangePara,$c(3),4)
	s arrangeTimeH=##class(web.DHCClinicCom).ConvertToDateH(arrangeTime)
	s daySeqCode=$p(arrangePara,$c(3),5)
	s existArrangeId=""
	s bedId=""
	&sql(select BPA_RowId,BPA_BPCBed_Dr into :existArrangeId,:bedId from DHC_BP_Arrange where BPA_BPPatRegister_Dr=:registerId and BPA_Date=:arrangeDateH and BPA_DaySeqNo=:daySeqCode and BPA_Status<>'D')
	b ;1
	i existArrangeId'=""  d
	.s result="该病人 "_arrangeDate_" 已安排透析!"
	q:(existArrangeId'="") result
	;q:(arrangeId'=existArrangeId)&(arrangeId'="") result
	;q:(arrangeId="")&(existArrangeId'="") result
	s arrange=##class(User.DHCBPArrange).%New()
	i (registerId'="") s arrange.BPABPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId(registerId)
    i schemeId'="" s arrange.BPABPSchemeDr=##class(User.DHCBPScheme).%OpenId(schemeId)
	s arrange.BPADate=arrangeDateH
	s arrange.BPATime=arrangeTimeH
	s arrange.BPADaySeqNo=daySeqCode
	s arrange.BPAArrangeType="T"
	s arrange.BPAStatus="F"
	s modeId=$p(arrangePara,$c(3),6)
	i modeId'="" s arrange.BPABPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(modeId)
    s secondModeId=$p(arrangePara,$c(3),7)
    i secondModeId'="" s arrange.BPASecondBPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(secondModeId)
	s arrange.BPACreateUserDr=$p(arrangePara,$c(3),8)
	s arrange.BPACreateDate=+$h
	s arrange.BPACreateTime=$p($h,",",2)
	d arrange.%Save()
    s rowId=arrange.%Id()
    q rowId
}

// D ##class(%ResultSet).RunQuery("web.DHCBPArrange","GetConsumableStatistics","2014-11-17","2014-11-23")

/// Creator: ZT
/// CreatDate: 2014-11-21
/// Description: 获取透析器材统计
/// Table：DHC_BP_Arrange,DHC_BP_ArrangeConsumable
/// Input：开始日期，结束日期，登记号
/// Return：count
Query GetConsumableStatistics(fromDate As %String, toDate As %String, regNo As %String = "", isInject As %String = "", arcimDr As %String = "", papmiMedicare As %String = "", papmiName As %String = "", locId As %String = "", needBpaStatus As %String = "") As %Query(ROWSPEC = "StartDate,DayPart,BedDesc,PatName,RegNo,Id,Desc,StatisticalQuantity:%String,ReplacedDesc:%String")
{
}

ClassMethod GetConsumableStatisticsExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, regNo As %String = "", isInject As %String = "", arcimDr As %String = "", papmiMedicare As %String = "", papmiName As %String = "", locId As %String = "", needBpaStatus As %String = "") As %Status
{
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s fromDate=##class(web.DHCANOPCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCANOPCom).ConvertToDateH(toDate)	
	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
	s EpisodeIDList=""
	i regNo'="" s EpisodeIDList=##class(web.DHCClinicCom).GetPatientEpisodeID(regNo,"","","","I")
	s papmiIdList=""
	s bpprIdList=""
	i regNo'="" s papmiIdList=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	i papmiIdList="",papmiMedicare'="" d
		.s papmiMedicare=$$ALPHAUP^SSUTIL4(papmiMedicare)
		.s papmiIdList=$o(^PAPERi("Medicare1",papmiMedicare,""))
	i papmiIdList="",papmiName'="" d
		.s papmiName=$$ALPHAUP^SSUTIL4(papmiName)
		.s papmiId=""
		.f  s papmiId=$o(^PAPERi("PAPER_PatName",papmiName,papmiId)) q:papmiId=""  d
			..i papmiIdList'="" s papmiIdList=papmiIdList_"^"
			..s papmiIdList=papmiIdList_papmiId
	i (regNo'="")!(papmiMedicare'="")!(papmiName'="") s isLocQuery=0
	e  s isLocQuery=1
	//w papmiIdList,!
	i papmiIdList'="" d
		.f i=1:1:$l(papmiIdList,"^") d
			..s papmiId=$p(papmiIdList,"^",i)
			..q:papmiId=""
			..s bpprId=$o(^DHCBPPatRegister(0,"PaPatMas",papmiId,""))
			..q:bpprId=""
			..s bpaId=""
			..f  s bpaId=$o(^DHCBPArrange(0,"PatRegister",bpprId,bpaId)) q:bpaId=""  d
			...q:$$GetStatistics()<0
	s consumableId="" 
	f  s consumableId=$O(TMPBPStastics("Output",consumableId)) q:consumableId=""  d
	.s item0=TMPBPStastics("Output",consumableId)
	.d OutputRowConsumable
	.s sum=TMPBPStastics("Count",consumableId)
	.s bpaDaySeqNo=""
	.f  s bpaDaySeqNo=$O(TMPBPStastics("Output",consumableId,bpaDaySeqNo)) q:bpaDaySeqNo=""  d
	..s papmiId=""
	..f  s papmiId=$O(TMPBPStastics("Output",consumableId,bpaDaySeqNo,papmiId)) q:papmiId=""  d
	...s bpaId=""
	...f  s bpaId=$O(TMPBPStastics("Output",consumableId,bpaDaySeqNo,papmiId,bpaId)) q:bpaId=""  d
	....s item=TMPBPStastics("Output",consumableId,bpaDaySeqNo,papmiId,bpaId)
	....d OutputRowPatSum
	.s item1=$lb("","","","","","","汇总",sum,"")
	.d OutputRowSum		
	i (regNo'="")!(papmiMedicare'="")!(papmiName'="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s bpaId=""	
	f curDate=fromDate:1:toDate d
	.s bpaId=""
	.f  s bpaId=$o(^DHCBPArrange(0,"Date",curDate,bpaId)) q:bpaId=""  d
	..q:$$GetStatistics()<0
		
	s consumableId="" 
	f  s consumableId=$O(TMPBPStastics("Output",consumableId)) q:consumableId=""  d
	.s item0=TMPBPStastics("Output",consumableId)
	.s $li(item0,8)=TMPBPStastics("Count",consumableId)
	.d OutputRowConsumable
	.s sum=TMPBPStastics("Count",consumableId)
	.s bpaDaySeqNo=""
	.f  s bpaDaySeqNo=$O(TMPBPStastics("Output",consumableId,bpaDaySeqNo)) q:bpaDaySeqNo=""  d
	..s papmiId=""
	..f  s papmiId=$O(TMPBPStastics("Output",consumableId,bpaDaySeqNo,papmiId)) q:papmiId=""  d
	...s bpaId=""
	...f  s bpaId=$O(TMPBPStastics("Output",consumableId,bpaDaySeqNo,papmiId,bpaId)) q:bpaId=""  d
	....s item=TMPBPStastics("Output",consumableId,bpaDaySeqNo,papmiId,bpaId)
	....//w "item："_item,!
	....//w "papmiId:"_papmiId,!
	....//w "bpaId:"_bpaId,!
	....d OutputRowPatSum
	.s item1=$lb("","","","","","","汇总",sum,"")
	.d OutputRowSum	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetStatistics()
	q:bpaId="" -1	
	s bpprId=$lg(^DHCBPArrange(bpaId),1)
	//;s admId=$lg(^DHCBPArrange(bpaId),2)
	s admId=$lg(^DHCBPPatRegister(bpprId),26)
	q:admId="" -2
	s admDeptId=$p($g(^PAADM(admId)),"^",4)	
    q:((locId'="")&&(admDeptId'="")&&($p($g(^CTLOC(locId)),"^",22)'=$p($g(^CTLOC(admDeptId)),"^",22))) -3 //病人所在医院判断
    s bpprPatLocationDr=$lg(^DHCBPPatRegister(bpprId),34)	
    q:(bpprPatLocationDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_bpprPatLocationDr_"^")) -3
	s bpaDaySeqNo="",dayPart=""
	s bpaDaySeqNo=$lg(^DHCBPArrange(bpaId),6)
	i bpaDaySeqNo="A" s dayPart="上午"	
	i bpaDaySeqNo="P" s dayPart="下午"
	i bpaDaySeqNo="E" s dayPart="晚上"
	s bpaBPCBedDr=$lg(^DHCBPArrange(bpaId),7)
	s bpaBPCBedDesc=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),2)	
    q:bpprId="" -2    
	s bpprStatus=$lg(^DHCBPPatRegister(bpprId),14)
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	q:papmiId="" -3
	q:'$d(^PAPER(papmiId,"PAT",1)) -4
	s patRegNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	//s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22) //20200515统一走病案接口
	s paadmtype=$p($g(^PAADM(admId)),"^",2)
	s papmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
	s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s patBirth=$p($g(^PAPER(papmiId,"ALL")),"^",6)	//出生日期
	s bpaDate=$lg(^DHCBPArrange(bpaId),4)
	s bpaTime=$lg(^DHCBPArrange(bpaId),5)
	q:(bpaDate'="")&(bpaDate>toDate) -11
	q:(bpaDate'="")&(bpaDate<fromDate) -12
	s bpaDate=##class(web.DHCANOPCom).ConvertToDate(bpaDate)
	s patAge=##class(web.DHCClinicCom).CalAge(patBirth,bpaDate)
	s bpaStatus=$lg(^DHCBPArrange(bpaId),9)
	q:bpaStatus="" -5
	q:(needBpaStatus'="")&&(needBpaStatus'[bpaStatus) -6
	q:bpaStatus="D" -7
	s bpacId=""
	f  s bpacId=$o(^DHCBPArrangeConsumable(0,"Arrange",bpaId,bpacId)) q:bpacId=""  d
	.s ifAbandon=$lg(^DHCBPArrangeConsumable(bpacId),6)
	.q:ifAbandon="Y"
	.s consumableId=$lg(^DHCBPArrangeConsumable(bpacId),2)
	.;b ;1
    .s consumableDesc=$lg($g(^DHCBPC("Consumable",+consumableId)),2)
    .;b ;2
    .s amount=$lg(^DHCBPArrangeConsumable(bpacId),4)
    .q:amount=0
    .q:consumableId=""
    .s replacedDesc=""
    .s replaced=$lg(^DHCBPArrangeConsumable(bpacId),3)
    .i replaced="R" s replacedDesc="替换使用"
	.i $d(TMPBPStastics("Count",consumableId)) s TMPBPStastics("Count",consumableId)=TMPBPStastics("Count",consumableId)+amount
	.e  s TMPBPStastics("Count",consumableId)=amount
	.i $d(TMPBPStastics("Count",consumableId,bpaDaySeqNo,papmiId,bpaId)) s TMPBPStastics("Count",consumableId,bpaDaySeqNo,papmiId,bpaId)=TMPBPStastics("Count",consumableId,bpaDaySeqNo,papmiId,bpaId)+amount
	.e  s TMPBPStastics("Count",consumableId,bpaDaySeqNo,papmiId,bpaId)=amount
	.s TMPBPStastics("Output",consumableId)=$lb("","","","","",consumableId,consumableDesc,"","")
	.s TMPBPStastics("Output",consumableId,bpaDaySeqNo,papmiId,bpaId)=$lb(bpaDate,dayPart,bpaBPCBedDesc,patName,patRegNo,consumableId,"",TMPBPStastics("Count",consumableId,bpaDaySeqNo,papmiId,bpaId),replacedDesc)     
	q 0
OutputRowConsumable
	set Data=item0
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
OutputRowPatSum           
	set Data=item
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
OutputRowSum
	set Data=item1
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetConsumableStatisticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConsumableStatisticsExecute ]
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

ClassMethod GetConsumableStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConsumableStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindBPStatus() As %Query(ROWSPEC = "statDesc:%String,statCode:%String")
{
}

ClassMethod FindBPStatusExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	//A-申请,D-拒绝,R-接收,M-监护,T-停止,F-完成
	s statDescStr="安排^监护^停止^完成" //"申请^拒绝^安排^监护^停止^完成"
	s statCodeStr="R^M^T^F" //"A^D^R^M^T^F" 
	f i=1:1:4 d
	    .s statDesc=$p(statDescStr,"^",i)
	    .s statCode=$p(statCodeStr,"^",i)
	    .d OutputStat
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputStat
	s Data=$lb(statDesc,statCode)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindBPStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPStatusExecute ]
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

ClassMethod FindBPStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPStatusExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod DeleteBPArrange(bpaId As %String)
{
    i bpaId="" q 0
    //&SQL(delete from DHC_BP_Arrange where BPA_RowId=:bpaId)  //
	&SQL(update DHC_BP_Arrange set BPA_Status='D' where BPA_RowId=:bpaId) //不是真正删除，防止误操作
	q SQLCODE
}

ClassMethod AdjustBpaStartDateTime(EpisodeID As %String, startDate As %String, startTime As %String) As %String
{
	q 0
	
	s retStr=##class(web.DHCANOPCom).GetAdmTransWardList(EpisodeID, .transWardList)
	q:retStr'=0 retStr
	q:'$d(transWardList) "该病人无转病区记录!"
	
	s wardInDateTime=$o(transWardList(""),-1)
	s startDate=##class(web.DHCANOPCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCANOPCom).ConvertToTimeH(startTime)
	s startDateTime=startDate+(startTime/100000)
	i startDateTime<wardInDateTime d
		.s wardInDate=$p(wardInDateTime,".",1)
		.s wardInTime=(wardInDateTime-wardInDate)*100000
		.s minTime=wardInTime,minDate=wardInDate
		.s preWardInDateTime=$o(transWardList(wardInDateTime),-1)
		.i preWardInDateTime'="" d //非入院病区
			..s minTime=minTime-18000 //最早提前5小时
			..i minTime<0 d
				...s minTime=minTime+86400
				...s minDate=minDate-1
			..s minDateTime=minDate+(minTime/100000)
			..i preWardInDateTime>minDateTime d //最早时间不早于上次转病区时间
				...s minDate=$p(preWardInDateTime,".",1)
				...s minTime=(preWardInDateTime-minDate)*100000
		.e  s minDate=minDate-1 //入院病区，最早提前一天
		.s minDateTime=minDate+(minTime/100000)
		.i startDateTime<minDateTime d
			..s startDate=minDate,startTime=minTime
	q 0
}

ClassMethod UpdateNormalStart(bpaId As %String, date As %String, time As %String)
{
	i bpaId="" q 0
	s date=##class(web.DHCANOPCom).ConvertToDateH(date,"")
	s time=##class(web.DHCANOPCom).ConvertToTimeH(time,"")
	i date="" s time=""
	&SQL(update DHC_BP_Arrange set BPA_Date=:date,BPA_Time=:time where BPA_RowId=:bpaId)
	q SQLCODE
}

ClassMethod GetDiag(admId As %String = "")
{

	s $p(str,"^",2)=""
	q:admId="" $p(str,"^",2)
	s mradm=$P(^PAADM(admId),"^",61)
	s retIcdId=""
	s tDiagDesc=""
	s mcl=0  
	f  s mcl=$O(^MR(mradm,"DIA",mcl) ) q:(mcl="")  d
		.s icddr=$P(^MR(mradm,"DIA",mcl),"^",1)
		.q:icddr=""
		.s retIcdId=icddr
		.i icddr'=""  d
			..s diagdes=$P(^MRC("ID",icddr),"^",2)
			..s diagdes=diagdes_"^"_icddr
		.i tDiagDesc="" s tDiagDesc=diagdes
		.e  s tDiagDesc=tDiagDesc_";"_diagdes
	q tDiagDesc
}

ClassMethod GetMRAdmDiagnosis(MRAdm As %String) As %String
{
	 q:$g(MRAdm)="" ""
	 s mrAdmId=$p($g(^PAADM(MRAdm)),"^",61)
	 s DiagStr=""
	 //业务，考虑到如果加前缀可能把诊断当成自定义，暂时不加，以后改造
	 s diagInfoStr=##class(web.DHCANAdaptor).GetDiagInfoByAdmId(mrAdmId)
	s digStrLength=$l(diagInfoStr,"^")
	f dnum=1:1:digStrLength d
		.s curDiagStr=$p(diagInfoStr,"^",dnum)
		.s curDigDesc=$p(curDiagStr,"&&",1)
		.s curDigId=$p(curDiagStr,"&&",2)
		.s curDigNote=$p(curDiagStr,"&&",3)
		.s curPreFix=$p(curDiagStr,"&&",4)
		.s curDigType=$p(curDiagStr,"&&",5)
		.s curDigMainFlag=$p(curDiagStr,"&&",6)
		.s newDiagStr=curDigDesc_"^"_curDigId
		.i DiagStr'="" s DiagStr=DiagStr_"|"_newDiagStr
		.e  s DiagStr=newDiagStr

	 /*
	 s Diagtmp=0
	 f  s Diagtmp=$O(^MR(mrAdmId,"DIA",Diagtmp)) Quit:(Diagtmp="")  Do
		 .s DiagID=$P($g(^MR(mrAdmId,"DIA",Diagtmp)),"^",1)
		 .q:$g(DiagID)=""
		 .s DiagDesc=$P($g(^MRC("ID",DiagID)),"^",2)
		 .s Diag=DiagDesc_"^"_DiagID
		 .i DiagStr'="" s DiagStr=DiagStr_"|"_Diag
		 .e  s DiagStr=Diag
 	*/
 	
 q DiagStr
}

ClassMethod AddDiag(bpaId As %String, DiagId As %String = "") As %String
{
	 q:$g(bpaId)="" ""
	 s $p(^DHCBPArrange(bpaId),"^",20)=DiagId
}

/// 按床位bpcBedId,病区wardId查找病人，床位的优先级高。
/// ifScheme为1按计划床位病人查（血液液化方式是最后一次的），否则按当前床位病人查
/// needDaySeqNo查找的日班次(A上午,P下午,E晚上)，可组合
Query FindBedArrange(bpcBedId As %String, wardId As %String, startDate As %String, endDate As %String, ifScheme As %Boolean, needDaySeqNo As %String) As %Query(ROWSPEC = "bpcBedId,bpaId,weekSeqNo,daySeqNo,patName,bpcBPModeDesc")
{
}

ClassMethod FindBedArrangeExecute(ByRef qHandle As %Binary, bpcBedId As %String, wardId As %String, startDate As %String, endDate As %String, ifScheme As %Boolean, needDaySeqNo As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s startDate=##class(web.DHCANOPCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCANOPCom).ConvertToDateH(endDate)
	i endDate<startDate Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	i (bpcBedId'="") s bpcBedIdList(bpcBedId)=""
	e  d
		.q:wardId=""
		.s bpcBedId=""
		.f  s bpcBedId=$o(^DHCBPC("Bed",bpcBedId)) q:bpcBedId=""  d
			..s bpcbgId=$lg(^DHCBPC("Bed",bpcBedId),3)
			..q:bpcbgId=""
			..q:$lg(^DHCBPC("BedGroup",bpcbgId),3)'=wardId
			..s bpcBedIdList(bpcBedId)=""
	i ifScheme d //按计划查
		.f curDate=startDate:1:endDate d
			..s weekSeqNo=$zd(curDate,10)
			..i weekSeqNo=0 s weekSeqNo=7
			..s weekSeqNoList(weekSeqNo)=""
		.s bpcBedId=""
		.f  s bpcBedId=$o(bpcBedIdList(bpcBedId)) q:bpcBedId=""  d
			..s weekSeqNo=0
			..f  s weekSeqNo=$o(^DHCBPBedScheme(0,"BedWeek",bpcBedId,weekSeqNo)) q:weekSeqNo=""  d
				...q:'$d(weekSeqNoList(weekSeqNo))
				...s bpbsId=0
				...f  s bpbsId=$o(^DHCBPBedScheme(0,"BedWeek",bpcBedId,weekSeqNo,bpbsId)) q:bpbsId=""  d
					....s daySeqNo=$lg(^DHCBPBedScheme(bpbsId),4)
					....q:(needDaySeqNo'="")&(needDaySeqNo'[daySeqNo)
					....s bpprId=$lg(^DHCBPBedScheme(bpbsId),2)
					....q:bpprId=""
					....s bpaId=$o(^DHCBPArrange(0,"Register",bpprId,""),-1) //$lg(^DHCBPArrange(bpaId),1)
					....//q:bpaId=""
					....s papmiId=$lg($g(^DHCBPPatRegister(bpprId)),1)
					....q:papmiId=""
					....s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
					....s bpcBPModeId=$lg($g(^DHCBPArrange(+bpaId)),26)
					....s bpcBPModeDesc=$lg($g(^DHCBPC("BloodPurificationMode",+bpcBPModeId)),2)
					....d OutputRow2
	e  d //按日期查
		.f curDate=startDate:1:endDate d
			..s bpaId=""
			..f  s bpaId=$o(^DHCBPArrange(0,"Date",curDate,bpaId)) q:bpaId=""  d
				...s bpcBedId=$lg(^DHCBPArrange(bpaId),7)
				...q:'$d(bpcBedIdList(bpcBedId))
				...s bpaDaySeqNo=$lg(^DHCBPArrange(bpaId),6)
				...q:(needDaySeqNo'="")&(needDaySeqNo'[bpaDaySeqNo)
				...s bpprId=$lg(^DHCBPArrange(bpaId),1)
				...q:bpprId=""
				...s papmiId=$lg($g(^DHCBPPatRegister(bpprId)),1)
				...q:papmiId=""
				...s weekSeqNo=$zd(curDate,10)
				...i weekSeqNo=0 s weekSeqNo=7
				...s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
				...s bpcBPModeId=$lg(^DHCBPArrange(bpaId),26)
				...s bpcBPModeDesc=$lg($g(^DHCBPC("BloodPurificationMode",+bpcBPModeId)),2)
				...d OutputRow2

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(bpcBedId,bpaId,weekSeqNo,daySeqNo,patName,bpcBPModeDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBedArrangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBedArrangeExecute ]
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

ClassMethod FindBedArrangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBedArrangeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// w ##class(web.DHCBPArrange).CopyDayArrangeFromLast("2014-07-21","","",3879)

ClassMethod CopyDayArrangeFromLast(lastDate As %String, arrangeDate As %String, arrangeTime As %String, updateUserId As %String) As %String
{
	s curDate=##class(web.DHCClinicCom).ConvertToDateH(lastDate)
	s retStr=""
	s bpaId=""
   	f  s bpaId=$o(^DHCBPArrange(0,"Date",curDate,bpaId)) q:bpaId=""  d
    .s arrange=##class(User.DHCBPArrange).%New()
    .s bedId=$lg(^DHCBPArrange(bpaId),7)
    .s bedIsArranged=1
    .i bedId'="" d
    ..s bedIsArranged=..GetBedIsArranged(arrangeDate,bedId) 
    .q:bedIsArranged    
    .s arrange.BPABPCBedDr=##class(User.DHCBPCBed).%OpenId(bedId)
    .s arrange.BPAStatus="R"
    .s registerId=$lg(^DHCBPArrange(bpaId),1)
    .s patientIsArranged=1
    .s patientIsArranged=..GetPatientIsArranged(arrangeDate,registerId)
    .q:patientIsArranged
    .i (registerId'="") s arrange.BPABPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId(registerId)
    .s schemeId=$lg(^DHCBPArrange(bpaId),3)
    .i schemeId'="" s arrange.BPABPSchemeDr=##class(User.DHCBPScheme).%OpenId(schemeId)
    .s arrangeDate=##class(DHCClinicCom).ConvertToDateH(arrangeDate)
    .i arrangeDate'="" s arrange.BPADate=arrangeDate
    .s arrangeTime=##class(DHCClinicCom).ConvertToDateH(arrangeTime)
    .i arrangeTime'="" s arrange.BPATime=arrangeTime
    .s daySeqNo=$lg(^DHCBPArrange(bpaId),6)
    .s arrange.BPADaySeqNo=daySeqNo
    .s modeId=$lg(^DHCBPArrange(bpaId),26)
    .i modeId'="" s arrange.BPABPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(modeId)
    .s secondModeId=$lg(^DHCBPArrange(bpaId),27)
    .i secondModeId'="" s arrange.BPASecondBPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(secondModeId)
    .s arrange.BPAOralHematin=$lg(^DHCBPArrange(bpaId),36)
    .s arrange.BPAInjectHematin=$lg(^DHCBPArrange(bpaId),37)  
    .d arrange.%Save()
    .s result=arrange.%Id()
    .i retStr="" s retStr=result
    .e  s retStr=retStr_"^"_result
     q retStr
}

ClassMethod SaveBPArrangeList(arrangeList As %String) As %String
{
    s result=""
	f i=1:1:$l(arrangeList,"^")  d
	.s arrangePara=$p(arrangeList,"^",i)
	.s id=..SaveBPArrange(arrangePara)
	.i result'="" s result=result_"^"
	.s result=result_id
	q result
}

// w ##class(web.DHCBPArrange).SaveBPArrange("")

ClassMethod SaveBPArrange(arrangePara As %String) As %String
{
	//s ^TMPzt("SaveBPArrange")=arrangePara
	//s arrangePara=^TMPzt("SaveBPArrange")
		s arrangeId=$p(arrangePara,$c(3),1)
        q:(arrangePara="") ""
        s result="",arrange=""
        i (arrangeId="") s arrange=##class(User.DHCBPArrange).%New()
        e  s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)
        s registerId=$p(arrangePara,$c(3),2)
        s arrangeDate=$p(arrangePara,$c(3),5)
        s arrangeDate=##class(DHCANOPCom).ConvertToDateH(arrangeDate)
        &sql(select count(*) into :count from DHC_BP_Arrange where BPA_Date=:arrangeDate and BPA_BPPatRegister_Dr=:registerId and BPA_Status<>'D')
	    q:(arrangeId="")&(count>0) "已安排"
        i (registerId'="") s arrange.BPABPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId(registerId)
        s arrange.BPAAdmDr=$p(arrangePara,$c(3),3)
        s schemeId=$p(arrangePara,$c(3),4)
        i schemeId'="" s arrange.BPABPSchemeDr=##class(User.DHCBPScheme).%OpenId(schemeId)        
        i arrangeDate'="" s arrange.BPADate=arrangeDate
        s arrangeTime=$p(arrangePara,$c(3),6)
        i arrangeTime'="" s arrange.BPATime=##class(DHCANOPCom).ConvertToTimeH(arrangeTime)
        s daySeqNo=$p(arrangePara,$c(3),7)
        i $p(arrangePara,$c(3),7)="上午"  s daySeqNo="A"
        i $p(arrangePara,$c(3),7)="下午"  s daySeqNo="P"
        i $p(arrangePara,$c(3),7)="晚上"  s daySeqNo="E"
        s arrange.BPADaySeqNo=daySeqNo
        s bedId=$p(arrangePara,$c(3),8)
        s bedIsArranged=1
        b ;bed
        i bedId'="" d
        .s bedIsArranged=..GetBedIsArranged(arrangeDate,daySeqNo,bedId)
        e  s arrange.BPAStatus=$p(arrangePara,$c(3),10)        
        i 'bedIsArranged d
        .s arrange.BPABPCBedDr=##class(User.DHCBPCBed).%OpenId(bedId)
        .s arrange.BPAStatus=$p(arrangePara,$c(3),10)
        s arrange.BPAArrangeType=$p(arrangePara,$c(3),9)       
        s arrange.BPAStartWeight=$p(arrangePara,$c(3),11)
        s arrange.BPASubtractiveWeight=$p(arrangePara,$c(3),12)
        s arrange.BPAIntakeAmount=$p(arrangePara,$c(3),13)
        s arrange.BPAPlanDewaterAmount=$p(arrangePara,$c(3),14)
        s arrange.BPAEndWeight=$p(arrangePara,$c(3),15)
        s arrange.BPADewaterAmount=$p(arrangePara,$c(3),16)
        s arrange.BPAFoodIntakeAmount=$p(arrangePara,$c(3),17)
        s arrange.BPAResidualBloodAmount=$p(arrangePara,$c(3),18)
        s arrange.BPATherapyDuration=$p(arrangePara,$c(3),19)
        s arrange.BPAFlushPipeNurseCtcpDr=$p(arrangePara,$c(3),20)
        s arrange.BPAPunctureNurseCtcpDr=$p(arrangePara,$c(3),21)
        s arrange.BPACirculatingNurseCtcpDr=$p(arrangePara,$c(3),22)
        s arrange.BPAJoinPipeNurseCtcpDr=$p(arrangePara,$c(3),23)
        s arrange.BPACloseNurseCtcpDr=$p(arrangePara,$c(3),24)
        s vascularAccessId=$p(arrangePara,$c(3),25)
        i vascularAccessId'="" s arrange.BPAVascularAccessDr=##class(User.DHCBPCVascularAccess).%OpenId(vascularAccessId)
        s equipId=$p(arrangePara,$c(3),26)
        i equipId'="" s arrange.BPABPCEquipDr=##class(User.DHCBPCEquip).%OpenId(equipId)
        s modeId=$p(arrangePara,$c(3),27)
        i modeId'="" s arrange.BPABPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(modeId)
        s secondModeId=$p(arrangePara,$c(3),28)
        i secondModeId'="" s arrange.BPASecondBPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(secondModeId)
        s thirdModeId=$p(arrangePara,$c(3),29)
        i thirdModeId'="" s arrange.BPAThirdBPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(thirdModeId)
        s equipRunModeId=$p(arrangePara,$c(3),33)
        i equipRunModeId'="" s arrange.BPABPCEquipRunModeDr=equipRunModeId
        s arrange.BPAOrdered=$p(arrangePara,$c(3),34)
        s arrange.BPACt=$p(arrangePara,$c(3),35)
        s arrange.BPAAct=$p(arrangePara,$c(3),36)
        s arrange.BPAOralHematin=$p(arrangePara,$c(3),37)
        s arrange.BPAInjectHematin=$p(arrangePara,$c(3),38)
        s arrange.BPAHeparin=$p(arrangePara,$c(3),39)
        s arrange.BPANa=$p(arrangePara,$c(3),43)     
        s arrange.BPAK=$p(arrangePara,$c(3),44)
        s arrange.BPACa2=$p(arrangePara,$c(3),45)
        s arrange.BPAHCO3=$p(arrangePara,$c(3),46)
        s arrange.BPAFilterReplaceMode=$p(arrangePara,$c(3),47)
        s arrange.BPAFilterReplaceAmount=$p(arrangePara,$c(3),48)
        s arrange.BPAEquipRunEffect=$p(arrangePara,$c(3),49)
        s arrange.BPAGrume=$p(arrangePara,$c(3),50)
        s arrange.BPAPipeGrume=$p(arrangePara,$c(3),51)
        s arrange.BPAAVFEffect=$p(arrangePara,$c(3),52)
        s arrange.BPADindle=$p(arrangePara,$c(3),53)
        s arrange.BPAJoinDirection=$p(arrangePara,$c(3),54)
        s arrange.BPAOutletEffect=$p(arrangePara,$c(3),55)       
        s arrange.BPANote=$p(arrangePara,$c(3),86) 
        s arrange.BPACreateUserDr=$p(arrangePara,$c(3),89)
        s updateDate=$p(arrangePara,$c(3),90)
        i updateDate'="" s arrange.BPACreateDate=##class(DHCANOPCom).ConvertToDateH(updateDate)
        s updateTime=$p(arrangePara,$c(3),91)
        i updateTime'="" s arrange.BPACreateTime= ##class(DHCANOPCom).ConvertToTimeH(updateTime)
        d arrange.%Save()
        s result=arrange.%Id()
        q result
}

ClassMethod PDSaveArrange(arrangePara As %String, consumableBusinessPara, anticoagulantDrugBusinessPara, equipRunParaBusinessPara) As %String
{
	//s ^TMPzt("SaveBPArrange")=arrangePara
	//s arrangePara=^TMPzt("SaveBPArrange")
	s arrangeId=$p(arrangePara,$c(3),1)
        q:(arrangePara="") ""
        s result="",arrange=""
        i (arrangeId="") s arrange=##class(User.DHCBPArrange).%New()
        e  s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)
        s registerId=$p(arrangePara,$c(3),2)
        s arrangeDate=$p(arrangePara,$c(3),5)
        s arrangeDate=##class(DHCANOPCom).ConvertToDateH(arrangeDate)
        //&sql(select count(*) into :count from DHC_BP_Arrange where BPA_Date=:arrangeDate and BPA_BPPatRegister_Dr=:registerId and BPA_Status<>'D')
	    //q:(arrangeId="")&(count>0) "已安排"
        i (registerId'="") s arrange.BPABPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId(registerId)
        s arrange.BPAAdmDr=$p(arrangePara,$c(3),3)
        s schemeId=$p(arrangePara,$c(3),4)
        i schemeId'="" s arrange.BPABPSchemeDr=##class(User.DHCBPScheme).%OpenId(schemeId)        
        i arrangeDate'="" s arrange.BPADate=arrangeDate
        s arrangeTime=$p(arrangePara,$c(3),6)
        i arrangeTime'="" s arrange.BPATime=##class(DHCANOPCom).ConvertToTimeH(arrangeTime)
        s daySeqNo=$p(arrangePara,$c(3),7)
        i $p(arrangePara,$c(3),7)="上午"  s daySeqNo="A"
        i $p(arrangePara,$c(3),7)="下午"  s daySeqNo="P"
        i $p(arrangePara,$c(3),7)="晚上"  s daySeqNo="E"
        s arrange.BPADaySeqNo=daySeqNo
        s bedId=$p(arrangePara,$c(3),8)
        s bedIsArranged=1
        b ;bed
        i bedId'="" d
        .s bedIsArranged=..GetBedIsArranged(arrangeDate,daySeqNo,bedId)
        e  s arrange.BPAStatus=$p(arrangePara,$c(3),10)        
        i 'bedIsArranged d
        .s arrange.BPABPCBedDr=##class(User.DHCBPCBed).%OpenId(bedId)
        .s arrange.BPAStatus=$p(arrangePara,$c(3),10)
        s arrange.BPAArrangeType=$p(arrangePara,$c(3),9)       
        s arrange.BPAStartWeight=$p(arrangePara,$c(3),11)
        s arrange.BPASubtractiveWeight=$p(arrangePara,$c(3),12)
        s arrange.BPAIntakeAmount=$p(arrangePara,$c(3),13)
        s arrange.BPAPlanDewaterAmount=$p(arrangePara,$c(3),14)
        s arrange.BPAEndWeight=$p(arrangePara,$c(3),15)
        s arrange.BPADewaterAmount=$p(arrangePara,$c(3),16)
        s arrange.BPAFoodIntakeAmount=$p(arrangePara,$c(3),17)
        s arrange.BPAResidualBloodAmount=$p(arrangePara,$c(3),18)
        s arrange.BPATherapyDuration=$p(arrangePara,$c(3),19)
        s arrange.BPAFlushPipeNurseCtcpDr=$p(arrangePara,$c(3),20)
        s arrange.BPAPunctureNurseCtcpDr=$p(arrangePara,$c(3),21)
        s arrange.BPACirculatingNurseCtcpDr=$p(arrangePara,$c(3),22)
        s arrange.BPAJoinPipeNurseCtcpDr=$p(arrangePara,$c(3),23)
        s arrange.BPACloseNurseCtcpDr=$p(arrangePara,$c(3),24)
        s vascularAccessId=$p(arrangePara,$c(3),25)
        i vascularAccessId'="" s arrange.BPAVascularAccessDr=##class(User.DHCBPCVascularAccess).%OpenId(vascularAccessId)
        s equipId=$p(arrangePara,$c(3),26)
        i equipId'="" s arrange.BPABPCEquipDr=##class(User.DHCBPCEquip).%OpenId(equipId)
        s modeId=$p(arrangePara,$c(3),27)
        i modeId'="" s arrange.BPABPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(modeId)
        s secondModeId=$p(arrangePara,$c(3),28)
        i secondModeId'="" s arrange.BPASecondBPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(secondModeId)
        s thirdModeId=$p(arrangePara,$c(3),29)
        i thirdModeId'="" s arrange.BPAThirdBPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(thirdModeId)
        s equipRunModeId=$p(arrangePara,$c(3),33)
        i equipRunModeId'="" s arrange.BPABPCEquipRunModeDr=equipRunModeId
        s arrange.BPAOrdered=$p(arrangePara,$c(3),34)
        s arrange.BPACt=$p(arrangePara,$c(3),35)
        s arrange.BPAAct=$p(arrangePara,$c(3),36)
        s arrange.BPAOralHematin=$p(arrangePara,$c(3),37)
        s arrange.BPAInjectHematin=$p(arrangePara,$c(3),38)
        s arrange.BPAHeparin=$p(arrangePara,$c(3),39)
        s arrange.BPANa=$p(arrangePara,$c(3),43)     
        s arrange.BPAK=$p(arrangePara,$c(3),44)
        s arrange.BPACa2=$p(arrangePara,$c(3),45)
        s arrange.BPAHCO3=$p(arrangePara,$c(3),46)
        s arrange.BPAFilterReplaceMode=$p(arrangePara,$c(3),47)
        s arrange.BPAFilterReplaceAmount=$p(arrangePara,$c(3),48)
        s arrange.BPAEquipRunEffect=$p(arrangePara,$c(3),49)
        s arrange.BPAGrume=$p(arrangePara,$c(3),50)
        s arrange.BPAPipeGrume=$p(arrangePara,$c(3),51)
        s arrange.BPAAVFEffect=$p(arrangePara,$c(3),52)
        s arrange.BPADindle=$p(arrangePara,$c(3),53)
        s arrange.BPAJoinDirection=$p(arrangePara,$c(3),54)
        s arrange.BPAOutletEffect=$p(arrangePara,$c(3),55)        
    	// 透析前舒张压
    	s arrange.BPAStartDiastolicPressure=$p(arrangePara,$c(3),63)   
    	// 透析前收缩压
    	s arrange.BPAStartSystolicPressure=$p(arrangePara,$c(3),65)   
    	/// 透析前心率
    	s arrange.BPAStartHeartRate=$p(arrangePara,$c(3),67)        
        s arrange.BPANote=$p(arrangePara,$c(3),86) 
        i arrangeId="" d
		.;s arrange.BPAArrangeType="T"
        .s arrange.BPACreateUserDr=$p(arrangePara,$c(3),89)
        .;s arrange.BPACreateDate=+$h
		.;s arrange.BPACreateTime=$p($h,",",2)
        .s updateDate=$p(arrangePara,$c(3),90)
        .i updateDate'="" s arrange.BPACreateDate=##class(DHCANOPCom).ConvertToDateH(updateDate)
        .s updateTime=$p(arrangePara,$c(3),91)
        .i updateTime'="" s arrange.BPACreateTime= ##class(DHCANOPCom).ConvertToTimeH(updateTime)
        s anticoagulantModeId=$p(arrangePara,$c(3),78)
    	i anticoagulantModeId'="" s arrange.BPAAnticoagulantModeDr=##class(User.DHCBPCAnticoagulantMode).%OpenId(anticoagulantModeId)
        s docOperateStatus=$p(arrangePara,$c(3),56)
    	s arrange.BPADocOperateStatus=docOperateStatus
    	i docOperateStatus="C" 
    	{
     		s arrange.BPACheckDocDr=$p(arrangePara,$c(3),92)
     		s updateDate=$p(arrangePara,$c(3),93)
     		i updateDate'="" s arrange.BPACheckDate=##class(web.DHCClinicCom).ConvertToDateH(updateDate)
     		s updateTime=$p(arrangePara,$c(3),94)
     		i updateTime'="" s arrange.BPACheckTime= ##class(web.DHCClinicCom).ConvertToTimeH(updateTime)
    	}
        //病情处理记录
    	s arrange.BPADiseaseTreatment=$p(arrangePara,$c(3),85)
    	//实验室检查(腹透复诊记录) 
    	s arrange.BPALaboratoryExamination=$p(arrangePara,$c(3),112) 
    	//其他症状(腹透复诊记录)
    	s arrange.BPAOtherSymptoms=$p(arrangePara,$c(3),113) 
        d arrange.%Save()
    	s rowId=arrange.%Id()
    TSTART
    s result=..SaveArrangeAntDrugList(rowId,anticoagulantDrugBusinessPara)
    i +result'=1 TROLLBACK  q "保存抗凝药品错误"
    TCOMMIT
	q rowId
}

// D ##class(%ResultSet).RunQuery("web.DHCBPArrange","FindBPArrange","2014-02-17","2014-11-23")

Query FindBPArrange(fromDate As %String = "", toDate As %String = "", regNo As %String = "", needBpaStatus As %String = "", papmiMedicare As %String = "", papmiName As %String = "", arrangeId As %String = "") As %Query(ROWSPEC = "Id,RegisterId,SchemeDetailId,EpisodeId,RegNo,PatName,PatGender,PatAge,PatDiagnosis,MedicareNo,BedId,BedDesc,ArrangeDate,ArrangeTime,DayPartCode,ArrangeType,Status,RegisterStatus,BPNum,StartWeight,SubtractiveWeight,EndWeight,IntakeAmount,PlanDewaterAmount,ReplenishWaterAmount,DewaterAmount,ResidualBloodAmount,TherapyDuration,FlushPipeNurseId,FlushPipeNurseDesc,PunctureNurseId,PunctureNurseDesc,CirculatingNurseId,CirculatingNurseDesc,JoinPipeNurseId,JoinPipeNurseDesc,CloseNurseId,CloseNurseDesc,VascularAccessSchemeId,EquipId,EquipDesc,DialysisMethodId,DialysisMethodDesc,SecondDialysisMethodId,SecondDialysisMethodDesc,CT,ACT,EquipRunModeId,Na,K,Ca2,HCO3,Temperature,FilterReplaceMode,FilterReplaceAmount,EquipRunStatus,Grume,PipeGrume,AVFEffect,Dindle,JoinDirection,OutletEffect,OralHematin,InjectHematin,PatBPNo,StartDiastolicPressure,EndDiastolicPressure,StartSystolicPressure,EndSystolicPressure,StartHeartRate,EndHeartRate,StartSymptom,EndSymptom,UrineVolume,ClinicalEvaluationNote,IsolatedUltrafiltrationVolume,BFR,BFRNote,VascularAccessId,BodySiteId,AnticoagulantModeId,AnticoagulantMode,ReturnSalineAmount,BPSchemeAdjustment,PlanTherapyDuration,PlanFilterReplaceAmount,DFR,VascularAccessStatus,AllConsumable,Note,DiseaseTreatment,ArrangeEndDate,ArrangeEndTime,CreateUserId,CreateDate,CreateTime,DocOperateStatus,CheckDocId,CheckDocDesc,CheckDate,CheckTime,RecheckDocId,RecheckDocDesc,RecheckDate,RecheckTime,WardRoundDocId,WardRoundDocDesc,WardRoundDate,WardRoundTime,StartOperationNurseId,StartOperationNurseDesc,StartOperationDate,StartOperationTime,EndOperationNurseId,EndOperationNurseDesc,EndOperationDate,EndOperationTime,CheckNurseId,CheckNurseDesc,NurseCheckDate,NurseCheckTime,IsOrdered:%Boolean,BloodPressureMeasurePart,EndUpdateDocId,DocEndUpdateDate,DocEndUpdateTime,LaboratoryExamination,OtherSymptoms,DialysisBeforeNote")
{
}

ClassMethod FindBPArrangeExecute(ByRef qHandle As %Binary, fromDate As %String = "", toDate As %String = "", regNo As %String = "", needBpaStatus As %String = "", papmiMedicare As %String = "", papmiName As %String = "", arrangeId As %String = "") As %Status
{
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i arrangeId'="" d
		.s bpaId=arrangeId
		.q:$$GetArrange()<0
		.d OutputRow
	i arrangeId'="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s fromDate=##class(web.DHCANOPCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCANOPCom).ConvertToDateH(toDate)
	s EpisodeIDList=""
	i regNo'="" s EpisodeIDList=##class(web.DHCClinicCom).GetPatientEpisodeID(regNo,"","","","I")
	s papmiIdList=""
	s bpprIdList=""
	i regNo'="" s papmiIdList=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	i papmiIdList="",papmiMedicare'="" d
		.s papmiMedicare=$$ALPHAUP^SSUTIL4(papmiMedicare)
		.s papmiIdList=$o(^PAPERi("Medicare1",papmiMedicare,""))
	i papmiIdList="",papmiName'="" d
		.s papmiName=$$ALPHAUP^SSUTIL4(papmiName)
		.s papmiId=""
		.f  s papmiId=$o(^PAPERi("PAPER_PatName",papmiName,papmiId)) q:papmiId=""  d
			..i papmiIdList'="" s papmiIdList=papmiIdList_"^"
			..s papmiIdList=papmiIdList_papmiId
	i (regNo'="")!(papmiMedicare'="")!(papmiName'="") s isLocQuery=0
	e  s isLocQuery=1

	//w papmiIdList,!
	i papmiIdList'="" d
		.f i=1:1:$l(papmiIdList,"^") d
			..s papmiId=$p(papmiIdList,"^",i)
			..q:papmiId=""
			..s bpprId=$o(^DHCBPPatRegister(0,"PaPatMas",papmiId,""))
			..q:bpprId=""
			..s bpaId=""
			..f  s bpaId=$o(^DHCBPArrange(0,"PatRegister",bpprId,bpaId)) q:bpaId=""  d
			...b
			...q:$$GetArrange()<0
			...d OutputRow
	i (regNo'="")!(papmiMedicare'="")!(papmiName'="") Set qHandle=$lb(0,repid,0) Quit $$$OK
 	
	s bpaId=""	
	f curDate=fromDate:1:toDate d
		.s bpaId=""
		.f  s bpaId=$o(^DHCBPArrange(0,"Date",curDate,bpaId)) q:bpaId=""  d
			..q:$$GetArrange()<0
			..d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetArrange()
	q:bpaId="" -1	
	s bpprId=$lg(^DHCBPArrange(bpaId),1)
	q:bpprId="" -2
	s admId=$lg(^DHCBPArrange(bpaId),2)
	i admId="" s admId=$lg(^DHCBPPatRegister(bpprId),26)    
    s bpsId=$lg(^DHCBPArrange(bpaId),3)
    q:bpsId="" -3    
	s bpprStatus=$lg(^DHCBPPatRegister(bpprId),14)
	//q:bpprStatus="D" -4
	i bpprStatus="N" s bpprStatus="治疗"
	i bpprStatus="D" s bpprStatus="转归"	
	s bpprDiagnosis=$lg(^DHCBPPatRegister(bpprId),6)
	s bpprPatBPNo=$lg(^DHCBPPatRegister(bpprId),17)
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	q:papmiId="" -5
	q:'$d(^PAPER(papmiId,"PAT",1)) -6
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	//s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22) //20200515统一走病案接口
	s paadmtype=$p($g(^PAADM(admId)),"^",2)
	s papmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
	s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s patBirth=$p($g(^PAPER(papmiId,"ALL")),"^",6)	//出生日期
	///病人登记时填写的已经透析次数
	s bpprBPCount=+$lg(^DHCBPPatRegister(bpprId),18)
	s bpaDate=$lg(^DHCBPArrange(bpaId),4)
	s bpaTime=$lg(^DHCBPArrange(bpaId),5)
	//w bpaDate_"/"_fromDate_"/"_toDate_"/"_isLocQuery,!
	q:(bpaDate'="")&(toDate'="")&(bpaDate>toDate) -7
	q:(bpaDate'="")&(fromDate'="")&(bpaDate<fromDate) -8
	s patAge=##class(web.DHCClinicCom).CalAge(patBirth,bpaDate)
	s bpaDaySeqNo=""
	s bpaDaySeqNo=$lg(^DHCBPArrange(bpaId),6)	
	s bpaBPCBedDr=$lg(^DHCBPArrange(bpaId),7)
	s bpaBPCBedDesc=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),2)
	s bpaArrangeType=$lg(^DHCBPArrange(bpaId),8)
	s bpaStatus=$lg(^DHCBPArrange(bpaId),9)	
	q:bpaStatus="" -9	
	q:(needBpaStatus'="")&&(needBpaStatus'[bpaStatus) -10
	q:bpaStatus="D" -11
	s bpaStartWeight=$lg(^DHCBPArrange(bpaId),10)
	s bpaSubtractiveWeight=$lg(^DHCBPArrange(bpaId),11)
	s bpaIntakeAmount=$lg(^DHCBPArrange(bpaId),12)
	s bpaPlanDewaterAmount=$lg(^DHCBPArrange(bpaId),13)
	s bpaEndWeight=$lg(^DHCBPArrange(bpaId),14)
	s bpaDewaterAmount=$lg(^DHCBPArrange(bpaId),15)
	s bpaResidualBloodAmount=$lg(^DHCBPArrange(bpaId),17)
	s bpaTherapyTime=$lg(^DHCBPArrange(bpaId),18)
	s bpaFlushPipeNurseCtcpDr=$lg(^DHCBPArrange(bpaId),19)
	s bpaFlushPipeNurseCtcpDesc=##class(web.DHCANOPCom).GetNameById(bpaFlushPipeNurseCtcpDr)
	s bpaPunctureNurseCtcpDr=$lg(^DHCBPArrange(bpaId),20)
	s bpaPunctureNurseCtcpDesc=##class(web.DHCANOPCom).GetNameById(bpaPunctureNurseCtcpDr)
	s bpaCirculatingNurseCtcpDr=$lg(^DHCBPArrange(bpaId),21)
	s bpaCirculatingNurseCtcpDesc=##class(web.DHCANOPCom).GetNameById(bpaCirculatingNurseCtcpDr)
	s bpaJoinPipeNurseCtcpDr=$lg(^DHCBPArrange(bpaId),22)
	s bpaJoinPipeNurseCtcpDesc=##class(web.DHCANOPCom).GetNameById(bpaJoinPipeNurseCtcpDr)
	s bpaCloseNurseCtcpDr=$lg(^DHCBPArrange(bpaId),23)
	s bpaCloseNurseCtcpDesc=##class(web.DHCANOPCom).GetNameById(bpaCloseNurseCtcpDr)
	s bpaVascularAccessSchemeDr=$lg(^DHCBPArrange(bpaId),24)
	;s bpaVascularAccessDesc=$lg($g(^DHCBPC("VascularAccess",+bpaVascularAccessDr)),2)
	s bpaBPCEquipDr=$lg(^DHCBPArrange(bpaId),25)
	s bpaBPCEquipDesc=$lg($g(^DHCBPC("Equip",+bpaBPCEquipDr)),2)
	s bpaBPCBPModeDr=$lg(^DHCBPArrange(bpaId),26)
	s bpaBPCBPModeDesc=$lg($g(^DHCBPC("BloodPurificationMode",+bpaBPCBPModeDr)),2)
	s bpaSecondBPCBPModeDr=$lg(^DHCBPArrange(bpaId),27)
	s bpaSecondBPCBPModeDesc=$lg($g(^DHCBPC("BloodPurificationMode",+bpaSecondBPCBPModeDr)),2)
	s bpaBPCConsumableDr=$lg(^DHCBPArrange(bpaId),29)
	s bpaBPCConsumableDesc=$lg($g(^DHCBPC("Consumable",+bpaBPCConsumableDr)),2)
	s bpaSecondBPCConsumableDr=$lg(^DHCBPArrange(bpaId),30)
	s bpaSecondBPCConsumableDesc=$lg($g(^DHCBPC("Consumable",+bpaSecondBPCConsumableDr)),2)
	s bpaThirdBPCConsumableDr=$lg(^DHCBPArrange(bpaId),31)
	s bpaThirdBPCConsumableDesc=$lg($g(^DHCBPC("Consumable",+bpaThirdBPCConsumableDr)),2)
	s bpaBPCEquipRunModeDr=$lg(^DHCBPArrange(bpaId),32)
	s bpaIsOrdered=$lg(^DHCBPArrange(bpaId),33)
	s bpaCt=$lg(^DHCBPArrange(bpaId),34)
	s bpaAct=$lg(^DHCBPArrange(bpaId),35)
	s bpaOralHematin=$lg(^DHCBPArrange(bpaId),36)
	s bpaInjecHeparin=$lg(^DHCBPArrange(bpaId),37)	
	s bpaNa=$lg(^DHCBPArrange(bpaId),42)
	s bpaK=$lg(^DHCBPArrange(bpaId),43)
	s bpaCa2=$lg(^DHCBPArrange(bpaId),44)
	s bpaHCO3=$lg(^DHCBPArrange(bpaId),45)
	s bpaFilterReplaceMode=$lg(^DHCBPArrange(bpaId),46)
	s bpaFilterReplaceAmount=$lg(^DHCBPArrange(bpaId),47)
	s bpaEquipRunEffect=$lg(^DHCBPArrange(bpaId),48)
	s bpaGrume=$lg(^DHCBPArrange(bpaId),49)
	s bpaPipeGrume=$lg(^DHCBPArrange(bpaId),50)
	s bpaAVFEffect=$lg(^DHCBPArrange(bpaId),51)
	s bpaDindle=$lg(^DHCBPArrange(bpaId),52)
	s bpaJoinDirection=$lg(^DHCBPArrange(bpaId),53)
	s bpaOutletEffect=$lg(^DHCBPArrange(bpaId),54)
	s bpaDocOperateStatus=$lg(^DHCBPArrange(bpaId),55)
	//s tBpprMainDoctorCtcpDr=$lg(^DHCBPArrange(bpprId),10)
	//s tBpprMainDoctorCtcpDesc=$p($g(^CTPCP(+tBpprMainDoctorCtcpDr,1)),"^",2)
	//s tBpprMainNurseCtcpDr=$lg(^DHCBPArrange(bpprId),11)
	//s tBpprMainNurseCtcpDesc=$p($g(^CTPCP(+tBpprMainNurseCtcpDr,1)),"^",2)
	
	///该安排为病人在本血透系统里的第几次透析
	s bpaBPNum=+$lg(^DHCBPArrange(bpaId),56) 
	s bpNum=bpprBPCount+bpaBPNum
	s bpaMeasurePart=$lg(^DHCBPArrange(bpaId),59)
	s bpaTemperature=$lg(^DHCBPArrange(bpaId),60)
	//充水量 
	s bpaReplenishWaterAmount=$lg(^DHCBPArrange(bpaId),61)
	// 透析前舒张压 
    s bpaStartDiastolicPressure=$lg(^DHCBPArrange(bpaId),62)
    // 透析后舒张压
    s bpaEndDiastolicPressure=$lg(^DHCBPArrange(bpaId),63)
    // 透析前收缩压
    s bpaStartSystolicPressure=$lg(^DHCBPArrange(bpaId),64)
    /// 透析后收缩压
    s bpaEndSystolicPressure=$lg(^DHCBPArrange(bpaId),65)
    /// 透析前心率
    s bpaStartHeartRate=$lg(^DHCBPArrange(bpaId),66)
    /// 透析后心率
    s bpaEndHeartRate=$lg(^DHCBPArrange(bpaId),67)
    /// 透析前症状
    s bpaStartSymptom=$lg(^DHCBPArrange(bpaId),68)  
    /// 透析后症状
    s bpaEndSymptom=$lg(^DHCBPArrange(bpaId),69)
    /// 尿量
    s bpaUrineVolume=$lg(^DHCBPArrange(bpaId),70)
    /// 临床评估备注
    s bpaClinicalEvaluationNote=$lg(^DHCBPArrange(bpaId),71)
    /// 单纯超滤量
	s bpaIsolatedUltVolume=$lg(^DHCBPArrange(bpaId),72)
    /// 血流速
    //s bpaBFR=$lg(^DHCBPArrange(bpaId),73) //数据在扩展表
    s bpaBFR=0
    s arrangeExtendId=$o(^DHCBPArrangeExtend(0,"BPACode",bpaId,"BFR",""))
	i (arrangeExtendId'="") d
	.s bpaBFR=$li(^DHCBPArrangeExtend(arrangeExtendId),6)
    /// 血流速备注
    s bpaBFRNote=$lg(^DHCBPArrange(bpaId),74)
    //血管通路码表指针
    s bpaVACDr=$lg(^DHCBPArrange(bpaId),75)
    //血管通路建立部位指针
    s bpaVABodySiteDr=$lg(^DHCBPArrange(bpaId),76)
    //抗凝方案指针
    s bpaAnticoagulantModeDr=$lg(^DHCBPArrange(bpaId),77)
    s AnticoagulantMode=$lg($g(^DHCBPC("AnticoagulantMode",+bpaAnticoagulantModeDr)),2)
    //回输盐水总量
    s bpaReturnSalineAmount=$lg(^DHCBPArrange(bpaId),78) 
    s bpaBPSchemeAdjustment=$lg(^DHCBPArrange(bpaId),79) 
    s bpaPlanTherapyTime=$lg(^DHCBPArrange(bpaId),80)
    s bpaPlanFilterReplaceAmount=$lg(^DHCBPArrange(bpaId),81)
    //透析液流量
    s bpaDFR=$lg(^DHCBPArrange(bpaId),82)
    //血管通路情况
    s bpaVascularAccessStatus=$lg(^DHCBPArrange(bpaId),83)
    s bpaDiseaseTreatment=$lg(^DHCBPArrange(bpaId),84)
    s bpaNote=$lg(^DHCBPArrange(bpaId),85)
    s allConsumable=..GetConsumableString(bpaId,"true")
	s bpaDateTime=""
	i bpaDate'="" d
		.s bpaDateTime=$zd(bpaDate,3)
		.s bpaDateTime=bpaDateTime_" "_$zt(bpaTime)
	i bpaDate'="" d
	.s bpaDate=##class(web.DHCClinicCom).ConvertToDate(bpaDate)
	i bpaTime'="" d
	.s bpaTime=##class(web.DHCClinicCom).ConvertToTime(bpaTime)
	s bpaEndDate = $lg(^DHCBPArrange(bpaId),86)
	i bpaEndDate'="" d
	.s bpaEndDate=##class(web.DHCClinicCom).ConvertToDate(bpaEndDate)
	s bpaEndTime =$lg(^DHCBPArrange(bpaId),87)
	i bpaEndTime'="" d
	.s bpaEndTime=##class(web.DHCClinicCom).ConvertToTime(bpaEndTime)
	s bpaCreateUserDr=$lg(^DHCBPArrange(bpaId),88)
	s bpaCreateDate=$lg(^DHCBPArrange(bpaId),89)
	i bpaCreateDate'="" d
	.s bpaCreateDate=##class(web.DHCClinicCom).ConvertToDate(bpaCreateDate)
	s bpaCreateTime=$lg(^DHCBPArrange(bpaId),90)
	i bpaCreateTime'="" d
	.s bpaCreateTime=##class(web.DHCClinicCom).ConvertToTime(bpaCreateTime)
	s bpaCheckDocDr=$lg(^DHCBPArrange(bpaId),91)
	s bpaCheckDocDesc=""
	i bpaCheckDocDr'="" d
	.s bpaCheckDocDesc=##class(web.DHCBPCom).GetNameById(bpaCheckDocDr) 
	s bpaCheckDate=$lg(^DHCBPArrange(bpaId),92)
	i bpaCheckDate'="" d
	.s bpaCheckDate=##class(web.DHCClinicCom).ConvertToDate(bpaCheckDate)
	s bpaCheckTime=$lg(^DHCBPArrange(bpaId),93)
	i bpaCheckTime'="" d
	.s bpaCheckTime=##class(web.DHCClinicCom).ConvertToTime(bpaCheckTime)
	s bpaRecheckDocDr=$lg(^DHCBPArrange(bpaId),94)
	s bpaRecheckDocDesc=""
	i bpaRecheckDocDr'="" d
	.s bpaRecheckDocDesc=##class(web.DHCBPCom).GetNameById(bpaRecheckDocDr) 
	s bpaRecheckDate=$lg(^DHCBPArrange(bpaId),95)
	i bpaRecheckDate'="" d
	.s bpaRecheckDate=##class(web.DHCClinicCom).ConvertToDate(bpaRecheckDate)
	s bpaRecheckTime=$lg(^DHCBPArrange(bpaId),96)
	i bpaRecheckTime'="" d
	.s bpaRecheckTime=##class(web.DHCClinicCom).ConvertToTime(bpaRecheckTime)
	s bpaWardRoundDocDesc=""
	s bpaWardRoundDocDr=$lg(^DHCBPArrange(bpaId),97)
	i bpaWardRoundDocDr'="" d
	.s bpaWardRoundDocDesc=##class(web.DHCBPCom).GetNameById(bpaWardRoundDocDr) 
	s bpaWardRoundDate=$lg(^DHCBPArrange(bpaId),98)
	i bpaWardRoundDate'="" d
	.s bpaWardRoundDate=##class(web.DHCClinicCom).ConvertToDate(bpaWardRoundDate)
	s bpaWardRoundTime=$lg(^DHCBPArrange(bpaId),99)
	i bpaWardRoundTime'="" d
	.s bpaWardRoundTime=##class(web.DHCClinicCom).ConvertToTime(bpaWardRoundTime)
	s bpaEndUpdateDocDesc=""
	s bpaEndUpdateDocDr=$lg(^DHCBPArrange(bpaId),100)
	i bpaEndUpdateDocDr'="" d
	.s bpaEndUpdateDocDesc=##class(web.DHCBPCom).GetNameById(bpaEndUpdateDocDr) 
	s bpaDocEndUpdateDate=$lg(^DHCBPArrange(bpaId),101)
	i bpaDocEndUpdateDate'="" d
	.s bpaDocEndUpdateDate=##class(web.DHCClinicCom).ConvertToDate(bpaDocEndUpdateDate)
	s bpaDocEndUpdateTime=$lg(^DHCBPArrange(bpaId),102)
	i bpaDocEndUpdateTime'="" d
	.s bpaDocEndUpdateTime=##class(web.DHCClinicCom).ConvertToTime(bpaDocEndUpdateTime)
	s bpaStartOperationNurseDesc=""
	s bpaStartOperationNurseDr=$lg(^DHCBPArrange(bpaId),103)
	i bpaStartOperationNurseDr'="" d
	.s bpaStartOperationNurseDesc=##class(web.DHCBPCom).GetNameById(bpaStartOperationNurseDr) 
	s bpaStartOperationDate=$lg(^DHCBPArrange(bpaId),104)
	i bpaStartOperationDate'="" d
	.s bpaStartOperationDate=##class(web.DHCClinicCom).ConvertToDate(bpaStartOperationDate)
	s bpaStartOperationTime=$lg(^DHCBPArrange(bpaId),105)
	i bpaStartOperationTime'="" d
	.s bpaStartOperationTime=##class(web.DHCClinicCom).ConvertToTime(bpaStartOperationTime)
	s bpaEndOperationNurseDesc=""
	s bpaEndOperationNurseDr=$lg(^DHCBPArrange(bpaId),106)
	i bpaEndOperationNurseDr'="" d
	.s bpaEndOperationNurseDesc=##class(web.DHCBPCom).GetNameById(bpaEndOperationNurseDr) 
	s bpaEndOperationDate=$lg(^DHCBPArrange(bpaId),107)
	i bpaEndOperationDate'="" d
	.s bpaEndOperationDate=##class(web.DHCClinicCom).ConvertToDate(bpaEndOperationDate)
	s bpaEndOperationTime=$lg(^DHCBPArrange(bpaId),108)
	i bpaEndOperationTime'="" d
	.s bpaEndOperationTime=##class(web.DHCClinicCom).ConvertToTime(bpaEndOperationTime)
	s bpaCheckNurseDesc=""
	s bpaCheckNurseDr=$lg(^DHCBPArrange(bpaId),109)
	i bpaCheckNurseDr'="" d
	.s bpaCheckNurseDesc=##class(web.DHCBPCom).GetNameById(bpaCheckNurseDr) 
	s bpaNurseCheckDate=$lg(^DHCBPArrange(bpaId),110)
	i bpaNurseCheckDate'="" d
	.s bpaNurseCheckDate=##class(web.DHCClinicCom).ConvertToDate(bpaNurseCheckDate)
	s bpaNurseCheckTime=$lg(^DHCBPArrange(bpaId),111)
	i bpaNurseCheckTime'="" d
	.s bpaNurseCheckTime=##class(web.DHCClinicCom).ConvertToTime(bpaNurseCheckTime)
	s bpaLaboratoryExamination=$lg(^DHCBPArrange(bpaId),112)
	s bpaOtherSymptoms=$lg(^DHCBPArrange(bpaId),113)
	s bpaDialysisBeforeNote=$lg(^DHCBPArrange(bpaId),114)
	q 0
OutputRow           
	set Data=$lb(bpaId,bpprId,bpsId,admId,regNo,patName,patSex,patAge,bpprDiagnosis,papmiMedicare,bpaBPCBedDr,bpaBPCBedDesc,bpaDate,bpaTime,bpaDaySeqNo,bpaArrangeType,bpaStatus,bpprStatus,bpNum,bpaStartWeight,bpaSubtractiveWeight,bpaEndWeight,bpaIntakeAmount,bpaPlanDewaterAmount,bpaReplenishWaterAmount,bpaDewaterAmount,bpaResidualBloodAmount,bpaTherapyTime,bpaFlushPipeNurseCtcpDr,bpaFlushPipeNurseCtcpDesc,bpaPunctureNurseCtcpDr,bpaPunctureNurseCtcpDesc,bpaCirculatingNurseCtcpDr,bpaCirculatingNurseCtcpDesc,bpaJoinPipeNurseCtcpDr,bpaJoinPipeNurseCtcpDesc,bpaCloseNurseCtcpDr,bpaCloseNurseCtcpDesc,bpaVascularAccessSchemeDr,bpaBPCEquipDr,bpaBPCEquipDesc,bpaBPCBPModeDr,bpaBPCBPModeDesc,bpaSecondBPCBPModeDr,bpaSecondBPCBPModeDesc,bpaCt,bpaAct,bpaBPCEquipRunModeDr,bpaNa,bpaK,bpaCa2,bpaHCO3,bpaTemperature,bpaFilterReplaceMode,bpaFilterReplaceAmount,bpaEquipRunEffect,bpaGrume,bpaPipeGrume,bpaAVFEffect,bpaDindle,bpaJoinDirection,bpaOutletEffect,bpaOralHematin,bpaInjecHeparin,bpprPatBPNo,bpaStartDiastolicPressure,bpaEndDiastolicPressure,bpaStartSystolicPressure,bpaEndSystolicPressure,bpaStartHeartRate,bpaEndHeartRate,bpaStartSymptom,bpaEndSymptom,bpaUrineVolume,bpaClinicalEvaluationNote,bpaIsolatedUltVolume,bpaBFR,bpaBFRNote,bpaVACDr,bpaVABodySiteDr,bpaAnticoagulantModeDr,AnticoagulantMode,bpaReturnSalineAmount,bpaBPSchemeAdjustment,bpaPlanTherapyTime,bpaPlanFilterReplaceAmount,bpaDFR,bpaVascularAccessStatus,allConsumable,bpaNote,bpaDiseaseTreatment,bpaEndDate,bpaEndTime,bpaCreateUserDr,bpaCreateDate,bpaCreateTime,bpaDocOperateStatus,bpaCheckDocDr,bpaCheckDocDesc,bpaCheckDate,bpaCheckTime,bpaRecheckDocDr,bpaRecheckDocDesc,bpaRecheckDate,bpaRecheckTime,bpaWardRoundDocDr,bpaWardRoundDocDesc,bpaWardRoundDate,bpaWardRoundTime,bpaStartOperationNurseDr,bpaStartOperationNurseDesc,bpaStartOperationDate,bpaStartOperationTime,bpaEndOperationNurseDr,bpaEndOperationNurseDesc,bpaEndOperationDate,bpaEndOperationTime,bpaCheckNurseDr,bpaCheckNurseDesc,bpaNurseCheckDate,bpaNurseCheckTime,bpaIsOrdered,bpaMeasurePart,bpaEndUpdateDocDr,bpaDocEndUpdateDate,bpaDocEndUpdateTime,bpaLaboratoryExamination,bpaOtherSymptoms,bpaDialysisBeforeNote)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPArrangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPArrangeExecute ]
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

ClassMethod FindBPArrangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPArrangeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creater:cshq
/// DateTime:2016-4-22
/// Reason:解决多台电脑同时操作多个病人到同一个床位的BUG
/// Input：date:时间 BedId:床位Id time:时间(上午，下午，晚上)
/// Output: 返回病人的登记Id registerId
/// w ##class(web.DHCBPArrange).GetBPArragneregisterId("2016/4/22","6","A")
/// b //w CurDate,BedId,DaySeqNo
/// &sql(select BPA_BPPatRegister_Drinto:registerId from DHC_BP_Arrange where BPA_DaySeqNo=:DaySeqNo and BPA_Date=:Date and BPA_BPCBed_Dr=:BedId)
ClassMethod GetBPArragneregisterId(CurDate As %String, BedId As %String, DaySeqNo As %String) As %String
{
 s registerId=""
 s bpaStatus="D"
 s CurDate=$zdh(CurDate,5)
 &sql(SELECT BPA_BPPatRegister_Dr into:registerId FROM DHC_BP_Arrange WHERE BPA_Date =:CurDate AND BPA_DaySeqNo=:DaySeqNo and BPA_BPCBed_Dr=:BedId and BPA_Status!=:bpaStatus)
 q:registerId="" -1
 q registerId
}

/// 获取安排表和扩展表数据
/// D ##class(%ResultSet).RunQuery("web.DHCBPArrange","FindBPArrangeAndExtend","2017-9-11","2017-9-13","416","")
Query FindBPArrangeAndExtend(fromDate As %String = "", toDate As %String = "", registerId As %String = "", needBpaStatus As %String = "") As %Query(ROWSPEC = "Id,RegisterId,SchemeDetailId,EpisodeId,RegNo,PatName,PatGender,PatAge,PatDiagnosis,MedicareNo,BedId,BedDesc,ArrangeDate,ArrangeTime,DayPartCode,ArrangeType,Status,RegisterStatus,StartWeight,SubtractiveWeight,EndWeight,IntakeAmount,PlanDewaterAmount,DewaterAmount,ResidualBloodAmount,TherapyDuration,DialysisMethodId,DialysisMethodDesc,SecondDialysisMethodId,SecondDialysisMethodDesc,URR,KtV,PreDiaUrea,PostDiaUrea,PCR")
{
}

ClassMethod FindBPArrangeAndExtendExecute(ByRef qHandle As %Binary, fromDate As %String = "", toDate As %String = "", registerId As %String = "", needBpaStatus As %String = "") As %Status
{
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i registerId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s bpprId=registerId
	w bpprId,!
 	s bpaId=""
	f  s bpaId=$o(^DHCBPArrange(0,"PatRegister",bpprId,bpaId)) q:bpaId=""  d
	.q:$$GetArrange()<0
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetArrange()
	q:bpaId="" -1	
	s bpprId=$lg(^DHCBPArrange(bpaId),1)
	s admId=$lg(^DHCBPArrange(bpaId),2)
	i admId="" s admId=$lg(^DHCBPPatRegister(bpprId),26)  
    q:bpprId="" -2
    s bpsId=$lg(^DHCBPArrange(bpaId),3)
    //q:bpsId="" -3  //充分性评估新增，没有保存方案ID  
	s bpprStatus=$lg(^DHCBPPatRegister(bpprId),14)
	i bpprStatus="N" s bpprStatus="治疗"
	i bpprStatus="D" s bpprStatus="转归"	
	s bpprDiagnosis=$lg(^DHCBPPatRegister(bpprId),6)
	s bpprPatBPNo=$lg(^DHCBPPatRegister(bpprId),17)
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	q:papmiId="" -5
	q:'$d(^PAPER(papmiId,"PAT",1)) -6
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	//s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22) //20200515统一走病案接口	
	s paadmtype=$p($g(^PAADM(admId)),"^",2)
	s papmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)	
	s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s patBirth=$p($g(^PAPER(papmiId,"ALL")),"^",6)	//出生日期
	///病人登记时填写的已经透析次数
	s bpprBPCount=+$lg(^DHCBPPatRegister(bpprId),18)
	s bpaDate=$lg(^DHCBPArrange(bpaId),4)
	s bpaTime=$lg(^DHCBPArrange(bpaId),5)
	//w bpaDate_"/"_fromDate_"/"_toDate_"/"_isLocQuery,!
	q:(bpaDate'="")&(toDate'="")&(bpaDate>toDate) -7
	q:(bpaDate'="")&(fromDate'="")&(bpaDate<fromDate) -8
	s patAge=##class(web.DHCClinicCom).CalAge(patBirth,bpaDate)
	s bpaDaySeqNo=""
	s bpaDaySeqNo=$lg(^DHCBPArrange(bpaId),6)	
	s bpaBPCBedDr=$lg(^DHCBPArrange(bpaId),7)
	s bpaBPCBedDesc=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),2)
	s bpaArrangeType=$lg(^DHCBPArrange(bpaId),8)
	s bpaStatus=$lg(^DHCBPArrange(bpaId),9)	
	q:bpaStatus="" -9	
	q:(needBpaStatus'="")&&(needBpaStatus'[bpaStatus) -10
	q:bpaStatus="D" -11
	s bpaStartWeight=$lg(^DHCBPArrange(bpaId),10)
	s bpaSubtractiveWeight=$lg(^DHCBPArrange(bpaId),11)
	s bpaIntakeAmount=$lg(^DHCBPArrange(bpaId),12)
	s bpaPlanDewaterAmount=$lg(^DHCBPArrange(bpaId),13)
	s bpaEndWeight=$lg(^DHCBPArrange(bpaId),14)
	s arrangeExtendId=$o(^DHCBPArrangeExtend(0,"BPACode",bpaId,"PatientEndSubtractiveWeight",""))
	i (arrangeExtendId'="") d
	.s endSubtractiveWeight=$li(^DHCBPArrangeExtend(arrangeExtendId),6)
	.s bpaEndWeight=bpaEndWeight-endSubtractiveWeight
	s bpaDewaterAmount=$lg(^DHCBPArrange(bpaId),15)
	s bpaResidualBloodAmount=$lg(^DHCBPArrange(bpaId),17)
	s bpaTherapyTime=$lg(^DHCBPArrange(bpaId),18)
	s bpaBPCBPModeDr=$lg(^DHCBPArrange(bpaId),26)
	s bpaBPCBPModeDesc=$lg($g(^DHCBPC("BloodPurificationMode",+bpaBPCBPModeDr)),2)
	s bpaSecondBPCBPModeDr=$lg(^DHCBPArrange(bpaId),27)
	s bpaSecondBPCBPModeDesc=$lg($g(^DHCBPC("BloodPurificationMode",+bpaSecondBPCBPModeDr)),2)
	s bpaPreDiaUrea=+$lg(^DHCBPArrange(bpaId),40) 
	s bpaPostDiaUrea=+$lg(^DHCBPArrange(bpaId),41) 
	s bpaURR=+$lg(^DHCBPArrange(bpaId),57) 
	s bpaKTV=+$lg(^DHCBPArrange(bpaId),58) 
	s bpaPCR=+$lg(^DHCBPArrange(bpaId),115)
	w bpaPCR,! 
	i bpaDate'="" d
	.s bpaDate=##class(web.DHCClinicCom).ConvertToDate(bpaDate)
	i bpaTime'="" d
	.s bpaTime=##class(web.DHCClinicCom).ConvertToTime(bpaTime)
	q 0
OutputRow           
	set Data=$lb(bpaId,bpprId,bpsId,admId,regNo,patName,patSex,patAge,bpprDiagnosis,papmiMedicare,bpaBPCBedDr,bpaBPCBedDesc,bpaDate,bpaTime,bpaDaySeqNo,bpaArrangeType,bpaStatus,bpprStatus,bpaStartWeight,bpaSubtractiveWeight,bpaEndWeight,bpaIntakeAmount,bpaPlanDewaterAmount,bpaDewaterAmount,bpaResidualBloodAmount,bpaTherapyTime,bpaBPCBPModeDr,bpaBPCBPModeDesc,bpaSecondBPCBPModeDr,bpaSecondBPCBPModeDesc,bpaURR,bpaKTV,bpaPreDiaUrea,bpaPostDiaUrea,bpaPCR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPArrangeAndExtendFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPArrangeAndExtendExecute ]
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

ClassMethod FindBPArrangeAndExtendClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPArrangeAndExtendExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator: by
/// CreatDate: 2021-11-20
/// Description: 周排班安排床位信息
/// Table：DHC_BP_Arrange
/// Input：要修改的关于周排班安排床位信息
/// Return：修改的DHC_BP_Arrange 表id
ClassMethod SaveBPBedArrangeForWeekly(bedArrangePara As %String) As %String
{
	//s ^TMPzt("SaveBPBedArrange")=bedArrangePara
	//s bedArrangePara=^TMPzt("SaveBPBedArrange")
	q:(bedArrangePara="") "参数为空"
	s arrangeId=$p(bedArrangePara,$c(3),1)
	q:arrangeId="" "安排表id为空"
    s result="",arrange=""
    s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)
    s registerId=$p(bedArrangePara,$c(3),2)
    q:registerId="" "登记表id为空"	    
    i (registerId'="") s arrange.BPABPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId(registerId)
    s arrange.BPAAdmDr=$p(bedArrangePara,$c(3),3) 
    
    s arrangeDate=$p(bedArrangePara,$c(3),5)
	s arrangeDateH=##class(web.DHCClinicCom).ConvertToDateH(arrangeDate)
	s arrangeTime=$p(bedArrangePara,$c(3),6)
	s arrangeTimeH=##class(web.DHCClinicCom).ConvertToTimeH(arrangeTime)
	  
    s daySeqNo=$p(bedArrangePara,$c(3),7)
    i $p(bedArrangePara,$c(3),7)="上午"  s daySeqNo="A"
    i $p(bedArrangePara,$c(3),7)="下午"  s daySeqNo="P"
    i $p(bedArrangePara,$c(3),7)="晚上"  s daySeqNo="E"
    s bedId=$p(bedArrangePara,$c(3),8)
    i bedId="" s ^TMPzt("SaveBPBedArrangeNew")="修改"_"^"_bedArrangePara
    s bedIsArranged=1
    s status=$p(bedArrangePara,$c(3),10)
    i bedId'="" d
    .s bedIsArranged=..GetBedIsArranged(arrangeDate,daySeqNo,bedId)
    e  d 
    .s arrange.BPAStatus="A"  
    .s arrange.BPABPCBedDr=""  
    i 'bedIsArranged d
    .s arrange.BPABPCBedDr=##class(User.DHCBPCBed).%OpenId(bedId)
    .s bpBedEquipDr=$o(^DHCBPBedEquip(0,"Bed",+bedId,"")) //净化设备
    .s bpEquipDr=$lg($g(^DHCBPBedEquip(+bpBedEquipDr)),2)
    .s arrange.BPABPCEquipDr=##class(User.DHCBPCEquip).%OpenId(bpEquipDr)    
    .s arrange.BPAStatus=status   
    .s arrange.BPADate=arrangeDateH
	.s arrange.BPATime=arrangeTimeH
    d arrange.%Save()
    s result=arrange.%Id()
    q result
}

ClassMethod FindBPFirstArrangeSummary(fromDate As %String, toDate As %String, needBpaStatus As %String = "", registerId As %String, arrangeId As %String = "", locId As %String = "", patRegStatus As %String = "") As %Query(ROWSPEC="Id,RegisterId,SchemeDetailId,EpisodeId,RegNo,PatName,PatGender,PatAge,MedicareNo,PatBPNo,BedId,BedDesc,ArrangeDate,ArrangeTime,DayPartCode,ArrangeType,Status,DocOperateStatus,RegisterStatus,DialysisMethodId,DialysisMethodDesc,SecondDialysisMethodId,SecondDialysisMethodDesc,AllConsumable,EquipId,EquipDesc,PatType,SecCode,PatLevel,BedGroupDesc,AnticoagulantModeId")
{
	s ret=""
	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
	s bpaId=arrangeId
	q:bpaId="" ""	
	s bpprId=$lg(^DHCBPArrange(bpaId),1)
	q:bpprId="" ""	
	//;s admId=$lg(^DHCBPArrange(bpaId),2)
	s admId=$lg(^DHCBPPatRegister(bpprId),26)
	q:admId="" ""
	s admDeptId=$p($g(^PAADM(admId)),"^",4)
	;s bpprPatDeptDr=$lg(^DHCBPPatRegister(bpprId),30)
	s bpprPatLocationDr=$lg(^DHCBPPatRegister(bpprId),34)	
    q:((locId'="")&&(bpprPatLocationDr'="")&&($p($g(^CTLOC(locId)),"^",22)'=$p($g(^CTLOC(bpprPatLocationDr)),"^",22))) -3 //病人所在医院判断
    q:(bpprPatLocationDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_bpprPatLocationDr_"^")) ""
    s bpsId=$lg(^DHCBPArrange(bpaId),3)
    q:bpsId="" ""   
	s bpprStatus=$lg(^DHCBPPatRegister(bpprId),14)
	//;i bpprId=118 w bpprStatus_"/"_patRegStatus,!
	q:(arrangeId="")&&(patRegStatus'="")&&("^"_patRegStatus_"^"'[bpprStatus) -5 //通过ArrangeId查询某个病人,不再判断方案状态
	
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	q:papmiId="" ""
	q:'$d(^PAPER(papmiId,"PAT",1)) ""
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s bpaStatus=$lg(^DHCBPArrange(bpaId),9)	
	q:bpaStatus="" -10	
	q:(needBpaStatus'="")&&(needBpaStatus'[bpaStatus) -11
	q:bpaStatus="D" ""
	s bpaDocOperateStatus=$lg(^DHCBPArrange(bpaId),55)
	s bpaBPCBPModeDr=$lg(^DHCBPArrange(bpaId),26)
	s bpaBPCBPModeDesc=$lg($g(^DHCBPC("BloodPurificationMode",+bpaBPCBPModeDr)),2)
	s bpaSecondBPCBPModeDr=$lg(^DHCBPArrange(bpaId),27)
	s bpaSecondBPCBPModeDesc=$lg($g(^DHCBPC("BloodPurificationMode",+bpaSecondBPCBPModeDr)),2)
	s ret=patName_" "_bpaBPCBPModeDesc
	q ret
}

/// Creator: MFC
/// CreatDate: 2022-04-26
/// Description: 当前班次再次透析安排，要求：床位维护为O占用
/// Table：DHC_BP_Arrange，透析器材DHC_BP_ArrangeConsumable，抗凝DHC_BP_ArrangeAnticoagulantDrug，设备参数DHC_BP_ArrangeEquipRunPara
/// Input：透析安排arrangePara，透析器材consumableBusinessPara，抗凝anticoagulantDrugBusinessPara，设备参数equipRunParaBusinessPara
/// Return：透析安排DHC_BP_Arrange表id
ClassMethod SaveAgainDialysisArrange(arrangePara As %String, consumableBusinessPara As %String, anticoagulantDrugBusinessPara As %String, equipRunParaBusinessPara As %String) As %String
{
	s arrangeId=$p(arrangePara,$c(3),1)
	s registerId=$p(arrangePara,$c(3),2)
	q:registerId="" -1
	s schemeId=$p(arrangePara,$c(3),4)
	q:schemeId="" "未制定透析方案不能进行透析安排"
	s arrangeDate=$p(arrangePara,$c(3),5)
	s arrangeDateH=##class(web.DHCClinicCom).ConvertToDateH(arrangeDate)
	s arrangeTime=$p(arrangePara,$c(3),6)
	s arrangeTimeH=##class(web.DHCClinicCom).ConvertToTimeH(arrangeTime)
	s daySeqCode=$p(arrangePara,$c(3),7)
	s bpprPatLocationDr=$lg(^DHCBPPatRegister(registerId),34)
	s bpaId=""
	f  s bpaId=$o(^DHCBPArrange(0,"Date",arrangeDateH,bpaId)) q:bpaId=""  d //占用床位
		.s tmpbpprId=$lg(^DHCBPArrange(bpaId),1)
		.s bpaStatus=$lg(^DHCBPArrange(bpaId),9)
		.q:bpaStatus="D"
		.s bpaDaySeqNo=$lg(^DHCBPArrange(bpaId),6) //班次
		.q:(daySeqCode'="")&&(daySeqCode'=bpaDaySeqNo)
		.s bpaBedDr=$lg(^DHCBPArrange(bpaId),7) //安排床位
		.q:(bpaBedDr="")||(bpaBedDr=0) 
		.s bpaBedStat=$lg($g(^DHCBPC("Bed",+bpaBedDr)),4) //被占用床位(床位维护为O占用)
		.q:bpaBedStat'="O"
		.s bpaBedGroupDr=$lg(^DHCBPC("Bed",+bpaBedDr),3) //床位组
		.s bpaBedLocationDr=$lg(^DHCBPC("BedGroup",+bpaBedGroupDr),3)
		.q:bpprPatLocationDr'=bpaBedLocationDr
		.s ^DHCBPAgainDialysisBedList($j,bpaBedDr)=bpaBedGroupDr	

	s defaultBedId="" //床位组的起始床位(滤过、普通透析)		
	&sql(select a.BPCB_RowId into :defaultBedId from DHC_BPC_Bed a,DHC_BPC_BedGroup b where a.BPCB_BPCBedGroup_Dr=b.BPCBG_RowId and a.BPCB_Status='O' and b.BPCBG_Location_Dr=:bpprPatLocationDr)
	
	s predictBedId="" //安排床位
	s firstBedId=$o(^DHCBPAgainDialysisBedList($j,"")) //占用床起始值
	i (firstBedId="") d
		.//s ^tmpmfcbp("2022",1)=firstBedId_"/"_defaultBedId
		.s predictBedId=defaultBedId //组内起始直接分配
	e  d
		.s predictBedId=##Class(web.DHCBPArrange).AgainDialysisBedIdByBedGroup(bpprPatLocationDr)
		.//s ^tmpmfcbp("2022",2)=firstBedId_"/"_predictBedId_"/"_bpprPatLocationDr
	i predictBedId=""  k ^DHCBPAgainDialysisBedList($j) q "没有可安排的床位!"
    
    i (arrangeId="") s arrange=##class(User.DHCBPArrange).%New()
    e  s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)    
    i (registerId'="") s arrange.BPABPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId(registerId)
    i schemeId'="" s arrange.BPABPSchemeDr=##class(User.DHCBPScheme).%OpenId(schemeId)
	s arrange.BPADate=arrangeDateH
	s arrange.BPATime=arrangeTimeH
	s arrange.BPADaySeqNo=daySeqCode
	s arrange.BPAArrangeType=$p(arrangePara,$c(3),9)
	s status=$p(arrangePara,$c(3),10)
	s arrange.BPAStatus=status
	i predictBedId'="" s arrange.BPABPCBedDr=##class(User.DHCBPCBed).%OpenId(predictBedId)	
    s arrange.BPAStartWeight=$p(arrangePara,$c(3),11)
    s arrange.BPASubtractiveWeight=$p(arrangePara,$c(3),12)
    s arrange.BPAIntakeAmount=$p(arrangePara,$c(3),13)
    s arrange.BPAPlanDewaterAmount=$p(arrangePara,$c(3),14)
    s arrange.BPADewaterAmount=$p(arrangePara,$c(3),16)
    s arrange.BPAFoodIntakeAmount=$p(arrangePara,$c(3),17)
    s arrange.BPAResidualBloodAmount=$p(arrangePara,$c(3),18)
    s arrange.BPAPlanTherapyDuration=$p(arrangePara,$c(3),81)
    s vascularAccessSchemeId=$p(arrangePara,$c(3),25)
    i vascularAccessSchemeId'="" s arrange.BPAVascularAccessDr=##class(User.DHCBPCVascularAccess).%OpenId(vascularAccessSchemeId)
    s equipId=$p(arrangePara,$c(3),26)
    i equipId'="" s arrange.BPABPCEquipDr=##class(User.DHCBPCEquip).%OpenId(equipId)
    s modeId=$p(arrangePara,$c(3),27)
    i modeId'="" s arrange.BPABPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(modeId)
    s secondModeId=$p(arrangePara,$c(3),28)
    s arrange.BPASecondBPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(secondModeId)
    s thirdModeId=$p(arrangePara,$c(3),29)
    s arrange.BPAThirdBPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(thirdModeId)
    s consumableId=$p(arrangePara,$c(3),30)
    s arrange.BPABPCConsumableDr=##class(User.DHCBPCConsumable).%OpenId(consumableId)
    s secondConsumableId=$p(arrangePara,$c(3),31)
    s arrange.BPASecondBPCConsumableDr=##class(User.DHCBPCConsumable).%OpenId(secondConsumableId)
    s thirdConsumableId=$p(arrangePara,$c(3),32)
    s arrange.BPAThirdBPCConsumableDr=##class(User.DHCBPCConsumable).%OpenId(thirdConsumableId)
    s equipRunModeId=$p(arrangePara,$c(3),33)
    i equipRunModeId'="" s arrange.BPABPCEquipRunModeDr=equipRunModeId
    s arrange.BPAOrdered=$p(arrangePara,$c(3),34)
    s arrange.BPACt=$p(arrangePara,$c(3),35)
    s arrange.BPAAct=$p(arrangePara,$c(3),36)
    s arrange.BPAOralHematin=$p(arrangePara,$c(3),37)
    s arrange.BPAInjectHematin=$p(arrangePara,$c(3),38)
    s arrange.BPAHeparin=$p(arrangePara,$c(3),39)
    s arrange.BPANa=$p(arrangePara,$c(3),43)
    s arrange.BPAK=$p(arrangePara,$c(3),44)
    s arrange.BPACa2=$p(arrangePara,$c(3),45)
    s arrange.BPAHCO3=$p(arrangePara,$c(3),46)
    s arrange.BPAFilterReplaceMode=$p(arrangePara,$c(3),47)
    //s arrange.BPAFilterReplaceAmount=$p(arrangePara,$c(3),48) 
    s arrange.BPAPlanFilterReplaceAmount=$p(arrangePara,$c(3),82)
    s arrange.BPABPMeasurePart=$p(arrangePara,$c(3),60)
    s arrange.BPATemperature=$p(arrangePara,$c(3),61)
    //充水量 
    s arrange.BPAReplenishWaterAmount=$p(arrangePara,$c(3),62)
     // 透析前舒张压
    s arrange.BPAStartDiastolicPressure=$p(arrangePara,$c(3),63)   
    // 透析前收缩压
    s arrange.BPAStartSystolicPressure=$p(arrangePara,$c(3),65)   
    /// 透析前心率
    s arrange.BPAStartHeartRate=$p(arrangePara,$c(3),67)
    /// 透析前症状
    s arrange.BPAStartSymptom=$p(arrangePara,$c(3),69)   
    /// 尿量
    s arrange.BPAUrineVolume=$p(arrangePara,$c(3),71)
    /// 临床评估备注
    s arrange.BPAClinicalEvaluationNote=$p(arrangePara,$c(3),72)
    /// 单纯超滤量
    s arrange.BPAIsolatedUltVolume=$p(arrangePara,$c(3),73)
    /// 血流速
    s arrange.BPABFR=$p(arrangePara,$c(3),74)
    /// 血流速备注
    s arrange.BPABFRNote=$p(arrangePara,$c(3),75)
    //血管通路码表指针
    s vascularAccessId=$p(arrangePara,$c(3),76)
    i vascularAccessId'="" s arrange.BPABPCVADr=##class(User.DHCBPCVascularAccess).%OpenId(vascularAccessId)
    //血管通路建立部位指针
    s arrange.BPAVABodySiteDr=$p(arrangePara,$c(3),77)
    //抗凝方案指针
    s anticoagulantModeId=$p(arrangePara,$c(3),78)
    i anticoagulantModeId'="" s arrange.BPAAnticoagulantModeDr=##class(User.DHCBPCAnticoagulantMode).%OpenId(anticoagulantModeId)
    s docOperateStatus=$p(arrangePara,$c(3),56)
    s arrange.BPADocOperateStatus=docOperateStatus
    //保存医生和状态
    i docOperateStatus="C"
    {
     s arrange.BPACheckDocDr=$p(arrangePara,$c(3),92)
     s updateDate=$p(arrangePara,$c(3),93)
     i updateDate'="" s arrange.BPACheckDate=##class(web.DHCClinicCom).ConvertToDateH(updateDate)
     s updateTime=$p(arrangePara,$c(3),94)
     i updateTime'="" s arrange.BPACheckTime= ##class(web.DHCClinicCom).ConvertToTimeH(updateTime)
     s status=$p(arrangePara,$c(3),10)
     s num=..SaveBPNum(status,arrangeId)
    }
    //i arrange.BPADocOperateStatus'="R" s arrange.BPADocOperateStatus=docOperateStatus //防止复核状态变回保存
    /// 透析前治疗备注
    s arrange.BPADialysisBeforeNote=$p(arrangePara,$c(3),114)
    s arrange.BPACreateUserDr=$p(arrangePara,$c(3),89)
	s arrange.BPACreateDate=+$h
	s arrange.BPACreateTime=$p($h,",",2)    
    d arrange.%Save()
    s rowId=arrange.%Id()
   
    s result=..SaveArrangeConsumableList(rowId,consumableBusinessPara)
    i +result'=1 q "保存透析耗材错误"

    s result=..SaveArrangeAntDrugList(rowId,anticoagulantDrugBusinessPara)
    i +result'=1 q "保存抗凝药品错误"

    s result=..SaveArrangeEquipRunParaList(rowId,equipRunParaBusinessPara)
    i +result'=1 q "保存透析设备参数错误"   


    k ^DHCBPAgainDialysisBedList($j)
	q rowId
}

/// 获取没有占用空床床位
/// patLocationDr病区ID
/// w ##Class(web.DHCBPArrange).AgainDialysisBedIdByBedGroup("")
ClassMethod AgainDialysisBedIdByBedGroup(patLocationDr As %String = "") As %String
{
	
	s predictBedId="",effectiveBedId=""
	&sql(declare C1 cursor for select a.BPCB_RowId into :effectiveBedId from DHC_BPC_Bed a,DHC_BPC_BedGroup b where a.BPCB_BPCBedGroup_Dr=b.BPCBG_RowId and a.BPCB_Status='O' and b.BPCBG_Location_Dr=:patLocationDr)
	&sql(open C1)
	&sql(fetch C1) 
	while(SQLCODE=0)  
	{	
	  s bpaIsEexist=$g(^DHCBPAgainDialysisBedList(+$j,effectiveBedId)) //床位是否占用
	  s bpaBedGroupDr=$lg(^DHCBPC("Bed",+effectiveBedId),3) //床位组
	  s bpaBedIsVisible=$lg(^DHCBPC("BedGroup",+bpaBedGroupDr),5)
	  q:bpaBedIsVisible=1
	  i (bpaIsEexist="") s predictBedId=effectiveBedId
	  q:predictBedId'=""
	  &sql(fetch C1)
	}
	&sql(close C1)
	q predictBedId
}

}
