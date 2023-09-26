Import SQLUser

Class web.DHCBCInquiry Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPCInquiry","FindBPCInquiry")
Query FindBPCInquiry(CtlocDr) As %Query(ROWSPEC = "TRowid:%String,TBPCICode:%String,TBPCIDesc:%String,TBPCICtlocDr:%String,TBPCICtloc:%String,TBPCIStatusCode:%String,TBPCIStatus:%String,TBPCISearchLevel:%String,TBPCIBpaCount:%String,TBPCIResultCount:%String,TBPCIDataType:%String,TBPCIType:%String,BPCIIsByDate:%String") [ SqlProc ]
{
}

ClassMethod FindBPCInquiryExecute(ByRef qHandle As %Binary, CtlocDr) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if CtlocDr=""  d ;配置界面使用
	.
	.s TRowid=0
	.f  s TRowid=$o(^DHCBPCInquiry(TRowid))  q:TRowid=""  d
	..d OutputRow1(TRowid)
	e  d ;前台程序调用
	.
	.;添加本科室的配置
	.//d Find(CtlocDr)
	.s rowid=""
	.f  s rowid=$o(^DHCBPCInquiry(0,"Ctloc",CtlocDr,rowid))  q:rowid=""  d	
	..d OutputRow1(rowid)
	.
	.;添加本科室关联病区的配置
	.s locStr=##class(web.DHCClinicCom).GetLinkLocId(CtlocDr)
	.s num=$l(locStr,"^")
	.f i=1:1:num  d
	..s wardId=$p(locStr,"^",i)
	..q:wardId=""
	..//q:'$d(^DHCICUPara(0,"Ctloc",wardId))
	..//d Find(wardId)
	..s rowid=""
	..f  s rowid=$o(^DHCBPCInquiry(0,"Ctloc",wardId,rowid))  q:rowid=""  d	
	...d OutputRow1(rowid)

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1(TRowid)
	q:'##class(User.DHCBPCInquiry).%ExistsId(TRowid)
	s obj=##class(User.DHCBPCInquiry).%OpenId(TRowid)
	s TBPCICode=obj.BPCICode
	s TBPCIDesc=obj.BPCIDesc
	s TBPCICtlocDr=obj.BPCICtlocDr
	s TBPCICtloc=""
	i TBPCICtlocDr'="" s TBPCICtloc=$p($g(^CTLOC(+TBPCICtlocDr)),"^",2)
	s TBPCIStatusCode=obj.BPCIStatus
	s TBPCIStatus=""
	s:TBPCIStatusCode="I" TBPCIStatus="Initial"
	s:TBPCIStatusCode="S" TBPCIStatus="Search"
	s:TBPCIStatusCode="F" TBPCIStatus="Finish"
	s TBPCISearchLevel=obj.BPCISearchLevel
	s TBPCIBpaCount=obj.BPCIBpaCount
	s TBPCIResultCount=obj.BPCIResultCount
	s TBPCIDataType=obj.BPCIDataType
	s TBPCIType=obj.BPCIType
	s BPCIIsByDate=obj.BPCIIsByDate
	i TBPCIType="" s TBPCIType="All"
	e  i TBPCIType="A" s TBPCIType="All"
	e  i TBPCIType="L" s TBPCIType="Location"
	e  i TBPCIType="U" s TBPCIType="User"
	e  s TBPCIType=""
	d obj.%Close()
	set Data=$lb(TRowid,TBPCICode,TBPCIDesc,TBPCICtlocDr,TBPCICtloc,TBPCIStatusCode,TBPCIStatus,TBPCISearchLevel,TBPCIBpaCount,TBPCIResultCount,TBPCIDataType,TBPCIType,BPCIIsByDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	/*
	..s TRowid=rowid
	..s TBPCICode=$lg(^DHCBPCInquiry(TRowid),1)
	..s TBPCIDesc=$lg(^DHCBPCInquiry(TRowid),2)
	..s TBPCICtlocDr=$lg(^DHCBPCInquiry(TRowid),3)
	..i TBPCICtlocDr'="" s TBPCICtloc=$p($g(^CTLOC(+TBPCICtlocDr)),"^",2)
	..s TBPCIStatusCode=$lg(^DHCBPCInquiry(TRowid),4)
	..s:TBPCIStatusCode="I" TBPCIStatus="Initial"
	..s:TBPCIStatusCode="S" TBPCIStatus="Search"
	..s:TBPCIStatusCode="F" TBPCIStatus="Finish"
	..s:TBPCIStatusCode="" TBPCIStatus=""
	..s TBPCISearchLevel=$lg(^DHCBPCInquiry(TRowid),5)
	..s TBPCIBpaCount=$lg(^DHCBPCInquiry(TRowid),6)
	..s TBPCIResultCount=$lg(^DHCBPCInquiry(TRowid),7)
	*/
}

