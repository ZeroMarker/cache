Class web.DHCAPPCellItemLinkSet Extends %RegisteredObject
{

Query FindItem(ItemID, HospID As %String) As %Query(ROWSPEC = "RowID:%String,Desc:%String")
{
}

ClassMethod FindItemExecute(ByRef qHandle As %Binary, ItemID, HospID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCAPPCellItemLinkSet","FindItem","13")
	Set repid=$I(^CacheTemp)
    Set ind=1
	s ID="0"
	F  s ID=$o(^DHCAPPPDI(0,"Type",ItemID,ID)) Q:ID=""  D
	.s Code=$p(^DHCAPPPDI(ID),"^",1)    //代码
	.s Desc=$p(^DHCAPPPDI(ID),"^",2)    //描述
	.s ActCode=$p(^DHCAPPPDI(ID),"^",3) //可用标志
	.q:ActCode="N"
	.s HospDr=$p(^DHCAPPPDI(ID),"^",4)  //医院
	.q:HospID'=HospDr
	.s HospDesc=""
	.s:HospDr'="" HospDesc=$p(^CT("HOSP",HospDr),"^",2)
	.s mID=$p(^DHCAPPPDI(ID),"^",5)    //类型ID
	.Do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb($g(ID),$g(Desc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindItemExecute ]
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

ClassMethod Insert(ItemMast As %String, ItemRowID As %String, RowID As %String = "", HospDr As %String = "")
{
	q:((ItemMast="")||(ItemRowID="")) ""
	s ^tempqujian("InsertBLType")=ItemMast_","_ItemRowID_","_RowID_","_HospDr
	if (RowID=""){
		&sql(select * from SQLUser.DHC_APPCellItemLink where APP_CellMastItem=:ItemMast and APP_CellItem=:ItemRowID and APP_HospDr=:HospDr)
		Q:SQLCODE'=100 "-1"
		&SQL(insert into SQLUser.DHC_APPCellItemLink 
		(APP_CellMastItem,APP_CellItem,APP_HospDr
		) Values(:ItemMast,:ItemRowID,:HospDr))
	}else{
		&sql(select * from SQLUser.DHC_APPCellItemLink where APP_CellMastItem=:ItemMast and APP_CellItem=:ItemRowID and APP_HospDr=:HospDr and RowID<>:RowID)
		Q:SQLCODE'=100 "-1"
		
		&SQL(Update SQLUser.DHC_APPCellItemLink set APP_CellMastItem=:ItemMast,APP_CellItem=:ItemRowID,APP_HospDr=:HospDr
		 where RowID=:RowID)
	}
	s rtn=SQLCODE
	q rtn
}

ClassMethod Delect(RowID As %String)
{
	q:RowID="" ""
	&SQL(DELETE SQLUser.DHC_APPCellItemLink where RowID=:RowID)
	s rtn=SQLCODE
	q rtn
}

Query FindMastItem(ItemID, HospDr) As %Query(ROWSPEC = "ItemRowID:%String,DescRowID:%String ,Desc:%String")
{
}

ClassMethod FindMastItemExecute(ByRef qHandle As %Binary, ItemID, HospDr) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCAPPCellItemLinkSet","FindMastItem","64")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ItemRowID=""
    for {
	    s ItemRowID=$O(^DHCAPPCellItemLinki("Mast",ItemID,ItemRowID))
	    q:ItemRowID=""
	    continue:'$d(^DHCAPPCellItemLink(ItemRowID))
	    s DescRowID=$P(^DHCAPPCellItemLink(ItemRowID),"^",2)
	    s HospID=$P(^DHCAPPCellItemLink(ItemRowID),"^",3)
	    continue:((HospDr'="")&&(HospDr'=HospID))
		continue:($g(^DHCAPPPDI(DescRowID))="")
	    s Desc=$p(^DHCAPPPDI(DescRowID),"^",2)    //描述
		s ActCode=$p(^DHCAPPPDI(DescRowID),"^",3) //可用标志
		continue:ActCode="N"
		d OutPutFindMast
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutFindMast
	set Data=$lb($g(ItemRowID),DescRowID,$g(Desc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindMastItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMastItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindMastItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindItemExecute ]
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

}
