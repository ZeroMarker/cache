Import sqluser

/// Descript:库存调整统计
/// Creater:    bianshuai
/// CreateDate:	2012-09-07
/// 
Class web.DHCST.AdjustStat Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// w ##class(web.DHCST.AdjustStat).jsAdjustStat(0,30,"","","2016-01-06^2016-01-06^G^102^^2^1")
ClassMethod jsAdjustStat(Start As %String, Limit As %String, Sort As %String, Dir As %String, StrPar As %String) As %String
{
	s StartDate=$p(StrPar,"^",1)
	s EndDate=$p(StrPar,"^",2)
	s StkType=$p(StrPar,"^",3)
	s Loc=$p(StrPar,"^",4)
	s ItmDr=$p(StrPar,"^",5)
	s ReasonDr=$p(StrPar,"^",6)
	s StkGrpType=$p(StrPar,"^",7)
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="ASC"
	s pid=..NewPid()
	s $zt="ErrorjsAdjustStat"
	s result=##class(%Library.ResultSet).%New("web.DHCST.AdjustStat:AdjustStat")
	s sc=result.Execute(StartDate,EndDate,StkType,StkGrpType,Loc,ReasonDr,ItmDr)
	i $$$ISERR(sc) w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:$$$ISERR(sc) ""
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords = 0,spamtsum=0,rpamtsum=0
	s End = Start+Limit
	s Start=Start+1
	While(result.Next())
	{ 
	    //Inci,InciCode,InciDesc,AdjUom,AdjQty,bUomDesc,bAdjQty,Sp,Rp,SpAmt,RpAmt,Manf,Spec
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.%GetData(i)
		.e   s ret=ret_"^"_result.%GetData(i)
		s spamt=$p(ret,"^",10)
		s rpamt=$p(ret,"^",11)
		s spamtsum=spamtsum+spamt
		i (spamtsum>0)&&(spamtsum<1) s spamtsum=0_spamtsum
		s rpamtsum=rpamtsum+rpamt
		i (rpamtsum>0)&&(rpamtsum<1) s rpamtsum=0_rpamtsum
		s incicode=$p(ret,"^",2)
		s incidesc=$p(ret,"^",3)
		s adjqty=$p(ret,"^",5)
		s countrecords=countrecords+1
		s index="1"
		i Sort="InciCode" s index=incicode
		e  i Sort="InciDesc" s index=incidesc
		e  i Sort="AdjQty" s index=adjqty
		e  i Sort="SpAmt" s index=spamt
		e  i Sort="RpAmt" s index=rpamt
		i index="" s index="1"  //虽然节点多,但是比起拼串做节点,排序更精准,yunhaibao20151120
		s ^TMP("DHCST","AdjustStat","jsAdjustStat",pid,1,index,countrecords)=ret
	}
	i countrecords=0 w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:countrecords=0 ""
	s sumstring=""
	s $p(sumstring,"^",1)=""
	s $p(sumstring,"^",2)="合计金额"
	s $p(sumstring,"^",10)=spamtsum
	s $p(sumstring,"^",11)=rpamtsum
	s $p(sumstring,"^",$l(colNameStr,"^"))="" 
	s countrecords=countrecords+1
	s ^TMP("DHCST","AdjustStat","jsAdjustStat",pid,0,0,countrecords)=sumstring //合计
	i End>countrecords s End=countrecords
	i Dir="DESC" s orderflag="-1"
	e  s orderflag="1"
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","AdjustStat","jsAdjustStat",pid,outputi)) q:outputi=""  d
	.s outputj=""
	.f  s outputj=$o(^TMP("DHCST","AdjustStat","jsAdjustStat",pid,outputi,outputj),orderflag) q:outputj=""  d
	..s outputk=""
	..f  s outputk=$o(^TMP("DHCST","AdjustStat","jsAdjustStat",pid,outputi,outputj,outputk),orderflag) q:outputk=""  d
	...s outputdata=^TMP("DHCST","AdjustStat","jsAdjustStat",pid,outputi,outputj,outputk)
	...s count = count+1
	...q:count<Start
	...q:count>End
	...i count=Start d
	....w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(countrecords)
	....s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,colNameStr)
	....w retstring
	...e  d
	....s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,colNameStr)
	....w ","_retstring
	i count=0 w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:count=0 ""
	w "]}"
	k ^TMP("DHCST","AdjustStat","jsAdjustStat",pid)
	Q ""
