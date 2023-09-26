Import sqluser

Class web.DHCSTMHUI.DHCPayMonDetail Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTMPAYMON";

/// 生成付款月报明细内容(以供应商为主)
/// Date:2016-09-06
/// update 20181207
/// Argu:
///  sm - 付款月报主表rowid
/// Return:
///  0 -success
///  <0 -failure
ClassMethod CreatePayMonDetail(sm As %String) As %String
{
 n (sm)
 q:sm="" -1
 s obj=##class(User.DHCPayMon).%OpenId(sm)
 i $ISOBJECT(obj)  d obj.%Reload()
 //取付款月报主信息
 s loc=obj.PMCTLOCDR.%Id()  
 s frdate=obj.PMDateFrom
 s todate=obj.PMDateTo
 s month=obj.PMMonthDate
 s user=obj.PMSSUSRDR
 s pmrowid=sm
 s pid=..NewPid()
 k ^TMPPAYMONVENDOR("web.DHCSTMHUI.DHCPayMonDetail",pid)
 s (VenLastRpAmt,VenArrearRpAmt,VenPayedRpAmt,VenEndRpAmt)=0
 s n=0,m=0
 f dat=frdate:1:todate  d
  .s payid=""
  .s Vendorid=""
  .f  s payid=$o(^DHCPAY(0,"D",dat,payid)) q:payid=""  d
  ..s ch=""
  ..s payinfo=^DHCPAY(payid)
  ..s payloc=$p(payinfo,"^",3)
  ..q:payloc'=loc
  ..s ack2=$p(payinfo,"^",9)
  ..q:ack2'="Y"
  ..s Vendorid=$p(payinfo,"^",2)
  ..f  s ch=$o(^DHCPAY(payid,"I",ch)) q:ch=""  d
  ...s payinfo=^DHCPAY(payid,"I",ch)
  ...s inci=$p(payinfo,"^",1)
  ...s stkgrpinfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
  ...s grptype=$p(stkgrpinfo,"^",3)
  ...q:grptype'=..sssCode()
  ...s PayedAmt=$p(payinfo,"^",5) ;付款金额
  ...s RecAmt=$p(payinfo,"^",3) ;入库或者退货金额
  ...i $d(^TMPPAYMONVENDOR("web.DHCSTMHUI.DHCPayMonDetail",pid,Vendorid))  d
  ....s PayedAmtsum=+PayedAmt+$p(^TMPPAYMONVENDOR("web.DHCSTMHUI.DHCPayMonDetail",pid,Vendorid),"^",1)
  ....s RecAmtsum=+RecAmt+$p(^TMPPAYMONVENDOR("web.DHCSTMHUI.DHCPayMonDetail",pid,Vendorid),"^",2)
  ....s ^TMPPAYMONVENDOR("web.DHCSTMHUI.DHCPayMonDetail",pid,Vendorid)=PayedAmtsum_"^"_RecAmtsum
  ...e  d
  ....s ^TMPPAYMONVENDOR("web.DHCSTMHUI.DHCPayMonDetail",pid,Vendorid)=PayedAmt_"^"_RecAmt
  ;本月未制付款单但上月有结余的供应商也显示
  s OtherVen=""
  f  s OtherVen=$o(^APC("APCVM",OtherVen))  q:OtherVen=""  d
  .q:'$d(^APC("APCVM",OtherVen))
  .s status=$p(^APC("APCVM",OtherVen),"^",18)
  .q:status'="A"
  .s Stvendid=$o(^DHCSTV(0,OtherVen,""))
  .s Unversal="N"
  .s:Stvendid'="" Unversal=$p(^DHCSTV(Stvendid),"^",49)
  .s type=$p(^APC("APCVM",OtherVen),"^",9)
  .q:((type'="M")&&(Unversal'="Y"))
  .q:$d(^TMPPAYMONVENDOR("web.DHCSTMHUI.DHCPayMonDetail",pid,OtherVen))
  .s VenLastUnPayedRpAmt=..VendorLastUnpayAmt(loc,OtherVen)
  .q:VenLastUnPayedRpAmt=0
  .s PayedAmt=0
  .s RecAmt=0
  .s ^TMPPAYMONVENDOR("web.DHCSTMHUI.DHCPayMonDetail",pid,OtherVen)=PayedAmt_"^"_RecAmt
  q:'$d(^TMPPAYMONVENDOR("web.DHCSTMHUI.DHCPayMonDetail")) 0  ;-2
  s ven="",InsertResult=0
  f  s ven=$o(^TMPPAYMONVENDOR("web.DHCSTMHUI.DHCPayMonDetail",pid,ven)) q:(ven="")!(InsertResult'=0)  d
  .s VenPayedRpAmt=$p(^TMPPAYMONVENDOR("web.DHCSTMHUI.DHCPayMonDetail",pid,ven),"^",1)
  .s VenArrearRpAmt=$p(^TMPPAYMONVENDOR("web.DHCSTMHUI.DHCPayMonDetail",pid,ven),"^",2)
  .s VenLastRpAmt=..VendorLastUnpayAmt(loc,ven)
  .s VenEndRpAmt=VenLastRpAmt+VenArrearRpAmt-VenPayedRpAmt
  .s paychl=$o(^DHCPAYM(pmrowid,"V",""),-1)+1
  .s InsertResult=0
  .&sql(insert into DHC_PayMonVendor(PMV_ParRef,PMV_ChildSub,PMV_APCVM_DR,PMV_AcctPayableAmt_Last,PMV_AddedAmt,PMV_PayedAmt,PMV_AcctPayableAmt) 
    values(:pmrowid,:paychl,:ven,:VenLastRpAmt,:VenArrearRpAmt,:VenPayedRpAmt,:VenEndRpAmt))
  .i SQLCODE'=0 d
  ..s InsertResult=-1 q
  .q:InsertResult=-1
  k ^TMPPAYMONVENDOR("web.DHCSTMHUI.DHCPayMonDetail",pid)
  q InsertResult
}

/// 供应商上期结余未付款金额
/// w ##class(web.DHCSTMHUI.DHCPayMonDetail).VendorLastUnpayAmt(153,781)
ClassMethod VendorLastUnpayAmt(loc As %String, Vendorid As %String) As %String
{
   n (loc,Vendorid)
   q:loc="" 0
   q:Vendorid="" 0
   s (lastPMid,PMid)=""
   &sql(SELECT TOP 1 PM_Rowid into PMid FROM DHC_PayMon WHERE PM_CTLOC_DR=:loc ORDER BY PM_Rowid DESC)
   s VendorLastUpayAmt=0
   i +PMid>0 d
   .s lastPMid=$o(^DHCPAYM(PMid),-1)
   .&sql(SELECT PMV_AcctPayableAmt into VendorLastUpayAmt FROM DHC_PayMonVendor WHERE PMV_APCVM_DR=:Vendorid AND PMV_ParRef=:lastPMid)
   q VendorLastUpayAmt
}

/// 检索付款月报明细
/// Author:lihui
/// Date:	2016-09-08
/// Argu:
///  pm - 付款月报主表rowid
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCPayMonDetail","PayMDetailRp",85)
Query PayMDetailRp(pm As %String) As Query(ROWSPEC = "paychl,vendor,vendordesc,LastAmt:%Float,AddedAmt:%Float,PayedAmt:%Float,AcctPayableAmt:%Float") [ SqlProc ]
{
}

ClassMethod PayMDetailRpExecute(ByRef qHandle As %Binary, pm As %String) As %Status
{
 n (qHandle, pm)
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:pm="" $$$OK
 
 s paychl=""
 f  s paychl=$o(^DHCPAYM(pm,"V",paychl)) q:paychl=""  d
 .s pmdetailinfo=^DHCPAYM(pm,"V",paychl)
 .s vendor=$p(pmdetailinfo,"^",1)
 .s:vendor'="" vendordesc=$p(^APC("APCVM",vendor),"^",3)
 .s LastAmt=$p(pmdetailinfo,"^",2)
 .s AddedAmt=$p(pmdetailinfo,"^",3)
 .s PayedAmt=$p(pmdetailinfo,"^",4)
 .s AcctPayableAmt=$p(pmdetailinfo,"^",5)
 .d OutPutRow
 
 Quit $$$OK
OutPutRow
 s Data=$lb(paychl,vendor,vendordesc,LastAmt,AddedAmt,PayedAmt,AcctPayableAmt)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// 本期付款金额(依据发票确认审核)
/// lihui20190526
/// w ##class(web.DHCSTMHUI.DHCPayMonDetail).GetPayRpAmt()
ClassMethod GetPayRpAmt(pid As %String, pm As %String) As %String
{
 n (pid,pm)
 q:pid="" 0
 q:pm="" 0
 s obj=##class(User.DHCPayMon).%OpenId(pm)
 i $ISOBJECT(obj)  d obj.%Reload()
 s loc=obj.PMCTLOCDR.%Id()  
 s frdate=obj.PMDateFrom
 s todate=obj.PMDateTo
 s month=obj.PMMonthDate
 s user=obj.PMSSUSRDR     ;obj.PMSSUSRDR.%Id()
 s pmrowid=pm
 s frtime=..TH2L("00:00:00")
 s totime=..TH2L("23:59:59")
 s payrpamtsum=0
 i $d(^DHCPAYMONFLAG(pid)) d
 .s inci=0
 .f  s inci=$o(^DHCPAYMONFLAG(pid,inci)) q:inci=""  d
 ..s incil=""
 ..f  s incil=$o(^DHCPAYMONFLAG(pid,inci,incil)) q:incil=""  d
 ...s inclb=""
 ...f  s inclb=$o(^DHCPAYMONFLAG(pid,inci,incil,inclb)) q:inclb=""  d
 ....f date=frdate:1:todate  d
 .....s paytrid=""
 .....f  s paytrid=$o(^DHCPAYTRANS(0,"DATEINCLB",date,inclb,paytrid))  q:paytrid=""  d
 ......q:'$d(^DHCPAYTRANS(paytrid))
 ......s time=$p(^DHCPAYTRANS(paytrid),"^",8)
 ......q:(date=frdate)&(frtime'="")&(time<frtime)
 ......q:(date=todate)&(totime'="")&(time>totime)
 ......s payrpamt=$p(^DHCPAYTRANS(paytrid),"^",6)
 ......s payrpamtsum=payrpamtsum+payrpamt
 q payrpamtsum
}

/// 判断incil上期月报是否有非零结存
/// Author:	lihui
/// Date:	20190522
/// Argu:	上期月报id,上期月报日期,incil,本期月报rowid
/// Return:	1:有结存, 0:结存为零
/// w ##class().IsIncilLastMon("","",
ClassMethod IsIncilLastMon(LastPM, incil, PM = "") As %String
{
	n (LastPM,incil,PM)
	s inci=+incil,il=$p(incil,"||",2)
	s LocId=$p(^INCI(inci,"IL",il),"^",1)
	s ret=0
	
	;若没有上期月报,按本期期初判断
	i (LastPM="")&&(PM'="") d
	.s StartDate=$p(^DHCPAYM(PM),"^",5)
	.s Date=StartDate-1
	.s lb=0
	.f  s lb=$o(^INCI(inci,"IL",il,"LB",lb)) q:(lb="")||(ret'=0)  d
	..s Inclb=incil_"||"_lb
	..s InclbQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(Inclb,Date)
	..i +InclbQty'=0 s ret=1 q
	i (LastPM="")&&(PM'="") q ret
	
	s lb=0
	f  s lb=$o(^INCI(inci,"IL",il,"LB",lb)) q:(lb="")||(ret'=0)  d
	.s inclb=incil_"||"_lb
	.s amt=..GetLastLBAmt(inclb,LastPM)
	.i amt'=0 s ret=1
	
	q ret
}

/// 生成月报批次数据
/// Date:2012-11-01
/// Argu:
///    pid - 临时Glboal数据识别ID
///    PM - 月报rowid
///    INCIL - 科室库存rowid
///    LastPM - 上月月报主表rowid
/// Return:
/// 	0 -success
/// 	<0  -失败
ClassMethod SaveLBData(pid As %String, PM As %String, INCIL As %String, LastPM As %String) As %String
{
 n (pid,PM,INCIL,LastPM)
 s err=0
 s INCI=+INCIL,CH=$p(INCIL,"||",2),LBCH=0
 f  s LBCH=$o(^INCI(INCI,"IL",CH,"LB",LBCH)) q:(LBCH="")!err  d 
  . s INCLB=INCI_"||"_CH_"||"_LBCH
  . ;q:..IfActive(INCLB)'="Y"  ;2015-07-31 rem: 此过滤方式欠妥 //滤除状态处于"非活动"的库存批次 zhwh 2012-11-02
  . i ..InsertLBTransPM(pid,PM,INCLB,LastPM)<0 d
  . . s err=1
 q err
}

/// 取某批次的上月月报的结存
/// Author: lihui 20190524
/// Argu:
///  LastPM -上月 DHCPayMon的rowid
///  INCLB - 批次rowid
/// Return:
/// 字符串: 结存进价金额  
ClassMethod GetLastLBAmt(INCLB As %String, LastPM As %String) As %String
{
 n (INCLB,LastPM)
 q:INCLB="" ""
 q:LastPM="" ""
 ;
 s LastPMCH=$o(^DHCPAYMONLB(0,"PMLB",INCLB,LastPM,"")) q:LastPMCH="" ""
 s amt=0
 i LastPMCH'="" d
 .q:'$d(^DHCPAYMONLB(LastPM,"LB",LastPMCH))
 .s amt=$p(^DHCPAYMONLB(LastPM,"LB",LastPMCH),"^",6)  ;
 q amt
}

/// 取某批次某业务类型的月报汇总数据     
/// Author: lihui
/// Date: 20190524
/// Argu:
///    Type - 业务类型
///    INCLB - 科室批次rowid
/// Return:
///  进价金额
ClassMethod GetLBTrans(pid As %String, Type As %String, INCLB As %String) As %String
{
 n (pid,Type,INCLB)
 s n="",rpamt=0
 f  s n=$o(^DHCDHCSTMPMLB(pid,Type,INCLB,n)) q:n=""  d
 .s rpamt=rpamt+$p(^DHCDHCSTMPMLB(pid,Type,INCLB,n),"^",2)
 q rpamt
}

/// 获取当月付款金额     
/// Author: lihui
/// Date: 20190524
/// Argu:
///    Type - 业务类型
///    INCLB - 科室批次rowid
/// Return:
///  进价金额
ClassMethod GetCurPayAmt(pm As %String, INCLB As %String) As %String
{
 n (pm,INCLB)
 q:pm="" 0
 q:INCLB="" 0
 s rpamt=0
 s paymoninfo=^DHCPAYM(pm)
 s frdate=$p(paymoninfo,"^",5)
 s todate=$p(paymoninfo,"^",6)
 f date=frdate:1:todate  d
 .s Ptrid=""
 .f  s Ptrid=$o(^DHCPAYTRANS(0,"DATEINCLB",date,INCLB,Ptrid))  q:Ptrid=""  d
 ..q:'$d(^DHCPAYTRANS(Ptrid))
 ..s paytrinfo=^DHCPAYTRANS(Ptrid)
 ..s trarpamt=$p(paytrinfo,"^",6)
 ..s rpamt=rpamt+trarpamt
 q rpamt
}

/// 插入库存批次的"批次月报"记录
/// Author:zhwh
/// Date:2012-11-01
/// Argu:
///   pid - 临时Glboal数据识别ID
///  PM - 月报rowid
///  INCLB  -批次rowid
///  LastPM - 上期月报主表rowid
/// Return:
///    <0 -failure
///    0  - success
ClassMethod InsertLBTransPM(pid As %String, PM As %String, INCLB As %String, LastPM As %String)
{
 n (pid,PM,INCLB,LastPM)
 s lastcoamt=..GetLastLBAmt(INCLB,LastPM)
 s INCI=+INCLB,INCIL=$p(INCLB,"||",1,2)
 ;2015-07-31 上期结存为0,且没有台帐数据的批次,过滤
 ;q:('$d(^DHCPAYMONFLAG(pid,INCI,INCIL,INCLB)))&&((lastqty=0) && (lastcoamt=0)) 0
 
 
 ;
 s recamt=..GetLBTrans(pid,"G",INCLB)
 s retamt=..GetLBTrans(pid,"R",INCLB)
 s payamt=..GetCurPayAmt(PM,INCLB)
 s curunpayamt=lastcoamt+recamt+retamt-payamt
 s lbch=$o(^DHCPAYMONLB(PM,"LB",""),-1)+1
 q:lbch="" -1

 &sql(INSERT INTO DHC_PayMonLB (PMLB_PM_Parref, PMLB_Childsub, PMLB_INCLB_DR, PMLB_LastUnPayRpAmt, PMLB_RecRpAmt, PMLB_RetRpAmt, PMLB_PayAmt, PMLB_UnPayRpAmt) 
 		VALUES(:PM,:lbch,:INCLB,:lastcoamt,:recamt,:retamt,:payamt,:curunpayamt))
 q SQLCODE
}

/// 生成付款月报明细内容(科室批次)
/// Date:20190524
/// Argu:
///  pm - 付款月报主表rowid
/// Return:
///  0 -success
///  <0 -failure
ClassMethod CreatePayMonLBDetail(pm As %String) As %String
{
 n (pm)
 q:pm="" ""
 s obj=##class(User.DHCPayMon).%OpenId(pm)
 i $ISOBJECT(obj)  d obj.%Reload()
 //取付款月报主信息
 s loc=obj.PMCTLOCDR.%Id()  
 s frdate=obj.PMDateFrom
 s todate=obj.PMDateTo
 s month=obj.PMMonthDate
 s user=obj.PMSSUSRDR     ;obj.PMSSUSRDR.%Id()
 s pmrowid=pm
 s frtime=..TH2L("00:00:00")
 s totime=..TH2L("23:59:59")
 s LastMainRowid=$o(^DHCPAYM(0,"Loc",loc,pm),-1)		;之前根据LastMon处理, 跨月时有问题
 s n=0,m=0
 s pid=..NewPid()
 s types="G^R"
 f i=1:1:$l(types,"^") d
 .s trtype=$p(types,"^",i)
 .f dat=frdate:1:todate d
 ..s tr=0 
 ..f  s tr=$o(^DHCINTR(0,"LOCTYPEDATE",loc,trtype,dat,tr)) q:tr=""  d
 ...s intrtime=$p(^DHCINTR(tr),"^",3)
 ...q:(dat=frdate)&(frtime'="")&(intrtime<frtime)
 ...q:(dat=todate)&(totime'="")&(intrtime>totime)
 ...s inclb=$p(^DHCINTR(tr),"^",7)
 ...q:inclb=""
 ...s inci=+inclb,incil=$p(inclb,"||",1,2)
 ...q:(inci'>0)||('$d(^INCI(inci,"IL",$p(inclb,"||",2))))
 ...
 ...;i '$d(IncilInfoArr(incil)) d
 ...;.s ExcludeFlag=##class(web.DHCSTMHUI.DHCStkMon).ExcludeFlag(incil)
 ...;.s IncilInfoArr(incil)=ExcludeFlag
 ...;e  d
 ...;.s ExcludeFlag=$p(IncilInfoArr(incil),"^",1)
 ...;q:ExcludeFlag		//根据排除标志的定义加以过滤 ps:有库存时,过滤会有问题
 ...
 ...i '$d(InciInfoArr(inci)) d
 ....s stkgrpinfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
 ....s grptype=$p(stkgrpinfo,"^",3)
 ....s InciInfoArr(inci)=grptype
 ...e  d
 ....s InciInfo=InciInfoArr(inci)
 ....s grptype=$p(InciInfo,"^",1)
 ...q:grptype'=..sssCode()
 ...
 ...s spamt=$p($G(^DHCINTR(tr)),"^",8)
 ...s rpamt=$p($G(^DHCINTR(tr)),"^",17)
 ...s newtype=trtype
 ...s n=n+1
 ...s ^DHCDHCSTMPMLB(pid,newtype,inclb,n)=spamt_"^"_rpamt
 ...s ^DHCPAYMONFLAG(pid,inci,incil,inclb)=""
 ...i '$d(^DHCDHCSTMPMLBSTAT(pid)) d
 ....s ^DHCDHCSTMPMLBSTAT(pid)=rpamt
 ...e  d
 ....s ^DHCDHCSTMPMLBSTAT(pid)=^DHCDHCSTMPMLBSTAT(pid)+rpamt
 ;获取付款金额
 s payamt=..GetPayRpAmt(pid,pm)
 s LastRpAmt=$p(^DHCPAYM(pm),"^",13)
 ;主表增加未付款进价金额
 i $d(^DHCDHCSTMPMLBSTAT(pid)) d
 .s unpayamt=^DHCDHCSTMPMLBSTAT(pid)
 .s EndRpAmt=LastRpAmt+unpayamt-payamt
 .&sql(UPDATE DHC_PayMon SET PM_ArrearRpAmt=:unpayamt,PM_PayedRpAmt=:payamt,PM_EndRpAmt=:EndRpAmt WHERE PM_Rowid=:pm)
 s inci=""
 s err=0
 f  s inci=$o(^INCI("IL_LOC",loc,inci)) q:(inci="")!(err<0)  d
 .s ch="",ch=$o(^INCI("IL_LOC",loc,inci,ch)) 
 .s incil=inci_"||"_ch
 .
 .s IncilLastFlag=..IsIncilLastMon(LastMainRowid,incil,pm)
 .q:(IncilLastFlag=0)&&('$d(^DHCPAYMONFLAG(pid,inci,incil)))
 .s err=..SaveLBData(pid,pm,incil,LastMainRowid)   ///生成批次月报
 .i err'=0  d
 ..s err=-4
 k ^DHCDHCSTMPMLB(pid)
 k ^DHCDHCSTMPMLBSTAT(pid)
 q err
}

/// 检索付款月报明细(批次)
/// Author:lihui
/// Date: 20190529
/// Argu:
///  pm - 付款月报主表rowid
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCPayMonDetail","PayMLBDetailRp",85)
Query PayMLBDetailRp(pm As %String) As Query(ROWSPEC = "pm:%Float,paychl,PMLocdesc,scgdesc,incscdesc,incicode,incidesc,vendor,lastunpayamt:%Float,recamt:%Float,retamt:%Float,payamt:%Float,unpayamt:%Float") [ SqlProc ]
{
}

ClassMethod PayMLBDetailRpExecute(ByRef qHandle As %Binary, pm As %String) As %Status
{
	n (qHandle, pm)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:pm="" $$$OK
	s PMLocid=$p(^DHCPAYM(pm),"^",1)
	q:PMLocid="" $$$OK
	s PMLocdesc=$p(^CTLOC(PMLocid),"^",2)
	s paychl=""
	f  s paychl=$o(^DHCPAYMONLB(pm,"LB",paychl)) q:paychl=""  d
	.s pmlbdetailinfo=^DHCPAYMONLB(pm,"LB",paychl)
	.s inclb=$p(pmlbdetailinfo,"^",1)
	.s inci=+inclb
	.s scginfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	.s scgtype=$p(scginfo,"^",3)
	.q:scgtype'=..sssCode()
	.s scgdesc=$p(scginfo,"^",2)
	.s incscdr=$p(^INCI(inci,2),"^",2)
	.q:incscdr=""
	.s incscdesc=$s(incscdr'="":$p(^INC("SC",incscdr),"^",2),1:"")
	.s incicode=$p(^INCI(inci,1),"^",1)
	.s incidesc=$p(^INCI(inci,1),"^",2)
	.s veninfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(inclb)
	.s vendid=$p(veninfo,"^",1)
	.s vendor=$p(veninfo,"^",2)
	.s locid=""
	.&sql(SELECT INCLB_CTLOC_DR into:locid FROM DHC_INCItmLcBt WHERE INCLB_LB_DR=:inclb)
	.q:locid=""
	.q:(PMLocid'=locid)
	.s lastunpayamt=$p(pmlbdetailinfo,"^",2)
	.s recamt=$p(pmlbdetailinfo,"^",3)
	.s retamt=$p(pmlbdetailinfo,"^",4)
	.s payamt=$p(pmlbdetailinfo,"^",5)
	.s unpayamt=$p(pmlbdetailinfo,"^",6)
	.d OutPutRowLB

	Quit $$$OK
OutPutRowLB
	s Data=$lb(pm,paychl,PMLocdesc,scgdesc,incscdesc,incicode,incidesc,vendor,lastunpayamt,recamt,retamt,payamt,unpayamt)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
