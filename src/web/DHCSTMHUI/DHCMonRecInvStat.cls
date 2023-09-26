Import sqluser

/// 财务监审接口
/// 统计已来发票 未来发票 补录发票
/// tsr_2015-10-26
Class web.DHCSTMHUI.DHCMonRecInvStat Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 统计物资采购付款（有发票）情况
/// w ##class(web.DHCSTMHUI.DHCMonRecInvStat).uGetWZRK01("2015","10")
ClassMethod uGetWZRK01(year, month) As %String
{
	n (year,month)
	k ^BonusTempWZRK($j,"WZRK01")
	s Month=year_"-"_month_"-"_"01"
	s Month=$zdh(Month,3)
	s LocId="219^283^313^315^331"  ;库房Rowid串
	s LocDr=""
	s colNum=$l(LocId,"^")
    f i=1:1:colNum d
    .s LocDr=$p(LocId,"^",i)
    .q:LocDr=""
    .s LocCode=$p(^CTLOC(LocDr),"^",1)
    .s LocDesc=$p(^CTLOC(LocDr),"^",2)
    .s sm=$o(^DHCSM(0,"MLOC",Month,LocDr,""))
    .q:sm=""
    .s ch=""
 	.f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d
	..s sub=""
	..f  s sub=$o(^DHCSTM(sm,"R",ch,"G",sub)) q:sub=""  d
	...s invInfo=^DHCSTM(sm,"R",ch,"G",sub)
	...s amt=$p(invInfo,"^",3)
	...q:amt=""
	...s vendor=$p(invInfo,"^",1)
	...s scg=$p(invInfo,"^",2)
	...i '$d(^BonusTempWZRK($j,"WZRK01",LocDr,vendor,scg)) d
	....s ^BonusTempWZRK($j,"WZRK01",LocDr,vendor,scg)=amt
	...e  d
	....s ^BonusTempWZRK($j,"WZRK01",LocDr,vendor,scg)=^BonusTempWZRK($j,"WZRK01",LocDr,vendor,scg)+amt
	..
	. 
    q 0
}

/// 统计物资采购付款（无发票）情况
ClassMethod uGetWZRK02(year, month) As %String
{
	n (year,month)
	k ^BonusTempWZRK($j,"WZRK02")
	s Month=year_"-"_month_"-"_"01"
	s Month=$zdh(Month,3)
	s LocId="219^283^313^315^331"	;库房Rowid串
	s LocDr=""
	s colNum=$l(LocId,"^")
    f i=1:1:colNum d
    .s LocDr=$p(LocId,"^",i)
    .q:LocDr=""
    .s sm=$o(^DHCSM(0,"MLOC",Month,LocDr,""))
    .q:sm=""
    .s ch=""
 	.f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d
	..s sub=""
	..f  s sub=$o(^DHCSTM(sm,"R",ch,"G",sub)) q:sub=""  d
	...s invInfo=^DHCSTM(sm,"R",ch,"G",sub)
	...s amt=$p(invInfo,"^",4)
	...q:amt=""
	...s vendor=$p(invInfo,"^",1)
	...s scg=$p(invInfo,"^",2)
	...i '$d(^BonusTempWZRK($j,"WZRK02",LocDr,vendor,scg)) d
	....s ^BonusTempWZRK($j,"WZRK02",LocDr,vendor,scg)=amt
	...e  d
	....s ^BonusTempWZRK($j,"WZRK02",LocDr,vendor,scg)=^BonusTempWZRK($j,"WZRK02",LocDr,vendor,scg)+amt
	...
	..
    q 0
}

/// 统计物资采购付款（补发票）情况
ClassMethod uGetWZRK03(year, month) As %String
{
	n (year,month)
	k ^BonusTempWZRK($j,"WZRK03")
	s Month=year_"-"_month_"-"_"01"
	s Month=$zdh(Month,3)
	s LocId="219^283^313^315^331"	;库房Rowid串
	s LocDr=""
	s colNum=$l(LocId,"^")
    f i=1:1:colNum d
    .s LocDr=$p(LocId,"^",i)
    .q:LocDr=""
    .s sm=$o(^DHCSM(0,"MLOC",Month,LocDr,""))
    .q:sm=""
	.s ret=..GetAmtRepInv(sm,LocDr)
    q 0
}

