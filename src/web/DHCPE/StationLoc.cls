Class web.DHCPE.StationLoc Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// function 判断站点对应科室是否存在
/// debug:w ##class(web.DHCPE.StationLoc).IsExistStationLoc()
ClassMethod IsExistStationLoc(Parref, LocID, LocDesc, LocSort)
{
	s id=0,flag=0
	s OldLocDesc="",OldLocSort=""
	if (LocID'=""){
		s OldLocDesc=$p($g(^DHCPEST(+LocID,"STLOC",$p(LocID,"||",2))),"^",1)
		s OldLocSort=$p($g(^DHCPEST(+LocID,"STLOC",$p(LocID,"||",2))),"^",2)
	}

	f  s id=$o(^DHCPEST(Parref,"STLOC",id)) q:(id="")||(flag=1)||(flag=2)  d
	.s Desc=$p($g(^DHCPEST(Parref,"STLOC",id)),"^",1)
	.s Sort=$p($g(^DHCPEST(Parref,"STLOC",id)),"^",2)
	.i (Desc=LocDesc)&&(OldLocDesc'=LocDesc) s flag=1
	.i (Sort=LocSort)&&(OldLocSort'=LocSort) s flag=2 
 
	q flag
}

ClassMethod Update(Parref, LocID, LocDesc, LocSort)
{
	i LocID="" d
	.&SQL(insert into Sqluser.DHC_PE_StationLoc (STL_ParRef,STL_LocDesc,STL_LocSort) values (:Parref,:LocDesc,:LocSort))
	e  d
	.&SQL(Update Sqluser.DHC_PE_StationLoc set STL_LocDesc=:LocDesc,STL_LocSort=:LocSort where STL_RowID=:LocID)
	q SQLCODE
}

ClassMethod Delete(LocID)
{
	s Sort=""
	f  s Sort=$o(^DHCPEStationOrder("LocSort",LocID,Sort)) q:Sort=""  d
	.s Index=""
	.f  s Index=$o(^DHCPEStationOrder("LocSort",LocID,Sort,Index)) q:Index=""  d
	..s ARCID=$g(^DHCPEStationOrder("LocSort",LocID,Sort,Index))
	..k ^DHCPEStationOrder("Loc",ARCID)
	k ^DHCPEStationOrder("LocSort",LocID)

	&SQL(Delete From Sqluser.DHC_PE_StationLoc where STL_RowID=:LocID)
	q SQLCODE
}

ClassMethod IsExistDetail(ARCID)
{
	q $d(^DHCPEStationOrder("Loc",ARCID))
}

ClassMethod GetDetail(ARCIMID)
{
	q:ARCIMID="" ""
	q $G(^DHCPEStationOrder("Loc",ARCIMID))
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.StationLoc", "SearchStationLoc","7")
Query SearchStationLoc(ParRef As %Library.String = "") As %SQLQuery(ROWSPEC = "Hidden:%String,STL_RowId:%String:ID, Hidden:%String, STL_Desc:%String:名称,STL_Sort:%String:顺序,STL_NoActive:%String,STL_UpdateDate:%String,STL_UpdateTime:%String,STL_UpdateUser:%String,STL_KBXCode:%String,STLKBItemCatDesc:%String") [ SqlProc ]
{
 select * from Sqluser.DHC_PE_StationLoc where STL_ParRef=:ParRef
}

ClassMethod UpdateDetail(ARCID, Sort, STLocID)
{
	s Info=$G(^DHCPEStationOrder("Loc",ARCID))
	i Info'=""
	{
		s OldSort=$P(Info,"^",2)
		q:OldSort=Sort 0
		s Index=$P(Info,"^",3)
		s STLoc=$P(Info,"^",1)
		k ^DHCPEStationOrder("Loc",ARCID)
		k ^DHCPEStationOrder("LocSort",STLoc,OldSort,Index)
	}
	s Index=$I(^DHCPEStationOrder("LocSort",STLocID,Sort))
	s ^DHCPEStationOrder("Loc",ARCID)=STLocID_"^"_Sort_"^"_Index
 	s ^DHCPEStationOrder("LocSort",STLocID,Sort,Index)=ARCID
 	q 0
}

ClassMethod DeleteDetail(ARCIMID)
{
	;d ##class(web.DHCPE.StationLoc).DeleteDetail("33046||1")
	s Info=$G(^DHCPEStationOrder("Loc",ARCIMID))
	q:Info="" -1
	s STLocID=$P(Info,"^",1)
	s Sort=$P(Info,"^",2)
	s Index=$P(Info,"^",3)
	k ^DHCPEStationOrder("Loc",ARCIMID)
 	k ^DHCPEStationOrder("LocSort",STLocID,Sort,Index)
 	q 0
}

Query SearchStationLocDetail(LocID As %String = "", hospId As %String = "") As %Query(ROWSPEC = "ArcimID:%String,ARCIMDesc:%String,TSort:%String")
{
}

ClassMethod SearchStationLocDetailExecute(ByRef qHandle As %Binary, LocID As %String = "", hospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i LocID=""
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s Sort=""
 	f  s Sort=$O(^DHCPEStationOrder("LocSort",LocID,Sort)) q:Sort=""  d
 	.s Index=""
 	.f  s Index=$O(^DHCPEStationOrder("LocSort",LocID,Sort,Index)) q:Index=""  d
 	..s ArcimID=$G(^DHCPEStationOrder("LocSort",LocID,Sort,Index))
	..s ARCIMDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ArcimID)
	..s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",ArcimID,hospId)
	..q:(HOSPshowFlag="N")
	..d SearchStationLocDetailBuild
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SearchStationLocDetailBuild
	set Data=$lb(ArcimID,ARCIMDesc,Sort)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchStationLocDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchStationLocDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SearchStationLocDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchStationLocDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
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
