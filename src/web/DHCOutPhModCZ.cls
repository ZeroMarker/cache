Class web.DHCOutPhModCZ Extends %Library.RegisteredObject
{

Parameter BUILD = 72;

ClassMethod InsertDhcIntrans(type, qty, inci, inclb, money, pointer, usr, ctuom, transno, price)
{
	    s currdate="",currtime=""
	    s currdate=$p($h,",",1)
	    s currtime=$p($h,",",2)
	    &sql(insert into sqluser.dhc_intrans(intr_type,intr_date,intr_time,intr_qty,intr_inclb_dr,intr_inci_dr,
	        intr_pointer,intr_amount,intr_ctuom_dr,intr_ssusr_dr,intr_no,intr_averageprice)  values(:type,
	        :currdate,:currtime,:qty,:inclb,:inci,:pointer,:money,:ctuom,:usr,:transno,:price))
	    q SQLCODE
}

ClassMethod DoDhcTotalMain(inci, ctloc, qty)
{
  s m=0,ldtrow="0",sdate="",ret="",cudate="",qtyend=0,latqty=0
  s Row=""
	    s cudate=$p($h,",",1)
	    s sdate=$o(^DHCLOCTOT(0,"LOCITMDATE",ctloc,inci,cudate+1),-1)        
	    i sdate'="" d
	      .s ldtrow=$o(^DHCLOCTOT(0,"LOCITMDATE",ctloc,inci,sdate,""))
	      .s qtyend=+$p(^DHCLOCTOT(ldtrow),"^",4)
	      .s latqty=qtyend+qty
	   i $g(sdate)=cudate d
	        .&sql(Update sqluser.DHC_LocDailyTotal set Day_QtyEnd=day_qtyend+:qty where Day_RowID=:ldtrow)
	        .s Row=ldtrow
	      e  d   
	        .&sql(insert into sqluser.DHC_LocDailyTotal(day_itm_dr,day_loc_dr,day_date,day_qtybeg,day_qtyend)  
	          values(:inci,:ctloc,:cudate,:qtyend,:latqty))
	        .s Row=+$g(%ROWID)
	      q Row
}

ClassMethod DoDhcTotalTail(inclb, ctloc, qty, row)
{
            s latrow="",m=0,endqty=0,cudate="",latedate="",tt=0,uinci="",latqty=0
	             s uinci=$p(inclb,"||",1)
	             s cudate=$p($h,",",1)
	             s latedate=$o(^DHCBTLOCTOT(0,"INCLBDATE",inclb,cudate+1),-1) 
	             i latedate="" s endqty=0
	             e  d
	               .s talrow="0"
	               .f  s talrow=$o(^DHCBTLOCTOT(0,"INCLBDATE",inclb,latedate,talrow)) q:(talrow="")!(talrow="0")!(tt=1)  d
	                 ..s talsub=""
	                 ..f  s talsub=$o(^DHCBTLOCTOT(0,"INCLBDATE",inclb,latedate,talrow,talsub)) q:(talsub="")!(tt=1)  d
	                  ...s tt=tt+1
	                  ...s endqty=+$p(^DHCBTLOCTOT(talrow,"I",talsub),"^",3)
	             i tt=0  d
	               .s endqty=0
	             s tailrow="0",sub="",i=0
	             s latqty=endqty+qty
	             f  s tailrow=$o(^DHCBTLOCTOT(row,"I",tailrow)) q:(tailrow="")!(tailrow="0")  d
	                .s tailclb="",loc=""
	                .s i=i+1
	                .s tailclb=$p(^DHCBTLOCTOT(row,"I",tailrow),"^",1)
	                .s loc=+$p(^DHCBTLOCTOT(row,"I",tailrow),"^",5)
	                .q:loc'=ctloc
	                .q:tailclb'=inclb
	                .s m=m+1
	                .s sub=tailrow
	             i m=0  d
	                .s i=i+1
	                .&sql(insert into sqluser.DHC_LocBTDailyTotal(dayBT_Bat_DR,DayBT_Childsub,DayBT_ParRef,DayBT_QtyBeg,DayBT_QtyEnd,DayBT_Date,DayBT_Loc_DR)
	                   values(:inclb,:i,:row,:endqty,:latqty,:cudate,:ctloc))
	             e  d
	                .&sql(update sqluser.DHC_LocBTDailyTotal set DayBT_QtyEnd=DayBT_QtyEnd+:qty where  daybt_parref=:row and daybt_childsub=:sub)
	             q SQLCODE
}

ClassMethod ModPhdisp(phd, user)
{
	       s phditm=""
	       s phl="",loc=""
	       s phl=+$p(^DHCPHDISP(phd,1),"^",1)
	       s loc=+$p(^DHCPHLOC(phl),"^",1)
	       f  s phditm=$o(^DHCPHDI(phd,"PHDI",phditm)) q:phditm=""  d
	          .s oeori="",disqty=0,money=0,ord="",itm="",price=0,inci=""
	          .s disqty=+$p(^DHCPHDI(phd,"PHDI",phditm),"^",4)
	          .s money=+$p(^DHCPHDI(phd,"PHDI",phditm),"^",3)
	          .s price=money/disqty
	          .s oeori=$p(^DHCPHDI(phd,"PHDI",phditm),"^",5)
	          .s ord=$p(oeori,"||",1)
	          .s itm=$p(oeori,"||",2)
	          .s itmmast="",basuom=""
	          .s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2) 
	          .s puruom=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),8),"^",14)
	          .s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),inci))
	          .q:inci=""
	          .s basuom=+$p(^INCI(inci,1),"^",10)
	          .s basqty=##CLASS(web.DHCOutPhModCZ).GetBasQty(puruom,basuom,disqty)
	          .s basprice=0
	          .s basprice=money/basqty
	          .s checkclb=""
	          .s checkclb=$p(^OEORD(ord,"I",itm,"X",1,"D",1),"^",2)
	          .q:checkclb=""
	          .s manrow=0
	          .s manrow=##CLASS(web.DHCOutPhModCZ).DoDhcTotalMain(inci,loc,-basqty)
	          .s exe="0"
	          .f  s exe=$o(^OEORD(ord,"I",itm,"X",exe)) q:(exe="")!(exe="0")  d
	         ..s disp="0"
	         ..f  s disp=$o(^OEORD(ord,"I",itm,"X",exe,"D",disp)) q:(disp="0")!(disp="")  d
	           ...s clb="",clbqty=0,err=0,clbmoney=0
	           ...s clb=$p(^OEORD(ord,"I",itm,"X",exe,"D",disp),"^",2)
	           ...q:clb=""
	           ...s clbqty=+$p(^OEORD(ord,"I",itm,"X",exe,"D",disp),"^",1)
	           ...s clbmoney=clbqty*basprice
	           ...s err=##CLASS(web.DHCOutPhModCZ).InsertDhcIntrans("F",-clbqty,inci,clb,clbmoney,phd_"||"_phditm,user,basuom,"",basprice)
	           ...q:err'=0
	           ...s err=##CLASS(web.DHCOutPhModCZ).DoDhcTotalTail(clb,loc,-clbqty,manrow)
	           ...q:err'=0
	      q 0
}

