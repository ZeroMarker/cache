Class web.DHCREAGStockItem Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 132;

/// Creator：      huhm
/// CreatDate：    20100510
/// Description:： 根据库存试剂的ID和批号查询相关信息
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others
ClassMethod GetReagLotNo(RowId As %String) As %String
{
	s RetValue=""
	//<<$LB("","No00002","61727","62072","10","0","0","0","10","0","P03")>>
	i '$l(RowId) q RetValue
	s str=^lab.DHCREAGStockD(+RowId,"Items",$p(RowId,"||",2))
	s SumRec=$li(str,6)
	s SumCancel=$li(str,7)
	s SumDiacard=$li(str,8)
	s SumOut=$li(str,9)
	s SumStock=$li(str,10)
	s SumBanlance=$li(str,11)
	s ProcDate=$li(str,4)
	s ExpDate=$li(str,5)
	s PosiDr=$li(str,12)
	s InPrice=$li(str,13)
	s PosiName=""
	i $l(PosiDr),$d(^lab.DHCCTPositionD(PosiDr)) s PosiName=$li(^lab.DHCCTPositionD(PosiDr),3)
	s OutPrice="0"
	i $l(ProcDate) s ProcDate=$zd(ProcDate,3)
	i $l(ExpDate) s ExpDate=$zd(ExpDate,3)
	//s ManuName=""
	//i $l(ManuDr),$d(^lab.DHCCTManufacturerD(ManuDr)) s ManuName=$li(^lab.DHCCTManufacturerD(ManuDr),3)
	s RetValue=ProcDate_$c(2)_ExpDate_$c(2)_SumRec_$c(2)_SumCancel_$c(2)_SumDiacard_$c(2)_SumOut_$c(2)_SumStock_$c(2)_SumBanlance_$c(2)_PosiDr_$c(2)_PosiName_$c(2)_InPrice
	q RetValue
}

