Import SQLUser

Class web.DHCBPCConsumable Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPCConsumable","FindConsumable")
Query FindConsumable() As %Query(ROWSPEC = "tID:%String,tBPCCCode:%String,tBPCCDesc:%String,tBPCCType:%String,tBPCCTypeD:%String,tBPCCMembraneArea:%Float,tBPCCHighFluxed:%String,tBPCCHighFluxedD:%String,tBPCCArcimDr:%String,tBPCCArcim:%String,tBPCBPMRowId:%String,tBPCBPMDesc:%String,tBPCBPMDept:%String,tBPCBPMDeptDr:%String")
{
}

ClassMethod FindConsumableExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tID=0
	f  s tID=$o(^DHCBPC("Consumable",tID)) q:tID=""  d
		.s tBPCCArcimDr="",tBPCCArcim=""
	    .s tBPCCCode=$lg(^DHCBPC("Consumable",tID),1)
	    .s tBPCCDesc=$lg(^DHCBPC("Consumable",tID),2)
	    .s tBPCCType=$lg(^DHCBPC("Consumable",tID),3)
	    .s tBPCCTypeD=""
	    .s:tBPCCType="D" tBPCCTypeD="透析器"
	    .s:tBPCCType="F" tBPCCTypeD="滤过器"
	    .s:tBPCCType="P" tBPCCTypeD="灌流器"
	    .s:tBPCCType="S" tBPCCTypeD="分离器"
	    .s:tBPCCType="O" tBPCCTypeD="其他"
	    .s tBPCCMembraneArea=$lg(^DHCBPC("Consumable",tID),4)
	    .s tBPCCHighFluxed=$lg(^DHCBPC("Consumable",tID),5)
	    .s:tBPCCHighFluxed="1" tBPCCHighFluxedD="是"
	    .s:tBPCCHighFluxed="0" tBPCCHighFluxedD="否"
 		.s tBPCBPMRowId=""
 		.s tBPCBPMDesc=""
		.s retStr=..GetModeByConsumableID(tID)
		.i retStr'="" d  
		..s tBPCBPMRowId=$p(retStr,"/",1)
		..s tBPCBPMDesc=$p(retStr,"/",2)
		..s tBPCBPMDeptDr=$p(retStr,"/",3)
		..s tBPCBPMDept=""
		..i tBPCBPMDeptDr'="" s tBPCBPMDept=$p(^CTLOC(tBPCBPMDeptDr),"^",2)
	    .s tBPCCArcimDr=$lg(^DHCBPC("Consumable",tID),6)
	    .i $l(tBPCCArcimDr,"||")>1 s tBPCCArcim=$p(^ARCIM($p(tBPCCArcimDr,"||",1),$p(tBPCCArcimDr,"||",2),1),"^",2)
	    .d OutputRow1
	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tID,tBPCCCode,tBPCCDesc,tBPCCType,tBPCCTypeD,tBPCCMembraneArea,tBPCCHighFluxed,tBPCCHighFluxedD,tBPCCArcimDr,tBPCCArcim,tBPCBPMRowId,tBPCBPMDesc,tBPCBPMDept,tBPCBPMDeptDr)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindConsumableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindConsumableExecute ]
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

ClassMethod FindConsumableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindConsumableExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// d ##class(web.DHCBPCConsumable).InsertConsumable("aa","描述1","O",10,"1","2||1")
ClassMethod InsertConsumable(bpcCCode As %String, bpcCDesc As %String, bpcCType As %String, bpcCMembraneArea As %Float, bpcCHighFluxed As %Boolean, bpcCArcimDr As %String)
{
	k PLIST
	TSTART
    s PLIST(2)=bpcCCode
	s PLIST(3)=bpcCDesc
	s PLIST(4)=bpcCType
	s PLIST(5)=bpcCMembraneArea
	s PLIST(6)=bpcCHighFluxed
	s PLIST(7)=bpcCArcimDr	
	&SQL(insert into DHC_BPC_Consumable values:PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
    TCOMMIT
	q SQLCODE
}

/// d ##class(web.DHCBPCConsumable).UpdateConsumable(29,"aabb","描述1","O",10,"1","6||1","1,5,12")
ClassMethod UpdateConsumable(bpcCId As %String, bpcCCode As %String, bpcCDesc As %String, bpcCType As %String, bpcCMembraneArea As %Float, bpcCHighFluxed As %Boolean, bpcCArcimDr As %String)
{
	//s ^Tempwq("0823")=bpcCId_"^"_bpcCCode_"^"_bpcCDesc_"^"_bpcCType_"^"_bpcCMembraneArea_"^"_bpcCHighFluxed_"^"_bpcCArcimDr_"^"_bpcMDrList_"^"_bpLocIdList
	q:bpcCId="" "ID不能为空"
	s $zt="Error"
	K PLIST	
	TSTART	
    s PLIST(1)=bpcCId
    s PLIST(2)=bpcCCode
	s PLIST(3)=bpcCDesc
	s PLIST(4)=bpcCType
	s PLIST(5)=bpcCMembraneArea
	s PLIST(6)=bpcCHighFluxed
	s PLIST(7)=bpcCArcimDr
	&SQL(update DHC_BPC_Consumable values:PLIST() where ID=:bpcCId)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}		
    TCOMMIT
	q SQLCODE
Error
	trollback
	quit "E^"_$ze
}

