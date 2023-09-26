Import SQLUser

Class web.webDHCBPInterface Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// D ##class(%ResultSet).RunQuery("web.DHCBPInterface","FindBPPatRegister","121677")
/// Creator：      	马福成
/// CreatDate：    	2021-4-20
/// Description： 	获取登记信息
/// Table：        	DHC_BP_PatRegister、DHC_BP_Arrange、mrc_icddx
/// Input：        	bpaId：透析记录Id
/// Return：       	PatDate登记日期，PatBPNo透析编号，PatType病人类型，PatStatus状态，
/// 				PatDiagnosis诊断，PatMRCICD透析原因，PatStartDate首次透析日期
Query FindBPPatRegister(bpaId As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT
	TO_CHAR(BPPR_Date,'YYYY-MM-DD') As PatDate,
	BPPR_PatBPNo As PatBPNo,
	CASE BPPR_PatType
  	WHEN 'N' THEN '常规'
  	WHEN 'T' THEN '临时'
  	ELSE NULL
	END AS PatType,
	CASE BPPR_Status
  	WHEN 'N' THEN '正常'
  	WHEN 'D' THEN '转归'
  	ELSE NULL
	END AS PatStatus,
	BPPR_Diagnosis As PatDiagnosis,
	(SELECT MRCID_Desc FROM mrc_icddx WHERE MRCID_RowId = pr.BPPR_MRCICD_Dr) As PatMRCICD,	
	TO_CHAR(BPPR_StartDate,'YYYY-MM-DD') As PatStartDate
	from DHC_BP_PatRegister as pr where BPPR_RowId in(select BPA_BPPatRegister_Dr from DHC_BP_Arrange where BPA_RowId=:bpaId)
}

/// D ##class(%ResultSet).RunQuery("web.DHCBPInterface","FindBPVascularAccess","121677")
/// Creator：      	马福成
/// CreatDate：    	2021-4-20
/// Description： 	获取血管通路列表
/// Table：        	DHC_BP_VascularAccess、DHC_BP_Arrange、DHC_BPC_VascularAccess、DHCCLC_BodySite、SS_User
/// Input：        	bpaId：透析记录Id
/// Return：       	VascularAccess通路类型，BodySite建立部位，BuildingDate建立日期，StartDate启动日期，
/// 				Status状态，Reason备注，UpdateUser创建者，UpdateDate更新日期
Query FindBPVascularAccess(bpaId As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT	
	(SELECT BPCVA_Desc FROM DHC_BPC_VascularAccess WHERE BPCVA_RowId = va.BPV_VascularAccess_Dr) As VascularAccess,
	(SELECT CLCBS_Desc FROM DHCCLC_BodySite WHERE CLCBS_RowId = va.BPV_BodySite_Dr) As BodySite,
	TO_CHAR(BPV_BuildingDate,'YYYY-MM-DD') As BuildingDate,
	TO_CHAR(BPV_StartDate,'YYYY-MM-DD') As StartDate,
	CASE BPV_Status
  	WHEN 'N' THEN '使用'
  	WHEN 'I' THEN '暂停'
  	ELSE NULL
	END AS Status,
	BPV_EndReason As Reason,
	(SELECT SSUSR_Name FROM SS_User WHERE %ID = va.BPV_UpdateUser_Dr) As UpdateUser,	
	TO_CHAR(BPV_UpdateDate,'YYYY-MM-DD') As UpdateDate
	from DHC_BP_VascularAccess as va where BPV_BPPatRegister_Dr in(select BPA_BPPatRegister_Dr from DHC_BP_Arrange where BPA_RowId=:bpaId) and BPV_Status!='D'
}

/// D ##class(%ResultSet).RunQuery("web.DHCBPInterface","FindBPScheme","121677")
/// Creator：      	马福成
/// CreatDate：    	2021-4-22
/// Description： 	获取透析方案
/// Table：        	DHC_BP_VascularAccess、DHC_BP_Arrange、DHC_BPC_VascularAccess、DHCCLC_BodySite、SS_User
/// Input：        	bpaId：透析记录Id
/// Return：       	StartDate开始日期，PatDryWeight干体重，BFR血流量，BPMode透析方式，BPAtMode抗凝方式，Note备注，UpdateUser创建者
Query FindBPScheme(bpaId As %String) As %Query(ROWSPEC = "StartDate,PatDryWeight,BFR,BPMode,BPAtMode,Note,UpdateUser")
{
}

