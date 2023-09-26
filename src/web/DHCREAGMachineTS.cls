Class web.DHCREAGMachineTS Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 66;

ClassMethod SaveTSReagent(machine As %String, TS As %String, ReagDr As %String, lot As %String, quantity As %String) As %String
{
	s ^TMP($zn,"SaveTS","para")=machine_","_TS_","_ReagDr_","_lot_","_quantity
	s id=""
	s TestCodeIndex=" "_TS
	i $d(^lab.DHCCTMachineTSI("MasterIndex",machine)),$d(^lab.DHCCTMachineTSI("MasterIndex",machine,TestCodeIndex)),$d(^lab.DHCCTMachineTSI("MasterIndex",machine,TestCodeIndex,ReagDr)) d
	.s id=$o(^lab.DHCCTMachineTSI("MasterIndex",machine,TestCodeIndex,ReagDr,""))
	s RowId=""
	&sql(select ID into :RowId from lab.DHCCTMachineTS where ParRef=:machine and TS=:TS and ReagentDR=:ReagDr)
	i $l(RowId) &sql(update lab.DHCCTMachineTS set LotNoDR=:lot,Quantity=:quantity where ID=:RowId)
	i '$l(RowId) &sql(insert into lab.DHCCTMachineTS(ParRef,TS,ReagentDR,LotNoDR,Quantity) Values(:machine,:TS,:ReagDr,:lot,:quantity))
	q SQLCODE
}

