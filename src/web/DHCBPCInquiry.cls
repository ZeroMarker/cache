Import SQLUser

Class web.DHCBPCInquiry Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPCInquiry","FindBPCInquiry")
Query FindBPCInquiry(CtlocDr As %String = "", desc As %String = "", hospId As %String = "") As %Query(ROWSPEC = "TRowid:%String,TBPCICode:%String,TBPCIDesc:%String,TBPCICtlocDr:%String,TBPCICtloc:%String,TBPCIStatusCode:%String,TBPCIStatus:%String,TBPCISearchLevel:%String,TBPCIBpaCount:%String,TBPCIResultCount:%String,TBPCIDataType:%String,TBPCIType:%String,BPCIIsByDate:%String,BPCIClassifyCode:%String,BPCIDateTimeType:%String") [ SqlProc ]
{
}

ClassMethod FindBPCInquiryExecute(ByRef qHandle As %Binary, CtlocDr As %String = "", desc As %String = "", hospId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMPAN("BPTotalCInquiry",$j)
	if CtlocDr=""  d ;配置界面使用
	.
	.s TRowid=0
	.f  s TRowid=$o(^DHCBPCInquiry(TRowid))  q:TRowid=""  d	
	..d OutputRow1(TRowid)
	.s Code="" f  s Code=$o(^TMPAN("BPTotalCInquiry",$j,Code)) q:Code=""  d
	..do OutputRow2
	e  d ;前台程序调用
	.;添加本科室的配置
	.//d Find(CtlocDr)
	.//s ^dhcmfctmp("2015")=CtlocDr
	.s rowid=""
	.f  s rowid=$o(^DHCBPCInquiry(0,"Ctloc",CtlocDr,rowid))  q:rowid=""  d	
	..d OutputRow1(rowid)
	.s Code="" f  s Code=$o(^TMPAN("BPTotalCInquiry",$j,Code)) q:Code=""  d
	..do OutputRow2
	.
	.;添加本科室关联病区的配置
	.;s locStr=##class(web.DHCClinicCom).GetLinkLocId(CtlocDr)
	.;s num=$l(locStr,"^")
	.;f i=1:1:num  d
	..;s wardId=$p(locStr,"^",i)
	..;q:wardId=""
	..//q:'$d(^DHCICUPara(0,"Ctloc",wardId))
	..//d Find(wardId)
	..;s rowid=""
	..;f  s rowid=$o(^DHCBPCInquiry(0,"Ctloc",wardId,rowid))  q:rowid=""  d	
	...;d OutputRow1(rowid)	
	k ^TMPAN("BPTotalCInquiry",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1(TRowid)
	q:'##class(User.DHCBPCInquiry).%ExistsId(TRowid)
	s obj=##class(User.DHCBPCInquiry).%OpenId(TRowid)
	i (CtlocDr'="")&&(hospId="") s hospId=$p($g(^CTLOC(CtlocDr)),"^",22)
	s hospitalId=obj.DataAttribution.HospitalID
	q:((hospitalId'="")&(hospId'=hospitalId))
	s TBPCICode=obj.BPCICode
	s TBPCIDesc=obj.BPCIDesc
	q:(desc'="")&&(TBPCIDesc'[desc)
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
	e  i TBPCIType="S" s TBPCIType="SelfDefine"	
	e  s TBPCIType=""
	s BPCIClassifyCode=obj.BPCIClassifyCode
	s BPCIDateTimeType=obj.BPCIDateTimeType
	;w TBPCIDesc_"/"_TBPCICtloc,!	
	d obj.%Close()
	s ^TMPAN("BPTotalCInquiry",$j,TBPCICode_","_TRowid)=$lb(TRowid,TBPCICode,TBPCIDesc,TBPCICtlocDr,TBPCICtloc,TBPCIStatusCode,TBPCIStatus,TBPCISearchLevel,TBPCIBpaCount,TBPCIResultCount,TBPCIDataType,TBPCIType,BPCIIsByDate,BPCIClassifyCode,BPCIDateTimeType)
	;do OutputRow2
	quit
	
	;set Data=$lb(TRowid,TBPCICode,TBPCIDesc,TBPCICtlocDr,TBPCICtloc,TBPCIStatusCode,TBPCIStatus,TBPCISearchLevel,TBPCIBpaCount,TBPCIResultCount,TBPCIDataType,TBPCIType,BPCIIsByDate)
 	;Set ^CacheTemp(repid,ind)=Data
 	;Set ind=ind+1
	;quit	
OutputRow2	
 	Set ^CacheTemp(repid,ind)=^TMPAN("BPTotalCInquiry",$j,Code)
 	Set ind=ind+1
	quit
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

/// w ##class(web.DHCBPCInquiry).InsertBPCInquiry("code1","描述1","15","I","","20","30","A","")
ClassMethod InsertBPCInquiry(BPCICode As %String, BPCIDesc As %String, BPCICtlocDr As %String, BPCIStatus As %String, BPCISearchLevel As %String, BPCIBpaCount As %Float = "", BPCIResultCount As %Float, BPCIType As %String = "", BPCIUpdateUserDr As %String = "", BPCIUpdateDate As %String = "", BPCIUpdateTime As %String = "", BPCIDataType As %String = "", BPCIClassifyCode As %String = "", BPCIDateTimeType As %String = "", hospId As %String = "") As %String
{
	;s ^tmpdhcmfc("BPCICode")=BPCICode_"/"_BPCIDesc_"/"_BPCICtlocDr_"/"_BPCIStatus_"/"_BPCISearchLevel_"/"_BPCIBpaCount_"/"_BPCIResultCount_"/"_BPCIType_"/"_BPCIUpdateUserDr_"/"_BPCIUpdateDate_"/"_BPCIUpdateTime_"/"_BPCIDataType_"/"_BPCIClassifyCode_"/"_BPCIDateTimeType
	q:BPCICode="" "代码不能为空"
	q:BPCIDesc="" "描述不能为空"
	q:BPCICtlocDr="" "科室不能为空"
	s BPCIUpdateDate=##Class(web.DHCClinicCom).ConvertToDateH(BPCIUpdateDate)
	s BPCIUpdateTime=##Class(web.DHCClinicCom).ConvertToDateH(BPCIUpdateTime)
	s inQuiryObj="",BPCIRowID=""	
	i BPCIUpdateUserDr'="" s BPCIRowID=$o(^DHCBPCInquiry(0,"TypeUser","S",BPCIUpdateUserDr,""))
	i BPCIRowID="" s inQuiryObj=##class(User.DHCBPCInquiry).%New()
	e  s inQuiryObj=##class(User.DHCBPCInquiry).%OpenId(BPCIRowID)
	s inQuiryObj.BPCICode=BPCICode
	s inQuiryObj.BPCIDesc=BPCIDesc
	s inQuiryObj.BPCICtlocDr=BPCICtlocDr
	s inQuiryObj.BPCIStatus=BPCIStatus
	s inQuiryObj.BPCISearchLevel=BPCISearchLevel
	s inQuiryObj.BPCIBpaCount=BPCIBpaCount
	s inQuiryObj.BPCIResultCount=BPCIResultCount
	s inQuiryObj.BPCIType=$$ALPHAUP^SSUTIL4(BPCIType)
	i BPCIUpdateUserDr'="" s inQuiryObj.BPCIUpdateUserDr=BPCIUpdateUserDr
	s inQuiryObj.BPCIUpdateDate=BPCIUpdateDate
	s inQuiryObj.BPCIUpdateTime=BPCIUpdateTime
	s inQuiryObj.BPCIDataType=BPCIDataType
	s inQuiryObj.BPCIClassifyCode=BPCIClassifyCode
	s inQuiryObj.BPCIDateTimeType=BPCIDateTimeType
	d inQuiryObj.%Save()
	;w inQuiryObj.%Id(),!
	s ret=inQuiryObj.%Id()
	d inQuiryObj.%Close()
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPCInquiry")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBPCInquiry",ret,hospId)
    }
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
ClassMethod UpdateBPCInquiry(RowID As %String, BPCICode As %String, BPCIDesc As %String, BPCICtlocDr As %String, BPCIStatus As %String, BPCISearchLevel As %String, BPCIBpaCount As %Float, BPCIResultCount As %Float, BPCIType As %String = "", BPCIUpdateUserDr As %String = "", BPCIUpdateDate As %String = "", BPCIUpdateTime As %String = "", BPCIDataType As %String = "", BPCIClassifyCode As %String = "", BPCIDateTimeType As %String = "", hospId As %String = "") As %String
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
	s obj.BPCIType=$$ALPHAUP^SSUTIL4(BPCIType)
	s obj.BPCIUpdateUserDr=BPCIUpdateUserDr
	s BPCIUpdateDate=##class(web.DHCClinicCom).ConvertToDateH(BPCIUpdateDate)
	s obj.BPCIUpdateDate=BPCIUpdateDate
	s BPCIUpdateTime=##class(web.DHCClinicCom).ConvertToTimeH(BPCIUpdateTime)
	s obj.BPCIUpdateTime=BPCIUpdateTime
	s obj.BPCIDataType=BPCIDataType
	s obj.BPCIClassifyCode=BPCIClassifyCode
	s obj.BPCIDateTimeType=BPCIDateTimeType
	s ret=obj.%Save()
	s DataRowId=obj.%Id()
	d obj.%Close()
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPCInquiry")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBPCInquiry",DataRowId,hospId)
    }
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
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPCInquiry")
	{
		do ##class(web.DHCBPCTablePermission).UnbindAttribution("User.DHCBPCInquiry",RowID)
    }
	q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPCInquiry","FindInquiryitem")
Query FindInquiryitem(BPCIRowid As %String) As %Query(ROWSPEC = "TBPCIRowid:%String,TRowid:%String,TBPCIICode:%String,TBPCIIDesc:%String,TBPCIIType:%String,TBPCIITypeD:%String,TBPCIIIsSearch:%String,TBPCIIIsSearchD:%String,TBPCIIIsDisplay:%String,TBPCIIIsDisplayD:%String,TBPCIIDataField:%String,TBPCIIIsSingle:%String,TBPCIIIsSingleD:%String,TBPCIIMinQty:%Float,TBPCIIMaxQty:%Float,TBPCIINote:%String,TBPCIIMultiple:%String,TBPCIIStartDateTime:%String,TBPCIIDurationHour:%Float,TBPCIIOeoriNote:%String,TBPCIIFromTime:%String,TBPCIIToTime:%String,TBPCIIExactTime:%String,TBPCIIRefIcuriId:%String,TBPCIIRefIcuriDesc:%String,TBPCIIRefValue:%String,TBPCIISeqNo:%Float,TBPCIILevel:%Float,TBPCIIColumnWidth:%String,TBPCIISummarySeqNo:%String,TBPCIISumChartType:%String") [ SqlProc ]
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
    .q:'$d(^DHCBPCInquiry(BPCIRowid,"I",ChildSub))
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
    .s:TBPCIIType="A" TBPCIITypeD="Arrange"
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
    .;i TBPCIIFromTime'="" s TBPCIIFromTime=$zt(TBPCIIFromTime,2)
    .s TBPCIIToTime=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),16)
    .;i TBPCIIToTime'="" s TBPCIIToTime=$zt(TBPCIIToTime,2)
    .s TBPCIIExactTime=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),17)
    .i TBPCIIExactTime'="" s TBPCIIExactTime=$zt(TBPCIIExactTime,2)
    .s TBPCIIRefIcuriId=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),18)
    .s TBPCIIRefIcuriDesc=""
    .i TBPCIIRefIcuriId'="" s TBPCIIRefIcuriDesc=$p($g(^DHCBPC("RecordItem",TBPCIIRefIcuriId)),"^",2)
    .s TBPCIIRefValue=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),19)
    .s TBPCIISeqNo=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),20)
    .s TBPCIILevel=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),21)
    .s TBPCIIColumnWidth=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),26)
    .s TBPCIISummarySeqNo=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),27)
    .s TBPCIISumChartType=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),28)    
    .s TBPCIISumChartTypeD=""
    .i TBPCIISumChartType="Z" s TBPCIISumChartTypeD="柱状图"
    .i TBPCIISumChartType="S" s TBPCIISumChartTypeD="饼状图"
    .s TBPCIISummaryType=$lg(^DHCBPCInquiry(BPCIRowid,"I",ChildSub),24)
    .i (TBPCIISeqNo="")||(TBPCIISeqNo=SubId) d      
    ..s ^TMPAN("InquiryItem",$j,SubId)=$lb(TBPCIRowid,TRowid,TBPCIICode,TBPCIIDesc,TBPCIIType,TBPCIITypeD,TBPCIIIsSearch,TBPCIIIsSearchD,TBPCIIIsDisplay,TBPCIIIsDisplayD,TBPCIIDataField,TBPCIIIsSingle,TBPCIIIsSingleD,TBPCIIMinQty,TBPCIIMaxQty,TBPCIINote,TBPCIIMultiple,TBPCIIStartDateTime,TBPCIIDurationHour,TBPCIIOeoriNote,TBPCIIFromTime,TBPCIIToTime,TBPCIIExactTime,TBPCIIRefIcuriId,TBPCIIRefIcuriDesc,TBPCIIRefValue,TBPCIISeqNo,TBPCIILevel,TBPCIIColumnWidth,TBPCIISummarySeqNo,TBPCIISumChartType)
    .e  d
    ..s ^TMPAN("InquiryItem",$j,TBPCIISeqNo)=$lb(TBPCIRowid,TRowid,TBPCIICode,TBPCIIDesc,TBPCIIType,TBPCIITypeD,TBPCIIIsSearch,TBPCIIIsSearchD,TBPCIIIsDisplay,TBPCIIIsDisplayD,TBPCIIDataField,TBPCIIIsSingle,TBPCIIIsSingleD,TBPCIIMinQty,TBPCIIMaxQty,TBPCIINote,TBPCIIMultiple,TBPCIIStartDateTime,TBPCIIDurationHour,TBPCIIOeoriNote,TBPCIIFromTime,TBPCIIToTime,TBPCIIExactTime,TBPCIIRefIcuriId,TBPCIIRefIcuriDesc,TBPCIIRefValue,TBPCIISeqNo,TBPCIILevel,TBPCIIColumnWidth,TBPCIISummarySeqNo,TBPCIISumChartType)
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
ClassMethod InsertInquiryitem(BPCIRowid As %String, BPCIICode As %String, BPCIIDesc As %String, BPCIIType As %String, BPCIIIsSearch As %String, BPCIIIsDisplay As %String, BPCIIDataField As %String, BPCIIIsSingle As %String, BPCIIMinQty As %Float, BPCIIMaxQty As %Float, BPCIINote As %String, BPCIIMultiple As %String, BPCIIStartDateTime As %String, BPCIIDurationHour As %Float, BPCIIOeoriNote As %String, BPCIIFromTime As %String, BPCIIToTime As %String, BPCIIExactTime As %String, BPCIIRefBPriId As %String, BPCIIRefValue As %String, BPCIISeqNo As %Float = 0, BPCIILevel As %Float = "", BPCIIFromBPriId As %String = "", BPCIIToBPriId As %String = "", BPCIISummaryType As %String = "", BPCIIDurationInterval As %String = "", BPCIIColumnWidth As %String = "", BPCIIMainBPCIIDr As %String = "", BPCIUpdateUserDr As %String = "", BPCIISummaryChartType As %String = "")
{
	;q:BPCIRowid="" "父表ID不能为空"
	q:BPCIICode="" "代码不能为空"
	q:BPCIIDesc="" "描述不能为空"
	q:BPCIISeqNo="" "排序号不能为空"	
	s tmpCIRowId=""
	i BPCIUpdateUserDr'="" d
	.s tmpCIRowId=$o(^DHCBPCInquiry(0,"TypeUser","S",BPCIUpdateUserDr,""))	
	q:(BPCIRowid="")&&(tmpCIRowId="") "父表ID不能为空"
	i tmpCIRowId'="" s BPCIRowid=tmpCIRowId
	
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
    i BPCIIFromTime'="" s PLIST(16)=BPCIIFromTime
    e  s PLIST(16)=""
    i BPCIIToTime'="" s PLIST(17)=BPCIIToTime
    e  s PLIST(17)=""
    i BPCIIExactTime'="" s PLIST(18)=##class(web.DHCClinicCom).ConvertToTimeH(BPCIIExactTime)
    e  s PLIST(18)=""
    s PLIST(19)=BPCIIRefBPriId
    s PLIST(20)=BPCIIRefValue
    s PLIST(21)=BPCIISeqNo
    s PLIST(22)=BPCIILevel
    s PLIST(23)=BPCIIFromBPriId
    s PLIST(24)=BPCIIToBPriId
    s PLIST(25)=BPCIISummaryType
    s PLIST(26)=BPCIIDurationInterval
    s PLIST(27)=BPCIIColumnWidth
    s PLIST(28)=BPCIIMainBPCIIDr
    s PLIST(29)=BPCIISummaryChartType 
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
ClassMethod UpdateInquiryitem(BPCIRowid As %String, Rowid As %String, BPCIICode As %String, BPCIIDesc As %String, BPCIIType As %String, BPCIIIsSearch As %String, BPCIIIsDisplay As %String, BPCIIDataField As %String, BPCIIIsSingle As %String, BPCIIMinQty As %Float, BPCIIMaxQty As %Float, BPCIINote As %String, BPCIIMultiple As %String, BPCIIStartDateTime As %String, BPCIIDurationHour As %Float, BPCIIOeoriNote As %String, BPCIIFromTime As %String, BPCIIToTime As %String, BPCIIExactTime As %String, BPCIIRefBpriId As %String, BPCIIRefValue As %String, BPCIISeqNo As %Float, BPCIILevel As %Float, BPCIIFromBPriId As %String = "", BPCIIToBPriId As %String = "", BPCIISummaryType As %String = "", BPCIIDurationInterval As %String = "", BPCIIColumnWidth As %String = "", BPCIIMainBPCIIDr As %String = "", BPCIUpdateUserDr As %String = "", BPCIISummaryChartType As %String = "")
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
    i BPCIIFromTime'="" s PLIST(16)=BPCIIFromTime
    e  s PLIST(16)=""
    i BPCIIToTime'="" s PLIST(17)=BPCIIToTime
    e  s PLIST(17)=""
    i BPCIIExactTime'="" s PLIST(18)=##class(web.DHCClinicCom).ConvertToTimeH(BPCIIExactTime)
    e  s PLIST(18)=""
    s PLIST(19)=BPCIIRefBpriId
    s PLIST(20)=BPCIIRefValue
    s PLIST(21)=BPCIISeqNo
    s PLIST(22)=BPCIILevel
    s PLIST(23)=BPCIIFromBPriId
    s PLIST(24)=BPCIIToBPriId
    s PLIST(25)=BPCIISummaryType
    s PLIST(26)=BPCIIDurationInterval
    s PLIST(27)=BPCIIColumnWidth
    s PLIST(28)=BPCIIMainBPCIIDr 
    s PLIST(29)=BPCIISummaryChartType 
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

/// w ##class(web.DHCBPCInquiry).DeleteInquiryitem("")
ClassMethod DeleteInquiryitem(Rowid As %String = "", BPCIRowid As %String = "", BPCIUpdateUserDr As %String = "") As %String
{
	i Rowid'=""  d
	.&SQL(delete from DHC_BPC_InquiryItem where %ID=:Rowid)
	i (Rowid="")&&(BPCIRowid'="") d
	.&SQL(delete from DHC_BPC_InquiryItem where BPCII_Parref=:BPCIRowid)
	.s ^DHCBPCInquiry(BPCIRowid,"I")=0
	i (Rowid="")&&(BPCIRowid="")&&(BPCIUpdateUserDr'="") d
	.s tmpCIRowId=$o(^DHCBPCInquiry(0,"TypeUser","S",BPCIUpdateUserDr,""))
	.i tmpCIRowId'=""  d
	..&SQL(delete from DHC_BPC_InquiryItem where BPCII_Parref=:tmpCIRowId)
	..s ^DHCBPCInquiry(tmpCIRowId,"I")=0
	q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPCInquiry","ctloclookup","XYJHZX")
Query ctloclookup(desc As %String, hospId As %String = "") As %Query(ROWSPEC = "oprCtLoc:%String,oprLocId:%String") [ SqlProc ]
{
}

ClassMethod ctloclookupExecute(ByRef qHandle As %Binary, desc As %String, hospId As %String = "") As %Status
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
	              WHERE (UPPER(ctloc_desc) like :desc) and (CTLOC_DateActiveFrom<=+$h) and ((CTLOC_DateActiveTo is null) or ((CTLOC_DateActiveTo is not null) and (CTLOC_DateActiveTo>=+$h))) and ((CTLOC_Hospital_DR=:hospId) or (:hospId is null)))
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
ClassMethod SaveGridStyle(BPCiId, ColNameList, ColwidthList = "", ColDescList = "")
{
	q:BPCiId=""||ColNameList=""
	s Rowid=BPCiId
	s BPCiiSub=0
	f  s BPCiiSub=$o(^DHCBPCInquiry(BPCiId,"I",BPCiiSub)) q:BPCiiSub=""  d
	    .s IdOrCode=$lg(^DHCBPCInquiry(BPCiId,"I",BPCiiSub),1)
	    .s Desc=$lg(^DHCBPCInquiry(BPCiId,"I",BPCiiSub),2)		
		.f i=1:1:$l(ColNameList,"^") d	
		..i $p(ColNameList,"^",i)=IdOrCode d
		...q:(ColDescList'="")&&($p(ColDescList,"^",i)'=Desc)
		...s Colwidth=$p(ColwidthList,"^",i)
		...
		...k PLIST		
		...   
    	...s PLIST(27)=Colwidth
    	...i ColDescList="" d
		....&SQL(update DHC_BPC_InquiryItem values:PLIST() where BPCII_Parref=:Rowid and BPCII_Code=:IdOrCode)
		...e  d
		....&SQL(update DHC_BPC_InquiryItem values:PLIST() where BPCII_Parref=:Rowid and BPCII_Code=:IdOrCode and BPCII_Desc=:Desc)
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

/// 功能：自定义统计项目表，获取项目信息
/// 入参：Type，"P"病人基本信息;locId科室
/// 返回：项目列表
/// d ##class(%ResultSet).RunQuery("web.DHCBPCInquiry","FindBPCInquiryCode")
Query FindBPCInquiryCode(Type As %String = "", locId As %String = "") As %Query(ROWSPEC = "tID:%String,BPCICCode:%String,BPCICDesc:%String,BPCICType:%String,BPCICCtlocDr:%String,BPCICOption:%String")
{
}

ClassMethod FindBPCInquiryCodeExecute(ByRef qHandle As %Binary, Type As %String = "", locId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tID=0,typeCode="",LikeLoc=""
 	i Type'=""  s Type=$$ALPHAUP^SSUTIL4(Type)
 	f  s LikeLoc=$o(^DHCBPBedGroupWardLikeLoc(LikeLoc)) q:(LikeLoc="")||(locId="")  d //护士病房ID对应的医生科室ID
 	.s wardLoc=$g(^DHCBPBedGroupWardLikeLoc(LikeLoc))
 	.q:(locId'=wardLoc)
 	.s locId=LikeLoc
	f  s typeCode=$o(^DHCBPC("InquiryCode",0,"Type",typeCode)) q:typeCode=""  d
	.q:((Type'="")&&(Type'=typeCode))
	.f  s tID=$o(^DHCBPC("InquiryCode",0,"Type",typeCode,tID)) q:tID=""  d
	..s BPCICCode=$lg($g(^DHCBPC("InquiryCode",tID)),1)
	..s BPCICDesc=$lg($g(^DHCBPC("InquiryCode",tID)),2)
	..s BPCICType=$lg($g(^DHCBPC("InquiryCode",tID)),3)
	..s BPCICCtlocDr=$lg($g(^DHCBPC("InquiryCode",tID)),4)
	..q:(locId'="")&&(locId'=BPCICCtlocDr)
	..s BPCICOption=$lg($g(^DHCBPC("InquiryCode",tID)),5)
	..d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tID,BPCICCode,BPCICDesc,BPCICType,BPCICCtlocDr,BPCICOption)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindBPCInquiryCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPCInquiryCodeExecute ]
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

ClassMethod FindBPCInquiryCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPCInquiryCodeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// d ##class(web.DHCBPCInquiry).InsertDefineInquiryitemList("^patName^姓名^P^^^^^^^^^^^^0^0^0^^^1^^^^^^100^4359")
ClassMethod InsertDefineInquiryitemList(InquiryitemList As %String) As %String
{
	q:InquiryitemList=""	
	s BPCIRowid=$p(InquiryitemList,"^",1)
	s BPCIICode=$p(InquiryitemList,"^",2)
	s BPCIIDesc=$p(InquiryitemList,"^",3)
	s BPCIIType=$p(InquiryitemList,"^",4)
	s BPCIIIsSearch=$p(InquiryitemList,"^",5)
	s BPCIIIsDisplay=$p(InquiryitemList,"^",6)
	s BPCIIDataField=$p(InquiryitemList,"^",7)
	s BPCIIIsSingle=$p(InquiryitemList,"^",8)
	s BPCIIMinQty=$p(InquiryitemList,"^",9)
	s BPCIIMaxQty=$p(InquiryitemList,"^",10)
	s BPCIINote=$p(InquiryitemList,"^",11)
	s BPCIIMultiple=$p(InquiryitemList,"^",12)
	s BPCIIStartDateTime=$p(InquiryitemList,"^",13)
	s BPCIIDurationHour=$p(InquiryitemList,"^",14)
	s BPCIIOeoriNote=$p(InquiryitemList,"^",15)
	s BPCIIFromTime=$p(InquiryitemList,"^",16)
	s BPCIIToTime=$p(InquiryitemList,"^",17)
	s BPCIIExactTime=$p(InquiryitemList,"^",18)
	s BPCIIRefBPriId=$p(InquiryitemList,"^",19)
	s BPCIIRefValue=$p(InquiryitemList,"^",20)
	s BPCIISeqNo=$p(InquiryitemList,"^",21)
	s BPCIILevel=$p(InquiryitemList,"^",22)
	s BPCIIFromBPriId=$p(InquiryitemList,"^",23)
	s BPCIIToBPriId=$p(InquiryitemList,"^",24)
	s BPCIISummaryType=$p(InquiryitemList,"^",25)
	s BPCIIDurationInterval=$p(InquiryitemList,"^",26)
	s BPCIIColumnWidth=$p(InquiryitemList,"^",27)
	s BPCIIMainBPCIIDr=$p(InquiryitemList,"^",28)
	s BPCIUpdateUserDr=$p(InquiryitemList,"^",29)
	;s ^inquiryMFC("2012")=InquiryitemList
	s retStr=##class(web.DHCBPCInquiry).InsertInquiryitem(BPCIRowid, BPCIICode, BPCIIDesc, BPCIIType, BPCIIIsSearch, BPCIIIsDisplay, BPCIIDataField, BPCIIIsSingle, BPCIIMinQty, BPCIIMaxQty, BPCIINote, BPCIIMultiple, BPCIIStartDateTime, BPCIIDurationHour,
             BPCIIOeoriNote, BPCIIFromTime, BPCIIToTime, BPCIIExactTime, BPCIIRefBPriId, BPCIIRefValue, BPCIISeqNo, BPCIILevel, BPCIIFromBPriId, BPCIIToBPriId, BPCIISummaryType, BPCIIDurationInterval, BPCIIColumnWidth,BPCIIMainBPCIIDr, BPCIUpdateUserDr)
	q retStr
}

/// 获取检验项目明细
/// d ##class(%ResultSet).RunQuery("web.DHCBPCInquiry","FindLabSpecDesc")
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

/// 获取检验项目明细
/// d ##class(%ResultSet).RunQuery("web.DHCBPCInquiry","FindLabDesc")
Query FindLabDesc(LabCode As %String = "") As %Query(ROWSPEC = "labStandCode%String,labStandDesc%String")
{
}

ClassMethod FindLabDescExecute(ByRef qHandle As %Binary, LabCode As %String = "") As %Status
{
	
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1 	
 	s labStandCode=0,labStandDesc="" 
 	
 	s TestCodeDR="" 
 	f  s TestCodeDR=$o(^dbo.BTTestCodeD(TestCodeDR)) q:TestCodeDR=""  d
    	.s labStandDesc=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),3)
    	.q:(LabCode'="")&&(labStandCode'[$$UPPER^SSUTIL4(LabCode))
    	.s labStandCode=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),7)
    	.d OutputRow1
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

/// 保存自定义统计查询条件
/// w ##class(web.DHCBPCInquiry).SaveQueryCondition()
ClassMethod SaveQueryCondition(BPCIRowid As %String = "", QueryDesc As %String = "") As %String
{
	q:'$d(^DHCBPCInquiry(BPCIRowid)) "-1"	
	q:$d(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc)) "该名称已存在，无法保存！"
	k ^DHCBPCInquiryCondition(BPCIRowid,QueryDesc)
	s ^DHCBPCInquiryCondition(BPCIRowid,QueryDesc)=^DHCBPCInquiry(BPCIRowid)
	s ChildSub=0,SubId=0
	f  s ChildSub=$o(^DHCBPCInquiry(BPCIRowid,"I",ChildSub))  q:ChildSub=""  d
	.s ^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub)=^DHCBPCInquiry(BPCIRowid,"I",ChildSub)
	q "0"
}

