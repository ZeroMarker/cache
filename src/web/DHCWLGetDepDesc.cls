Class web.DHCWLGetDepDesc Extends %RegisteredObject
{

/// Creator?      czx
/// CreatDate?    2016-09
/// description:  取得科室明细
/// Table?         
/// Input?        
/// Output?       depId:科室id,depDesc:科室描述
/// d ##class(%ResultSet).RunQuery("web.DHCWLGetDepDesc","GeDepByCond") 
Query GeDepByCond() As %Query(ROWSPEC = "resDep:%String,depDesc:%String") [ SqlProc ]
{
}

ClassMethod GeDepByCondExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
    s depId=0,depDesc="全部" d BuildData11                 ;科室Id为0时，显示全部。
    s depId=0 f  s depId=$o(^CTLOC(depId)) q:depId=""  d
    .s depDesc=$$GetDepDesc^DHCWLCommon(depId)             ;获取科室描述
    .q:depDesc="Null"                                    
    .d BuildData11
	Quit $$$OK
BuildData11
	set Data=$listbuild(depId,depDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GeDepByCondClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GeDepByCondExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GeDepByCondFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GeDepByCondExecute ]
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

// d ##class(%ResultSet).RunQuery("web.DHCWLGetDepDesc","GeDepById","1")

Query GeDepById(id As %String) As %Query(ROWSPEC = "resDep:%String,depDesc:%String") [ SqlProc ]
{
}

ClassMethod GeDepByIdExecute(ByRef qHandle As %Binary, id As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
    //s depId=0,depDesc="全部" d BuildData12                 ;科室Id为0时，显示全部。
    s depId=0 f  s depId=$o(^CTLOC(depId)) q:depId=""  d
    .q:id'=depId
    .s depDesc=$$GetDepDesc^DHCWLCommon(depId)             ;获取科室描述
    .q:depDesc="Null"                                    
    .d BuildData12
    
    i id=0 s depDesc="全部" d BuildData12
	Quit $$$OK
BuildData12
	set Data=$listbuild(id,depDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GeDepByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GeDepByIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GeDepByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GeDepByIdExecute ]
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
