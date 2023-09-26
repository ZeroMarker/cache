Import sqluser

Class web.DHCOutPhDisp Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod UpdatePhwp(phwp As %Library.String = "", flag As %Library.String = "", ctloc As %Library.String = "")
{
  //yunhaibao20161122,至少保持一个窗口开启,用于默认分配
  s exist=0
  i flag=0 d
  .q:phwp="" 
  .q:'$d(^DHCPHWP(phwp)) 
  .s phwpphl=$p(^DHCPHWP(phwp),"^",2)
  .s phwpphw=0
  .f  s phwpphw=$o(^DHCPHWPi("WINDOW",phwpphl,phwpphw)) q:phwpphw=""  d
  ..q:$p($g(^DHCPHWIN(phwpphw)),"^",4)=1
  ..s phwpid=0
  ..f  s phwpid=$o(^DHCPHWPi("WINDOW",phwpphl,phwpphw,phwpid)) q:phwpid=""  d
  ...q:phwp=phwpid
  ...s doflag=$p(^DHCPHWP(phwpid),"^",1)
  ...q:doflag'=1
  ...s exist=1
  q:(flag=0)&&(exist=0) -11
  &sql(update sqluser.dhc_phwper set phwp_doflag=:flag where phwp_rowid=:phwp)
  q SQLCODE
}

ClassMethod GetPhgg(inc As %Library.String = "")
{
  s itminf="",retgg=""
  s itminf=$o(^DHCITMINFO(0,"INCI",inc,""))
  i itminf'=""  d
    .s retgg=$p(^DHCITMINFO(itminf),"^",27)
  q retgg
}

/// w ##class(web.DHCOutPhDisp).GetSureWin(100)
ClassMethod GetSureWin(ctloc As %Library.String = "")
{
 s phl="",ret="0"
 s phl=$o(^DHCPHLOCi("LOC",ctloc,"")) 	
 i phl="" s ret="-1" q ret
 s byfs="",windesc="",phw="",pk=0,winid=""
 s byfs=$p(^DHCPHLOC(phl),"^",5)
 i byfs'="1"  d
   .f  s phw=$o(^DHCPHWINi("WIN",phl,phw)) q:(phw="")!(pk=1)  d
     ..s sureflag=""
     ..s sureflag=$p(^DHCPHWIN(phw),"^",3)
     ..q:sureflag'="1"
     ..s pk=pk+1
     ..s windesc=$p(^DHCPHWIN(phw),"^",1)
     ..s winid=phw
     ..s ret=windesc_"^"_winid_"^"_phl
 q ret
}

ClassMethod GWinDoFlag(itmjs As %Library.String = "", itmjsex As %Library.String = "", ctloc As %Library.String = "")
{
    s ret=""
    k ^TMPOPENWin($j)
  	s desc="",flag="",wp="",m=0
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	s phw="0"
	f  s phw=$o(^DHCPHWINi("WIN",phl,phw)) q:phw=""  d
	  .s phwp="",phwl=""
	  .s phwp=$o(^DHCPHWPi("WINDOW",phl,phw,""))
	  .s useflag="",phwdesc="",doflag=""
	  .q:phwp=""
	  .s doflag=$p(^DHCPHWP(phwp),"^",1)
	  .i doflag="1" s doflag="有人" 
	  .e  s doflag="无人"
	  .q:phw=""
	  .s useflag=$p(^DHCPHWIN(phw),"^",4)
	  .q:useflag="1"
      .s phwdesc=$p(^DHCPHWIN(phw),"^",1)
      .s m=m+1
      .s ^TMPOPENWin($j,m)=phwdesc_"^"_doflag_"^"_phwp
   i m>0  s ret=$j_"^"_m
   e  s ret=""
   s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
   i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
   &javascript<#(retval)#>
   q 1
}

