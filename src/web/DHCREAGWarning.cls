/// 系统预警
Class web.DHCREAGWarning Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 32;

/// Creator：      huhm
/// CreatDate：    20100506
/// Description:： 报警提示
/// Table：        
/// Input：        科室
/// Output：       无
/// Return：       
/// Others：
ClassMethod GetWarnFlag(depart As %String, user As %String) As %String
{
	//试剂有效期
	s RetValue=0
    s RetValue=..GetWarnExpire(depart,user)
	i RetValue q RetValue
	//试剂库存量
	s RetValue=..GetWarnVolumn(depart,user)
	//证书有效期
	i RetValue q RetValue
	q RetValue
}

/// Creator：      huhm
/// CreatDate：    20100506
/// Description:： 得到有效期提示
/// Table：        
/// Input：        科室
/// Output：       无
/// Return：       
/// Others：
ClassMethod GetWarnExpire(depart As %String, user As %String) As %String
{
	n (depart,user)
	s depart=$g(depart),user=$g(user)
	s RetValue=0
	s stkSum=0 f  s stkSum=$o(^lab.DHCREAGStockI("StockIndex",stkSum)) q:(stkSum="")!(RetValue)  d
	.s StockId="" f  s StockId=$o(^lab.DHCREAGStockI("StockIndex",stkSum,StockId)) q:(StockId="")!(RetValue)  d
	..s str=$g(^lab.DHCREAGStockD(StockId))
	..i $li(str,2)'=depart q
	..s reag=$li(str,3)
	..i $d(^lab.DHCCTReagentD(reag)) s flag=$li(^lab.DHCCTReagentD(reag),19)
	..i flag'="Y" q
	..s lotVol=0 f  s lotVol=$o(^lab.DHCREAGStockItemsI("SumQtyIndex",StockId,lotVol)) q:(lotVol="")!(RetValue)  d
	...s subid="" f  s subid=$o(^lab.DHCREAGStockItemsI("SumQtyIndex",StockId,lotVol,subid)) q:(subid="")!(RetValue)  d
	....s str=$g(^lab.DHCREAGStockD(StockId,"Items",subid))
	....s Expire=$li(str,5)
	....i $l(Expire),(Expire-$h)<60 s RetValue=1
	Quit RetValue
}

/// Creator：      huhm
/// CreatDate：    20100506
/// Description:： 得到库存量提示
/// Table：        
/// Input：        科室
/// Output：       无
/// Return：       
/// Others：
ClassMethod GetWarnVolumn(depart As %String, user As %String) As %String
{
	n (depart,user)
	s depart=$g(depart),user=$g(user)
	s RetValue=0
	s id="" f  s id=$o(^lab.DHCREAGStockD(id)) q:(id="")!(RetValue)  d
	.s str=$g(^lab.DHCREAGStockD(id))
	.i $li(str,2)'=depart q
	.s reag=$li(str,3)
	.i $d(^lab.DHCCTReagentD(reag)) s flag=$li(^lab.DHCCTReagentD(reag),19)
	.i flag'="Y" q
	.s Vol=$li(str,4)
	.s DefVol=$li(^lab.DHCCTReagentD(reag),15)
	.i (Vol-DefVol)<1 s RetValue=1
	Quit RetValue
}

/// Creator：      huhm
/// CreatDate：    20100506
/// Description:： 得到证书提示
/// Table：        
/// Input：        科室
/// Output：       无
/// Return：       
/// Others：
ClassMethod GetWarnLicence(depart As %String, user As %String) As %String
{
	n (depart,user)
	s depart=$g(depart),user=$g(user)
	Quit 0
}

ClassMethod QryExpireClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExpireExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)	
	Quit $$$OK
}

