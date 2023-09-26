Class web.DHCAcceptorQuery Extends %RegisteredObject
{

/// 查询收费员姓名的Query,返回姓名和rowid
Query Acceptor() As %Query(ROWSPEC = "AcceptorName:%String,rowid:%String")
{
}

ClassMethod AcceptorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AcceptorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod AcceptorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AcceptorExecute ]
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

/// Creator     :qzl
/// CreatDate   :2010-3-23
/// Function    :取得所有收费员姓名
ClassMethod AcceptorExecute(ByRef qHandle As %Binary) As %Status
{
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=0
   s index=0
   f  s index=$O(^SSU("SSUSR",index)) q:index=""  d
   .s AcceptorName=$p(^SSU("SSUSR",index),"^",2)
   .d OutputRow
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
    
OutputRow
	set Data=$lb(AcceptorName,index)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

}
