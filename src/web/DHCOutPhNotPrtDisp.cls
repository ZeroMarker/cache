Import sqluser

Class web.DHCOutPhNotPrtDisp Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod dispenph(orditem As %Library.String = "")
{
   s ret=0
   s sysdate=+$h
   s systime=$p($h,",",2)
	s ord=$p(orditem,"||",1)
	s ordi=$p(orditem,"||",2)
	s $p(^OEORD(ord,"I",ordi,6),"^",7)="1"
	TSTART
	// &sql(update sqluser.dhc_oedispensing set dsp_status="C",dsp_type="F",dsp_date=:sysdate,dsp_time=:systime
	// where dsp_oeori_dr=:orditem )
	 i SQLCODE'=0 TRo
	 i $g(SQLCODE)'=0 s ret=-1
	TCOMMIT 
   q ret
}

ClassMethod UpdatePyd(adm As %Library.String = "", phl As %Library.String = "", pydr As %Library.String = "", fydr As %Library.String = "", prescno As %Library.String = "")
{
	s currdate=$p($h,",",1)
	s currtime=$p($h,",",2)
	s ctloc=+$P(^DHCPHLOC(phl),"^",1)
	s pyusr="",fyusr="",shusr=""
	s pmi=""
	s pmi=+$p(^PAADM(adm),"^",1)
    ;s pmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(pmino),""))
	s ssusr="",pmino=""
	s ssusr=+$p(^DHCPHPER(fydr),"^",5)
	
	s suess=0
	TSTART
	s phdrow="",pharow="",ret=""
	f  s phdrow=$o(^DHCPHDISPi("PAPMI",pmi,phdrow)) q:(phdrow="")!(suess'=0)  d
	  .s phdprescno=""
	  .s phdprescno=$p(^DHCPHDISP(phdrow,2),"^",1)
	  .q:phdprescno'=prescno
	  .s $p(^DHCPHDISP(phdrow,1),"^",6)="1"
	  .s $p(^DHCPHDISP(phdrow),"^",4)="1"
	  .s $p(^DHCPHDISP(phdrow),"^",5)=currtime
	  .s $p(^DHCPHDISP(phdrow,1),"^",2)=fydr
	  .s pmino=$p(^PAPER(pmi,"PAT",1),"^",2)
	  .s phdsub=""
	  .f  s phdsub=$o(^DHCPHDI(phdrow,"PHDI",phdsub)) q:(phdsub="")!(suess'=0)  d
	    ..s oeori="",ord="",itm="",qty=0,basqty=0,err="",fs=0
	    ..s oeori=$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",5)
	    ..s qty=+$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",4)
	    ..s basprice=0,phdmoney=0
	    ..s phdmoney=+$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",3)
	    ..s basprice=phdmoney/qty
	    ..s basprice=$fn(basprice,"",4)
	    ..s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
	    ..s duratdr="" s duratdr=+$p($g(^OEORD(ord,"I",itm,2)),"^",6)
	    ..i duratdr'=0  s fs=+$p(^PHCDU(duratdr),"^",2)
	    ..s itmmast="",puruom="",basuom="",inci=""
	    ..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
	    ..s pointer=""
	    ..s pointer=phdrow_"||"_phdsub 
	    ..s fyflag="F"
	    ..s colflag="C"
	    ..&sql(update sqluser.dhc_oedispensing set dsp_pointer=:pointer,dsp_type=:fyflag,dsp_user=:ssusr,dsp_status=:colflag,dsp_date=:currdate,dsp_time=:currtime  where dsp_oeori_dr=:oeori )
	    ..i SQLCODE'=0  d
	    ...s suess=suess+1
	    ...TRo
	    ..;s retcollect=0
	    ..;s retcollect=##class(web.DHCOutPhDisp).collect(ord,itm)
	    ..;i retcollect'=0  d
	    ..;.s suess=suess+1
	    ..;.TRo
	    ..s puruom=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),8),"^",14)
	    ..s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),inci))
	    ..q:inci=""
	    ..s basuom=+$p(^INCI(inci,1),"^",10)
	    ..s parowid=""
	    ..s parowid=phdrow_"||"_phdsub
	    ..k ^TMPGETCLB($j)
	    ..d ##CLASS(web.DHCOutPhDisp).GInclb(inci,qty,ctloc)
	    ..s ret=##CLASS(web.DHCOutPhNotPrtDisp).InsertPhdisItmClb(parowid)
	    ..i ret'=0  d
	    ...TRo
	    ...s suess=suess+1
	    ..s phdicsub="0"
        ..f  s phdicsub=$o(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub)) q:(phdicsub="")!(phdicsub="0")!(suess'=0)  d
          ...s inclb="",incqty=0,basuom="",pointer="",intrno="",user=""
          ...s inclb=$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub),"^",3)
          ...s incqty=+$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub),"^",1)
          ...s inc=""
          ...q:inclb=""
          ...s inc=$p(inclb,"||",1)
          ...s basuom=$p(^INCI(inc,1),"^",10)
          ...s pointer=phdrow_"||"_phdsub_"||"_phdicsub
          ...s err=""
          ...s err=##CLASS(web.DHCOutPhModCZ).HandleStk(inclb,-incqty,basuom,ctloc,basprice,pointer,"",ssusr)
          ...i err'=0 d
          ....TRo
          ....s suess=suess+1
      .&sql(update sqluser.dhc_phdispen set phd_fydate=:currdate where phd_rowid=:phdrow)
	  .i SQLCODE'=0  d
	  ..TRo
	  ..s suess=suess+1
	 i suess'=0 q -1  
     e  d
      .TCOMMIT
  q 0
}

ClassMethod InsertPhdisItmClb(phditm As %Library.String = "")
{
      s newclb="",bb=0
	  f  s newclb=$o(^TMPGETCLB($j,newclb)) q:newclb=""  d
	    .s baseqty=0,bb=bb+1
	    .s baseqty=$p(^TMPGETCLB($j,newclb),"^",1)
	    .&sql(insert into SQLUSER.dhc_phdisitmclb(phdic_phdi_parref,phdic_childsub,phdic_basqty,phdic_inclb_dr)
	       values(:phditm,:bb,:baseqty,:newclb))
	  q 0
}

