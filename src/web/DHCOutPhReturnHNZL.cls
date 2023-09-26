Import sqluser

Class web.DHCOutPhReturnHNZL Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod DoReturn(ctloc As %Library.String = "", userid As %Library.String = "", phditm As %Library.String = "", rfr As %Library.String = "", newprt As %Library.String = "", winpos As %Library.String = "", reqrow As %Library.String = "", RetInf As %Library.String = "")
{
 
   
   
    s currdate=$p($h,",",1)
	s currtime=$p($h,",",2) 
	s sysdate=$zd(currdate,3)
	s curryear=$p(sysdate,"-",1)
	s phd="",itm=""
	s phd=$p(phditm,"||",1)
	s itm=$p(phditm,"||",2)
	s phl="",retmain="0",su=0,retrow=""
    s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
    i reqrow'="" s newprt=+$P(^DHCPHREQ(reqrow),"^",5)
    s newprt=..GetNewPrtFrOld(newprt)
	s prtdr=""
	s prtdr=+$p(^DHCPHDISP(phd),"^",2)
	s inv=$p(^DHCINVPRT(prtdr),"^",14)
    s php="",retphp=""
	f  s php=$o(^DHCPHPERi("USR",userid,php)) q:php=""  d
	  .s phpl=$p(^DHCPHPER(php),"^",3)
	  .q:phpl'=phl
	  .s retphp=php
    i retphp="" q -1
    TSTART
    
    &sql(insert into sqluser.dhc_phreturn(phret_date,phret_inv,phret_phl_dr,phret_phd_dr,phret_prt_dr,phret_php_dr,
	      phret_rfr_dr,phret_time,phret_newprt_dr,phret_type)  values(:currdate,:inv,:phl,:phd,:prtdr,:retphp,:rfr,:currtime,:newprt,:winpos))
	i SQLCODE'=0  TRo 
	i SQLCODE'=0 q -2
	s retrow=+$g(%ROWID)
	i reqrow'=""  d
	   .&sql(update dhc_phrequest set phreq_retflag='1' where phreq_rowid=:reqrow) 
	   .i SQLCODE'=0 s retmain="-1"
	i retmain="-1" TRo 
	i retmain="-1" q -3
	s retline=0,lt=0
	s retline=$l(RetInf,"&")
	for lt=1:1:retline q:(retmain'=0)  d
	  .s retitmstr="",phditm="",retqty="",retmoney=0,retunit="",retsub="",reqcode=""
	  .s retitmstr=$p(RetInf,"&",lt)
	  .s phditm=$p(retitmstr,"^",1)
	  .s retqty=$p(retitmstr,"^",2)
	  .s retmoney=$p(retitmstr,"^",3)
	  .s retunit=$p(retitmstr,"^",4)
	  .s retsub=$p(retitmstr,"^",5)
	  .s retmain=##class(web.DHCOutPhReturn).DoRetItm(retrow,phditm,retqty,retmoney,retunit,retsub,reqrow)
    i retmain'=0 TRo
    i retmain'=0 q -4
	TCOMMIT
 q retrow
}

ClassMethod DoRetItm(retrow As %Library.String = "", phditm As %Library.String = "", retqty As %Library.String = "", retmoney As %Library.String = "", retunit As %Library.String = "", sub As %Library.String = "", reqrow As %Library.String = "")
{
	s currdate=$p($h,",",1)
	s phd="",itm="",php=""
	s phd=$p(phditm,"||",1)
	s itm=$p(phditm,"||",2)
	s php=+$p(^DHCPHRET(retrow),"^",8)
	s user="",oeori=""
	s user=+$p(^DHCPHPER(php),"^",5)
	s oeori=$p(^DHCPHDI(phd,"PHDI",itm),"^",5)
	s prtdr=""
	s prtdr=+$p(^DHCPHDISP(phd),"^",2)
	s inv=$p(^DHCINVPRT(prtdr),"^",14)
	s ord="",ordi=""
	s ord=$p(oeori,"||",1)
	s ordi=$p(oeori,"||",2)
	s itmmast=""
	s itmmast=$p(^OEORD(ord,"I",ordi,1),"^",2)      ;arc_itmmast
	s itmmastid="",itmmastver=""
	s itmmastid=$p(itmmast,"||",1)
	s itmmastver=$p(itmmast,"||",2)
	s currdate=""
	s currdate=$p($h,",",1)
	s inci=""
	s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
	q:inci="" -1
	s inci=$p(inci,$c(1),1)
	s phuomid=""
	s phuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	q:phuomid=""
	s phuomid=$p(phuomid,$c(1),1)
	s puruom="",basuom="",newqty=0,newunit=""
	s puruom=+$p(^INCI(inci,3),"^",6)
	s basuom=+$p(^INCI(inci,1),"^",10)
	s confac=1,conrow=""
	i phuomid=basuom s confac=1
	e  d
	   .s conrow=$o(^CT("CTCF",0,"UOM",phuomid,basuom,conrow))
	   .s confac=+$p(^CT("CTCF",conrow),"^",3)
	i retunit=basuom  d
	  .s newqty=retqty
	  .s newunit=retunit
	e  d
	  .s newqty=retqty*confac
	  .s newunit=basuom
	i (retmoney<1)&(retmoney'["0.") d
	   .s retmoney="0"_retmoney
	s $p(^DHCPHDI(phd,"PHDI",itm),"^",6)=$p(^DHCPHDI(phd,"PHDI",itm),"^",6)+newqty
    &sql(insert into sqluser.dhc_phretitm(phrti_phret_parref,phrti_amount,phrti_childsub,phrti_oeori_dr,phrti_retqty,phrti_unit_dr)
	     values(:retrow,:retmoney,:sub,:oeori,:newqty,:newunit))
	i SQLCODE'=0 q -1
	s err=0
	s bas=1
	s basqty=0
	s basqty=newqty
	s retreason=""
	s phdirow=phd_"||"_itm
	;修改申请子表中的退药数量
	i reqrow'=""  d
	  .s reqsub="" 
	  .f  s reqsub=$o(^DHCPHREQ(reqrow,"I",reqsub)) q:reqsub=""  d
	  ..s reqphdirow=""
	  ..s reqphdirow=$P(^DHCPHREQ(reqrow,"I",reqsub),"^",1)
	  ..q:reqphdirow'=phdirow
	  ..s $P(^DHCPHREQ(reqrow,"I",reqsub),"^",5)=newqty
	s retreason=$p(^DHCPHRET(retrow),"^",13)
	s lqty=0
	s lqty=basqty
	;s err=##CLASS(DHCOutPhReturn).UpdatPhdinclb(phditm,basqty)
	s retval=0
	s retval=##CLASS(DHCOutPhDisp).InsertDHCOEDisp(oeori,newqty,newunit, retrow_"||"_sub,"R","H",user)
	i retval'=0 q -1
	s retval=##class(web.DHCOutPhModCZ).ModPhReturn(retrow,sub,user,phditm)
	i retval'=0 q -1
 q 0
}

ClassMethod CheckReturn(prt As %Library.String = "")
{
	/*
  	s HospitalCode="",curprt=""
	s str=$g(^DHCDocConfig("CurrentHospital"))
	s HospitalCode=$p(str,"^",1)
    i HospitalCode="ZGYDYY"  d
      .s curprt=+$p(^DHCPHREQ(prt),"^",5)
    e  s curprt=prt
  s ret=""
  s nprt=""
  s nprt=$o(^DHCINVPRT(0,"OldINV",curprt,"")) 
  i (nprt'="")&(nprt'="0") q -1
  */
  q 0
}

ClassMethod UpdatPhdinclb(phdi As %Library.String = "", mqty As %Library.String = "")
{
  s mqty=$g(mqty)
  s phd=$p(phdi,"||",1)
	    s phditm=$p(phdi,"||",1)
	    s phdic=""
	    k ^S
	    f  s phdic=$o(^DHCPHDI(phd,"PHDI",phditm,"INCLB",phdic)) q:(phdic="")!(mqty=0)  d
	      .s phinclb="",phqty=0,phretqty=0,^S=^DHCPHDI(phd,"PHDI",phditm,"INCLB",phdic)
	      .s phqty=+$p(^S,"^",1),phretqty=+$p(^S,"^",2),phinclb=$p(^S,"^",3)
	      .i (phqty-phretqty)'<mqty  d
	        ..s $p(^S,"^",2)=$p(^S,"^",2)+mqty
	        ..s mqty=0
	      .e  d
	        ..s $p(^S,"^",2)=phqty
	        ..s mqty=mqty-phqty+phretqty
	       q 0
}

ClassMethod GUserName(userid As %Library.String = "")
{
  s username=""
  i userid="" q username
  s username=$p(^SSU("SSUSR",userid),"^",2)
  q username
}

ClassMethod GSysDate()
{
  s sysdate=""
  s sysdate=$zd(+$h,3)
  q sysdate
}

ClassMethod DeleteReturn(retrow As %Library.String = "")
{
 &Sql(delete from sqluser.dhc_phreturn where phret_rowid=:retrow)
 q SQLCODE
}

ClassMethod UpdatePhWin(itmjs As %Library.String = "", itmjsex As %Library.String = "", ctloc As %Library.String = "", pyusr As %Library.String = "", phw As %Library.String = "", fydr As %Library.String = "")
{
   s phl="",ret=""
   s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
   s locdesc=$p(^CTLOC(ctloc),"^",2)
   s pydr="",pyname=""
   s pydr=$o(^DHCPHPERi("USR",pyusr,""))
   i (phl="")!(pydr="") s ret="" 
   e  d 
     .s count=0
     .&sql(select count(phwp_rowid) into :count from sqluser.dhc_phwper
       where phwp_phl_dr=:phl and phwp_phw_dr=:phw)
     .i count=0 d
        ..&sql(insert into sqluser.dhc_phwper(phwp_phl_dr,phwp_doflag,phwp_phw_dr,phwp_php_pydr,phwp_php_fydr)
          values(:phl,'0',:phw,:pydr,:fydr))
     .s pyname=$p(^DHCPHPER(pydr),"^",2)
     .
     .s ret=locdesc_"^"_phl_"^"_phw_"^"_pyname_"^"_fydr
 s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod QueryPRTClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryPRTExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryPRTExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "", CDate As %Library.String = "", CPmiNo As %Library.String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	s phl="",stdate=""
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	;modify by tang 2008-07-30
	s basphl="",basloc=""
	s basphl=##class(web.DHCOutPhAdd).GetTwoPhlFrThree(phl)
	s basloc=+$p(^DHCPHLOC(basphl),"^",1)
	
	i phl="" Set QHandle=$lb(0,repid,0)	Quit $$$OK
	i CPmiNo=""  Set QHandle=$lb(0,repid,0)	Quit $$$OK
	i CDate'="" s stdate=$zdh(CDate,4)
	s pmi="",m=0,pername="",lzero=""
	;^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
    s pmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(CPmiNo),""))
   
    s pername=$p(^PAPER(pmi,"ALL"),"^",1)
    s phd="0"
    f  s phd=$o(^DHCPHDISPi("PAPMI",pmi,phd)) q:(phd="")!(phd="0")   d
      .s prt="",phdphl="",newprt=""
      .q:'$d(^DHCPHDISP(phd))
      .s prt=+$p(^DHCPHDISP(phd),"^",2)
      .s phdphl=+$p(^DHCPHDISP(phd,1),"^",1)
      .;modify by tang 20080730
      .s phdbasphl=""
      .s phdbasphl=##class(web.DHCOutPhAdd).GetTwoPhlFrThree(phdphl)
      .q:phdbasphl'=basphl
      .q:'$d(^DHCINVPRT(prt))
      .s fyflag=$p(^DHCPHDISP(phd),"^",4)
      .q:fyflag'="1"
      .s newprt=$$GetNewPrt(prt)
      .i newprt=""  s newprt=prt
      .s prtdate="",phdl="",prescno=""
      .s prtdate=+$p(^DHCINVPRT(newprt),"^",5)
      .q:(prtdate'=stdate)&(stdate'="")
      .s phdsub="",ph=0
      .f  s phdsub=$o(^DHCPHDI(phd,"PHDI",phdsub)) q:(phdsub="")!(ph=1)  d
        ..s dispqty=0,retqty=0,cyqty=0
        ..;
        ..s dispqty=+$p(^DHCPHDI(phd,"PHDI",phdsub),"^",4)
        ..s retqty=+$p(^DHCPHDI(phd,"PHDI",phdsub),"^",6)
        ..s cyqty=dispqty-retqty
        ..;q:retqty'=0
        ..q:cyqty=0
        ..s ph=ph+1
      .q:ph=0
      .s prtdate=$zd(prtdate,3)
      .s prescno=$p(^DHCPHDISP(phd,2),"^",1)
      .s prtinv=""
      .s prtinv=$p(^DHCINVPRT(newprt),"^",14)
	  .set Data=$lb(prtinv,pername,prtdate,prt,prescno,newprt)
 	  .Set ^CacheTemp(repid,ind)=Data	
 	  .Set ind=ind+1
    s ^TA=ind
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
GetNewPrt(prt)
	s nprt="0",gnprt=""
	s lprt="",lprt=prt
	f  s nprt=$o(^DHCINVPRT(0,"OldINV",lprt,nprt)) q:(nprt="")!(nprt="0")  d
	  .s lprt=nprt                                                                                                        
	  .s gnprt=nprt
    i (gnprt="")!(gnprt="0") s gnprt=prt
    quit gnprt
}

