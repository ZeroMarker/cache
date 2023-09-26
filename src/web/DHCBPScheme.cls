Import SQLUser

Class web.DHCBPScheme Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Query FindBPSchemeList(registerId As %String) As %SQLQuery(CONTAINID = 1)
{
	   
       SELECT %ID As Id,
	   BPS_BPRegister_Dr As RegisterId,
	   BPS_WeekNum As WeekNum,
	   BPS_PatDryWeight As PatientDryWeight,
	   BPS_MaxDeWaterAmount As MaxDewaterAmount,
	   BPS_NetDeWaterAmount As NetDewaterAmount,
	   BPS_FoodIntakeAmount As FoodIntakeAmount,
	   BPS_ResidualBloodAmount As ResidualBloodAmount,
	   BPS_VascularAccess_Dr As VascularAccessSchemeId,
	   BPS_BPCEquipModel_Dr As EquipModelId,
	   BPS_BPCBPMode_Dr As DialysisMethodId,
	   BPS_SecondBPCBPMode_Dr As SecondDialysisMethodId,
	   BPS_ThirdBPCBPMode_Dr As ThirdDialysisMethodId,
	   BPS_BPCConsumable_Dr As ConsumableId,
	   BPS_SecondBPCConsumable_Dr As SecondConsumableId,
	   BPS_ThirdBPCConsumable_Dr As ThirdConsumableId,
	   BPS_TherapyDuration As TherapyDuration,
	   BPS_AnticoagulantMode_Dr As AnticoagulantModeId,
	   BPS_BPCEquipRunPara_Dr As EquipRunModeId,
	   BPS_FilterReplaceMode As FilterReplaceMode,
	   BPS_FilterReplaceAmount As FilterReplaceAmount,
	   BPS_OralHematin As OralHematin,
	   BPS_InjectHematin As InjectHematin,
	   BPS_Na As Na,
	   BPS_K As K,
	   BPS_Ca2 As Ca2,
	   BPS_HCO3 As HCO3,
	   BPS_BFR As BFR,
	   BPS_BFRNote As BFRNote,
	   BPS_Note As Note,
	   BPS_StartDate As StartDate,
	   BPS_EndDate As EndDate,
	   BPS_UpdateUser_Dr As UpdateUserId,
	   BPS_UpdateDate As UpdateDate,
	   BPS_UpdateTime As UpdateTime,
	   BPS_FirstHeparinAmount As FirstHeparinAmount,
	   BPS_HeparinDose As HeparinDose,
	   BPS_ProtamineAmount As ProtamineAmount,
	   BPS_LowMoleHeparinAmount As LowMoleHeparinAmount,
	   BPS_SubtractiveWeight As SubtractiveWeight,
	   BPS_SalineDose As SalineDose,
	   BPS_PFR As PFR,
	   BPS_DFR As DFR,
	   BPS_ObjectiveClearAmount As ObjectiveClearAmount,
	   BPS_ResidualPlasmaAmount As ResidualPlasmaAmount,
	   BPS_ResidualSalineAmount As ResidualSalineAmount,
	   BPS_ResidualAlbuminAmount As ResidualAlbuminAmount,
	   BPS_SalineGlucoseDrug As SalineGlucoseDrug,
	   BPS_KCL As KCL,
	   BPS_NaHCO3 As NaHCO3,
	   BPS_RP As RP,
	   BPS_DialysateAmount As DialysateAmount,
	   BPS_AntContraindication As AntContraindication,
	   BPS_AntContraindicationNote As AntContraindicationNote
	   FROM DHC_BP_Scheme
	   WHERE BPS_BPRegister_Dr=:registerId
}

