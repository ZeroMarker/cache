Import SQLUser

Class web.DHCSTPIVALOCGROUP Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Insert(LocDesc) As %String
{
	 n (LocDesc)
	 q:LocDesc="" -1
	 k PLIST
	 s PLIST(2)=LocDesc
	 &sql(insert into  PIVA_LocGrp values PLIST())
	 q:SQLCODE'=0 -2
	 q $p(%ROWID,$c(1))
}

ClassMethod Update(Trowid, LocDesc) As %String
{
	 n (Trowid,LocDesc)
	 &sql(update PIVA_LocGrp set PLG_Desc=:LocDesc where  PLG_Rowid=:Trowid)
	 q:SQLCODE'=0 -1
	 q $p(%ROWID,$c(1))
}

ClassMethod Delete(Trowid) As %String
{
	 n (Trowid)
	 &sql(delete from  PIVA_LocGrp where PLG_Rowid=:Trowid)
	 q:SQLCODE'=0 -1
	 q $p(%ROWID,$c(1))
}

ClassMethod GetLocGrpExecute(ByRef qHandle As %Binary, LocDesc) As %Status
{

    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    ;
    s plg="0"
    f  s plg=$o(^PLGR(plg)) q:plg=""  d
    .s desc=$p(^PLGR(plg),"^",1)
    .q:(desc'=LocDesc)&(LocDesc'="")
    .d OutRowLocGrp
	Quit $$$OK
OutRowLocGrp
	set Data=$lb(desc,plg)   
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetLocGrpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocGrpExecute ]
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

Query GetLocGrp(LocDesc As %String) As %Query(ROWSPEC = "Tdesc:%String,Trowid:%String")
{
}

ClassMethod GetLocGrpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocGrpExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/*ClassMethod InsertLinkitm(inci, mrowid) As %String
{
	 n (inci,mrowid)
	 q:inci="" -1
	 q:mrowid="" -2
	 s arcitm=$p(^INCI(inci,1),"^",3)
	 q:arcitm=-3
	 s sub=$o(^POLI(mrowid,"G",""),-1)+1   ;child sub
	 k PLIST
	 s PLIST(0)=mrowid
	 s PLIST(2)=sub
	 s PLIST(3)=arcitm
	 &sql(insert into   PIVA_OrderLinkItm values PLIST())
	 q:SQLCODE'=0 -4
	 q $p(%ROWID,$c(1))
}

ClassMethod UpdateLinkitm(rowid, inci) As %String
{
	 n (rowid, inci)
	 s arcitm=$p(^INCI(inci,1),"^",3)
	 q:arcitm="" -1
	 &sql(update PIVA_OrderLinkItm set  POLI_Arcim_Dr=:arcitm where  POLI_RowID=:rowid)
	 q:SQLCODE'=0 -2
	 q $p(%ROWID,$c(1))
}

ClassMethod DeleteLinkitm(rowid) As %String
{
	 n (rowid)
	 q:rowid="" -1
	 &sql(delete from PIVA_OrderLinkItm  where  POLI_RowID=:rowid)
	 q:SQLCODE'=0 -2
	 q $p(%ROWID,$c(1))
}

*/
ClassMethod GetGetLocGrpItmExecute(ByRef qHandle As %Binary, mRowid) As %Status
{

    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    ;
    s typestring="W"
    s cnt=$l(typestring,"^")
    f i=1:1:cnt d
    .s type=$p(typestring,"^",i)
    .s locdr=""
    .f  s locdr=$o(^CTLOC(0,"LocType",type,locdr)) q:locdr=""  d
    ..s locdesc=$p(^CTLOC(locdr),"^",2)
    ..s rowid=locdr
    ..s tselect=$$CheckLoc(mRowid,locdr)
    ..d OutRowLocGrpItm
	Quit $$$OK
OutRowLocGrpItm
	set Data=$lb(locdesc,rowid,tselect)   
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
CheckLoc(plg,locdr)
    s ret="N"
    q:plg="" ret
    s sub=""
    f  s sub=$o(^PLGR(plg,"I",sub)) q:sub=""  d
    .s tmplocdr=$p(^PLGR(plg,"I",sub),"^",3)
    .i locdr=tmplocdr d
    ..s ret="Y"
    quit ret
}

ClassMethod GetGetLocGrpItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGetLocGrpItmExecute ]
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

Query GetGetLocGrpItm(mRowid As %String) As %Query(ROWSPEC = "Tdesc:%String,Trowid:%String,Tselect:%String")
{
}

ClassMethod GetGetLocGrpItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGetLocGrpItmExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod InsertLocGrpItm(locstring, mrowid) As %String
{
	 n (locstring,mrowid)
	 q:locstring="" -1
	 q:mrowid="" -2
	 s cnt=$l(locstring,"^")
	 s ret=0
	 tstart
	 f i=1:1:cnt q:ret=-1  d
	 .s locdr=$p(locstring,"^",i)
	 .s sub=$o(^PLGR(mrowid,"I",""),-1)+1   ;child sub
	 .k PLIST
	 .s PLIST(0)=mrowid
	 .s PLIST(2)=sub
	 .s PLIST(3)=locdr
	 .&sql(insert into PIVA_LocGrpItm values PLIST())
	 .i SQLCODE'=0 s ret=-1
	 .i ret=-1 trollback
     .q:ret=-1
     tcommit
	 ;q $p(%ROWID,$c(1))
	 q ret
}

ClassMethod DeleteLocGrpItm(mrowid) As %String
{
	 n (mrowid)
	 q:mrowid="" -1
	 s cnt=$o(^PLGR(mrowid,"I",""),-1)
	 q:cnt="" 0
	 &sql(delete from PIVA_LocGrpItm  where  PLGI_PLG_ParRef=:mrowid)
	 q:SQLCODE'=0 -2
	 q $p(%ROWID,$c(1))
}

}
