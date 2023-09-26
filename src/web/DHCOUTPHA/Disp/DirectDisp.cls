Import sqluser

Class web.DHCOUTPHA.Disp.DirectDisp Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator		zzd
/// CreatDate	2018.11.4
/// Input:		ordstr 部分发药信息 ,supp'=""表示补货全发,="U"表示非补货全发,=""表示非补货单个处方直接发药
/// Output:		发药表ID
/// 			w ##class(web.DHCOutPhDirectDispen).SAVEDATA("228270","12","36","60","61","O181108000011","","","36","1&&0&&470||4^1^5^23^548","")
/// 			w ##class(web.DHCOutPhDirectDispen).SAVEDATA("228270","12","","61","61","O181108000011","","","","1&&0&&470||4^2^4^23&&960","") 欠药		
ClassMethod SAVEDATA(prt, phl, phw, pydr, fydr, prescno, phwpos, shdr, newphw, ordstr = "", supp = "")
{

	s ^TMPDHCSTPARAMS("web.DHCOutPhDispen","SAVEDATA")=$lb(prt, phl, phw, pydr, fydr, prescno, phwpos, shdr, newphw, ordstr, supp )
    s updflag=1 //直接发药标志
    s refuseflag=##class(web.DHCOutPhCommon).GetOrdRefResultByPresc(prescno)  		//拒绝发药不允许发药
	q:refuseflag="N" -111_"^"_"处方已拒绝发药，不允许发药"
    TSTART    
    
    i supp'="" s ErrInsert=..InsertPHDisp(prt,phl,phw,pydr,fydr,prescno,phwpos)				//非欠药
	i supp="" s ErrInsert=##class(web.DHCOUTPHA.Disp.Dispen).InsertPHDisp(prt,phl,phw,pydr,fydr,prescno,phwpos,"",ordstr,updflag)
	i (ErrInsert'>0)&(ErrInsert'=0)  TRo
	q:(ErrInsert'>0)&(ErrInsert'=0) ErrInsert
	i supp="U" s supp=""
	s ErrUpate=..UpdatePyd(prt,phl,pydr,fydr,prescno,shdr,phw,newphw,"",ordstr,supp)

    i +ErrUpate'>0  TRo
	q:+ErrUpate'>0 ErrUpate
	s patId=$p($g(^DHCPHDISP(ErrUpate)),"^",7)
	s phOweId=$o(^DHCPHOWi(0,"PAPMI",patId,prescno,""),-1)
	i phOweId'="" d
	.s origPhOweId=$p(ordstr,"&&",4)
	.q:phOweId=origPhOweId
	.s rebOwe=##class(web.DHCOUTPHA.Disp.Dispen).RebuildPhOweItm(phOweId)
	TCOMMIT 
	
	q ErrUpate
}

