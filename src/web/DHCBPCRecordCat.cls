Import SQLUSER

Class web.DHCBPCRecordCat Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPCRecordCat","FindBPCReCat")
Query FindBPCReCat() As %Query(ROWSPEC = "tRowId:%String,tBPCRCCode:%String,tBPCRCDesc:%String")
{
}

ClassMethod FindBPCReCatExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s tRowId=0
	f  s tRowId=$o(^DHCBPC("RecordCat",tRowId))  q:tRowId=""  d
	.s tBPCRCCode=$lg(^DHCBPC("RecordCat",tRowId),1)
	.s tBPCRCDesc=$lg(^DHCBPC("RecordCat",tRowId),2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(tRowId,tBPCRCCode,tBPCRCDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPCReCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPCReCatExecute ]
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

ClassMethod FindBPCReCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPCReCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(web.DHCBPCBedGroup).InsertBPCBedGroup("2","1","C","N")
/// 插入数据
ClassMethod InsertBPCRecordCat(Code As %String, Desc As %String)
{
	TSTART
	s PLIST(2)=Code
	s PLIST(3)=Desc
	&SQL(insert into DHC_BPC_RecordCat Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

/// 更新
ClassMethod UpdateBPCRecordCat(BPCRCRowid As %String, Code As %String, Desc As %String)
{
	q:(BPCRCRowid="") "" 
	k PLIST
	s PLIST(2)=Code
	s PLIST(3)=Desc
	&SQL(update DHC_BPC_RecordCat Values :PLIST() where BPCRC_RowId=:BPCRCRowid)
	Q SQLCODE
}

/// 删除
ClassMethod DeleteBPCRecordCat(BPCRCRowid As %String)
{
	i BPCRCRowid'="" d
	.&SQL(delete from DHC_BPC_RecordCat where BPCRC_RowId=:BPCRCRowid)
	q SQLCODE
}

Query GetRecordCatList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As Id,
	   BPCRC_Code As Code,
	   BPCRC_Desc As Description
	   FROM DHC_BPC_RecordCat
}

}
