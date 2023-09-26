Import SQLUser

Class web.DHCANCInquiry Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCANCInquiry","FindANCInquiry")
Query FindANCInquiry(ctlocDr As %String = "", userId As %String = "", ifOnlyOneLoc As %String = "N") As %Query(ROWSPEC = "RowId,ANCICode,ANCIDesc,ANCICtlocDr,ANCICtloc,ANCIStatus,ANCIStatusDesc,ANCIType,ANCITypeDesc,ANCISearchLevel,ANCIOpaCount,ANCIResultCount,ANCIIsByDate,ANCIDataType,ANCIDataTypeDesc,ANCIDateTimeType,ANCIDateTimeTypeDesc,ANCIUpdateUserDr,ANCIUpdateUser,ANCIUpdateDate,ANCIUpdateTime,ANCIDisplayDesc,IfStartStoreTimeLine,ANCIIsActive")
{
}

ClassMethod FindANCInquiryExecute(ByRef qHandle As %Binary, ctlocDr As %String = "", userId As %String = "", ifOnlyOneLoc As %String = "N") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s RowId=0
	f  s RowId=$o(^DHCANCInquiry(RowId))  q:RowId=""  d
	.s ANCIIsActive=$lg($g(^DHCANCInquiry(RowId)),15)
	.q:((ctlocDr'="")||(userId'=""))&&'ANCIIsActive
	.s ANCICode=$lg($g(^DHCANCInquiry(RowId)),1)
	.s ANCIDesc=$lg($g(^DHCANCInquiry(RowId)),2)
	.s ANCIDisplayDesc=RowId_"-"_ANCIDesc
	.s ANCICtlocDr=$lg($g(^DHCANCInquiry(RowId)),16)
	.s ANCICtloc=""
	.f i=1:1:$l(ANCICtlocDr,",") d
	..i ANCICtloc'="" s ANCICtloc=ANCICtloc_","
	..s ANCICtloc=ANCICtloc_$p($g(^CTLOC(+$p(ANCICtlocDr,",",i))),"^",2)
	.s ANCIStatus=$lg($g(^DHCANCInquiry(RowId)),4)
	.s ANCIStatusDesc=""
	.s:ANCIStatus="I" ANCIStatusDesc="初始化"
	.s:ANCIStatus="S" ANCIStatusDesc="查询中"
	.s:ANCIStatus="F" ANCIStatusDesc="完成"
	.s ANCIType=$lg($g(^DHCANCInquiry(RowId)),5)
	.i ANCIType="A" s ANCITypeDesc="所有"
	.e  i ANCIType="L" s ANCITypeDesc="科室"
	.e  i ANCIType="U" s ANCITypeDesc="用户"
	.q:(ctlocDr'="")&&(ANCIType="L")&&((","_ANCICtlocDr_",")'[(","_ctlocDr_",")) //权限为本科室时只取科室为输入科室的策略
	.s ANCISearchLevel=$lg($g(^DHCANCInquiry(RowId)),6)
	.s ANCIOpaCount=$lg($g(^DHCANCInquiry(RowId)),7)
	.s ANCIResultCount=$lg($g(^DHCANCInquiry(RowId)),8)
	.s ANCIIsByDate=$lg($g(^DHCANCInquiry(RowId)),9)
	.s ANCIDataType=$lg($g(^DHCANCInquiry(RowId)),10)
	.i ANCIDataType="P" s ANCIDataTypeDesc="单个病人"
	.e  i ANCIDataType="M" s ANCIDataTypeDesc="多个病人"
	.e  i ANCIDataType="L" s ANCIDataTypeDesc="科室病人"
	.e  i ANCIDataType="S" s ANCIDataTypeDesc="统计"
	.e  i ANCIDataType="C" s ANCIDataTypeDesc="CRF"
	.s ANCIDateTimeType=$lg($g(^DHCANCInquiry(RowId)),11)
	.i ANCIDateTimeType="R" s ANCIDateTimeTypeDesc="手术时间"
	.e  i ANCIDateTimeType="I" s ANCIDateTimeTypeDesc="住院时间"
	.s ANCIUpdateUserDr=$lg($g(^DHCANCInquiry(RowId)),12)
	.q:(userId'="")&&(ANCIType="U")&&(userId'=ANCIUpdateUserDr)
	.s ANCIUpdateUser=$p($g(^SSU("SSUSR",+ANCIUpdateUserDr)),"^",2)
	.s ANCIUpdateDate=$lg($g(^DHCANCInquiry(RowId)),13)
	.s ANCIUpdateDate=$zd(ANCIUpdateDate,3)
	.s ANCIUpdateTime=$lg($g(^DHCANCInquiry(RowId)),14)
	.s ANCIUpdateTime=$zt(ANCIUpdateTime)
	.s IfStartStoreTimeLine=+$g(^DHCANInquiry("StartStoreTimeLine",+RowId))
	.d OutputANCI
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputANCI
	set Data=$lb(RowId,ANCICode,ANCIDesc,ANCICtlocDr,ANCICtloc,ANCIStatus,ANCIStatusDesc,ANCIType,ANCITypeDesc,ANCISearchLevel,ANCIOpaCount,ANCIResultCount,ANCIIsByDate,ANCIDataType,ANCIDataTypeDesc,ANCIDateTimeType,ANCIDateTimeTypeDesc,ANCIUpdateUserDr,ANCIUpdateUser,ANCIUpdateDate,ANCIUpdateTime,ANCIDisplayDesc,IfStartStoreTimeLine,ANCIIsActive)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindANCInquiryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANCInquiryExecute ]
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

