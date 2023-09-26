Import sqluser

/// creator:	yunhaibao
/// createdate: 2018-05-29
/// description:静配中心收取的附加配置费用统计
Class web.DHCSTPIVAS.Report.FeeStat Extends %RegisteredObject
{

/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Report.FeeStat","WardFeeStat","2018-05-29","2018-05-29","101")
Query WardFeeStat(startDate, endDate, pivaLoc) As websys.Query(ROWSPEC = "wardId,wardDesc,arcItmCode,arcItmDesc,qty,sp,spAmt") [ SqlProc ]
{
}

ClassMethod WardFeeStatExecute(ByRef qHandle As %Binary, startDate, endDate, pivaLoc) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:(startDate="")||(endDate="")||(pivaLoc="") $$$OK
	s collRet=..CollectFeeStat("WardFeeStat",startDate, endDate, pivaLoc)
	s pid=$p(collRet,"^",1)
	q:pid="" $$$OK
	s wardId=""
	f  s wardId=$o(^TMP("DHCST",$ClassName(),"CollectFeeStat","WardFeeStat",pid,wardId)) q:wardId=""  d
	.s arcItmId=""
	.f  s arcItmId=$o(^TMP("DHCST",$ClassName(),"CollectFeeStat","WardFeeStat",pid,wardId,arcItmId)) q:arcItmId=""  d
	..s data=^TMP("DHCST",$ClassName(),"CollectFeeStat","WardFeeStat",pid,wardId,arcItmId)
	..s ^CacheTemp(repid,ind)=$lfs(data,"^")    
	..s ind=ind+1
	k ^TMP("DHCST",$ClassName(),"CollectFeeStat","WardFeeStat",pid)
	Quit $$$OK
}

/// description: 统计配置费用
ClassMethod CollectFeeStat(queryType, startDate, endDate, pivaLoc)
{
	s pid=..NewPid()
	s startDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
	s endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
	s calcuDate=""
	f calcuDate=startDate:1:endDate d
	.s sttTime=""
	.f  s sttTime=$o(^OEORDi(0,"LocStDtTm",pivaLoc,calcuDate,sttTime)) q:sttTime=""  d
	..s ordId=""
	..f  s ordId=$o(^OEORDi(0,"LocStDtTm",pivaLoc,calcuDate,sttTime,ordId)) q:ordId=""  d
	...q:+ordId=0
	...s admId=$p(^OEORD(ordId),"^",1)
	...s ordItm=""
	...f  s ordItm=$o(^OEORDi(0,"LocStDtTm",pivaLoc,calcuDate,sttTime,ordId,ordItm)) q:ordItm=""  d
	....q:+ordItm=0
	....q:'$d(^OEORD(ordId,"I",ordItm,7))
	....s recLocDr=$p(^OEORD(ordId,"I",ordItm,3),"^",6)
	....s userDeptDr=$p(^OEORD(ordId,"I",ordItm,7),"^",2)
	....q:userDeptDr'=pivaLoc
	....s oeoriStatStr=##class(web.DHCSTPIVAS.Common).OeoriStat(ordId_"||"_ordItm)
	....s oeoriStat=$p(oeoriStatStr,"^",1)
	....q:(oeoriStat'="V")&&(oeoriStat'="E")
	....s userAddDr=$p(^OEORD(ordId,"I",ordItm,7),"^",1)
	....s userName=$p($g(^SSU("SSUSR",+userAddDr)),"^",2)
	....s ordTime=$p(^OEORD(ordId,"I",ordItm,1),"^",17)
	....s ordDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(calcuDate)
	....s ordTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ordTime)
	....s patId=$p(^PAADM(admId),"^",1)
	....s patName=$p(^PAPER(patId,"ALL"),"^",1)
	....s patNo=$p(^PAPER(patId,"PAT",1),"^",1)
	....s arcItm=$P(^OEORD(ordId,"I",ordItm,1),"^",2)
	....q:+arcItm=0
	....s arcVer=+arcItm
	....s arcSub=$p(arcItm,"||",2)
	....s arcItmCode=$p(^ARCIM(arcVer,arcSub,1),"^",1)
	....s arcItmDesc=$p(^ARCIM(arcVer,arcSub,1),"^",2)
	....s qty=$P(^OEORD(ordId,"I",ordItm,1),"^",12)
	....s sp=..GetTarPrice(arcItm,calcuDate)
	....s spAmt=sp*qty
	....s pogId=$o(^PIVA(0,"Order","Oeori",ordId_"||"_ordItm,""))
	....q:pogId=""
	....s mDsp=$p(^PIVA(pogId),"^",1)
	....s wardLocId=$p(^DHCOEDISQTY(mDsp),"^",22)
	....s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
	....s wardDesc=$p($G(^PAWARD(wardId)),"^",2)
	....i queryType="WardFeeStat" d
	....// 按病区汇总
	....i '$d(^TMP("DHCST",$ClassName(),"CollectFeeStat","WardFeeStat",pid,wardId,arcItm)) d
	.....s ^TMP("DHCST",$ClassName(),"CollectFeeStat","WardFeeStat",pid,wardId,arcItm)=wardId_"^"_wardDesc_"^"_arcItmCode_"^"_arcItmDesc_"^"_qty_"^"_sp_"^"_spAmt
	....e  d
	.....s $p(^TMP("DHCST",$ClassName(),"CollectFeeStat","WardFeeStat",pid,wardId,arcItm),"^",5)=qty+$p(^TMP("DHCST",$ClassName(),"CollectFeeStat","WardFeeStat",pid,wardId,arcItm),"^",5)
	.....s $p(^TMP("DHCST",$ClassName(),"CollectFeeStat","WardFeeStat",pid,wardId,arcItm),"^",7)=spAmt+$p(^TMP("DHCST",$ClassName(),"CollectFeeStat","WardFeeStat",pid,wardId,arcItm),"^",7)
	q pid
}

/// description: 获取收费项售价,配置费都是一对一
ClassMethod GetTarPrice(arcItm, date)
{
	s price=0
	q:arcItm="" 0
	i date="" s date=+$h
	s tarItmId=""
	f  s tarItmId=$o(^DHCOLT(0,"ARTTA",arcItm,tarItmId)) q:tarItmId=""  d
	.s startDate=""
	.f  s startDate=$o(^DHCOLT(0,"ARTTA",arcItm,tarItmId,startDate)) q:startDate=""  d
	..s oltId=""
	..f  s oltId=$o(^DHCOLT(0,"ARTTA",arcItm,tarItmId,startDate,oltId)) q:oltId=""  d
	...q:+oltId=0
	...s oltStartDate=$p(^DHCOLT(oltId),"^",4)
	...s oltEndDate=$p(^DHCOLT(oltId),"^",5)
	...q:(oltStartDate'="")&&(oltStartDate>date)
	...q:(oltEndDate'="")&&(oltEndDate<date)
	...s tarItmPId=""
	...f  s tarItmPId=$o(^DHCTARI(tarItmId,"P",tarItmPId)) q:tarItmPId=""  d
	....s priceStartDate=$p(^DHCTARI(tarItmId,"P",tarItmPId),"^",3)
	....s priceEndDate=$p(^DHCTARI(tarItmId,"P",tarItmPId),"^",4)
	....q:(priceStartDate'="")&&(priceStartDate>date)
	....q:(priceEndDate'="")&&(priceEndDate<date)
	....s price=$p(^DHCTARI(tarItmId,"P",tarItmPId),"^",5)
	q $fn(price, "N")
}

/// description: 进程号
ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"PIVA")
}

}
