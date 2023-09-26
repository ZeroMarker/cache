Import sqluser

/// 进销存月报明细数据维护程序
/// 相关表;
///  DHC_StkMonReport
///  DHC_StkMonStat
///  DHC_StkMonStatIn
///  DHC_StkMonRepLcBt
///  
Class web.DHCST.DHCStkMonReport Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 更新一条月报明细记录
/// Author:zhwh
/// Date:2012-11-02
/// Argu:
/// smr - 明细rowid
/// data -数据串
ClassMethod Update(smr As %String, data As %String) As %String
{
 s obj=##class(User.DHCStkMonReport).%OpenId(smr)
 d obj.%Reload()
 ;
 s sm=+smr
 s monthDate=""
 &sql(select dhcsm_month into :monthDate from dhc_stkmon where %id=:sm )
 s inci=$p(data,"^",1)  //库存项rowid
 s loc=$p(data,"^",2)  //科室obj
 s incil=$p(data,"^",3) //INC_ItmLoc
 s user=$p(data,"^",4)  //用户rowid
 s qty=$p(data,"^",5)  //本月结存数量
 s amt=$p(data,"^",6) //本月结存金额
 s costAmt=$p(data,"^",7)  //本月结存金额(进价)
 s lastQty=$p(data,"^",8) //上月结存数量
 s lastAmt=$p(data,"^",9)  //上月结存金额
 s lastCostAmt=$p(data,"^",10)  //上月结存金额(进价)
 ;
 s obj.SMRINCIDR=##class(User.INCItm).%OpenId(inci,0)
 s obj.SMRCTLOCDR=##class(User.CTLoc).%OpenId(loc,0)
 s obj.SMRINCILDR= ##class(User.INCItmLoc).%OpenId(incil,0)
 s obj.SMRMonthDate=monthDate
 s obj.SMRDate=+$h
 s obj.SMRSSUSRDR=##class(User.SSUser).%OpenId(user,0)
 s obj.SMRPhyQty=+qty
 s obj.SMRAmount=+amt
 s obj.SMRCostAmount=+costAmt
 s obj.SMRLastPhyQty=+lastQty
 s obj.SMRLastAmount=+lastAmt
 s obj.SMRLastCostAmount=+lastCostAmt
 s ret=obj.%Save()
 i $$$ISERR(ret) q -1
 q 0
}

/// 删除库存月报明细表DHC_StkMonReport的一条记录
/// (这个方法基本上不使用,因为一般不会单独删除明细)
/// Author:zhwh
/// Date:2012-11-08
/// Argu:
///  smr - DHC_StkMonReport的rowid
/// Return:
///  0 -success
///  <0 - failure
///  
ClassMethod Delete(smr As %String) As %String
{
 s sm=+smr
 s appName=##class(web.DHCST.DHCStkMon).%GetParameter("AppName")
 q:##class(web.DHCST.Common.AppCommon).Lock(appName_sm)<0 -99
 ;
 s err=0
 //是否允许删除
 i ##class(web.DHCST.DHCStkMon).AllowDel(sm)<0 d
 .d ##class(web.DHCST.Common.AppCommon).UnLock(appName_sm)
 .s err=-100
 q:err<0 err

 tstart
 //删除dhc_stkmonstat
 &sql(delete from dhc_stkmonstat where smrd_smr_dr=:smr)
 i SQLCODE<0 d
 . trollback
 . s err=-1
 . d ##class(web.DHCST.Common.AppCommon).UnLock(appName_sm)
 q:err<0 err
 //删除dhc_stkmonstatin
 &sql(delete from dhc_stkmonstatin where smrdi_smr_dr=:smr)
 i SQLCODE<0 d
 . trollback
 . s err=-2
 . d ##class(web.DHCST.Common.AppCommon).UnLock(appName_sm)
 q:err<0 err
 //删除dhc_stkmonreport
 &sql(delete from dhc_stkmonreport where %id=:smr)
 i SQLCODE<0 d
 . trollback
 . s err=-3
 . d ##class(web.DHCST.Common.AppCommon).UnLock(appName_sm)
 q:err<0 err
 tcommit
}

/// 取月报明细记录的数据
/// Author:zhwh
/// Date:2012-11-02
/// Argu:
///  smr - 明细记录rowid
/// Return:
///  记录数据串("^"分隔)
ClassMethod Select(smr As %String) As %String
{
 k PLIST
 s result=""
 &sql(select * into :PLIST() from DHC_StkMonReport where %ID=:smr )
 q:SQLCODE'=0 result
 s cnt=$o(PLIST(""),-1)
 f i=1:1:cnt d
 .i result=""  s result=$g(PLIST(i))
 .e  s result=result_"^"_$g(PLIST(i))
 .
 q result
}