/// 统计补录发票的入库单金额(填写发票日期在月报日期内,但入库日期早于月报起始日期)
ClassMethod GetAmtRepInv(sm, loc) As %String
{
	n (sm,loc)
	s StartDate=$p(^DHCSM(sm),"^",3)
    s EndDate=$p(^DHCSM(sm),"^",4)
    s i=0
	f date=StartDate:1:EndDate d
 	.s ingr="" 
 	.f  s ingr=$o(^DHCINGR(0,"INVSETDATE",date,ingr)) q:ingr=""  d
 	..q:'$d(^DHCINGR(ingr))
 	..s RecLocId=$p(^DHCINGR(ingr),"^",13)
 	..q:RecLocId'=loc
 	..s creatDate=$p(^DHCINGR(ingr),"^",14)
 	..q:creatDate>=StartDate
 	..s vendor=$p(^DHCINGR(ingr),"^",3)
 	..q:vendor=""
 	..s scg=$p(^DHCINGR(ingr),"^",28)
 	..q:scg=""
	..s scg=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTopScgDesc(scg),"^",1)
 	..s ingri="" f  s ingri=$o(^DHCINGR(0,"INVSETDATE",date,ingr,ingri)) q:ingri=""  d
 	...q:'$d(^DHCINGR(ingr,"GRI",ingri))
 	...s amt=$p(^DHCINGR(ingr,"GRI",ingri),"^",54)
	...i '$d(^BonusTempWZRK($j,"WZRK03",loc,vendor,scg)) d
	....s ^BonusTempWZRK($j,"WZRK03",loc,vendor,scg)=amt
	...e  d
	....s ^BonusTempWZRK($j,"WZRK03",loc,vendor,scg)=^BonusTempWZRK($j,"WZRK03",loc,vendor,scg)+amt
	.s ingrt=""
	.f  s ingrt=$o(^INGRT(0,"INVSETDATE",date,ingrt)) q:ingrt=""  d
	..q:'$d(^INGRT(ingrt))
	..s RetLocId=$p(^INGRT(ingrt),"^",7)
	..q:RetLocId'=loc
	..s crtDate=$p(^INGRT(ingrt),"^",3)
	..q:crtDate>=StartDate
	..s ven=$p(^INGRT(ingrt),"^",2)
	..q:ven=""
	..s scgid=$p(^INGRT(ingrt),"^",14)
	..q:scgid=""
	..s scgid=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTopScgDesc(scgid),"^",1)
	..s ingrti="" f  s ingrti=$o(^INGRT(0,"INVSETDATE",date,ingrt,ingrti)) q:ingrti=""  d
	...q:'$d(^INGRT(ingrt,"DHCGRR",ingrti))
	...s retamt=-$p(^INGRT(ingrt,"DHCGRR",ingrti),"^",21)
	...i '$d(^BonusTempWZRK($j,"WZRK03",loc,ven,scgid)) d
	....s ^BonusTempWZRK($j,"WZRK03",loc,ven,scgid)=retamt
	...e  d
	....s ^BonusTempWZRK($j,"WZRK03",loc,ven,scgid)=^BonusTempWZRK($j,"WZRK03",loc,ven,scgid)+retamt
	..
	q 0
}

/// 统计本月实际进价\已来发票金额\未来发票金额
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCMonRecInvStat","QueryDetail","325")
Query QueryDetail(sm As %String) As Query(ROWSPEC = "vendor,venDesc,scg,scgDesc,amtWithInv:%Float,amtWithoutInv:%Float,amtInv:%Float") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, sm As %String) As %Status
{
	n (qHandle,sm)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:sm="" ""
	k ^TmpMonRecInvStat("inv")
	s ch=""
 	f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d
	.s sub=""
	.f  s sub=$o(^DHCSTM(sm,"R",ch,"G",sub)) q:sub=""  d
	..s invInfo=^DHCSTM(sm,"R",ch,"G",sub)
	..s vendor=$p(invInfo,"^",1)
	..s scg=$p(invInfo,"^",2)
	..s amtWithInv=$p(invInfo,"^",3)
	..s amtWithoutInv=$p(invInfo,"^",4)
	..;s amtRepInv=$p(invInfo,"^",5)
	..s amtInv=$p(invInfo,"^",6)
	..i '$d(^TmpMonRecInvStat("inv",vendor,scg)) d
	...s ^TmpMonRecInvStat("inv",vendor,scg)=amtWithInv_"^"_amtWithoutInv_"^"_amtInv
	..e  d
	...s $p(^TmpMonRecInvStat("inv",vendor,scg),"^",1)=$p(^TmpMonRecInvStat("inv",vendor,scg),"^",1)+amtWithInv
	...s $p(^TmpMonRecInvStat("inv",vendor,scg),"^",2)=$p(^TmpMonRecInvStat("inv",vendor,scg),"^",2)+amtWithoutInv
	...s $p(^TmpMonRecInvStat("inv",vendor,scg),"^",3)=$p(^TmpMonRecInvStat("inv",vendor,scg),"^",3)+amtInv
	..
	.
	i $d(^TmpMonRecInvStat("inv")) d OutputRowImp	
	Quit $$$OK

OutputRowImp   
	s ven=0
	f  s ven=$o(^TmpMonRecInvStat("inv",ven))  q:ven=""  d
	.s scgid=0 f  s scgid=$o(^TmpMonRecInvStat("inv",ven,scgid)) q:scgid=""  d
	..s data=^TmpMonRecInvStat("inv",ven,scgid)
	..s amtWithInv=$p(data,"^",1)
	..s amtWithoutInv=$p(data,"^",2)
	..s amtInv=$p(data,"^",3)
	..s venDesc=$p(^APC("APCVM",ven),"^",3)
	..s scgDesc=$p(^DHCSCG(scgid),"^",2)
	..s Data=$lb(ven,venDesc,scgid,scgDesc,amtWithInv,amtWithoutInv,amtInv)
	..s ^CacheTemp(repid,ind)=Data    
	..s ind=ind+1
	.
	k ^TmpMonRecInvStat("inv")
	q
}

