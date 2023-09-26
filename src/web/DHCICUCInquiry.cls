Import SQLUser

Class web.DHCICUCInquiry Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCICUCInquiry","FindICUCInquiry")
Query FindICUCInquiry(CtlocDr) As %Query(ROWSPEC = "TRowid:%String,TICUCICode:%String,TICUCIDesc:%String,TICUCICtlocDr:%String,TICUCICtloc:%String,TICUCIStatusCode:%String,TICUCIStatus:%String,TICUCISearchLevel:%String,TICUCIIcuaCount:%String,TICUCIResultCount:%String,TICUCIDataType:%String,TICUCIType:%String,ICUCIIsByDate:%String") [ SqlProc ]
{
}

ClassMethod FindICUCInquiryExecute(ByRef qHandle As %Binary, CtlocDr) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if CtlocDr=""  d ;配置界面使用
	.
	.s TRowid=0
	.f  s TRowid=$o(^DHCICUCInquiry(TRowid))  q:TRowid=""  d
	..d OutputRow1(TRowid)
	e  d ;前台程序调用
	.
	.;添加本科室的配置
	.//d Find(CtlocDr)
	.s rowid=""
	.f  s rowid=$o(^DHCICUCInquiry(0,"Ctloc",CtlocDr,rowid))  q:rowid=""  d	
	..d OutputRow1(rowid)
	.s locType=$p(^CTLOC(CtlocDr),"^",13)
	.;q:(locType="W")
	.;添加本科室关联病区的配置
	.s locStr=##class(web.DHCClinicCom).GetLinkLocId(CtlocDr)
	.s num=$l(locStr,"^")
	.f i=1:1:num  d
	..s wardId=$p(locStr,"^",i)
	..q:wardId=""
	..//q:'$d(^DHCICUPara(0,"Ctloc",wardId))
	..//d Find(wardId)
	..s rowid=""
	..f  s rowid=$o(^DHCICUCInquiry(0,"Ctloc",wardId,rowid))  q:rowid=""  d	
	...d OutputRow1(rowid)

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1(TRowid)
	q:'##class(User.DHCICUCInquiry).%ExistsId(TRowid)
	s obj=##class(User.DHCICUCInquiry).%OpenId(TRowid)
	s TICUCICode=obj.ICUCICode
	s TICUCIDesc=obj.ICUCIDesc
	s TICUCICtlocDr=obj.ICUCICtlocDr
	s TICUCICtloc=""
	i TICUCICtlocDr'="" s TICUCICtloc=$p($g(^CTLOC(+TICUCICtlocDr)),"^",2)
	s TICUCIStatusCode=obj.ICUCIStatus
	s TICUCIStatus=""
	s:TICUCIStatusCode="I" TICUCIStatus="Initial"
	s:TICUCIStatusCode="S" TICUCIStatus="Search"
	s:TICUCIStatusCode="F" TICUCIStatus="Finish"
	s TICUCISearchLevel=obj.ICUCISearchLevel
	s TICUCIIcuaCount=obj.ICUCIIcuaCount
	s TICUCIResultCount=obj.ICUCIResultCount
	s TICUCIDataType=obj.ICUCIDataType
	s TICUCIType=obj.ICUCIType
	s ICUCIIsByDate=obj.ICUCIIsByDate
	i TICUCIType="" s TICUCIType="All"
	e  i TICUCIType="A" s TICUCIType="All"
	e  i TICUCIType="L" s TICUCIType="Location"
	e  i TICUCIType="U" s TICUCIType="User"
	e  i TICUCIType="S" s TICUCIType ="SelfDefine"
	e  s TICUCIType=""
	d obj.%Close()
	set Data=$lb(TRowid,TICUCICode,TICUCIDesc,TICUCICtlocDr,TICUCICtloc,TICUCIStatusCode,TICUCIStatus,TICUCISearchLevel,TICUCIIcuaCount,TICUCIResultCount,TICUCIDataType,TICUCIType,ICUCIIsByDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	/*
	..s TRowid=rowid
	..s TICUCICode=$lg(^DHCICUCInquiry(TRowid),1)
	..s TICUCIDesc=$lg(^DHCICUCInquiry(TRowid),2)
	..s TICUCICtlocDr=$lg(^DHCICUCInquiry(TRowid),3)
	..i TICUCICtlocDr'="" s TICUCICtloc=$p($g(^CTLOC(+TICUCICtlocDr)),"^",2)
	..s TICUCIStatusCode=$lg(^DHCICUCInquiry(TRowid),4)
	..s:TICUCIStatusCode="I" TICUCIStatus="Initial"
	..s:TICUCIStatusCode="S" TICUCIStatus="Search"
	..s:TICUCIStatusCode="F" TICUCIStatus="Finish"
	..s:TICUCIStatusCode="" TICUCIStatus=""
	..s TICUCISearchLevel=$lg(^DHCICUCInquiry(TRowid),5)
	..s TICUCIIcuaCount=$lg(^DHCICUCInquiry(TRowid),6)
	..s TICUCIResultCount=$lg(^DHCICUCInquiry(TRowid),7)
	*/
}

ClassMethod FindICUCInquiryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUCInquiryExecute ]
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