ClassMethod QryStockReagLotClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStockReagLotExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryStockReagLotExecute(ByRef qHandle As %Binary, StockId As %String) As %Status
{
	Set StockId=$g(StockId)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    i '$l(StockId) Set qHandle=$lb(0,repid,0) Quit $$$OK
    k ^TMP($zn,$j)
	s ReagDr=$li(^lab.DHCREAGStockD(StockId),3)
	///修改为容量
	s PackageVol=+$p(##Class(web.DHCREAGReagent).SelectReagent(ReagDr),$c(2),27)
	i PackageVol=0 s PackageVol=1
	s DepartId=$li(^lab.DHCREAGStockD(StockId),2)
	s stkSum=0 f  s stkSum=$o(^lab.DHCREAGStockItemsI("SumQtyIndex",StockId,stkSum)) q:stkSum=""  d
	.s id="" f  s id=$o(^lab.DHCREAGStockItemsI("SumQtyIndex",StockId,stkSum,id)) q:id=""  d
	..s str=$g(^lab.DHCREAGStockD(StockId,"Items",id))
	..s LotNo=$li(str,2)
	..s LotCount=$li(str,3)
	..s Expire=$li(str,5)
	..//i '$l(Expire) q
	..i '$l(Expire) s Expire=+$h-100
	..s PosiDr=$li(str,12)
	..s PosiName=""
	..//s Price=$g(^lab.DHCREAGStockInItemsI("LotNo",205,LotNo,1)=10
	..i $l(PosiDr),$d(^lab.DHCCTPositionD(PosiDr)) s PosiName=$li(^lab.DHCCTPositionD(PosiDr),3)
	..s ItemId=StockId_"||"_id
	..//s LotNoIndex=$c(32)_$ZCVT(LotNo,"U")
	..s Price=+$g(^lab.DHCREAGStockInItemsI("LotNo",ReagDr,LotNo,LotCount))
	..s ^TMP($zn,$j,"Items",Expire,stkSum,ItemId)=$lb(LotNo,PosiDr,PosiName,LotCount,Price)
	..//s StkInId=""
	..//i $l(LotNo) d
	..//.s StkInId=$o(^lab.DHCREAGStockInItemsI("LotNoIndex",ReagDr," "_LotNo,""),-1)
	..//.i '$l(StkInId) q
	..//.s StkInItm=$o(^lab.DHCREAGStockInItemsI("LotNoIndex",ReagDr," "_LotNo,StkInId,""),-1)
	..//.i '$l(StkInItm) q
	..//.s Expire=$li(^lab.DHCREAGStockInD(StkInId,"Items",StkInItm),6)
	..//i $l(Expire) s Expire=$zd(Expire,3)
	..//d OutputReag
	s exp="" f  s exp=$o(^TMP($zn,$j,"Items",exp)) q:exp=""  d
	.s num="" f  s num=$o(^TMP($zn,$j,"Items",exp,num)) q:num=""  d
	..s id="" f  s id=$o(^TMP($zn,$j,"Items",exp,num,id)) q:id=""  d
	...s str=^(id)
	...s LotNo=$li(str,1)
	...s LotCount=$li(str,4)
	...s ExpireDate=$zd(exp,3)
	...s PosiName=$li(str,3)
	...s Price=$li(str,5)
	...//
	...s ItmStocks=$fn(num/PackageVol,"",3)
	...//i ItmStocks<1,ItmStocks>0 s ItmStocks="0"_ItmStocks
	...//s ItmStocks=$fn(ItmStocks,"",3)
	...d OutputReag
	k ^TMP($zn,$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputReag
	set Data=$lb(LotNo,LotCount,ItmStocks,ExpireDate,id,PosiName,Price)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryStockReagLotFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStockReagLotExecute ]
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
/// CreatDate：    20100406
/// Description:： 查询库存试剂批号
/// Table：        
/// Input：        库存试剂ID
/// Output：       无
/// Return：       0:成功,非0:不成功
/// Others：  
Query QryStockReagLot(StockId As %String) As %Query(ROWSPEC = "LotNo:%String,LotCount:%String,Quantity:%String,Expire:%String,StkInId:%String,PositionName:%String,Price:%String")
{
}

ClassMethod QryStockItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStockItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryStockItemsExecute(ByRef qHandle As %Binary, depart As %String, flag As %String, reag As %String, manu As %String, supplier As %String, GroupTpype As %String, Exclude As %String) As %Status
{
	s depart=$g(depart),flag=$g(flag),reag=$g(reag),GroupTpype=$g(GroupTpype)
	s Exclude=$g(Exclude),manu=$g(manu),supplier=$g(supplier)
    s ^TMP($zn,"QryStockItems","para")=depart_","_flag_reag_","_GroupTpype_","_supplier
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMP($zn,$j)
	s stkSum=""
	i flag="Y" s stkSum=0 
	//^lab.DHCREAGStockItemsI("SumQtyIndex",105,10,30)=
	s StkId="" f  s StkId=$o(^lab.DHCREAGStockItemsI("SumQtyIndex",StkId)) q:StkId=""  d
	.i $li(^lab.DHCREAGStockD(StkId),2)'=depart q
	.s ReagDr=$li(^lab.DHCREAGStockD(StkId),3)
	.i $l(reag),reag'=ReagDr q
	.s (UnitDr,UnitName,PackageDr,PackageName,ManuDr,ManuName,SuppDr,SuppName)=""
	.s (Group,GroupDr)=""
	.s ReagName=""
	.s ReagStr=##Class(web.DHCREAGReagent).SelectReagent(ReagDr)
	.s PackageVol=1,Sequence=""
	.i $l(ReagStr) d
	..s ReagName=$p(ReagStr,$c(2),2) //$li(ReagStr,3)
	..s PackageName=$p(ReagStr,$c(2),3) //$li(ReagStr,4)
	..s PackageDr=$p(ReagStr,$c(2),21) //$li(ReagStr,22)
	..s UnitName=$p(ReagStr,$c(2),4) //$li(ReagStr,5)
	..s UnitDr=$p(ReagStr,$c(2),22) //$li(ReagStr,23)
	..s Group=$p(ReagStr,$c(2),5) //$li(ReagStr,6)
	..s GroupDr=$p(ReagStr,$c(2),23) //$li(ReagStr,24)
	..//s SuppName=$p(ReagStr,$c(2),12) //$li(ReagStr,13)
	..//s SuppDr=$p(ReagStr,$c(2),24) //$li(ReagStr,25)
	..s ManuName=$p(ReagStr,$c(2),13) //$li(ReagStr,14)
	..s ManuDr=$p(ReagStr,$c(2),25) //$li(ReagStr,26)
	..s PackageVol=+$p(ReagStr,$c(2),27)
	..s Sequence=$p(ReagStr,$c(2),17)
	.i Sequence="" s Sequence="999"
	.i PackageVol=0 s PackageVol=1
	.i $l(GroupTpype),GroupTpype'=GroupDr q
	.i $l(manu),manu'=ManuDr q
	.w !,"id:",StkId
	.s stkSum="" 
	.i flag="Y" s stkSum=0 
	.f  s stkSum=$o(^lab.DHCREAGStockItemsI("SumQtyIndex",StkId,stkSum)) q:stkSum=""  d
	..s ItmId="" f  s ItmId=$o(^lab.DHCREAGStockItemsI("SumQtyIndex",StkId,stkSum,ItmId)) q:ItmId=""  d
	...//b 100
	...s str=$g(^lab.DHCREAGStockD(StkId,"Items",ItmId))
	...s LotNo=$li(str,2)
	...s LotCnt=$li(str,3)
	...//s Price=+$g(^lab.DHCREAGStockInItemsI("LotNo",ReagDr,LotNo,LotCnt))
	...s ExpireDate=$li(str,5)
	...//供应商
	...s RecId=$o(^lab.DHCREAGStockInItemsI("LotNoIndex",ReagDr," "_LotNo,LotCnt,""),-1)
	...s SuppDr=""
	...i $l(RecId) s SuppDr=$li(^lab.DHCREAGStockInD(RecId),5)
	...i $l(supplier),$l(SuppDr),supplier'=SuppDr q
	...i $l(SuppDr) s SuppName=$li(^lab.DHCCTSupplierD(SuppDr),3)
	...i Exclude'="Y",$l(ExpireDate),(ExpireDate-$h)<0 q
	...s ProductDate=$li(str,4)
	...s QuanIn=$fn($li(str,6)/PackageVol,"",3)
	...i +QuanIn=0 s QuanIn=0
	...s QuanC=$fn($li(str,7)/PackageVol,"",3)
	...i +QuanC=0 s QuanC=0
	...s QuanD=$fn($li(str,8)/PackageVol,"",3)
	...i +QuanD=0 s QuanD=0
	...s QuanO=$fn($li(str,9)/PackageVol,"",3)
	...//s QuanS=$li(str,9)
	...s QuanB=$fn($li(str,11)/PackageVol,"",3)
	...i +QuanB=0 s QuanB=0
	...s Price=$li(str,13)
	...i $l(ProductDate) s ProductDate=$zd(ProductDate,3)
	...i $l(ExpireDate) s ExpireDate=$zd(ExpireDate,3)
	...//b 101
	...s ItemStocks=$fn(stkSum/PackageVol,"",3)
	...i +ItemStocks=0 s ItemStocks=0
	...//s ^TMP($zn,$j,"LIST",
	...d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(StkId_"||"_ItmId,ReagName,PackageName,LotNo,ManuName,ItemStocks,UnitName,Price,ExpireDate,Group,SuppName,QuanIn,QuanC,QuanD,QuanO,QuanB,ReagDr) //,ProductDate
 	//s ^TMPITM(repid,ind)=Data
 	//s ^TMPITM(repid,ind,"df")=ReagStr
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryStockItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStockItemsExecute ]
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
/// CreatDate：    20100527
/// Description:： 查询库存试剂批号
/// Table：        
/// Input：        库存试剂ID
/// Output：       无
/// Return：       0:成功,非0:不成功
/// Others：,ProcductDate:%String
Query QryStockItems(depart As %String, flag As %String, reag As %String, manu As %String, supplier As %String, GroupTpype As %String, Exclude As %String) As %Query(ROWSPEC = "ItemId:%String,ReagName:%String,Package:%String,LotNo:%String,ManuName:%String,Quantity:%String,Unit:%String,Price:%String,ExpireDate:%String,Group:%String,SuppName:%String,QuanIn:%String,QuanCancel:%String,QuanDiscard:%String,QuanOut:%String,QuanBanance:%String,ReagDr:%String")
{
}

/// CreatDate：    20100601
/// Description:： 得到试剂批号的当前的库存数量
/// Table：        
/// Input：        库存试剂ID
/// Output：       无
/// Return：       0:成功,非0:不成功
/// Others
ClassMethod GetStockQuantity(depart As %String, reag As %String, LotNo As %String, LotCnt As %String) As %String
{
	n (depart,reag,LotNo,LotCnt)
	s depart=$g(depart),reag=$g(reag),LotNo=$zcvt($g(LotNo),"U"),LotCnt=$g(LotCnt)
	s ^TMP($ZN,"PARA")=depart_","_reag_","_LotNo_","_LotCnt
	s RetValue=0
	s Id=$o(^lab.DHCREAGStockI("MasterIndex",depart,reag,""))
	i '$l(Id) Quit RetValue
	s SubId=""
	s SubId=$o(^lab.DHCREAGStockItemsI("MasterIndex",Id,$c(32)_LotNo,LotCnt,""))
	i '$l(SubId) Quit RetValue
	i '$d(^lab.DHCREAGStockD(Id,"Items",SubId)) Quit RetValue
	s RetValue=$li(^lab.DHCREAGStockD(Id,"Items",SubId),10)
	Quit RetValue
}

/// CreatDate：    20100806
/// Description:： 得到试剂批号的当前的库存试剂明细信息
/// Table：        
/// Input：        库存试剂ID
/// Output：       无
/// Return：       0:成功,非0:不成功
/// Others
ClassMethod GetStockItem(depart As %String, reag As %String, LotNo As %String, LotCnt As %String) As %String
{
	s depart=$g(depart),reag=$g(reag),LotNo=$zcvt($g(LotNo),"U"),LotCnt=$g(LotCnt)
	s ^TMP($ZN,"PARA")=depart_","_reag_","_LotNo_","_LotCnt
	s RetValue=""
	s Id=$o(^lab.DHCREAGStockI("MasterIndex",depart,reag,""))
	i '$l(Id) Quit RetValue
	s SubId=""
	s SubId=$o(^lab.DHCREAGStockItemsI("MasterIndex",Id,$c(32)_LotNo,LotCnt,""))
	i '$l(SubId) Quit RetValue
	i '$d(^lab.DHCREAGStockD(Id,"Items",SubId)) Quit RetValue
	s RetValue=$g(^lab.DHCREAGStockD(Id,"Items",SubId)) //$li(^lab.DHCREAGStockD(Id,"Items",SubId),9)
	Quit RetValue
}

/// CreatDate：    20100909
/// Description:： 根据试剂和批号得到当前的库存试剂明细信息
/// Table：        
/// Input：        库存试剂ID
/// Output：       无
/// Return：       0:成功,非0:不成功
/// Others
ClassMethod GetStockItemByLot(depart As %String, reag As %String, LotNo As %String) As %String
{
	n (depart,reag,LotNo)
	s depart=$g(depart),reag=$g(reag),LotNo=$g(LotNo)
	s LotNo=$zcvt($g(LotNo),"U")
	s RetValue=""
	s Id=$o(^lab.DHCREAGStockI("MasterIndex",depart,reag,""))
	i '$l(Id) Quit RetValue
    s LotCnt=$o(^lab.DHCREAGStockItemsI("MasterIndex",Id,$c(32)_LotNo,""),-1)
    i '$l(LotCnt) Quit RetValue 
	s SubId=$o(^lab.DHCREAGStockItemsI("MasterIndex",Id,$c(32)_LotNo,LotCnt,""))
	i '$l(SubId) Quit RetValue	
	i '$d(^lab.DHCREAGStockD(Id,"Items",SubId)) Quit RetValue
	s ProDate=$li(^lab.DHCREAGStockD(Id,"Items",SubId),4)
	s ExpDate=$li(^lab.DHCREAGStockD(Id,"Items",SubId),5)
	i $l(ProDate) s ProDate=$zd(ProDate,3)
	i $l(ExpDate) s ExpDate=$zd(ExpDate,3)
	s InPrice=$li(^lab.DHCREAGStockD(Id,"Items",SubId),13)
	s PosDr=$li(^lab.DHCREAGStockD(Id,"Items",SubId),12)
	s Position=""
	i $l(PosDr),$d(^lab.DHCCTPositionD(PosDr)) s Position=$li(^lab.DHCCTPositionD(PosDr),3)
	s RetValue=ProDate_$c(2)_ExpDate_$c(2)_InPrice_$c(2)_PosDr_$c(2)_Position
	Quit RetValue
}

}