/// 统计本月补录发票金额
ClassMethod GetRepInv(sm, loc) As %String
{
	n (sm,loc)
	q:sm="" -1
	s StartDate=$p(^DHCSM(sm),"^",3)
    s EndDate=$p(^DHCSM(sm),"^",4)
    s i=0
	f date=StartDate:1:EndDate d
 	.s ingr=0 
 	.f  s ingr=$o(^DHCINGR(0,"INVSETDATE",date,ingr)) q:ingr=""  d
 	..q:'$d(^DHCINGR(ingr))
 	..s RecLocId=$p(^DHCINGR(ingr),"^",13)
 	..q:RecLocId'=loc
 	..s creatDate=$p(^DHCINGR(ingr),"^",14)
 	..q:creatDate<63918
 	..q:creatDate>=StartDate
 	..s vendor=$p(^DHCINGR(ingr),"^",3)
 	..q:vendor=""
 	..s scg=$p(^DHCINGR(ingr),"^",28)
 	..q:scg=""
	..s scg=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTopScgDesc(scg),"^",1)
 	..s ingri=0 f  s ingri=$o(^DHCINGR(0,"INVSETDATE",date,ingr,ingri)) q:ingri=""  d
 	...q:'$d(^DHCINGR(ingr,"GRI",ingri))
 	...s invNo=$p(^DHCINGR(ingr,"GRI",ingri),"^",27)
 	...q:invNo=""
 	...s amt=$p(^DHCINGR(ingr,"GRI",ingri),"^",54)
	...i '$d(^TmpAmtWithoutInv("WithoutInv",vendor,scg)) d
	....s ^TmpAmtWithoutInv("WithoutInv",vendor,scg)=amt_"^"_0
	...e  d
	....s $p(^TmpAmtWithoutInv("WithoutInv",vendor,scg),"^",1)=$p(^TmpAmtWithoutInv("WithoutInv",vendor,scg),"^",1)+amt
	.s ingrt=0
	.f  s ingrt=$o(^INGRT(0,"INVSETDATE",date,ingrt)) q:ingrt=""  d
	..q:'$d(^INGRT(ingrt))
	..s RetLocId=$p(^INGRT(ingrt),"^",7)
	..q:RetLocId'=loc
	..s crtDate=$p(^INGRT(ingrt),"^",3)
	..q:crtDate<63918
	..q:crtDate>=StartDate
	..s ven=$p(^INGRT(ingrt),"^",2)
	..q:ven=""
	..s scgid=$p(^INGRT(ingrt),"^",14)
	..q:scgid=""
	..s scgid=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTopScgDesc(scgid),"^",1)
	..s ingrti=0 f  s ingrti=$o(^INGRT(0,"INVSETDATE",date,ingrt,ingrti)) q:ingrti=""  d
	...q:'$d(^INGRT(ingrt,"DHCGRR",ingrti))
	...s invNo=$p(^INGRT(ingrt,"DHCGRR",ingrti),"^",12)
	...q:invNo=""
	...s retamt=-$p(^INGRT(ingrt,"DHCGRR",ingrti),"^",21)
	...i '$d(^TmpAmtWithoutInv("WithoutInv",ven,scgid)) d
	....s ^TmpAmtWithoutInv("WithoutInv",ven,scgid)=retamt_"^"_0
	...e  d
	....s $p(^TmpAmtWithoutInv("WithoutInv",ven,scgid),"^",1)=$p(^TmpAmtWithoutInv("WithoutInv",ven,scgid),"^",1)+retamt
	..
	q 0
}