/// 获取当前有效的透析方案(过滤掉停止的方案)
/// registerId：病人登记ID
/// add mfc 20200911 优化处理
Query FindBPCurSchemeList(registerId As %String) As %SQLQuery(CONTAINID = 1)
{
	   
       SELECT %ID As Id,
	   BPS_BPRegister_Dr As RegisterId,
	   BPS_WeekNum As WeekNum,
	   BPS_PatDryWeight As PatientDryWeight,
	   BPS_MaxDeWaterAmount As MaxDewaterAmount,
	   BPS_NetDeWaterAmount As NetDewaterAmount,
	   BPS_FoodIntakeAmount As FoodIntakeAmount,
	   BPS_ResidualBloodAmount As ResidualBloodAmount,
	   BPS_VascularAccess_Dr As VascularAccessSchemeId,
	   BPS_BPCEquipModel_Dr As EquipModelId,
	   BPS_BPCBPMode_Dr As DialysisMethodId,
	   BPS_SecondBPCBPMode_Dr As SecondDialysisMethodId,
	   BPS_ThirdBPCBPMode_Dr As ThirdDialysisMethodId,
	   BPS_BPCConsumable_Dr As ConsumableId,
	   BPS_SecondBPCConsumable_Dr As SecondConsumableId,
	   BPS_ThirdBPCConsumable_Dr As ThirdConsumableId,
	   BPS_TherapyDuration As TherapyDuration,
	   BPS_AnticoagulantMode_Dr As AnticoagulantModeId,
	   BPS_BPCEquipRunPara_Dr As EquipRunModeId,
	   BPS_FilterReplaceMode As FilterReplaceMode,
	   BPS_FilterReplaceAmount As FilterReplaceAmount,
	   BPS_OralHematin As OralHematin,
	   BPS_InjectHematin As InjectHematin,
	   BPS_Na As Na,
	   BPS_K As K,
	   BPS_Ca2 As Ca2,
	   BPS_HCO3 As HCO3,
	   BPS_BFR As BFR,
	   BPS_BFRNote As BFRNote,
	   BPS_Note As Note,
	   BPS_StartDate As StartDate,
	   BPS_EndDate As EndDate,
	   BPS_UpdateUser_Dr As UpdateUserId,
	   BPS_UpdateDate As UpdateDate,
	   BPS_UpdateTime As UpdateTime,
	   BPS_FirstHeparinAmount As FirstHeparinAmount,
	   BPS_HeparinDose As HeparinDose,
	   BPS_ProtamineAmount As ProtamineAmount,
	   BPS_LowMoleHeparinAmount As LowMoleHeparinAmount,
	   BPS_SubtractiveWeight As SubtractiveWeight,
	   BPS_SalineDose As SalineDose,
	   BPS_PFR As PFR,
	   BPS_DFR As DFR,
	   BPS_ObjectiveClearAmount As ObjectiveClearAmount,
	   BPS_ResidualPlasmaAmount As ResidualPlasmaAmount,
	   BPS_ResidualSalineAmount As ResidualSalineAmount,
	   BPS_ResidualAlbuminAmount As ResidualAlbuminAmount,
	   BPS_SalineGlucoseDrug As SalineGlucoseDrug,
	   BPS_KCL As KCL,
	   BPS_NaHCO3 As NaHCO3,
	   BPS_RP As RP,
	   BPS_DialysateAmount As DialysateAmount,
	   BPS_AntContraindication As AntContraindication,
	   BPS_AntContraindicationNote As AntContraindicationNote
	   FROM DHC_BP_Scheme
	   WHERE BPS_BPRegister_Dr=:registerId and BPS_EndDate="2980013"
}

