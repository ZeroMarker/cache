Class web.DHCANConfigItem Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCANConfigItem","FindRecordOrder")
Query FindRecordOrder(txtCode As %String = "") As %Query(ROWSPEC = "ANCRRowId,ANCRCode,ANCRDesc,ANCRType,ANCRTypeDesc,ANCRFlag,ANCRValue,ANCRNote")
{
}

ClassMethod FindRecordOrderExecute(ByRef qHandle As %Binary, txtCode As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s ANCRRowId=0 f  s ANCRRowId=$o(^DHCANC("Record",ANCRRowId)) q:ANCRRowId=""  d
	.s ANCRCode=$li(^DHCANC("Record",ANCRRowId),1)
	.s ANCRDesc=$li(^DHCANC("Record",ANCRRowId),2)
	.s ANCRType=$li(^DHCANC("Record",ANCRRowId),3)
	.q:(ANCRCode'=txtCode)&(txtCode'="")
	.s ANCRTypeDesc=""
	.i ANCRType="E" s ANCRTypeDesc="术前"
	.e  i ANCRType="I" s ANCRTypeDesc="术中"
	.e  i ANCRType="T" s ANCRTypeDesc="术后"
	.e  i ANCRType="C" s ANCRTypeDesc="同意书"
	.e  i ANCRType="S" s ANCRTypeDesc="小结总结"
	.e  i ANCRType="A" s ANCRTypeDesc="镇痛访视"
	.e  i ANCRType="R" s ANCRTypeDesc="复苏室"
	.s ANCRFlag=$li(^DHCANC("Record",ANCRRowId),4)
	.s ANCRValue=$li(^DHCANC("Record",ANCRRowId),5)
	.s ANCRNote=$li(^DHCANC("Record",ANCRRowId),6)
	.d OutputMessage
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputMessage
 set Data=$lb(ANCRRowId,ANCRCode,ANCRDesc,ANCRType,ANCRTypeDesc,ANCRFlag,ANCRValue,ANCRNote)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindRecordOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRecordOrderExecute ]
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

ClassMethod FindRecordOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRecordOrderExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

//w ##class(web.DHCANConfigItem).SaveRecordOrder(214,"Intubat_$c(1)_3#",3053)

ClassMethod SaveRecordOrder(opaId, para, userId) As %String
{
	s ^tempck(1234)=opaId_"*"_para_"*"_userId
	q:opaId="" "-1^opaId"
	q:userId="" "-2^userId"
	s result="",tempResult="",date=+$h,time=$p($h,",",2)
	f i=1:1:$l(para,"^") d
	.s recordItem=$p(para,"^",i)
	.q:recordItem=""
	.s code=$p(recordItem,$c(3),1)
	.s value=$p(recordItem,$c(3),2)
	.i $l(recordItem,$c(3))>2 d
	..s date=##class(web.DHCANOPCom).ConvertToDateH($p(recordItem,$c(3),3),$H)
	..s time=##class(web.DHCANOPCom).ConvertToTimeH($p(recordItem,$c(3),4),$H)
	
	.i code'="" d
	..s recordDr=$o(^DHCANC("Record",0,"Code",code,""))
	..i recordDr'="" d
	...s retult=..SaveRecordOrderItem(opaId,recordDr,value,userId,date,time)
	...i +retult<0 s result=result_retult_"^"
	..e  d
	...s tempResult=tempResult_code_"^"
	s ^tempck("RecordOrder",opaId)=tempResult
	q result
}

//w ##class(web.DHCANConfigItem).SaveRecordOrderItem(214,3,"3#",3053)

ClassMethod SaveRecordOrderItem(opaId, recordId, value, userId, date, time) As %String
{
	s ^tempck(1235)=recordId_"*"_value
	q:opaId="" "-1^opaId"
	q:recordId="" "-2^recordId"
	q:userId="" "-3^userId"
	s rowDr=""
    s rowId="" f  s rowId=$o(^DHCANRecordOrder(0,"OpaDr",opaId,rowId)) q:rowId=""  d
    .s recordDr=$li(^DHCANRecordOrder(rowId),2)
    .q:recordDr'=recordId
    .s obj=##class(User.DHCANRecordOrder).%OpenId(rowId)
    .s rowDr=rowId
    i rowDr="" s obj=##class(User.DHCANRecordOrder).%New()
	s obj.ANROOpaDr=##Class(User.DHCANOPArrange).%OpenId(opaId)
	s obj.ANRORecordDr=##Class(User.DHCANCRecord).%OpenId(recordId)
	s obj.ANROValue=value
	s obj.ANROUser=userId
	s obj.ANROUpdateDate=+$h
	s obj.ANROUpdateTime=$p($h,",",2)
	s obj.ANRODate=date
	s obj.ANROTime=time
		
	s saveStatus=obj.%Save()
	q:(+saveStatus=0) "-4^数据保存失败!"_code
	s RowId=obj.%Id()
	d obj.%Close()
	q RowId
}