/// 统计到月报截止日期没有发票号的所有入库单金额
ClassMethod GetWithoutInv(sm, loc) As %String
{
	n (sm,loc)
	q:sm="" -1
	s StartDate=$p(^DHCSM(sm),"^",3)
    s EndDate=$p(^DHCSM(sm),"^",4)
	s ingr=0
	f  s ingr=$o(^DHCINGR(ingr)) q:ingr=""  d
 	.s RecLocId=$p(^DHCINGR(ingr),"^",13)
 	.q:RecLocId'=loc
 	.s creatDate=$p(^DHCINGR(ingr),"^",14)
 	.q:creatDate<63918
 	.q:creatDate>EndDate
 	.s vendor=$p(^DHCINGR(ingr),"^",3)
 	.q:vendor=""
 	.s scg=$p(^DHCINGR(ingr),"^",28)
 	.q:scg=""
	.s scg=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTopScgDesc(scg),"^",1)
 	.s ingri=0 f  s ingri=$o(^DHCINGR(ingr,"GRI",ingri)) q:ingri=""  d
 	..s invNo=$p(^DHCINGR(ingr,"GRI",ingri),"^",27)
 	..q:invNo'=""
 	..s amt=$p(^DHCINGR(ingr,"GRI",ingri),"^",54)
	..i '$d(^TmpAmtWithoutInv("WithoutInv",vendor,scg)) d
	...s ^TmpAmtWithoutInv("WithoutInv",vendor,scg)=0_"^"_amt
	..e  d
	...s $p(^TmpAmtWithoutInv("WithoutInv",vendor,scg),"^",2)=$p(^TmpAmtWithoutInv("WithoutInv",vendor,scg),"^",2)+amt
	s ingrt=0
	f  s ingrt=$o(^INGRT(ingrt)) q:ingrt=""  d
	.s RetLocId=$p(^INGRT(ingrt),"^",7)
	.q:RetLocId'=loc
	.s crtDate=$p(^INGRT(ingrt),"^",3)
	.q:crtDate<63918
	.q:crtDate>EndDate
	.s ven=$p(^INGRT(ingrt),"^",2)
	.q:ven=""
	.s scgid=$p(^INGRT(ingrt),"^",14)
	.q:scgid=""
	.s scgid=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTopScgDesc(scgid),"^",1)
	.s ingrti=0 f  s ingrti=$o(^INGRT(ingrt,"DHCGRR",ingrti)) q:ingrti=""  d
	..s invNo=$p(^INGRT(ingrt,"DHCGRR",ingrti),"^",12)
	..q:invNo'=""
	..s retamt=-$p(^INGRT(ingrt,"DHCGRR",ingrti),"^",21)
	..i '$d(^TmpAmtWithoutInv("WithoutInv",ven,scgid)) d
	...s ^TmpAmtWithoutInv("WithoutInv",ven,scgid)=0_"^"_retamt
	..e  d
	...s $p(^TmpAmtWithoutInv("WithoutInv",ven,scgid),"^",2)=$p(^TmpAmtWithoutInv("WithoutInv",ven,scgid),"^",2)+retamt
	..
	q 0
}

/// 统计没有发票的入库金额和本月补录发票金额
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCMonRecInvStat","QueryWithoutInv","325")
Query QueryWithoutInv(sm As %String) As Query(ROWSPEC = "vendor,venDesc,scg,scgDesc,amtRepInv:%Float,amtWithoutInv:%Float") [ SqlProc ]
{
}

ClassMethod QueryWithoutInvExecute(ByRef qHandle As %Binary, sm As %String) As %Status
{
	n (qHandle,sm)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:sm="" ""
	k ^TmpAmtWithoutInv("WithoutInv")
	s loc=$p(^DHCSM(sm),"^",1)	
	s ret=..GetRepInv(sm,loc)
	s ret1=..GetWithoutInv(sm,loc)
	i $d(^TmpAmtWithoutInv("WithoutInv")) d OutputWithoutInv	
	Quit $$$OK

OutputWithoutInv   
	s ven=0
	f  s ven=$o(^TmpAmtWithoutInv("WithoutInv",ven))  q:ven=""  d
	.s scgid=0 f  s scgid=$o(^TmpAmtWithoutInv("WithoutInv",ven,scgid)) q:scgid=""  d
	..s data=^TmpAmtWithoutInv("WithoutInv",ven,scgid)
	..s amtRepInv=$p(data,"^",1)
	..s amtWithoutInv=$p(data,"^",2)
	..s venDesc=$p(^APC("APCVM",ven),"^",3)
	..s scgDesc=$p(^DHCSCG(scgid),"^",2)
	..s Data=$lb(ven,venDesc,scgid,scgDesc,amtRepInv,amtWithoutInv)
	..s ^CacheTemp(repid,ind)=Data    
	..s ind=ind+1
	.
	k ^TmpAmtWithoutInv("WithoutInv")
	q
}

}
