Import SQLUSER

/// D ##class(%ResultSet).RunQuery("web.DHCANCKnowledgeSubCat","FindexeKnowledgeSubCat")
/// 对知识库子类类进行增删改操作lhw20100126
Class web.DHCANCKnowledgeSubCat Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindexeKnowledgeSubCat() As %Query(ROWSPEC = "ANCKC_RowId:%String,ANCKC_Code:%String,ANCKC_Desc:%String,ANCKSC_ANCKC_DR:%String")
{
}

ClassMethod FindexeKnowledgeSubCatExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=0
	f  s RowId=$o(^DHCANC("KSCat",RowId))  q:RowId=""  d
	.s TOPRCode=$p(^DHCANC("KSCat",RowId),"^",1)
	.s TOPRDesc=$p(^DHCANC("KSCat",RowId),"^",2)
	.S TOPDR=$p(^DHCANC("KSCat",RowId),"^",3)
	.q:TOPDR=""
	.S TOPANCKCDR=$p($G(^DHCANC("KCat",TOPDR)),"^",2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,TOPRCode,TOPRDesc,TOPANCKCDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindexeKnowledgeSubCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindexeKnowledgeSubCatExecute ]
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

ClassMethod FindexeKnowledgeSubCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindexeKnowledgeSubCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod RepOperKnowledgeSubCat(NANCKCCode As %String, NANCKCDesc As %String, NANCKSCANCKCDR As %String)
{
	s OPRowid=0
	s flag="N"
	f  s OPRowid=$o(^DHCANC("KSCat",OPRowid)) q:(OPRowid="")  d
	.s RCode=$p(^DHCANC("KSCat",OPRowid),"^",1)
	.S RDesc =$p(^DHCANC("KSCat",OPRowid),"^",2)
	.s RNANCKSCANCKCDR=$p(^DHCANC("KSCat",OPRowid),"^",3)
	.i (RCode=NANCKCCode && RNANCKSCANCKCDR=NANCKSCANCKCDR)!(RDesc=NANCKCDesc && RNANCKSCANCKCDR=NANCKSCANCKCDR) s flag="Y"
	q flag
}

//插入数据

ClassMethod InsertOperKnowledgeSubCat(NANCKCCode As %String, NANCKCDesc As %String, NTOPANCKCDR As %String)
{
	
	TSTART
	s PLIST(2)=NANCKCCode
	s PLIST(3)=NANCKCDesc
	s PLIST(4)=NTOPANCKCDR	;大类代码
	&SQL(insert into DHC_ANC_KnowledgeSubCat Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

//更新数据

ClassMethod UpdateOperKnowledgeSubCat(NANCKCRowid As %String, NANCKCCode As %String, NANCKCDesc As %String, NANCKSCANCKCDR As %String)
{
	i (NANCKCRowid'="")&&(NANCKCCode'="")&&(NANCKCDesc'="") d
	.k PLIST
	.s PLIST(2)=NANCKCCode
	.s PLIST(3)=NANCKCDesc
	.s PLIST(4)=NANCKSCANCKCDR
	.&SQL(update DHC_ANC_KnowledgeSubCat Values :PLIST() where ANCKSC_Code=:NANCKCRowid)
	Q 0
}

//删除数据

ClassMethod DeleteOperKnowledgeSubCat(NANCKCRowid As %String)
{
	i NANCKCRowid'="" d
	.k ^DHCANC("KSCat",NANCKCRowid)
	Q 0
}

//

Query DHCANCKnowledgeCatlookup(desc As %String) As %Query(ROWSPEC = "ANCKCDesc:%String,ANCKCRowId:%String")
{
}

ClassMethod DHCANCKnowledgeCatlookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0
	i $g(desc)=""  d
	.s desc="%"
	e  d
	.s desc=$$ALPHAUP^SSUTIL4(desc)
	.s desc=desc_"%"
	&sql(declare DHCANCKnowledgeCat cursor  for 
	select distinct ANCKC_Desc,ANCKC_RowId
	              from SQLUser.DHC_ANC_KnowledgeCat
	              WHERE (UPPER(ANCKC_Desc) like :desc))
	&sql(open DHCANCKnowledgeCat)
	f  &sql(fetch DHCANCKnowledgeCat into :ANCKCDesc,:ANCKCRowId) q:SQLCODE  d
 	.Do OutputRow4	 	
 	&sql(close DHCANCKnowledgeCat)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	set Data=$lb(ANCKCDesc,ANCKCRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCANCKnowledgeCatlookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCANCKnowledgeCatlookupExecute ]
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

ClassMethod DHCANCKnowledgeCatlookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCANCKnowledgeCatlookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindexeQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindexeQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindexeQueryExecute(ByRef qHandle As %Binary, ANCKCDRref As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    s RowId=0
	f  s RowId=$o(^DHCANC("KSCat",RowId)) q:RowId=""  d
	.S TOPANCKCDRref=$p($g(^DHCANC("KSCat",RowId)),"^",3)
	.i TOPANCKCDRref=ANCKCDRref d
	..s TOPRCode=$p($g(^DHCANC("KSCat",RowId)),"^",1)
	..s TOPRDesc=$p($g(^DHCANC("KSCat",RowId)),"^",2)
	..S TOPANCKCDR=$p($g(^DHCANC("KCat",$p($g(^DHCANC("KSCat",RowId)),"^",3))),"^",2)
	..d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,TOPRCode,TOPRDesc,TOPANCKCDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindexeQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindexeQueryExecute ]
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

Query FindexeQuery(ANCKCDRref As %String) As %Query(ROWSPEC = "ANCKC_RowId:%String,ANCKC_Code:%String,ANCKC_Desc:%String,ANCKSC_ANCKC_DR:%String")
{
}

//D ##class(%ResultSet).RunQuery("web.DHCANCKnowledgeSubCat","FindexeQuery",2)

///    D ##class(%ResultSet).RunQuery("web.DHCANCKnowledgeSubCat","FindexeQuery",89)

}