ClassMethod InsertPHDisp(prt As %Library.String = "", phl As %Library.String = "", phw As %Library.String = "", pydr As %Library.String = "", fydr As %Library.String = "", prescno As %Library.String = "", phwpos As %Library.String = "")
{
	k InsertPHDispData
	s loclog=%session.Data("LOGON.CTLOCID")
	s paramPropStr=##class(web.DHCOUTPHA.Common.Method).GetParamProp("",loclog,"")
	s NeedSkinTest=$p(paramPropStr,"^",1) //皮试配置,为Y时需要判断
	s chkreclocflag=##class(web.DHCOutPhCommon).GetChkRecLocFlag()

	s pid=##CLASS(web.DHCSTKUTIL).GetOutDispCounter()
	s sysdate="",systime="",phperson=""
	s sysdate=$p($h,",",1)
	s systime=$p($h,",",2)

	
	s ctlocdr=+$p(^DHCPHLOC(phl),"^",1)
	s hospId=$p(^CTLOC(ctlocdr),"^",22)
	s cyflag=$p(^DHCPHLOC(phl),"^",6)				//草药科室标志
	s papmidr=##class(web.DHCOutPhCommon).GetPapmiByPresc(prescno)		//患者id	PA_PatMas
	
	s pharw="",winpycode=""
	s pha=""
	f  s pha=$o(^DHCPHARi("PRESCNO",prescno,pha),-1) q:pha=""  d        
	.s fphldr="" 
	.s fphldr=+$p(^DHCPHARW(pha),"^",3)
	.q:(fphldr'=phl)&(chkreclocflag=1)
	.s pharw=+$p(^DHCPHARW(pha),"^",4)
    i pharw'="" s winpycode=##class(web.DHCOutPhTQDisp).GetWinDayPyCode(pharw)			//一个计数
	
	l +^DHCOEDISPENSING(prescno):5  e  q -11_"^"_"处方加锁失败"   ;加锁
	
	s chkerr=##class(PHA.OP.COM.Method).ChkPreIfNotUse(prescno,phl)			 
    i chkerr=1 d unlock
	q:chkerr=1 -12_"^"_"处方已作废"   
	
	s chkerr=##class(web.DHCOutPhDisp).CheckBeforInsertNew(prescno,phl,0)
	i (chkerr=1) d unlock
	q:chkerr=1 0
	
	s patadm=##class(web.DHCOutPhDisp).getadm(prescno)
	
	s payMode=##class(PHA.FACE.IN.Com).IStayPayModeByEpisodeID(hospId)	
	TSTART
	Set $ZT="troll"
	
	s fyflag="0"
	s pyflag="1"
	s pyuserid=pydr
	s prtflag=1  								//打印标志
	
	&sql(insert into SQLUSER.dhc_phdispen
	(phd_prtdate,phd_prt_dr,phd_papmi_dr,phd_phl_dr,phd_phw_dr,
	 phd_pydate,phd_pytime,phd_prescno,phd_pattype,phd_serialno,PHD_PRINTFLAG,
     PHD_OWE_DR,PHD_PYFLAG,PHD_FYFLAG,PHD_PHP_PYDR,PHD_PYEDDATE,PHD_PYEDTIME)
	values
	(:sysdate,:prt,:papmidr,:phl,:pharw,
	 :sysdate,:systime,:prescno,:phwpos,:winpycode,:prtflag,
	 :owedr,:pyflag,:fyflag,:pyuserid,:sysdate,:systime)
	)
	i SQLCODE'=0 TRo
	i SQLCODE'=0 d unlock
	i SQLCODE q -15_"^"_"插入主表失败"_","_SQLCODE
	s phdrow=+$g(%ROWID)
	
    
	s insubsuess=0  
	s arcdesc=""
	
	s m=0
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:(ord="")!(insubsuess'=0)  d
	.s itm=""
	.f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:(itm="")!(insubsuess'=0)  d
	..s oeori=ord_"||"_itm
	..s nouseitm=""
	..q:##class(web.DHCSTInterfaceFromElse).ICheckOrderIsRefundAudit(oeori)="Y" //已做退费申请
	..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
	..s arcdesc=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),1),"^",2)
	..s EmLGflag=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",17)	
	..s reclocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
    ..q:(chkreclocflag=1)&&(ctlocdr'=reclocdr)   			//是否需要判断科室
	..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)                                      
    ..s payflag=$p(^OEORD(ord,"I",itm,3),"^",5)
	..q:(payflag'="P")&&(oeflag'="V")&&(oeflag'="E")  		//急诊留观未交费过滤掉停医嘱 
	..s priority=$p(^OEORD(ord,"I",itm,1),"^",8)    
	..s (priordesc,priorcode)=""
	..i priority'="" d
	...s priordesc=$p(^OECPR(priority),"^",2)
	...s priorcode=$p(^OECPR(priority),"^",1)
	..q:priordesc["自备"
    ..q:priorcode["OM" 
    ..i NeedSkinTest="Y" d
    ...s checkskintest=##class(web.DHCSTCOMMONORDER).OeoriSkinTest(oeori)
	...i (+$p(checkskintest,"^")<0) s insubsuess=-123 
	...q:insubsuess=""
	..s (qty,money)=0
	..s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,"")) 
	..q:dspId=""
	..i $d(^DHCOEDISQTY(dspId,"I"))  d
	...k ExistInci										//清除数组,数组记录的是库存项
	...s dspSub=0
	...f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
	....s dspInci=$p(^DHCOEDISQTY(dspId,"I",dspSub),"^",5) 
	....s dspqty=$p(^DHCOEDISQTY(dspId,"I",dspSub),"^",2)
	....s ExistInci(dspInci)=$g(ExistInci(dspInci))+dspqty
	...s Inci=0
	...f  s Inci=$o(ExistInci(Inci)) q:(Inci="")||((insubsuess'=0))  d
	....s qty=ExistInci(Inci)
	....s ch=$o(^INCI("IL_LOC",ctlocdr,Inci,""))
	....i ch="" s insubsuess=10
	....q:ch=""
    ....s incil=Inci_"||"_ch
    ....s inciQty=##class(web.DHCSTSTKQTY).GetPhaQty(incil,qty)
	....i inciQty=0 s insubsuess=10
    ....q:inciQty=0
    ..e  d  	//医嘱改造前的数据
    ...s qty=##class(web.DHCOutPhDisp).getDspQty(oeori)
	...
	...s Inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),""))
	...q:Inci=""
	...s ch=$o(^INCI("IL_LOC",ctlocdr,Inci,""))
	...i ch="" s insubsuess=10
	...q:ch=""
    ...s incil=Inci_"||"_ch
    ...s inciQty=##class(web.DHCSTSTKQTY).GetPhaQty(incil,qty)
	...i inciQty=0 s insubsuess=10
    ...q:inciQty=0
	..s m=m+1
	..&sql(insert into SQLUSER.DHC_PHDISITEM(phdi_phd_parref,phdi_childsub,phdi_oeori_dr)values(:phdrow,:m,:oeori))
	..i SQLCODE'=0 s insubsuess=11 q
	..i EmLGflag="1" d
	...s oeore=$p(^DHCOEDISQTY(dspId),"^",3)
	...q:oeore=""
	...s dspQty=$p(^DHCOEDISQTY(dspId),"^",2)
	...s InsertPHDispData("CheckArrearsNew",oeore)=dspQty
	i (payMode=1)&&($g(EmLGflag)=1) d
	.s oeordqtystr=""
	.s oeore=""
	.f  s oeore=$o(InsertPHDispData("CheckArrearsNew",oeore)) q:oeore=""  d
	..s oeoreqtystr=oeore_$c(2)_InsertPHDispData("CheckArrearsNew",oeore)
	..i oeordqtystr="" s oeordqtystr=oeoreqtystr
	..e  s oeordqtystr=oeordqtystr_"^"_oeoreqtystr
	.s AmtRet=##class(web.DHCSTPCHCOLLS2).CheckArrearsNew("",patadm,oeordqtystr,loclog)						
    .i (AmtRet="N") s insubsuess=100
	k InsertPHDispData
	i (m=0)&&(insubsuess=0) s insubsuess=12
	i insubsuess'=0 Tro
	i insubsuess'=0 d unlock
	q:insubsuess=10 -17_"^"_arcdesc_"库存不足"
	q:insubsuess=11 -18_"^"_"插入明细错误"
	q:insubsuess=12 -19_"^"_"无符合的明细数据"
	q:insubsuess=100 -20_"^"_"对方已欠费"
	q:insubsuess=-123 -21_"^"_"皮试不合格"
	q:insubsuess'=0 -22_"^"_insubsuess

	s phaid=""
	f  s phaid=$o(^DHCPHARi("PRESCNO",prescno,phaid)) q:(phaid="")!(insubsuess'=0)  d   
	.s phldr=+$p(^DHCPHARW(phaid),"^",3)
	.q:(phldr'=phl)&(chkreclocflag=1)
	.s ret=##class(web.DHCOutPhDisp).UpdPyPharwin(phaid,prescno)
	.s insubsuess=ret
	q:insubsuess'=0 -23_"^"_"更新中间表失败"_","_insubsuess

	TCOMMIT
	d unlock
	q phdrow
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

ClassMethod UpdatePyd(prt As %Library.String = "", phl As %Library.String = "", pydr As %Library.String = "", fydr As %Library.String = "", prescno As %Library.String = "", shdr As %Library.String = "", phw As %Library.String = "", newphw As %Library.String = "", pycode As %Library.String = "", ordstr = "", supp = "")
{
	s owedr=$p(ordstr,"&&",4)
	s currdate=$p($h,",",1)
	s currtime=$p($h,",",2)
	s currdt=currdate_","_currtime
	s ctloc=+$P(^DHCPHLOC(phl),"^",1)
	s locdr=$p(^DHCPHLOC(phl),"^",1)
	s paramPropStr=##class(web.DHCOUTPHA.Common.Method).GetParamProp("",ctloc,"")
	s NeedSkinTest=$p(paramPropStr,"^",1) //皮试配置,为Y时需要判断
	s leadlocdr=##class(web.DHCOutPhDisp).GetLeadLoc(locdr)
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
	s phdrow="0",pharow="",ret=""

    l +^DHCOEDISPENSING(prescno):5  e  q -101_"^"_"处方加锁失败"   ;加锁  
    
    s chkerr=##class(PHA.OP.COM.Method).ChkPreIfNotUse(prescno,phl)        
    i chkerr=1 D unlock
	q:chkerr=1 -102_"^"_"处方已经作废"   	

	s chkerr=##class(web.DHCOutPhDisp).CheckBeforUpdate(prescno,phl)
	i (chkerr=1)&(owedr="") D unlock
	q:(chkerr=1)&(owedr="") -103_"^"_"处方已发状态" 			///如果是欠药发药，则不考虑已发状态
	s chkerr=##class(web.DHCOutPhDisp).CheckBeforInsertNew(prescno,oldphl,0)   
	i (chkerr=0)&(owedr="") D unlock
	q:(chkerr=0)&(owedr="") -104_"^"_"处方未配药" 
	s ownstatus=..GetOwdStatus(owedr)
	i (owedr'="")&(ownstatus'=1) D unlock
	q:(owedr'="")&(ownstatus'=1) -105_"^"_"处方已发状态"   //如果是欠药,判断是否已发完
	TSTART
	Set $ZT="troll"
	s phdrowid=""
	s suess=0
	s phdisprowid=""
	f  s phdrow=$o(^DHCPHDISPi("PRESCNO",prescno,phdrow)) q:(phdrow="")!(phdrow="0")!(suess'=0)  d
	.s phdprescno="",pmi=""
	.s phdphl=$p(^DHCPHDISP(phdrow,1),"^",1)
	.s phdprtID=$p(^DHCPHDISP(phdrow),"^",2)
	.s fyflag=$p(^DHCPHDISP(phdrow),"^",4)
	.q:fyflag=1  									//过滤已发药
	.s tmpowedr=$p(^DHCPHDISP(phdrow,2),"^",2)
	.q:(owedr'="")&(tmpowedr'=owedr) 				//欠药发药时，过滤非欠药记录
	.q:(owedr="")&(tmpowedr'="")
	.s checkskintest=##class(web.DHCOUTPHA.Common.CommonDisp).CheckSkinTestByPhd(phdrow)
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
	.i $p(^DHCPHDISP(phdrow,2),"^",5)="" s $p(^DHCPHDISP(phdrow,2),"^",5)=+$h 
	.i $p(^DHCPHDISP(phdrow,2),"^",6)="" s $p(^DHCPHDISP(phdrow,2),"^",6)=$p($h,",",2) 
	.i newphw'="" s $p(^DHCPHDISP(phdrow,1),"^",4)=newphw
	.s $p(^DHCPHDISP(phdrow,1),"^",16)=shusr
    .s phdsub=""
    .f  s phdsub=$o(^DHCPHDI(phdrow,"PHDI",phdsub)) q:(phdsub="")!(suess'=0)  d
    ..s oeori="",ord="",itm="",qty=0,basqty=0,err="",fs=0
    ..s oeori=$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",5)
    ..s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
    ..q:(ord="")!(itm="")
    ..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)  
    ..s BillFlag=$p(^OEORD(ord,"I",itm,3),"^",5)
    ..q:(BillFlag'="P")&(oeflag'="V")&(oeflag'="E")			//未交费  
    ..i cyflag="1"  d
    ...s $p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",9)=fs
    ..s pointer=""
    ..s pointer=phdrow_"||"_phdsub 
    ..s parowid=phdrow_"||"_phdsub
    ..s suess=..Dispensing(parowid,oeori,ctloc,currdt)
    ..i +suess=-4 s suess=-24
    ..q:+suess'=0
    ..s suess=..UpdOrdRecloc(oeori,phl,pointer,pydr)
    ..q:+suess'=0
    ..s $p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",10)=1  //发药子表FYFlag=1为发药减库,考虑有机器配完药又有医嘱退费情况
    ..
    ..s:supp'="" suess=##class(web.DHCSTPHSUPPLY).SavePHOutSUPPLYITM(supp,pointer)   ;生成补货记录
    .q:+suess'=0 
    .s phdrowid=phdrow
    .;
    i +suess'=0 TRo
    i +suess'=0 d unlock
    q:+suess=-24 -124_"^"_$tr(suess,"^","&&")
    q:+suess=-123 -123_"^"_"皮试不合格"
    q:+suess'=0 -291_"^"_$tr(suess,"^","&&")

    i +suess=0 s suess=..UpdPhDispEN(phdrowid,currdate,currtime)  //更新发药表
    i +suess'=0 TRo
    
    i +suess'=0 d unlock
    q:+suess'=0 -292_"^"_"更新发药表失败:"_suess
    ;
    s:+suess=0 suess=..UpdOeDispen(prescno)  //如果有欠药时检测，标记已发药
    i +suess'=0 TRo
    i +suess'=0 d unlock   
    q:+suess'=0 -30_"^"_"更新医嘱中间表失败:"_suess
    ;
    i newphw="" s newphw=phw
    s suess=..UpdPharwin(prescno,phl,newphw)  //到这的都是发药成功的
    i +suess'=0 TRo
    i +suess'=0 d unlock
    q:+suess'=0 -31_"^"_"更新医嘱中间表失败:"_suess
    ///更新欠药已发标志
    i owedr'="" s suess=..UpdOweListStatus(owedr)
    i +suess'=0 TRo
    i +suess'=0 d unlock
    q:+suess'=0 -32_"^"_"更新欠药表失败:"_suess
    TCOMMIT
    
    D unlock
    //读取拒绝发药申诉消息prescno
    i prescno'="" d
    .s phaor=$o(^DHCPHORDM(0,"PrescNo",prescno,""),-1)
    .q:phaor=""
    .q:$p(^DHCPHORDM(phaor),"^",9)'="OR"
    .&SQL(UPDATE DHC_PHAORDMONITOR SET PHAOM_Result='Y',PHAOM_CancelUser_Dr=null,PHAOM_CancelDate=null,PHAOM_CancelTime=null WHERE PHAOM_ROWID=:phaor)
    .s execret=##class(web.DHCSTInterfaceMessage).SendAppealOrderMonitor(phaor,"Exec")
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
    s payModeFlag=##class(PHA.FACE.IN.Com).IStayPayModeByEpisodeID(HospID)
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
    .
    s errCode=""
    s reinsflag=""
    s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
    s dspSub=0
    f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:(dspSub="")||(+errCode<0)  d
    .s dspbBatchId=dspId_"||"_dspSub
	.s dspInclb=$p(^DHCOEDISQTY(dspId,"I",dspSub),"^",1)
	.s dspInci=$p(^DHCOEDISQTY(dspId,"I",dspSub),"^",5) 
	.s inci=$s(dspInclb'="":+dspInclb,1:+dspInci)
    .s dspqty=$p(^DHCOEDISQTY(dspId,"I",dspSub),"^",2) 
    .s inclb=dspSub   //$s(dspInclb'="":dspInclb,1:inci)
    .s ^TMP("DHCST",$ClassName(),"Dispensing",pid,"INCI",inci,inclb)=dspqty_"^"_dspbBatchId_"^"_dspInclb
    .s ^TMP("DHCST",$ClassName(),"Dispensing",pid,"INCI",inci)=$p($g(^TMP("DHCST",$ClassName(),"Dispensing",pid,"INCI",inci)),"^",1)+dspqty
    .
    
    s incidesc=""
    s inci=0
    f  s inci=$o(^TMP("DHCST",$ClassName(),"Dispensing",pid,"INCI",inci)) q:(inci="")||(+errCode<0)  d
    .q:+inci=0
    .s inciqty=^TMP("DHCST",$ClassName(),"Dispensing",pid,"INCI",inci)
    .s incidesc=$p(^INCI(inci,1),"^",2)
    .s alreadyqty=##class(web.DHCOUTPHA.Common.CommonDisp).GetAlreadyDispQty(oeori,inci)  		//欠药(未发)+发药
    .s realqty=inciqty-alreadyqty							//本次需要发药数量
    .s ILSub=$o(^INCI("IL_LOC",locdr,inci,"")) 
 	.i ILSub="" s errCode=-1 
 	.s incil=inci_"||"_ILSub
 	.q:+errCode<0 
 	.s index=0
 	.f  s index=$o(^TMP("DHCST",$ClassName(),"Dispensing",pid,"INCI",inci,index))  q:(index="")||(+errCode<0)  d  
 	..d KillInclbTmp
 	..s tmpdata=^TMP("DHCST",$ClassName(),"Dispensing",pid,"INCI",inci,index)
 	..s dspqty=$p(tmpdata,"^",1)
 	..s dspbBatchId=$p(tmpdata,"^",2)
 	..s dspInclb=$p(tmpdata,"^",3)
 	..i dspqty>alreadyqty d 			
 	...s dspqty=dspqty-alreadyqty    //该批次需要发药数量=批次数-已发数量
 	...s alreadyqty=0
 	..e  d
 	...s alreadyqty=alreadyqty-dspqty
 	...s dspqty=0
 	..q:dspqty=0
	..s stkqty=0
    ..//批次价判断库存
    ..i RuleFlag=3 d
    ...s dspFlag=##Class(web.DHCST01).GetDspClbForOut(dspbBatchId,pid,inci) 	
    ...;先发药后收费模式下库存不足重写DHC_OEDispBatch
    ...i (dspFlag'=1)&&(oweflag1="")&&(oweflag2="") d
    ....s advdispflag=""
    ....s emLGflag=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",17)
	....s:(emLGflag'="")&&(emLGflag'=0)&&(payModeFlag="1") advdispflag=1   	//急诊留观且押金收费模式
	....s readyToBill=$p($g(^OEORD(ord,"I",itm,12)),"^",26)
	....s:readyToBill="Y" advdispflag=1									 	//先就诊后收费
	....s studyId=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",10)
	....s:studyId'="" advdispflag=1										 	//科研用药
	....s payflag=$p(^OEORD(ord,"I",itm,3),"^",5) 
	....s:(AdmType="H")&&(payflag="P") advdispflag=1							//体检发药
    ....i (advdispflag=1)&&(dspFlag'=1)&&(oweflag1="")&&(oweflag2="") d 
    .....s delret=##class(web.DHCSTOEDispBatch).DelDspBatch(dspbBatchId)
    .....i delret'=0 d
    ......d exit
    ......d UK
    ......s errCode=-3
    .....q:+errCode<0
    .....s reinsflag=1 
    ...q:+errCode<0
    ...
    ...d ##class(web.DHCST01).UpdInclbResQty(dspInclb,-dspqty) 			//按照打包子表删除在途数
    ...i (dspFlag'=1)||(oweflag1'="")||(oweflag2'="") d 					//"ower"考虑到欠药模式，强制重新分批次 
    ....s stkqty=##CLASS(web.DHCST01).GetInclbQty(incil,dspqty,pid,1,1) 
    ...e  d
    ....s stkqty=1
    ..e  d   //非批次价判断库存
    ...s stkqty=##CLASS(web.DHCSTSTKQTY).GetInclbQty(inci,dspqty,locdr,pid)
    ..i stkqty'=1 d
    ...d exit
    ...d UK 
    ...s errCode=-4
    ..q:+errCode<0 
    ..s ret=0
    ..i RuleFlag=3 d
    ...s ret=..InsertPhdisItmClbByBatch(parowid,pid,dspbBatchId) 
    ..e  d
    ...s ret=..InsertPhdisItmClb(parowid,pid,locdr,dspbBatchId)
    ..i ret'=0 d 
    ...d exit
    ...d UK 
    ...s errCode=-5
    ..q:ret'=0
    ..d UK 
    ..d KillInclbTmp 
    
    q:+errCode<0 errCode_"^"_incidesc
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
    q:suess'=0 suess_"^"_"修改打包表错误:"_SQLCODE
    //修改打包子表
	&sql(update DHC_OEDispBatch set DSPB_Status='C' where DSPB_DSP_ParRef=:dspId)
    i SQLCODE'=0 s suess=500
    i suess'=0 d exit
    q:suess'=0 suess_"^"_"修改打包子表错误:"_SQLCODE
    //处理非批次价在途数
    i RuleFlag'=3 d
    .s reclocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
	.i reclocdr=locdr d
	..s dspID=""
	..f  s dspID=$o(^DHCOEDISQTY(0,"OEORI",oeori,dspID)) q:dspID=""  d
	...s dspSub=""
	...f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:(dspSub="")  d
    ....s dspbBatchId=dspId_"||"_dspSub
	....s dspInclb=$p(^DHCOEDISQTY(dspId,"I",dspSub),"^",1)
	....s dspInci=$p(^DHCOEDISQTY(dspId,"I",dspSub),"^",5) 
	....s inci=$s(dspInclb'="":+dspInclb,1:+dspInci)
	....s ilSub=$o(^INCI("IL_LOC",locdr,inci,"")) 
	....q:ilSub=""
	....s dspQty=-$p(^DHCOEDISQTY(dspId,"I",dspSub),"^",2) 
	....d ##Class(web.DHCST01).UPDINVRESQTY(inci,locdr,dspQty)
	....s incil=inci_"||"_ilSub
	....s pointer=dspId_"||"_dspSub
	....s SqlStr=incil_"^"_3_"^"_dspQty_"^"_""_"^"_dspID_"^"_locdr
 	....s Ret=##Class(User.DHCIncReservedQtyDetail).Insert(SqlStr)	
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
	k ^TMP("DHCST",$ClassName(),"Dispensing",pid,"INCI")
	k ^TMPGETINCLB(pid)
	q
KillInclbTmp
	k ^TMP("DHCST","web.DHCST01","Inclb",pid)
	k ^TMPGETINCLB(pid)
	q
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
	  .s spamt=sp*baseqty	//售价金额与子表计算方法保持一致
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
	s ord=+oeoriID
	s itm=$p(oeoriID,"||",2)
	s BillFlag=$p(^OEORD(ord,"I",itm,3),"^",5)
	i BillFlag'="P" d
	.;先发药后收费的按照批次价格重新更新打包表价格
	.s inclb=$p(^DHCOEDISQTY(+dspBatchId,"I",$p(dspBatchId,"||",2)),"^",1)
	.s sp=+##class(web.DHCSTPRICE).GetSp(inclb,+$h,"",HospID,"","") 
	.s $p(^DHCOEDISQTY(+dspBatchId,"I",$p(dspBatchId,"||",2)),"^",4)=sp
	.s rp=+##Class(web.DHCSTPRICE).GetRp(inclb,+$h,"",HospID,"")
	.s $p(^DHCOEDISQTY(+dspBatchId,"I",$p(dspBatchId,"||",2)),"^",3)=rp 
	e  d
	.;正常门诊都取收费的价格
	.s sp=$p(##class(web.DHCOutPhCommon).GetBasePriceByOe(oeoriID,dspBatchId),"^",1) 
	;按照有效批次存发药孙表，此处有可能一个打包子表对应多条发药孙表！
	s lbNum="",bb=0,itmclbnum=0
	f  s lbNum=$o(^TMP("DHCST","web.DHCST01","Inclb",pid,lbNum)) q:(lbNum="")!(itmclbnum'=0)  d
	.s inclbstr=^(lbNum)
	.s newclb=$p(inclbstr,"^",4)
	.s baseqty=$p(inclbstr,"^",1)
	.s inci=+newclb
	.s buom=$p(^INCI(inci,1),"^",10)
	.s rp=+##Class(web.DHCSTPRICE).GetCurRp(newclb,buom,HospID) //进价取当前进价
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

/// 更新发药主表
ClassMethod UpdPhDispEN(phdrowid, currdate, currtime) As %String
{
    s fyflag=1
    &sql(update DHC_PHDISPEN set PHD_FYDATE=:currdate, PHD_FYFLAG=:fyflag, PHD_FYTIME=:currtime where PHD_ROWID=:phdrowid)
	q:SQLCODE'=0 SQLCODE
    q 0
}

/// Input:处方号
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
	..q:(payflag'="P")&(oeflag'="V")&(oeflag'="E")  //未交费 停医嘱  过滤
	..s prcode="" 
	..s pr=+$p(^OEORD(ord,"I",chl,1),"^",8)
    ..i pr'=0 s prcode=$p(^OECPR(pr),"^",1)
    ..q:prcode["OM" 
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

/// Description: 更新欠药单完成状态
ClassMethod UpdOweListStatus(owedr)
{
    s $p(^DHCPHOW(owedr),"^",8)=2
    q 0
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

ClassMethod UpdPharwin(prescno, phl, newphw) As %String
{
    s phaid=""
	f  s phaid=$o(^DHCPHARi("PRESCNO",prescno,phaid)) q:phaid=""  d 
	.s phldr="",phwdr=""
	.s phldr=+$p(^DHCPHARW(phaid),"^",3) 
	.s locdr=$p(^DHCPHLOC(phl),"^",1)
	.s leadlocdr=##class(web.DHCOutPhDisp).GetLeadLoc(locdr)
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

ClassMethod GetOwdStatus(owedr)
{
  q:owedr="" ""	
  s owestatus=$p(^DHCPHOW(owedr),"^",8)
  s oweretdate=$p(^DHCPHOW(owedr),"^",10)
  i oweretdate'="" s owestatus=""
  q owestatus
}

}
