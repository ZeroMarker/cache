/// 名称: DHCWL.MKPIService.YZCXQueryArg
/// 描述: 院长查询
/// 编写者：lxc
/// 编写日期:2012-07-30
/// 
Class DHCWL.MKPIService.YZCXQueryArg Extends %RegisteredObject [ Not ProcedureBlock ]
{

//区间选择查询

//d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.YZCXQueryArg","GetKPIMonth","2,5")	

ClassMethod GetKPIMonthExecute(ByRef qHandle As %Binary, type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    s sectionId=""
    f  s sectionId=$o(^DHCWL.MKPI.SectionD(sectionId)) q:sectionId=""  d
    .q:$F(","_type_",",","_sectionId_",")=0  
    .s secName=$LIST(^DHCWL.MKPI.SectionD(sectionId),4)
    .s monthId=""
    .f  s monthId=$o(^DHCWL.MKPI.MonthsI("SectionFlag",sectionId,monthId)) q:monthId=""  d
    ..s monDesc=$LIST(^DHCWL.MKPI.MonthsD(monthId),3)
	..d OutputRow1
 	q $$$OK	
OutputRow1
    s fl=$E(monDesc,1,4)
    s Data=$lb(fl,sectionId,secName,monthId,monDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetKPIMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKPIMonthExecute ]
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

ClassMethod GetKPIMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKPIMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetKPIMonth(type As %String) As %Query(ROWSPEC = "fl:%String,sectionId:%Integer,secName:%String,monthId:%Integer,monDesc:%String") [ SqlProc ]
{
}

//指标选择查询

//d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.YZCXQueryArg","GetKPI")	

ClassMethod GetKPIExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    s mkpiId=""
    f  s mkpiId=$o(^DHCWL.MKPI.MKPIFLD(mkpiId)) q:mkpiId=""  d
    .s mkpiName=$LIST(^DHCWL.MKPI.MKPIFLD(mkpiId),3)
    .s kpiId=""
    .f  s kpiId=$o(^DHCWL.MKPI.MKPII("MKPICate",mkpiId,kpiId)) q:kpiId=""  d
    ..s kpiDesc=$LIST(^DHCWL.MKPI.MKPID(kpiId),3)
	..d OutputRow2
 	q $$$OK	
OutputRow2
    s Data=$lb(mkpiId,mkpiName,kpiId,kpiDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetKPIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKPIExecute ]
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

ClassMethod GetKPIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKPIExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetKPI() As %Query(ROWSPEC = "mkpiId:%Integer,mkpiName:%String,kpiId:%Integer,kpiDesc:%String") [ SqlProc ]
{
}

}