ClassMethod FindICUCInquiryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUCInquiryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(web.DHCICUCInquiry).InsertICUCInquiry("code1","描述1","1","","","","")
ClassMethod InsertICUCInquiry(ICUCICode As %String, ICUCIDesc As %String, ICUCICtlocDr As %String, ICUCIStatus As %String, ICUCISearchLevel As %String, ICUCIIcuaCount As %Float = "", ICUCIResultCount As %Float, ICUCIIsByDate As %String = "", ICUCIType As %String = "", ICUCIUpdateUserDr As %String = "", ICUCIUpdateDate As %String = "", ICUCIUpdateTime As %String = "", ICUCIDataType As %String = "") As %String
{
	;s ^mfcTEMP(ICUCICode)=ICUCICode_"/"_ICUCIDesc_"/"_ICUCICtlocDr_"/"_ICUCIStatus_"/"_ICUCISearchLevel_"/"_ICUCIIcuaCount_"/"_ICUCIResultCount_"/"_ICUCIIsByDate_"/"_ICUCIType_"/"_ICUCIUpdateUserDr_"/"_ICUCIUpdateDate_"/"_ICUCIUpdateTime_"/"_ICUCIDataType
	q:ICUCICode="" "代码不能为空"
	q:ICUCIDesc="" "描述不能为空"
	q:ICUCICtlocDr="" "科室不能为空"	
	s retstr=0
	s ICUCIUpdateDate=##Class(web.DHCClinicCom).ConvertToDateH(ICUCIUpdateDate)
	s ICUCIUpdateTime=##Class(web.DHCClinicCom).ConvertToDateH(ICUCIUpdateTime)
	s ICUCIRowID="",inQuiryObj=""
	b 11	
	s ICUCIRowID=$o(^DHCICUCInquiry(0,"TypeUser","S",ICUCIUpdateUserDr,""))
	b 0
	i ICUCIRowID="" s inQuiryObj=##class(User.DHCICUCInquiry).%New()
	e  s inQuiryObj=##class(User.DHCICUCInquiry).%OpenId(ICUCIRowID)
	b 1
	s inQuiryObj.ICUCICode=ICUCICode
	s inQuiryObj.ICUCIDesc=ICUCIDesc
	s inQuiryObj.ICUCICtlocDr=ICUCICtlocDr
	s inQuiryObj.ICUCIStatus=ICUCIStatus
	s inQuiryObj.ICUCISearchLevel=ICUCISearchLevel
	s inQuiryObj.ICUCIIcuaCount=ICUCIIcuaCount
	s inQuiryObj.ICUCIResultCount=ICUCIResultCount
	s inQuiryObj.ICUCIType=ICUCIType
	s inQuiryObj.ICUCIUpdateUserDr=ICUCIUpdateUserDr
	s inQuiryObj.ICUCIUpdateDate=ICUCIUpdateDate
	s inQuiryObj.ICUCIUpdateTime=ICUCIUpdateTime
	s inQuiryObj.ICUCIDataType=ICUCIDataType
	s inQuiryObj.ICUCIIsByDate=ICUCIIsByDate
	d inQuiryObj.%Save()
	s retstr=inQuiryObj.%Id()
	d inQuiryObj.%Close()
	q retstr
	/*k PLIST
	TSTART
    s PLIST(2)=ICUCICode
	s PLIST(3)=ICUCIDesc
    s PLIST(4)=ICUCICtlocDr
	i ICUCIStatus'="" s PLIST(5)=ICUCIStatus
	i ICUCISearchLevel'="" s PLIST(6)=ICUCISearchLevel
	i ICUCIIcuaCount'="" s PLIST(7)=ICUCIIcuaCount
	i ICUCIResultCount'="" s PLIST(8)=ICUCIResultCount
	&SQL(insert into DHC_ICUC_Inquiry values:PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
	q SQLCODE*/
}

/// d ##class(web.DHCICUCInquiry).UpdateICUCInquiry("2","code","测试描述","S",0.3,50,1,0,"test1")
ClassMethod UpdateICUCInquiry(RowID As %String, ICUCICode As %String, ICUCIDesc As %String, ICUCICtlocDr As %String, ICUCIStatus As %String, ICUCISearchLevel As %String, ICUCIIcuaCount As %Float, ICUCIResultCount As %Float, ICUCIType As %String = "", ICUCIUpdateUserDr As %String = "", ICUCIUpdateDate As %String = "", ICUCIUpdateTime As %String = "", ICUCIDataType As %String = "") As %String
{
	q:RowID="" "ID不能为空"
	q:ICUCICode="" "代码不能为空"
	q:ICUCIDesc="" "描述不能为空"
	q:ICUCICtlocDr="" "科室不能为空"
	q:'##class(User.DHCICUCInquiry).%ExistsId(RowID)
	s obj=##class(User.DHCICUCInquiry).%OpenId(RowID)
	s obj.ICUCICode=ICUCICode
	s obj.ICUCIDesc=ICUCIDesc
	s obj.ICUCICtlocDr=ICUCICtlocDr
	s obj.ICUCIStatus=ICUCIStatus
	s obj.ICUCISearchLevel=ICUCISearchLevel
	s obj.ICUCIIcuaCount=ICUCIIcuaCount
	s obj.ICUCIResultCount=ICUCIResultCount
	s obj.ICUCIType=ICUCIType
	s obj.ICUCIUpdateUserDr=ICUCIUpdateUserDr
	s ICUCIUpdateDate=##class(web.DHCClinicCom).ConvertToDateH(ICUCIUpdateDate)
	s obj.ICUCIUpdateDate=ICUCIUpdateDate
	s ICUCIUpdateTime=##class(web.DHCClinicCom).ConvertToTimeH(ICUCIUpdateTime)
	s obj.ICUCIUpdateTime=ICUCIUpdateTime
	s obj.ICUCIDataType=ICUCIDataType
	s ret=obj.%Save()
	d obj.%Close()

	/*
	K PLIST
	TSTART	
    s PLIST(1)=RowID
    s PLIST(2)=ICUCICode
	s PLIST(3)=ICUCIDesc
    s PLIST(4)=ICUCICtlocDr
	s PLIST(5)=ICUCIStatus
	s PLIST(6)=ICUCISearchLevel
	s PLIST(7)=ICUCIIcuaCount
	s PLIST(8)=ICUCIResultCount
	&SQL(update DHC_ICUC_Inquiry values:PLIST() where ID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	*/
    //TCOMMIT
    i ret=1 s ret=0
	q ret
}