/// 生成月报明细内容
/// Author:zhwh
/// Date:2012-10-31
/// Argu:
///  sm - 月报主表rowid
/// Return:
///  0 -success
///  <0 -failure
///  w ##class(web.DHCST.DHCStkMonReport).CreateRepDetail(37)
ClassMethod CreateRepDetail(sm As %String) As %String
{
 n (sm)
 s obj=##class(User.DHCStkMon).%OpenId(sm,0)
 i $ISOBJECT(obj)  d obj.%Reload()
 //取月报主信息
 s loc=obj.DHCSMCTLOCDR.%Id()
 s frdate=obj.DHCSMFromDate
 s todate=obj.DHCSMToDate
 s frtime=obj.DHCSMFromTime
 s totime=obj.DHCSMToTime
 s month=obj.DHCSMMonth
 s user=obj.DHCSMCreatedUserDR.%Id()
 s mrowid=sm
 s pId=$i(^DHCSTTmpCounter(##class(web.DHCST.DHCStkMon).%GetParameter("AppName")))  //识别流水号
 q:pId="" -100
 s HospID=$p(^CTLOC(loc),"^",22)  //取科室的医院
 s MonthConfig=##class(web.DHCST.DHCStkMon).GetParamProp("",loc,"") //发药数据取自日报
 s CreateFromDaily=$p(MonthConfig,"^",2)
 s CommonAppName=##class(web.DHCST.Common.AppCommon).%GetParameter("AppName")
 s CommonParam=""_"^"_loc_"^"_user_"^"_$g(HospID)
 s RpRule=##class(web.DHCST.Common.AppCommon).GetAppPropValue(CommonAppName,"RpRule",CommonParam)
 s $ZT="HandleErr"
 //汇总并暂存业务数据到临时Global Start
#; k ^DHCMONSTAT(pId)
#; k ^DHCMONSTATLB(pId)                             ;Zwh 2004-04-20 added
#; k ^DHCTMPMONTRANS(pId)
#; k ^DHCTMPASPRET(pId)
#; k ^DHCTMPPHAASPRET(pId)
#; k ^DHCTMPMONTRANSSUM(pId)
 k ^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId)
 s n=0,m=0
 s transtypelist=$lfs("P,Y,F,H,T,K,R,G,HC",",")
 s types=##class(web.DHCST.DHCStkMon).%GetParameter("TransTypeStr")
 s newtypes=""
 i CreateFromDaily="Y" d
 .s types=$tr(types,"P","")  //住院发药
 .s types=$tr(types,"F","")  //门诊发药
 .s newtypes="P^F"
 f i=1:1:$l(types,"^") d
 .s trtype=$p(types,"^",i)
 .q:trtype=""
 .f dat=frdate:1:todate d
 ..s tr=0 
 ..f  s tr=$o(^DHCINTR(0,"LOCTYPEDATE",loc,trtype,dat,tr)) q:tr=""  d 
 ...s intrtime=$p(^DHCINTR(tr),"^",3)
 ...q:(dat=frdate)&(frtime'="")&(intrtime<frtime)
 ...q:(dat=todate)&(totime'="")&(intrtime>totime)
 ...s inclb=$p(^DHCINTR(tr),"^",7)
 ...q:inclb=""
 ...q:##class(web.DHCST.DHCStkMon).ExcludeFlag(inclb)  //根据排除标志的定义加以过滤
 ...s inci=+inclb
 ...q:'$d(^INCI(inci,"IL",$p(inclb,"||",2)))  ;check if exists of INCIL
 ...s stkgrpinfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
 ...s grptype=$p(stkgrpinfo,"^",3)
 ...q:grptype'=..sssCode()
 ...s scg=$p(stkgrpinfo,"^",5)
 ...s inccat=$p(^INCI(inci,2),"^",2)
 ...;b ;intr3
 ...s pointer=$p(^DHCINTR(tr),"^",9)  ;pointer
 ...s baseuom=$p(^INCI(inci,1),"^",10) ;baseuom
 ...s qty=$p(^DHCINTR(tr),"^",6)     ;qty for transaction
 ...s uom=$p(^DHCINTR(tr),"^",10)    ;uom
 ...s sp=$p($G(^DHCINTR(tr)),"^",14)
 ...s spamt=$p($G(^DHCINTR(tr)),"^",8)
 ...s rp=$p($G(^DHCINTR(tr)),"^",16)
 ...s rpamt=$p($G(^DHCINTR(tr)),"^",17)
 ...i rp="" d
 ....s rp=##class(web.DHCSTPRICE).GetRp(inclb,dat,uom,HospID,"")	//zhouyg 20141203
 ....s rpamt=rp*qty
 ...s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,baseuom)
 ...s qty=qty*fac
 ...s newtype=trtype
 ...i newtype="A" d
 ....s adjid=+pointer
 ....s reasonid=$p(^DHCINAD(adjid),"^",6)
 ....i reasonid="" s newtype="AT"	//盘点损益
 ...s checkresult="0&0"  //判断是否是调价换票和赠品入库    hulihua 2015-12-01
 ...i (newtype="R")!(newtype="G") d
 ....s checkresult=..GetGiftChgCheckFlag(pointer,newtype)
 ...s n=n+1
 ...s ^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCMONSTAT",loc,newtype,inci,n)=$g(qty)_"^"_$g(sp)_"^"_$g(spamt)_"^"_$g(rpamt)_"^"_$g(inclb)_"^"_$g(oldspamt)_"^"_checkresult
 ...s ^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCMONSTATLB",newtype,inclb,n)=$g(qty)_"^"_$g(sp)_"^"_$g(spamt)_"^"_$g(rp)_"^"_$g(rpamt)_"^"_checkresult
 ...
 ...//add wyx 2014-02-18 准备插入DHC_StkMonTrans表的数据
 ...//modified by yunhaibao 20170531,准备插入DHC_StkMonSum_TransLoc数据,用于综合运营获取数据用
 ...i $lf(transtypelist,newtype) d
 ....s transindex=loc_"^"_""_"^"_inccat_"^"_inci_"^"_newtype_"^"_tr_"^"_scg
 ....s savetmp=..PrepareDataForTrans(pId,transindex,$g(qty)_"^"_$g(spamt)_"^"_$g(rpamt))
 ...//计算各种损益
 ..i (trtype="Y")!(trtype="H")!(trtype="R")!(trtype="G")!(trtype="K")!(trtype="P")!(trtype="F")!(trtype="HC") d
 ...s pharetdr=0
 ...f  s pharetdr=$o(^DHCRETA(0,"LOCTYPEDATE",loc,trtype,dat,pharetdr)) q:pharetdr=""  d 
 ....//计算各种损益
 ....q:'$d(^DHCRETA(pharetdr))
 ....s inci=$p(^DHCRETA(pharetdr),"^",1)
 ....s sp=$p(^DHCRETA(pharetdr),"^",3) 
 ....s spamt=$p(^DHCRETA(pharetdr),"^",5)
 ....s rp=$p(^DHCRETA(pharetdr),"^",11)
 ....s rpamt=$p(^DHCRETA(pharetdr),"^",12)
 ....s inclb=$p(^DHCRETA(pharetdr),"^",14)
 ....s newtype=trtype
 ....s:(RpRule="1")&&(newtype'="Y")&&(newtype'="H")&&(newtype'="HC") rpamt=0  //进价按入库进价模式不存在损益
 ....s newtype=newtype_"D"	//原业务类型后面加D
 ....s m=m+1
 ....s ^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCMONSTAT",loc,newtype,inci,m)=$g(qty)_"^"_$g(sp)_"^"_$g(spamt)_"^"_$g(rpamt)_"^"_$g(inclb)
 ....q:inclb="" 
 ....s ^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCMONSTATLB",newtype,inclb,m)=$g(qty)_"^"_$g(sp)_"^"_$g(spamt)_"^"_$g(rp)_"^"_$g(rpamt)
 ....//s amt=..GetPhaRetAspAmt(loc,inci,pointer,newtype)
 ....//s rpamt=$p(amt,"^",1)
 ....//s spamt=$p(amt,"^",2)
 ....//s rp=$p(amt,"^",3)
 ....//s sp=$p(amt,"^",4)
 ....//i (RpRule="1")&&(newtype'="Y")&&(newtype'="H") s rpamt=0  //进价按入库进价模式不存在损益
 ....//s newtype=newtype_"D"	//原业务类型后面加D
 ....//s ^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCMONSTAT",loc,newtype,inci,n)=$g(qty)_"^"_$g(sp)_"^"_$g(spamt)_"^"_$g(rpamt)_"^"_$g(inclb)
 ....//s ^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCMONSTATLB",newtype,inclb,n)=$g(qty)_"^"_$g(sp)_"^"_$g(spamt)_"^"_$g(rp)_"^"_$g(rpamt)
 //汇总并暂存业务数据到临时Global End,如下单独从日报统计发药数据,yunhaibao20160126
 i CreateFromDaily="Y" s newpid=..PrepareDataFromDaily(loc,frdate,todate,pId,"P^F")
 s inci=""
 s child=0,InsertResult=0
 s LastMon=##class(web.DHCST.DHCStkMon).LastMon(month)  ;Get the Last Month Date
 s LastMainRowid=$o(^DHCSM(0,"MLOC",LastMon,loc,""))
 s Perv=""
 f  s inci=$o(^INCI("IL_LOC",loc,inci)) q:(inci="")!($g(InsertResult)<0)  d
 .s ilSub=$o(^INCI("IL_LOC",loc,inci,"")) 
 .s incil=inci_"||"_ilSub    ;incil 
 .s stkgrpinfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
 .s grptype=$p(stkgrpinfo,"^",3)
 .q:grptype'=..sssCode()
 .s data=^INCI(inci,"IL",ilSub)
 .s availqty=##class(web.DHCST.Common.DrugStkCommon).IL(inci,loc,todate)    ; the stk-qty at the date of month-end  
 .s lastamount=0,amount=0,lastcostamount=0,costamount=0
 .s recamount=0,retamount=0,transiamount=0,transoamount=0,dspamount=0
 .s adjamount=0,consumeamount=0,disposalamount=0,aspamt=0
 .s recrpamount=0,retrpamount=0,transirpamount=0,transorpamount=0,dsprpamount=0
 .s adjrpamount=0,consumerpamount=0,disposalrpamount=0,asprpamt=0
 .s dd=+$h  ;date
 .s user=$g(user)  ;user
 .; ingdrec
 .s tmp=..GetTrans(pId,loc,inci,"G")
 .s recqty=$p(tmp,"^")
 .s recamount=$p(tmp,"^",2)
 .s recrpamount=$p(tmp,"^",3)
 .; return
 .s tmp=..GetTrans(pId,loc,inci,"R") ; receive return
 .s retqty=$p(tmp,"^")
 .s retamount=$p(tmp,"^",2)
 .s retrpamount=$p(tmp,"^",3)
 .; trans in
 .s tmp=..GetTrans(pId,loc,inci,"K") 
 .s transiqty=$p(tmp,"^")
 .s transiamount=$p(tmp,"^",2)
 .s transirpamount=$p(tmp,"^",3)
 .; trans out
 .s tmp=..GetTrans(pId,loc,inci,"T") ; transfer out
 .s transoqty=$p(tmp,"^") 
 .s transoamount=$p(tmp,"^",2)
 .s transorpamount=$p(tmp,"^",3)
 .; dsp
 .s tmp=..GetTrans(pId,loc,inci,"F") ; dispensing
 .s dspFqty=$p(tmp,"^")
 .s dspFamount=$p(tmp,"^",2)
 .s dspFrpamount=$p(tmp,"^",3)
 .
 .s tmp=..GetTrans(pId,loc,inci,"P")
 .s dspPqty=$p(tmp,"^")
 .s dspPamount=$p(tmp,"^",2)
 .s dspPrpamount=$p(tmp,"^",3)
 .s tmp=..GetTrans(pId,loc,inci,"S")
 .s dspSqty=$p(tmp,"^")
 .s dspSamount=$p(tmp,"^",2)
 .s dspSrpamount=$p(tmp,"^",3)
 .; adjust
 .s tmp=..GetTrans(pId,loc,inci,"A")
 .s adjqty=$p(tmp,"^")
 .s adjamount=$p(tmp,"^",2)
 .s adjrpamount=$p(tmp,"^",3)
 .; consume
 .s tmp=..GetTrans(pId,loc,inci,"C")
 .s consumeqty=$p(tmp,"^")
 .s consumeamount=$p(tmp,"^",2)
 .s consumerpamount=$p(tmp,"^",3)
 .; disposal
 .s tmp=..GetTrans(pId,loc,inci,"D")
 .s disposalqty=$p(tmp,"^")
 .s disposalamount=$p(tmp,"^",2)
 .s disposalrpamount=$p(tmp,"^",3)
 .; pha return
 .s tmp=..GetTrans(pId,loc,inci,"H")
 .s pharetHqty=$p(tmp,"^")
 .s pharetHamount=$p(tmp,"^",2)
 .s pharetHrpamount=$p(tmp,"^",3)
 .//门诊撤消退药
 .s tmp=..GetTrans(pId,loc,inci,"HC")
 .s pharetHCqty=$p(tmp,"^")
 .s pharetHCamount=$p(tmp,"^",2)
 .s pharetHCrpamount=$p(tmp,"^",3)
 .//撤消退药和退药同一字段
 .s pharetHqty=pharetHqty+pharetHCqty
 .s pharetHamount=pharetHamount+pharetHCamount
 .s pharetHrpamount=pharetHrpamount+pharetHCrpamount
 .
 .s tmp=..GetTrans(pId,loc,inci,"Y")
 .s pharetYqty=$p(tmp,"^")
 .s pharetYamount=$p(tmp,"^",2)
 .s pharetYrpamount=$p(tmp,"^",3)
 .s tmp=..GetTrans(pId,loc,inci,"Z")
 .s pharetZqty=$p(tmp,"^")
 .s pharetZamount=$p(tmp,"^",2)
 .s pharetZrpamount=$p(tmp,"^",3)
 .;gift rec
 .s tmp=..GetTransGift(pId,loc,inci,"G")
 .s giftrecqty=$p(tmp,"^")
 .s giftrecamount=$p(tmp,"^",2)
 .s giftrecrpamount=$p(tmp,"^",3)
 .;gift tranfer
 .s tmp=..GetTransGift(pId,loc,inci,"T")
 .s gifttrfqty=$p(tmp,"^")
 .s gifttrfamount=$p(tmp,"^",2)
 .s gifttrfrpamount=$p(tmp,"^",3)
 .;调价换票入库
 .s tmp=..GetTransChg(pId,loc,inci,"G")
 .s chgcheckrecqty=$p(tmp,"^")
 .s chgcheckamount=$p(tmp,"^",2)
 .s chgcheckrpamount=$p(tmp,"^",3)
 .;调价换票退货
 .s tmp=..GetTransChg(pId,loc,inci,"R")
 .s chgcheckretqty=$p(tmp,"^")
 .s chgcheckretamount=$p(tmp,"^",2)
 .s chgcheckretrpamount=$p(tmp,"^",3)
 .; adj saleprice
 .s aspamtStr=..GetAsp(loc,inci,frdate,todate,frtime,totime)
 .s aspamt=+$p(aspamtStr,"^",2)
 .//s arpamt=+$p(aspamtStr,"^",1)
 .s asprpamt=+$p(aspamtStr,"^",1)
 .i RpRule="1" s asprpamt=0
 .//制剂生成
 .s MAmtStr=..GetTrans(pId,loc,inci,"M")
 .s MQty=$p(MAmtStr,"^",1)
 .s MSpAmt=$p(MAmtStr,"^",2)
 .s MRpAmt=$p(MAmtStr,"^",3)
 .//制剂消耗
 .s XAmtStr=..GetTrans(pId,loc,inci,"X")
 .s XQty=$p(XAmtStr,"^",1)
 .s XSpAmt=$p(XAmtStr,"^",2)
 .s XRpAmt=$p(XAmtStr,"^",3)
 .//盘点损益
 .s ATAmtStr=..GetTrans(pId,loc,inci,"AT")
 .s ATQty=$p(ATAmtStr,"^",1)
 .s ATSpAmt=$p(ATAmtStr,"^",2)
 .s ATRpAmt=$p(ATAmtStr,"^",3)
 .//住院退药损益
 .s YDAmtStr=..GetTrans(pId,loc,inci,"YD")
 .s YDQty=$p(YDAmtStr,"^",1)
 .s YDSpAmt=$p(YDAmtStr,"^",2)
 .s YDRpAmt=$p(YDAmtStr,"^",3)
 .//门诊退药损益
 .s HDAmtStr=..GetTrans(pId,loc,inci,"HD")
 .s HDQty=$p(HDAmtStr,"^",1)
 .s HDSpAmt=$p(HDAmtStr,"^",2)
 .s HDRpAmt=$p(HDAmtStr,"^",3)
 .//门诊撤消退药损益
 .s HDAmtStr=..GetTrans(pId,loc,inci,"HCD")
 .s HCDQty=$p(HDAmtStr,"^",1)
 .s HCDSpAmt=$p(HDAmtStr,"^",2)
 .s HCDRpAmt=$p(HDAmtStr,"^",3)
 .//门诊撤消退药和退药同字段损益
 .s HDAmtStr=..GetTrans(pId,loc,inci,"HCD")
 .s HDQty=HDQty+HCDQty
 .s HDSpAmt=HDSpAmt+HCDSpAmt
 .s HDRpAmt=HDRpAmt+HCDRpAmt
 .//退货损益
 .s RDAmtStr=..GetTrans(pId,loc,inci,"RD")
 .s RDQty=$p(RDAmtStr,"^",1)
 .s RDSpAmt=$p(RDAmtStr,"^",2)
 .s RDRpAmt=$p(RDAmtStr,"^",3)
 .//入库损益(统一进价可能产生)
 .s GDAmtStr=..GetTrans(pId,loc,inci,"GD")
 .s GDQty=$p(GDAmtStr,"^",1)
 .s GDSpAmt=$p(GDAmtStr,"^",2)
 .s GDRpAmt=$p(GDAmtStr,"^",3)
 .//转移入库损益
 .s KDAmtStr=..GetTrans(pId,loc,inci,"KD")
 .s KDQty=$p(KDAmtStr,"^",1)
 .s KDSpAmt=$p(KDAmtStr,"^",2)
 .s KDRpAmt=$p(KDAmtStr,"^",3)
 .//门诊发药损益
 .s FDAmtStr=..GetTrans(pId,loc,inci,"FD")
 .s FDQty=$p(FDAmtStr,"^",1)
 .s FDSpAmt=$p(FDAmtStr,"^",2)
 .s FDRpAmt=$p(FDAmtStr,"^",3)
 .//住院发药损益
 .s PDAmtStr=..GetTrans(pId,loc,inci,"PD")
 .s PDQty=$p(PDAmtStr,"^",1)
 .s PDSpAmt=$p(PDAmtStr,"^",2)
 .s PDRpAmt=$p(PDAmtStr,"^",3)
 .//上期 
 .s last=##class(web.DHCST.DHCStkMon).GetLast(LastMainRowid,LastMon,incil)
 .s lastqty=+$p($g(last),"^",1)
 .s lastamount=+$p($g(last),"^",2)
 .s lastcostamount=+$p($g(last),"^",3)
 .//本期
 .s buomID=$p(^INCI(inci,1),"^",10)
 .s (amount,rpamount)=0
 .s lbSub=0
 .f  s lbSub=$o(^INCI(inci,"IL",ilSub,"LB",lbSub)) q:lbSub=""  d
 ..s inclb=inci_"||"_ilSub_"||"_lbSub
 ..s lbqty=##Class(web.DHCST.Common.DrugStkCommon).QtyINCLB(inclb,todate)
 ..s bUomSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclb,todate,buomID,HospID,"G","")
 ..s amount=$g(lbqty)*$g(bUomSp)+amount
 ..s bUomRp=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(inclb,todate,buomID,HospID,"G","")
 ..s rpamount=$g(lbqty)*$g(bUomRp)+rpamount  //当前进价计算
 .////wyx add 20131014
 .s Chl=$o(^INCI("IL_LOC",loc,inci,0))
 .s Incil=inci_"||"_Chl
 .//s RpAmt=##class(web.DHCST.Common.DrugStkCommon).GetRpAmt(Incil,todate)  //上方已经计算计价金额此处不再计算
 .//s rpamount=+RpAmt
 .s amount = ##class(web.DHCST.Common.AppCommon).FormatSpAmt(amount,HospID)   //进售价按照金额小数位数保留
 .s rpamount = ##class(web.DHCST.Common.AppCommon).FormatRpAmt(rpamount,HospID)
 .s InsertResult=0
 .s child=$o(^DHCSM(mrowid,"R",""),-1)+1
 .&sql(Insert into dhc_stkmonreport(SMR_SM_Parref,SMR_Childsub,SMR_CTLOC_DR,SMR_INCI_DR,SMR_INCIL_DR,SMR_PhyQty,SMR_Date,SMR_MonthDate,SMR_SSUSR_DR,
    SMR_CostAmount,SMR_Amount,SMR_LastAmount,SMR_LastCostAmount,SMR_LastPhyQty,SMR_Remarks)
   values(:mrowid,:child,:loc,:inci,:incil,:availqty,:dd,:month,:user,:rpamount,:amount,:lastamount,:lastcostamount,:lastqty,""))
 .i SQLCODE'=0 d
 ..s ret=$$ErrorRecord^DHCSTERROR("Insert:dhc_stkmonreport",mrowid,SQLCODE_":"_%msg)
 ..s InsertResult=-1 q
 .q:InsertResult=-1
 .i $g(%ROWID)'="" s SMRDR=%ROWID    ;successfully insert 
 .q:$g(SMRDR)=""
 .&sql(insert into dhc_stkmonstat(SMRD_SMR_DR,SMRD_Rec_Qty,SMRD_Rec_Amount,
      SMRD_Ret_Qty,SMRD_Ret_Amount,SMRD_Trfo_Qty,SMRD_Trfo_Amount,
   SMRD_TrfI_Qty,SMRD_TrfI_Amount,SMRD_DspP_Qty,SMRD_DspP_Amount,
   SMRD_DspF_Qty,SMRD_DspF_Amount,SMRD_DspS_Qty,SMRD_DspS_Amount,
   SMRD_Adj_Qty,SMRD_Adj_Amount,SMRD_Consume_Qty,SMRD_Consume_Amount,
   SMRD_Disposal_Qty,SMRD_Disposal_Amount,SMRD_Asp_Amount,
   SMRD_PhaRetY_Qty,SMRD_PhaRetY_Amount,SMRD_PhaRetH_Qty,
   SMRD_PhaRetH_Amount,SMRD_PhaRetZ_Qty,SMRD_PhaRetZ_Amount,
   SMRD_GiftRec_Qty,SMRD_GiftRec_Amount,SMRD_GiftTrf_Qty,SMRD_GiftTrf_Amount,
   SMRD_ChgCheckRec_Qty,SMRD_ChgCheckRec_Amount,SMRD_ChgCheckRet_Qty,
   SMRD_ChgCheckRet_Amount,SMRD_RetAsp_Amount,SMRD_PhaRetAsp_Amount,
   SMRD_StkTk_Qty,SMRD_StkTk_Amount,SMRD_ManuX_Qty,SMRD_ManuX_Amount,
   SMRD_ManuM_Qty,SMRD_ManuM_Amount,SMRD_PhoRetAsp_Amount,SMRD_TrfIAsp_Amount,
   SMRD_DspFA_Amount,SMRD_DspPA_Amount)
   values(:SMRDR,:recqty,:recamount,:retqty,:retamount,:transoqty,:transoamount,
   :transiqty,:transiamount,:dspPqty,:dspPamount,:dspFqty,:dspFamount,
   :dspSqty,:dspSamount,:adjqty,:adjamount,:consumeqty,:consumeamount,
   :disposalqty,:disposalamount,:aspamt,
   :pharetYqty,:pharetYamount,:pharetHqty,:pharetHamount,:pharetZqty,:pharetZamount,
   :giftrecqty,:giftrecamount,:gifttrfqty,:gifttrfamount,
   :chgcheckrecqty,:chgcheckamount,:chgcheckretqty,:chgcheckretamount,:RDSpAmt,:YDSpAmt,
   :ATQty,:ATSpAmt,:XQty,:XSpAmt,:MQty,:MSpAmt,:HDSpAmt,:KDSpAmt,:FDSpAmt,:PDSpAmt))

 .i SQLCODE'=0 d
 ..s ret=$$ErrorRecord^DHCSTERROR("Insert:dhc_stkmonstat",SMRDR,SQLCODE_":"_%msg)
 ..s InsertResult=-2
 .q:SQLCODE'=0
 .&sql(insert into DHC_StkMonStatIn(SMRDI_SMR_DR,SMRDI_Rec_Qty,SMRDI_Rec_Amount,
   SMRDI_Ret_Qty,SMRDI_Ret_Amount,SMRDI_Trfo_Qty,SMRDI_Trfo_Amount,
   SMRDI_TrfI_Qty,SMRDI_TrfI_Amount,SMRDI_DspP_Qty,SMRDI_DspP_Amount,
   SMRDI_Adj_Qty,SMRDI_Adj_Amount,SMRDI_Consume_Qty,SMRDI_Consume_Amount,
   SMRDI_Disposal_Qty,SMRDI_Disposal_Amount,SMRDI_Asp_Amount,
   SMRDI_PhaRetY_Qty,SMRDI_PhaRetY_Amount,SMRDI_GiftRec_Qty,SMRDI_GiftRec_Amount,
   SMRDI_GiftTrf_Qty,SMRDI_GiftTrf_Amount,SMRDI_ChgCheckRec_Qty,SMRDI_ChgCheckRec_Amount,
   SMRDI_ChgCheckRet_Qty,SMRDI_ChgCheckRet_Amount,SMRDI_DspF_Qty,SMRDI_DspF_Amount,
   SMRDI_DspS_Qty,SMRDI_DspS_Amount,SMRDI_PhaRetH_Qty,SMRDI_PhaRetH_Amount,
   SMRDI_PhaRetZ_Qty,SMRDI_PhaRetZ_Amount,SMRDI_RecAsp_Amount,SMRDI_TrfIAsp_Amount,SMRDI_RetAsp_Amount,
   SMRDI_StkTk_Qty,SMRDI_StkTk_Amount,SMRDI_ManuX_Qty,SMRDI_ManuX_Amount,SMRDI_ManuM_Qty,SMRDI_ManuM_Amount,SMRDI_PhaRetAsp_Amount)
   values(:SMRDR,:recqty,:recrpamount,:retqty,:retrpamount,:transoqty,:transorpamount,:transiqty,:transirpamount,
   :dspPqty,:dspPrpamount,:adjqty,:adjrpamount,:consumeqty,:consumerpamount,
   :disposalqty,:disposalrpamount,:asprpamt,:pharetYqty,:pharetYrpamount,:giftrecqty,:giftrecrpamount,
   :gifttrfqty,:gifttrfrpamount,:chgcheckrecqty,:chgcheckrpamount,:chgcheckretqty,:chgcheckretrpamount,
   :dspFqty,:dspFrpamount,:dspSqty,:dspSrpamount,:pharetHqty,:pharetHrpamount,:pharetZqty,
   :pharetZrpamount,:GDRpAmt,:KDRpAmt,:RDRpAmt,:ATQty,:ATRpAmt,:XQty,:XRpAmt,:MQty,:MRpAmt,:YDRpAmt))
 .i SQLCODE'=0 d
 ..s ret=$$ErrorRecord^DHCSTERROR("Insert:DHC_StkMonStatIn",SMRDR,SQLCODE_":"_%msg)
 ..s InsertResult=-3  
 .q:SQLCODE'=0 
 .//生成批次月报记录;DHC_StkMonRepLcBt
 .s err=0 //..SaveLBData(pId,SMRDR,incil,LastMainRowid)   ///生成批次月报,yunhaibao20151222,因超时问题,暂时屏蔽批次明细
 .i err'=0  d
 ..s InsertResult=-4  
 s err=0
 s err=..SaveTranData(mrowid,pId)
 i err'=0 d
 .s InsertResult=-5
 d KTmp
 q $g(InsertResult)
KTmp
  i $d(pId) {
	  k ^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId)
#;	  k ^DHCMONSTAT(pId)
#;	  k ^DHCMONSTATLB(pId)                             
#;	  k ^DHCTMPMONTRANS(pId)
#;	  k ^DHCTMPASPRET(pId)
#;	  k ^DHCTMPPHAASPRET(pId)
#;	  k ^DHCTMPMONTRANSSUM(pId)
  }
  q
HandleErr
  d KTmp
  s ret=$$Error^DHCSTERROR()
  q ret
}

/// 取某科室某品种某业务类型的发生数量、金额(比如赠品)
/// Date:2012-10-31
/// Argu:
///   pId - 临时Glboal数据识别ID
///   loc - 科室rowid
///  inci - 库存项目rowid
///  type -业务类型代码
/// Return:
///  数量^售价金额^进价金额
ClassMethod GetTrans(pId As %String, loc As %String, inci As %String, type As %String) As %String
{
  n (pId,loc,inci,type)      
  s totalqty=0,totalamount=0,totalrpamount=0
  s n=""
  f  s n=$o(^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCMONSTAT",loc,type,inci,n)) q:n=""  d
   .s data=^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCMONSTAT",loc,type,inci,n)
   .s inclb=$p(data,"^",5)
   .s result=$p(data,"^",7)
   .s giftrec=$p(result,"&",1),chgcheck=$p(result,"&",2)
   .i type="G" q:(giftrec=1)!(chgcheck=1)
   .i type="T" q:giftrec=1
   .i type="R" q:chgcheck=1
   .s qty=$p(data,"^"),totalqty=totalqty+qty
   .s sp=$p(data,"^",2) 
   .s amount=$p(data,"^",3),totalamount=totalamount+amount
   .s rpamt=$p(data,"^",4),totalrpamount=totalrpamount+rpamt
  q +$g(totalqty)_"^"_+$g(totalamount)_"^"_+$g(totalrpamount)
}

/// 取某科室某品种某业务类型的发生数量、金额(比如赠品)
/// Date:2012-10-31
/// Argu:
///  pId - 临时Glboal数据识别ID
///  loc - 科室rowid
///  inci - 库存项目rowid
///  type -业务类型代码
/// Return:
///  数量^售价金额^进价金额
///  w ##class(web.DHCST.DHCStkMonReport).GetTransChg("987414997",102,858,"R")
ClassMethod GetTransChg(pId As %String, loc As %String, inci As %String, type As %String) As %String
{
  n (pId,loc,inci,type)      
  s totalqty=0,totalamount=0,totalrpamount=0
  s n=""
  f  s n=$o(^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCMONSTAT",loc,type,inci,n)) q:n=""  d
   .s data=^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCMONSTAT",loc,type,inci,n)
   .s inclb=$p(data,"^",5)
   .s result=$p(data,"^",7)
   .s giftrec=$p(result,"&",1),chgcheck=$p(result,"&",2)
   .q:chgcheck=0
   .s qty=$p(data,"^"),totalqty=totalqty+qty
   .s sp=$p(data,"^",2) 
   .i type="G" d
   ..s amount=$p(data,"^",3)
   .e  d
   ..s amount=$p(data,"^",6)
   ..i amount="" s amount=$p(data,"^",3)
   .s totalamount=totalamount+amount
   .s rpamt=$p(data,"^",4),totalrpamount=totalrpamount+rpamt
  q +$g(totalqty)_"^"_+$g(totalamount)_"^"_+$g(totalrpamount)
}

/// 取某科室某品种某业务类型的发生数量、金额(比如赠品)
/// Date:2012-10-31
/// Argu:
///  pId - 临时Glboal数据识别ID 
///  loc - 科室rowid
///  inci - 库存项目rowid
///  type -业务类型代码
/// Return:
///  数量^售价金额^进价金额
ClassMethod GetTransGift(pId As %String, loc As %String, inci As %String, type As %String) As %String
{
  n (pId,loc,inci,type)      
  s totalqty=0,totalamount=0,totalrpamount=0
  s n=""
  f  s n=$o(^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCMONSTAT",loc,type,inci,n)) q:n=""  d
   .s data=^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCMONSTAT",loc,type,inci,n)
   .s inclb=$p(data,"^",5)
   .s result=$p(data,"^",7)
   .s giftrec=$p(result,"&",1),chgcheck=$p(result,"&",2)
   .q:giftrec=0
   .q:giftrec=""
   .s qty=$p(data,"^"),totalqty=totalqty+qty
   .s sp=$p(data,"^",2) 
   .s amount=$p(data,"^",3),totalamount=totalamount+amount
   .s rpamt=$p(data,"^",4),totalrpamount=totalrpamount+rpamt
  q +$g(totalqty)_"^"_+$g(totalamount)_"^"_+$g(totalrpamount)
}

/// 根据批次查找其最后入库的属性(是否为调价换票?赠品入库?)
/// Date:2012-10-31
/// Argu:
/// inclb  - 库存批次rowid
/// Return:
///   调价换票入库标志^赠品入库标志
///   禁用,取得不对,yunhaibao20151203
ClassMethod GetGiftChgFlag(inclb As %String) As %String
{
 n (inclb)
 s giftrec=0,chgcheckrec=0
 q:inclb="" giftrec_"^"_chgcheckrec
 s ingri=##class(web.DHCST.Common.DrugStkCommon).LastINGRI(inclb)
 q:ingri="" giftrec_"^"_chgcheckrec
 s dhcingdr=$p(ingri,"||",1)
 q:dhcingdr="" giftrec_"^"_chgcheckrec
 s chgcheckrec=$p(^DHCINGR(dhcingdr),"^",32)  // 调价换票入库标志 INGR_AdjCheque
 s:chgcheckrec="Y" chgcheckrec=1
 s:chgcheckrec="N" chgcheckrec=0
 s giftrec=$p(^DHCINGR(dhcingdr),"^",31)    //赠品入库标志 INGR_GiftFlag
 s:giftrec="Y" giftrec=1
 s:giftrec="N" giftrec=0
 q giftrec_"^"_chgcheckrec
}

/// Description: 根据台账表查找是否为调价换票和赠品入库
/// Creator:	 hulihua
/// CreatDate:   2015-12-01
/// Table:       DHC_INTRANS
/// Input:       pointer-业务指针，type-业务类型
/// Output:
/// Return:		 调价换票入库标志^赠品入库标志
ClassMethod GetGiftChgCheckFlag(pointer As %String, type As %String) As %String
{
	n (pointer,type)
	s giftrec=0,chgcheckrec=0
	q:pointer="" giftrec_"&"_chgcheckrec
	i type="G" d
	.s ingri=pointer
	.s dhcingdr=$p(ingri,"||",1)
	.s chgcheckrec=$p(^DHCINGR(dhcingdr),"^",32)  // 调价换票入库标志 INGR_AdjCheque
	.s giftrec=$p(^DHCINGR(dhcingdr),"^",31)      // 赠品入库标志 INGR_GiftFlag
	i type="R" d
	.s ingrt=pointer
	.s dhcingrt=$p(ingrt,"||",1)
	.s chgcheckrec=$p(^INGRT(dhcingrt),"^",11)    // 调价换票退货标志 INGRT_AdjCheque
	.s giftrec="N"                                // 赠品不存在退货
	s:chgcheckrec="Y" chgcheckrec=1
	s:chgcheckrec="N" chgcheckrec=0
	s:giftrec="Y" giftrec=1
	s:giftrec="N" giftrec=0
	q giftrec_"&"_chgcheckrec
}

/// 取某批次某业务类型的月报汇总数据     
/// Author:zhwh
/// Date:2012-11-01
/// Argu:
///    Type - 业务类型
///    INCLB - 库存批次rowid
/// Return:
///  业务发生数量^售价金额^进价金额
ClassMethod GetLBTrans(pId As %String, Type As %String, INCLB As %String) As %String
{
 n (pId,Type,INCLB)
 s n=""
 f  s n=$o(^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCMONSTATLB",Type,INCLB,n)) q:n=""  d
 . s qty=$g(qty)+$p(^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCMONSTATLB",Type,INCLB,n),"^",1)
 . s amt=$g(amt)+$p(^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCMONSTATLB",Type,INCLB,n),"^",3)
 . s rpamt=$g(rpamt)+$p(^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCMONSTATLB",Type,INCLB,n),"^",5)
 q $g(qty)_"^"_$g(amt)_"^"_$g(rpamt)
}

/// 本月库存结存数据
/// Author:zhwh
/// Date:2012-11-01
/// Argu:
///  INCLB  -批次rowid
///  sm - 月报住表rowid
/// Return:
///  字符串: 结存数量^结存售价金额^结存进价金额  
ClassMethod GetCurStk(INCLB As %String, sm As %String) As %String
{
 n (INCLB,sm)
 q:INCLB="" ""   
 s INCI=+INCLB
 s todate=$p(^DHCSM(sm),"^",4)
 s loc=$P($G(^INCI(INCI,"IL",$P(INCLB,"||",2))),"^",1)
 S HospID=$P(^CTLOC(loc),"^",22)
 //s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(INCI,todate,"",HospID)  //基本单位的售价
 s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(INCLB,todate,"",HospID,"G","")  //基本单位的售价
 s qty=##class(web.DHCST.Common.DrugStkCommon).QtyINCLBU(INCLB,todate,"")  //基本单位的数量
 s amt=qty*sp
 //s rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(INCLB,"",HospID)
 //s rp=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(INCI,todate,"",HospID)  //基本单位的进价
 s rp=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(INCLB,todate,"",HospID,"G","")  //基本单位的进价
 s ramt=qty*rp
 q qty_"^"_amt_"^"_ramt
}

/// 取某批次的上月月报的结存
/// Author:zhwh
/// Date:2012-11-02
/// Argu:
///  LastSM -上月月报主表rowid
///  INCLB - 批次rowid
/// Return:
/// 字符串: 结存数量^结存售价金额^结存进价金额  
ClassMethod GetLastStk(INCLB As %String, LastSM As %String) As %String
{
 n (INCLB,LastSM)
 q:INCLB="" ""
 q:LastSM="" ""
 ;
 s SMRCH=$o(^DHCSM(0,"INCLB",INCLB,LastSM,"")) q:$g(SMRCH)="" ""
 s LBCH=$o(^DHCSM(0,"INCLB",INCLB,LastSM,SMRCH,"")) q:$g(LBCH)="" ""
 ;
 i LBCH'="" d
  .q:'$d(^DHCSM(LastSM,"R",SMRCH,"B",LBCH))  ;2006-12-27
  .s qty=$p(^DHCSM(LastSM,"R",SMRCH,"B",LBCH,1),"^",3)  ;
  .s amt=$p(^DHCSM(LastSM,"R",SMRCH,"B",LBCH,1),"^",5) ;
  .s coamt=$p(^DHCSM(LastSM,"R",SMRCH,"B",LBCH,1),"^",7) ;
 q $g(qty)_"^"_$g(amt)_"^"_$g(coamt)
}

/// 生成月报批次数据
/// Date:2012-11-01
/// Argu:
///    pId - 临时Glboal数据识别ID
///    SMR - 月报明细记录rowid
///    INCIL - 科室库存rowid
///    LastSM - 上月月报主表rowid
/// Return:
/// 	0 -success
/// 	<0  -失败
ClassMethod SaveLBData(pId As %String, SMR As %String, INCIL As %String, LastSM As %String) As %String
{
 n (pId,SMR,INCIL,LastSM)
 s err=0
 s INCI=+INCIL,CH=$p(INCIL,"||",2),LBCH=0
 f  s LBCH=$o(^INCI(INCI,"IL",CH,"LB",LBCH)) q:(LBCH="")!err  d 
  . s INCLB=INCI_"||"_CH_"||"_LBCH
  . q:..IfActive(INCLB)'="Y"   //滤除状态处于"非活动"的库存批次 zhwh 2012-11-02,yunhaibao,此处可能导致月报数据不全
  . i ..InsertLBTrans(pId,SMR,INCLB,LastSM)<0 d
  . . s err=1
 q err
}

/// 插入库存批次的"批次月报"记录
/// Author:zhwh
/// Date:2012-11-01
/// Argu:
///   pId - 临时Glboal数据识别ID
///  SMR - 月报子表rowid(DHC_StkMonReport)
///  INCLB  -批次rowid
///  LastSM - 上期月报主表rowid
/// Return:
///    <0 -failure
///    0  - success
ClassMethod InsertLBTrans(pId As %String, SMR As %String, INCLB As %String, LastSM As %String)
{
 n (pId,SMR,INCLB,LastSM)
 s currstk=..GetCurStk(INCLB,+SMR)  //本期
 s laststk=..GetLastStk(INCLB,LastSM)	//上期
 s rec=..GetLBTrans(pId,"G",INCLB)	//入库
 s transo=..GetLBTrans(pId,"T",INCLB)	//出库
 s transi=..GetLBTrans(pId,"K",INCLB)	//转入
 s ret=..GetLBTrans(pId,"R",INCLB)	//退货
 s adj=..GetLBTrans(pId,"A",INCLB)  //调整
 s disp=..GetLBTrans(pId,"D",INCLB)	//报损
 s consume=..GetLBTrans(pId,"C",INCLB)	//消耗
 s dspP=..GetLBTrans(pId,"P",INCLB)	//住院发药
 s dspF=..GetLBTrans(pId,"F",INCLB)	//门诊发药
 s dspS=..GetLBTrans(pId,"S",INCLB)	//非正常发药
 s dspYret=..GetLBTrans(pId,"Y",INCLB)	//住院退药
 s dspHret=..GetLBTrans(pId,"H",INCLB)	//门诊退药
 s dspZret=..GetLBTrans(pId,"Z",INCLB)  //非正常退药
 s atamtstr=..GetLBTrans(pId,"AT",INCLB)  //盘点损益
 s ydamtstr=..GetLBTrans(pId,"YD",INCLB)  //住院退药损益
 s hdamtstr=..GetLBTrans(pId,"HD",INCLB)  //门诊退药损益
 s rdamtstr=..GetLBTrans(pId,"RD",INCLB)  //退货损益
 s gdamtstr=..GetLBTrans(pId,"GD",INCLB)  //入库损益(统一进价可能产生)
 s kdamtstr=..GetLBTrans(pId,"KD",INCLB)  //转移入库损益
 ; Get rid of the result data that have not any movements 
 s qty=$p(currstk,"^",1),amt=$p(currstk,"^",2),coamt=$p(currstk,"^",3)
 s lastqty=$p(laststk,"^",1),lastamt=$p(laststk,"^",2),lastcoamt=$p(laststk,"^",3)
 s recqty=+$p(rec,"^",1),recamt=+$p(rec,"^",2),reccoamt=+$p(rec,"^",3)
 s retqty=+$p(ret,"^",1),retamt=+$p(ret,"^",2),retcoamt=+$p(ret,"^",3)
 s transoqty=+$p(transo,"^",1),transoamt=+$p(transo,"^",2),transocoamt=+$p(transo,"^",3)
 s transiqty=+$p(transi,"^",1),transiamt=+$p(transi,"^",2),transicoamt=+$p(transi,"^",3)
 s adjqty=+$p(adj,"^",1),adjamt=+$p(adj,"^",2),adjcoamt=+$p(adj,"^",3)
 s dispqty=+$p(disp,"^",1),dispamt=+$p(disp,"^",2),dispcoamt=+$p(disp,"^",3)  //报损
 s consumeqty=+$p(consume,"^",1),consumeamt=+$p(consume,"^",2),consumecoamt=+$p(consume,"^",3)
 s dspqty=+$p(dspP,"^",1),dspamt=+$p(dspP,"^",2),dspcoamt=+$p(dspP,"^",3)
 s dspretqty=+$p(dspYret,"^",1),dspretamt=+$p(dspYret,"^",2),dspretcoamt=+$p(dspYret,"^",3)
 //yunhaibao,20151208,新表结构已有门诊住院的发药结构,非正常发药还是存在门诊里
 s phaoutdispqty=+$p(dspF,"^",1)+$p(dspS,"^",1),phaoutdispamt=+$p(dspF,"^",2)+$p(dspS,"^",2),phaoutdispcoamt=+$p(dspF,"^",3)+$p(dspS,"^",3)
 s phaoutretqty=+$p(dspHret,"^",1)+$p(dspZret,"^",1),phaoutretamt=+$p(dspHret,"^",2)+$p(dspZret,"^",2),phaoutretcoamt=+$p(dspHret,"^",3)+$p(dspZret,"^",3) 
 s asp=..GetAspaLB(INCLB,+SMR)
 s aspamt=$p(asp,"^",1),aspcoamt=$p(asp,"^",2)
 s atqty=+$p(atamtstr,"^",1),atamt=+$p(atamtstr,"^",2),atcoamt=+$p(atamtstr,"^",3)
 s ydqty=+$p(ydamtstr,"^",1),ydamt=+$p(ydamtstr,"^",2),ydcoamt=+$p(ydamtstr,"^",3)
 s hdqty=+$p(hdamtstr,"^",1),hdamt=+$p(hdamtstr,"^",2),hdcoamt=+$p(hdamtstr,"^",3)
 s rdqty=+$p(rdamtstr,"^",1),rdamt=+$p(rdamtstr,"^",2),rdcoamt=+$p(rdamtstr,"^",3)
 s gdqty=+$p(gdamtstr,"^",1),gdamt=+$p(gdamtstr,"^",2),gdcoamt=+$p(gdamtstr,"^",3)
 s kdqty=+$p(kdamtstr,"^",1),kdamt=+$p(kdamtstr,"^",2),kdcoamt=+$p(kdamtstr,"^",3)
 s lbch=$o(^DHCSM($P(SMR,"||",1),"R",$P(SMR,"||",2),"B",""),-1)+1
 q:lbch="" -1
 ;b ;lbch
 &sql(insert into DHC_StkMonRepLcBt(SMRLB_SMR_Parref,SMRLB_Childsub,SMRLB_INCLB_DR,
         SMRLB_Qty,SMRLB_LastQty,SMRLB_Amount,SMRLB_CostAmount,SMRLB_LastAmount,SMRLB_LastCostAmount,
         SMRLB_Rec_Qty,SMRLB_Rec_Amt,SMRLB_Rec_CoAmt,
         SMRLB_Ret_Qty,SMRLB_Ret_Amt,SMRLB_Ret_CoAmt,
         SMRLB_Trfo_Qty,SMRLB_Trfo_Amt,SMRLB_Trfo_CoAmt,
         SMRLB_TrfI_Qty,SMRLB_TrfI_Amt,SMRLB_TrfI_CoAmt,
         SMRLB_Adj_Qty,SMRLB_Adj_Amt,SMRLB_Adj_CoAmt,
         SMRLB_Cons_Qty,SMRLB_Cons_Amt,SMRLB_Cons_CoAmt,
         SMRLB_Disp_Qty,SMRLB_Disp_Amt,SMRLB_Disp_CoAmt,
         SMRLB_Dsp_Qty,SMRLB_Dsp_Amt,SMRLB_Dsp_CoAmt,
         SMRLB_PhaRet_Qty,SMRLB_PhaRet_Amt,SMRLB_PhaRet_CoAmt,
         SMRLB_Asp_Amt,SMRLB_Asp_CoAmt,
         SMRLB_DspO_Qty,SMRLB_DspO_Amt,SMRLB_DspO_CoAmt,
         SMRLB_PhoRet_Qty,SMRLB_PhoRet_Amt,SMRLB_PhoRet_CoAmt,
         SMRLB_RecAsp_Amt,SMRLB_RecAsp_CoAmt,
         SMRLB_TrfIAsp_Amt,SMRLB_TrfIAsp_CoAmt,
         SMRLB_RetAsp_Amt,SMRLB_RetAsp_CoAmt,
         SMRLB_PhaRetAsp_Amt,SMRLB_PhaRetAsp_CoAmt,
         SMRLB_PhoRetAsp_Amt,SMRLB_PhoRetAsp_CoAmt
         
         )
  	values (:SMR,:lbch,:INCLB,:qty,:lastqty,
         :amt,:coamt,:lastamt,:lastcoamt,
         :recqty,:recamt,:reccoamt,
         :retqty,:retamt,:retcoamt,
         :transoqty,:transoamt,:transocoamt,
         :transiqty,:transiamt,:transicoamt,
         :adjqty,:adjamt,:adjcoamt,
         :consumeqty,:consumeamt,:consumecoamt,
         :dispqty,:dispamt,:dispcoamt,
         :dspqty,:dspamt,:dspcoamt,
         :dspretqty,:dspretamt,:dspretcoamt,
         :aspamt,:aspcoamt, 
         :phaoutdispqty,:phaoutdispamt,:phaoutdispcoamt,
         :phaoutretqty,:phaoutretamt,:phaoutretcoamt,
         :gdamt,:gdcoamt,
         :kdamt,:kdcoamt,
         :rdamt,:rdcoamt,
         :ydamt,:ydcoamt,
         :hdamt,:hdcoamt )
   )
 i SQLCODE<0  d
 .s ret=$$ErrorRecord^DHCSTERROR("Insert:DHC_StkMonRepLcBt",SMR,SQLCODE_":"_%msg)
 .
 q SQLCODE
}

/// 取批次调价损益金额
/// AUthor:zhwh
/// Date:2012-11-01
/// Argu:
///  inclb -批次rowid
///  sm - 月报主表rowid
/// Return: 损益金额
ClassMethod GetAspaLB(inclb, sm)
{
 n (inclb,sm)
 q:sm="" ""
 s inci=+inclb,ch=$p(inclb,"||",2),lbch=$p(inclb,"||",3)
 s loc=$p(^DHCSM(sm),"^",1)
 s frdate=$p(^DHCSM(sm),"^",3)
 s todate=$p(^DHCSM(sm),"^",4)
 s aspa=""
 s adjaspamt=0,adjaspcoamt=0
 f dd=frdate:1:todate  d
  . f  s aspa=$o(^ASPA(0,"DATEINCIL",dd,inci,loc,aspa)) q:aspa=""  d
  . . s aspalbch=0 
  . . f  s aspalbch=$o(^ASPA(0,"INCLB",inclb,aspa,aspalbch))  q:aspalbch=""  d
  . . . s adjaspamt=adjaspamt+$p(^ASPA(aspa,"LB",aspalbch),"^",4)
  . . . s adjaspcoamt=adjaspcoamt+$p(^ASPA(aspa,"LB",aspalbch),"^",6)   //进价损益 2012-11-02
 q adjaspamt_"^"_adjaspcoamt
}

/// 取退药调价损益金额
/// Date:2012-10-31
/// Argu:
///  loc - 科室rowid
///  inci  -库存项rowid
///  pointer - 业务类型指针
///  type -业务类型代码
ClassMethod GetPhaRetAspAmt(loc As %String, inci As %String, pointer As %String, type As %String) As %String
{
 n (loc,inci,pointer,type)
 s pharetdr=$o(^DHCRETA(0,"TypePointer",type,pointer,""))
 q:pharetdr="" 0
 q:'$d(^DHCRETA(pharetdr)) 0
 s spamt=$p(^DHCRETA(pharetdr),"^",5)
 s rpamt=$p(^DHCRETA(pharetdr),"^",12)
 s sp=$p(^DHCRETA(pharetdr),"^",3)
 s rp=$p(^DHCRETA(pharetdr),"^",11)
 q rpamt_"^"_spamt_"^"_rp_"^"_sp
}

/// 取某科室某品种一段日期范围内的调价损益金额
/// Author:zhwh
/// Date:2012-10-31
/// Argu:
///  loc as %String ,inci as %String,frdate,todate
/// Return:
/// 调价损益进价金额^调价损益售价金额
ClassMethod GetAsp(loc As %String, inci As %String, frdate As %String, todate As %String, frtime As %String = "", totime As %String = "") As %String
{
 n (loc,inci,frdate,todate,frtime,totime)
 q:loc="" 0
 q:inci="" 0
 s spamt=0,rpamt=0
 f aspdate=frdate:1:todate  d
 .s asp=""
 .f  s asp=$o(^ASPA(0,"DATEINCIL",aspdate,inci,loc,asp)) q:asp=""  d
 ..s aspTime= $p(^ASPA(asp),"^",9)
 ..q:(aspdate=frdate)&&(frtime'="")&&(aspTime<frtime)
 ..q:(aspdate=todate)&&(totime'="")&&(aspTime>totime)
 ..s spamt=spamt+$p(^ASPA(asp),"^",5)
 ..s rpamt=rpamt+$p(^ASPA(asp),"^",12)
 q rpamt_"^"_spamt
}

/// 判断某个批次是否为"活动"状态
/// Author:zhwh
/// Date:2012-11-02
/// Argu:
///  inclb -库存批次rowid
/// Return:
///  "Y" - 是
///  "N","" - 否
ClassMethod IfActive(inclb As %String) As %String
{
 n (inclb)
 s dhclb=$o( ^DHCINCLB(0,"LB",inclb,""))
 q:dhclb="" "Y"
 s active=$p($G( ^DHCINCLB(dhclb)),"^",2)
 q active
}

/// 保存月报台帐表的数据
/// Author:wyx 
/// Date:2014-02-18
/// 
ClassMethod SaveTranData(sm, pId) As %String
{
 n (sm,pId)
 s loc=$p(^DHCSM(sm),"^",1)
 s ret=0
 s relaLoc=""
 f  s relaLoc=$o(^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCTMPMONTRANSSUM",loc,relaLoc)) q:(relaLoc="")||(ret<0)  d
 .s scg="" 
 .f  s scg=$o(^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCTMPMONTRANSSUM",loc,relaLoc,scg)) q:(scg="")||(ret<0)  d
 ..s cat="" 
 ..f  s cat=$o(^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCTMPMONTRANSSUM",loc,relaLoc,scg,cat)) q:(cat="")||(ret<0)  d
 ...s type=""
 ...f  s type=$o(^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCTMPMONTRANSSUM",loc,relaLoc,scg,cat,type)) q:(type="")||(ret<0)  d
 ....q:(type'="TK")&&(type'="RG")&&(type'="PYFH")
 ....s tkRpAmt=$p(^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCTMPMONTRANSSUM",loc,relaLoc,scg,cat,type),"^",1)
 ....s tkSpAmt=$p(^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCTMPMONTRANSSUM",loc,relaLoc,scg,cat,type),"^",2)
 ....;relaLoc(TK:业务科室, RG:供应商 , PYFH:发药科室)
 ....i type="TK" s RelaLocDr=relaLoc,RelaOrg=""
 ....i type="RG" s RelaLocDr=loc,RelaOrg=relaLoc
 ....i type="PYFH" s RelaLocDr=relaLoc,RelaOrg=""
 ....&sql(Insert DHC_StkMonSum_TransLoc
 	(SUMTL_SM_DR,SUMTL_Type,SUMTL_RelaLoc_DR,SUMTL_StkCat_DR,SUMTL_SCG_DR,
 	SUMTL_RpAmt,SUMTL_SpAmt,SUMTL_RelaOrg)
 	values
 	(:sm,:type,:RelaLocDr,:cat,:scg,
 	:tkRpAmt,:tkSpAmt,:RelaOrg))
 ....i SQLCODE=0  d
 .....s sumtlRowId=%ROWID
 .....s ret=..CreatTranData(sm,loc,scg,cat,pId,sumtlRowId,relaLoc,type)
 ....e  d
 .....s ret=-9
 q ret
}

/// relaLoc参数(type=TK时传入业务科室id, type=RG时传入供应商id)
ClassMethod CreatTranData(sm, loc, scg, cat, pId, sumtlRowId, relaLoc, type) As %String
{
 n (sm,loc,scg,cat,pId,sumtlRowId,relaLoc,type)
 q:loc="" -1
 q:sm="" -1
 q:pId="" -1
 s relaLocCat=relaLoc_"^"_cat
 s $ZT="Error^DHCSTERROR"
 s InsertResult=0
 s len=$l(type)
 s inci="" 
 f  s inci=$o(^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCTMPMONTRANS",loc,relaLocCat,inci)) q:inci=""  d
 .f i=1:1:len  d
 ..s newtype=$e(type,i)
 ..s tr="0" 
 ..f  s tr=$o(^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCTMPMONTRANS",loc,relaLocCat,inci,newtype,tr))  q:(tr="")!(tr=0)  d
 ...s tmpstr=^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCTMPMONTRANS",loc,relaLocCat,inci,newtype,tr)
 ...s qty=$p(tmpstr,"^",1)
 ...s spamt=$p(tmpstr,"^",2)
 ...s rpamt=$p(tmpstr,"^",3)
 ...s pointer=$p(^DHCINTR(tr),"^",9)
 ...s slg=""		;科室组
 ...&sql(select DHCLoc_SLG_Dr into :slg from dhcst_ctloc where DHCLoc_Ctloc_dr=:relaLoc)
 ...s (operateType,RelaLocDr,RelaOrg)=""
 ...i ((newtype="T")||(newtype="K")) d
 ....s operateType=$p(^DHCINIT($p(pointer,"||",1)),"^",20)	;记录出库类型
 ....s RelaLocDr=relaLoc,RelaOrg=""
 ...e  i ((newtype="G")||(newtype="R")) d
 ....s RelaLocDr=loc,RelaOrg=relaLoc
 ...e  i ((newtype="P")||(newtype="Y")||(newtype="F")||(newtype="H")) d
 ....s RelaLocDr=relaLoc,RelaOrg=""
 ...s smsub=$O(^DHCSM(0,"INCI",inci,sm,""))
 ...s smr=sm_"||"_smsub
 ...s chsub=$o(^DHCSM(sm,"R",smsub,"T",""),-1)+1
 ...&sql(insert into DHC_StkMonTrans(SMT_SMR_Parref,SMT_ChildSub,SMT_TransType,SMT_Pointer,SMT_PhyQty,
       SMT_Amount,SMT_CostAmount,SMT_RelaLoc_DR,SMT_SLG_DR,SMT_INCSC_DR,
       SMT_SCG_DR,SMT_SUMTL_DR,SMT_OperateType,SMT_RelaOrg)
   values(:smr,:chsub,:newtype,:pointer,:qty,
       :spamt,:rpamt,:RelaLocDr,:slg,:cat,
       :scg,:sumtlRowId,:operateType,:RelaOrg))
 ...i SQLCODE'=0 d
 ....d ErrorRecord^DHCSTERROR(..%GetParameter("AppName"),smr_","_chsub_","_newtype_","_pointer_","_qty_","_spamt_","_rpamt_","_relaLoc_","_slg,$ClassName()_".CreatTranData:SQLCODE"_SQLCODE_":"_$g(%msg))
 ....s InsertResult=-1 q
 q InsertResult
}

/// creator:yunhaibao
/// createdate:20160126
/// description:根据类型统计日报的发退药数据,用于生成月报
/// w ##class(web.DHCST.DHCStkMonReport).PrepareDataFromDaily(100,"63935","63943","111111","P^Y^F^H")
ClassMethod PrepareDataFromDaily(locrowid, startdate, enddate, pId, newtypes)
{
	n (locrowid,startdate,enddate,newtypes,pId)
	q:locrowid="" ""
	s countnum=0
	s i=0
	s checkresult="0&0"
	s cacudate=""
	f cacudate=startdate:1:enddate d
	.q:'$d(^DHCSDR(0,"DateLoc",cacudate,locrowid))
	.s stkdaily=$o(^DHCSDR(0,"DateLoc",cacudate,locrowid,""),-1) //日期+药房唯一记录
	.s stkdailyreport=""
	.f  s stkdailyreport=$o(^DHCSDR(stkdaily,"R",stkdailyreport)) q:stkdailyreport=""  d //rp+sp+inci确定子记录
	..q:+stkdailyreport=0
	..s stkdailydata=$g(^DHCSDR(stkdaily,"R",stkdailyreport))
	..s sp=$p(stkdailydata,"^",3)
	..s rp=$p(stkdailydata,"^",2)
	..s inci=$p(stkdailydata,"^",1)
	..s stkdailytrans="" 
	..f  s stkdailytrans=$o(^DHCSDR(stkdaily,"R",stkdailyreport,"T",stkdailytrans)) q:stkdailytrans=""  d
	...q:+stkdailytrans=0
	...s dailytransdata=$g(^DHCSDR(stkdaily,"R",stkdailyreport,"T",stkdailytrans))
	...s transtype=$p(dailytransdata,"^",5)
	...q:transtype["Ward"  //以docloc的数据为准,孙表数据是按docloc和ward存了两份数据
	...s newtranstype=$e(transtype,1) //对应台账类型PYFH
	...q:newtypes'[newtranstype
	...s transrpamt=$p(dailytransdata,"^",3)
	...s transspamt=$p(dailytransdata,"^",4)
	...s transqty=$p(dailytransdata,"^",2)
	...s countnum=countnum+1
 	...s ^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCMONSTAT",locrowid,newtranstype,inci,countnum)=$g(transqty)_"^"_$g(sp)_"^"_$g(transspamt)_"^"_$g(transrpamt)_"^"_""_"^"_""_"^"_checkresult
	q pId
}

/// creator:    yunhaibao
/// createdate: 20170531
/// description:准备数据至临时global,用于插入DHC_StkMonSum_TransLoc\DHC_StkMonTrans
/// params:detailData-qty^rpamt6spamt
/// w ##class(web.DHCST.DHCStkMonReport).PrepareDataForTrans()
ClassMethod PrepareDataForTrans(pId, indexData, detailData) As %String
{
	n (pId,indexData,detailData)
	s newType=$p(indexData,"^",5)
	s trId=$p(indexData,"^",6)
	s locId=$p(indexData,"^",1)
	s incCat=$p(indexData,"^",3)
	s inciId=$p(indexData,"^",4)
	s scgId=$p(indexData,"^",7)
	s rpAmt=$p(detailData,"^",3)
	s spAmt=$p(detailData,"^",2)
	s pointer=$p(^DHCINTR(trId),"^",9)
	s type="",tkRpAmt=0,tkSpAmt=0,relaLoc=""
	// 转移出入数据,relaLoc=出入科室
	i (newType="T")||(newType="K") d
	.s relaLoc=$s(newType="T":$p(^DHCINIT(+pointer),"^",6),newType="K":$p(^DHCINIT(+pointer),"^",5),1:"")
	.s type="TK"
	// 入库退货数据,relaLoc=供应商
	i (newType="G")||(newType="R") d
	.s pointer=$p(^DHCINTR(trId),"^",9)
	.s relaLoc=$s(newType="G":$p($g(^DHCINGR(+pointer)),"^",3),newType="R":$p($g(^INGRT(+pointer)),"^",2))
	.s type="RG"
	// 门诊发退数据,relaLoc=发药科室
	i (newType="P")||(newType="Y")||(newType="F")||(newType="H") d
	.i newType="P" d
	..q:'$d(^DHCPHAC(+pointer))
	..s pacwarddr=$p($g(^DHCPHAC(+pointer)),"^",4) //病区
	..i pacwarddr'="" s relaLoc=$p($g(^PAWARD(pacwarddr)),"^",5) 
	..e  s relaLoc=##class(web.DHCSTPCHCOLLS).DocLoc(+pointer) //医生科室
	.e  i newType="Y"  d
	..q:'$d(^PHARET(+pointer))
	..s wardlocdr=$p($g(^PHARET(+pointer)),"^",6)
	..i wardlocdr'="" s relaLoc=wardlocdr
	..e  s relaLoc=""
	.e  i newType="F" d
	..q:'$d(^DHCPHDI(+pointer,"PHDI",$p(pointer,"||",2)))
	..s oeori=$p($g(^DHCPHDI(+pointer,"PHDI",$p(pointer,"||",2))),"^",5)
	..s relaLoc=..GetAdmLocIdByOeori(oeori)
	.e  i newType="H" d
	..q:'$d(^DHCPHRTI(+pointer,"RTI",$p(pointer,"||",2)))
	..s oeori=$p(^DHCPHRTI(+pointer,"RTI",$p(pointer,"||",2)),"^",2)
	..s relaLoc=..GetAdmLocIdByOeori(oeori)
	.e  i newType="HC" d
	..q:'$d(^DHCPHRTI(+pointer,"RTI",$p(pointer,"||",2)))
	..s oeori=$p(^DHCPHRTI(+pointer,"RTI",$p(pointer,"||",2)),"^",2)
	..s relaLoc=..GetAdmLocIdByOeori(oeori)
	.s type="PYFH"
	q:relaLoc="" 0
	q:type="" 0
    s ^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCTMPMONTRANS",locId,relaLoc_"^"_incCat,inciId,newType,trId)=detailData
	i $d(^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCTMPMONTRANSSUM",locId,relaLoc,scgId,incCat,type)) d
	.s tkRpAmt=+rpAmt+$p(^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCTMPMONTRANSSUM",locId,relaLoc,scgId,incCat,type),"^",1)
	.s tkSpAmt=+spAmt+$p(^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCTMPMONTRANSSUM",locId,relaLoc,scgId,incCat,type),"^",2)
	.s ^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCTMPMONTRANSSUM",locId,relaLoc,scgId,incCat,type)=$g(tkRpAmt)_"^"_$g(tkSpAmt)
	e  d
	.s ^TMP("DHCST","web.DHCST.DHCStkMonReport","CreateRepDetail",pId,"DHCTMPMONTRANSSUM",locId,relaLoc,scgId,incCat,type)=$g(rpAmt)_"^"_$g(spAmt)
	q 0
}

ClassMethod GetAdmLocIdByOeori(oeori) As %String
{
	n (oeori)
	s paadmdr=$P($g(^OEORD(+oeori)),"^",1)
	q:paadmdr="" ""
	S paadmloc=$P($G(^PAADM(paadmdr)),"^",4)
	q paadmloc
}

}
