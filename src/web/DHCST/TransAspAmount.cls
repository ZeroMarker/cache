/// Description:各业务的损益统计
/// Creater:	yunhaibao
/// CreateDate:	2015-11-30
Class web.DHCST.TransAspAmount Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Creater:	yunhaibao
/// CreateDate:	2015-11-30
/// Description:针对调价后,各业务可能产生相关损益
/// w ##class(%ResultSet).RunQuery("web.DHCST.TransAspAmount","QueryTransAspAmount","","2015-01-01","2015-11-11","","","","^R^1")
Query QueryTransAspAmount(LocRowid As %String = "", StartDate As %String = "", EndDate As %String = "", StartTime As %String = "", EndTime As %String = "", StkTypeId As %String = "", Others As %String = "") As websys.Query(ROWSPEC = "Rowid:%String,InciRowid:%String,InciCode:%String,InciDesc:%String,LocDesc:%String,DiffRp:%Double,DiffRpAmt:%Double,DiffSp:%Double,DiffSpAmt:%Double,TransQty:%Double,TransUomDesc:%String,TransType:%String") [ SqlProc ]
{
}

ClassMethod QueryTransAspAmountExecute(ByRef qHandle As %Binary, LocRowid As %String = "", StartDate As %String = "", EndDate As %String = "", StartTime As %String = "", EndTime As %String = "", StkTypeId As %String = "", Others As %String = "") As %Status
{
	n (qHandle, LocRowid, StartDate, EndDate, StartTime, EndTime, Others)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	i StartTime[":" s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	i EndTime[":" s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	s transtype=$p(Others,"^",2)
	s incirowid=$p(Others,"^",1)
	s stktypeid=$p(Others,"^",3)
	s locid=""
	f  s locid=$o(^DHCRETA(0,"LOCDATE",locid)) q:locid=""  d
	.q:+locid=0
	.q:(LocRowid'="")&&(LocRowid'=locid)  //过滤科室
	.s hospid=$p($g(^CTLOC(locid)),"^",22)
	.s locdesc=$p(^CTLOC(locid),"^",2)
	.i locdesc["-" s locdesc=$p(locdesc,"-",2)
	.s cacudate=""
	.f cacudate=StartDate:1:EndDate d
	..s asparowid=""
	..f  s asparowid=$o(^DHCRETA(0,"LOCDATE",locid,cacudate,asparowid)) q:asparowid=""  d
	...q:+asparowid=0
	...s aspadata=^DHCRETA(asparowid)
	...s asptime=$p(aspadata,"^",8)
	...q:(cacudate=StartDate)&&(StartTime'="")&&(asptime<StartTime)
	...q:(cacudate=EndDate)&&(EndTime'="")&&(asptime>EndTime)
	...s inci=$p(aspadata,"^",1)
	...q:(incirowid'="")&&(incirowid'=inci)
	...s stktypestr=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	...s stktyperowid=$p(stktypestr,"^",5)
	...s StkTypeDesc=$p(stktypestr,"^",4)
	...s stktype=$p(stktypestr,"^",3)
	...q:stktype'=..sssCode()
	...q:(stktypeid'="")&&(stktypeid'=stktyperowid)
	...s diffrp=$p(aspadata,"^",11)
	...s diffsp=$p(aspadata,"^",3)
	...s diffrpamt=$p(aspadata,"^",12)
	...s diffspamt=$p(aspadata,"^",5)
	...s diffrpamt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(diffrpamt,hospid)
	...s diffspamt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(diffspamt,hospid)
	...s incicode=$p(^INCI(inci,1),"^",1)
	...s incidesc=$p(^INCI(inci,1),"^",2)
	...s uom=$p(aspadata,"^",13)
	...s uomdesc=$p(^CT("UOM",uom),"^",2)
	...s puom=$p(^INCI(inci,3),"^",6)
	...s buom=$p(^INCI(inci,1),"^",10)
	...s puomdesc=$p(^CT("UOM",puom),"^",2)
	...s fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)
	...s fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(puom,buom)
	...s qty=$p(aspadata,"^",4)
	...s qty=qty*fac1/fac2  //转换为入库单位数
	...s qty=$fn(qty,"",2)
	...s diffrp=diffrp/fac1*fac2
	...s diffsp=diffsp/fac1*fac2
	...i $d(^$R("^web.DHCSTCOMMPARA.1")) d
    ....S CustID=##Class(web.DHCSTCOMMO).GetCusIDByHospID(hospid) //DHC_STCustomer
    ....S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
    ....i buom=puom d
    .....s diffrp=##Class(web.DHCSTCOMMPARA).GetNumbDec(diffrp,Perv,"FmtRP",2)
    .....s diffsp=##Class(web.DHCSTCOMMPARA).GetNumbDec(diffsp,Perv,"FmtSP",2)
    ....e  d
    .....s diffsp=##Class(web.DHCSTCOMMPARA).GetNumbDec(diffsp,Perv,"FmtSP",1)
    .....s diffrp=##Class(web.DHCSTCOMMPARA).GetNumbDec(diffrp,Perv,"FmtRP",1)
	...s type=$p(aspadata,"^",10)
	...q:(transtype'="")&&(transtype'=type)
	...i type="G" s type="入库"
	...e  i type="R" s type="退货"
	...e  i type="K" s type="转移入库"
	...e  i type="H" s type="门诊退药"
	...e  i type="Y" s type="住院退药"
	...e  i type="F" s type="门诊发药"
	...e  i type="P" s type="住院发药"
	...e  i type="M" s type="制剂损耗"
	...e  s type="未知"
	...d OutPutRow
	q $$$OK

OutPutRow
	s Data=$lb(asparowid,inci,incicode,incidesc,locdesc,diffrp,diffrpamt,diffsp,diffspamt,qty,puomdesc,type)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
