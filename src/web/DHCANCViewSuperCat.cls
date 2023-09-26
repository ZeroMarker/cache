Import SQLUSER

Class web.DHCANCViewSuperCat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

// 执行查询功能，无入参

Query FindexeSuperCat() As %Query(ROWSPEC = "RowId:%String,TANCVSCCode:%String,TANCVSCDesc:%String")
{
}

ClassMethod FindexeSuperCatExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=0
	f  s RowId=$o(^DHCANC("VSCat",RowId))  q:RowId=""  d
	.s TANCVSCCode=$p(^DHCANC("VSCat",RowId),"^",1)
	.s TANCVSCDesc=$p(^DHCANC("VSCat",RowId),"^",2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,TANCVSCCode,TANCVSCDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindexeSuperCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindexeSuperCatExecute ]
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

ClassMethod FindexeSuperCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindexeSuperCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 判断是否重复

ClassMethod RepOperSuperCat(Code As %String)
{
	s OPRowid=0
	s flag="N"
	f  s OPRowid=$o(^DHCANC("VSCat",OPRowid)) q:(OPRowid="")  d
	.s RCode=$p(^DHCANC("VSCat",OPRowid),"^",1)

	.i (RCode=Code) s flag="Y"
	q flag
}

// 插入数据

ClassMethod InsertOperSuperCat(Code As %String, Desc As %String)
{
	s OPRowid=0
	s flag="N"
	s i=0
	f  s OPRowid=$o(^DHCANC("VSCat",OPRowid)) q:(OPRowid="")  d
	.s i=i+1
	TSTART
	s PLIST(2)=Code
	s PLIST(3)=Desc
	&SQL(insert into DHC_ANC_ViewSuperCat Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

// 更新数据

ClassMethod UpdateOperSuperCat(OPRRowid As %String, Code As %String, Desc As %String)
{
	i (OPRRowid'="")&&(Code'="")&&(Desc'="") d
	.k PLIST
	.//s $p(^DHCANC("OPRoom",OPRRowid),"^",1)=OPRCode
	.//s $p(^DHCANC("OPRoom",OPRRowid),"^",2)=OPRDesc
	.//s $p(^DHCANC("OPRoom",OPRRowid),"^",3)=LocId
	.s PLIST(2)=Code
	.s PLIST(3)=Desc
	.&SQL(update DHC_ANC_ViewSuperCat Values :PLIST() where ANCVSC_RowId=:OPRRowid)
	Q SQLCODE
}

// 删除数据

ClassMethod DeleteOperSuperCat(OPRRowid As %String)
{
	i OPRRowid'="" d
	.&SQL(delete from DHC_ANC_ViewSuperCat where ANCVSC_RowId=:OPRRowid)
	q SQLCODE
}

Query GetViewSuperCatList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As Id,
	   ancvsc_code As Code,
	   ancvsc_desc As Description From DHC_ANC_ViewSuperCat
}

}
