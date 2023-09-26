/// Description: 配液配置量折线图
Class web.DHCSTPIVAS.Charts.LinePS60 Extends %RegisteredObject
{

/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Charts.LinePS60","QueryDateCnt","248^2019-01-01^2019-12-31")
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
	s psId60=##class(web.DHCSTPIVAS.Common).LocPsIdByPsNumber(PivaLocId,60)
	q:psId60="" $$$OK
	s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
	s EdDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EdDate)
	f calcuDate=StDate:1:EdDate d
	.s pogId=""
	.f  s pogId=$o(^PIVA(0,"DATELOC",PivaLocId,calcuDate,psId60,pogId)) q:pogId=""  d
	..q:+pogId=0
	..s QueryDateCntDATA(+calcuDate)=$g(QueryDateCntDATA(+calcuDate))+1
	s calcuDate=""
	f  s calcuDate=$o(QueryDateCntDATA(calcuDate)) q:calcuDate=""  d
	.s date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(calcuDate) //$zd(calcuDate,3)
	.s ^CacheTemp(repid,ind)=$lb(date,+$g(QueryDateCntDATA(calcuDate))) 
	.s ind=ind+1
	q $$$OK
}

/// w ##class(web.DHCSTPIVAS.Charts.LinePS60).Test()
ClassMethod Test()
{
	s i=""
	f  s i=$o(^TMPDHCSTPIVAS(i)) q:i=""  d
	.q:i=""
	.s ni=$zdh(i,3)
	.s ^TMPDHCSTPIVAS(ni)=^TMPDHCSTPIVAS(i)
	.k ^TMPDHCSTPIVAS(i)
	q ""
	s ^TMPDHCSTPIVAS("2019-8-1")=3931
	s ^TMPDHCSTPIVAS("2019-8-2")=3792
	s ^TMPDHCSTPIVAS("2019-8-3")=3780
	s ^TMPDHCSTPIVAS("2019-8-4")=3606
	s ^TMPDHCSTPIVAS("2019-8-5")=3486
	s ^TMPDHCSTPIVAS("2019-8-6")=3654
	s ^TMPDHCSTPIVAS("2019-8-7")=3859
	s ^TMPDHCSTPIVAS("2019-8-8")=4290
	s ^TMPDHCSTPIVAS("2019-8-9")=4249
	s ^TMPDHCSTPIVAS("2019-8-10")=4162
	s ^TMPDHCSTPIVAS("2019-8-11")=4109
	s ^TMPDHCSTPIVAS("2019-8-12")=3951
	s ^TMPDHCSTPIVAS("2019-8-13")=4086
	s ^TMPDHCSTPIVAS("2019-8-14")=4239
	s ^TMPDHCSTPIVAS("2019-8-15")=4451
	s ^TMPDHCSTPIVAS("2019-8-16")=4502
	s ^TMPDHCSTPIVAS("2019-8-17")=4381
	s ^TMPDHCSTPIVAS("2019-8-18")=4051
	s ^TMPDHCSTPIVAS("2019-8-19")=3788
	s ^TMPDHCSTPIVAS("2019-8-20")=3913
	s ^TMPDHCSTPIVAS("2019-8-21")=4193
	s ^TMPDHCSTPIVAS("2019-8-22")=4676
	s ^TMPDHCSTPIVAS("2019-8-23")=4616
	s ^TMPDHCSTPIVAS("2019-8-24")=4408
	s ^TMPDHCSTPIVAS("2019-8-25")=4183
	s ^TMPDHCSTPIVAS("2019-8-26")=3844
	s ^TMPDHCSTPIVAS("2019-8-27")=3961
	s ^TMPDHCSTPIVAS("2019-8-28")=4338
	s ^TMPDHCSTPIVAS("2019-8-29")=4559
	s ^TMPDHCSTPIVAS("2019-8-30")=4590
	s ^TMPDHCSTPIVAS("2019-8-31")=4566
}

}