ClassMethod GetTestSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTestSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTestSetExecute(ByRef qHandle As %Binary, depart As %String, machine As %String) As %Status
{
	s depart=$g(depart),machine=$g(machine)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMP($zn,$j)
	//取得有通道号的医嘱^TMIF("AGENS",0,"A122","GENS")=
    s ts="" f  s ts=$o(^TMIF(machine,0,ts)) q:ts=""  d
    .s tsIndex=" "_ts
	.s TSName=""
	.i $l(ts),$d(^TTAB("TS",ts)) s TSName=$p(^TTAB("TS",ts),"\",1)
	.s ^TMP($zn,$j,"ts",ts)=TSName
	.//^lab.DHCCTMachineTCI("MasterIndex","ALX20"," A1002",203,1)=
	.s reagId="" f  s reagId=$o(^lab.DHCCTMachineTSI("MasterIndex",machine,tsIndex,reagId)) q:reagId=""  d
	..s (reag,PackageName,lot,LotDr,quan,UnitName,GrpName,ManuName)=""
	..s id=""
	..i $l(reagId) s id=$o(^lab.DHCCTMachineTSI("MasterIndex",machine,tsIndex,reagId,""))
	..i '$l(id) q
	..s str=$g(^lab.DHCCTMachineD(machine,"TS",id))
	..s (reag,PackageName,UnitName,GrpName,LotDr)=""
	..i $d(^lab.DHCCTReagentD(reagId)) d
	...s reag=$li(^lab.DHCCTReagentD(reagId),3)
	...s PackageName=$li(^lab.DHCCTReagentD(reagId),4)
	...s UnitDr=$li(^lab.DHCCTReagentD(reagId),5)
	...s GrpId=$li(^lab.DHCCTReagentD(reagId),6)
	...s ManuDR=$li(^lab.DHCCTReagentD(reagId),14)
	...s UnitName=$li(^lab.DHCCTReagentD(reagId),24)
	..//i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	..i $l(GrpId),$d(^lab.DHCCTGroupTypeD(GrpId)) s GrpName=$li(^lab.DHCCTGroupTypeD(GrpId),3)
	..//i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	..i $l(ManuDR),$d(^lab.DHCCTManufacturerD(ManuDR))  s ManuName=$li(^lab.DHCCTManufacturerD(ManuDR),3)
	..s LotDr=$li(str,6)
	..s lot=""
	..i $l(LotDr),LotDr,$d(^lab.DHCREAGStockD($p(LotDr,"||",1),"Items",$p(LotDr,"||",2))) s lot=$li(^lab.DHCREAGStockD($p(LotDr,"||",1),"Items",$p(LotDr,"||",2)),2)
	..i '$l(lot) s lot=$li(str,4)
	..//
	..s quan=+$li(str,5)
	..i +quan<1 s quan="0"_quan
	..s StkId=""
	..i $l(reagId) s StkId=$o(^lab.DHCREAGStockI("MasterIndex",depart,reagId,""))
	..i $d(^TMP($zn,$j,"ts",ts)) k ^TMP($zn,$j,"ts",ts)
	..s RowId=machine_"||"_id
	..d OutputData
	s ts="" f  s ts=$o(^TMP($zn,$j,"ts",ts)) q:ts=""  d
	.s TSName=^(ts)
	.s (RowId,reag,PackageName,lot,quan,UnitName,ManuName,GrpName,reagId,StkId,LotDr)=""
	.d OutputData
	k ^TMP($zn,$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputData
	set Data=$lb(RowId,TSName,reag,PackageName,lot,quan,UnitName,ManuName,GrpName,ts,reagId,StkId,LotDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTestSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTestSetExecute ]
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

/// Creator：      huhm
/// CreatDate：    20100823
/// Description:： 项目关联试剂查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetTestSet(depart As %String, machine As %String) As %Query(ROWSPEC = "RowId:%String,TS:%String,Reagent:%String,PackageName:%String,LotNo:%String,Quantity:%String,UnitName:%String,ManuName:%String,GrpName:%String,TestSet:%String,ReagDr:%String,StkId:%String,LotDr:%String")
{
}

ClassMethod GetReagentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReagentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetReagentExecute(ByRef qHandle As %Binary, depart As %String, machine As %String, ts As %String) As %Status
{
	s depart=$g(depart),machine=$g(machine),ts=$g(ts)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCCTMachineTSI("MasterIndex","AGENS"," A001",800,4)=
    s tsIndex=" "_ts
    s reagId="" f  s reagId=$o(^lab.DHCCTMachineTSI("MasterIndex",machine,tsIndex,reagId)) q:reagId=""  d
	.s (reag,PackageName,lot,LotDr,quan,UnitName,GrpName,ManuName)=""
	.s id=""
	.i $l(reagId) s id=$o(^lab.DHCCTMachineTSI("MasterIndex",machine,tsIndex,reagId,""))
	.i '$l(id) q
	.s str=$g(^lab.DHCCTMachineD(machine,"TS",id))
	.s (reag,PackageName,UnitName,GrpName,LotDr)=""
	.i $d(^lab.DHCCTReagentD(reagId)) d
	..s reag=$li(^lab.DHCCTReagentD(reagId),3)
	..s PackageName=$li(^lab.DHCCTReagentD(reagId),4)
	..//s UnitDr=$li(^lab.DHCCTReagentD(reagId),5)
	..s UnitName=$li(^lab.DHCCTReagentD(reagId),24)
	..s GrpId=$li(^lab.DHCCTReagentD(reagId),6)
	..s ManuDR=$li(^lab.DHCCTReagentD(reagId),14)
	.//i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	.i $l(GrpId),$d(^lab.DHCCTGroupTypeD(GrpId)) s GrpName=$li(^lab.DHCCTGroupTypeD(GrpId),3)
	.//i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	.i $l(ManuDR),$d(^lab.DHCCTManufacturerD(ManuDR))  s ManuName=$li(^lab.DHCCTManufacturerD(ManuDR),3)
	.s LotDr=$li(str,6)
	.s lot=""
	.i $l(LotDr),LotDr,$d(^lab.DHCREAGStockD($p(LotDr,"||",1),"Items",$p(LotDr,"||",2))) s lot=$li(^lab.DHCREAGStockD($p(LotDr,"||",1),"Items",$p(LotDr,"||",2)),2)
	.i '$l(lot) s lot=$li(str,4)
	.//
	.s quan=+$li(str,5)
	.i quan<1 s quan="0"_quan
	.s StkId=""
	.i $l(reagId) s StkId=$o(^lab.DHCREAGStockI("MasterIndex",depart,reagId,""))
	.i $d(^TMP($zn,$j,"ts",ts)) k ^TMP($zn,$j,"ts",ts)
	.s RowId=machine_"||"_id
	.d OutputReag
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputReag
	set Data=$lb(RowId,reag,PackageName,lot,quan,UnitName,ManuName,GrpName,reagId,StkId,LotDr,GrpId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMachineTSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMachineTSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMachineTSExecute(ByRef qHandle As %Binary, depart As %String, machine As %String) As %Status
{
	s depart=$g(depart),machine=$g(machine)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMP($zn,$j)
	//取得有通道号的医嘱^TMIF("AGENS",0,"A122","GENS")=
    s ts="" f  s ts=$o(^TMIF(machine,0,ts)) q:ts=""  d
	.s tsIndex=" "_ts
	.s TSName=""
	.i $l(ts),$d(^TTAB("TS",ts)) s TSName=$p(^TTAB("TS",ts),"\",1)
	.s ^TMP($zn,$j,"ts",ts)=TSName
	.i '$d(^lab.DHCCTMachineTSI("MasterIndex",machine,tsIndex)) q
	.k ^TMP($zn,$j,"ts",ts)
	.d OutputTS
	s ts="" f  s ts=$o(^TMP($zn,$j,"ts",ts)) q:ts=""  d
	.s TSName=^(ts)
	.d OutputTS
	k ^TMP($zn,$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTS
	set Data=$lb(TSName,ts)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMachineTSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMachineTSExecute ]
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

/// Creator：      huhm
/// CreatDate：    20100823
/// Description:： 查询仪器关联医嘱
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetMachineTS(depart As %String, machine As %String) As %Query(ROWSPEC = "ItemName:%String,ItemCode:%String")
{
}

ClassMethod GetReagentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReagentExecute ]
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

/// Creator：      huhm
/// CreatDate：    20100823
/// Description:： 查询医嘱关联试剂
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetReagent(depart As %String, machine As %String, ts As %String) As %Query(ROWSPEC = "RowId:%String,Reagent:%String,PackageName:%String,LotNo:%String,Quantity:%String,UnitName:%String,ManuName:%String,GrpName:%String,ReagDr:%String,StkId:%String,LotDr:%String,GroupId:%String")
{
}

}
