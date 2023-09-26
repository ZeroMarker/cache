Class web.DHCClinic.DHCANCAppDate Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2016-05-09
/// Description： 	获取特殊手术日
/// Table：        	DHC_ANC_AppDate
/// Input:			
/// Return：       	ResultSet
/// Debug:			d ##class(%ResultSet).RunQuery("web.DHCClinic.DHCANCAppDate","FindAppDate")
Query FindAppDate() As %Query(ROWSPEC = "RowId,AppDate,WeekDay,Status,StatusDesc") [ SqlProc ]
{
}

ClassMethod FindAppDateExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set appDateId=0
	for
	{
		set appDateId=$order(^DHCANC("AppDate",appDateId))
		quit:(appDateId="")
		set appDate=$list(^DHCANC("AppDate",appDateId),1)
		set weekIndex=$zd(appDate,10)
		set weekDay=$case(weekIndex,
						  0:"周日",
						  1:"周一",
						  2:"周二",
						  3:"周三",
						  4:"周四",
						  5:"周五",
						  6:"周六")
		set appDate=##class(web.DHCClinicCom).ConvertToDate(appDate,"")
	    set status=$list(^DHCANC("AppDate",appDateId),2)
	    set statusDesc=$case(status,
	    					 "":"",
	    					 "W":"工作日",
	    					 "H":"节假日")
	    do OutputRow	
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(appDateId,appDate,weekDay,status,statusDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindAppDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAppDateExecute ]
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

ClassMethod FindAppDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAppDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
