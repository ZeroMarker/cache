Class CHSSWeb.Pharmacy.OutDspPhaQuery Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

/// creator:zhangyong
/// date:2011-11-8
/// description: 门诊药房发药查询列表
/// input:  StartDate(起始日期)  EndDate(截止日期)  ctloc(药房)      CPmiNo(登记号)    
///         inci(药品编号)       CPydr(配药人员)  CFydr(发药人员)    FinFlag(发药状态)  
/// output: String  pname^perno^pydate^phdmoney^pyname^fyname^inv^phdrow^prescno^presctypedesc^prttime^durfact^adm^mricd^fytime^prtdate
/// others: 
ClassMethod QueryLocPatienCX(StartDate As %Library.String = "", EndDate As %Library.String = "", ctloc As %Library.String = "", CPmiNo As %Library.String = "", inci As %Library.String = "", CPydr As %Library.String = "", CFydr As %Library.String = "", FyFlag As %Library.String = "") As %Library.String
{
	Set json = ##class(Code.JsonObj).%New()
	s ind=0,st="",end=""
	s phmoney=0,phcount=0
	s resultString = ""
	i $g(ctloc)="" Quit resultString
	
	s st=$ZDH(StartDate,3)
	s end=$ZDH(EndDate,3)
	i st>end Quit resultString
	s pmino=CPmiNo
	s inci=$g(inci)
	s pydr=CPydr
	s fydr=CFydr
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl=""  Quit resultString
	s cyflag="",dfflag="" 
	s cyflag=$p(^DHCPHLOC(phl),"^",6)
	;已发药
	i FyFlag'="2" 
  	{ s phddate = ""
    f phddate=st:1:end  d
      .s phdrow = ""
      .f  s phdrow=$o(^DHCPHDISPi(phddate,phl,phdrow)) q:phdrow=""  d
         ..s ppyflag="",pfyflag="",pydr1="",fydr1="",prt="",inv="",pydate="",use="",perno="",pname=""
         ..s ppyflag=$p(^DHCPHDISP(phdrow,1),"^",6)
         ..s pfyflag=$p(^DHCPHDISP(phdrow),"^",4)
         ..q:(ppyflag'="1")
         ..q:(pfyflag="1")&(FyFlag="0")
         ..q:(pfyflag'="1")&(FyFlag="1")
         ..s pydate=phddate
         ..s pydate=$zd(pydate,3)
         ..s pydr1=+$p(^DHCPHDISP(phdrow,1),"^",3)
         ..s fydr1=+$p(^DHCPHDISP(phdrow,1),"^",2)
         ..q:(fydr1'=fydr)&(fydr'="")
         ..q:(pydr1'=pydr)&(pydr'="") 
         ..s prescno=""
         ..s prescno=$p(^DHCPHDISP(phdrow,2),"^",1)
         ..s pmi=""
         ..s pmi=+$p(^DHCPHDISP(phdrow),"^",7)
         ..s perno=$p(^PAPER(pmi,"PAT",1),"^",2)
         ..q:(perno'=pmino)&(pmino'="")
         ..s pname=$p(^PAPER(pmi,"ALL"),"^",1)
         ..s pyname="",fyname=""
         ..i $d(^DHCPHPER(pydr1))  s pyname=$p(^DHCPHPER(pydr1),"^",2)
         ..i $d(^DHCPHPER(fydr1))  s fyname=$p(^DHCPHPER(fydr1),"^",2)
         ..s prt=+$p(^DHCPHDISP(phdrow),"^",2)
         ..q:'$d(^DHCINVPRT(prt))
         ..s inv=$p(^DHCINVPRT(prt),"^",14)
         ..s prtflag=""
         ..s prtflag=$p(^DHCINVPRT(prt),"^",8)
         ..q:(prtflag["A")&(FyFlag="0")
         ..s prttime=""
         ..s prttime=+$p(^DHCINVPRT(prt),"^",20)
         ..s prttime=$zt(prttime)
         ..s date=""
         ..s date=+$p(^DHCINVPRT(prt),"^",5)
         ..s date=$zd(date,3)
         ..s fytime=""
	     ..i pfyflag="1" s fytime=+$p(^DHCPHDISP(phdrow),"^",5)
	     ..i fytime'="" s fytime=$zt(fytime)
         ..s phdi="",phdmoney=0,preason=""
         ..s pp=0,qq=0
         ..s adm="",mricd=""
         ..s mricd=##class(web.DHCOutPhDisp).GPerIcd(phl,prt,prescno)
         ..f  s phdi=$o(^DHCPHDI(phdrow,"PHDI",phdi)) q:phdi=""  d
            ...s money=0
            ...s money=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",3)
            ...s orditm="",ord="",itm="",durfact=""
            ...s orditm=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",5)
            ...s ord=$p(orditm,"||",1)
            ...s itm=$p(orditm,"||",2)
            ...s adm=+$P(^OEORD(ord),"^",1)
            ...s duratdr="" s duratdr=+$p($g(^OEORD(ord,"I",itm,2)),"^",6)
            ...i duratdr'="" s durfact=$p($g(^PHCDU(duratdr)),"^",2)
            ...i cyflag'="1" s durfact=""
            ...s preason=$p(^OEORD(ord,"I",itm,11),"^",18)
            ...s itmmast="",inc=""
            ...s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
            ...s ItemCatDR="",ordertype=""
            ...s ItemCatDR=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),1),"^",10)
            ...s inc=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),inc))
            ...s manrow="",incmanflag=""
            ...s manrow=$o(^DHCPHMCi(ctloc,inc,manrow))
	        ...i (manrow'="")&(manrow'="0")  d
	          ....s incmanflag=$p(^DHCPHMC(manrow),"^",4)
	        ...i (incmanflag="1") s qq=qq+1
            ...i (inc=inci)&(inci'="") s pp=pp+1
            ...s ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
            ...q:(ordertype'="R")
            ...s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",2)
            ...;q:oeflag["停止"
            ...s phdmoney=phdmoney+money
          ..q:(pp=0)&(inci'="")
          ..q:(qq=0)
          ..s dhcprescrow="",PrescTypeCode="",presctypedesc=""
          ..s dhcprescrow=$o(^DHCPAQPT(0,"PrescNo",prescno,""))
          ..i dhcprescrow '=""  d
           ...s psonrow="",pson="",psoncode=""
           ...s psonrow=+$p(^DHCPAQPT(dhcprescrow),"^",2)
           ...s pson=+$p(^DHCPAADMPrescType(psonrow),"^",2)
           ...s PrescTypeCode=pson
           ...s presctypedesc=$p(^PAC("ADMREA",PrescTypeCode),"^",2)
          ..e  d
            ...s PrescTypeCode=preason
            ...i PrescTypeCode'="" s presctypedesc=$p(^PAC("ADMREA",PrescTypeCode),"^",2)
            ...e  s presctypedesc=""
          ..s phmoney=phmoney+phdmoney
          ..s phcount=phcount+1
          ..Set tmp = pname_"^"_perno_"^"_pydate_"^"_phdmoney_"^"_pyname_"^"_fyname_"^"_inv_"^"_phdrow_"^"_prescno_"^"_presctypedesc_"^"_prttime_"^"_durfact_"^"_adm_"^"_mricd_"^"_fytime_"^"_date
 	      ..Set ind=ind+1
 	      ..Do json.InsertRowData(tmp)
     }
     else {
	 s phadate=0
	 f phadate=st:1:end  d
	  .s pha=0
	  .f  s pha=$o(^DHCPHARWi(phadate,phl,pha)) q:pha=""  d
        ..s phw="",finflag="",nouse="",printflag="",arrcpdr="",prt="",prescno=""
	    ..s finflag=$p(^DHCPHARW(pha),"^",6)
	    ..q:(finflag="1")
	    ..s printflag=$p(^DHCPHARW(pha),"^",8)
	    ..q:(printflag="1")
	    ..s nouse=$p(^DHCPHARW(pha),"^",7)
	    ..q:nouse="1"
	    ..s prt=+$p(^DHCPHARW(pha),"^",1)
	    ..s prttime=""
        ..s prttime=+$p(^DHCINVPRT(prt),"^",20)
	    ..s prttime=$zt(prttime)
	    ..s date=""
        ..s date=$p(^DHCINVPRT(prt),"^",5)
        ..s date=$zd(date,3)
	    ..s prescno=$p(^DHCPHARW(pha),"^",16)
	    ..s preason=""
	    ..s adm="",mricd=""
        ..s mricd=##class(web.DHCOutPhDisp).GPerIcd(phl,prt,prescno)
	    ..s bci="0"
	    .. f  s bci=$o(^DHCBCI(0,"INV",prt,bci)) q:(bci="")!(bci="0")!(preason'="")  d
	      ...s patbill=""
	      ...s patbill=+$p(^DHCBCI(bci),"^",2)
	      ...s patbillsub="0"
	      ...f  s patbillsub=$o(^DHCPB(patbill,"O",patbillsub)) q:(patbillsub="")!(patbillsub="")!(preason'="")  d
	        ....s orditm="",ord="",itm="",dispflag="",presc=""
	        ....s orditm=$p(^DHCPB(patbill,"O",patbillsub),"^",4)
	        ....s ord=$p(orditm,"||",1),itm=$p(orditm,"||",2)
	        ....s adm=+$P(^OEORD(ord),"^",1)
	        ....s recplocdr=""
	        ....s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	        ....q:recplocdr=""
	        ....q:recplocdr'=ctloc
	        ....s presc=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
	        ....q:presc=""
	        ....q:presc'=prescno
	        ....s preason=$p(^OEORD(ord,"I",itm,11),"^",18)
	    ..s dhcprescrow="",PrescTypeCode="",presctypedesc=""
        ..s dhcprescrow=$o(^DHCPAQPT(0,"PrescNo",prescno,""))
        ..i dhcprescrow '=""  d
           ...s psonrow="",pson="",psoncode=""
           ...s psonrow=+$p(^DHCPAQPT(dhcprescrow),"^",2)
           ...s pson=+$p(^DHCPAADMPrescType(psonrow),"^",2)
           ...s PrescTypeCode=pson
           ...s presctypedesc=$p(^PAC("ADMREA",PrescTypeCode),"^",2)
          ..e  d
            ...s PrescTypeCode=preason
            ...i PrescTypeCode'="" s presctypedesc=$p(^PAC("ADMREA",PrescTypeCode),"^",2)
            ...e  s presctypedesc=""
  	    ..s arraldr=""
	    ..s papmidr="",papmino="",payamount0=0,phatime=""
	    ..q:'$d(^DHCINVPRT(prt))
	    ..s prtdate=""
	    ..s prtdate=$zd(phadate,3)
	    ..s phatime=+$p(^DHCINVPRT(prt),"^",20)
	    ..s phatime=$zt(phatime)
	    ..s papmidr=$p(^DHCINVPRT(prt),"^",15)
	    ..q:papmidr=""
	    ..s prtcode=""
	    ..s prtcode=$p(^DHCINVPRT(prt),"^",14)
	    ..s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	    ..q:(papmino'=pmino)&(pmino'="")
	    ..s patienname=""
	    ..s patienname=$p(^PAPER(papmidr,"ALL"),"^",1)
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
	    ..s pp=$fn(pmoney,"",2)
	    ..s phmoney=phmoney+pp
	    ..s phcount=phcount+1
 	    ..Set tmp = patienname_"^"_papmino_"^^"_pp_"^^^"_prtcode_"^"_prt_"^"_prescno_"^"_presctypedesc_"^"_prttime_"^"_pfact_"^"_adm_"^"_mricd_"^"_"^"_date
 	    ..Set ind=ind+1
 	    ..Do json.InsertRowData(tmp)
    }
    
    Set tmp = "合计"_"^"_phcount_"条"_"^^"_phmoney_"^^^^^^^^^^^"
 	Set ind=ind+1
 	Do json.InsertRowData(tmp)
    
	Set resultString = json.getJsonData("pname^perno^pydate^phdmoney^pyname^fyname^inv^phdrow^prescno^presctypedesc^prttime^durfact^adm^mricd^fytime^prtdate",ind)
	Kill json
	WRITE resultString
	Quit resultString
}

/// creator:zhangyong
/// date:2011-11-9
/// description: 发药明细
/// input:  rPhd(收据RowID)  FyFlag(发药状态)  rCtloc(药房)   rPrescNo(处方号)    
/// output: String orditem^phdesc^newunitdesc^newprice^newqty^totprice^oeflag^pc^phfragdesc^instrdesc^duratdesc^username^yppc^yphw^newretqty
/// others: 
ClassMethod QueryGPersonOrd(rPhd, FyFlag, rCtloc, rPrescNo) As %Library.String
{
	Set json = ##class(Code.JsonObj).%New()
	s resultString = ""
	s ind=0
	s phd=""
	s phd=rPhd
	s phl="",ctloc="",yprescno=""
	s ctloc=rCtloc,yprescno=rPrescNo
	i phd=""  Quit resultString
	i '$d(^DHCPHDISP(phd))	 s FyFlag="2"
    i FyFlag="1" { s phl=+$p(^DHCPHDISP(phd,1),"^",1)}
    else {s phl=$o(^DHCPHLOCi("LOC",ctloc,""))}
    i FyFlag'="2"{
    s phdi = "", m = 0
    f  s phdi=$o(^DHCPHDI(phd,"PHDI",phdi)) q:phdi=""  d
      .s orditm = ""
      .s orditm=$p(^DHCPHDI(phd,"PHDI",phdi),"^",5)
      .s ord = "", ordi = ""
      .s ord=$p(orditm,"||",1)
      .s ordi=$p(orditm,"||",2)
      .
      .s itmmast = ""
      .s itmmast=$p(^OEORD(ord,"I",ordi,1),"^",2)      ;arc_itmmast
      .s priority = ""
      .s dispqty = "",retqty=0
      .s dispqty=+$p(^DHCPHDI(phd,"PHDI",phdi),"^",4)      ;药品数量
      .s retqty=+$p(^DHCPHDI(phd,"PHDI",phdi),"^",6)
      .s price = 0, totprice = 0
      .s totprice=+$p(^DHCPHDI(phd,"PHDI",phdi),"^",3)
      .q:totprice=""
      .;s price = totprice / dispqty
      .s orddoctco = ""
      .s orddoctco=$p($g(^OEORD(ord,"I",ordi,1)),"^",11) ;医师
      .s orduser="",ordusertypedr="",ordusercare="",careprovtype="",userdoctype=""
      .s orduser=+$p($g(^OEORD(ord,"I",ordi,7)),"^",1)
	  .s username=""
	  .s username=$p(^SSU("SSUSR",orduser),"^",2)
	  .i orduser'=""  s ordusercare=$p(^SSU("SSUSR",orduser),"^",14)
	  .i ordusercare'="" s careprovtype=$p(^CTPCP(ordusercare,1),"^",4)
	  .i careprovtype'="" s userdoctype=$p(^CT("CPT",careprovtype),"^",4)
      .s doseqty="" s doseqty=$p($g(^OEORD(ord,"I",ordi,2)),"^",1)
      .s unitdr="" s unitdr=$p($g(^OEORD(ord,"I",ordi,2)),"^",3)
      .s phfragdr="" s phfragdr=$p($g(^OEORD(ord,"I",ordi,2)),"^",4)
      .s duratdr="" s duratdr=$p($g(^OEORD(ord,"I",ordi,2)),"^",6)
      .s instrdr="" s instrdr=$p($g(^OEORD(ord,"I",ordi,2)),"^",7)
      .s unitdesc = ""
      .i unitdr '="" s unitdesc=$p($g(^CT("UOM",unitdr)),"^",2)
      .s phuomid = "", phuomdesc = "", itmmastid = "", itmmastver = ""
      .s itmmastid=$p(itmmast,"||",1)
      .s itmmastver=$p(itmmast,"||",2)
      .s ItemCatDR = "", ordertype = ""
      .s ItemCatDR=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),1),"^",10)
      .s ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
      .q:(ordertype'="R")
      .s phuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
      .q:phuomid=""
      .s phuomid=$p(phuomid,$c(1),1)
      .s currdate = ""
      .s currdate=$p($h,",",1)
      .s phuomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
      .s inci = ""
      .;^INCI(0,"ARCIM_DR",$p({INCI_OriginalARCIM_DR},"||",1),{INCI_RowId})
      .s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
      .q:inci=""
      .s inci=$p(inci,$c(1),1)
      .s yppc="",inclb="",incib=""
	  .s ex="0"
	  .f  s ex=$o(^OEORD(ord,"I",ordi,"X",ex)) q:(ex="")!(ex="0")!(yppc'="")  d
	    ..s dsp="0"
	    ..f  s dsp=$o(^OEORD(ord,"I",ordi,"X",ex,"D",dsp)) q:(dsp="")!(dsp="0")!(yppc'="")  d
	      ...s inclb=$p(^OEORD(ord,"I",ordi,"X",ex,"D",dsp),"^",2)
	      ...s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	      ...s yppc=$p(^INCI($p(incib,"||",1),"IB",$p(incib,"||",2)),"^",1)
      .s incil="",yphw="",incstb=""
	  .s incil=$o(^INCI("IL_LOC",ctloc,inci,""))
	  .i incil'=""  d
	      ..s incstb=+$p(^INCI(inci,"IL",incil),"^",2)
	      ..i incstb'=0  d
	        ...i '$d(^INC("SB",incstb)) s yphw=""
	        ...e  s yphw=$p(^INC("SB",incstb),"^",2)
      .s phdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)
      .q:phdesc=""
      .s puruom="",puruomdesc="",basuom="",basuomdesc=""
	  .s puruom=+$p(^INCI(inci,3),"^",6)
	  .s puruomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
	  .s basuom=+$p(^INCI(inci,1),"^",10)
	  .s basuomdesc=$p($g(^CT("UOM",basuom)),"^",2)
	  .s confac=1,conrow=""
	  .i basuom=phuomid s confac=1
	  .e  d
	    ..s conrow=$o(^CT("CTCF",0,"UOM",phuomid,basuom,conrow))
	    ..i conrow'="" s confac=+$p(^CT("CTCF",conrow),"^",3)
	  .s newqty=0,newunit="",getnum=0,newunitdesc="",newprice=0,newretqty=0
	  .s getnum=$p((dispqty/confac),".",1)
	  .i getnum="" s getnum=0
	  .i getnum=(dispqty/confac)  d
	    ..s newunit=phuomid
	    ..s newunitdesc=phuomdesc
	    ..s newqty=getnum
	    ..s newprice=totprice/getnum
	    ..s newprice=$j(newprice,12,4)
	    ..s newretqty=retqty/confac
	  .e  d
	    ..s newunit=basuom
	    ..s newunitdesc=basuomdesc
	    ..s newqty=dispqty
	    ..s newretqty=retqty
	    ..s newprice=totprice/dispqty
	    ..s newprice=$j(newprice,12,4) 
      .s duratdesc = "", oemsg = ""
      .s oemsg=$g(^ARCIM(itmmastid,itmmastver,"OEM",1))
      .i oemsg["皮试"  d
          ..s oemsg="1"
      .e  s oemsg=""
      .i duratdr '="" s duratdesc=$p($g(^PHCDU(duratdr)),"^",3)
      .s phfragdesc = ""
      .i phfragdr '="" s phfragdesc=$p($g(^PHCFR(phfragdr)),"^",3)
      .s instrdesc = ""
      .i instrdr '="" s instrdesc=$p($g(^PHCIN(instrdr)),"^",2)
      .s orddoctnam = ""
      .i orddoctco '="" s orddoctnam=$p($g(^CTPCP(orddoctco,1)),"^",2)
      .s m = m + 1, Error = "", t = 0
      .s oeflag = "", inclbid = "", disstatu = "",orditem=""
      .i userdoctype'["DOC"  d
	      ..s jlflag="",phfragdesc="",instrdesc="",duratdesc="",orddoctnam="",username=""
      .s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",ordi,1),"^",13)),"^",2)       ;医嘱状态
      .s orditem=ord_"||"_ordi
	  .s pc=""
	  .s pc=doseqty_unitdesc
	   
	  .Set tmp = orditem_"^"_phdesc_"^"_newunitdesc_"^"_newprice_"^"_newqty_"^"_totprice_"^"_oeflag_"^"_pc_"^"_phfragdesc_"^"_instrdesc_"^"_duratdesc_"^"_username_"^"_yppc_"^"_yphw_"^"_newretqty
 	  .Set ind=ind+1
 	  .Do json.InsertRowData(tmp)
 	  }
 	else {
	  s prt=""
	  s prt=rPhd
 	  k ^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno)
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
	      ..q:recplocdr'=ctloc
	      ..s dispflag="" 
	      ..s dispflag=$p($g(^OEORD(ord,"I",itm,6)),"^",7)
	      ..s prescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
	      ..q:prescno=""
	      ..q:prescno'=yprescno
	      ..s qty=0,money=0
	      ..s qty=+$p(^DHCPB(patbill,"O",patbillsub),"^",5)
	      ..s money=+$p(^DHCPB(patbill,"O",patbillsub),"^",8)
	      ..i $d(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,ord,"I",itm))  d
	         ...s $p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,ord,"I",itm),"^",1)=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,ord,"I",itm),"^",1)+qty
	         ...s $p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,ord,"I",itm),"^",2)=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,ord,"I",itm),"^",2)+money
	      ..e  d
	         ...s $p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,ord,"I",itm),"^",1)=qty
	         ...s $p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,ord,"I",itm),"^",2)=money
	   s ord=""
	   f  s ord=$o(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,ord)) q:ord=""  d
	     .s itm=""
	     .f  s itm=$o(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,ord,"I",itm)) q:itm=""  d
	       ..s dispqty=0,dispmoney=0,price=0
	       ..s dispqty=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,ord,"I",itm),"^",1)
	       ..s dispmoney=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,ord,"I",itm),"^",2)
	       ..s price=dispmoney/dispqty
	 	   ..s itmmast=""
	       ..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast
	       ..s recplocdr=""
	       ..s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	       ..q:recplocdr=""
	       ..q:recplocdr'=ctloc
	       ..s priority=""
	       ..s priority=$p(^OEORD(ord,"I",itm,1),"^",8)     ;????
	       ..s yppc="",inclb="",incib=""
	       ..s ex="0"
	       ..f  s ex=$o(^OEORD(ord,"I",itm,"X",ex)) q:(ex="")!(ex="0")!(yppc'="")  d
	         ...s dsp="0"
	         ...f  s dsp=$o(^OEORD(ord,"I",itm,"X",ex,"D",dsp)) q:(dsp="")!(dsp="0")!(yppc'="")  d
	           ....s inclb=$p(^OEORD(ord,"I",itm,"X",ex,"D",dsp),"^",2)
	           ....s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	           ....s yppc=$p(^INCI($p(incib,"||",1),"IB",$p(incib,"||",2)),"^",1)
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
	    ..s unitdesc=""
	    ..i unitdr'="" s unitdesc=$p($g(^CT("UOM",unitdr)),"^",2)
	    ..s phuomid="",phuomdesc="",itmmastid="",itmmastver=""
	    ..s itmmastid=$p(itmmast,"||",1)
	    ..s itmmastver=$p(itmmast,"||",2)
	    ..s drgform="",drgmast="",phtype=""
	    ..s drgform=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
	    ..i drgform'="" s drgmast=$p(drgform,"||",1)
	    ..i drgmast'=""  d
	      ...s phtype=$p($g(^PHCD(drgmast,4)),"^",2)
	    ..s phuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	    ..q:phuomid=""
	    ..s phuomid=$p(phuomid,$c(1),1)
	    ..s phbz="",bz=0,bb=0
	    ..s bz=$g(^OEORD(ord,"I",itm,"DEP",0))
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
	    ..;^INCI("IL_LOC",{INCIL_CTLOC_DR},{INC_Itm.INCI_RowId},             x
	    ..s incil="",yphw="",incstb=""
	    ..s incil=$o(^INCI("IL_LOC",ctloc,inci,""))
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
	    ..s phgg=""
	    ..s phgg=$p($g(^INCI(inci,3)),"^",9)
	    ..s confac=1,conrow=""
	    ..i basuom=puruom s confac=1
	    ..e  d
	      ...s conrow=$o(^CT("CTCF",0,"UOM",phuomid,basuom,conrow))
	      ...i conrow'="" s confac=+$p(^CT("CTCF",conrow),"^",3)
	    ..s qty=0,newunit="",getnum=0,newunitdesc="",newprice=0
	    ..s getnum=$p((dispqty/confac),".",1)
	    ..i getnum="" s getnum=0
	    ..i getnum=(dispqty/confac)  d
	      ...s newunit=phuomid
	      ...s newunitdesc=phuomdesc
	      ...s qty=getnum
	      ...s newprice=price*confac
	    ..e  d
	       ...s newunit=basuom
	       ...s newunitdesc=basuomdesc
	       ...s qty=dispqty
	       ...s newprice=price
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
	    ..s error="",t=0,cc=0,notes=""
	    ..s notes=$p(^OEORD(ord,"I",itm,2),"^",8)
	    ..s oeflag="",inclbid="",disstatu=""
	    ..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",2)       ;????
        ..q:oeflag["停"
        ..i newunitdesc["(" s newunitdesc=$p(newunitdesc,"(",1)
	     ..i t=0 s error="1"
	     ..s newprice=$fn(newprice,"",4)
	     ..s dispmoney=$fn(dispmoney,"",4)
         
         ..Set tmp = ord_"^"_phdesc_"^"_newunitdesc_"^"_newprice_"^"_qty_"^"_dispmoney_"^"_oeflag_"^"_jlflag_"^"_phfragdesc_"^"_instrdesc_"^"_duratdesc_"^"_username_"^"_yppc_"^"_yphw_"^"_""
 	     ..Set ind=ind+1
 	     ..Do json.InsertRowData(tmp)
 	 }
 	
 	Set resultString = json.getJsonData("orditem^phdesc^newunitdesc^newprice^newqty^totprice^oeflag^pc^phfragdesc^instrdesc^duratdesc^username^yppc^yphw^newretqty",ind)
	Kill json
	WRITE resultString
	Quit resultString
}

}
