Import SQLUser

/// 对附加项目的综合查询
/// by wuqk 2007-05-15
/// Modify by 2007-05-22  for Structure Rebuild
Class web.DHCWMRXDtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 47;

ClassMethod QueryTotalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTotalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryTotalExecute(ByRef qHandle As %Binary, MrTypeDr As %String, ItemDetails As %String, dFrom As %String, dTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:ItemDetails="" $$$OK
	s dFrom=$zdh(dFrom,4)
	s dTo=$zdh(dTo,4)
	f i=1:1:$l(ItemDetails,"^") d
	.s DtlRowid=$p(ItemDetails,"^",i)
	.;^DHCWMRMAIN(0,"Dtl",{Detail_Dr},{ItemValue},
	.;  "M",{DHC_WMR_Main.Rowid},{DHC_WMR_MainStatus.ChildSub},{ChildSub})
	.;  "V",{DHC_WMR_Main.Rowid},{DHC_WMR_MainVolume.ChildSub},{DHC_WMR_VolStatus.ChildSub},{ChildSub}    ^DHCWMRMAIN({DHC_WMR_Main.Rowid},"V",{DHC_WMR_MainVolume.ChildSub},"S",{DHC_WMR_VolStatus.ChildSub},"D",{ChildSub}) 
	.;q:'$d(^DHCWMRMAIN(0,"Dtl",+DtlRowid))
	.s Data=..BuildXDtl(MrTypeDr,DtlRowid, dFrom, dTo)
	.q:Data=""
	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
	
	/*
	s rowid="0"
	f  s rowid=$o(^DHCWMRWDTL(rowid)) q:rowid=""  d
	.s s=$g(^DHCWMRWDTL(rowid))
	.;q:$p(s,"^",4)'=Active
	.s desc=$p(s,"^",2)
	.s Data=$lb(+rowid,desc)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
	*/
	Quit $$$OK
}

ClassMethod QueryTotalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTotalExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query QueryTotal(MrTypeDr As %String, ItemDetails As %String, dFrom As %String, dTo As %String) As %Query(ROWSPEC = "DetailRowid:%String,Desc:%String,DataType:%String,Count:%String,Max:%String,Min:%String,Avg:%String")
{
}

/// 构造QueryTotal的输出结果
ClassMethod BuildXDtl(MrTypeDr, DtlRowid, dFrom, dTo)
{
	n (MrTypeDr,DtlRowid, dFrom, dTo)
	
	;^DHCWMRMAIN(0,"Dtl",{Detail_Dr},{ItemValue},
	;  "M",{DHC_WMR_Main.Rowid},{DHC_WMR_MainStatus.ChildSub},{ChildSub})
	;  "V",{DHC_WMR_MainVolume.Rowid},{DHC_WMR_VolStatus.ChildSub},{ChildSub}
	;s Data=$lb("")
	s sDtl=##class(web.DHCWMRWorkDetailCtl).GetDataById(+DtlRowid)
	s DataType=$p(sDtl,"^",4)
	s Desc=$p(sDtl,"^",3)
	s Count=0,Max="",Min="",Avg="",Total=0
	s Data=$lb(DtlRowid,Desc,DataType,Count,Max,Min,Avg)
	i '$d(^DHCWMRMAIN(0,"Dtl",+DtlRowid)) d
	.s Data=$lb(DtlRowid,Desc,DataType,Count,Max,Min,Avg)
	q:'$d(^DHCWMRMAIN(0,"Dtl",+DtlRowid)) Data
	
	; Max=0,Min=0,Avg=0
	s ItemValue=""
	f  s ItemValue=$o(^DHCWMRMAIN(0,"Dtl",+DtlRowid,ItemValue)) q:ItemValue=""  d
	.s CountM=..GetMainCount(MrTypeDr,DtlRowid,ItemValue,dFrom,dTo)
	.s CountV=..GetVolCount(MrTypeDr,DtlRowid,ItemValue,dFrom,dTo)
	.s Count=Count+CountM+CountV
	.i DataType="Number" d
	..s Total=((CountM+CountV)*(+ItemValue))+Total
	q:+Count=0 Data

	i DataType="Number" d
	.s Max=$o(^DHCWMRMAIN(0,"Dtl",+DtlRowid,""),-1)
	.s Min=$o(^DHCWMRMAIN(0,"Dtl",+DtlRowid,""))
	.s Total=+Total,Count=+Count
	.s Avg=+(Total/Count)
	s Data=$lb(DtlRowid,Desc,DataType,Count,Max,Min,Avg)
	q Data
	/*
	;^DHCWMRMAIN(0,"Dtl",{Detail_Dr},{ItemValue},
	;  "M",{DHC_WMR_Main.Rowid},{DHC_WMR_MainStatus.ChildSub},{ChildSub})
	;  "V",{DHC_WMR_Main.Rowid},{DHC_WMR_MainVolume.ChildSub},{DHC_WMR_VolStatus.ChildSub},{ChildSub}    
	s Data=$lb("")
	s sDtl=##class(web.DHCWMRWorkDetailCtl).GetDataById(+DtlRowid)
	s DataType=$p(sDtl,"^",4)
	s Desc=$p(sDtl,"^",3)
	s Count=0,Max="",Min="",Avg="",Total=0
	i '$d(^DHCWMRMAIN(0,"Dtl",+DtlRowid)) d
	.s Data=$lb(DtlRowid,Desc,DataType,Count,Max,Min,Avg)
	q:'$d(^DHCWMRMAIN(0,"Dtl",+DtlRowid)) Data
	
	; Max=0,Min=0,Avg=0
	s ItemValue=""
	f  s ItemValue=$o(^DHCWMRMAIN(0,"Dtl",+DtlRowid,ItemValue)) q:ItemValue=""  d
	.s CountM=..GetMainCount(DtlRowid,ItemValue,dFrom,dTo)
	.s CountV=..GetVolCount(DtlRowid,ItemValue,dFrom,dTo)
	.s Count=Count+CountM+CountV
	.i DataType="Number" d
	..s Total=((CountM+CountV)*(+ItemValue))+Total

	i DataType="Number" d
	.s Max=$o(^DHCWMRMAIN(0,"Dtl",+DtlRowid,""),-1)
	.s Min=$o(^DHCWMRMAIN(0,"Dtl",+DtlRowid,""))
	.s Avg=Total/Count
	s Data=$lb(DtlRowid,Desc,DataType,Count,Max,Min,Avg)
	q Data
	*/
}