ClassMethod QryExpireExecute(ByRef qHandle As %Binary, depart As %String, user As %String) As %Status
{
	s depart=$g(depart),user=$g(user)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGStockI("MasterIndex","D03",206,144)=
	s reag="" f  s reag=$o(^lab.DHCREAGStockI("MasterIndex",depart,reag)) q:reag=""  d
	.s StockId="" f  s StockId=$o(^lab.DHCREAGStockI("MasterIndex",depart,reag,StockId)) q:StockId=""  d
	..s str=$g(^lab.DHCREAGStockD(StockId))
	..//i $li(str,2)'=depart q
	..//s reag=$li(str,3)
	..i $d(^lab.DHCCTReagentD(reag)) s flag=$li(^lab.DHCCTReagentD(reag),19)
	..i flag'="Y" q
	..s lotVol=0 f  s lotVol=$o(^lab.DHCREAGStockItemsI("SumQtyIndex",StockId,lotVol)) q:lotVol=""  d
	...s subid="" f  s subid=$o(^lab.DHCREAGStockItemsI("SumQtyIndex",StockId,lotVol,subid)) q:subid=""  d
	....s str=$g(^lab.DHCREAGStockD(StockId,"Items",subid))
	....s Expire=$li(str,5)
	....i $l(Expire),(Expire-$h)>60 q
	....s LotNo=$li(str,2)
	....s LotCnt=$li(str,3)
	....s quan=$li(str,10)
	....s PosiDr=$li(str,12)
	....s Price=$li(str,13)
	....s (ReagStr,ReagName,PackageName,UnitName,Group)=""
	....s ReagStr=##Class(web.DHCREAGReagent).SelectReagent(reag)
	....i $l(ReagStr) d
	.....s ReagName=$p(ReagStr,$c(2),2) //$li(ReagStr,3)
	.....s PackageName=$p(ReagStr,$c(2),3) //$li(ReagStr,4)
	.....s PackageDr=$p(ReagStr,$c(2),21) //$li(ReagStr,22)
	.....s UnitName=$p(ReagStr,$c(2),4) //$li(ReagStr,5)
	.....s UnitDr=$p(ReagStr,$c(2),22) //$li(ReagStr,23)
	.....s Group=$p(ReagStr,$c(2),5) //$li(ReagStr,6)
	.....s GroupDr=$p(ReagStr,$c(2),23) //$li(ReagStr,24)
	.....s ManuName=$p(ReagStr,$c(2),13)
	....s PosiName=""
	....i $l(PosiDr),$d(^lab.DHCCTPositionD(PosiDr)) s PosiName=$li(^lab.DHCCTPositionD(PosiDr),3)
	....s ExpDate=$zd(Expire,3)
	....d OutputExpire
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputExpire
	set Data=$lb(reag,ReagName,PackageName,LotNo,quan,UnitName,Price,ExpDate,ManuName,Group,PosiName,LotCnt)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryExpireFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExpireExecute ]
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
/// CreatDate：    20100914
/// Description:： 得到有效期明细
/// Table：        
/// Input：        
/// Output：       无
/// Return：       
/// Others：
Query QryExpire(depart As %String, user As %String) As %Query(ROWSPEC = "ReagDr:%String,ReagName:%String,PackageSize:%String,LotNo:%String,Quantity:%String,Unit:%String,Price:%String,Expire:%String,ManuName:%String,Group:%String,PosiName:%String,LotCnt:%String")
{
}

ClassMethod QryMinQuantityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMinQuantityExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)	
	Quit $$$OK
}

ClassMethod QryMinQuantityExecute(ByRef qHandle As %Binary, depart As %String, user As %String) As %Status
{
	s depart=$g(depart),user=$g(user)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGStockI("MasterIndex","D03",206,144)=
	s reag="" f  s reag=$o(^lab.DHCREAGStockI("MasterIndex",depart,reag)) q:reag=""  d
	.s StockId="" f  s StockId=$o(^lab.DHCREAGStockI("MasterIndex",depart,reag,StockId)) q:StockId=""  d
	..s str=$g(^lab.DHCREAGStockD(StockId))
	..s quan=$li(str,4)
	..s (ReagStr,ReagName,PackageName,UnitName,Group)=""
	..s Min=0
	..s ReagStr=##Class(web.DHCREAGReagent).SelectReagent(reag)
	..i $l(ReagStr) d
	...s ReagName=$p(ReagStr,$c(2),2) //$li(ReagStr,3)
	...s PackageName=$p(ReagStr,$c(2),3) //$li(ReagStr,4)
	...s PackageDr=$p(ReagStr,$c(2),21) //$li(ReagStr,22)
	...s UnitName=$p(ReagStr,$c(2),4) //$li(ReagStr,5)
	...s UnitDr=$p(ReagStr,$c(2),22) //$li(ReagStr,23)
	...s Group=$p(ReagStr,$c(2),5) //$li(ReagStr,6)
	...s GroupDr=$p(ReagStr,$c(2),23) //$li(ReagStr,24)
	...s ManuName=$p(ReagStr,$c(2),13)
	...s Min=+$p(ReagStr,$c(2),14)
	..//
	..i Min-0.00001<0 q 
	..i quan-Min>0 q
	..d OutputQuan
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputQuan
	set Data=$lb(reag,ReagName,PackageName,quan,UnitName,Min,ManuName,Group)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryMinQuantityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMinQuantityExecute ]
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
/// CreatDate：    20100914
/// Description:： 得到最小量明细
/// Table：        
/// Input：        
/// Output：       无
/// Return：       
/// Others：
Query QryMinQuantity(depart As %String, user As %String) As %Query(ROWSPEC = "ReagDr:%String,ReagName:%String,PackageSize:%String,Quantity:%String,Unit:%String,MinQuan:%String,ManuName:%String,Group:%String")
{
}

}