/// d ##class(web.DHCICUCInquiry).DeleteICUCInquiry("1")
ClassMethod DeleteICUCInquiry(RowID As %String) As %String
{
	i RowID'=""  d
	.&SQL(delete from DHC_ICUC_Inquiry where %ID=:RowID)
	q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUCInquiry","FindInquiryitem")
Query FindInquiryitem(ICUCIRowid As %String) As %Query(ROWSPEC = "TICUCIRowid:%String,TRowid:%String,TICUCIICode:%String,TICUCIIDesc:%String,TICUCIIType:%String,TICUCIITypeD:%String,TICUCIIIsSearch:%Boolean,TICUCIIIsSearchD:%String,TICUCIIIsDisplay:%Boolean,TICUCIIIsDisplayD:%String,TICUCIIDataField:%String,TICUCIIIsSingle:%Boolean,TICUCIIIsSingleD:%String,TICUCIIMinQty:%Float,TICUCIIMaxQty:%Float,TICUCIINote:%String,TICUCIIMultiple:%String,TICUCIIStartDateTime:%String,TICUCIIDurationHour:%Float,TICUCIIOeoriNote:%String,TICUCIIFromTime:%String,TICUCIIToTime:%String,TICUCIIExactTime:%String,TICUCIIRefIcuriId:%String,TICUCIIRefIcuriDesc:%String,TICUCIIRefValue:%String,TICUCIISeqNo:%Float,TICUCIILevel:%Float,ICUCIIColumnWidth:%String,TICUCIISummaryType:%String,TICUCIIDurationInterval:%String") [ SqlProc ]
{
}

ClassMethod FindInquiryitemExecute(ByRef qHandle As %Binary, ICUCIRowid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    
    k ^TMPAN("InquiryItem",$j)
    if ICUCIRowid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s ChildSub=0,SubId=0
    f  s ChildSub=$o(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub))  q:ChildSub=""  d
    .s TICUCIRowid=ICUCIRowid
    .s TRowid=TICUCIRowid_"||"_ChildSub
    .s TICUCIICode=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),1)
    .s TICUCIIDesc=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),2)
    .s TICUCIIType=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),3)
    .s TICUCIITypeD=""
    .s:TICUCIIType="P" TICUCIITypeD="Patient"
    .s:TICUCIIType="B" TICUCIITypeD="Baseline"
    .s:TICUCIIType="I" TICUCIITypeD="ICD"
    .s:TICUCIIType="D" TICUCIITypeD="Docter"
    .s:TICUCIIType="O" TICUCIITypeD="Order"
    .s:TICUCIIType="R" TICUCIITypeD="Record"
    .s:TICUCIIType="L" TICUCIITypeD="Lab"
    .s:TICUCIIType="C" TICUCIITypeD="CalcuLate"
    .s TICUCIIIsSearch=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),4)
    .s:TICUCIIIsSearch="1" TICUCIIIsSearchD="是"
    .s:TICUCIIIsSearch="0" TICUCIIIsSearchD="否"
    .s:TICUCIIIsSearch="" TICUCIIIsSearchD="是"
    .s TICUCIIIsDisplay=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),5)
    .s:TICUCIIIsDisplay="1" TICUCIIIsDisplayD="是"
    .s:TICUCIIIsDisplay="0" TICUCIIIsDisplayD="否"
    .s:TICUCIIIsDisplay="" TICUCIIIsDisplayD="是"    
    .s TICUCIIDataField=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),6)
    .s TICUCIIIsSingle=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),7)
    .s:TICUCIIIsSingle="1" TICUCIIIsSingleD="是"
    .s:TICUCIIIsSingle="0" TICUCIIIsSingleD="否"
    .s:TICUCIIIsSingle="" TICUCIIIsSingleD="是" 
    .s TICUCIIMinQty=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),8)
    .s TICUCIIMaxQty=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),9)
    .s TICUCIINote=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),10)
    .s TICUCIIMultiple=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),11)
    .s TICUCIIStartDateTime=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),12)
    .s TICUCIIDurationHour=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),13)
    .s TICUCIIOeoriNote=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),14)
    .s TICUCIIFromTime=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),15)
    .//i TICUCIIFromTime'="" s TICUCIIFromTime=$zt(TICUCIIFromTime,2)
    .s TICUCIIToTime=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),16)
    .//i TICUCIIToTime'="" s TICUCIIToTime=$zt(TICUCIIToTime,2)
    .s TICUCIIExactTime=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),17)
    .i TICUCIIExactTime'="" s TICUCIIExactTime=$zt(TICUCIIExactTime,2)
    .s TICUCIIRefIcuriId=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),18)
    .s TICUCIIRefIcuriDesc=""
    .i TICUCIIRefIcuriId'="" s TICUCIIRefIcuriDesc=$p($g(^DHCICUC("RecordItem",TICUCIIRefIcuriId)),"^",2)
    .s TICUCIIRefValue=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),19)
    .s TICUCIISeqNo=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),20)
    .s TICUCIILevel=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),21)
    .s TICUCIISummaryType=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),24)
    .s TICUCIIDurationInterval=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),25)
    .s ICUCIIColumnWidth=$lg(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub),26)
    .i (TICUCIISeqNo="")||(TICUCIISeqNo=SubId) d      
    ..s ^TMPAN("InquiryItem",$j,SubId)=$lb(TICUCIRowid,TRowid,TICUCIICode,TICUCIIDesc,TICUCIIType,TICUCIITypeD,TICUCIIIsSearch,TICUCIIIsSearchD,TICUCIIIsDisplay,TICUCIIIsDisplayD,TICUCIIDataField,TICUCIIIsSingle,TICUCIIIsSingleD,TICUCIIMinQty,TICUCIIMaxQty,TICUCIINote,TICUCIIMultiple,TICUCIIStartDateTime,TICUCIIDurationHour,TICUCIIOeoriNote,TICUCIIFromTime,TICUCIIToTime,TICUCIIExactTime,TICUCIIRefIcuriId,TICUCIIRefIcuriDesc,TICUCIIRefValue,TICUCIISeqNo,TICUCIILevel,ICUCIIColumnWidth,TICUCIISummaryType,TICUCIIDurationInterval)
    .e  d
    ..s ^TMPAN("InquiryItem",$j,TICUCIISeqNo)=$lb(TICUCIRowid,TRowid,TICUCIICode,TICUCIIDesc,TICUCIIType,TICUCIITypeD,TICUCIIIsSearch,TICUCIIIsSearchD,TICUCIIIsDisplay,TICUCIIIsDisplayD,TICUCIIDataField,TICUCIIIsSingle,TICUCIIIsSingleD,TICUCIIMinQty,TICUCIIMaxQty,TICUCIINote,TICUCIIMultiple,TICUCIIStartDateTime,TICUCIIDurationHour,TICUCIIOeoriNote,TICUCIIFromTime,TICUCIIToTime,TICUCIIExactTime,TICUCIIRefIcuriId,TICUCIIRefIcuriDesc,TICUCIIRefValue,TICUCIISeqNo,TICUCIILevel,ICUCIIColumnWidth,TICUCIISummaryType,TICUCIIDurationInterval)
    ..s SubId=TICUCIISeqNo
    .s SubId=SubId+1
    
    s TICUCIISeqNo="" f  s TICUCIISeqNo=$o(^TMPAN("InquiryItem",$j,TICUCIISeqNo)) q:TICUCIISeqNo=""  d
    .d OutputRow2
	
	k ^TMPAN("InquiryItem",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	;set Data=$lb(TRowid,TICUCICode,TICUCIDesc,TICUCICtlocDr,TICUCICtloc,TICUCIStatusCode,TICUCIStatus,TICUCISearchLevel,TICUCIIcuaCount,TICUCIResultCount)
 	Set ^CacheTemp(repid,ind)=^TMPAN("InquiryItem",$j,TICUCIISeqNo)
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

/// d ##class(web.DHCICUCInquiry).InsertInquiryitem(3,"子code1","子描述1","","","","","","","","","","","","","","","","","","","")
ClassMethod InsertInquiryitem(ICUCIRowid As %String, ICUCIICode As %String, ICUCIIDesc As %String, ICUCIIType As %String, ICUCIIIsSearch As %Boolean = "", ICUCIIIsDisplay As %Boolean = "", ICUCIIDataField As %String = "", ICUCIIIsSingle As %Boolean = "", ICUCIIMinQty As %Float = "", ICUCIIMaxQty As %Float = "", ICUCIINote As %String = "", ICUCIIMultiple As %String = "", ICUCIIStartDateTime As %String = "", ICUCIIDurationHour As %Float = "", ICUCIIOeoriNote As %String = "", ICUCIIFromTime As %String = "", ICUCIIToTime As %String = "", ICUCIIExactTime As %String = "", ICUCIIRefIcuriId As %String = "", ICUCIIRefValue As %String = "", ICUCIISeqNo As %Float = 0, ICUCIILevel As %Float = "", ICUCIIFromIcuriId As %String = "", ICUCIIToIcuriId As %String = "", ICUCIISummaryType As %String = "", ICUCIIDurationInterval As %String = "", ICUCIIColumnWidth As %String = "", ICUCIIMainICUCIIDr As %String = "", ICUCIUpdateUserDr As %String = "") As %String
{
	;q:ICUCIRowid="" "父表ID不能为空"
	q:ICUCIICode="" "代码不能为空"
	q:ICUCIIDesc="" "描述不能为空"
	q:ICUCIISeqNo="" "排序号不能为空"	
	s tmpCIRowId=""
	i ICUCIUpdateUserDr'="" d
	.s tmpCIRowId=$o(^DHCICUCInquiry(0,"TypeUser","S",ICUCIUpdateUserDr,""))	
	q:(ICUCIRowid="")&&(tmpCIRowId="") "父表ID不能为空"
	i tmpCIRowId'="" s ICUCIRowid=tmpCIRowId

	k PLIST
	TSTART
    s PLIST(0)=ICUCIRowid
    s PLIST(2)=ICUCIICode
    s PLIST(3)=ICUCIIDesc
    s PLIST(4)=ICUCIIType
    s PLIST(5)=ICUCIIIsSearch
    s PLIST(6)=ICUCIIIsDisplay
    s PLIST(7)=ICUCIIDataField
    s PLIST(8)=ICUCIIIsSingle
    s PLIST(9)=ICUCIIMinQty
    s PLIST(10)=ICUCIIMaxQty
    s PLIST(11)=ICUCIINote
    s PLIST(12)=ICUCIIMultiple
    s PLIST(13)=ICUCIIStartDateTime
    s PLIST(14)=ICUCIIDurationHour
    s PLIST(15)=ICUCIIOeoriNote
    i ICUCIIFromTime'="" s PLIST(16)=ICUCIIFromTime
    e  s PLIST(16)=""
    i ICUCIIToTime'="" s PLIST(17)=ICUCIIToTime
    e  s PLIST(17)=""
    i ICUCIIExactTime'="" s PLIST(18)=$zth(ICUCIIExactTime,2)
    e  s PLIST(18)=""
    s PLIST(19)=ICUCIIRefIcuriId
    s PLIST(20)=ICUCIIRefValue
    s PLIST(21)=ICUCIISeqNo
    s PLIST(22)=ICUCIILevel
    s PLIST(23)=ICUCIIFromIcuriId
    s PLIST(24)=ICUCIIToIcuriId
    s PLIST(25)=ICUCIISummaryType
    s PLIST(26)=ICUCIIDurationInterval
    s PLIST(27)=ICUCIIColumnWidth
    s PLIST(28)=ICUCIIMainICUCIIDr  
    &SQL(insert into DHC_ICUC_InquiryItem values:PLIST())    
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	TCOMMIT
	/// 调整顺序
    d ..AdjustSeq(ICUCIRowid)
	q SQLCODE
}

/// d ##class(web.DHCICUCInquiry).InsertDefineInquiryitemList("^patName^姓名^P^^^^^^^^^^^^0^0^0^^^1^^^^^^100^4359")
ClassMethod InsertDefineInquiryitemList(InquiryitemList As %String) As %String
{
	q:InquiryitemList=""	
	s ICUCIRowid=$p(InquiryitemList,"^",1)
	s ICUCIICode=$p(InquiryitemList,"^",2)
	s ICUCIIDesc=$p(InquiryitemList,"^",3)
	s ICUCIIType=$p(InquiryitemList,"^",4)
	s ICUCIIIsSearch=$p(InquiryitemList,"^",5)
	s ICUCIIIsDisplay=$p(InquiryitemList,"^",6)
	s ICUCIIDataField=$p(InquiryitemList,"^",7)
	s ICUCIIIsSingle=$p(InquiryitemList,"^",8)
	s ICUCIIMinQty=$p(InquiryitemList,"^",9)
	s ICUCIIMaxQty=$p(InquiryitemList,"^",10)
	s ICUCIINote=$p(InquiryitemList,"^",11)
	s ICUCIIMultiple=$p(InquiryitemList,"^",12)
	s ICUCIIStartDateTime=$p(InquiryitemList,"^",13)
	s ICUCIIDurationHour=$p(InquiryitemList,"^",14)
	s ICUCIIOeoriNote=$p(InquiryitemList,"^",15)
	s ICUCIIFromTime=$p(InquiryitemList,"^",16)
	s ICUCIIToTime=$p(InquiryitemList,"^",17)
	s ICUCIIExactTime=$p(InquiryitemList,"^",18)
	s ICUCIIRefIcuriId=$p(InquiryitemList,"^",19)
	s ICUCIIRefValue=$p(InquiryitemList,"^",20)
	s ICUCIISeqNo=$p(InquiryitemList,"^",21)
	s ICUCIILevel=$p(InquiryitemList,"^",22)
	s ICUCIIFromIcuriId=$p(InquiryitemList,"^",23)
	s ICUCIIToIcuriId=$p(InquiryitemList,"^",24)
	s ICUCIISummaryType=$p(InquiryitemList,"^",25)
	s ICUCIIDurationInterval=$p(InquiryitemList,"^",26)
	s ICUCIIColumnWidth=$p(InquiryitemList,"^",27)
	s ICUCIIMainICUCIIDr=$p(InquiryitemList,"^",28)
	s ICUCIUpdateUserDr=$p(InquiryitemList,"^",29)
	;s ^inquiryMFC("2012")=InquiryitemList
	s retStr=##class(web.DHCICUCInquiry).InsertInquiryitem(ICUCIRowid, ICUCIICode, ICUCIIDesc, ICUCIIType, ICUCIIIsSearch, ICUCIIIsDisplay, ICUCIIDataField, ICUCIIIsSingle, ICUCIIMinQty, ICUCIIMaxQty, ICUCIINote, ICUCIIMultiple, ICUCIIStartDateTime, ICUCIIDurationHour,
             ICUCIIOeoriNote, ICUCIIFromTime, ICUCIIToTime, ICUCIIExactTime, ICUCIIRefIcuriId, ICUCIIRefValue, ICUCIISeqNo, ICUCIILevel, ICUCIIFromIcuriId, ICUCIIToIcuriId, ICUCIISummaryType, ICUCIIDurationInterval, ICUCIIColumnWidth,ICUCIIMainICUCIIDr, ICUCIUpdateUserDr)
	q retStr
}

