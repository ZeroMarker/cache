Class web.DHCOPCashier4 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 35;

/// //版本为4		宁波使用
ClassMethod GetAdmInsCost(Adm As %String, InsType As %String, OrdItemStr As %String, URecLocStr As %String) As %String
{
	s ToBillSum=0
	s ToBillPatSum=0
	s ToBillDiscSum=0
	s ToBillInsSum=0
	s PatType=""
	s InsType=$g(InsType)
	s OrdItemStr=$g(OrdItemStr)
	;Set JfCF=$o(^DHCTarC("CF",""))
	;If (InsType="")&(JfCF'="") Set PatInsType=$P(^DHCTarC("CF",JfCF),"^",3)
	Set Ord=$O(^OEORD(0,"Adm",Adm,""))
	Quit:Ord="" $fn(ToBillSum,"",4)_"^"_$fn(ToBillDiscSum,"",4)_"^"_$fn(ToBillInsSum,"",4)_"^"_$fn(ToBillPatSum,"",4)
	;
	Set Itm=0 For  Set Itm=$o(^OEORD(Ord,"I",Itm)) Quit:(Itm="")  Do
	.Set billed=$p($g(^OEORD(Ord,"I",Itm,3)),"^",5)
	.Quit:(billed="P")
	.Set RecDepDR=$p($g(^OEORD(Ord,"I",Itm,3)),"^",6)
	.q:((URecLocStr'="")&&(URecLocStr'[("^"_RecDepDR_"^")))
	.Set ItmStat=$p($g(^OEORD(Ord,"I",Itm,1)),"^",13)
	.i ItmStat'="" Set StatCode=$p($g(^OEC("OSTAT",ItmStat)),"^",1)
	.Quit:($g(StatCode)'="V")
	.Set OrdInsType=$p($g(^OEORD(Ord,"I",Itm,11)),"^",18)
	.Set JfCF=$o(^DHCTarC("CF",""))
	.If (OrdInsType="")&(JfCF'="") Set OrdInsType=$P(^DHCTarC("CF",JfCF),"^",3)
	.s OrdInsType=##class(web.DHCBillCons1).GetCurrentOrdInsType(Ord_"||"_Itm ,InsType,"")
	.Quit:(InsType'="")&(OrdInsType'=InsType)
	.s OEORI=Ord_"||"_Itm
	.Quit:((OrdItemStr'="")&(OrdItemStr[("^"_OEORI_"^")))
	.s mySkinFlag=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(OEORI)
	.q:(mySkinFlag="Y")				;限制医嘱不计费
	.s OEORICost=..GetOrderItemDetail(PatType,InsType,OEORI)
	.s OEORISum=$p(OEORICost,"^",1)
	.s OEORIDiscSum=$p(OEORICost,"^",2)
	.s OEORIInsSum=$p(OEORICost,"^",3)
	.s OEORIPatSum=$p(OEORICost,"^",4)
	.s ToBillSum=ToBillSum+OEORISum
	.s ToBillInsSum=ToBillInsSum+OEORIDiscSum
	.s ToBillDiscSum=ToBillDiscSum+OEORIDiscSum
	.s ToBillPatSum=ToBillPatSum+OEORIPatSum
	Q $fn(ToBillSum,"",2)_"^"_$fn(ToBillDiscSum,"",2)_"^"_$fn(ToBillInsSum,"",2)_"^"_$fn(ToBillPatSum,"",2)
}

ClassMethod GetOrderItemDetail(PatType As %String, InsType As %String, OEORI As %String) As %String
{
	s Sum=0
	s PatSum=0
	s DiscSum=0
	s InsSum=0
	s Ord=+OEORI
	s Itm=$P(OEORI,"||",2)
	s ARCIM=$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
	s SttDate=$p($g(^OEORD(Ord,"I",Itm,3)),"^",7)
	s ItemCatDR=$p(^ARCIM(+ARCIM,$p(ARCIM,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	s PriorRowid=""
	s InstrRowid=""
	s LinkTo=""
	s OEPrice=$p($g(^OEORD(Ord,"I",Itm,3)),"^",25)
	;i InsType=""  
	s InsType=$p($g(^OEORD(Ord,"I",Itm,11)),"^",18)
	//
	;if InsType="" d
	;.s Conf=$o(^DHCTarC("CF",""))
	;.s:InsType="" InsType=$p(^DHCTarC("CF",Conf),"^",3)
	//
	s PackQty=$p($g(^OEORD(Ord,"I",Itm,9)),"^",4)
	s DoseqtySum=$p($g(^OEORD(Ord,"I",Itm,1)),"^",12)
	i (OrderType="R")&(PackQty="") s PackQty=1
	i (OrderType="R")&(PackQty'="") d 
	.s convqty=..GetUomConvFactor(ARCIM)
	.s PackQty=PackQty*convqty
	e  d 
	.s PackQty=DoseqtySum
	s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice(PatType, InsType, ARCIM, +$H, PriorRowid, InstrRowid, LinkTo, OEPrice)
	s Price=$P(retPrice,"^",1)
	s DiscPrice=$P(retPrice,"^",2)
	s InsPrice=$P(retPrice,"^",3)
	s PatPrice=$P(retPrice,"^",4)
	s Sum=Price*PackQty
	s InsSum=InsPrice*PackQty
	s DiscSum=DiscPrice*PackQty
	s PatSum=PatPrice*PackQty
	Q $fn(Sum,"",2)_"^"_$fn(DiscSum,"",2)_"^"_$fn(InsSum,"",2)_"^"_$fn(PatSum,"",2)
}

ClassMethod GetUomConvFactor(ARCIM As %String) As %String
{
	Set inci=$o(^INCI(0,"ARCIM_DR",+ARCIM,""))
	Quit:inci="" 1
	Set BaseUom=$p(^INCI(inci,1),"^",10)
	Set BillUom=$p(^ARCIM(+ARCIM,1,8),"^",14)
	Quit:(BaseUom="")!(BillUom="") 1
	Set ConvDr=$o(^CT("CTCF",0,"UOM",BillUom,BaseUom,""))
	Quit:ConvDr="" 1
	Set Conv=+$p(^CT("CTCF",ConvDr),"^",3)
	q Conv
}

}
