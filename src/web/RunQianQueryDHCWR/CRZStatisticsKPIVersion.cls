/// Creator：王峥
/// CreatDate： 2013-6-15
/// Description：出入转统计指标版类。
/// Table： 	
/// Input： 
/// Output： 
/// Return： 
/// Others： 无
Class web.RunQianQueryDHCWR.CRZStatisticsKPIVersion Extends %RegisteredObject
{

/// Creator：王峥
/// CreatDate： 2013-6-13
/// Description：统计所以科室数据。
/// Table： ct_loc	
/// Input： 
/// Output： LocID:科室ID,LocDesc:%科室描述
/// Return： 
/// Others： 无
/// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL.whet.wanvdsl","MRDynaDataDaily","2012-11-04")
/// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWR.CRZStatisticsKPIVersion","QueryLoc")
Query QueryLoc() As %Query(ROWSPEC = "locID:%String,locDesc:%String")
{
}

ClassMethod QueryLocExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^mtempDHCWL($j)
	
	s depID=0
	f  s depID=$o(^CTLOC(depID)) q:depID=""  d
	.q:$p($g(^CTLOC(depID)),"^",13)="W"
	.s depDesc=$p($g(^CTLOC(depID)),"^",2)
	.s depDesc=$$getdesc(depDesc)
    .s Data=$lb(depID,depDesc)
	.d OuputRow1
	k ^mtempDHCWL($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	;set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
getdesc(mLocDesc)
 s Locdep=""
 s len=$l(mLocDesc,"-")
 s Locdep=$P(mLocDesc,"-",len)
 q Locdep
}

ClassMethod QueryLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocExecute ]
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

/// Creator：王峥
/// CreatDate： 2013-6-13
/// Description：查询所有病区的ID和名称。
/// Table： 	pac_ward
/// Input： 
/// Output： wardID:病区ID,wardDesc：病区描述
/// Return： 
/// Others： 无
/// d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWL.whet.wanvdsl","QueryWard")
Query QueryWard() As %Query(ROWSPEC = "wardID:%String,wardDesc:%String")
{
}

ClassMethod QueryWardExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^mtempDHCWL($j)
	s wardID=0
	f  s wardID=$o(^PAWARD(wardID)) q:wardID=""  d
	.q:$p($g(^PAWARD(wardID)),"^",6)'="Y"
	.s wardDesc=$p($g(^PAWARD(wardID)),"^",2)
    .s Data=$lb(wardID,wardDesc)
	.d OuputRow2
	k ^mtempDHCWL($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow2
	;set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QueryWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWardExecute ]
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

}