/// d ##class(web.DHCBPCConsumable).DeleteConsumable(29)
ClassMethod DeleteConsumable(bpcCId) As %String
{
	q:bpcCId="" "ID不能为空!"
	TSTART
	i bpcCId'=""  d
	.s Error=0
	.&SQL(delete from DHC_BPC_Consumable where %ID=:bpcCId)
	.s Error=SQLCODE
	.i Error'=0 TROLLBACK
	TCOMMIT
	q Error
}

Query FindCBoolen() As %Query(ROWSPEC = "Desc:%String,Id:%String")
{
}

ClassMethod FindCBoolenExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Id="1",Desc="是"
	d OutputRow1
	s Id="0",Desc="否"
	d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Desc,Id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCBoolenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCBoolenExecute ]
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

ClassMethod FindCBoolenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCBoolenExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindCType() As %Query(ROWSPEC = "Desc:%String,Id:%String")
{
}

ClassMethod FindCTypeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Id="D",Desc="透析器"
	d OutputRow1
	s Id="F",Desc="滤过器"
	d OutputRow1
	s Id="P",Desc="灌流器"
	d OutputRow1
	s Id="S",Desc="分离器"
	d OutputRow1
	s Id="O",Desc="其他"
	d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Desc,Id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTypeExecute ]
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

ClassMethod FindCTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPCConsumable","GetConsumableList")
/// 替换旧的SQL方法GetConsumableList，旧方法无法满足相关返回
Query GetConsumableList(locId As %String = "") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,ConsumableType:%String,ConsumableTypeDesc:%String,MembraneArea:%Float,HighFluxed:%Boolean,ArcimId:%String")
{
}

ClassMethod GetConsumableListExecute(ByRef qHandle As %Binary, locId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
 	s tID=0
	f  s tID=$o(^DHCBPC("Consumable",tID)) q:tID=""  d
	    .s tBPCCCode=$lg(^DHCBPC("Consumable",tID),1)
	    .s tBPCCDesc=$lg(^DHCBPC("Consumable",tID),2)
	    .s tBPCCType=$lg(^DHCBPC("Consumable",tID),3)
	    .s tBPCCTypeD=""
	    .s:tBPCCType="D" tBPCCTypeD="透析器"
	    .s:tBPCCType="F" tBPCCTypeD="滤过器"
	    .s:tBPCCType="P" tBPCCTypeD="灌流器"
	    .s:tBPCCType="S" tBPCCTypeD="分离器"
	    .s:tBPCCType="O" tBPCCTypeD="其他"
	    .s tBPCCMembraneArea=$lg(^DHCBPC("Consumable",tID),4)
	    .s tBPCCHighFluxed=$lg(^DHCBPC("Consumable",tID),5)
	    .s:tBPCCHighFluxed="1" tBPCCHighFluxedD="是"
	    .s:tBPCCHighFluxed="0" tBPCCHighFluxedD="否"
 		.s tBPCBPMRowId="",tBPCBPMDesc="",tBPCBPMDeptDr=""
		.s retStr=..GetModeByConsumableID(tID)
		.i retStr'="" d  
		..s tBPCBPMRowId=$p(retStr,"/",1)
		..s tBPCBPMDesc=$p(retStr,"/",2)
		..s tBPCBPMDeptDr=$p(retStr,"/",3)
		.q:(locIdList'="")&&(tBPCBPMDeptDr'="")&&(("^"_locIdList_"^")'[("^"_tBPCBPMDeptDr_"^"))
	    .s tBPCCArcimDr=$lg(^DHCBPC("Consumable",tID),6)
	    .i $l(tBPCCArcimDr,"||")>1 s tBPCCArcim=$p(^ARCIM($p(tBPCCArcimDr,"||",1),$p(tBPCCArcimDr,"||",2),1),"^",2)
	    .d OutputRow1
	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tID,tBPCCCode,tBPCCDesc,tBPCCType,tBPCCTypeD,tBPCCMembraneArea,tBPCCHighFluxed,tBPCCArcimDr)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetConsumableListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConsumableListExecute ]
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

