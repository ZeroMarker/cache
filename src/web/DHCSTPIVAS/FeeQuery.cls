/// Description: 配置费用查询
/// Creator:	 yunhaibao
/// CreateDate:	 2019-04-04
Class web.DHCSTPIVAS.FeeQuery Extends %RegisteredObject
{

/// Description: 单组药品窗体查询
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.FeeQuery","OrdGrpOrder",56)
Query OrdGrpOrder(PogId) As websys.Query(ROWSPEC = "oeori,arcimDesc,qty,oeoriDateTime,userName,oeoriStatDesc") [ SqlProc ]
{
}

ClassMethod OrdGrpOrderExecute(ByRef qHandle As %Binary, PogId) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:+PogId=0 $$$OK
	q:'$d(^PIVA(PogId,"O")) $$$OK
	s pogoItm=""
	f  s pogoItm=$o(^PIVA(PogId,"O",pogoItm)) q:pogoItm=""  d
	.s oeori=^PIVA(PogId,"O",pogoItm)
	.s ordId=+oeori
	.s ordItm=+$p(oeori,"||",2)
	.s userName=$p(##class(web.DHCSTCOMMONORDER).OeoriDoctor(oeori),"^",2)
	.s oeoriDateTime=##class(web.DHCSTCOMMONORDER).OeoriDateTime(oeori)
	.s oeoriStatDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriStat(oeori),"^",2)
	.s arcimDr=$p(^OEORD(ordId,"I",ordItm,1),"^",2)
	.s arcimDesc=##class(PHA.COM.Data.Base).ArcimDesc(arcimDr)
	.s qty=$P(^OEORD(ordId,"I",ordItm,1),"^",12)
	.s ^CacheTemp(repid,ind)=$lb(oeori,arcimDesc,qty,oeoriDateTime,userName,oeoriStatDesc)    
	.s ind=ind+1
	Quit $$$OK
}

}
