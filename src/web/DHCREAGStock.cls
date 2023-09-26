Class web.DHCREAGStock Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 105;

ClassMethod QryStockReagentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStockReagentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryStockReagentExecute(ByRef qHandle As %Binary, depart As %String, flag As %String, manu As %String, supplier As %String, group As %String) As %Status
{
	s depart=$g(depart),flag=$g(flag)
	s manu=$g(manu)
	s supplier=$g(supplier),group=$g(group)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMP($zn,$j)
	s stkSum=""
	i flag="Y" s stkSum=0 
	f  s stkSum=$o(^lab.DHCREAGStockI("StockIndex",stkSum)) q:stkSum=""  d
	.s id="" f  s id=$o(^lab.DHCREAGStockI("StockIndex",stkSum,id)) q:id=""  d
	..s str=$g(^lab.DHCREAGStockD(id))
	..i '$l(str) q
	..s DepCode=$li(str,2)
	..i DepCode'=depart q
	..s ReagDr=$li(str,3)
	..s (UnitDr,UnitName,PackageDr,PackageName,ManuDr,ManuName,SuppDr,SuppName)=""
	..s (InPrice,OutPrice)=""
	..s ReagName=""
	..s ReagStr=##Class(web.DHCREAGReagent).SelectReagent(ReagDr)
	..s PackageVol=1
	..i $l(ReagStr) d
	...s ReagName=$p(ReagStr,$c(2),2) //$li(ReagStr,3)
	...s PackageName=$p(ReagStr,$c(2),3) //$li(ReagStr,4)
	...//s PackageDr=$p(ReagStr,$c(2),21) //$li(ReagStr,22)
	...s PackageDr=$p(ReagStr,$c(2),27)_" "_$p(ReagStr,$c(2),28)
	...//s PackageDr=$p(ReagStr,$c(2),23)_" "_$p(ReagStr,$c(2),24)
	...s UnitName=$p(ReagStr,$c(2),4) //$li(ReagStr,5)
	...s UnitDr=$p(ReagStr,$c(2),22) //$li(ReagStr,23)
	...s Group=$p(ReagStr,$c(2),5) //$li(ReagStr,6)
	...s InPrice=$p(ReagStr,$c(2),7)
	...s OutPrice=$p(ReagStr,$c(2),8)
	...s GroupDr=$p(ReagStr,$c(2),23) //$li(ReagStr,24)
	...s SuppName=$p(ReagStr,$c(2),12) //$li(ReagStr,13)
	...s SuppDr=$p(ReagStr,$c(2),24) //$li(ReagStr,25)
	...s ManuName=$p(ReagStr,$c(2),13) //$li(ReagStr,14)
	...s ManuDr=$p(ReagStr,$c(2),25) //$li(ReagStr,26)
	...s Sequence=$p(ReagStr,$c(2),17) 
	...s PackageVol=+$p(ReagStr,$c(2),27)
	..i PackageVol=0 s PackageVol=1
	..//
	..//i $l(ReagDr),$d(^lab.DHCCTReagentD(ReagDr)) d
	..//.s ReagName=$li(^lab.DHCCTReagentD(ReagDr),3)
    ..//.s PackageDr=$li(^lab.DHCCTReagentD(ReagDr),4)
    ..//.s UnitDr=$li(^lab.DHCCTReagentD(ReagDr),5)
    ..//.s ManuDr=$li(^lab.DHCCTReagentD(ReagDr),14)
    ..//.s SuppDr=$li(^lab.DHCCTReagentD(ReagDr),13)
    ..//.s InPrice=$li(^lab.DHCCTReagentD(ReagDr),8)
    ..//.s OutPrice=$li(^lab.DHCCTReagentD(ReagDr),9)
	..//i $l(supplier),supplier'=SuppDr q
	..i $l(manu),manu'=ManuDr q
	..//i $l(group) q
	..//i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	..//i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	..//i $l(ManuDr),$d(^lab.DHCCTManufacturerD(ManuDr)) s ManuName=$li(^lab.DHCCTManufacturerD(ManuDr),3)
	..//i $l(SuppDr),$d(^lab.DHCCTSupplierD(SuppDr)) s SuppName=$li(^lab.DHCCTSupplierD(SuppDr),3)
	..s StockSum=$fn(stkSum/PackageVol,"",3)
	..//i StockSum<1,StockSum>0 s StockSum="0"_StockSum
	..//s StockSum=$fn(StockSum,"",3)
	..set Data=$lb(ReagDr,ReagName,PackageName,ManuName,StockSum,UnitName,Group,InPrice,OutPrice,PackageDr,UnitDr,ManuDr,id)
	..i '$l(Sequence) s Sequence="999"
	..s ^TMP($zn,$j,Sequence,ReagDr)=Data
	..//d OutputRow
	s seq="" f  s seq=$o(^TMP($zn,$j,seq)) q:seq=""  d
	.s reag="" f  s reag=$o(^TMP($zn,$j,seq,reag)) q:reag=""  d
	..s Data=^(reag)
	..d OutputRow
	k ^TMP($zn,$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    //,SuppName,SuppDr
	//set Data=$lb(ReagDr,ReagName,PackageName,ManuName,stkSum,UnitName,Group,InPrice,OutPrice,PackageDr,UnitDr,ManuDr,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryStockReagentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStockReagentExecute ]
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
/// CreatDate：    20100506
/// Description:： 查询库存试剂
/// Table：        
/// Input：        科室
/// Output：       无
/// Return：       
/// Others：,SupplierName:%String,SupplierDr:%String
Query QryStockReagent(depart As %String, flag As %String, manu As %String, supplier As %String, group As %String) As %Query(ROWSPEC = "ReagDr:%String,ReagName:%String,PackageName:%String,ManuName:%String,Quantity:%String,UnitName:%String,group:%String,InPrice:%String,OutPrice:%String,PackageDr:%String,UnitDr:%String,ManuDr:%String,StkId:%String")
{
}

ClassMethod GetStockReagentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStockReagentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetStockReagentExecute(ByRef qHandle As %Binary, depart As %String, ToDepart As %String) As %Status
{
	s depart=$g(depart)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s stkSum=0 f  s stkSum=$o(^lab.DHCREAGStockI("StockIndex",stkSum)) q:stkSum=""  d
	.s id="" f  s id=$o(^lab.DHCREAGStockI("StockIndex",stkSum,id)) q:id=""  d
	..s str=$g(^lab.DHCREAGStockD(id))
	..i '$l(str) q
	..s DepCode=$li(str,2)
	..i DepCode'=depart q
	..s ReagDr=$li(str,3)
	..//判断试剂是否在发送科室
	..i $l(ToDepart),'$d(^lab.DHCCTDepartReagmentI("ReagentDRIndex",ReagDr,ToDepart)) q
	..s ReagName=""
	..//i $l(ReagDr),$d(^lab.DHCCTReagentD(ReagDr)) d
	..//.s uSyn=$li(^lab.DHCCTReagentD(ReagDr),19)
	..//.s ReagName=uSyn_" "_$li(^lab.DHCCTReagentD(ReagDr),3)
	..//基本信息单位规格厂商
	..s ReagStr="",PackageVol=1
	..s ReagStr=##Class(web.DHCREAGReagent).SelectReagent(ReagDr)
	..i $l(ReagStr) d
	...s ReagName=$p(ReagStr,$c(2),2) //$li(ReagStr,3)
	...s PackageName=$p(ReagStr,$c(2),3) //$li(ReagStr,4)
	...//s PackageDr=$p(ReagStr,$c(2),21) //$li(ReagStr,22)
	...s PackageDr=$p(ReagStr,$c(2),28) //$li(ReagStr,22)  $p(ReagStr,$c(2),27)_" "_
	...s UnitName=$p(ReagStr,$c(2),4) //$li(ReagStr,5)
	...s UnitDr=$p(ReagStr,$c(2),22) //$li(ReagStr,23)
	...s Group=$p(ReagStr,$c(2),5) //$li(ReagStr,6)
	...s GroupDr=$p(ReagStr,$c(2),23) //$li(ReagStr,24)
	...s SuppName=$p(ReagStr,$c(2),12) //$li(ReagStr,13)
	...s SuppDr=$p(ReagStr,$c(2),24) //$li(ReagStr,25)
	...s ManuName=$p(ReagStr,$c(2),13) //$li(ReagStr,14)
	...s ManuDr=$p(ReagStr,$c(2),25) //$li(ReagStr,26)
	...s InPrice=$p(ReagStr,$c(2),7) //$li(ReagStr,8)
	...s OutPrice=+$p(ReagStr,$c(2),8) //$li(ReagStr,9)
	...s uSyn=$p(ReagStr,$c(2),19)
	...s PackageVol=+$p(ReagStr,$c(2),27)
	..i PackageVol=0 s PackageVol=1
	..//s PackageDr=$p(ReagStr,$c(2),1)
	..//s PackageName=$p(ReagStr,$c(2),2)
	..//s UnitDr=$p(ReagStr,$c(2),3)
	..//s UnitName=$p(ReagStr,$c(2),4)
	..//s ManuDr=$p(ReagStr,$c(2),5)
	..//s ManuName=$p(ReagStr,$c(2),6)
	..//s InPrice=$p(ReagStr,$c(2),7)
	..//s OutPrice=$p(ReagStr,$c(2),9)
	..s StockSum=$fn(stkSum/PackageVol,"",3)
	..d OutputReag
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputReag
	set Data=$lb(id,ReagDr,uSyn_" "_ReagName,StockSum,PackageName,UnitName,ManuName,Group,InPrice,OutPrice,PackageDr,UnitDr,ManuDr,uSyn,PackageVol)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetStockReagentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStockReagentExecute ]
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
/// CreatDate：    20100506
/// Description:： 查询库存试剂
/// Table：        
/// Input：        科室
/// Output：       无
/// Return：       
/// Others：  
Query GetStockReagent(depart As %String, ToDepart As %String) As %Query(ROWSPEC = "StkId:%String,ReagDr:%String,ReagName:%String,Quantity:%String,PackageName:%String,UnitName:%String,ManuName:%String,group:%String,InPrice:%String,OutPrice:%String,PackageDr:%String,UnitDr:%String,ManuDr:%String,syn:%String,PackageVol:%String")
{
}

ClassMethod GetStkWarnReagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStkWarnReagExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetStkWarnReagExecute(ByRef qHandle As %Binary, depart As %String, WarnType As %String) As %Status
{
	s depart=$g(depart),WarnType=$g(WarnType)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s stkSum=0 f  s stkSum=$o(^lab.DHCREAGStockI("StockIndex",stkSum)) q:stkSum=""  d
	.s id="" f  s id=$o(^lab.DHCREAGStockI("StockIndex",stkSum,id)) q:id=""  d
	..s str=$g(^lab.DHCREAGStockD(id))
	..i '$l(str) q
	..s DepCode=$li(str,2)
	..i DepCode'=depart q
	..s ReagDr=$li(str,3)
	..s (ReagName,UnitDr,UnitName,PackageDr,PackageName,ManuDr,ManuName,SuppDr,SuppName,Group,GroupDr)=""
	..s (Min,Max)=0
	..//基本信息单位规格厂商
	..s ReagStr=""
	..s ReagStr=##Class(web.DHCREAGReagent).SelectReagent(ReagDr)
	..i $l(ReagStr) d
	...s ReagName=$p(ReagStr,$c(2),2) //$li(ReagStr,3)
	...s PackageName=$p(ReagStr,$c(2),3) //$li(ReagStr,4)
	...s PackageDr=$p(ReagStr,$c(2),21) //$li(ReagStr,22)
	...s UnitName=$p(ReagStr,$c(2),4) //$li(ReagStr,5)
	...s UnitDr=$p(ReagStr,$c(2),22) //$li(ReagStr,23)
	...s Group=$p(ReagStr,$c(2),5) //$li(ReagStr,6)
	...s GroupDr=$p(ReagStr,$c(2),23) //$li(ReagStr,24)
	...s SuppName=$p(ReagStr,$c(2),12) //$li(ReagStr,13)
	...s SuppDr=$p(ReagStr,$c(2),24) //$li(ReagStr,25)
	...s ManuName=$p(ReagStr,$c(2),13) //$li(ReagStr,14)
	...s ManuDr=$p(ReagStr,$c(2),25) //$li(ReagStr,26)
	...s Min=+$p(ReagStr,$c(2),14)
	...s Max=+$p(ReagStr,$c(2),15)
	..i WarnType="0",stkSum-Min>0 q
	..i WarnType="1",stkSum-Max>0 q
	..d OutputWarn
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputWarn
	set Data=$lb(id,ReagDr,ReagName,stkSum,PackageName,UnitName,Group,ManuName,Min,Max,PackageDr,UnitDr,ManuDr,"Y")
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetStkWarnReagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStkWarnReagExecute ]
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
/// CreatDate：    20100506
/// Description:： 查询库存报警试剂
/// Table：        
/// Input：        科室,报警类型0:最小库存量,1:最大库存量
/// Output：       无
/// Return：       
/// Others：  
Query GetStkWarnReag(depart As %String, WarnType As %String) As %Query(ROWSPEC = "StkId:%String,ReagDr:%String,ReagName:%String,Quantity:%String,PackageName:%String,UnitName:%String,Group:%String,ManuName:%String,Min:%String,Max:%String,PackageDr:%String,UnitDr:%String,ManuDr:%String,Visible:%String")
{
}

/// Creator：      huhm
/// CreatDate：    20100903
/// Description:： 查询库存试剂信息
/// Table：        
/// Input：        
/// Output：       无
/// Return：       
/// Others：
ClassMethod SelectStkReag(rowid As %String) As %String
{
	s RetValue=""
	//=<<$LB("","D01","202","28.6")>>
	s str=$g(^lab.DHCREAGStockD(rowid))
	i '$l(str) q str
	s DepId=$li(str,2)
	s ReagDr=$li(str,3)
	s sum=$li(str,4)
	s ReagStr=##Class(web.DHCREAGReagent).SelectReagent(ReagDr)
	s ReagName=$p(ReagStr,$c(2),2)
	s PackageName=$p(ReagStr,$c(2),3) //$li(ReagStr,4)
	s PackageDr=$p(ReagStr,$c(2),21) //$li(ReagStr,22)
	s UnitName=$p(ReagStr,$c(2),4) //$li(ReagStr,5)
	s UnitDr=$p(ReagStr,$c(2),22) //$li(ReagStr,23)
	s Group=$p(ReagStr,$c(2),5) //$li(ReagStr,6)
	s GroupDr=$p(ReagStr,$c(2),23) //$li(ReagStr,24)
	s ManuName=$p(ReagStr,$c(2),13) //$li(ReagStr,14)
	s ManuDr=$p(ReagStr,$c(2),25) //$li(ReagStr,26)
	s InPrice=$p(ReagStr,$c(2),7)
	s OutPrice=$p(ReagStr,$c(2),8)
	s Volumn=+$p(ReagStr,$c(2),27)
	i Volumn=0 s Volumn=1
	i '$l(OutPrice) s OutPrice=InPrice
	s RetValue=DepId_$c(2)_ReagDr_$c(2)_ReagName_$c(2)_PackageDr_$c(2)_PackageName
	s RetValue=RetValue_$c(2)_UnitDr_$c(2)_UnitName_$c(2)_ManuDr_$c(2)_ManuName
	s RetValue=RetValue_$c(2)_GroupDr_$c(2)_Group_$c(2)_InPrice_$c(2)_OutPrice_$c(2)_Volumn
	q RetValue
}

}