ClassMethod FindRecordItemValue(opaId, code) As %String
{
	q:opaId="" ""
	q:code="" ""
	s retStr=""
	s recordDr=$o(^DHCANC("Record",0,"Code",code,""))
	q:recordDr="" ""
	s ANRORowId="" f  s ANRORowId=$o(^DHCANRecordOrder(0,"OpaDr",opaId,ANRORowId)) q:ANRORowId=""  d
	.s recordId=$li(^DHCANRecordOrder(ANRORowId),2)
	.q:recordDr'=recordId
	.s value=$li(^DHCANRecordOrder(ANRORowId),3)
	.s date=$li(^DHCANRecordOrder(ANRORowId),7)
	.s time=$li(^DHCANRecordOrder(ANRORowId),8)
	.i retStr="" s retStr=value_$c(3)_$zd(date,3)_" "_$zt(time,2)
	.e  s retStr=retStr_"^"_value_$c(3)_$zd(date,3)_" "_$zt(time,2)
	
	q retStr
}

/// 插入数据
/// ANCRCode,ANCRDesc,ANCRType,ANCRFlag,ANCRValue,ANCRNote
ClassMethod InsertMessage(ANCRCode As %String, ANCRDesc As %String, ANCRType As %String, ANCRFlag As %String, ANCRValue As %String, ANCRNote As %String) As %String
{
	k PLIST
	TSTART
	s PLIST(2)=ANCRCode
	s PLIST(3)=ANCRDesc
	s PLIST(4)=ANCRType
	s PLIST(5)=ANCRFlag
	s PLIST(6)=ANCRValue
	s PLIST(7)=ANCRNote
	;s PLIST(8)=UserIPAdress
	&SQL(insert into SQLUSER.DHC_ANC_Record Values :PLIST())
	i SQLCODE
	{	TROLLBACK
	}
	else {	TCOMMIT}
	q SQLCODE
}

/// w ##class(web.DHCANConfigItem).PanduanMessage("1")
ClassMethod PanduanMessage(ANCRCode) As %String
{
	s Pinchuan="",ret=1
	s rowid=0
	for  s rowid=$o(^DHCANC("Record",rowid))  q:rowid=""  d
	.s Pinchuan=Pinchuan_"^"_$li(^DHCANC("Record",rowid),1)
	.i "^"_Pinchuan_"^"[("^"_ANCRCode_"^") set ret=0
	.;if "^"_ANCRCode_"^"["^"_Pinchuan_"^" set ret=0
	q ret
}

/// 删除数据
/// w ##class(web.DHCANConfigItem).DeleteMessage("9")
ClassMethod DeleteMessage(Rowid) As %String
{
	i Rowid'="" d
	.&SQL(delete from SQLUSER.DHC_ANC_Record where ANCR_RowId=:Rowid)
	q SQLCODE
}

/// 更新数据
/// ANCRRowId,ANCRCode,ANCRDesc,ANCRType,ANCRFlag,ANCRValue,ANCRNote
/// w ##class(web.DHCANConfigItem).UpdateMessage("8","cccttt","娜娜","E","Y","vvvvvvVVV","BBB")
ClassMethod UpdateMessage(RowId As %String, ANCRCode As %String, ANCRDesc As %String, ANCRType As %String, ANCRFlag As %String, ANCRValue As %String, ANCRNote As %String)
{
	k PLIST 
	&sql(select * into :PLIST() from SQLUSER.DHC_ANC_Record where ANCR_RowId=:RowId)
    i SQLCODE TRollBack  q 
	;s PLIST(1)=ANCRRowId
	s PLIST(2)=ANCRCode
	s PLIST(3)=ANCRDesc
	s PLIST(4)=ANCRType
	s PLIST(5)=ANCRFlag
	s PLIST(6)=ANCRValue
	s PLIST(7)=ANCRNote
	&sql(update SQLUSER.DHC_ANC_Record Values :PLIST() where ANCR_RowId=:RowId)
 	q SQLCODE
}

}
