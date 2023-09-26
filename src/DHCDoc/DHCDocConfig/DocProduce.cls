Class DHCDoc.DHCDocConfig.DocProduce Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Insert(RowID As %String, ProduceCode As %String, ProduceDesc As %String, ProduceActive As %String, ProcduceShowCode As %String)
{
	q:((ProduceCode="")||(ProduceDesc="")) ""
	s count=0
	&sql(select count(RowID) into :count from SQLUser.DHCDocProduce where (DocProduceCode=:ProduceCode and RowID<>:RowID))
	Q:count'=0 "记录重复!"
	&sql(select count(RowID) into :count from SQLUser.DHCDocProduce where (DocProduceDesc=:ProduceDesc and RowID<>:RowID))
	Q:count'=0 "记录重复!"
	if (RowID=""){
		&SQL(insert into SQLUser.DHCDocProduce 
		(DocProduceCode,DocProduceDesc,DocProduceActive,DocProcduceShowCode
		) Values(:ProduceCode,:ProduceDesc,:ProduceActive,:ProcduceShowCode))
	}else{
		&SQL(Update SQLUser.DHCDocProduce set DocProduceCode=:ProduceCode,DocProduceDesc=:ProduceDesc, 
		DocProduceActive=:ProduceActive,DocProcduceShowCode=:ProcduceShowCode where RowID=:RowID)
		}
	s rtn=SQLCODE
	q rtn
}

ClassMethod Delect(RowID As %String)
{
	q:RowID="" ""
	&SQL(DELETE SQLUser.DHCDocProduce where RowID=:RowID)
	s rtn=SQLCODE
	q rtn
}

Query FindDocProduce() As %Query(ROWSPEC = "RowID:%String,ProcduceCode:%String,ProcduceDesc:%String,ProcduceActive:%String,ProcduceShowCode:%String")
{
}

ClassMethod FindDocProduceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDocProduceExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDocProduceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDocProduceExecute ]
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

ClassMethod FindDocProduceExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocProduce","FindDocProduce","")
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s RowID=0
	for{
		s RowID=$O(^DHCDocProduce(RowID))
		q:RowID=""
		s ProcduceCode=$P(^DHCDocProduce(RowID),"^",1)
		s ProcduceDesc=$P(^DHCDocProduce(RowID),"^",2)
		s ProcduceActive=$P(^DHCDocProduce(RowID),"^",3)
		s ProcduceShowCode=$P(^DHCDocProduce(RowID),"^",4)
		set Data=$lb(RowID,ProcduceCode,ProcduceDesc,ProcduceActive,ProcduceShowCode)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

}