ClassMethod GetBasQty(puruom, baseuom, purqty)
{
          s conrow="",base="",newqty=0
	       i puruom'=baseuom  d
	          .s conrow=$o(^CT("CTCF",0,"UOM",puruom,baseuom,conrow))
	          .s base=$p(^CT("CTCF",conrow),"^",3)
	       e  s base=1
	       s newqty=purqty*base
	       q newqty
}

ClassMethod DoModifyPhRet(st, end, phl)
{
       s st=$zdh(st,3)
	          s end=$zdh(end,3)
	          s retdate=""
	          f  s retdate=$o(^DHCPHRETi(retdate)) q:retdate=""  d
	            .q:retdate<st
	            .q:retdate>end
	            .s retrow=""
	            .f  s retrow=$o(^DHCPHRETi(retdate,phl,retrow)) q:retrow=""  d
	              ..s retsub="",user="",php=""
	              ..s php=+$p(^DHCPHRET(retrow),"^",8)
	              ..s user=+$p(^DHCPHPER(php),"^",5)
	              ..f  s retsub=$o(^DHCPHRTI(retrow,"RTI",retsub)) q:retsub=""  d
	                ...s retqty=0,orditm=""
	                ...s err=0
	                ...s err=##CLASS(web.DHCOutPhModCZ).ModPhReturn(retrow,retsub,user)
	             q 0
}