ClassMethod FindBPSchemeExecute(ByRef qHandle As %Binary, bpaId As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	i bpaId="" q ""
 	s bpprId=$lg(^DHCBPArrange(bpaId),1)
 	&sql(declare C2 cursor for select BPAS_BPScheme_Dr,BPAS_BPCBPMode_Dr->BPCBPM_Desc,count(BPAS_BPCBPMode_Dr),BPAS_AnticoagulantMode_Dr->BPCAM_Desc
 	into :schemeId,:modeDesc,:count,:atModeDesc
 	from dhc_bp_arrangescheme where BPAS_BPScheme_Dr in (SELECT %ID FROM DHC_BP_Scheme WHERE BPS_BPRegister_Dr=:bpprId and BPS_EndDate='2980013')	
	and ((BPAS_IfActive='Y') and (BPAS_IfAbandon='N' OR  BPAS_IfAbandon is null)) group by BPAS_BPCBPMode_Dr)
	&sql(open C2)
	&sql(fetch C2)
	s BPMode="",BPAtMode=""
	while(SQLCODE=0)
	{
	  	q:modeDesc=""
 		i BPMode="" s BPMode=modeDesc_"("_count_")"
 		e  s BPMode=BPMode_";"_modeDesc _"("_count_")"
 		i BPAtMode="" s BPAtMode=atModeDesc
 		e  s BPAtMode=BPAtMode_";"_atModeDesc 		
 		&sql(fetch C2)
 	}
	&sql(close C2)
	&sql(SELECT TO_CHAR(BPS_StartDate,'YYYY-MM-DD'),BPS_PatDryWeight,BPS_BFR,BPS_Note,(SELECT SSUSR_Name FROM SS_User WHERE %ID = BPS_UpdateUser_Dr) into :StartDate,:PatDryWeight,:BFR,:Note,:UpdateUser FROM DHC_BP_Scheme WHERE BPS_RowId=:schemeId)	
 	
 	d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK  
OutputRow1
	s Data=$lb(StartDate,PatDryWeight,BFR,BPMode,BPAtMode,Note,UpdateUser)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindBPSchemeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPSchemeExecute ]
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

ClassMethod FindBPSchemeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPSchemeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCBPInterface","FindBPArrangeScheme","121677")
/// Creator：      	马福成
/// CreatDate：    	2021-4-22
/// Description： 	获取透析计划列表
/// Table：        	dhc_bp_arrangescheme、DHC_BP_Arrange、DHC_BP_Scheme
/// Input：        	bpaId：透析记录Id
/// Return：       	WeekSeq周期，WeekDay星期，DaySeqNo班次，EffectDate生效日期，
/// 				BPMode透析方式，BPSecondMode附件透析，Consumable透析器材，SecondConsumable附加器材
Query FindBPArrangeScheme(bpaId As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT
	CASE BPAS_WeekSeqNo
  	WHEN '1' THEN '第一周'
  	WHEN '2' THEN '第二周'
  	ELSE NULL
	END AS WeekSeq,
	CASE BPAS_WeekDay
  	WHEN '1' THEN '星期一'
  	WHEN '2' THEN '星期二'
  	WHEN '3' THEN '星期三'
  	WHEN '4' THEN '星期四'
  	WHEN '5' THEN '星期五'
  	WHEN '6' THEN '星期六'
  	WHEN '7' THEN '星期日'
  	ELSE NULL
	END AS WeekDay,
	CASE BPAS_DaySeqNo
  	WHEN 'A' THEN '上午'
  	WHEN 'P' THEN '下午'
  	WHEN 'E' THEN '晚上'
  	ELSE NULL
	END AS DaySeqNo,
	TO_CHAR(BPAS_EffectDate,'YYYY-MM-DD') As EffectDate,	
	BPAS_BPCBPMode_Dr->BPCBPM_Desc As BPMode,
	BPAS_SecondBPCBPMode_Dr->BPCBPM_Desc As BPSecondMode,
	BPAS_BPCConsumable_Dr->BPCC_Desc As Consumable,
	BPAS_SecondBPCConsumable_Dr->BPCC_Desc As SecondConsumable	
	from dhc_bp_arrangescheme where BPAS_BPScheme_Dr in (SELECT %ID FROM DHC_BP_Scheme WHERE BPS_BPRegister_Dr in(select BPA_BPPatRegister_Dr from DHC_BP_Arrange where BPA_RowId=:bpaId) and BPS_EndDate='2980013')	
	and (BPAS_IfActive='Y') and (BPAS_IfAbandon='N' OR  BPAS_IfAbandon is null) order by BPAS_WeekSeqNo,BPAS_WeekDay asc
}

