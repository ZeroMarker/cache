Import SQLUSER

Class web.DHCICUCommonOrdMapping Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod InsertOrdMapping(ViewSuperCat As %String, ViewCat As %String, arcim As %String, speedUnit As %String, anco As %String, oeoriNote As %String, uom As %String, density As %String, qty As %String, prepareVolume As %String, abbreviate As %String, defSpeed As %String, deptId As %String = "")
{
    s QCode=1    
    i ViewSuperCat="" q QCode
    s QCode=0
	i ViewCat="" d
		..i $d(^DHCICUC("OrdMapping",ViewSuperCat))>1 s QCode="项目重复"
		..s ^DHCICUC("OrdMapping",ViewSuperCat)=anco_"^"_"^"_"^"_"^"_"^"_"^"_"^"_"^"_deptId
	i ViewCat'="" d 
		.i arcim="" d
			..i $d(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat))>1 s QCode="项目重复"
			..s ^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)=anco_"^"_"^"_"^"_"^"_"^"_"^"_"^"_"^"_deptId
		.i arcim'="" d
			..i oeoriNote="" d
				...i $d(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim))>1 s QCode="项目重复"
				...s ^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)=anco_"^"_speedUnit_"^"_uom_"^"_density_"^"_qty_"^"_prepareVolume_"^"_abbreviate_"^"_defSpeed_"^"_deptId
			..i oeoriNote'=""  d
				...i $d(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,oeoriNote))>1 s QCode="项目重复"
				...s ^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,oeoriNote)=anco_"^"_speedUnit_"^"_uom_"^"_density_"^"_qty_"^"_prepareVolume_"^"_abbreviate_"^"_defSpeed_"^"_deptId
		
	;s QCode=0
	q QCode
}

ClassMethod UpdateOrdMapping(ViewSuperCat As %String, ViewCat As %String, arcim As %String, speedUnit As %String, anco As %String, oeoriNote As %String, uom As %String, density As %String, qty As %String, prepareVolume As %String, abbreviate As %String, defSpeed As %String, deptId As %String = "", PreViewSuperCatDr As %String = "", PreViewCatDr As %String = "", PreArcimDr As %String = "", PreOeoriNote As %String = "")
{
    s QCode=1
    i ViewSuperCat="" q QCode
   
    i (PreViewSuperCatDr'="")&&(PreViewCatDr="") k ^DHCICUC("OrdMapping",PreViewSuperCatDr)
	i (PreViewSuperCatDr'="")&&(PreViewCatDr'="")&&(PreArcimDr="") k ^DHCICUC("OrdMapping",PreViewSuperCatDr,PreViewCatDr)
	i (PreViewSuperCatDr'="")&&(PreViewCatDr'="")&&(PreArcimDr'="")&&(PreOeoriNote="") k ^DHCICUC("OrdMapping",PreViewSuperCatDr,PreViewCatDr,PreArcimDr)
	i (PreViewSuperCatDr'="")&&(PreViewCatDr'="")&&(PreArcimDr'="")&&(PreOeoriNote'="") k ^DHCICUC("OrdMapping",PreViewSuperCatDr,PreViewCatDr,PreArcimDr,PreOeoriNote)
	i ViewCat="" s ^DHCICUC("OrdMapping",ViewSuperCat)=anco_"^"_"^"_"^"_"^"_"^"_"^"_"^"_"^"_deptId
	i ViewCat'="" d 
	.i arcim="" s ^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)=anco_"^"_"^"_"^"_"^"_"^"_"^"_"^"_"^"_deptId
	.i arcim'="" d
	..i oeoriNote="" s ^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)=anco_"^"_speedUnit_"^"_uom_"^"_density_"^"_qty_"^"_prepareVolume_"^"_abbreviate_"^"_defSpeed_"^"_deptId
	..i oeoriNote'="" s ^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,oeoriNote)=anco_"^"_speedUnit_"^"_uom_"^"_density_"^"_qty_"^"_prepareVolume_"^"_abbreviate_"^"_defSpeed_"^"_deptId
	
	s QCode=0
	q QCode
}

