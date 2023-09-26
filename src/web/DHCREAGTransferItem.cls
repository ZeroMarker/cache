Class web.DHCREAGTransferItem Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 98;

ClassMethod QryTransferItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTransferItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTransferItemExecute(ByRef qHandle As %Binary, TransNo As %String) As %Status
{
	s Depart=$g(Depart)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGStockInD(46,"Items",
	//<<$LB("","203","P900001","M04","61727","62041","10","330","","","","")>>
	s TransId=$o(^lab.DHCREAGTransferI("MasterIndex"," "_TransNo,""))
	Set qHandle=$lb(0,repid,0)
	i '$l(TransId) Quit $$$OK
	s id="" f  s id=$o(^lab.DHCREAGTransferD(TransId,"Items",id)) q:id=""  d
	.s str=$g(^lab.DHCREAGTransferD(TransId,"Items",id))
	.s ReagentDR=$li(str,2)
	.s LotNo=$li(str,3)
	.s LotCount=$li(str,4)
	.s ManufacturerDR=$li(str,5)
	.s ProductDate=$li(str,6)
	.s ExpireDate=$li(str,7)
	.s Quantity=+$li(str,8)
	.s Price=+$li(str,9)
	.s PositionDR=$li(str,11)
	.s Remarks=$li(str,12)
	.s StockInNo=$li(str,13)
	.//
	.s PackageDr="",PackageName="",Volumn=1
	.s UnitDr="",UnitName=""
	.i $d(^lab.DHCCTReagentD(ReagentDR)) d
	..s PackageName=$li(^lab.DHCCTReagentD(ReagentDR),4)
	..s UnitDr=$li(^lab.DHCCTReagentD(ReagentDR),5)
	..s Volumn=+$li(^lab.DHCCTReagentD(ReagentDR),23)
	.i Volumn=0 s Volumn=1
	.s Quantity=$fn(Quantity/Volumn,"",2)
	.s TotalPrices=Quantity*Price
	.//i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	.i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	.///
	.i $l(ProductDate) s ProductDate=$zd(ProductDate,3)
	.i $l(ExpireDate) s ExpireDate=$zd(ExpireDate,3)
	.s ReagentName=""
	.i $l(ReagentDR),$d(^lab.DHCCTReagentD(ReagentDR)) s ReagentName=$li(^lab.DHCCTReagentD(ReagentDR),3)
	.s ManufacturerName=""
	.i $l(ManufacturerDR),$d(^lab.DHCCTManufacturerD(ManufacturerDR)) s ManufacturerName=$li(^lab.DHCCTManufacturerD(ManufacturerDR),3)
	.s PositionName=""
	.i $l(PositionDR),$d(^lab.DHCCTPositionD(PositionDR)) s PositionName=$li(^lab.DHCCTPositionD(PositionDR),3)
	.d OutputRow			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(id,ReagentName,PackageName,LotNo,LotCount,Quantity,UnitName,ManufacturerName,Price,TotalPrices,ExpireDate,ProductDate,PositionName,Remarks,StockInNo,ReagentDR,ManufacturerDR,PositionDR,PackageDr,UnitDr,Volumn)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryTransferItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTransferItemExecute ]
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
/// CreatDate：    20100430
/// Description:： 领用单明细查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryTransferItem(TransNo As %String) As %Query(ROWSPEC = "ItemId:%String,ReagName:%String,PackageName:%String,LotNo:%String,LotCount:%String,Quantity:%String,UnitName:%String,ManuName:%String,Price:%String,SumPrice:%String,ExpireDate:%String,ProductDate:%String,Position:%String,Remark:%String,StockInNo:%String,ReagDr:%String,ManuDr:%String,PositionDr:%String,PackageDr:%String,UnitDr:%String,PackageVol:%String")
{
}

/// Creator：      huhm
/// CreatDate：    20100714
/// Description:： 判断领用单中批号是否存在
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod CheckReagLot(TransId As %String, Reag As %String, Lot As %String, LotCnt As %String) As %String
{
	n (TransId,Reag,Lot,LotCnt)
	s TransId=$g(TransId),Reag=$g(Reag),Lot=$g(Lot),LotCnt=$g(LotCnt)
	s RetValue="0"
	i '$l(TransId) Quit RetValue
	i '$l(Reag) Quit RetValue
	i '$l(Lot) Quit RetValue
	i '$l(LotCnt) Quit RetValue
	//^lab.DHCREAGTransferItemsI("MasterIndex",80,206," 201001",1,86)=
	s LotIndex=$c(32)_$zcvt(Lot,"U")
	s ItemId=$o(^lab.DHCREAGTransferItemsI("MasterIndex",TransId,Reag,LotIndex,LotCnt,""),-1)
	i $l(ItemId) s RetValue="1"
	Quit RetValue
}

ClassMethod QryReagentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReagentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReagentExecute(ByRef qHandle As %Binary, FromDepart As %String, DateFrom As %String, DateTo As %String, reag As %String, group As %String, manu As %String, supplier As %String, ToDepart As %String, type As %String) As %Status
{
	s FromDepart=$g(FromDepart)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGTransferI("CheckDateIndex","D01",61916,85)=
	//^lab.DHCREAGStockOutI("CheckDateIndex","D01",61878,25)=
 	s DateFrom=$zdh(DateFrom,3)
 	s DateTo=$zdh(DateTo,3)
 	s reag=$g(reag),group=$g(group),manu=$g(manu),supplier=$g(supplier),ToDepart=$g(ToDepart)
 	s type=$g(type)
 	s ^TMP($zn,"QryReag","para")=FromDepart_","_DateFrom_","_DateTo_","_reag_","_group_","_manu_","_supplier_","_ToDepart_","_type
 	i '$l(type) s type=0
 	k ^TMP($zn,$j)
 	i type=0 d
 	.//
 	.s date=DateFrom-1 f  s date=$o(^lab.DHCREAGTransferI("CheckDateIndex",FromDepart,date)) q:(date=(DateTo+1))!(date="")  d
 	..s id="" f  s id=$o(^lab.DHCREAGTransferI("CheckDateIndex",FromDepart,date,id)) q:id=""  d
 	...s RecStr=$g(^lab.DHCREAGTransferD(id))
 	...i '$l(RecStr) q
 	...s ToDepDr=$li(RecStr,3)
 	...i '$l(ToDepDr) q
 	...i $l(ToDepart),ToDepDr'=ToDepart q
 	...s OpTypeId=$li(RecStr,5)
 	...s OpType=$li(^lab.DHCCTOperateTypeD(OpTypeId),5)
 	...//i OpTypeId'="3" q //1:正常入库,3:试剂领用,2:正常出库,4:退货,5:报废,6:盘点
 	...i OpType'="T" q
 	...//
 	...s ChkTime=$li(RecStr,10)
 	...i '$l(ChkTime) s ChkTime=0
 	...s ^TMP($zn,$j,"reag",date,ChkTime,id)=""
 	//^lab.DHCREAGTransferI("ToDepartmentDRIndex",-100000000000000,"D01",143)=
 	i type=1 d
 	.s date=DateFrom-1 f  s date=$o(^lab.DHCREAGTransferI("ToDepartmentDRIndex",date)) q:(date=(DateTo+1))!(date="")  d
 	..s id="" f  s id=$o(^lab.DHCREAGTransferI("ToDepartmentDRIndex",date,ToDepart,id)) q:id=""  d
 	...s RecStr=$g(^lab.DHCREAGTransferD(id))
 	...i '$l(RecStr) q
 	...s FromDepDr=$li(RecStr,4)
 	...i '$l(FromDepDr) q
 	...i $l(FromDepart),FromDepDr'=FromDepart q
 	...s OpTypeId=$li(RecStr,5)
 	...s OpType=$li(^lab.DHCCTOperateTypeD(OpTypeId),5)
 	...//i OpTypeId'="3" q //1:正常入库,3:试剂领用,2:正常出库,4:退货,5:报废,6:盘点
 	...i OpType'="T" q
 	...//
 	...s ChkTime=$li(RecStr,10)
 	...i '$l(ChkTime) s ChkTime=0
 	...s ^TMP($zn,$j,"reag",date,ChkTime,id)=""
 	//
 	s date="" f  s date=$o(^TMP($zn,$j,"reag",date)) q:date=""  d
 	.s time="" f  s time=$o(^TMP($zn,$j,"reag",date,time)) q:time=""  d
 	..s id="" f  s id=$o(^TMP($zn,$j,"reag",date,time,id)) q:id=""  d
 	...//
 	...s RecStr=$g(^lab.DHCREAGTransferD(id))
 	...//
 	...s StockTransNo=$li(RecStr,2)
 	...s ToDepDr=$li(RecStr,3)
 	...s ChkDate=$li(RecStr,9)
 	...s ChkUserId=$li(RecStr,11)
 	...s OpTypeId=$li(RecStr,5)
 	...//s Type=$li(^lab.DHCCTOperateTypeD(OpTypeId),5)
 	...//
 	...s ToDepName=$li(^lab.DHCCTDepartmentD(ToDepDr),3)
 	...s ChkUserName=""
 	...i $l(ChkUserId),$d(^lab.DHCCTUserD(ChkUserId)) s ChkUserName=$li(^lab.DHCCTUserD(ChkUserId),3)
 	...i $l(ChkDate) s ChkDate=$zd(ChkDate,3)
 	...//
 	...s subid="" f  s subid=$o(^lab.DHCREAGTransferD(id,"Items",subid)) q:subid=""  d
 	....s ItemStr=$g(^lab.DHCREAGTransferD(id,"Items",subid))
 	....i '$l(ItemStr) q
 	....s ReagentDR=$li(ItemStr,2)
 	....i $l(reag),reag'=ReagentDR q //试剂
	....///
	....s Volumn=1
	....s (Reagent,PackageDr,PackageName,UnitDr,UnitName,GrpId,GrpName,ManufacturerDR,ManufacturerName)=""
	....i $d(^lab.DHCCTReagentD(ReagentDR)) d
	.....s Reagent=$li(^lab.DHCCTReagentD(ReagentDR),3)
	.....s PackageName=$li(^lab.DHCCTReagentD(ReagentDR),4)
	.....s UnitDr=$li(^lab.DHCCTReagentD(ReagentDR),5)
	.....s GrpId=$li(^lab.DHCCTReagentD(ReagentDR),6)
	.....s ManufacturerDR=$li(^lab.DHCCTReagentD(ReagentDR),14)
	.....s Volumn=+$li(^lab.DHCCTReagentD(ReagentDR),23)
	....i Volumn=0 s Volumn=1
	....i $l(manu),manu'=ManufacturerDR q //厂商
	....i $l(group),group'=GrpId q //组别
	....//i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	....i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	....i $l(ManufacturerDR),$d(^lab.DHCCTManufacturerD(ManufacturerDR)) s ManufacturerName=$li(^lab.DHCCTManufacturerD(ManufacturerDR),3)
	....i $l(GrpId),$d(^lab.DHCCTGroupTypeD(GrpId)) s GrpName=$li(^lab.DHCCTGroupTypeD(GrpId),3)
	....///根据试剂和批号查询供应商,同一试剂和批号,默认为同一供应商
 	....s LotNo=$li(ItemStr,3)
 	....s LotCnt=$li(ItemStr,4)
 	....s LotNoIndex=$c(32)_$zcvt(LotNo,"U")
 	....s RecId=$o(^lab.DHCREAGStockInItemsI("LotNoIndex",ReagentDR,LotNoIndex,LotCnt,""))
 	....s SuppId=""
 	....i $l(RecId),$d(^lab.DHCREAGStockInD(RecId)) s SuppId=$li(^lab.DHCREAGStockInD(RecId),5)
 	....i $l(supplier),supplier'=SuppId q //供应商
 	....s SuppName=""
 	....i $l(SuppId),$d(^lab.DHCCTSupplierD(SuppId)) s SuppName=$li(^lab.DHCCTSupplierD(SuppId),3)
 	....//
 	....s Quantity=$li(ItemStr,8)
 	....s Quantity=$fn(Quantity/Volumn,"",3)
 	....s Price=+$li(ItemStr,9)
 	....s PositionDR=$li(ItemStr,11)
	....s PositionName=""
	....i $l(PositionDR),$d(^lab.DHCCTPositionD(PositionDR)) s PositionName=$li(^lab.DHCCTPositionD(PositionDR),3)
 	....s Remarks=$li(ItemStr,12)
 	....//
	....s TotalPrices=$fn(Price*Quantity,"",2)
	....d OutputReag			
	k ^TMP($zn,$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputReag
	set Data=$lb(id_"||"_subid,Reagent,PackageName,LotNo,LotCnt,ManufacturerName,Quantity,UnitName,Price,TotalPrices,ToDepName,GrpName,PositionName,Remarks,StockTransNo,SuppName,ChkUserName,ChkDate)
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
/// CreatDate：    20100716
/// Description:： 领用试剂查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryReagent(Depart As %String, DateFrom As %String, DateTo As %String, reag As %String, group As %String, manu As %String, supplier As %String, ToDepart As %String, type As %String) As %Query(ROWSPEC = "ItemId:%String,ReagName:%String,PackageName:%String,LotNo:%String,LotCount:%String,ManuName:%String,Quantity:%String,UnitName:%String,Price:%String,SumPrice:%String,ToDepName:%String,Group:%String,Position:%String,Remark:%String,StockTransNo:%String,Supplier:%String,CheckUser:%String,CheckDate:%String")
{
}

ClassMethod QryReagSummaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReagSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReagSummaryExecute(ByRef qHandle As %Binary, FromDepart As %String, DateFrom As %String, DateTo As %String, reag As %String, group As %String, manu As %String, supplier As %String, ToDepart As %String, type As %String) As %Status
{
	s FromDepart=$g(FromDepart)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGStockInI("CheckDateIndex","D01",61867,6)=
 	s DateFrom=$zdh(DateFrom,3)
 	s DateTo=$zdh(DateTo,3)
 	s reag=$g(reag),group=$g(group),manu=$g(manu),supplier=$g(machine),machine=$g(machine)
  	s ToDepart=$g(ToDepart)
  	s type=$g(type)
 	i '$l(type) s type=0
 	k ^TMP($zn,$j)	
 	i type=0 d
 	.s date=DateFrom-1 f  s date=$o(^lab.DHCREAGTransferI("CheckDateIndex",FromDepart,date)) q:(date=(DateTo+1))!(date="")  d
 	..s id="" f  s id=$o(^lab.DHCREAGTransferI("CheckDateIndex",FromDepart,date,id)) q:id=""  d
 	...s RecStr=$g(^lab.DHCREAGTransferD(id))
 	...i '$l(RecStr) q
 	...s ToDepDr=$li(RecStr,3)
 	...i '$l(ToDepDr) q
 	...i $l(ToDepart),ToDepDr'=ToDepart q
 	...s OpTypeId=$li(RecStr,5)
 	...s OpType=$li(^lab.DHCCTOperateTypeD(OpTypeId),5)
 	...//i OpTypeId'="3" q //1:正常入库,3:试剂领用,2:正常出库,4:退货,5:报废,6:盘点
 	...i OpType'="T" q
 	...s ^TMP($zn,$j,"id",id)=id
 	i type=1 d
 	.s date=DateFrom-1 f  s date=$o(^lab.DHCREAGTransferI("ToDepartmentDRIndex",date)) q:(date=(DateTo+1))!(date="")  d
 	..s id="" f  s id=$o(^lab.DHCREAGTransferI("ToDepartmentDRIndex",date,ToDepart,id)) q:id=""  d
 	...s RecStr=$g(^lab.DHCREAGTransferD(id))
 	...i '$l(RecStr) q
 	...s FromDepDr=$li(RecStr,4)
 	...i '$l(FromDepDr) q
 	...i $l(FromDepart),FromDepDr'=FromDepart q
 	...s OpTypeId=$li(RecStr,5)
 	...s OpType=$li(^lab.DHCCTOperateTypeD(OpTypeId),5)
 	...//i OpTypeId'="3" q //1:正常入库,3:试剂领用,2:正常出库,4:退货,5:报废,6:盘点
 	...i OpType'="T" q
 	...s ^TMP($zn,$j,"id",id)=id
 	//
 	//s date=DateFrom-1 f  s date=$o(^lab.DHCREAGTransferI("CheckDateIndex",Depart,date)) q:(date=(DateTo+1))!(date="")  d
 	//.s id="" f  s id=$o(^lab.DHCREAGTransferI("CheckDateIndex",Depart,date,id)) q:id=""  d
 	s id="" f  s id=$o(^TMP($zn,$j,"id",id)) q:id=""  d
 	.s RecStr=$g(^lab.DHCREAGTransferD(id))
 	.i '$l(RecStr) q
 	.s StockTransNo=$li(RecStr,2)
 	.s ToDepDr=$li(RecStr,3)
 	.//i '$l(ToDepDr) q
 	.//i $l(ToDepart),ToDepDr'=ToDepart q
 	.s ChkDate=$li(RecStr,9)
 	.s ChkUserId=$li(RecStr,11)
 	.s OpTypeId=$li(RecStr,5)
 	.s OpType=$li(^lab.DHCCTOperateTypeD(OpTypeId),5)
 	.//
 	.s ToDepName=$li(^lab.DHCCTDepartmentD(ToDepDr),3)
 	.s ChkUserName=""
 	.i $l(ChkUserId),$d(^lab.DHCCTUserD(ChkUserId)) s ChkUserName=$li(^lab.DHCCTUserD(ChkUserId),3)
 	.i $l(ChkDate) s ChkDate=$zd(ChkDate,3)
 	.//
 	.s subid="" f  s subid=$o(^lab.DHCREAGTransferD(id,"Items",subid)) q:subid=""  d
 	..s ItemStr=$g(^lab.DHCREAGTransferD(id,"Items",subid))
 	..i '$l(ItemStr) q
 	..s ReagentDR=$li(ItemStr,2)
 	..i $l(reag),reag'=ReagentDR q //试剂
	..///
	..s (Reagent,PackageDr,PackageName,UnitDr,UnitName,GrpId,GrpName,ManufacturerDR,ManufacturerName)=""
	..s Volumn=1
	..i $d(^lab.DHCCTReagentD(ReagentDR)) d
	...s Reagent=$li(^lab.DHCCTReagentD(ReagentDR),3)
	...s PackageName=$li(^lab.DHCCTReagentD(ReagentDR),4)
	...s UnitDr=$li(^lab.DHCCTReagentD(ReagentDR),5)
	...s GrpId=$li(^lab.DHCCTReagentD(ReagentDR),6)
	...s ManufacturerDR=$li(^lab.DHCCTReagentD(ReagentDR),14)
	...s sequence=$li(^lab.DHCCTReagentD(ReagentDR),18)
	...s Volumn=+$li(^lab.DHCCTReagentD(ReagentDR),23)
	..i Volumn=0 s Volumn=1
	..i $l(manu),manu'=ManufacturerDR q //厂商
	..i $l(group),group'=GrpId q //组别
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
 	..i $l(supplier),supplier'=SuppId q //供应商
 	..s SuppName=""
 	..i $l(SuppId),$d(^lab.DHCCTSupplierD(SuppId)) s SuppName=$li(^lab.DHCCTSupplierD(SuppId),3)
 	..//
 	..s Quantity=+$li(ItemStr,8)
 	..s Quantity=$fn(Quantity/Volumn,"",2)
 	..s OutPrice=+$li(ItemStr,9)
 	..s TotalPrices=Quantity*OutPrice
 	..//
	..s SumQuan=+$g(^TMP($zn,$j,"REAG",ReagentDR,"SUMQUAN"))
	..s SumPrice=+$g(^TMP($zn,$j,"REAG",ReagentDR,"SUMPRICE"))
	..s SumQuan=SumQuan+Quantity
	..s SumPrice=SumPrice+TotalPrices
	..i '$l(sequence) s sequence="999"
	..s ^TMP($zn,$j,"SEQ",sequence,ReagentDR)=""
	..s ^TMP($zn,$j,"REAG",ReagentDR,"SUMQUAN")=SumQuan
	..s ^TMP($zn,$j,"REAG",ReagentDR,"SUMPRICE")=SumPrice
    //
    s seq="" f  s seq=$o(^TMP($zn,$j,"SEQ",seq)) q:seq=""  d
    .s reag="" f  s reag=$o(^TMP($zn,$j,"SEQ",seq,reag)) q:reag=""  d
    ..s SumQuan=$g(^TMP($zn,$j,"REAG",reag,"SUMQUAN"))
    ..s SumPrice=$g(^TMP($zn,$j,"REAG",reag,"SUMPRICE"))
	..s (Reagent,PackageDr,PackageName,UnitDr,UnitName,GrpId,GrpName,ManufacturerDR,ManufacturerName)=""
	..i $d(^lab.DHCCTReagentD(reag)) d
	...s Reagent=$li(^lab.DHCCTReagentD(reag),3)
	...s PackageName=$li(^lab.DHCCTReagentD(reag),4)
	...s UnitDr=$li(^lab.DHCCTReagentD(reag),5)
	...s GrpId=$li(^lab.DHCCTReagentD(reag),6)
	...s ManufacturerDR=$li(^lab.DHCCTReagentD(reag),14)
	..//
	..//i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	..i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	..i $l(ManufacturerDR),$d(^lab.DHCCTManufacturerD(ManufacturerDR)) s ManufacturerName=$li(^lab.DHCCTManufacturerD(ManufacturerDR),3)
	..i $l(GrpId),$d(^lab.DHCCTGroupTypeD(GrpId)) s GrpName=$li(^lab.DHCCTGroupTypeD(GrpId),3)
 	..s AvePrice=$fn(SumPrice/SumQuan,"",3)
 	..s SumPrice=$fn(SumPrice,"",3)
 	..s SumQuan=$fn(SumQuan,"",3)
	..d OutputSum	
	k ^TMP($zn,$j)	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSum
	//ReagId,ReagName,PackageName,UnitName,ManuName,Group,Quantity,Price,SumPrice
	set Data=$lb(reag,Reagent,PackageName,ManufacturerName,SumQuan,UnitName,AvePrice,SumPrice,GrpName)
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
/// CreatDate：    20100719
/// Description:： 领用试剂汇总
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryReagSummary(FromDepart As %String, DateFrom As %String, DateTo As %String, reag As %String, group As %String, manu As %String, supplier As %String, ToDepart As %String, type As %String) As %Query(ROWSPEC = "ReagId:%String,ReagName:%String,PackageName:%String,ManuName:%String,Quantity:%String,UnitName:%String,Price:%String,SumPrice:%String,Group:%String")
{
}

ClassMethod QryReagByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReagByIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReagByIdExecute(ByRef qHandle As %Binary, StockTransNo As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
 	s StockTransNo=$g(StockTransNo)
    s TransNo=$c(32)_$zcvt(StockTransNo,"U")
    s id="" f  s id=$o(^lab.DHCREAGTransferI("MasterIndex",TransNo,id)) q:id=""  d
 	.s RecStr=$g(^lab.DHCREAGTransferD(id))
 	.i '$l(RecStr) q
 	.s StockTransNo=$li(RecStr,2)
 	.s ToDepDr=$li(RecStr,3)
 	.i '$l(ToDepDr) q
 	.//i $l(ToDepart),ToDepDr'=ToDepart q
 	.s ChkDate=$li(RecStr,9)
 	.s ChkUserId=$li(RecStr,11)
 	.s OpTypeId=$li(RecStr,5)
 	.s Type=$li(^lab.DHCCTOperateTypeD(OpTypeId),5)
 	.//i OpTypeId'="3" q //1:正常入库,3:试剂领用,2:正常出库,4:退货,5:报废,6:盘点
 	.i Type'="T" q
 	.//
 	.s ToDepName=$li(^lab.DHCCTDepartmentD(ToDepDr),3)
 	.s ChkUserName=""
 	.i $l(ChkUserId),$d(^lab.DHCCTUserD(ChkUserId)) s ChkUserName=$li(^lab.DHCCTUserD(ChkUserId),3)
 	.i $l(ChkDate) s ChkDate=$zd(ChkDate,3)
 	.//
 	.s subid="" f  s subid=$o(^lab.DHCREAGTransferD(id,"Items",subid)) q:subid=""  d
 	..s ItemStr=$g(^lab.DHCREAGTransferD(id,"Items",subid))
 	..i '$l(ItemStr) q
 	..s ReagentDR=$li(ItemStr,2)
 	..//i $l(reag),reag'=ReagentDR q //试剂
	..///
	..s (Reagent,PackageDr,PackageName,UnitDr,UnitName,GrpId,GrpName,ManufacturerDR,ManufacturerName)=""
	..s Volumn=1
	..i $d(^lab.DHCCTReagentD(ReagentDR)) d
	...s Reagent=$li(^lab.DHCCTReagentD(ReagentDR),3)
	...s PackageName=$li(^lab.DHCCTReagentD(ReagentDR),4)
	...s UnitDr=$li(^lab.DHCCTReagentD(ReagentDR),5)
	...s GrpId=$li(^lab.DHCCTReagentD(ReagentDR),6)
	...s ManufacturerDR=$li(^lab.DHCCTReagentD(ReagentDR),14)
	...s Volumn=+$li(^lab.DHCCTReagentD(ReagentDR),23)
	..i Volumn=0 s Volumn=1
	..//i $l(manu),manu'=ManufacturerDR q //厂商
	..//i $l(group),group'=GrpId q //组别
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
 	..//i $l(supplier),supplier'=SuppId q //供应商
 	..s SuppName=""
 	..i $l(SuppId),$d(^lab.DHCCTSupplierD(SuppId)) s SuppName=$li(^lab.DHCCTSupplierD(SuppId),3)
 	..//
 	..s Quantity=+$li(ItemStr,8)
 	..s Quantity=$fn(Quantity/Volumn,"",3)
 	..s Price=$li(ItemStr,9)
 	..s PositionDR=$li(ItemStr,11)
	..s PositionName=""
	..i $l(PositionDR),$d(^lab.DHCCTPositionD(PositionDR)) s PositionName=$li(^lab.DHCCTPositionD(PositionDR),3)
 	..s Remarks=$li(ItemStr,12)
 	..//
	..s TotalPrices=$fn(+Price*Quantity,"",3)
	..d OutputId			
	set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputId
	set Data=$lb(id_"||"_subid,Reagent,PackageName,LotNo,LotCnt,ManufacturerName,Quantity,UnitName,Price,TotalPrices,ToDepName,GrpName,PositionName,Remarks,StockTransNo,SuppName,ChkUserName,ChkDate)
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
/// CreatDate：    20100728
/// Description:： 根据领用单号查询试剂
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryReagById(StockTransNo As %String) As %Query(ROWSPEC = "ItemId:%String,ReagName:%String,PackageName:%String,LotNo:%String,LotCount:%String,ManuName:%String,Quantity:%String,UnitName:%String,Price:%String,SumPrice:%String,ToDepName:%String,Group:%String,Position:%String,Remark:%String,StockTransNo:%String,Supplier:%String,CheckUser:%String,CheckDate:%String")
{
}

}
