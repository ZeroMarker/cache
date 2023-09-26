/// 旧版手麻对医保接口(张生坤)
Class DHCCL.Product.ForINSU.OperServiceOld Extends %RegisteredObject
{

/// 4401 住院病案首页信息
/// d ##class(%ResultSet).RunQuery("DHCCL.Implement.ANOld.OperArrangeService","FindOperScheduleInfo","10792198")
Query FindOperScheduleInfo(AdmDr As %String) As %Query(ROWSPEC = "oprn_oprt_date,oprn_oprt_name,oprn_oprt_code,oprn_oprt_sn,oprn_lv_code,oprn_lv_name,oper_name,asit_1_name,asit_name2,sinc_heal_lv,sinc_heal_lv_code,anst_mtd_name,anst_mtd_code,anst_dr_name,oprn_oper_part,oprn_oper_part_code,oprn_con_time,anst_lv_name,anst_lv_code,oprn_patn_type,oprn_patn_type_code,main_oprn_flag,anst_asa_lv_code,anst_asa_lv_name,anst_medn_code,anst_medn_name,anst_medn_dos,unt,anst_begntime,anst_endtime,anst_copn_code,anst_copn_name,anst_copn_dscr,pacu_begntime,pacu_endtime,canc_oprn_flag,vali_flag,ipt_medcas_hmpg_sn,mdtrt_sn") [ SqlProc ]
{
}

ClassMethod FindOperScheduleInfoExecute(ByRef qHandle As %Binary, AdmDr As %String) As %Status
{
	
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set operDate=""								;1	oprn_oprt_date	手术操作日期
	set operDesc=""								;2	oprn_oprt_name	手术操作名称
	set operCode=""								;3	oprn_oprt_code	手术操作代码
	set operSeqNo=""							;4	oprn_oprt_sn	手术操作序列号
	set operClassCode="" 						;5	oprn_lv_code	手术级别代码
	set operClassDesc=""						;6	oprn_lv_name	手术级别名称
	set surgeonDesc=""							;7	oper_name	手术者姓名
	set firstAssistDesc=""						;8	asit1_name	助手Ⅰ姓名
	set secondAssistDesc=""						;9	asit2_name	助手Ⅱ姓名
	set healLevelDesc=""						;10	sinc_heal_lv	手术切口愈合等级
	set healLevelCode=""						;11	sinc_heal_lv_code	手术切口愈合等级代码
	set anaMethodDesc=""						;12	anst_mtd_name	麻醉-方法名称
	set anaMethodCode=""						;13	anst_mtd_code	麻醉-方法代码
	set anesthesiologistDesc=""					;14	anst_dr_name	麻醉医师姓名
	set bodySiteDesc=""							;15	oprn_oper_part	手术操作部位
	set bodySiteCode=""							;16	oprn_oper_part_code	手术操作部位代码
	set operDuration=""							;17	oprn_con_time	手术持续时间
	set asaLvDesc=""							;18	anst_lv_name	麻醉分级名称
	set asaLvCode=""							;19	anst_lv_code	麻醉分级代码
	set patTypeDesc=""							;20	oprn_patn_type	手术患者类型  1非手术患者  2急诊手术   3择期手术
	set patTypeCode=""							;21	oprn_patn_type_code	手术患者类型代码
	set mainOperFlag=""							;22	main_oprn_flag	主要手术标志
	set asaClassCode=""							;23	anst_asa_lv_code	麻醉ASA分级代码
	set asaClassDesc=""							;24	anst_asa_lv_name	麻醉ASA分级名称
	set anMedicineCode=""						;25	anst_medn_code	麻醉药物代码
	set anMedicineDesc=""						;26	anst_medn_name	麻醉药物名称
	set anMedicineDose=""						;27	anst_medn_dos	麻醉药物剂量
	set anMedicineUnit=""						;28	unt	计量单位
	set anaStartDT=""							;29	anst_begntime	麻醉开始时间
	set anaEndDT=""								;30	anst_endtime	麻醉结束时间
	set anComplicationCode=""					;31	anst_copn_code	麻醉合并症代码
	set anComplicationName=""					;32	anst_copn_name	麻醉合并症名称
	set anComplicationDesc=""					;33	anst_copn_dscr	麻醉合并症描述
	set pacuInDT=""								;34	pacu_begntime	复苏室开始时间
	set pacuOutDT=""							;35	pacu_endtime	复苏室结束时间
	set operCancelFlag="0"						;36	canc_oprn_flag	取消手术标志
	set validateFlag=""							;37	vali_flag	有效标志
	set homePageNo=""							;38	ipt_medcas_hmpg_sn	住院病案首页流水号
	set serialNo=""								;39	mdtrt_sn	就医流水号

	set rset=##class(%ResultSet).%New("DHCCL.Implement.ANOld.OperArrangeService:FindOperArrangeList")
	do rset.Execute("","","",AdmDr)
	while (rset.Next()) 
	{                                                                                         
		set operDate=rset.Get("OperDate")
		set operSeqNo=rset.Get("OperSeq")  
		set surgeonDesc=rset.Get("SurgeonDesc") 
		set firstAssistDesc=rset.Get("PlanFirstAsstDesc") 
		set secondAssistDesc=rset.Get("PlanSecAsstDesc") 
		                         
		set anaMethodDesc=rset.Get("PrevAnaMethodDesc")                                                      
		set anesthesiologistDesc=rset.Get("AnaesthetistDesc")   
		set anesthesiologistCode=rset.Get("AnaesthetistId") 
		
		set operDuration=rset.Get("OperDuration")  
		
		set sourceType=rset.Get("SourceTypeCode") 
		if (sourceType="B") set patTypeDesc="择期手术", patTypeCode=3
		if (sourceType="E") set patTypeDesc="急诊手术", patTypeCode=2
		
		set ASAClass=rset.Get("ASAId")
		set asaClassCode=rset.Get("ASACode")
		set asaClassDesc=rset.Get("ASADesc") 
		
		set asaLvDesc=asaClassDesc
		set asaLvCode=rset.Get("ASACode") 
		
		set anaStartDT=rset.Get("AnaStartDT")
		set anaEndDT=rset.Get("AnaFinishDT")
		
		set pacuInDT=rset.Get("PACUInDT")
		set pacuOutDT=rset.Get("PACUOutDT")
		
		set StatusCode=rset.Get("Status")
		if "C^D"[StatusCode set operCancelFlag="1"
		
		set validateFlag="Y"
	    set operId=rset.Get("OperId")
	    set operDesc=rset.Get("OperDesc")
	    set operCode=""
	    
	    set surgeonId=rset.Get("SurgeonId")
	    set surgeonDesc=rset.Get("SurgeonDesc")
	    set surgeonCode=""
	    
	    set operClassId=rset.Get("OperClass")
	    set operClassDesc=rset.Get("OperClassDesc")
	    set operClassCode=""
	    set bodySiteDesc=rset.Get("BodySiteDesc")
	    set bodySiteCode=rset.Get("BodySiteId")
		do OutputRow1
	}
	
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputRow1
	set Data=$lb(operDate,operDesc,operCode,operSeqNo,operClassCode,operClassDesc,surgeonDesc,firstAssistDesc,secondAssistDesc,healLevelDesc,healLevelCode,anaMethodDesc,anaMethodCode,anesthesiologistDesc,bodySiteDesc,bodySiteCode,operDuration,asaLvDesc,asaLvCode,patTypeDesc,patTypeCode,mainOperFlag,asaClassCode,asaClassDesc,anMedicineCode,anMedicineDesc,anMedicineDose,anMedicineUnit,anaStartDT,anaEndDT,anComplicationCode,anComplicationName,anComplicationDesc,pacuInDT,pacuOutDT,operCancelFlag,validateFlag,homePageNo,serialNo)
	Set ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindOperScheduleInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperScheduleInfoExecute ]
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

ClassMethod FindOperScheduleInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperScheduleInfoExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// 4701  电子病历上传  手术记录
/// d ##class(%ResultSet).RunQuery("DHCCL.Implement.ANOld.OperArrangeService","FindOperRecord","11166770")
Query FindOperRecord(AdmDr As %String) As %Query(ROWSPEC = "oprn_appy_id,oprn_seq,blotype_abo,oprn_time,oprn_type_code,oprn_type_name,bfpn_diag_code,bfpn_oprn_diag_name,bfpn_inhosp_ifet,afpn_diag_code,afpn_diag_name,sinc_heal_lv_code,sinc_heal_lv,back_oprn,selv,prev_abtl_medn,abtl_medn_days,oprn_oprt_code,oprn_oprt_name,oprn_lv_code,oprn_lv_name,anst_mtd_code,anst_mtd_name,anst_lv_code,anst_lv_name,exe_anst_dept_code,exe_anst_dept_name,anst_efft,oprn_begntime,oprn_endtime,oprn_asps,oprn_asps_ifet,afpn_info,oprn_merg,oprn_conc,oprn_anst_dept_code,oprn_anst_dept_name,palg_dise,oth_med_dspo,out_std_oprn_time,oprn_oper_name,oprn_asit_name1,oprn_asit_name2,anst_dr_name,anst_asa_lv_code,anst_asa_lv_name,anst_medn_code,anst_medn_name,anst_medn_dos,anst_dosunt,anst_begntime,anst_endtime,anst_merg_symp_code,anst_merg_symp,anst_merg_symp_dscr,pacu_begntime,pacu_endtime,oprn_selv,canc_oprn,vali_flag") [ SqlProc ]
{
}

ClassMethod FindOperRecordExecute(ByRef qHandle As %Binary, AdmDr As %String) As %Status
{
	
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set operIdList=##class(web.DHCANAdaptor).GetOpaIdStrByAdmId(AdmDr)
	set operIdCount=$l(operIdList,"^")
	for i=1:1:operIdCount
	{
		set opaId=$p(operIdList,"^",i)
		q:opaId=""
		continue:($d(^DHCANOPArrange(opaId))=0)
		do Output(opaId)
	}
	
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
Output(opaId)
	set rset=##class(%ResultSet).%New("DHCCL.Implement.ANOld.OperArrangeService:FindOperArrangeList")
	do rset.Execute("","","",opaId)
	while (rset.Next()) 
	{
		set sourceType=rset.Get("SourceType")
		set isBookedOper="N"
		if sourceType="B" set isBookedOper="Y"
		set duration=rset.Get("OperDuration")
		set ifBeyondDeadtime="N"
		if (+duration>3) set ifBeyondDeadtime="Y"
		set StatusCode=rset.Get("StatusCode")
		set ifCancelOper="N"
		if StatusCode="Cancel" set ifCancelOper="Y"
		set isValidate="Y"
		if (StatusCode="Cancel" || StatusCode="Revoke" || StatusCode="Decline") set isValidate="N"
		
		
		set applyId=opaId   										;1	oprn_appy_id	手术申请单号
		set operSeqNo=rset.Get("OperSeq")							;2	oprn_seq	手术序列号
		set bloodType=rset.Get("BloodType")							;3	blotype_abo	ABO血型代码
		set operDate=rset.Get("OperDate")	     					;4	oprn_time	手术日期
		set operTypeCode=""											;5	oprn_type_code	手术分类代码
		set operTypeDesc=""											;6	oprn_type_name	手术分类名称
		set preDiagCode=""											;7	bfpn_diag_code	术前诊断代码
		set preDiagDesc=rset.Get("PrevDiagnosis")                   ;8	bfpn_oprn_diag_name	术前诊断名称
		set infect=rset.Get("InfectionOper") 						;9	bfpn_inhosp_ifet	术前是否发生院内感染
		set diagCode=""												;10	afpn_diag_code	术后诊断代码
		set diagDesc=rset.Get("PostDiagnosis")  					;11	afpn_diag_name	术后诊断名称
		set healLevelCode=""										;12	sinc_heal_lv_code	手术切口愈合等级代码
		set healLevelDesc=""										;13	sinc_heal_lv	手术切口愈合等级
		set reentryOperation=rset.Get("PostDiagnosis") 				;14	back_oprn	是否重返手术（明确定义）
		set selv=isBookedOper 										;15	selv	是否择期
		set isUseAntibiotics="N"										;16	prev_abtl_medn	是否预防使用抗菌药物
		set useAntibioticsDays=""									;17	abtl_medn_days	预防使用抗菌药物天数
		set operCode=""												;18	oprn_oprt_code	手术操作代码
		set operDesc=rset.Get("OperDesc")							;19	oprn_oprt_name	手术操作名称
		set operClassCode=""										;20	oprn_lv_code	手术级别代码
		set operClassDesc=rset.Get("OperClassDesc")					;21	oprn_lv_name	手术级别名称
		set anaMethodCode=rset.Get("AnaMethod")						;22	anst_mtd_code	麻醉-方法代码
		set anaMethodDesc=rset.Get("AnaMethodDesc")					;23	anst_mtd_name	麻醉-方法名称
		set ASACode=rset.Get("ASACode")							;24	anst_lv_code	麻醉分级代码
		set ASADesc=rset.Get("ASADesc")						;25	anst_lv_name	麻醉分级名称
		set anDeptCode=rset.Get("AnaDept")							;26	exe_anst_dept_code	麻醉执行科室代码
		set anDeptDesc=rset.Get("AnaDeptDesc")						;27	exe_anst_dept_name	麻醉执行科室名称
		set anestEffect=""											;28	anst_efft	麻醉效果
		set theatreInDT=rset.Get("TheatreInDT")						;29	oprn_begntime	手术开始时间
		set theatreOutDT=rset.Get("TheatreOutDT")      				;30	oprn_endtime	手术结束时间
		set isAsepsis=""											;31	oprn_asps	是否无菌手术
		set isAsepsisInfect=""										;32	oprn_asps_ifet	无菌手术是否感染
		set postOperInfo=""											;33	afpn_info	手术后情况
		set ifHasComplication=""									;34	oprn_merg	是否手术合并症
		set ifHasSyndrome=""										;35	oprn_conc	是否手术并发症
		set operDeptCode=rset.Get("OperDeptID")						;36	oprn_anst_dept_code	手术执行科室代码
		set operDeptDesc=rset.Get("OperDeptDesc")					;37	oprn_anst_dept_name	手术执行科室名称
		set pathology=""											;38	palg_dise	病理检查
		set otherMedicalDisposal=""									;39	oth_med_dspo	其他医学处置
		set outStandOperTime=ifBeyondDeadtime  						;40	out_std_oprn_time	是否超出标准手术时间
		set surgeonDesc=rset.Get("SurgeonDesc")						;41	oprn_oper_name	手术者姓名
		set firstAsstDesc=rset.Get("FirstAsstDesc")					;42	oprn_asit_name1	助手I姓名
		set secondAsstDesc=rset.Get("SecAsstDesc")					;43	oprn_asit_name2	助手Ⅱ姓名
		set anesthesiologistDesc=rset.Get("AnesthesiologistDesc")	;44	anst_dr_name	麻醉医师姓名
		set ASAClassCode=rset.Get("ASACode")						;45	anst_asa_lv_code	麻醉ASA分级代码
		set ASAClassDesc=rset.Get("ASADesc")					;46	anst_asa_lv_name	麻醉ASA分级名称
		set anaDrugCode=""											;47	anst_medn_code	麻醉药物代码
		set anaDrugDesc=""											;48	anst_medn_name	麻醉药物名称
		set anaDrugDose=""											;49	anst_medn_dos	麻醉药物剂量
		set anaDrugUnit=""											;50	anst_dosunt	计量单位
		set theatreInDT=rset.Get("TheatreInDT")						;51	anst_begntime	麻醉开始时间
		set theatreOutDT=rset.Get("TheatreOutDT")					;52	anst_endtime	麻醉结束时间
		set complicationCode=""										;53	anst_merg_symp_code	麻醉合并症代码
		set complicationName=""										;54	anst_merg_symp	麻醉合并症名称
		set complicationDesc=""										;55	anst_merg_symp_dscr	麻醉合并症描述
		set pacuInDT=rset.Get("PacuInDT")							;56	pacu_begntime	入复苏室时间
		set pacuOutDT=rset.Get("PacuOutDT")							;57	pacu_endtime	出复苏室时间
		set operSelv=isBookedOper 									;58	oprn_selv	是否择期手术
		set isCanceledOper=ifCancelOper								;59	canc_oprn	是否择取消手术
		set validateFlag=isValidate									;60	vali_flag	有效标志
		do OutputRow
	}
	quit 
	
	
OutputRow
	set Data=$lb(applyId,operSeqNo,bloodTyp,operDate,operTypeCode,operTypeDesc,preDiagCode,preDiagDesc,infect,diagCode,diagDesc,healLevelCode,healLevelDesc,reentryOperation,selv,isUseAntibiotics,useAntibioticsDays,operCode,operDesc,operClassCode,operClassDesc,anaMethodCode,anaMethodDesc,ASACode,ASADesc,anDeptCode,anDeptDesc,anestEffect,theatreInDT,theatreOutDT,isAsepsis,isAsepsisInfect,postOperInfo,ifHasComplication,ifHasSyndrome,operDeptCode,operDeptDesc,pathology,otherMedicalDisposal,outStandOperTime,surgeonDesc,firstAsstDesc,secondAsstDesc,anesthesiologistDesc,ASAClassCode,ASAClassDesc,anaDrugCode,anaDrugDesc,anaDrugDose,anaDrugUnit,theatreInDT,theatreOutDT,complicationCode,complicationName,complicationDesc,pacuInDT,pacuOutDT,operSelv,isCanceledOper,validateFlag)
	Set ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindOperRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperRecordExecute ]
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

ClassMethod FindOperRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperRecordExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

}
