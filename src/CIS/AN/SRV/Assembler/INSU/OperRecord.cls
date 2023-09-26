/// 4701  电子病历上传  手术记录
Class CIS.AN.SRV.Assembler.INSU.OperRecord Extends %RegisteredObject
{

/// 数据表名
Parameter TableName = "CIS.AN.OperSchedule";

/// 外部系统
Parameter ExternalSystem = "INSU";

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

ClassMethod Query(params As CIS.AN.DTO.ENS.Request.Arguments) As %ListOfObjects
{
	set collection=##class(%ListOfObjects).%New()
	if ..VerifyInput(params)
	{
		//查询Query，或者调用业务方法
		set list=""
		if (params.EpisodeID'="")
		{
			set list=$lb(params.EpisodeID)
		}
	    
	   	if (list'="")
	    {
	        for i=1:1:$ll(list)
	        {
		        set EpisodeID=$lg(list,i)
		        
		        set rset=##class(%ResultSet).%New("CIS.AN.SRV.Assembler.INSU.OperRecord:FindOperRecord")
				do rset.Execute(EpisodeID)
				while (rset.Next()) 
				{
					set instance=##class(CIS.AN.DTO.INSU.OperRecord).Create()
					set query=##class(%ResultSet).%New("CIS.AN.COM.DataService:FindProperties")
        			set sc=query.Execute("CIS.AN.DTO.INSU.OperRecord")
        			while(query.%Next())
        			{
	        			set propertyName=query.Get("Name")
	            		set $property(instance,propertyName)=rset.Get(propertyName)
        			}
        			
        			do collection.Insert(instance)
				}
	        }
	    }
	}
	
	quit collection
}

ClassMethod VerifyInput(params As CIS.AN.DTO.ENS.Request.Arguments) As %Boolean
{
	quit 1
}

/// 4701  电子病历上传  手术记录
/// d ##class(%ResultSet).RunQuery("CIS.AN.SRV.Assembler.INSU.OperRecord","FindOperRecord","12")
Query FindOperRecord(AdmDr As %String) As %Query(ROWSPEC = "applyId,operSeqNo,bloodTyp,operDate,operTypeCode,operTypeDesc,preDiagCode,preDiagDesc,infect,diagCode,diagDesc,healLevelCode,healLevelDesc,reentryOperation,selv,isUseAntibiotics,useAntibioticsDays,operCode,operDesc,operClassCode,operClassDesc,anaMethodCode,anaMethodDesc,ASACode,ASADesc,anDeptCode,anDeptDesc,anestEffect,theatreInDT,theatreOutDT,isAsepsis,isAsepsisInfect,postOperInfo,ifHasComplication,ifHasSyndrome,operDeptCode,operDeptDesc,pathology,otherMedicalDisposal,outStandOperTime,surgeonDesc,firstAsstDesc,secondAsstDesc,anesthesiologistDesc,ASAClassCode,ASAClassDesc,anaDrugCode,anaDrugDesc,anaDrugDose,anaDrugUnit,theatreInDT,theatreOutDT,complicationCode,complicationName,complicationDesc,pacuInDT,pacuOutDT,operSelv,isCanceledOper,validateFlag") [ SqlProc ]
{
}

ClassMethod FindOperRecordExecute(ByRef qHandle As %Binary, AdmDr As %String) As %Status
{
	
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set operIdList=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm(AdmDr)
	set operIdCount=$l(operIdList,",")
	for i=1:1:operIdCount
	{
		set opsId=$p(operIdList,",",i)
		continue:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
		do Output(opsId)
	}
	
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
Output(opsId)
	set rset=##class(%ResultSet).%New("CIS.AN.BL.OperScheduleList:FindOperScheduleList")
	do rset.Execute("","","",opsId)
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
		
		set PrevDiagnosis=rset.Get("PrevDiagnosis")
		set PrevDiagnosisCode=..GetDiagnosisCode(PrevDiagnosis)
		set PrevDiagnosisDesc=..GetDiagnosisCode(PrevDiagnosis,"Y")
		
		set PostDiagnosis=rset.Get("PostDiagnosis")
		set PostDiagnosisCode=..GetDiagnosisCode(PostDiagnosis)
		set PostDiagnosisDesc=..GetDiagnosisCode(PostDiagnosis,"Y")
		
		set seqNo=0
		
		set rs=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
	    set sc=rs.Execute(opsId)
	    while(rs.%Next())
	    {
		    set opListId=rs.Get("RowId")
	        set operId=rs.Get("Operation")
	        set operCode1=##class(CIS.AN.COM.String).GetDescByID("User.ORCOperation","OPERCode",operId)
	        set OperationDesc=rs.Get("OperationDesc")
	        
	        set OperClassId=rs.Get("OperClass") 
	        set OperClassCode=##class(CIS.AN.COM.String).GetDescByID("User.ORCOperationCategory","CATEGCode",OperClassId)
	        set OperClassDesc=rs.Get("OperClassDesc")
	        
	        set BladeTypeId=rs.Get("BladeType")
	        set BladeTypeCode=##class(CIS.AN.COM.String).GetDescByID("User.ORCBladeType","BLDTPCode",BladeTypeId)
	        set BladeTypeDesc=rs.Get("BladeTypeDesc")
	        
	        set BodySiteId=rs.Get("BodySite")
	        set BodySiteCode=##class(CIS.AN.COM.String).GetDescByID("User.OECBodySite","BODSCode",BodySiteId)
	        set BodySiteDesc=rs.Get("BodySiteDesc")
	        
	        set OperPosId=rs.Get("OperPos")
	        set OperPosCode=##class(CIS.AN.COM.String).GetDescByID("User.ORCOperPosition","OPPOSCode",OperPosId)
	        set OperPosDesc=rs.Get("OperPosDesc")
	        
	        set SurgeonId=rs.Get("OperPosDesc")
	        set SurgeonDesc=rs.Get("SurgeonDesc")
	        
	        set SurgeonExpert=rs.Get("SurgeonExpert")
	        set Assistant=rs.Get("Assistant")
	        set AssistantDesc=rs.Get("AssistantDesc")
	        set OperNote=rs.Get("OperNote")
	        
	        set firstAssistantDesc=$p(AssistantDesc,",",1)
	        set secondAssistantDesc=$p(AssistantDesc,",",2)
	        
	        set seqNo=seqNo+1
	        
	        do OutputSingleOperation
	    }
		
	}
	quit 
	
OutputSingleOperation
	set applyId=opsId   										;1	oprn_appy_id	手术申请单号
	set operSeqNo=opListId  ;;rset.Get("OperSeq")					;2	oprn_seq	手术序列号
	set bloodType=rset.Get("BloodType")							;3	blotype_abo	ABO血型代码
	set operDate=rset.Get("OperDate")	     					;4	oprn_time	手术日期
	set operTypeCode=""											;5	oprn_type_code	手术分类代码
	set operTypeDesc=""											;6	oprn_type_name	手术分类名称
	set preDiagCode=PrevDiagnosisCode											;7	bfpn_diag_code	术前诊断代码
	set preDiagDesc=PrevDiagnosisDesc  ;;rset.Get("PrevDiagnosis")                   ;8	bfpn_oprn_diag_name	术前诊断名称
	set infect=rset.Get("InfectionOper") 						;9	bfpn_inhosp_ifet	术前是否发生院内感染
	set diagCode=PostDiagnosisCode												;10	afpn_diag_code	术后诊断代码
	set diagDesc=PostDiagnosisDesc  ;;rset.Get("PostDiagnosis")  					;11	afpn_diag_name	术后诊断名称
	set healLevelCode=""										;12	sinc_heal_lv_code	手术切口愈合等级代码
	set healLevelDesc=""										;13	sinc_heal_lv	手术切口愈合等级
	set reentryOperation=rset.Get("ReentryOperation")      ;;rset.Get("PostDiagnosis") 		;14	back_oprn	是否重返手术（明确定义）
	set selv=isBookedOper 										;15	selv	是否择期
	set isUseAntibiotics=""										;16	prev_abtl_medn	是否预防使用抗菌药物
	set useAntibioticsDays=""									;17	abtl_medn_days	预防使用抗菌药物天数
	set operCode=operCode1										;18	oprn_oprt_code	手术操作代码
	set operDesc=OperationDesc									;19	oprn_oprt_name	手术操作名称
	set operClassCode=OperClassCode								;20	oprn_lv_code	手术级别代码
	set operClassDesc=OperClassDesc								;21	oprn_lv_name	手术级别名称
	set anaMethodCode=rset.Get("AnaMethod")						;22	anst_mtd_code	麻醉-方法代码
	set anaMethodDesc=rset.Get("AnaMethodDesc")					;23	anst_mtd_name	麻醉-方法名称
	set ASACode=rset.Get("ASAClass")							;24	anst_lv_code	麻醉分级代码
	set ASADesc=rset.Get("ASAClassDesc")						;25	anst_lv_name	麻醉分级名称
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
	set surgeonDesc=SurgeonDesc   ;;rset.Get("SurgeonDesc")						;41	oprn_oper_name	手术者姓名
	set firstAsstDesc=firstAssistantDesc  ;rset.Get("FirstAsstDesc")					;42	oprn_asit_name1	助手I姓名
	set secondAsstDesc=secondAssistantDesc   ;rset.Get("SecAsstDesc")					;43	oprn_asit_name2	助手Ⅱ姓名
	set anesthesiologistDesc=rset.Get("AnesthesiologistDesc")	;44	anst_dr_name	麻醉医师姓名
	set ASAClassCode=rset.Get("ASAClass")						;45	anst_asa_lv_code	麻醉ASA分级代码
	set ASAClassDesc=rset.Get("ASAClassDesc")					;46	anst_asa_lv_name	麻醉ASA分级名称
	set anaDrugCode=""											;47	anst_medn_code	麻醉药物代码
	set anaDrugDesc=""											;48	anst_medn_name	麻醉药物名称
	set anaDrugDose=""											;49	anst_medn_dos	麻醉药物剂量
	set anaDrugUnit=""											;50	anst_dosunt	计量单位
	set theatreInDT=rset.Get("TheatreInDT")						;51	anst_begntime	麻醉开始时间
	set theatreOutDT=rset.Get("TheatreOutDT")					;52	anst_endtime	麻醉结束时间
	set complicationCode=""										;53	anst_merg_symp_code	麻醉合并症代码
	set complicationName=""										;54	anst_merg_symp	麻醉合并症名称
	set complicationDesc=""										;55	anst_merg_symp_dscr	麻醉合并症描述
	set pacuInDT=rset.Get("PACUInDT")							;56	pacu_begntime	入复苏室时间
	set pacuOutDT=rset.Get("PACUOutDT")							;57	pacu_endtime	出复苏室时间
	set operSelv=isBookedOper 									;58	oprn_selv	是否择期手术
	set isCanceledOper=ifCancelOper								;59	canc_oprn	是否择取消手术
	set validateFlag=isValidate									;60	vali_flag	有效标志
	
	do OutputRow
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

}