Query GetBPScheme(schemeId As %String) As %SQLQuery(CONTAINID = 1)
{
       SELECT %ID As Id,
	   BPS_BPRegister_Dr As RegisterId,
	   BPS_WeekNum As WeekNum,
	   BPS_PatDryWeight As PatientDryWeight,
	   BPS_MaxDeWaterAmount As MaxDewaterAmount,
	   BPS_NetDeWaterAmount As NetDewaterAmount,
	   BPS_FoodIntakeAmount As FoodIntakeAmount,
	   BPS_ResidualBloodAmount As ResidualBloodAmount,
	   BPS_VascularAccess_Dr As VascularAccessSchemeId,
	   BPS_BPCEquipModel_Dr As EquipModelId,
	   BPS_BPCBPMode_Dr As DialysisMethodId,
	   BPS_SecondBPCBPMode_Dr As SecondDialysisMethodId,
	   BPS_ThirdBPCBPMode_Dr As ThirdDialysisMethodId,
	   BPS_BPCConsumable_Dr As ConsumableId,
	   BPS_SecondBPCConsumable_Dr As SecondConsumableId,
	   BPS_ThirdBPCConsumable_Dr As ThirdConsumableId,
	   BPS_TherapyDuration As TherapyDuration,
	   BPS_AnticoagulantMode_Dr As AnticoagulantModeId,
	   BPS_BPCEquipRunPara_Dr As EquipRunModeId,
	   BPS_FilterReplaceMode As FilterReplaceMode,
	   BPS_FilterReplaceAmount As FilterReplaceAmount,
	   BPS_OralHematin As OralHematin,
	   BPS_InjectHematin As InjectHematin,
	   BPS_Na As Na,
	   BPS_K As K,
	   BPS_Ca2 As Ca2,
	   BPS_HCO3 As HCO3,
	   BPS_BFR As BFR,
	   BPS_BFRNote As BFRNote,
	   BPS_Note As Note,
	   BPS_StartDate As StartDate,
	   BPS_EndDate As EndDate,
	   BPS_UpdateUser_Dr As UpdateUserId,
	   BPS_UpdateDate As UpdateDate,
	   BPS_UpdateTime As UpdateTime,
	   BPS_FirstHeparinAmount As FirstHeparinAmount,
	   BPS_HeparinDose As HeparinDose,
	   BPS_ProtamineAmount As ProtamineAmount,
	   BPS_LowMoleHeparinAmount As LowMoleHeparinAmount,
	   BPS_SubtractiveWeight As SubtractiveWeight,
	   BPS_SalineDose As SalineDose,
	   BPS_PFR As PFR,
	   BPS_DFR As DFR,
	   BPS_ObjectiveClearAmount As ObjectiveClearAmount,
	   BPS_ResidualPlasmaAmount As ResidualPlasmaAmount,
	   BPS_ResidualSalineAmount As ResidualSalineAmount,
	   BPS_ResidualAlbuminAmount As ResidualAlbuminAmount,
	   BPS_SalineGlucoseDrug As SalineGlucoseDrug,
	   BPS_KCL As KCL,
	   BPS_NaHCO3 As NaHCO3,
	   BPS_RP As RP,
	   BPS_DialysateAmount As DialysateAmount,
	   BPS_AntContraindication As AntContraindication,
	   BPS_AntContraindicationNote As AntContraindicationNote
	   FROM DHC_BP_Scheme
	   WHERE %ID=:schemeId
}

// 

ClassMethod FindSchemeTemplatesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSchemeTemplatesExecute ]
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

ClassMethod FindSchemeTemplatesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSchemeTemplatesExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

// w ##class(web.DHCBPScheme).SaveScheme("","","")

ClassMethod SaveScheme(schemePara, arrangeSchemePara, equipRunParaBusinessPara) As %String
{
	;s ^DHCBPTMPzt("schemePara")=schemePara
    ;s ^DHCBPTMPzt("arrangeSchemePara")=arrangeSchemePara
	;s ^DHCBPTMPzt("equipRunParaBusinessPara")=equipRunParaBusinessPara	
	s result=0
	TSTART
    s schemeObj=..CreateScheme(schemePara)
	d schemeObj.%Save()
	s schemeId=schemeObj.%Id()
	s schemeEndDate=schemeObj.BPSEndDate
	d schemeObj.%Close()
	i schemeEndDate'="2980013" d
	.&sql(update DHC_BP_Arrange set BPA_Status='D' where BPA_Date>:schemeEndDate and BPA_BPScheme_Dr=:schemeId and (BPA_Status='A' OR BPA_Status='R'))
	i schemeEndDate'="2980013" TCOMMIT  q schemeId	
	s result=##class(web.DHCBPArrangeScheme).SaveArrangeScheme(arrangeSchemePara,schemeId)
	i +result'=1 TROLLBACK  q result
	s result=..SaveSchemeEquipRunPara(schemeId,equipRunParaBusinessPara)
	b ;out 3
	i +result'=1 TROLLBACK  q result
	TCOMMIT
	s result=schemeId
	q result
}

ClassMethod SaveSchemeEquipRunPara(schemeId, paraStr)
{
	q:schemeId="0" 0
	s curDate=+$h
	s curTime=$p($h,",",2)
	b ;equip1
	&sql(update DHC_BP_SchemeEquipRunPara set BPSERP_IfAbandon='Y' where BPSERP_Parref=:schemeId)
	;&sql(delete from DHC_BP_SchemeEquipRunPara where BPSERP_Parref=:schemeId)
	b ;equip2
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
	..&sql(insert into DHC_BP_SchemeEquipRunPara (BPSERP_Parref,BPSERP_BPCERP_Dr,BPSERP_MinValue,BPSERP_MaxValue,BPSERP_Value,BPSERP_IfAbandon,BPSERP_OperationDate,BPSERP_OperationTime) values(:schemeId,:equipRunParaId,:minValue,:maxValue,:value,'N',:curDate,:curTime))
    .e  d
    ..&sql(update DHC_BP_SchemeEquipRunPara set BPSERP_Parref=:schemeId,BPSERP_BPCERP_Dr=:equipRunParaId,BPSERP_MinValue=:minValue,BPSERP_MaxValue=:maxValue,BPSERP_Value=:value,BPSERP_IfAbandon='N',BPSERP_OperationDate=:curDate,BPSERP_OperationTime=:curTime where BPSERP_RowId=:id)
    b ;equip3
    i (SQLCODE'=0)&(SQLCODE'=100) q SQLCODE
	q 1
}