/// 统计MainStatusDtl下 DtlRowid,ItemValue 的数量
ClassMethod GetMainCount(MrTypeDr, DtlRowid, ItemValue, dFrom, dTo)
{
	n (MrTypeDr,DtlRowid,ItemValue,dFrom,dTo)
	s CountM=0
	q:'$d(^DHCWMRMAIN(0,"Dtl",+DtlRowid,ItemValue,"M")) CountM
	;^DHCWMRMAIN(0,"Dtl",{Detail_Dr},{ItemValue},
	;  "M",{DHC_WMR_Main.Rowid},{DHC_WMR_MainStatus.ChildSub},{ChildSub})
	s MainRowid=""
	f  s MainRowid=$o(^DHCWMRMAIN(0,"Dtl",+DtlRowid,ItemValue,"M",MainRowid)) q:MainRowid=""  d
	.s sMain=$g(^DHCWMRMAIN(+MainRowid))
	.q:$p(sMain,"^",1)'=MrTypeDr
	.q:$p(sMain,"^",6)'="Y"
	.s Status="" f  s Status=$o(^DHCWMRMAIN(0,"Dtl",+DtlRowid,ItemValue,"M",MainRowid,Status)) q:Status=""  d
	..s sMainStatus=$g(^DHCWMRMAIN(+MainRowid,"S",Status))
	..s Date=$p(sMainStatus,"^",3)
	..q:(Date>dTo)!(Date<dFrom)
	..s Dtl="" f  s Dtl=$o(^DHCWMRMAIN(0,"Dtl",+DtlRowid,ItemValue,"M",MainRowid,Status,Dtl)) q:Dtl=""  d
	...s CountM=CountM+1
	
	q CountM
}

