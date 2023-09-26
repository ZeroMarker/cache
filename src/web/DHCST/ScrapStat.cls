Import sqluser

/// Descript:库存报损统计
/// Creater:    caoting
/// CreateDate:	2012-12-02
/// 
Class web.DHCST.ScrapStat Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// w ##class(web.DHCST.ScrapStat).GetScrapInfo(0,30,"17/08/2017^17/08/2018^G^320^^^3")
ClassMethod GetScrapInfo(Start As %String, Limit As %String, StrPar As %String) As %String
{
	
	s endpage=Start+Limit  //结束行
	s stpage=Start+1 //开始行
	s h=0,SpAmtSum=0,RpAmtSum=0
	s StartDate=$p(StrPar,"^",1)
	s EndDate=$p(StrPar,"^",2)
	s StkType=$p(StrPar,"^",3)
	s Loc=$p(StrPar,"^",4)
	s ItmDr=$p(StrPar,"^",5)
	s ReasonDr=$p(StrPar,"^",6)
	s StkGrpType=$p(StrPar,"^",7)
	Q:Loc="" ""
	Q:StartDate="" ""
	Q:EndDate="" ""
	i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s HospID=$p($g(^CTLOC(Loc)),"^",22)
	S pid=$I(^TMP("DHCST","ScrapStat","GetScrapInfo"))

	F Date=StartDate:1:EndDate  d
	.S INTR=""
	.F  S INTR=$o(^DHCINTR(0,"TypeDate","D",Date,INTR))  Q:INTR=""  D
	..S TrPointer=$p(^DHCINTR(INTR),"^",9)
	..s ScrapDr=+TrPointer
	..s reasondr=$p(^DHCINSP(ScrapDr),"^",4)
	..Q:(ReasonDr'="")&(reasondr'=ReasonDr)
	..s scgdr=$p(^DHCINSP(ScrapDr),"^",13)
	..Q:(StkGrpType'="")&(scgdr'=StkGrpType)
	..S stktypedr=$p(^DHCINSP(ScrapDr),"^",15)
	..Q:(StkType'="")&(stktypedr'=StkType)
	..s locdr=$p(^DHCINSP(ScrapDr),"^",5)
	..Q:(Loc'="")&(locdr'=Loc)
	..S ScrapSub=$P(TrPointer,"||",2)
	..S INCI=$p(^DHCINTR(INTR),"^",15)
	..S INCLB=$p(^DHCINTR(INTR),"^",7) 
	..S ILSub=$p(INCLB,"||",2)
	..Q:'$d(^INCI(INCI))
	..S LocDr=$p(^INCI(INCI,"IL",ILSub),"^",1)
	..Q:Loc'=LocDr
	..S InciCode=$p(^INCI(INCI,1),"^",1)
	..S InciDesc=$p(^INCI(INCI,1),"^",2)
	..s buomdr=$p(^INCI(INCI,1),"^",10)
	..s puomdr=$p(^INCI(INCI,3),"^",6)
	..Q:(ItmDr'="")&(ItmDr'=INCI)
	..S mdata=^DHCINSP(ScrapDr,"I",ScrapSub)
	..S Qty=$p(mdata,"^",3)	//报损单位数量
	..S Sp=$p(mdata,"^",8)		//报损单位售价
	..S Uomdr=$p(mdata,"^",2)	//报损单位
	..S SpAmt=$p(mdata,"^",9)	//售价金额
	..S Rp=$p(mdata,"^",4)		//进价
	..S RpAmt=$p(mdata,"^",5)	//进价金额
	..S SpAmtSum=SpAmtSum+SpAmt
	..S RpAmtSum=RpAmtSum+RpAmt
	..s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(Uomdr,buomdr)
	..S bSp=Sp/fac
	..S bRp=Rp/fac
	..S UomDesc=$P($G(^CT("UOM",puomdr)),"^",2)
	..S ManfStr=##Class(web.DHCST.Common.DrugInfoCommon).GetManf(INCI)
	..S ManfDesc=$P(ManfStr,"^",3)
	..S Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec(InciCode,INCI)
	..s bQty=Qty*fac
	..s bpFac=##class(web.DHCST.Common.UtilCommon).UOMFac(puomdr,buomdr)
	..i Uomdr'=puomdr d
	...s Sp=bSp*bpFac
	...s Rp=bRp*bpFac
	...s Sp=##class(web.DHCST.Common.AppCommon).FormatSp(Sp,HospID,1,"G")
	...s Rp=##class(web.DHCST.Common.AppCommon).FormatRp(Rp,HospID,1,"G")
	..S index=INCI_"^"_ManfDesc_"^"_bSp_"^"_bRp
	..i $d(^TMP("DHCST","ScrapStat","GetScrapInfo",pid,"index",index)) d
	...s $p(^TMP("DHCST","ScrapStat","GetScrapInfo",pid,"index",index),"^",5)=$p(^TMP("DHCST","ScrapStat","GetScrapInfo",pid,"index",index),"^",5)+bQty
	...s $p(^TMP("DHCST","ScrapStat","GetScrapInfo",pid,"index",index),"^",7)=$p(^TMP("DHCST","ScrapStat","GetScrapInfo",pid,"index",index),"^",7)+SpAmt
	...s $p(^TMP("DHCST","ScrapStat","GetScrapInfo",pid,"index",index),"^",9)=$p(^TMP("DHCST","ScrapStat","GetScrapInfo",pid,"index",index),"^",9)+RpAmt
	..e  d
	...s h=h+1
	...s ^TMP("DHCST","ScrapStat","GetScrapInfo",pid,"index",index)=INCI_"^"_InciCode_"^"_InciDesc_"^"_UomDesc_"^"_bQty_"^"_Sp_"^"_SpAmt_"^"_Rp_"^"_RpAmt_"^"_ManfDesc_"^"_Spec_"^"_bpFac

	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s sumstring=""
	s $p(sumstring,"^",2)="合计金额"
	s $p(sumstring,"^",7)=SpAmtSum
	s $p(sumstring,"^",9)=RpAmtSum
	s h=h+1
	s ^TMP("DHCST","ScrapStat","GetScrapInfo",pid,"index",h)=sumstring //合计
	s maxrow=h
	i endpage>maxrow s endpage=maxrow

	s count=0
	S h=""
	f  s h=$o(^TMP("DHCST","ScrapStat","GetScrapInfo",pid,"index",h)) q:h=""  d
	.s Sdata=^TMP("DHCST","ScrapStat","GetScrapInfo",pid,"index",h)
	.S Inci=$P(Sdata,"^",1)
	.S InciCode=$P(Sdata,"^",2)
	.S InciDesc=$P(Sdata,"^",3)
	.S UomDesc=$P(Sdata,"^",4)
	.S ScrapQty=$P(Sdata,"^",5)
	.S Sp=$P(Sdata,"^",6)
	.i (Sp>0)&&(Sp<1) s Sp=0_Sp
	.S Rp=$P(Sdata,"^",8)
	.i (Rp>0)&&(Rp<1) s Rp=0_Rp
	.S SpAmt=$P(Sdata,"^",7)
	.i (SpAmt>0)&&(SpAmt<1) s SpAmt=0_SpAmt
	.S RpAmt=$P(Sdata,"^",9)
	.i (RpAmt>0)&&(RpAmt<1) s RpAmt=0_RpAmt
	.S Manf=$P(Sdata,"^",10)
	.S Spec=$P(Sdata,"^",11)
	.s Fac=$P(Sdata,"^",12)
	.i Fac'="" s ScrapQty=ScrapQty/Fac
	.s count=count+1
	.q:count<stpage
	.q:count>endpage
	.
	.s Inci=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Inci",Inci)
	.s InciCode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("InciCode",InciCode)
	.s InciDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("InciDesc",InciDesc)
	.s UomDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ScrapUom",UomDesc)
	.s ScrapQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ScrapQty",ScrapQty)
	.s Sp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Sp",Sp)
	.s Rp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Rp",Rp)
	.s SpAmt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("SpAmt",SpAmt)
	.s RpAmt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("RpAmt",RpAmt)
	.s Manf=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Manf",Manf)
	.s Spec=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("Spec",Spec)
	.s tmpstr=Inci_InciCode_InciDesc_UomDesc_ScrapQty_Sp_Rp_SpAmt_RpAmt_Manf_Spec

	.s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
	.s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
	.s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.i count=stpage w startString
	.i count<endpage w firstrow
	.i count=endpage w lastrow

	k ^TMP("DHCST","ScrapStat","GetScrapInfo",pid)
	q ""
}