ClassMethod ModPhReturn(phret, retsub, user, phdlbrowid)
{
      
	s oeori=$p(^DHCPHRTI(phret,"RTI",retsub),"^",2)
	s amount=+$p(^DHCPHRTI(phret,"RTI",retsub),"^",1)
	s retqty=+$p(^DHCPHRTI(phret,"RTI",retsub),"^",3)
	s inci=+$p(^DHCPHRTI(phret,"RTI",retsub),"^",13)
	s basuom=+$p(^INCI(inci,1),"^",10)
	s basqty=retqty
	s basprice=0
	s basprice=$p(^DHCPHRTI(phret,"RTI",retsub),"^",6)
	s rp=$p(^DHCPHRTI(phret,"RTI",retsub),"^",8)
	s phd=$p(phdlbrowid,"||",1),phdisitm=$p(phdlbrowid,"||",2),phdic=$p(phdlbrowid,"||",3)
	s everyqty=basqty
	s hbasretqty=+$p(^DHCPHDI(phd,"PHDI",phdisitm,"INCLB",phdic),"^",2)
	s phdicdispqty=+$p(^DHCPHDI(phd,"PHDI",phdisitm,"INCLB",phdic),"^",1)
	s phdicdispqty=phdicdispqty-hbasretqty //发药余量 lq
	q:phdicdispqty=0
	i phdicdispqty<everyqty  d
	.s retclbqty=phdicdispqty  //要退的数量 lq
	.s $p(^DHCPHDI(phd,"PHDI",phdisitm,"INCLB",phdic),"^",2)=hbasretqty+retclbqty
	.s everyqty=everyqty-phdicdispqty  //要退余量 lq
	e  d
	.s retclbqty=everyqty
	.s $p(^DHCPHDI(phd,"PHDI",phdisitm,"INCLB",phdic),"^",2)=hbasretqty+retclbqty
	.s basqty=0
	s phinclb=$p(^DHCPHDI(phd,"PHDI",phdisitm,"INCLB",phdic),"^",3)
	//add wyx 2014-05-06
	s phl=+$p(^DHCPHRET(phret),"^",7)
	s loc=+$p(^DHCPHLOC(phl),"^",1)
	s othlocretflag=$p(^DHCPHLOC(phl),"^",8)
	s HospID=$p(^CTLOC(loc),"^",22)
	s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)	//进价规则
	i RuleFlag=3 d
	.s basprice=$p(^DHCPHDI(phd,"PHDI",phdisitm,"INCLB",phdic),"^",7) // 取发药批次表价格,判断是按批价模式的话
	.s rp=$p(^DHCPHDI(phd,"PHDI",phdisitm,"INCLB",phdic),"^",5)  //和售价模式一样
	i othlocretflag="Y" d
	.s othclb=..GetOthClbRet(phinclb,loc) //yunhaibao20161017,跨科室退药,不存在该批次则插入新批次
	e  s othclb=phinclb
	s retclbqty=retclbqty
	s ret=0
	s ret=..HandleStk(othclb,retclbqty,basuom,loc,basprice,phret_"||"_retsub,"",user,rp)
	q:ret'=0 -1
	q 0
}

ClassMethod GetOrdItmUom(oeori, qty)
{
     s ord="",itm="",itmmast="",itmmastid="",itmmastver=""
	       s ord=$p(oeori,"||",1)
	       s itm=$p(oeori,"||",2)
	       s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
	       s itmmastid=$p(itmmast,"||",1)
	       s inci=""
	       s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
	       s puruom="",basuom="",basqty0=0,bas=1
	       s puruom=+$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),8),"^",14)
	       s basuom=+$p(^INCI(inci,1),"^",10)
	       s basqty0=##CLASS(web.DHCOutPhModCZ).GetBasQty(puruom,basuom,qty)
	       q basqty0
}