/// D ##class(%ResultSet).RunQuery("web.DHCBPInterface","FindBPVitalSigns","122399")
/// Creator：      	马福成
/// CreatDate：    	2021-4-22
/// Description： 	获取异常生命体征列表（透析中）
/// Table：        	DHC_BP_Record、SS_User
/// Input：        	bpaId：透析记录Id
/// Return：       	StartDate日期，StartTime时间，RecordItem异常项目，Qty异常值，UpdateUser记录人
Query FindBPVitalSigns(bpaId As %String) As %Query(ROWSPEC = "StartDate,StartTime,RecordItem,Qty,UpdateUser")
{
}

ClassMethod FindBPVitalSignsExecute(ByRef qHandle As %Binary, bpaId As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	i bpaId="" q ""
 	s bpprId=$lg(^DHCBPArrange(bpaId),1)
 	&sql(declare C1 cursor for SELECT
	TO_CHAR(BPR_StartDate,'YYYY-MM-DD'),
	BPR_StartTime,	
	BPR_BPCRecordItem_Dr->BPCRI_Desc,
	BPR_Qty,	
	(SELECT SSUSR_Name FROM SS_User WHERE %ID = BPR_UpdateUser_Dr)
	into :StartDate,:StartTime,:RecordItem,:Qty,:UpdateUser
	from DHC_BP_Record
	where BPR_BPArrange_Dr =:bpaId and BPR_EditStatus!='D' and BPR_Qty!=0 and (
	((BPR_BPCRecordItem_Dr->BPCRI_Code='SBP') and ((BPR_Qty>=180) or (BPR_Qty<=90)))
	or ((BPR_BPCRecordItem_Dr->BPCRI_Code='DBP') and ((BPR_Qty>=100) or (BPR_Qty<=60)))
	or ((BPR_BPCRecordItem_Dr->BPCRI_Code='HR') and ((BPR_Qty>=100) or (BPR_Qty<=60))))	
	)
	&sql(open C1)
	&sql(fetch C1)
	while(SQLCODE=0)
	{
	  	s StartTime=$zt(StartTime,1)
 		d OutputRow1
 		&sql(fetch C1)
 	}
 	&sql(close C1)
 	s qHandle=$lb(0,repid,0)
	q $$$OK  
OutputRow1
	s Data=$lb(StartDate,StartTime,RecordItem,Qty,UpdateUser)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindBPVitalSignsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPVitalSignsExecute ]
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

ClassMethod FindBPVitalSignsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPVitalSignsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCBPInterface","FindBPCalculateURR","122234")
/// Creator：      	马福成
/// CreatDate：    	2021-4-20
/// Description： 	获取当次透析充分性评估
/// Table：        	DHC_BP_PatRegister、DHC_BP_Arrange、mrc_icddx
/// Input：        	bpaId：透析记录Id
/// Return：       	StartDate日期，DaySeqNo时段，BPMode透析方式，BPSecondMode附件透析，
/// 				KtV：Kt/v值，URR：URR值，PCR：PCR值
Query FindBPCalculateURR(bpaId As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT
	TO_CHAR(BPA_Date,'YYYY-MM-DD') As StartDate,
	CASE BPA_DaySeqNo
  	WHEN 'A' THEN '上午'
  	WHEN 'P' THEN '下午'
  	WHEN 'E' THEN '晚上'
  	ELSE NULL
	END AS DaySeqNo,
	BPA_BPCBPMode_Dr->BPCBPM_Desc As BPMode,
	BPA_SecondBPCBPMode_Dr->BPCBPM_Desc As BPSecondMode,
	BPA_KtV As KtV,
	BPA_URR As URR,
	BPA_PCR As PCR
	from DHC_BP_Arrange where BPA_RowId =:bpaId and BPA_Status!='D'
}

