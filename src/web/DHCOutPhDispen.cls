Import sqluser

/// Creator		zzd
/// Creatdate	2018.10.16
/// Description	主要实现门诊发药的查询保存cls分离
Class web.DHCOutPhDispen Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator		zzd
/// CreatDate	2018.10.16
/// Description	配药插入发药表(依据)
/// Table		DHC_Phdispen
/// Input		直接发药 updflag=1；
/// Output		
/// Exec		w ##class(web.DHCOutPhDispen).InsertPHDispPY("",11,42,"50","","O180928000006","","","","1")
/// Other	
ClassMethod InsertPHDisp(prt As %Library.String = "", phl As %Library.String = "", phw As %Library.String = "", pydr As %Library.String = "", fydr As %Library.String = "", prescno As %Library.String = "", phwpos As %Library.String = "", pyusercode As %Library.String = "", ordstr = "", updflag = "")
{
	s loclog=%session.Data("LOGON.CTLOCID")
	s hospid=$p(^CTLOC(loclog),"^",22)
	s Params="^"_loclog_"^^"_hospid
	s NeedSkinTest=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTOUTPH","SKINTESTFLAG",Params) //皮试配置,为Y时需要判断
	s chkreclocflag=##class(web.DHCOutPhCommon).GetChkRecLocFlag()

	s owedr=$p(ordstr,"&&",4)					//欠药数据
	s pid=##CLASS(web.DHCSTKUTIL).GetOutDispCounter()
	s sysdate="",systime="",phperson=""
	s sysdate=$p($h,",",1)
	s systime=$p($h,",",2)
	i pyusercode'="" s phperson=..GetPhpFrUserCode(pyusercode,phl)
	i phperson'="" s pydr=phperson
	
	s ctlocdr=+$p(^DHCPHLOC(phl),"^",1)
	s cyflag=$p(^DHCPHLOC(phl),"^",6)				//草药科室标志
	s pysure=""
	i $d(^GLobDHCPHLOC(phl))  d
	.s pysure=$p(^GLobDHCPHLOC(phl),"^",7)			//需要配药确认标志
	s papmidr=##class(web.DHCOutPhCommon).GetPapmiByPresc(prescno)		//患者id	PA_PatMas
	
	s pharw="",winpycode=""
	s pha=""
	f  s pha=$o(^DHCPHARi("PRESCNO",prescno,pha),-1) q:pha=""  d        
	.s fphldr="" 
	.s fphldr=+$p(^DHCPHARW(pha),"^",3)
	.q:(fphldr'=phl)&(chkreclocflag=1)
	.q:owedr'="" 														//如果是欠药发药，则不考虑状态
	.s pharw=+$p(^DHCPHARW(pha),"^",4)
    i pharw'="" s winpycode=##class(web.DHCOutPhTQDisp).GetWinDayPyCode(pharw)			//一个计数
	
	l +^DHCOEDISPENSING(prescno):5  e  q -11_"^"_"加锁失败"   ;加锁
	
	s chkerr=##class(web.DHCOutPhDisp).CheckNotUseNew(prescno,phl)			 
    i chkerr=1 d unlock
	q:chkerr=1 -12_"^"_"处方已作废"   
	
	s chkerr=##class(web.DHCOutPhDisp).CheckBeforInsertNew(prescno,phl,0)
	i (owedr="")&&(chkerr=1)&&(updflag'="") d unlock
	q:(owedr="")&&(chkerr=1)&&(updflag'="") 0							//直接发药	返回值
	i (owedr="")&&(chkerr=1)&&(updflag="") d unlock
	q:(owedr="")&&(chkerr=1)&&(updflag="") -13_"^"_"处方已配药"    		//如果是欠药发药，则不考虑已配状态
	s OwdStatus=""
	i owedr'=""  d
	.s OwdStatus=##class(web.DHCOutPhTQDisp).GetOwdStatus(owedr)
	i (owedr'="")&&(OwdStatus'="") d unlock
	q:(owedr'="")&&(OwdStatus'="") -14_"^"_"欠药已完成"     			//欠药已完
	
	s patadm=##class(web.DHCOutPhDisp).getadm(prescno)
	s oeordqtystr=##class(web.DHCOutPhDisp).GetOrdQtyStr(prescno)
	
	
	TSTART
	Set $ZT="troll"
	
	///生成欠药单
	s retphow=""
	i ordstr'="" d
	.s retphow=..InsertOweData(sysdate,systime,pid,ordstr,phl,prt,prescno,fydr) 
	i retphow<0 Tro
	i retphow<0 d unlock
	i retphow=-10 q -14_"^"_"欠药已完成"     
	i retphow<0 q -14_"^"_"欠药失败"_","_$tr(retphow,"^","$$")   
	s chkallowe=$p(ordstr,"&&",2)
	
	s fyflag="-1",pyflag="",pyuserid=""
    i (pysure'="1")||(updflag'="")  d			//非配药确认，或者直接发药
	.s fyflag="0"
	.s pyflag="1"
	.s pyuserid=pydr
	s prtflag=1  								//打印标志
	
	&sql(insert into SQLUSER.dhc_phdispen
	(phd_prtdate,phd_prt_dr,phd_papmi_dr,phd_phl_dr,phd_phw_dr,
	 phd_pydate,phd_pytime,phd_prescno,phd_pattype,phd_serialno,PHD_PRINTFLAG,
     PHD_OWE_DR,PHD_PYFLAG,PHD_FYFLAG,PHD_PHP_PYDR)
	values
	(:sysdate,:prt,:papmidr,:phl,:pharw,
	 :sysdate,:systime,:prescno,:phwpos,:winpycode,:prtflag,
	 :owedr,:pyflag,:fyflag,:pyuserid)
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
	..i EmLGflag=1 s AmtRet=##class(web.DHCSTPCHCOLLS2).CheckArrearsNew("",patadm,oeordqtystr,loclog)
	..e  s AmtRet="Y"						
    ..i (EmLGflag="1")&(AmtRet="N") s insubsuess=100
    ..q:insubsuess'=0
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
	...i (+checkskintest<0) s insubsuess=-123 
	...q:insubsuess=""
	..s (qty,money)=0
	..;s qty=##class(web.DHCOutPhDisp).getDspQty(oeori)
	..;s oldqty=qty
	..;s realqty=+$g(^TMP("DHCST","web.DHCOutPhDispen","InsertOweData",pid,"TMPRealQty",oeori)) ///获取实发数量
	..;i ordstr'="" s qty=realqty
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
	....s alreadyqty=##class(web.DHCOUTPHA.Common.CommonDisp).GetAlreadyDispQty(oeori,Inci)
	....s qty=qty-alreadyqty
	....q:qty'>0
	....s ch=$o(^INCI("IL_LOC",ctlocdr,Inci,""))
	....i ch="" s insubsuess=10
	....q:ch=""
    ....s incil=Inci_"||"_ch
    ....s inciQty=##class(web.DHCSTSTKQTY).GetPhaQty(incil,qty)
	....i inciQty=0 s insubsuess=10
    ....q:inciQty=0
    ..e  d  	//医嘱改造前的数据
    ...s qty=##class(web.DHCOutPhDisp).getDspQty(oeori)
	...s alreadyqty=##class(web.DHCOutPhDirectDispen).GetAlreadyDispQty(oeori,Inci)
	...s qty=qty-alreadyqty
	...q:qty'>0
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
	..i SQLCODE'=0 s insubsuess=11
	
	
	i (m=0)&&(insubsuess=0) s insubsuess=12
	i insubsuess'=0 Tro
	i insubsuess'=0 d unlock
	q:insubsuess=10 -17_"^"_arcdesc_"库存不足"
	q:insubsuess=11 -18_"^"_"插入明细错误"
	q:insubsuess=12 -19_"^"_"无符合的明细数据"
	q:insubsuess=100 -20_"^"_"对方已欠费"
	q:insubsuess=-123 -21_"^"_"皮试不合格"
	q:insubsuess'=0 -21_"^"_""

	s phaid=""
	f  s phaid=$o(^DHCPHARi("PRESCNO",prescno,phaid)) q:(phaid="")!(insubsuess'=0)  d   
	.s phldr=+$p(^DHCPHARW(phaid),"^",3)
	.q:(phldr'=phl)&(chkreclocflag=1)
	.s ret=##class(web.DHCOutPhDisp).UpdPyPharwin(phaid,prescno)
	.s insubsuess=ret
	q:insubsuess'=0 -22_"^"_"更新中间表失败"_","_insubsuess

	TCOMMIT
	d unlock
	q phdrow
unlock
   l -^DHCOEDISPENSING(prescno)
   q
   
troll
   Set $ZT=""
   b ;troll
   TRo
   l -^DHCOEDISPENSING(prescno)
   s ErrorMsg=$ZE
   q ErrorMsg
}

ClassMethod InsertOweData(sysdate, systime, pid, ordstr, phl, prt, prescno, fydr)
{
    s ctlocdr=+$p(^DHCPHLOC(phl),"^",1) 
    s chkreclocflag=##class(web.DHCOutPhCommon).GetChkRecLocFlag() 
    s insubsuess=0
    s chkallowe=$p(ordstr,"&&",2)
    s tmporderstr=$p(ordstr,"&&",3)
    s ordcnt=$l(tmporderstr,"!!")
    f i=1:1:ordcnt d 
    .s tmpordstr=$p(tmporderstr,"!!",i)
    .q:tmpordstr=""
    .s tmpoeori=$p(tmpordstr,"^",1)
    .s tmprealqty=$p(tmpordstr,"^",2)
    .s tmpphqty=$p(tmpordstr,"^",3)
    .s tmpunit=$p(tmpordstr,"^",4)
    .s tmpinci=$p(tmpordstr,"^",5)
    .;s arcimid=$p(^OEORD(+tmpoeori,"I",$p(tmpoeori,"||",2),1),"^",2)  
    .;s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
    .s inci=tmpinci
    .q:inci=""
    .s buomdr=$p(^INCI(inci,1),"^",10)
    .s fac=##class(web.DHCSTCOMMONSRV).UOMFac(tmpunit,buomdr)
    .s oweqty=tmpphqty-tmprealqty
    .s oweqty=oweqty*fac
    .s tmprealqty=tmprealqty*fac
    .s ^TMP("DHCST","web.DHCOutPhDispen","InsertOweData",pid,"TMPRealQty",tmpoeori,tmpinci)=tmprealqty
    .i oweqty'=0 s ^TMP("DHCST","web.DHCOutPhDispen","InsertOweData",pid,"TMPOWEQty",prescno,tmpoeori,tmpinci)=oweqty
  
    s tmpowedr=$p(ordstr,"&&",4) //欠药单ID
    i tmpowedr'="" d
    .s owestatus=$p(^DHCPHOW(tmpowedr),"^",8)
    .i owestatus'="" d
    ..s exit=1
    .s owesretdate=$p(^DHCPHOW(tmpowedr),"^",10)
    .i owesretdate'="" d
    ..s exit=1
    .e  d
    ..s $p(^DHCPHOW(tmpowedr),"^",8)="1"
    q:(tmpowedr'="")&($G(exit)'="") -10_"^"_"该欠药单已发"
   
    i '$D(^TMP("DHCST","web.DHCOutPhDispen","InsertOweData",pid,"TMPRealQty")) s ^tmprealdata(sysdate, systime, pid)=ordstr
    q:'$D(^TMP("DHCST","web.DHCOutPhDispen","InsertOweData",pid,"TMPRealQty")) -109 
    q:'$D(^TMP("DHCST","web.DHCOutPhDispen","InsertOweData",pid,"TMPOWEQty")) 0 
    
    s locdr=$p(^DHCPHLOC(phl),"^",1) 
    s ord=$o(^OEORD(0,"PrescNo",prescno,""))
    q:ord="" -1
    s adm=$p(^OEORD(ord),"^",1)
    s papmidr=$p(^PAADM(adm),"^",1)
    s phono=""
    &sql(insert into SQLUSER.DHC_PHOweList(PHO_No,PHO_Loc_Dr,PHO_Date,PHO_Time,PHO_User_Dr,PHO_PrescNo,PHO_PRT_DR,PHO_Papmi_Dr)
	     values(:phono,:locdr,:sysdate,:systime,:fydr,:prescno,:prt,:papmidr))
    i SQLCODE'=0 s insubsuess=insubsuess+1
    q:SQLCODE'=0 -2
    s phow=%ROWID
    q:insubsuess'=0 -3
    s i=0
    s oeori=""
    f  s oeori=$o(^TMP("DHCST","web.DHCOutPhDispen","InsertOweData",pid,"TMPOWEQty",prescno,oeori)) q:(oeori="")!(insubsuess'=0)  d
    .s inci=0 
    .f  s inci=$o(^TMP("DHCST","web.DHCOutPhDispen","InsertOweData",pid,"TMPOWEQty",prescno,oeori,inci)) q:(inci="")!(insubsuess'=0)  d
    ..s oweqty=^TMP("DHCST","web.DHCOutPhDispen","InsertOweData",pid,"TMPOWEQty",prescno,oeori,inci)
    ..s ord=$p(oeori,"||",1)
    ..s itm=$p(oeori,"||",2)
    ..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
	..s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),""))
	..s BillFlag=$p(^OEORD(ord,"I",itm,3),"^",5)
    ..i BillFlag="P" d   													
    ...s ordpriceinfo=##class(web.DHCOutPhCommon).GetBasePriceByOe(oeori)  	//根据医嘱是否结算判断，取价格方式
	...s spice=$p(ordpriceinfo,"^",1)
	..i BillFlag'="P" d   													//根据医嘱是否结算判断，取价格方式
	...s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(ctlocdr)
    ...s hospdr=$p(HospString,"^",1)
	...s exStr=oeori_"^"
	...s spice=##class(web.DHCSTPRICE).GetSp(+inci,+$h,"",hospdr,"",exStr)	//zhouyg 20150113
    ..s i=i+1
    ..&sql(insert into SQLUSER.DHC_PHOweListItm(PHOI_OrdItm,PHOI_Qty,PHOI_PHO_PARREF,PHOI_ChildSub,PHOI_Price,PHOI_Inci_Dr)
	     values(:oeori,:oweqty,:phow,:i,:spice,:inci))
    ..i SQLCODE'=0 s insubsuess=insubsuess+1
    ..q:insubsuess'=0
    ..//全部欠药时，直接置医嘱状态为已发
	k ^TMP("DHCST","web.DHCOutPhDispen","InsertOweData",pid,"TMPOWEQty")
    q phow
}

ClassMethod GetPhpFrUserCode(usercode, phloc)
{
	s userrow="",phprow="",ret=""
	s usercode=$ZCVT(usercode,"U")
	s userrow=$o(^SSU("SSUSR",0,"SSUSR_Initials",usercode,""))
	q:userrow="" ""
	f  s phprow=$o(^DHCPHPERi("USR",userrow,phprow)) q:(phprow="")||(ret'="")  d
	.s phploc=""
	.s phploc=+$p(^DHCPHPER(phprow),"^",3)
	.q:phploc'=phloc
	.s ret=phprow
	q ret
}

ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($this,"OP")
}

}