/// d ##class(web.DHCICUCInquiry).UpdateInquiryitem("code1","描述1","1","","","","")
ClassMethod UpdateInquiryitem(ICUCIRowid As %String, Rowid As %String, ICUCIICode As %String, ICUCIIDesc As %String, ICUCIIType As %String, ICUCIIIsSearch As %Boolean, ICUCIIIsDisplay As %Boolean, ICUCIIDataField As %String, ICUCIIIsSingle As %Boolean, ICUCIIMinQty As %Float, ICUCIIMaxQty As %Float, ICUCIINote As %String, ICUCIIMultiple As %String, ICUCIIStartDateTime As %String, ICUCIIDurationHour As %Float, ICUCIIOeoriNote As %String, ICUCIIFromTime As %String, ICUCIIToTime As %String, ICUCIIExactTime As %String, ICUCIIRefIcuriId As %String, ICUCIIRefValue As %String, ICUCIISeqNo As %Float, ICUCIILevel As %Float, ICUCIIFromIcuriId As %String = "", ICUCIIToIcuriId As %String = "", ICUCIISummaryType As %String = "", ICUCIIDurationInterval As %String = "", ICUCIIColumnWidth As %String = "")
{
	q:ICUCIRowid="" "父表ID不能为空"
	q:Rowid="" "ID号不能为空"
	q:ICUCIICode="" "代码不能为空"
	q:ICUCIIDesc="" "描述不能为空"
	q:ICUCIISeqNo="" "排序号不能为空"
	k PLIST
	TSTART
    s PLIST(0)=ICUCIRowid
    s PLIST(1)=Rowid
    s PLIST(2)=ICUCIICode
    s PLIST(3)=ICUCIIDesc
    s PLIST(4)=ICUCIIType
    s PLIST(5)=ICUCIIIsSearch
    s PLIST(6)=ICUCIIIsDisplay
    s PLIST(7)=ICUCIIDataField
    s PLIST(8)=ICUCIIIsSingle
    s PLIST(9)=ICUCIIMinQty
    s PLIST(10)=ICUCIIMaxQty
    s PLIST(11)=ICUCIINote
    s PLIST(12)=ICUCIIMultiple
    s PLIST(13)=ICUCIIStartDateTime
    s PLIST(14)=ICUCIIDurationHour
    s PLIST(15)=ICUCIIOeoriNote
    i ICUCIIFromTime'="" s PLIST(16)=$zth(ICUCIIFromTime,2)
    e  s PLIST(16)=""
    i ICUCIIToTime'="" s PLIST(17)=$zth(ICUCIIToTime,2)
    e  s PLIST(17)=""
    i ICUCIIExactTime'="" s PLIST(18)=$zth(ICUCIIExactTime,2)
    e  s PLIST(18)=""
    s PLIST(19)=ICUCIIRefIcuriId
    s PLIST(20)=ICUCIIRefValue
    s PLIST(21)=ICUCIISeqNo
    s PLIST(22)=ICUCIILevel
    s PLIST(23)=ICUCIIFromIcuriId
    s PLIST(24)=ICUCIIToIcuriId
    s PLIST(25)=ICUCIISummaryType
    s PLIST(26)=ICUCIIDurationInterval
    s PLIST(27)=ICUCIIColumnWidth
	&SQL(update DHC_ICUC_InquiryItem values:PLIST() where ICUCII_RowId=:Rowid)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
    // 调整顺序
    d ..AdjustSeq(ICUCIRowid)
	q SQLCODE
}