ClassMethod ModPhdispitm(phditmPH, user)
{
	       s phd="",phditm=""
	       s phd=$p(phditmPH,"||",1)
	       s phditm=$p(phditmPH,"||",2)
	       s phl="",loc=""
	       s phl=+$p(^DHCPHDISP(phd,1),"^",1)
	       s loc=+$p(^DHCPHLOC(phl),"^",1)
	       s oeori="",disqty=0,money=0,ord="",itm="",price=0,inci=""
	       s disqty=+$p(^DHCPHDI(phd,"PHDI",phditm),"^",4)
	       s money=+$p(^DHCPHDI(phd,"PHDI",phditm),"^",3)
	       s price=money/disqty
	       s oeori=$p(^DHCPHDI(phd,"PHDI",phditm),"^",5)
	       s ord=$p(oeori,"||",1)
	       s itm=$p(oeori,"||",2)
	       s itmmast="",basuom=""
	       s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2) 
	       s puruom=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),8),"^",14)
	       s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),inci))
	       i inci="" q 0
	       s basuom=+$p(^INCI(inci,1),"^",10)
	       ;s basqty=##CLASS(web.DHCOutPhModCZ).GetBasQty(puruom,basuom,disqty)
	       s basqty=disqty
	       s basprice=0
	       s basprice=money/basqty
	       s checkclb=""
	       i '$d(^DHCPHDI(phd,"PHDI",phditm,"INCLB",1)) q 0
	       s manrow=0
	       s manrow=##CLASS(web.DHCOutPhModCZ).DoDhcTotalMain(inci,loc,-basqty)
	       s phdic=""
	       f  s phdic=$o(^DHCPHDI(phd,"PHDI",phditm,"INCLB",phdic)) q:phdic=""  d
	          .s clb="",clbqty=0,err=0,clbmoney=0,^TY=^DHCPHDI(phd,"PHDI",phditm,"INCLB",phdic)
	          .s clb=$p(^TY,"^",3),clbqty=+$p(^TY,"^",1)
	          .q:clb=""
	          .s clbmoney=clbqty*basprice
	          .s err=##CLASS(web.DHCOutPhModCZ).InsertDhcIntrans("F",-clbqty,inci,clb,-clbmoney,phd_"||"_phditm,user,basuom,"",basprice)
	          .q:err'=0
	          .s err=##CLASS(web.DHCOutPhModCZ).DoDhcTotalTail(clb,loc,-clbqty,manrow)
	          .s clbbasqty=0
	          .;s clbbasqty=##CLASS(web.DHCSTSTKQTY).CurQtyINCLB(clb)
	          .;d ##CLASS(web.DHCMZYFXTYWMODBUG).RollBackMedInclb(clb,clbbasqty)
	          .q:err'=0
	      q
}

ClassMethod RollBackMedInclb(winclb, nqty)
{
         s inc="",cil="",tclb="",medqty=0,ptqty=0        
	              s inc=$p(winclb,"||",1)
	              s cil=$p(winclb,"||",2)
	              s tclb=$p(winclb,"||",3)
	              s medqty=+$p(^INCI(inc,"IL",cil,"LB",tclb),"^",2)
	              s ptqty=medqty-nqty
	              q:ptqty=0 
	              s $p(^INCI(inc,"IL",cil,"LB",tclb),"^",2)=nqty
	              s $p(^INCI(inc,"IL",cil),"^",3)=$p(^INCI(inc,"IL",cil),"^",3)-ptqty
	              s $p(^INCI(inc,1),"^",4)=$p(^INCI(inc,1),"^",4)-ptqty
	              q
}

