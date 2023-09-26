/// 病案首页数据，获取手术申请信息
Class DHCCL.Product.ForINSU.OperService Extends %RegisteredObject
{

/// 4401 住院病案首页信息
/// d ##class(%ResultSet).RunQuery("DHCCL.Product.ForINSU.OperService","FindOperScheduleInfo","1")
Query FindOperScheduleInfo(opId As %String) As %Query(ROWSPEC = "oprn_oprt_date,oprn_oprt_name,oprn_oprt_code,oprn_oprt_sn,oprn_lv_code,oprn_lv_name,oper_name,asit1_name,asit2_name,sinc_heal_lv,sinc_heal_lv_code,anst_mtd_name,anst_mtd_code,anst_dr_name,oprn_oper_part,oprn_oper_part_code,oprn_con_time,anst_lv_name,anst_lv_code,oprn_patn_type,oprn_patn_type_code,main_oprn_flag,anst_asa_lv_code,anst_asa_lv_name,anst_medn_code,anst_medn_name,anst_medn_dos,unt,anst_begntime,anst_endtime,anst_copn_code,anst_copn_name,anst_copn_dscr,pacu_begntime,pacu_endtime,canc_oprn_flag,vali_flag,ipt_medcas_hmpg_sn,mdtrt_sn,oprn_oprt_begntime,oprn_oprt_endtime") [ SqlProc ]
{
}

ClassMethod FindOperScheduleInfoExecute(ByRef qHandle As %Binary, opId As %String) As %Status
{
	
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1

	set SourceSystem="SYS0001"
	set MessageID="MES0009"
	set msg="<Request><Header><SourceSystem>"_SourceSystem_"</SourceSystem><MessageID>"_MessageID_"</MessageID></Header><Body><Arguments><OperationID>"_opId_"</OperationID></Arguments></Body></Request>"
	set request=##class(%Stream.GlobalCharacter).%New()
    do request.Write(msg)
    
    set response=""
    set dbMode=##class(web.DHCENS.STBLL.MANAGE.MergeInstance).GetSystemDbMode("AN","") 
    if (dbMode="共库")
    {
	    set insuObj=##class(CIS.AN.SRV.DirectConn.Server.ForINSU).%New()
		set response=insuObj.Get4401OperInfo(request)
	}
    else
    {
	    set insuSoap=##class(DHCCL.WebService.Soap.HISServiceInsuSoap).%New()
		set response=insuSoap.HIPMessageServer(MessageID,request)
	}
    
	
	set reader=##class(%XML.Reader).%New()
	do reader.OpenStream(response)
	do reader.Correlate("Model","DHCCL.Product.ForINSU.DTO.OperScheduleInfo")
	While (reader.Next(.object,.sc)) 
	{
		set operDate=object.operDate											;1	oprn_oprt_date	手术操作日期
		set operDesc=object.operDesc											;2	oprn_oprt_name	手术操作名称
		set operCode=object.operCode											;3	oprn_oprt_code	手术操作代码
		set operSeqNo=object.operSeqNo											;4	oprn_oprt_sn	手术操作序列号
		set operClassCode=object.operClassCode 									;5	oprn_lv_code	手术级别代码
		set operClassDesc=object.operClassDesc									;6	oprn_lv_name	手术级别名称
		set surgeonDesc=object.surgeonDesc										;7	oper_name	手术者姓名
		set firstAssistDesc=object.firstAssistDesc								;8	asit1_name	助手Ⅰ姓名
		set secondAssistDesc=object.secondAssistDesc							;9	asit2_name	助手Ⅱ姓名
		set healLevelDesc=object.healLevelDesc									;10	sinc_heal_lv	手术切口愈合等级
		set healLevelCode=object.healLevelCode									;11	sinc_heal_lv_code	手术切口愈合等级代码
		set anaMethodDesc=object.anaMethodDesc									;12	anst_mtd_name	麻醉-方法名称
		set anaMethodCode=object.anaMethodCode									;13	anst_mtd_code	麻醉-方法代码
		set anesthesiologistDesc=object.anesthesiologistDesc					;14	anst_dr_name	麻醉医师姓名
		set bodySiteDesc=object.bodySiteDesc									;15	oprn_oper_part	手术操作部位
		set bodySiteCode=object.bodySiteCode									;16	oprn_oper_part_code	手术操作部位代码
		set operDuration=object.operDuration									;17	oprn_con_time	手术持续时间
		set asaLvDesc=object.asaLvDesc											;18	anst_lv_name	麻醉分级名称
		set asaLvCode=object.asaLvCode											;19	anst_lv_code	麻醉分级代码
		set patTypeDesc=object.patTypeDesc										;20	oprn_patn_type	手术患者类型  1非手术患者  2急诊手术   3择期手术
		set patTypeCode=object.patTypeCode										;21	oprn_patn_type_code	手术患者类型代码
		set mainOperFlag=object.mainOperFlag									;22	main_oprn_flag	主要手术标志
		set asaClassCode=object.asaClassCode									;23	anst_asa_lv_code	麻醉ASA分级代码
		set asaClassDesc=object.asaClassDesc									;24	anst_asa_lv_name	麻醉ASA分级名称
		set anMedicineCode=object.anMedicineCode								;25	anst_medn_code	麻醉药物代码
		set anMedicineDesc=object.anMedicineDesc								;26	anst_medn_name	麻醉药物名称
		set anMedicineDose=object.anMedicineDose								;27	anst_medn_dos	麻醉药物剂量
		set anMedicineUnit=object.anMedicineUnit								;28	unt	计量单位
		set anaStartDT=object.anaStartDT										;29	anst_begntime	麻醉开始时间
		set anaEndDT=object.anaEndDT											;30	anst_endtime	麻醉结束时间
		set anComplicationCode=object.anComplicationCode						;31	anst_copn_code	麻醉合并症代码
		set anComplicationName=object.anComplicationName						;32	anst_copn_name	麻醉合并症名称
		set anComplicationDesc=object.anComplicationDesc						;33	anst_copn_dscr	麻醉合并症描述
		set pacuInDT=object.pacuInDT											;34	pacu_begntime	复苏室开始时间
		set pacuOutDT=object.pacuOutDT											;35	pacu_endtime	复苏室结束时间
		set operCancelFlag=object.operCancelFlag								;36	canc_oprn_flag	取消手术标志
		set validateFlag=object.validateFlag									;37	vali_flag	有效标志
		set homePageNo=object.homePageNo										;38	ipt_medcas_hmpg_sn	住院病案首页流水号
		set serialNo=object.serialNo											;39	mdtrt_sn	就医流水号
		set operBeginTime=object.operBeginTime									;40	oprn_oprt_begntime	手术操作开始时间
		set operEndTime=object.operEndTime										;41	oprn_oprt_endtime	手术操作结束时间
		
		do OutputRow
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
	

	
OutputRow
	set Data=$lb(operDate,operDesc,operCode,operSeqNo,operClassCode,operClassDesc,surgeonDesc,firstAssistDesc,secondAssistDesc,healLevelDesc,healLevelCode,anaMethodDesc,anaMethodCode,anesthesiologistDesc,bodySiteDesc,bodySiteCode,operDuration,asaLvDesc,asaLvCode,patTypeDesc,patTypeCode,mainOperFlag,asaClassCode,asaClassDesc,anMedicineCode,anMedicineDesc,anMedicineDose,anMedicineUnit,anaStartDT,anaEndDT,anComplicationCode,anComplicationName,anComplicationDesc,pacuInDT,pacuOutDT,operCancelFlag,validateFlag,homePageNo,serialNo,operBeginTime,operEndTime)
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
/// d ##class(%ResultSet).RunQuery("DHCCL.Product.ForINSU.OperService","FindOperRecord","12")
Query FindOperRecord(AdmDr As %String) As %Query(ROWSPEC = "oprn_appy_id,oprn_seq,blotype_abo,oprn_time,oprn_type_code,oprn_type_name,bfpn_diag_code,bfpn_oprn_diag_name,bfpn_inhosp_ifet,afpn_diag_code,afpn_diag_name,sinc_heal_lv_code,sinc_heal_lv,back_oprn,selv,prev_abtl_medn,abtl_medn_days,oprn_oprt_code,oprn_oprt_name,oprn_lv_code,oprn_lv_name,anst_mtd_code,anst_mtd_name,anst_lv_code,anst_lv_name,exe_anst_dept_code,exe_anst_dept_name,anst_efft,oprn_begntime,oprn_endtime,oprn_asps,oprn_asps_ifet,afpn_info,oprn_merg,oprn_conc,oprn_anst_dept_code,oprn_anst_dept_name,palg_dise,oth_med_dspo,out_std_oprn_time,oprn_oper_name,oprn_asit_name1,oprn_asit_name2,anst_dr_name,anst_asa_lv_code,anst_asa_lv_name,anst_medn_code,anst_medn_name,anst_medn_dos,anst_dosunt,anst_begntime,anst_endtime,anst_merg_symp_code,anst_merg_symp,anst_merg_symp_dscr,pacu_begntime,pacu_endtime,oprn_selv,canc_oprn,vali_flag") [ SqlProc ]
{
}

ClassMethod FindOperRecordExecute(ByRef qHandle As %Binary, AdmDr As %String) As %Status
{
	
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set SourceSystem="SYS0001"
	set MessageID="MES0010"
	set msg="<Request><Header><SourceSystem>"_SourceSystem_"</SourceSystem><MessageID>"_MessageID_"</MessageID></Header><Body><Arguments><EpisodeID>"_AdmDr_"</EpisodeID></Arguments></Body></Request>"
	set request=##class(%Stream.GlobalCharacter).%New()
    do request.Write(msg)
    
    set response=""
    set dbMode=##class(web.DHCENS.STBLL.MANAGE.MergeInstance).GetSystemDbMode("AN","")
    if (dbMode="共库")
    {
	    set insuObj=##class(CIS.AN.SRV.DirectConn.Server.ForINSU).%New()
		set response=insuObj.Get4701OperRecord(request)
	}
    else
    {
	    set insuSoap=##class(DHCCL.WebService.Soap.HISServiceInsuSoap).%New()
		set response=insuSoap.HIPMessageServer(MessageID,request)
	}
	
	set reader=##class(%XML.Reader).%New()
	do reader.OpenStream(response)
	do reader.Correlate("Model","DHCCL.Product.ForINSU.DTO.OperRecord")
	While (reader.Next(.object,.sc)) 
	{
		set applyId=object.applyId   													;1	oprn_appy_id	手术申请单号
		set operSeqNo=object.operSeqNo													;2	oprn_seq	手术序列号
		set bloodType=object.bloodType													;3	blotype_abo	ABO血型代码
		set operDate=object.operDate	     											;4	oprn_time	手术日期
		set operTypeCode=object.operTypeCode											;5	oprn_type_code	手术分类代码
		set operTypeDesc=object.operTypeDesc											;6	oprn_type_name	手术分类名称
		set preDiagCode=object.preDiagCode												;7	bfpn_diag_code	术前诊断代码
		set preDiagDesc=object.preDiagDesc                   							;8	bfpn_oprn_diag_name	术前诊断名称
		set infect=object.infect 														;9	bfpn_inhosp_ifet	术前是否发生院内感染
		set diagCode=object.diagCode													;10	afpn_diag_code	术后诊断代码
		set diagDesc=object.diagDesc  													;11	afpn_diag_name	术后诊断名称
		set healLevelCode=object.healLevelCode											;12	sinc_heal_lv_code	手术切口愈合等级代码
		set healLevelDesc=object.healLevelDesc											;13	sinc_heal_lv	手术切口愈合等级
		set reentryOperation=object.reentryOperation      								;14	back_oprn	是否重返手术（明确定义）
		set selv=object.selv 															;15	selv	是否择期
		set isUseAntibiotics=object.isUseAntibiotics									;16	prev_abtl_medn	是否预防使用抗菌药物
		set useAntibioticsDays=object.useAntibioticsDays								;17	abtl_medn_days	预防使用抗菌药物天数
		set operCode=object.operCode													;18	oprn_oprt_code	手术操作代码
		set operDesc=object.operDesc													;19	oprn_oprt_name	手术操作名称
		set operClassCode=object.operClassCode											;20	oprn_lv_code	手术级别代码
		set operClassDesc=object.operClassDesc											;21	oprn_lv_name	手术级别名称
		set anaMethodCode=object.anaMethodCode											;22	anst_mtd_code	麻醉-方法代码
		set anaMethodDesc=object.anaMethodDesc											;23	anst_mtd_name	麻醉-方法名称
		set ASACode=object.ASACode														;24	anst_lv_code	麻醉分级代码
		set ASADesc=object.ASADesc														;25	anst_lv_name	麻醉分级名称
		set anDeptCode=object.anDeptCode												;26	exe_anst_dept_code	麻醉执行科室代码
		set anDeptDesc=object.anDeptDesc												;27	exe_anst_dept_name	麻醉执行科室名称
		set anestEffect=object.anestEffect												;28	anst_efft	麻醉效果
		set operStartDT=object.operStartDT												;29	oprn_begntime	手术开始时间
		set operEndDT=object.operEndDT      											;30	oprn_endtime	手术结束时间
		set isAsepsis=object.isAsepsis 													;31	oprn_asps	是否无菌手术
		set isAsepsisInfect=object.isAsepsisInfect										;32	oprn_asps_ifet	无菌手术是否感染
		set postOperInfo=object.postOperInfo											;33	afpn_info	手术后情况
		set ifHasComplication=object.ifHasComplication									;34	oprn_merg	是否手术合并症
		set ifHasSyndrome=object.ifHasSyndrome											;35	oprn_conc	是否手术并发症
		set operDeptCode=object.operDeptCode											;36	oprn_anst_dept_code	手术执行科室代码
		set operDeptDesc=object.operDeptDesc											;37	oprn_anst_dept_name	手术执行科室名称
		set pathology=object.pathology													;38	palg_dise	病理检查
		set otherMedicalDisposal=object.otherMedicalDisposal							;39	oth_med_dspo	其他医学处置
		set outStandOperTime=object.outStandOperTime  									;40	out_std_oprn_time	是否超出标准手术时间
		set surgeonDesc=object.surgeonDesc												;41	oprn_oper_name	手术者姓名
		set firstAsstDesc=object.firstAsstDesc											;42	oprn_asit_name1	助手I姓名
		set secondAsstDesc=object.secondAsstDesc										;43	oprn_asit_name2	助手Ⅱ姓名
		set anesthesiologistDesc=object.anesthesiologistDesc							;44	anst_dr_name	麻醉医师姓名
		set ASAClassCode=object.ASAClassCode											;45	anst_asa_lv_code	麻醉ASA分级代码
		set ASAClassDesc=object.ASAClassDesc											;46	anst_asa_lv_name	麻醉ASA分级名称
		set anaDrugCode=object.anaDrugCode												;47	anst_medn_code	麻醉药物代码
		set anaDrugDesc=object.anaDrugDesc												;48	anst_medn_name	麻醉药物名称
		set anaDrugDose=object.anaDrugDose												;49	anst_medn_dos	麻醉药物剂量
		set anaDrugUnit=object.anaDrugUnit												;50	anst_dosunt	计量单位
		set theatreInDT=object.theatreInDT												;51	anst_begntime	麻醉开始时间
		set theatreOutDT=object.theatreOutDT											;52	anst_endtime	麻醉结束时间
		set complicationCode=object.complicationCode									;53	anst_merg_symp_code	麻醉合并症代码
		set complicationName=object.complicationName									;54	anst_merg_symp	麻醉合并症名称
		set complicationDesc=object.complicationDesc									;55	anst_merg_symp_dscr	麻醉合并症描述
		set pacuInDT=object.pacuInDT													;56	pacu_begntime	入复苏室时间
		set pacuOutDT=object.pacuOutDT													;57	pacu_endtime	出复苏室时间
		set operSelv=object.operSelv													;58	oprn_selv	是否择期手术
		set isCanceledOper=object.isCanceledOper										;59	canc_oprn	是否择取消手术
		set validateFlag=object.validateFlag											;60	vali_flag	有效标志
		
		do OutputRow
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
		
OutputRow
	set Data=$lb(applyId,operSeqNo,bloodTyp,operDate,operTypeCode,operTypeDesc,preDiagCode,preDiagDesc,infect,diagCode,diagDesc,healLevelCode,healLevelDesc,reentryOperation,selv,isUseAntibiotics,useAntibioticsDays,operCode,operDesc,operClassCode,operClassDesc,anaMethodCode,anaMethodDesc,ASACode,ASADesc,anDeptCode,anDeptDesc,anestEffect,operStartDT,operEndDT,isAsepsis,isAsepsisInfect,postOperInfo,ifHasComplication,ifHasSyndrome,operDeptCode,operDeptDesc,pathology,otherMedicalDisposal,outStandOperTime,surgeonDesc,firstAsstDesc,secondAsstDesc,anesthesiologistDesc,ASAClassCode,ASAClassDesc,anaDrugCode,anaDrugDesc,anaDrugDose,anaDrugUnit,theatreInDT,theatreOutDT,complicationCode,complicationName,complicationDesc,pacuInDT,pacuOutDT,operSelv,isCanceledOper,validateFlag)
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

/// 4302 计费医保组判断是否是急诊留观
/// d ##class(%ResultSet).RunQuery("DHCCL.Product.ForINSU.OperService","FindEmergencyOperInfo","12")
Query FindEmergencyOperInfo(AdmDr As %String, ByRef Params As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "mdtrt_sn,mdtrt_id,psn_no,medrcdno,oprn_oprt_sn,oprn_oprt_code,oprn_oprt_name,oprn_oprt_tagt_ part_name,itvt_name,oprn_oprt_mtd_ dscr,oprn_oprt_cnt,oprn_oprt_time,vali_flag") [ SqlProc ]
{
}

ClassMethod FindEmergencyOperInfoExecute(ByRef qHandle As %Binary, AdmDr As %String, ByRef Params As %ArrayOfDataTypes = "") As %Status
{
	
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	s (mdtrtsn, mdtrtid, psnno)=""
	
	if ($IsObject(Params))
	{
		s mdtrtsn=Params.GetAt("mdtrt_sn")
		s mdtrtid=Params.GetAt("mdtrt_id")
		s psnno=Params.GetAt("psn_no")
	}
	
	set SourceSystem="SYS0001"
	set MessageID="MES0011"
	set msg="<Request><Header><SourceSystem>"_SourceSystem_"</SourceSystem><MessageID>"_MessageID_"</MessageID></Header><Body><Arguments><EpisodeID>"_AdmDr_"</EpisodeID></Arguments></Body></Request>"
	set request=##class(%Stream.GlobalCharacter).%New()
    do request.Write(msg)
    
    set response=""
    set dbMode=##class(web.DHCENS.STBLL.MANAGE.MergeInstance).GetSystemDbMode("AN","")
    if (dbMode="共库")
    {
	    set insuObj=##class(CIS.AN.SRV.DirectConn.Server.ForINSU).%New()
		set response=insuObj.Get4302EmergencyOperInfo(request)
	}
    else
    {
	    set insuSoap=##class(DHCCL.WebService.Soap.HISServiceInsuSoap).%New()
		set response=insuSoap.HIPMessageServer(MessageID,request)
	}
	
	set reader=##class(%XML.Reader).%New()
	do reader.OpenStream(response)
	do reader.Correlate("Model","DHCCL.Product.ForINSU.DTO.EmergencyOperInfo")
	While (reader.Next(.object,.sc)) 
	{
		set sn=mdtrtsn																;1	mdtrt_sn	就医流水号
		set id=mdtrtid																;2	mdtrt_id	就诊ID
		set no=psnno																;3	psn_no	人员编号
		set medrcdno=object.medrcdno												;4	medrcdno	病历号
		set seqNo=object.seqNo														;5	oprn_oprt_sn	手术操作序号
		set operCode=object.operCode												;6	oprn_oprt_code	手术操作代码
		set operDesc=object.operDesc												;7	oprn_oprt_name	手术操作名称
		set bodySite=object.bodySite												;8	oprn_oprt_tagt_ part_name	手术操作目标部位名称
		set interventionName=object.interventionName								;9	itvt_name	介入物名称
		set operMethodDesc=object.operMethodDesc									;10	oprn_oprt_mtd_ dscr	手术及操作方法描述
		set operCnt=object.operCnt													;11	oprn_oprt_cnt	手术及操作次数
		set operTime=object.operTime												;12	oprn_oprt_time	手术及操作时间
		set validateFlag=object.validateFlag										;13	vali_flag	有效标志
		do OutputRow
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputRow
	set Data=$lb(sn,id,no,medrcdno,seqNo,operCode,operDesc,bodySite,interventionName,operMethodDesc,operCnt,operTime,validateFlag)
	Set ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindEmergencyOperInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEmergencyOperInfoExecute ]
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

ClassMethod FindEmergencyOperInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEmergencyOperInfoExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// 入参就诊id  返回值：本次就诊存在日间手术就是2  不存在就是1
/// w ##class(DHCCL.Product.ForINSU.OperService).GetIfDaySurgeny(29)
ClassMethod GetIfDaySurgeny(AdmDr As %String) As %String
{
	set IfDaySurgery="N"
	
	set operIdList=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm(AdmDr)
	set operIdCount=$l(operIdList,",")
	for i=1:1:operIdCount
	{
		set opsId=$p(operIdList,",",i)
		continue:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
		set rset=##class(%ResultSet).%New("CIS.AN.BL.OperScheduleList:FindOperScheduleList")
		do rset.Execute("","","",opsId)
		while (rset.Next()) 
		{
			set DaySurgery=rset.Get("DaySurgery")
			if DaySurgery="Y" set IfDaySurgery="Y"
		}
	}
	
	set result=1
	if IfDaySurgery="Y" set result=2
	quit result
}

ClassMethod GetDiagnosisCode(diagnosis As %String, showDiagDesc As %String = "") As %String
{
	set diagDescStr=""
	set ret=diagnosis,diagStr=""
	set diagnosisCount=$l(diagnosis,"&&&")
	for i=1:1:diagnosisCount
	{
		set curDiagnosis=$p(diagnosis,"&&&",i)
		set diagId=$p(curDiagnosis,"###",1)
		set diagDesc=$p(curDiagnosis,"###",2)
		set diagNote=$p(curDiagnosis,"###",3)

		set diagCode=##class(CIS.AN.COM.String).GetDescByIDStr("User.MRCICDDx","MRCIDCode",diagId)
		//if diagStr="" set diagStr=diagCode
		//if diagStr="" set diagStr=diagStr
		//else  set diagStr=diagStr_","_diagCode
		//set diagStr=diagStr_","_diagCode
		if i=diagnosisCount set diagStr=diagStr_diagCode
		else  set diagStr=diagStr_diagCode_","
		
		
		if diagNote'="" set diagDesc=diagDesc_"("_diagNote_")"
		if i=diagnosisCount set diagDescStr=diagDescStr_diagDesc
		else  set diagDescStr=diagDescStr_diagDesc_","
	}
	
	quit:showDiagDesc="Y" diagDescStr
		
	quit diagStr
}

/// w ##class(DHCCL.Product.ForINSU.OperService).Test()
ClassMethod Test()
{
	set insuSoap=##class(DHCCL.WebService.Soap.HISServiceInsuSoap).%New()
	//set msg="<Request><Header><SourceSystem>SYS0001</SourceSystem><MessageID>MES0009</MessageID></Header><Body><Arguments><OperationID>1</OperationID></Arguments></Body></Request>"
	set msg="<Request><Header><SourceSystem>SYS0001</SourceSystem><MessageID>MES0011</MessageID></Header><Body><Arguments><EpisodeID>12</EpisodeID></Arguments></Body></Request>"
	set stream=##class(%Stream.GlobalCharacter).%New()
    do stream.Write(msg)
	set rtn=insuSoap.HIPMessageServer("MES0011",stream).Read()
	quit rtn
}

}
