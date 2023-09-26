Import SQLUser

Class web.DHCWMRCommon.Location Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 11;

ClassMethod QueryLoctionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLoctionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryLoctionExecute(ByRef qHandle As %Binary, Desc, Dep, Loc, Type) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	;;^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub})
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s Rowid=0
	f  s Rowid=$o(^CTLOC(Rowid)) q:Rowid=""  d
	.s tmpLoc=$g(^CTLOC(+Rowid))
    .s LocDesc=$p(tmpLoc,"^",2)
    .s LocDep=$p(tmpLoc,"^",19)
    .s LocType=$p(tmpLoc,"^",13)
    .q:(Desc'="")&&($$ALPHAUP^SSUTIL4(LocDesc)'[Desc)
    .q:(Dep'="")&&(LocDep'=Dep)    //判断科室是否属于Dep部门组
	.q:(Loc'="")&&('$d(^CTLOC(Loc,"LINK",0,"Loc",+Rowid)))   //根据科室关联科室表判断科室是否属于Loc科室  CT_LocLinkLocation
    .q:(Type'="")&&(LocType'=Type)  //判断科室类型 E--执行科室  W--病区  
    .s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)	//add by liuxuefeng 2009-12-05
    .s Data=$lb(Rowid,LocDesc)
    .s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryLoctionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLoctionExecute ]
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

/// 查询科室列表
/// Desc--科室名称  Dep--部门组  Loc--科室  Type--科室类型
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRCommon.Location","QueryLoction","","","","")
Query QueryLoction(Desc, Dep, Loc, Type) As %Query(ROWSPEC = "LocId:%String,LocDesc:%String")
{
}

/// 取科室信息  ID^代码^名称
/// w ##Class(web.DHCWMRCommon.Location).GetLoc(LocId)
ClassMethod GetLoc(LocId)
{
	n (LocId)
	s ret=""
	s tmpLoc=$g(^CTLOC(+LocId))
	q:($p(tmpLoc,"^",1)="")||($p(tmpLoc,"^",2)="") ret
	s ret=(+LocId)_"^"_$p(tmpLoc,"^",1)_"^"_$p(tmpLoc,"^",2)
	q ret
}

}