ClassMethod GWinItm(itmjs As %Library.String = "", itmjsex As %Library.String = "", proc As %Library.String = "", t As %Library.String = "")
{
 s ret=""
 s ret=^TMPOPENWin(proc,t)
 s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod dispenph(orditem As %Library.String = "")
{
   s ret=0
   s sysdate=+$h
   s systime=$p($h,",",2)
   
	s ord=$p(orditem,"||",1)
	s ordi=$p(orditem,"||",2)
	s $p(^OEORD(ord,"I",ordi,6),"^",7)="1"
	s err=##class(web.DHCOutPhDisp).collect(ord,ordi)
	;newadd by tang 2007-08-07
	 &sql(update sqluser.dhc_oedispensing set dsp_status='C',dsp_type='F',dsp_date=:sysdate,dsp_time=:systime
	 where dsp_oeori_dr=:orditem )
	 i $g(SQLCODE)'=0 s ret=-1
   q ret
}

ClassMethod GLocType(itmjs As %Library.String = "", itmjsex As %Library.String = "", ctloc As %Library.String = "")
{
   s ret="",phl="",tjflag="",cyflag=""
   s phl=$o(^DHCPHLOCi("LOC",ctloc,"")) 
   i phl=""  s ret=""
   e  d
     .s tjflag=$p(^DHCPHLOC(phl),"^",5) //提前摆药
     .s cyflag=$p(^DHCPHLOC(phl),"^",6)
     .s ret=tjflag_"^"_cyflag
   s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
   i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
   &javascript<#(retval)#>
   q 1
}

ClassMethod GDescFrid(itmjs As %Library.String = "", itmjsex As %Library.String = "", phl As %Library.String = "", phw As %Library.String = "", pydr As %Library.String = "", fydr As %Library.String = "", wincode As %Library.String = "")
{
   s ret="",ctloc="",ctlocdesc="",phwdesc="",pyname="",fyname="",winposdesc=""
   s ctloc=+$p(^DHCPHLOC(phl),"^",1)
   s ctlocdesc=$p(^CTLOC(ctloc),"^",2)
   i ctlocdesc["-" s ctlocdesc=$p(ctlocdesc,"-",2)
   s phwdesc=$p(^DHCPHWIN(phw),"^",1)
   i pydr'="" s pyname=$p(^DHCPHPER(pydr),"^",2)
   i fydr'="" s fyname=$p(^DHCPHPER(fydr),"^",2)
   i wincode="W" s winposdesc="西侧"
   i wincode="E" s winposdesc="东侧"
   s ret=ctlocdesc_"^"_phwdesc_"^"_pyname_"^"_fyname_"^"_winposdesc
   s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
   i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
   &javascript<#(retval)#>
   q 1
}

ClassMethod ExitSys(itmjs As %Library.String = "", itmjsex As %Library.String = "", phl, phw)
{
   s ret=0
   &sql(update sqluser.dhc_phwper set phwp_doflag="" where phwp_phl_dr=:phl and phwp_phw_dr=:phw)
   s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
   i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
   &javascript<#(retval)#>
   q 1
}

ClassMethod UpdatePyd(prt As %Library.String = "", phl As %Library.String = "", pydr As %Library.String = "", fydr As %Library.String = "", prescno As %Library.String = "", shdr As %Library.String = "", phw As %Library.String = "", newphw As %Library.String = "", pycode As %Library.String = "", ordstr = "", supp = "")
{
	s owedr=$p(ordstr,"&&",4)
	s currdate=$p($h,",",1)
	s currtime=$p($h,",",2)
	s currdt=currdate_","_currtime
	s ctloc=+$P(^DHCPHLOC(phl),"^",1)
	s locdr=$p(^DHCPHLOC(phl),"^",1)
	s hospid=$p(^CTLOC(ctloc),"^",22)
	s Params="^"_ctloc_"^^"_hospid
	s NeedSkinTest=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTOUTPH","SKINTESTFLAG",Params) //皮试配置,为Y时需要判断,yunhaibao20160531
	s leadlocdr=..GetLeadLoc(locdr)
	s mainphl=$o(^DHCPHLOCi("LOC",leadlocdr,""))
	s oldphl=phl
	s phl=mainphl
	s send=""
	s:$D(^GLobDHCPHLOC(phl)) send=$p(^GLobDHCPHLOC(phl),"^",1)
	s pyusr=pydr,fyusr="",shusr=""
	i pycode'=""  d
	.s pyuserowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",pycode,""))
	.s uppydr="",pydr=""
   	.f  s uppydr=$o(^DHCPHPERi("USR",pyuserowid,uppydr)) q:uppydr=""  d
  	..s pyloc=""
  	..s pyloc=+$p(^DHCPHPER(uppydr),"^",3)
  	..q:pyloc'=oldphl
  	..s pydr=uppydr
	s cyflag=$p(^DHCPHLOC(phl),"^",6)
	i cyflag="1"  d
	.s pyusr=shdr,fyusr=fydr,shusr=fydr
	e  d
	.s pyusr=pydr,fyusr=fydr,shusr=shdr
	s ssusr="",pmino=""
	i (cyflag="1")&(fyusr'="")  d
	.s ssusr=+$p(^DHCPHPER(fyusr),"^",5)
	e  d
	.s ssusr=+$p(^DHCPHPER(fyusr),"^",5)
	s susercode=""
	i ssusr'="" d
	.s susercode=$p($g(^SSU("SSUSR",ssusr)),"^",1) 
	s phdrow="0",pharow="",ret=""

    s prt="" //2018.03.26  zzd 
    l +^DHCOEDISPENSING(prescno):5  e  q -23   ;加锁
    
    
    s chkerr=..CheckNotUseNew(prescno,phl)        //2018.03.26  zzd  忽视发票  
    i chkerr=1 D unlock
	q:chkerr=1 -20
	s chkerr=..CheckBeforUpdate(prescno,phl)
	i (chkerr=1)&(owedr="") D unlock
	q:(chkerr=1)&(owedr="") -21 ///如果是欠药发药，则不考虑已发状态
	s chkerr=..CheckBeforInsertNew(prescno,oldphl,0)   //2018.03.26  zzd  忽视发票 
	i (chkerr=0)&(owedr="") D unlock
	q:(chkerr=0)&(owedr="") -26
	i (owedr'="")&(..GetOwdStatus(owedr)'=1) D unlock
	q:(owedr'="")&(..GetOwdStatus(owedr)'=1) -31  //如果是欠药,判断是否已发完
	TSTART
	Set $ZT="troll"
	s phdrowid=""
	s suess=0
	s phdisprowid=""
	f  s phdrow=$o(^DHCPHDISPi("PRESCNO",prescno,phdrow)) q:(phdrow="")!(phdrow="0")!(suess'=0)  d
	.s phdprescno="",pmi=""
	.s phdphl=$p(^DHCPHDISP(phdrow,1),"^",1)
	.s phdprtID=$p(^DHCPHDISP(phdrow),"^",2)
    .;q:(phdprtID'=prt)&(phdprtID'="")&(prt'="")      //zzd 忽视发票 待定
	.s fyflag=$p(^DHCPHDISP(phdrow),"^",4)
	.q:fyflag=1  ///过滤已发药
	.s tmpowedr=$p(^DHCPHDISP(phdrow,2),"^",2)
	.q:(owedr'="")&(tmpowedr'=owedr) ///欠药发药时，过滤非欠药记录
	.q:(owedr="")&(tmpowedr'="")
	.s checkskintest=..CheckSkinTestByPhd(phdrow)
	.i (NeedSkinTest="Y")&&(checkskintest=1) s suess=-123
	.q:suess'=0
    .s pmi=+$p(^DHCPHDISP(phdrow),"^",7)
    .s pmino=$p(^PAPER(pmi,"PAT",1),"^",2)
    .s phdisprowid=phdrow
    .s phw=$p(^DHCPHDISP(phdrow,1),"^",4)
    .;	
    .s $p(^DHCPHDISP(phdrow),"^",4)="1"
	.s $p(^DHCPHDISP(phdrow,1),"^",2)=fyusr 
	.// 直接发药如果配药人为空则需更新
	.i $p(^DHCPHDISP(phdrow,1),"^",3)="" s $p(^DHCPHDISP(phdrow,1),"^",3)=pyusr  
	.i newphw'="" s $p(^DHCPHDISP(phdrow,1),"^",4)=newphw
	.s $p(^DHCPHDISP(phdrow,1),"^",16)=shusr
    .s phdsub=""
    .f  s phdsub=$o(^DHCPHDI(phdrow,"PHDI",phdsub)) q:(phdsub="")!(suess'=0)  d
    ..s oeori="",ord="",itm="",qty=0,basqty=0,err="",fs=0
    ..s oeori=$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",5)
    ..s basprice=0,phdmoney=0
    ..s phdmoney=+$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",3)
    ..s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
    ..q:(ord="")!(itm="")
    ..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)  
    ..s BillFlag=$p(^OEORD(ord,"I",itm,3),"^",5)
    ..q:(BillFlag'="P")&(oeflag'="V")&(oeflag'="E")	//2018.03.26  zzd  忽视发票  
    ..i $d(^OEORD(ord,"I",itm,2))  s duratdr=+$p(^OEORD(ord,"I",itm,2),"^",6)
    ..i +$g(duratdr)'=0  d
    ...i $d(^PHCDU(duratdr)) s fs=+$p(^PHCDU(duratdr),"^",2)
    ..i cyflag="1"  d
    ...s $p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",9)=fs
    ..s itmmast="",puruom="",basuom="",inci=""
    ..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
    ..s pointer=""
    ..s pointer=phdrow_"||"_phdsub 
    ..s paidflag=1
    ..i BillFlag="P" d
    ...s ordpriceinfo=##class(web.DHCOutPhCommon).GetBasePriceByOe(oeori)  //2018.03.26  zzd  忽视发票   替换上一方法
    ...s paidflag=$p(ordpriceinfo,"^",3)	//判断是否收费，而不能判断金额是否为0  zhouyg 20160223
    ..q:paidflag=0	
    ..s parowid=phdrow_"||"_phdsub
    ..s suess=..Dispensing(parowid,oeori,ctloc,currdt)
    ..i suess=-4 s suess=-24
    ..q:suess'=0
    ..s suess=..UpdOrdRecloc(oeori,phl,pointer,pydr)
    ..q:suess'=0
    ..s $p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",10)=1  //发药子表FYFlag=1为发药减库,考虑有机器配完药又有医嘱退费情况  2012-10-18
    ..;生成补货记录
    ..s:supp'="" suess=##class(web.DHCSTPHSUPPLY).SavePHOutSUPPLYITM(supp,pointer)
    ..//i suess'=0 tro
    .q:suess'=0
    .s phdrowid=phdrow
    .;
    i suess'=0 TRo
    i suess'=0 d unlock
    q:suess=-24 -24
    q:suess=-123 -123
    q:suess'=0 -291
    // zhouyg 20140328添加返回值的判断，去掉循环内的tro
    i suess=0 s suess=..UpdPhDispEN(phdrowid,currdate,currtime,prt)
    i suess'=0 TRo
    
    i suess'=0 d unlock
    q:suess'=0 -292
    ;
    s:suess=0 suess=..UpdOeDispen(prescno)  //如果有欠药时检测，标记已发药
    i suess'=0 TRo
    i suess'=0 d unlock   
    q:suess'=0 -30
    ;
    i newphw="" s newphw=phw
    s suess=..UpdPharwin(prt,prescno,phl,newphw)  //到这的都是发药成功的  zzd忽视发票 
    i suess'=0 TRo
    i suess'=0 d unlock
    q:suess'=0 -31
    ///更新欠药已发标志
    i owedr'="" s suess=..UpdOweListStatus(owedr)
    i suess'=0 TRo
    i suess'=0 d unlock
    q:suess'=0 -32
    TCOMMIT
    
    D unlock
    //读取拒绝发药申诉消息prescno
    i prescno'="" d
    .s phaor=$o(^DHCPHORDM(0,"PrescNo",prescno,""),-1)
    .q:phaor=""
    .q:$p(^DHCPHORDM(phaor),"^",9)'="OR"
    .&SQL(UPDATE DHC_PHAORDMONITOR SET PHAOM_Result='Y',PHAOM_CancelUser_Dr=null,PHAOM_CancelDate=null,PHAOM_CancelTime=null WHERE PHAOM_ROWID=:phaor)
    .s execret=##class(web.DHCSTInterfaceMessage).SendAppealOrderMonitor(phaor,"Exec")
	job ##class(web.DHCST.HERP).SendData(phdrowid,"F","")   //插入HERP中间表 add by liangjiaquan 2018-11-27
	q +phdrowid 
    
unlock 
    l -^DHCOEDISPENSING(prescno)
    q
    
troll
   Set $ZT=""
   TRo
   l -^DHCOEDISPENSING(prescno)
   i $g(inci)'="" l -^DHCINCIL(ctloc,inci)
   s ErrorMsg=$ZE
   q ErrorMsg
}

ClassMethod GetNextWin(phl, phw)
{
 
  s nextwin="",prewin="",df=""
  s df=$p(^DHCPHLOCWINOPEN(+$h,phl,phw),"^",2)
  s nextwin=phw
  f  s nextwin=$o(^DHCPHWINi(phl,nextwin)) q:(nextwin="")!(prewin'="")  d
    .s nextdf="",openflag="",tprs=0
    .s nextdf=$p(^DHCPHLOCWINOPEN(+$h,phl,nextwin),"^",2)
    .q:nextdf'=df
    .s openflag=$p(^DHCPHLOCWINOPEN(+$h,phl,nextwin),"^",1)
    .s tprs=$p(^DHCPHLOCWINOPEN(+$h,phl,nextwin),"^",3)
    .q:openflag'="1"
    .q:tprs'>0
    .s prewin=nextwin
   i prewin=""  d
     .;本轮次结束
     .;^DHCTodayWinInf(currdate,phl,phw)
     .s tophw=""
     .f  s tophw=$o(^DHCTodayWinInf(+$h,phl,tophw)) q:tophw=""  d
       ..s todf="",toop="",tors=0
       ..s todf=$p(^DHCPHLOCWINOPEN(+$h,phl,tophw),"^",2)
       ..q:todf'=df
       ..s toop=$p(^DHCPHLOCWINOPEN(+$h,phl,tophw),"^",1)
       ..s tors=$p(^DHCPHLOCWINOPEN(+$h,phl,tophw),"^",3)
       ..q:toop'="1"
       ..q:tors'>0
       ..s $p(^DHCTodayWinInf(+$h,phl,tophw),"^",2)=0
      .s yphw="",pphw=""
      .f  s pphw=$o(^DHCTodayWinInf(+$h,phl,pphw)) q:(pphw="")!(yphw'="")  d
       ..s todf="",toop="",tors=0
       ..s todf=$p(^DHCPHLOCWINOPEN(+$h,phl,pphw),"^",2)
       ..q:todf'=df
       ..s toop=$p(^DHCPHLOCWINOPEN(+$h,phl,pphw),"^",1)
       ..s tors=$p(^DHCPHLOCWINOPEN(+$h,phl,pphw),"^",3)
       ..q:toop'="1"
       ..q:tors'>0
       ..s yphw=pphw
      .s prewin=yphw
   s sl=0
   i $d(^DHCTodayWinInf(+$h,phl,prewin)) s sl=$p(^DHCTodayWinInf(+$h,phl,prewin),"^",1)
   s tp=$p(^DHCPHLOCWINOPEN(+$h,phl,prewin),"^",3)
   i sl'<tp  d
     .s $p(^DHCTodayWinInf(+$h,phl,prewin),"^",1)=$p(^DHCTodayWinInf(+$h,phl,prewin),"^",1)-tp
     .s prewin=##CLASS(web.DHCOutPhDisp).GetNextWin(phl,prewin)
     .
  ;w !,prewin 
  q prewin
}

ClassMethod InsertPhdisItmClb(phditm = "", pid, locdr, dspBatchId)
{
      s phdID=$p(phditm,"||",1)
      q:phdID="" -1
      s phlocID=$p(^DHCPHDISP(phdID,1),"^",1)
      q:phlocID="" -2
      s locID=$p(^DHCPHLOC(phlocID),"^",1)
      q:locID="" -3
      s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(locID)
      s HospID=$p(CustStr,"^",5)
      s CustID=$p(CustStr,"^",1)
      s phdSub=$p(phditm,"||",2)
      q:phdSub="" -4
      s orditm=$p(^DHCPHDI(phdID,"PHDI",phdSub),"^",5)
      s MoneyStr=##class(web.DHCOutPhCommon).GetOrdItmMoney(orditm,dspBatchId)
      s sp=$p(MoneyStr,"^",1)
      s newclb="",bb=0,itmclbnum=0
	  f  s newclb=$o(^TMPGETINCLB(pid,newclb)) q:(newclb="")!(itmclbnum'=0)  d
	  .s baseqty=$p(^TMPGETINCLB(pid,newclb),"^",1)
	  .s inclbid=$p(^TMPGETINCLB(pid,newclb),"^",2)
	  .s inci=+inclbid
	  .s buom=$p(^INCI(inci,1),"^",10)
	  .s rp=+##Class(web.DHCSTPRICE).GetCurRp(inclbid,buom,HospID)
	  .s rpamt=rp*baseqty
	  .s spamt=sp*baseqty	//zhouyg 20160216 售价金额与子表计算方法保持一致
	  .s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inci)
      .s StkTypeDesc=$P(CatGrpStr,"^",4)
      .s Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
      .s rpamt=##Class(web.DHCSTCOMMPARA).GetNumbDec(rpamt,Perv,"FmtRA",1)
      .s spamt=##Class(web.DHCSTCOMMPARA).GetNumbDec(spamt,Perv,"FmtSA",1)
      .s bb=$o(^DHCPHDI(phdID,"PHDI",phdSub,"INCLB",""),-1)+1
	  .&sql(insert into SQLUSER.dhc_phdisitmclb(phdic_phdi_parref,phdic_childsub,phdic_basqty,phdic_inclb_dr,PHDIC_Rp,PHDIC_RpAmt,PHDIC_Sp,PHDIC_SpAmt,PHDIC_DSPB_DR)
	       values(:phditm,:bb,:baseqty,:inclbid,:rp,:rpamt,:sp,:spamt,:dspBatchId))
	  .i SQLCODE'=0  d
	  ..s itmclbnum=itmclbnum+1
	  i itmclbnum'=0 q -1
	  i bb=0 q -1
	  q 0
}

/// Descript：	按批次价格保存发药批次表
/// Creater:	zhouyg
/// CreateDate:	2013-08-19
/// Input:		phditm-发药子表ID,pid-进程号
/// Return:		0-成功,其他-失败
/// Others:		hulihua 2018-10-26新医嘱改造修改
ClassMethod InsertPhdisItmClbByBatch(phditm = "", pid, dspBatchId)
{
	s phdID=$p(phditm,"||",1)
	q:phdID="" -1
	s phdSub=$p(phditm,"||",2)
	q:phdSub="" -2
	s phlocID=$p(^DHCPHDISP(phdID,1),"^",1)
	q:phlocID="" -3
	s locID=$p(^DHCPHLOC(phlocID),"^",1)
	q:locID="" -4
	s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(locID)
	s HospID=$p(CustStr,"^",5)
	s CustID=$p(CustStr,"^",1)
	s oeoriID=$p(^DHCPHDI(phdID,"PHDI",phdSub),"^",5)
	s phdprt=$p(^DHCPHDISP(+phdID),"^",2)
	i +phdprt=0 d
	.;先发药后收费的按照批次价格重新更新打包表价格
	.s inclb=$p(^DHCOEDISQTY(+dspBatchId,"I",$p(dspBatchId,"||",2)),"^",1)
	.s sp=+##class(web.DHCSTPRICE).GetSp(inclb,+$h,"",HospID,"","") 
	.s $p(^DHCOEDISQTY(+dspBatchId,"I",$p(dspBatchId,"||",2)),"^",4)=sp
	.s rp=+##Class(web.DHCSTPRICE).GetRp(inclb,+$h,"",HospID,"")
	.s $p(^DHCOEDISQTY(+dspBatchId,"I",$p(dspBatchId,"||",2)),"^",3)=rp 
	e  d
	.;正常门诊都取收费的价格
	.s sp=$p(##class(web.DHCOutPhCommon).GetDspBatPriceByInv(phdprt,dspBatchId),"^",1) 
	;按照有效批次存发药孙表，此处有可能一个打包子表对应多条发药孙表！
	s lbNum="",bb=0,itmclbnum=0
	f  s lbNum=$o(^TMP("DHCST","web.DHCST01","Inclb",pid,lbNum)) q:(lbNum="")!(itmclbnum'=0)  d
	.s inclbstr=^(lbNum)
	.s newclb=$p(inclbstr,"^",4)
	.s baseqty=$p(inclbstr,"^",1)
	.s inci=+newclb
	.s buom=$p(^INCI(inci,1),"^",10)
	.s rp=+##Class(web.DHCSTPRICE).GetCurRp(newclb,buom,HospID) //yunhaibao20160310,进价取当前进价
	.s rpamt=rp*baseqty
	.s spamt=sp*baseqty
	.s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(inci)
	.s StkTypeDesc=$P(CatGrpStr,"^",4)
	.s Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
	.s rpamt=##Class(web.DHCSTCOMMPARA).GetNumbDec(rpamt,Perv,"FmtRA",1)
	.s spamt=##Class(web.DHCSTCOMMPARA).GetNumbDec(spamt,Perv,"FmtSA",1)
	.s bb=$o(^DHCPHDI(phdID,"PHDI",phdSub,"INCLB",""),-1)+1
	.&sql(insert into SQLUSER.dhc_phdisitmclb(phdic_phdi_parref,phdic_childsub,phdic_basqty,phdic_inclb_dr,PHDIC_Rp,PHDIC_RpAmt,PHDIC_Sp,PHDIC_SpAmt,PHDIC_DSPB_DR)
	values(:phditm,:bb,:baseqty,:newclb,:rp,:rpamt,:sp,:spamt,:dspBatchId))
	.i SQLCODE'=0  d
	..s itmclbnum=itmclbnum+1
	i itmclbnum'=0 q -5
	i bb=0 q -6
	q 0
}

/// 处理门诊发药台帐数据
ClassMethod DhcOutStkTab(pointer As %String, intrtype As %String) As %String
{
	;Insert into DHC_Intrans accroding to rowid 
	s phdrow=$p(pointer,"||",1)
	s phdsub=$p(pointer,"||",2) 
	s phdicsub=$p(pointer,"||",3)
	q:'$d(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub)) -22
	s inclb=$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub),"^",3)
    s incqty=+$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub),"^",1)
    s inc=$p(inclb,"||",1)
    s ItmCode=$p(^INCI(inc,1),"^",1)
    s basuom=$p(^INCI(inc,1),"^",10)
    s UomDesc=$p(^CT("UOM",basuom),"^",2 )
    s pointer=phdrow_"||"_phdsub_"||"_phdicsub  
	s phper=+$p(^DHCPHDISP(phdrow,1),"^",2)  
	s user=+$p(^DHCPHPER(phper),"^",5)
	s phl=+$p(^DHCPHDISP(phdrow,1),"^",1)
	s locdr=+$p(^DHCPHLOC(phl),"^",1) 
	s LocDesc=$p(^CTLOC(locdr),"^",2)
	s qty=-incqty 		
	s pmoney=$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",3) 
	s Rp=+$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub),"^",5)
	s Sp=+$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub),"^",7)
	s Data=intrtype_"^"_""_"^"_inclb_"^"_qty_"^"_UomDesc_"^"_ItmCode_"^"_Sp_"^"_user_"^"_pointer_"^"_LocDesc_"^"_Rp
	s Err=##class(web.DHCST01).UPDINCI(Data)
    q:Err=0 -23
	q 1
}

/// Descript:	根据医嘱ID获取医嘱保存的批次进价
/// Creater：	zhouyg
/// CreateDate：	2013-08-19
/// Input：		oeoriID-医嘱ID
/// Return:		医嘱保存的批次进价
ClassMethod GetDspRp(oeoriID)
{
	s dspID=$o(^DHCOEDISQTY(0,"OEORI",oeoriID,""))
	q:dspID="" 0
	s dspbSub=$o(^DHCOEDISQTY(dspID,"I",0))
	q:dspbSub="" 0
	s rp=$p(^DHCOEDISQTY(dspID,"I",dspbSub),"^",3)
	q rp
}

ClassMethod collect(ord, chl)
{
	/*Set Config=##Class(websys.Configuration).%OpenId(1)
        Set MEDDATA=Config.DataNamespace            ;得到当前的MEDTRAK的NameSpace,保存到MEDDATA中
        Set LABDATA=Config.LabDataNamespace         ;得到当前的LABTRAK的NameSpace,保存到LABDATA中
        Set CurrentNS=$ZNSPACE                      ;保存当前所用的NameSpace  
        ZN MEDDATA                                  ;切换到所希望的NameSpace,
        s prsno=$p(^OEORD(ord,"I",chl,1),"^",14)  q:$g(prsno)="" -1
	s que=$o(^PAQUE1(0,"PrescNo",prsno,"")) q:$g(que)="" -1
	s err=$$collect^CHMVBPAQUE(prsno,ord,chl) q:$g(err)'=0 -1
	s err=$$updcoll^CHMVBPAQUE(que) q:$g(err)'=0 -1
         ZN CurrentNS 
	*/
	q 0
}

ClassMethod GInclb(inc As %Library.String = "", newqty As %Library.String = "", ctloc As %Library.String = "")
{
    s clb="0",val=0
    s cil=""
    k ^DHCTMPMZYFXQ($j)
    q:'$d(^INCI("IL_LOC",ctloc,inc))  ;Modify by Cuilp 2007.11.5
    s cil=$o(^INCI("IL_LOC",ctloc,inc,""))
    ;s ^cuilp=inc_" "_newqty_" "_ctloc
    ;q:'$d(^INCI(inc,"IL",cil,"LB"))
    f  s clb=$o(^INCI(inc,"IL",cil,"LB",clb)) q:(clb="")!(newqty=0)!(clb="0")  d
      .s incqty=0,inclb=""
      .s inclb=inc_"||"_cil_"||"_clb
      .s incibrowid=""
      .s incibrowid=$P(^INCI(inc,"IL",cil,"LB",clb),"^",1)
      .s cib=""
      .s cib=$p(incibrowid,"||",2)
      .s xqdate="",xqcyday=0
      .s xqdate=+$p(^INCI(inc,"IB",cib),"^",2)
      .;q:xqdate<+$h
      .i (xqdate=0)!(xqdate="")  d
      ..s xqdate=+$h+500
      .i xqdate=+$h s xqcyday=1
      .e  s xqcyday=xqdate-(+$h)
      .s incqty=##CLASS(web.DHCSTSTKQTY).CurQtyINCLB(inclb) 
      .q:incqty=0
      .q:incqty<0
      .s ^DHCTMPMZYFXQ($j,xqcyday,inclb)=incqty
    s currxq=""
    f  s currxq=$o(^DHCTMPMZYFXQ($j,currxq)) q:(currxq="")!(newqty=0)  d
      .s xqclb=""
      .f  s xqclb=$o(^DHCTMPMZYFXQ($j,currxq,xqclb)) q:(xqclb="")!(newqty=0)  d
      ..s xqclbqty=0
      ..s xqclbqty=$g(^DHCTMPMZYFXQ($j,currxq,xqclb))
      ..i xqclbqty>newqty  d
         ...s $p(^TMPGETCLB($j,xqclb),"^",1)=newqty
	     ...s newqty=0     
	  ..e  d
	     ...s $p(^TMPGETCLB($j,xqclb),"^",1)=xqclbqty                                         
	     ...s newqty=newqty-xqclbqty
 q
}

ClassMethod GPatICDItm(itmjs As %Library.String = "", itmjsex As %Library.String = "", t As %Library.String = "")
{
 s ret=""
  s ret=^TMPICD($j,t) 
  s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
  i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
  &javascript<#(retval)#>
   q 1
}

ClassMethod InsRePrint(itmjs As %Library.String = "", itmjsex As %Library.String = "", prt As %Library.String = "", php As %Library.String = "", phl As %Library.String = "", prescno As %Library.String = "")
{
	 s cudate="",cutime=""
	 s cudate=$p($h,",",1),cutime=$p($h,",",2)
	 s phd="",gphd=""
	
	 f  s phd=$o(^DHCPHDISPi("PRESCNO",prescno,phd)) q:phd=""  d   //zzd 忽视发票
	  .s phdprescno=""
	  .s phdprescno=$p(^DHCPHDISP(phd,2),"^",1)
	  .q:phdprescno'=prescno
	  .s gphd=phd
	  
	 &sql(insert into sqluser.DHC_PHDREPRINT(phdr_date,phdr_time,phdr_php_dr,phdr_pointer,phdr_type)
	       values(:cudate,:cutime,:php,:gphd,'2'))
   s retval=itmjs_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
  i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
  &javascript<#(retval)#>
   q 1
}

ClassMethod GPatICD(itmjs As %Library.String = "", itmjsex As %Library.String = "", prt As %Library.String = "")
{
    k ^TMPICD($j)
        s m=0
	        s sysdate="",difdate=""
	        s sysdate=+$h
	        s PP=""
	        s prtsub="0",t=0,oeord="",papmi="",prtdate="",prtinv=""
	        s papmi=+$p(^DHCINVPRT(prt),"^",15)
	        s prtdate=+$p(^DHCINVPRT(prt),"^",5)
	        s prtdate=$zd(prtdate,3)
	        s prtinv=+$p(^DHCINVPRT(prt),"^",14)
	        s papname="",papsexdr="",papsex="",birthday=""
	        s papname=$p(^PAPER(papmi,"ALL"),"^",1)
	        s papsexdr=+$p(^PAPER(papmi,"ALL"),"^",7)
	        s birthday=+$p(^PAPER(papmi,"ALL"),"^",6)
	        s difdate=sysdate-birthday+1
	        s birthday=$zd(birthday,3)
	        i papsexdr'="" s papsex=$p(^CT("SEX",papsexdr),"^",2)
	        f  s prtsub=$o(^PRTS(prt,prtsub)) q:(t=1)!(prtsub="0")!(prtsub="")  d
	          .s oeori=""
	          .s oeori=$p(^PRTS(prt,prtsub),"^",5)
	          .s oeord=$p(oeori,"||",1)
	          .s t=t+1
	        i oeord="" q 0
	        s adm="",mradm="",pertype="",pertypedr=""
	        s adm=+$p(^OEORD(oeord),"^",1)
	        s mradm=+$p(^PAADM(adm),"^",61)
	        s mrdia="0"
	        f  s mrdia=$o(^MR(mradm,"DIA",mrdia)) q:(mrdia="")!(mrdia="0")  d
	          .s diadesc="",icdcode="",diatype=0,diatypecode="",desc=""
	          .&sql(select mrdia_desc into :desc from SQLUSER.MR_Diagnos where mrdia_mradm_parref=:mradm and mrdia_childsub=:mrdia)
	          .;s diadesc=$g(^MR(mradm,"DIA",mrdia,"DES"))
	          .s icdcode=+$p(^MR(mradm,"DIA",mrdia),"^",1)
	          .s diatype=$o(^MR(mradm,"DIA",mrdia,"TYP",diatype))
	          .s diatypecode=$p(^MRC("DTYP",diatype),"^",1)
	          .q:diatypecode'="DIS"
	          .i diadesc="" s diadesc=$p(^MRC("ID",icdcode),"^",2)
	          .i diadesc["-" s diadesc=$p(diadesc,"-",2)
	          .s m=m+1
	          .i desc'="" s ^TMPICD($j,m)=diadesc_"^"_desc(1)
	          .e  s ^TMPICD($j,m)=diadesc_"^"_""
	       s retval=itmjs_"('"_$ZCVT(m,"O","JS")_"');"
           i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(m,"O","JS")_"');"
           &javascript<#(retval)#>
          q 1
}

ClassMethod GPatIcdInf(itmjs As %Library.String = "", itmjsex As %Library.String = "", prt As %Library.String = "")
{
        s m=0
	        s sysdate="",difdate=""
	        s sysdate=+$h
	        s ret=""
	        s prtsub="0",t=0,oeord="",papmi="",prtdate="",prtinv=""
	        s papmi=+$p(^DHCINVPRT(prt),"^",15)
	        s prtdate=+$p(^DHCINVPRT(prt),"^",5)
	        s prtdate=$zd(prtdate,4)
	        s prtinv=+$p(^DHCINVPRT(prt),"^",14)
	        s papname="",papsexdr="",papsex="",birthday=""
	        s papname=$p(^PAPER(papmi,"ALL"),"^",1)
	        s papsexdr=+$p(^PAPER(papmi,"ALL"),"^",7)
	        s birthday=+$p(^PAPER(papmi,"ALL"),"^",6)
	        s difdate=sysdate-birthday+1
	        s difday=0
	        s difday=sysdate-birthday
	        i difday>=365  s age=$p(difday/365,".",1),age=age_"岁"
	        e  s age=difday_"天"
	        i birthday=0  s age=""
	        i papsexdr'="" s papsex=$p(^CT("SEX",papsexdr),"^",2)
	        f  s prtsub=$o(^PRTS(prt,prtsub)) q:(t=1)!(prtsub="0")!(prtsub="")  d
	          .s oeori=""
	          .s oeori=$p(^PRTS(prt,prtsub),"^",5)
	          .s oeord=$p(oeori,"||",1)
	          .s t=t+1
	        i oeord="" q 0
	        s adm="",mradm="",pertype="",pertypedr=""
	        s adm=+$p(^OEORD(oeord),"^",1)
	        s papmi=""
	        s papmi=+$p(^PAADM(adm),"^",1)
	        i $d(^PAPER(papmi,"PER",1)) d
	          .s pertypedr=+$p(^PAPER(papmi,"PER",1),"^",10)
	          .i pertypedr="" s pertype="自费"
	          .e  s pertype=$p(^CT("SS",pertypedr),"^",2)
	          .i pertype["自"  s pertype="自费"
	          .i pertype["医"  s pertype="医保"
	        e  s pertype="自费"
	        s ctlocdr="",ctloc=""
	        s ctlocdr=+$p(^PAADM(adm),"^",4)
	        s ctloc=$p(^CTLOC(ctlocdr),"^",2)
	        i ctloc["-" s ctloc=$p(ctloc,"-",2)
	        s mradm=+$p(^PAADM(adm),"^",61)
	        s weight=""
	        s weight=$p(^MR(mradm,"PRO",1),"^",27)
	        i weight="0" s weight=""
	        s ret=ctloc_"^"_papname_"^"_papsex_"^"_age_"^"_pertype_"^"_weight
	       s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
           i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
           &javascript<#(retval)#>
          q 1
}

ClassMethod GetDSPRowid(presc, prt)
{
  s argphd="",retdsp=""
  f  s argphd=$o(^DHCPHDISPi("PRESCNO",presc,argphd)) q:argphd=""  d
    .s argprt=""
    .s argprt=+$p(^DHCPHDISP(argphd),"^",2)
    .q:argprt'=prt
    .s retdsp=argphd
  q retdsp
}

ClassMethod InsertPHDispOld(prt As %Library.String = "", phl As %Library.String = "", phw As %Library.String = "", pydr As %Library.String = "", fydr As %Library.String = "", prescno As %Library.String = "", phwpos As %Library.String = "")
{
	s sysdate="",systime=""
	s sysdate=$p($h,",",1)
	s systime=$p($h,",",2)
	s ctlocdr="" 
	s ctlocdr=+$p(^DHCPHLOC(phl),"^",1)
	s insertpresc=""
	s insertpresc=##class(web.DHCOutPhDisp).GetDSPRowid(prescno,prt)
	i insertpresc'="" q 0
    s locdr=$p(^DHCPHLOC(phl),"^",1)
	s leadlocdr=..GetLeadLoc(locdr)
	s mainphl=$o(^DHCPHLOCi("LOC",leadlocdr,""))  //主科室
	s papmidr=""
	i prt'="" s papmidr=$p(^DHCINVPRT(prt),"^",15)
	s pha="",phause="",phaok=""
	f  s pha=$o(^DHCPHARi("PRT",prt,pha)) q:pha=""  d
	   .s fphldr=""
	   .
	   .s fphldr=+$p(^DHCPHARW(pha),"^",3)
	   .;q:fphldr'=phl  //lq
	   .q:fphldr'=mainphl
	   .s phaprescno=""
	   .s phaprescno=$p(^DHCPHARW(pha),"^",16)
	   .q:phaprescno'=prescno
	   .s phause=$p(^DHCPHARW(pha),"^",7)
	   .s phaok=$p(^DHCPHARW(pha),"^",6)
	   .
    i phause="1" q -1
    i phaok="1" q -2
   
    TSTART
	&sql(insert into SQLUSER.dhc_phdispen(phd_prtdate,phd_prt_dr,phd_papmi_dr,phd_php_pydr,phd_php_fydr,phd_phl_dr,phd_phw_dr,phd_pydate,phd_fydate,phd_pytime,phd_prescno,phd_pattype,phd_fytime)
    values(:prtdate,:prt,:papmidr,:pydr,:fydr,:phl,:phw,:sysdate,:sysdate,:systime,:prescno,:phwpos,:systime))
	i SQLCODE TRo
	i SQLCODE q 200
	s phdrow=""
	s phdrow=+$g(%ROWID)
	s insubsuess=0
	s subsaveflag=0
	s phaid=""
	s b="33334"
	f  s phaid=$o(^DHCPHARi("PRT",prt,phaid)) q:(phaid="")!(insubsuess'=0)  d
	   .s phldr="",phwdr=""
	   .s phldr=+$p(^DHCPHARW(phaid),"^",3)
	   .;q:phldr'=phl
	   .s b=phldr_"^"_phl
	   .s locdr=$p(^DHCPHLOC(phl),"^",1)
	   .s leadlocdr=..GetLeadLoc(locdr)
	   .s mainphl=$o(^DHCPHLOCi("LOC",leadlocdr,""))  //主科室
	   .q:phldr'=..GetLeadLoc(mainphl) //lq
	   .s phwdr=+$p(^DHCPHARW(phaid),"^",4)
	   .;q:phwdr'=phw
	   .s b="4444444"
	   .s phaprescno=""
	   .s phaprescno=$p(^DHCPHARW(phaid),"^",16)
	   .q:phaprescno'=prescno
	   .s $p(^DHCPHARW(phaid),"^",8)="1"
	   .s $p(^DHCPHARW(phaid),"^",11)=sysdate
	   .s bci="0"
	   .f  s bci=$o(^DHCBCI(0,"INV",prt,bci)) q:(bci="")!(bci="0")!(insubsuess'=0)  d
	     ..s patbill=""
	     ..s patbill=+$p(^DHCBCI(bci),"^",2)
	     ..s patbillsub="0"
	     ..s m=0
	     ..f  s patbillsub=$o(^DHCPB(patbill,"O",patbillsub)) q:(patbillsub="")!(patbillsub="0")!(insubsuess'=0)  d
	        ...s orditm="",ord="",itm="",dispflag="",invprescno=""
	        ...s orditm=$p(^DHCPB(patbill,"O",patbillsub),"^",4)
	        ...s ord=$p(orditm,"||",1),itm=$p(orditm,"||",2)
	        ...s recplocdr=""
	        ...s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	        ...s b="5555555"
	        ...q:recplocdr=""
	        ...;q:recplocdr'=ctlocdr 
	        ...q:recplocdr'=$p(^DHCPHLOC(phldr),"^",1)
	        ...;s ctlocdr=$p(^DHCPHLOC(phldr),"^",1)
	        ...s dispflag=$p($g(^OEORD(ord,"I",itm,6)),"^",7)
	        ...s invprescno=$p(^OEORD(ord,"I",itm,1),"^",14)
	        ...q:invprescno=""
	        ...q:invprescno'=prescno
	        ...s qty=0,money=0
	        ...s qty=+$p(^DHCPB(patbill,"O",patbillsub),"^",5)
	        ...s money=+$p(^DHCPB(patbill,"O",patbillsub),"^",8)
	        ...;q:(dispflag="1")
	        ...s m=m+1
	  	    ...&sql(insert into SQLUSER.DHC_PHDISITEM(phdi_phd_parref,phdi_childsub,phdi_qty,phdi_payamount,phdi_oeori_dr) 
	             values(:phdrow,:m,:qty,:money,:orditm))
	        ...i SQLCODE'=0 s insubsuess=insubsuess+1
	        ...i SQLCODE'=0 TRo
	        ...i SQLCODE=0 s subsaveflag=subsaveflag+1
	 i insubsuess'=0 q -1
	 i subsaveflag=0 TRo //
	 i subsaveflag=0 q -1   //lq

     q SQLCODE
}

ClassMethod InsertPHDisp(prt As %Library.String = "", phl As %Library.String = "", phw As %Library.String = "", pydr As %Library.String = "", fydr As %Library.String = "", prescno As %Library.String = "", phwpos As %Library.String = "")
{
	
	s sysdate="",systime=""
	s sysdate=$p($h,",",1)
	s systime=$p($h,",",2)
	s ctlocdr="" 
	s oldphl=phl
	s ctlocdr=+$p(^DHCPHLOC(phl),"^",1)
    s phlocdr=$p(^DHCPHLOC(phl),"^",1)
	s leadlocdr=..GetLeadLoc(phlocdr)
	s mainphl=$o(^DHCPHLOCi("LOC",leadlocdr,""))  //主科室
	s reclocdr=leadlocdr
	s phl=mainphl
	s papmidr=##class(web.DHCOutPhCommon).GetPapmiByPresc(prescno)
	s prt=""   //2018.03.26  zzd  忽视发票  
	;
	
		//wyx 增加loclog取自登录科室session里的科室
	s loclog=%session.Data("LOGON.CTLOCID")
	
	l +^DHCOEDISPENSING(prescno):5  e  q -5   ;加锁
    
 	
 	s chkerr=..CheckNotUseNew(prescno,phl)	 //2018.03.26  zzd  忽视发票 
        i chkerr=1    d unlock
	q:chkerr=1 -1
	s chkerr=..CheckBeforUpdate(prescno,phl)
        i chkerr=1    d unlock
	q:chkerr=1 -3
	s chkerr=##class(web.DHCOutPhCommon).GetOrdXState(prescno,phl)
    //    i chkerr=1    d unlock
	//q:chkerr=1 -4
	s chkerr=..CheckBeforInsertNew(prescno,oldphl,0)   //2018.03.26  zzd  忽视发票  
        i chkerr=1    d unlock
	q:chkerr=1 0
	
		
	Tstart
	Set $ZT="troll"

    //  
    s pyflag=1,prtflag=1
	&sql(insert into SQLUSER.dhc_phdispen(phd_prtdate,phd_prt_dr,phd_papmi_dr,phd_php_pydr,phd_phl_dr,phd_phw_dr,phd_pydate,
	phd_pytime,phd_prescno,phd_pattype,PHD_PYFLAG,PHD_PRINTFLAG)
    values(:prtdate,:prt,:papmidr,:pydr,:oldphl,:phw,:sysdate,:systime,:prescno,:phwpos,:pyflag,:prtflag))
    
	i SQLCODE TRo
	i SQLCODE d unlock
	i SQLCODE q -6
	s phdrow=""
	s phdrow=+$g(%ROWID)
	s oeordqtystr=..GetOrdQtyStr(prescno)
	s subsaveflag=0
	s m=0
	s ord=""
    f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:(ord="")!(subsaveflag'=0)  d
    .s itm=""
    .f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:(itm="")!(subsaveflag'=0)  d
    ..s oeori=ord_"||"_itm
    ..s OEPrescNo=$p(^OEORD(ord,"I",itm,1),"^",14)
    ..q:prescno'=OEPrescNo
    ..//q:##class(web.DHCSTInterfaceFromElse).ICheckOrderIsRefundAudit(oeori)="Y" //已做退费申请
    ..//add wyx 2015-02-28 急诊留观病人增加欠费控制
    ..s EmLGflag=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",17)
    ..s patadm=##class(web.DHCOutPhDisp).getadm(prescno)
    ..i EmLGflag=1 s AmtRet=##class(web.DHCSTPCHCOLLS2).CheckArrearsNew("",patadm,oeordqtystr,loclog)
    ..e  s AmtRet="Y"
    ..i (EmLGflag="1")&(AmtRet="N") s subsaveflag=100
    ..q:subsaveflag'=0
    ..//add wyx 2015-02-28 急诊留观病人增加欠费控制
    ..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)                                    
    ..s BillFlag=$p(^OEORD(ord,"I",itm,3),"^",5) 
    ..q:(BillFlag'="P")&(oeflag'="V")&(oeflag'="E")	//2018.03.26  zzd  忽视发票  替换上一方法
    ..s priority=$p(^OEORD(ord,"I",itm,1),"^",8)    
	..s priordesc=""
	..i priority'="" s priordesc=$p(^OECPR(priority),"^",2)
	..q:priordesc["自备"
	..s tmpreclocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
    ..q:reclocdr'=tmpreclocdr
    ..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
    ..s nouseitm=""
    ..i prt'="" d
    ...s ordpriceinfo=##class(web.DHCOutPhCommon).GetBasPriceByInv(prt,oeori)
	...s paidFlag=$p(ordpriceinfo,"^",3)
	...i paidFlag=0 s nouseitm=0	//20160216改为判断是否有账单记录
	..q:$g(nouseitm)=0  //过滤发票中没有的项目
    ..s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,"")) // 医嘱改造
    ..k ExistInclb
    ..s dspSub=""
    ..f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:(dspSub="")!(subsaveflag'=0)  d
    ...q:+dspSub=0
    ...s qty=0,money=0
	...s dspInci=$p(^DHCOEDISQTY(dspId,"I",dspSub),"^",5) 
	...s dspInclb=$p(^DHCOEDISQTY(dspId,"I",dspSub),"^",1) 
	...q:(dspInclb'="")&&($d(ExistInclb(+dspInclb))) // 批次价一个批次只取一次
	...s ExistInclb(+dspInclb)=""
	...s qty=$p(^DHCOEDISQTY(dspId,"I",dspSub),"^",2)
	...i dspInclb'="" s qty=##class(web.DHCSTCOMMONSRV).GetDspInciQtyByDsp(dspId,dspInclb,3)
	...s inci=dspInci
	...s ch=$o(^INCI("IL_LOC",phlocdr,inci,""))
	...i ch="" s subsaveflag=10
	...q:subsaveflag'=0
    ...s incil=inci_"||"_ch
    ...s inciQty=##class(web.DHCSTSTKQTY).GetPhaQty(incil,qty)
    ...i inciQty=0 TRo
    ...i inciQty=0 s subsaveflag=10
    ...q:inciQty=0
    ..q:subsaveflag'=0
	..s m=m+1
	..&sql(insert into SQLUSER.DHC_PHDISITEM(phdi_phd_parref,phdi_childsub,phdi_oeori_dr)values(:phdrow,:m,:oeori))
	..i SQLCODE'=0 TRo
	..i SQLCODE'=0 s subsaveflag=1
	..q:SQLCODE'=0
	.
	i subsaveflag'=0 d unlock
	q:subsaveflag=10 -7
	q:subsaveflag=100 -9
	q:subsaveflag'=0 -8

	s phaid="",updateflag=0
	f  s phaid=$o(^DHCPHARi("PRESCNO",prescno,phaid)) q:(phaid="")||(updateflag'=0)  d      //2018.03.26  zzd  忽视发票 替换上一行
    .s phaprescno=""
    .s phaprescno=$p(^DHCPHARW(phaid),"^",16)
    .q:phaprescno'=prescno
    .s phaphl=$p(^DHCPHARW(phaid),"^",3)
    .q:phaphl'=phl
    .s ret=..UpdPyPharwin(phaid,prescno)   
    .s updateflag=ret
    i updateflag'=0 d unlock
    i updateflag'=0 tro
    q:updateflag'=0 updateflag   
    TCOMMIT
	d unlock 
	q 0

unlock
   l -^DHCOEDISPENSING(prescno)
   q
   
troll
   Set $ZT=""
   TRo
   l -^DHCOEDISPENSING(prescno)
   s ErrorMsg=$ZE
   q ErrorMsg
}

ClassMethod GetPhWinCom(ctloc)
{
	s loc="",ret=""
	s php=""
	s phpdr=""
	s phl="",phw="0",byfs=""
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl="" q ret
	s byfs=$p(^DHCPHLOC(phl),"^",5)
	i byfs'="1" d
	  .f  s phw=$o(^DHCPHWINi("WIN",phl,phw)) q:(phw="0")!(phw="")  d
	     ..s okflag="",useflag=""
	     ..s okflag=$p(^DHCPHWIN(phw),"^",3)
	     ..q:okflag'="1"
	     ..s useflag=$p(^DHCPHWIN(phw),"^",4)
	     ..q:useflag="1"
	     ..s phwdesc=$p(^DHCPHWIN(phw),"^",1)
	     ..s val=""
	     ..s val=phw_"*"_phl
	     ..i ret'=""  d
	     ...s ret=ret_"^"_val_$c(1)_phwdesc
	     ..e  s ret=val_$c(1)_phwdesc
 e  d
 .f  s phw=$o(^DHCPHWINi("WIN",phl,phw)) q:(phw="")!(phw="0")  d
	    ..s phwp="",useflag=""
	    ..s phwp=$o(^DHCPHWPi("WINDOW",phl,phw,""))
	    ..s phwdesc="",doflag=""
	    ..;q:phwp=""
	    ..;s doflag=$p(^DHCPHWP(phwp),"^",1)
	    ..;q:doflag="1" 
	    ..s useflag=$p(^DHCPHWIN(phw),"^",4)
	    ..q:useflag="1"
	    ..s phwdesc=$p(^DHCPHWIN(phw),"^",1)
	    ..s val=""
	    ..s val=phw_"*"_phl
	    ..i ret'=""  d
	     ...s ret=ret_"^"_val_$c(1)_phwdesc
	    ..e  s ret=val_$c(1)_phwdesc

 q ret
}

ClassMethod GetPyUserCom(ctloc, userid)
{
	s ret=""
	s loc=""
	s phl=""
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl="" q ""
	s php="",getphp=""
	f  s php=$o(^DHCPHPERi("USR",userid,php)) q:php=""  d
	  .s phyp=""
	  .s phyp=+$p(^DHCPHPER(php),"^",3)
	  .q:phyp'=phl
	  .s getphp=php
	i getphp="" q ""
	s phlp=""
	f  s phlp=$o(^DHCPHPER(phlp)) q:phlp=""  d
	  .s phwl="",phwdesc=""
	  .s phwl=+$p(^DHCPHPER(phlp),"^",3)
	  .q:phwl'=phl
	  .s use=""
	  .s use=$p(^DHCPHPER(phlp),"^",9)
	  .q:use="1"
	  .s phwdesc=$p(^DHCPHPER(phlp),"^",2)
	  .s val=""
	  .s val=getphp_"*"_phlp
	  .i ret'=""  d
	   ..s ret=ret_"^"_val_$c(1)_phwdesc
	  .e  s ret=val_$c(1)_phwdesc
 	q ret
}

ClassMethod UpdatePhWin(itmjs As %Library.String = "", itmjsex As %Library.String = "", ctloc As %Library.String = "", pyusr As %Library.String = "", phw As %Library.String = "", fydr As %Library.String = "")
{
   s msg=""	
   i $d(^RetDispGlob($j,+$h)) s msg="1"
   k ^RetDispGlob($j)
   s phl="",ret="",sysdate=""
   s sysdate=$zd(+$h,4)
   s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
   s locdesc=$p(^CTLOC(ctloc),"^",2)
   i locdesc["-" s locdesc=$p(locdesc,"-",2)
   s pydr="",pyname=""
   s pydr=$o(^DHCPHPERi("USR",pyusr,""))
   i (phl="")!(pydr="") s ret="" 
   e  d 
     .s count=0
     .s phwp=""
     .f  s phwp=$o(^DHCPHWP(phwp)) q:phwp=""  d
       ..s phwpwin=""
       ..s phwpwin=+$p(^DHCPHWP(phwp),"^",5)
       ..q:phwpwin'=phw
       ..s count=count+1
     .i count=0 d
        ..&sql(insert into sqluser.dhc_phwper(phwp_phl_dr,phwp_doflag,phwp_phw_dr,phwp_php_pydr,phwp_php_fydr)
          values(:phl,'1',:phw,:pydr,:fydr))
     .e  d
        ..//&sql(update sqluser.dhc_phwper set phwp_doflag='1'  where phwp_phl_dr=:phl and phwp_phw_dr=:phw) //注释 bianshuai 2015-12-11 窗口状态不自动设置
     .s pyname=$p(^DHCPHPER(pydr),"^",2)
     .s fyname="",phwdesc=""
     .s phwdesc=$p(^DHCPHWIN(phw),"^",1)
     .s fyname=$p(^DHCPHPER(fydr),"^",2)
     .s ret=locdesc_"^"_phl_"^"_phwdesc_"^"_phw_"^"_pyname_"^"_pydr_"^"_fyname_"^"_fydr_"^"_msg
                 
 s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod QueryLocPatClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocPatExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// ##class(%Library.ResultSet).%New("web.DHCOutPhDisp","QueryLocOutPat")
ClassMethod QueryLocPatExecute(ByRef QHandle As %Binary, CDateSt As %Library.String = "", CDateEnd As %Library.String = "", GPhl As %Library.String = "", GPhw As %Library.String = "", CPmiNo As %Library.String = "", CPatName As %Library.String = "", GPydr As %Library.String = "", GFydr As %Library.String = "", GPhwPos As %Library.String = "", Fin As %Library.String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	s phl=""
    s phl=GPhl
	i (phl="")!(CPmiNo="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s stdate=CDateSt
	s enddate=CDateEnd
	s cyflag="",dfflag="" 
	s locdr=$p(^DHCPHLOC(phl),"^",1)
	s leadlocdr=..GetLeadLoc(locdr)
	s mainphl=$o(^DHCPHLOCi("LOC",leadlocdr,""))  //主科室
	s cyflag=$p(^DHCPHLOC(phl),"^",6)
	s yflocdr=+$p(^DHCPHLOC(phl),"^",1)
	s fpflag=""
	
	i $d(^GLobDHCPHLOC(phl)) d 
      .s fpflag=$p(^GLobDHCPHLOC(phl),"^",4)
	i (cyflag="1")&(fpflag="1") d
		  .s dfflag=##class(web.DHCOutPhDisp).GetDFFlag(stdate,enddate,phl,CPmiNo) 
	
	s phadate=0
	s phl=mainphl
	f phadate=stdate:1:enddate  d
	  .;f  s phadate=$o(^DHCPHARWi(phadate)) q:(phadate="")  d
	  .;q:phadate<stdate
	  .;q:phadate>enddate
	  .s pha=0
	  .f  s pha=$o(^DHCPHARWi(phadate,phl,pha)) q:pha=""  d
        ..s phwdesc="",phw="",finflag="",nouse="",printflag="",arrcpdr="",prt="",prescno=""
	    ..s phw=+$p(^DHCPHARW(pha),"^",4)
	    ..i (cyflag="1")&(fpflag="1")  d
	       ...i $d(^DHCTMPSUMPRESC(phl,CPmiNo,+$h))  d
	       ....s phw=$p(^DHCTMPSUMPRESC(phl,CPmiNo,+$h),"^",3)
	       ...e  d
	         ....i dfflag="1"  d
	         .....s phw=##class(web.DHCOutPhDisp).GetCurrWin(phl,"D")
	         ....e  s phw=##class(web.DHCOutPhDisp).GetCurrWin(phl,"X")
	    ..;q:phw'=GPhw
	    ..s phwdesc=$p(^DHCPHWIN(phw),"^",1)
	    ..s finflag=$p(^DHCPHARW(pha),"^",6)
	    ..
	    ..q:(finflag="1")&(Fin'="1")
	    ..q:(finflag'="1")&(Fin="1")
	    ..//i finflag="1" s $p(^DHCPHARW(pha),"^",6)=""
	    ..i finflag="1" s finflag="OK"
	    ..e  s finflag=""
	    ..s nouse=$p(^DHCPHARW(pha),"^",7)
	    ..q:nouse="1"
	    ..
	    ..s printflag=$p(^DHCPHARW(pha),"^",8)
	    ..i printflag'="1" s printflag=""
	    ..e  s printflag="OK"
	    ..s prt=+$p(^DHCPHARW(pha),"^",1)
	    ..s prescno=$p(^DHCPHARW(pha),"^",16)
	    ..s arraldr=""
	    ..s papmidr="",papmino="",payamount0=0,phatime=""
	    ..q:'$d(^DHCINVPRT(prt))
	    ..s prtdate=""
	    ..s prtdate=$zd(phadate,3)
	    ..s phatime=+$p(^DHCINVPRT(prt),"^",20)
	    ..s phatime=$zt(phatime,3)
	    ..s papmidr=$p(^DHCINVPRT(prt),"^",15)
	    ..q:papmidr=""
	    ..s prtcode=$p(^DHCINVPRT(prt),"^",14)
	    ..
	    ..s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	    ..q:(papmino'=CPmiNo)&(CPmiNo'="")
	    ..s patienname=""
	    ..s papsexdr="",papsex="",birthday="",difdate="",perold="",patage=""
	    ..s papsexdr=+$p(^PAPER(papmidr,"ALL"),"^",7)
	    ..s birthday=+$p(^PAPER(papmidr,"ALL"),"^",6)
	    ..s perold=##class(web.DHCOutPhTQDisp).GetPatientAgeDesc(papmidr)
 	    ..i papsexdr'="" s papsex=$p(^CT("SEX",papsexdr),"^",2)
	    ..s patid=""
	    ..s patienname=$p(^PAPER(papmidr,"ALL"),"^",1)
	    ..s patid=$p(^PAPER(papmidr,"ALL"),"^",9)
	    ..q:(patienname'=CPatName)&(CPatName'="")
	    ..s m=0,p=0,error=""
	    ..s pp=0,pmoney=0,pret="",pfact=""
	    ..s pp=##class(web.DHCOutPhDisp).GPerOrd(phl,prt,prescno)
	    ..
	    ..s mricd="",patadm="",retval=""
	    ..s presctype="",ptype="",jrflag=""
	    ..s ptype=..CheckPydType(phl,prt,prescno)
	    ..s presctype=$p(ptype,"^",1)
	    ..s jrflag=$p(ptype,"^",2)
	    ..s retval=##class(web.DHCOutPhDisp).GPerIcd(phl,prt,prescno)
	    ..s mricd=$p(retval,"&",1)
	    ..s patadm=##class(web.DHCOutPhDisp).getadm(prescno)
	    ..s patorditem="",patord="",patitm="",patcosdesc="",patcos=""
	    ..s patorditem=##class(web.DHCOutPhDisp).GetPatOrditm(phl,prt,prescno)
	    ..q:patorditem="" //部分退费后为空
	    ..s patord=$p(patorditem,"||",1)
	    ..s patitm=$p(patorditem,"||",2)
	    ..
	    ..s patcos=+$p(^OEORD(patord,"I",patitm,3),"^",10)
	    ..i patcos'=0 d
	      ...s patcosdesc=$p(^ARCOS(patcos),"^",2)
	    ..s patloc="",patlocdesc=""
	    ..s patloc=+$p(^PAADM(patadm),"^",4)
	    ..s patlocdesc=$p(^CTLOC(patloc),"^",2)
	    ..i patlocdesc["-" s patlocdesc=$p(patlocdesc,"-",2)
	    ..i pp["&"  d  
	     ...s pret=$p(pp,"&",1)
	     ...s pfact=$p(pp,"&",3)
	     ...i pret["^" s unflag="1",pmoney=$p(pret,"^",1)
	     ...e  s pmoney=pret
	    ..e  d
	    ...i pp["^" s unflag="1",pmoney=$p(pp,"^",1)
	    ...e  s pmoney=pp
	    ..;q:pmoney=0
	    ..
	    ..s querow="",jytype=""
	    ..s querow=$O(^PAQUE1(0,"PrescNo",prescno,""))
	    ..i querow'=""  d
	     ...i $d(^PAQUE1(querow,"DHC")) s jytype=$p(^PAQUE1(querow,"DHC"),"^",15)
	    ..i jytype["代"  s jytype="代煎"

	    ..s pattype="",patstatudr="",tel="",patadd=""
        ..s patstatudr=+$p(^PAPER(papmidr,"PER",1),"^",10)
        ..s tel=+$p(^PAPER(papmidr,"PER",1),"^",11)   //add by xuyj
        ..i patstatudr'=0 s pattype=$p(^CT("SS",patstatudr),"^",2)
        ..i pattype["(" s pattype=$p(pattype,"(",1)
        ..s patadd=$p($g(^PAPER(papmidr,"NOK")),"^",7)
        ..s presctitle=""
	    ..s presctitle=##class(web.DHCOutPhTQDisp).GetPrescTitle(prescno)
	    ..s pmoney=$fn(pmoney,"",2)
	    ..set Data=$lb(patienname,papmino,prtdate,printflag,finflag,prtcode,phatime,prt,prescno,pmoney,pfact,phwdesc,mricd,patadm,presctype,papsex,perold,patid,patlocdesc,patcosdesc,jytype,tel,patadd,presctitle)
 	    ..Set ^CacheTemp(repid,ind)=Data	
 	    ..Set ind=ind+1
 	i (ind>2)&(cyflag="1")&(fpflag="1")  d
 	  .I '$d(^DHCTMPSUMPRESC(phl,CPmiNo,+$h))  d
 	    ..s $P(^DHCTMPSUMPRESC(phl,CPmiNo,+$h),"^",1)=ind-1
 	    ..s $P(^DHCTMPSUMPRESC(phl,CPmiNo,+$h),"^",2)=ind-1
 	    ..s $P(^DHCTMPSUMPRESC(phl,CPmiNo,+$h),"^",3)=phw
 	  .e  i $P(^DHCTMPSUMPRESC(phl,CPmiNo,+$h),"^",2)=0  d
 	    ..s $P(^DHCTMPSUMPRESC(phl,CPmiNo,+$h),"^",1)=ind-1
 	    ..s $P(^DHCTMPSUMPRESC(phl,CPmiNo,+$h),"^",2)=ind-1
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryLocPatFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocPatExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryLocPat(CDateSt As %String, CDateEnd As %String, GPhl As %String, GPhw As %String, CPmiNo As %String, CPatName As %String, GPydr As %String, GFydr As %String, GPhwPos As %String, Fin As %String) As %Query(ROWSPEC = "TPatName:%String,TPmiNo:%String,TPrtDate:%String,TPrintFlag:%String,TFyFlag:%String,TPrtInv:%String,TPrtTime:%String,TPrt:%String,TPrescNo:%String,TPrescMoney:%String,TJS:%String,TWinDesc:%String,TMR:%String,TAdm:%String,TPrescType:%String,TPatSex:%String,TPatAge:%String,TPatID:%String,TPatLoc:%String,TOrdGroup:%String,TJYType:%String,TCallCode:%String,TPatAdd:%String,TPrescTitle:%String")
{
}

ClassMethod GetDFFlag(st, end, phl, CPmiNo)
{
 s t=0,df=""
	s phadate=0
	f phadate=st:1:end  d
	  .s pha=0
	  .f  s pha=$o(^DHCPHARWi(phadate,phl,pha)) q:pha=""  d
        ..s phw="",finflag="",nouse="",printflag="",arrcpdr="",prt="",prescno=""
	    ..s phw=+$p(^DHCPHARW(pha),"^",4)
	    ..;q:phw'=GPhw
	    ..s finflag=$p(^DHCPHARW(pha),"^",6)
	    ..;i finflag'="1" s finflag=""
	    ..q:(finflag="1")
	    ..s nouse=$p(^DHCPHARW(pha),"^",7)
	    ..q:nouse="1"
	    ..s prt=+$p(^DHCPHARW(pha),"^",1)
	    ..s prescno=$p(^DHCPHARW(pha),"^",16)
	    ..s arraldr=""
	    ..s papmidr="",papmino="",payamount0=0,phatime=""
	    ..q:'$d(^DHCINVPRT(prt))
	    ..s papmidr=$p(^DHCINVPRT(prt),"^",15)
	    ..q:papmidr=""
	    ..s prtcode=""
	    ..s prtcode=$p(^DHCINVPRT(prt),"^",14)
	    ..s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	    ..q:(papmino'=CPmiNo)&(CPmiNo'="")
	    ..s m=0,p=0,error=""
	    ..s pp=0,pmoney=0,pret="",pfact=""
	    ..s pp=##class(web.DHCOutPhDisp).GPerOrd(phl,prt,prescno)
	    ..i pp["&"  d  
	     ...s pret=$p(pp,"&",1)
	     ...s pfact=$p(pp,"&",2)
	     ...i pret["^" s unflag="1",pmoney=$p(pret,"^",1)
	     ...e  s pmoney=pret
	    ..e  d
	    ...i pp["^" s unflag="1",pmoney=$p(pp,"^",1)
	    ...e  s pmoney=pp
	    ..;q:pmoney=0
	    ..s pmoney=$fn(pmoney,"",2)
	    ..i pfact>14 s df="1"
 	    ..Set t=t+1
 	 q df
}

ClassMethod GetCurrWin(phl, flag)
{
  s currdate=+$h
  s retwin=""
  i '$d(^DHCTodayCurrWin(+$h,flag,phl)) d
     .s retwin=##class(web.DHCOutPhDisp).GetFirstWin(+$h,phl,flag)
     .i retwin=""  s retwin=##class(web.DHCOutPhDisp).GetOKWin(phl)
  e  d
     .s retwin=$g(^DHCTodayCurrWin(+$h,flag,phl))
  ;s ^DHCTodayWinInf(currdate,phl,phw)=slrs_"^"_blrs_"^"_totalnum
  i retwin=""  s retwin=##class(web.DHCOutPhDisp).GetOKWin(phl)
  q retwin
}

ClassMethod GetOKWin(phl)
{
  s surwin="",retwin=""
  f  s surwin=$o(^DHCPHWINi(phl,surwin)) q:(surwin="")!(retwin'="")  d
    .s sureflag=""
    .s sureflag=$p(^DHCPHWIN(surwin),"^",3)
    .i sureflag="1" s retwin=surwin
  q retwin
}

ClassMethod GetFirstWin(cur, phl, flag)
{
  s tophw="",ret=""
  f  s tophw=$o(^DHCPHWINi(phl,tophw)) q:(tophw="")!(ret'="")  d
    .s todf="",toop="",tors=0
    .q:'$d(^DHCPHLOCWINOPEN(cur,phl,tophw))
    .s todf=$p(^DHCPHLOCWINOPEN(cur,phl,tophw),"^",2)
    .q:(todf'="1")&(flag="D")
    .q:(todf="1")&(flag="X")
    .s toop=$p(^DHCPHLOCWINOPEN(cur,phl,tophw),"^",1)
    .s tors=$p(^DHCPHLOCWINOPEN(cur,phl,tophw),"^",3)
    .q:toop'="1"
    .q:tors'>0
    .s ^DHCTodayCurrWin(+$h,flag,phl)=tophw
    .s ret=tophw
  q ret
}

ClassMethod GDispItmClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GDispItmExecute ]
{
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GDispItmExecute(ByRef QHandle As %Binary, rPHL As %Library.String = "", rPRT As %Library.String = "", rPrescNo As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s HospitalCode=""
	s str=$g(^DHCDocConfig("CurrentHospital"))
	s HospitalCode=$p(str,"^",1)
	s ind=1
	s sysdate=""
	s phl=$g(rPHL)
	s prt=$g(rPRT)
	i phl="" Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s locdr=$p(^DHCPHLOC(phl),"^",1)
	s loginloc=locdr
	s leadlocdr=..GetLeadLoc(locdr)
	s mainphl=$o(^DHCPHLOCi("LOC",leadlocdr,""))  //主科室
	s phl=mainphl
	s cyflag=""
	s cyflag=$p(^DHCPHLOC(phl),"^",6)
	s yprescno=$g(rPrescNo)
	i (phl="")!(prt="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s reclocdr=""
	s reclocdr=+$p(^DHCPHLOC(phl),"^",1)
	k ^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno)
	s bci="0"
	f  s bci=$o(^DHCBCI(0,"INV",prt,bci)) q:(bci="")!(bci="0")  d
	.s patbill=""
	.s patbill=+$p(^DHCBCI(bci),"^",2)
	.s patbillsub="0"
	.s t=0
	.f  s patbillsub=$o(^DHCPB(patbill,"O",patbillsub)) q:(patbillsub="")!(patbillsub="")  d
	..s orditm="",ord="",itm="",dispflag="",prescno=""
	..s orditm=$p(^DHCPB(patbill,"O",patbillsub),"^",4)
	..s ord=$p(orditm,"||",1),itm=$p(orditm,"||",2)
	..s recplocdr=""
	..s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	..q:recplocdr=""
	..q:recplocdr'=reclocdr
	..s dispflag="" 
	..s dispflag=$p($g(^OEORD(ord,"I",itm,6)),"^",7)
	..;q:dispflag="1"
	..s dispflag=##class(web.DHCOutPhDisp).GetDHCOEDisp(orditm,"W")
	..;q:dispflag="0"
	..s prescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
	..q:prescno=""
	..q:prescno'=yprescno
	..s qty=0,money=0
	..s qty=+$p(^DHCPB(patbill,"O",patbillsub),"^",5)
	..s money=+$p(^DHCPB(patbill,"O",patbillsub),"^",8)
	..q:money=0
	..s t=t+1
	..s ^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,t)=orditm_"^"_qty_"^"_money
	s psub=0
	f  s psub=$o(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,psub)) q:(psub="")!(psub=0)  d
	.s itm="",ord="",orditem=""
	.s dispqty=0,dispmoney=0,price=0,unflag=""
	.s orditem=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,psub),"^",1)
	.s dispqty=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,psub),"^",2)
	.s dispmoney=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,psub),"^",3)
	.s itm=$p(orditem,"||",2)
	.s ord=$p(orditem,"||",1)
	.s price=dispmoney/dispqty
	.s itmmast=""
	.s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast
	.s priority=""
	.s priority=$p(^OEORD(ord,"I",itm,1),"^",8)     ;????
	.s priordesc=""
	.i priority'="" s priordesc=$p(^OECPR(priority),"^",2)
	.q:priordesc["自备"
	.s orddoctco=""
	.s orduser="",ordusertypedr="",ordusercare="",careprovtype="",userdoctype=""
	.s orddoctco=+$p($g(^OEORD(ord,"I",itm,1)),"^",11) ;??
	.s orduser=+$p($g(^OEORD(ord,"I",itm,7)),"^",1)
	.s username=""
	.s username=$p(^SSU("SSUSR",orduser),"^",2)
	.i orduser'=""  s ordusercare=$p(^SSU("SSUSR",orduser),"^",14)
	.i ordusercare'="" s careprovtype=$p(^CTPCP(ordusercare,1),"^",4)
	.i careprovtype'="" s userdoctype=$p(^CT("CPT",careprovtype),"^",4)
	.s doseqty="" s doseqty=$p($g(^OEORD(ord,"I",itm,2)),"^",1)
	.;i doseqty<1 s doseqty="0"_doseqty
	.s unitdr="" s unitdr=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
	.s phfragdr="" s phfragdr=$p($g(^OEORD(ord,"I",itm,2)),"^",4)
	.s duratdr="" s duratdr=$p($g(^OEORD(ord,"I",itm,2)),"^",6)
	.s instrdr="" s instrdr=$p($g(^OEORD(ord,"I",itm,2)),"^",7)
	.s skinflag="",skintest=""
	.s skintest=$p(^OEORD(ord,"I",itm,5),"^",2)
	.i skintest["Y"  d
	..s skintest="Y"
	..s Abnormal=""
	..s Abnormal=$p(^OEORD(ord,"I",itm,11),"^",3)
	..i Abnormal["Y"  s skinflag="2"
	..i Abnormal["N"  s skinflag="1"
	.s unitdesc=""
	.i unitdr'="" s unitdesc=$p($g(^CT("UOM",unitdr)),"^",2)
	.s phuomid="",phuomdesc="",itmmastid="",itmmastver=""
	.s itmmastid=$p(itmmast,"||",1)
	.s itmmastver=$p(itmmast,"||",2)
	.s itmcat="",itmcatdesc="",syflag=""
	.s itmcat=+$p(^ARCIM(itmmastid,itmmastver,1),"^",10)
	.s itmcatdesc=$p(^ARC("IC",itmcat),"^",2)
	.i itmcatdesc["输液"  s syflag="1"
	.s drgform="",drgmast="",phtype=""
	.s drgform=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
	.s phcform="",phfact="",factdesc=""
	.i drgform'=""  d
	..s phcform=$p(^PHCD($p(drgform,"||",1),"DF",$p(drgform,"||",2),1),"^",1)
	..s phfact=$p(^PHCD($p(drgform,"||",1),2),"^",4)
	.e  d
	..s phcform="",phfact=""
	.i phfact="" d
	..s factdesc="" 
	.e  d
	..i '$d(^PHMNF(phfact)) d
	...s factdesc="" 
	..e  d
	...s factdesc=$p(^PHMNF(phfact),"^",2)  
	.i factdesc["-" s factdesc=$p(factdesc,"-",2)  
	.i drgform'="" s drgmast=$p(drgform,"||",1)
	.s jrflag=""
	.s ybcode=""
	.i drgmast'=""  d
	..s phtype=$p($g(^PHCD(drgmast,1)),"^",4)
	..s ybcode=$p($g(^PHCD(drgmast,4)),"^",2)
	.i phtype'="" d
	..s phtype=+phtype
	..s phtypedesc=""
	..q:'$d(^PHCPO(phtype))
	..s phtypedesc=$p(^PHCPO(phtype),"^",1)
	..
	..i phtypedesc["J2" s jrflag="2"
	..i phtypedesc["J1" s jrflag="1"
	.
	.s dxsl="",dxunit=""
	.s dxrowid="0"
	.s dxrowid=$o(^PHCD(drgmast,"DF",$p(drgform,"||",2),"EQ",dxrowid))
	.s phuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	.q:phuomid=""
	.s phuomid=$p(phuomid,$c(1),1)
	.s genric=""
	.s genric=$p(^ARCIM(itmmastid,itmmastver,8),"^",20)
	.s incTYdesc=""
	.i genric'="" s incTYdesc=$p(^PHCGE("GE",genric),"^",2)
	.s phbz="",bz=0,bb=0
	.s bz=$g(^OEORD(ord,"I",itm,"DEP",0))
	.f bb=1:1:bz  d
	..s phbz0=""
	..s phbz0=$g(^OEORD(ord,"I",itm,"DEP",bb))
	..s phbz=phbz_phbz0
	.s currdate=""
	.s cyyf=""
	.s cyyf=$p($g(^OEORD(ord,"I",itm,2)),"^",8)
	.s currdate=$p($h,",",1)
	.s phuomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
	.s inci=""
	.s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
	.q:inci=""
	.s inci=$p(inci,$c(1),1)
	.s sendflag=""
	.;s sendflag=##CLASS(web.DHCOutPhNewAddCommit).ChDispMachine(reclocdr,inci)
	.;i sendflag="1" s sendflag="发药机" 
	.;e  s sendflag=""
	.k ^TMPGETCLB($j)
	.s reclocdr=loginloc // lq 检查登陆科室的库存,使用接受科实下面分组库存
	.d ##CLASS(web.DHCOutPhDisp).GInclb(inci,dispqty,reclocdr)
	.s yppc="",inclb="",incib=""
	.s newclb="",bb=0
	.f  s newclb=$o(^TMPGETCLB($j,newclb)) q:(newclb="")!(bb>0)  d
	..s bb=bb+1
	..s inclb=newclb
	..s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	..s yppc=$p(^INCI($p(incib,"||",1),"IB",$p(incib,"||",2)),"^",1)

	.s sdate="",qtyend=0,ldtrow=""
	.s sdate=$o(^DHCLOCTOT(0,"LOCITMDATE",reclocdr,inci,currdate+1),-1)        
	.i sdate'="" d
	..s ldtrow=$o(^DHCLOCTOT(0,"LOCITMDATE",reclocdr,inci,sdate,""))
	..s qtyend=+$p(^DHCLOCTOT(ldtrow),"^",4)
	.i qtyend<dispqty s unflag="不够"
	.;^INCI("IL_LOC",{INCIL_CTLOC_DR},{INC_Itm.INCI_RowId},             x
	.s incil="",yphw="",incstb=""
	.s incil=$o(^INCI("IL_LOC",reclocdr,inci,""))
	.i incil'=""  d
	..s incstb=+$p(^INCI(inci,"IL",incil),"^",2)
	..i incstb'=0  d
	...q:'$d(^INC("SB",incstb))
	...s yphw=$p(^INC("SB",incstb),"^",2)
	.s puruom="",puruomdesc="",basuom="",basuomdesc=""
	.s puruom=+$p(^INCI(inci,3),"^",6)
	.s puruomdesc=$p($g(^CT("UOM",puruom)),"^",2)
	.s basuom=+$p(^INCI(inci,1),"^",10)
	.s dxts=""
	.s basuomdesc=$p($g(^CT("UOM",basuom)),"^",2)
	.i dxrowid'=""  d
	..s dxsl=+$p(^PHCD(drgmast,"DF",$p(drgform,"||",2),"EQ",dxrowid),"^",2) 
	..s dxunit=+$p(^PHCD(drgmast,"DF",$p(drgform,"||",2),"EQ",dxrowid),"^",1) 
	..s dxundesc=""
	..i dxunit'=0  d
	...s dxundesc=$p($g(^CT("UOM",dxunit)),"^",2)
	...s dxts=dxsl_dxundesc
	..i unitdr=dxunit  d
	...s doseqty=doseqty/dxsl
	...i doseqty["."  s doseqty=$fn(doseqty,"",2)


	.s phgg=""
	.;s phgg=$p($g(^INCI(inci,3)),"^",9)
	.s phgg=##class(web.DHCOutPhDisp).GetPhgg(inci)
	.s confac=1,conrow=""
	.i basuom=phuomid s confac=1
	.e  d
	..s conrow=$o(^CT("CTCF",0,"UOM",phuomid,basuom,conrow))
	..i conrow'="" s confac=+$p(^CT("CTCF",conrow),"^",3)
	.s kcqty=0
	.s kcqty=qtyend/confac
	.s qty=0,newunit="",getnum=0,newunitdesc="",newprice=0
	.s getnum=$p((dispqty/confac),".",1)
	.i getnum="" s getnum=0
	.i getnum=(dispqty/confac)  d
	..s newunit=phuomid
	..s newunitdesc=phuomdesc
	..s qty=getnum
	..s newprice=price*confac
	.e  d
	..s newunit=basuom
	..s newunitdesc=basuomdesc
	..s qty=dispqty
	..s newprice=price
	.s phdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)
	.q:phdesc="" 
	.s duratdesc=""
	.i duratdr'="" s duratdesc=$p($g(^PHCDU(duratdr)),"^",3)
	.s phfragdesc=""
	.i phfragdr'="" s phfragdesc=$p($g(^PHCFR(phfragdr)),"^",3)
	.
	.s instrdesc=""
	.i instrdr'="" s instrdesc=$p($g(^PHCIN(instrdr)),"^",2)
	.s orddoctnam=""
	.i orduser'="" s orddoctnam=$p(^SSU("SSUSR",orduser),"^",2)
	.s doctype=""
	.;i orddoctco'=""  s doctype=$p(^CT("CPT",+$p(^CTPCP(orddoctco,1),"^",4)),"^",4)
	.s jlflag=""
	.s jlflag=doseqty_basuomdesc
	.s error="",t=0,cc=0,notes=""
	.s notes=$p(^OEORD(ord,"I",itm,2),"^",8)
	.s oeflag="",inclbid="",disstatu=""
	.s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",2)       ;????
	.;q:oeflag["停"
	.i newunitdesc["(" s newunitdesc=$p(newunitdesc,"(",1)

	.i t=0 s error="1"
	.s newprice=$fn(newprice,"",2)
	.s dispmoney=$fn(dispmoney,"",2)
	.i instrdesc["遵医嘱" s instrdesc=phbz
	.s doctcode=""
	.i (orddoctco'=0)&(orddoctco'="") d
	..s doctcode=$p(^CTPCP(orddoctco,1),"^",1)
	..s username=$p(^CTPCP(orddoctco,1),"^",2)
	.s ypmc=phdesc
	.i cyflag="1"  d
	..i ypmc["("  d
	...s ypmc=$p(ypmc,"(",1)
	..i ypmc["["   d
	...s ypmc=$p(ypmc,"[",1)
	.set Data=$lb(ypmc,newunitdesc,qty,newprice,dispmoney,oeflag,jlflag,phfragdesc,instrdesc,duratdesc,username,ord_"||"_itm,newunit,yppc,yphw,phtype,phgg,phbz,unflag,skintest,syflag,factdesc,doctcode,jrflag,cyyf,kcqty,ybcode,dxts)
	.Set ^CacheTemp(repid,ind)=Data
	.Set ind=ind+1
	k ^DHCPHTMPPRESCNO($j,prt,"PRESCNO")
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GDispItmFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GDispItmExecute ]
{
	 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query GDispItm(rPHL As %String, rPRT As %String, rPrescNo As %String) As %Query(ROWSPEC = "TPhDesc:%String,TPhUom:%String,TPhQty:%String,TPrice:%String,TMoney:%String,TOrdStatus:%String,TJL:%String,TPC:%String,TYF:%String,TLC:%String,TDoctor:%String,TOrditm:%String,TUnit:%String,TIncPC:%String,TIncHW:%String,TPhType:%String,TPhgg:%String,TPhbz:%String,TKCFlag:%String,TSkinTest:%String,TSyFlag:%String,TPhFact:%String,TDoctCode:%String,TJRFlag:%String,TCyyf:%String,TKCQty:%String,TYBType:%String,TDX:%String")
{
}

ClassMethod CheckPhKC(ctloc, prt, presc)
{
 s phl="",ret=0,kc=""
 s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
 s kc=##class(web.DHCOutPhDisp).GPerOrd(phl,prt,presc)
 i kc["^" s ret=1
 e  s ret=0
 q ret
}

ClassMethod GetPatOrditm(rPHL As %Library.String = "", rPRT As %Library.String = "", rPrescNo As %Library.String = "")
{
	  s phl=$g(rPHL)
	  s prt=$g(rPRT),hh=0,allmoney=0,retorditm=""
	  s yprescno=$g(rPrescNo)
	  s unflag=""
	  s sysdate=+$h
	  i (phl="")!(prt="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	  s reclocdr=""
	  s reclocdr=+$p(^DHCPHLOC(phl),"^",1)
	  s cy=""
	  s cy=$p(^DHCPHLOC(phl),"^",6)
	  s bci="0"
	  f  s bci=$o(^DHCBCI(0,"INV",prt,bci)) q:(bci="")!(bci="0")!(retorditm'="")  d
	    .s patbill=""
	    .s patbill=+$p(^DHCBCI(bci),"^",2)
	    .s patbillsub="0"
	    .f  s patbillsub=$o(^DHCPB(patbill,"O",patbillsub)) q:(patbillsub="")!(patbillsub="")!(retorditm'="")  d
	      ..s orditm="",ord="",itm="",dispflag="",prescno=""
	      ..s orditm=$p(^DHCPB(patbill,"O",patbillsub),"^",4)
	      ..s ord=$p(orditm,"||",1),itm=$p(orditm,"||",2)
	      ..s recplocdr=""
	      ..s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	      ..q:recplocdr=""
	      ..q:recplocdr'=reclocdr
	      ..s dispflag="" 
	      ..s dispflag=$p($g(^OEORD(ord,"I",itm,6)),"^",7)
	      ..s prescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
	      ..q:prescno=""
	      ..q:prescno'=yprescno
	      ..s retorditm=orditm
 q retorditm
}

ClassMethod GPerOrd(rPHL As %Library.String = "", rPRT As %Library.String = "", rPrescNo As %Library.String = "")
{
	s phl=$g(rPHL)
	s prt=$g(rPRT),hh=0,allmoney=0
	s yprescno=$g(rPrescNo)
	s unflag=""
	s sysdate=+$h

	; k ^DHCPHTMPPRESCNO
	i (phl="")!(prt="") Set QHandle=$lb(0,repid,0)	Quit $$$OK

	s locdr=$p(^DHCPHLOC(phl),"^",1)
	s loginloc=locdr
	s leadlocdr=..GetLeadLoc(locdr)
	s mainphl=$o(^DHCPHLOCi("LOC",leadlocdr,""))  //主科室
	s phl=mainphl //lq
	s reclocdr=""
	s reclocdr=+$p(^DHCPHLOC(phl),"^",1)
	s cy=""
	s cy=$p(^DHCPHLOC(phl),"^",6)
	k ^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno)
	
	s len=$l(prt,",")
	f i=1:1:len d
	.s tmpprt=$p(prt,",",i)
	.s bci="0"
	.f  s bci=$o(^DHCBCI(0,"INV",tmpprt,bci)) q:(bci="")!(bci="0")  d
	..s patbill=""
	..s patbill=+$p(^DHCBCI(bci),"^",2)
	..s patbillsub="0"
	..f  s patbillsub=$o(^DHCPB(patbill,"O",patbillsub)) q:(patbillsub="")!(patbillsub="")  d
	...s orditm="",ord="",itm="",dispflag="",prescno=""
	...s orditm=$p(^DHCPB(patbill,"O",patbillsub),"^",4)
	...s ord=$p(orditm,"||",1),itm=$p(orditm,"||",2)
	...s recplocdr=""
	...s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	...q:recplocdr=""
	...q:recplocdr'=reclocdr
	...s dispflag="" 
	...s dispflag=$p($g(^OEORD(ord,"I",itm,6)),"^",7)
	...s prescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
	...q:prescno=""
	...q:prescno'=yprescno
	...s qty=0,money=0
	...s qty=+$p(^DHCPB(patbill,"O",patbillsub),"^",5)
	...s money=+$p(^DHCPB(patbill,"O",patbillsub),"^",8)
	...i $d(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm))  d
	....s $p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",1)=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",1)+qty
	....s $p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",2)=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",2)+money
	...e  d
	....s $p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",1)=qty
	....s $p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",2)=money
	 
	   s ordi="",durfact="",patlocdesc=""
	   f  s ordi=$o(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,ordi)) q:ordi=""  d
	     .s dispqty=0,dispmoney=0,price=0
	     .s dispqty=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,ordi),"^",1)
	     .s dispmoney=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,ordi),"^",2)
	     .s price=dispmoney/dispqty
	     .s ord="",itm=""
	     .s ord=$p(ordi,"||",1)
	     .s itm=$p(ordi,"||",2)
	 	 .s itmmast="",adm=""
	 	 .s adm=+$p(^OEORD(ord),"^",1)
	 	 .s patloc=""
	 	 .s patloc=+$p(^PAADM(adm),"^",4)
	 	 .i patloc'="" s patlocdesc=$p(^CTLOC(patloc),"^",2)
	 	 .i patlocdesc["-" s patlocdesc=$p(patlocdesc,"-",2)
	 	 .;i patlocdesc["&" s patlocdesc=$p(patlocdesc,"&",2)
	     .s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast
	     .s priority=""
	     .s priority=$p(^OEORD(ord,"I",itm,1),"^",8)     ;????
	     .s yppc="",inclb="",incib=""
	     .i $d(^OEORD(ord,"I",itm,"X",1,"D",1))  d
	       ..s inclb=$p(^OEORD(ord,"I",itm,"X",1,"D",1),"^",2)
	       ..s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	       ..s yppc=$p(^INCI($p(incib,"||",1),"IB",$p(incib,"||",2)),"^",1)
	     .e  s yppc=""
	     .s priordesc=""
	     .i priority'="" s priordesc=$p(^OECPR(priority),"^",2)
	     .q:priordesc["自备"
	    .s orddoctco=""
	    .s orddoctco=$p($g(^OEORD(ord,"I",itm,1)),"^",11) ;??
	    .s doseqty="" s doseqty=$p($g(^OEORD(ord,"I",itm,2)),"^",1)
	    .;i doseqty<1 s doseqty="0"_doseqty
	    .s unitdr="" s unitdr=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
	    .s phfragdr="" s phfragdr=$p($g(^OEORD(ord,"I",itm,2)),"^",4)
	    .s duratdr="" s duratdr=$p($g(^OEORD(ord,"I",itm,2)),"^",6)
	    .s instrdr="" s instrdr=$p($g(^OEORD(ord,"I",itm,2)),"^",7)
	    .s unitdesc=""
	    .i unitdr'="" s unitdesc=$p($g(^CT("UOM",unitdr)),"^",2)
	    .s phuomid="",phuomdesc="",itmmastid="",itmmastver=""
	    .s itmmastid=$p(itmmast,"||",1)
	    .s itmmastver=$p(itmmast,"||",2)
	    .s drgform="",drgmast="",phtype=""
	    .s drgform=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
	    .i drgform'="" s drgmast=$p(drgform,"||",1)
	    .i drgmast'=""  d
	      ..s phtype=$p($g(^PHCD(drgmast,4)),"^",2)
	    .s phuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	    .q:phuomid=""
	    .s phuomid=$p(phuomid,$c(1),1)
	    .s currdate=""
	    .s currdate=$p($h,",",1)
	    .s phuomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
	    .s inci=""
	    .s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
	    .q:inci=""
	    .s inci=$p(inci,$c(1),1)
	    .s sdate="",qtyend=0
	    .s reclocdr=loginloc //lq 检查登陆科室库存
	    .s sdate=$o(^DHCLOCTOT(0,"LOCITMDATE",reclocdr,inci,sysdate+1),-1)        
	    .i sdate'="" d
	      ..s ldtrow=$o(^DHCLOCTOT(0,"LOCITMDATE",reclocdr,inci,sdate,""))
	      ..s qtyend=+$p(^DHCLOCTOT(ldtrow),"^",4)
	     .
        .i qtyend<dispqty s unflag="1"
	    .;^INCI("IL_LOC",{INCIL_CTLOC_DR},{INC_Itm.INCI_RowId},             x
	    .s incil="",yphw="",incstb=""
	    .s incil=$o(^INCI("IL_LOC",reclocdr,inci,""))
	    .i incil'=""  d
	      ..s incstb=+$p(^INCI(inci,"IL",incil),"^",2)
	      ..i incstb'=0  d
	      ...q:'$d(^INC("SB",incstb))
	      ...s yphw=$p(^INC("SB",incstb),"^",2)
	    .s puruom="",puruomdesc="",basuom="",basuomdesc=""
	    .s puruom=+$p(^INCI(inci,3),"^",6)
	    .s puruomdesc=$p($g(^CT("UOM",puruom)),"^",2)
	    .s basuom=+$p(^INCI(inci,1),"^",10)
	    .s basuomdesc=$p($g(^CT("UOM",basuom)),"^",2)
	    .s phgg=""
	    .s phgg=$p($g(^INCI(inci,3)),"^",9)
	    .s confac=1,conrow=""
	    .i basuom=puruom s confac=1
	    .e  d
	      ..s conrow=$o(^CT("CTCF",0,"UOM",puruom,basuom,conrow))
	      ..i conrow'="" s confac=+$p(^CT("CTCF",conrow),"^",3)
	      ..
	    .s qty=0,newunit="",getnum=0,newunitdesc="",newprice=0
	    .s getnum=$p((dispqty/confac),".",1)
	    .i getnum="" s getnum=0
	    .i getnum=(dispqty/confac)  d
	      ..s newunit=puruom
	      ..s newunitdesc=puruomdesc
	      ..s qty=getnum
	      ..s newprice=price*confac
	    .e  d
	       ..s newunit=basuom
	       ..s newunitdesc=basuomdesc
	       ..s qty=dispqty
	       ..s newprice=price
	    .s phdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)
	    .q:phdesc="" 
	    .s duratdesc=""
	    .i (duratdr'="")&(durfact="") s duratdesc=$p($g(^PHCDU(duratdr)),"^",3),durfact=$p($g(^PHCDU(duratdr)),"^",2)
	    .s phfragdesc=""
	    .i phfragdr'="" s phfragdesc=$p($g(^PHCFR(phfragdr)),"^",4)
	    .s instrdesc=""
	    .i instrdr'="" s instrdesc=$p($g(^PHCIN(instrdr)),"^",2)
	    .s orddoctnam=""
	    .i orddoctco'="" s orddoctnam=$p($g(^CTPCP(orddoctco,1)),"^",2)
	    .s doctype=""
	    .i orddoctco'=""  s doctype=$p(^CT("CPT",+$p(^CTPCP(orddoctco,1),"^",4)),"^",4)
	    .s jlflag=""
	    .;i unitdesc["?" s unitdesc=$p(unitdesc,"?",1) s unitdesc=unitdesc_"?"
	    .s jlflag=doseqty_unitdesc
	    .s error="",t=0,cc=0,notes=""
	    .s notes=$p(^OEORD(ord,"I",itm,2),"^",8)
	     .s oeflag="",inclbid="",disstatu=""
	    .s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",2)       ;????
        .;q:oeflag["停"
        .i newunitdesc["(" s newunitdesc=$p(newunitdesc,"(",1)
	     .i t=0 s error="1"
	     .s allmoney=allmoney+dispmoney
	     .;s dispmoney=$j(dispmoney,12,4)
 	     .s hh=hh+1
  i allmoney'=0  d
    . i allmoney<1   s allmoney="0"_allmoney
   i unflag="1"  d
     .s allmoney=allmoney_"^"_"1"
   i cy="1"  d
     .s allmoney=allmoney_"&"_patlocdesc_"&"_durfact
   e  d
     .s allmoney=allmoney_"&"_patlocdesc
 k ^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno)
 q allmoney
}

ClassMethod CheckDispMachine(rPHL As %Library.String = "", rPRT As %Library.String = "", rPrescNo As %Library.String = "")
{
	  s phl=$g(rPHL)
	  s prt=$g(rPRT),hh=0,allmoney=0
	  s yprescno=$g(rPrescNo)
	  s retdispmachine=0
	  i (phl="")!(prt="") q 0
	  s reclocdr=""
	  s reclocdr=+$p(^DHCPHLOC(phl),"^",1)
	  s cy=""
	  s cy=$p(^DHCPHLOC(phl),"^",6)
	  s bci="0"
	  f  s bci=$o(^DHCBCI(0,"INV",prt,bci)) q:(bci="")!(bci="0")  d
	    .s patbill=""
	    .s patbill=+$p(^DHCBCI(bci),"^",2)
	    .s patbillsub="0"
	    .f  s patbillsub=$o(^DHCPB(patbill,"O",patbillsub)) q:(patbillsub="")!(patbillsub="")  d
	      ..s orditm="",ord="",itm="",dispflag="",prescno=""
	      ..s orditm=$p(^DHCPB(patbill,"O",patbillsub),"^",4)
	      ..s ord=$p(orditm,"||",1),itm=$p(orditm,"||",2)
	      ..s recplocdr=""
	      ..s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	      ..q:recplocdr=""
	      ..q:recplocdr'=reclocdr
	      ..s dispflag="" 
	      ..s dispflag=$p($g(^OEORD(ord,"I",itm,6)),"^",7)
	      ..s prescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
	      ..q:prescno=""
	      ..q:prescno'=yprescno
	      ..s qty=0,money=0
	      ..s qty=+$p(^DHCPB(patbill,"O",patbillsub),"^",5)
	      ..s money=+$p(^DHCPB(patbill,"O",patbillsub),"^",8)
	      ..s retdisp=""
	      ..s retdisp=##class(web.DHCOutPhNewAddCommit).ChDispMachine(reclocdr,orditm,qty)
	      ..;(loc,qty,ordi)
	      ..i retdisp="1" s retdispmachine="1"
   
 q retdispmachine
}

ClassMethod CheckWinPos(ctloc)
{
 s ret="0",CTCode="",CTDesc=""
 i ctloc'="636"  d
  .s CTCode="O"
  .s CTDesc="无位"
 i CTCode'=""  s ret=CTCode_"^"_CTDesc
 q ret
}

ClassMethod GPerIcd(rPHL As %Library.String = "", rPRT As %Library.String = "", rPrescNo As %Library.String = "")
{
		 s phl=$g(rPHL)
		 s prt=$g(rPRT),hh=0,allmoney=0
		 s yprescno=$g(rPrescNo)
		 ;k ^DHCPHTMPPRESCNO
		 i (phl="")!(prt="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
		 s reclocdr=""
		 s reclocdr=+$p(^DHCPHLOC(phl),"^",1)
		 s adm="",deploc="",deplocdesc=""
		 k ^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno)
		 s bci="0",mricd=""
	     f  s bci=$o(^DHCBCI(0,"INV",prt,bci)) q:(bci="")!(bci="0")  d
	     .s patbill=""
	     .s patbill=+$p(^DHCBCI(bci),"^",2)
	     .s patbillsub="0"
	     .f  s patbillsub=$o(^DHCPB(patbill,"O",patbillsub)) q:(patbillsub="")!(patbillsub="")  d
	     ..s orditm="",ord="",itm="",dispflag="",prescno=""
	     ..s orditm=$p(^DHCPB(patbill,"O",patbillsub),"^",4)
	     ..s ord=$p(orditm,"||",1),itm=$p(orditm,"||",2)
	     ..s adm=+$p(^OEORD(ord),"^",1)
	     ..s deploc=+$p(^PAADM(adm),"^",4)
	     ..s deplocdesc=$p(^CTLOC(deploc),"^",2)
	     ..s recplocdr=""
	     ..s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	     ..q:recplocdr=""
	     ..q:recplocdr'=reclocdr
	     ..s dispflag="" 
	     ..s dispflag=$p($g(^OEORD(ord,"I",itm,6)),"^",7)
	     ..s prescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
	     ..q:prescno=""
	     ..q:prescno'=yprescno
	     ..s qty=0,money=0
	     ..s qty=+$p(^DHCPB(patbill,"O",patbillsub),"^",5)
	     ..s money=+$p(^DHCPB(patbill,"O",patbillsub),"^",8)
	     ..i $d(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm))  d
	     ...s $p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",1)=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",1)+qty
	     ...s $p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",2)=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",2)+money
	     ..e  d
	     ...s $p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",1)=qty
	     ...s $p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",2)=money
	         
	     s ordi="",sysl=0,zsl=0
	     f  s ordi=$o(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,ordi)) q:ordi=""  d
	     .s dispqty=0,dispmoney=0,price=0
	     .s glorditm=""
	     .s dispqty=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,ordi),"^",1)
	     .s dispmoney=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,ordi),"^",2)
	     .q:(dispqty="")
	     .q:(dispqty=0)
	     .s price=dispmoney/dispqty
	     .s ord="",itm=""
	     .s ord=$p(ordi,"||",1)
	     .s itm=$p(ordi,"||",2)
	     .s itmmast=""
	     .s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast
	     .s itmmastid="",itmmastver="",itmcat="",itmcatdesc=""
	     .s itmmastid=$p(itmmast,"||",1)
	     .s itmmastver=$p(itmmast,"||",2)
	     .s itmcat=+$p(^ARCIM(itmmastid,itmmastver,1),"^",10)
	     .s itmcatdesc=$p(^ARC("IC",itmcat),"^",2)
	     .i itmcatdesc["输液"  s sysl=sysl+1
	     .s zsl=zsl+1
	     .s paadm="",mradm="",allicd=""
	     .s paadm=+$p(^OEORD(ord),"^",1)
	     .s mradm=+$p(^PAADM(paadm),"^",61)
	     .s mrdia="0"
	     .f  s mrdia=$o(^MR(mradm,"DIA",mrdia)) q:(mrdia="")!(mrdia="0")  d
	     ..s icdcode="",desc=""
	     ..s icdcode=+$p(^MR(mradm,"DIA",mrdia),"^",1)
	     ..s descremark=$p($g(^MR(mradm,"DIA",mrdia,"DES",1)),"^",1)  //诊断描述-》非标准ICd诊断liangqiang 2014-12-18
	     ..i icdcode'=0 d
	     ...s desc=$p(^MRC("ID",icdcode),"^",2)
	     ..s desc=desc_descremark
	     ..
	     ..i desc'=""  d
	     ...i allicd="" s allicd=desc
	     ...e  s allicd=allicd_";"_desc
         .s mricd=allicd
          
         s syflag=""
         i sysl>0  d
         .i sysl<zsl  s syflag="1"
         
         s mricd=mricd_"&"_syflag
         q mricd
}

ClassMethod QueryWinInfClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryWinInfExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryWinInfExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	s phl=""
    s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i (phl="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	i '$d(^DHCPHLOCWINOPEN(+$h,phl)) Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s phw=""
	f  s phw=$o(^DHCPHWINi(phl,phw)) q:phw=""  d
	  .s phwdesc="",dfflag="",pfrs=0,openflag=""
	  .s phwdesc=$p(^DHCPHWIN(phw),"^",1)
	  .;^DHCPHLOCWINOPEN(pdate,phl,phw)=openflag_"^"_dfflag_"^"_pfrs_"^"_userid
	  .s openflag=$p(^DHCPHLOCWINOPEN(+$h,phl,phw),"^",1)
	  .s dfflag=$p(^DHCPHLOCWINOPEN(+$h,phl,phw),"^",2)
	  .s pfrs=$p(^DHCPHLOCWINOPEN(+$h,phl,phw),"^",3)
	  .q:pfrs<1
	  .q:openflag'="1"
	  .i dfflag="1" s dfflag="是"
	  .e  s dfflag="否"
	  .s cfs=0,fs=0
	  .i $d(^DHCTodayWinInf(+$h,phl,phw)) s cfs=$p(^DHCTodayWinInf(+$h,phl,phw),"^",3)
	  .i $d(^DHCTodayWinInf(+$h,phl,phw)) s fs=$p(^DHCTodayWinInf(+$h,phl,phw),"^",4)
	  .set Data=$lb(phwdesc,pfrs,cfs,fs,dfflag)
 	  .Set ^CacheTemp(repid,ind)=Data	
 	  .Set ind=ind+1
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryWinInfFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWinInfExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryWinInf(ctloc As %String) As %Query(ROWSPEC = "TPhwDesc:%String,TPFrs:%String,TPrescNum:%String,TPrescFS:%String,TDFFlag:%String")
{
}

ClassMethod QueryNewWinClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryNewWinExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryNewWinExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	s phl=""
    s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i (phl="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	i '$d(^DHCPHLOCWINOPEN(+$h,phl)) Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s phw=""
	f  s phw=$o(^DHCPHWINi(phl,phw)) q:phw=""  d
	  .s phwdesc="",dfflag="",pfrs=0,openflag=""
	  .s phwdesc=$p(^DHCPHWIN(phw),"^",1)
	  .;^DHCPHLOCWINOPEN(pdate,phl,phw)=openflag_"^"_dfflag_"^"_pfrs_"^"_userid
	  .s openflag=$p(^DHCPHLOCWINOPEN(+$h,phl,phw),"^",1)
	  .s dfflag=$p(^DHCPHLOCWINOPEN(+$h,phl,phw),"^",2)
	  .s pfrs=$p(^DHCPHLOCWINOPEN(+$h,phl,phw),"^",3)
	  .q:pfrs<1
	  .q:openflag'="1"
	  .set Data=$lb(phwdesc,phw)
 	  .Set ^CacheTemp(repid,ind)=Data	
 	  .Set ind=ind+1
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryNewWinFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryNewWinExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryNewWin(ctloc As %String) As %Query(ROWSPEC = "TPhwDesc:%String,TPhw:%String")
{
}

ClassMethod GetPhwCode(phl, phw)
{
  s ret="",code=0
  i '$d(^DHCPHCODEToday(+$h,phl,phw)) d
    .s ^DHCPHCODEToday(+$h,phl,phw)=0
  s ^DHCPHCODEToday(+$h,phl,phw)=^DHCPHCODEToday(+$h,phl,phw)+1
  s code=$g(^DHCPHCODEToday(+$h,phl,phw))
 q code
}

ClassMethod GetTelMb(phl)
{
	 s ret="",tel="",cymb=""
	 i $d(^GLobDHCPHLOC(phl))  d
	 .s tel=$p(^GLobDHCPHLOC(phl),"^",1)
 	 .s cymb=$p(^GLobDHCPHLOC(phl),"^",2)
 	 s ret=tel_"^"_cymb
 	 q ret
}

ClassMethod InsPhwCode(phl, phw, wincode, pmino, patname, prescno)
{
 s ^DHCPHTodayWinCode(+$h,phl,pmino,prescno)=patname_"^"_wincode_"^"_phw
 q 0
}

ClassMethod getpatloc(phl, st, end, pmino)
{
	s st=$zdh(st,4)
	s end=$zdh(end,4)
	s phadate=0
	s lret=""
	s ret=0,l=0
	s ret=##class(web.DHCOutPhDisp).getlocph(phl,st,end,pmino)
	i ret=0  d
	  .s nphl=""
	  .s retval=""
	  .f  s nphl=$o(^DHCPHLOC(nphl)) q:nphl=""  d
	   ..q:nphl=phl
	   ..s nret=0
	   ..s ctloc="",locdesc=""
	   ..s ctloc=+$p(^DHCPHLOC(nphl),"^",1)
	   ..s locdesc=$p(^CTLOC(ctloc),"^",2)
	   ..i locdesc["-" s locdesc=$p(locdesc,"-",2)
	   ..s nret=##class(web.DHCOutPhDisp).getlocph(nphl,st,end,pmino)
	   ..q:nret=0
	   ..i retval="" s retval=locdesc
	   ..e  s retval=retval_";"_locdesc
	 .i retval="" s lret=100
	 .e  s lret=retval
	e  s lret=0
	q lret
}

ClassMethod getlocph(phl, st, end, pmino)
{
    s phadate=0
	s t=0
	f phadate=st:1:end  d
	  .s pha=0
	  .f  s pha=$o(^DHCPHARWi(phadate,phl,pha)) q:pha=""  d
        ..s phwdesc="",phw="",finflag="",nouse="",printflag="",arrcpdr="",prt="",prescno=""
	    ..s phw=+$p(^DHCPHARW(pha),"^",4)
	    ..s phwdesc=$p(^DHCPHWIN(phw),"^",1)
	    ..s finflag=$p(^DHCPHARW(pha),"^",6)
	    ..;i finflag'="1" s finflag=""
	    ..q:(finflag="1")
	    ..s nouse=$p(^DHCPHARW(pha),"^",7)
	    ..q:nouse="1"
	    ..s printflag=$p(^DHCPHARW(pha),"^",8)
	    ..i printflag'="1" s printflag=""
	    ..e  s printflag="OK"
	    ..s prt=+$p(^DHCPHARW(pha),"^",1)
	    ..s prescno=$p(^DHCPHARW(pha),"^",16)
	    ..s arraldr=""
	    ..s papmidr="",papmino="",payamount0=0,phatime=""
	    ..q:'$d(^DHCINVPRT(prt))
	    ..s papmidr=$p(^DHCINVPRT(prt),"^",15)
	    ..q:papmidr=""
	    ..s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	    ..q:(papmino'=pmino)
	    ..s patienname=""
	    ..s patienname=$p(^PAPER(papmidr,"ALL"),"^",1)
	    ..s t=t+1
	q t
}

ClassMethod getadm(prescno)
{
	s ord="0",adm=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:(ord="")!(ord="0")  d
	  .s adm=+$P(^OEORD(ord),"^",1)
   q adm
}

ClassMethod getpatinf(phl, adm, prt, prescno)
{
  s sysdate=+$h	
  s ctloc="",ret="",ctlocdesc=""
  s ctloc=+$P(^DHCPHLOC(phl),"^",1)
  s ctlocdesc=$p(^CTLOC(ctloc),"^",2)
  i ctlocdesc["-" s ctlocdesc=$p(ctlocdesc,"-",2)
  s admdep="",patname=""
  s patcompany="",patno="",pmidr=""
  s pmidr=+$p(^PAADM(adm),"^",1)
  s patno=$p(^PAPER(pmidr,"PAT",1),"^",2)
  s patname=$p(^PAPER(pmidr,"ALL"),"^",1)
  s patsexdr="",patsex="",birthday="",difdate="",perold=""
  s patsexdr=+$p(^PAPER(pmidr,"ALL"),"^",7)
  s birthday=+$p(^PAPER(pmidr,"ALL"),"^",6)
  s difdate=sysdate-birthday+1
  s perold=difdate/365
  i perold["." s perold=$p(perold,".",1)
  i patsexdr'="" s patsex=$p(^CT("SEX",patsexdr),"^",2)
  s patID=$p(^PAPER(pmidr,"ALL"),"^",9)
  s mricd="",retval=""
  s retval=##class(web.DHCOutPhDisp).GPerIcd(phl,prt,prescno)
  s mricd=$p(retval,"&",1)
  s patcompany=##class(web.DHCDocOrderEntry).GetPatientCompany(pmidr)
  s CardNo=##class(web.DHCDocOrderEntry).GetMRNo(pmidr)
  s admdate="",admdep="",admdepdesc=""
  s admdate=+$p(^PAADM(adm),"^",6)
  s admdate=$zd(admdate,3)
  s admdep=+$p(^PAADM(adm),"^",4)
  s admdepdesc=$p(^CTLOC(admdep),"^",2)
  i admdepdesc["-" s admdepdesc=$p(admdepdesc,"-",2)
  s ret=patname_"^"_patno_"^"_patsex_"^"_perold_"^"_patcompany_"^"_admdepdesc_"^"_admdate_"^"_ctlocdesc_"^"_mricd_"^"_CardNo
  q ret
}

ClassMethod getordinf(orditm)
{
 s ret=""
 &sql( SELECT OEORI_Rowid,OEORI_ItmMast_DR->ARCIM_Desc,Todate(OEORI_SttDat,'dd/mm/yyyy'),OEORI_SeqNo,
 OEORI_DoseQty,OEORI_UNIT_DR->CTUOM_Desc,
	       OEORI_Priority_dr->OECPR_Desc,OEORI_Itemstat_dr->OSTAT_Desc,oeori_PHFreq_dr->PHCFR_Desc1,
	       OEORI_instr_dr->PHCIN_Desc1,OEORI_Durat_dr->PHCDU_Desc1,
	       OEORI_QtyPackUOM,OEORI_ItmMast_DR->ARCIM_BillingUOM_DR->CTUOM_Desc,
	       OEORI_RecDep_DR->CTLOC_Desc,OEORI_Billed,OEORI_ItmMast_DR,OEORI_SttDat,OEORI_BBExtCode,
	       OEORI_UserAdd->SSUSR_Initials,OEORI_UserAdd->SSUSR_Name,
	       OEORI_ItmMast_DR->ARCIM_ItemCat_DR,OEORI_OEORI_DR,OEORI_Action_DR->ACT_Desc
	  INTO :Rowid,:OrderName,:StartDate,:SeqNo,:DoseQty,:DoseUOM,:Priority,:Status,:Frequence,
	       :Instruction,:Duration,:PackQty,:PackUOM,:RecDep,:Billed,:ARCIMRowid,:SttDate,
	       :BillType,:UserAddCode,:UserAddName,:ItemCat,:LinkOrderItem,:Action
 From SQLUser.OE_OrdItem 
 WHERE OEORI_rowid=:orditm )
 s subcat=$p($g(^ARCIM(+ARCIMRowid,1,1)),"^",10)
 s orcat=$p($g(^ARC("IC",+subcat)),"^",8)
 s orcatdesc=""
 i orcat'="" s orcatdesc=$p($g(^OEC("ORCAT",orcat)),"^",2)
 i orcatdesc["材料" q ret
 i BillType="" s BillTypeDesc="自费"
 e  s BillTypeDesc=$P(^PAC("ADMREA",BillType),"^",2)
 ;在药学项上记录了该药品属于哪类
 s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
 s OfficialCode=""
 s BillClassDesc=""
 i DrgFormRowid'="" d
   .s DrgMastRowid=$p(DrgFormRowid,"||",1)
   .s OfficialCode=$p($g(^PHCD(DrgMastRowid,4)),"^",2)
 i OfficialCode=1 s BillClassDesc="甲类"
 i OfficialCode=2 s BillClassDesc="乙类"
 i OfficialCode=3 s BillClassDesc="丙类"
 s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ARCIMRowid)
 i PoisonRowid'="" d
  .s PoisonClass=$p($g(^PHCPO(PoisonRowid)),"^",2)
  .i PoisonClass="二类精神" s PoisonClass="精二"
  .i PoisonClass="一类精神" s PoisonClass="精一"
  .i PoisonClass="毒麻药" s PoisonClass="麻"
 e  s PoisonClass=""
 s PackUOM=$p(PackUOM,"(",1)
 i (DoseQty'="")&(DoseQty<1) s DoseQty="0"_$number(DoseQty)
  s GenericName=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(ARCIMRowid)
 i GenericName'="" d
   .s Spec=""
   .s ARCIMSub=$p(ARCIMRowid,"||",1)
   .s InciRowid=##class(web.DHCDocOrderEntry).GetINCI(ARCIMSub)
 ; s OrderName=GenericName
 ; set Data=$lb(Rowid,OrderName,StartDate,SeqNo,DoseQty,DoseUOM,Priority,Status,Frequence,Instruction,Duration,PackQty,PackUOM,Price,Sum,RecDep,Billed,BillTypeDesc,BillClassDesc,UserAddCode,UserAddName,PoisonClass,ItemCat,Action)
 i OrderName["-" s OrderName=$p(OrderName,"-",2)
 s ret=OrderName_"^"_StartDate_"^"_SeqNo_"^"_DoseQty_"^"_DoseUom_"^"_Priority_"^"_Status_"^"_Frequence_"^"_Instruction_"^"_Duration_"^"_PackQty_"^"_PackUOM_"^"_Billed_"^"_BillTypeDesc_"^"_BillClassDesc_"^"_UserAddCode_"^"_UserAddName_"^"_PoisonClass_"^"_ItemCat
 q ret
}

ClassMethod GetDHCOEDisp(orditm, type)
{
	;type=Y--已发药；W--未发药
	s dhcoedisp="0"
	s ret=0
	f  s dhcoedisp=$o(^DHCOEDISQTY(0,"OEORI",orditm,dhcoedisp)) q:(dhcoedisp="")!(dhcoedisp="0")  d
	 .s dspstatu="",dsptype=""
	 .;s dsptype=$p(^DHCOEDISQTY(dhcoedisp),"^",13)
	 .s dspstatu=$p(^DHCOEDISQTY(dhcoedisp),"^",7)
	 .q:(dspstatu="R")
	 .q:(dspstatu="TC")&(type="Y")
	 .q:(dspstatu="C")&(type="W")
	 .s ret=ret+1
  i ret>0 s ret=1
  q ret
}

ClassMethod InsertDHCOEDisp(orditm, qty, unit, pointer, status, type, user)
{
   s sysdate=+$h
   s systime=$p($h,",",2)
   &sql(insert into sqluser.dhc_oedispensing(dsp_date,dsp_dateadd,dsp_time,dsp_timeadd,
   dsp_qty,dsp_qtyuom,dsp_oeori_dr,dsp_pointer,dsp_type,dsp_status,dsp_user,dsp_confirmqty)
   values(:sysdate,:sysdate,:systime,:systime,:qty,:unit,:orditm,:pointer,:type,:status,:user,:qty))
   q SQLCODE_"^"_$p(%ROWID,$c(1))
}

ClassMethod CheckPydType(pydphl, pydprt, pydpresc)
{
  	  s chphl=$g(pydphl)
	  s chprt=+$g(pydprt),hh=0,allmoney=0
	  s yprescno=$g(pydpresc)
	  s reclocdr=""
	  s reclocdr=+$p(^DHCPHLOC(chphl),"^",1)
	  
	  k ^DHCPHTMPPRESCNO($j,chprt,"PRESCNO",yprescno)
	  /*
	  s bci="0",mricd=""
	  f  s bci=$o(^DHCBCI(0,"INV",chprt,bci)) q:(bci="")!(bci="0")  d
	    .s patbill=""
	    .s patbill=+$p(^DHCBCI(bci),"^",2)
	    .s patbillsub="0"
	    .f  s patbillsub=$o(^DHCPB(patbill,"O",patbillsub)) q:(patbillsub="")!(patbillsub="")  d
	      ..s orditm="",ord="",itm="",dispflag="",prescno=""
	      ..s orditm=$p(^DHCPB(patbill,"O",patbillsub),"^",4)
	      ..s ord=$p(orditm,"||",1),itm=$p(orditm,"||",2)
	      ..s recplocdr=""
	      ..s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	      ..q:recplocdr=""
	      ..q:recplocdr'=reclocdr
	      ..s dispflag="" 
	      ..s dispflag=$p($g(^OEORD(ord,"I",itm,6)),"^",7)
	      ..s prescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
	      ..q:prescno=""
	      ..q:prescno'=yprescno
	      ..s qty=0,money=0
	      ..s qty=+$p(^DHCPB(patbill,"O",patbillsub),"^",5)
	      ..s money=+$p(^DHCPB(patbill,"O",patbillsub),"^",8)
	      ..i $d(^DHCPHTMPPRESCNO($j,chprt,"PRESCNO",prescno,orditm))  d
	      ...s $p(^DHCPHTMPPRESCNO($j,chprt,"PRESCNO",prescno,orditm),"^",1)=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",1)+qty
	      ...s $p(^DHCPHTMPPRESCNO($j,chprt,"PRESCNO",prescno,orditm),"^",2)=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",2)+money
	      ..e  d
	      ...s $p(^DHCPHTMPPRESCNO($j,chprt,"PRESCNO",prescno,orditm),"^",1)=qty
	      ...s $p(^DHCPHTMPPRESCNO($j,chprt,"PRESCNO",prescno,orditm),"^",2)=money
	         
	    */
	    
	    s ord=""
	    f  s ord=$o(^OEORD(0,"PrescNo",yprescno,ord)) q:ord=""  d 
	    .s itm=""
	    .f  s itm=$o(^OEORD(0,"PrescNo",yprescno,ord,itm) ) q:itm=""  d
	    ..s orditm=ord_"||"_itm
	    ..s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	    ..q:recplocdr=""
	    ..q:recplocdr'=reclocdr
	    ..s prescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
	    ..q:prescno'=yprescno
	    ..s dspdate=..getDspDate(ord_"||"_itm)
	    ..s qty=+..getDspQty(ord_"||"_itm) 
	    ..s inci=##class(web.DHCOutPhCommon).GetInciByOrditm(ord_"||"_itm)
	    ..i +chprt=0 d
	    ...s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(reclocdr)
        ...s hospdr=$p(HospString,"^",1)
	    ...//s ordprice=##class(web.DHCSTCOMMONSRV).GetPriceElse(+inci,+dspdate,"",hospdr)
	    ...s exStr=orditm_"^"
	    ...s ordprice=##class(web.DHCSTPRICE).GetSp(+inci,+dspdate,"",hospdr,"",exStr)	//zhouyg 20150113
	    ...s money=ordprice*qty
	    ..e  d
	    ...s ordpriceinfo=##class(web.DHCOutPhCommon).GetBasPriceByInv(chprt,ord_"||"_itm)
	    ...s ordprice=$p(ordpriceinfo,"^",1)
	    ...s money=$p(ordpriceinfo,"^",2) 
	    ...s money=$fn(money,"",2)
	    ..i $d(^DHCPHTMPPRESCNO($j,chprt,"PRESCNO",prescno,orditm))  d
	    ...s $p(^DHCPHTMPPRESCNO($j,chprt,"PRESCNO",prescno,orditm),"^",1)=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",1)+qty
	    ...s $p(^DHCPHTMPPRESCNO($j,chprt,"PRESCNO",prescno,orditm),"^",2)=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",2)+money
	    ..e  d
	    ...s $p(^DHCPHTMPPRESCNO($j,chprt,"PRESCNO",prescno,orditm),"^",1)=qty
	    ...s $p(^DHCPHTMPPRESCNO($j,chprt,"PRESCNO",prescno,orditm),"^",2)=money
        ;    
	    s ordi="",sysl=0,zsl=0,presctypedesc="",ret="",jrflag=""
	    f  s ordi=$o(^DHCPHTMPPRESCNO($j,chprt,"PRESCNO",yprescno,ordi)) q:ordi=""  d
	     .s dispqty=0,dispmoney=0,price=0,preason=""
	     .s glorditm=""
	     .s dispqty=$p(^DHCPHTMPPRESCNO($j,chprt,"PRESCNO",yprescno,ordi),"^",1)
	     .s dispmoney=$p(^DHCPHTMPPRESCNO($j,chprt,"PRESCNO",yprescno,ordi),"^",2)
	     .q:(dispqty="")
	     .q:(dispqty=0)
	     .s price=dispmoney/dispqty
	     .s ord="",itm=""
	     .s ord=$p(ordi,"||",1)
	     .s itm=$p(ordi,"||",2)
	     .s preason=$p(^OEORD(ord,"I",itm,11),"^",18)
	     .s itmmast=""
	     .s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast
	     .s itmmastid="",itmmastver="",itmcat="",itmcatdesc=""
	     .s itmmastid=$p(itmmast,"||",1)
	     .s itmmastver=$p(itmmast,"||",2)
	     .s itmcat=+$p(^ARCIM(itmmastid,itmmastver,1),"^",10)
	     .s drgform="",drgmast="",phtype=""
	     .s drgform=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
	     .i drgform'="" s drgmast=$p(drgform,"||",1)
	     .i drgmast'=""  d
	      ..s phtype=$p($g(^PHCD(drgmast,1)),"^",4)
	     .i phtype'="" d
	      ..s phtype=+phtype
	      ..s phtypedesc=""
	      ..s phtypedesc=$p(^PHCPO(phtype),"^",1)
	      ..i phtypedesc["精二" s jrflag="2"
	      ..i phtypedesc["精一" s jrflag="1"
	     .s itmcatdesc=$p(^ARC("IC",itmcat),"^",2)
	     .i itmcatdesc["输液"  s sysl=sysl+1
	     .s zsl=zsl+1
	     .s paadm="",mradm="",allicd=""
	     .s paadm=+$p(^OEORD(ord),"^",1)
	     .s dhcprescrow="",PrescTypeCode=""
         .s dhcprescrow=$o(^DHCPAQPT(0,"PrescNo",yprescno,""))
         .i dhcprescrow'=""  d
          ..s psonrow="",pson="",psoncode=""
          ..s psonrow=+$p(^DHCPAQPT(dhcprescrow),"^",2)
          ..s pson=+$p(^DHCPAADMPrescType(psonrow),"^",2)
          ..s PrescTypeCode=pson
          ..s presctypedesc=$p(^PAC("ADMREA",PrescTypeCode),"^",2)
          .e  d
            ..s PrescTypeCode=preason
            ..i (PrescTypeCode'="")&(PrescTypeCode'="undefined")  d
            ...
            ...s presctypedesc=$p(^PAC("ADMREA",PrescTypeCode),"^",2)
            
            ..e  s presctypedesc="自费"
            
         s ret=presctypedesc_"^"_jrflag
         
	     k ^DHCPHTMPPRESCNO($j,chprt,"PRESCNO",yprescno) 
	        
         q ret
}

ClassMethod GetIncLocTotal(inc, loc)
{
  
    s sysdate=+$h
	s sdate="",qtyend=0
	s sdate=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inc,sysdate+1),-1)        
	i sdate'="" d
	     .s ldtrow=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inc,sdate,""))
	     .i ldtrow'=""  d
	     ..s qtyend=+$p(^DHCLOCTOT(ldtrow),"^",4)
 q qtyend
}

ClassMethod GetBasPrice(prt, oeori, dispb = "")
{
	s retprice=0
  	s dbci="0"
  	f  s dbci=$o(^DHCBCI(0,"INV",prt,dbci)) q:(dbci="")  d
    .s patbill=+$p(^DHCBCI(dbci),"^",2)
    .;add by wangjian 2018-06-12 增加分支
    .i (dispb="") d
    ..s billsub="0"
    ..f  s billsub=$o(^DHCPBi(0,"OEORI",oeori,patbill,billsub)) q:(billsub="")  d
    ...q:'$d(^DHCPB(patbill,"O",billsub))
    ...s basprice=$p(^DHCPB(patbill,"O",billsub),"^",7)
    ...s money=+$p(^DHCPB(patbill,"O",billsub),"^",8)
    ...s retprice=basprice
    .e  d
    ..s billsub="0"
	..f  s billsub=$o(^DHCPB(0,"DSPBDR",dispb,patbill,billsub))  q:(billsub="")  d
	...s pbdsub="0"
	...f  s pbdsub=$o(^DHCPB(0,"DSPBDR",dispb,patbill,billsub,pbdsub))  q:(pbdsub="")  d
	....s basprice=$p(^DHCPB(patbill,"O",billsub,"D",pbdsub),"^",4)
    ....s retprice=basprice
    
 	q retprice
}

ClassMethod CheckPhdKC(phdrow)
{
	s argphl="",argloc=""
	s argphl=+$p(^DHCPHDISP(phdrow,1),"^",1)
	s argloc=+$p(^DHCPHLOC(argphl),"^",1)
	s currdate=+$h
	k ^DHCTMPPHLocTotal($j)
	s phdchild=""
	f  s phdchild=$o(^DHCPHDI(phdrow,"PHDI",phdchild)) q:phdchild=""  d
	  .s phdqty=0,phorditm="",phord="",phitm=""
	  .s phdqty=+$p(^DHCPHDI(phdrow,"PHDI",phdchild),"^",4)
	  .s phorditm=$p(^DHCPHDI(phdrow,"PHDI",phdchild),"^",5)
	  .s phord=$p(phorditm,"||",1)
	  .s phitm=$p(phorditm,"||",2)
	  .s itmmast="",inc=""
	  .s itmmast=$p(^OEORD(phord,"I",phitm,1),"^",2)
	  .s inc=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),inc))
	  .q:inc=""
	  .i $d(^DHCTMPPHLocTotal($j,inc)) d
	    ..s ^DHCTMPPHLocTotal($j,inc)=^DHCTMPPHLocTotal($j,inc)+phdqty
	  .e  d
	    ..s ^DHCTMPPHLocTotal($j,inc)=phdqty
	  s chinc="",unflag=0
	  f  s chinc=$o(^DHCTMPPHLocTotal($j,chinc)) q:(chinc="")!(unflag'=0)  d
	    .s incqty=0
	    .s incqty=$p(^DHCTMPPHLocTotal($j,chinc),"^",1)
	    .s sdate="",ldtrow="",qtyend=""
	    .s qtyend=##class(web.DHCOutPhDisp).GetIncLocTotal(chinc,argloc)
        .i qtyend<incqty s unflag="1"
       k ^DHCTMPPHLocTotal($j)
	  i unflag'=0 q -1
	q 0
}

ClassMethod GetLeadLoc(locdr As %String) As %String
{
	s MainLoc=""
	s loadloc=""
	f  s loadloc=$o(^DHCDLOC(0,"LEADSUB",loadloc)) q:(loadloc="")||(MainLoc'="")  d
	.i $d(^DHCDLOC(0,"LEADSUB",loadloc,locdr)) s MainLoc=loadloc
	q:MainLoc="" locdr  //主科室为空时返回本科室
	q leadlocdr	
	/*
	///取出主科室(lead location)rowid : 
	s leadlocdr=$O(^DHCDLOC(0,"SUBLOC",locdr,""))
	q:leadlocdr="" locdr  //主科室为空时返回本科室
	s leadlocdr=$p(^DHCDLOC(leadlocdr),"^",1)
	q leadlocdr
	*/
}

/// Description:查询某个患者
/// Creator:Liang Qiang 
ClassMethod QueryLocOutPatClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocOutPatExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// w ##class(%ResultSet).RunQuery("web.DHCOutPhDisp","QueryLocOutPat",65176,65178,"2","3","","","","","","1","212^")
ClassMethod QueryLocOutPatExecute(ByRef QHandle As %Binary, CDateSt As %Library.String = "", CDateEnd As %Library.String = "", GPhl As %Library.String = "", GPhw As %Library.String = "", CPmiNo As %Library.String = "", CPatName As %Library.String = "", GPydr As %Library.String = "", GFydr As %Library.String = "", GPhwPos As %Library.String = "", Fin As %Library.String = "", specString) As %Status
{
	s ^TMPDHCSTPARAMS("web.DHCOutPhDisp","QueryLocOutPat")=$lb(CDateSt , CDateEnd , GPhl , GPhw , CPmiNo , CPatName , GPydr , GFydr , GPhwPos , Fin , specString)
 	Set repid=$I(^CacheTemp)
	s ind=1
	s phl=""
    s phl=GPhl
    s SpecialID=$p(specString,"^",1)  //留观室
    s Specialloc=$p(specString,"^",2)  //基数科室
    s pid=##CLASS(web.DHCSTKUTIL).GetOutDispCounter()
    s prt=""
    s CDateEnd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateEnd)
    s CDateSt=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateSt)
	s stdate=CDateSt
	s enddate=CDateEnd
	s cyflag="",dfflag="" 
	s locdr=$p(^DHCPHLOC(phl),"^",1)
	s leadlocdr=..GetLeadLoc(locdr)
	s reclocdr=leadlocdr
    s phaphl=phl
	s mainphl=$o(^DHCPHLOCi("LOC",leadlocdr,""))  //主科室
	s phl=mainphl
	s cyflag=$p(^DHCPHLOC(phl),"^",6)				//草药药房标志
	s yflocdr=+$p(^DHCPHLOC(phl),"^",1)
	s fpflag=""
	s phadate=0
	s phl=mainphl	
	s pid=##CLASS(web.DHCSTKUTIL).GetOutDispCounter()
	s dispnum=0
	s phlStr=""
	s chkreclocflag=##class(web.DHCOutPhCommon).GetChkRecLocFlag() 		//不判断科室
	i chkreclocflag=0 d
	.i cyflag=1 s phlStr=##class(web.DHCOutPhCommon).GetPatCyPhlStr()
	.e  s phlStr=##class(web.DHCOutPhCommon).GetPatPhlStr()
	i phlStr="" s phlStr=phl
	s needauditflag=##class(web.DHCOutPhCommon).GetNeedOrdAuditFlag(phl)		//是否处方审核
	
	f phadate=stdate:1:enddate  d
	.q:SpecialID'=""						//特殊科室
	.s phlCnt=$l(phlStr,"^")
	.f xx=1:1:phlCnt d
	..s phl=$p(phlStr,"^",xx)
	..s pha=""
    ..f  s pha=$o(^DHCPHARWi(phadate,phl,pha)) q:pha=""  d
	...s phw=+$p(^DHCPHARW(pha),"^",4)
	...s phwdesc=""
	...s:+phw>0 phwdesc=$p(^DHCPHWIN(phw),"^",1)
	...s finflag=$p(^DHCPHARW(pha),"^",6)			//发药标志
	...q:(finflag="1")&(Fin'="1")
	...q:(finflag'="1")&(Fin="1")
	...s nouse=$p(^DHCPHARW(pha),"^",7)				//计费作废标志
	...q:nouse="1"
	...s retflag=$p(^DHCPHARW(pha),"^",13)
	...q:retflag'="1"      
	...s printflag=$p(^DHCPHARW(pha),"^",8)			//打印标志(配药标志)
    ...s prescno=$p(^DHCPHARW(pha),"^",16)
    ...q:prescno=""
    ...s tmpord=$o(^OEORD(0,"PrescNo",prescno,""))
    ...s tmpchl=$o(^OEORD(0,"PrescNo",prescno,tmpord,"")) 
	...s adm=$p(^OEORD(tmpord),"^",1) 
	...q:adm=""
	...s papmidr=$p($g(^PAADM(adm)),"^",1)
	...q:papmidr=""
	...s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	...q:(papmino'=CPmiNo)&(CPmiNo'="")
    ...s chkerr=..CheckBeforUpdate(prescno,phl)
	...q:(Fin'="1")&&(chkerr=1)
	...q:(Fin="1")&&(chkerr'="1")
	...s orditm=+tmpord_"||"_tmpchl
	...s payDispFlag=##class(PHA.OP.COM.Method).GetDispBeforePay(orditm)
	...q:payDispFlag="Y"
	...s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	...q:dsp=""
	...s dspdate=""
	...i dsp'="" d
	....s dspdate=$p(^DHCOEDISQTY(dsp),"^",8)   //发药日期
	....s:dspdate'="" dspdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(dspdate)
    ...s ^TMPPRESCINFO(pid,adm,prescno)=dspdate
    f orddate=stdate:1:enddate  d
    .q:(SpecialID="")&&(CPmiNo="") // 留观类,登记号留观室不能同时为空
    .s phadate="" //收费日期
	.s ord=""
	.f  s ord=$o(^OEORDi(0,"LocStDtArr",yflocdr,0,orddate,ord)) q:ord=""  d
	..q:'$d(^OEORD(ord))
	..s adm=$p(^OEORD(ord),"^",1) 
	..q:adm=""
	..s AdmType=$p($g(^PAADM(adm)),"^",2)
	..q:(AdmType'="O")&(AdmType'="E")&(AdmType'="H")  		//只处理门诊,急诊,体检类病人 
	..s papmidr=$p($g(^PAADM(adm)),"^",1)
	..q:papmidr=""
	..s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	..q:(papmino'=CPmiNo)&(CPmiNo'="")
	..s chl="" 
	..f  s chl=$o(^OEORDi(0,"LocStDtArr",yflocdr,0,orddate,ord,chl)) q:chl=""  d
	...s prescno=$p($g(^OEORD(ord,"I",chl,1)),"^",14)
	...q:prescno=""
	...//q:$d(^DHCPHARi("PRESCNO",prescno))	//此处方已经收过费
	...q:$d(^TMPPRESCINFO(pid,adm,prescno))
	...s prcode=""
	...s pr=+$p(^OEORD(ord,"I",chl,1),"^",8)
    ...i pr'=0 s prcode=$p(^OECPR(pr),"^",1)
    ...q:prcode["OM"
	...s ordstatus=$p(^OEORD(ord,"I",chl,3),"^",5)
	...s ordstatdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	...s ordstat=$p(^OEC("OSTAT",ordstatdr),"^",1)       
    ...i Fin'=1 q:(ordstat'="V")&(ordstat'="E")
	...s orditm=ord_"||"_chl
	...s payDispFlag=##class(PHA.OP.COM.Method).GetDispBeforePay(orditm,AdmType)
	...q:payDispFlag'="Y"
	...s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	...q:dsp=""
	...s dspstatus=$p(^DHCOEDISQTY(dsp),"^",7)
	...i (dspstatus="TC")&&(AdmType="H") s phwdesc=""
	...q:(dspstatus="C")&(Fin'="1") 
	...q:(dspstatus'="C")&(Fin="1")
	...s chkdocloc=..ChkLGDocLoc(SpecialID,adm) //留观室
	...q:chkdocloc=0
    ...s Cat=$p(^DHCOEDISQTY(dsp),"^",27)
    ...q:Cat=0 //过虑配液医嘱
    ...s dspdate=""
    ...s dspdate=$p(^DHCOEDISQTY(dsp),"^",8)   //发药日期
	...s:dspdate'="" dspdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(dspdate)
	...s ^TMPPRESCINFO(pid,adm,prescno)=dspdate
	..
	s phl=mainphl
	s adm="" 
    f  s adm=$o(^TMPPRESCINFO(pid,adm)) q:adm=""  d
    .s papmidr=$p(^PAADM(adm),"^",1) 
    .s AdmType=$p(^PAADM(adm),"^",2)
    .s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	.q:(papmino'=CPmiNo)&(CPmiNo'="")
	.s patienname=""
	.s (papsexdr,papsex,perold,patage,pattype,patstatudr,tel,patadd)=""
	.s papsexdr=+$p(^PAPER(papmidr,"ALL"),"^",7)
	.s perold=##class(web.DHCOutPhTQDisp).GetPatientAgeDesc(papmidr)
 	.i papsexdr'="" s papsex=$p(^CT("SEX",papsexdr),"^",2)
	.s patid=""
	.s patienname=$p(^PAPER(papmidr,"ALL"),"^",1)
	.s patid=$p(^PAPER(papmidr,"ALL"),"^",9)
	.s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2) 
    .s patstatudr=+$p(^PAPER(papmidr,"PER",1),"^",10)
	.s tel=+$p(^PAPER(papmidr,"PER",1),"^",11)   
    .i patstatudr'=0 s pattype=$p($g(^CT("SS",patstatudr)),"^",2)
    .i pattype["(" s pattype=$p(pattype,"(",1)
    .s patadd=$p($g(^PAPER(papmidr,"NOK")),"^",7)
    .s mricd=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",")			//诊断
    .s patloc="",patlocdesc=""
	.s patloc=+$p(^PAADM(adm),"^",4)
	.s patlocdesc=$p(^CTLOC(patloc),"^",2)
	.i patlocdesc["-" s patlocdesc=$p(patlocdesc,"-",2)
	.s warddesc=""
	.s currwarddr=$p(^PAADM(adm),"^",70)
	.i currwarddr'="" d
	..s ctlocdr=$p(^PAWARD(currwarddr),"^",5)
	..s warddesc=$p(^CTLOC(ctlocdr),"^",2)
	..i warddesc["-" s warddesc=$p(warddesc,"-",2)
	..s patlocdesc=patlocdesc_"["_warddesc_"]"
    .s prescno=""
    .f  s prescno=$o(^TMPPRESCINFO(pid,adm,prescno)) q:prescno=""  d
    ..
    ..s prt="",phadate="",printflag=""
    ..s phar="",phwdesc=""
	..f  s phar=$o(^DHCPHARi("PRESCNO",prescno,phar)) q:phar=""  d
	...s notuse=$p(^DHCPHARW(phar),"^",7)
	...q:notuse=1
	...s retflag=$p(^DHCPHARW(phar),"^",13)
	...q:retflag'="1"
	...s phadate=$p(^DHCPHARW(phar),"^",2)
	...s phw=+$p(^DHCPHARW(phar),"^",4)
	...s:+phw>0 phwdesc=$p(^DHCPHWIN(phw),"^",1)
	..i (Fin="1")||(phwdesc="") d
	...s lastphd=$o(^DHCPHDISPi("PRESCNO",prescno,""),-1)
	...i lastphd'="" d
	....s phw=$p(^DHCPHDISP(lastphd,1),"^",4)
	....s:+phw>0 phwdesc=$p(^DHCPHWIN(phw),"^",1)
    ..s finflag=""
	..s chkerr=..CheckBeforUpdate(prescno,phl)
	..q:(chkerr=1)&(Fin'="1")
	..q:(chkerr'=1)&(Fin="1")
	..i (chkerr=1) d
	...s finflag="OK"
	...s printflag="OK"
	..e  d
	...s chkerr=..CheckBeforInsertNew(prescno,phaphl,0)  
	...i chkerr="1" s printflag="OK"
	..s chkerr=##class(web.DHCOutPhCommon).GetOrdXState(prescno,phl)
	..q:(chkerr=1)&(Fin'="1")
    ..s phd=..GetPhdByPresc(prescno,"",phaphl)
    ..s dspdate=^TMPPRESCINFO(pid,adm,prescno)
    ..d getdata
    d clearTmp 
    Set QHandle=$lb(0,repid,0)
    Quit $$$OK
	    
getdata()
		s doclocstr=##class(web.DHCOutPhCommon).GetOrdUseLocByPresc(prescno)
        s uselocdr=$p(doclocstr,"^",1)
        q:(Specialloc="")&&(uselocdr'="")					//默认不显示基数药科室
        q:(Specialloc'="")&&(uselocdr'=Specialloc)
        
	    s Str=##class(web.DHCOutPhCommon).GetHandTime(prescno)    //发票的日期时间
	    ;s handflag=+$p(Str,"^",1)
	    s prtdate=$p(Str,"^",2)
	    s phatime=$p(Str,"^",3)
	    s prt=$p(Str,"^",4)
	    s prtcode=$p(Str,"^",5)
	    
		s auditflag=""
	    s auditflag=##class(web.DHCOutPhCommon).GetOrdAuditResultByPresc(prescno)
	    q:(needauditflag="1")&(auditflag'="Y") //处理需要发药前审核
	    s ssresult=##class(web.DHCOutPhCommon).GetOrdRefResultByPresc(prescno)
	    i ssresult="S" d
	    .s appealreason=##class(web.DHCOutPhCommon).GetOrdAppealReasonByPresc(prescno) //申诉理由
	    .s ssresult="申诉拒绝"_"("_appealreason_")"
	    i ssresult="N" s ssresult="拒绝发药"
	    i ssresult="A" s ssresult="拒绝发药(接受)"
	    i ssresult="Y" s ssresult="通过"	
	    i ssresult="" d				//发药拒绝为空 -》处方审核
		.i auditflag="N" s ssresult="拒绝"
		.i auditflag="Y" s ssresult="通过"
		.i auditflag="S" s ssresult="申诉" 
	    s (fs,syflag,jrflag,jytype,ptype)=""					//草药付数,输液标志,未知,煎药方式
	   
	    s (patorditem,patord,patitm,patcosdesc,patcos)=""
	    s patord=$o(^OEORD(0,"PrescNo",prescno,"")) 
	    q:patord=""
	    s patitm=$o(^OEORD(0,"PrescNo",prescno,patord,"")) 
	    q:patitm=""
	    s patcos=+$p($g(^OEORD(patord,"I",patitm,3)),"^",10)
	    i patcos'=0 d
	    .s patcosdesc=$p(^ARCOS(patcos),"^",2)
	    e  s patcosdesc=""  	    
	    s pfact=##class(web.DHCOutPhCommon).GetQueFactor(prescno,phl)
	    s querow="",jytype=""
	    s querow=$O(^PAQUE1(0,"PrescNo",prescno,""))
	    i querow'=""  d
	    .i $d(^PAQUE1(querow,"DHC")) s jytype=$p(^PAQUE1(querow,"DHC"),"^",15)
	    i jytype["代"  s jytype="代煎"
        s presctitle=""
	    s presctitle=##class(web.DHCOutPhDisp).GetPrescType(prescno)
	    s dispnum=dispnum+1
	    s reclocinfo=##class(web.DHCOutPhCommon).GetPrescRecLoc(prescno)
	    s reclocdesc=$p(reclocinfo,"^",1)
	    s reclocdr=$p(reclocinfo,"^",2)
	    //准备发药数据
	    i (Specialloc'="") d
	    .s uselocdr="1"
	    .s ^TMP("DHCOutPh","DHCOutPhDisp","QueryLocOutPatExecute",pid,dispnum)=prt_"^"_phl_"^"_$g(phw)_"^"_prescno
	    
	    s EncryptLevelInfo=""
        s EncryptLevel=""
        s PatLevel=""
	    s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
        i EncryptFlag=1 d
	    .s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmidr,"")
 	    .s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 	    .s PatLevel=$p(EncryptLevelInfo,"^",2)
 	    s jytype=""
 	    s prescrow=$o(^PAQUE1(0,"PrescNo",prescno,""))
	    i prescrow'=""  d
	    .i $d(^PAQUE1(prescrow,"DHC")) s jytype=$p(^PAQUE1(prescrow,"DHC"),"^",15)
	    s prescmoney=##class(PHA.OP.COM.Method).GetPrescAmt(prescno,yflocdr,$s(finflag="OK":1,1:""))
	    s pmoney=$p(prescmoney,"^",1) 
	    s presctype=$p(prescmoney,"^",2) 
	    i phd'="" s phdispstat=##class(web.DHCOutPhCommon).GetPhdStatus(phd)
	    e  s phdispstat=""
	    set Data=$lb(patienname,papmino,prtdate,printflag,finflag,prtcode,phatime,prt,prescno,pmoney,pfact,phwdesc,mricd,patadm,presctype,papsex,perold,patid,patlocdesc,patcosdesc,jytype,tel,patadd,presctitle,phd,uselocdr,pid,reclocdesc,reclocdr,$g(ssresult),EncryptLevel,PatLevel,dspdate,jytype,phdispstat)
 	    Set ^CacheTemp(repid,ind)=Data	
 	    Set ind=ind+1
 	    q
clearTmp
    k ^TMPPRESCINFO(pid)
}

ClassMethod QueryLocOutPatFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocOutPatExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryLocOutPat(CDateSt As %String, CDateEnd As %String, GPhl As %String, GPhw As %String, CPmiNo As %String, CPatName As %String, GPydr As %String, GFydr As %String, GPhwPos As %String, Fin As %String, specString) As %Query(ROWSPEC = "TPatName:%String,TPmiNo:%String,TPrtDate:%String,TPrintFlag:%String,TFyFlag:%String,TPrtInv:%String,TPrtTime:%String,TPrt:%String,TPrescNo:%String,TPrescMoney:%String,TJS:%String,TWinDesc:%String,TMR:%String,TAdm:%String,TPrescType:%String,TPatSex:%String,TPatAge:%String,TPatID:%String,TPatLoc:%String,TOrdGroup:%String,TJYType:%String,TCallCode:%String,TPatAdd:%String,TPrescTitle:%String,Tphd:%String,TUseLocdr:%String,TPid:%String,TRecLocdesc:%String,TRecLocdr:%String,TDocSS:%String,TEncryptLevel:%String,TPatLevel:%String,TFyDate:%String,TJyType:%String,TPhDispStat:%String")
{
}

/// w ##class(web.DHCOutPhDisp).GetPrescMoney("4712","E180907000017","309","1")
ClassMethod GetPrescMoney(adm, presc, loc, FYFlag As %Library.String = "")
{
	
	s ord=0,dispnum=0,retmoney=0,PrescTypeDesc="",rpamt=0
	f  s ord=$o(^OEORD(0,"Adm",adm,ord)) q:(ord="")!(ord=0)!(dispnum'=0)  d
	.s itm=0
	.f  s itm=$O(^OEORD(ord,"I",itm)) q:(itm="")!(itm=0)  d
	..s ordpresc=""
	..s ordpresc=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
	..q:ordpresc=""
	..s recloc=""
	..s recloc=+$p(^OEORD(ord,"I",itm,3),"^",6)
	..q:recloc'=loc
	..s preason=""
	..s preason=$p(^OEORD(ord,"I",itm,11),"^",18)
	..q:ordpresc'=presc
	..s PrescTypeCode=""
	..s PrescTypeCode=preason
	..i PrescTypeCode'="" s PrescTypeDesc=$p(^PAC("ADMREA",PrescTypeCode),"^",2)
	..e  s PrescTypeDesc=""
	..s ordprice=0
	..s dpflag=""
	..s EmLGflag=$p($g(^OEORD(+ord,"I",itm,"DHC")),"^",17)
	..;q:(EmLGflag'=1)
	..s arcitm="",qty=0
	..s arcitm=$p(^OEORD(ord,"I",itm,1),"^",2)
	..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcitm,"||",1),""))
	..q:+inci=0
	..s baseuom=$p(^INCI(inci,1),"^",10)
	..s puruom=$p(^INCI(inci,3),"^",6)
	..s fac=+##Class(web.DHCST.Common.UtilCommon).UOMFac(puruom,baseuom)
	..s qty=+$p(^OEORD(ord,"I",itm,9),"^",4)
	..s dspdate=..getDspDate(ord_"||"_itm)
	..i dspdate="" s dspdate=+$h
	..s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(loc)
	..s hospdr=$p(HospString,"^",1)
	..s Billuom=+$p(^INCI(inci,1),"^",12)
	..s dispuomdr=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)
	..i dispuomdr'="" s Billuom=dispuomdr        ;add by lq
	..s exStr=ord_"||"_itm_"^"
	..s spdate=+dspdate
	..s firstinclb=##class(web.DHCOutPhCommon).GetFirstInclbByOe(ord_"||"_itm)
	..i firstinclb="" s firstinclb=+inci,spdate=+$p($g(^OEORD(ord,"I",itm,3)),"^",7)
	..i spdate=0 s spdate=+dspdate
	..s ordprice=##class(web.DHCSTPRICE).GetSp(firstinclb,+spdate,Billuom,hospdr,"","")	//zhouyg 20150113,yunhaibao20170210,批次价调价后发药按调价后价格
	..s oeflag="",inclbid="",disstatu=""
	..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)       ;????
	..i FYFlag'=1 q:oeflag="D"
	..s ordmoney=0
	..s ordmoney=qty*ordprice
	..s retmoney=retmoney+ordmoney
	..s rp=##class(web.DHCSTPRICE).GetRp(+inci,+dspdate,Billuom,hospdr,"")
	..s rpsumamt=rp*qty
	..s rpamt=rpamt+rpsumamt
	i retmoney=0 q 0_"^"_PrescTypeDesc
	s retmoney=$fn(retmoney,"",2)
	s retval=retmoney_"^"_PrescTypeDesc_"^"_rpamt
	q retval
}

/// d ##class(%ResultSet).RunQuery("web.DHCOutPhDisp","QueryLocOutPatItm","12","","E181108000037","78","")
Query QueryLocOutPatItm(rPHL As %String, rPRT As %String, rPrescNo As %String, rPhdrow = "", fyflag = "") As websys.Query(ROWSPEC = "TPhDesc:%String,TPhUom:%String,TPhQty:%String,TPrice:%String,TMoney:%String,TOrdStatus:%String,TJL:%String,TPC:%String,TYF:%String,TLC:%String,TDoctor:%String,TOrditm:%String,TUnit:%String,TIncPC:%String,TIncHW:%String,TPhType:%String,TPhgg:%String,TPhbz:%String,TKCFlag:%String,TSkinTest:%String,TSyFlag:%String,TPhFact:%String,TDoctCode:%String,TJRFlag:%String,TCyyf:%String,TKCQty:%String,TYBType:%String,TRealQty:%String,TPhDispItmStat:%String,TPrescNo:%String,TInci:%String")
{
}

ClassMethod QueryLocOutPatItmExecute(ByRef QHandle As %Binary, rPHL As %Library.String = "", rPRT As %Library.String = "", rPrescNo As %Library.String = "", rPhdrow = "", fyflag = "") As %Status
{
	s ^TMPDHCSTPARAMS("web.DHCOutPhDisp","QueryLocOutPatItm")=rPHL_","_rPRT_","_rPrescNo_","_rPhdrow_","_fyflag
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set QHandle=$lb(0,repid,0)
	Quit:(rPHL="")||(rPrescNo="") $$$OK
	i rPrescNo="" Quit $$$OK
	s chkreclocflag=##class(web.DHCOutPhCommon).GetChkRecLocFlag() 			//是否可跨科室标志
	s PID=##CLASS(web.DHCSTKUTIL).GetOutDispCounter()
	s phl=$g(rPHL),prt=$g(rPRT),prescno=$g(rPrescNo)
	
	s locdr=$p(^DHCPHLOC(phl),"^",1)
	s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(locdr)
	s CustID=$p(CustStr,"^",1)
	s loginloc=locdr
	s leadlocdr=..GetLeadLoc(locdr)
	s mainphl=$o(^DHCPHLOCi("LOC",leadlocdr,""))  //主科室
	s phl=mainphl
	s cyflag=""
	s cyflag=$p(^DHCPHLOC(phl),"^",6)
	s reclocdr=+$p(^DHCPHLOC(phl),"^",1)
	
	s dispflag=##CLASS(web.DHCOutPhDisp).CheckDispFlag(prescno,phl)
	s prtdate=""
	s phar=$o(^DHCPHARi("PRESCNO",rPrescNo,"")) 
	i phar'="" d
	.s prtdate=$p(^DHCPHARW(phar),"^",2)
	s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(reclocdr)
	s hospdr=$p(HospString,"^",1)
	s yprescno=reclocdr_"||"_rPrescNo
	s t=0 
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",rPrescNo,ord))  q:ord=""  d 
	.s patadm=$p(^OEORD(ord),"^",1)
	.s admtype=$p(^PAADM(patadm),"^",2)
	.s itm=""
	.f  s itm=$o(^OEORD(0,"PrescNo",rPrescNo,ord,itm)) q:itm=""  d
	..s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	..q:recplocdr=""
	..q:(chkreclocflag=1)&&(recplocdr'=reclocdr) 					//取配置判断是否允许跨科室发药
	..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)                                     
	..s BillFlag=$p(^OEORD(ord,"I",itm,3),"^",5)                               
	..s orditm=ord_"||"_itm
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	..q:dsp=""
	..s dspStatus=$p(^DHCOEDISQTY(dsp),"^",7)
	..q:(dspStatus="TC")&&(BillFlag'="P")&&(oeflag'="V")&&(oeflag'="E") 
	..s spdate=$s(prtdate'="":prtdate,1:$p(^DHCOEDISQTY(dsp),"^",8)) 
	..i spdate="" s spdate=+$h
	..i $d(^DHCOEDISQTY(dsp,"I")) d  
	...s dspSub=0
	...f  s dspSub=$o(^DHCOEDISQTY(dsp,"I",dspSub)) q:dspSub=""  d
	....s inci=$p(^DHCOEDISQTY(dsp,"I",dspSub),"^",5)
	....s dspQty=$p(^DHCOEDISQTY(dsp,"I",dspSub),"^",2)
	....s dspbat=dsp_"||"_dspSub
	....i (BillFlag="P")&&(admtype'="H") d 
	.....s ordpriceinfo=##class(web.DHCOutPhCommon).GetBasePriceByOe(orditm,dspbat)
	.....s ordprice=$p(ordpriceinfo,"^",1)
	.....s pmoney=+$p(ordpriceinfo,"^",2)
	....e  d
	.....s dspInclb=$p(^DHCOEDISQTY(dsp,"I",dspSub),"^",1) 
	.....s getSpInc=$s(dspInclb'="":dspInclb,1:inci)
	.....s ordprice=##class(web.DHCSTPRICE).GetSp(getSpInc,+spdate,"",hospdr,"","")	//没发票的需要按最新进价
	.....s pmoney=ordprice*dspQty
	.....s Perv="^^^^"_hospdr_"^DHC"
	.....s pmoney=##Class(web.DHCSTCOMMPARA).GetNumbDec(pmoney,Perv,"FmtSA",1)
	....//q:pmoney=0 // 价格是0也需要发药
	....i '$d(^DHCPHTMPPRESCNO("DHCST","web.DHCOutPhDisp","QueryLocOutPatItm",PID,"PRESCNO",yprescno,itm,inci)) d
	.....s ^DHCPHTMPPRESCNO("DHCST","web.DHCOutPhDisp","QueryLocOutPatItm",PID,"PRESCNO",yprescno,itm,inci)=orditm_"^"_dspQty_"^"_pmoney_"^"_ordprice_"^"_inci_"^"_dspbat  
	....e  d
	.....s tmpdata=^DHCPHTMPPRESCNO("DHCST","web.DHCOutPhDisp","QueryLocOutPatItm",PID,"PRESCNO",yprescno,itm,inci)
	.....s $p(tmpdata,"^",2)=$p(tmpdata,"^",2)+dspQty
	.....s $p(tmpdata,"^",3)=$p(tmpdata,"^",3)+pmoney
	.....s ^DHCPHTMPPRESCNO("DHCST","web.DHCOutPhDisp","QueryLocOutPatItm",PID,"PRESCNO",yprescno,itm,inci)=tmpdata
	..e  d								//下面仅为查询医嘱改造前数据
	...q
	...s arcitm=$p(^OEORD(ord,"I",itm,1),"^",2)
	...s inci=$o(^INCI(0,"ARCIM_DR",$p(arcitm,"||",1),""))
	...q:+inci=0
	...s qty=$p(^DHCOEDISQTY(dsp),"^",2)
	...i BillFlag="P" d
	....s ordpriceinfo=##class(web.DHCOutPhCommon).GetBasePriceByOe(orditm,"")
	....s ordprice=$p(ordpriceinfo,"^",1)
	....s pmoney=+$p(ordpriceinfo,"^",2)
	...e  d 
	....s uom=$p(^DHCOEDISQTY(dsp),"^",6)
	....s Buom=$p(^INCI(inci,1),"^",10)
	....i Buom'=uom  d
	.....s fac=##Class(web.DHCST.Common.UtilCommon).UOMFac(uom,Buom)	
	.....s qty=qty*fac
	....s ordprice=##class(web.DHCSTPRICE).GetSp(inci,+spdate,Buom,hospdr,"","")
	....s pmoney=ordprice*dspQty
	....s Perv="^^^^"_hospdr_"^DHC"
	....s pmoney=##Class(web.DHCSTCOMMPARA).GetNumbDec(pmoney,Perv,"FmtSA",1)
	...q:pmoney=0
	...i '$d(^DHCPHTMPPRESCNO("DHCST","web.DHCOutPhDisp","QueryLocOutPatItm",PID,"PRESCNO",yprescno,itm,inci)) d
	....s ^DHCPHTMPPRESCNO("DHCST","web.DHCOutPhDisp","QueryLocOutPatItm",PID,"PRESCNO",yprescno,itm,inci)=orditm_"^"_qty_"^"_pmoney_"^"_ordprice_"^"_inci_"^"_""  
	...e  d
	....s tmpdata=^DHCPHTMPPRESCNO("DHCST","web.DHCOutPhDisp","QueryLocOutPatItm",PID,"PRESCNO",yprescno,itm,inci)
	....s $p(tmpdata,"^",2)=$p(tmpdata,"^",2)+qty
	....s $p(tmpdata,"^",3)=$p(tmpdata,"^",3)+pmoney
	

	s psub=0
	f  s psub=$o(^DHCPHTMPPRESCNO("DHCST","web.DHCOutPhDisp","QueryLocOutPatItm",PID,"PRESCNO",yprescno,psub)) q:(psub="")!(psub=0)  d
	.s IncIndex=0 
	.f  s IncIndex=$o(^DHCPHTMPPRESCNO("DHCST","web.DHCOutPhDisp","QueryLocOutPatItm",PID,"PRESCNO",yprescno,psub,IncIndex)) q:(IncIndex="")!(IncIndex=0)  d
	..s prescInfoData=^DHCPHTMPPRESCNO("DHCST","web.DHCOutPhDisp","QueryLocOutPatItm",PID,"PRESCNO",yprescno,psub,IncIndex)
	..s orditem=$p(prescInfoData,"^",1)
	..s dispqty=$p(prescInfoData,"^",2)
	..s dispmoney=$p(prescInfoData,"^",3)
	..s price=dispmoney/dispqty   //$p(prescInfoData,"^",4)
	..s inci=$p(prescInfoData,"^",5)
	..s dspbatchid=$p(prescInfoData,"^",6)
	..s itm=$p(orditem,"||",2)
	..s ord=$p(orditem,"||",1)
	..s priority=$p(^OEORD(ord,"I",itm,1),"^",8)     
	..s priorCode=$p($g(^OECPR(priority)),"^",1) 
	..q:$ZCVT(priorCode,"U")["OM"       
	..s dsp=+dspbatchid
	..s ordusertypedr="",ordusercare="",careprovtype="",userdoctype=""
	..s orddoctco=+$p($g(^OEORD(ord,"I",itm,1)),"^",11) 
	..s orduser=+$p($g(^OEORD(ord,"I",itm,7)),"^",1)
	..s username=$p(^SSU("SSUSR",orduser),"^",2)
	..i orduser'=""  s ordusercare=$p(^SSU("SSUSR",orduser),"^",14)
	..s orddoctnam=""
	..i orduser'="" s orddoctnam=$p(^SSU("SSUSR",orduser),"^",2)
	..i ordusercare'="" s careprovtype=$p(^CTPCP(ordusercare,1),"^",4)
	..i careprovtype'="" s userdoctype=$p(^CT("CPT",careprovtype),"^",4)
	..s doctcode=""
	..i (orddoctco'=0)&(orddoctco'="") d
	...s doctcode=$p(^CTPCP(orddoctco,1),"^",1)
	...s username=$p(^CTPCP(orddoctco,1),"^",2)
	..//s doseqty=$p($g(^OEORD(ord,"I",itm,2)),"^",1)
	..s doseqty=##class(web.DHCSTCOMMONORDER).OeoriDosage(orditm) 
	..s unitdr=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
	..i unitdr="" s doseqty=""
	..s unitdesc=$s(unitdr'="":$p($g(^CT("UOM",unitdr)),"^",2),1:"")
	..s jlflag=doseqty //_unitdesc
	..s phfragdesc=$p(##class(web.DHCSTCOMMONORDER).OeoriFreq(orditem),"^",3)
	..s duratdr=$p($g(^OEORD(ord,"I",itm,2)),"^",6)
	..s duratdesc=$s(duratdr'="":$p($g(^PHCDU(duratdr)),"^",3),1:"")
	..s instrdr=$p($g(^OEORD(ord,"I",itm,2)),"^",7)
	..s instrdesc=$s(instrdr'="":$p($g(^PHCIN(instrdr)),"^",2),1:"")
	..s skintest=""
	..s skinflag=##class(web.DHCOutPhCommon).SkinTest(orditem)
	..i (skinflag'<0)&(skinflag'="") s skintest="(-)"
	..i skinflag=-1 s skintest="(+)"
	..i skinflag=-6 s skintest="( )"
	..s phbz=##class(web.DHCOutPhCommon).GetOrdRemark(orditem)
	..s cyyf=$p($g(^OEORD(ord,"I",itm,2)),"^",8)
	..s:phbz="" phbz=cyyf
	..s:instrdesc["遵医嘱" instrdesc=phbz
	..;医嘱项
	..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast
	..s Phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(itmmast) 
	..s phtypedesc=$p(##class(web.DHCST.Common.DrugInfoCommon).GetPhcPoisonByPhcd(Phcdf),"^",3)
	..s jrflag=$s(phtypedesc["J1":"1",phtypedesc["J2":"2",1:"")
	..s admreasonid=$p($g(^OEORD(ord,"I",itm,11)),"^",18)
	..s ybcode=##class(web.DHCSTInterfaceFromElse).ArcimLinkInsu(itmmast,admreasonid)
	..;库存项
	..s itmcatdesc=$p(##class(web.DHCST.Common.DrugInfoCommon).GetArcItemCat(inci),"^",2)
	..s syflag=$s(itmcatdesc["输液":"1",1:"")
	..s factdesc="" 
	..i (rPhdrow'="")&&(dispflag=1) d
	...s inclb=..GetDispInclb(rPhdrow,dspbatchid)
	...s factdesc=$p(##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclb),"^",2)  
	..e  d
	...s factdesc=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci),"^",3)  
	..s:$F(factdesc,"-") factdesc=$p(factdesc,"-",2)
	..s reclocdr=loginloc 							// 检查登陆科室的库存,使用接受科实下面分组库存
	..s qtyend=##class(web.DHCSTSTKQTY).GetIncilValidQty(inci,reclocdr,1)
	..s unflag=""
	..i qtyend<dispqty s unflag="不够"
	..s incil=$o(^INCI("IL_LOC",reclocdr,inci,""))
	..s incilnew=inci_"||"_incil
	..s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incilnew,",","","") //改为取新的科室货位表DHCIncItmLocBin（可多货位）add wyx 2013-11-21
	..s stkchkflag=$p(stkbinret,":",1)
	..s stkbinstr=$p(stkbinret,":",2)
	..s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
	..s baseuom=+$p(^INCI(inci,1),"^",10)
	..s basuomdesc=$p($g(^CT("UOM",baseuom)),"^",2)
	..s jlflag=doseqty
	..//s dxsl=##class(web.DHCSTKUTIL).GetBuomDosage(orditem)
	..//i +dxsl'="0" d
	...//s doseqty=doseqty/dxsl
	...//i doseqty'["."  s jlflag=doseqty_basuomdesc
	..s puruom=+$p(^INCI(inci,3),"^",6)
	..s pfac=+##Class(web.DHCST.Common.UtilCommon).UOMFac(puruom,baseuom)	    
	..s pqty=dispqty/pfac
	..;转换为门诊发药单位或药房发药单位 hulihua
	..s outdispuomdr=+$p(^INCI(inci,1),"^",12)
	..s dispuomdr=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)
	..i (dispuomdr'="")&&(dispuomdr'=outdispuomdr)  d						//药房发药单位
	...s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(dispuomdr,baseuom)
	...s newunit=dispuomdr
	..e  d
	...i outdispuomdr'=""  d													//门诊发药单位
	....s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(outdispuomdr,baseuom)
	....s newunit=outdispuomdr
	...e  d
	....s Fac=1																//基本单位
	....s newunit=baseuom
	..s kcqty=qtyend/Fac
	..s qty=dispqty/Fac
	..s newunitdesc=$p($g(^CT("UOM",newunit)),"^",2)
	..s newprice=price*Fac
	..//格式化售价
	..S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(inci)
	..S StkTypeDesc=$P(CatGrpStr,"^",4)
	..S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
	..s newprice=##Class(web.DHCSTCOMMPARA).GetNumbFN(newprice,Perv,"FmtSP",1)
	..s realqty=qty
	..i (rPhdrow'="")&&(dispflag=1) d
	...s realqty= ##class(web.DHCOUTPHA.Common.CommonDisp).GetDispQty(orditem,inci) 
	...s realqty=realqty/Fac
	..s realqty=$$AddZero(realqty)
	..s incidesc=$p(^INCI(inci,1),"^",2)
	..s phdispitmstat=""
	..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",2) 
	..i (oeflag'["核实")&&(oeflag'["执行") s phdispitmstat="医嘱"_oeflag
	..i (unflag["不够")&&(dispflag'=1) s phdispitmstat="库存不足"
	..set Data=$lb(incidesc,newunitdesc,qty,newprice,dispmoney,oeflag,jlflag,phfragdesc,instrdesc,duratdesc,username,orditem,newunit,inci,stkbinstr,phtype,spec,phbz,unflag,skintest,syflag,factdesc,doctcode,jrflag,cyyf,kcqty,ybcode,realqty,phdispitmstat,$p(yprescno,"||",2),inci)
	..Set ^CacheTemp(repid,ind)=Data
	..Set ind=ind+1
	k ^DHCPHTMPPRESCNO("DHCST","web.DHCOutPhDisp","QueryLocOutPatItm",PID,"PRESCNO")
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
	
AddZero(number)
	q:$F(number,".")=0 number
	q:(number'<1)||(number'>-1) number
	s newnumber=$fn(number,"",$l($p(number,".",2)))
	q newnumber
}

/// Description:检查处方是否已作废
/// Creator:LiangQiang
/// CreatDate:2011-02-21
ClassMethod CheckNotUse(prt, phl, prescno) As %String
{
	q:prt="" 0
	s existflag=0,FINFLAG=0
	s pha="",phause="",phaok=""
	f  s pha=$o(^DHCPHARi("PRT",prt,pha)) q:pha=""  d
	.s fphldr=""
	.s fphldr=+$p(^DHCPHARW(pha),"^",3)
	.q:fphldr'=phl 
	.s phaprescno=""
	.s phaprescno=$p(^DHCPHARW(pha),"^",16)
	.q:phaprescno'=prescno
	.s phause=$p(^DHCPHARW(pha),"^",7)
	.s FINFLAG=$p(^DHCPHARW(pha),"^",6)
	.s existflag=1 
    i FINFLAG=1 q 0	//如果已经发药的不判断是否作废，打印处方能用到 2014-05-07
    i phause="1" q 1
    i existflag=0 q 1
    q:'$d(^DHCINVPRT(prt)) 1  //不存在  LiangQiang 20140416
    s prtuseflag=$p(^DHCINVPRT(prt),"^",8)
    q:prtuseflag'="N" 1  //非正常状态   LiangQiang 20140416(和计费组协定)
    q 0
}

/// Description:检查处方是否已配药
/// Creator:LiangQiang
/// CreatDate:2011-02-21
/// Input：处方号,门诊科室,检查方式, 0 ，1
/// Output:0 未配 1 已配
ClassMethod CheckBeforInsert(prescno, prt, phl = "", chkflag = "1") As %String
{
	 s m=0
     s phdisp=""
     f  s phdisp=$o(^DHCPHDISPi("PRESCNO",prescno,phdisp)) q:phdisp=""  d
     .s phdphl=$p(^DHCPHDISP(phdisp,1),"^",1)
     .q:(phl'=phdphl)&(phl'="")
     .s phprt=$p(^DHCPHDISP(phdisp),"^",2)
     .//q:(phprt'=prt)&(prt'="")
     .q:(phprt'=prt)&(prt'="")&(phprt'="")	//zhouyg 20160719 
     .s pyflag=$p(^DHCPHDISP(phdisp,1),"^",6)
     .s m=m+1
     q:(chkflag=0)&(m'=0) 1
     q:$g(pyflag)=1 1
     q 0
}

/// Description:检查处方是否已发药
/// Creator:LiangQiang
/// CreatDate:2011-02-21
/// 0 未发，1 已发
ClassMethod CheckBeforUpdate(prescno, phl = "") As %String
{
	s dspflag="C"
	s locdr=""
	i phl'="" s locdr=$p(^DHCPHLOC(phl),"^",1)   
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:ord=""  d
	.s itm=""
	.f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:itm=""  d
	..s tprescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
	..q:tprescno=""
	..q:prescno'=tprescno
	..s reclocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
	..q:(locdr'=reclocdr)&(locdr'="")
	..s oeori=ord_"||"_itm
	..s dsp=""
	..f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,dsp)) q:dsp=""  d
	...s status=$p(^DHCOEDISQTY(dsp),"^",7)
	...i status=dspflag d
	....s fyflag=1
	q:$g(fyflag)=1 1
	q 0
}

/// Description:一步式完成发药
/// Input:ordstr 部分发药信息 ,supp'=""表示补货全发,="U"表示非补货全发,=""表示非补货单个处方直接发药
/// Output:发药表ID
/// w ##class(web.DHCOutPhDisp).SAVEDATA("228251","11","42","50","50","O181107000037","","","42","1&&0&&458||2^2^16^13","")
ClassMethod SAVEDATA(prt, phl, phw, pydr, fydr, prescno, phwpos, shdr, newphw, ordstr = "", supp = "")
{
	s ^TMPDHCSTPARAMS("web.DHCOutPhDisp","SAVEDATA")=$lb(prt, phl, phw, pydr, fydr, prescno, phwpos, shdr, newphw, ordstr, supp )
    s updflag=1 //直接发药标志
    s refuseflag=##class(web.DHCOutPhCommon).GetOrdRefResultByPresc(prescno)  //yunhaibao20151113,拒绝发药不允许发药
	q:refuseflag="N" -111
    TSTART    
    i supp'="" s ErrInsert=..InsertPHDisp(prt,phl,phw,pydr,fydr,prescno,phwpos)
	i supp="" s ErrInsert=##class(web.DHCOutPhDispen).InsertPHDisp(prt,phl,phw,pydr,fydr,prescno,phwpos,"",ordstr,updflag)
	i (ErrInsert'>0)&(ErrInsert'=0)  TRo
	q:(ErrInsert'>0)&(ErrInsert'=0) ErrInsert
	i supp="U" s supp=""
	s ErrUpate=..UpdatePyd(prt,phl,pydr,fydr,prescno,shdr,phw,newphw,"",ordstr,supp)
    i +ErrUpate'>0  TRo
	q:+ErrUpate'>0 ErrUpate
	
	TCOMMIT 
	
	q ErrUpate
}

/// 门诊发药过程整理
ClassMethod Dispensing(parowid, oeori, locdr, currdt) As %String
{
	s currdate=$p(currdt,",",1)
	s currtime=$p(currdt,",",2)
	s phdrow=$p(parowid,"||",1)
	s phdsub=$p(parowid,"||",2)
    s ord=$p(oeori,"||",1)
    s itm=$p(oeori,"||",2)
 	s phper=+$p(^DHCPHDISP(phdrow,1),"^",2)  
	s user=+$p($g(^DHCPHPER(phper)),"^",5)
    s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
    s HospID=$p(^CTLOC(locdr),"^",22)
    s pid=##Class(web.DHCSTCOMMO).NewPidOEInclb()
    s oweflag1="",oweflag2="",AdmType=""
    s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)	//进价规则
    i RuleFlag=3 d
    .s oweflag1=$p(^DHCPHDISP(+parowid,2),"^",2) //在欠药管理发药时存入
    .s prescno= $p(^DHCPHDISP(+parowid,2),"^",1)
    .s adm=$p(^DHCPHDISP(+parowid),"^",7)
    .s phdprt=$p(^DHCPHDISP(+parowid),"^",2)
    .s oweflag2=$O(^DHCPHOWi(0,"PAPMI",adm,prescno,""))
    .s AdmType=$p($g(^PAADM(adm)),"^",2)
    s errCode=""
    s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
    s reinsflag=""
    s dspSub=0
    f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:(dspSub="")||(+errCode<0)  d
    .s dspbBatchId=dspId_"||"_dspSub
	.s dspInclb=$p(^DHCOEDISQTY(dspId,"I",dspSub),"^",1)
	.s dspInci=$p(^DHCOEDISQTY(dspId,"I",dspSub),"^",5) 
	.s inci=$s(dspInclb'="":+dspInclb,1:+dspInci)
    .s dspqty=$p(^DHCOEDISQTY(dspId,"I",dspSub),"^",2) 
    .s ILSub=$o(^INCI("IL_LOC",locdr,inci,"")) 
 	.i ILSub="" s errCode=-1 
 	.q:+errCode<0 
 	.s incil=inci_"||"_ILSub
    .i $$LK()<0 s errCode=-2 q    ;加锁
    .s stkqty=0
    .//批次价判断库存
    .i RuleFlag=3 d
    ..s dspFlag=##Class(web.DHCST01).GetDspClbForOut(dspbBatchId,pid,inci) 
    ..;先发药后收费模式下库存不足重写DHC_OEDispBatch
	..s payDispFlag=##class(web.DHCOUTPHA.Common.Method).GetDispBeforePay(oeori)
    ..i (payDispFlag="Y")&&(dspFlag'=1)&&(oweflag1="")&&(oweflag2="") d 
    ...s delret=##class(web.DHCSTOEDispBatch).DelDspBatch(dspbBatchId)
    ...i delret'=0 d
    ....d exit
    ....d UK
    ....s errCode=-3
    ...q:+errCode<0
    ...s reinsflag=1 
    ..q:+errCode<0
    ..;按照打包子表删除在途数
    ..d ##class(web.DHCST01).UpdInclbResQty(dspInclb,-dspqty)
    ..;wyx add "ower"考虑到欠药模式，强制重新分批次 2015-01-26 
    ..i (dspFlag'=1)||(oweflag1'="")||(oweflag2'="") d 
    ...s stkqty=##CLASS(web.DHCST01).GetInclbQty(incil,dspqty,pid,1,1)
    ..e  d
    ...s stkqty=1
    .//非批次价判断库存
    .e  d
    ..s stkqty=##CLASS(web.DHCSTSTKQTY).GetInclbQty(inci,dspqty,locdr,pid)
    .i stkqty'=1 d
    ..d exit
    ..d UK 
    ..s errCode=-4
    .q:+errCode<0 
    .s ret=0
    .i RuleFlag=3 d
    ..s ret=..InsertPhdisItmClbByBatch(parowid,pid,dspbBatchId) 
    .e  d
    ..s ret=..InsertPhdisItmClb(parowid,pid,locdr,dspbBatchId)
    .i ret'=0 d 
    ..d exit
    ..d UK 
    ..s errCode=-5
    .q:ret'=0
    .d UK 
    q:+errCode<0 errCode 
    s phdicsub=0,intrtype="F",suess=0
    f  s phdicsub=$o(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub)) q:(phdicsub="")!(phdicsub="0")!(suess'=0)  d
    .s inclb="",incqty=0,basuom="",pointer="",intrno="",user=""
    .s inclb=$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub),"^",3)
    .s incqty=+$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub),"^",1)
    .s sp=$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub),"^",7)
    .s rp=$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub),"^",5)
    .i inclb="" s suess=200
    .q:inclb=""
    .s pointer=phdrow_"||"_phdsub_"||"_phdicsub
    .i reinsflag=1 d
    ..s DspbStr=dspid_"^"_inclb_"^"_incqty_"^"_sp_"^"_rp_"^"_+inclb_"^C"
 	..s RetIns=##Class(web.DHCSTOEDispBatch).InsDspBatch(DspbStr)
 	..s insDspBatchID=$p(RetIns,"^",2)
    ..&SQL(UPDATE DHC_PHDISITMCLB SET PHDIC_DSPB_DR=:insDspBatchID WHERE PHDIC_ROWID=:pointer)
    .s err=0
    .s err=..DhcOutStkTab(pointer,intrtype)  ;处理该笔发药记录的台帐库存
    .i err<0 s suess=300 
    .q:err<0
    i suess'=0 d exit
    q:suess'=0 suess
    //修改打包表
    &sql(update sqluser.dhc_oedispensing set dsp_pointer=:parowid,dsp_type='F',dsp_status='C',dsp_date=:currdate,dsp_time=:currtime where dsp_oeori_dr=:oeori )
    i SQLCODE'=0 s suess=400
    i suess'=0 d exit
    q:suess'=0 suess
    //修改打包子表
	&sql(update DHC_OEDispBatch set DSPB_Status='C' where DSPB_DSP_ParRef=:dspId)
    i SQLCODE'=0 s suess=500
    i suess'=0 d exit
    q:suess'=0 suess
    //处理非批次价在途数
    i RuleFlag'=3 d
    .s reclocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
	.i reclocdr=locdr d
	..s dspID=""
	..f  s dspID=$o(^DHCOEDISQTY(0,"OEORI",oeori,dspID)) q:dspID=""  d
	...s dspQty=-$p($g(^DHCOEDISQTY(dspID)),"^",11)
	...d ##Class(web.DHCST01).UPDINVRESQTY(inci,locdr,dspQty) //zhouyg 20160826
	...s SqlStr=incil_"^"_3_"^"_dspQty_"^"_""_"^"_dspID_"^"_locdr
 	...s Ret=##Class(User.DHCIncReservedQtyDetail).Insert(SqlStr)	//zhouyg 20160826 
 	..
 	.
    d exit
    q 0
LK()
	l +^DHCINCIL(locdr,inci):10 e  q -1
	q 0
UK
	l -^DHCINCIL(locdr,inci)
	q
exit
	k ^TMP("DHCST","web.DHCST01","Inclb",pid)
	k ^TMPGETINCLB(pid)
}

/// 判断开医嘱保存的批次库存是否够用
/// 1-够用，0-不够用，需要重新取批次
ClassMethod GetDspClb(OeoriID As %String, pid As %String) As %String
{
 //n (OeoriID,pid)
 s retFlag=1
 s DspID=0
 f  s DspID=$o(^DHCOEDISQTY(0,"OEORI",OeoriID,DspID)) q:(DspID="")!(retFlag'=1)  d
 .s DspSub=0
 .f  s DspSub=$o(^DHCOEDISQTY(DspID,"I",DspSub)) q:(DspSub="")!(retFlag'=1)  d
 ..s inclb=$p(^DHCOEDISQTY(DspID,"I",DspSub),"^",1)
 ..s Dspqty=$p(^DHCOEDISQTY(DspID,"I",DspSub),"^",2)
 ..s Curqty=##Class(web.DHCSTSTKQTY).CurQtyINCLB(inclb)
 ..i Curqty<Dspqty s retFlag=0
 ..q:Curqty<Dspqty
 ..s rp=$p(^DHCOEDISQTY(DspID,"I",DspSub),"^",3)
 ..s sp=$p(^DHCOEDISQTY(DspID,"I",DspSub),"^",4)
 ..s ^TMP("DHCST","OEINCLB",pid,"Inclb",inclb)=Dspqty_"^"_sp_"^"_rp
 i retFlag'=1 k ^TMP("DHCST","OEINCLB",pid,"Inclb")
 q retFlag
}

/// 更新门诊收费发药中间表
ClassMethod UpdPharwin(prt, prescno, phl, newphw) As %String
{
    s phaid=""
	f  s phaid=$o(^DHCPHARi("PRESCNO",prescno,phaid)) q:phaid=""  d  //2018.03.26  zzd  忽视发票  
	.s phldr="",phwdr=""
	.s phldr=+$p(^DHCPHARW(phaid),"^",3) 
	.s locdr=$p(^DHCPHLOC(phl),"^",1)
	.s leadlocdr=..GetLeadLoc(locdr)
	.s mainphl=$o(^DHCPHLOCi("LOC",leadlocdr,""))  //主科室 lq
	.q:phldr'=mainphl
	.s phaprescno=""
	.s phaprescno=$p(^DHCPHARW(phaid),"^",16)
	.q:phaprescno'=prescno
	.s nouse=$p(^DHCPHARW(phaid),"^",7)
	.q:nouse=1
	.s $p(^DHCPHARW(phaid),"^",6)="1" 
	.s $p(^DHCPHARW(phaid),"^",10)=+$h
	.s $p(^DHCPHARW(phaid),"^",4)=newphw
    q 0
}

/// 更新发药主表
/// zhouyg 20160719 添加参数prtID
ClassMethod UpdPhDispEN(phdrowid, currdate, currtime, prtID) As %String
{
    s prtdate=currdate
    s pydate=currdate
    s pytime=currtime
    s fyflag=1
    s tmpprtdate=$p(^DHCPHDISP(phdrowid),"^",1)
    i tmpprtdate'="" d
    .s prtdate=$p(^DHCPHDISP(phdrowid),"^",1)
    .s pydate=$p(^DHCPHDISP(phdrowid,1),"^",5)
    .s pytime=$p(^DHCPHDISP(phdrowid,1),"^",7)
    &sql(update DHC_PHDISPEN set PHD_PRT_DR=:prtID, PHD_PRTDATE=:prtdate, PHD_FYDATE=:currdate, PHD_FYFLAG=:fyflag, PHD_FYTIME=:currtime, PHD_PYDATE=:pydate,  PHD_PYTIME=:pytime where PHD_ROWID=:phdrowid)
	q:SQLCODE'=0 -100
    q 0
}

/// 获取发药数量
ClassMethod getDspQty(oeori) As %String
{
	s totoalQty=0
	s dsp=""
	f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,dsp)) q:dsp=""  d 
	.s DspQty=$p(^DHCOEDISQTY(dsp),"^",2)
	.s totoalQty=totoalQty+DspQty
	q totoalQty
}

/// 获取发药时间
ClassMethod getDspDate(oeori) As %String
{
	s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,"") )
	q:dsp="" "" 
	s DspDate=$p(^DHCOEDISQTY(dsp),"^",8)
	q DspDate
}

/// Description:检查处方是否已发药
/// Creator:LiangQiang
/// CreatDate:2011-02-21
ClassMethod CheckOrdPay(prescno, phl) As %String
{
     s phdisp=""
     f  s phdisp=$o(^DHCPHDISPi("PRESCNO",prescno,phdisp)) q:phdisp=""  d 
     .s tmpphl=$p(^DHCPHDISP(phdisp,1),"^",1)
     .q:tmpphl'=phl
     .s fyflag=$p(^DHCPHDISP(phdisp),"^",4)
     q:$g(fyflag)=1 1
     q 0
}

/// Description:根据处方取发药主表id(非欠单)
/// w ##class(web.DHCOutPhDisp).GetPhdByPresc("O181031000013","228120","16")
ClassMethod GetPhdByPresc(prescno, prt, phl) As %String
{
     s phdisp=""
     s ret=""
     f  s phdisp=$o(^DHCPHDISPi("PRESCNO",prescno,phdisp)) q:phdisp=""  d
     .s tmpphl=$p(^DHCPHDISP(phdisp,1),"^",1)
     .q:tmpphl'=phl
     .s phprt=$p(^DHCPHDISP(phdisp),"^",2)
     .q:(prt'="")&&(phprt'=prt)
     .s tmpowedr=$p(^DHCPHDISP(phdisp,2),"^",2)
     .q:tmpowedr'=""
     .s ret=phdisp
     q ret
}

/// Description:检查某医嘱是否在发药表存在
/// 
ClassMethod ChkPhdOeori(prescno, prt, phl, oeori) As %String
{
     s phdisp=""
     s ret=0
     f  s phdisp=$o(^DHCPHDISPi("PRESCNO",prescno,phdisp)) q:phdisp=""  d
     .s tmpphl=$p(^DHCPHDISP(phdisp,1),"^",1)
     .q:tmpphl'=phl
     .s phprt=$p(^DHCPHDISP(phdisp),"^",2)
     .q:(phprt'=prt)&(prt'="")
     .s phdi=""
     .f  s phdi=$o(^DHCPHDI(phdisp,"PHDI",phdi)) q:phdi=""  d
     ..s phoeori=$p(^DHCPHDI(phdisp,"PHDI",phdi),"^",5)
     ..i phoeori=oeori s ret=1
     q ret
}

/// Description:得到处方类型
/// w ##class(web.DHCOutPhDisp).GetPrescType("O17021500003")
ClassMethod GetPrescType(prescno)
{
   s ord=$o(^OEORD(0,"PrescNo",prescno,"")) 
   s itm=$o(^OEORD(0,"PrescNo",prescno,ord,"") ) 
   s preason=$p(^OEORD(ord,"I",itm,11),"^",18)
   s dhcprescrow=$o(^DHCPAQPT(0,"PrescNo",prescno,""))
   i dhcprescrow'=""  d
   .s psonrow="",pson="",psoncode=""
   .s psonrow=+$p(^DHCPAQPT(dhcprescrow),"^",2)
   .s pson=+$p(^DHCPAADMPrescType(psonrow),"^",2)
   .s PrescTypeCode=pson
   .s presctypedesc=$p(^PAC("ADMREA",PrescTypeCode),"^",2)
   e  d
   .s PrescTypeCode=preason
   .i (PrescTypeCode'="")&(PrescTypeCode'="undefined")  d
   ..s presctypedesc=$p(^PAC("ADMREA",PrescTypeCode),"^",2)  
   .e  d 
   ..s presctypedesc="自费"
   q presctypedesc
}

/// Description:判断登录科室是否与医嘱接收科室一致
/// OutPut:1 - 真  0 -假
ClassMethod ChkRecLocAndLogin(prescno, loginlocdr)
{
   s ord=$o(^OEORD(0,"PrescNo",prescno,"")) 
   s itm=$o(^OEORD(0,"PrescNo",prescno,ord,"") ) 
   s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
   q:recplocdr="" 0
   q:recplocdr'=loginlocdr 0
   q 1
}

/// Description: 获取欠药单完成状态
ClassMethod GetOwdStatus(owedr)
{
  q:owedr="" ""	
  s owestatus=$p(^DHCPHOW(owedr),"^",8)
  s oweretdate=$p(^DHCPHOW(owedr),"^",10)
  i oweretdate'="" s owestatus=""
  q owestatus
}

/// Description: 更新欠药单完成状态
ClassMethod UpdOweListStatus(owedr)
{
    s $p(^DHCPHOW(owedr),"^",8)=2
    q 0
}

/// Description: 检测该处方号下所有医嘱是否都已标记已发状态，如果没有则更新
/// Input:医嘱Rowid
ClassMethod UpdOeDispen(prescNo)
{
	s pointer=""
    s dsptype="F"
    s dspstatus="TC"
    s currdate=+$h
    s currtime=$p($h,",",2)
    s exit=0
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescNo,ord)) q:(ord="")!(exit=1)  d
	.s chl=""
	.f  s chl=$o(^OEORD(0,"PrescNo",prescNo,ord,chl) ) q:(chl="")!(exit=1)  d
	..s oeori=ord_"||"_chl
	..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",chl,1),"^",13)),"^",1)                                      
    ..s payflag=$p(^OEORD(ord,"I",chl,3),"^",5)
	..q:(payflag'="P")&(oeflag'="V")&(oeflag'="E")  //急诊留观未交费过滤掉停医嘱
	..s prcode="" 
	..s pr=+$p(^OEORD(ord,"I",chl,1),"^",8)
    ..i pr'=0 s prcode=$p(^OECPR(pr),"^",1)
    ..q:prcode["OM" 
    ..//q:##class(web.DHCSTInterfaceFromElse).ICheckOrderIsRefundAudit(oeori)="Y"
	..s dsp=""
    ..f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,dsp)) q:dsp=""  d
    ...s dspcoll=$p(^DHCOEDISQTY(dsp),"^",7)
    ...q:dspcoll'=dspstatus
    ...s dspstatus="C"
    ...&sql(update sqluser.dhc_oedispensing set dsp_pointer=:pointer,dsp_type=:dsptype,dsp_status=:dspstatus,dsp_date=:currdate,dsp_time=:currtime where DSP_RowId=:dsp )
    ...i SQLCODE'=0 d
    ....s exit=1
    q exit
}

/// 更新原处方接收科室为现操作药房科室 liangqiang
ClassMethod UpdOrdRecloc(orditm, phl, pointer, pydr)
{
	//1.改中间表接收科室
	s ord=+orditm
	s itm=$p(orditm,"||",2)
	s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)
	q:prescno="" -1
	s reclocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
	q:reclocdr="" -5
	s updlocdr=$p(^DHCPHLOC(phl),"^",1)
	q:updlocdr="" -2
	q:reclocdr=updlocdr 0
	s phar=$o(^DHCPHARi("PRESCNO",prescno,""))
	i phar'="" &sql(update dhc_pharwin set PHA_PHL_DR=:phl where Pha_PrescNo=:prescno)
	i phar'="" d
	..i SQLCODE'=0 d
	...s ret=-1
	q:$g(ret)=-3
	/*/2.清在途数
	//s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	//s qty=$p(^DHCOEDISQTY(dsp),"^",2)
	s reclocdr=$p(^OEORD(ord,"I",itm,3),"^",6) q:reclocdr="" -5
	s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)                              
    s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci="" -6
    s ch=$o(^INCI("IL_LOC",reclocdr,inci,"")) q:ch="" -7
    s IMILROW=inci_"||"_ch
    S IM=inci
    //S QTY=-qty
	L +^INCI(IM,"IL",$P(IMILROW,"||",2)):10 E  Q -444
    S IMILREC=$g(^INCI(IM,"IL",$P(IMILROW,"||",2)))
    S Resqty=$p(IMILREC,"^",10)
    I Resqty+QTY<0 s Resqty=-QTY  ;当qty<0时,消去resqty时到零为止
    S $p(IMILREC,"^",10)=Resqty+QTY
    S ^INCI(IM,"IL",$P(IMILROW,"||",2))=IMILREC 
    L -^INCI(IM,"IL",$P(IMILROW,"||",2))
    */
    //3.修改接收科室
    &sql(update OE_OrdItem set OEORI_RecDep_DR=:updlocdr where OEORI_RowId=:orditm)
	i SQLCODE'=0 Q -8
	//4.修改配药表原配药人
	&sql(update dhc_phdispen set PHD_PHL_DR=:phl,PHD_PHP_PYDR=:pydr where PHD_ROWID=:pointer)
	i SQLCODE'=0 Q -11
	//5.更新DHC_OEDispensing的接收科室 zhouyg 20160826
	&sql(update sqluser.dhc_oedispensing set DSP_RecDep_DR=:updlocdr where dsp_oeori_dr=:oeori )
    i SQLCODE'=0 q -12
    //6.清除原接收科室的在途数，记录在途数明细 zhouyg 20160826
	s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)                              
    s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci="" -6
    s ch=$o(^INCI("IL_LOC",reclocdr,inci,"")) q:ch="" -7
    s IMILROW=inci_"||"_ch
    S IM=inci
    s HospID=$p(^CTLOC(reclocdr),"^",22)
 	s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)	//进价规则
    i RuleFlag'=3 d
	.s dspID=""
	.f  s dspID=$o(^DHCOEDISQTY(0,"OEORI",orditm,dspID)) q:dspID=""  d
	..s dspQty=-$p($g(^DHCOEDISQTY(dspID)),"^",11)
	..d ##Class(web.DHCST01).UPDINVRESQTY(IM,reclocdr,dspQty) //zhouyg 20160826
	..s SqlStr=IMILROW_"^"_3_"^"_dspQty_"^"_""_"^"_dspID_"^"_reclocdr
 	..s Ret=##Class(User.DHCIncReservedQtyDetail).Insert(SqlStr)	//zhouyg 20160826 
	Q 0
}

/// Description:批量确认发掉门诊基数科室处方,并生成补货记录表(DHC_PHSUPPLY)
/// Creator:LiangQiang
/// CreatDate:2012-07-31
/// Output:0 失败  1成功
ClassMethod SAVESUPPDATA(pid, GFydr, GPhl, GPydr)
{
	
	s data=^TMP("DHCOutPh","DHCOutPhDisp","QueryLocOutPatExecute",pid,1)
	s prescno=$p(data,"^",4) 
	s user=$p(^DHCPHPER(GFydr),"^",5)
	s phlocdr=$p(^DHCPHLOC(GPhl),"^",1)
	s supp=##Class(web.DHCSTPHSUPPLY).SavePHOutSUPPLY(prescno,user,phlocdr)
	s suess=0
	s i=""
	f  s i=$o(^TMP("DHCOutPh","DHCOutPhDisp","QueryLocOutPatExecute",pid,i)) q:i=""  d
	.s data=^TMP("DHCOutPh","DHCOutPhDisp","QueryLocOutPatExecute",pid,i)
	.s prt=$p(data,"^",1)
	.s phl=$p(data,"^",2)
	.s phw=$p(data,"^",3)
	.s pydr=GPydr
	.s fydr=GFydr
	.s prescno=$p(data,"^",4) 
	.s refuseflag=##class(web.DHCOutPhCommon).GetOrdRefResultByPresc(prescno)  //yunhaibao20151113,拒绝发药不允许发药
	.q:refuseflag="N"
	.s ret=##class(web.DHCOUTPHA.Disp.DirectDisp).SAVEDATA(prt, GPhl, phw, pydr, fydr, prescno, "", "", "", "",supp)
	.i ret>0 s suess=1
	.
	i suess=0 d
	.&sql(delete from DHC_PHSUPPLY where SUPP_RowID=:supp)

	q:suess=0 0
	q supp
}

/// 判断医嘱开单科室是含关联留观观察室
/// 0 不符条件  1 符合条件
ClassMethod ChkLGDocLoc(SpecialID, adm)
{
	q:SpecialID="" 1
	s currwarddr=$p(^PAADM(adm),"^",70)
	q:currwarddr="" 0
	s ctlocdr=$p(^PAWARD(currwarddr),"^",5)
	q:ctlocdr="" 0
	q:ctlocdr'=SpecialID 0
	q 1
}

/// creator:yunhaibao
/// createdate:20151022
/// description:按处方号获取有效医嘱串,用于判断欠费
/// w ##class(web.DHCOutPhDisp).GetOrdQtyStr("E15072400024")
ClassMethod GetOrdQtyStr(prescno)
{
	s oeoriqtystr=""
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:ord=""  d
	.q:+ord=0
	.s orditm=""
	.f  s orditm=$o(^OEORD(0,"PrescNo",prescno,ord,orditm)) q:orditm=""  d
	..q:+orditm=0
	..s oeori=ord_"||"_orditm
    ..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",orditm,1),"^",13)),"^",1)                                     
    ..q:(oeflag'="V")&(oeflag'="E")
	..s oeoriqty=..getDspQty(oeori)
	..i oeoriqtystr="" s oeoriqtystr=oeori_$c(2)_oeoriqty
	..e  s oeoriqtystr=oeoriqtystr_"^"_oeori_$c(2)_oeoriqty
	q oeoriqtystr
}

/// creator:     yunhaibao
/// createdate:  20160307
/// description: 批次价模式单独处理门诊发药在途以及欠药模式
/// 			 部分发药时,按已发数处理在途,根据累加批次打包表中数量,与已发数比较确定处理哪个批次在途
/// 			 如果发药重新确定批次,则原在途先全部处理,在新增分配批次后的在途
/// input:		 医嘱id,数量(按正负传)
/// w ##class(web.DHCOutPhDisp).MinusResQtyByDisp("1919||3","-6")
ClassMethod MinusResQtyByDisp(oeori, minusqty)
{
	s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	i minusqty<0  s minusqty=-minusqty
	s dispedtotalqty=0 //已发数合计
	s dispid=""
	f  s dispid=$o(^DHCPHDI(0,"OEORI",oeori,dispid)) q:dispid=""  d
	.q:$p(^DHCPHDISP(dispid),"^",4)'="1" ///过滤未发
	.s dispsub=""
	.f  s dispsub=$o(^DHCPHDI(0,"OEORI",oeori,dispid,dispsub)) q:dispsub=""  d
	..q:$p(^DHCPHDI(dispid,"PHDI",dispsub),"^",10)'="1" 
	..s dispedqty=$p(^DHCPHDI(dispid,"PHDI",dispsub),"^",4)
	..s dispedtotalqty=dispedtotalqty+dispedqty	
	//如果已发数=oedispsing的数量
	s dhcoedispqty=$p(^DHCOEDISQTY(dsp),"^",5)
	q:dhcoedispqty=dispedtotalqty 0 //已发数等于医嘱数,不再处理在途
	s accqty=dispedtotalqty+minusqty //累计数
	s minusret=0,dspsub=0,successminus=0,dspbatchtotalqty=0
 	f  s dspsub=$o(^DHCOEDISQTY(dsp,"I",dspsub)) q:(dspsub="")||(minusret<0)||(successminus>0)  d
 	.s dspbatchinclb=$p(^DHCOEDISQTY(dsp,"I",dspsub),"^",1)
 	.s dspbatchqty=$p(^DHCOEDISQTY(dsp,"I",dspsub),"^",2)
 	.s dspbatchtotalqty=dspbatchtotalqty+dspbatchqty
 	.s tmpminustqty=0
 	.i dspbatchqty>=accqty d
 	..s tmpminustqty=minusqty
 	.e  d
 	..i dspbatchqty>dispedtotalqty d //还有减的余地
 	...s tmpminustqty=dspbatchqty-dispedtotalqty
 	..e  d
 	...s tmpminustqty=0
 	.s minusret=##class(web.DHCST01).UpdInclbResQty(dspbatchinclb,-tmpminustqty)
 	.s minusqty=minusqty-tmpminustqty
 	.s accqty=accqty-dspbatchqty //每次循环减已发
 	.s dispedtotalqty=dispedtotalqty-dspbatchqty
 	.i dispedtotalqty<0 s dispedtotalqty=0
 	.i minusqty'>0 s successminus=successminus+1
	q minusret
}

/// creator:yunhaibao
/// createdate:20160602
/// description:根据发药记录判断皮试状态是否允许发药
/// 0-允许,1-不允许
ClassMethod CheckSkinTestByPhd(phdrow)
{
	q:phdrow="" 0
	s checkskintest=0
	s dhcphditm=""
	f  s dhcphditm=$o(^DHCPHDI(phdrow,"PHDI",dhcphditm)) q:(dhcphditm="")!(checkskintest=2)  d
    .s oeori=$p(^DHCPHDI(phdrow,"PHDI",dhcphditm),"^",5)
    .s qty=+$p(^DHCPHDI(phdrow,"PHDI",dhcphditm),"^",4)
    .q:qty=0
    .s skintest=##class(web.DHCSTPCHCOLLS2).SkinTest(oeori)
    .i (checkskintest'=2)&&(skintest<0) d //存在原液允许发药
    ..s checkskintest=$s(skintest=-5:2,1:1)
    q:checkskintest=2 0
	q checkskintest
}

/// Description:配药完成时更新门诊收费发药中间表
/// Creator:	hulihua
/// CreateDate:	2016-08-02
/// Table:      DHC_PHARWIN
/// Input:		phaid-中间表ID,prescno-处方号,box-篮子号
/// Output:
/// Return：    0-成功，非0-失败
/// w ##class(web.DHCOutPhDisp).UpdPyPharwin("0","85","")
ClassMethod UpdPyPharwin(phaid, prescno, box = "") As %String
{
	q:(phaid="")||(prescno="") -12
	s printflag="1"
	s sysdate=$p($h,",",1)
	s systime=$p($h,",",2)
	s papmidr=##class(web.DHCOutPhCommon).GetPapmiByPresc(prescno)
    &sql(update DHC_PHARWIN set PHA_PAPMI_DR=:papmidr, PHA_PRINTFLAG=:printflag, 
    PHA_PRINTDATE=:sysdate, PHA_PRINTTIME=:systime, pha_lcdserialno=:box 
    where PHA_ROWID=:phaid)
	q:SQLCODE'=0 -13
    q 0
}

/// creator:	yunhaibao
/// createdate: 2016-01-03
/// description:判断处方内医嘱是否存在退药申请,发药配药前判断
/// 	output:	w ##class(web.DHCOutPhDisp).CheckPrescIsRefundAudit("O17010300001")	
ClassMethod CheckPrescIsRefundAudit(prescNo)
{
	q "" //此功能需计费更新
	s returnstring=""
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescNo,ord)) q:ord=""  d
	.s chl=""
	.f  s chl=$o(^OEORD(0,"PrescNo",prescNo,ord,chl) ) q:chl=""  d
	..s oeori=ord_"||"_chl
	..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",chl,1),"^",13)),"^",1)                                      
    ..s payflag=$p(^OEORD(ord,"I",chl,3),"^",5)
	..q:(payflag'="P")&(oeflag'="V")&(oeflag'="E")  //急诊留观未交费过滤掉停医嘱
	..s prcode="" 
	..s pr=+$p($g(^OEORD(ord,"I",chl,1)),"^",8)
    ..i pr'=0 s prcode=$p(^OECPR(pr),"^",1)
    ..q:prcode["OM" 	
    ..s refundret=##class(web.DHCSTInterfaceFromElse).ICheckOrderIsRefundAudit(oeori)
    ..i refundret="Y" d
    ...s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2) 
    ...s arcch=+$p(arcimid,"||",1)
    ...s arcsub=+$p(arcimid,"||",2)
    ...s arcimdesc="　"_$p($g(^ARCIM(arcch,arcsub,1)),"^",2)
    ...s returnstring=$s(returnstring="":arcimdesc,1:returnstring_$c(13)_arcimdesc)
    q returnstring
}

/// Description		检查处方是否已作废 (医嘱是否结算)
/// Creator			zhaozhiduan
/// CreatDate		2018.03.26
/// Input			处方号，门诊配置科室
/// Output			0---正常；1---不正常
/// Other			w ##class(web.DHCOutPhDisp).CheckNotUseNew("O181203000002",11)
ClassMethod CheckNotUseNew(prescNo, phLocId) As %String
{
	q:prescNo="" 0
    s tmpOrd=$o(^OEORD(0,"PrescNo",prescNo,""))
    s tmpOrdItm=$o(^OEORD(0,"PrescNo",prescNo,tmpOrd,"")) 
	s oeori=tmpOrd_"||"_tmpOrdItm
	s payDispFlag=##class(web.DHCOUTPHA.Common.Method).GetDispBeforePay(oeori)
	q:payDispFlag="Y" 0
	s existFlag=0
	s finalFlag=0
	s pharId="",noUserFlag="",phaok=""
	f  s pharId=$o(^DHCPHARi("PRESCNO",prescNo,pharId)) q:pharId=""  d
	.s phaPhlId=+$p(^DHCPHARW(pharId),"^",3)
	.q:phaPhlId'=phLocId 
	.s noUserFlag=$p(^DHCPHARW(pharId),"^",7)
	.q:noUserFlag=1
	.s finalFlag=$p(^DHCPHARW(pharId),"^",6)
	.s existFlag=1 
    i finalFlag=1 q 0	// 已发药发药的不判断是否作废,打印处方能用到
    i noUserFlag="1" q 1
    i existFlag=0 q 1
    s retFlag=1			// 一个已缴费即为正常
    s billFlag="P"
    s num=0
	s ordId=""
	f  s ordId=$o(^OEORD(0,"PrescNo",prescNo,ordId)) q:(ordId="")||(retFlag="0")  d
	.s ordItm=""
	.f  s ordItm=$o(^OEORD(0,"PrescNo",prescNo,ordId,ordItm)) q:(ordItm="")||(retFlag="0")  d
	..s billStatus=$p(^OEORD(ordId,"I",ordItm,3),"^",5)
	..i billStatus=billFlag d
	...s retFlag=0
    q:retFlag'=0 1  //非正常状态 
    q 0
}

/// Creator			
/// CreatDate		2018.03.26
/// Description		检查处方是否已配药
/// Input			处方号,门诊科室,判断标志(判断节点：0-配药,1-配药确认)
/// Output			0-未配；1-已配
ClassMethod CheckBeforInsertNew(prescno, phl = "", chkflag = "1") As %String
{
	 s m=0
	 s pyflag=""
     s phdisp=""
     f  s phdisp=$o(^DHCPHDISPi("PRESCNO",prescno,phdisp)) q:(phdisp="")||(pyflag=1)  d
     .s phdphl=$p(^DHCPHDISP(phdisp,1),"^",1)
     .q:(phl'=phdphl)&(phl'="")
     .s pyflag=$p(^DHCPHDISP(phdisp,1),"^",6)
     .s m=m+1
     q:(chkflag=0)&(m'=0) 1
     q:$g(pyflag)=1 1
     q 0
}

/// Creator		zzd
/// CreatDate	2018.10.15
/// Description	根据处方获取处方金额和处方缴费类型
/// w ##class(web.DHCOutPhDisp).GetPrescAmt("O181019000025",314)
ClassMethod GetPrescAmt(PrescNo, RecLoc, FYFlag = "")
{
	s Sunmoney=0,rpamt=0
	s hospdr=""
	i RecLoc'="" d
	.s hospdr=$P(^CTLOC(RecLoc),"^",22)
	s Ord=$o(^OEORD(0,"PrescNo",PrescNo,""))
	q:Ord="" ""
	s admId=$p(^OEORD(Ord),"^",1)
	s admType=$p(^PAADM(admId),"^",2)
	s PrescTypeDesc=""
	s Itm=""
	f  s Itm=$o(^OEORD(0,"PrescNo",PrescNo,Ord,Itm)) q:Itm=""  d
	.s Arc=$p(^OEORD(Ord,"I",Itm,1),"^",2)
	.s ArcCatId=$p($g(^ARCIM(+Arc,$p(Arc,"||",2),1)),"^",10)
    .q:+ArcCatId=0
    .s ArcCatType=$p($g(^ARC("IC",+ArcCatId)),"^",7)
    .q:ArcCatType'="R"
    .s DispLoc=+$p(^OEORD(Ord,"I",Itm,3),"^",6)
	.q:DispLoc=0
	.q:(RecLoc'="")&&(RecLoc'=DispLoc) 
	.s Money=0
	.i PrescTypeDesc="" d
	..s preason=$p(^OEORD(Ord,"I",Itm,11),"^",18)
	..i preason'="" s PrescTypeDesc=$p(^PAC("ADMREA",preason),"^",2)
    .s BillFlag=$p(^OEORD(Ord,"I",Itm,3),"^",5) 
    .s OrdItm=Ord_"||"_Itm
    .s oeflag=$p(^OEC("OSTAT",$p(^OEORD(Ord,"I",Itm,1),"^",13)),"^",1)       
	.i FYFlag'=1 q:oeflag="D"
	.s dsp=$o(^DHCOEDISQTY(0,"OEORI",OrdItm,""))
	.q:dsp=""
	.s dspdate=$p(^DHCOEDISQTY(dsp),"^",8)
	.i dspdate="" s dspdate=+$h
	.i $d(^DHCOEDISQTY(dsp,"I")) d
	..s dspSub=0
	..f  s dspSub=$o(^DHCOEDISQTY(dsp,"I",dspSub)) q:dspSub=""  d
	...s dspInci=$p(^DHCOEDISQTY(dsp,"I",dspSub),"^",5) 
	...s dspInclb=$p(^DHCOEDISQTY(dsp,"I",dspSub),"^",1) 
	...s Buom=$p(^INCI(dspInci,1),"^",10)
	...s qty=$p(^DHCOEDISQTY(dsp,"I",dspSub),"^",2)
	...i dspInclb="" s dspInclb=dspInci
	...s dspbat=dsp_"||"_dspSub
	...i (BillFlag="P")&&(admType'="H") d
	....s RetStr=##class(web.DHCOutPhCommon).GetBasePriceByOe(OrdItm,dspbat)
	....s Money=$p(RetStr,"^",2)
	...e  d
	....s ordprice=##class(web.DHCSTPRICE).GetSp(dspInclb,+dspdate,Buom,hospdr,"","")	//批次价调价后发药按调价后价格
	....s Money=qty*ordprice
	...s rp=##class(web.DHCSTPRICE).GetRp(dspInclb,+dspdate,Buom,hospdr,"")
	...s rpsumamt=rp*qty
	...s rpamt=rpamt+rpsumamt
	...s Sunmoney=Sunmoney+Money
	.e  d
	..s arcitm=$p(^OEORD(Ord,"I",Itm,1),"^",2)
	..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcitm,"||",1),""))
	..q:+inci=0
	..s Buom=$p(^INCI(inci,1),"^",10)
	..s dispuomdr=$p($g(^OEORD(Ord,"I",Itm,"DHC")),"^",13)
	..i dispuomdr'="" s Buom=dispuomdr        										
    ..s qty=+$p(^OEORD(Ord,"I",Itm,9),"^",4)
    ..i (BillFlag="P")&&(admType'="H") d
    ...s RetStr=##class(web.DHCOutPhCommon).GetBasePriceByOe(OrdItm)
    ...s Money=$p(RetStr,"^",2)
    ..e  d
	...s ordprice=##class(web.DHCSTPRICE).GetSp(inci,+dspdate,Buom,hospdr,"","")	//批次价调价后发药按调价后价格
	...s Money=qty*ordprice
	..s rp=##class(web.DHCSTPRICE).GetRp(inci,+dspdate,Buom,hospdr,"")
	..s rpsumamt=rp*qty
	..s rpamt=rpamt+rpsumamt
	..s Sunmoney=Sunmoney+Money
	q Sunmoney_"^"_PrescTypeDesc_"^"_rpamt
}

/// Creator			zzd
/// CreatDate		2018.10.12
/// Description		检查处方是否已发药
/// Input			处方号,门诊科室
/// Output			0-未发；1-已发
ClassMethod CheckDispFlag(prescno, phl = "") As %String
{
	s m=0
	s fyflag=0
	s phdisp=0
	f  s phdisp=$o(^DHCPHDISPi("PRESCNO",prescno,phdisp)) q:(phdisp="")||(fyflag=1)  d
	.s phdphl=$p(^DHCPHDISP(phdisp,1),"^",1)
	.q:(phl'=phdphl)&(phl'="")
	.s fyflag=$p(^DHCPHDISP(phdisp),"^",4)
	.s m=m+1
	q fyflag
}

ClassMethod GetDispInclb(phdrow, DspBatchId) As %String
{
	q:(phdrow="") ""
	q:(DspBatchId="") ""
	s inclb=""
	s phdi=""
	f  s phdi=$o(^DHCPHDIi("DSPB",DspBatchId,phdrow,phdi)) q:(phdi="")||(inclb'="")  d
	.s phdsub=""
	.f  s phdsub=$o(^DHCPHDIi("DSPB",DspBatchId,phdrow,phdi,phdsub))  q:(phdsub="")||(inclb'="")  d
	..s inclb=$p(^DHCPHDI(phdrow,"PHDI",phdi,"INCLB",phdsub),"^",3)
	q inclb
}

}
