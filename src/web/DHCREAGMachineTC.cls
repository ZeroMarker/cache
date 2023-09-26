Class web.DHCREAGMachineTC Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 75;

ClassMethod SaveTCReagent(machine As %String, TC As %String, ReagDr As %String, lot As %String, quantity As %String) As %String
{
	s ^TMP($zn,"SaveTC","para")=machine_","_TC_","_ReagDr_","_lot_","_quantity
	s id=""
	s TestCodeIndex=" "_TC
	//i $d(^lab.DHCCTMachineTCI("MasterIndex",machine)),$d(^lab.DHCCTMachineTCI("MasterIndex",machine,TestCodeIndex)),$d(^lab.DHCCTMachineTCI("MasterIndex",machine,TestCodeIndex,ReagDr)) d
	//.s id=$o(^lab.DHCCTMachineTCI("MasterIndex",machine,TestCodeIndex,ReagDr,""))
	s RowId=""
	&sql(select ID into :RowId from lab.DHCCTMachineTC where ParRef=:machine and TC=:TC and ReagentDR=:ReagDr)
	i $l(RowId) &sql(update lab.DHCCTMachineTC set LotNoDR=:lot,Quantity=:quantity where ID=:RowId)
	i '$l(RowId) &sql(insert into lab.DHCCTMachineTC(ParRef,TC,ReagentDR,LotNoDR,Quantity) Values(:machine,:TC,:ReagDr,:lot,:quantity))
	q SQLCODE
}