/// w ##Class(web.DHCBPScheme).CreateScheme("dd")
ClassMethod CreateScheme(singleSchemePara As %String) As User.DHCBPScheme
{
	s schemeId=$p(singleSchemePara,$c(3),1)
	s scheme=""
	q:(singleSchemePara="") scheme
	i schemeId="" s scheme=##class(User.DHCBPScheme).%New()
	e  s scheme=##class(User.DHCBPScheme).%OpenId(schemeId)
	s templateName=$p(singleSchemePara,$c(3),35)
	s registerId=$p(singleSchemePara,$c(3),2)
	i registerId'="" s scheme.BPSBPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId(registerId)
	e  d
	.i $d(^DHCBPScheme(0,"Template"," "_templateName)) d
	..s schemeId=$o(^DHCBPScheme(0,"Template"," "_templateName,""))
	..s scheme=##class(User.DHCBPScheme).%OpenId(schemeId)
	s startDate=$p(singleSchemePara,$c(3),3)
	i startDate'="" s scheme.BPSStartDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=$p(singleSchemePara,$c(3),4)
	i endDate'="" s scheme.BPSEndDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s scheme.BPSWeekNum=+$p(singleSchemePara,$c(3),5)
	s scheme.BPSPatDryWeight=+$p(singleSchemePara,$c(3),6)
	s scheme.BPSMaxDewaterAmount=+$p(singleSchemePara,$c(3),7)
	s scheme.BPSNetDewaterAmount=+$p(singleSchemePara,$c(3),8)
	s scheme.BPSFoodIntakeAmount=+$p(singleSchemePara,$c(3),9)
	s scheme.BPSResidualBloodAmount=+$p(singleSchemePara,$c(3),10)
	s vascularAccessId=$p(singleSchemePara,$c(3),11)
	i vascularAccessId'="" s scheme.BPSVascularAccessDr=##class(User.DHCBPVascularAccess).%OpenId(vascularAccessId)
	s equipModelId=$p(singleSchemePara,$c(3),12)
	i equipModelId'="" s scheme.BPSBPCEquipModelDr=##class(User.DHCBPCEquipModel).%OpenId(equipModelId)
	s dialysisMethodId=$p(singleSchemePara,$c(3),13)
	i dialysisMethodId'="" s scheme.BPSBPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(dialysisMethodId)
	s secondDialysisMethodId=$p(singleSchemePara,$c(3),14)
	i secondDialysisMethodId'="" s scheme.BPSSecondBPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(secondDialysisMethodId)
	s thirdDialysisMethodId=$p(singleSchemePara,$c(3),15)
	i thirdDialysisMethodId'="" s scheme.BPSThirdBPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(thirdDialysisMethodId)
	s consumableId=$p(singleSchemePara,$c(3),16)
	i consumableId'="" s scheme.BPSBPCConsumableDr=##class(User.DHCBPCConsumable).%OpenId(consumableId)
	s secondConsumableId=$p(singleSchemePara,$c(3),17)
	i secondConsumableId'="" s scheme.BPSBPCConsumableDr=##class(User.DHCBPCConsumable).%OpenId(secondConsumableId)
	s thirdConsumableId=$p(singleSchemePara,$c(3),18)
	i thirdConsumableId'="" s scheme.BPSBPCConsumableDr=##class(User.DHCBPCConsumable).%OpenId(thirdConsumableId)
	s therapyDuration=$p(singleSchemePara,$c(3),19)
	i therapyDuration'="" s scheme.BPSTherapyDuration=##class(web.DHCANOPCom).ConvertToDateH(therapyDuration)
	s anticoagulantModeId=$p(singleSchemePara,$c(3),20)
	i anticoagulantModeId'="" s scheme.BPSAnticoagulantModeDr=##class(User.DHCBPCAnticoagulantMode).%OpenId(anticoagulantModeId)
	s scheme.BPSFirstHeparinAmount=+$p(singleSchemePara,$c(3),21) //首推
	s scheme.BPSHeparinDose=+$p(singleSchemePara,$c(3),22)  //维持剂量
	s scheme.BPSProtamineAmount=+$p(singleSchemePara,$c(3),23) //鱼精蛋白
	s scheme.BPSLowMoleHeparinAmount=+$p(singleSchemePara,$c(3),24) //低分子肝素量
	;s equipRunModeId=$p(singleSchemePara,$c(3),25)
	;i equipRunModeId'="" s scheme.BPSBPCEquipRunModeDr=equipRunModeId //2013.11.22
	s scheme.BPSFilterReplaceMode=$p(singleSchemePara,$c(3),26)
	s scheme.BPSFilterReplaceAmount=+$p(singleSchemePara,$c(3),27)
	s scheme.BPSOralHematin=+$p(singleSchemePara,$c(3),28)
	s scheme.BPSInjectHematin=+$p(singleSchemePara,$c(3),29)
	s scheme.BPSNa=+$p(singleSchemePara,$c(3),30)
	s scheme.BPSK=+$p(singleSchemePara,$c(3),31)
	s scheme.BPSCa2=+$p(singleSchemePara,$c(3),32)
	s scheme.BPSHCO3=+$p(singleSchemePara,$c(3),33)
	s scheme.BPSBFR=+$p(singleSchemePara,$c(3),34)
	s scheme.BPSBFRNote=$p(singleSchemePara,$c(3),35)
	s scheme.BPSNote=$p(singleSchemePara,$c(3),36)
	s scheme.BPSTemplateName=$p(singleSchemePara,$c(3),37)
	s scheme.BPSUpdateUserDr=$p(singleSchemePara,$c(3),38)
	s updateDate=$p(singleSchemePara,$c(3),39)
	i updateDate'="" s scheme.BPSUpdateDate=##class(web.DHCANOPCom).ConvertToDateH(updateDate)
	s updateTime=$p(singleSchemePara,$c(3),40)
	i updateTime'="" s scheme.BPSUpdateTime=##class(web.DHCANOPCom).ConvertToTimeH(updateTime)	
	s scheme.BPSSubtractiveWeight=$p(singleSchemePara,$c(3),41)
	s scheme.BPSSalineDose=$p(singleSchemePara,$c(3),42)
	s scheme.BPSPFR=$p(singleSchemePara,$c(3),43)
	s scheme.BPSDFR=$p(singleSchemePara,$c(3),44)
	s scheme.BPSObjectiveClearAmount=$p(singleSchemePara,$c(3),45)
	s scheme.BPSResidualPlasmaAmount=$p(singleSchemePara,$c(3),46)
	s scheme.BPSResidualSalineAmount=$p(singleSchemePara,$c(3),47)
	s scheme.BPSResidualAlbuminAmount=$p(singleSchemePara,$c(3),48)
	s scheme.BPSSalineGlucoseDrug=$p(singleSchemePara,$c(3),49)
	s scheme.BPSKCL=$p(singleSchemePara,$c(3),50)
	s scheme.BPSNaHCO3=$p(singleSchemePara,$c(3),51)
	s scheme.BPSRP=$p(singleSchemePara,$c(3),52)
	s scheme.BPSDialysateAmount=$p(singleSchemePara,$c(3),53)
	s scheme.BPSAntContraindication=$p(singleSchemePara,$c(3),54)
	s scheme.BPSAntContraindicationNote=$p(singleSchemePara,$c(3),55)
	q scheme
}

