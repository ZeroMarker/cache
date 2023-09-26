Class CHSSWeb.Pharmacy.OutDispensePha Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

/// creator:zhangyong
/// date:2011-10-12
/// description: 门诊药房发药列表
/// input:  StartDate(起始日期)  EndDate(截止日期)  PhaLoc(药房)
///         PapmiNo(登记号)      FinFlag(发药状态)
/// output: String "PapmiName^PapmiNo^PhaData^PhaPrintFlag^PhaFinFlag^PrtInv^PhaPrescNo^PrtAcount^PhaFact^PrescType^PhaWindow^PatICD^PatSex^PatAge^PatLoc^PrtInvRowId^PhaLoc"
/// others: 
ClassMethod QueryLocPat(StartDate As %String, EndDate As %String, PhaLoc As %String, PapmiNo As %String, FinFlag As %String)
{
	SET StartDate=$ZDH(StartDate,3)
	SET EndDate=$ZDH(EndDate,3)
	SET PhaLoc = $ORDER(^DHCPHLOCi("LOC",PhaLoc,0))
	Set json = ##class(Code.JsonObj).%New()
	Set count=0
	FOR prtdate=StartDate:1:EndDate DO
	.SET pha=0
	.FOR  SET pha=$ORDER(^DHCPHARWi(prtdate,PhaLoc,pha)) QUIT:pha=""  DO
	..SET Nouser = $P(^DHCPHARW(pha),"^",7)
	..SET RetFlg = $P(^DHCPHARW(pha),"^",13)
	..SET PhaFinFlag = $P(^DHCPHARW(pha),"^",6)
	..SET PapmiNoId = $p(^PAPER($p(^DHCINVPRT($p(^DHCPHARW(pha),"^",1)),"^",15),"PAT",1),"^",2)
	..IF (Nouser '= "1") && (RetFlg = "1") && (FinFlag = PhaFinFlag) && (PapmiNoId = PapmiNo) D
	...SET papmidr = $P(^DHCINVPRT($p(^DHCPHARW(pha),"^",1)), "^", 15)
	...SET Pat = ^PAPER(papmidr, "ALL")
	...SET PapmiName = $P(Pat,"^",1)
	...SET PapmiNo = PapmiNo
	...SET PhaData = $ZD($P(^DHCPHARW(pha),"^",2), 3)
	...SET PhaPrintFlag = $P(^DHCPHARW(pha),"^",8)
	...IF PhaPrintFlag = "1" D
	....SET PhaPrintFlag = "是"
	...ELSE  D
	....SET PhaPrintFlag = "否"
	...SET PhaFinFlag = $P(^DHCPHARW(pha),"^",6)
	...IF PhaFinFlag = "1" D
	....SET PhaFinFlag = "是"
	...ELSE  D
	....SET PhaFinFlag = "否"
	...SET PrtInv = $p(^DHCINVPRT($p(^DHCPHARW(pha),"^",1)),"^",14)
	...SET PrtInvRowId = $p(^DHCPHARW(pha),"^",1)
	...SET PhaPrescNo = $P(^DHCPHARW(pha),"^",16)
	...SET PrtAcount = $p(^DHCINVPRT($p(^DHCPHARW(pha),"^",1)),"^",1)
	...SET pp=##class(web.DHCOutPhDisp).GPerOrd(PhaLoc,$p(^DHCPHARW(pha),"^",1),PhaPrescNo)
	...IF pp["&"  d 
	....SET PhaFact=$p(pp,"&",3)
	...ELSE  D
	....SET PhaFact = ""
	...SET ptype=##class(web.DHCOutPhDisp).CheckPydType(PhaLoc,$p(^DHCPHARW(pha),"^",1),PhaPrescNo)
	...SET PrescType = $p(ptype,"^",1)
	...SET PhaWindow = ""
	...SET retval=##class(web.DHCOutPhDisp).GPerIcd(PhaLoc,$p(^DHCPHARW(pha),"^",1),PhaPrescNo)
	...SET PatICD = $p(retval,"&",1)
	...SET PatSex = $p(^CT("SEX",$P(Pat,"^",7)),"^",2)
	...SET PatAge = ##class(CHSSWeb.DTHealthCommon).GetAgeDesc($P($G(^PAPER(papmidr,"ALL")),"^",6) , "")
	...SET patadm=##class(web.DHCOutPhDisp).getadm(PhaPrescNo)
	...SET patloc=$p(^PAADM(patadm),"^",4)
	...SET PatLoc = $p(^CTLOC(patloc),"^",2)
	...Set tmp = PapmiName_"^"_PapmiNo_"^"_PhaData_"^"_PhaPrintFlag_"^"_PhaFinFlag_"^"_PrtInv_"^"_PhaPrescNo_"^"_PrtAcount_"^"_PhaFact_"^"_PrescType_"^"_PhaWindow_"^"_PatICD_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_PrtInvRowId_"^"_PhaLoc
	...Set count = count + 1
	...Do json.InsertRowData(tmp)
	Set resultString = json.getJsonData("PapmiName^PapmiNo^PhaData^PhaPrintFlag^PhaFinFlag^PrtInv^PhaPrescNo^PrtAcount^PhaFact^PrescType^PhaWindow^PatICD^PatSex^PatAge^PatLoc^PrtInvRowId^PhaLoc",count)
	Kill json
	WRITE resultString
	Quit resultString
}

/// creator:zhangyong
/// date:2011-10-13
/// description: 发药明细
/// input:  rPHL(药房)  rPRT(收据号RowId)  rPrescNo(处方签)
/// output: String ypmc^newunitdesc^qty^newprice^dispmoney^oeflag^jlflag^phfragdesc^instrdesc^duratdesc^username^orditm^newunit^yppc^yphw^phtype^phgg^phbz^unflag^skintest^syflag^factdesc^doctcode^jrflag^cyyf^kcqty^ybcode^dxts
/// others:
ClassMethod GDispItm(rPHL As %String, rPRT As %String, rPrescNo As %String)
{
	  Set json = ##class(Code.JsonObj).%New()
	  Set count=0
	  s HospitalCode=""
	  s str=$g(^DHCDocConfig("CurrentHospital"))
	  s HospitalCode=$p(str,"^",1)
	  s ind=1
	  s sysdate=""
	  s phl=$g(rPHL)
	  s prt=$g(rPRT)
	  SET phl = $ORDER(^DHCPHLOCi("LOC",phl,0))
	  i phl=""  Quit 
      s cyflag=""
      s cyflag=$p(^DHCPHLOC(phl),"^",6)
	  s yprescno=$g(rPrescNo)
	  i (phl="")!(prt="")  Quit
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
	      ..;q:money=0
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
	      ..s ybcode=$p(^PHCD(drgmast,4),"^",2)
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
	    .i phfragdr'="" s phfragdesc=$p($g(^PHCFR(phfragdr)),"^",4)
	    .s instrdesc=""
	    .i instrdr'="" s instrdesc=$p($g(^PHCIN(instrdr)),"^",2)
	    .s orddoctnam=""
	    .i orduser'="" s orddoctnam=$p(^SSU("SSUSR",orduser),"^",2)
	    .s doctype=""
	    .;i orddoctco'=""  s doctype=$p(^CT("CPT",+$p(^CTPCP(orddoctco,1),"^",4)),"^",4)
	    .s jlflag=""
	    .;i unitdesc["?" s unitdesc=$p(unitdesc,"?",1) s unitdesc=unitdesc_"?"
	    .s jlflag=doseqty_basuomdesc
	    .i userdoctype'["DOC"  d
	      ..s jlflag="",phfragdesc="",instrdesc="",duratdesc="",orddoctnam="",username=""
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
	    .i HospitalCode["BJZLYY"  d
	      ..i phdesc["(" s phdesc=$p(phdesc,"(",1)
	      ..i phdesc["[" s phdesc=$p(phdesc,"[",1)
        .s ypmc=""
        .s ypmc=phdesc
        .i cyflag="1"  d
          ..i ypmc["("  d
          ...s ypmc=$p(ypmc,"(",1)
          ..i ypmc["["   d
          ...s ypmc=$p(ypmc,"[",1)
	    .;s ypmc=phdesc_"("_incTYdesc_")"
	    .Set tmp = ypmc_"^"_newunitdesc_"^"_qty_"^"_newprice_"^"_dispmoney_"^"_oeflag_"^"_jlflag_"^"_phfragdesc_"^"_instrdesc_"^"_duratdesc_"^"_username_"^"_ord_"||"_itm_"^"_newunit_"^"_yppc_"^"_yphw_"^"_phtype_"^"_phgg_"^"_phbz_"^"_unflag_"^"_skintest_"^"_syflag_"^"_factdesc_"^"_doctcode_"^"_jrflag_"^"_cyyf_"^"_kcqty_"^"_ybcode_"^"_dxts
	    .Set count = count + 1
	    .Do json.InsertRowData(tmp)
	    Set resultString = json.getJsonData("ypmc^newunitdesc^qty^newprice^dispmoney^oeflag^jlflag^phfragdesc^instrdesc^duratdesc^username^orditm^newunit^yppc^yphw^phtype^phgg^phbz^unflag^skintest^syflag^factdesc^doctcode^jrflag^cyyf^kcqty^ybcode^dxts",count)
	    Kill json
	    WRITE resultString
	    Quit resultString
}

/// creator:zhangyong
/// date:2011-10-19
/// description: 读取卡信息
/// input:  CardType(卡类型)  CardNo(卡号)
/// output: String 
/// others:
ClassMethod GetAccInfoFromCardNo(CardType As %Library.String, CardNo As %Library.String) As %Library.String
{
	SET resultString = ##class(CHSSWeb.DTHealthCommon).GetPatInfoFromCardNo(CardType,CardNo)
	SET CFPAPMINo = $P(resultString, "^", 2)
	if CFPAPMINo="" D
	.w "{""success"":""false"",""info"":""没有查询结果!""}"
	ELSE  D
	.w "{""success"":""true"",""info"":"""_resultString_"""}"
	Q ""
}

/// creator:zhangyong
/// date:2011-10-20
/// description: 检核库存
/// input:  ctloc(药房)  prt(收据号RowId)  presc(处方签)
/// output: String 
/// others:
ClassMethod CheckPhKC(ctloc, prt, presc)
{
 s phl="",ret=0,kc=""
 s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
 s kc=##class(web.DHCOutPhDisp).GPerOrd(phl,prt,presc)
 i kc["^" s ret=1
 e  s ret=0
 if ret=1 D
 .w "{""success"":""false"",""info"":"""_1_"""}"
 ELSE  D
 .w "{""success"":""true"",""info"":"""_0_"""}"
 Q ""
}

/// creator:zhangyong
/// date:2011-10-20
/// description: 发药确认
/// input: prt(收据号RowId)  GPhl(药房)  GPydr(配药人)  GFydr(发药人)  prescno(处方签)  shdr(审核人)  pwin  newwin  fs(付数/剂数)  phw(发药窗口)
/// output: String 
/// others:
ClassMethod UpdatePhKC(prt, GPhl, GPydr, GFydr, prescno, shdr, pwin, newwin, fs, phw)
{
 s ret = -1
 set phwpos = ""
 s ret=##class(web.DHCOutPhDisp).InsertPHDisp(prt,GPhl,phw,GPydr,GFydr,prescno,phwpos)
 if ret'=0 D
 .w "{""success"":""false"",""info"":"""_-1_"""}"
 ELSE  D
 .s ret=##class(web.DHCOutPhDisp).UpdatePyd(prt,GPhl,GPydr,GFydr,prescno,shdr,pwin,newwin,fs)
 .if ret'=0 D
 ..w "{""success"":""false"",""info"":"""_-1_"""}"
 .ELSE  D
 ..w "{""success"":""true"",""info"":"""_0_"""}"
 Q ""
}

Storage Default
{
<Data name="OutDispensePhaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.Phar5B2.OutDispensePhaD</DataLocation>
<DefaultData>OutDispensePhaDefaultData</DefaultData>
<IdLocation>^CHSSWeb.Phar5B2.OutDispensePhaD</IdLocation>
<IndexLocation>^CHSSWeb.Phar5B2.OutDispensePhaI</IndexLocation>
<StreamLocation>^CHSSWeb.Phar5B2.OutDispensePhaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