ClassMethod GetConsumableListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConsumableListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/*
Query GetConsumableList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As Id,
	   BPCC_Code As Code,
	   BPCC_Desc As Description,
	   BPCC_Type As ConsumableType,
	   BPCC_MembraneArea As MembraneArea,
	   BPCC_HighFluxed As HighFluxed,
	   BPCC_Arcim_Dr As ArcimId
	   FROM DHC_BPC_Consumable
}
*/

// D ##class(%ResultSet).RunQuery("web.DHCBPCConsumable","GetConsumableListByBPModeId","1")

Query GetConsumableListByBPModeId(bpModeId, locId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT T1.%ID As Id,
       T1.BPCC_Code As Code,
       T1.BPCC_Desc As Description,
	   T1.BPCC_Type As ConsumableType,
	   T1.BPCC_MembraneArea As MembraneArea,
	   T1.BPCC_HighFluxed As HighFluxed,
	   T1.BPCC_Arcim_Dr As ArcimId
	   FROM DHC_BPC_Consumable T1,DHC_BPC_ModeConsumable T2 where T2.BPCMC_BPCMode_Dr=:bpModeId 
	   and ((T2.BPCMC_Ctloc_Dr=:locId) or (T2.BPCMC_Ctloc_Dr is null))
	   and T1.%ID=T2.BPCMC_BPCConsumable_Dr
}

/// 通过材料查找透析方式
/// w ##class(web.DHCBPCConsumable).GetModeByConsumableID("14")
ClassMethod GetModeByConsumableID(BPCConsumableID, hospId As %String = "") As %String
{
	q:BPCConsumableID="" ""
	s tMRowid=0,tMCRowid=0,tBPCCDr="",retMId="",retMDesc="",retloc=""
	f  s tMRowid=$o(^DHCBPC("ModeConsumable",0,"Mode",tMRowid)) q:tMRowid=""  d
	.s flag=0
	.f  s tMCRowid=$o(^DHCBPC("ModeConsumable",0,"Mode",tMRowid,tMCRowid)) q:tMCRowid=""  d
	..s hospitalId=""
	..s DataAttributionDr=$lg(^DHCBPC("ModeConsumable",tMCRowid),5)
	..i DataAttributionDr'="" s hospitalId=$li(^DHCBPC("DataAttribution",DataAttributionDr),1)
	..q:((hospitalId'="")&(hospId'=hospitalId))
	..s tBPCCDr=$lg(^DHCBPC("ModeConsumable",tMCRowid),2)
	..q:(BPCConsumableID'="")&&(tBPCCDr'=BPCConsumableID)
    ..s tBPCBPMDesc=$lg($g(^DHCBPC("BloodPurificationMode",tMRowid)),2)
    ..i retMDesc="" s retMDesc=tBPCBPMDesc
    ..e  d  s retMDesc=retMDesc_","_tBPCBPMDesc
    
    ..;s ctlocdr=$lg($g(^DHCBPC("BloodPurificationMode",tMRowid)),4)
    ..s ctlocdr=$lg($g(^DHCBPC("ModeConsumable",tMCRowid)),4)
    ..i retloc="" s retloc=ctlocdr 
    ..;e  d   s retloc=retloc_","_ctlocdr
    ..;if ctlocdr'="" s ctloc=$P(^CTLOC(ctlocdr),"^",2)
    ..s flag=1
    .i flag=1  d
    ..i retMId="" s retMId=tMRowid
    ..e  d  s retMId=retMId_","_tMRowid
    q retMId_"/"_retMDesc_"/"_retloc
    //q retMId_"/"_retMDesc
}

/// d ##class(web.DHCBPCConsumable).InsertConsumableLoc()
ClassMethod InsertConsumableLoc(bpcCId, bpcMDrList, bpLocIdList = "", hospId As %String = "") As %String
{
	
	s Error=0
	s BPCMCQty=""
	i bpcMDrList'="" d
	f i=1:1:$l(bpcMDrList,",") q:Error'=0  d
	.s bpcMDr=$p(bpcMDrList,",",i)
	.f j=1:1:$l(bpLocIdList,",") q:Error'=0  d
	..s bpLocId=$p(bpLocIdList,",",j)
	..&SQL(insert into DHC_BPC_ModeConsumable(BPCMC_BPCMode_Dr,BPCMC_BPCConsumable_Dr,BPCMC_Qty,BPCMC_Ctloc_Dr) Values(:bpcMDr,:bpcCId,:BPCMCQty,:bpLocId))
	..s Error=SQLCODE
	..s DataRowId=%ROWID
	..i ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPCModeConsumable") d
		...do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBPCModeConsumable",DataRowId,hospId)
	q:Error'=0 "数据保存失败!"	
	q Error
}