ClassMethod GetTestCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTestCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTestCodeExecute(ByRef qHandle As %Binary, depart As %String, machine As %String) As %Status
{
	s depart=$g(depart),machine=$g(machine)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMP($zn,$j)
	//取得有通道号的项目
	s chl="" f  s chl=$o(^TMIF(machine,3,chl)) q:chl=""  d
	.s tc="" f  s tc=$o(^TMIF(machine,3,chl,tc)) q:tc=""  d
	..//^lab.DHCCTMachineTCI("MasterIndex","ALX20"," A1002",203,1)=
	..s tcIndex=" "_tc
	..s TCName=""
	..i $l(tc),$d(^TTAB("TC",tc)) s TCName=$p(^TTAB("TC",tc),"\",1)
	..s ^TMP($zn,$j,"tc",tc)=TCName
	..//
	..s reagId="" f  s reagId=$o(^lab.DHCCTMachineTCI("MasterIndex",machine,tcIndex,reagId)) q:reagId=""  d
	...s (reag,PackageName,lot,LotDr,quan,UnitName,GrpName,ManuName)=""
	...s id=""
	...i $l(reagId) s id=$o(^lab.DHCCTMachineTCI("MasterIndex",machine,tcIndex,reagId,""))
	...//^lab.DHCCTMachineD("ALX20","TC",1)=<<$LB("","A1002","203","",".1")>>
	...i $l(id) d
	....s str=$g(^lab.DHCCTMachineD(machine,"TC",id))
	....s (reag,PackageName,UnitName,GrpName,LotDr)=""
	....s ShowSeq=999
	....i $d(^lab.DHCCTReagentD(reagId)) d
	.....s reag=$li(^lab.DHCCTReagentD(reagId),3)
	.....s PackageName=$li(^lab.DHCCTReagentD(reagId),4)
	.....//s UnitDr=$li(^lab.DHCCTReagentD(reagId),5)
	.....s UnitName=$li(^lab.DHCCTReagentD(reagId),24)
	.....s GrpId=$li(^lab.DHCCTReagentD(reagId),6)
	.....s ManuDR=$li(^lab.DHCCTReagentD(reagId),14)
	.....s ShowSeq=+$li(^lab.DHCCTReagentD(reagId),18)
	....i ShowSeq=0 s ShowSeq=999
	....//i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	....i $l(GrpId),$d(^lab.DHCCTGroupTypeD(GrpId)) s GrpName=$li(^lab.DHCCTGroupTypeD(GrpId),3)
	....//i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	....i $l(ManuDR),$d(^lab.DHCCTManufacturerD(ManuDR))  s ManuName=$li(^lab.DHCCTManufacturerD(ManuDR),3)
	....s LotDr=$li(str,6)
	....s lot=""
	....i $l(LotDr),LotDr,$d(^lab.DHCREAGStockD($p(LotDr,"||",1),"Items",$p(LotDr,"||",2))) s lot=$li(^lab.DHCREAGStockD($p(LotDr,"||",1),"Items",$p(LotDr,"||",2)),2)
	....i '$l(lot) s lot=$li(str,4)
	....//
	....s quan=$li(str,5)
	...s StkId=""
	...i $l(reagId) s StkId=$o(^lab.DHCREAGStockI("MasterIndex",depart,reagId,""))
	...i $d(^TMP($zn,$j,"tc",tc)) k ^TMP($zn,$j,"tc",tc)
	...s RowId=machine_"||"_id
	...set Data=$lb(RowId,TCName,reag,PackageName,lot,quan,UnitName,ManuName,GrpName,tc,reagId,StkId,LotDr)
	...s ^TMP($zn,$j,"LIST",tc,ShowSeq,reag)=Data
	...//d OutputData
	s tc="" f  s tc=$o(^TMP($zn,$j,"tc",tc)) q:tc=""  d
	.s TCName=^(tc)
	.s (RowId,reag,PackageName,lot,quan,UnitName,ManuName,GrpName,reagId,StkId,LotDr)=""
	.s ShowSeq=1
	.set Data=$lb(RowId,TCName,reag,PackageName,lot,quan,UnitName,ManuName,GrpName,tc,reagId,StkId,LotDr)
	.s ^TMP($zn,$j,"LIST",tc,ShowSeq,1)=Data
	.//d OutputData
	s itm="" f  s itm=$o(^TMP($zn,$j,"LIST",itm)) q:itm=""  d
	.s seq="" f  s seq=$o(^TMP($zn,$j,"LIST",itm,seq)) q:seq=""  d
	..s reag="" f  s reag=$o(^TMP($zn,$j,"LIST",itm,seq,reag)) q:reag=""  d
	...s Data=^(reag)
	...d OutputData
	k ^TMP($zn,$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputData
	//set Data=$lb(RowId,TCName,reag,PackageName,lot,quan,UnitName,ManuName,GrpName,tc,reagId,StkId,LotDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTestCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTestCodeExecute ]
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
Query GetTestCode(depart As %String, machine As %String) As %Query(ROWSPEC = "RowId:%String,TC:%String,Reagent:%String,PackageName:%String,LotNo:%String,Quantity:%String,UnitName:%String,ManuName:%String,GrpName:%String,TestCode:%String,ReagDr:%String,StkId:%String,LotDr:%String")
{
}

ClassMethod GetMachineTCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMachineTCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMachineTCExecute(ByRef qHandle As %Binary, depart As %String, machine As %String) As %Status
{
	s depart=$g(depart),machine=$g(machine)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMP($zn,$j)
	//取得有通道号的项目
	s chl="" f  s chl=$o(^TMIF(machine,3,chl)) q:chl=""  d
	.s tc="" f  s tc=$o(^TMIF(machine,3,chl,tc)) q:tc=""  d
	..s TCName=""
	..i $l(tc),$d(^TTAB("TC",tc)) s TCName=$p(^TTAB("TC",tc),"\",1)
	..s ^TMP($zn,$j,"tc",tc)=TCName
	..s tcIndex=" "_tc
	..i '$d(^lab.DHCCTMachineTCI("MasterIndex",machine,tcIndex)) q
	..k ^TMP($zn,$j,"tc",tc)
	..d OutputTC
	s tc="" f  s tc=$o(^TMP($zn,$j,"tc",tc)) q:tc=""  d
	.s TCName=^(tc)
	.d OutputTC
	k ^TMP($zn,$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTC
	set Data=$lb(TCName,tc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMachineTCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMachineTCExecute ]
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
/// Description:： 查询仪器关联项目
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetMachineTC(depart As %String, machine As %String) As %Query(ROWSPEC = "ItemName:%String,ItemCode:%String")
{
}

ClassMethod GetReagentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReagentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetReagentExecute(ByRef qHandle As %Binary, depart As %String, machine As %String, tc As %String) As %Status
{
	s depart=$g(depart),machine=$g(machine),ts=$g(ts)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCCTMachineTSI("MasterIndex","AGENS"," A001",800,4)=
    s tcIndex=" "_tc
    s reagId="" f  s reagId=$o(^lab.DHCCTMachineTCI("MasterIndex",machine,tcIndex,reagId)) q:reagId=""  d
	.s (reag,PackageName,lot,LotDr,quan,UnitName,GrpName,ManuName)=""
	.s id=""
	.i $l(reagId) s id=$o(^lab.DHCCTMachineTCI("MasterIndex",machine,tcIndex,reagId,""))
	.i '$l(id) q
	.s str=$g(^lab.DHCCTMachineD(machine,"TC",id))
	.s (reag,PackageName,UnitName,GrpName,LotDr)=""
	.i $d(^lab.DHCCTReagentD(reagId)) d
	..s reag=$li(^lab.DHCCTReagentD(reagId),3)
	..s PackageName=$li(^lab.DHCCTReagentD(reagId),4)
	..//s UnitDr=$li(^lab.DHCCTReagentD(reagId),5)
	..s GrpId=$li(^lab.DHCCTReagentD(reagId),6)
	..s ManuDR=$li(^lab.DHCCTReagentD(reagId),14)
	..s UnitName=$li(^lab.DHCCTReagentD(reagId),24)
	.//i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	.i $l(GrpId),$d(^lab.DHCCTGroupTypeD(GrpId)) s GrpName=$li(^lab.DHCCTGroupTypeD(GrpId),3)
	.//i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	.i $l(ManuDR),$d(^lab.DHCCTManufacturerD(ManuDR))  s ManuName=$li(^lab.DHCCTManufacturerD(ManuDR),3)
	.s LotDr=$li(str,6)
	.s lot=""
	.i $l(LotDr),LotDr,$d(^lab.DHCREAGStockD($p(LotDr,"||",1),"Items",$p(LotDr,"||",2))) s lot=$li(^lab.DHCREAGStockD($p(LotDr,"||",1),"Items",$p(LotDr,"||",2)),2)
	.i '$l(lot) s lot=$li(str,4)
	.//
	.s quan=$li(str,5)
	.s StkId=""
	.i $l(reagId) s StkId=$o(^lab.DHCREAGStockI("MasterIndex",depart,reagId,""))
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
Query GetReagent(depart As %String, machine As %String, tc As %String) As %Query(ROWSPEC = "RowId:%String,Reagent:%String,PackageName:%String,LotNo:%String,Quantity:%String,UnitName:%String,ManuName:%String,GrpName:%String,ReagDr:%String,StkId:%String,LotDr:%String,GroupId:%String")
{
}

}