ClassMethod GetSchemeExistsByTemplateName(templateName) As %String
{
	 s ret="0"
	 i $d(^DHCBPScheme(0,"Template"," "_templateName)) d
	 .s ret="1"
	 q ret
}

ClassMethod DeleteSchemes(strId) As %String
{
	 s ret="1"
	 s deleteStatus="1"
     q:strId="" "ID不能为空!"
     f i=1:1:$l(strId) d
     .s id=$p(strId,"^",i)
     .q:id=""
	 .q:'##class(User.DHCBPScheme).%ExistsId(id)
	 .s status=##class(User.DHCBPScheme).%DeleteId(id)
	 .i +status=0 s deleteStatus=0
	 .q:+status=0
	 q:(+deleteStatus=0) "数据删除失败!"
	 q ret
}

ClassMethod UpdateSchemeEndDate(schemeId, endDate) As %String
{
	q:schemeId="" "方案ID空"
	q:endDate="" "结束日期空"
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	TSTART
	&sql(update DHC_BP_Scheme set BPS_EndDate=:endDate where BPS_RowId=:schemeId)
	i SQLCODE'=0 TROLLBACK  Q "更新方案表失败"
	s result=$g(%ROWID)
	&sql(update DHC_BP_Arrange SET BPA_Status='D'  where BPA_BPScheme_Dr=:schemeId and BPA_Date>:endDate)
	i (SQLCODE'=0)&(SQLCODE'=100) TROLLBACK  Q "更新安排表失败"
	TCOMMIT
	q result
}

