Import SQLUser

Class web.DHCRisRightSetDo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 234;

Query ctloclookup(desc As %String) As %Query(ROWSPEC = "ctloc:%String,ctlocid:%String")
{
}

ClassMethod ctloclookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s getdesc="   "
    s rowid=0 f  s rowid=$o(^CTLOC(0,"LocType","E",rowid)) q:rowid=""  d
    .s getdesc=$p(^CTLOC(rowid),"^",2)
    .i (getdesc[desc) d
    ..Do OutputRow4 
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	set Data=$lb(getdesc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ctloclookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ctloclookupExecute ]
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

ClassMethod ctloclookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ctloclookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QueryDoc(LocID As %String) As %Query(ROWSPEC = "tID:%String,tName:%String,tRight:%String,tLocID:%String")
{
}

ClassMethod QueryDocExecute(ByRef qHandle As %Binary, LocID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
 	
 	i LocID="" S qHandle=$lb(0,repid,0)
	Quit:LocID="" $$$OK

    s rr="",r1=""
   	Set repid=$I(^CacheTemp)
	i $g(^DHCRisGetNameSet)="" s ^DHCRisGetNameSet="ID"
	s ind=1
	s resrowid=0 f  s resrowid=$o(^RB("RES",0,"CTLOC",LocID,resrowid)) q:(resrowid="")  d
	.s ResInfo=^RB("RES",resrowid)
	.s CareProvrowid=$p(ResInfo,"^",2)
	.i CareProvrowid'=""  d
	..i ^DHCRisGetNameSet="ID" d
	...s CareProvDesc=$p(^CTPCP(CareProvrowid,1),"^",3)
	..else  d
	...s CareProvDesc=$p(^CTPCP(CareProvrowid,1),"^",2)
    ..s RightRowId=$o(^DHCPACRighti("CarePr",CareProvrowid,0))
	..i RightRowId'=""  d
	...s r1=$p(^DHCPACRight("RBRIGHT",0,RightRowId),"^",2)
	...i r1="1" s rr="浏览"
	...i r1="2" s rr="修改"
	...i r1="3" s rr="审核"
	...i r1="4" s rr="悔改"
 	..Do OutputRow5
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow5
	set Data=$lb(CareProvrowid,CareProvDesc,rr,LocID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	set rr="",r1=""
	quit
}

//Query ctloclookup(desc As %String) As %Query(ROWSPEC = "ctloc:%String,ctlocid:%String")

ClassMethod QueryDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDocExecute ]
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

ClassMethod QueryDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod UpdateRight(Info)
{
	
	s DocID=$p(Info,"^",1)
	s DocRight=$p(Info,"^",2)
	s LocID=$p(Info,"^",3)
	s sFlag=$p(Info,"^",4)
	;s ^TtEMPWYK(0)=Info
	;w Info
	i DocID="" Quit $$$OK
	;w Info
	i DocRight'="5"  d
	.i sFlag=" "  d
	..&sql(insert into  SQLUser.DHCRB_Right (RBR_CTPCP_DR,RBR_RightValue,RBR_CTLOC_DR) values (:DocID,:DocRight,:LocID))
	.e  d
	..&sql(update SQLUser.DHCRB_Right set RBR_RightValue=:DocRight where RBR_CTPCP_DR=:DocID)
	e  d
	.i sFlag'=""  d
	..&sql(delete from  SQLUser.DHCRB_Right where RBR_CTPCP_DR=:DocID)
	Quit $$$OK
}

}