/// d ##class(%ResultSet).RunQuery("web.DHCST.ScrapStat","ScrapStatPrt","29/09/2020","25/12/2020","G","165","","","3")
Query ScrapStatPrt(StartDate As %String, EndDate As %String, StkType As %String, Loc As %String, ItmDr As %String, ReasonDr As %String, StkGrpType As %String, USERID As %String) As %Query(ROWSPEC = "Inci:%String,InciCode:%String,InciDesc:%String,UomDesc:%String,ScrapQty:%Double,Sp:%Double,Rp:%Double,SpAmt:%Double,RpAmt:%Double,Manf:%String,Spec:%String,UserIO,LocdescIO,hospDescIO") [ SqlProc ]
{
}

ClassMethod ScrapStatPrtExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, StkType As %String, Loc As %String, ItmDr As %String, ReasonDr As %String, StkGrpType As %String, USERID As %String) As %Status
{
	S repid=$I(^CacheTemp)
	S ind=1
	S qHandle=$lb(0,repid,0)
	Q:Loc="" $$$OK
	Q:StartDate="" $$$OK
	Q:EndDate="" $$$OK
	s UserIO="",LocdescIO=""
	s:USERID'="" UserIO=$P(^SSU("SSUSR",USERID),"^",2)
	s LocdescIO=$P(^CTLOC(Loc),"^",2)
	s hosp=$P(^CTLOC(Loc),"^",22)
	s hospDescIO=$P(^CT("HOSP",hosp),"^",2)
	i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s HospID=$p($g(^CTLOC(Loc)),"^",22)
	S pid=$I(^TMP("DHCST","ScrapStat","ScrapStatPrt"))
	F Date=StartDate:1:EndDate  d
	.S INTR=""
	.F  S INTR=$o(^DHCINTR(0,"TypeDate","D",Date,INTR))  Q:INTR=""  D
	..S TrPointer=$p(^DHCINTR(INTR),"^",9)
	..s ScrapDr=+TrPointer
	..s reasondr=$p(^DHCINSP(ScrapDr),"^",4)
	..Q:(ReasonDr'="")&(reasondr'=ReasonDr)
	..s scgdr=$p(^DHCINSP(ScrapDr),"^",13)
	..Q:(StkGrpType'="")&(scgdr'=StkGrpType)
	..S stktypedr=$p(^DHCINSP(ScrapDr),"^",15)
	..Q:(StkType'="")&(stktypedr'=StkType)
	..s locdr=$p(^DHCINSP(ScrapDr),"^",5)
	..Q:(Loc'="")&(locdr'=Loc)
	..S ScrapSub=$P(TrPointer,"||",2)
	..S INCI=$p(^DHCINTR(INTR),"^",15)
	..S INCLB=$p(^DHCINTR(INTR),"^",7) 
	..S ILSub=$p(INCLB,"||",2)
	..Q:'$d(^INCI(INCI))
	..S LocDr=$p(^INCI(INCI,"IL",ILSub),"^",1)
	..Q:Loc'=LocDr
	..S InciCode=$p(^INCI(INCI,1),"^",1)
	..S InciDesc=$p(^INCI(INCI,1),"^",2)
	..s buomdr=$p(^INCI(INCI,1),"^",10)
	..s puomdr=$p(^INCI(INCI,3),"^",6)
	..Q:(ItmDr'="")&(ItmDr'=INCI)
	..S mdata=^DHCINSP(ScrapDr,"I",ScrapSub)
	..S Qty=$p(mdata,"^",3)	//报损单位数量
	..S Sp=$p(mdata,"^",8)		//报损单位售价
	..S Uomdr=$p(mdata,"^",2)	//报损单位
	..S SpAmt=$p(mdata,"^",9)	//售价金额
	..S Rp=$p(mdata,"^",4)		//进价
	..S RpAmt=$p(mdata,"^",5)	//进价金额
	..s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(Uomdr,buomdr)
	..S bSp=Sp/fac
	..S bRp=Rp/fac
	..S UomDesc=$P($G(^CT("UOM",puomdr)),"^",2)
	..S ManfStr=##Class(web.DHCST.Common.DrugInfoCommon).GetManf(INCI)
	..S ManfDesc=$P(ManfStr,"^",3)
	..S Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec(InciCode,INCI)
	..s bpFac=##class(web.DHCST.Common.UtilCommon).UOMFac(puomdr,buomdr)
	..s bQty=Qty
	..i Uomdr'=puomdr d
	...s Sp=bSp*bpFac
	...s Rp=bRp*bpFac
	...s bQty=Qty*fac
	...s Sp=##class(web.DHCST.Common.AppCommon).FormatSp(Sp,HospID,1,"G")
	...s Rp=##class(web.DHCST.Common.AppCommon).FormatRp(Rp,HospID,1,"G")
	..S index=INCI_"^"_ManfDesc_"^"_bSp_"^"_bRp
	..i $d(^TMP("DHCST","ScrapStat","ScrapStatPrt",pid,"index",index)) d
	...s $p(^TMP("DHCST","ScrapStat","ScrapStatPrt",pid,"index",index),"^",5)=$p(^TMP("DHCST","ScrapStat","ScrapStatPrt",pid,"index",index),"^",5)+bQty
	...s $p(^TMP("DHCST","ScrapStat","ScrapStatPrt",pid,"index",index),"^",7)=$p(^TMP("DHCST","ScrapStat","ScrapStatPrt",pid,"index",index),"^",7)+SpAmt
	...s $p(^TMP("DHCST","ScrapStat","ScrapStatPrt",pid,"index",index),"^",9)=$p(^TMP("DHCST","ScrapStat","ScrapStatPrt",pid,"index",index),"^",9)+RpAmt
	..e  d
	...s ^TMP("DHCST","ScrapStat","ScrapStatPrt",pid,"index",index)=INCI_"^"_InciCode_"^"_InciDesc_"^"_UomDesc_"^"_bQty_"^"_Sp_"^"_SpAmt_"^"_Rp_"^"_RpAmt_"^"_ManfDesc_"^"_Spec_"^"_bpFac

	S h=""
	f  s h=$o(^TMP("DHCST","ScrapStat","ScrapStatPrt",pid,"index",h)) q:h=""  d
	.s Sdata=^TMP("DHCST","ScrapStat","ScrapStatPrt",pid,"index",h)
	.S Inci=$P(Sdata,"^",1)
	.S InciCode=$P(Sdata,"^",2)
	.S InciDesc=$P(Sdata,"^",3)
	.S UomDesc=$P(Sdata,"^",4)
	.S ScrapQty=$P(Sdata,"^",5)
	.S Sp=$P(Sdata,"^",6)
	.S Rp=$P(Sdata,"^",8)
	.S SpAmt=$P(Sdata,"^",7)
	.S RpAmt=$P(Sdata,"^",9)
	.S Manf=$P(Sdata,"^",10)
	.S Spec=$P(Sdata,"^",11)
	.s Fac=$P(Sdata,"^",12)
	.s ScrapQty=ScrapQty/Fac
	.d OutPutRow
	k ^TMP("DHCST","ScrapStat","ScrapStatPrt",pid)
	Quit $$$OK
OutPutRow
	S Data=$lb(Inci,InciCode,InciDesc,UomDesc,ScrapQty,Sp,Rp,SpAmt,RpAmt,Manf,Spec,UserIO,LocdescIO,hospDescIO)   
	S ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod ScrapStatPrtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ScrapStatPrtExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod ScrapStatPrtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ScrapStatPrtExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

}