/// d ##class(web.DHCICUCInquiry).DeleteInquiryitem("1")
ClassMethod DeleteInquiryitem(Rowid As %String = "", ICUCIRowid As %String = "", ICUCIUpdateUserDr As %String = "") As %String
{
	i Rowid'=""  d
	.&SQL(delete from DHC_ICUC_InquiryItem where %ID=:Rowid)
	i (Rowid="")&&(ICUCIRowid'="") d
	.&SQL(delete from DHC_ICUC_InquiryItem where ICUCII_Parref=:ICUCIRowid)
	.s ^DHCICUCInquiry(ICUCIRowid,"I")=0
	s tmpCIRowId=""
	i (Rowid="")&&(ICUCIRowid="")&&(ICUCIUpdateUserDr'="") d
	.s tmpCIRowId=$o(^DHCICUCInquiry(0,"TypeUser","S",ICUCIUpdateUserDr,""))
	.i tmpCIRowId'=""  d
	..&SQL(delete from DHC_ICUC_InquiryItem where ICUCII_Parref=:tmpCIRowId)
	..s ^DHCICUCInquiry(tmpCIRowId,"I")=0
	q SQLCODE
}

Query ctloclookup(desc As %String) As %Query(ROWSPEC = "oprCtLoc:%String,oprLocId:%String") [ SqlProc ]
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

Query Statuslookup() As %Query(ROWSPEC = "StatusCode:%String,StatusDesc:%String") [ SqlProc ]
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

Query FindBoolen() As %Query(ROWSPEC = "Desc:%String,Id:%String") [ SqlProc ]
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

Query FindType() As %Query(ROWSPEC = "Desc:%String,Id:%String") [ SqlProc ]
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
    f  s ChildSub=$o(^DHCICUCInquiry(ParRowid,"I",ChildSub))  q:ChildSub=""  d
    .s row=row+1
	q row
}

// 重新按顺序设置序号

ClassMethod AdjustSeq(mainId) As %String
{
	// 调整序号
	s sub=""
	f  s sub=$O(^DHCICUCInquiry(mainId,"I",sub)) q:sub=""  d
	.s subRowId=mainId_"||"_sub
	.q:'##class(User.DHCICUCInquiryItem).%ExistsId(subRowId)
	.s obj=##class(User.DHCICUCInquiryItem).%OpenId(subRowId)
	.s TMPSeqItem(+obj.ICUCIISeqNo,sub)=subRowId
	.d obj.%Close()
	
	s seq=""
	s index=1
	f  s seq=$O(TMPSeqItem(seq)) q:seq=""  d
	.s sub=""
	.f  s sub=$O(TMPSeqItem(seq,sub)) q:sub=""  d
	..s subRowId=$g(TMPSeqItem(seq,sub))
	..q:'##class(User.DHCICUCInquiryItem).%ExistsId(subRowId)
	..s obj=##class(User.DHCICUCInquiryItem).%OpenId(subRowId)
	..s obj.ICUCIISeqNo=index
	..d obj.%Save()
	..d obj.%Close()
	..s index=index+1
}

/// 保存表格样式(列宽等)
/// 
ClassMethod SaveGridStyle(icuciId, ColNameList, ColwidthList = "")
{
	q:icuciId=""||ColNameList=""
	s Rowid=icuciId
	s icuciiSub=0
	f  s icuciiSub=$o(^DHCICUCInquiry(icuciId,"I",icuciiSub)) q:icuciiSub=""  d
	    .s IdOrCode=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)		
		.f i=1:1:$l(ColNameList,"^") d	
		..i $p(ColNameList,"^",i)=IdOrCode d
		...s Colwidth=$p(ColwidthList,"^",i)
		...
		...k PLIST		
		...   
    	...s PLIST(27)=Colwidth
		...&SQL(update DHC_ICUC_InquiryItem values:PLIST() where ICUCII_Parref=:Rowid and ICUCII_Code=:IdOrCode)
	q SQLCODE
}

