Import SQLUser

/// 统计接诊情况
Class web.DHCWMRXReceipt Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 13;

ClassMethod QueryReceiptsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReceiptsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryReceiptsExecute(ByRef qHandle As %Binary, MrType As %String, ItemDr As %String, DateFrom As %String, DateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:MrType="" $$$OK
	Quit:ItemDr="" $$$OK
	Quit:DateFrom="" $$$OK
	Quit:DateTo="" $$$OK
	
	s JIndex=..GetTempData(MrType, ItemDr, DateFrom,DateTo)
	Quit:'$d(^CacheTemp("DHCWMRXReceipt",JIndex)) $$$OK
	
	s SumAll=0,SumActive=0
	s ctloc=""
	f  s ctloc=$o(^CacheTemp("DHCWMRXReceipt",JIndex,ctloc)) q:ctloc=""  d
	.s LocDesc=$p($g(^CTLOC(+ctloc)),"^",2)
	.s UserRowid="",UserName=""
	.s CountAll=+$g(^CacheTemp("DHCWMRXReceipt",JIndex,ctloc,0,"All"))
	.s CountActive=+$g(^CacheTemp("DHCWMRXReceipt",JIndex,ctloc,0,"Active"))
	.s SumAll=SumAll+CountAll
	.s SumActive=SumActive+CountActive
	.d BuildReceiptData
	.s UserRowid=0
	.f  s UserRowid=$o(^CacheTemp("DHCWMRXReceipt",JIndex,ctloc,UserRowid)) q:UserRowid=""  d
	..s LocDesc=""
	..s CountAll=+$g(^CacheTemp("DHCWMRXReceipt",JIndex,ctloc,UserRowid,"All"))
	..s CountActive=+$g(^CacheTemp("DHCWMRXReceipt",JIndex,ctloc,UserRowid,"Active"))
	..s UserName=$p($g(^SSU("SSUSR",UserRowid)),"^",2)
	..d BuildReceiptData
	i SumAll'=0 d
	.s ctloc="",LocDesc="合计",UserRowid="",UserName=""
	.s CountAll=SumAll,CountActive=SumActive
	.d BuildReceiptData
	Quit $$$OK	
BuildReceiptData
	s Data=$lb(ctloc,LocDesc,UserRowid,UserName,CountAll,CountActive)
	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod QueryReceiptsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReceiptsExecute ]
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

//d ##Class(%ResultSet).RunQuery("web.DHCWMRXReceipt","QueryReceipts","6","28","2008-04-08","2008-04-24")

Query QueryReceipts(MrType As %String, ItemDr As %String, DateFrom As %String, DateTo As %String) As %Query(ROWSPEC = "ctloc:%String,LocDesc:%String,UserRowid:%String,UserName:%String,CountAll:%String,CountActive:%String")
{
}

ClassMethod GetTempData(MrType, ItemDr, DateFrom, DateTo)
{
	n (MrType, ItemDr, DateFrom,DateTo)
	s JIndex=$j
	k ^CacheTemp("DHCWMRXReceipt",JIndex)
	;^DHCWMRVOL(0,"VSDateStatus",{CurrDate},{Status_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
	s tmpDate=DateFrom-1
	f  s tmpDate=$o(^DHCWMRVOL(0,"VSDateStatus",tmpDate)) q:(tmpDate="")!(tmpDate>DateTo)  d
	.q:'$d(^DHCWMRVOL(0,"VSDateStatus",tmpDate,ItemDr))
	.s VolRowid=0
	.f  s VolRowid=$o(^DHCWMRVOL(0,"VSDateStatus",tmpDate,ItemDr,VolRowid)) q:VolRowid=""  d
	..s statusSub=$o(^DHCWMRVOL(0,"VSDateStatus",tmpDate,ItemDr,VolRowid,""),-1)
	..s UserRowid=$p($g(^DHCWMRVOL(VolRowid,"S",statusSub)),"^",2)
	..q:UserRowid=""
	..s ctloc=$p($g(^SSU("SSUSR",UserRowid)),"^",4)
	..s sVol=##class(web.DHCWMRVolumeCtl).GetVolume(VolRowid)
	..s VolActive=$p(sVol,"^",8)
	..s MainRowid=$p(sVol,"^",2)
	..s sMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
	..s MainActive=$p(sMain,"^",7)
	..s MainType=$p(sMain,"^",2)
	..q:MainType'=MrType
	..;;Get ctloc count
	..i '$d(^CacheTemp("DHCWMRXReceipt",JIndex,ctloc,0,"All")) d
	...s ctlocAll=0
	..e  d
	...s ctlocAll=+$g(^CacheTemp("DHCWMRXReceipt",JIndex,ctloc,0,"All"))
	..i '$d(^CacheTemp("DHCWMRXReceipt",JIndex,ctloc,0,"Active")) d
	...s ctlocActive=0
	..e  d
	...s ctlocActive=+$g(^CacheTemp("DHCWMRXReceipt",JIndex,ctloc,0,"Active"))
	..;;Get user count
	..i '$d(^CacheTemp("DHCWMRXReceipt",JIndex,ctloc,UserRowid,"All")) d
	...s UserAll=0
	..e  d
	...s UserAll=+$g(^CacheTemp("DHCWMRXReceipt",JIndex,ctloc,UserRowid,"All"))
	..i '$d(^CacheTemp("DHCWMRXReceipt",JIndex,ctloc,UserRowid,"Active")) d
	...s UserActive=0
	..e  d
	...s UserActive=+$g(^CacheTemp("DHCWMRXReceipt",JIndex,ctloc,UserRowid,"Active"))
	..;;Set count
	..s ^CacheTemp("DHCWMRXReceipt",JIndex,ctloc,0,"All")=ctlocAll+1
	..s ^CacheTemp("DHCWMRXReceipt",JIndex,ctloc,UserRowid,"All")=UserAll+1
	..i (MainActive="Y")&(VolActive="Y") d
	...s ^CacheTemp("DHCWMRXReceipt",JIndex,ctloc,0,"Active")=ctlocActive+1
	...s ^CacheTemp("DHCWMRXReceipt",JIndex,ctloc,UserRowid,"Active")=UserActive+1
	
	q JIndex
}

}
