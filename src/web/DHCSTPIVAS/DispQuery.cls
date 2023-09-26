Import sqluser

/// description: 静配发药查询记录
Class web.DHCSTPIVAS.DispQuery Extends %RegisteredObject [ ProcedureBlock ]
{

/// creator:	dinghongying
/// createdate: 2018-03-13
/// description:获取病区列表
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.DispQuery","DispQueryWard","101^2017-03-13^2018-03-13^^^^^")
Query DispQueryWard(inputStr = "") As websys.Query(ROWSPEC = "wardId,wardDesc")
{
}

ClassMethod DispQueryWardExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:inputStr="" $$$OK
 	s collRet=..CollectDispQuery(inputStr, "DispQueryWard")
	s pid=$p(collRet,"^",1)
	q:pid="" $$$OK
	s sortIndex=""
	f  s sortIndex=$o(^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery","DispQueryWard",pid,sortIndex)) q:sortIndex=""  d
	.s wardId=""
	.f  s wardId=$o(^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery","DispQueryWard",pid,sortIndex,wardId)) q:wardId=""  d
	..s wardData=$g(^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery","DispQueryWard",pid,sortIndex,wardId))
	..q:wardData=""
	..s Data=$lfs(wardData,"^")
	..s ^CacheTemp(repid,ind)=Data 
	..s ind=ind+1
	d ..KillTmpDispQueryWard(pid)
	q $$$OK
}

/// creator:	dinghongying
/// createdate: 2018-03-14
/// description:获取发药信息列表,配液中心数量使用基本单位即可,配液中心药品不多
/// others:	
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.DispQuery","DispQueryDetail","186^2022-08-28^2022-11-21^^^4,3,9^^1^","")
Query DispQueryDetail(inputStr = "", raqflag = "") As websys.Query(ROWSPEC = "incId,incCode,incDesc,incSpec,phManfDesc,bUomDesc,dispQty,dispSpAmt,retQty,retSpAmt,totalQty,totalSpAmt") [ SqlProc ]
{
}

ClassMethod DispQueryDetailExecute(ByRef qHandle As %Binary, inputStr = "", raqflag = "") As %Status
{
    s trans("合计") = ##class(PHA.COM.Base).Get("合计")
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:inputStr="" $$$OK
	s %AmtDecimal = 2
	s collRet=..CollectDispQuery(inputStr, "DispQueryDetail")
	s pid=$p(collRet,"^",1)
	s total=$p(collRet,"^",2)
	q:(pid="")||(+total=0) $$$OK
	s PivaLocId=$p(inputStr,"^",1)
	s hospId=$p(^CTLOC(PivaLocId),"^",22)
	// 先输出汇总
	i raqflag="" d	// 非润乾计算总金额输出
	.s totalData=$g(^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery","DispQueryDetail",pid,"合计","合计"))
	.i totalData'="" d
	..s dispSpAmt=$p(totalData,"^",3)
	..s retSpAmt=$p(totalData,"^",5)
	..s totalSpAmt=dispSpAmt+retSpAmt
	..s dispSpAmt=##class(web.DHCSTPIVAS.Common).FmtNum($ZABS(dispSpAmt))
	..s retSpAmt=##class(web.DHCSTPIVAS.Common).FmtNum($ZABS(retSpAmt))
	..s totalSpAmt=##class(web.DHCSTPIVAS.Common).FmtNum($ZABS(totalSpAmt))
	..s dispSpAmt=$fn(dispSpAmt,"",%AmtDecimal)
	..s retSpAmt=$fn(retSpAmt,"",%AmtDecimal)
	..s totalSpAmt=$fn(totalSpAmt,"",%AmtDecimal)
	..s Data=$lb(0,"",trans("合计"),"","","","",dispSpAmt,"",retSpAmt,"",totalSpAmt)
	..s ^CacheTemp(repid,ind)=Data 
	..s ind=ind+1
	k ^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery","DispQueryDetail",pid,"合计","合计")
	s sortIndex=""
	f  s sortIndex=$o(^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery","DispQueryDetail",pid,sortIndex)) q:sortIndex=""  d
	.s incId=""
	.f  s incId=$o(^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery","DispQueryDetail",pid,sortIndex,incId)) q:incId=""  d
	..s data=^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery","DispQueryDetail",pid,sortIndex,incId)
	..s incId=$p(data,"^",1)
	..s incDesc=##class(PHA.COM.Data.Base).InciDesc(incId)
	..s incCode=$p(^INCI(incId,1),"^",1)
	..s bUom=$p(^INCI(incId,1),"^",10)
	..s bUomDesc=##class(PHA.COM.Data.Base).UomDesc(bUom)
	..s phManf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(incId),"^",1)
    ..s phManfDesc=##class(PHA.COM.Data.Base).ManfName(phManf)
	..s incSpec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",incId)
	..s dispQty=$p(data,"^",2)
	..s dispSpAmt=$p(data,"^",3)
	..s retQty=$p(data,"^",4)
	..s retSpAmt=$p(data,"^",5)
	..s totalQty=dispQty+retQty
	..s totalSpAmt=dispSpAmt+retSpAmt
	..s dispSpAmt=##class(web.DHCSTPIVAS.Common).FmtNum($ZABS(dispSpAmt))
	..s retSpAmt=##class(web.DHCSTPIVAS.Common).FmtNum($ZABS(retSpAmt))
	..s totalSpAmt=##class(web.DHCSTPIVAS.Common).FmtNum($ZABS(totalSpAmt))
	..s dispQty=##class(web.DHCSTPIVAS.Common).FmtNum($ZABS(dispQty))
	..s retQty=##class(web.DHCSTPIVAS.Common).FmtNum($ZABS(retQty))
	..s totalQty=##class(web.DHCSTPIVAS.Common).FmtNum($ZABS(totalQty))
	..s dispSpAmt=$fn(dispSpAmt,"",%AmtDecimal)
	..s retSpAmt=$fn(retSpAmt,"",%AmtDecimal)
	..s totalSpAmt=$fn(totalSpAmt,"",%AmtDecimal)
	..d outputDispQueryDetail
	d ..KillTmpDispQueryDetail(pid)
	q $$$OK
outputDispQueryDetail
	s Data=$lb(incId,incCode,incDesc,incSpec,phManfDesc,bUomDesc,dispQty,dispSpAmt,retQty,retSpAmt,totalQty,totalSpAmt)
	s ^CacheTemp(repid,ind)=Data 
	s ind=ind+1	
	q
}

/// creator: 	yunhaibao
/// createdate: 2018-03-30
/// description:统计发药数据
/// w ##class(web.DHCSTPIVAS.DispQuery).CollectDispQuery("248^05/07/2019^05/07/2019^01:00:00^16:59:56^^^1^","DispQueryWard")
ClassMethod CollectDispQuery(inputStr, queryType)
{
	s PivaLocId=$p(inputStr,"^",1)
	s StartDate=$p(inputStr,"^",2)
	s EndDate=$p(inputStr,"^",3)
	s StartTime=$p(inputStr,"^",4)
	s EndTime=$p(inputStr,"^",5)
	s WardIdStr=$p(inputStr,"^",6)
	s PatNo=$p(inputStr,"^",7)
	s OnlyPiva=$p(inputStr,"^",8)
	s IncId=$p(inputStr,"^",9)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	s WardIdList=$lfs(WardIdStr,",")
	q:(PivaLocId="")||(StartDate="")||(EndDate="") ""
	s pid=..NewPid()
	s typeStr="P^Y"
	s typeLen=$l(typeStr,"^")
	s count=0
	s calcuDate=""
	f calcuDate=StartDate:1:EndDate d
	.i IncId="" d
	..f typeI=1:1:typeLen d
	...s type=$p(typeStr,"^",typeI)
	...q:type=""
	...s intrId=""
	...f  s intrId=$o(^DHCINTR(0,"LOCTYPEDATE",PivaLocId,type,calcuDate,intrId)) q:intrId=""  d
	....d GetIntrData
	.e  d
	..s incCh=""
	..f  s incCh=$o(^INCI("IL_LOC",PivaLocId,IncId,incCh)) q:incCh=""  d
	...s incLb=""
	...f  s incLb=$o(^INCI(IncId,"IL",incCh,"LB",incLb)) q:incLb=""  d
	....s inclb=IncId_"||"_incCh_"||"_incLb
	....s intrId=""
	....f  s intrId=$o(^DHCINTR(0,"INCLB",inclb,calcuDate,intrId)) q:intrId=""  d
	.....s type=$p(^DHCINTR(intrId),"^",1)
	.....q:typeStr'[type
	.....d GetIntrData
	q pid_"^"_count
GetIntrData
	s intrTime=$p(^DHCINTR(intrId),"^",3)
	q:(StartTime'="")&&(calcuDate=StartDate)&&(intrTime<StartTime)
	q:(EndTime'="")&&(calcuDate=EndDate)&&(intrTime>EndTime)
	s pointer=$p(^DHCINTR(intrId),"^",9) 
	s dspId=""
	i type="P" d
	.s dspId=+$p($g(^DHCPHAC(+pointer,"I",+$p(pointer,"||",2))),"^",13)
	e  i type="Y" d
	.s dspId=+$p($g(^PHARET(+pointer,"I",+$p(pointer,"||",2))),"^",13)
	q:dspId=0
	s wardLocId=$p(^DHCOEDISQTY(dspId),"^",22)
    s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
    q:(WardIdStr'="")&&($lf(WardIdList,wardId)=0)
    i PatNo'="" d
    .s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
    .s admId=$p(^OEORD(+oeori),"^",1)
	.s patId=$p(^PAADM(admId),"^",1)                    						
	.s patNo=$P(^PAPER(patId,"PAT",1),"^",1) 
	q:(PatNo'="")&&(PatNo'=patNo)
    i queryType="DispQueryWard" d
    .s wardDesc=##class(PHA.PIVAS.Data.Base).WardDesc(wardId)
    .q:wardDesc=""
    .s sortIndex=wardDesc
    .s ^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery",queryType,pid,sortIndex,wardId)=wardId_"^"_wardDesc
    e  i queryType="DispQueryDetail" d
 	.s inclb=$p(^DHCINTR(intrId),"^",7)
 	.s incId=+inclb
 	.// 需要计算合计
 	.s intrUom=$p(^DHCINTR(intrId),"^",10) 
 	.s intrQty=$p(^DHCINTR(intrId),"^",6)
 	.s bUom=$p(^INCI(incId,1),"^",10)
 	.s biFac=##class(web.DHCSTCOMMONSRV).UOMFac(intrUom,intrQty)
 	.s bQty=intrQty*biFac
 	.s intrSpAmt=$p($G(^DHCINTR(intrId)),"^",8)
 	.s intrRpAmt=$p($G(^DHCINTR(intrId)),"^",17)
 	.s %AmtDecimal = ##class(web.DHCSTPIVAS.Common).MaxDecimal(%AmtDecimal, intrSpAmt)
 	.s sortIndex="1"
 	.// 库存Id^发药数量^发药金额^退药数量^退药金额
 	.// 按药品汇总
 	.i '$d(^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery",queryType,pid,sortIndex,incId)) d
 	..i type="P" d  	// 发药
 	...s data=incId_"^"_bQty_"^"_intrSpAmt_"^"_0_"^"_0
 	..e  i type="Y" d 	// 退药
 	...s data=incId_"^0^0^"_bQty_"^"_intrSpAmt
 	..s ^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery",queryType,pid,sortIndex,incId)=data
 	..s count=count+1
 	.e  d
 	..i type="P" d		// 发药
 	...s $p(^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery",queryType,pid,sortIndex,incId),"^",2)=bQty+$p(^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery",queryType,pid,sortIndex,incId),"^",2)
 	...s $p(^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery",queryType,pid,sortIndex,incId),"^",3)=intrSpAmt+$p(^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery",queryType,pid,sortIndex,incId),"^",3)
 	..e  i type="Y" d 	// 退药
 	...s $p(^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery",queryType,pid,sortIndex,incId),"^",4)=bQty+$p(^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery",queryType,pid,sortIndex,incId),"^",4)
 	...s $p(^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery",queryType,pid,sortIndex,incId),"^",5)=intrSpAmt+$p(^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery",queryType,pid,sortIndex,incId),"^",5)
 	.// 配液中心合计
	.i type="P" d 
	..s $p(^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery",queryType,pid,"合计","合计"),"^",3)=intrSpAmt+$p($g(^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery",queryType,pid,"合计","合计")),"^",3)
	.e  i type="Y" d
	..s $p(^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery",queryType,pid,"合计","合计"),"^",5)=intrSpAmt+$p($g(^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery",queryType,pid,"合计","合计")),"^",5)
 	q
}

ClassMethod KillTmpDispQueryWard(pid)
{
	q:pid="" ""
	k ^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery","DispQueryWard",pid)
	q ""
}

ClassMethod KillTmpDispQueryDetail(pid)
{
	q:pid="" ""
	k ^||TMP("DHCST","web.DHCSTPIVAS.DispQuery","CollectDispQuery","DispQueryDetail",pid)
	q ""
}

ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($this,"PIVA")
}

}