/// 统计VolStatusDtl下 DtlRowid,ItemValue 的数量
ClassMethod GetVolCount(MrTypeDr, DtlRowid, ItemValue, dFrom, dTo)
{
	n (MrTypeDr,DtlRowid,ItemValue,dFrom,dTo)
	s CountV=0
	q:'$d(^DHCWMRMAIN(0,"Dtl",+DtlRowid,ItemValue,"V")) CountV
	;^DHCWMRMAIN(0,"Dtl",{Detail_Dr},{ItemValue},
	;  "V",{DHC_WMR_MainVolume.Rowid},{DHC_WMR_VolStatus.ChildSub},{ChildSub}
	
	s Vol="" f  s Vol=$o(^DHCWMRMAIN(0,"Dtl",+DtlRowid,ItemValue,"V",Vol)) q:Vol=""  d
	.s sVol=$g(^DHCWMRVOL(+Vol))
	.q:$p(sVol,"^",7)'="Y"
	.s MainRowid=+$p(sVol,"^",1)
	.s sMain=$g(^DHCWMRMAIN(+MainRowid))
	.q:$p(sMain,"^",1)'=MrTypeDr
	.q:$p(sMain,"^",6)'="Y"
	.s Status="" f  s Status=$o(^DHCWMRMAIN(0,"Dtl",+DtlRowid,ItemValue,"V",Vol,Status)) q:Status=""  d
	..s sVolStatus=$g(^DHCWMRVOL(+Vol,"S",Status))
	..s Date=$p(sVolStatus,"^",3)
	..q:(Date>dTo)!(Date<dFrom)
	..s Dtl="" f  s Dtl=$o(^DHCWMRMAIN(0,"Dtl",+DtlRowid,ItemValue,"V",Vol,Status,Dtl)) q:Dtl=""  d
	...s CountV=CountV+1
	q CountV
	/*
	s MainRowid=""	
	f  s MainRowid=$o(^DHCWMRMAIN(0,"Dtl",+DtlRowid,ItemValue,"V",MainRowid)) q:MainRowid=""  d
	.s Vol="" f  s Vol=$o(^DHCWMRMAIN(0,"Dtl",+DtlRowid,ItemValue,"V",MainRowid,Vol)) q:Vol=""  d
	..s Status="" f  s Status=$o(^DHCWMRMAIN(0,"Dtl",+DtlRowid,ItemValue,"M",MainRowid,Vol,Status)) q:Status=""  d
	...s sVolStatus=$g(^DHCWMRMAIN(+MainRowid,"V",Vol,"S",Status))
	...s Date=$p(sMainStatus,"^",3)
	...q:(Date>dTo)!(Date<dFrom)
	...s Dtl="" f  s Dtl=$o(^DHCWMRMAIN(0,"Dtl",+DtlRowid,ItemValue,"M",MainRowid,Vol,Status,Dtl)) q:Dtl=""  d
	....s CountV=CountV+1
	*/
}

ClassMethod QueryDtlValueListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDtlValueListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryDtlValueListExecute(ByRef qHandle As %Binary, MrTypeDr As %String, DtlRowid As %String, dFrom As %String, dTo As %String, DtlCount As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s DtlCount=+DtlCount
	Quit:DtlRowid="" $$$OK
	Quit:DtlCount=0 $$$OK
	
	Quit:'$d(^DHCWMRMAIN(0,"Dtl",+DtlRowid)) $$$OK
	
	s dFrom=$zdh(dFrom,4)
	s dTo=$zdh(dTo,4)
	s ItemValue=""
	f  s ItemValue=$o(^DHCWMRMAIN(0,"Dtl",+DtlRowid,ItemValue)) q:ItemValue=""  d
	.s CountM=..GetMainCount(MrTypeDr,DtlRowid,ItemValue,dFrom,dTo)
	.s CountV=..GetVolCount(MrTypeDr,DtlRowid,ItemValue,dFrom,dTo)
	.s Count=CountM+CountV
	.q:Count=0
	.s Perc=##class(web.DHCWMRMedBaseCtl).GetPercent(Count/DtlCount)
	.;Add by wuqk 2008-05-29  字典类型，取描述
	.s ItemValueDesc=ItemValue
	.s sWorkDetail=##class(web.DHCWMRWorkDetailCtl).GetDataById(DtlRowid)
	.s DataType=$p(sWorkDetail,"^",4)
	.i DataType="Dictionary"  d
	..s sDictionary=##class(web.DHCWMRDictionaryCtl).GetDataById(ItemValue)
	..s ItemValueDesc=$p(sDictionary,"^",4)
	.s Data=$lb(DtlRowid,ItemValueDesc,Count,Perc)
	.;end by wuqk 
	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
	Quit $$$OK
}

ClassMethod QueryDtlValueListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDtlValueListExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 查询按照具体DetailRowid的值分组的列表
/// by wuqk 2007－05
Query QueryDtlValueList(MrTypeDr As %String, DtlRowid As %String, dFrom As %String, dTo As %String, DtlCount As %String) As %Query(ROWSPEC = "DtlRowid:%String,ItemValue:%String,ItemCount:%String,Perc:%String")
{
}

}