Query FindICUCInquiryList() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT ICUCI_RowId As TRowid,
	   ICUCI_Code As TICUCICode,
	   ICUCI_Desc As TICUCIDesc,
	   ICUCI_Ctloc_Dr As TICUCICtlocDr,
       ICUCI_Ctloc_Dr AS TICUCICtloc,
	   ICUCI_Status As TICUCIStatusCode,
	   ICUCI_Status As TICUCIStatus,
	   ICUCI_SearchLevel As TICUCISearchLevel,
	   ICUCI_IcuaCount As TICUCIIcuaCount,
	   ICUCI_ResultCount As TICUCIResultCount,
	   ICUCI_DataType As TICUCIDataType,
	   ICUCI_Type As TICUCIType,
	   ICUCI_IsByDate As ICUCIIsByDate
	   From DHC_ICUC_Inquiry
}

/// 功能：自定义统计项目表，获取项目信息
/// 入参：Type，"P"病人基本信息;locId科室
/// 返回：项目列表
/// d ##class(%ResultSet).RunQuery("web.DHCICUCInquiry","FindICUCInquiryCode")
Query FindICUCInquiryCode(Type As %String = "", locId As %String = "") As %Query(ROWSPEC = "tID:%String,ICUCICCode:%String,ICUCICDesc:%String,ICUCICType:%String,ICUCICCtlocDr:%String,ICUCICOption:%String")
{
}

ClassMethod FindICUCInquiryCodeExecute(ByRef qHandle As %Binary, Type As %String = "", locId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tID=0,typeCode=""
 	i Type'=""  s Type=$$ALPHAUP^SSUTIL4(Type)
 	;s linkWardId=""
 	;i (locId'="")&&($o(^CTLOC(locId,"LINK",""))=0) d //根据病区获取科室
	;.s sub=0
	;.f  s sub=$O(^CTLOC(locId,"LINK",sub)) q:sub=""  d
	;..s linkWardId=^CTLOC(locId,"LINK",sub)			
	;i linkWardId '="" s locId=linkWardId	
	f  s typeCode=$o(^DHCICUC("InquiryCode",0,"Type",typeCode)) q:typeCode=""  d
	.q:((Type'="")&&(Type'=typeCode))
	.f  s tID=$o(^DHCICUC("InquiryCode",0,"Type",typeCode,tID)) q:tID=""  d
	..s ICUCICCode=$lg($g(^DHCICUC("InquiryCode",tID)),1)
	..s ICUCICDesc=$lg($g(^DHCICUC("InquiryCode",tID)),2)
	..s ICUCICType=$lg($g(^DHCICUC("InquiryCode",tID)),3)
	..s ICUCICCtlocDr=$lg($g(^DHCICUC("InquiryCode",tID)),4)
	..q:(locId'="")&&(locId'=ICUCICCtlocDr)
	..s ICUCICOption=$lg($g(^DHCICUC("InquiryCode",tID)),5)
	..d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tID,ICUCICCode,ICUCICDesc,ICUCICType,ICUCICCtlocDr,ICUCICOption)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindICUCInquiryCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUCInquiryCodeExecute ]
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

ClassMethod FindICUCInquiryCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUCInquiryCodeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 获取检验项目明细
/// d ##class(%ResultSet).RunQuery("web.DHCICUCInquiry","FindLabDesc")
Query FindLabDesc(LabCode As %String = "") As %Query(ROWSPEC = "labStandCode%String,labStandDesc%String")
{
}

