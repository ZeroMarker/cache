Import SQLUSER

Class web.DHCICUCViewSuperCat Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// 执行查询功能，无入参

Query FindexeSuperCat() As %Query(ROWSPEC = "tICUCVSCCode:%String,tICUCVSCDesc:%String,tICUCVSCRowId:%String") [ SqlProc ]
{
}

ClassMethod FindexeSuperCatExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s tICUCVSCRowId=0
	f  s tICUCVSCRowId=$o(^DHCICUC("VSCat",tICUCVSCRowId))  q:tICUCVSCRowId=""  d
	.s tICUCVSCCode=$p(^DHCICUC("VSCat",tICUCVSCRowId),"^",1)
	.s tICUCVSCDesc=$p(^DHCICUC("VSCat",tICUCVSCRowId),"^",2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(tICUCVSCCode,tICUCVSCDesc,tICUCVSCRowId)
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

ClassMethod RepOperSuperCat(icuCVSCCode As %String)
{
	s OPRowid=0
	s flag="N"
	f  s OPRowid=$o(^DHCICUC("VSCat",OPRowid)) q:(OPRowid="")  d
	.s RCode=$p(^DHCICUC("VSCat",OPRowid),"^",1)
	.i (RCode=icuCVSCCode) s flag="Y"
	q flag
}

// 插入数据

ClassMethod InsertOperSuperCat(Code As %String, Desc As %String)
{
	s OPRowid=0
	s flag="N"
	s i=0
	f  s OPRowid=$o(^DHCICUC("VSCat",OPRowid)) q:(OPRowid="")  d
	.s i=i+1
	TSTART
	s PLIST(2)=Code
	s PLIST(3)=Desc
	&SQL(insert into DHC_ICUC_ViewSuperCat Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

// 更新数据

ClassMethod RepSuperCat(icuCVSCCode As %String, rowId As %String)
{
	s OPRowid=0
	s flag="N"
	f  s OPRowid=$o(^DHCICUC("VSCat",OPRowid)) q:(OPRowid="")  d
	.s RCode=$p(^DHCICUC("VSCat",OPRowid),"^",1)
	.i (RCode=icuCVSCCode)&(OPRowid'=rowId) s flag="Y"
	q flag
}

ClassMethod UpdateOperSuperCat(OPRRowid As %String, Code As %String, Desc As %String)
{
	s flag="N"
	s flag=..RepSuperCat(Code,OPRRowid)
	q:(flag="Y") "代码重复"
	i (OPRRowid'="")&&(Code'="")&&(Desc'="") d
	.k PLIST
	.s PLIST(2)=Code
	.s PLIST(3)=Desc
	.&SQL(update DHC_ICUC_ViewSuperCat Values :PLIST() where ICUCVSC_RowId=:OPRRowid)
	Q SQLCODE
}

// 删除数据

ClassMethod DeleteOperSuperCat(OPRRowid As %String)
{
	i OPRRowid'="" d
	.&SQL(delete from DHC_ICUC_ViewSuperCat where ICUCVSC_RowId=:OPRRowid)
	q SQLCODE
}

Query GetViewSuperCatList() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT %ID As Id,
	   ICUCVSC_Code As Code,
	   ICUCVSC_Desc As Description From DHC_ICUC_ViewSuperCat
}

Storage Default
{
<Data name="DHCICUCViewSuperCatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCICUCViewSuperCatD</DataLocation>
<DefaultData>DHCICUCViewSuperCatDefaultData</DefaultData>
<IdLocation>^web.DHCICUCViewSuperCatD</IdLocation>
<IndexLocation>^web.DHCICUCViewSuperCatI</IndexLocation>
<StreamLocation>^web.DHCICUCViewSuperCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
