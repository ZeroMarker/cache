Import SQLUser

Class web.DHCSTPIVAORDLINK Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Insert(TarDesc) As %String
{
	 n (TarDesc)
	 q:TarDesc="" -1
	 k PLIST
	 s PLIST(2)=TarDesc
	 &sql(insert into  PIVA_OrderLink values PLIST())
	 q:SQLCODE'=0 -2
	 q $p(%ROWID,$c(1))
}

ClassMethod Update(Trowid, TarDesc) As %String
{
	 n (Trowid,TarDesc)
	 &sql(update PIVA_OrderLink set POL_Desc=:TarDesc where  POL_Rowid=:Trowid)
	 q:SQLCODE'=0 -1
	 q $p(%ROWID,$c(1))
}

ClassMethod Delete(Trowid) As %String
{
	 n (Trowid)
	 &sql(delete from  PIVA_OrderLink where POL_Rowid=:Trowid)
	 q:SQLCODE'=0 -1
	 q $p(%ROWID,$c(1))
}

ClassMethod GetOrdLinkExecute(ByRef qHandle As %Binary, tarDesc) As %Status
{

    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    ;
    s pol="0"
    f  s pol=$o(^POLI(pol)) q:pol=""  d
    .s desc=$p(^POLI(pol),"^",1)
    .q:(desc'=tarDesc)&(tarDesc'="")
    .d OutRowOrdLink
	Quit $$$OK
OutRowOrdLink
	set Data=$lb(desc,pol)   
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetOrdLinkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdLinkExecute ]
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

Query GetOrdLink(tarDesc As %String) As %Query(ROWSPEC = "Tdesc:%String,Trowid:%String")
{
}

ClassMethod GetOrdLinkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdLinkExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod InsertLinkitm(inci, mrowid) As %String
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

ClassMethod GetOrdLinkItmExecute(ByRef qHandle As %Binary, mRowid) As %Status
{

    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    ;
    q:mRowid="" $$$OK
    s pol=mRowid
    s sub=""
    f  s sub=$o(^POLI(pol,"G",sub)) q:sub=""  d
    .s arcrowid=$p(^POLI(pol,"G",sub),"^",1)
    .s arcdesc=$p(^ARCIM(+arcrowid,$p(arcrowid,"||",2),1),"^",2)
    .s rowid=pol_"||"_sub
    .d OutRowOrdLinkItm
	Quit $$$OK
OutRowOrdLinkItm
	set Data=$lb(arcdesc,rowid)   
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetOrdLinkItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdLinkItmExecute ]
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

Query GetOrdLinkItm(mRowid As %String) As %Query(ROWSPEC = "Tdesc:%String,Trowid:%String")
{
}

ClassMethod GetOrdLinkItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdLinkItmExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod InsertLinkOrd(arci, mrowid, qty) As %String
{
	 n (arci,mrowid,qty)
	 q:arci="" -1
	 q:mrowid="" -2
	 s sub=$o(^POLI(mrowid,"M",""),-1)+1   ;child sub
	 k PLIST
	 s PLIST(0)=mrowid
	 s PLIST(2)=sub
	 s PLIST(3)=arci
	 s PLIST(4)=qty
	 &sql(insert into PIVA_OrderLinkOrder values PLIST())
	 q:SQLCODE'=0 -3
	 q $p(%ROWID,$c(1))
}

ClassMethod UpdateLinkOrd(rowid, arci, qty) As %String
{
	 n (rowid,arci,qty)
	 q:rowid="" -1
	 i arci="" s arci=$p($g(^POLI(+rowid,"M",$p(rowid,"||",2))),"^",1)  //arci为空时表示未修改
	 q:arci="" -1
	 i +qty=0 s qty=1
	 &sql(update PIVA_OrderLinkOrder set  POLO_Arcim_Dr=:arci,POLO_AddQty=:qty where  POLO_RowID=:rowid)
	 q:SQLCODE'=0 -2
	 q $p(%ROWID,$c(1))
}

ClassMethod DeleteLinkOrd(rowid) As %String
{
	 n (rowid)
	 q:rowid="" -1
	 &sql(delete from PIVA_OrderLinkOrder  where  POLO_RowID=:rowid)
	 q:SQLCODE'=0 -2
	 q $p(%ROWID,$c(1))
}

ClassMethod GetOrdLinkOrdExecute(ByRef qHandle As %Binary, mRowid) As %Status
{

    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    ;
    q:mRowid="" $$$OK
    s pol=mRowid
    s sub=""
    f  s sub=$o(^POLI(pol,"M",sub)) q:sub=""  d
    .s arcrowid=$p(^POLI(pol,"M",sub),"^",1)
    .s arcdesc=$p(^ARCIM(+arcrowid,$p(arcrowid,"||",2),1),"^",2)
    .s rowid=pol_"||"_sub
    .s qty=$p(^POLI(pol,"M",sub),"^",4)
    .i +qty=0 s qty=1
    .d OutRowOrdLinkOrd
	Quit $$$OK
OutRowOrdLinkOrd
	set Data=$lb(arcdesc,rowid,qty)   
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetOrdLinkOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdLinkOrdExecute ]
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

Query GetOrdLinkOrd(mRowid As %String) As %Query(ROWSPEC = "Tdesc:%String,Trowid:%String,Tqty:%String")
{
}

ClassMethod GetOrdLinkOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdLinkOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
