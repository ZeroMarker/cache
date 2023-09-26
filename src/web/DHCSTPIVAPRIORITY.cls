Import SQLUser

Class web.DHCSTPIVAPRIORITY Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetPriorityExecute(ByRef qHandle As %Binary, Locid As %String) As %Status
{
	//获取科室优先级
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//实现；
	q:Locid="" $$$OK 
	s rowid=0
    f  s rowid=$o(^OECPR(rowid)) q:rowid=""  d
    .s code=$p(^OECPR(rowid),"^",1)
    .s desc=$p(^OECPR(rowid),"^",2)
    .i $d(^PIVAO(0,"OECPR",Locid,rowid)) s set="Y"
    .e  s set=""
	.d OutPutRow
	Quit $$$OK
	
OutPutRow
	set Data=$lb(rowid,code,desc,set)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	q
}

ClassMethod GetPriorityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPriorityExecute ]
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

Query GetPriority(Locid As %String) As %Query(ROWSPEC = "Trowid:%String,Tcode:%String,Tdesc:%String,Tset:%String")
{
}

ClassMethod GetPriorityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPriorityExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAPRIORITY","GetGroupLoc","")
ClassMethod GetGroupLocExecute(ByRef qHandle As %Binary, Grpid As %String) As %Status
{
	//获取科室
	n (%session,Grpid,qHandle)
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//实现；
	i Grpid="" d
	.i $d(%session) s Grpid=$g(%session.Data("LOGON.GROUPID"))
	q:Grpid="" $$$OK 
	s rowid=0
    f  s rowid=$o(^SSU("SSGRP",Grpid,"ST",rowid)) q:rowid=""  d
    .s locdr=$p(^SSU("SSGRP",Grpid,"ST",rowid),"^",1)
    .q:'$d(^CTLOC(locdr))
    .s desc=$p(^CTLOC(locdr),"^",2)
	.d OutPutRow2
	Quit $$$OK
	
OutPutRow2
	set Data=$lb(desc,locdr)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	q
}

ClassMethod GetGroupLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupLocExecute ]
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

Query GetGroupLoc(Grpid As %String) As %Query(ROWSPEC = "Tdesc:%String,Trowid:%String")
{
}

ClassMethod GetGroupLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupLocExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod Update(rowid, locid, flag) As %String
{
 n (rowid, locid,flag)
 i flag=1 &sql(insert into  PIVA_Oecpr (PO_OECPR_Dr,PO_Ctloc_dr)values (:rowid,:locid))
 i flag=2 &sql(delete  from  PIVA_Oecpr where PO_OECPR_Dr=:rowid and PO_Ctloc_dr=:locid)
 q:SQLCODE'=0 -1
 q $p(%ROWID,$c(1))
 q
}

}