/// w ##class(web.DHCBPArrangeScheme).GetMaturingScheme(2)
ClassMethod GetMaturingScheme(days As %Integer) As %String
{
	s curDate=+$h
	s cutOffDate=curDate+days
	s endDate=""
	s ret=""
	&sql(declare C1 cursor for SELECT %ID,
	   BPS_BPRegister_Dr,BPS_EndDate into :schemeId,:registerId,:endDate  FROM DHC_BP_Scheme
	   WHERE BPS_EndDate>:curDate and BPS_EndDate<=:cutOffDate)
	&sql(open C1)
	&sql(fetch C1)
	while(SQLCODE=0)
	{
	  q:schemeId=""
	  q:registerId=""
	  s papmiId=$lg($g(^DHCBPPatRegister(registerId)),1)
	  q:papmiId="" 
	  s bpcPatStatus=$lg($g(^DHCBPPatRegister(registerId)),14)
	  q:bpcPatStatus="D"   ///去掉转归病人
	  s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	  s endDate=##class(web.DHCClinicCom).ConvertToDate(endDate)
	  i ret="" s ret=schemeId_$c(3)_patName_$c(3)_endDate
	  e  s ret=ret_"^"_schemeId_$c(3)_patName_$c(3)_endDate
	  &sql(fetch C1)
	}
	&sql(close C1)
	q ret
}

// w ##class(web.DHCBPScheme).GetModifiedScheme()