/// D ##class(%ResultSet).RunQuery("web.DHCBPInterface","FindBPArrange","122234")
/// Creator：      	马福成
/// CreatDate：    	2021-4-23
/// Description： 	获取透析安排列表（当天到下周日的记录）
/// Table：        	DHC_BP_Arrange、dhc_bp_arrangescheme
/// Input：        	bpaId：透析记录Id
/// Return：       	BPDate日期，DaySeqNo时间段，BPMode透析方式，BPSecondMode附件透析，Status状态，WeekSeqNo所属透析计划周
Query FindBPArrange(bpaId As %String) As %Query(ROWSPEC = "BPDate,DaySeqNo,BPMode,BPSecondMode,Status,WeekSeqNo")
{
}

ClassMethod FindBPArrangeExecute(ByRef qHandle As %Binary, bpaId As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	i bpaId="" q ""
 	s bpprId=$lg(^DHCBPArrange(bpaId),1)
 	s startDate=+$h 	
 	s nextEndWeekDate= (+$h+7)+(7-$zd(+$h+7,10)) //下周日期（当天+7） + （下周周末-下周日期）=下周周末日期
 	&sql(declare C3 cursor for SELECT
	BPA_Date,BPA_DaySeqNo,BPA_BPCBPMode_Dr,BPA_BPCBPMode_Dr->BPCBPM_Desc,BPA_SecondBPCBPMode_Dr->BPCBPM_Desc,BPA_Status,BPA_ArrangeType,BPA_BPScheme_Dr
	into BPDate,DaySeqNo,BPModeId,BPMode,BPSecondMode,Status,ArrangeType,SchemeId
	from DHC_BP_Arrange
	where BPA_BPPatRegister_Dr=:bpprId and BPA_Date>=:startDate and BPA_Date<=:nextEndWeekDate and BPA_Status!='D'
	)
	&sql(open C3)
	&sql(fetch C3)
	while(SQLCODE=0)
	{
		s WeekDay=$zd(BPDate,10)
		s cycle=2,weekSeqNoDesc=""
	  	&sql(select min(BPAS_EffectDate) into :effectDate from dhc_bp_arrangescheme where BPAS_BPPatRegister_Dr=:bpprId and BPAS_BPScheme_Dr=:SchemeId and BPAS_BPCBPMode_Dr=:BPModeId and BPAS_WeekDay=:WeekDay and BPAS_DaySeqNo=:DaySeqNo and (BPAS_IfAbandon='N' OR BPAS_IfAbandon is null))   
		w effectDate,!
		i (effectDate'="")&&(ArrangeType'="T") d //安排计划生效/非临时透析
			.s effectWeekDay=$zd(effectDate,10)
			.s virtualEffectDate=effectDate-effectWeekDay+1   //虚拟开始日期，当本周使用了安排计划，相当于下周一开始就算第二周，所以将起始生效时间虚拟为本周一
			.s virWeekSeqNo=(BPDate-virtualEffectDate)\7+1
			.s remainder=virWeekSeqNo#cycle
			.i remainder=0 s WeekSeqNo="第"_cycle_"周"
			.e  s WeekSeqNo="第"_remainder_"周"		
		i WeekDay=1 s WeekDay="星期一"
		i WeekDay=2 s WeekDay="星期二"
		i WeekDay=3 s WeekDay="星期三"
		i WeekDay=4 s WeekDay="星期四"
		i WeekDay=5 s WeekDay="星期五"
		i WeekDay=6 s WeekDay="星期六"
		i WeekDay=0 s WeekDay="星期日"
		s BPDate=##class(web.DHCClinicCom).ConvertToDate(BPDate)
		s BPDate=BPDate_" "_WeekDay		
		i DaySeqNo="A" s DaySeqNo="上午"
		i DaySeqNo="P" s DaySeqNo="下午"
		i DaySeqNo="E" s DaySeqNo="晚上"
		i Status="A" s Status="申请"	
		i Status="R" s Status="安排"
		i Status="M" s Status="治疗"
		i Status="F" s Status="完成"
 		d OutputRow1
 		&sql(fetch C3)
 	}
 	&sql(close C3)
 	s qHandle=$lb(0,repid,0)
	q $$$OK  
OutputRow1
	s Data=$lb(BPDate,DaySeqNo,BPMode,BPSecondMode,Status,WeekSeqNo)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
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

/// D ##class(%ResultSet).RunQuery("web.DHCBPInterface","FindBPTreatment","122234")
/// Creator：      	马福成
/// CreatDate：    	2021-4-23
/// Description： 	获取当次查房记录
/// Table：        	DHC_BP_Treatment、DHC_BPC_Treatment、DHC_BPC_TreatmentCat、SS_User
/// Input：        	bpaId：透析记录Id
/// Return：       	BPDate日期，BPTime时间，TreatmentCat项目分类，TreatmentItem项目，
/// 				Symptom调整原因，Treatment调整内容，UpdateUser操作人
Query FindBPTreatment(bpaId As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT
	TO_CHAR(BPT_Date,'YYYY-MM-DD') As BPDate,
	{fn CONVERT(BPT_Time,SQL_VARCHAR)} As BPTime,
	(SELECT BPCTC_Desc FROM DHC_BPC_TreatmentCat WHERE BPCTC_RowId in (SELECT BPCT_BPTCat_Dr FROM DHC_BPC_Treatment WHERE BPCT_RowId = t.BPT_BPCT_Dr) and BPCTC_Active='Y') As TreatmentCat,
	BPT_BPCT_Dr->BPCT_Desc As TreatmentItem,
	BPT_Symptom As Symptom,
	BPT_Treatment As Treatment,	
	(SELECT SSUSR_Name FROM SS_User WHERE %ID = t.BPT_UpdateUser_Dr) As UpdateUser
	from DHC_BP_Treatment as t where BPT_BPA_Dr =:bpaId and BPT_Status!='C'
}

/// D ##class(%ResultSet).RunQuery("web.DHCBPInterface","FindBPOrderItem","122234")
/// Creator：      	马福成
/// CreatDate：    	2021-4-23
/// Description： 	获取当次透析医嘱（临时）
/// Table：        	DHC_BP_OrderItem、ARC_ItmMast、PHC_Instruc、CT_UOM、PHC_Freq、ct_careprov
/// Input：        	bpaId：透析记录Id
/// Return：       	ARCIM医嘱名称，Instruc用法，Dose剂量，UOM单位，Freq频次，Note备注，Status状态，
/// 				StartDate开始日期，ExecUser执行人，ExecDate执行日期，ExecTime执行时间
Query FindBPOrderItem(bpaId As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT
	(SELECT ARCIM_Desc FROM ARC_ItmMast WHERE ARCIM_RowId = o.BPOI_Arcim_Dr) As ARCIM,
	(SELECT PHCIN_Desc2 FROM PHC_Instruc WHERE PHCIN_RowId = o.BPOI_Instruct_Dr) As Instruc,
	BPOI_Dose As Dose,
	(SELECT CTUOM_Code FROM CT_UOM WHERE CTUOM_RowId = o.BPOI_DoseUnit_Dr) As UOM,
	(SELECT PHCFR_Desc2 FROM PHC_Freq WHERE PHCFR_RowId = o.BPOI_Freq_Dr) As Freq,
	BPOI_Note As Note,
	CASE BPOI_Status
  	WHEN 'V' THEN '审核'
  	WHEN 'E' THEN '执行'
  	ELSE NULL
	END AS Status,
	TO_CHAR(BPOI_StartDate,'YYYY-MM-DD') As StartDate,
	(SELECT CTPCP_Desc FROM ct_careprov WHERE CTPCP_RowId1 = o.BPOI_ExecCtcp_Dr) As ExecUser,
	TO_CHAR(BPOI_ExecDate,'YYYY-MM-DD') As ExecDate,
	{fn CONVERT(BPOI_ExecTime,SQL_VARCHAR)} As ExecTime
	from DHC_BP_OrderItem as o where BPOI_BPArrange_Dr =:bpaId and BPOI_OrderType='N' and BPOI_Status!='D'
}

/// 任务执行，把透析记录状态、时间节点等数据传给平台组
/// w ##Class(web.DHCBPSignIn).ConfirmBPStatToPlatform("")
ClassMethod ConfirmBPStatToPlatform(isDebug As %String = "") As %String
{
	s retStr=""
	s curDate=+$h
	s bpaId=""
	f  s bpaId=$o(^DHCBPArrange(0,"Date",curDate,bpaId)) q:bpaId=""  d
		.//q:bpaId'="115638"
		.q:$$GetSignIn()<0 
		.i siUserId'="" d //签到
			..s dynObject = {"OEOrdItemID":(bpaId),"Position":"","ExamID":"","Status":"BPCheck","UserID":(siUserId),"UserName":(siUserDesc),"UpDateTime":(siDateTime),"SourceSystem":"BP","Notes":""}
			..s retStr =##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",dynObject)
			..set dynEntity = {}.%FromJSON(retStr)
   			..set itr = dynEntity.%GetIterator()
   			..while itr.%GetNext(.key,.val) {
	   			...i val="0" s retStr="成功"
   			..}
   		.i bpaCheckDocId'="" d //透析前记录
			..s dynObject = {"OEOrdItemID":(bpaId),"Position":"","ExamID":"","Status":"BPBeforeRecord","UserID":(bpaCheckDocId),"UserName":(bpaCheckDocDesc),"UpDateTime":(bpaCheckDateTime),"SourceSystem":"BP","Notes":""}
			..s retStr =##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",dynObject)
		.i bpaStartOperationNurseId'="" d //上机
			..s dynObject = {"OEOrdItemID":(bpaId),"Position":"","ExamID":"","Status":"BPOperation","UserID":(bpaStartOperationNurseId),"UserName":(bpaStartOperationNurseDesc),"UpDateTime":(bpaStartOperationDateTime),"SourceSystem":"BP","Notes":""}
			..s retStr =##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",dynObject)
		.i bprUserId'="" d //透析中记录（第一条时间点）
			..s dynObject = {"OEOrdItemID":(bpaId),"Position":"","ExamID":"","Status":"BPDuringRecord","UserID":(bprUserId),"UserName":(bprUserDesc),"UpDateTime":(bprStartDateTime),"SourceSystem":"BP","Notes":""}
			..s retStr =##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",dynObject)
		.i bpaEndOperationNurseId'="" d //透析后记录
			..s dynObject = {"OEOrdItemID":(bpaId),"Position":"","ExamID":"","Status":"BPAfterRecord","UserID":(bpaEndOperationNurseId),"UserName":(bpaEndOperationNurseDesc),"UpDateTime":(bpaEndOperationDateTime),"SourceSystem":"BP","Notes":""}
			..s retStr =##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",dynObject)
		.i bpaEndOperationNurseId'="" d //下机
			..s dynObject = {"OEOrdItemID":(bpaId),"Position":"","ExamID":"","Status":"BPDismount","UserID":(bpaEndOperationNurseId),"UserName":(bpaEndOperationNurseDesc),"UpDateTime":(bpaEndOperationDateTime),"SourceSystem":"BP","Notes":""}
			..s retStr =##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",dynObject)
		.i bpatNurAssNurseId'="" d //护理评估
			..s dynObject = {"OEOrdItemID":(bpaId),"Position":"","ExamID":"","Status":"BPNursing Assessment","UserID":(bpatNurAssNurseId),"UserName":(bpatNurAssNurseDesc),"UpDateTime":(bpatNurAssDateTime),"SourceSystem":"BP","Notes":""}
			..s retStr =##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",dynObject)	
	q retStr	
GetSignIn()
	q:bpaId="" -1
	s bpprId=$lg(^DHCBPArrange(bpaId),1)
	//w curDate,!
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	q:papmiId="" -2
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s bpaDate=$lg(^DHCBPArrange(bpaId),4)
	s arrDate=bpaDate
	s bpaDate=##class(web.DHCClinicCom).ConvertToDate(bpaDate)
	s bpaStatus=$lg(^DHCBPArrange(bpaId),9)
	q:bpaStatus="A" -3
	s bpaDaySeqNo=$lg(^DHCBPArrange(bpaId),6)
	s bpaBPCBedDr=$lg(^DHCBPArrange(bpaId),7)
	s bpaBPCBedDesc=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),2)
	s bpaBPCBPModeDr=$lg(^DHCBPArrange(bpaId),26)
	s bpaReceiveTime="" //获取当次透析接诊时间
	s arrExtValue=##class(web.DHCBPArrangeExtend).GetArrangeExtendValue(bpaId,"SignInReceiveTime")
	i arrExtValue'="" s bpaReceiveTime= $p(arrExtValue,$c(3),1)
	s bpsiId="",siUserId="",siUserDesc="",siDateTime="" //签到
	f  s bpsiId=$o(^DHCBPSignIn(0,"Date",curDate,bpsiId)) q:bpsiId=""  d 
		.s siRegNo=$lg(^DHCBPSignIn(bpsiId),1)
		.q:regNo'=siRegNo
		.s siDate=$lg(^DHCBPSignIn(bpsiId),2)
		.s siDate=##class(web.DHCClinicCom).ConvertToDate(siDate)
		.s siTime=$lg(^DHCBPSignIn(bpsiId),3)
		.s siTime=##class(web.DHCClinicCom).ConvertToTime(siTime)
		.s siDateTime=siDate_" "_siDate
		.s siStatus=$lg(^DHCBPSignIn(bpsiId),4)
		.q:siStatus="D"
		.s siCtcp=$lg(^DHCBPSignIn(bpsiId),5)
		.i siCtcp'="" d
			..s siUserId=$o(^SSU("SSUSR",0,"CTPCP",siCtcp,""))			
			..s siUserDesc=$p($g(^SSU("SSUSR",siUserId)),"^",2)
		.s siDaySeqNo=$lg(^DHCBPSignIn(bpsiId),8)
		.q:bpaDaySeqNo'=siDaySeqNo
	s bpaCheckDocId="", bpaCheckDocDesc="",bpaCheckDateTime="" //透析前记录	
	s bpaCheckDocDr=$lg(^DHCBPArrange(bpaId),91) //透析前记录	
	i bpaCheckDocDr'="" d
		.s bpaCheckDocId=$o(^SSU("SSUSR",0,"CTPCP",bpaCheckDocDr,""))
		.s bpaCheckDocDesc=$p($g(^SSU("SSUSR",bpaCheckDocId)),"^",2)
	s bpaCheckDate=$lg(^DHCBPArrange(bpaId),92)
	i bpaCheckDate'="" s bpaCheckDate=##class(web.DHCClinicCom).ConvertToDate(bpaCheckDate)
	s bpaCheckTime=$lg(^DHCBPArrange(bpaId),93)
	i bpaCheckTime'="" s bpaCheckTime=##class(web.DHCClinicCom).ConvertToTime(bpaCheckTime)	
	s bpaCheckDateTime=bpaCheckDate_" "_bpaCheckTime
	q:bpaCheckDocId="" 0
	s bpaStartOperationNurseId="", bpaStartOperationNurseDesc="",bpaStartOperationDateTime="" //上机
	s bpaStartOperationNurseDr=$lg(^DHCBPArrange(bpaId),103)
	i bpaStartOperationNurseDr'="" d
		.s bpaStartOperationNurseId=$o(^SSU("SSUSR",0,"CTPCP",bpaStartOperationNurseDr,""))
		.s bpaStartOperationNurseDesc=$p($g(^SSU("SSUSR",bpaStartOperationNurseId)),"^",2)
	s bpaStartOperationDate=$lg(^DHCBPArrange(bpaId),104)
	i bpaStartOperationDate'="" s bpaStartOperationDate=##class(web.DHCClinicCom).ConvertToDate(bpaStartOperationDate)
	s bpaStartOperationTime=$lg(^DHCBPArrange(bpaId),105)
	i bpaStartOperationTime'="" s bpaStartOperationTime=##class(web.DHCClinicCom).ConvertToTime(bpaStartOperationTime)
	s bpaStartOperationDateTime=bpaStartOperationDate_" "_bpaStartOperationTime
	q:bpaStartOperationNurseId="" 0
	s bprSttTime="",quit=0,bprUserId="",bprUserDesc="",bprStartDateTime=""  //透析中记录（第一条时间点）
	f  s bprSttTime=$o(^DHCBPRecord(0,"DateTime",curDate,bpaId,bprSttTime)) q:bprSttTime=""||(quit=1)   d
		.s bprId=$o(^DHCBPRecord(0,"DateTime",curDate,bpaId,bprSttTime,""))
	   	.s bprStartDate=$li(^DHCBPRecord(bprId),5)
	   	.i bprStartDate'="" s bprStartDate=##class(web.DHCClinicCom).ConvertToDate(bprStartDate)
		.s bprStartTime=$li(^DHCBPRecord(bprId),6)
		.i bprStartTime'="" s bprStartTime=##class(web.DHCClinicCom).ConvertToTime(bprStartTime)
		.s bprStartDateTime=bprStartDate_" "_bprStartTime
		.s bprUserId=$li(^DHCBPRecord(bprId),21) 
		.i bprUserId'="" s bprUserDesc=$p($g(^SSU("SSUSR",bprUserId)),"^",2)
	   	.s quit=1
	s bpaEndOperationNurseId="", bpaEndOperationNurseDesc="",bpaEndOperationDateTime="" //透析后记录
	s bpaEndOperationNurseDr=$lg(^DHCBPArrange(bpaId),106)
	i bpaEndOperationNurseDr'="" d
		.s bpaEndOperationNurseId=$o(^SSU("SSUSR",0,"CTPCP",bpaEndOperationNurseDr,""))
		.s bpaEndOperationNurseDesc=$p($g(^SSU("SSUSR",bpaEndOperationNurseId)),"^",2)
	s bpaEndOperationDate=$lg(^DHCBPArrange(bpaId),107)
	i bpaEndOperationDate'="" s bpaEndOperationDate=##class(web.DHCClinicCom).ConvertToDate(bpaEndOperationDate)
	s bpaEndOperationTime=$lg(^DHCBPArrange(bpaId),108)
	i bpaEndOperationTime'="" s bpaEndOperationTime=##class(web.DHCClinicCom).ConvertToTime(bpaEndOperationTime)
	s bpaEndOperationDateTime=bpaEndOperationDate_" "_bpaEndOperationTime
	q:bpaEndOperationNurseId="" 0
	
	s bpatNurAssNurseId="", bpatNurAssNurseDesc="",bpatNurAssDateTime="" //护理评估
	s arrExtValue=##class(web.DHCBPArrangeExtend).GetArrangeExtendValue(bpaId,"NurAssessmentMark")
	i arrExtValue'="" d
		.s bpatNurAssNurseId= $p(arrExtValue,$c(3),3)
		.i bpatNurAssNurseId'="" s bpatNurAssNurseDesc=$p($g(^SSU("SSUSR",bpatNurAssNurseId)),"^",2)
		.s bpatNurAssDate= $p(arrExtValue,$c(3),4)
		.s bpatNurAssTime= $p(arrExtValue,$c(3),5)		
		.s bpatNurAssDateTime=bpatNurAssDate_" "_bpatNurAssTime	
	q 0
}

}
