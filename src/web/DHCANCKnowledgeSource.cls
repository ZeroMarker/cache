Import SQLUSER

/// 对知识库来源进行增删改操作lhw20100126
Class web.DHCANCKnowledgeSource Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

//执行查询功能，无入参

Query FindexeKnowledgeSource() As %Query(ROWSPEC = "ANCKS_RowId:%String,ANCKS_Code:%String,ANCKS_Desc:%String")
{
}

ClassMethod FindexeKnowledgeSourceExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=0
	f  s RowId=$o(^DHCANC("KSrc",RowId))  q:RowId=""  d
	.s TOPRCode=$p(^DHCANC("KSrc",RowId),"^",1)
	.s TOPRDesc=$p(^DHCANC("KSrc",RowId),"^",2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,TOPRCode,TOPRDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindexeKnowledgeSourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindexeKnowledgeSourceExecute ]
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

ClassMethod FindexeKnowledgeSourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindexeKnowledgeSourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//判断来源编号是否重复

ClassMethod RepOperKnowledgeSource(NANCKSCode As %String, NANCKSDesc As %String)
{
	s ANCKSRowId=0
	s flag="N"
	f  s ANCKSRowId=$o(^DHCANC("KSrc",ANCKSRowId)) q:(ANCKSRowId="")  d
	.s RCode=$p(^DHCANC("KSrc",ANCKSRowId),"^",1)
	.s RNANCKSDesc=$p(^DHCANC("KSrc",ANCKSRowId),"^",2)
	.i (RCode=NANCKSCode)!(RNANCKSDesc=NANCKSDesc) s flag="Y"
	q flag
}

//插入数据

ClassMethod InsertOperKnowledgeSource(NANCKSCode As %String, NANCKSDesc As %String)
{
	TSTART
	s PLIST(2)=NANCKSCode
	s PLIST(3)=NANCKSDesc
	&SQL(insert into DHC_ANC_KnowledgeSource Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

//更新数据

ClassMethod UpdateOperKnowledgeSource(NANCKSRowid As %String, NANCKSCode As %String, NANCKSDesc As %String)
{
	i (NANCKSRowid'="")&&(NANCKSCode'="")&&(NANCKSDesc'="") d
	.k PLIST
	.s PLIST(2)=NANCKSCode
	.s PLIST(3)=NANCKSDesc
	.&SQL(update DHC_ANC_KnowledgeSource Values :PLIST() where ANCKS_RowId=:NANCKSRowid)
	Q 0
}

//删除数据

ClassMethod DeleteOperKnowledgeSource(NANCKSRowid As %String)
{
	i NANCKSRowid'="" d
	.k ^DHCANC("KSrc",NANCKSRowid)
	Q 0
}

ClassMethod FindSourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindSourceExecute(ByRef qHandle As %Binary, NANCKSCode As %String, NANCKSDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=0
	f  s RowId=$o(^DHCANC("KSrc",RowId))  q:RowId=""  d
	
	.I ($p(^DHCANC("KSrc",RowId),"^",2)[NANCKSDesc)!($p(^DHCANC("KSrc",RowId),"^",1)[NANCKSCode) d
	..s TOPRCode=$p(^DHCANC("KSrc",RowId),"^",1)
	..s TOPRDesc=$p(^DHCANC("KSrc",RowId),"^",2)
	..d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,TOPRCode,TOPRDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindSourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSourceExecute ]
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

Query FindSource(NANCKSCode As %String, NANCKSDesc As %String) As %Query(ROWSPEC = "ANCKS_RowId:%String,ANCKS_Code:%String,ANCKS_Desc:%String")
{
}

ClassMethod FindSourceDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSourceDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindSourceDescExecute(ByRef qHandle As %Binary, NANCKSCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=0
	f  s RowId=$o(^DHCANC("KSrc","0",NANCKSCode,RowId))  q:RowId=""  d
	.s TOPRDesc=$p(^DHCANC("KSrc",RowId),"^",2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(TOPRDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindSourceDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSourceDescExecute ]
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

Query FindSourceDesc(NANCKSCode As %String) As %Query(ROWSPEC = "ANCKS_Code:%String")
{
}

ClassMethod FindSourceCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSourceCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindSourceCodeExecute(ByRef qHandle As %Binary, NANCKSDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=0
	f  s RowId=$o(^DHCANC("KSrc",RowId))  q:RowId=""  d
	.i $p(^DHCANC("KSrc",RowId),"^",2)=NANCKSDesc d
	..d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindSourceCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSourceCodeExecute ]
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

Query FindSourceCode(NANCKSDesc As %String) As %Query(ROWSPEC = "ANCKS_Code:%String")
{
}

//D ##class(%ResultSet).RunQuery("web.DHCANCKnowledgeSource","FindSourceCode","a")

}
