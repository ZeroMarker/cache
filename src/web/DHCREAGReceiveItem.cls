/// 入库试剂明细
Class web.DHCREAGReceiveItem Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 95;

ClassMethod QryRecItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRecItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRecItemExecute(ByRef qHandle As %Binary, RecNo As %String) As %Status
{
	s Depart=$g(Depart)
	s ^TMP($zn,"RecItemPara")=RecNo
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGStockInD(46,"Items",
	s RecId=$o(^lab.DHCREAGStockInI("MasterIndex"," "_RecNo,""))
	Set qHandle=$lb(0,repid,0)
	i '$l(RecId) Quit $$$OK
	s Status=$li(^lab.DHCREAGStockInD(RecId),18)
	Set Table=""
	i Status="C" Set Table="RegItem"
	i Status="A" Set Table="Items"
	i '$l(Table) Quit $$$OK
	s id="" f  s id=$o(^lab.DHCREAGStockInD(RecId,Table,id)) q:id=""  d
	.s str=$g(^lab.DHCREAGStockInD(RecId,Table,id))
	.s ReagentDR=$li(str,2)
	.s PackageVol=+$p(##Class(web.DHCREAGReagent).SelectReagent(ReagentDR),$c(2),27)
	.i PackageVol=0 s PackageVol=1
	.s LotNo=$li(str,3)
	.//s ManufacturerDR=$li(str,5)
	.s ProductDate=$li(str,6)
	.s ExpireDate=$li(str,7)
	.s Quantity=$fn(+$li(str,8)/PackageVol,"",2)
	.s Price=+$li(str,9)
	.s TotalPrices=Quantity*Price
	.s PositionDR=$li(str,11)
	.s Remarks=$li(str,12)
	.///
	.s PackageDr="",PackageName=""
	.s UnitDr="",UnitName=""
	.i $d(^lab.DHCCTReagentD(ReagentDR)) d
	..//s PackageDr=$li(^lab.DHCCTReagentD(ReagentDR),4)
	..s PackageName=$li(^lab.DHCCTReagentD(ReagentDR),4)
	..s UnitDr=$li(^lab.DHCCTReagentD(ReagentDR),5)
	..s ManufacturerDR=$li(^lab.DHCCTReagentD(ReagentDR),14)
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
	set Data=$lb(id,ReagentName,PackageName,LotNo,Quantity,UnitName,ManufacturerName,Price,TotalPrices,ExpireDate,ProductDate,PositionName,Remarks,ReagentDR,ManufacturerDR,PositionDR,PackageDr,UnitDr,PackageVol)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryRecItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRecItemExecute ]
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
/// Description:： 未审核的入库单明细查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryRecItem(RecNo As %String) As %Query(ROWSPEC = "ItemId:%String,ReagName:%String,PackageName:%String,LotNo:%String,Quantity:%String,UnitName:%String,ManuName:%String,Price:%String,SumPrice:%String,ExpireDate:%String,ProductDate:%String,Position:%String,Remark:%String,ReagDr:%String,ManuDr:%String,PositionDr:%String,PackageDr:%String,UnitDr:%String,PackageVol:%String")
{
}

/// Creator：      huhm
/// CreatDate：    20100510
/// Description:： 根据接收试剂的ID查询相关信息
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others
ClassMethod SelectReceive(RowId As %String) As %String
{
	s RetValue=""
	i '$l(RowId) q RetValue
	s str=^lab.DHCREAGStockInD(+RowId,"Items",$p(RowId,"||",2))
	s RecNo=$li(^lab.DHCREAGStockInD(+RowId),2)
	s ManuDr=$li(str,4)
	s ProcDate=$li(str,5)
	s ExpDate=$li(str,6)
	s price=$li(str,8)
	s PosiDr=$li(str,10)
	i $l(ProcDate) s ProcDate=$zd(ProcDate,3)
	i $l(ExpDate) s ExpDate=$zd(ExpDate,3)
	s ManuName=""
	i $l(ManuDr),$d(^lab.DHCCTManufacturerD(ManuDr)) s ManuName=$li(^lab.DHCCTManufacturerD(ManuDr),3)
	s PosiName=""
	i $l(PosiDr),$d(^lab.DHCCTPositionD(PosiDr)) s PosiName=$li(^lab.DHCCTPositionD(PosiDr),3)
	s RetValue=RecNo_$c(2)_ManuDr_$c(2)_ManuName_$c(2)_ProcDate_$c(2)_ExpDate_$c(2)_price_$c(2)_PosiDr_$c(2)_PosiName
	q RetValue
}

/// Creator：      huhm
/// CreatDate：    20100611
/// Description:： 保存有效期
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others
ClassMethod SaveExpire(RowId As %String, ExpireDate As %String) As %String
{
	Set RowId=$g(RowId),ExpDate=$P($g(ExpireDate)," ",1)
	i $l(ExpDate) s ExpDate=$zdh(ExpDate,3)
	S ^TMP($ZN,"PARA")=RowId_","_ExpDate
	&sql(update lab.DHCREAGStockInRegItems set ExpireDate=:ExpDate where ID=:RowId)
	Quit SQLCODE
}

/// Creator：      huhm
/// CreatDate：    20100611
/// Description:： 保存位置号
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others
ClassMethod SavePosition(RowId As %String, PositonDr As %String) As %String
{
	Set RowId=$g(RowId),PositonDr=$g(PositonDr)
	&sql(update lab.DHCREAGStockInRegItems set PositionDR=:PositonDr where ID=:RowId)
	Quit SQLCODE
}

ClassMethod QryReagentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReagentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReagentExecute(ByRef qHandle As %Binary, Depart As %String, DateFrom As %String, DateTo As %String, reag As %String, group As %String, manu As %String, supplier As %String, SendUser As %String) As %Status
{
	s Depart=$g(Depart)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^TMP($ZN,"para")=DateFrom_","_DateTo_","_reag_","_group_","_manu
	//^lab.DHCREAGStockInI("CheckDateIndex","D01",61867,6)=
 	s DateFrom=$zdh(DateFrom,3)
 	s DateTo=$zdh(DateTo,3)
 	s reag=$g(reag),group=$g(group),manu=$g(manu),supplier=$g(supplier),SendUser=$g(SendUser)
 	s date=DateFrom-1 f  s date=$o(^lab.DHCREAGStockInI("CheckDateIndex",Depart,date)) q:(date=(DateTo+1))!(date="")  d
 	.s id="" f  s id=$o(^lab.DHCREAGStockInI("CheckDateIndex",Depart,date,id)) q:id=""  d
 	..s RecStr=$g(^lab.DHCREAGStockInD(id))
 	..i '$l(RecStr) q
 	..s SuppId=$li(RecStr,5)
 	..i $l(supplier),supplier'=SuppId q //供应商
 	..s SuppName=""
 	..i $l(SuppId),$d(^lab.DHCCTSupplierD(SuppId)) s SuppName=$li(^lab.DHCCTSupplierD(SuppId),3)
 	..s ChkUserId=$li(RecStr,17)
 	..s ChkUserName=""
 	..i $l(ChkUserId),$d(^lab.DHCCTUserD(ChkUserId)) s ChkUserName=$li(^lab.DHCCTUserD(ChkUserId),3)
 	..s ChkDate=$li(RecStr,15)
 	..i $l(ChkDate) s ChkDate=$zd(ChkDate,3)
 	..s ReceiveNo=$li(RecStr,2)
 	..s InvoiceNo=$li(RecStr,3)
 	..s SendUsr=$li(RecStr,11)
 	..i $l(SendUser),SendUser'=SendUsr q //送货者
 	..//
 	..s subid="" f  s subid=$o(^lab.DHCREAGStockInD(id,"Items",subid)) q:subid=""  d
 	...s ItemStr=$g(^lab.DHCREAGStockInD(id,"Items",subid))
 	...i '$l(ItemStr) q
 	...s ReagentDR=$li(ItemStr,2)
 	...i $l(reag),reag'=ReagentDR q //试剂
	...///
	...s (Reagent,PackageDr,PackageName,UnitDr,UnitName,GrpId,GrpName,ManufacturerDR,ManufacturerName)=""
	...i $d(^lab.DHCCTReagentD(ReagentDR)) d
	....s Reagent=$li(^lab.DHCCTReagentD(ReagentDR),3)
	....s PackageName=$li(^lab.DHCCTReagentD(ReagentDR),4)
	....s UnitDr=$li(^lab.DHCCTReagentD(ReagentDR),5)
	....s GrpId=$li(^lab.DHCCTReagentD(ReagentDR),6)
	....s ManufacturerDR=$li(^lab.DHCCTReagentD(ReagentDR),14)
	...i $l(manu),manu'=ManufacturerDR q //厂商
	...i $l(group),group'=GrpId q //组别
	...//i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	...i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	...i $l(ManufacturerDR),$d(^lab.DHCCTManufacturerD(ManufacturerDR)) s ManufacturerName=$li(^lab.DHCCTManufacturerD(ManufacturerDR),3)
	...i $l(GrpId),$d(^lab.DHCCTGroupTypeD(GrpId)) s GrpName=$li(^lab.DHCCTGroupTypeD(GrpId),3)
	...///
 	...s LotNo=$li(ItemStr,3)
 	...s ProductDate=$li(ItemStr,6)
 	...s ExpireDate=$li(ItemStr,7)
	...///修改为容量
	...s PackageVol=+$p(##Class(web.DHCREAGReagent).SelectReagent(ReagentDR),$c(2),27)
	...i PackageVol=0 s PackageVol=1
 	...s Quantity=$fn(+$li(ItemStr,8)/PackageVol,"",2)
 	...s InPrice=+$li(ItemStr,9)
 	...s PositionDR=$li(ItemStr,11)
	...s PositionName=""
	...i $l(PositionDR),$d(^lab.DHCCTPositionD(PositionDR)) s PositionName=$li(^lab.DHCCTPositionD(PositionDR),3)
 	...s Remarks=$li(ItemStr,12)
 	...//
	...i $l(ProductDate) s ProductDate=$zd(ProductDate,3)
	...i $l(ExpireDate) s ExpireDate=$zd(ExpireDate,3)
	...s TotalPrices=InPrice*Quantity
	...d OutputReag			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputReag
	set Data=$lb(id_"||"_subid,Reagent,PackageName,LotNo,ManufacturerName,Quantity,UnitName,InPrice,TotalPrices,GrpName,ChkUserName,ChkDate,SuppName,ExpireDate,ProductDate,PositionName,ReceiveNo,InvoiceNo,SendUsr) //,Remarks)
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
/// CreatDate：    20100613
/// Description:： 入库试剂查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：  ,Remark:%String)
Query QryReagent(Depart As %String, DateFrom As %String, DateTo As %String, reag As %String, group As %String, manu As %String, supplier As %String, SendUser As %String) As %Query(ROWSPEC = "ItemId:%String,ReagName:%String,PackageName:%String,LotNo:%String,ManuName:%String,Quantity:%String,UnitName:%String,Price:%String,SumPrice:%String,Group:%String,CheckUser:%String,CheckDate:%String,Supplier:%String,ExpireDate:%String,ProductDate:%String,Position:%String,ReceiveNo:%String,InvoiceNo:%String,SendUser:%String")
{
}

ClassMethod QryReagSummaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReagSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReagSummaryExecute(ByRef qHandle As %Binary, Depart As %String, DateFrom As %String, DateTo As %String, reag As %String, group As %String, manu As %String, supplier As %String, SendUser As %String) As %Status
{
	s Depart=$g(Depart)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGStockInI("CheckDateIndex","D01",61867,6)=
 	s DateFrom=$zdh(DateFrom,3)
 	s DateTo=$zdh(DateTo,3)
 	s reag=$g(reag),group=$g(group),manu=$g(manu),supplier=$g(supplier),SendUser=$g(SendUser)
 	k ^TMP($zn,$j)
 	s date=DateFrom-1 f  s date=$o(^lab.DHCREAGStockInI("CheckDateIndex",Depart,date)) q:(date=(DateTo+1))!(date="")  d
 	.s id="" f  s id=$o(^lab.DHCREAGStockInI("CheckDateIndex",Depart,date,id)) q:id=""  d
 	..s RecStr=$g(^lab.DHCREAGStockInD(id))
 	..i '$l(RecStr) q
 	..s SuppId=$li(RecStr,5)
 	..i $l(supplier),supplier'=SuppId q //供应商
 	..s SuppName=""
 	..i $l(SuppId),$d(^lab.DHCCTSupplierD(SuppId)) s SuppName=$li(^lab.DHCCTSupplierD(SuppId),3)
 	..s ChkUserId=$li(RecStr,17)
 	..s ChkUserName=""
 	..i $l(ChkUserId),$d(^lab.DHCCTUserD(ChkUserId)) s ChkUserName=$li(^lab.DHCCTUserD(ChkUserId),3)
 	..s ChkDate=$li(RecStr,15)
 	..i $l(ChkDate) s ChkDate=$zd(ChkDate,3)
 	..s ReceiveNo=$li(RecStr,2)
 	..s InvoiceNo=$li(RecStr,3)
 	..s SendUsr=$li(RecStr,11)
 	..i $l(SendUser),SendUser'=SendUsr q //送货者
 	..//
 	..s subid="" f  s subid=$o(^lab.DHCREAGStockInD(id,"Items",subid)) q:subid=""  d
 	...s ItemStr=$g(^lab.DHCREAGStockInD(id,"Items",subid))
 	...i '$l(ItemStr) q
 	...s ReagentDR=$li(ItemStr,2)
 	...i '$l(ReagentDR) q
 	...i $l(reag),reag'=ReagentDR q //试剂
	...///
	...s (GrpId,ManufacturerDR)=""
	...i $d(^lab.DHCCTReagentD(ReagentDR)) d
	....s GrpId=$li(^lab.DHCCTReagentD(ReagentDR),6)
	....s ManufacturerDR=$li(^lab.DHCCTReagentD(ReagentDR),14)
	....s sequence=$li(^lab.DHCCTReagentD(ReagentDR),18)
	...i $l(manu),manu'=ManufacturerDR q //厂商
	...i $l(group),group'=GrpId q //组别
	...///修改为容量
	...s PackageVol=+$p(##Class(web.DHCREAGReagent).SelectReagent(ReagentDR),$c(2),27)
	...i PackageVol=0 s PackageVol=1
	...s Quantity=+$fn(+$li(ItemStr,8)/PackageVol,"",2)
 	...s InPrice=+$li(ItemStr,9)
	...s TotalPrices=InPrice*Quantity
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
 	..//
 	..s AvePrice=+$fn(SumPrice/SumQuan,"",2)
 	..s SumPrice=+$fn(SumPrice,"",2)
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
/// CreatDate：    20100613
/// Description:： 入库试剂汇总
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryReagSummary(Depart As %String, DateFrom As %String, DateTo As %String, reag As %String, group As %String, manu As %String, supplier As %String, SendUser As %String) As %Query(ROWSPEC = "ReagId:%String,ReagName:%String,PackageName:%String,ManuName:%String,Quantity:%String,UnitName:%String,Price:%String,SumPrice:%String,Group:%String")
{
}

ClassMethod QryReagByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReagByIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReagByIdExecute(ByRef qHandle As %Binary, StockInNo As %String, InvoiceNo As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGStockInI("CheckDateIndex","D01",61867,6)=
 	s StockInNo=$g(StockInNo),InvoiceNo=$g(InvoiceNo)
	i $l(InvoiceNo) d
	.s InvNo=$c(32)_$zcvt(InvoiceNo,"U")
	.s id="" f  s id=$o(^lab.DHCREAGStockInI("InvoiceNoIndex",InvNo,id)) q:id=""  d
	..i '$d(^lab.DHCREAGStockInD(id)) q
	..s RecNo=$li(^lab.DHCREAGStockInD(id),2)
	..i '$l(RecNo) q
	..s ^TMP($zn,$j,RecNo,id)=""
	i $l(StockInNo) d
	.s StkInNo=$c(32)_$zcvt(StockInNo,"U")
	.s id="" f  s id=$o(^lab.DHCREAGStockInI("MasterIndex",StkInNo,id)) q:id=""  d
	..i '$d(^lab.DHCREAGStockInD(id)) q
	..s RecNo=$li(^lab.DHCREAGStockInD(id),2)
	..i '$l(RecNo) q
	..s ^TMP($zn,$j,RecNo,id)=""
 	//
 	s RecNo="" f  s RecNo=$o(^TMP($zn,$j,RecNo)) q:RecNo=""  d
 	.s id="" f  s id=$o(^TMP($zn,$j,RecNo,id)) q:id=""  d
 	..s RecStr=$g(^lab.DHCREAGStockInD(id))
 	..i '$l(RecStr) q
 	..s SuppId=$li(RecStr,5)
 	..s SuppName=""
 	..i $l(SuppId),$d(^lab.DHCCTSupplierD(SuppId)) s SuppName=$li(^lab.DHCCTSupplierD(SuppId),3)
 	..s ChkUserId=$li(RecStr,17)
 	..s ChkUserName=""
 	..i $l(ChkUserId),$d(^lab.DHCCTUserD(ChkUserId)) s ChkUserName=$li(^lab.DHCCTUserD(ChkUserId),3)
 	..s ChkDate=$li(RecStr,15)
 	..i $l(ChkDate) s ChkDate=$zd(ChkDate,3)
 	..s ReceiveNo=$li(RecStr,2)
 	..s InvoiceNo=$li(RecStr,3)
 	..s SendUsr=$li(RecStr,11)
 	..//
 	..s subid="" f  s subid=$o(^lab.DHCREAGStockInD(id,"Items",subid)) q:subid=""  d
 	...s ItemStr=$g(^lab.DHCREAGStockInD(id,"Items",subid))
 	...i '$l(ItemStr) q
 	...s ReagentDR=$li(ItemStr,2)
	...///
	...s (Reagent,PackageDr,PackageName,UnitDr,UnitName,GrpId,GrpName,ManufacturerDR,ManufacturerName)=""
	...i $d(^lab.DHCCTReagentD(ReagentDR)) d
	....s Reagent=$li(^lab.DHCCTReagentD(ReagentDR),3)
	....s PackageName=$li(^lab.DHCCTReagentD(ReagentDR),4)
	....s UnitDr=$li(^lab.DHCCTReagentD(ReagentDR),5)
	....s GrpId=$li(^lab.DHCCTReagentD(ReagentDR),6)
	....s ManufacturerDR=$li(^lab.DHCCTReagentD(ReagentDR),14)
	...//i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	...i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	...i $l(ManufacturerDR),$d(^lab.DHCCTManufacturerD(ManufacturerDR)) s ManufacturerName=$li(^lab.DHCCTManufacturerD(ManufacturerDR),3)
	...i $l(GrpId),$d(^lab.DHCCTGroupTypeD(GrpId)) s GrpName=$li(^lab.DHCCTGroupTypeD(GrpId),3)
	...///
 	...s LotNo=$li(ItemStr,3)
 	...s ProductDate=$li(ItemStr,6)
 	...s ExpireDate=$li(ItemStr,7)
	...///修改为容量
	...s PackageVol=+$p(##Class(web.DHCREAGReagent).SelectReagent(ReagentDR),$c(2),27)
	...i PackageVol=0 s PackageVol=1
 	...s Quantity=+$fn(+$li(ItemStr,8)/PackageVol,"",2)
 	...s InPrice=+$li(ItemStr,9)
 	...s PositionDR=$li(ItemStr,11)
	...s PositionName=""
	...i $l(PositionDR),$d(^lab.DHCCTPositionD(PositionDR)) s PositionName=$li(^lab.DHCCTPositionD(PositionDR),3)
 	...s Remarks=$li(ItemStr,12)
 	...//
	...i $l(ProductDate) s ProductDate=$zd(ProductDate,3)
	...i $l(ExpireDate) s ExpireDate=$zd(ExpireDate,3)
	...s TotalPrices=InPrice*Quantity
	...d OutputId			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputId
	//set Data=$lb(id_"||"_subid,Reagent,LotNo,PackageName,UnitName,ManufacturerName,GrpName,Quantity,InPrice,TotalPrices,ExpireDate,ProductDate,PositionName,Remarks,ReceiveNo,InvoiceNo,SuppName,ChkUserName,ChkDate,SendUsr)
 	set Data=$lb(id_"||"_subid,Reagent,PackageName,LotNo,ManufacturerName,Quantity,UnitName,InPrice,TotalPrices,GrpName,ChkUserName,ChkDate,SuppName,ExpireDate,ProductDate,PositionName,ReceiveNo,InvoiceNo,SendUsr) //,Remarks)
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
/// CreatDate：    20100613
/// Description:： 根据入库单号或发票号入库试剂查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryReagById(StockInNo As %String, InvoiceNo As %String) As %Query(ROWSPEC = "ItemId:%String,ReagName:%String,PackageName:%String,LotNo:%String,ManuName:%String,Quantity:%String,UnitName:%String,Price:%String,SumPrice:%String,Group:%String,CheckUser:%String,CheckDate:%String,Supplier:%String,ExpireDate:%String,ProductDate:%String,Position:%String,ReceiveNo:%String,InvoiceNo:%String,SendUser:%String")
{
}

}
