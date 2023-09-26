Import SQLUser

Class web.DHCWMRCommon.Ward Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 10;

ClassMethod QueryWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryWardExecute(ByRef qHandle As %Binary, Desc, Loc) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	;^PAWARD({WARD_RowID})
	;^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub})
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s Rowid=0
	f  s Rowid=$o(^PAWARD(Rowid)) q:Rowid=""  d
	.s tmpWard=$g(^PAWARD(+Rowid))
	.q:tmpWard=""
	.s WardDesc=$p(tmpWard,"^",2)
	.s LocDR=$p(tmpWard,"^",5)
    .q:(Desc'="")&&($$ALPHAUP^SSUTIL4(WardDesc)'[Desc)
    .q:(Loc'="")&&('$d(^CTLOC(Loc,"LINK",0,"Loc",+LocDR)))   //根据科室关联科室表判断病区是否属于Loc科室  CT_LocLinkLocation
    .s:WardDesc["-" WardDesc=$p(WardDesc,"-",2) 				//add by liuxuefeng 2009-12-05
    .s Data=$lb(Rowid,WardDesc)
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
	Quit $$$OK
}

ClassMethod QueryWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWardExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 根据名称、科室查询病区列表
/// Desc--病区名称  Loc--病区所属科室
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRCommon.Ward","QueryWard","","22")
Query QueryWard(Desc, Loc) As %Query(ROWSPEC = "WardId:%String,WardDesc:%String")
{
}

ClassMethod GetWard(WardId)
{
	n (WardId)
	s ret=""
	s tmpWard=$g(^PAWARD(+WardId))
	q:($p(tmpWard,"^",1)="")||($p(tmpWard,"^",2)="") ret
	s ret=(+WardId)_"^"_$p(tmpWard,"^",1)_"^"_$p(tmpWard,"^",2)
	q ret
}

}
