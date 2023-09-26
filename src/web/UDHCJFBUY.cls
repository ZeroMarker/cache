Class web.UDHCJFBUY Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod FindRcptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRcptExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRcptExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s rowid=""
	f  s rowid=$o(^DHCSFBUY(rowid)) q:rowid=""  d
	.s grdate=$p(^DHCSFBUY(rowid),"^",1)
	.s grtime=$p(^DHCSFBUY(rowid),"^",2)
	.i grdate'=""  s grdate=$zd(grdate,3)
	.i grtime'=""  s grtime=$zt(grtime,1)
	.s stno=$p(^DHCSFBUY(rowid),"^",3)
	.s endno=$p(^DHCSFBUY(rowid),"^",4)
	.s curno=$p(^DHCSFBUY(rowid),"^",8)
	.s useflag=$p(^DHCSFBUY(rowid),"^",9)
	.i useflag="1" s useflag="可用"
	.i useflag="3" s useflag="已用完"
	.i useflag="" s useflag="代用"
	.s gruser=$p(^DHCSFBUY(rowid),"^",10)
	.i gruser'="" s gruser=$p(^SSU("SSUSR",gruser),"^",2)
	.s title=$p(^DHCSFBUY(rowid),"^",11)
	.Do OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(grdate,grtime,stno,endno,curno,useflag,gruser,title)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindRcptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRcptExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindRcpt() As %Query(ROWSPEC = "Tgrdate:%String,Tgrtime:%String,Tstno:%String,Tendno:%String,Tcurno:%String,Tuseflag:%String,Tgruser:%String,Ttitle:%String")
{
}

Query FindUser() As %SQLQuery(CONTAINID = 1, ROWSPEC = "sssur_rowid:%Integer,sssur_name:%String")
{
SELECT SSUSR_RowId,SSUSR_Name FROM SQLUser.SS_User
}

}