ClassMethod FindANCInquiryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANCInquiryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(web.DHCANCInquiry).InsertANCInquiry("code1","描述1","1","","","","")
ClassMethod InsertANCInquiry(ANCICode As %String, ANCIDesc As %String, ANCICtlocDr As %String, ANCIStatus As %String, ANCIType As %String, ANCISearchLevel As %String, ANCIOpaCount As %Float, ANCIResultCount As %Float, ANCIIsByDate As %Boolean, ANCIDataType As %String, ANCIDateTimeType As %String, ANCIUpdateUserDr As %String, ANCIIsActive As %String, ANCIAvailableCtloc As %String = "")
{
	q:ANCICode="" "代码不能为空"
	q:ANCIDesc="" "描述不能为空"
	//q:ANCICtlocDr="" "科室不能为空"
	
	k PLIST
	TSTART
    s PLIST(2)=ANCICode
	s PLIST(3)=ANCIDesc
    s PLIST(4)=ANCICtlocDr
    i ANCIStatus="" s PLIST(5)="I"
	e  s PLIST(5)=ANCIStatus
	s PLIST(6)=ANCIType
	s PLIST(7)=ANCISearchLevel
	s PLIST(8)=ANCIOpaCount
	s PLIST(9)=ANCIResultCount
	s PLIST(10)=ANCIIsByDate
	s PLIST(11)=ANCIDataType
	s PLIST(12)=ANCIDateTimeType
	s PLIST(13)=ANCIUpdateUserDr
	s PLIST(14)=+$h
	s PLIST(15)=$p($h,",",2)
	s PLIST(16)=+ANCIIsActive
	s PLIST(17)=ANCIAvailableCtloc
	&SQL(insert into sqluser.DHC_ANC_Inquiry values:PLIST())
	i SQLCODE
	{
		TROLLBACK
		q -1	
	}
	
    TCOMMIT
    s ReRowId=%ROWID
	q ReRowId
}