ErrorjsAdjustStat
 k ^TMP("DHCST","AdjustStat","jsAdjustStat",pid)
 q $ze
}

Query AdjustStat(StartDate As %String, EndDate As %String, StkType As %String, StkGrpType As %String, Loc As %String, ReasonDr As %String, ItmDr As %String, User As %String = "") As %Query(ROWSPEC = "Inci:%String,InciCode:%String,InciDesc:%String,AdjUom:%String,AdjQty:%Double,bUomDesc:%String,bAdjQty:%Double,Sp:%Double,Rp:%Double,SpAmt:%Double,RpAmt:%Double,Manf:%String,Spec:%String,UserIO,LocdescIO,hospDescIO") [ SqlProc ]
{
}

ClassMethod AdjustStatExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, StkType As %String, StkGrpType As %String, Loc As %String, ReasonDr As %String, ItmDr As %String, User As %String = "") As %Status
{
 S repid=$I(^CacheTemp)
 S ind=1
 S qHandle=$lb(0,repid,0)
 Q:Loc="" $$$OK
 Q:StartDate="" $$$OK
 Q:EndDate="" $$$OK
 
 s UserIO="",LocdescIO="",hospDescIO=""
 s:User'="" UserIO=$P(^SSU("SSUSR",User),"^",2)
 s LocdescIO=$P(^CTLOC(Loc),"^",2)
 s hosp=$P(^CTLOC(Loc),"^",22)
 s hospDescIO=$P(^CT("HOSP",hosp),"^",2)
 
 S Pid=##class(web.DHCSTKUTIL).NewPid($this,"ST")
 k ^TMP("DHCST",$this,"AdjustStat",Pid)
 S HospID=$p(^CTLOC(Loc),"^",22)
 i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 F Date=StartDate:1:EndDate  d
 .S INTR=""
 .F  S INTR=$o(^DHCINTR(0,"TypeDate","A",Date,INTR))  Q:INTR=""  D
 ..S TrPointer=$p(^DHCINTR(INTR),"^",9)
 ..S InadDr=+TrPointer
 ..S AdjreasonID=$p(^DHCINAD(InadDr),"^",6)
 ..Q:(ReasonDr'="")&(AdjreasonID'=ReasonDr)
 ..S Type=$p(^DHCINAD(InadDr),"^",15)
 ..Q:Type'=StkType
 ..S LocDr=$p(^DHCINAD(InadDr),"^",16)
 ..Q:LocDr'=Loc
 ..S InadSub=$P(TrPointer,"||",2)
 ..S INCI=$p(^DHCINTR(INTR),"^",15)
 ..s stkgrpinfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(INCI) //类组
 ..s grpid=$p(stkgrpinfo,"^",5)
 ..q:(StkGrpType'="")&(grpid'=StkGrpType)
 ..S INCLB=$p(^DHCINTR(INTR),"^",7) 
 ..S ILSub=$p(INCLB,"||",2)
 ..Q:'$d(^INCI(INCI))
 ..S LocDr=$p(^INCI(INCI,"IL",ILSub),"^",1)
 ..Q:Loc'=LocDr
 ..S InciCode=$p(^INCI(INCI,1),"^",1)
 ..S InciDesc=$p(^INCI(INCI,1),"^",2)
 ..Q:(ItmDr'="")&(ItmDr'=INCI)
 ..S mdata=^DHCINAD(InadDr,"ADI",InadSub)
 ..S Qty=$p(mdata,"^",2)	//调整单位数量
 ..S Sp=$p(mdata,"^",4)		//调整单位售价
 ..S Uomdr=$p(mdata,"^",5)	//调整单位
 ..S bQty=$p(mdata,"^",7)	//基本单位数量
 ..S SpAmt=$p(mdata,"^",8)	//售价金额
 ..S Rp=$p(mdata,"^",9)		//进价
 ..S RpAmt=$p(mdata,"^",10)	//进价金额
 ..s bUom=$p(^INCI(INCI,1),"^",10)
 ..s pUom=$p(^INCI(INCI,3),"^",6)
 ..s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(Uomdr,bUom)
 ..S bSp=Sp/fac
 ..S bRp=Rp/fac
 ..S ManfStr=##Class(web.DHCST.Common.DrugInfoCommon).GetManf(INCI)
 ..S ManfDesc=$P(ManfStr,"^",3)
 ..S Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec(InciCode,INCI)
 ..S UomDesc=$P($G(^CT("UOM",pUom)),"^",2)
 ..S bUomDesc=$P($G(^CT("UOM",bUom)),"^",2)
 ..s bpFac=##class(web.DHCST.Common.UtilCommon).UOMFac(pUom,bUom)
 ..i Uomdr'=pUom d
 ...s Sp=bSp*bpFac
 ...s Rp=bRp*bpFac
 ...s Sp=##class(web.DHCST.Common.AppCommon).FormatSp(Sp,HospID,1,"G")
 ...s Rp=##class(web.DHCST.Common.AppCommon).FormatRp(Rp,HospID,1,"G")
 ..S Index=INCI_"^"_ManfDesc_"^"_bSp_"^"_bRp
 ..If $d(^TMP("DHCST",$this,"AdjustStat",Pid,Index)) D
 ...S $P(^TMP("DHCST",$this,"AdjustStat",Pid,Index),"^",5)=$P(^TMP("DHCST",$this,"AdjustStat",Pid,Index),"^",5)+Qty
 ...S $P(^TMP("DHCST",$this,"AdjustStat",Pid,Index),"^",7)=$P(^TMP("DHCST",$this,"AdjustStat",Pid,Index),"^",7)+bQty
 ...S $P(^TMP("DHCST",$this,"AdjustStat",Pid,Index),"^",9)=$P(^TMP("DHCST",$this,"AdjustStat",Pid,Index),"^",9)+SpAmt
 ...S $P(^TMP("DHCST",$this,"AdjustStat",Pid,Index),"^",11)=$P(^TMP("DHCST",$this,"AdjustStat",Pid,Index),"^",11)+RpAmt
 ..Else  D
 ...S ^TMP("DHCST",$this,"AdjustStat",Pid,Index)=INCI_"^"_InciCode_"^"_InciDesc_"^"_UomDesc_"^"_Qty_"^"_bUomDesc_"^"_bQty_"^"_Sp_"^"_SpAmt_"^"_Rp_"^"_RpAmt_"^"_ManfDesc_"^"_Spec_"^"_bpFac
 S Sub=""
 F  S Sub=$o(^TMP("DHCST",$this,"AdjustStat",Pid,Sub)) Q:Sub=""  D
 .S Sdata=$g(^TMP("DHCST",$this,"AdjustStat",Pid,Sub))
 .S Inci=$P(Sdata,"^",1)
 .S InciCode=$P(Sdata,"^",2)
 .S InciDesc=$P(Sdata,"^",3)
 .S UomDesc=$P(Sdata,"^",4)
 .//S AdjQty=$P(Sdata,"^",5)
 .S bUomDesc=$P(Sdata,"^",6)
 .S bAdjQty=$P(Sdata,"^",7)
 .S Sp=$P(Sdata,"^",8)
 .i (Sp>0)&&(Sp<1) s Sp=0_Sp
 .S Rp=$P(Sdata,"^",10)
 .i (Rp>0)&&(Rp<1) s Rp=0_Rp
 .S SpAmt=$P(Sdata,"^",9)
 .i (SpAmt>0)&&(SpAmt<1) s SpAmt=0_SpAmt
 .S RpAmt=$P(Sdata,"^",11)
 .i (RpAmt>0)&&(RpAmt<1) s RpAmt=0_RpAmt
 .S Manf=$P(Sdata,"^",12)
 .S Spec=$P(Sdata,"^",13)
 .s Fac=$P(Sdata,"^",14)
 .s AdjQty=bAdjQty/Fac
 .S Data=$lb(Inci,InciCode,InciDesc,UomDesc,AdjQty,bUomDesc,bAdjQty,Sp,Rp,SpAmt,RpAmt,Manf,Spec,UserIO,LocdescIO,hospDescIO)   
 .S ^CacheTemp(repid,ind)=Data
 .S ind=ind+1
 k ^TMP("DHCST",$this,"AdjustStat",Pid)
 Quit $$$OK
}

ClassMethod AdjustStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AdjustStatExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod AdjustStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AdjustStatExecute ]
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

ClassMethod NewPid()
{
	q $I(^DHCSTPID("AdjustStat"))
}

}