ClassMethod FindBPCInquiryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPCInquiryExecute ]
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

ClassMethod FindBPCInquiryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPCInquiryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(web.DHCBPCInquiry).InsertBPCInquiry("code1","描述1","1","","","","")
ClassMethod InsertBPCInquiry(BPCICode As %String, BPCIDesc As %String, BPCICtlocDr As %String, BPCIStatus As %String, BPCISearchLevel As %String, BPCIBpaCount As %Float = "", BPCIResultCount As %Float, BPCIType As %String = "", BPCIUpdateUserDr As %String = "", BPCIUpdateDate As %String = "", BPCIUpdateTime As %String = "", BPCIDataType As %String = "") As %String
{
	q:BPCICode="" "代码不能为空"
	q:BPCIDesc="" "描述不能为空"
	q:BPCICtlocDr="" "科室不能为空"
	s BPCIUpdateDate=##Class(web.DHCClinicCom).ConvertToDateH(BPCIUpdateDate)
	s BPCIUpdateTime=##Class(web.DHCClinicCom).ConvertToDateH(BPCIUpdateTime)
	s inQuiryObj=##class(User.DHCBPCInquiry).%New()
	s inQuiryObj.BPCICode=BPCICode
	s inQuiryObj.BPCIDesc=BPCIDesc
	s inQuiryObj.BPCICtlocDr=BPCICtlocDr
	s inQuiryObj.BPCIStatus=BPCIStatus
	s inQuiryObj.BPCISearchLevel=BPCISearchLevel
	s inQuiryObj.BPCIBpaCount=BPCIBpaCount
	s inQuiryObj.BPCIResultCount=BPCIResultCount
	s inQuiryObj.BPCIType=BPCIType
	s inQuiryObj.BPCIUpdateUserDr=BPCIUpdateUserDr
	s inQuiryObj.BPCIUpdateDate=BPCIUpdateDate
	s inQuiryObj.BPCIUpdateTime=BPCIUpdateTime
	s inQuiryObj.BPCIDataType=BPCIDataType
	s ret=inQuiryObj.%Save()
	d inQuiryObj.%Close()
	i ret=1 s ret=0
	q ret
	/*k PLIST
	TSTART
    s PLIST(2)=BPCICode
	s PLIST(3)=BPCIDesc
    s PLIST(4)=BPCICtlocDr
	i BPCIStatus'="" s PLIST(5)=BPCIStatus
	i BPCISearchLevel'="" s PLIST(6)=BPCISearchLevel
	i BPCIBpaCount'="" s PLIST(7)=BPCIBpaCount
	i BPCIResultCount'="" s PLIST(8)=BPCIResultCount
	&SQL(insert into DHC_BPC_Inquiry values:PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
	q SQLCODE*/
}

