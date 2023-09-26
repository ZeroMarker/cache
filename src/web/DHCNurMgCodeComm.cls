Import SQLUser

Class web.DHCNurMgCodeComm Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Query SSGROUP(desc As %String) As %Query(ROWSPEC = "Group:%String,ID:%String")
{
}

ClassMethod SSGROUPExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s rw=""  f  s rw=$O(^SSU("SSGRP",rw)) q:rw=""  d
 	.q:+rw=0
 	.s GrpDesc=$P(^SSU("SSGRP",rw),"^",1)
 	.q:(GrpDesc'[desc)&(desc'="")
    .d Output4
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
Output4
	s Data=$lb(GrpDesc,rw)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod SSGROUPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SSGROUPExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SSGROUPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SSGROUPExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetHospExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
 	s HospRowId=""
    f  s HospRowId=$O(^CT("HOSP",HospRowId)) q:HospRowId=""  d
    .s HospName=$p($G(^CT("HOSP",HospRowId)),"^",2)
    .s stdate=$P($G(^CT("HOSP",HospRowId)),"^",9)
    .s enddate=$P($G(^CT("HOSP",HospRowId)),"^",10)
    .s date=+$H
    .q:(((stdate'="")&&(date<stdate))!((enddate'="")&&(date>enddate)))
    .q:HospName=""
    .s ret=""
    .s ret="HospName|"_HospName
	.s ret=ret_"^rw|"_HospRowId
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetHospFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospExecute ]
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

Query GetHosp() As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetHospClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/*
Query GetCtloc(locdes) As %SQLQuery(CONTAINID = 1, ROWSPEC = "CTLOC_RowId:%Integer,CTLOC_Desc:%String")
{
    select CTLOC_RowId,CTLOC_Desc from CT_LOC where CTLOC_Type<>'OR' and CTLOC_Type<>'O' and CTLOC_Desc like UCASE(:locdes)_'%' order by CTLOC_Type
}
*/
Query GetCtloc(locdes As %String = "") As %Query(ROWSPEC = "CTLOC_RowId:%Integer,CTLOC_Desc:%String")
{
}

ClassMethod GetCtlocExecute(ByRef qHandle As %Binary, locdes As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s loctyp="" f  s loctyp=$O(^CTLOC(0,"LocType",loctyp)) q:loctyp=""  d
 	.q:((loctyp="OR")!(loctyp="O"))
 	.s rowid="" f  s rowid=$O(^CTLOC(0,"LocType",loctyp,rowid)) q:rowid=""  d
 	..s obj=##class(User.CTLoc).%OpenId(rowid)
 	..s CTLOCDesc=obj.CTLOCDesc
 	..q:((locdes'="")&&(CTLOCDesc'[$zcvt(locdes,"U")))
	..d outputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outputRow
	set Data=$lb(rowid,CTLOCDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCtlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCtlocExecute ]
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

ClassMethod GetCtlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCtlocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
