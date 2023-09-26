Import SQLUSER

Class web.DHCANCFloor Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

//执行查询功能，无入参

Query FindexeFloor() As %Query(ROWSPEC = "RowId:%String,ANCF_Code:%String,ANCF_Desc:%String")
{
}

ClassMethod FindexeFloorExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=0
	f  s RowId=$o(^DHCANC("Floor",RowId))  q:RowId=""  d
	.s TOPRCode=$p(^DHCANC("Floor",RowId),"^",1)
	.s TOPRDesc=$p(^DHCANC("Floor",RowId),"^",2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,TOPRCode,TOPRDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindexeFloorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindexeFloorExecute ]
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

ClassMethod FindexeFloorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindexeFloorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//判断楼层号是否重复

ClassMethod RepOperFloor(Code As %String)
{
	s OPRowid=0
	s flag="N"
	f  s OPRowid=$o(^DHCANC("Floor",OPRowid)) q:(OPRowid="")  d
	.s RCode=$p(^DHCANC("Floor",OPRowid),"^",1)

	.i (RCode=Code) s flag="Y"
	q flag
}

//插入数据

ClassMethod InsertOperFloor(Code As %String, Desc As %String)
{
	s OPRowid=0
	s flag="N"
	s i=0
	f  s OPRowid=$o(^DHCANC("Floor",OPRowid)) q:(OPRowid="")  d
	.s i=i+1
	TSTART
	s PLIST(2)=Code
	s PLIST(3)=Desc
	&SQL(insert into DHC_ANC_Floor Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

//更新数据

ClassMethod UpdateOperFloor(OPRRowid As %String, Code As %String, Desc As %String)
{
	i (OPRRowid'="")&&(Code'="")&&(Desc'="") d
	.k PLIST
	.//s $p(^DHCANC("OPRoom",OPRRowid),"^",1)=OPRCode
	.//s $p(^DHCANC("OPRoom",OPRRowid),"^",2)=OPRDesc
	.//s $p(^DHCANC("OPRoom",OPRRowid),"^",3)=LocId
	.s PLIST(2)=Code
	.s PLIST(3)=Desc
	.&SQL(update DHC_ANC_Floor Values :PLIST() where ANCF_RowId=:OPRRowid)
	Q 0
}

//删除数据

ClassMethod DeleteOperFloor(OPRRowid As %String)
{
	i OPRRowid'="" d
	.k ^DHCANC("Floor",OPRRowid)
	Q 0
}

}