/// d ##class(web.DHCBPCInquiry).UpdateBPCInquiry("2","code","测试描述","S",0.3,50,1,0,"test1")
ClassMethod UpdateBPCInquiry(RowID As %String, BPCICode As %String, BPCIDesc As %String, BPCICtlocDr As %String, BPCIStatus As %String, BPCISearchLevel As %String, BPCIBpaCount As %Float, BPCIResultCount As %Float, BPCIType As %String = "", BPCIUpdateUserDr As %String = "", BPCIUpdateDate As %String = "", BPCIUpdateTime As %String = "", BPCIDataType As %String = "") As %String
{
	q:RowID="" "ID不能为空"
	q:BPCICode="" "代码不能为空"
	q:BPCIDesc="" "描述不能为空"
	q:BPCICtlocDr="" "科室不能为空"
	q:'##class(User.DHCBPCInquiry).%ExistsId(RowID)
	s obj=##class(User.DHCBPCInquiry).%OpenId(RowID)
	s obj.BPCICode=BPCICode
	s obj.BPCIDesc=BPCIDesc
	s obj.BPCICtlocDr=BPCICtlocDr
	s obj.BPCIStatus=BPCIStatus
	s obj.BPCISearchLevel=BPCISearchLevel
	s obj.BPCIBpaCount=BPCIBpaCount
	s obj.BPCIResultCount=BPCIResultCount
	s obj.BPCIType=BPCIType
	s obj.BPCIUpdateUserDr=BPCIUpdateUserDr
	s BPCIUpdateDate=##class(web.DHCClinicCom).ConvertToDateH(BPCIUpdateDate)
	s obj.BPCIUpdateDate=BPCIUpdateDate
	s BPCIUpdateTime=##class(web.DHCClinicCom).ConvertToTimeH(BPCIUpdateTime)
	s obj.BPCIUpdateTime=BPCIUpdateTime
	s obj.BPCIDataType=BPCIDataType
	s ret=obj.%Save()
	d obj.%Close()

	/*
	K PLIST
	TSTART	
    s PLIST(1)=RowID
    s PLIST(2)=BPCICode
	s PLIST(3)=BPCIDesc
    s PLIST(4)=BPCICtlocDr
	s PLIST(5)=BPCIStatus
	s PLIST(6)=BPCISearchLevel
	s PLIST(7)=BPCIBpaCount
	s PLIST(8)=BPCIResultCount
	&SQL(update DHC_BPC_Inquiry values:PLIST() where ID=:RowID)
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

/// d ##class(web.DHCBPCInquiry).DeleteBPCInquiry("1")
ClassMethod DeleteBPCInquiry(RowID As %String) As %String
{
	i RowID'=""  d
	.&SQL(delete from DHC_BPC_Inquiry where %ID=:RowID)
	q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPCInquiry","FindInquiryitem")
Query FindInquiryitem(BPCIRowid As %String) As %Query(ROWSPEC = "TBPCIRowid:%String,TRowid:%String,TBPCIICode:%String,TBPCIIDesc:%String,TBPCIIType:%String,TBPCIITypeD:%String,TBPCIIIsSearch:%Boolean,TBPCIIIsSearchD:%String,TBPCIIIsDisplay:%Boolean,TBPCIIIsDisplayD:%String,TBPCIIDataField:%String,TBPCIIIsSingle:%Boolean,TBPCIIIsSingleD:%String,TBPCIIMinQty:%Float,TBPCIIMaxQty:%Float,TBPCIINote:%String,TBPCIIMultiple:%String,TBPCIIStartDateTime:%String,TBPCIIDurationHour:%Float,TBPCIIOeoriNote:%String,TBPCIIFromTime:%String,TBPCIIToTime:%String,TBPCIIExactTime:%String,TBPCIIRefIcuriId:%String,TBPCIIRefIcuriDesc:%String,TBPCIIRefValue:%String,TBPCIISeqNo:%Float,TBPCIILevel:%Float,BPCIIColumnWidth:%String") [ SqlProc ]
{
}

ClassMethod FindInquiryitemExecute(ByRef qHandle As %Binary, BPCIRowid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    
    k ^TMPAN("InquiryItem",$j)
    if BPCIRowid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s ChildSub=0,SubId=0
    f  s ChildSub=$o(^DHCBPCInquiry(BPCIRowid,"I",ChildSub))  q:ChildSub=""  d
    .s TBPCIRowid=BPCIRowid
    .s TRowid=TBPCIRowid_"||"_ChildSub
    .s TBPCIICode=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),1)
    .s TBPCIIDesc=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),2)
    .s TBPCIIType=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),3)
    .s:TBPCIIType="P" TBPCIITypeD="Patient"
    .s:TBPCIIType="B" TBPCIITypeD="Baseline"
    .s:TBPCIIType="I" TBPCIITypeD="ICD"
    .s:TBPCIIType="D" TBPCIITypeD="Docter"
    .s:TBPCIIType="O" TBPCIITypeD="Order"
    .s:TBPCIIType="R" TBPCIITypeD="Record"
    .s:TBPCIIType="L" TBPCIITypeD="Lab"
    .s TBPCIIIsSearch=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),4)
    .s:TBPCIIIsSearch="1" TBPCIIIsSearchD="是"
    .s:TBPCIIIsSearch="0" TBPCIIIsSearchD="否"
    .s:TBPCIIIsSearch="" TBPCIIIsSearchD="是"
    .s TBPCIIIsDisplay=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),5)
    .s:TBPCIIIsDisplay="1" TBPCIIIsDisplayD="是"
    .s:TBPCIIIsDisplay="0" TBPCIIIsDisplayD="否"
    .s:TBPCIIIsDisplay="" TBPCIIIsDisplayD="是"    
    .s TBPCIIDataField=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),6)
    .s TBPCIIIsSingle=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),7)
    .s:TBPCIIIsSingle="1" TBPCIIIsSingleD="是"
    .s:TBPCIIIsSingle="0" TBPCIIIsSingleD="否"
    .s:TBPCIIIsSingle="" TBPCIIIsSingleD="是" 
    .s TBPCIIMinQty=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),8)
    .s TBPCIIMaxQty=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),9)
    .s TBPCIINote=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),10)
    .s TBPCIIMultiple=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),11)
    .s TBPCIIStartDateTime=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),12)
    .s TBPCIIDurationHour=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),13)
    .s TBPCIIOeoriNote=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),14)
    .s TBPCIIFromTime=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),15)
    .i TBPCIIFromTime'="" s TBPCIIFromTime=$zt(TBPCIIFromTime,2)
    .s TBPCIIToTime=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),16)
    .i TBPCIIToTime'="" s TBPCIIToTime=$zt(TBPCIIToTime,2)
    .s TBPCIIExactTime=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),17)
    .i TBPCIIExactTime'="" s TBPCIIExactTime=$zt(TBPCIIExactTime,2)
    .s TBPCIIRefIcuriId=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),18)
    .s TBPCIIRefIcuriDesc=""
    .i TBPCIIRefIcuriId'="" s TBPCIIRefIcuriDesc=$p($g(^DHCBPC("RecordItem",TBPCIIRefIcuriId)),"^",2)
    .s TBPCIIRefValue=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),19)
    .s TBPCIISeqNo=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),20)
    .s TBPCIILevel=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),21)
    .s BPCIIColumnWidth=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),26)
    .i (TBPCIISeqNo="")||(TBPCIISeqNo=SubId) d      
    ..s ^TMPAN("InquiryItem",$j,SubId)=$lb(TBPCIRowid,TRowid,TBPCIICode,TBPCIIDesc,TBPCIIType,TBPCIITypeD,TBPCIIIsSearch,TBPCIIIsSearchD,TBPCIIIsDisplay,TBPCIIIsDisplayD,TBPCIIDataField,TBPCIIIsSingle,TBPCIIIsSingleD,TBPCIIMinQty,TBPCIIMaxQty,TBPCIINote,TBPCIIMultiple,TBPCIIStartDateTime,TBPCIIDurationHour,TBPCIIOeoriNote,TBPCIIFromTime,TBPCIIToTime,TBPCIIExactTime,TBPCIIRefIcuriId,TBPCIIRefIcuriDesc,TBPCIIRefValue,TBPCIISeqNo,TBPCIILevel,BPCIIColumnWidth)
    .e  d
    ..s ^TMPAN("InquiryItem",$j,TBPCIISeqNo)=$lb(TBPCIRowid,TRowid,TBPCIICode,TBPCIIDesc,TBPCIIType,TBPCIITypeD,TBPCIIIsSearch,TBPCIIIsSearchD,TBPCIIIsDisplay,TBPCIIIsDisplayD,TBPCIIDataField,TBPCIIIsSingle,TBPCIIIsSingleD,TBPCIIMinQty,TBPCIIMaxQty,TBPCIINote,TBPCIIMultiple,TBPCIIStartDateTime,TBPCIIDurationHour,TBPCIIOeoriNote,TBPCIIFromTime,TBPCIIToTime,TBPCIIExactTime,TBPCIIRefIcuriId,TBPCIIRefIcuriDesc,TBPCIIRefValue,TBPCIISeqNo,TBPCIILevel,BPCIIColumnWidth)
    ..s SubId=TBPCIISeqNo
    .s SubId=SubId+1
    
    s TBPCIISeqNo="" f  s TBPCIISeqNo=$o(^TMPAN("InquiryItem",$j,TBPCIISeqNo)) q:TBPCIISeqNo=""  d
    .d OutputRow2
	
	k ^TMPAN("InquiryItem",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	;set Data=$lb(TRowid,TBPCICode,TBPCIDesc,TBPCICtlocDr,TBPCICtloc,TBPCIStatusCode,TBPCIStatus,TBPCISearchLevel,TBPCIBpaCount,TBPCIResultCount)
 	Set ^CacheTemp(repid,ind)=^TMPAN("InquiryItem",$j,TBPCIISeqNo)
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

/// d ##class(web.DHCBPCInquiry).InsertInquiryitem(3,"子code1","子描述1","","","","","","","","","","","","","","","","","","","")
ClassMethod InsertInquiryitem(BPCIRowid As %String, BPCIICode As %String, BPCIIDesc As %String, BPCIIType As %String, BPCIIIsSearch As %Boolean, BPCIIIsDisplay As %Boolean, BPCIIDataField As %String, BPCIIIsSingle As %Boolean, BPCIIMinQty As %Float, BPCIIMaxQty As %Float, BPCIINote As %String, BPCIIMultiple As %String, BPCIIStartDateTime As %String, BPCIIDurationHour As %Float, BPCIIOeoriNote As %String, BPCIIFromTime As %String, BPCIIToTime As %String, BPCIIExactTime As %String, BPCIIRefIcuriId As %String, BPCIIRefValue As %String, BPCIISeqNo As %Float, BPCIILevel As %Float)
{
	q:BPCIRowid="" "父表ID不能为空"
	q:BPCIICode="" "代码不能为空"
	q:BPCIIDesc="" "描述不能为空"
	q:BPCIISeqNo="" "排序号不能为空"
	
	k PLIST
	TSTART
    s PLIST(0)=BPCIRowid
    s PLIST(2)=BPCIICode
    s PLIST(3)=BPCIIDesc
    s PLIST(4)=BPCIIType
    s PLIST(5)=BPCIIIsSearch
    s PLIST(6)=BPCIIIsDisplay
    s PLIST(7)=BPCIIDataField
    s PLIST(8)=BPCIIIsSingle
    s PLIST(9)=BPCIIMinQty
    s PLIST(10)=BPCIIMaxQty
    s PLIST(11)=BPCIINote
    s PLIST(12)=BPCIIMultiple
    s PLIST(13)=BPCIIStartDateTime
    s PLIST(14)=BPCIIDurationHour
    s PLIST(15)=BPCIIOeoriNote
    i BPCIIFromTime'="" s PLIST(16)=$zth(BPCIIFromTime,2)
    e  s PLIST(16)=""
    i BPCIIToTime'="" s PLIST(17)=$zth(BPCIIToTime,2)
    e  s PLIST(17)=""
    i BPCIIExactTime'="" s PLIST(18)=$zth(BPCIIExactTime,2)
    e  s PLIST(18)=""
    s PLIST(19)=BPCIIRefIcuriId
    s PLIST(20)=BPCIIRefValue
    s PLIST(21)=BPCIISeqNo
    s PLIST(22)=BPCIILevel
	&SQL(insert into DHC_BPC_InquiryItem values:PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
	// 调整顺序
    d ..AdjustSeq(BPCIRowid)
	q SQLCODE
}

/// d ##class(web.DHCBPCInquiry).UpdateInquiryitem("code1","描述1","1","","","","")
ClassMethod UpdateInquiryitem(BPCIRowid As %String, Rowid As %String, BPCIICode As %String, BPCIIDesc As %String, BPCIIType As %String, BPCIIIsSearch As %Boolean, BPCIIIsDisplay As %Boolean, BPCIIDataField As %String, BPCIIIsSingle As %Boolean, BPCIIMinQty As %Float, BPCIIMaxQty As %Float, BPCIINote As %String, BPCIIMultiple As %String, BPCIIStartDateTime As %String, BPCIIDurationHour As %Float, BPCIIOeoriNote As %String, BPCIIFromTime As %String, BPCIIToTime As %String, BPCIIExactTime As %String, BPCIIRefIcuriId As %String, BPCIIRefValue As %String, BPCIISeqNo As %Float, BPCIILevel As %Float)
{
	q:BPCIRowid="" "父表ID不能为空"
	q:Rowid="" "ID号不能为空"
	q:BPCIICode="" "代码不能为空"
	q:BPCIIDesc="" "描述不能为空"
	q:BPCIISeqNo="" "排序号不能为空"
	k PLIST
	TSTART
    s PLIST(0)=BPCIRowid
    s PLIST(1)=Rowid
    s PLIST(2)=BPCIICode
    s PLIST(3)=BPCIIDesc
    s PLIST(4)=BPCIIType
    s PLIST(5)=BPCIIIsSearch
    s PLIST(6)=BPCIIIsDisplay
    s PLIST(7)=BPCIIDataField
    s PLIST(8)=BPCIIIsSingle
    s PLIST(9)=BPCIIMinQty
    s PLIST(10)=BPCIIMaxQty
    s PLIST(11)=BPCIINote
    s PLIST(12)=BPCIIMultiple
    s PLIST(13)=BPCIIStartDateTime
    s PLIST(14)=BPCIIDurationHour
    s PLIST(15)=BPCIIOeoriNote
    i BPCIIFromTime'="" s PLIST(16)=$zth(BPCIIFromTime,2)
    e  s PLIST(16)=""
    i BPCIIToTime'="" s PLIST(17)=$zth(BPCIIToTime,2)
    e  s PLIST(17)=""
    i BPCIIExactTime'="" s PLIST(18)=$zth(BPCIIExactTime,2)
    e  s PLIST(18)=""
    s PLIST(19)=BPCIIRefIcuriId
    s PLIST(20)=BPCIIRefValue
    s PLIST(21)=BPCIISeqNo
    s PLIST(22)=BPCIILevel
	&SQL(update DHC_BPC_InquiryItem values:PLIST() where BPCII_RowId=:Rowid)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
    // 调整顺序
    d ..AdjustSeq(BPCIRowid)
	q SQLCODE
}

/// d ##class(web.DHCBPCInquiry).DeleteInquiryitem("1")
ClassMethod DeleteInquiryitem(Rowid As %String) As %String
{
	i Rowid'=""  d
	.&SQL(delete from DHC_BPC_InquiryItem where %ID=:Rowid)
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
    f  s ChildSub=$o(^DHCBPCInquiry(ParRowid,"I",ChildSub))  q:ChildSub=""  d
    .s row=row+1
	q row
}

// 重新按顺序设置序号

ClassMethod AdjustSeq(mainId) As %String
{
	// 调整序号
	s sub=""
	f  s sub=$O(^DHCBPCInquiry(mainId,"I",sub)) q:sub=""  d
	.s subRowId=mainId_"||"_sub
	.q:'##class(User.DHCBPCInquiryItem).%ExistsId(subRowId)
	.s obj=##class(User.DHCBPCInquiryItem).%OpenId(subRowId)
	.s TMPSeqItem(+obj.BPCIISeqNo,sub)=subRowId
	.d obj.%Close()
	
	s seq=""
	s index=1
	f  s seq=$O(TMPSeqItem(seq)) q:seq=""  d
	.s sub=""
	.f  s sub=$O(TMPSeqItem(seq,sub)) q:sub=""  d
	..s subRowId=$g(TMPSeqItem(seq,sub))
	..q:'##class(User.DHCBPCInquiryItem).%ExistsId(subRowId)
	..s obj=##class(User.DHCBPCInquiryItem).%OpenId(subRowId)
	..s obj.BPCIISeqNo=index
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
	f  s icuciiSub=$o(^DHCBPCInquiry(icuciId,"I",icuciiSub)) q:icuciiSub=""  d
	    .s IdOrCode=$lg(^DHCBPCInquiry(icuciId,"I",icuciiSub),1)		
		.f i=1:1:$l(ColNameList,"^") d	
		..i $p(ColNameList,"^",i)=IdOrCode d
		...s Colwidth=$p(ColwidthList,"^",i)
		...
		...k PLIST		
		...   
    	...s PLIST(27)=Colwidth
		...&SQL(update DHC_BPC_InquiryItem values:PLIST() where BPCII_Parref=:Rowid and BPCII_Code=:IdOrCode)
	q SQLCODE
}

Query FindBPCInquiryList() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT BPCI_RowId As TRowid,
	   BPCI_Code As TBPCICode,
	   BPCI_Desc As TBPCIDesc,
	   BPCI_Ctloc_Dr As TBPCICtlocDr,
       BPCI_Ctloc_Dr AS TBPCICtloc,
	   BPCI_Status As TBPCIStatusCode,
	   BPCI_Status As TBPCIStatus,
	   BPCI_SearchLevel As TBPCISearchLevel,
	   BPCI_BpaCount As TBPCIBpaCount,
	   BPCI_ResultCount As TBPCIResultCount,
	   BPCI_DataType As TBPCIDataType,
	   BPCI_Type As TBPCIType,
	   BPCI_IsByDate As BPCIIsByDate
	   From DHC_BPC_Inquiry
}

}