/// d ##class(web.DHCANCInquiry).UpdateANCInquiry("2","code","测试描述","S",0.3,50,1,0,"test1")
ClassMethod UpdateANCInquiry(RowID As %String, ANCICode As %String, ANCIDesc As %String, ANCICtlocDr As %String, ANCIStatus As %String, ANCIType As %String, ANCISearchLevel As %String, ANCIOpaCount As %Float, ANCIResultCount As %Float, ANCIIsByDate As %Boolean, ANCIDataType As %String, ANCIDateTimeType As %String, ANCIUpdateUserDr As %String, ANCIIsActive As %String, ANCIAvailableCtloc As %String = "") As %String
{
	q:RowID="" "ID不能为空"
	q:ANCICode="" "代码不能为空"
	q:ANCIDesc="" "描述不能为空"
	//q:ANCICtlocDr="" "科室不能为空"
	
	K PLIST
	TSTART	
    s PLIST(1)=RowID
    s PLIST(2)=ANCICode
	s PLIST(3)=ANCIDesc
    s PLIST(4)=ANCICtlocDr
	s PLIST(5)=ANCIStatus
	s PLIST(6)=ANCIType
	s PLIST(7)=ANCISearchLevel
	s PLIST(8)=ANCIOpaCount
	s PLIST(9)=ANCIResultCount
	s PLIST(10)=ANCIIsByDate
	s PLIST(11)=ANCIDataType
	s PLIST(12)=ANCIDateTimeType
	s PLIST(13)=ANCIUpdateUserDr
	s PLIST(14)=+$h
	s PLIST(15)=$p($h,",",2)
	s PLIST(16)=+ANCIIsActive
	s PLIST(17)=ANCIAvailableCtloc
	&SQL(update sqluser.DHC_ANC_Inquiry values:PLIST() where %id=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
    s ReRowId=%ROWID
	q ReRowId
}

/// d ##class(web.DHCANCInquiry).UpdateANCInquiryStatus("2","S","0","0")
ClassMethod UpdateANCInquiryStatus(anciId As %String, status As %String, opaCount As %String = "0", resultCount As %String = "0") As %String
{
	q:anciId="" "ID不能为空"
	
	K PLIST
	TSTART
	&sql(select * into :PLIST() from sqluser.DHC_ANC_Inquiry where %id=:anciId)
	s PLIST(5)=status
	s PLIST(8)=+opaCount
	s PLIST(9)=+resultCount
	s PLIST(14)=+$h
	s PLIST(15)=$p($h,",",2)
	&SQL(update sqluser.DHC_ANC_Inquiry values:PLIST() where %id=:anciId)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
    s ReRowId=%ROWID
	q ReRowId
}

/// d ##class(web.DHCANCInquiry).DeleteANCInquiry("1")
ClassMethod DeleteANCInquiry(RowID As %String) As %String
{
	i RowID'=""  d
	.&SQL(delete from sqluser.DHC_ANC_Inquiry where %ID=:RowID)
	q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCANCInquiry","FindInquiryitem")
Query FindInquiryitem(ANCIRowid As %String) As %Query(ROWSPEC = "TANCIRowid:%String,RowId:%String,TANCIICode:%String,TANCIIDesc:%String,TANCIIType:%String,TANCIITypeD:%String,TANCIIIsSearch:%Boolean,TANCIIIsSearchD:%String,TANCIIIsDisplay:%Boolean,TANCIIIsDisplayD:%String,TANCIIDataField:%String,TANCIIIsSingle:%Boolean,TANCIIIsSingleD:%String,TANCIIMinQty:%Float,TANCIIMaxQty:%Float,TANCIINote:%String,TANCIIMultiple:%String,TANCIIStartDateTime:%String,TANCIIDurationHour:%Float,TANCIIOeoriNote:%String,TANCIIFromTime:%String,TANCIIToTime:%String,TANCIIExactTime:%String,TANCIIRefIcuriId:%String,TANCIIRefIcuriDesc:%String,TANCIIRefValue:%String,TANCIISeqNo:%Float,TANCIILevel:%Float,TANCIIFromAncoId:%String,TANCIIToAncoId:%String,TANCIISummaryType:%String,TANCIIDurationInterval:%Float,TANCIIRelateANCIIDr:%String")
{
}

ClassMethod FindInquiryitemExecute(ByRef qHandle As %Binary, ANCIRowid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    
    k ^TMPAN("InquiryItem",$j)
    if ANCIRowid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s ChildSub=0,SubId=0
    f  s ChildSub=$o(^DHCANCInquiry(ANCIRowid,"I",ChildSub))  q:ChildSub=""  d
    .s TANCIRowid=ANCIRowid
    .s RowId=TANCIRowid_"||"_ChildSub
    .s TANCIICode=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),1)
    .s TANCIIDesc=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),2)
    .s TANCIIType=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),3)
    .s:TANCIIType="P" TANCIITypeD="Patient"
    .s:TANCIIType="B" TANCIITypeD="Baseline"
    .s:TANCIIType="I" TANCIITypeD="ICD"
    .s:TANCIIType="D" TANCIITypeD="Docter"
    .s:TANCIIType="O" TANCIITypeD="Order"
    .s:TANCIIType="R" TANCIITypeD="Record"
    .s:TANCIIType="L" TANCIITypeD="Lab"
    .s TANCIIIsSearch=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),4)
    .s:TANCIIIsSearch="1" TANCIIIsSearchD="是"
    .s:TANCIIIsSearch="0" TANCIIIsSearchD="否"
    .s:TANCIIIsSearch="" TANCIIIsSearchD="是"
    .s TANCIIIsDisplay=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),5)
    .s:TANCIIIsDisplay="1" TANCIIIsDisplayD="是"
    .s:TANCIIIsDisplay="0" TANCIIIsDisplayD="否"
    .s:TANCIIIsDisplay="" TANCIIIsDisplayD="是"    
    .s TANCIIDataField=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),6)
    .s TANCIIIsSingle=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),7)
    .s:TANCIIIsSingle="1" TANCIIIsSingleD="是"
    .s:TANCIIIsSingle="0" TANCIIIsSingleD="否"
    .s:TANCIIIsSingle="" TANCIIIsSingleD="是" 
    .s TANCIIMinQty=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),8)
    .s TANCIIMaxQty=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),9)
    .s TANCIINote=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),10)
    .s TANCIIMultiple=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),11)
    .s TANCIIStartDateTime=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),12)
    .s TANCIIDurationHour=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),13)
    .s TANCIIOeoriNote=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),14)
    .s TANCIIFromTime=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),15)
    .i TANCIIFromTime'="" s TANCIIFromTime=$zt(TANCIIFromTime,2)
    .s TANCIIToTime=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),16)
    .i TANCIIToTime'="" s TANCIIToTime=$zt(TANCIIToTime,2)
    .s TANCIIExactTime=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),17)
    .i TANCIIExactTime'="" s TANCIIExactTime=$zt(TANCIIExactTime,2)
    .s TANCIIRefAncoId=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),18)
    .s TANCIIRefAncoDesc=""
    .i TANCIIRefAncoId'="" s TANCIIRefAncoDesc=$p($g(^DHCANC("ComOrd",TANCIIRefAncoId)),"^",2)
    .s TANCIIRefValue=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),19)
    .s TANCIISeqNo=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),20)
    .s TANCIILevel=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),21)
    .s TANCIIFromAncoId=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),22)
    .s TANCIIToAncoId=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),23)
    .s TANCIISummaryType=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),24)
    .s TANCIIDurationInterval=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),25)
    .s TANCIIRelateANCIIDr=$lg(^DHCANCInquiry(ANCIRowid,"I",ChildSub),26)
    .i (TANCIISeqNo="")||(TANCIISeqNo=SubId) d      
    ..s ^TMPAN("InquiryItem",$j,SubId)=$lb(TANCIRowid,RowId,TANCIICode,TANCIIDesc,TANCIIType,TANCIITypeD,TANCIIIsSearch,TANCIIIsSearchD,TANCIIIsDisplay,TANCIIIsDisplayD,TANCIIDataField,TANCIIIsSingle,TANCIIIsSingleD,TANCIIMinQty,TANCIIMaxQty,TANCIINote,TANCIIMultiple,TANCIIStartDateTime,TANCIIDurationHour,TANCIIOeoriNote,TANCIIFromTime,TANCIIToTime,TANCIIExactTime,TANCIIRefAncoId,TANCIIRefAncoDesc,TANCIIRefValue,TANCIISeqNo,TANCIILevel,TANCIIFromAncoId,TANCIIToAncoId,TANCIISummaryType,TANCIIDurationInterval,TANCIIRelateANCIIDr)
    .e  d
    ..s ^TMPAN("InquiryItem",$j,TANCIISeqNo)=$lb(TANCIRowid,RowId,TANCIICode,TANCIIDesc,TANCIIType,TANCIITypeD,TANCIIIsSearch,TANCIIIsSearchD,TANCIIIsDisplay,TANCIIIsDisplayD,TANCIIDataField,TANCIIIsSingle,TANCIIIsSingleD,TANCIIMinQty,TANCIIMaxQty,TANCIINote,TANCIIMultiple,TANCIIStartDateTime,TANCIIDurationHour,TANCIIOeoriNote,TANCIIFromTime,TANCIIToTime,TANCIIExactTime,TANCIIRefAncoId,TANCIIRefAncoDesc,TANCIIRefValue,TANCIISeqNo,TANCIILevel,TANCIIFromAncoId,TANCIIToAncoId,TANCIISummaryType,TANCIIDurationInterval,TANCIIRelateANCIIDr)
    ..s SubId=TANCIISeqNo
    .s SubId=SubId+1
    
    s TANCIISeqNo="" f  s TANCIISeqNo=$o(^TMPAN("InquiryItem",$j,TANCIISeqNo)) q:TANCIISeqNo=""  d
    .d OutputRow2
	
	k ^TMPAN("InquiryItem",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	;set Data=$lb(RowId,ANCICode,ANCIDesc,ANCICtlocDr,ANCICtloc,ANCIStatusCode,ANCIStatus,ANCISearchLevel,TANCIIcuaCount,ANCIResultCount)
 	Set ^CacheTemp(repid,ind)=^TMPAN("InquiryItem",$j,TANCIISeqNo)
 	Set ind=ind+1
	quit
}

