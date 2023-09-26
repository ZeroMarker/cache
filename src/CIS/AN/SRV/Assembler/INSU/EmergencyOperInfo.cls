/// 4302 计费医保组判断是否是急诊留观
Class CIS.AN.SRV.Assembler.INSU.EmergencyOperInfo Extends %RegisteredObject
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
		        
		        set rset=##class(%ResultSet).%New("CIS.AN.SRV.Assembler.INSU.EmergencyOperInfo:FindEmergencyOperInfo")
				do rset.Execute(EpisodeID)
				while (rset.Next()) 
				{
					set instance=##class(CIS.AN.DTO.INSU.EmergencyOperInfo).Create()
					set query=##class(%ResultSet).%New("CIS.AN.COM.DataService:FindProperties")
        			set sc=query.Execute("CIS.AN.DTO.INSU.EmergencyOperInfo")
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

/// 4302 计费医保组判断是否是急诊留观
/// d ##class(%ResultSet).RunQuery("CIS.AN.SRV.Assembler.INSU.EmergencyOperInfo","FindEmergencyOperInfo","12")
Query FindEmergencyOperInfo(AdmDr As %String, ByRef Params As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "sn,id,no,medrcdno,seqNo,operCode,operDesc,bodySite,interventionName,operMethodDesc,operCnt,operTime,validateFlag") [ SqlProc ]
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
		continue:sourceType'="E"
		
		set StatusCode=rset.Get("StatusCode")
		set isValidate="Y"
		if (StatusCode="Cancel" || StatusCode="Revoke" || StatusCode="Decline") set isValidate="N"
		
		set operCount1=0, operCode1=""
		set rs=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
	    set sc=rs.Execute(opsId)
	    while(rs.%Next())
	    {
	        set operId=rs.Get("Operation")
	        set operCount1=operCount1+1
	        if operCode1="" set operCode1=##class(CIS.AN.COM.String).GetDescByID("User.ORCOperation","OPERCode",operId)
	        else  set operCode1=operCode1_","_##class(CIS.AN.COM.String).GetDescByID("User.ORCOperation","OPERCode",operId)
	    }
		
		
		set sn=mdtrtsn													;1	mdtrt_sn	就医流水号
		set id=mdtrtid													;2	mdtrt_id	就诊ID
		set no=psnno													;3	psn_no	人员编号
		set medrcdno=rset.Get("MedcareNo")								;4	medrcdno	病历号
		set seqNo=rset.Get("OperSeq")									;5	oprn_oprt_sn	手术操作序号
		set operCode=operCode1											;6	oprn_oprt_code	手术操作代码
		set operDesc=rset.Get("OperDesc")								;7	oprn_oprt_name	手术操作名称
		set bodySite=rset.Get("BodySiteDesc")							;8	oprn_oprt_tagt_ part_name	手术操作目标部位名称
		set interventionName=""											;9	itvt_name	介入物名称
		set operMethodDesc=""											;10	oprn_oprt_mtd_ dscr	手术及操作方法描述
		set operCnt=operCount1											;11	oprn_oprt_cnt	手术及操作次数
		set operTime=rset.Get("OperStartDT")							;12	oprn_oprt_time	手术及操作时间
		set validateFlag=isValidate										;13	vali_flag	有效标志
		do OutputRow
	}
	quit 
	
	
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

}
