Import SQLUser

Class web.DHCWMRCircul.xWorkload Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

ClassMethod GetMainTempData(JIndex, MrType, ItemId, DateFrom, DateTo)
{
	n (JIndex,MrType, ItemId, DateFrom, DateTo)
	
	;^DHCWMRMAIN(0,"SDateStatus",{CurrDate},{Status_Dr},{DHC_WMR_Main.Rowid},"S",{ChildSub})
	s tmpDate=DateFrom-1
	f  s tmpDate=$o(^DHCWMRMAIN(0,"SDateStatus",tmpDate)) q:(tmpDate="")!(tmpDate>DateTo)  d
	.q:'$d(^DHCWMRMAIN(0,"SDateStatus",tmpDate,ItemId))
	.s MainId=0
	.f  s MainId=$o(^DHCWMRMAIN(0,"SDateStatus",tmpDate,ItemId,MainId)) q:MainId=""  d
	..s tmpMain=$g(^DHCWMRMAIN(MainId))
	..q:tmpMain=""
	..s xActive=$p(tmpMain,"^",6)
	..q:$p(tmpMain,"^",1)'=MrType
	..s SubId=$o(^DHCWMRMAIN(0,"SDateStatus",tmpDate,ItemId,MainId,"S",""),-1)
	..s UserId=$p($g(^DHCWMRMAIN(MainId,"S",SubId)),"^",2)
	..q:UserId=""
	..s CTLoc=$p($g(^SSU("SSUSR",UserId)),"^",4)
	..;Get CTLoc count
	..s CTLocAll=+$g(^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,0,"All"))
	..s CTLocActive=+$g(^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,0,"Active"))
	..;Get user count
	..s UserAll=+$g(^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,UserId,"All"))
	..s UserActive=+$g(^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,UserId,"Active"))
	..;Set count
	..s ^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,0,"All")=CTLocAll+1
	..s ^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,UserId,"All")=UserAll+1
	..s:xActive="Y" ^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,0,"Active")=CTLocActive+1
	..s:xActive="Y" ^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,UserId,"Active")=UserActive+1
	
	q JIndex
}

ClassMethod GetVolTempData(JIndex, MrType, ItemId, DateFrom, DateTo)
{
	n (JIndex,MrType, ItemId, DateFrom, DateTo)
		
	;^DHCWMRVOL(0,"VSDateStatus",{CurrDate},{Status_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
	s tmpDate=DateFrom-1
	f  s tmpDate=$o(^DHCWMRVOL(0,"VSDateStatus",tmpDate)) q:(tmpDate="")!(tmpDate>DateTo)  d
	.q:'$d(^DHCWMRVOL(0,"VSDateStatus",tmpDate,ItemId))
	.s VolId=0
	.f  s VolId=$o(^DHCWMRVOL(0,"VSDateStatus",tmpDate,ItemId,VolId)) q:VolId=""  d
	..s tmpVol=$g(^DHCWMRVOL(VolId))
	..q:tmpVol=""
	..s xActive=$p(tmpVol,"^",7)
	..s SubId=""
	..f  s SubId=$o(^DHCWMRVOL(0,"VSDateStatus",tmpDate,ItemId,VolId,SubId),-1) q:SubId=""  d
	...s UserId=$p($g(^DHCWMRVOL(VolId,"S",SubId)),"^",2)
	...q:UserId=""
	...s CTLoc=$p($g(^SSU("SSUSR",UserId)),"^",4)
	...s MainId=$p(tmpVol,"^",1)
	...s tmpMain=$g(^DHCWMRMAIN(+MainId))
	...q:$p(tmpMain,"^",1)'=MrType
	...;Get CTLoc count
	...s CTLocAll=+$g(^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,0,"All"))
	...s CTLocActive=+$g(^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,0,"Active"))
	...;Get user count
	...s UserAll=+$g(^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,UserId,"All"))
	...s UserActive=+$g(^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,UserId,"Active"))
	...;Set count
	...s ^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,0,"All")=CTLocAll+1
	...s ^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,UserId,"All")=UserAll+1
	...s:xActive="Y" ^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,0,"Active")=CTLocActive+1
	...s:xActive="Y" ^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,UserId,"Active")=UserActive+1
	
	q JIndex
}

ClassMethod QueryWorkloadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWorkloadExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryWorkloadExecute(ByRef qHandle As %Binary, MrType As %String, ItemId As %String, DateFrom As %String, DateTo As %String, QryType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:(MrType="")||(ItemId="")||(DateFrom="")||(DateTo="") $$$OK
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s DateFrom=+DateFrom
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	s DateTo=+DateTo
	
	s JIndex=$j
	k ^CacheTemp("DHCWMRXWorkload",JIndex)
	s:(QryType="")||(QryType="0") flg=..GetMainTempData(JIndex,MrType, ItemId, DateFrom,DateTo)
	s:(QryType="")||(QryType="1") flg=..GetVolTempData(JIndex,MrType, ItemId, DateFrom,DateTo)
	q:'$d(^CacheTemp("DHCWMRXWorkload",JIndex)) $$$OK
	
	s SumAll=0,SumActive=0
	s CTLoc=""
	f  s CTLoc=$o(^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc)) q:CTLoc=""  d
	.s LocDesc=$p($g(^CTLOC(+CTLoc)),"^",2)
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s UserId="",UserName=""
	.s CountAll=+$g(^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,0,"All"))
	.s CountActive=+$g(^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,0,"Active"))
	.s SumAll=SumAll+CountAll
	.s SumActive=SumActive+CountActive
	.d BuildData
	.s UserId=0
	.f  s UserId=$o(^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,UserId)) q:UserId=""  d
	..s LocDesc=""
	..s CountAll=+$g(^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,UserId,"All"))
	..s CountActive=+$g(^CacheTemp("DHCWMRXWorkload",JIndex,CTLoc,UserId,"Active"))
	..s UserName=$p($g(^SSU("SSUSR",UserId)),"^",2)
	..d BuildData
	i SumAll'=0 d
	.s CTLoc="",LocDesc="合计",UserId="",UserName=""
	.s CountAll=SumAll,CountActive=SumActive
	.d BuildData
	Quit $$$OK
BuildData
	s Data=$lb(CTLoc,LocDesc,UserId,UserName,CountAll,CountActive)
	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod QueryWorkloadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWorkloadExecute ]
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

/// *****************************************************
/// 说明       : 工作量统计
/// 参数       : 
/// MrType     : 病案类型 6-门诊  7-住院
/// ItemId     : 操作项ID
/// DateFrom   : 开始日期
/// DateTo     : 结束日期
/// xType      : 查询类型 “”-病案和卷  0-病案  1-卷
/// 调试       : d ##Class(%ResultSet).RunQuery("web.DHCWMRCircul.xWorkload","QueryWorkload","7","2","2009-04-05","2009-04-05","1")
/// ******************************************************
Query QueryWorkload(MrType As %String, ItemId As %String, DateFrom As %String, DateTo As %String, QryType As %String) As %Query(ROWSPEC = "CTLoc:%String,LocDesc:%String,UserId:%String,UserName:%String,CountAll:%String,CountActive:%String")
{
}

}