ClassMethod InsertPHDisp(adm As %Library.String = "", phl As %Library.String = "", phw As %Library.String = "", pydr As %Library.String = "", fydr As %Library.String = "", prescno As %Library.String = "")
{
	s sysdate="",systime=""
	s pattype="5"   ;1--正常，2--急诊，3--押金，4--涉外，5--体检
	s sysdate=$p($h,",",1)
	s systime=$p($h,",",2)
	s ctlocdr="",loc=""
	s loc=+$p(^DHCPHLOC(phl),"^",1)
	;s ctlocdr=+$p(^DHCPHLOC(thphl),"^",1)
	s papmidr=""
	s papmidr=+$p(^PAADM(adm),"^",1)
	s ord=0,dispflag=0
	f  s ord=$o(^OEORD(0,"Adm",adm,ord)) q:(ord="")!(ord=0)!(dispflag=1)  d
	.s itm="0"
	.f  s itm=$o(^OEORD(ord,"I",itm)) q:(itm="")!(itm=0)  d
	..s ordpresc=""
	..s ordpresc=$p(^OEORD(ord,"I",itm,1),"^",14)
	..q:ordpresc'=prescno
	..;s fyflag=##class(web.DHCOutPhDisp).GetDHCOEDisp(orditm,"W")
    ..;i fyflag=0 s dispflag=dispflag+1
    ..;q:fyflag="0"
    i dispflag'=0 q -2
    s su=0
    TSTART
    s amdtype="4"
    s pyflag="1"
 &sql(insert into SQLUSER.dhc_phdispen(phd_paadm_dr,phd_prtdate,phd_phw_dr,phd_papmi_dr,phd_php_pydr,phd_php_fydr,phd_phl_dr,phd_pydate,phd_fydate,phd_pytime,phd_prescno,phd_pattype,phd_fytime,phd_pyflag)
values(:adm,:sysdate,:phw,:papmidr,:pydr,:fydr,:phl,:sysdate,:sysdate,:systime,:prescno,:amdtype,:systime,:pyflag))
	i SQLCODE TRo
	i SQLCODE q 200
	s phdrow=""
	s phdrow=+$g(%ROWID)
	s ord=0,sub=0
	f  s ord=$o(^OEORD(0,"Adm",adm,ord)) q:(ord="")!(ord=0)!(su'=0)  d
	.s itm="0"
	.f  s itm=$o(^OEORD(ord,"I",itm)) q:(itm="")!(itm=0)  d
	..s ordpresc="",orditm="",qty=0,money=0,retprice=0
	..s orditm=ord_"||"_itm
	..s arcitm=""
	..s arcitm=$p(^OEORD(ord,"I",itm,1),"^",2)
	..s preason=""
	..s preason=$p(^OEORD(ord,"I",itm,11),"^",18)
	..s retprice=##class(web.DHCOPItemMast).GetOrderPrice("",preason,arcitm,+$h,"","","","")
    ..q:retprice=""
    ..s confac=1
    ..s confac=$p(retprice,"^",5)
    ..s retprice=$p(retprice,"^",1)
	..s ordpresc=$p(^OEORD(ord,"I",itm,1),"^",14)
	..s qty=+$p(^OEORD(ord,"I",itm,9),"^",4)
	..q:ordpresc'=prescno
	..s money=qty*retprice
	..s qty=qty*confac
	..s money=$fn(money,"",2)
	..s sub=sub+1
	..&sql(insert into SQLUSER.DHC_PHDISITEM(phdi_phd_parref,phdi_childsub,phdi_qty,phdi_payamount,phdi_oeori_dr) 
	   values(:phdrow,:sub,:qty,:money,:orditm))
	..i SQLCODE'=0 s su=su+1
	..i SQLCODE'=0 TRo
 i su'=0 TRo
 e  TCOMMIT 
 q SQLCODE
}

ClassMethod CheckDSP(oeori)
{
  s retdsp=0,dp=0
  ;&sql(select count(dsp_rowid) into :dp from dhc_oedispensing where dsp_oeori_dr=:oeori and dsp_status="TC")
  i dp=0  s retdsp=1
  q retdsp
}

ClassMethod CheckDispFrPresc(presc, flag)
{
  s ord=0,dispnum=0,retval=0
  s phdrow=""
  f  s phdrow=$o(^DHCPHDISPi("PRESCNO",presc,phdrow)) q:phdrow=""  d
    .s fyflag="",pyflag=""
    .s fyflag=$p(^DHCPHDISP(phdrow),"^",4)
    .s pyflag=$p(^DHCPHDISP(phdrow,1),"^",6)
    .q:(fyflag'="1")&(flag="FY")
    .q:(pyflag'="1")&(flag="PY")
    .s dispnum=dispnum+1
   i dispnum'=0 s retval=1
   q retval
}

ClassMethod CheckPYFrPresc(presc, adm)
{
  s ord=0,dispnum=0,retval=0
  s phdrow=""
  f  s phdrow=$o(^DHCPHDISPi("PRESCNO",presc,phdrow)) q:phdrow=""  d
    .s fyflag="",pyflag=""
    .s fyflag=$p(^DHCPHDISP(phdrow),"^",4)
    .s pyflag=$p(^DHCPHDISP(phdrow,1),"^",6)
    .q:pyflag'="1"
    .s dispnum=dispnum+1
   i dispnum'=0 s retval=1
   q retval
}

ClassMethod GetPrescMoney(adm, presc, loc)
{
	
  s ord=0,dispnum=0,retmoney=0,PrescTypeDesc=""
  f  s ord=$o(^OEORD(0,"Adm",adm,ord)) q:(ord="")!(ord=0)!(dispnum'=0)  d
    .s itm=0
    .f  s itm=$O(^OEORD(ord,"I",itm)) q:(itm="")!(itm=0)  d
    ..s ordpresc=""
    ..s ordpresc=$p(^OEORD(ord,"I",itm,1),"^",14)
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
    ..
    ..s EmLGflag=$p($g(^OEORD(+ord,"I",itm,"DHC")),"^",17)
    ..;q:(EmLGflag'=1)
    ..
    ..s arcitm="",qty=0
	..s arcitm=$p(^OEORD(ord,"I",itm,1),"^",2)
	..s ordprice=##class(web.DHCOPItemMast).GetOrderPrice("",preason,arcitm,+$h,"","","","")
	..s confac=1
	..s confac=$p(ordprice,"^",5)
	..s ordprice=+ordprice
	..s qty=+$p(^OEORD(ord,"I",itm,9),"^",4)
	..s oeflag="",inclbid="",disstatu=""
	..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)       ;????
    ..q:oeflag="D"

	..s ordmoney=0
	..s ordmoney=qty*ordprice
	..s retmoney=retmoney+ordmoney
    i retmoney=0 q 0
    s retmoney=$fn(retmoney,"",2)
    s retval=retmoney_"^"_PrescTypeDesc
   q retval
}

ClassMethod QueryLocPatNotPrtClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocPatNotPrtExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryLocPatNotPrtExecute(ByRef QHandle As %Binary, CDateSt As %Library.String = "", CDateEnd As %Library.String = "", GPhl As %Library.String = "", CPmiNo As %Library.String = "", GPydr As %Library.String = "", GFydr As %Library.String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	s phl=""
	s sysdate=+$h
    s phl=GPhl
    
	i (phl="")!(CPmiNo="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s stdate=CDateSt
	s enddate=CDateEnd
	s cyflag="",dfflag="" 
	s cyflag=$p(^DHCPHLOC(phl),"^",6)
	s yflocdr=+$p(^DHCPHLOC(phl),"^",1)
	s fpflag=""
    s pmi=""
    s pmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(CPmiNo),""))
    i pmi="" Set QHandle=$lb(0,repid,0)	Quit $$$OK
    s patno="",patname=""
    s patno=$p(^PAPER(pmi,"PAT",1),"^",2)
    s patname=$p(^PAPER(pmi,"ALL"),"^",1)
    s patsexdr="",patsex="",birthday="",difdate="",patage="",deploc="",deplocdr="" 
	s patsexdr=+$p(^PAPER(pmi,"ALL"),"^",7)
    i patsexdr'="" s patsex=$p(^CT("SEX",patsexdr),"^",2)
    s patage=##class(web.DHCOutPhTQDisp).GetPatientAgeDesc(pmi)
	s admdate=0
	
	f admdate=stdate:1:enddate  d
	  .s adm=0
	  .f  s adm=$o(^PAADMi("PAADM_AdmDate",admdate,adm)) q:(adm="")!(adm=0)  d
	  ..s admpmi=""
	  ..s admpmi=+$p(^PAADM(adm),"^",1)
	  ..q:admpmi'=pmi
	  ..s deplocdr="",deploc=""
	  ..s ^TANGK=adm
	  ..s deplocdr=+$p(^PAADM(adm),"^",4)
	  ..s deploc=$p(^CTLOC(deplocdr),"^",2)
	  ..i deploc["-" s deploc=$p(deploc,"-",2)
	  ..s admreasdr="",reascode=""
	  ..s admreasdr=+$p(^PAADM(adm,1),"^",7)
	  ..s reascode=$p(^PAC("ADMREA",admreasdr),"^",1)
	  ..q:reascode'="POSTPAID"
	  ..s mradm="",mricd=""
	  ..s mradm=+$p(^PAADM(adm),"^",61)
	  ..s mrdia="0",allicd=""
	  ..f  s mrdia=$o(^MR(mradm,"DIA",mrdia)) q:(mrdia="")!(mrdia="0")  d
	       ...s icdcode="",desc=""
	       ...s icdcode=+$p(^MR(mradm,"DIA",mrdia),"^",1)
	       ...i icdcode'=0 s desc=$p(^MRC("ID",icdcode),"^",2)
	       ...i desc'=""  d
	         ....i allicd="" s allicd=desc
	         ....e  s allicd=allicd_";"_desc
      ..s mricd=allicd
	  ..s paqrow=0
	  ..f  s paqrow=$o(^PAQUE1(0,"QUE1_PAADM_DR",adm,paqrow)) q:(paqrow="")!(paqrow=0)  d
	    ...s presc="",dispflag="",paqdate=""
	    ...s presc=$p(^PAQUE1(paqrow),"^",14)
	    ...s paqdate=+$p(^PAQUE1(paqrow),"^",7)
	    ...s paqdate=$zd(paqdate,3)
	    ...s dispflag=##class(web.DHCOutPhNotPrtDisp).CheckDispFrPresc(presc,"FY")
	    ...q:dispflag=1
	    ...s prescmoney=0
	    ...s prescmoney=##class(web.DHCOutPhNotPrtDisp).GetPrescMoney(adm,presc,yflocdr)
	    ...s money=0,presctype=""
	    ...s money=$p(prescmoney,"^",1)
	    ...s presctype=$p(prescmoney,"^",2)
	    ...q:money=0
	    ...set Data=$lb(patname,patno,patsex,patage,deploc,presc,paqdate,"",money,mricd,adm,presctype)
 	    ...Set ^CacheTemp(repid,ind)=Data	
 	    ...Set ind=ind+1
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryLocPatNotPrtFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocPatNotPrtExecute ]
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

Query QueryLocPatNotPrt(CDateSt As %String, CDateEnd As %String, GPhl As %String, CPmiNo As %String, GPydr As %String, GFydr As %String) As %Query(ROWSPEC = "TPatName:%String,TPmiNo:%String,TPatSex:%String,TPatAge:%String,TPatLoc:%String,TPrescNo:%String,TPrescDate:%String,TDispFlag:%String,TPrescMoney:%String,TMR:%String,TAdm:%String,TPrescType:%String")
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
	    ..s pp=##class(web.DHCOutPhDisp).GPerOrd(phl,prt,prescno,"")
	    ..i pp["&"  d  
	     ...s pret=$p(pp,"&",1)
	     ...s pfact=$p(pp,"&",3)
	     ...i pret["^" s unflag="1",pmoney=$p(pret,"^",1)
	     ...e  s pmoney=pret
	    ..e  d
	    ...i pp["^" s unflag="1",pmoney=$p(pp,"^",1)
	    ...e  s pmoney=pp
	    ..q:pmoney=0
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

ClassMethod GDispItmExecute(ByRef QHandle As %Binary, rPHL As %Library.String = "", rAdm As %Library.String = "", rPrescNo As %Library.String = "") As %Status
{
	  Set repid=$I(^CacheTemp)
	  s HospitalCode=""
	  s str=$g(^DHCDocConfig("CurrentHospital"))
	  s HospitalCode=$p(str,"^",1)
	  s ind=1,phl=""
	  s sysdate=""
	  s phl=$g(rPHL)
	  s yprescno=$g(rPrescNo)
	  s reclocdr=""
	 
	 
	   i (phl="")!(rPrescNo="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	    s reclocdr=+$p(^DHCPHLOC(phl),"^",1)
	    k ^DHCPHTMPPRESCNO($j,"PRESCNO",yprescno)
	  s thloc="",thphl=""
  	  k ^TMPDHCPH($j,"ItmPrescINC",rPrescNo)
 	  s thloc=+$P(^DHCPHLOC($g(phl)),"^",1)
 	  s ord=0
 	  f  s ord=$o(^OEORD(0,"Adm",rAdm,ord)) q:(ord=0)!(ord="")  d
 	    .s itm=0
 	    .f  s itm=$o(^OEORD(ord,"I",itm)) q:(itm="")!(itm=0)  d
 	      ..s ordpresc=""
          ..s ordpresc=$p(^OEORD(ord,"I",itm,1),"^",14)
          ..q:ordpresc'=rPrescNo
 	      ..s arcitm="",dispqty=0,ordprice=0,ordmoney=0
	      ..s arcitm=$p(^OEORD(ord,"I",itm,1),"^",2)
	      ..s preason=""
	      ..s preason=$p(^OEORD(ord,"I",itm,11),"^",18)
	      ..s ordprice=##class(web.DHCOPItemMast).GetOrderPrice("",preason,arcitm,+$h,"","","","")
	      ..s confac=1
	      ..s confac=$p(ordprice,"^",5)
	      ..s ordprice=+ordprice
	      ..s dispqty=+$p(^OEORD(ord,"I",itm,9),"^",4)
	      ..s ordmoney=dispqty*ordprice
	      ..;s ^tanglt(ord,itm)=ordprice_"^"_ordmoney_"^"_dispqty_"^"_confac
	 	  ..s itmmast=""
	      ..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast
	      ..s ordadm="",admreasrow="",yblb="",ybret=""
	      ..s ordadm=+$p(^OEORD(ord),"^",1)
	      ..s admreasrow=+$p(^PAADM(ordadm,1),"^",7)
	      ..;s ybret=##class(web.INSUTarContrastCom).ArcimLinkInsu(itmmast, admreasrow)
	      ..;s yblb=$p(ybret,"^",1)
	      ..;i +yblb<0 s yblb=""
	      ..s dlgtype=""
	      ..;s dlgtype=##CLASS(web.DHCOutPhDisp).GetPhType(itmmast)

	      ..s priority=""
	     ..s priority=$p(^OEORD(ord,"I",itm,1),"^",8)     ;????
	     ..s priordesc=""
	     ..i priority'="" s priordesc=$p(^OECPR(priority),"^",2)
	     ..q:priordesc["自备"
	     ..s orddoctco=""
	     ..s orduser="",ordusertypedr="",ordusercare="",careprovtype="",userdoctype=""
	     ..s orddoctco=$p($g(^OEORD(ord,"I",itm,1)),"^",11) ;??
	     ..s orduser=+$p($g(^OEORD(ord,"I",itm,7)),"^",1)
	     ..s username=""
	     ..s username=$p(^SSU("SSUSR",orduser),"^",2)
	     ..i orduser'=""  s ordusercare=$p(^SSU("SSUSR",orduser),"^",14)
	     ..i ordusercare'="" s careprovtype=$p(^CTPCP(ordusercare,1),"^",4)
	     ..i careprovtype'="" s userdoctype=$p(^CT("CPT",careprovtype),"^",4)
	     ..s doseqty="" s doseqty=$p($g(^OEORD(ord,"I",itm,2)),"^",1)
	     ..;i doseqty<1 s doseqty="0"_doseqty
	     ..s unitdr="" s unitdr=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
	     ..s phfragdr="" s phfragdr=$p($g(^OEORD(ord,"I",itm,2)),"^",4)
	     ..s duratdr="" s duratdr=$p($g(^OEORD(ord,"I",itm,2)),"^",6)
	     ..s instrdr="" s instrdr=$p($g(^OEORD(ord,"I",itm,2)),"^",7)
	     ..s skinflag="",skintest=""
	     ..s skintest=$p(^OEORD(ord,"I",itm,5),"^",2)
	     ..i skintest["Y"  d
	       ...s skintest="Y"
	       ...s Abnormal=""
	       ...s Abnormal=$p(^OEORD(ord,"I",itm,11),"^",3)
	       ...i Abnormal["Y"  s skinflag="2"
	       ...i Abnormal["N"  s skinflag="1"
	     ..s unitdesc=""
	     ..i unitdr'="" s unitdesc=$p($g(^CT("UOM",unitdr)),"^",2)
	     ..s phuomid="",phuomdesc="",itmmastid="",itmmastver=""
	     ..s itmmastid=$p(itmmast,"||",1)
	     ..s itmmastver=$p(itmmast,"||",2)
	     ..s itmcat="",itmcatdesc="",syflag=""
	     ..s itmcat=+$p(^ARCIM(itmmastid,itmmastver,1),"^",10)
	     ..s genric=""
	     ..s genric=$p(^ARCIM(itmmastid,itmmastver,8),"^",20)
	     ..s incTYdesc=""
	     ..i genric'="" s incTYdesc=$p(^PHCGE("GE",genric),"^",2)
	     ..i incTYdesc["-" s incTYdesc=$p(incTYdesc,"-",2)
	     ..s itmcatdesc=$p(^ARC("IC",itmcat),"^",2)
	     ..i itmcatdesc["输液"  s syflag="1"
	     ..s drgform="",drgmast="",phtype=""
	     ..s drgform=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
	     ..i drgform'="" s drgmast=$p(drgform,"||",1)
	     ..i drgmast'=""  d
	      ...s phtype=$p($g(^PHCD(drgmast,4)),"^",2)
	     ..s dxsl="",dxunit="",phfact="",factdesc=""
	     ..s dxrowid="0"
	     ..s dxrowid=$o(^PHCD(drgmast,"DF",$p(drgform,"||",2),"EQ",dxrowid))
	  	 ..i drgform'=""  d
	       ...s phcform=$p(^PHCD($p(drgform,"||",1),"DF",$p(drgform,"||",2),1),"^",1)
	       ...s phfact=$p(^PHCD($p(drgform,"||",1),2),"^",4)
	     ..e  d
	       ...s phcform="",phfact=""
         ..i phfact=""  s factdesc="" 
         ..e  d
           ...i '$d(^PHMNF(phfact))  s factdesc="" 
           ...e  s factdesc=$p(^PHMNF(phfact),"^",2)  
         ..i factdesc["-" s factdesc=$p(factdesc,"-",2)  
	     ..s phuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	     ..q:phuomid=""
	     ..s phuomid=$p(phuomid,$c(1),1)
	     ..s phbz="",bz=0,bb=0
	     ..s bz=$g(^OEORD(ord,"I",itm,"DEP",0))
	     ..
	     ..f bb=1:1:bz  d
	      ...s phbz0=""
	      ...s phbz0=$g(^OEORD(ord,"I",itm,"DEP",bb))
	      ...s phbz=phbz_phbz0
	    ..s currdate=""
	    ..s currdate=$p($h,",",1)
	    ..s phuomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
	    ..s inci=""
	    ..s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
	    ..q:inci=""
	    ..s inci=$p(inci,$c(1),1)
	    ..s basqty=0
	    ..s basqty=dispqty*confac
	    ..i '$d(^TMPDHCPH($j,"ItmPrescINC",rPrescNo,inci))  d
	    ...s ^TMPDHCPH($j,"ItmPrescINC",rPrescNo,inci)=basqty
	    ..e  d
	    ...s ^TMPDHCPH($j,"ItmPrescINC",rPrescNo,inci)=$g(^TMPDHCPH($j,"ItmPrescINC",rPrescNo,inci))+basqty
	    ..k ^TMPGETCLB($j)
	    ..d ##CLASS(web.DHCOutPhDisp).GInclb(inci,dispqty,reclocdr)
	     ..s yppc="",inclb="",incib=""
	     ..s newclb="",bb=0
	     ..f  s newclb=$o(^TMPGETCLB($j,newclb)) q:(newclb="")!(bb>0)  d
	       ...s bb=bb+1
	       ...s inclb=newclb
	       ...q:'$d(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)))
	       ...s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	       ...s yppc=$p(^INCI($p(incib,"||",1),"IB",$p(incib,"||",2)),"^",1)

	    ..s sdate="",qtyend=0,ldtrow=""
	    ..;modify by tang 2008.07.30
	    ..s curdispqty=0
	    ..s curdispqty=$g(^TMPDHCPH($j,"ItmPrescINC",rPrescNo,inci))
	    ..s sdate=$o(^DHCLOCTOT(0,"LOCITMDATE",thloc,inci,currdate+1),-1)        
	    ..i sdate'="" d
	      ...s ldtrow=$o(^DHCLOCTOT(0,"LOCITMDATE",thloc,inci,sdate,""))
	      ...s qtyend=+$p(^DHCLOCTOT(ldtrow),"^",4)
        ..i qtyend<curdispqty s unflag="不够"
	    ..;^INCI("IL_LOC",{INCIL_CTLOC_DR},{INC_Itm.INCI_RowId},             x
	    ..s incil="",yphw="",incstb=""
	    ..s incil=$o(^INCI("IL_LOC",reclocdr,inci,""))
	    ..i incil'=""  d
	      ...s incstb=+$p(^INCI(inci,"IL",incil),"^",2)
	      ...i incstb'=0  d
	       ....q:'$d(^INC("SB",incstb))
	       ....s yphw=$p(^INC("SB",incstb),"^",2)
	    ..s puruom="",puruomdesc="",basuom="",basuomdesc=""
	    ..s puruom=+$p(^INCI(inci,3),"^",6)
	    ..s puruomdesc=$p($g(^CT("UOM",puruom)),"^",2)
	    ..s basuom=+$p(^INCI(inci,1),"^",10)
	    ..s basuomdesc=$p($g(^CT("UOM",basuom)),"^",2)
	    ..i dxrowid'=""  d
	        ...s dxsl=+$p(^PHCD(drgmast,"DF",$p(drgform,"||",2),"EQ",dxrowid),"^",2) 
	        ...s dxunit=+$p(^PHCD(drgmast,"DF",$p(drgform,"||",2),"EQ",dxrowid),"^",1) 
	        ...i unitdr=dxunit  d
	          ....;s doseqty=doseqty/dxsl
	          ....;i doseqty["."  s doseqty=$fn(doseqty,"",2)


	    ..s phgg=""
	    ..s phgg=$p($g(^INCI(inci,3)),"^",9)
	    ..;s phgg=##class(web.DHCSTKUTIL).GetSpec(inci)  
	    ..s qty=0,newunit="",getnum=0,newunitdesc="",newprice=0
	    ..s getnum=$p((dispqty/confac),".",1)
	    ..i getnum="" s getnum=0
	    ..s qty=getnum
	    ..s newprice=ordprice
	    ..s newunitdesc=phuomdesc
	    ..s phdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)
	    ..q:phdesc="" 
	    ..s duratdesc=""

	    ..i duratdr'="" s duratdesc=$p($g(^PHCDU(duratdr)),"^",3)
	    ..s phfragdesc=""
	    ..i phfragdr'="" s phfragdesc=$p($g(^PHCFR(phfragdr)),"^",3)
	    ..s instrdesc=""
	    ..i instrdr'="" s instrdesc=$p($g(^PHCIN(instrdr)),"^",2)
	    ..s orddoctnam=""
	    ..i orduser'="" s orddoctnam=$p(^SSU("SSUSR",orduser),"^",2)
	    ..s doctype=""
	    ..;i orddoctco'=""  s doctype=$p(^CT("CPT",+$p(^CTPCP(orddoctco,1),"^",4)),"^",4)
	    ..s jlflag=""
	    ..;i unitdesc["?" s unitdesc=$p(unitdesc,"?",1) s unitdesc=unitdesc_"?"
	    ..s jlflag=doseqty_unitdesc
	    ..i userdoctype'["DOC"  d
	      ...s jlflag="",phfragdesc="",instrdesc="",duratdesc="",orddoctnam="",username=""
	      ...i orddoctco'="" s username=$p(^CTPCP(orddoctco,1),"^",2)
	    ..s error="",t=0,cc=0,notes=""
	    ..s notes=$p(^OEORD(ord,"I",itm,2),"^",8)
	    ..s oeflag="",inclbid="",disstatu=""
	    ..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",2)       ;????
        ..q:oeflag["停"
        ..i newunitdesc["(" s newunitdesc=$p(newunitdesc,"(",1)
	    ..i t=0 s error="1"
	    ..s newprice=$fn(newprice,"",4)
	    ..s ordmoney=$fn(ordmoney,"",2)
	    ..i HospitalCode["YKYZLYY"  d
	      ...i phdesc["(" s phdesc=$p(phdesc,"(",1)
	      ...i phdesc["[" s phdesc=$p(phdesc,"[",1)
	      ...s phdesc=dlgtype_phdesc
	    ..e  d
	    ...i incTYdesc'="" s phdesc=incTYdesc
	    ..s phdesc="("_yblb_")"_phdesc
        ..set Data=$lb(phdesc,newunitdesc,dispqty,newprice,ordmoney,oeflag,jlflag,phfragdesc,instrdesc,duratdesc,username,ord_"||"_itm,newunit,yppc,yphw,phtype,phgg,phbz,factdesc,unflag,skintest,syflag)
 	    ..Set ^CacheTemp(repid,ind)=Data
 	    ..Set ind=ind+1
 	k ^TMPDHCPH($j,"ItmPrescINC",rPrescNo)
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

Query GDispItm(rPHL As %String, rAdm As %String, rPrescNo As %String) As %Query(ROWSPEC = "TPhDesc:%String,TPhUom:%String,TPhQty:%String,TPrice:%String,TMoney:%String,TOrdStatus:%String,TJL:%String,TPC:%String,TYF:%String,TLC:%String,TDoctor:%String,TOrditm:%String,TUnit:%String,TIncPC:%String,TIncHW:%String,TPhType:%String,TPhgg:%String,TPhbz:%String,TPhFact:%String,TKCFlag:%String,TSkinTest:%String,TSyFlag:%String")
{
}

ClassMethod CheckPhKC(ctloc, adm, presc)
{
 s phl="",ret=0,kc=""
 s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
 b
 
 s kc=##class(web.DHCOutPhNotPrtDisp).GetKCPresc(phl,adm,presc)
 i kc="-1" s ret=1
 e  s ret=0
 q ret
}

ClassMethod GetKCPresc(phl, adm, rPrescNo)
{
     
      s retkc=0
      s retloc=""
      s retloc=+$p(^DHCPHLOC(phl),"^",1)
      k ^TMPDHCPH($j,"ItmPrescINC",rPrescNo)
      s ord=0
 	  f  s ord=$o(^OEORD(0,"Adm",adm,ord)) q:(ord=0)!(ord="")  d
 	    .s itm=0
 	    .f  s itm=$o(^OEORD(ord,"I",itm)) q:(itm="")!(itm=0)  d
 	      ..s ordpresc=""
          ..s ordpresc=$p(^OEORD(ord,"I",itm,1),"^",14)
          ..q:ordpresc'=rPrescNo
 	      ..s arcitm="",dispqty=0,ordprice=0,ordmoney=0
	      ..s arcitm=$p(^OEORD(ord,"I",itm,1),"^",2)
	      ..s dispqty=$p(^OEORD(ord,"I",itm,9),"^",4)
	      ..s recloc=""
	      ..s recloc=+$p(^OEORD(ord,"I",itm,3),"^",6)
	      ..q:recloc'=retloc
		  ..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)
		  ..q:(oeflag'="V")&(oeflag'="E")
	 	  ..s itmmast=""
	      ..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast
	      ..s ordadm="",admreasrow="",yblb="",ybret=""
	      ..s ordadm=+$p(^OEORD(ord),"^",1)
	     ..s phuomid="",phuomdesc="",itmmastid="",itmmastver=""
	     ..s itmmastid=$p(itmmast,"||",1)
	     ..s itmmastver=$p(itmmast,"||",2)
	     ..s phuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	     ..q:phuomid=""
	     ..s phuomid=$p(phuomid,$c(1),1)
	     ..s currdate=""
	     ..s currdate=$p($h,",",1)
	    ..s inci=""
	    ..s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
	    ..q:inci=""
	    ..s inci=$p(inci,$c(1),1)
	    ..i '$d(^TMPDHCPH($j,"ItmPrescINC",rPrescNo,inci))  d
	    ...s ^TMPDHCPH($j,"ItmPrescINC",rPrescNo,inci)=dispqty
	    ..e  d
	    ...s ^TMPDHCPH($j,"ItmPrescINC",rPrescNo,inci)=$g(^TMPDHCPH($j,"ItmPrescINC",rPrescNo,inci))+dispqty
	    ..s sdate="",qtyend=0,ldtrow=""
	    ..;modify by tang 2008.07.30
	    ..s curdispqty=0
	    ..s curdispqty=$g(^TMPDHCPH($j,"ItmPrescINC",rPrescNo,inci))
	    ..s sdate=$o(^DHCLOCTOT(0,"LOCITMDATE",retloc,inci,currdate+1),-1)        
	    ..i sdate'="" d
	      ...s ldtrow=$o(^DHCLOCTOT(0,"LOCITMDATE",retloc,inci,sdate,""))
	      ...s qtyend=+$p(^DHCLOCTOT(ldtrow),"^",4)
        ..i qtyend<curdispqty s retkc="-1"
 	k ^TMPDHCPH($j,"ItmPrescINC",rPrescNo)

 q retkc
}

ClassMethod GPerOrd(rPHL As %Library.String = "", rPRT As %Library.String = "", rPrescNo As %Library.String = "", flag As %Library.String = "")
{
	  s phl=$g(rPHL)
	  s prt=$g(rPRT),hh=0,allmoney=0
	  s yprescno=$g(rPrescNo)
	  s unflag="",basphl="",basloc=""
	  s basphl=##class(web.DHCOutPhAdd).GetTwoPhlFrThree(phl)
	  s basloc=+$p(^DHCPHLOC(basphl),"^",1)
	  s sysdate=+$h
	 ; k ^DHCPHTMPPRESCNO
	  i (phl="")!(prt="") q 0
	  s reclocdr=""
	  s reclocdr=+$p(^DHCPHLOC(phl),"^",1)
	  s cy=""
	  k ^TMPDHCPH($j,"PrescINC",yprescno)
	  s cy=$p(^DHCPHLOC(phl),"^",6)
	  k ^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno)
	  s bci="0"
	  f  s bci=$o(^DHCBCI(0,"INV",prt,bci)) q:(bci="")!(bci="0")  d
	    .s patbill=""
	    .s patbill=+$p(^DHCBCI(bci),"^",2)
	    .s patbillsub="0"
	    .f  s patbillsub=$o(^DHCPB(patbill,"O",patbillsub)) q:(patbillsub="")!(patbillsub="")  d
	      ..s orditm="",ord="",itm="",dispflag="",prescno=""
	      ..s orditm=$p(^DHCPB(patbill,"O",patbillsub),"^",4)
	      ..
	      ..;s dispflag=""
	      ..;s dispflag=##class(web.DHCOutPhDisp).GetDHCOEDisp(orditm,"W")
	      ..s dispflag=""
	      ..i flag="1" s dispflag=##class(web.DHCOutPhDisp).GetDHCOEDisp(orditm,"Y")
	      ..e  s dispflag=##class(web.DHCOutPhDisp).GetDHCOEDisp(orditm,"W")
	      ..
	      ..q:dispflag="0"
	      ..
	      ..s ord=$p(orditm,"||",1),itm=$p(orditm,"||",2)
	      ..s recplocdr=""
	      ..s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	      ..q:recplocdr=""
	      ..q:(recplocdr'=basloc)&(flag'="1")
	      ..;q:(recplocdr'=reclocdr)&(flag="1")
	      ..
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
	   s ordi="",durfact="",deploc=""
	   f  s ordi=$o(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,ordi)) q:ordi=""  d
	     .s dispqty=0,dispmoney=0,price=0
	     .s dispqty=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,ordi),"^",1)
	     .s dispmoney=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,ordi),"^",2)
	     .s price=dispmoney/dispqty
	     .s ord="",itm=""
	     .s ord=$p(ordi,"||",1)
	     .s adm=+$p(^OEORD(ord),"^",1)
	     .s deploc=+$p(^PAADM(adm),"^",4)
	     .s itm=$p(ordi,"||",2)
	 	 .s itmmast=""
	     .s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast
	     .s priority=""
	     .s priority=$p(^OEORD(ord,"I",itm,1),"^",8)     ;????
	     .s yppc="",inclb="",incib=""
	     .i $d(^OEORD(ord,"I",itm,"X",1,"D",1))  d
	       ..s inclb=$p(^OEORD(ord,"I",itm,"X",1,"D",1),"^",2)
	       ..q:'$d(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)))
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
	    .i '$d(^TMPDHCPH($j,"PrescINC",yprescno,inci))  d
	    ..s ^TMPDHCPH($j,"PrescINC",yprescno,inci)=dispqty
	    .e  d
	    ..s ^TMPDHCPH($j,"PrescINC",yprescno,inci)=$g(^TMPDHCPH($j,"PrescINC",yprescno,inci))+dispqty
	    .s sdate="",qtyend=0
	    .s curdispqty=0
	    .s curdispqty=$g(^TMPDHCPH($j,"PrescINC",yprescno,inci))
	    .s sdate=$o(^DHCLOCTOT(0,"LOCITMDATE",reclocdr,inci,sysdate+1),-1)        
	    .i sdate'="" d
	      ..s ldtrow=$o(^DHCLOCTOT(0,"LOCITMDATE",reclocdr,inci,sdate,""))
	      ..s qtyend=+$p(^DHCLOCTOT(ldtrow),"^",4)
        .i qtyend<curdispqty s unflag="1"
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
	    .;s phgg=$p($g(^INCI(inci,3)),"^",9)
	    .s phgg=##class(web.DHCSTKUTIL).GetSpec(inci)  
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
	    .i phfragdr'="" s phfragdesc=$p($g(^PHCFR(phfragdr)),"^",3)
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
        .q:oeflag["停"
        .i newunitdesc["(" s newunitdesc=$p(newunitdesc,"(",1)
	     .i t=0 s error="1"
	     .s allmoney=allmoney+dispmoney
	     .;s dispmoney=$j(dispmoney,12,4)
 	     .s hh=hh+1
   s deplocdesc=""
   i deploc'=""  d
    .s deplocdesc=$p(^CTLOC(deploc),"^",2)
    .i deplocdesc["-" s deplocdesc=$p(deplocdesc,"-",2)
   i unflag="1" s allmoney=allmoney_"^"_"1"_"&"_deplocdesc
   e  s allmoney=allmoney_"&"_deplocdesc
   
   i cy="1" s allmoney=allmoney_"&"_durfact
 q allmoney
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
 s dateformat="dd/mm/yyyy"
 &sql( SELECT OEORI_Rowid,OEORI_ItmMast_DR->ARCIM_Desc,Todate(OEORI_SttDat,:dateformat),OEORI_SeqNo,
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
 s ret=OrderName_"^"_StartDate_"^"_SeqNo_"^"_DoseQty_"^"_DoseUOM_"^"_Priority_"^"_Status_"^"_Frequence_"^"_Instruction_"^"_Duration_"^"_PackQty_"^"_PackUOM_"^"_Billed_"^"_BillTypeDesc_"^"_BillClassDesc_"^"_UserAddCode_"^"_UserAddName_"^"_PoisonClass_"^"_ItemCat
 q ret
}

ClassMethod InsertDHCOEDisp(orditm, qty, unit, pointer, status, type, user)
{
   s sysdate=+$h
   s systime=$p($h,",",2)
   ;&sql(insert into sqluser.dhc_oedispensing(dsp_date,dsp_dateadd,dsp_time,dsp_timeadd,
   ;dsp_qty,dsp_qtyuom,dsp_oeori_dr,dsp_pointer,dsp_type,dsp_status,dsp_user,DSP_ConfirmQty)
   ;values(:sysdate,:sysdate,:systime,:systime,:qty,:unit,:orditm,:pointer,:type,:status,:user,:qty))
   q SQLCODE
}

ClassMethod GetBasPrice(prt, oeori)
{
 s retprice=0
  s dbci="0"
  f  s dbci=$o(^DHCBCI(0,"INV",prt,dbci)) q:(dbci="0")!(dbci="")  d
    .s patbill=""
    .s patbill=+$p(^DHCBCI(dbci),"^",2)
    .s billsub="0"
    .f  s billsub=$o(^DHCPBi(0,"OEORI",oeori,patbill,billsub)) q:(billsub="0")!(billsub="")  d
      ..s basprice=0
      ..q:'$d(^DHCPB(patbill,"O",billsub))
      ..s basprice=$p(^DHCPB(patbill,"O",billsub),"^",7)
      ..s retprice=basprice
 q retprice
}

ClassMethod QueryLocPatNotPrtPYClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocPatNotPrtPYExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryLocPatNotPrtPYExecute(ByRef QHandle As %Binary, CDateSt As %Library.String = "", CDateEnd As %Library.String = "", GPhl As %Library.String = "", CPmiNo As %Library.String = "", GPydr As %Library.String = "", GFydr As %Library.String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	s phl=""
	s sysdate=+$h
    s phl=GPhl
    
	i (phl="")!(CPmiNo="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s stdate=CDateSt
	s enddate=CDateEnd
	s cyflag="",dfflag="" 
	s cyflag=$p(^DHCPHLOC(phl),"^",6)
	s yflocdr=+$p(^DHCPHLOC(phl),"^",1)
	s fpflag=""
    s pmi=""
    s pmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(CPmiNo),""))
    i pmi="" Set QHandle=$lb(0,repid,0)	Quit $$$OK
    s patno="",patname=""
    s patno=$p(^PAPER(pmi,"PAT",1),"^",2)
    s patname=$p(^PAPER(pmi,"ALL"),"^",1)
    s patsexdr="",patsex="",birthday="",difdate="",patage="",deploc="",deplocdr="" 
	s patsexdr=+$p(^PAPER(pmi,"ALL"),"^",7)
    i patsexdr'="" s patsex=$p(^CT("SEX",patsexdr),"^",2)
    s patage=##class(web.DHCOutPhTQDisp).GetPatientAgeDesc(pmi)
	s admdate=0
	/*
	f admdate=stdate:1:enddate  d
	  .s adm=0
	  .f  s adm=$o(^PAADMi("PAADM_AdmDate",admdate,adm)) q:(adm="")!(adm=0)  d
	  ..s admpmi=""
	  ..s admpmi=+$p(^PAADM(adm),"^",1)
	  ..q:admpmi'=pmi
	  ..s admtype=$p(^PAADM(adm),"^",2)
	  ..q:(admtype="O")
	  ..s StayRtn=##class(web.DHCADMVisitStat).GetStayStatus(adm)
	  ..q:(StayRtn'=1) */
	  
	   s adm=0
	  f  s adm=$o(^PAPERdr(pmi,"ADM","E",adm)) q:(adm="")  d
	  .s AdmVisitStatus=$p(^PAADM(adm),"^",20)
	  .q:AdmVisitStatus="C"
	  .s StayRtn=##class(web.DHCADMVisitStat).GetStayStatus(adm)
	  .q:(StayRtn'=1)
	  .s deplocdr="",deploc=""
	  .s deplocdr=+$p(^PAADM(adm),"^",4)
	  .s deploc=$p(^CTLOC(deplocdr),"^",2)
	  .i deploc["-" s deploc=$p(deploc,"-",2)
	  .s admreasdr="",reascode=""
	  .s admreasdr=+$p(^PAADM(adm,1),"^",7)
	  .s reascode=$p(^PAC("ADMREA",admreasdr),"^",1)
	  .;q:reascode'="POSTPAID"
	  .s mradm="",mricd=""
	  .s mradm=+$p(^PAADM(adm),"^",61)
	  .s mrdia="0",allicd=""
	  .f  s mrdia=$o(^MR(mradm,"DIA",mrdia)) q:(mrdia="")!(mrdia="0")  d
	  ..s icdcode="",desc=""
	  ..s icdcode=+$p(^MR(mradm,"DIA",mrdia),"^",1)
	  ..i icdcode'=0 s desc=$p(^MRC("ID",icdcode),"^",2)
	  ..i desc'=""  d
	  ...i allicd="" s allicd=desc
	  ...e  s allicd=allicd_";"_desc
      .s mricd=allicd
	  .s paqrow=0
	  .f  s paqrow=$o(^PAQUE1(0,"QUE1_PAADM_DR",adm,paqrow)) q:(paqrow="")!(paqrow=0)  d
	  ..s presc="",dispflag="",paqdate="",pyflag=""
	  ..s presc=$p(^PAQUE1(paqrow),"^",14)
	  ..s paqdate=+$p(^PAQUE1(paqrow),"^",7)
	  ..s paqdate=$zd(paqdate,3)
	  ..s dispflag=##class(web.DHCOutPhNotPrtDisp).CheckDispFrPresc(presc,"PY")
	  ..q:dispflag=1
	  ..s pyflag=##class(web.DHCOutPhNotPrtDisp).CheckPYFrPresc(presc,adm)
	  ..q:pyflag=1
	  ..s prescmoney=0
	  ..s prescmoney=##class(web.DHCOutPhNotPrtDisp).GetPrescMoney(adm,presc,yflocdr)
	  ..s money=0,presctype=""
	  ..s money=$p(prescmoney,"^",1)
	  ..s presctype=$p(prescmoney,"^",2)
	  ..q:money=0
	  ..set Data=$lb(patname,patno,patsex,patage,deploc,presc,paqdate,"",money,mricd,adm,presctype)
 	  ..Set ^CacheTemp(repid,ind)=Data	
 	  ..Set ind=ind+1
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryLocPatNotPrtPYFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocPatNotPrtPYExecute ]
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

Query QueryLocPatNotPrtPY(CDateSt As %String, CDateEnd As %String, GPhl As %String, CPmiNo As %String, GPydr As %String, GFydr As %String) As %Query(ROWSPEC = "TPatName:%String,TPmiNo:%String,TPatSex:%String,TPatAge:%String,TPatLoc:%String,TPrescNo:%String,TPrescDate:%String,TDispFlag:%String,TPrescMoney:%String,TMR:%String,TAdm:%String,TPrescType:%String")
{
}

ClassMethod GetSpec(inci)
{
	;根据库存项代码取得规格 -07-11-02
	;incicode : 代码
	;inci : rowid of INC_Itm
	;"inci"为空时根据"incicode"取??否则使用"inci"
	s spec=""
	//s spec=$p(^INCI(inci,3),"^",9)
	s add=$o(^DHCITMINFO(0,"INCI",inci,"")) q:add=""
	s spec=$p($G(^DHCITMINFO(add)),"^",27)
	q spec
}

ClassMethod QueryLocPatNotPrtFYClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocPatNotPrtFYExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryLocPatNotPrtFYExecute(ByRef QHandle As %Binary, CDateSt As %Library.String = "", CDateEnd As %Library.String = "", GPhl As %Library.String = "", CPmiNo As %Library.String = "", GPydr As %Library.String = "", GFydr As %Library.String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	s phl=""
	s sysdate=+$h
    s phl=GPhl
    
	i (phl="")!(CPmiNo="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s stdate=CDateSt
	s enddate=CDateEnd
	s cyflag="",dfflag="" 
	s cyflag=$p(^DHCPHLOC(phl),"^",6)
	s yflocdr=+$p(^DHCPHLOC(phl),"^",1)
	s fpflag=""
    s pmi=""
    s pmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(CPmiNo),""))
    i pmi="" Set QHandle=$lb(0,repid,0)	Quit $$$OK
    s patno="",patname=""
    s patno=$p(^PAPER(pmi,"PAT",1),"^",2)
    s patname=$p(^PAPER(pmi,"ALL"),"^",1)
    s patsexdr="",patsex="",birthday="",difdate="",patage="",deploc="",deplocdr="" 
	s patsexdr=+$p(^PAPER(pmi,"ALL"),"^",7)
    i patsexdr'="" s patsex=$p(^CT("SEX",patsexdr),"^",2)
    s patage=##class(web.DHCOutPhTQDisp).GetPatientAgeDesc(pmi)
	
	/*s admdate=0
    f admdate=stdate:1:enddate  d
	  .s adm=0
	  .f  s adm=$o(^PAADMi("PAADM_AdmDate",admdate,adm)) q:(adm="")!(adm=0)  d
	  ..s admpmi=""
	  ..s admpmi=+$p(^PAADM(adm),"^",1)
	  ..q:admpmi'=pmi
	  ..s admtype=$p(^PAADM(adm),"^",2)
	  ..q:(admtype="O")
	  ..s StayRtn=##class(web.DHCADMVisitStat).GetStayStatus(adm)
	  ..q:(StayRtn'=1) */
	  
	  
	  s adm=0
	  f  s adm=$o(^PAPERdr(pmi,"ADM","E",adm)) q:(adm="")  d
	  .s StayRtn=##class(web.DHCADMVisitStat).GetStayStatus(adm)
	  .q:(StayRtn'=1)
	  .s deplocdr="",deploc=""
	  .s deplocdr=+$p(^PAADM(adm),"^",4)
	  .s deploc=$p(^CTLOC(deplocdr),"^",2)
	  .i deploc["-" s deploc=$p(deploc,"-",2)
	  .s admreasdr="",reascode=""
	  .s admreasdr=+$p(^PAADM(adm,1),"^",7)
	  .s reascode=$p(^PAC("ADMREA",admreasdr),"^",1)
	  .;q:reascode'="POSTPAID"
	  .s mradm="",mricd=""
	  .s mradm=+$p(^PAADM(adm),"^",61)
	  .s mrdia="0",allicd=""
	  .f  s mrdia=$o(^MR(mradm,"DIA",mrdia)) q:(mrdia="")!(mrdia="0")  d
	  ..s icdcode="",desc=""
	  ..s icdcode=+$p(^MR(mradm,"DIA",mrdia),"^",1)
	  ..i icdcode'=0 s desc=$p(^MRC("ID",icdcode),"^",2)
	  ..i desc'=""  d
	  ...i allicd="" s allicd=desc
	  ...e  s allicd=allicd_";"_desc
      .s mricd=allicd
	  .s paqrow=0
	  .f  s paqrow=$o(^PAQUE1(0,"QUE1_PAADM_DR",adm,paqrow)) q:(paqrow="")!(paqrow=0)  d
	  ..s presc="",dispflag="",paqdate="",pyflag=""
	  ..s presc=$p(^PAQUE1(paqrow),"^",14)
	  ..s paqdate=+$p(^PAQUE1(paqrow),"^",7)
	  ..s paqdate=$zd(paqdate,3)
	  ..s dispflag=##class(web.DHCOutPhNotPrtDisp).CheckDispFrPresc(presc,"FY")
	  ..q:dispflag=1
	  ..s pyflag=##class(web.DHCOutPhNotPrtDisp).CheckPYFrPresc(presc,adm)
	  ..q:pyflag'=1
	  ..s prescmoney=0
	  ..s prescmoney=##class(web.DHCOutPhNotPrtDisp).GetPrescMoney(adm,presc,yflocdr)
	  ..s money=0,presctype=""
	  ..s money=$p(prescmoney,"^",1)
	  ..s presctype=$p(prescmoney,"^",2)
	  ..q:money=0
	  ..set Data=$lb(patname,patno,patsex,patage,deploc,presc,paqdate,"",money,mricd,adm,presctype)
 	  ..Set ^CacheTemp(repid,ind)=Data	
 	  ..Set ind=ind+1
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryLocPatNotPrtFYFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocPatNotPrtFYExecute ]
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

Query QueryLocPatNotPrtFY(CDateSt As %String, CDateEnd As %String, GPhl As %String, CPmiNo As %String, GPydr As %String, GFydr As %String) As %Query(ROWSPEC = "TPatName:%String,TPmiNo:%String,TPatSex:%String,TPatAge:%String,TPatLoc:%String,TPrescNo:%String,TPrescDate:%String,TDispFlag:%String,TPrescMoney:%String,TMR:%String,TAdm:%String,TPrescType:%String")
{
}

ClassMethod QueryDispPrescClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryDispPrescExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryDispPrescExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "", CPmino As %Library.String = "") As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 set myrowid=0
 
 i (CPmino="")!(ctloc="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
 s phl=""
 s phl=$O(^DHCPHLOCi("LOC",ctloc,""))
 s pmi=""
 s pmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(CPmino),""))
 i pmi="" Set QHandle=$lb(0,repid,0)	Quit $$$OK
 
 s phdrow="0"
 f  s phdrow=$o(^DHCPHDISPi("PAPMI",pmi,phdrow)) q:(phdrow="")!(phdrow=0)  d
   .s fyflag="",phdloc=""
   .s fyflag=$p(^DHCPHDISP(phdrow),"^",4)
   .q:fyflag'=1
   .
   .s phdloc=+$p(^DHCPHDISP(phdrow,1),"^",1)
   .
   .q:phdloc'=phl
   .
   .s phdadm=$p(^DHCPHDISP(phdrow,1),"^",18)
   .s amdtype=""
   .i phdadm'="" s admtype=$p(^PAADM(phdadm),"^",2)
   .//q:admtype="O"
   .//s StayRtn=##class(web.DHCADMVisitStat).GetStayStatus(phdadm)
   .//q:(StayRtn'=1)
   .s presc=""
   .s presc=$p(^DHCPHDISP(phdrow,2),"^",1)
   .s fydate=""
   .s fydate=+$p(^DHCPHDISP(phdrow),"^",3)
   .s fydate=$zd(fydate,3)
   .
   .set Data=$lb(fydate,presc)
   .Set ^CacheTemp(repid,ind)=Data	
   .Set ind=ind+1
 Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryDispPrescFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDispPrescExecute ]
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

Query QueryDispPresc(ctloc As %String, CPmino As %String) As %Query(ROWSPEC = "FYDATE:%String,PrescNo:%String") [ SqlProc ]
{
}

ClassMethod GetPatInfFrPresc(prescno)
{
  s retval="",paticd="",patloc="",cflb="",depdesc=""
  s ord=0,adm=""
  s ord=$o(^OEORD(0,"PrescNo",prescno,""))
  i ord="" q -1
  s adm=+$p(^OEORD(ord),"^",1)
  s itm=""
  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,""))
  i itm="" q -1
  s presctype="",presctypedr=""
  s presctypedr=$p(^OEORD(ord,"I",itm,11),"^",18)
  i presctypedr'="" s presctype=$p(^PAC("ADMREA",presctypedr),"^",2)
  s patloc=+$p(^PAADM(adm),"^",4)
  s depdesc=$p(^CTLOC(patloc),"^",2)
  i depdesc["-" s depdesc=$p(depdesc,"-",2)
  s mradm="",mricd=""
  s mradm=+$p(^PAADM(adm),"^",61)
  s mrdia="0",allicd=""
  f  s mrdia=$o(^MR(mradm,"DIA",mrdia)) q:(mrdia="")!(mrdia="0")  d
	 .s icdcode="",desc=""
	 .s icdcode=+$p(^MR(mradm,"DIA",mrdia),"^",1)
	 .i icdcode'=0 s desc=$p(^MRC("ID",icdcode),"^",2)
	 .i desc'=""  d
	 ..i allicd="" s allicd=desc
	 ..e  s allicd=allicd_";"_desc
  s mricd=allicd
  s retval=depdesc_"^"_presctype_"^"_mricd
 q retval
}

}