ClassMethod FindLabDescExecute(ByRef qHandle As %Binary, LabCode As %String = "") As %Status
{
	
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1 	
 	s labStandCode=0,labStandDesc="" 	
 	f  s labStandCode=$o(^TTABi("TC","NNL",labStandCode)) q:labStandCode=""  d
 	.q:(LabCode'="")&&(labStandCode'[$$UPPER^SSUTIL4(LabCode))
 	.s labTc=$o(^TTABi("TC","NNL",labStandCode,""))
 	.i labTc'="" d
 	..s labStandDesc=$p($g(^TTAB("TC",labTc)),"\",1)
 	..q:labStandDesc=""
	..d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(labStandCode,labStandDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindLabDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLabDescExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindLabDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLabDescExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 获取检验项目明细
/// d ##class(%ResultSet).RunQuery("web.DHCICUCInquiry","FindLabSpecDesc")
Query FindLabSpecDesc(SpecDesc As %String = "") As %Query(ROWSPEC = "SpecimenRowId%String,SpecimenDesc%String")
{
}

ClassMethod FindLabSpecDescExecute(ByRef qHandle As %Binary, SpecDesc As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1 	
 	s SpecimenRowId=0,SpecimenDesc="" 	
 	f  s SpecimenRowId=$o(^TTAB("SPEC",SpecimenRowId)) q:SpecimenRowId=""  d 	
 	.s SpecimenDesc=$p($g(^TTAB("SPEC",SpecimenRowId)),"\",1)
 	.q:(SpecDesc'="")&&(SpecimenDesc'[SpecDesc)
	.d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(SpecimenRowId,SpecimenDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindLabSpecDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLabSpecDescExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindLabSpecDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLabSpecDescExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 获取医嘱关联常用医嘱的记录主项描述
/// d ##class(%ResultSet).RunQuery("web.DHCICUCInquiry","FindRecordItemMapValue","DetailDosePump","")
Query FindRecordItemMapValue(RecordItemCode As %String, locId As %String = "") As %Query(ROWSPEC = "Desc:%String")
{
}

ClassMethod FindRecordItemMapValueExecute(ByRef qHandle As %Binary, RecordItemCode As %String, locId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1	
	s tRowId=0
	f  s tRowId=$o(^DHCICUC("RecordItem",tRowId))  q:tRowId=""  d
	.s tICUCRICode=$p($g(^DHCICUC("RecordItem",tRowId)),"^",1)	
	.q:(RecordItemCode'="")&&(RecordItemCode'=tICUCRICode)
	.s tICUCRIMainICUCRIDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",23)
	.q:tICUCRIMainICUCRIDr=""
	.s tICUCRIMainICUCRICode=$p($g(^DHCICUC("RecordItem",+tICUCRIMainICUCRIDr)),"^",1)
	.s tICUCRIMainICUCRIDesc=$p($g(^DHCICUC("RecordItem",+tICUCRIMainICUCRIDr)),"^",2)
	.s ViewSuperCat="",ViewCat="",arcim="",Desc=""
	.f  s ViewSuperCat=$O(^DHCICUC("OrdMapping",ViewSuperCat)) q:(ViewSuperCat="")  d
	..f  s ViewCat=$O(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)) q:(ViewCat="")  d
	...f  s arcim=$O(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)) q:(arcim="")  d
	....f  s Desc=$O(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)) q:(Desc="")  d
	.....s tancoId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)),"^",1)
	.....q:(tICUCRIMainICUCRIDr'="")&&(tICUCRIMainICUCRIDr'=tancoId)
	.....s tDeptId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)),"^",9)	
	.....q:(locId'="")&&(tDeptId'="")&&(locId'=tDeptId)	
	.....d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow1
	s Data=$lb(Desc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindRecordItemMapValueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRecordItemMapValueExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {		
 		s AtEnd=1
 		s Row=""
 	}
 	else      {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindRecordItemMapValueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRecordItemMapValueExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 根据临时^DHCICUAnimalGlobal中的值，返回血气类型Arteries、Venous
/// w ##class(web.DHCICUCInquiry).GetAnimalSpirits()
ClassMethod GetAnimalSpirits(animalCode As %String = "") As %String
{
	s retStr=""
	s refCriCode=""
	f  s refCriCode=$o(^DHCICUAnimalGlobal(refCriCode)) q:refCriCode=""  d
	.s refCriCodeStr="", animalRowId=""
	.f  s animalRowId=$o(^DHCICUAnimalGlobal(refCriCode,animalRowId)) q:animalRowId=""  d
	..s animalType=""
	..f  s animalType=$o(^DHCICUAnimalGlobal(refCriCode,animalRowId,animalType)) q:animalType=""  d
	    ...s animalStr=$g(^DHCICUAnimalGlobal(refCriCode,animalRowId,animalType))
	    ...q:(animalCode'="")&&(("^"_animalStr_"^")'[("^"_animalCode_"^"))
	    ...i refCriCodeStr="" s refCriCodeStr=animalType
	    ...e  s refCriCodeStr=refCriCodeStr_";"_animalType
	    ...;w refCriCodeStr,!
	 .i retStr="" d
	 ..i refCriCodeStr'="" d
	 ...s retStr=refCriCode_"^"_refCriCodeStr
	 .e  d
	 ..i refCriCodeStr'="" d
	 ...s retStr=retStr_"@"_refCriCode_"^"_refCriCodeStr
	q retStr
}

/// 保存自定义统计查询条件
/// w ##class(web.DHCICUCInquiry).SaveQueryCondition()
ClassMethod SaveQueryCondition(ICUCIRowid As %String = "", QueryDesc As %String = "") As %String
{
	q:'$d(^DHCICUCInquiry(ICUCIRowid)) "-1"	
	q:$d(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc)) "该名称已存在，无法保存！"
	k ^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc)
	s ^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc)=^DHCICUCInquiry(ICUCIRowid)
	s ChildSub=0,SubId=0
	f  s ChildSub=$o(^DHCICUCInquiry(ICUCIRowid,"I",ChildSub))  q:ChildSub=""  d
	.s ^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub)=^DHCICUCInquiry(ICUCIRowid,"I",ChildSub)
	q "0"
}

/// 保存自定义统计查询条件
/// w ##class(web.DHCICUCInquiry).DeleteQueryCondition()
ClassMethod DeleteQueryCondition(ICUCIRowid As %String = "", QueryDesc As %String = "") As %String
{
	q:'$d(^DHCICUCInquiry(ICUCIRowid)) "-1"	
	q:'$d(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc)) "该名称不存在，无法删除！"
	k ^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc)
	q "0"
}

/// 获取历史自定义统计查询条件主项列表
/// d ##class(%ResultSet).RunQuery("web.DHCICUCInquiry","FindInquiryForCondition","3879","60")
Query FindInquiryForCondition(userId As %String, ICUCIRowid As %String = "") As %Query(ROWSPEC = "DefQueryDesc:%String,DefQueryDate:%String,ICUCIRowid:%String") [ SqlProc ]
{
}

ClassMethod FindInquiryForConditionExecute(ByRef qHandle As %Binary, userId As %String, ICUCIRowid As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    if userId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    if ICUCIRowid="" s ICUCIRowid=$o(^DHCICUCInquiry(0,"TypeUser","S",userId,""))
    if ICUCIRowid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s QueryDesc=""
    f  s QueryDesc=$o(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc))  q:QueryDesc=""  d
    .s DefQueryDesc=QueryDesc
  	.s DefQueryDate=$lg($g(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc)),13)
  	.i DefQueryDate'="" s DefQueryDate=$zd(DefQueryDate,3)
    .d OutputRow2
 	s qHandle=$lb(0,repid,0)
	q $$$OK    
OutputRow2
	s Data=$lb(DefQueryDesc,DefQueryDate,ICUCIRowid)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindInquiryForConditionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInquiryForConditionExecute ]
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

ClassMethod FindInquiryForConditionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInquiryForConditionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 获取自定义统计查询条件
/// d ##class(%ResultSet).RunQuery("web.DHCICUCInquiry","FindInquiryitemForCondition")
Query FindInquiryitemForCondition(userId As %String, ICUCIRowid As %String = "", QueryDesc As %String) As %Query(ROWSPEC = "TICUCIRowid:%String,TRowid:%String,TICUCIICode:%String,TICUCIIDesc:%String,TICUCIIType:%String,TICUCIITypeD:%String,TICUCIIIsSearch:%String,TICUCIIIsSearchD:%String,TICUCIIIsDisplay:%String,TICUCIIIsDisplayD:%String,TICUCIIDataField:%String,TICUCIIIsSingle:%String,TICUCIIIsSingleD:%String,TICUCIIMinQty:%String,TICUCIIMaxQty:%String,TICUCIINote:%String,TICUCIIMultiple:%String,TICUCIIStartDateTime:%String,TICUCIIDurationHour:%Float,TICUCIIOeoriNote:%String,TICUCIIFromTime:%String,TICUCIIToTime:%String,TICUCIIExactTime:%String,TICUCIIRefIcuriId:%String,TICUCIIRefIcuriDesc:%String,TICUCIIRefValue:%String,TICUCIISeqNo:%Float,TICUCIILevel:%Float,ICUCIIColumnWidth:%String,TICUCIISummaryType:%String,TICUCIIDurationInterval:%String,ICUCIIMain:%String") [ SqlProc ]
{
}

