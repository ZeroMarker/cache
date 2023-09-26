Import SQLUSER

/// D ##class(%ResultSet).RunQuery("web.DHCANCKnowledgeCat","FindexeKnowledgeCat")
/// 对知识库大类进行增删改操作lhw20100126
Class web.DHCANCKnowledgeCat Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindexeKnowledgeCat() As %Query(ROWSPEC = "ANCKC_RowId:%String,ANCKC_Code:%String,ANCKC_Desc:%String")
{
}

ClassMethod FindexeKnowledgeCatExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=0
	
	f  s RowId=$o(^DHCANC("KCat",RowId))  q:RowId=""  d
	.s TOPRCode=$p(^DHCANC("KCat",RowId),"^",1)
	.s TOPRDesc=$p(^DHCANC("KCat",RowId),"^",2)
	
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,TOPRCode,TOPRDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindexeKnowledgeCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindexeKnowledgeCatExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindexeKnowledgeCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindexeKnowledgeCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod RepOperKnowledgeCat(NANCKCCode As %String, NANCKCDesc As %String)
{
	s OPRowid=0
	s flag="N"
	f  s OPRowid=$o(^DHCANC("KCat",OPRowid)) q:(OPRowid="")  d
	.s RCode=$p(^DHCANC("KCat",OPRowid),"^",1)
	.s RDesc=$p(^DHCANC("KCat",OPRowid),"^",2)
	.i (RCode=NANCKCCode)!(RDesc=NANCKCDesc) s flag="Y"
	q flag
}

//插入数据

ClassMethod InsertOperKnowledgeCat(NANCKCCode As %String, NANCKCDesc As %String)
{
	TSTART
	K PLIST
	s PLIST(2)=NANCKCCode
	s PLIST(3)=NANCKCDesc
	&SQL(insert into DHC_ANC_KnowledgeCat Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

//更新数据

ClassMethod UpdateOperKnowledgeCat(NANCKCRowId As %String, NANCKCCode As %String, NANCKCDesc As %String)
{
	i (NANCKCRowId'="")&&(NANCKCCode'="")&&(NANCKCDesc'="") d
	.k PLIST
	.s PLIST(2)=NANCKCCode
	.s PLIST(3)=NANCKCDesc
	.&SQL(update DHC_ANC_KnowledgeCat Values :PLIST() where ANCKC_RowId=:NANCKCRowId)
	Q 0
}

//删除数据

ClassMethod DeleteOperKnowledgeCat(NANCKCRowId As %String)
{
	i NANCKCRowId'="" d
	.k ^DHCANC("KCat",NANCKCRowId)
	Q 0
}

Query FindKnowledgeCatTree(ksdesc As %String) As %Query(ROWSPEC = "ANCKC_RowId:%String,ANCKC_Code:%String,ANCKC_Desc:%String")
{
}

ClassMethod FindKnowledgeCatTreeExecute(ByRef qHandle As %Binary, ksdesc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=0
	
	f  s RowId=$o(^DHCANC("KCat",RowId))  q:RowId=""  d
	 . i $p(^DHCANC("KCat",RowId),"^",2)[ksdesc d
	..s TOPRCode=$p(^DHCANC("KCat",RowId),"^",1)
	..s TOPRDesc=$p(^DHCANC("KCat",RowId),"^",2)
	..d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,TOPRCode,TOPRDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindKnowledgeCatTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindKnowledgeCatTreeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindKnowledgeCatTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindKnowledgeCatTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
