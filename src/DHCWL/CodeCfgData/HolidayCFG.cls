/// 节假日维护
Class DHCWL.CodeCfgData.HolidayCFG Extends %RegisteredObject
{

/// 根据时间段取得时间列表，并标示段内的周六日
/// d ##class(%ResultSet).RunQuery("DHCWL.CodeCfgData.HolidayCFG","HolidayQuery","2014-1-1","2014-10-1")
Query HolidayQuery(Sday As %String, Eday As %String) As %Query(ROWSPEC = "UnChoice:%String,DateType:%String,Weekflag:%String") [ SqlProc ]
{
}

ClassMethod HolidayQueryExecute(ByRef qHandle As %Binary, Sday As %String, Eday As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	//s Sday=$zdh(Sday,3),Eday=$zdh(Eday,3)
 	s Sday=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(Sday)
 	s Eday=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(Eday)
 	f UnChoice=Sday:1:Eday d
 	.s week=$zd(UnChoice,10)    ;星期标志,6、0为周六周日 
    .i (week=6)!(week=0) s Weekflag=1
    .e  s Weekflag=0
 	.//i $d(^DHCWL.CodeCfg.HolidayI("Holiday",UnChoice)) s weekflag=0
 	.q:$d(^DHCWL.CodeCfg.HolidayI("Holiday",UnChoice))
 	.s flag=$o(^DHCWL.CodeCfg.HolidayI("Holiday",UnChoice,""))
 	.i $tr(flag," ")=1 s DateType="节日"
 	.i $tr(flag," ")=2 s DateType="假日"
 	.i flag="" s DateType=""
 	.s newUnChoice=##class(DHCWL.CommonUtil.DateUtil).DateLogicalToHtml(UnChoice)
	.s ^CacheTemp(repid,ind)=$lb(newUnChoice,DateType,Weekflag)
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod HolidayQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HolidayQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod HolidayQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HolidayQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 根据时间段取得已选时间列表，并标示时段
/// d ##class(%ResultSet).RunQuery("DHCWL.CodeCfgData.HolidayCFG","ChHolidayQuery","2014-1-1","2014-10-1","1")
Query ChHolidayQuery(Sday As %String, Eday As %String) As %Query(ROWSPEC = "ChoiceDay:%String,AmOrPm:%String,id:%Integer") [ SqlProc ]
{
}

ClassMethod ChHolidayQueryExecute(ByRef qHandle As %Binary, Sday As %String, Eday As %String, HolidayFlag As %Integer) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	//s Sday=$zdh(Sday,3),Eday=$zdh(Eday,3)
 	s Sday=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(Sday)
 	s Eday=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(Eday)
 	f ChoiceDay=Sday:1:Eday d
 	.i $d(^DHCWL.CodeCfg.HolidayI("HolidayType"," "_HolidayFlag,ChoiceDay)) d
 	..s AmPm=$tr($o(^DHCWL.CodeCfg.HolidayI("HolidayType"," "_HolidayFlag,ChoiceDay,""))," ")
 	..s AmOrPm=""
 	..i AmPm=""  s AmOrPm="全天"
 	..e  d
 	...f len=1:1:$l(AmPm,",")   d
 	....s AP=$p(AmPm,",",len)
 	....i $g(AmOrPm)="" s AmOrPm=$p(^DHCTimeRange(AP),"^",2)
 	....e  s AmOrPm=AmOrPm_","_$p(^DHCTimeRange(AP),"^",2)
 	..s id=$o(^DHCWL.CodeCfg.HolidayI("HolidayType"," "_HolidayFlag,ChoiceDay," "_AmPm,""))
 	..s newChoiceDay=##class(DHCWL.CommonUtil.DateUtil).DateLogicalToHtml(ChoiceDay)
 	..s ^CacheTemp(repid,ind)=$lb(newChoiceDay,AmOrPm,id)
	..s ind=ind+1
	
	Quit $$$OK
}

ClassMethod ChHolidayQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ChHolidayQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod ChHolidayQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ChHolidayQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

Storage Default
{
<Data name="HolidayCFGDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCWL.CodeCfgData.HolidayCFGD</DataLocation>
<DefaultData>HolidayCFGDefaultData</DefaultData>
<IdLocation>^DHCWL.CodeCfgData.HolidayCFGD</IdLocation>
<IndexLocation>^DHCWL.CodeCfgData.HolidayCFGI</IndexLocation>
<StreamLocation>^DHCWL.CodeCfgData.HolidayCFGS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
