Import SQLUSER

Class web.DHCANCOPLevel Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindOPLevel() As %Query(ROWSPEC = "RowId:%String,ANCOPL_Code:%String,ANCOPL_Desc:%String")
{
}

ClassMethod FindOPLevelExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=0
	f  s RowId=$O(^DHCANC("OPLevel",RowId))  q:RowId=""  d
	.s ANCOPLCode=$P(^DHCANC("OPLevel",RowId),"^",1)
	.s ANCOPLDesc=$P(^DHCANC("OPLevel",RowId),"^",2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,ANCOPLCode,ANCOPLDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOPLevelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOPLevelExecute ]
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

ClassMethod FindOPLevelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOPLevelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod InsertANCOPLevel(Code As %String, Desc As %String)
{
	q:(Code="")||(Desc="") 0
	&SQL(insert into DHC_ANC_OPLevel (ANCOPL_Code,ANCOPL_Desc) Values (:Code,:Desc))
	q SQLCODE
}

ClassMethod UpdateANCOPLevel(ANOPLRowId As %String, Code As %String, Desc As %String)
{
	q:(ANOPLRowId="")||(Code="")||(Desc="") 0
	&SQL(update DHC_ANC_OPLevel set ANCOPL_Code=:Code,ANCOPL_Desc=:Desc where ANCOPL_RowId=:ANOPLRowId)
	q SQLCODE
}

ClassMethod DeleteANCOPLevel(ANOPLRowId As %String)
{
	q:ANOPLRowId="" 0
	&SQL(Delete from DHC_ANC_OPLevel where ANCOPL_RowId=:ANOPLRowId)
	q SQLCODE
}

}
