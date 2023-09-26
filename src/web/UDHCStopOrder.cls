/// web.UDHCStopOrder
/// by xin used to stop orders
Class web.UDHCStopOrder Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetLocDescByID(LocID As %Library.String, Locdesc)
{
	n (LocID,Locdesc)
	q:$g(Locdesc)'="" Locdesc
	q:'$d(^CTLOC(LocID)) ""
	q $p($g(^CTLOC(LocID)),"^",2)
}

ClassMethod GetSession(Name As %Library.String)
{
	q %session.Get(Name)
}

ClassMethod GetordersClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetordersExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetordersExecute(ByRef qHandle As %Binary, EpisodeID As %String, OrdDesc As %String, CurDataFlag As %String, Lflag As %String, Sflag As %String, User As %String, lulocdes, QueryStartDate As %String = "", QueryEndDate As %String = "", AllowStopOtherLoc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)  ;这个是大家公用的?
	Set qHandle=$lb(0,repid,0)
	s ind=1
	s lulocdes=##class(web.DHCDocUtil).UnEscape(lulocdes)
	s tmpid=##class(web.UDHCStopOrderLook).GetAdmOrderC(EpisodeID,OrdDesc,CurDataFlag,Lflag,Sflag,User,lulocdes,QueryStartDate,QueryEndDate,AllowStopOtherLoc)
	i tmpid<0 Quit $$$OK
	s j=0 f   s j=$o(^mPLIST(tmpid,j)) q:j=""  d
	.s ^CacheTemp(repid,ind)=^mPLIST(tmpid,j)
	.S ind=ind+1
	k ^mPLIST(tmpid)
	Quit $$$OK
}

ClassMethod GetordersFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetordersExecute ]
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

ClassMethod SetSession(Name As %Library.String, Value As %Library.String)
{
	s %session.Data(Name)=Value
}

ClassMethod orderlookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = orderlookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod orderlookupExecute(ByRef qHandle As %Binary, desc As %String, EpisodeID As %String) As %Status
{
 Set repid=$I(^CacheTemp)

 If $g(ind)="" Set ind=1
	s rowid=0
	i $g(desc)=""  d
	.i $g(EpisodeID)'=""  d
	..s ORD=$o(^OEORD(0,"Adm",EpisodeID,"0"))
	..s Arci="0"
	..f  s Arci=$o(^OEORDi(0,"ARCIM",ORD,Arci))   q:Arci=""   d
	...q:(Arci="")||('$d(^ARCIM(+Arci,$p(Arci,"||",2)))) 
	...s orderrowid=Arci
	...s orderdesc=$p($g(^ARCIM(+Arci,$p(Arci,"||",2),1)),"^",2)
	...d OutputRow3
	.e  s desc="%"
	e  d
	.s desc=$$ALPHAUP^SSUTIL4(desc)
	.s desc=desc_"%"
	
	i $g(desc)'=""  d
	.&sql(declare orderc cursor  for 
	select distinct alias_arcim_dr,alias_arcim_dr->arcim_desc
	              from SQLUser.arc_ALIAS 
	              WHERE (UPPER(ALIAS_text) like :desc))
	.&sql(open orderc)
	.f  &sql(fetch orderc into :orderrowid,:orderdesc) q:SQLCODE  d
	..q:orderdesc=""
 ..Do OutputRow3 	 	
 .&sql(close orderc)

 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	s orderdesc=$p($g(^ARCIM(+orderrowid,$p(orderrowid,"||",2),1)),"^",2)
	set Data=$lb(orderdesc,orderrowid)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod orderlookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = orderlookupExecute ]
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

Query Getorders(EpisodeID As %String, OrdDesc As %String, CurDataFlag As %String, Lflag As %String, Sflag As %String, User As %String, lulocdes As %String = "", QueryStartDate As %String = "", QueryEndDate As %String = "", AllowStopOtherLoc As %String = "") As %Query(ROWSPEC = "seqno:%String,arcdesc:%String,ordtype:%String,oeflag:%String,date:%String,status:%String,qty:%String,reploc:%String,presc:%String,dosage:%String,freq:%String,inst:%String,ordch:%String,sttd:%String,xuserid:%String,xusername:%String,ordlink:%String,usemethod:%String,docloc:%String,exflag:%String,EndDate:%String,EndTime:%String,AddDoc:%String,LabSpec:%String,NurseExecStatus:%String,FirstSttdate:%String,FirstStttime:%String,Notes:%String")
{
}

Query orderlookup(desc As %String, EpisodeID As %String) As %Query(ROWSPEC = "order:%String,orderid:%String")
{
}

}
