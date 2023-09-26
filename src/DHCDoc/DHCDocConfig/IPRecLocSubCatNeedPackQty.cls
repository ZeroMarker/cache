Class DHCDoc.DHCDocConfig.IPRecLocSubCatNeedPackQty Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query FindCatList(LocId As %String, value As %String, HospId As %String = "") As %Query(ROWSPEC = "ARCICRowId:%String,ARCICDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCatListExecute(ByRef qHandle As %Binary, LocId As %String, value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.IPRecLocSubCatNeedPackQty","FindCatList",348,"IPRecLocSubCatNeedPackQty")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ARCICRowId=0
 	f  s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""  d
 	.Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItemCat",ARCICRowId,HospId)="N"
 	.s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
 	.s ARCICOrderType=$p(^ARC("IC",ARCICRowId),"^",7)
 	.q:ARCICOrderType'="R"
 	.s selected=0
 	.i (value'="")&&(LocId'="") d
 	..s CatListStr=..%GetConfig1(value,LocId,HospId) //$g(^DHCDocConfig(value,LocId))
 	..s:("^"_CatListStr_"^")[("^"_ARCICRowId_"^") selected=1
	.Do OutputRowFindCatList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCatList
	set Data=$lb($g(ARCICRowId),$g(ARCICDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCatListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCatListExecute ]
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

ClassMethod SaveOrdNeedPackQtyLimit(Node As %String, LocId As %String, ARCIMRowid As %String, rowid As %String) As %String
{
	q:(+ARCIMRowid=0)||(ARCIMRowid'["||") "-2"
	q:'$d(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)) "-2"
	s Index=$O(^DHCDocConfig(Node,LocId,"Item",""),-1)
	s repeat=0
	for i=1:1:Index {
		s ArcimRowId=$g(^DHCDocConfig(Node,LocId,"Item",i))
		continue:(rowid'="")&&(rowid=i)
		if (ArcimRowId=ARCIMRowid) s repeat=1 Q
	}
	Q:repeat=1 "-1"
	if (rowid'="") {
		s ^DHCDocConfig(Node,LocId,"Item",rowid)=ARCIMRowid
	}else{
		s Index=Index+1
		s ^DHCDocConfig(Node,LocId,"Item",Index)=ARCIMRowid
	}
	q 0
}

ClassMethod DelOrdNeedPackQty(LocId As %String, index As %String) As %String
{
	k ^DHCDocConfig("IPRecLocArcItemNeedPackQty",LocId,"Item",index)
	q 0
}

Query FindOrdNeedPackQtyList(LocId As %String, value As %String, HospId As %String = "") As %Query(ROWSPEC = "index:%String,ARCIMRowid:%String,ARCIMDesc:%String")
{
}

ClassMethod FindOrdNeedPackQtyListExecute(ByRef qHandle As %Binary, LocId As %String, value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.IPRecLocSubCatNeedPackQty","FindOrdNeedPackQtyList",348,"IPRecLocSubCatNeedPackQty")
	Set repid=$I(^CacheTemp)
    Set ind=1
    if (LocId="") {
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
    s index=0
    for {
	    s index=$o(^DHCDocConfig("IPRecLocArcItemNeedPackQty",LocId,"Item",index)) Q:index=""
	    s ArcimRowId=$g(^DHCDocConfig("IPRecLocArcItemNeedPackQty",LocId,"Item",index))
	    continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ArcimRowId,HospId)="N"
	    s ArcimDesc=$P($G(^ARCIM(+ArcimRowId,+$P(ArcimRowId,"||",2),1)),"^",2)
	    Do OutputRowFindOrdNeedPackQtyList
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindOrdNeedPackQtyList
	set Data=$lb($g(index),$g(ArcimRowId),$g(ArcimDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindOrdNeedPackQtyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrdNeedPackQtyListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOrdNeedPackQtyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrdNeedPackQtyListExecute ]
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