ClassMethod HandleStk(inclb, qty, uom, locdr, sprice, pointer, intrno, user, Rp = "") As %String
{
 ;inclb - 批次rowid
 ;qty - 数量(和uom 相应的数量) - 数量应根据业务类型区分正还是负
 ;uom - 单位rowid
 ;locdr - 科室rowid
 ;sprice - 售价(和uom 相应的售价)
 ;pointer - 业务记录的rowid
 ;intrno - 业务记录的业务号，如发药单号
 ;user - 用户rowid
 ;
 ;tstart
 /*
 s ret=0
 s ret=..InsTrans(inclb,qty,uom,locdr,sprice,pointer,intrno,user)
 ;i ret<0 trollback
 q:ret<0 -1
 ;tcommit
 */
 ;
 ;
 l +^DHCINCIL(locdr,+inclb):10  e  q -1   ;加锁
 s err=0
 s Type="H"
 s RetNo=""
 s Inclb=inclb
 s Qty=qty
 s UomDesc=$p(^CT("UOM",uom),"^",2)
 s ItmCode=$p(^INCI(+inclb,1),"^",1)
 s Price=sprice
 s User=user
 s Pointer=pointer
 s inci=+Inclb  //2013-12-30 ws for error dhcstock
 s inch=$p(Inclb,"||",2)  //2013-12-30 ws for error dhcstock
 s displocdr=+$p(^INCI(inci,"IL",inch),"^",1)  //2013-12-30 ws for error dhcstock
 ;s LocDesc=$p(^CTLOC(locdr),"^",2)   //2013-12-30 ws for error dhcstock
 s LocDesc=$p(^CTLOC(displocdr),"^",2)   //2013-12-30 ws for error dhcstock
 s RetID=$p(Pointer,"||",1)
 s RetSub=$p(Pointer,"||",2)
 //s SpAmt=$p(^DHCPHRTI(RetID,"RTI",RetSub),"^",1)
 //s Rp=$p(^DHCPHRTI(RetID,"RTI",RetSub),"^",8)
 //s RpAmt=$p(^DHCPHRTI(RetID,"RTI",RetSub),"^",9)
 s data=Type_"^"_RetNo_"^"_Inclb_"^"_Qty_"^"_UomDesc_"^"_ItmCode_"^"_Price_"^"_User_"^"_Pointer_"^"_LocDesc_"^"_Rp  //_"^"_RpAmt_"^"_SpAmt

 s err=##class(web.DHCST01).UPDINCI(data)
 
 l -^DHCINCIL(locdr,+inclb)
 q:err=0 -5
 
 q 0
}

ClassMethod InsTrans(inclb, qty, uom, locdr, sprice, pointer, intrno, user) As %String
{
 ; This routine is used to handle the stock qty of Table Dhc_LocDailytotal and Dhc_LocBtDailytotal when dispensing .
 ;n (inclb,qty,uom,locdr,sprice,pointer,intrno,user)
 q:inclb="" -1
 q:locdr="" -2
 s inci=+inclb,locdr=+locdr
 q:inci<0 -11
 s qty=+qty
 s buom=$p(^INCI(inci,1),"^",10)  q:buom="" -3
 ;s fac=+$$CONVFAC^ST01(uom,buom)
 s fac=+##class(web.DHCSTCOMMONSRV).UOMFac(uom,buom) q:buom="" -3
 s bqty=qty*fac
 s retclb=""
 s retclb=##class(web.DHCOutPhModCZ).DoUpdateItmLoc(inclb,bqty)
 s mrowid=##class(web.DHCSTLOCDTOTAL).UpdateMainByID(inci,bqty,locdr)
 q:mrowid="" -4
 s detrowid=##class(web.DHCSTLOCBTDTOTAL).UpdateDayBT(inclb,bqty,mrowid)
 q:detrowid="" -5
 ; Insert transaction data 
 k PLIST
 f i=1:1:16 s PLIST(i)=""
 s PLIST(2)=+qty*sprice                                                  ;INTR_Amount
 s PLIST(3)=+sprice                                                       ;INTR_AveragePrice
 s PLIST(4)=uom ;                           ;INTR_CTUOM_DR
 s PLIST(5)=$p($h,",",1)                                                  ;INTR_Date
 s PLIST(6)=""                                                            ;INTR_GLBatch_DR
 s PLIST(7)=inci ;                            ;INTR_INCI_DR
 s PLIST(8)=inclb                                                                                                              ;INTR_INCLB_DR
 s PLIST(9)=intrno                                                         ;INTR_No
 s PLIST(10)=pointer                                                     ;INTR_Pointer
 s PLIST(11)=+qty                                                        ;INTR_Qty
 s PLIST(12)=+user                                                       ;INTR_SSUSR_DR
 s PLIST(13)=$p($h,",",2)
  i qty<0  s PLIST(14)="F"                                                        ;INTR_Type
 else  s PLIST(14)="H"                                                        ;INTR_Type
                                                 ;INTR_Time
 ;s PLIST(14)="F"                                                        ;INTR_Type
 s PLIST(15)="N"                                                          ;INTR_UpdBalFlag       
 s PLIST(16)="N"                                                          ;INTR_UpdFlag
 &sql(insert into sqluser.DHC_Intrans values PLIST() )
 q:SQLCODE'=0 -6
 q +%ROWID
}

