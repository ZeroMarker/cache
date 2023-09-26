Class web.DHCWLGetHosp Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 院长查询专用
/// Creator：xss
/// Desc:医院
/// CreateDate:2015-02-13
/// Table:CT_Hospital
/// Input:      
/// Output:医院id，医院描述，医院code   
/// d ##class(%ResultSet).RunQuery("web.DHCWLGetHosp","GetHospQuery") 
Query GetHospQuery() As %Query(ROWSPEC = "hospId:%Integer,hosCode:%String,hosDesc:%String") [ SqlProc ]
{
}

ClassMethod GetHospQueryExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	
	s hospId=0 f  s hospId=$o(^CT("HOSP",hospId)) q:hospId=""  d
	.s hosCode=$p($g(^CT("HOSP",hospId)),"^",1)
	.s hosDesc=$p($g(^CT("HOSP",hospId)),"^",2)
	.d OuputRow
	Quit $$$OK
	
OuputRow
	s Data=$lb(hospId,hosCode,hosDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetHospQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRecDepQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHospQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRecDepQueryExecute ]
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

/// /d ##class(web.DHCWLGetHosp).Test()
ClassMethod Test()
{
	d ##class(%ResultSet).RunQuery("web.DHCWLGetHosp","GetHospQuery")
}

}