/// 删除自定义统计查询条件
/// w ##class(web.DHCBPCInquiry).DeleteQueryCondition()
ClassMethod DeleteQueryCondition(BPCIRowid As %String = "", QueryDesc As %String = "") As %String
{
	q:'$d(^DHCBPCInquiry(BPCIRowid)) "-1"	
	q:'$d(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc)) "该名称不存在，无法删除！"
	k ^DHCBPCInquiryCondition(BPCIRowid,QueryDesc)
	q "0"
}

/// 获取历史自定义统计查询条件主项列表
/// d ##class(%ResultSet).RunQuery("web.DHCBPCInquiry","FindInquiryForCondition","3879","60")
Query FindInquiryForCondition(userId As %String, BPCIRowid As %String = "") As %Query(ROWSPEC = "DefQueryDesc:%String,DefQueryDate:%String,BPCIRowid:%String") [ SqlProc ]
{
}

ClassMethod FindInquiryForConditionExecute(ByRef qHandle As %Binary, userId As %String, BPCIRowid As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    if userId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    if BPCIRowid="" s BPCIRowid=$o(^DHCBPCInquiry(0,"TypeUser","S",userId,""))
    if BPCIRowid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s QueryDesc=""
    f  s QueryDesc=$o(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc))  q:QueryDesc=""  d
    .s DefQueryDesc=QueryDesc
  	.s DefQueryDate=$lg($g(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc)),13)
  	.i DefQueryDate'="" s DefQueryDate=$zd(DefQueryDate,3)
    .d OutputRow2
 	s qHandle=$lb(0,repid,0)
	q $$$OK    
