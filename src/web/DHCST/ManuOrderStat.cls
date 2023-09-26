Import sqluser

Class web.DHCST.ManuOrderStat Extends %RegisteredObject
{

/// description: 进程号
ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"DHCST")
}

/// d ##class(%ResultSet).RunQuery("web.DHCST.ManuOrderStat","ManuOrderStat","2018-07-29","2018-8-29","877")
Query ManuOrderStat(startDate, endDate, Loc) As websys.Query(ROWSPEC = "num,Inci,InciCode,InciDesc,TheQty,FactQty,RpAmt:%Double,SpAmt:%Double,PuomDesc,prtDateTime,Hosp") [ SqlProc ]
{
}

ClassMethod ManuOrderStatExecute(ByRef qHandle As %Binary, startDate, endDate, Loc) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:(startDate="")||(endDate="")||(Loc="") $$$OK
	s startDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate) //$zdh(startDate,3)
	s endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)   //$zdh(endDate,3)
	s pid=..NewPid()
	f Date=startDate:1:endDate d
	. s Inci=""
	. f  s Inci=$o(^DHCINMAN(0,"DLOCINCI",Date,Loc,Inci)) q:(Inci=0)!(Inci="")  d
	.. s InciCode=##class(PHA.COM.Data.Base).InciCode(Inci)
	.. s InciDesc=##class(PHA.COM.Data.Base).InciDesc(Inci)
	.. q:InciCode=""
	.. s Buom=$p($g(^INCI(Inci,1)),"^",10)
	.. s Puom=$p($g(^INCI(Inci,3)),"^",6)
	.. s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(Puom,Buom)
	.. s InManu=""
	.. f  s InManu=$o(^DHCINMAN(0,"DLOCINCI",Date,Loc,Inci,InManu)) q:(InManu=0)!(InManu="")  d
	... s Status=$p(^DHCINMAN(InManu),"^",27)
	... q:Status'="21"
	... s TheQty=$p(^DHCINMAN(InManu),"^",9)
	... s FactQty=$p(^DHCINMAN(InManu),"^",10)
	... s RpAmt=$p(^DHCINMAN(InManu),"^",15)
	... s UomDr=$p(^DHCINMAN(InManu),"^",8)
	... s InManuDate=$p(^DHCINMAN(InManu),"^",30)
	... s SpAmt=$p(^DHCINMAN(InManu),"^",32)
	... i UomDr'=Puom  d
	... .s Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(UomDr,Buom)
	... .s TheQty=TheQty*Fac2/Fac
	... .s FactQty=FactQty*Fac2/Fac
	...s Index=Inci
	...i $d( ^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderStat",pid,"Total",Index))  d
	....s $p(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderStat",pid,"Total",Index),"^",4)=TheQty+$p(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderStat",pid,"Total",Index),"^",4)
	....s $p(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderStat",pid,"Total",Index),"^",5)=FactQty+$p(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderStat",pid,"Total",Index),"^",5)
	....s $p(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderStat",pid,"Total",Index),"^",6)=RpAmt+$p(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderStat",pid,"Total",Index),"^",6)
	....s $p(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderStat",pid,"Total",Index),"^",7)=SpAmt+$p(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderStat",pid,"Total",Index),"^",7)
	...e  d
	....s ^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderStat",pid,"Total",Index)=Inci_"^"_ InciCode_"^"_InciDesc _"^"_ TheQty_"^"_FactQty_"^"_RpAmt_"^"_SpAmt_"^"_Puom
	...
	s curDate=+$h
	s curDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(curDate,"ST")
	s curTime=$p($h,",",2)
	s curTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(curTime,"ST")
	s prtDateTime=curDate_" "_curTime
	s Hosp=$p(^CTLOC(Loc),"^",22)
 	i Hosp'="" s Hosp=$p(^CT("HOSP",Hosp),"^",2)

	
	s num=0
	s Index=""
	f  s Index=$o(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderStat",pid,"Total",Index))  q:Index=""  d
	.s tmpData=$g(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderStat",pid,"Total",Index))
	.s Inci=$p(tmpData,"^",1)
	.s InciCode=$p(tmpData,"^",2)
	.s InciDesc=$p(tmpData,"^",3)
	.s TheQty=$p(tmpData,"^",4)
	.s FactQty=$p(tmpData,"^",5)
	.s RpAmt=$p(tmpData,"^",6)
	.s SpAmt=$p(tmpData,"^",7)
	.s Puom=$p(tmpData,"^",8)
	.s PuomDesc=##class(PHA.COM.Data.Base).UomDesc(Puom)
	.s num=num+1
	.s Data=$lb(num,Inci,InciCode,InciDesc,TheQty,FactQty,RpAmt,SpAmt,PuomDesc,prtDateTime,Hosp)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	k ^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderStat",pid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCST.ManuOrderStat","ManuOrderBatStat","15/12/2019","24/12/2019","257")
Query ManuOrderBatStat(startDate, endDate, Loc) As websys.Query(ROWSPEC = "num,Inci,InciCode,InciDesc,SpAmt:%Double,MatBatRpAmt:%Double,PackBatRpAmt:%Double,SumBatRpamt:%Double,DifAmt:%Double,ManuDifAmt:%Double,Remark,prtDateTime,Hosp") [ SqlProc ]
{
}

ClassMethod ManuOrderBatStatExecute(ByRef qHandle As %Binary, startDate, endDate, Loc) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:(startDate="")||(endDate="")||(Loc="") $$$OK
	s startDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)   //$zdh(startDate,3)
	s endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)   //$zdh(endDate,3)
	s pid=..NewPid()
	f Date=startDate:1:endDate d
	.s Inci=""
	.f  s Inci=$o(^DHCINMAN(0,"DLOCINCI",Date,Loc,Inci)) q:(Inci=0)!(Inci="")  d
	..s InciCode=##class(PHA.COM.Data.Base).InciCode(Inci)
	..s InciDesc=##class(PHA.COM.Data.Base).InciDesc(Inci)
	..q:InciCode=""
	..s Buom=$p($g(^INCI(Inci,1)),"^",10)
	..s Puom=$p($g(^INCI(Inci,3)),"^",6)
	..s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(Puom,Buom)
	..s InManu=""
	..f  s InManu=$o(^DHCINMAN(0,"DLOCINCI",Date,Loc,Inci,InManu)) q:(InManu=0)!(InManu="")  d
	...s Status=$p(^DHCINMAN(InManu),"^",27)
	...q:Status'="21"
	...s SpAmt=$p(^DHCINMAN(InManu),"^",32)
	...s RpAmt=$p(^DHCINMAN(InManu),"^",15)
	...s remarks=$p(^DHCINMAN(InManu),"^",29)	//备注
	...s Sub="" 
	...s MatBatRpAmt=0,PackBatRpAmt=0,SumBatRpamt=0
	...f  s Sub=$o(^DHCINMAN(InManu,"BAT",Sub)) q:(Sub="0")!(Sub="")  d
	....s BatRpAmt=$p(^DHCINMAN(InManu,"BAT",Sub),"^",8)
	....s BatInclb=$p(^DHCINMAN(InManu,"BAT",Sub),"^",1)
	....s BatInci=+BatInclb
	....s Incsc=$p(^INCI(BatInci,2),"^",2)
	....s IncscDesc=$p($g(^INC("SC",Incsc)),"^",2)
	....i IncscDesc["制剂包装" s PackBatRpAmt=PackBatRpAmt+BatRpAmt
	....e  s MatBatRpAmt=MatBatRpAmt+BatRpAmt
	....s IncscDesc=##class(PHA.COM.Data.Base).StkCatDesc(Incsc)
	....s SumBatRpamt=SumBatRpamt+BatRpAmt
	...s Index=InManu
	...i $d( ^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderBatStat",pid,"Total",Index))  d
	....s $p(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderBatStat",pid,"Total",Index),"^",4)=SpAmt+$p(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderBatStat",pid,"Total",Index),"^",4)
	....s $p(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderBatStat",pid,"Total",Index),"^",5)=MatBatRpAmt+$p(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderBatStat",pid,"Total",Index),"^",5)
	....s $p(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderBatStat",pid,"Total",Index),"^",6)=PackBatRpAmt+$p(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderBatStat",pid,"Total",Index),"^",6)
	....s $p(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderBatStat",pid,"Total",Index),"^",7)=SumBatRpamt+$p(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderBatStat",pid,"Total",Index),"^",7)
	....s $p(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderBatStat",pid,"Total",Index),"^",8)=RpAmt+$p(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderBatStat",pid,"Total",Index),"^",8)
	...e  d
	....s ^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderStat",pid,"Total",Index)=Inci_"^"_ InciCode_"^"_InciDesc _"^"_ SpAmt_"^"_MatBatRpAmt_"^"_PackBatRpAmt_"^"_ SumBatRpamt_"^"_RpAmt_"^"_remarks
	...
	
	s curDate=+$h
	s curDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(curDate,"ST")
	s curTime=$p($h,",",2)
	s curTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(curTime,"ST")
	s prtDateTime=curDate_" "_curTime
	s Hosp=$p(^CTLOC(Loc),"^",22)
 	s Hosp=##class(PHA.COM.Data.Base).HospDesc(Hosp)
 	
	s num=0
	s Index=""
	f  s Index=$o(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderStat",pid,"Total",Index))  q:Index=""  d
	.s tmpData=$g(^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderStat",pid,"Total",Index))
	.s Inci=$p(tmpData,"^",1)
	.s InciCode=$p(tmpData,"^",2)
	.s InciDesc=$p(tmpData,"^",3)
	.s SpAmt=$p(tmpData,"^",4)
	.s MatBatRpAmt=$p(tmpData,"^",5)
	.s PackBatRpAmt=$p(tmpData,"^",6)
	.s SumBatRpamt=$p(tmpData,"^",7)
	.s RpAmt=$p(tmpData,"^",8)
	.s Remark=$p(tmpData,"^",9)
	.s DifAmt=SpAmt-RpAmt   //(SpAmt/1.05)    //批零差价
 	.s ManuDifAmt=SpAmt-(MatBatRpAmt+PackBatRpAmt)-DifAmt
	.s num=num+1
	.s Data=$lb(num,Inci,InciCode,InciDesc,SpAmt,MatBatRpAmt,PackBatRpAmt,SumBatRpamt,DifAmt,ManuDifAmt,Remark,prtDateTime,Hosp)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	k ^TMP("DHCST","web.DHCST.ManuOrderStat","ManuOrderStat",pid)
	Quit $$$OK
}

}