ClassMethod DeleteOrdMapping(ViewSuperCat As %String, ViewCat As %String, arcim As %String, oeoriNote As %String)
{
    s QCode=1
    i ViewSuperCat="" q QCode
    i (ViewCat="")&&(arcim="")&&(oeoriNote="") s ^DHCICUC("OrdMapping",ViewSuperCat)=""
    i (ViewCat'="")&&(arcim="")&&(oeoriNote="") s ^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)=""
    i (ViewCat'="")&&(arcim'="")&&(oeoriNote="") s ^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)=""
	i (ViewCat'="")&&(arcim'="")&&(oeoriNote'="") k ^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,oeoriNote)
	s QCode=0
	q QCode
}

Query FindViewSuperCat(ViewSuperCat As %String) As %Query(ROWSPEC = "ORCatDesc:%String,RowId:%String") [ SqlProc ]
{
}

ClassMethod FindViewSuperCatExecute(ByRef qHandle As %Binary, ViewSuperCat As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=0
	f  s RowId=$o(^OEC("ORCAT",RowId))  q:RowId=""  d
	.s ORCatID=$p(^OEC("ORCAT",RowId),"^",1)	
	.s ORCatDesc=$p(^OEC("ORCAT",RowId),"^",2)
	.i (ViewSuperCat'="")&&((ViewSuperCat=RowId)||(ORCatDesc[ViewSuperCat)) d OutputRow6
	.i (ViewSuperCat="") d OutputRow6
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	set Data=$lb(ORCatDesc,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindViewSuperCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindViewSuperCatExecute ]
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

ClassMethod FindViewSuperCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindViewSuperCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      	MFC
/// CreatDate：    	2012-12-11
/// Description： 	
/// Table：        	
/// Input：        	ViewSuperCatID医嘱大类，ViewCatID医嘱分类
/// Output：       
/// Return：       	
Query FindICUOrdMap(ViewSuperCatID As %String, ViewCatID As %String, arcimID As %String, oeoriNote As %String) As %Query(ROWSPEC = "tAncoId:%String,tAncoDesc:%String,tSpeedUnitId:%String,tSpeedUnitDesc:%String,tUomId:%String,tUomDesc:%String,tDensity:%String,tQty:%String,tPrepareVolume:%String,tAbbreviate:%String,tDefSpeed:%String,tViewSuperCatIDT:%String,tViewSuperCatDescT:%String,tViewCatIDT:%String,tViewCatDescT:%String,tArcimIDT:%String,tArcimDescT:%String ,tOeoriNoteT:%String,tDeptId:%String,tDeptDesc:%String") [ SqlProc ]
{
}

ClassMethod FindICUOrdMapExecute(ByRef qHandle As %Binary, ViewSuperCatID As %String, ViewCatID As %String, arcimID As %String, oeoriNote As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	i $g(ind)="" Set ind=1
	s ViewSuperCat="" ,ViewCat="",arcim="",Desc=""
	s tancoId="",tancoDesc="",tspeedUnitId="",tspeedUnitDesc="",tuomId="",tuomtDesc="",tdensity="",tqty="",tprepareVolume="",tabbreviate="",tdefSpeed=""
	s tViewSuperCatIDT="",tViewSuperCatDescT="",tViewCatIDT="",tViewCatDescT="",arcimIDT="",tarcimDescT="",toeoriNoteT=""
	//b ;"1"
    s tarcimID1="",tarcimID2=""
    f  s ViewSuperCat=$O(^DHCICUC("OrdMapping",ViewSuperCat)) q:(ViewSuperCat="")  d
    .s tancoId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat)),"^",1)
    .q:(tancoId="")
    .s tancoDesc=$p($g(^DHCICUC("RecordItem",tancoId)),"^",2)
    .s tViewSuperCatIDT=ViewSuperCat
	.s tViewSuperCatDescT=$p($g(^OEC("ORCAT",ViewSuperCat)),"^",2)	
	.s tDeptId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat)),"^",9)
	.d Output1
	f  s ViewSuperCat=$O(^DHCICUC("OrdMapping",ViewSuperCat)) q:(ViewSuperCat="")  d	
	.f  s ViewCat=$O(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)) q:(ViewCat="")  d
    ..s tancoId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)),"^",1)
    ..q:(tancoId="")
    ..s tancoDesc=$p($g(^DHCICUC("RecordItem",tancoId)),"^",2)
    ..s tViewSuperCatIDT=ViewSuperCat
	..s tViewSuperCatDescT=$p($g(^OEC("ORCAT",ViewSuperCat)),"^",2)
	..s tViewCatIDT=ViewCat
	..s tViewCatDescT=$p($g(^ARC("IC",ViewCat)),"^",2)
	..s tDeptId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)),"^",9)
	..d Output5
	f  s ViewSuperCat=$O(^DHCICUC("OrdMapping",ViewSuperCat)) q:(ViewSuperCat="")  d
	.f  s ViewCat=$O(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)) q:(ViewCat="")  d
	..f  s arcim=$O(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)) q:(arcim="")  d	
    ...;s tancoId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",1)
    ...;q:(tancoId="")
    ...;s tancoDesc=$p($g(^DHCICUC("RecordItem",tancoId)),"^",2)
    ...;s tViewSuperCatIDT=ViewSuperCat
	...;s tViewSuperCatDescT=$p($g(^OEC("ORCAT",ViewSuperCat)),"^",2)
	...;s tViewCatIDT=ViewCat
	...;s tViewCatDescT=$p($g(^ARC("IC",ViewCat)),"^",2)
	...;s tarcimIDT=arcim
	...;s tarcimID1=$p($g(tarcimIDT),"||",1)
	...;s tarcimID2=$p($g(tarcimIDT),"||",2)
	...;i (tarcimID1'="")&&(tarcimID2'="") d
	....;s tarcimDescT=$p($g(^ARCIM(tarcimID1,tarcimID2,1)),"^",2)
	...s tancoId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",1)
	...q:(tancoId="")
	...s tancoDesc=$p($g(^DHCICUC("RecordItem",tancoId)),"^",2)
	...s tspeedUnitId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",2)
	...s speedUnit=""
	...;q:(tspeedUnitId="")
	...&SQL(select ICUCSU_Desc into :speedUnit from SQLUSER.DHC_ICUC_SpeedUnit where ICUCSU_RowId=:tspeedUnitId)
	...i (speedUnit'="") d
	....s tspeedUnitDesc=speedUnit
	...s tuomId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",3)
	...s uom=""
	...;q:(tuomId="")
	...&SQL(select CTUOM_Desc into :uom from SQLUSER.ct_uom where CTUOM_RowId=:tuomId)
	...i (uom'="") d
	....s tuomtDesc=uom
	...s tdensity=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",4)
	...s tqty=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",5)
	...s tprepareVolume=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",6)
	...s tabbreviate=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",7)
	...s tdefSpeed=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",8)
	...s tViewSuperCatIDT=ViewSuperCat
	...s tViewSuperCatDescT=$p($g(^OEC("ORCAT",ViewSuperCat)),"^",2)
	...s tViewCatIDT=ViewCat
	...s tViewCatDescT=$p($g(^ARC("IC",ViewCat)),"^",2)
	...s tarcimIDT=arcim
	...s tarcimID1=$p($g(tarcimIDT),"||",1)
	...s tarcimID2=$p($g(tarcimIDT),"||",2)	
	...i (tarcimID1'="")&&(tarcimID2'="") d
	....s tarcimDescT=$p($g(^ARCIM(tarcimID1,tarcimID2,1)),"^",2)
	...s tDeptId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",9)	
	...d Output7
    s ViewSuperCat="",ViewCat=""
	f  s ViewSuperCat=$O(^DHCICUC("OrdMapping",ViewSuperCat)) q:(ViewSuperCat="")  d	
	.;q:(ViewSuperCatID'="")&&(ViewSuperCat'=ViewSuperCatID)
	.f  s ViewCat=$O(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)) q:(ViewCat="")  d	
	..;s ^tempmfc("2012")=ViewCat
	..;q:(ViewCatID'="")&&(ViewCat'=ViewCatID)	
	..f  s arcim=$O(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)) q:(arcim="")  d
	...;q:(arcimID'="")&&(arcim'=arcimID)	
	...f  s Desc=$O(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)) q:(Desc="")  d
	....;q:(oeoriNote'="")&&(Desc'=oeoriNote)
	....s tancoId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)),"^",1)
	....s tancoDesc=$p($g(^DHCICUC("RecordItem",tancoId)),"^",2)
	....s tspeedUnitId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)),"^",2)
	....s speedUnit=""
	....&SQL(select ICUCSU_Desc into :speedUnit from SQLUSER.DHC_ICUC_SpeedUnit where ICUCSU_RowId=:tspeedUnitId)
	....i (speedUnit'="") d
	.....s tspeedUnitDesc=speedUnit
	....s tuomId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)),"^",3)
	....s uom=""
	....&SQL(select CTUOM_Desc into :uom from SQLUSER.ct_uom where CTUOM_RowId=:tuomId)
	....i (uom'="") d
	.....s tuomtDesc=uom
	....s tdensity=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)),"^",4)
	....s tqty=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)),"^",5)
	....s tprepareVolume=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)),"^",6)
	....s tabbreviate=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)),"^",7)
	....s tdefSpeed=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)),"^",8)
	....s tViewSuperCatIDT=ViewSuperCat
	....s tViewSuperCatDescT=$p($g(^OEC("ORCAT",ViewSuperCat)),"^",2)
	....s tViewCatIDT=ViewCat
	....s tViewCatDescT=$p($g(^ARC("IC",ViewCat)),"^",2)
	....s tarcimIDT=arcim
	....s tarcimID1=$p($g(tarcimIDT),"||",1)
	....s tarcimID2=$p($g(tarcimIDT),"||",2)
	....;s ^tempmfc("2011")=tarcimID1_"^"_tarcimID2
	....i (tarcimID1'="")&&(tarcimID2'="") d
	.....s tarcimDescT=$p($g(^ARCIM(tarcimID1,tarcimID2,1)),"^",2)
	....s toeoriNoteT=Desc
	....s tDeptId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)),"^",9)	
	....d Output
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output
	i toeoriNoteT["CaGlu" b
	s tDeptDesc=$p($g(^CTLOC(+tDeptId)),"^",2)
	set Data=$lb(tancoId,tancoDesc,tspeedUnitId,tspeedUnitDesc,tuomId,tuomtDesc,tdensity,tqty,tprepareVolume,tabbreviate,tdefSpeed,tViewSuperCatIDT,tViewSuperCatDescT,tViewCatIDT,tViewCatDescT,tarcimIDT,tarcimDescT,toeoriNoteT,tDeptId,tDeptDesc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
Output1
	s tDeptDesc=$p($g(^CTLOC(+tDeptId)),"^",2)
	set Data=$lb(tancoId,tancoDesc,tspeedUnitId,tspeedUnitDesc,tuomId,tuomtDesc,tdensity,tqty,tprepareVolume,tabbreviate,tdefSpeed,tViewSuperCatIDT,tViewSuperCatDescT,tViewCatIDT,tViewCatDescT,tarcimIDT,tarcimDescT,toeoriNoteT,tDeptId,tDeptDesc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
Output5
	s tDeptDesc=$p($g(^CTLOC(+tDeptId)),"^",2)
	set Data=$lb(tancoId,tancoDesc,tspeedUnitId,tspeedUnitDesc,tuomId,tuomtDesc,tdensity,tqty,tprepareVolume,tabbreviate,tdefSpeed,tViewSuperCatIDT,tViewSuperCatDescT,tViewCatIDT,tViewCatDescT,tarcimIDT,tarcimDescT,toeoriNoteT,tDeptId,tDeptDesc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
Output7
	s tDeptDesc=$p($g(^CTLOC(+tDeptId)),"^",2)
	set Data=$lb(tancoId,tancoDesc,tspeedUnitId,tspeedUnitDesc,tuomId,tuomtDesc,tdensity,tqty,tprepareVolume,tabbreviate,tdefSpeed,tViewSuperCatIDT,tViewSuperCatDescT,tViewCatIDT,tViewCatDescT,tarcimIDT,tarcimDescT,toeoriNoteT,tDeptId,tDeptDesc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUOrdMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUOrdMapExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindICUOrdMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUOrdMapExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindViewCat(ViewCat As %String, ViewSuperCat As %String) As %Query(ROWSPEC = "ARCICatDesc:%String,RowId:%String") [ SqlProc ]
{
}

ClassMethod FindViewCatExecute(ByRef qHandle As %Binary, ViewCat As %String, ViewSuperCat As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=0
	f  s RowId=$o(^ARC("IC",RowId))  q:RowId=""  d
	.s ARCICatID=$p(^ARC("IC",RowId),"^",1)
	.s ARCICatDesc=$p(^ARC("IC",RowId),"^",2)
	.s ARCViewSuperCatID=$p(^ARC("IC",RowId),"^",8)
	.i (ViewCat'="")&&((ViewCat=RowId)||(ARCICatDesc[ViewCat))&&(ViewSuperCat'="")&&(ViewSuperCat=ARCViewSuperCatID) d OutputRow2
	.i (ViewCat'="")&&((ViewCat=RowId)||(ARCICatDesc[ViewCat))&&(ViewSuperCat="") d OutputRow2
	.i (ViewCat="")&&(ViewSuperCat'="")&&(ViewSuperCat=ARCViewSuperCatID) d OutputRow2
	.i (ViewCat="")&&(ViewSuperCat="") d OutputRow2	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(ARCICatDesc,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindViewCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindViewCatExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindViewCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindViewCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindOrcItmMast(OrcItmMast As %String, ViewCat As %String) As %Query(ROWSPEC = "ARCIMastDesc:%String,ARCIMastRowID:%String") [ SqlProc ]
{
}

ClassMethod FindOrcItmMastExecute(ByRef qHandle As %Binary, OrcItmMast As %String, ViewCat As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ARCIMastRowID=""
	s RowId=0,subID=0
	f  s RowId=$o(^ARCIM(RowId)) q:RowId=""  d
	.f  s subID=$o(^ARCIM(RowId,subID)) q:subID=""  d
	  ..s ARCIMastDesc=$p(^ARCIM(RowId,subID,1),"^",2)
	  ..s ARCViewCatID=$p(^ARCIM(RowId,subID,1),"^",10)	  
	  ..s ARCIMastRowID=RowId_"||"_subID
	  ..i (OrcItmMast'="")&&((OrcItmMast=ARCIMastRowID)||(ARCIMastDesc[OrcItmMast))&&(ViewCat'="")&&(ViewCat=ARCViewCatID) d OutputRow3
	  ..i (OrcItmMast'="")&&((OrcItmMast=ARCIMastRowID)||(ARCIMastDesc[OrcItmMast))&&(ViewCat'="") d OutputRow3
	  ..i (OrcItmMast="")&&(ViewCat'="")&&(ViewCat=ARCViewCatID) d OutputRow3
	  ..i (OrcItmMast="")&&(ViewCat="") d OutputRow3	  	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(ARCIMastDesc,ARCIMastRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOrcItmMastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrcItmMastExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOrcItmMastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrcItmMastExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindCommonOrd(CommonOrd As %String, ViewCat As %String) As %Query(ROWSPEC = "ComOrdRowDesc:%String,rowid:%String") [ SqlProc ]
{
}

ClassMethod FindCommonOrdExecute(ByRef qHandle As %Binary, CommonOrd As %String, ViewCat As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	s rowid=0
	f  s rowid=$o(^DHCICUC("RecordItem",rowid)) q:rowid=""  d	 
	  .s ComOrdRowDesc=$p($g(^DHCICUC("RecordItem",rowid)),"^",2)
	  .s ANCEViewCatId=$p($g(^DHCICUC("RecordItem",rowid)),"^",5)	
	  .i (CommonOrd'="")&&((CommonOrd=rowid)||(ComOrdRowDesc[CommonOrd))&&(ViewCat'="")&&(ViewCat=ANCEViewCatId) d OutputRow4
	  .i (CommonOrd'="")&&((CommonOrd=rowid)||(ComOrdRowDesc[CommonOrd))&&(ViewCat'="") d OutputRow4
	  .i (CommonOrd="")&&(ViewCat'="")&&(ViewCat=ANCEViewCatId) d OutputRow4
	  .i (CommonOrd="")&&(ViewCat="") d OutputRow4	  	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(ComOrdRowDesc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCommonOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCommonOrdExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCommonOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCommonOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query Findspeedunit(OrcItmMast As %String, ViewCat As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
  select ICUCSU_Desc As ANCSUDesc,%ID As ANCSURowId From SQLUSER.DHC_ICUC_SpeedUnit
}

Query FindUom(OrcItmMast As %String, ViewCat As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	
 select CTUOM_Desc As ANCSUDesc,%ID As ANCSURowId From SQLUSER.ct_uom
}

}