OutputRow2
	s Data=$lb(DefQueryDesc,DefQueryDate,BPCIRowid)
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
/// d ##class(%ResultSet).RunQuery("web.DHCBPCInquiry","FindInquiryitemForCondition")
Query FindInquiryitemForCondition(userId As %String, BPCIRowid As %String = "", QueryDesc As %String) As %Query(ROWSPEC = "TBPCIRowid:%String,TRowid:%String,TBPCIICode:%String,TBPCIIDesc:%String,TBPCIIType:%String,TBPCIITypeD:%String,TBPCIIIsSearch:%String,TBPCIIIsSearchD:%String,TBPCIIIsDisplay:%String,TBPCIIIsDisplayD:%String,TBPCIIDataField:%String,TBPCIIIsSingle:%String,TBPCIIIsSingleD:%String,TBPCIIMinQty:%String,TBPCIIMaxQty:%String,TBPCIINote:%String,TBPCIIMultiple:%String,TBPCIIStartDateTime:%String,TBPCIIDurationHour:%Float,TBPCIIOeoriNote:%String,TBPCIIFromTime:%String,TBPCIIToTime:%String,TBPCIIExactTime:%String,TBPCIIRefIcuriId:%String,TBPCIIRefIcuriDesc:%String,TBPCIIRefValue:%String,TBPCIISeqNo:%Float,TBPCIILevel:%Float,BPCIIColumnWidth:%String,TBPCIISummaryType:%String,TBPCIIDurationInterval:%String,BPCIIMain:%String") [ SqlProc ]
{
}