ClassMethod FindInquiryitemForConditionExecute(ByRef qHandle As %Binary, userId As %String, ICUCIRowid As %String = "", QueryDesc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    if userId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    if ICUCIRowid="" s ICUCIRowid=$o(^DHCICUCInquiry(0,"TypeUser","S",userId,""))
    if ICUCIRowid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    if QueryDesc="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s ChildSub=0,SubId=0
    f  s ChildSub=$o(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub))  q:ChildSub=""  d
    .s TICUCIRowid=ICUCIRowid
    .s TRowid=ChildSub
    .s TICUCIICode=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),1)
    .s TICUCIIDesc=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),2)
    .s TICUCIIType=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),3)
    .s TICUCIITypeD=""
    .s:TICUCIIType="P" TICUCIITypeD="Patient"
    .s:TICUCIIType="B" TICUCIITypeD="Baseline"
    .s:TICUCIIType="I" TICUCIITypeD="ICD"
    .s:TICUCIIType="D" TICUCIITypeD="Docter"
    .s:TICUCIIType="O" TICUCIITypeD="Order"
    .s:TICUCIIType="R" TICUCIITypeD="Record"
    .s:TICUCIIType="L" TICUCIITypeD="Lab"
    .s:TICUCIIType="C" TICUCIITypeD="CalcuLate"
    .s TICUCIIIsSearch=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),4)
    .s:TICUCIIIsSearch="1" TICUCIIIsSearchD="是"
    .s:TICUCIIIsSearch="0" TICUCIIIsSearchD="否"
    .s:TICUCIIIsSearch="" TICUCIIIsSearchD="是"
    .s TICUCIIIsDisplay=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),5)
    .s:TICUCIIIsDisplay="1" TICUCIIIsDisplayD="是"
    .s:TICUCIIIsDisplay="0" TICUCIIIsDisplayD="否"
    .s:TICUCIIIsDisplay="" TICUCIIIsDisplayD="是"    
    .s TICUCIIDataField=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),6)
    .s TICUCIIIsSingle=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),7)
    .s:TICUCIIIsSingle="1" TICUCIIIsSingleD="是"
    .s:TICUCIIIsSingle="0" TICUCIIIsSingleD="否"
    .s:TICUCIIIsSingle="" TICUCIIIsSingleD="是" 
    .s TICUCIIMinQty=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),8)
    .s TICUCIIMaxQty=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),9)
    .s TICUCIINote=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),10)
    .s TICUCIIMultiple=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),11)
    .s TICUCIIStartDateTime=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),12)
    .s TICUCIIDurationHour=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),13)
    .s TICUCIIOeoriNote=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),14)
    .s TICUCIIFromTime=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),15)
    .i TICUCIIFromTime'="" s TICUCIIFromTime=TICUCIIFromTime
    .s TICUCIIToTime=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),16)
    .i TICUCIIToTime'="" s TICUCIIToTime=TICUCIIToTime
    .s TICUCIIExactTime=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),17)
    .i TICUCIIExactTime'="" s TICUCIIExactTime=$zt(TICUCIIExactTime,2)
    .s TICUCIIRefIcuriId=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),18)
    .s TICUCIIRefIcuriDesc=""
    .i TICUCIIRefIcuriId'="" s TICUCIIRefIcuriDesc=$p($g(^DHCICUC("RecordItem",TICUCIIRefIcuriId)),"^",2)
    .s TICUCIIRefValue=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),19)
    .s TICUCIISeqNo=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),20)
    .s TICUCIILevel=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),21)
    .s TICUCIISummaryType=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),24)
    .s TICUCIIDurationInterval=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),25)
    .s ICUCIIColumnWidth=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),26)
    .s ICUCIIMain=$lg(^DHCICUCInquiryCondition(ICUCIRowid,QueryDesc,"I",ChildSub),27)
    .i (TICUCIISeqNo="")||(TICUCIISeqNo=SubId) d      
    ..s ^TMPAN("InquiryItem",$j,SubId)=$lb(TICUCIRowid,TRowid,TICUCIICode,TICUCIIDesc,TICUCIIType,TICUCIITypeD,TICUCIIIsSearch,TICUCIIIsSearchD,TICUCIIIsDisplay,TICUCIIIsDisplayD,TICUCIIDataField,TICUCIIIsSingle,TICUCIIIsSingleD,TICUCIIMinQty,TICUCIIMaxQty,TICUCIINote,TICUCIIMultiple,TICUCIIStartDateTime,TICUCIIDurationHour,TICUCIIOeoriNote,TICUCIIFromTime,TICUCIIToTime,TICUCIIExactTime,TICUCIIRefIcuriId,TICUCIIRefIcuriDesc,TICUCIIRefValue,TICUCIISeqNo,TICUCIILevel,ICUCIIColumnWidth,TICUCIISummaryType,TICUCIIDurationInterval,ICUCIIMain)
    .e  d
    ..s ^TMPAN("InquiryItem",$j,TICUCIISeqNo)=$lb(TICUCIRowid,TRowid,TICUCIICode,TICUCIIDesc,TICUCIIType,TICUCIITypeD,TICUCIIIsSearch,TICUCIIIsSearchD,TICUCIIIsDisplay,TICUCIIIsDisplayD,TICUCIIDataField,TICUCIIIsSingle,TICUCIIIsSingleD,TICUCIIMinQty,TICUCIIMaxQty,TICUCIINote,TICUCIIMultiple,TICUCIIStartDateTime,TICUCIIDurationHour,TICUCIIOeoriNote,TICUCIIFromTime,TICUCIIToTime,TICUCIIExactTime,TICUCIIRefIcuriId,TICUCIIRefIcuriDesc,TICUCIIRefValue,TICUCIISeqNo,TICUCIILevel,ICUCIIColumnWidth,TICUCIISummaryType,TICUCIIDurationInterval,ICUCIIMain)
    ..s SubId=TICUCIISeqNo
    .s SubId=SubId+1
    
    s TICUCIISeqNo="" f  s TICUCIISeqNo=$o(^TMPAN("InquiryItem",$j,TICUCIISeqNo)) q:TICUCIISeqNo=""  d
    .d OutputRow2
	
	k ^TMPAN("InquiryItem",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	;set Data=$lb(TRowid,TICUCICode,TICUCIDesc,TICUCICtlocDr,TICUCICtloc,TICUCIStatusCode,TICUCIStatus,TICUCISearchLevel,TICUCIIcuaCount,TICUCIResultCount)
 	Set ^CacheTemp(repid,ind)=^TMPAN("InquiryItem",$j,TICUCIISeqNo)
 	Set ind=ind+1
	quit
}

ClassMethod FindInquiryitemForConditionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInquiryitemForConditionExecute ]
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

ClassMethod FindInquiryitemForConditionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInquiryitemForConditionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
