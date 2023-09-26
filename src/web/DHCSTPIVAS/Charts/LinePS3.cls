/// Description: 配液排批修改量折线图
Class web.DHCSTPIVAS.Charts.LinePS3 Extends %RegisteredObject
{

/// Description: 仅用于统计用户是否修改过,便于观测排批规则的有效利用或不怎么满足待改进
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Charts.LinePS3","QueryDateCnt","248^2019-01-01^2019-12-31")
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
	.s pbuId=""
	.f  s pbuId=$o(^PIVABU(0,"Date",calcuDate,pbuId)) q:pbuId=""  d
	..q:+pbuId=0
	..s PIVABU=$g(^PIVABU(pbuId))
	..q:$p(PIVABU,"^",8)'["用户修改"	// 多次修改也算1
	..s mDsp=$p(PIVABU,"^",1)
	..q:$d(QueryDateCntDATA("Exist",mDsp))
	..s QueryDateCntDATA("Exist",mDsp)=""
	..s recLocId=$p(^DHCOEDISQTY(mDsp),"^",24)
	..q:recLocId'=PivaLocId
	..s QueryDateCntDATA("Data",calcuDate)=$g(QueryDateCntDATA("Data",calcuDate))+1
	s calcuDate=""
	f  s calcuDate=$o(QueryDateCntDATA("Data",calcuDate)) q:calcuDate=""  d
	.s date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(calcuDate)
	.s ^CacheTemp(repid,ind)=$lb(date,+$g(QueryDateCntDATA("Data",calcuDate))) 
	.s ind=ind+1
	q $$$OK
}

}
