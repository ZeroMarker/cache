Class web.DHCICUCTemperature Extends %RegisteredObject
{

ClassMethod SaveICUCTemper(rowId, recordItemId, observeItemId, dayFactor, startTime, validSpan, upperThreshold, interval, type = "", summaryInsertTime = "", ctlocId = "", strategy = "", spareIcucriCode = "") As %String
{
	quit:recordItemId="" "常用医嘱不能为空"
	quit:observeItemId="" "观察项不能为空"
	quit:dayFactor="" "时间点个数不能为空"
	quit:startTime="" "开始时间不能为空"
	quit:type="" "类型不能为空"
	
	if +rowId set saveObj=##class(User.DHCICUCTemperature).%OpenId(rowId)
	else  set saveObj=##class(User.DHCICUCTemperature).%New()
	
	set saveObj.ICUCTRecordItemCode=recordItemId
	set saveObj.ICUCTObservationItemCode=observeItemId
	set saveObj.ICUCTDayFactor=dayFactor
	set saveObj.ICUCTStartTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	set saveObj.ICUCTValidSpan=##class(web.DHCClinicCom).ConvertToTimeH(validSpan)
	set saveObj.ICUCTExtraUpperThreshold=upperThreshold
	if interval'="" set saveObj.ICUCTExtraInterval=##class(web.DHCClinicCom).ConvertToTimeH(interval)
	else  set saveObj.ICUCTExtraInterval=""
	set saveObj.ICUCTType=type
	if summaryInsertTime'="" set saveObj.ICUCTSummaryInsertTime = ##class(web.DHCClinicCom).ConvertToTimeH(summaryInsertTime)
	else  set saveObj.ICUCTSummaryInsertTime = ""
	set saveObj.ICUCTCtlocId=ctlocId
	set saveObj.ICUCTStrategy=strategy
	set saveObj.ICUCTSpareIcucriCode=spareIcucriCode
	
	
	do saveObj.%Save()
	
	quit +saveObj.%Id()
}

ClassMethod RemoveICUCTemper(rowId) As %String
{
	quit:rowId="" "数据ID为空"
	
	set status=##class(User.DHCICUCTemperature).%DeleteId(rowId)
	
	quit 0
}

Query FindICUCTemper() As %Query(ROWSPEC = "RowId,RecordItemId,RecordItem,ObserveItemId,ObserveItem,DayFactor,StartTime,ValidSpan,UpperThreshold,Interval,Type,SummaryInsertTime,CtlocId,Strategy,SpareIcucriCode")
{
}

ClassMethod FindICUCTemperExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=0
	f  s RowId=$o(^DHCICUC("Temperature",RowId))  q:RowId=""  d
    .s RecordItemId=$lg(^DHCICUC("Temperature",RowId),1)
    .s RecordItem="" //$p($g(^DHCICUC("RecordItem",+RecordItemId)),"^",2)
    .s ObserveItemId=$lg(^DHCICUC("Temperature",RowId),2)
    .s ObserveItem=ObserveItemId
    .;s ObserveItem=$p($g(^MRC("OBITM",+ObserveItemId)),"^",2)
    .s DayFactor=$lg(^DHCICUC("Temperature",RowId),3)
    .s StartTime=$lg(^DHCICUC("Temperature",RowId),4)
    .s StartTime=$zt(+StartTime,2)
    .s ValidSpan=$lg(^DHCICUC("Temperature",RowId),5)
    .s ValidSpan=$zt(+ValidSpan,2)
    .s UpperThreshold=$lg(^DHCICUC("Temperature",RowId),6)
    .s Interval=$lg(^DHCICUC("Temperature",RowId),7)
    .s:Interval'="" Interval=$zt(+Interval,2)
    .s Type=$lg(^DHCICUC("Temperature",RowId),8)
    .s SummaryInsertTime=$lg(^DHCICUC("Temperature",RowId),9)
    .s:SummaryInsertTime'="" SummaryInsertTime=$zt(+SummaryInsertTime,2)
    .s CtlocId=$lg(^DHCICUC("Temperature",RowId),10)
    .s Strategy=$lg(^DHCICUC("Temperature",RowId),11)
    .s SpareIcucriCode=$lg(^DHCICUC("Temperature",RowId),12)
	.d OutputICUCTemper
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputICUCTemper
	set Data=$lb(RowId,RecordItemId,RecordItem,ObserveItemId,ObserveItem,DayFactor,StartTime,ValidSpan,UpperThreshold,Interval,Type,SummaryInsertTime,CtlocId,Strategy,SpareIcucriCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUCTemperFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUCTemperExecute ]
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

ClassMethod FindICUCTemperClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUCTemperExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindObserveItem() As %Query(ROWSPEC = "RowId,Desc")
{
}

ClassMethod FindObserveItemExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=0
	f  s RowId=$o(^MRC("OBITM",RowId))  q:RowId=""  d
    .s Desc=$p(^MRC("OBITM",RowId),"^",2)
	.d OutputRow9
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow9
	set Data=$lb(RowId,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindObserveItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindObserveItemExecute ]
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

ClassMethod FindObserveItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindObserveItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