ClassMethod DoUpdateItmLoc(inclbrow, clbqty)
{
	s batinc="",batcil="",batcilrow=""
	s batinc=$p(inclbrow,"||",1)
	s batcil=$p(inclbrow,"||",2)
	s batcilrow=batinc_"||"_batcil
	&sql(update sqluser.inc_itmloc set incil_logqty=incil_logqty+:clbqty,incil_reservedqty=incil_reservedqty+:clbqty where incil_rowid=:batcilrow)
	&sql(update sqluser.inc_itmloc set incil_reservedqty=0 where incil_rowid=:batcilrow and incil_reservedqty<0 )
	&sql(update sqluser.inc_itmlcbt set inclb_phyqty=inclb_phyqty+:clbqty where inclb_rowid=:inclbrow)
	q SQLCODE
}

ClassMethod DoUpdateItmLocRet(inclbrow, clbqty, newclbqty)
{
	s batinc="",batcil="",batcilrow=""
	s batinc=$p(inclbrow,"||",1)
	s batcil=$p(inclbrow,"||",2)
	s batcilrow=batinc_"||"_batcil
	&sql(update sqluser.inc_itmloc set incil_logqty=incil_logqty+:newclbqty where incil_rowid=:batcilrow)
	i SQLCODE=0  d
	  .&sql(update sqluser.inc_itmlcbt set inclb_phyqty=inclb_phyqty+:newclbqty where inclb_rowid=:inclbrow)

	q SQLCODE
}

ClassMethod UpdateItmLoc(loc)
{
	s sysdate=+$h
	s inc=0,t=0
	f  s inc=$o(^INCI(inc)) q:(inc="")!(inc="0")  d
	  .s dhclocqty=0
	  .s dhclocqty=..GetDhcQty(loc,inc)
	  .s incil="0"
	  .f  s incil=$o(^INCI("IL_LOC",loc,inc,incil))  q:(incil="")!(incil="0")  d
	  ..s incilrow=""
	  ..s t=t+1
	  ..s incilrow=inc_"||"_incil
	  ..;s ^Tang(incilrow)=dhclocqty
	  ..&sql(update sqluser.inc_itmloc set incil_logqty=:dhclocqty where incil_rowid=:incilrow)
	q t
}

ClassMethod GetDhcQty(loc, inci)
{
  s locdate="",retqty=0
  s locdate=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inci,""),-1)
  i locdate'=""  d
    .s locrow="0"
    .s locrow=$o(^DHCLOCTOT(0,"Date",locdate,loc,inci,locrow)) 
    .i locrow'=""  d
    ..s retqty=+$p(^DHCLOCTOT(locrow),"^",4)
  q retqty
}

/// lastupdate by yunhaibao,跨科室退药时,如所跨科室不存在该批次时,插入新批次
/// 
ClassMethod GetOthClbRet(inclb, loc)
{
	s inc=$p(inclb,"||",1)
	s cil=$p(inclb,"||",2) 
	s clb=$p(inclb,"||",3) 
	s inclbbat="",newcil="",newclb=""
	s inclbbat=$p(^INCI(inc,"IL",cil,"LB",clb),"^",1)
	s newcil=$o(^INCI("IL_LOC",loc,inc,""))
	i newcil'="" d
	.s newclb=$o(^INCI("LB_IB",inclbbat,inc,newcil,""),-1)
	.s newcilrow=inc_"||"_newcil
	.i newclb=""  d
	..&sql(insert into sqluser.inc_itmlcbt(inclb_incib_dr,inclb_incil_parref,inclb_childsub)
	values(:inclbbat,:newcilrow,'1'))
	..s newclb="1"
	.s newclbrowid=newcilrow_"||"_newclb
	e  d
	.s maxcil=""
	.s maxcil=$o(^INCI(inc,"IL",""),-1)
	.i maxcil="" s maxcil=0
	.s maxcil=maxcil+1
	.s newcilrow=inc_"||"_maxcil
	.&sql(insert into sqluser.inc_itmloc(incil_inci_parref,incil_childsub,incil_ctloc_dr)
	values(:inc,:maxcil,:loc))
	.&sql(insert into sqluser.inc_itmlcbt(inclb_incib_dr,inclb_incil_parref,inclb_childsub)
	values(:inclbbat,:newcilrow,'1'))
	.s newclbrowid=newcilrow_"||"_"1"
	q newclbrowid
}

}
