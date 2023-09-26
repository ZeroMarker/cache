/// Description: 配液退药量折线图
Class web.DHCSTPIVAS.Charts.LineReturn Extends %RegisteredObject
{

/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Charts.LineReturn","QueryDateCnt","248^2019-01-01^2019-12-31")
Query QueryDateCnt(InputStr = "") As websys.Query(ROWSPEC = "calcuDate,cnt")
{
}

ClassMethod QueryDateCntExecute(ByRef qHandle As %Binary, InputStr = "") As %Status
{
	k QueryDateCntDATA
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PivaLocId=$p(InputStr,"^",1)
	s StDate=$p(InputStr,"^",2)
	s EdDate=$p(InputStr,"^",3)
	q:(+PivaLocId=0)||(StDate="")||(EdDate="") $$$OK
	s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
	s EdDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EdDate)
	f calcuDate=StDate:1:EdDate d
	.s phaRetId=""
	.f  s phaRetId=$o(^PHARET(0,"RECLOC",PivaLocId,calcuDate,phaRetId)) q:phaRetId=""  d
	..q:+phaRetId=0
	..s phaRetItm=""
	..f  s phaRetItm=$o(^PHARET(phaRetId,"I",phaRetItm)) q:phaRetItm=""  d
	...q:+phaRetItm=0
	...s phaRetLb=""
	...f  s phaRetLb=$o(^PHARET(phaRetId,"I",phaRetItm,"B",phaRetLb)) q:phaRetLb=""  d
	....q:+phaRetLb=0
	....s phacItmLbId=$p(^PHARET(phaRetId,"I",phaRetItm,"B",phaRetLb),"^",8)
	....q:phacItmLbId=""
	....s dspId=$p(^DHCPHAC(+phacItmLbId,"I",+$p(phacItmLbId,"||",2)),"^",13)
	....s grpNo=$p(^DHCOEDISQTY(dspId),"^",4)
	....s mDsp=##class(web.DHCSTPIVAS.Common).GetMainDspId(dspId,grpNo)
	....q:mDsp=""
	....q:$d(QueryDateCntDATA("Exist",mDsp))
	....q:$p(^DHCOEDISQTY(mDsp),"^",27)'=0	// 非配液医嘱
	....s QueryDateCntDATA("Exist",mDsp)=""
	....s QueryDateCntDATA("Data",calcuDate)=$g(QueryDateCntDATA("Data",calcuDate))+1
	s calcuDate=""
	f  s calcuDate=$o(QueryDateCntDATA("Data",calcuDate)) q:calcuDate=""  d
	.s date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(calcuDate)
	.s ^CacheTemp(repid,ind)=$lb(date,+$g(QueryDateCntDATA("Data",calcuDate))) 
	.s ind=ind+1
	q $$$OK
}

}