ClassMethod QueryPRTFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPRTExecute ]
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

Query QueryPRT(ctloc As %String, CDate As %String, CPmiNo As %String) As %Query(ROWSPEC = "收据:%String,姓名:%String,日期:%String,ID:%String,处方:%String,新ID:%String")
{
}

ClassMethod GetRetInf(reqrow)
{
     s curryear="",currdate=$zd(+$h,3)
      s ret=""
	  s curryear=$p(currdate,"-",1)
	  s flag=""
	  s flag=$p(^DHCPHREQ(reqrow),"^",11)
	  i flag="1" q ""
	  s reqitm=""
	  f  s reqitm=$o(^DHCPHREQ(reqrow,"I",reqitm)) q:reqitm=""  d
	  .s phditm="",phdrow="",phdsub="",reqqty=0,reqprice=0,reqmoney=0,price=0
	  .s phditm=$p(^DHCPHREQ(reqrow,"I",reqitm),"^",1)
	  .s reqqty=+$p(^DHCPHREQ(reqrow,"I",reqitm),"^",4)
	  .s phdrow=$p(phditm,"||",1)
	  .s phdsub=$p(phditm,"||",2)
	  .s inclb="",phdclb=""
	  .f  s phdclb=$o(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdclb)) q:(phdclb="")!(inclb'="")  d
	  ..s inclb=$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdclb),"^",3) 
	  .s incbatdr="",batcode=""
	  .i inclb'=""  d
	  ..s incbatdr=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	  ..s batcode=$p( ^INCI($p(incbatdr,"||",1),"IB",$p(incbatdr,"||",2)),"^",1)
	  .
	  .s orditm="",ord="",itm="",prt=""
	  .s prt=+$p(^DHCPHDISP(phdrow),"^",2)
	  .s orditm=$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",5)
	  .s reqprice=##CLASS(web.DHCOutPhDisp).GetBasPrice(prt,orditm)
	  .s ord=$p(orditm,"||",1)
	  .s itm=$p(orditm,"||",2)
	  .s itmmast="",itmmastver="",itmmastid=""
	  .s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
	  .s phuomid="",phuomdesc=""
	  .s itmmastid=$p(itmmast,"||",1)
	  .s itmmastver=$p(itmmast,"||",2)
	  .s phuomid="",phuomdesc="",phdesc="",basuom=""
	  .s phuomid=+$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	  .s inci="",incode=""
	  .s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
	  .q:inci=""
	  .s inci=$p(inci,$c(1),1)
	  .s basuom=+$p(^INCI(inci,1),"^",10)
	  .s qty=0,retqty=0,phgg=""
	  .;s phgg=$p(^INCI(inci,3),"^",9)
	  .s phgg=##class(web.DHCSTKUTIL).GetSpec(inci)  
	  .s seqno=""
	  .s seqno=$p(^OEORD(ord,"I",itm,3),"^",4)
	  .s qty=+$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",4)
	  .s paymoney=+$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",4)
	  .s retqty=$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",6)
	  .i retqty="" s retqty=0
	  .s retqty=$p(retqty,$c(1),1)
	  .s qty=qty-retqty
	  .s curconfact=1,dispqty=0,dispmoney=0
	  .s curconfact=..GetConFac(phuomid,basuom)
	  .s price=reqprice*curconfact
	  .s reqmoney=reqqty*price
	  .s dispqty=qty/curconfact
	  .s dispmoney=dispqty*price
	  .s phuomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
	  .s phdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) 
	  .i ret="" s ret=phdesc_"^"_phuomdesc_"^"_price_"^"_dispqty_"^"_dispmoney_"^"_reqqty_"^"_reqmoney_"^"_phditm_"^"_phuomid_"^"_phgg_"^"_seqno_"^"_batcode
	  .e  s ret=ret_$c(1)_phdesc_"^"_phuomdesc_"^"_price_"^"_dispqty_"^"_dispmoney_"^"_reqqty_"^"_reqmoney_"^"_phditm_"^"_phuomid_"^"_phgg_"^"_seqno_"^"_batcode
   q ret
}