ClassMethod GetModifiedScheme(locId As %String = "") As %String
{
	s curDate=+$h
	s ret=""
	k SCHEME
	&sql(declare C2 cursor for select BPAS_BPScheme_Dr,BPAS_BPPatRegister_Dr,count(distinct BPAS_BPScheme_Dr) into:schemeId,:registerId,:count from dhc_bp_arrangescheme where (BPAS_BPScheme_Dr in 
	( SELECT %ID FROM DHC_BP_Scheme
	   WHERE BPS_StartDate<=:curDate and BPS_EndDate>:curDate))
	and ((BPAS_IfActive='Y' and BPAS_IfAbandon='Y') OR ((BPAS_IfActive='N' OR BPAS_IfActive is null) and (BPAS_IfAbandon='N' OR  BPAS_IfAbandon is null))) group by BPAS_BPScheme_Dr)
	&sql(open C2)
	&sql(fetch C2)
	while(SQLCODE=0)
	{
	  q:schemeId=""
	  q:registerId=""
	  b ;1
	  s SCHEME(schemeId)=$g(SCHEME(schemeId))+1
	  b ;2
	  ;i SCHEME(schemeId)=1  d
	  s papmiId=$lg($g(^DHCBPPatRegister(registerId)),1)
	  q:papmiId="" 
	  s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	  s admId=$lg($g(^DHCBPPatRegister(registerId)),26)
	  i admId=""  &sql(fetch C2) continue
      s admDeptId=$p($g(^PAADM(admId)),"^",4) 
      q:((locId'="")&&(admDeptId'="")&&($p($g(^CTLOC(locId)),"^",22)'=$p($g(^CTLOC(admDeptId)),"^",22))) //病人所在医院和用户登录医院判断	  
	  i ret="" s ret=schemeId_$c(3)_patName
	  e  s ret=ret_"^"_schemeId_$c(3)_patName
	  &sql(fetch C2)
	}
	&sql(close C2)
	q ret
}

Query GetSchemeEquipRunParaList(schemeId As %String) As %SQLQuery(CONTAINID = 1)
{
	 SELECT 
	 BPSERP_RowId As Id,
	 BPSERP_BPCERP_Dr As EquipRunParaId,
	 BPSERP_MinValue As MinValue,
	 BPSERP_MaxValue As MaxValue,
	 BPSERP_Value As Value from DHC_BP_SchemeEquipRunPara where BPSERP_Parref=:schemeId and (BPSERP_IfAbandon='N' or BPSERP_IfAbandon is null) and BPSERP_BPCERP_Dr is not null
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPScheme","FindSchemeTemplates","Common","")
Query FindSchemeTemplates(type As %String, registerId As %String) As %Query(ROWSPEC = "Id,StartDate,EndDate,WeekNum,PatientWeight,MaxDewaterAmount,NetDewaterAmount,FoodIntakeAmount,ResidualBloodAmount,VascularAccessId,VascularAccessDesc,EquipModelId,DialysisMethodId,DialysisMethodDesc,SecondDialysisMethodId,SecondDialysisMethodDesc,ThirdDialysisMethodId,ThirdDialysisMethodDesc,ConsumableId,ConsumableDesc,SecondConsumableId,SecondConsumableDesc,ThirdConsumableId,ThirdConsumableDesc,TherapyDuration,AnticoagulantModeId,AnticoagulantModeDesc,FirstHeparinAmount,HeparinDose,ProtamineAmount,LowMoleHeparinAmount,EquipRunModeId,EquipRunModeDesc,FilterReplaceMode,FilterReplaceAmount,OralHematin,InjectHematin,Na,K,Ca2,HCO3,Note,TemplateName,UpdateUserId,UpdateDate,UpdateTime")
{
}

ClassMethod FindSchemeTemplatesExecute(ByRef qHandle As %Binary, type As %String, registerId As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	b ;1
 	s templateName=""
 	if type="Common" 
 	{
	  b ;2
      s templateName=" "
      f  s templateName=$o(^DHCBPScheme(0,"Template",templateName)) q:templateName=""  d
      .s rowId=""
      .f  s rowId=$o(^DHCBPScheme(0,"Template",templateName,rowId)) q:rowId=""  d
      ..q:$$GetSchemeInfo()<0
      ..d OutputRow1	
 	}
 	if (type="Last")&(registerId'="")
 	{
	   b ;3
	   s rowId="",i=0
	   f rowId=$o(^DHCBPScheme(0,"PatRegister",registerId,rowId),-1) q:rowId=""  d
	   .q:i>0
	   .q:$$GetSchemeInfo()<0
	   .s i=i+1
	   .d OutputRow1
 	}
 	s qHandle=$lb(0,repid,0)
	q $$$OK 
    
GetSchemeInfo()
    q:rowId="" -1
    s scheme=##class(User.DHCBPScheme).%OpenId(rowId)
	s startDate=scheme.BPSStartDate
	
	i startDate'="" s startDate=##class(web.DHCClinicCom).ConvertToDate(startDate)
	s endDate=scheme.BPSEndDate
	i endDate'="" s endDate=##class(web.DHCClinicCom).ConvertToDate(endDate)
	s weekNum=scheme.BPSWeekNum
	s patWeight=scheme.BPSPatDryWeight
	s maxDewaterAmount=scheme.BPSMaxDewaterAmount
	s netDewaterAmount=scheme.BPSNetDewaterAmount //净出水量		
	s foodIntakeAmount=scheme.BPSFoodIntakeAmount		
	s residualBloodAmount=scheme.BPSResidualBloodAmount
	s vascularAccess=scheme.BPSVascularAccessDr
	s vascularAccessId="",vascularAccessDesc=""
	i vascularAccess'="" d
	.s vascularAccessId=vascularAccess.%Id()
	.s vascularAccessDesc=vascularAccess.BPCVADesc		
	s equipModel=scheme.BPSBPCEquipModelDr
	s equipModelId="",equipModeDesc=""
	i equipModel'="" d
	.s equipModelId=EquipModel.%Id()
	.s equipModeDesc=EquipModel.BPCEMDesc
	s dialysisMethod=scheme.BPSBPCBPModeDr
	s dialysisMethodId="",dialysisMethodDesc=""
	i dialysisMethod'="" d
	.s dialysisMethodId=dialysisMethod.%Id()
	.s dialysisMethodDesc=dialysisMethod.BPCBPMDesc
	s secondDialysisMethod=scheme.BPSSecondBPCBPModeDr
	s secondDialysisMethodId="",secondDialysisMethodDesc=""
	i secondDialysisMethod'="" d
	.s secondDialysisMethodId=secondDialysisMethod.%Id()
	.s secondDialysisMethodDesc=secondDialysisMethod.BPCBPMDesc	
	s thirdDialysisMethod=scheme.BPSThirdBPCBPModeDr
	s thirdDialysisMethodId="",thirdDialysisMethodDesc=""
	i thirdDialysisMethod'="" d
	.s thirdDialysisMethodId=thirdDialysisMethod.%Id()
	.s thirdDialysisMethodDesc=thirdDialysisMethod.BPCBPMDesc
    s consumable=scheme.BPSBPCConsumableDr
	s consumableId="",consumableDesc=""
	i consumable'="" d
	.s consumableId=consumable.%Id()
	.s consumableDesc=consumable.BPCCDesc
    s secondConsumable=scheme.BPSSecondBPCConsumableDr
	s secondConsumableId="",secondConsumableDesc=""
	i secondConsumable'="" d
	.s secondConsumableId=secondConsumable.%Id()
	.s secondConsumableDesc=secondConsumable.BPCCDesc
	s thirdConsumable=scheme.BPSThirdBPCConsumableDr
	s thirdConsumableId="",thirdConsumableDesc=""
	i thirdConsumable'="" d
	.s thirdConsumableId=thirdConsumable.%Id()
	.s thirdConsumableDesc=thirdConsumable.BPCCDesc

	s therapyDuration=scheme.BPSTherapyDuration
	i therapyDuration'="" d
	.s therapyDuration=##class(web.DHCANOPCom).ConvertToTime(therapyDuration)
	s anticoagulantMode=scheme.BPSAnticoagulantModeDr
	s anticoagulantModeId="",anticoagulantModeDesc=""
	i anticoagulantMode'="" d
	.s anticoagulantModeId=anticoagulantMode.%Id()
	.s anticoagulantModeDesc=anticoagulantMode.BPCAMDesc
	s firstHeparinAmount=scheme.BPSFirstHeparinAmount  //首推
	
	s heparinDose=scheme.BPSHeparinDose //维持剂量
	s protamineAmount=scheme.BPSProtamineAmount //鱼精蛋白
	s lowMoleHeparinAmount=scheme.BPSLowMoleHeparinAmount //低分子肝素量
	s equipRunModeIdStr=scheme.BPSBPCEquipRunModeDr  //2013.11.22
	s num=$l(equipRunModeIdStr,",")
	s equipRunModeDescStr=""
	f i=1:1:num d
	.s equipRunModeId=$p(equipRunModeIdStr,",",i)
	.q:equipRunModeId=""
	.s equipRunModeDesc=$lg(^DHCBPC("EquipRunMode",equipRunModeId),2)
	.i equipRunModeDescStr="" s equipRunModeDescStr=equipRunModeDesc
	.e  s equipRunModeDescStr=equipRunModeDescStr_","_equipRunModeDesc
	s filterReplaceMode=scheme.BPSFilterReplaceMode
	s filterReplaceAmount=scheme.BPSFilterReplaceAmount
	s oralHematin=scheme.BPSOralHematin
	s injectHematin=scheme.BPSInjectHematin
	s na=scheme.BPSNa
	s k=scheme.BPSK
	s ca2=scheme.BPSCa2
	s hco3=scheme.BPSHCO3
	s note=scheme.BPSNote
	s updateUserDr=scheme.BPSUpdateUserDr
	s updateDate=scheme.BPSUpdateDate
	i updateDate'="" s updateDate=##class(web.DHCANOPCom).ConvertToDate(updateDate)
	s updateTime=scheme.BPSUpdateTime
	i updateTime'="" s updateTime=##class(web.DHCANOPCom).ConvertToTime(updateTime)
	s templateNameOut=$tr(templateName," ","")
	q 0

    
OutputRow1
	s Data=$lb(rowId,startDate,endDate,weekNum,patWeight,maxDewaterAmount,netDewaterAmount,foodIntakeAmount,residualBloodAmount,vascularAccessId,vascularAccessDesc,equipModelId,dialysisMethodId,dialysisMethodDesc,secondDialysisMethodId,secondDialysisMethodDesc,thirdDialysisMethodId,thirdDialysisMethodDesc,consumableId,consumableDesc,secondConsumableId,secondConsumableDesc,thirdConsumableId,thirdConsumableDesc,therapyDuration,anticoagulantModeId,anticoagulantModeDesc,firstHeparinAmount,heparinDose,protamineAmount,lowMoleHeparinAmount,equipRunModeIdStr,equipRunModeDescStr,filterReplaceMode,filterReplaceAmount,oralHematin,injectHematin,na,k,ca2,hco3,note,templateNameOut,updateUserDr,updateDate,updateTime)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

}