ClassMethod FindInquiryitemForConditionExecute(ByRef qHandle As %Binary, userId As %String, BPCIRowid As %String = "", QueryDesc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    if userId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    if BPCIRowid="" s BPCIRowid=$o(^DHCBPCInquiry(0,"TypeUser","S",userId,""))
    if BPCIRowid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    if QueryDesc="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s ChildSub=0,SubId=0
    f  s ChildSub=$o(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub))  q:ChildSub=""  d
    .s TBPCIRowid=BPCIRowid
    .s TRowid=ChildSub
    .s TBPCIICode=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),1)
    .s TBPCIIDesc=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),2)
    .s TBPCIIType=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),3)
    .s TBPCIITypeD=""
    .s:TBPCIIType="P" TBPCIITypeD="Patient"
    .s:TBPCIIType="B" TBPCIITypeD="Baseline"
    .s:TBPCIIType="I" TBPCIITypeD="ICD"
    .s:TBPCIIType="D" TBPCIITypeD="Docter"
    .s:TBPCIIType="O" TBPCIITypeD="Order"
    .s:TBPCIIType="R" TBPCIITypeD="Record"
    .s:TBPCIIType="L" TBPCIITypeD="Lab"
    .s:TBPCIIType="C" TBPCIITypeD="CalcuLate"
    .s TBPCIIIsSearch=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),4)
    .s:TBPCIIIsSearch="1" TBPCIIIsSearchD="是"
    .s:TBPCIIIsSearch="0" TBPCIIIsSearchD="否"
    .s:TBPCIIIsSearch="" TBPCIIIsSearchD="是"
    .s TBPCIIIsDisplay=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),5)
    .s:TBPCIIIsDisplay="1" TBPCIIIsDisplayD="是"
    .s:TBPCIIIsDisplay="0" TBPCIIIsDisplayD="否"
    .s:TBPCIIIsDisplay="" TBPCIIIsDisplayD="是"    
    .s TBPCIIDataField=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),6)
    .s TBPCIIIsSingle=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),7)
    .s:TBPCIIIsSingle="1" TBPCIIIsSingleD="是"
    .s:TBPCIIIsSingle="0" TBPCIIIsSingleD="否"
    .s:TBPCIIIsSingle="" TBPCIIIsSingleD="是" 
    .s TBPCIIMinQty=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),8)
    .s TBPCIIMaxQty=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),9)
    .s TBPCIINote=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),10)
    .s TBPCIIMultiple=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),11)
    .s TBPCIIStartDateTime=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),12)
    .s TBPCIIDurationHour=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),13)
    .s TBPCIIOeoriNote=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),14)
    .s TBPCIIFromTime=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),15)
    .i TBPCIIFromTime'="" s TBPCIIFromTime=TBPCIIFromTime
    .s TBPCIIToTime=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),16)
    .i TBPCIIToTime'="" s TBPCIIToTime=TBPCIIToTime
    .s TBPCIIExactTime=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),17)
    .i TBPCIIExactTime'="" s TBPCIIExactTime=$zt(TBPCIIExactTime,2)
    .s TBPCIIRefIcuriId=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),18)
    .s TBPCIIRefIcuriDesc=""
    .i TBPCIIRefIcuriId'="" s TBPCIIRefIcuriDesc=$p($g(^DHCBPC("RecordItem",TBPCIIRefIcuriId)),"^",2)
    .s TBPCIIRefValue=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),19)
    .s TBPCIISeqNo=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),20)
    .s TBPCIILevel=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),21)
    .s TBPCIISummaryType=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),24)
    .s TBPCIIDurationInterval=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),25)
    .s BPCIIColumnWidth=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),26)
    .s BPCIIMain=$lg(^DHCBPCInquiryCondition(BPCIRowid,QueryDesc,"I",ChildSub),27)
    .i (TBPCIISeqNo="")||(TBPCIISeqNo=SubId) d      
    ..s ^TMPAN("InquiryItem",$j,SubId)=$lb(TBPCIRowid,TRowid,TBPCIICode,TBPCIIDesc,TBPCIIType,TBPCIITypeD,TBPCIIIsSearch,TBPCIIIsSearchD,TBPCIIIsDisplay,TBPCIIIsDisplayD,TBPCIIDataField,TBPCIIIsSingle,TBPCIIIsSingleD,TBPCIIMinQty,TBPCIIMaxQty,TBPCIINote,TBPCIIMultiple,TBPCIIStartDateTime,TBPCIIDurationHour,TBPCIIOeoriNote,TBPCIIFromTime,TBPCIIToTime,TBPCIIExactTime,TBPCIIRefIcuriId,TBPCIIRefIcuriDesc,TBPCIIRefValue,TBPCIISeqNo,TBPCIILevel,BPCIIColumnWidth,TBPCIISummaryType,TBPCIIDurationInterval,BPCIIMain)
    .e  d
    ..s ^TMPAN("InquiryItem",$j,TBPCIISeqNo)=$lb(TBPCIRowid,TRowid,TBPCIICode,TBPCIIDesc,TBPCIIType,TBPCIITypeD,TBPCIIIsSearch,TBPCIIIsSearchD,TBPCIIIsDisplay,TBPCIIIsDisplayD,TBPCIIDataField,TBPCIIIsSingle,TBPCIIIsSingleD,TBPCIIMinQty,TBPCIIMaxQty,TBPCIINote,TBPCIIMultiple,TBPCIIStartDateTime,TBPCIIDurationHour,TBPCIIOeoriNote,TBPCIIFromTime,TBPCIIToTime,TBPCIIExactTime,TBPCIIRefIcuriId,TBPCIIRefIcuriDesc,TBPCIIRefValue,TBPCIISeqNo,TBPCIILevel,BPCIIColumnWidth,TBPCIISummaryType,TBPCIIDurationInterval,BPCIIMain)
    ..s SubId=TBPCIISeqNo
    .s SubId=SubId+1
    
    s TBPCIISeqNo="" f  s TBPCIISeqNo=$o(^TMPAN("InquiryItem",$j,TBPCIISeqNo)) q:TBPCIISeqNo=""  d
    .d OutputRow2
	
	k ^TMPAN("InquiryItem",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	;set Data=$lb(TRowid,TBPCICode,TBPCIDesc,TBPCICtlocDr,TBPCICtloc,TBPCIStatusCode,TBPCIStatus,TBPCISearchLevel,TBPCIIcuaCount,TBPCIResultCount)
 	Set ^CacheTemp(repid,ind)=^TMPAN("InquiryItem",$j,TBPCIISeqNo)
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
