Class web.DHCCLMappingData Extends %RegisteredObject
{

/// w ##class(web.DHCCLMappingData).MappingInit("")
ClassMethod MappingInit(ChangeType As %String = "") As %String
{
	if ChangeType="Clear" do
	.kill ^DHCCLMappingRecord, ^DHCCLMappingLog, ^DHCCLC("MappingService"), ^DHCCLC("MappingEntity"), ^DHCCLC("MappingCode")
	quit:ChangeType="Clear" "数据已清"
	
	set date=$p($h,",",1)
	set time=$p($h,",",2)
	//视图
	set ret=..InsertMappingService("Loc","科室视图","V")
	set ret=..InsertMappingService("CareProv","医护人员视图","V")
	set ret=..InsertMappingService("Arcim","药品视图","V")
	set ret=..InsertMappingService("Trans","转科视图","V")
	set ret=..InsertMappingService("Oeori","医嘱视图","V")
	set ret=..InsertMappingService("Lab","检验视图","V")
	set ret=..InsertMappingService("InOut","出入院视图","V")
	//码表映射
	set ret=..InsertMappingService("SSGroupCodeMapping","安全组码表映射","C")
	//数据映射
	set ret=..InsertMappingService("PatientNoRecordMapping","病人No数据映射","R")
	quit 0
}

ClassMethod InsertMappingService(CLCMSCode As %String, CLCMSDesc As %String, CLCMSType As %String)
{
	set date=$p($h,",",1)
	set time=$p($h,",",2)
	
	if (..GetServiceIdByCode(CLCMSCode)="") &SQL(INSERT INTO SQLUSER.DHC_CLC_MappingService(CLCMS_Code,CLCMS_Desc,CLCMS_Type,CLCMS_UpdateDate,CLCMS_UpdateTime) VALUES (:CLCMSCode,:CLCMSDesc,:CLCMSType,:date,:time))
	quit 0
}

/// Creator：      	wll
/// CreatDate：    	2016-04-27
/// Description： 	查找服务表数据
/// Table：        	DHC_CLC_MappingService
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCCLMappingData","FindMappingService")
Query FindMappingService() As %Query(ROWSPEC = "RowId,Code,Desc,Type,UDate,UTime") [ SqlProc ]
{
}

ClassMethod FindMappingServiceExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set rowId=0
	for
	{
		set rowId=$order(^DHCCLC("MappingService",rowId))
		quit:(rowId="")
		set code=$list(^DHCCLC("MappingService",rowId),1)
		set desc=$list(^DHCCLC("MappingService",rowId),2)
		set type=$list(^DHCCLC("MappingService",rowId),3)
		set udate=$list(^DHCCLC("MappingService",rowId),4)
		if udate'="" s udate=$zd(udate,3)
		set utime=$list(^DHCCLC("MappingService",rowId),5)
		if utime'="" s utime=$zt(utime,1)
		do OutputRow	
	}
	
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(rowId,code,desc,type,udate,utime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindMappingServiceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMappingServiceExecute ]
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

ClassMethod FindMappingServiceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMappingServiceExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	wll
/// CreatDate：    	2016-04-27
/// Description： 	保存服务表
/// Table：        	DHC_CLC_MappingService
/// Input:			rowId:服务表ID,code:服务表代码,desc:服务表名称,type:服务表类型
/// Return：       	保存成功返回ID，失败返回错误原因
/// w ##class(web.DHCCLMappingData).SaveMappingService()
ClassMethod SaveMappingService(rowId, code, desc, type) As %String
{
	quit:(code="")!(desc="")!(type="") "-1^code, desc, type不能为空"
	quit:(rowId="")&($d(^DHCCLC("MappingService",0,"Code",code))) "Code不能重复"
	
	set mappingService=""
	if (+rowId>0)
	{
		set mappingService=##class(User.DHCCLCMappingService).%OpenId(rowId)
	}	
	else
	{
		set mappingService=##class(User.DHCCLCMappingService).%New()	
	}
	
	set mappingService.CLCMSCode=code
	set mappingService.CLCMSDesc=desc
	set mappingService.CLCMSType=type
	set mappingService.CLCMSUpdateDate=+$h
	set mappingService.CLCMSUpdateTime=$p($h,",",2)
	
	set status=mappingService.%Save()
	
	set result=""
	if ($System.Status.IsOK(status))
	{
		set result=mappingService.%Id()	
	}
	else
	{
		set result=$System.Status.GetErrorText(status)	
	}
	
	quit result
}

/// Creator：      	wll
/// CreatDate：    	2016-04-27
/// Description： 	删除服务表数据
/// Table：        	DHC_CLC_MappingService
/// Input:			rowId:服务表ID
/// Return：       	删除成功返回0，失败返回错误原因
/// w ##class(web.DHCCLMappingData).RemoveMappingService()
ClassMethod RemoveMappingService(rowId) As %String
{
	set mappingService=##class(User.DHCCLCMappingService).%New()
	set status=mappingService.%DeleteId(rowId)
	set result=""
	if ($System.Status.IsOK(status))
	{
		set result="0"	
	}	
	else
	{
		set result=$System.Status.GetErrorText(status)	
	}
	
	quit result
}

/// Creator：      	wll
/// CreatDate：    	2016-04-27
/// Description： 	查找映射实体码表
/// Table：        	DHC_CLC_MappingEntity
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCCLMappingData","FindMappingEntity")
Query FindMappingEntity() As %Query(ROWSPEC = "RowId,Code,Desc,ClcmsDr,ClcmsDesc,UDate,UTime") [ SqlProc ]
{
}

ClassMethod FindMappingEntityExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set rowId=0
	for
	{
		set rowId=$order(^DHCCLC("MappingEntity",rowId))
		quit:(rowId="")
		set code=$list(^DHCCLC("MappingEntity",rowId),1)
		set desc=$list(^DHCCLC("MappingEntity",rowId),2)
		set clcmsdr=$list(^DHCCLC("MappingEntity",rowId),3)
		if clcmsdr'="" set clcmsdesc=$listget(^DHCCLC("MappingService",clcmsdr),2)
		else  set clcmsdesc=""
		set udate=$list(^DHCCLC("MappingEntity",rowId),4)
		if udate'="" s udate=$zd(udate,3)
		set utime=$list(^DHCCLC("MappingEntity",rowId),5)
		if utime'="" s utime=$zt(utime,2)
		do OutputRow	
	}
	
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(rowId,code,desc,clcmsdr,clcmsdesc,udate,utime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindMappingEntityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMappingEntityExecute ]
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

ClassMethod FindMappingEntityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMappingEntityExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	wll
/// CreatDate：    	2016-04-27
/// Description： 	保存映射实体码表
/// Table：        	DHC_CLC_MappingEntity
/// Input:			rowId:映射码表ID,code:映射码表代码,desc:映射码表名称,clcmsdr:指向服务
/// Return：       	保存成功返回ID，失败返回错误原因
/// w ##class(web.DHCCLMappingData).SaveMappingEntity()
ClassMethod SaveMappingEntity(rowId, code, desc, clcmsdr) As %String
{
	set mappingEntity=""
	if (+rowId>0)
	{
		set mappingEntity=##class(User.DHCCLCMappingEntity).%OpenId(rowId)
	}	
	else
	{
		set mappingEntity=##class(User.DHCCLCMappingEntity).%New()	
	}
	
	if (code'="") set mappingEntity.CLCMECode=code
	if (desc'="") set mappingEntity.CLCMEDesc=desc
	
    if (##class(User.DHCCLCMappingService).%ExistsId(clcmsdr))
	{
		set mappingEntity.CLCMECLCMSDr=##class(User.DHCCLCMappingService).%OpenId(clcmsdr)	
	}
	
	set mappingEntity.CLCMEUpdateDate=+$h
	set mappingEntity.CLCMEUpdateTime=$p($h,",",2)
	
	set status=mappingEntity.%Save()
	
	set result=""
	if ($System.Status.IsOK(status))
	{
		set result=mappingEntity.%Id()	
	}
	else
	{
		set result=$System.Status.GetErrorText(status)	
	}
	
	quit result
}

/// Creator：      	wll
/// CreatDate：    	2016-04-27
/// Description： 	删除映射实体码表
/// Table：        	DHC_CLC_MappingEntity
/// Input:			rowId:映射实体码表ID
/// Return：       	删除成功返回0，失败返回错误原因
/// w ##class(web.DHCCLMappingData).RemoveMappingEntity()
ClassMethod RemoveMappingEntity(rowId) As %String
{
	set mappingEntity=##class(User.DHCCLCMappingEntity).%New()
	set status=mappingEntity.%DeleteId(rowId)
	set result=""
	if ($System.Status.IsOK(status))
	{
		set result="0"	
	}	
	else
	{
		set result=$System.Status.GetErrorText(status)	
	}
	
	quit result
}

/// w ##class(web.DHCCLMappingData).GetServiceIdByCode("Arcim")
ClassMethod GetServiceIdByCode(CLCMSCode As %String) As %String
{
	quit:CLCMSCode="" ""
	quit $o(^DHCCLC("MappingService",0,"Code",CLCMSCode,""))
}

/// w ##class(web.DHCCLMappingData).InsertLog("Loc","插入科室表","1","开始插入数据，para=1^2^3","Success")
ClassMethod InsertLog(LogType As %String, LogDesc As %String, LogSeq As %String, LogContent As %String, LogStatus As %String) As %String
{
	set serviceId=##class(web.DHCCLMappingData).GetServiceIdByCode(LogType)
	quit:serviceId="" "服务码表不对"
	
	quit:LogDesc="" "日志描述为空"
	quit:LogContent="" "日志内容为空"
	
	if LogStatus="" set LogStatus="Success"    //如果状态为空，默认为成功
	
	set LogStatus=$select(LogStatus["ExternalError":"X",LogStatus["Error":"E",LogStatus["Warning":"W",LogStatus["Success":"S",1:"")
	if LogStatus="" set LogStatus="S"
	set LogDate=$p($h,",",1)
	set LogTime=$p($h,",",2)
	set UpdateDate=$p($h,",",1)
	set UpdateTime=$p($h,",",2)
	
	&SQL(INSERT INTO SQLUSER.DHC_CL_MappingLog(CLML_CLCMS_Dr,CLML_Date,CLML_Time,CLML_Desc,CLML_Sequence,CLML_Content,CLML_Status,CLML_UpdateDate,CLML_UpdateTime) VALUES(:serviceId,:LogDate,:LogTime,:LogDesc,:LogSeq,:LogContent,:LogStatus,:UpdateDate,:UpdateTime))
	quit SQLCODE
}

ClassMethod ConvertToDateH(dateStr As %String, defaultVal As %String = "$H") As %String
{
	q:((dateStr="")!(dateStr<0))&(defaultVal="") ""
	q:(dateStr="")!(dateStr<0) +$h
	s $zt="ERROR"
	i ($l(dateStr,"/")>2)&(dateStr>1900) s dateStr=$tr(dateStr,"/","-")
	i $l(dateStr,"/")>2 q $zdh(dateStr,1)
	i $l(dateStr,"-")>2 q $zdh(dateStr,3)

	q +dateStr
ERROR	; 
	q:(defaultVal="") ""
	q +$h
}

ClassMethod ConvertToTimeH(timeStr As %String, defaultVal As %String = "$H") As %String
{
	q:((timeStr="")!(timeStr<0)!(timeStr>86399))&(defaultVal="") ""
	q:((timeStr="")!(timeStr<0)!(timeStr>86399))&(defaultVal="0") 0
	q:((timeStr="")!(timeStr<0)!(timeStr>86399)) $p($h,",",2)
	i $l(timeStr,":")>1 d
		.s tmpHour=+$p(timeStr,":")
		.s tmpHour=$p(tmpHour,".")
		.q:(tmpHour<0)!(tmpHour>23)
		.s $p(timeStr,":")=tmpHour
		.s tmpMinute=+$p(timeStr,":",2)
		.s tmpMinute=$p(tmpMinute,".")
		.q:(tmpMinute<0)!(tmpMinute>59)
		.s $p(timeStr,":",2)=tmpMinute
		.s tmpSecond=+$p(timeStr,":",3)
		.s tmpSecond=$p(tmpSecond,".")
		.q:(tmpSecond<0)!(tmpSecond>59)
		.
		.s timeStr=$ZTH(tmpHour_":"_tmpMinute_":"_tmpSecond,3)
	q +timeStr
}

/// Creator：      	lijie
/// CreatDate：    	2016-04-28
/// Description： 	查找一段时间内的日志
/// Table：        	DHC_CL_MappingLog
/// Input:			StartDate:开始日期 (YYYY-MM-DD)
/// 					StartTime:开始时间 (HH-mm-ss)
/// 					EndDate:结束日期 (YYYY-MM-DD)
/// 					EndTime:结束时间 (HH-mm-ss)
/// 					LogType:日志类型，可以是Loc,CareProv,Arcim,Trans,Oeori,Lab,InOut，多个类型之间用^隔开
///                 	LogDesc:日志描述，不包含日志描述的部分过滤掉
/// 					LogSeq:日志序号  
/// 					LogContent:日志内容，不包含日志内容的部分过滤掉
/// 					LogStatus:日志状态，可以是X(ExternalError),E(Error),W(Warning),S(Success)，多个状态之间用^隔开
/// 
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCCLMappingData","FindLogInfo","2016-04-28","00:00:00","2016-04-29","00:00:00","","","","","")
Query FindLogInfo(StartDate As %String, StartTime As %String, EndDate As %String, EndTime As %String, LogType As %String, LogDesc As %String, LogSeq As %String, LogContent As %String, LogStatus As %String) As %Query(ROWSPEC = "RowId,LogType,LogDesc,LogSeq,LogContent,LogStatus,LogDate,LogTime") [ SqlProc ]
{
}

ClassMethod FindLogInfoExecute(ByRef qHandle As %Binary, StartDate As %String, StartTime As %String, EndDate As %String, EndTime As %String, LogType As %String, LogDesc As %String, LogSeq As %String, LogContent As %String, LogStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set fromDate=##class(web.DHCCLMappingData).ConvertToDateH(StartDate)
	set fromTime=##class(web.DHCCLMappingData).ConvertToTimeH(StartTime)
	set toDate=##class(web.DHCCLMappingData).ConvertToDateH(EndDate)
	set toTime=##class(web.DHCCLMappingData).ConvertToTimeH(EndTime)
	
	if toDate<fromDate set toDate=fromDate
	if (toDate=fromDate)&(toTime<fromTime) set toTime=fromTime
	

	for date=fromDate:1:toDate
	{
		set serviceId=""
		for  set serviceId=$o(^DHCCLMappingLog(0,"Date",date,serviceId)) quit:serviceId=""  do
		.set type=$list(^DHCCLC("MappingService",serviceId),1)
		.quit:(LogType'="")&(("^"_LogType_"^")'[("^"_type_"^"))
		.set rowId=""
		.for  set rowId=$o(^DHCCLMappingLog(0,"Date",date,serviceId,rowId)) quit:rowId=""  do
		..set LogDate=$list(^DHCCLMappingLog(rowId),2)
		..set LogTime=$list(^DHCCLMappingLog(rowId),3)
		..quit:(LogDate=fromDate)&(LogTime<fromTime)
		..quit:(LogDate=toDate)&(LogTime>toTime)
		..set LogDate=$zd(LogDate,3)
		..set LogTime=$zt(LogTime)
		..set desc=$list(^DHCCLMappingLog(rowId),4)
		..quit:(LogDesc'="")&(desc'[LogDesc)
		..set seq=$list(^DHCCLMappingLog(rowId),5)
		..quit:(LogSeq'="")&(seq'=LogSeq)
		..set content=$list(^DHCCLMappingLog(rowId),6)
		..quit:(LogContent'="")&(content'[LogContent)
		..set status=$list(^DHCCLMappingLog(rowId),7)
		..quit:(LogStatus'="")&(("^"_LogStatus_"^")'[("^"_status_"^"))
		..set updateDate=$zd($list(^DHCCLMappingLog(rowId),8),3)
		..set updateTime=$zt($list(^DHCCLMappingLog(rowId),9))
		..do OutputRow	
	}
	
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(rowId,type,desc,seq,content,status,LogDate,LogTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindLogInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLogInfoExecute ]
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

ClassMethod FindLogInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLogInfoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// w ##class(web.DHCCLMappingData).SaveMappingCode("","SSGroupCodeMapping","23","住院护士","","22住院护士（核心）","22住院护士（核心）")
/// 保存映射代码表
ClassMethod SaveMappingCode(RowId As %String, MappingServiceCode As %String, CodeDr As %String, Code As %String, Desc As %String, MappedCode As %String, MappedDesc As %String) As %String
{
	set MappingServiceId=##class(web.DHCCLMappingData).GetServiceIdByCode(MappingServiceCode)
	quit:MappingServiceId="" "-1^MappingServiceCode不对"
	quit:CodeDr="" "-2^CodeDr不对"
	quit:Code="" "-3^Code不对"
	quit:MappedCode="" "-4^MappedCode不对"
	quit:MappedDesc="" "-5^MappedDesc不对"
	
	set curDate=+$h
	set curTime=$p($h,",",2)
	
	set CLCMappingCodeObj=""
	if RowId="" set RowId=##class(web.DHCCLMappingData).GetCodeMappingIdByMappedCode(MappingServiceCode,MappedCode)
	
	if (RowId="")
	{
		set CLCMappingCodeObj=##class(User.DHCCLCMappingCode).%New()
		set CLCMappingCodeObj.CLCMCDate=curDate
		set CLCMappingCodeObj.CLCMCTime=curTime
	}	
	else
	{
		set CLCMappingCodeObj=##class(User.DHCCLCMappingCode).%OpenId(RowId)	
	}
	
	set CLCMappingCodeObj.CLCMCCLCMSDr=##class(User.DHCCLCMappingService).%OpenId(MappingServiceId)
	set CLCMappingCodeObj.CLCMCCodeDr=CodeDr
	set CLCMappingCodeObj.CLCMCCode=Code
	set CLCMappingCodeObj.CLCMCDesc=Desc
	set CLCMappingCodeObj.CLCMCMappedCode=MappedCode
	set CLCMappingCodeObj.CLCMCMappedDesc=MappedDesc
	set CLCMappingCodeObj.CLCMCUpdateDate=curDate
	set CLCMappingCodeObj.CLCMCUpdateTime=curTime
	set status=CLCMappingCodeObj.%Save()
	
	set result=""
	if ($System.Status.IsOK(status))
	{
		set result=CLCMappingCodeObj.%Id()	
	}
	else
	{
		set result=$System.Status.GetErrorText(status)	
	}
	
	quit result
}

///                 MappedCode---->CodeDr
/// 第三方HIS对应码表数据记录的Code---->HIS码表数据记录的Code, 单向映射
/// w ##class(web.DHCCLMappingData).GetCodeMappingIdByMappedCode("SSGroupCodeMapping","22住院护士（核心）")
ClassMethod GetCodeMappingIdByMappedCode(MappingServiceCode As %String, MappedCode As %String) As %String
{
	set MappingServiceId=..GetServiceIdByCode(MappingServiceCode)
	quit:MappingServiceId="" ""
	quit:MappedCode="" ""

	quit $o(^DHCCLC("MappingCode",0,"MappedCode",MappingServiceId,MappedCode,""))
}

/// 第三方HIS对应数据的RowId<---->HIS数据记录的Code, 一一对应
/// w ##class(web.DHCCLMappingData).SaveMappingRecord("PatientNoRecordMapping","11174","李家英" ,"病人No映射","ZY010000792546","李家英" )
ClassMethod SaveMappingRecord(MappingServiceCode As %String, RecordDr As %String, RecordCode As %String, Desc As %String, MappedNo As %String, MappedDesc As %String) As %String
{
	set MappingServiceId=##class(web.DHCCLMappingData).GetServiceIdByCode(MappingServiceCode)
	quit:MappingServiceId="" "-1^MappingServiceCode不对"
	
	quit:RecordDr="" "-2^RecordDr不能为空"
	quit:RecordCode="" "-3^RecordCode不能为空"
	quit:MappedNo="" "-4^MappedNo不能为空"
	
	set curDate=+$h
	set curTime=$p($h,",",2)
	
	set CLCMappingRecordObj=""
	set RowId=""
	
	if (RowId="")
	{
		set CLCMappingRecordObj=##class(User.DHCCLMappingRecord).%New()
		set CLCMappingRecordObj.CLMRDate=curDate
		set CLCMappingRecordObj.CLMRTime=curTime
	}
	else
	{
		set CLCMappingRecordObj=##class(User.DHCCLMappingRecord).%OpenId(RowId)
	}
	
	set CLCMappingRecordObj.CLMRCLCMSDr=##class(User.DHCCLCMappingService).%OpenId(MappingServiceId)
	set CLCMappingRecordObj.CLMRRecordDr=RecordDr
	set CLCMappingRecordObj.CLMRRecordNo=RecordCode
	set CLCMappingRecordObj.CLMRDesc=Desc
	set CLCMappingRecordObj.CLMRMappedNo=MappedNo
	set CLCMappingRecordObj.CLMRMappedDesc=MappedDesc
	set CLCMappingRecordObj.CLMRUpdateDate=curDate
	set CLCMappingRecordObj.CLMRUpdateTime=curTime
	set status=CLCMappingRecordObj.%Save()
	
	set result=""
	if ($System.Status.IsOK(status))
	{
		set result=CLCMappingRecordObj.%Id()	
	}
	else
	{
		set result=$System.Status.GetErrorText(status)	
	}
	
	quit result
}

/// w ##class(web.DHCCLMappingData).GetRecordMappingIdByRecordDr("PatientNoRecordMapping",11174)
ClassMethod GetRecordMappingIdByRecordDr(MappingServiceCode As %String, RecordDr As %String) As %String
{
	set MappingServiceId=##class(web.DHCCLMappingData).GetServiceIdByCode(MappingServiceCode)
	quit:MappingServiceId="" ""
	
	quit:RecordDr="" ""
	
	quit $o(^DHCCLMappingRecord(0,"RecordDr",MappingServiceId,RecordDr,0))
}

/// w ##class(web.DHCCLMappingData).GetRecordMappingIdByMappedNo("PatientNoRecordMapping","ZY010000792546")
ClassMethod GetRecordMappingIdByMappedNo(MappingServiceCode As %String, MappedNo As %String) As %String
{
	set MappingServiceId=##class(web.DHCCLMappingData).GetServiceIdByCode(MappingServiceCode)
	quit:MappingServiceId="" ""
	
	quit:MappedNo="" ""
	
	quit $o(^DHCCLMappingRecord(0,"MappedNo",MappingServiceId,MappedNo,0))
}

}
