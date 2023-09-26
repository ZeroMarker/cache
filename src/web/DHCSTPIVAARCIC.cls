Import SQLUser

/// 配液类别维护，table(PIVA_Arcic)
Class web.DHCSTPIVAARCIC Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetArcItmCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetArcItmCatExecute ]
{
	S AtEnd=$LIST(qHandle,1)
 	S repid=$LIST(qHandle,2)
 	S ind=$LIST(qHandle,3)
 	S ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		S AtEnd=1
 		S Row=""
 	}
 	Else {				
 		S Row=^CacheTemp(repid,ind)
 	}
 	S qHandle=$lb(AtEnd,repid,ind)
	Q $$$OK
}

ClassMethod GetArcItmCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetArcItmCatExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
 	Q $$$OK
}

ClassMethod GetArcItmCatExecute(ByRef qHandle As %Binary, OrderType As %String) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	I OrderType="" S qHandle=$lb(0,repid,0) Q $$$OK
	S arcicdr="0"
 	F  S arcicdr=$O(^ARC("IC",0,"OrderType",OrderType,arcicdr)) Q:arcicdr=""  D
 	.Q:'$D(^ARC("IC",arcicdr))
 	.S arciccode=$P(^ARC("IC",arcicdr),"^",1)
 	.S arcicdesc=$P(^ARC("IC",arcicdr),"^",2)
 	.S flag=0
 	.I $O(^PIVAA(0,"ARCIC",arcicdr,""))'="" S flag=1
	.D OutputRow
 	Q $$$OK
OutputRow
	S Data=$lb(arcicdr,arciccode,arcicdesc,flag)
 	S ^CacheTemp(repid,ind)=Data	
 	S ind=ind+1
 	Q
}

Query GetArcItmCat(OrderType As %String) As %Query(ROWSPEC = "TArcicDr:%String,TArcicCode:%String,TArcicDesc:%String,TArcicFlag:%String")
{
}

/// 保存配药类别
ClassMethod SaveArcic(arcicdr As %String, flag As %String) As %String
{
	N (arcicdr,flag)
	Q:arcicdr="" -99998
	S padr=$o(^PIVAA(0,"ARCIC",arcicdr,""))
	I (padr="")&(flag=1) d
	.&sql(Insert into PIVA_Arcic(PA_ARCIC_Dr) Values(:arcicdr)) 
	.I SQLCODE<0 S padr=SQLCODE Q
	.I SQLCODE=100 S padr=-99999 Q
	.S padr=$p(%ROWID,$c(1))
	Else  IF (padr'="")&(flag=0) d
	.&sql(delete from PIVA_Arcic where PA_Rowid=:padr) 
	.I SQLCODE<0 S padr=SQLCODE Q
	.I SQLCODE=100 S padr=-99999 Q
	Q +padr
}

}