ClassMethod FindInquiryitemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInquiryitemExecute ]
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

ClassMethod FindInquiryitemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInquiryitemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(web.DHCANCInquiry).InsertInquiryitem(3,"子code1","子描述1","","","","","","","","","","","","","","","","","","","")
ClassMethod InsertInquiryitem(ANCIRowid As %String, ANCIICode As %String, ANCIIDesc As %String, ANCIIType As %String, ANCIIIsSearch As %Boolean, ANCIIIsDisplay As %Boolean, ANCIIDataField As %String, ANCIIIsSingle As %Boolean, ANCIIMinQty As %Float, ANCIIMaxQty As %Float, ANCIINote As %String, ANCIIMultiple As %String, ANCIIStartDateTime As %String, ANCIIDurationHour As %Float, ANCIIOeoriNote As %String, ANCIIFromTime As %String, ANCIIToTime As %String, ANCIIExactTime As %String, ANCIIRefIcuriId As %String, ANCIIRefValue As %String, ANCIISeqNo As %Float, ANCIILevel As %Float, ANCIIFromAncoId As %String, ANCIIToAncoId As %String, ANCIISummaryType As %String, ANCIIDurationInterval As %String, ANCIIRelateANCIIDr As %String)
{
	q:ANCIRowid="" "父表ID不能为空"
	q:ANCIICode="" "代码不能为空"
	q:ANCIIDesc="" "描述不能为空"
	q:ANCIISeqNo="" "排序号不能为空"
	
	k PLIST
	TSTART
    s PLIST(0)=ANCIRowid
    s PLIST(2)=ANCIICode
    s PLIST(3)=ANCIIDesc
    s PLIST(4)=ANCIIType
    s PLIST(5)=ANCIIIsSearch
    s PLIST(6)=ANCIIIsDisplay
    s PLIST(7)=ANCIIDataField
    s PLIST(8)=ANCIIIsSingle
    s PLIST(9)=ANCIIMinQty
    s PLIST(10)=ANCIIMaxQty
    s PLIST(11)=ANCIINote
    s PLIST(12)=ANCIIMultiple
    s PLIST(13)=ANCIIStartDateTime
    s PLIST(14)=ANCIIDurationHour
    s PLIST(15)=ANCIIOeoriNote
    i ANCIIFromTime'="" s PLIST(16)=$zth(ANCIIFromTime,2)
    e  s PLIST(16)=""
    i ANCIIToTime'="" s PLIST(17)=$zth(ANCIIToTime,2)
    e  s PLIST(17)=""
    i ANCIIExactTime'="" s PLIST(18)=$zth(ANCIIExactTime,2)
    e  s PLIST(18)=""
    s PLIST(19)=ANCIIRefIcuriId
    s PLIST(20)=ANCIIRefValue
    s PLIST(21)=ANCIISeqNo
    s PLIST(22)=ANCIILevel
    s PLIST(23)=ANCIIFromAncoId
    s PLIST(24)=ANCIIToAncoId
    s PLIST(25)=ANCIISummaryType
    s PLIST(26)=ANCIIDurationInterval
    s PLIST(27)=ANCIIRelateANCIIDr
	&SQL(insert into sqluser.DHC_ANC_InquiryItem values:PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
	q SQLCODE
}

/// d ##class(web.DHCANCInquiry).UpdateInquiryitem("code1","描述1","1","","","","")
ClassMethod UpdateInquiryitem(ANCIRowid As %String, Rowid As %String, ANCIICode As %String, ANCIIDesc As %String, ANCIIType As %String, ANCIIIsSearch As %Boolean, ANCIIIsDisplay As %Boolean, ANCIIDataField As %String, ANCIIIsSingle As %Boolean, ANCIIMinQty As %Float, ANCIIMaxQty As %Float, ANCIINote As %String, ANCIIMultiple As %String, ANCIIStartDateTime As %String, ANCIIDurationHour As %Float, ANCIIOeoriNote As %String, ANCIIFromTime As %String, ANCIIToTime As %String, ANCIIExactTime As %String, ANCIIRefIcuriId As %String, ANCIIRefValue As %String, ANCIISeqNo As %Float, ANCIILevel As %Float, ANCIIFromAncoId As %String, ANCIIToAncoId As %String, ANCIISummaryType As %String, ANCIIDurationInterval As %Float, ANCIIRelateANCIIDr As %String)
{
	q:ANCIRowid="" "父表ID不能为空"
	q:Rowid="" "ID号不能为空"
	q:ANCIICode="" "代码不能为空"
	q:ANCIIDesc="" "描述不能为空"
	q:ANCIISeqNo="" "排序号不能为空"
	k PLIST
	TSTART
    s PLIST(0)=ANCIRowid
    s PLIST(1)=Rowid
    s PLIST(2)=ANCIICode
    s PLIST(3)=ANCIIDesc
    s PLIST(4)=ANCIIType
    s PLIST(5)=ANCIIIsSearch
    s PLIST(6)=ANCIIIsDisplay
    s PLIST(7)=ANCIIDataField
    s PLIST(8)=ANCIIIsSingle
    s PLIST(9)=ANCIIMinQty
    s PLIST(10)=ANCIIMaxQty
    s PLIST(11)=ANCIINote
    s PLIST(12)=ANCIIMultiple
    s PLIST(13)=ANCIIStartDateTime
    s PLIST(14)=ANCIIDurationHour
    s PLIST(15)=ANCIIOeoriNote
    i ANCIIFromTime'="" s PLIST(16)=$zth(ANCIIFromTime,2)
    e  s PLIST(16)=""
    i ANCIIToTime'="" s PLIST(17)=$zth(ANCIIToTime,2)
    e  s PLIST(17)=""
    i ANCIIExactTime'="" s PLIST(18)=$zth(ANCIIExactTime,2)
    e  s PLIST(18)=""
    s PLIST(19)=ANCIIRefIcuriId
    s PLIST(20)=ANCIIRefValue
    s PLIST(21)=ANCIISeqNo
    s PLIST(22)=ANCIILevel
    s PLIST(23)=ANCIIFromAncoId
    s PLIST(24)=ANCIIToAncoId
    s PLIST(25)=ANCIISummaryType
    s PLIST(26)=ANCIIDurationInterval
    s PLIST(27)=ANCIIRelateANCIIDr
	&SQL(update sqluser.DHC_ANC_InquiryItem values:PLIST() where ANCII_RowId=:Rowid)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
	q SQLCODE
}

ClassMethod SetInquiryItem(anciItemStr As %String) As User.DHCANCInquiryItem
{
	s ANCIItemObj=""
	s ANCIRowid=$p(anciItemStr,$c(3),1)
	s ANCIItemId=$p(anciItemStr,$c(3),2)
	
	i ANCIItemId="" s ANCIItemObj=##class(User.DHCANCInquiryItem).%New(ANCIRowid)
	e  d
	.//导入的数据保存时处理
	.i +ANCIItemId'=ANCIRowid d
	..s ANCIItemId=ANCIRowid_"||"_(+$p(ANCIItemId,"||",2))
	..i +$p(ANCIItemId,"||",2)>+$g(^DHCANCInquiry(ANCIRowid,"I")) s ^DHCANCInquiry(ANCIRowid,"I")=+$p(ANCIItemId,"||",2)
	..s ^DHCANCInquiry(ANCIRowid,"I",+$p(ANCIItemId,"||",2))=$lb("Import","Import","B",0,1,"",0,"","","","","","","","","","","","",1,1,"","","","","",0,0,"","")
	.s ANCIItemObj=##class(User.DHCANCInquiryItem).%OpenId(ANCIItemId)
	
	s ANCIItemObj.ANCIICode=$p(anciItemStr,$c(3),3)
	s ANCIItemObj.ANCIIDesc=$p(anciItemStr,$c(3),4)
    s ANCIItemObj.ANCIIType=$p(anciItemStr,$c(3),5)
    s ANCIItemObj.ANCIIIsSearch=$p(anciItemStr,$c(3),6)
    s ANCIItemObj.ANCIIIsDisplay=$p(anciItemStr,$c(3),7)
    s ANCIItemObj.ANCIIDataField=$p(anciItemStr,$c(3),8)
    s ANCIItemObj.ANCIIIsSingle=$p(anciItemStr,$c(3),9)
    s ANCIItemObj.ANCIIMinQty=$p(anciItemStr,$c(3),10)
    s ANCIItemObj.ANCIIMaxQty=$p(anciItemStr,$c(3),11)
    s ANCIItemObj.ANCIINote=$p(anciItemStr,$c(3),12)
    s ANCIItemObj.ANCIIMultiple=$p(anciItemStr,$c(3),13)
    s ANCIItemObj.ANCIIStartDateTime=$p(anciItemStr,$c(3),14)
    s ANCIItemObj.ANCIIDurationHour=$p(anciItemStr,$c(3),15)
    s ANCIItemObj.ANCIIOeoriNote=$p(anciItemStr,$c(3),16)
    i $p(anciItemStr,$c(3),17)'="" s ANCIItemObj.ANCIIFromTime=##class(web.DHCClinicCom).ConvertToTimeH($p(anciItemStr,$c(3),17))
    e  s ANCIItemObj.ANCIIFromTime=""
    i $p(anciItemStr,$c(3),18)'="" s ANCIItemObj.ANCIIToTime=##class(web.DHCClinicCom).ConvertToTimeH($p(anciItemStr,$c(3),18))
    e  s ANCIItemObj.ANCIIToTime=""
    i $p(anciItemStr,$c(3),19)'="" s ANCIItemObj.ANCIIExactTime=##class(web.DHCClinicCom).ConvertToTimeH($p(anciItemStr,$c(3),19))
    e  s ANCIItemObj.ANCIIExactTime=""
    s ancoId=$p(anciItemStr,$c(3),20)
    i +ancoId>0 s ANCIItemObj.ANCIIRefAncoId=+ancoId //##class(User.DHCANCCommonOrd).%OpenId(ancoId)
    
    s ANCIItemObj.ANCIIRefValue=##class(web.DHCANOPStat).ReplaceString($p(anciItemStr,$c(3),21)," ","")
    s ANCIItemObj.ANCIISeqNo=$p(anciItemStr,$c(3),22)
    s ANCIItemObj.ANCIILevel=$p(anciItemStr,$c(3),23)
    
    s ancoId=$p(anciItemStr,$c(3),24)
    i +ancoId>0 s ANCIItemObj.ANCIIFromAncoId=+ancoId //##class(User.DHCANCCommonOrd).%OpenId(ancoId)
    e  s ANCIItemObj.ANCIIFromAncoId=""
    
    s ancoId=$p(anciItemStr,$c(3),25)
    i +ancoId>0 s ANCIItemObj.ANCIIToAncoId=+ancoId //##class(User.DHCANCCommonOrd).%OpenId(ancoId)
    e  s ANCIItemObj.ANCIIToAncoId=""
    
    s ANCIItemObj.ANCIISummaryType=$p(anciItemStr,$c(3),26)
    s ANCIItemObj.ANCIIDurationInterval=$p(anciItemStr,$c(3),27)
    s ANCIItemObj.ANCIIRelateANCIIDr=$p(anciItemStr,$c(3),28)
    s ANCIItemObj.ANCIIColumnWidth=+$p(anciItemStr,$c(3),29)
    s ANCIItemObj.ANCIIIsResultSearch=+$p(anciItemStr,$c(3),30)
    
    i $p(anciItemStr,$c(3),31)'="" s ANCIItemObj.ANCIIFromDate=+##class(web.DHCClinicCom).ConvertToDateH($p(anciItemStr,$c(3),31))
    e  s ANCIItemObj.ANCIIFromDate=""
    
    i $p(anciItemStr,$c(3),32)'="" s ANCIItemObj.ANCIIToDate=+##class(web.DHCClinicCom).ConvertToDateH($p(anciItemStr,$c(3),32))
    e  s ANCIItemObj.ANCIIToDate=""
    
    s ANCIItemObj.ANCIIIsNegative=+$p(anciItemStr,$c(3),33)
    
    s ANCIItemObj.ANCIIParref=##class(User.DHCANCInquiry).%OpenId(ANCIRowid)
    
    q ANCIItemObj
}

ClassMethod SaveInquiryItems(anciItemListStr As %String) As %String
{
	s ^TMPAN("InquiryPara")=anciItemListStr
	s result=0
	f i=1:1:$l(anciItemListStr,"^") q:result  d
	.s anciItemStr=$p(anciItemListStr,"^",i)
	.s itemObj=..SetInquiryItem(anciItemStr)
	.q:itemObj=""
	.d itemObj.%Save()
	.s anciiId=itemObj.%Id()
	.i anciiId="" s result=1
	.e  s result=0
	.d itemObj.%Close()
	q result
}

/// d ##class(web.DHCANCInquiry).DeleteInquiryitem("1")
ClassMethod DeleteInquiryitem(Rowid As %String) As %String
{
	i Rowid'=""  d
	.&SQL(delete from sqluser.DHC_ANC_InquiryItem where %ID=:Rowid)
	q SQLCODE
}

Query ctloclookup(desc As %String) As %Query(ROWSPEC = "oprCtLoc:%String,oprLocId:%String")
{
}

ClassMethod ctloclookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0
	i $g(desc)=""  d
	.s desc="%"
	e  d
	.s desc=$$ALPHAUP^SSUTIL4(desc)
	.s desc=desc_"%"
	&sql(declare ctloc cursor  for 
	select distinct ctloc_desc,ctloc_rowid
	              from SQLUser.ct_loc 
	              WHERE (UPPER(ctloc_desc) like :desc))
	&sql(open ctloc)
	f  &sql(fetch ctloc into :ctlocdesc,:ctlocrowid) q:SQLCODE  d
 	.Do OutputRow4	 	
 	&sql(close ctloc)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	set Data=$lb(ctlocdesc,ctlocrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ctloclookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ctloclookupExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ctloclookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ctloclookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query Statuslookup() As %Query(ROWSPEC = "StatusCode:%String,StatusDesc:%String")
{
}

ClassMethod StatuslookupExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s StatusCode="I"
 	s StatusDesc="Initial"
 	Do OutputRow	 	
 	s StatusCode="S"
 	s StatusDesc="Search"
 	Do OutputRow	
 	s StatusCode="F"
 	s StatusDesc="Finish"
 	Do OutputRow	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK   
OutputRow
	set Data=$lb(StatusCode,StatusDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod StatuslookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StatuslookupExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod StatuslookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StatuslookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindBoolen() As %Query(ROWSPEC = "Desc:%String,Id:%String")
{
}

ClassMethod FindBoolenExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Id="1",Desc="是"
	d OutputRow1
	s Id="0",Desc="否"
	d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Desc,Id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBoolenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBoolenExecute ]
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

ClassMethod FindBoolenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBoolenExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindType() As %Query(ROWSPEC = "Desc:%String,Id:%String")
{
}

ClassMethod FindTypeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Id="P",Desc="Patient"
	d OutputRow1
	s Id="B",Desc="Baseline"
	d OutputRow1
	s Id="I",Desc="ICD"
	d OutputRow1
	s Id="D",Desc="Docter"
	d OutputRow1
	s Id="O",Desc="Order"
	d OutputRow1
	s Id="R",Desc="Record"
	d OutputRow1
	s Id="L",Desc="Lab"
	d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Desc,Id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTypeExecute ]
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

ClassMethod FindTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 判断父表ID下子表是否存在数据
ClassMethod Justislink(ParRowid) As %String
{
	q:ParRowid="" "请选择一条数据"
	s row=0
    s ChildSub=0
    f  s ChildSub=$o(^DHCANCInquiry(ParRowid,"I",ChildSub))  q:ChildSub=""  d
    .s row=row+1
	q row
}

}
