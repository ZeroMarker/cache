/// 医保首页接口数据
Class CIS.AN.SRV.Assembler.INSU.OperInfo Extends %RegisteredObject
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
		if (params.OperationID'="")
		{
			set list=$lb(params.OperationID)
		}
	    
	   	if (list'="")
	    {
	        for i=1:1:$ll(list)
	        {
		        set opId=$lg(list,i)
		        set rset=##class(%ResultSet).%New("CIS.AN.SRV.Assembler.INSU.OperInfo:FindOperScheduleInfo")
				do rset.Execute(opId)
				while (rset.Next()) 
				{
					set instance=##class(CIS.AN.DTO.INSU.OperScheduleInfo).Create()
					
					set query=##class(%ResultSet).%New("CIS.AN.COM.DataService:FindProperties")
        			set sc=query.Execute("CIS.AN.DTO.INSU.OperScheduleInfo")
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

/// 4401 住院病案首页信息
/// d ##class(%ResultSet).RunQuery("CIS.AN.SRV.Assembler.INSU.OperInfo","FindOperScheduleInfo","1")
Query FindOperScheduleInfo(opId As %String) As %Query(ROWSPEC = "operDate,operDesc,operCode,operSeqNo,operClassCode,operClassDesc,surgeonDesc,firstAssistDesc,secondAssistDesc,healLevelDesc,healLevelCode,anaMethodDesc,anaMethodCode,anesthesiologistDesc,bodySiteDesc,bodySiteCode,operDuration,asaLvDesc,asaLvCode,patTypeDesc,patTypeCode,mainOperFlag,asaClassCode,asaClassDesc,anMedicineCode,anMedicineDesc,anMedicineDose,anMedicineUnit,anaStartDT,anaEndDT,anComplicationCode,anComplicationName,anComplicationDesc,pacuInDT,pacuOutDT,operCancelFlag,validateFlag,homePageNo,serialNo,operBeginTime,operEndTime") [ SqlProc ]
{
}

ClassMethod FindOperScheduleInfoExecute(ByRef qHandle As %Binary, opId As %String) As %Status
{
	
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	if ('##class(CIS.AN.OperList).%ExistsId(opId))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	set obj=##class(CIS.AN.OperList).%OpenId(opId)
	set opsId=obj.OperSchedule.%Id()
	
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
	set operBeginTime=""						;40	oprn_oprt_begntime	手术操作开始时间
	set operEndTime=""							;41	oprn_oprt_endtime	手术操作结束时间
	
	set rset=##class(%ResultSet).%New("CIS.AN.BL.OperScheduleList:FindOperScheduleList")
	do rset.Execute("","","",opsId)
	while (rset.Next()) 
	{                                                                                         
		set operDate=rset.Get("OperDate")
		set operSeqNo=rset.Get("OperSeq")  
		set surgeonDesc=rset.Get("SurgeonDesc") 
		set firstAssistDesc=rset.Get("PlanFirstAsstDesc") 
		set secondAssistDesc=rset.Get("PlanSecAsstDesc") 
		                         
		set anaMethodDesc=rset.Get("PrevAnaMethodDesc")                                                      
		set anesthesiologistDesc=rset.Get("AnesthesiologistDesc")   
		set anesthesiologistCode=rset.Get("Anesthesiologist") 
		
		set operDuration=rset.Get("OperDuration")  
		
		set sourceType=rset.Get("SourceType") 
		if (sourceType="B") set patTypeDesc="择期手术", patTypeCode=3
		if (sourceType="E") set patTypeDesc="急诊手术", patTypeCode=2
		
		set ASAClass=rset.Get("ASAClass")
		set asaClassCode=##class(CIS.AN.COM.String).GetDescByID("User.ORCASAClassPhActiv","ORASACode",ASAClass)
		set asaClassDesc=rset.Get("ASAClassDesc") 
		
		set asaLvDesc=asaClassDesc
		set asaLvCode=rset.Get("ASAClass") 
		
		set anaStartDT=rset.Get("AnaStartDT")
		set anaEndDT=rset.Get("AnaFinishDT")
		
		set pacuInDT=rset.Get("PACUInDT")
		set pacuOutDT=rset.Get("PACUOutDT")
		
		set StatusCode=rset.Get("StatusCode")
		if StatusCode="Cancel" set operCancelFlag="1"
		
		set validateFlag="Y"
		
		set operBeginTime=rset.Get("OperStartDT")
		set operEndTime=rset.Get("OperFinishDT")
	}
	
	set rset2=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
	set sc=rset2.Execute(opsId)
    while(rset2.%Next())
    {
        set targetOpId=rset2.Get("RowId")
        continue:targetOpId'=opId
        
        set operId=rset2.Get("Operation")
        set operDesc=rset2.Get("OperationDesc")
        set operCode=##class(CIS.AN.COM.String).GetDescByID("User.ORCOperation","OPERCode",operId)
        
        set surgeonId=rset2.Get("Surgeon")
        set surgeonDesc=rset2.Get("SurgeonDesc")
        set surgeonCode=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPCode",surgeonId)
        
        set operClassId=rset2.Get("OperClass")
        set operClassDesc=rset2.Get("OperClassDesc")
        set operClassCode=##class(CIS.AN.COM.String).GetDescByID("User.ORCOperationCategory","CATEGCode",operClassId)
        
        set bodySiteDesc=rset2.Get("BodySiteDesc")
        set bodySiteCode=rset2.Get("BodySite")
         
    }		
	
	
	do OutputRow
	
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

}
