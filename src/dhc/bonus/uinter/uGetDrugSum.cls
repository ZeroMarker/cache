Class dhc.bonus.uinter.uGetDrugSum Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// creator:yunhaibao
/// createdate:20141202
/// description:给绩效接口,获取指定日期库存进售价
/// input:日期(2014-12-02),科室(xyf-西药房)
/// w ##class(dhc.bonus.uinter.uGetDrugSum).GetSumInciSpRp("2014-12-02","xyk-西药库")
ClassMethod GetSumInciSpRp(cacudate, locdesc)
{
	s locdesc="mzxyf-门诊西药房"
	
	s rptotal=0,sptotal=0
	s spdate=$zdh(cacudate,3)
	&SQL(SELECT ctloc_rowid into:locDr FROM sqluser.CT_Loc WHERE CTLOC_Desc=:locdesc)
	s inci=""
	f  s inci=$o(^INCI("IL_LOC",locDr,inci)) Q:inci=""  d
	.s inciloc=""
	.f  s inciloc=$o(^INCI("IL_LOC",locDr,inci,inciloc)) q:inciloc=""  d
	..s incilb=""
	..f  s incilb=$o(^INCI(inci,"IL",inciloc,"LB",incilb)) q:incilb=""  d
	...s inclb=inci_"||"_inciloc_"||"_incilb
	...s puom=$p(^INCI(inci,3),"^",6)
	...s buom=$p(^INCI(inci,1),"^",10)
	...q:(+buom=0)||(+puom=0)
	...s curlbqty=##class(web.DHCSTSTKQTY).QtyINCLB(inclb,cacudate)
	...s fac=##class(web.DHCSTCOMMONSRV).UOMFac(puom,buom)  //转换系数
	...s puomqty=curlbqty/fac  //入库单位数量
	...s sp=##class(web.DHCSTCOMMONSRV).GetPriceElse(inci,spdate,puom)
	...s rp=##class(web.DHCSTPRICE).LastInPrice(inclb,puom)
	...s spamt=sp*puomqty
	...s rpamt=rp*puomqty
	...s rptotal=rptotal+rpamt
	...s sptotal=sptotal+spamt
	q rptotal_"^"_sptotal
}

Storage Default
{
<StreamLocation>^dhc.bonus.uinter.uGetDrugSumS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