/// d ##class(web.DHCBPCConsumable).UpdateConsumableLoc()
ClassMethod UpdateConsumableLoc(bpcCId, bpcMDrList, bpLocIdList As %String = "", hospId As %String = "") As %String
{
	
	s oldbpLocIdList="",oldbpcMDrList=""
	s oldbpcMDrList=..GetModeByConsumableID(bpcCId,hospId)
	i oldbpcMDrList'="" s oldbpcMDrList=$p(oldbpcMDrList,"/",1)
	i oldbpcMDrList'="" s oldbpLocIdList=$p(oldbpcMDrList,"/",3)	
	b ;1
	s Error=0
	s BPCMCQty=""	
	i oldbpcMDrList'="" d  //edit mfc 20191220
	.f i=1:1:$l(oldbpcMDrList,",") q:Error'=0  d
	..s oldbpcMDr=$p(oldbpcMDrList,",",i)
	..i ((","_bpcMDrList_",")'[(","_oldbpcMDr_","))  d
		...&SQL(delete from DHC_BPC_ModeConsumable where BPCMC_BPCMode_Dr=:oldbpcMDr and BPCMC_BPCConsumable_Dr=:bpcCId )
		...s Error=SQLCODE
		...s DataRowId=%ROWID
		...i ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPCModeConsumable") d
			....do ##class(web.DHCBPCTablePermission).UnbindAttribution("User.DHCBPCModeConsumable",DataRowId)
	.f j=1:1:$l(bpcMDrList,",")  d
	..s bpcMDr=$p(bpcMDrList,",",j)
	..s bpLocId=bpLocIdList
	..i (","_oldbpcMDrList_",")[(","_bpcMDr_",") d
		...s flag=1 
		...&SQL(update DHC_BPC_ModeConsumable(BPCMC_BPCMode_Dr,BPCMC_BPCConsumable_Dr,BPCMC_Qty,BPCMC_Ctloc_Dr) Values(:bpcMDr,:bpcCId,:BPCMCQty,:bpLocId) where BPCMC_BPCMode_Dr=:bpcMDr and BPCMC_BPCConsumable_Dr=:bpcCId )
		...s Error=SQLCODE
	..e  d
		...&SQL(insert into DHC_BPC_ModeConsumable(BPCMC_BPCMode_Dr,BPCMC_BPCConsumable_Dr,BPCMC_Qty,BPCMC_Ctloc_Dr) Values(:bpcMDr,:bpcCId,:BPCMCQty,:bpLocId))
		...s Error=SQLCODE
		...s DataRowId=%ROWID
		...i ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPCModeConsumable") d
			....do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBPCModeConsumable",DataRowId,hospId)
	q:Error'=0 "数据修改失败!"
	q Error
}

/// d ##class(web.DHCBPCConsumable).DeleteConsumableLoc()
ClassMethod DeleteConsumableLoc(bpcCId) As %String
{
	q:bpcCId="" "ID不能为空!"
	s Error=0
	&SQL(delete from DHC_BPC_ModeConsumable where BPCMC_BPCConsumable_Dr=:bpcCId)
	s Error=SQLCODE
	q:Error'=0 "数据删除失败!"
	s DataRowId=%ROWID
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPCModeConsumable")
	{
		do ##class(web.DHCBPCTablePermission).UnbindAttribution("User.DHCBPCModeConsumable",DataRowId)
    }
	q Error
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPCConsumable","FindConsumable")
Query FindConsumableLoc(hospId As %String = "") As %Query(ROWSPEC = "tCID:%String,tBPCCCode:%String,tBPCCDesc:%String,tBPCBPMRowId:%String,tBPCBPMDesc:%String,tBPCBPMDept:%String,tBPCBPMDeptDr:%String")
{
}

ClassMethod FindConsumableLocExecute(ByRef qHandle As %Binary, hospId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tCID=0
	f  s tCID=$o(^DHCBPC("Consumable",tCID)) q:tCID=""  d		
		.s tBPCCArcimDr="",tBPCCArcim=""
	    .s tBPCCCode=$lg(^DHCBPC("Consumable",tCID),1)
	    .s tBPCCDesc=$lg(^DHCBPC("Consumable",tCID),2)
 		.s tBPCBPMRowId=""
 		.s tBPCBPMDesc=""
		.s retStr=..GetModeByConsumableID(tCID,hospId)
		.q:$p(retStr,"/",1)=""
		.i retStr'="" d  
		..s tBPCBPMRowId=$p(retStr,"/",1)
		..s tBPCBPMDesc=$p(retStr,"/",2)
		..s tBPCBPMDeptDr=$p(retStr,"/",3)
		..s tBPCBPMDept=""
		..i tBPCBPMDeptDr'="" s tBPCBPMDept=$p(^CTLOC(tBPCBPMDeptDr),"^",2)
	    .d OutputRow1
	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tCID,tBPCCCode,tBPCCDesc,tBPCBPMRowId,tBPCBPMDesc,tBPCBPMDept,tBPCBPMDeptDr)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindConsumableLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindConsumableLocExecute ]
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

ClassMethod FindConsumableLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindConsumableLocExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