ClassMethod QueryRetPhClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryRetPhExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryRetPhExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "", CPrt As %Library.String = "", CPrescNo As %Library.String = "", CurrReqNo As %Library.String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s HospitalCode=""
	s str=$g(^DHCDocConfig("CurrentHospital"))
	s HospitalCode=$p(str,"^",1)
	s HospitalCode="ZGYDYY"
	s ind=1
	s phl=""
	s ^TANGD=ctloc_"^"_CPrt_"^"_CPrescNo_"^"_CurrReqNo
	i (ctloc="")&(HospitalCode'="ZGYDYY") Set QHandle=$lb(0,repid,0) Quit $$$OK
	i (CPrt="")&(HospitalCode'="ZGYDYY") Set QHandle=$lb(0,repid,0) Quit $$$OK
	i (ctloc'="") s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i (phl="")&(HospitalCode'="ZGYDYY") Set QHandle=$lb(0,repid,0) Quit $$$OK
	s pmi="",m=0,pername="",lzero=""
    s phd="",prt=""
    i (HospitalCode="ZGYDYY")&(CPrt="") 
    {
  	 s Data=$lb("","","","","","","","","","","","")
 	 S ^CacheTemp(repid,ind)=Data	
 	 S ind=ind+1
    }
    else
    {
	  s prt=CPrt
	;modify by tang 2008-07-31
	s phglrow="",twoloc="",chgroup=""
	s twoloc=##class(web.DHCOutPhAdd).GetBasLoc(ctloc)
	s chgroup=##class(web.DHCOutPhAdd).CheckGroupLoc(ctloc)
	f  s phglrow=$o(^DHCPHGLi(twoloc,phglrow)) q:phglrow=""  d
	  .s newphl=""
	  .s newphl=+$p(^DHCPHGL(phglrow),"^",5)
	  .s phld=""
      .f  s phld=$o(^DHCPHDISPi("PRT",newphl,prt,phld)) q:phld=""  d
      ..s prescno=""
      ..s prescno=$p(^DHCPHDISP(phld,2),"^",1)
      ..q:prescno'=CPrescNo
      ..s phd=phld
     i chgroup="0"  d
      .s phld=""
      .f  s phld=$o(^DHCPHDISPi("PRT",phl,prt,phld)) q:phld=""  d
      ..s prescno=""
      ..s prescno=$p(^DHCPHDISP(phld,2),"^",1)
      ..q:prescno'=CPrescNo
      ..s phd=phld
    i (phd="")&(twoloc'="") Set QHandle=$lb(0,repid,0) Quit $$$OK
   
    s phdi="",fyflag=""
	s fyflag=$p(^DHCPHDISP(phd),"^",4)
	i fyflag'="1" Set QHandle=$lb(0,repid,0) Quit $$$OK
	f  s phdi=$o(^DHCPHDI(phd,"PHDI",phdi)) q:phdi=""  d
	 .s oeori="",payamount="",retqty="",qty="",price=0
	 .s oeori=$p(^DHCPHDI(phd,"PHDI",phdi),"^",5)
	 .s payamount=$p(^DHCPHDI(phd,"PHDI",phdi),"^",3)
	 .s payamount=$p(payamount,$c(1),1)
	 .s qty=+$p(^DHCPHDI(phd,"PHDI",phdi),"^",4)
	 .;s price=payamount/qty
	 .s price=##CLASS(web.DHCOutPhDisp).GetBasPrice(prt,oeori)
	 .s retqty=$p(^DHCPHDI(phd,"PHDI",phdi),"^",6)
	 .i retqty="" s retqty=0
	 .s retqty=$p(retqty,$c(1),1)
	 .s qty=qty-retqty
	 .;q:retqty>0
	 .q:qty=0
	 .s ord="",itm=""
	 .s ord=$p(oeori,"||",1)
	 .s itm=$p(oeori,"||",2)
	 .s seqno=""
	 .s seqno=$p(^OEORD(ord,"I",itm,3),"^",4)
	 .s itmmast="",itmmastid="",itmmastver="",phdesc=""
	 .s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
	 .s phuomid="",phuomdesc=""
	 .s itmmastid=$p(itmmast,"||",1)
	 .s itmmastver=$p(itmmast,"||",2)
	 .s phuomid=+$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	 .s inci="",incode=""
	 .s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
	 .q:inci=""
	 .s inci=$p(inci,$c(1),1)
	 .s itmcost=0,taruom=""
	 .s puruom="",puruomdesc="",phgg=""
	 .;s phgg=$p(^INCI(inci,3),"^",9)
	 .s phgg=##class(web.DHCSTKUTIL).GetSpec(inci)  
	 .s puruom=+$p(^INCI(inci,3),"^",6)
	 .s basuom="",basuomdesc=""
	 .s basuom=+$p(^INCI(inci,1),"^",10)
	 .s puruomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
	 .s basuomdesc=$p($g(^CT("UOM",basuom)),"^",2)
	 .s confac=1,conrow=""
	 .i phuomid=basuom s confac=1
	 .e  d
	    ..s conrow=$o(^CT("CTCF",0,"UOM",phuomid,basuom,conrow))
	    ..s confac=+$p(^CT("CTCF",conrow),"^",3)
	 .s newqty=0,newunit="",getnum=0,newunitdesc="",newprice=0
	 .s getnum=$p((qty/confac),".",1)
	 .i getnum="" s getnum=0
	 .i getnum=(qty/confac) d
	   ..s newunit=puruom
	   ..s newunitdesc=puruomdesc 
	   ..s newqty=getnum
	   ..s newprice=price*confac
	 .e  d  
	   ..s newunit=basuom
	   ..s newunitdesc=basuomdesc 
	   ..s newqty=qty
	   ..s newprice=price
	 .s phdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  
	 .q:phdesc=""                                           ;INCI_DESC
	 .s phdirow=""
	 .s phdirow=phd_"||"_phdi
	  .s inclb="",phdclb=""
	  .f  s phdclb=$o(^DHCPHDI(phd,"PHDI",phdi,"INCLB",phdclb)) q:(phdclb="")!(inclb'="")  d
	  ..s inclb=$p(^DHCPHDI(phd,"PHDI",phdi,"INCLB",phdclb),"^",3) 
	  .s incbatdr="",batcode=""
	  .s incbatdr=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	  .s batcode=$p( ^INCI($p(incbatdr,"||",1),"IB",$p(incbatdr,"||",2)),"^",1)

	 .s dispmoney=0
	 
	 .s dispmoney=newprice*newqty
	 .s newprice=$j(newprice,12,4)
	 .s dispmoney=$j(dispmoney,12,2)
	 .s oeflag="",ordstatus=""
	 .s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",2)       ;医嘱状态
     .i oeflag["停" s ordstatus="1"
     .s newretqty="",retmoney=""
     .i ordstatus="1"  d             ;衢州退药要求
     ..s newretqty=newqty
     ..s retmoney=dispmoney
	 .i HospitalCode["BJYKYZLYY"  d
	      ..i phdesc["(" s phdesc=$p(phdesc,"(",1)
	      ..i phdesc["[" s phdesc=$p(phdesc,"[",1)
	 .s Data=$lb(phdesc,newunitdesc,newprice,newqty,dispmoney,newretqty,retmoney,phdirow,newunit,phgg,seqno,batcode,ordstatus)
 	 .S ^CacheTemp(repid,ind)=Data	
 	 .S ind=ind+1
 	 .s phdesc="",phuomdesc="",qty=0,retqty=0,phdirow=""

	   }
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryRetPhFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRetPhExecute ]
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

//phdesc,newunitdesc,newprice,getqty,"","",phdirow,newunit

Query QueryRetPh(ctloc As %String, CPrt As %String, CPrescNo As %String, CurrReqNo As %String) As %Query(ROWSPEC = "TPhdesc:%String,TPhUom:%String,TPrice:%String,TDispQty:%String,TDispMoney:%String,TRetQty:%String,TRetMoney:%String,TPhdItm:%String,TPhUomid:%String,TPhgg:%String,TSeqNo:%String,TIncDispBatCode:%String,TOrdStatus:%String")
{
}

ClassMethod QueryReturnPhClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryReturnPhExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryReturnPhExecute(ByRef QHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	 s ind=1
	 s phdesc="",phuomdesc="",getqty="",retqty="",phdirow="",newunitdesc="",newprice="",newunit=""
	 s Data=$lb(phdesc,newunitdesc,newprice,getqty,dispmoney,"","",phdirow,newunit)
 	 S ^CacheTemp(repid,ind)=Data	
 	 S ind=ind+1
 	 s phdesc="",phuomdesc="",qty=0,retqty=0,phdirow=""

 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryReturnPhFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReturnPhExecute ]
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

Query QueryReturnPh() As %Query(ROWSPEC = "TPhdesc:%String,TPhUom:%String,TPrice:%String,TDispQty:%String,TDispMoney:%String,TRetQty:%String,TRetMoney:%String,TPhdItm:%String,TPhUomid:%String")
{
}

ClassMethod QueryRetReasClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryRetReasExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryRetReasExecute(ByRef QHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	/*
    s rfr=""
    f  s rfr=$o(^BLC("RFR",rfr)) q:rfr=""  d
	   .s rfrdesc=""
	   .s rfrdesc=$p(^BLC("RFR",rfr),"^",2)
	   .q:rfr=0
       .set Data=$lb(rfrdesc,rfr)
 	   .Set ^CacheTemp(repid,ind)=Data	
 	   .Set ind=ind+1
 	   */
 	/// 修改:退药原因取计费组退费原因表-DHC_INVOPRefReason 
 	/// bianshuai 2015-12-17
	s irr=""
	f  s irr=$o(^DHCINVOPREFR(irr)) q:irr=""  d
	.q:irr=0
	.s irrdesc=$p(^DHCINVOPREFR(irr),"^",2)  ///描述
	.set Data=$lb(irrdesc,irr)
	.Set ^CacheTemp(repid,ind)=Data	
	.Set ind=ind+1
	
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryRetReasFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRetReasExecute ]
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

Query QueryRetReas() As %Query(ROWSPEC = "CRetReason:%String,CRetReasonid:%String")
{
}

ClassMethod GPatName(itmjs As %Library.String = "", itmjsex As %Library.String = "", pmino As %Library.String = "")
{
   s pmi=""	,pername="",ret="",perage="",age=""
   Set Config=##Class(websys.Configuration).%OpenId(1)
   Set MEDDATA=Config.DataNamespace            ;得到当前的MEDTRAK的NameSpace,保存到MEDDATA中
   Set LABDATA=Config.LabDataNamespace         ;得到当前的LABTRAK的NameSpace,保存到LABDATA中
   Set CurrentNS=$ZNSPACE                      ;保存当前所用的NameSpace  
   ZN MEDDATA                                  ;切换到所希望的NameSpace,
   s pmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(pmino),""))
   zn CurrentNS
   i pmi="" s ret="",patadd="",pataddint=0
   s sysdate=$p($h,",",1)
   i pmi'=""  d
   .s pername=$p(^PAPER(pmi,"ALL"),"^",1)
   .s perage=$p(^PAPER(pmi,"ALL"),"^",6)
   .s cydate=sysdate-perage
   .i cydate<365 s age=cydate_"天"
   .else  s age=cydate/365,age=$p(age,".",1),age=age_"岁"
   .s pataddint=$g(^PAPER(pmi,"PER","ADD",0))
   .s patadd=$g(^PAPER(pmi,"PER","ADD",pataddint))
    .s ret=pername_"^"_age_"^"_patadd
   s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
   i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
   &javascript<#(retval)#>
  q 1
}

ClassMethod GetLocDescFrID(ctloc)
{
 s desc=""
 s desc=$p(^CTLOC(ctloc),"^",2)
 i desc["-" s desc=$p(desc,"-",2)
 q desc
}

ClassMethod QueryDepClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryDepExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryDepExecute(ByRef QHandle As %Binary, input As %Library.String = "") As %Status
{
  
	Set repid=$I(^CacheTemp)
	s ind=1
	i input="" S QHandle=$lb(0,repid,0)	Quit $$$OK 
	s input=$g(input)
	s input=$ZCVT(input,"U") 
	s ctloc=0
	f  s ctloc=$o(^CTLOC(ctloc)) q:ctloc=""  d
	  .s ctlocdesc="",loctype=""
	  .s ctlocdesc=$p(^CTLOC(ctloc),"^",2)
	  .s ctlocdesc=$ZCVT(ctlocdesc,"U")
	  .q:ctlocdesc'[input
	  .set Data=$lb(ctlocdesc,ctloc)
	  .Set ^CacheTemp(repid,ind)=Data
	  .Set ind=ind+1
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryDepFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDepExecute ]
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

Query QueryDep(input As %String) As %Query(ROWSPEC = "科室:%String,ID:%String")
{
}

ClassMethod QueryDoctorClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryDoctorExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryDoctorExecute(ByRef QHandle As %Binary, CDepCode As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	;i CDepCode="" S QHandle=$lb(0,repid,0)	Quit $$$OK 
	s ctcarvp=0
	f  s ctcarvp=$o(^CTPCP(ctcarvp)) q:(ctcarvp="")!(ctcarvp="0")  d
	  .s ctcardesc="",loctype="",ctloc=""
	  .;s ctloc=+$p(^CTPCP(ctcarvp,3),"^",3)
	  .;q:ctloc'=CDepCode
	  .s ctcardesc=$p(^CTPCP(ctcarvp,1),"^",2)
	  .set Data=$lb(ctcardesc,ctcarvp)
	  .Set ^CacheTemp(repid,ind)=Data
	  .Set ind=ind+1
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryDoctorFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDoctorExecute ]
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

Query QueryDoctor(CDepCode As %String) As %Query(ROWSPEC = "医生:%String,ID:%String")
{
}

ClassMethod RetMoney(ctloc As %String = "", userid As %String, groupid As %String, newprt As %String, retrow As %String, card As %String)
{
	s ret=""
	s card=""
	i card=""  q 100
	s Flag="",PrtFlag="",InvNo="",PayMode="",InvMoney=0,retmoney=0,retorditm=""
	s Flag=$p(^DHCINVPRT(newprt),"^",8)
    s PrtFlag=$p(^DHCINVPRT(newprt),"^",3)
    s InvNo=$p(^DHCINVPRT(newprt),"^",14)
    s InvMoney=+$p(^DHCINVPRT(newprt),"^",16)
    s MoneyFlag="",ChYMoney=0
    s retsub=""
    f  s retsub=$o(^DHCPHRTI(retrow,"RTI",retsub)) q:retsub=""  d
      .s submoney=0,orditm=""
      .s submoney=+$p(^DHCPHRTI(retrow,"RTI",retsub),"^",1)
      .s orditm=$p(^DHCPHRTI(retrow,"RTI",retsub),"^",2)
      .s retmoney=retmoney+submoney
      .i retorditm=""  s retorditm=orditm
      .e  s retorditm=retorditm_"^"_orditm
    i InvMoney-retmoney<0.02  s MoneyFlag="0"
    e  s MoneyFlag="1"
    s ChYMoney=InvMoney-retmoney
    i ChYMoney<0.02 s ChYMoney=0
    s retcode=""
    if ((InvNo="") & (Flag="N") & (PrtFlag'="P"))  d
      .s PayMode=$p(^DHCINVPRT(newprt,"P",1),"^")
      .s retcode=##class(web.udhcOPRefEditIF).RefundReceipt(newprt,userid,"S",retorditm,ChYMoney,groupid,MoneyFlag,ctloc,PayMode)
      .i retcode=""  s ret=300
      .e  d
        ..s ret=$p(retcode,"^",1)
        ..i ret="" s ret=300
    e  q 200
	
    q ret
}

ClassMethod CheckIncBat(phditm, batcode)
{
	s phd=$p(phditm,"||",1)
	s phloc=+$p(^DHCPHDISP(phd,1),"^",1)
	s loc=+$p(^DHCPHLOC(phloc),"^",1)
	s phdsub=$p(phditm,"||",2)
	s sysdate=+$h
	s orditm=$p(^DHCPHDI(phd,"PHDI",phdsub),"^",5)
	s ord="",itm=""
	s ord=$p(orditm,"||",1)
	s itm=$p(orditm,"||",2)
	s itmmast="",inc=""
	s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)   
	s inc=$o(^INCI(0,"ARCIM_DR",+itmmast,""))
	s incloc=$o(^INCI("IL_LOC",loc,inc,""))   
	s incbat="0",ret=0
	f  s incbat=$o(^INCI(inc,"IB",incbat)) q:(incbat="")!(incbat="0")  d
	  .s itmbat=""
	  .s itmbat=$p(^INCI(inc,"IB",incbat),"^",1)
	  .q:itmbat'=batcode
	  .s itmcib=""
	  .s itmcib=inc_"||"_incbat
	  .s clb="",inclb=""
	  .f  s clb=$o(^INCI("LB_IB",itmcib,inc,incloc,clb)) q:clb=""  d
	    ..s inclb=inc_"||"_incloc_"||"_clb
	  .s ingdrec=""
	  .s cibrow=""
	  .s cibrow=..GetValue(inclb)
	  .s ingdrec=$o(^INGRI("GRI_INCIB",cibrow,"")) 
	  .s ingrdate=""
	  .s ingrdate=+$p(^INGR(ingdrec),"^",4)
	  .q:(sysdate-ingrdate)>365
	  .s ingdri="0"
	  .f  s ingri=$o(^INGRI("GRI_INCIB",cibrow,ingdrec,ingdri)) q:(ingdri="")!(ret'=0)  d 
	  ..s xqdate=""
	  ..s xqdate=+$p(^INGR(ingdrec,"GRI",ingri),"^",9)
	  ..i xqdate<sysdate  d
	  ...s ret=3 ;效期已过
	  ..;e  i (xpdate-sysdate)<183  d
	  ..;.s ret=2 ;效期快到了
	  ..e  s ret=$zd(xqdate,3) ;正常退药
	q ret
}

ClassMethod GetRetReas(reqrow)
{
	s reasid="",reasdesc=""
	s reasid=+$p(^DHCPHREQ(reqrow),"^",13)
	//i reasid'=0 s reasdesc=$p(^BLC("RFR",reasid),"^",2)
	i reasid'=0 s reasdesc=$p(^DHCINVOPREFR(reasid),"^",2) ///取退费原因表 bianshuai 2015-12-17
	s ret=reasid_"^"_reasdesc
	q ret
}

ClassMethod GetValue(inclb)
{
   s ret=""
	Set Config=##Class(websys.Configuration).%OpenId(1)
        Set MEDDATA=Config.DataNamespace            ;得到当前的MEDTRAK的NameSpace,保存到MEDDATA中
        Set LABDATA=Config.LabDataNamespace         ;得到当前的LABTRAK的NameSpace,保存到LABDATA中
        Set CurrentNS=$ZNSPACE                      ;保存当前所用的NameSpace  
        ZN MEDDATA                                  ;切换到所希望的NameSpace,
      s ret=$$CIBrow^at299(inclb)     
         ZN CurrentNS 
      q ret
}

ClassMethod GetReqNo(loc, pmino)
{
  	s pmidr=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(pmino),""))
  	i pmidr="" q ""
  	s sysdate=+$h
  	s reqdate=""
  	s phl=$o(^DHCPHLOCi("LOC",loc,""))
  	s basphloc=""
  	s basphloc=##class(web.DHCOutPhAdd).GetBasLoc(phl)
  	s ret=""
  	f reqdate=sysdate-2:1:sysdate  d
  	  .s reqrow=""
  	  .f  s reqrow=$o(^DHCPHREQi("PAPMI",pmidr,reqdate,reqrow)) q:reqrow=""  d
  	  ..s reqcode="",curr=1
  	  ..s reqcode=$p(^DHCPHREQ(reqrow),"^",2)
  	  ..s retflag=$p(^DHCPHREQ(reqrow),"^",11)
	  ..q:retflag="1"
	  ..s reqloc=""
	  ..s reqloc=+$p(^DHCPHREQ(reqrow),"^",3)
	  ..q:reqloc'=loc
  	  ..i reqdate=sysdate  s curr=1
  	  ..i ret="" s ret=reqcode_"^"_reqrow_"^"_curr
  	  ..e  s ret=ret_"&"_reqcode_"^"_reqrow_"^"_curr
  	 q ret
}

ClassMethod QueryRequestClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryRequestExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryRequestExecute(ByRef QHandle As %Binary, CPrtInv As %Library.String = "") As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	s prt="",prtnum=""
	i (CPrtInv="")  Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s prt=$o(^DHCINVPRT(0,"INV",CPrtInv,prt),-1)
	i (prt="0")!(prt="")  Set QHandle=$lb(0,repid,0)	Quit $$$OK
	k ^DHCTMPPRTDSP($j)
	s prtnum=..GetFYPrt(prt)
	s allprt=""
	f  s allprt=$o(^DHCTMPPRTDSP($j,allprt)) q:allprt=""  d                     
	.s phl=""
	.f  s phl=$o(^DHCPHLOC(phl)) q:phl=""  d
	  ..s RecLoc="",RecLocDesc=""
	  ..s RecLoc=+$p(^DHCPHLOC(phl),"^",1)
	  ..s RecLocDesc=$p(^CTLOC(RecLoc),"^",2)
	  ..s phdrow=""
	  ..f  s phdrow=$o(^DHCPHDISPi("PRT",phl,allprt,phdrow)) q:phdrow=""  d
	  ...s prescno="",prtinv="",phw="",wintype="",prtdate=""
	  ...s fyflag=""
	  ...s fyflag=$p(^DHCPHDISP(phdrow),"^",4)
	  ...q:fyflag'="1"
	  ...s prescno=$p(^DHCPHDISP(phdrow,2),"^",1)
	  ...s prtinv=$p(^DHCINVPRT(allprt),"^",14)
	  ...s prtdate=+$p(^DHCINVPRT(allprt),"^",5)
	  ...s prtdate=$zd(prtdate,3)
	  ...s phw=+$p(^DHCPHDISP(phdrow,1),"^",4)
	  ...i phw'=0 s wintype=$g(^DHCPHWINTYPE(phw))
	  ...q:wintype="5"
	  ...s phdsub=""
	  ...f  s phdsub=$o(^DHCPHDI(phdrow,"PHDI",phdsub)) q:phdsub=""  d
	  ....s orditm="",ord="",itm="",phditm="",dispqty=0,retqty=0,price=0
	  ....s orditm=$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",5)
	  ....s dispqty=+$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",4) 
	  ....s retqty=+$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",6)
	  ....q:retqty=dispqty
	  ....s phdqty=0
	  ....s phdqty=dispqty-retqty
	  ....s ord=$p(orditm,"||",1)
	  ....s itm=$p(orditm,"||",2)
	  ....s phditm=phdrow_"||"_phdsub
	  ....s phreq="",reqqty=0
	  ....;取申请单中的记录
	  ....f  s phreq=$o(^DHCPHREQi(phditm,"PHDI",phreq)) q:phreq=""  d
	  .....s zfflag="",retflag=""
	  .....s zfflag=$p(^DHCPHREQ(phreq),"^",1)
	  .....q:zfflag="1"
	  .....s retflag=$p(^DHCPHREQ(phreq),"^",11)
	  .....q:(retflag'="0")&(retflag'="")
	  .....s phreqsub=""
	  .....f  s phreqsub=$o(^DHCPHREQi(phditm,"PHDI",phreq,phreqsub)) q:phreqsub=""  d
	  ......s phreqphdi="",lreqqty=0
	  ......s phreqphdi=$p(^DHCPHREQ(phreq,"I",phreqsub),"^",1)
	  ......q:phreqphdi'=phditm
	  ......s lreqqty=$p(^DHCPHREQ(phreq,"I",phreqsub),"^",4)
	  ......s reqqty=reqqty+lreqqty
	  ....s itmmast="",itmmastid="",itmmastver=""
	  ....s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2) 
	  ....s itmmastid=$p(itmmast,"||",1)
	  ....s itmmastver=$p(itmmast,"||",2)
	  ....s inci=""
	  ....s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
	  ....q:inci=""
	  ....s phdesc=""
	  ....s phdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)
	  ....s baseprice=0,phuomid="",basuom="",phuomdesc=""
	  ....s baseprice=##class(web.DHCOutPhDisp).GetBasPrice(allprt,orditm)
	  ....s baseprice=$fn(baseprice,"",4)
	  ....s phuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	  ....s phuomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
	  ....s basuom=+$p(^INCI(inci,1),"^",10)
	  ....s confac=""
	  ....s confac=..GetConFac(phuomid,basuom)
	  ....s reqqty=reqqty*confac
	  ....s phdqty=phdqty-reqqty
	  ....q:phdqty=0
	  ....s scrqty=0,scrprice=0
	  ....s scrqty=phdqty/confac
	  ....s scrprice=baseprice*confac
	  ....i RecLocDesc["-" s RecLocDesc=$p(RecLocDesc,"-",2)
	  ....set Data=$lb(RecLocDesc,RecLoc,phdrow,prescno,prtinv,allprt,prt,phditm,phdesc,scrqty,scrprice,"","",phuomdesc,"",prtdate)
	  ....Set ^CacheTemp(repid,ind)=Data
	  ....Set ind=ind+1
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryRequestFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRequestExecute ]
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

Query QueryRequest(CPrtInv As %String) As %Query(ROWSPEC = "TPhLocDesc:%String,TPhLoc:%String,TPhdRowid:%String,TPrescNo:%String,TPrtInv:%String,TPrt:%String,TNewPrt:%String,TPhdSub:%String,TPhDesc:%String,TPhQty:%String,TPhPrice:%String,TReqQty:%String,TReqMoney:%String,TPhUomDesc:%String,TReqCode:%String,TPrtDate:%String")
{
}

ClassMethod GetFYPrt(newprt)
{
	s retprt="0",jprt=1,dp=0
	while(jprt'=0)
	{
	  s dspflag=""
	  
	  s dspflag=##class(web.DHCOutPhReturn).CheckDisp(newprt)
	 
	  i dspflag'=0  d
	    .s ^DHCTMPPRTDSP($j,newprt)=newprt
	    .s dp=dp+1
	  s jprt=+$p(^DHCINVPRT(newprt),"^",29)
	  i jprt'=0 s newprt=jprt,retprt=jprt	
	}
	;i retprt="0" s retprt=newprt
    ;retprt
  q dp
}

ClassMethod GetConFac(fruom, touom)
{
  s fac=1,conrow=""
  i fruom=touom s fac=1
  e  d
	.s conrow=$o(^CT("CTCF",0,"UOM",fruom,touom,conrow))
	.i conrow'="" s fac=+$p(^CT("CTCF",conrow),"^",3)

 q fac
}

ClassMethod CheckInsRequest(phditm, qty)
{
  s phdrow="",dispitm="",dispqty=0,retqty=0,resqty=0,orditm="",ord="",itm=""
  s phdrow=$p(phditm,"||",1)
  s dispitm=$p(phditm,"||",2)
  s dispqty=+$p(^DHCPHDI(phdrow,"PHDI",dispitm),"^",4)
  s retqty=+$p(^DHCPHDI(phdrow,"PHDI",dispitm),"^",6)
  s orditm=$p(^DHCPHDI(phdrow,"PHDI",dispitm),"^",5)
  s ord=$p(orditm,"||",1)
  s itm=$p(orditm,"||",2)
  s itmmast="",itmmastid="",itmmastver=""
  s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2) 
  s itmmastid=$p(itmmast,"||",1)
  s itmmastver=$p(itmmast,"||",2)
  s inci=""
  s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
  s phdesc=""
  s phdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)
  s baseprice=0,phuomid="",basuom="",phuomdesc=""
  s phuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
  s basuom=+$p(^INCI(inci,1),"^",10)
  s confac="",yreqqty=0
  s confac=..GetConFac(phuomid,basuom)
  s resqty=dispqty-retqty
  s hreqqty=0
  s allreqretqty=0
  s reqrow=""
  f  s reqrow=$o(^DHCPHREQi("DISP",phdrow,reqrow)) q:reqrow=""  d
  .s reqsub=""
  .f  s reqsub=$o(^DHCPHREQ(reqrow,"I",reqsub)) q:reqsub=""  d
  ..s qtyreq=0,reqphditm=""
  ..s reqphditm=$p(^DHCPHREQ(reqrow,"I",reqsub),"^",1)
  ..q:reqphditm'=phditm
  ..s qtyreq=+$p(^DHCPHREQ(reqrow,"I",reqsub),"^",4)
  ..s reqretqty=0
  ..s reqretqty=+$p(^DHCPHREQ(reqrow,"I",reqsub),"^",5)
  ..s allreqretqty=allreqretqty+reqretqty
  ..s hreqqty=hreqqty+qtyreq
  i ((qty+hreqqty)*confac-allreqretqty)>resqty q -1
  q 0
}

ClassMethod InsertPhRequest(recloc, phd, nprt, prescno, phditm, qty, reason, userid, over)
{
  s ReqCode=0
  s sysdate=+$h
  s systime=$p($h,",",2)
  s curryear="",currdate=""
  s currdate=$zd(sysdate,3)
  s curryear=$p(currdate,"-",1)
  
  s pmi=$p(^DHCPHDISP(phd),"^",7)
  i '$d(^DHCTMPRequest(+$h)) d
   .k ^DHCTMPRequest
   .s ^DHCTMPRequest(+$h)=0
  s ins=0
  i $d(^DHCTMPRequest(userid,recloc,phd,nprt)) d
  .s phreqrow=""
  .f  s phreqrow=$o(^DHCPHREQi("DISP",phd,phreqrow),-1) q:(phreqrow="")!(ReqCode'=0)  d
   ..s newprt="",reqdate=""
   ..s newprt=+$p(^DHCPHREQ(phreqrow),"^",5)
   ..q:newprt'=nprt
   ..s reqdate=+$p(^DHCPHREQ(phreqrow),"^",4)
   ..q:reqdate'=sysdate
   ..s ReqCode=$p(^DHCPHREQ(phreqrow),"^",2)
   ..s retflag=""
   ..s retflag=$p(^DHCPHREQ(phreqrow),"^",11)
   ..q:retflag="1"
   ..s phreqsub="",sub=0
   ..f  s phreqsub=$o(^DHCPHREQ(phreqrow,"I",phreqsub)) q:phreqsub=""  d
    ...s sub=sub+1
   ..s sub=sub+1
   ..&sql(insert into sqluser.dhc_phreqitem(phreqi_phreq_parref,phreqi_child,
      phreqi_phdi_dr,phreqi_reqqty)
      values(:phreqrow,:sub,:phditm,:qty))
   ..s ins=ins+1
 i ins=0  d
  .s ^DHCTMPRequest(userid,recloc,phd,nprt)=phditm_"^"_qty_"^"_reason
  .;First GetReqCode
  .
  .&sql(select phreqc_code into :ReqCode from dhc_phreqcode where phreqc_year=:curryear)
  .i +ReqCode=0  d
  ..&sql(insert into sqluser.dhc_phreqcode(phreqc_year,phreqc_code)
     values(:curryear,1))
  .e  d
    ..&sql(update dhc_phreqcode set phreqc_code=phreqc_code+1 where phreqc_year=:curryear)
  .s ReqCode=+ReqCode+1
  .&sql(insert into dhc_phrequest(phreq_ctloc_dr,phreq_code,phreq_date,phreq_newprt_dr,phreq_papmi_dr,
    phreq_phd_dr,phreq_prescno,phreq_retreason,phreq_time,phreq_usr,phreq_year)
   values(:recloc,:ReqCode,:sysdate,:nprt,:pmi,:phd,:prescno,:reason,:systime,:userid,:curryear))
  .s phreqrow=""
  .s phreqrow=$g(%ROWID)
  .&sql(insert into dhc_phreqitem(phreqi_phreq_parref,phreqi_child,
      phreqi_phdi_dr,phreqi_reqqty)
   values(:phreqrow,1,:phditm,:qty))
  i over="1" d
    .k ^DHCTMPRequest(userid)
  q ReqCode
}

ClassMethod GetPmiNo(inv)
{
  s prt=""
  s prt=$o(^DHCINVPRT(0,"INV",inv,prt),-1)
  i prt="" q 0
  s pmi=""
  s pmi=+$p(^DHCINVPRT(prt),"^",15)
  s patname="",pmino=""
  s pmino=$p(^PAPER(pmi,"PAT",1),"^",2)
  s patname=$p(^PAPER(pmi,"ALL"),"^",1)
  s sysdate=+$h
  s prtdate=+$P(^DHCINVPRT(prt),"^",5)
  i sysdate-prtdate>2 q -1
  q pmino_"^"_patname
}

ClassMethod GetPrtFrPmi(CPmiNo)
{
    s pmi="",m=0,pername="",lzero="",ret=""
    i CPmiNo="" q ""
	;^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
    s pmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(CPmiNo),""))
    k ^DHCTMPPHPRT($j)
    s pername=$p(^PAPER(pmi,"ALL"),"^",1)
    s phd="0"
    f  s phd=$o(^DHCPHDISPi("PAPMI",pmi,phd)) q:(phd="")!(phd="0")   d
      .s prt="",phdphl="",newprt=""
      .s prt=+$p(^DHCPHDISP(phd),"^",2)
      .q:'$d(^DHCINVPRT(prt))
      .s fyflag=$p(^DHCPHDISP(phd),"^",4)
      .q:fyflag'="1"
      .s newprt=..GetNewPrtFrOld(prt)
      .i newprt=""  s newprt=prt
      .;
      .s prtdate="",phdl="",prescno=""
      .s prtdate=+$p(^DHCINVPRT(prt),"^",5)
      .s phdsub="",ph=0
      .f  s phdsub=$o(^DHCPHDI(phd,"PHDI",phdsub)) q:(phdsub="")!(ph=1)  d
        ..s dispqty=0,retqty=0,cyqty=0
        ..;
        ..s dispqty=+$p(^DHCPHDI(phd,"PHDI",phdsub),"^",4)
        ..s retqty=+$p(^DHCPHDI(phd,"PHDI",phdsub),"^",6)
        ..s cyqty=dispqty-retqty
        ..;q:retqty'=0
        ..q:cyqty=0
        ..s ph=ph+1
      .q:ph=0
      .q:$d(^DHCTMPPHPRT($j,newprt))
      .s ^DHCTMPPHPRT($j,newprt)=prt 
      .s prtdate=$zd(prtdate,3)
      .s prtinv=""
      .s prtinv=$p(^DHCINVPRT(newprt),"^",14)
      .i ret'="" s ret=ret_"^"_newprt_$C(1)_prtinv
      .e  s ret=newprt_$C(1)_prtinv
   q ret
}

ClassMethod GetNewPrtFrOld(prt)
{
	s nprt="0",gnprt=""
	s lprt="",lprt=prt
	f  s nprt=$o(^DHCINVPRT(0,"OldINV",lprt,nprt)) q:(nprt="")!(nprt="0")  d
	  .s lprt=nprt                                                                                                        
	  .s gnprt=nprt
    i (gnprt="")!(gnprt="0") s gnprt=prt
    quit gnprt
}

ClassMethod GetReas()
{
	s ret=""
	/*
	s rfr=""
    f  s rfr=$o(^BLC("RFR",rfr)) q:rfr=""  d
	   .s rfrdesc=""
	   .s rfrdesc=$p(^BLC("RFR",rfr),"^",2)
	   .q:rfr=0
	   .i ret'="" s ret=ret_"^"_rfr_$C(1)_rfrdesc
       .e  s ret=rfr_$C(1)_rfrdesc
    */
    /// 修改:退药原因取计费组退费原因表-DHC_INVOPRefReason 
 	/// bianshuai 2015-12-17
	s rfr=""
	f  s rfr=$o(^DHCINVOPREFR(rfr)) q:rfr=""  d
	.s rfrdesc=""
	.s rfrdesc=$p(^DHCINVOPREFR(rfr),"^",2)
	.q:rfr=0
	.i ret'="" s ret=ret_"^"_rfr_$C(1)_rfrdesc
	.e  s ret=rfr_$C(1)_rfrdesc
	q ret
}

ClassMethod CheckRetQty(phditm, qty)
{
	s phdrow="",phdsub="",orditm="",ord="",itm="",itmmast=""
	s phdrow=$p(phditm,"||",1)
	s phdsub=$p(phditm,"||",2)
	s orditm=$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",5)
	s dispqty=0,hadretqty=0
	s dispqty=+$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",4)
	s hadretqty=+$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",6)
	
	s ord=$p(orditm,"||",1)
	s itm=$p(orditm,"||",2)
	s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast
	s itmmastid="",itmmastver=""
	s itmmastid=$p(itmmast,"||",1)
	s itmmastver=$p(itmmast,"||",2)
    s inci=""
	s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
	s inci=$p(inci,$c(1),1)
	s phuomid=""
	s phuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	s phuomid=$p(phuomid,$c(1),1)
	s basuom="",newqty=0,newunit=""
	s basuom=+$p(^INCI(inci,1),"^",10)
	s confac=1,conrow=""
	i phuomid=basuom s confac=1
	e  d
	   .s conrow=$o(^CT("CTCF",0,"UOM",phuomid,basuom,conrow))
	   .i conrow'="" s confac=+$p(^CT("CTCF",conrow),"^",3)
	s retqty=qty*confac
	i dispqty<(retqty+hadretqty) q -1
   q 0
}

ClassMethod CheckDisp(np)
{
	s pmi="",gm=0
	s pmi=+$p(^DHCINVPRT(np),"^",15)
	s phdrow=""
	f  s phdrow=$o(^DHCPHDISPi("PAPMI",pmi,phdrow)) q:phdrow=""  d
	  .s phdprt="",phdfyflag=""
	  .s phdprt=+$p(^DHCPHDISP(phdrow),"^",2)
	  .s phdfyflag=$p(^DHCPHDISP(phdrow),"^",4)
	  .q:phdfyflag'="1"
	  .q:phdprt'=np
	  .s gm=gm+1
	q gm
}

ClassMethod GetRetOrdQty(orditm)
{
	;收费判断退药数量
	;##class(web.DHCOutPhReturn).GetRetOrdQty(orditm)
	;check ^DHCOutPatientRetOrdItem(orditm,"PRT",rowid)
	s retrow="",retqty=0
	f  s retrow=$o(^DHCPHRTIi(orditm,"ORDI",retrow)) q:retrow=""  d
	  .s retsub=""
	  .f  s retsub=$o(^DHCPHRTIi(orditm,"ORDI",retrow,retsub)) q:retsub=""  d
	  ..s curretqty=0
	  ..s curretqty=+$p($g(^DHCPHRTI(retrow,"RTI",retsub)),"^",3)
	  ..s retitmrow=""
	  ..s retitmrow=retrow_"||"_retsub
	  ..s checkretprt=0
	  ..s checkretprt=##class(web.DHCOutPhReturn).CeckRetPrt(orditm,retitmrow)
	  ..q:checkretprt'=0
	  ..s retqty=retqty+curretqty
	 q retqty
}

ClassMethod CeckRetPrt(orditm, retitmrow)
{
  s retval=0
  i '$d(^DHCOutPatientRetOrdItem(orditm))  d
    .s retval=0
  e  d
    .s retsubrow=""
    .f  s retsubrow=$o(^DHCOutPatientRetOrdItem(orditm,"PRT",retsubrow)) q:retsubrow=""  d
    ..q:retsubrow'=retitmrow
    ..s prtflag=""
    ..s prtflag=$p(^DHCOutPatientRetOrdItem(orditm,"PRT",retsubrow),"^",1)
    ..i prtflag="1"  s retval=1
  q retval
}

ClassMethod UpdateRetPrt(orditminf)
{
	n (orditminf)
   ;退费时写上退药标志
    ;##class(web.DHCOutPhReturn).UpdateRetPrt(orditminf)
   q:orditminf="" 0
    s orditmlen=$l(orditminf,"^")
    for t=1:1:orditmlen
    {
	 s orditm=""
	 s orditm=$p(orditminf,"^",t)
    s retrow="",retqty=0
	f  s retrow=$o(^DHCPHRTIi(orditm,"ORDI",retrow)) q:retrow=""  d
	  .s retsub=""
	  .f  s retsub=$o(^DHCPHRTIi(orditm,"ORDI",retrow,retsub)) q:retsub=""  d
	  ..s curretqty=0
	  ..s curretqty=+$p($g(^DHCPHRTI(retrow,"RTI",retsub)),"^",3)
	  ..s retitmrow=""
	  ..s retitmrow=retrow_"||"_retsub
	  ..s checkretprt=0
	  ..s checkretprt=##class(web.DHCOutPhReturn).CeckRetPrt(orditm,retitmrow)
	  ..q:checkretprt'=0
	  ..s $p(^DHCOutPatientRetOrdItem(orditm,"PRT",retitmrow),"^",1)="1"
    }
   
  q 0
}

ClassMethod UpdateAllRetItm()
{
	;##class(web.DHCOutPhReturn).UpdateAllRetItm()
   s retrow="",m=0
   f  s retrow=$o(^PHRET(retrow)) q:retrow=""  d
     .s retsub=""
     .f  s retsub=$o(^PHRTI(retrow,"RTI",retsub)) q:retsub=""  d
     ..s retorditm="",retitm=""
     ..s retorditm=$p(^PHRTI(retrow,"RTI",retsub),"^",2)
     ..s retitm=retrow_"||"_retsub
     ..s $p(^DHCOutPatientRetOrdItem(retorditm,"PRT",retitm),"^",1)="1"
     ..s m=m+1
  q m
}

ClassMethod DeleteRequest(prtinv)
{
  s prt="",prtflag=""
  s prt=$o(^DHCINVPRT(0,"INV",prtinv,""))
  
  s prtflag=$p(^DHCINVPRT(prt),"^",8)
  i prtflag'["N" q -1
  s reqrow="",cxflag=0
  f  s reqrow=$o(^DHCPHREQi("INVPRT",prt,reqrow)) q:(reqrow="")!(cxflag'=0)  d
    .s retflag=""
    .s retflag=$p(^DHCPHREQ(reqrow),"^",11)
    .i retflag="1"  s cxflag="1"
  i cxflag'=0 q -2
 f  s reqrow=$o(^DHCPHREQi("INVPRT",prt,reqrow)) q:(reqrow="")  d
      .&sql(delete from sqluser.DHC_Phrequest where phreq_rowid=:reqrow)
      

 q 0
}

ClassMethod CheckUserSH(userid, ctloc)
{
	s phperson="",retlevel=0,ploc=0,sh=0
	f  s phperson=$o( ^DHCPHPERi("USR",userid,phperson)) q:phperson=""  d
	  .s phphl=""
	  .s phphl=+$p(^DHCPHPER(phperson),"^",3)
	  .s phctloc=""
	  .s phctloc=+$p(^DHCPHLOC(phphl),"^",1)
	  .q:phctloc'=ctloc
	  .s ploc=ploc+1
	  .s shflag=""
	  .s shflag=$p(^DHCPHPER(phperson),"^",8)
	  .q:shflag'="1"
	  .s sh=sh+1
	  
	i ploc=0 q -1
	i sh=0 q 0
	q 1
}

}
