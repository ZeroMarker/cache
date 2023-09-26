Class web.DHCREAGStockOutItem Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 203;

ClassMethod QryStockOutItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStockOutItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryStockOutItemExecute(ByRef qHandle As %Binary, StockOutNo As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGStockInD(46,"Items",
	//<<$LB("","203","P900001","M04","61727","62041","10","330","","","","")>>
	//s StockOutId=$o(^lab.DHCREAGStockOutI("MasterIndex"," "_StockOutNo,""))
	Set qHandle=$lb(0,repid,0)
	i '$l(StockOutNo) Quit $$$OK
	s id="" f  s id=$o(^lab.DHCREAGStockOutI("MasterIndex"," "_StockOutNo,id)) q:id=""  d
	.i '$d(^lab.DHCREAGStockOutD(id)) q
	.s Depart=$li(^lab.DHCREAGStockOutD(id),4)
	.s subid="" f  s subid=$o(^lab.DHCREAGStockOutD(id,"Items",subid)) q:subid=""  d
	..s str=$g(^lab.DHCREAGStockOutD(id,"Items",subid))
	..s ReagentDR=$li(str,2)
	..s LotNo=$li(str,3)
	..s LotCnt=$li(str,4)
	..s MachineDr=$li(str,5)
	..s LabNo=$li(str,6)
	..s TestSetDr=$li(str,7)
	..s TestCodeDr=$li(str,8)
	..s Quantity=+$li(str,9)
	..s Price=+$li(str,10)
	..s PositionDR=$li(str,11)
	..s Remarks=$li(str,12)
	..//当前库存数
	..s CurStock=##Class(web.DHCREAGStockItem).GetStockQuantity(Depart,ReagentDR,LotNo,LotCnt)
	..///从试剂基本信息中得到单位规格和厂商
	..s PackageDr="",PackageName=""
	..s UnitDr="",UnitName=""
	..s ManufacturerDR="",PackageVol=1
	..i $d(^lab.DHCCTReagentD(ReagentDR)) d
	...s PackageName=$li(^lab.DHCCTReagentD(ReagentDR),4)
	...s UnitDr=$li(^lab.DHCCTReagentD(ReagentDR),5)
	...s ManufacturerDR=$li(^lab.DHCCTReagentD(ReagentDR),14)
	...///包装容量
	...s PackageVol=$li(^lab.DHCCTReagentD(ReagentDR),23)
	..i PackageVol=0 s PackageVol=1
	..//换算包装
	..s Quantity=$fn(Quantity/PackageVol,"",2)
	..s CurStock=$fn(CurStock/PackageVol,"",2)
	..s TotalPrices=$fn(Quantity*Price,"",2)
	..//i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	..i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	..///
	..s ReagentName=""
	..i $l(ReagentDR),$d(^lab.DHCCTReagentD(ReagentDR)) s ReagentName=$li(^lab.DHCCTReagentD(ReagentDR),3)
	..s ManufacturerName=""
	..//
	..i $l(ManufacturerDR),$d(^lab.DHCCTManufacturerD(ManufacturerDR)) s ManufacturerName=$li(^lab.DHCCTManufacturerD(ManufacturerDR),3)
	..s PositionName=""
	..i $l(PositionDR),$d(^lab.DHCCTPositionD(PositionDR)) s PositionName=$li(^lab.DHCCTPositionD(PositionDR),3)
	..s MachineName=""
	..i $l(MachineDr),$d(^lab.DHCCTMachineD(MachineDr)) s MachineName=$li(^lab.DHCCTMachineD(MachineDr),2)
	..s TS=""
	..i $l(TestSetDr),$d(^TTAB("TS",TestSetDr)) s TS=$p(^TTAB("TS",TestSetDr),"\",1)
	..s TC=""
	..i $l(TestCodeDr),$d(^TTAB("TC",TestCodeDr)) s TC=$p(^TTAB("TC",TestCodeDr),"\",1)
	..///从库存明细中得到生成日期和失效日期
	..s (ProductDate,ExpireDate)=""
	..s StkId=$o(^lab.DHCREAGStockI("MasterIndex",Depart,ReagentDR,""))
	..i $l(StkId) d
	...s LotNoIndex=$c(32)_$zcvt(LotNo,"U")
	...s SubId=$o(^lab.DHCREAGStockItemsI("MasterIndex",StkId,LotNoIndex,LotCnt,""))
	...i '$l(SubId) q
	...s LotStr=$g(^lab.DHCREAGStockD(StkId,"Items",SubId))
	...s ProductDate=$li(LotStr,4)
	...s ExpireDate=$li(LotStr,5)
	..i $l(ProductDate) s ProductDate=$zd(ProductDate,3)
	..i $l(ExpireDate) s ExpireDate=$zd(ExpireDate,3)
	..d OutputRow			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(subid,ReagentName,PackageName,LotNo,LotCnt,Quantity,UnitName,ManufacturerName,Price,TotalPrices,ExpireDate,ProductDate,PositionName,MachineName,LabNo,TS,TC,Remarks,CurStock,ReagentDR,ManufacturerDR,PositionDR,PackageDr,UnitDr,PackageVol)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryStockOutItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStockOutItemExecute ]
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
/// CreatDate：    20100521
/// Description:： 出库单明细查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryStockOutItem(StockOutNo As %String) As %Query(ROWSPEC = "ItemId:%String,ReagName:%String,PackageName:%String,LotNo:%String,LotCount:%String,Quantity:%String,UnitName:%String,ManuName:%String,Price:%String,SumPrice:%String,ExpireDate:%String,ProductDate:%String,Position:%String,Machine:%String,LabNo:%String,TS:%String,TC:%String,Remark:%String,CurStock:%String,ReagDr:%String,ManuDr:%String,PositionDr:%String,PackageDr:%String,UnitDr:%String,PackageVol:%String")
{
}

ClassMethod QryReagentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReagentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReagentExecute(ByRef qHandle As %Binary, Depart As %String, DateFrom As %String, DateTo As %String, reag As %String, group As %String, manu As %String, supplier As %String, machine As %String, type As %String) As %Status
{
	s Depart=$g(Depart)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMP($zn,$j)
	//^lab.DHCREAGStockOutI("CheckDateIndex","D01",61878,25)=
 	s DateFrom=$zdh(DateFrom,3)
 	s DateTo=$zdh(DateTo,3)
 	s reag=$g(reag),group=$g(group),manu=$g(manu),supplier=$g(supplier),machine=$g(machine)
 	i $l(machine) s machine=machine_","
 	s type=+$g(type)
 	b ;100
 	s date=DateFrom-1 f  s date=$o(^lab.DHCREAGStockOutI("CheckDateIndex",Depart,date)) q:(date=(DateTo+1))!(date="")  d
 	.s id="" f  s id=$o(^lab.DHCREAGStockOutI("CheckDateIndex",Depart,date,id)) q:id=""  d
 	..s RecStr=$g(^lab.DHCREAGStockOutD(id))
 	..i '$l(RecStr) q
 	..i $li(RecStr,11)'="A" q  //不是审核状态退出
 	..s OpTypeId=$li(RecStr,3)
 	..i OpTypeId="4" q //1:正常入库,3:试剂领用,2:正常出库,4:退货,5:报废,6:盘点
 	..i OpTypeId="5" q
 	..i OpTypeId="6" q
 	..s SuppId=$li(RecStr,5)
 	..s ChkUserId=$li(RecStr,10)
 	..s ChkUserName=""
 	..i $l(ChkUserId),$d(^lab.DHCCTUserD(ChkUserId)) s ChkUserName=$li(^lab.DHCCTUserD(ChkUserId),3)
 	..s StockOutNo=$li(RecStr,2)
 	..i type=0,OpTypeId=8 q   //0手工出库,8自动出库
 	..i type=1,OpTypeId'=8 q  //1 自动出库,8自动出库
 	..s OutType="" f  s OutType=$o(^lab.DHCREAGStockOutD(id,OutType)) q:OutType=""  d
 	...s subid="" f  s subid=$o(^lab.DHCREAGStockOutD(id,OutType,subid)) q:subid=""  d
 	....s ^TMP($zn,$j,"ID",id,OutType,subid)=""
 	b ;200
 	s id="" f  s id=$o(^TMP($zn,$j,"ID",id)) q:id=""  d
 	.s CheckDate=$li($g(^lab.DHCREAGStockOutD(id)),8)
 	.s StockOutNo=$li($g(^lab.DHCREAGStockOutD(id)),2)
 	.s ChkDate=""
 	.i '$l(CheckDate) q
 	.s ChkDate=$zd(CheckDate,3)
 	.s ChkTime=+$li($g(^lab.DHCREAGStockOutD(id)),9)
 	.s OutType="" f  s OutType=$o(^TMP($zn,$j,"ID",id,OutType)) q:OutType=""  d
 	..s subid="" f  s subid=$o(^TMP($zn,$j,"ID",id,OutType,subid)) q:subid=""  d
 	...s ItemStr=$g(^lab.DHCREAGStockOutD(id,OutType,subid))
 	...i '$l(ItemStr) q
 	...s ReagentDR=$li(ItemStr,2)
 	...i $l(reag),reag'=ReagentDR q //试剂
	...///
	...s (Reagent,PackageDr,PackageName,UnitDr,UnitName,GrpId,GrpName,ManufacturerDR,ManufacturerName)=""
	...s PackageVol=1
	...i $d(^lab.DHCCTReagentD(ReagentDR)) d
	....s Reagent=$li(^lab.DHCCTReagentD(ReagentDR),3)
	....s PackageName=$li(^lab.DHCCTReagentD(ReagentDR),4)
	....s UnitDr=$li(^lab.DHCCTReagentD(ReagentDR),5)
	....s GrpId=$li(^lab.DHCCTReagentD(ReagentDR),6)
	....s ManufacturerDR=$li(^lab.DHCCTReagentD(ReagentDR),14)
	....///包装容量
	....s PackageVol=$li(^lab.DHCCTReagentD(ReagentDR),23)
	....s Sequence=$li(^lab.DHCCTReagentD(ReagentDR),18)
	....s UnitName=$li(^lab.DHCCTReagentD(ReagentDR),24)
	...i PackageVol=0 s PackageVol=1
	...i $l(manu),manu'=ManufacturerDR q //厂商
	...i $l(group),group'=GrpId q //组别
	...//i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	...i $l(ManufacturerDR),$d(^lab.DHCCTManufacturerD(ManufacturerDR)) s ManufacturerName=$li(^lab.DHCCTManufacturerD(ManufacturerDR),3)
	...i $l(GrpId),$d(^lab.DHCCTGroupTypeD(GrpId)) s GrpName=$li(^lab.DHCCTGroupTypeD(GrpId),3)
	...///根据试剂和批号查询供应商,同一试剂和批号,默认为同一供应商
 	...s LotNo=$li(ItemStr,3)
 	...s LotCnt=$li(ItemStr,4)
 	...s LotNoIndex=$c(32)_$zcvt(LotNo,"U")
 	...s RecId=$o(^lab.DHCREAGStockInItemsI("LotNoIndex",ReagentDR,LotNoIndex,LotCnt,""))
 	...s SuppId=""
 	...i $l(RecId),$d(^lab.DHCREAGStockInD(RecId)) s SuppId=$li(^lab.DHCREAGStockInD(RecId),5)
 	...i $l(supplier),supplier'=SuppId q //供应商
 	...s SuppName=""
 	...i $l(SuppId),$d(^lab.DHCCTSupplierD(SuppId)) s SuppName=$li(^lab.DHCCTSupplierD(SuppId),3)
 	...//
 	...s MachId=$li(ItemStr,5)
 	...i $l(machine),'$l(MachId) q
 	...s MachList=MachId_","
 	...i $l(machine),machine'[MachList q //仪器
 	...s MachName=""
 	...i $l(MachId),$d(^lab.DHCCTMachineD(MachId)) s MachName=$li(^lab.DHCCTMachineD(MachId),3)
 	...s LabNo=$li(ItemStr,6)
 	...s TS=$li(ItemStr,7)
 	...s TSName=""
 	...i $l(TS),$d(^TTAB("TS",TS)) s TSName=$p(^TTAB("TS",TS),"\",1)
 	...s TC=$li(ItemStr,8)
 	...s TCName=""
 	...i $l(TC),$d(^TTAB("TC",TC)) s TCName=$p(^TTAB("TC",TC),"\",1)
 	...s Quantity=+$li(ItemStr,9)
	...i type=0 d
	....i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	....s Quantity=$fn(Quantity/PackageVol,"",3)
 	...//s Quantity=$fn(Quantity/PackageVol,"",3)
 	...s Quantity=$fn(Quantity,"",3)
 	...s OutPrice=+$li(ItemStr,10)
 	...s PositionDR=$li(ItemStr,11)
	...s PositionName=""
	...i $l(PositionDR),$d(^lab.DHCCTPositionD(PositionDR)) s PositionName=$li(^lab.DHCCTPositionD(PositionDR),3)
 	...s Remarks=$li(ItemStr,12)
 	...//
	...s TotalPrices=$fn(OutPrice*Quantity,"",3)
	...i '$l(Sequence) s Sequence="999"
	...set Data=$lb(id_"||"_subid,Reagent,PackageName,LotNo,ManufacturerName,Quantity,UnitName,OutPrice,TotalPrices,GrpName,PositionName,Remarks,StockOutNo,SuppName,ChkUserName,ChkDate,MachName,LabNo,TSName,TCName,PackageVol)
	...//s ^TMP($zn,$j,"LIST",CheckDate,ChkTime,Sequence,ReagentDR,id_"||"_subid)=Data
	...d OutputReag	
	/*
	s date="" f  s date=$o(^TMP($zn,$j,"LIST",date)) q:date=""  d
	.s time="" f  s time=$o(^TMP($zn,$j,"LIST",date,time)) q:time=""  d
	..s seq="" f  s seq=$o(^TMP($zn,$j,"LIST",date,time,seq)) q:seq=""  d
	...s reag="" f  s reag=$o(^TMP($zn,$j,"LIST",date,time,seq,reag)) q:reag=""  d
	....s id="" f  s id=$o(^TMP($zn,$j,"LIST",date,time,seq,reag,id)) q:id=""  d
	.....s Data=$g(^TMP($zn,$j,"LIST",date,time,seq,reag,id))
	.....d OutputReag
	*/
	k ^TMP($zn,$j)		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputReag
	set Data=$lb(id_"||"_subid,Reagent,PackageName,LotNo,ManufacturerName,Quantity,UnitName,OutPrice,TotalPrices,GrpName,PositionName,Remarks,StockOutNo,SuppName,ChkUserName,ChkDate,MachName,LabNo,TSName,TCName,PackageVol)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryReagentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReagentExecute ]
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
/// CreatDate：    20100617
/// Description:： 出库试剂查询
/// Table：       
/// Input：        type:0 手工出库,1 自动出库,2 所有
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryReagent(Depart As %String, DateFrom As %String, DateTo As %String, reag As %String, group As %String, manu As %String, supplier As %String, machine As %String, type As %String) As %Query(ROWSPEC = "ItemId:%String,ReagName:%String,PackageName:%String,LotNo:%String,ManuName:%String,Quantity:%String,UnitName:%String,Price:%String,SumPrice:%String,Group:%String,Position:%String,Remark:%String,StockOutNo:%String,Supplier:%String,CheckUser:%String,CheckDate:%String,MachName:%String,LabNo:%String,TS:%String,TC:%String,PackageVol:%String")
{
}

ClassMethod QryReagSummaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReagSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReagSummaryExecute(ByRef qHandle As %Binary, Depart As %String, DateFrom As %String, DateTo As %String, reag As %String, group As %String, manu As %String, supplier As %String, machine As %String, type As %String) As %Status
{
	s Depart=$g(Depart)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGStockInI("CheckDateIndex","D01",61867,6)=
 	s DateFrom=$zdh(DateFrom,3)
 	s DateTo=$zdh(DateTo,3)
 	s reag=$g(reag),group=$g(group),manu=$g(manu),supplier=$g(supplier),machine=$g(machine)
 	i $l(machine) s machine=machine_","
 	k ^TMP($zn,$j)
 	s date=DateFrom-1 f  s date=$o(^lab.DHCREAGStockOutI("CheckDateIndex",Depart,date)) q:(date=(DateTo+1))!(date="")  d
 	.s id="" f  s id=$o(^lab.DHCREAGStockOutI("CheckDateIndex",Depart,date,id)) q:id=""  d
 	..s RecStr=$g(^lab.DHCREAGStockOutD(id))
 	..i '$l(RecStr) q
 	..i $li(RecStr,11)'="A" q  //不是审核状态退出
 	..s OpTypeId=$li(RecStr,3)
 	..i OpTypeId="4" q //1:正常入库,3:试剂领用,2:正常出库,4:退货,5:报废,6:盘点
 	..i OpTypeId="5" q
 	..i OpTypeId="6" q
 	..s SuppId=$li(RecStr,5)
 	..s ChkUserId=$li(RecStr,10)
 	..s ChkUserName=""
 	..i $l(ChkUserId),$d(^lab.DHCCTUserD(ChkUserId)) s ChkUserName=$li(^lab.DHCCTUserD(ChkUserId),3)
 	..s ChkDate=$li(RecStr,8)
 	..i $l(ChkDate) s ChkDate=$zd(ChkDate,3)
 	..s StockOutNo=$li(RecStr,2)
 	..//
 	..i type=0,OpTypeId=8 q  //0手工出库,8自动出库
 	..i type=1,OpTypeId'=8 q //1 自动出库,8自动出库
 	..s OutType="" f  s OutType=$o(^lab.DHCREAGStockOutD(id,OutType)) q:OutType=""  d
 	...s subid="" f  s subid=$o(^lab.DHCREAGStockOutD(id,OutType,subid)) q:subid=""  d
 	....s ^TMP($zn,$j,"ID",id,OutType,subid)=""
 	s id="" f  s id=$o(^TMP($zn,$j,"ID",id)) q:id=""  d
 	.s OutType="" f  s OutType=$o(^TMP($zn,$j,"ID",id,OutType)) q:OutType=""  d
 	..s subid="" f  s subid=$o(^TMP($zn,$j,"ID",id,OutType,subid)) q:subid=""  d
 	...s ItemStr=$g(^lab.DHCREAGStockOutD(id,OutType,subid))
 	...i '$l(ItemStr) q
 	...s ReagentDR=$li(ItemStr,2)
 	...i $l(reag),reag'=ReagentDR q //试剂
	...///
	...s (GrpId,ManufacturerDR)=""
	...i $d(^lab.DHCCTReagentD(ReagentDR)) d
	....s GrpId=$li(^lab.DHCCTReagentD(ReagentDR),6)
	....s ManufacturerDR=$li(^lab.DHCCTReagentD(ReagentDR),14)
	....s sequence=$li(^lab.DHCCTReagentD(ReagentDR),18)
	...i $l(manu),manu'=ManufacturerDR q //厂商
	...i $l(group),group'=GrpId q //组别
	...///根据试剂和批号查询供应商,同一试剂和批号,默认为同一供应商
 	...s LotNo=$li(ItemStr,3)
 	...s LotCnt=$li(ItemStr,4)
 	...s LotNoIndex=$c(32)_$zcvt(LotNo,"U")
 	...s RecId=$o(^lab.DHCREAGStockInItemsI("LotNoIndex",ReagentDR,LotNoIndex,LotCnt,""))
 	...s SuppId=""
 	...i $l(RecId),$d(^lab.DHCREAGStockInD(RecId)) s SuppId=$li(^lab.DHCREAGStockInD(RecId),5)
 	...i $l(supplier),supplier'=SuppId q //供应商
 	...s MachId=$li(ItemStr,5)
 	...i $l(machine),'$l(MachId) q
 	...s MachList=MachId_","
 	...i $l(machine),machine'[MachList q //仪器
 	...s Quantity=+$li(ItemStr,9)
 	...s OutPrice=+$li(ItemStr,10)
	...s TotalPrices=OutPrice*Quantity
	...s SumQuan=+$g(^TMP($zn,$j,"REAG",ReagentDR,"SUMQUAN"))
	...s SumPrice=+$g(^TMP($zn,$j,"REAG",ReagentDR,"SUMPRICE"))
	...s SumQuan=SumQuan+Quantity
	...s SumPrice=SumPrice+TotalPrices
	...i '$l(sequence) s sequence="999"
	...s ^TMP($zn,$j,"SEQ",sequence,ReagentDR)=""
	...s ^TMP($zn,$j,"REAG",ReagentDR,"SUMQUAN")=SumQuan
	...s ^TMP($zn,$j,"REAG",ReagentDR,"SUMPRICE")=SumPrice
    //
    s seq="" f  s seq=$o(^TMP($zn,$j,"SEQ",seq)) q:seq=""  d
    .s reag="" f  s reag=$o(^TMP($zn,$j,"SEQ",seq,reag)) q:reag=""  d
    ..s SumQuan=$g(^TMP($zn,$j,"REAG",reag,"SUMQUAN"))
    ..s SumPrice=$g(^TMP($zn,$j,"REAG",reag,"SUMPRICE"))
	..s (Reagent,PackageDr,PackageName,UnitDr,UnitName,GrpId,GrpName,ManufacturerDR,ManufacturerName)=""
	..s PackageVol=1
	..i $d(^lab.DHCCTReagentD(reag)) d
	...s Reagent=$li(^lab.DHCCTReagentD(reag),3)
	...s PackageName=$li(^lab.DHCCTReagentD(reag),4)
	...s UnitDr=$li(^lab.DHCCTReagentD(reag),5)
	...s GrpId=$li(^lab.DHCCTReagentD(reag),6)
	...s ManufacturerDR=$li(^lab.DHCCTReagentD(reag),14)
	...///包装容量
	...s PackageVol=$li(^lab.DHCCTReagentD(reag),23)
	...s UnitName=$li(^lab.DHCCTReagentD(reag),24)
	..i PackageVol=0 s PackageVol=1
	..//
	..//i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	..i $l(ManufacturerDR),$d(^lab.DHCCTManufacturerD(ManufacturerDR)) s ManufacturerName=$li(^lab.DHCCTManufacturerD(ManufacturerDR),3)
	..i $l(GrpId),$d(^lab.DHCCTGroupTypeD(GrpId)) s GrpName=$li(^lab.DHCCTGroupTypeD(GrpId),3)
 	..//
 	..s AvePrice=$fn(SumPrice/SumQuan,"",2)
	..i type=0 d
	...s UnitName=""
	...i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	...s SumQuan=$fn(SumQuan/PackageVol,"",2)
 	..//s SumQuan=$fn(SumQuan/PackageVol,"",2)
 	..//
 	..s SumPrice=$fn(SumPrice,"",2)
 	..s PackageSum=$fn(SumQuan/PackageVol,"",3)_"("_PackageName_")"
 	..i SumQuan=+SumQuan
 	..i SumQuan<1,SumQuan>0 s SumQuan="0"_SumQuan
 	..s SumQuan=$fn(SumQuan,"",3)
	..d OutputSum	
	k ^TMP($zn,$j)	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSum
	//ReagId,ReagName,PackageName,UnitName,ManuName,Group,Quantity,Price,SumPrice
	set Data=$lb(reag,Reagent,PackageName,ManufacturerName,SumQuan,UnitName,AvePrice,SumPrice,GrpName,PackageSum,PackageVol)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryReagSummaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReagSummaryExecute ]
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
/// CreatDate：    20100617
/// Description:： 出库试剂汇总
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryReagSummary(Depart As %String, DateFrom As %String, DateTo As %String, reag As %String, group As %String, manu As %String, supplier As %String, machine As %String, type As %String) As %Query(ROWSPEC = "ReagId:%String,ReagName:%String,PackageName:%String,ManuName:%String,Quantity:%String,UnitName:%String,Price:%String,SumPrice:%String,Group:%String,PackageSum:%String,PackageVol:%String")
{
}

ClassMethod QryReagByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReagByIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReagByIdExecute(ByRef qHandle As %Binary, StockOutNo As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGStockOutI("MasterIndex"," CK2010050008",15)=
 	s StockOutNo=$g(StockOutNo)
    s StkOutNo=$c(32)_$zcvt(StockOutNo,"U")
    s id="" f  s id=$o(^lab.DHCREAGStockOutI("MasterIndex",StkOutNo,id)) q:id=""  d
    .s RecStr=$g(^lab.DHCREAGStockOutD(id))
 	.i '$l(RecStr) q
 	.s status=$li(RecStr,11)
 	.i status'="A" q
 	.s OpTypeId=$li(RecStr,3)
 	.i OpTypeId="4" q //1:正常入库,3:试剂领用,2:正常出库,4:退货,5:报废,6:盘点
 	.i OpTypeId="5" q
 	.i OpTypeId="6" q
 	.s SuppId=$li(RecStr,5)
 	.s ChkUserId=$li(RecStr,10)
 	.s ChkUserName=""
 	.i $l(ChkUserId),$d(^lab.DHCCTUserD(ChkUserId)) s ChkUserName=$li(^lab.DHCCTUserD(ChkUserId),3)
 	.s ChkDate=$li(RecStr,8)
 	.i '$l(ChkDate) q
 	.s ChkDate=$zd(ChkDate,3)
 	.s StockOutNo=$li(RecStr,2)
 	.//
 	.s subid="" f  s subid=$o(^lab.DHCREAGStockOutD(id,"Items",subid)) q:subid=""  d
 	..s ItemStr=$g(^lab.DHCREAGStockOutD(id,"Items",subid))
 	..i '$l(ItemStr) q
 	..s ReagentDR=$li(ItemStr,2)
	..///
	..s (Reagent,PackageDr,PackageName,UnitDr,UnitName,GrpId,GrpName,ManufacturerDR,ManufacturerName)=""
	..s PackageVol=1,Sequence=""
	..i $d(^lab.DHCCTReagentD(ReagentDR)) d
	...s Reagent=$li(^lab.DHCCTReagentD(ReagentDR),3)
	...s PackageName=$li(^lab.DHCCTReagentD(ReagentDR),4)
	...s UnitDr=$li(^lab.DHCCTReagentD(ReagentDR),5)
	...s GrpId=$li(^lab.DHCCTReagentD(ReagentDR),6)
	...s ManufacturerDR=$li(^lab.DHCCTReagentD(ReagentDR),14)
	...///包装容量
	...s PackageVol=+$li(^lab.DHCCTReagentD(ReagentDR),23)
	...s Sequence=$li(^lab.DHCCTReagentD(ReagentDR),18)
	..i PackageVol=0 s PackageVol=1
	..i '$l(Sequence) s Sequence="999"
	..//i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	..i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	..i $l(ManufacturerDR),$d(^lab.DHCCTManufacturerD(ManufacturerDR)) s ManufacturerName=$li(^lab.DHCCTManufacturerD(ManufacturerDR),3)
	..i $l(GrpId),$d(^lab.DHCCTGroupTypeD(GrpId)) s GrpName=$li(^lab.DHCCTGroupTypeD(GrpId),3)
	..///根据试剂和批号查询供应商,同一试剂和批号,默认为同一供应商
 	..s LotNo=$li(ItemStr,3)
 	..s LotCnt=$li(ItemStr,4)
 	..s LotNoIndex=$c(32)_$zcvt(LotNo,"U")
 	..s RecId=$o(^lab.DHCREAGStockInItemsI("LotNoIndex",ReagentDR,LotNoIndex,LotCnt,""))
 	..s SuppId=""
 	..i $l(RecId),$d(^lab.DHCREAGStockInD(RecId)) s SuppId=$li(^lab.DHCREAGStockInD(RecId),5)
 	..s SuppName=""
 	..i $l(SuppId),$d(^lab.DHCCTSupplierD(SuppId)) s SuppName=$li(^lab.DHCCTSupplierD(SuppId),3)
 	..//
 	..s MachId=$li(ItemStr,5)
 	..s MachName=""
 	..i $l(MachId),$d(^lab.DHCCTMachineD(MachId)) s MachName=$li(^lab.DHCCTMachineD(MachId),3)
 	..s LabNo=$li(ItemStr,6)
 	..s TS=$li(ItemStr,7)
 	..s TSName=""
 	..i $l(TS),$d(^TTAB("TS",TS)) s TSName=$p(^TTAB("TS",TS),"\",1)
 	..s TC=$li(ItemStr,8)
 	..s TCName=""
 	..i $l(TC),$d(^TTAB("TC",TC)) s TCName=$p(^TTAB("TC",TC),"\",1)
 	..s Quantity=$fn(+$li(ItemStr,9)/PackageVol,"",2)
 	..s OutPrice=+$li(ItemStr,10)
 	..s PositionDR=$li(ItemStr,11)
	..s PositionName=""
	..i $l(PositionDR),$d(^lab.DHCCTPositionD(PositionDR)) s PositionName=$li(^lab.DHCCTPositionD(PositionDR),3)
 	..s Remarks=$li(ItemStr,12)
 	..//
	..s TotalPrices=OutPrice*Quantity
	..d OutputId			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputId
	set Data=$lb(id_"||"_subid,Reagent,PackageName,LotNo,ManufacturerName,Quantity,UnitName,OutPrice,TotalPrices,GrpName,PositionName,Remarks,StockOutNo,SuppName,ChkUserName,ChkDate,MachName,LabNo,TSName,TCName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryReagByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReagByIdExecute ]
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
/// CreatDate：    20100617
/// Description:： 根据出库单号查询出库试剂
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryReagById(StockOutNo As %String) As %Query(ROWSPEC = "ItemId:%String,ReagName:%String,PackageName:%String,LotNo:%String,ManuName:%String,Quantity:%String,UnitName:%String,Price:%String,SumPrice:%String,Group:%String,Position:%String,Remark:%String,StockOutNo:%String,Supplier:%String,CheckUser:%String,CheckDate:%String,MachName:%String,LabNo:%String,TS:%String,TC:%String")
{
}

ClassMethod QryReagByLabNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReagByLabNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReagByLabNoExecute(ByRef qHandle As %Binary, LabNo As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGStockOutI("MasterIndex"," CK2010050008",15)=
	k ^TMP($zn,$j)
 	s LabNo=$g(LabNo)
 	//^lab.DHCREAGStockOutMachineI("LabNoIndex"," A619695999",139,61)= 	
    s LabNo=$c(32)_$zcvt(LabNo,"U")
    s id="" f  s id=$o(^lab.DHCREAGStockOutMachineI("LabNoIndex",LabNo,id)) q:id=""  d
    .s RecStr=$g(^lab.DHCREAGStockOutD(id))
 	.i '$l(RecStr) q
 	.s status=$li(RecStr,11)
 	.i status'="A" q
 	.s OpTypeId=$li(RecStr,3)
 	.//i OpTypeId="4" q //1:正常入库,3:试剂领用,2:正常出库,4:退货,5:报废,6:盘点,8:自动消耗
 	.//i OpTypeId="5" q
 	.//i OpTypeId="6" q
 	.i OpTypeId'="8" q
 	.s SuppId=$li(RecStr,5)
 	.s ChkUserId=$li(RecStr,10)
 	.s ChkUserName=""
 	.i $l(ChkUserId),$d(^lab.DHCCTUserD(ChkUserId)) s ChkUserName=$li(^lab.DHCCTUserD(ChkUserId),3)
 	.s ChkDate=$li(RecStr,8)
 	.i '$l(ChkDate) q
 	.s ChkDate=$zd(ChkDate,3)
 	.s StockOutNo=$li(RecStr,2)
 	.//
 	.s subid="" f  s subid=$o(^lab.DHCREAGStockOutD(id,"Machine",subid)) q:subid=""  d
 	..s ItemStr=$g(^lab.DHCREAGStockOutD(id,"Machine",subid))
 	..i '$l(ItemStr) q
 	..s ReagentDR=$li(ItemStr,2)
	..///
	..s (Reagent,PackageDr,PackageName,UnitDr,UnitName,GrpId,GrpName,ManufacturerDR,ManufacturerName)=""
	..s PackageVol=1,Sequence=""
	..i $d(^lab.DHCCTReagentD(ReagentDR)) d
	...s Reagent=$li(^lab.DHCCTReagentD(ReagentDR),3)
	...s PackageName=$li(^lab.DHCCTReagentD(ReagentDR),4)
	...//s UnitDr=$li(^lab.DHCCTReagentD(ReagentDR),5)
	...s GrpId=$li(^lab.DHCCTReagentD(ReagentDR),6)
	...s ManufacturerDR=$li(^lab.DHCCTReagentD(ReagentDR),14)
	...s UnitName=$li(^lab.DHCCTReagentD(ReagentDR),24)
	...///包装容量
	...s PackageVol=+$li(^lab.DHCCTReagentD(ReagentDR),23)
	...s Sequence=$li(^lab.DHCCTReagentD(ReagentDR),18)
	..i '$l(Sequence) s Sequence="999"
	..i PackageVol=0 s PackageVol=1
	..//i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	..//i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	..i $l(ManufacturerDR),$d(^lab.DHCCTManufacturerD(ManufacturerDR)) s ManufacturerName=$li(^lab.DHCCTManufacturerD(ManufacturerDR),3)
	..i $l(GrpId),$d(^lab.DHCCTGroupTypeD(GrpId)) s GrpName=$li(^lab.DHCCTGroupTypeD(GrpId),3)
	..///根据试剂和批号查询供应商,同一试剂和批号,默认为同一供应商
 	..s LotNo=$li(ItemStr,3)
 	..s LotCnt=$li(ItemStr,4)
 	..s LotNoIndex=$c(32)_$zcvt(LotNo,"U")
 	..s RecId=$o(^lab.DHCREAGStockInItemsI("LotNoIndex",ReagentDR,LotNoIndex,LotCnt,""))
 	..s SuppId=""
 	..i $l(RecId),$d(^lab.DHCREAGStockInD(RecId)) s SuppId=$li(^lab.DHCREAGStockInD(RecId),5)
 	..s SuppName=""
 	..i $l(SuppId),$d(^lab.DHCCTSupplierD(SuppId)) s SuppName=$li(^lab.DHCCTSupplierD(SuppId),3)
 	..//
 	..s MachId=$li(ItemStr,5)
 	..s MachName=""
 	..i $l(MachId),$d(^lab.DHCCTMachineD(MachId)) s MachName=$li(^lab.DHCCTMachineD(MachId),3)
 	..s LabNo=$li(ItemStr,6)
 	..s TS=$li(ItemStr,7)
 	..s TSName=""
 	..i $l(TS),$d(^TTAB("TS",TS)) s TSName=$p(^TTAB("TS",TS),"\",1)
 	..s TC=$li(ItemStr,8)
 	..s TCName=""
 	..i $l(TC),$d(^TTAB("TC",TC)) s TCName=$p(^TTAB("TC",TC),"\",1)
 	..s Quantity=+$li(ItemStr,9)
 	..i Quantity<1,Quantity>0 s Quantity="0"_Quantity
 	..s Quantity=$fn(Quantity,"",3)
 	..s OutPrice=+$li(ItemStr,10)
 	..s PositionDR=$li(ItemStr,11)
	..s PositionName=""
	..i $l(PositionDR),$d(^lab.DHCCTPositionD(PositionDR)) s PositionName=$li(^lab.DHCCTPositionD(PositionDR),3)
 	..s Remarks=$li(ItemStr,12)
 	..//
	..s TotalPrices=OutPrice*Quantity
	..set Data=$lb(id_"||"_subid,Reagent,PackageName,LotNo,ManufacturerName,Quantity,UnitName,OutPrice,TotalPrices,GrpName,PositionName,Remarks,StockOutNo,SuppName,ChkUserName,ChkDate,MachName,LabNo,TSName,TCName)
	..s ^TMP($zn,$j,"LabNo",Sequence,ReagentDR,LotNo)=Data
	..//d OutputLabNo			
	s seq="" f  s seq=$o(^TMP($zn,$j,"LabNo",seq)) q:seq=""  d
	.s reag="" f  s reag=$o(^TMP($zn,$j,"LabNo",seq,reag)) q:reag=""  d
	..s lot="" f  s lot=$o(^TMP($zn,$j,"LabNo",seq,reag,lot)) q:lot=""  d
	...s Data=$g(^TMP($zn,$j,"LabNo",seq,reag,lot))
	...d OutputLabNo
	k ^TMP($zn,$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputLabNo
	//set Data=$lb(id_"||"_subid,Reagent,PackageName,LotNo,ManufacturerName,Quantity,UnitName,OutPrice,TotalPrices,GrpName,PositionName,Remarks,StockOutNo,SuppName,ChkUserName,ChkDate,MachName,LabNo,TSName,TCName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryReagByLabNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReagByLabNoExecute ]
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
/// CreatDate：    20100901
/// Description:： 根据检验号查询出库试剂
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryReagByLabNo(LabNo As %String) As %Query(ROWSPEC = "ItemId:%String,ReagName:%String,PackageName:%String,LotNo:%String,ManuName:%String,Quantity:%String,UnitName:%String,Price:%String,SumPrice:%String,Group:%String,Position:%String,Remark:%String,StockOutNo:%String,Supplier:%String,CheckUser:%String,CheckDate:%String,MachName:%String,LabNo:%String,TS:%String,TC:%String")
{
}

/// Creator：      huhm
/// CreatDate：    20100714
/// Description:： 判断出库单中批号是否存在
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod CheckReagLot(StkOutId As %String, Reag As %String, Lot As %String, LotCnt As %String) As %String
{
	n (StkOutId,Reag,Lot,LotCnt,MachCode)
	s RetValue="0"
	s StkOutId=$g(StkOutId),Reag=$g(Reag),Lot=$g(Lot),LotCnt=$g(LotCnt)
	//^lab.DHCREAGStockOutItemsI("MasterIndex",54,206," 201001",1,85)=
	s LotIndex=$c(32)_$zcvt(Lot,"U")
	s ItemId=$o(^lab.DHCREAGStockOutItemsI("MasterIndex",StkOutId,Reag,LotIndex,LotCnt,""),-1)
	i $l(ItemId) s RetValue="1"
	Quit RetValue
}

}
