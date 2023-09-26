Import sqluser

Class web.DHCOutPhInterFace Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1043;

ClassMethod PutMessagePharmacy(type, rowid)
{
 s ret = ""
 s sysdate=+$h
 ;type=1 rowid是发药表的rowid
 ;type=2 rowid是退药表的rowid
 s retmain="",retsub=""
 if type=1  d
  .s pmidr = "", pmino = "", patname = "", prt = "", prtcode = ""
  .s prescno = "", fydr = "", fyuser = "", fycode = "", fydate = ""
  .s doctcode="",phl="",ctlocdesc="",ctloc="",presctypedesc=""
  .s pmidr=+$p(^DHCPHDISP(rowid),"^",7)
  .s pmino=$p(^PAPER(pmidr,"PAT",1),"^",2)
  .s patname=$p(^PAPER(pmidr,"ALL"),"^",1)
  .s prt=+$P(^DHCPHDISP(rowid),"^",2)
  .s prtuser=+$p(^DHCINVPRT(prt),"^",21)
  .s prtusername=$p(^SSU("SSUSR",prtuser),"^",2)
  .s prtcode=$p(^DHCINVPRT(prt),"^",14)
  .s prtdate=+$p(^DHCINVPRT(prt),"^",5)
  .s prtdate=$zd(prtdate,3)
  .s fydate=+$p(^DHCPHDISP(rowid),"^",3)
  .s phl=+$p(^DHCPHDISP(rowid,1),"^",1)
  .s ctloc=+$p(^DHCPHLOC(phl),"^",1)
  .s ctlocdesc=$p(^CTLOC(ctloc),"^",2)
  .s prescno=$p(^DHCPHDISP(rowid,2),"^",1)
  .s fydate=$zd(fydate,3)
  .s fydr=+$p(^DHCPHDISP(rowid,1),"^",2)
  .s fyuser=+$p(^DHCPHPER(fydr),"^",5)
  .s fycode=$p(^SSU("SSUSR",fyuser),"^",2)
  .s patsexdr="",patsex="",birthday="",difdate="",perold="",glord=""
  .s patsexdr=+$p(^PAPER(pmidr,"ALL"),"^",7)
  .s birthday=+$p(^PAPER(pmidr,"ALL"),"^",6)
  .s difdate=sysdate-birthday+1
  .s perold=difdate/365
  .s prescnum=0,admloccode=""
  .i perold["." s perold=$p(perold,".",1)
  .i patsexdr'="" s patsex=$p(^CT("SEX",patsexdr),"^",2)
  .s phdsub = ""
  .f  s phdsub=$o(^DHCPHDI(rowid,"PHDI",phdsub)) q:phdsub=""  d
    ..s orditm="",ord="",itm="",qty=0,paymoney=0,phdesc="",phcode="",itmmast=""
    ..s orditm=$p(^DHCPHDI(rowid,"PHDI",phdsub),"^",5)
    ..s qty=+$p(^DHCPHDI(rowid,"PHDI",phdsub),"^",4)
    ..s paymoney=+$p(^DHCPHDI(rowid,"PHDI",phdsub),"^",3)
    ..s price=0,adm="",admloc=""
    ..s ord=$p(orditm,"||",1)
    ..s itm=$p(orditm,"||",2)
    ..s adm=+$p(^OEORD(ord),"^",1)
    ..s admloc=+$p(^PAADM(adm),"^",4)
    ..i admloccode="" s admloccode=$p(^CTLOC(admloc),"^",1)
    ..s prescnum=prescnum+1
    ..s price=paymoney/qty
    ..s price=$fn(price,"",2)
    ..i (price<1)&(price'["0.")  s price=0_price
    ..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
    ..s inci="",inccode=""
    ..s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),inci))   
    ..q:inci=""
    ..s inccode=$p(^INCI(inci,1),"^",1)
    ..s orddoct="",preason=""
    ..s orddoct=+$p($g(^OEORD(ord,"I",itm,1)),"^",11)
    ..i (doctcode="")&(orddoct'=0) s doctcode=$p(^CTPCP(orddoct,1),"^",2)
    ..s preason=$p(^OEORD(ord,"I",itm,11),"^",18) 
    ..s PrescTypeCode=preason
    ..i PrescTypeCode'="" s presctypedesc=$p(^PAC("ADMREA",PrescTypeCode),"^",2)
    ..i retsub=""  d
    ...s retsub=inccode_"^"_qty_"^"_price_"^"_100_"^"_"1"
    ..e  d
    ...s retsub=retsub_$c(1)_inccode_"^"_qty_"^"_price_"^"_100_"^"_"1"
  .s retmain=prtdate_"^"_prtcode_"^"_fydate_"^"_prescno_"^"_admloccode_"^"_pmino_"^"_patname_"^"_perold_"^"_patsex_"^"_doctcode_"^"_prtusername_"^"_fycode_"^"_presctypedesc_"^"_"1"_"^"_ctlocdesc
  .s ret=retmain_$c(2)_retsub
 
 i type=2  d
  .s phd="",retphp="",retusername=""
  .s retphp=+$p(^DHCPHRET(rowid),"^",8)
  .s retusername=$p(^SSU("SSUSR",+$p(^DHCPHPER(retphp),"^",5)),"^",2)
  .s phd=+$p(^DHCPHRET(rowid),"^",6)
  .s pmidr = "", pmino = "", patname = "", prt = "", prtcode = ""
  .s prescno = "", fydr = "", fyuser = "", fycode = "", fydate = ""
  .s doctcode="",phl="",ctlocdesc="",ctloc="",presctypedesc=""
  .s pmidr=+$p(^DHCPHDISP(phd),"^",7)
  .s pmino=$p(^PAPER(pmidr,"PAT",1),"^",2)
  .s patname=$p(^PAPER(pmidr,"ALL"),"^",1)
  .s prt=+$P(^DHCPHDISP(phd),"^",2)
  .s prtuser=+$p(^DHCINVPRT(prt),"^",21)
  .s prtusername=$p(^SSU("SSUSR",prtuser),"^",2)
  .s prtdate=+$p(^DHCINVPRT(prt),"^",5)
  .s prtcode=$p(^DHCINVPRT(prt),"^",14)
  .s prtdate=$zd(prtdate,3)
  .s fydate=+$p(^DHCPHDISP(phd),"^",3)
  .s phl=+$p(^DHCPHDISP(phd,1),"^",1)
  .s ctloc=+$p(^DHCPHLOC(phl),"^",1)
  .s ctlocdesc=$p(^CTLOC(ctloc),"^",2)
  .s prescno=$p(^DHCPHDISP(phd,2),"^",1)
  .s fydate=$zd(fydate,3)
  .s fydr=+$p(^DHCPHDISP(phd,1),"^",2)
  .s fyuser=+$p(^DHCPHPER(fydr),"^",5)
  .s fycode=$p(^SSU("SSUSR",fyuser),"^",2)
  .s patsexdr="",patsex="",birthday="",difdate="",perold="",glord=""
  .s patsexdr=+$p(^PAPER(pmidr,"ALL"),"^",7)
  .s birthday=+$p(^PAPER(pmidr,"ALL"),"^",6)
  .s difdate=sysdate-birthday+1
  .s perold=difdate/365
  .s prescnum=0,admloccode=""
  .i perold["." s perold=$p(perold,".",1)
  .i patsexdr'="" s patsex=$p(^CT("SEX",patsexdr),"^",2)
  .s phdsub = ""
  .f  s phdsub=$o(^DHCPHDI(phd,"PHDI",phdsub)) q:phdsub=""  d
    ..s orditm="",ord="",itm="",qty=0,paymoney=0,phdesc="",phcode="",itmmast=""
    ..s orditm=$p(^DHCPHDI(phd,"PHDI",phdsub),"^",5)
    ..s qty=+$p(^DHCPHDI(phd,"PHDI",phdsub),"^",4)
    ..s paymoney=+$p(^DHCPHDI(phd,"PHDI",phdsub),"^",3)
    ..s price=0,adm="",admloc=""
    ..s ord=$p(orditm,"||",1)
    ..s retqty=0
    ..s retqty=+$p(^DHCPHDI(phd,"PHDI",phdsub),"^",6)
    ..s itm=$p(orditm,"||",2)
    ..s adm=+$p(^OEORD(ord),"^",1)
    ..s admloc=+$p(^PAADM(adm),"^",4)
    ..i admloccode="" s admloccode=$p(^CTLOC(admloc),"^",1)
    ..s prescnum=prescnum+1
    ..s price=paymoney/qty
    ..s price=$fn(price,"",2)
    ..s qty=qty-retqty
    ..q:qty=0
    ..i (price<1)&(price'["0.")  s price=0_price
    ..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
    ..s inci="",inccode=""
    ..s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),inci))   
    ..s inccode=$p(^INCI(inci,1),"^",1)
    ..s orddoct="",preason=""
    ..s orddoct=+$p($g(^OEORD(ord,"I",itm,1)),"^",11)
    ..i (doctcode="")&(orddoct'=0) s doctcode=$p(^CTPCP(orddoct,1),"^",2)
    ..s preason=$p(^OEORD(ord,"I",itm,11),"^",18) 
    ..s PrescTypeCode=preason
    ..i PrescTypeCode'="" s presctypedesc=$p(^PAC("ADMREA",PrescTypeCode),"^",2)
    ..i retsub=""  d
    ...s retsub=inccode_"^"_qty_"^"_price_"^"_100_"^"_"1"
    ..e  d
    ...s retsub=retsub_$c(1)_inccode_"^"_qty_"^"_price_"^"_100_"^"_"1"
  .s retmain=prtdate_"^"_prtcode_"^"_fydate_"^"_prescno_"^"_admloccode_"^"_pmino_"^"_patname_"^"_perold_"^"_patsex_"^"_doctcode_"^"_prtusername_"^"_retusername_"^"_presctypedesc_"^"_"1"_"^"_ctlocdesc
  .s ret=retmain_$c(2)_retsub
  i ret="" q -1
 s retval=##class(web.DHCOutPhInterFace).TransXMLFrStr(ret)
 q retval
}

ClassMethod TransXMLFrStr(AllString)
{
 s MainString=$p(AllString,$c(2),1)
 s SubString=$p(AllString,$c(2),2)
 s prtdate=$p(MainString,"^",1)
 s prtcode=$p(MainString,"^",2)
 s dispdate=$p(MainString,"^",3)
 s prescno=$p(MainString,"^",4)
 s admlocdesc=$p(MainString,"^",5)
 s patno=$p(MainString,"^",6)
 s patname=$p(MainString,"^",7)
 s patage=$p(MainString,"^",8)
 s patsex=$p(MainString,"^",9)
 s doctor=$p(MainString,"^",10)
 s prtuser=$p(MainString,"^",11)
 s fyuser=$p(MainString,"^",12)
 s presctype=$p(MainString,"^",13)
 s pattype=$p(MainString,"^",14)
 s disploc=$p(MainString,"^",15)
 k obj,objsub
 set obj=##class(web.DHCOutPhSendMeg).%New()
 s obj.Pharmacy=disploc
 s obj.PrtDate=prtdate
 s obj.PatNo=pmino
 s obj.PatName=patname
 s obj.PatSex=patsex
 s obj.PatAge=patage
 s obj.PatType=pattype
 s obj.PrescNo=prescno
 s obj.PrescType=presctype
 s obj.PatAdmLoc=admlocdesc
 s obj.PatDoctor=doctor
 s obj.Chemist=fyuser
 s obj.Cashier=prtuser
 s obj.BillNo=prtcode
 s obj.DispDate=dispdate
 s m=$l(SubString,$c(1))
 f i=1:1:m  d
  .set objsub=##class(web.DHCOutPhSendMegSub).%New()
  .s lrowstr="",phcode="",phqty=0,phprice=0,payscale="",bursary=""
  .s lrowstr=$p(SubString,$c(1),i)
  .s phcode=$p(lrowstr,"^",1)
  .s phqty=$p(lrowstr,"^",2)
  .s phprice=$p(lrowstr,"^",3)
  .s payscale=$p(lrowstr,"^",4)
  .s bursary=$p(lrowstr,"^",5)
  .s objsub.PhCode=phcode
  .s objsub.PhQty=phqty
  .s objsub.PhPrice=phprice
  .s objsub.SelfPayScale=payscale
  .s objsub.Bursary=bursary
  .d obj.PhInformation.Insert(objsub)
 set sc=obj.XMLExportToString(.result)
 quit result
}

ClassMethod DoINCADJ(allstr)
{
	;allstr=locdesc_$c(2)_phcode1_"^"_qty1_$c(1)_phcode2_"^"_qty2
  s loc=""
  s locdesc=$p(allstr,$c(2),1)
  s incstr=$p(allstr,$c(2),2)
  s loc=$o(^CTLOC(0,"Desc",locdesc,""))
  i loc="" q -1
  s curdate=+$h
  s itmnum=$l(incstr,$c(1))
  
  s ret=0
  d ..tb()
  for t=1:1:itmnum d
   .s strph=""
   .s lret=0
   .s strph=$p(incstr,$c(1),t)
   .s inccode="",incqty=0,inc=""
   .s inccode=$p(strph,"^",1)
   .s incqty=$p(strph,"^",2)
   .s inccode=$$ALPHAUP^SSUTIL4(inccode)
   .s inc=$o(^INCI(0,"Code",inccode,""))
   .q:inc=""
   .s lret=..ModifyIncItmLoc(loc,inc,incqty)
   .i lret=0  d
     ..s lret=..ModifyLocDaily(inc,loc,incqty)
   .s ret=ret+lret
   i ret'=0 d ..tr()
   e  d ..tc()
   q ret
}

ClassMethod ModifyIncItmLoc(loc, inci, incqty)
{
  
 s itmloc="",itmclbrow=""
 s itmloc=$o(^INCI("IL_LOC",loc,inci,itmloc))
 i itmloc=""  d
   .s itmclbrow=..InsertNoClb(inci,loc,"1",incqty)
   .s itmloc=$o(^INCI("IL_LOC",loc,inci,""))
 s itmlocrowid=inci_"||"_itmloc
 &sql(update sqluser.INC_ItmLoc set INCIL_LogQty=INCIL_LogQty+:incqty,INCIL_AvailQty=INCIL_AvailQty+:incqty,INCIL_RepQty=INCIL_RepQty+:incqty where INCIL_RowId=:itmlocrowid)
 s itmclb=""
 s itmclb=$o(^INCI(inci,"IL",itmloc,"LB",itmclb),-1) 
 i itmclbrow=""  s itmclbrow=inci_"||"_itmloc_"||"_itmclb
 s itmclbparref=inci_"||"_itmloc
 i itmclb=""  d
   .&sql(insert into inc_itmlcbt(inclb_incil_parref,inclb_childsub,inclb_phyqty,inclb_incib_dr)
    values(:itmclbparref,1,:incqty,:itmclbparref))
   .s itmclbrow=inci_"||"_itmloc_"||"_1
 &sql(update inc_itmlcbt set INCLB_PhyQty=INCLB_PhyQty+:incqty where inclb_rowid=:itmclbrow)
 q 0
}

ClassMethod ModifyLocDaily(inci, ctloc, qty)
{
 
 s maindaily=##class(web.DHCOutPhModCZ).DoDhcTotalMain(inci,ctloc,qty)
 i maindaily="" q -1
 s itmloc=$o(^INCI("IL_LOC",ctloc,inci,""))
 s itmclb=$o(^INCI(inci,"IL",itmloc,"LB",""),-1)
 s itmclbrow=inci_"||"_itmloc_"||"_itmclb
 s retsql=##class(web.DHCOutPhModCZ).DoDhcTotalTail(itmclbrow,ctloc,qty,maindaily)	
 q retsql
}

ClassMethod ADJTarPriceXML(adj As %GlobalCharacterStream)
{
	s allstr=""
	s ret=0
 	d adj.Rewind()
 	Set reader = ##class(%XML.Reader).%New()
	set sc=reader.OpenStream(adj)
	d reader.Correlate("TarAdjust","web.TarAdjust")
	;d ..tb()
	While reader.Next(.obj,.sc)
	 {
		s stdate=obj.Date1
		s phinf=obj.PhInformation
		s m=phinf.Count()
		for i=1:1:m 
		{
			s phcode="",price="",lret=0
			s phcode=phinf.GetAt(i).PhCode
			s price=phinf.GetAt(i).Price
			s lret=..ADJTarPrice(stdate, phcode, price)
			s ret=ret+lret
			
		}
		
		set sc=obj.%Save()
		If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
		  
	}
	;i ret'=0 d ..tr()
	;e  d ..tc()
	q 1
}

ClassMethod ADJTarPriceXMLNew(allstr)
{
	;allstr=locdesc_"^"_stdate_$c(2)_phcode1_"^"_price_$c(1)_phcode2_"^"_price
  s loc="",ret=0
  s incstr1=$p(allstr,$c(2),1)
  s stdate=$p(incstr1,"^",2)
  s locdesc=$p(incstr1,"^",1)
  s incstr=$p(allstr,$c(2),2)
  s curdate=+$h
  s itmnum=$l(incstr,$c(1))
  s ret=0
  d ..tb()
  for t=1:1:itmnum d
   .s strph=""
   .s lret=0
   .s strph=$p(incstr,$c(1),t)
   .s phcode="",price=0
   .s phcode=$p(strph,"^",1)
   .s price=$p(strph,"^",2)
   .s lret=..ADJTarPrice(stdate, phcode, price,locdesc)
   .s ret=ret+lret
   i ret'=0 d ..tr()
   e  d ..tc()
   q ret
}

ClassMethod ADJTarPrice(stdate, phcode, price, locdesc)
{
  s patistype=""
  s stdate=$zdh(stdate,3)
  s curtime=$p($h,",",2)
  s curdate=+$h
  s typerow=""
  f  s typerow=$o(^PAC("ADMREA",typerow)) q:(typerow="")!(patistype'="")  d
    .s type=""
    .s type=$p(^PAC("ADMREA",typerow),"^",2)
    .q:type'["自费"
    .s patistype=typerow
  s tar="0",instar=0,instarsub=0,instarprice=0
  s phcode=$$ALPHAUP^SSUTIL4(phcode)
  f  s tar=$o(^DHCTARI(0,"Code",phcode,tar)) q:(tar="0")!(tar="")  d
    .s tarsub=0
    .s instar=tar
    .f  s tarsub=$o(^DHCTARI(tar,"P",tarsub)) q:(tarsub="0")!(tarsub="")  d
      ..s instarsub=tarsub+1
      ..s instarprice=+$p(^DHCTARI(tar,"P",tarsub),"^",5)
   s altprice=0,intprice=0
   i locdesc["利康药房" s altprice=price,intprice=instarprice
   i locdesc["心理卫生中心药房" s altprice=instarprice,intprice=price
   &sql(insert into dhc_taritemprice(tp_tari_parref,tp_childsub,tp_startdate,TP_PatInsType,TP_AlterPrice1,TP_Price,tp_Updatetime,tp_UpdateDate )
    values(:instar,:instarsub,:stdate,:patistype,:altprice,:intprice,:curtime,:curdate))
  q SQLCODE
}

ClassMethod GetStreamToXML(LStream)
{
	;k ^Huaxi.Test.XML2D
	Set reader = ##class(%XML.Reader).%New()
	set sc=reader.OpenStream(LStream)
	;w reader.Rewind()
	d reader.Correlate("DHCOutPhRecMeg","web.DHCOutPhRecMeg")
	While reader.Next(.obj,.sc) {
		set sc=obj.%Save()
		If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	}
}

ClassMethod UpdateDHCLocDailyXML(adjstream)
{
	Set reader = ##class(%XML.Reader).%New()
	set sc=reader.OpenStream(adjstream)
	s allstr=""
	k obj
	s ret=0
	d reader.Correlate("DHCOutPhRecMeg","web.DHCOutPhRecMeg")
	d ..tb()
	While reader.Next(.obj,.sc)
	 {
		s stdate=obj.Date
		s pharmacy=obj.Pharmacy
		s phinf=obj.PhInformation
		s m=phinf.count()
		for i=1:1:m
		{
			s phcode="",price="",lret=0
			s phcode=phinf.GetAt(i).PhCode
			s qty=phinf.GetAt(i).PhQty
			s lret=..UpdateDHCLocDaily(pharmacy, phcode, qty)
			s ret=ret+lret
			
		}
		
		set sc=obj.%Save()
		If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
		  
	}
	i ret'=0 d ..tr()
	e  d ..tc()
	q ret
}

ClassMethod UpdateDHCLocDailyXMLNew(allstr)
{
	;allstr=Pharmacy_$c(2)_phcode1_"^"_phqty1_$c(1)_phcode2_"^"_phqty2
  ;s allstr="心理卫生中心药房"_$c(2)_"160008Bdh0270^360"_$c(1)_"160008Bdi0270^50"
  //s ^TANG=allstr
 //s allstr="心理卫生中心药房"_$c(2)_"010107Bez1201^1401"_$c(1)_"010109M142704^714"_$c(1)_"010115B372202^24"
  s incstr=$p(allstr,$c(2),2)
  s pharmacy=$p(allstr,$c(2),1)
  s curdate=+$h
  s itmnum=$l(incstr,$c(1))
  s ret=0,t=0
  ;d ..tb()
  for t=1:1:itmnum 
  {
   s strph=""
   s lret=0
   s strph=$p(incstr,$c(1),t)
   s phcode="",qty=0
   s phcode=$p(strph,"^",1)
   s qty=$p(strph,"^",2)
   s lret=##Class(web.DHCOutPhInterFace).UpdateDHCLocDaily(pharmacy, phcode, qty)
   s ret=ret+lret
   }
   ;i ret'=0 d ..tr()
  ; e  d ..tc()   
   q ret
}

ClassMethod UpdateDHCLocDaily(locdesc, phcode, qty)
{
	
  s loc="",inc="",trakqty=0,ldtrow="",latqty="",retsql=0
  s loc=$o(^CTLOC(0,"Desc",locdesc,""))	
  s phcode=$$ALPHAUP^SSUTIL4(phcode)
  s inc=$o(^INCI(0,"Code",phcode,""))
  s cudate=$p($h,",",1)
  i inc="" d
    .&sql(insert into SQLUser.DHCPhUpdate(phup_date,phup_inci_dr,phup_qtylk)
      values(:cudate,:phcode,:qty))
  i inc="" q 0
  s sdate=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inc,cudate+1),-1) 
  i sdate'="" d
	 .s ldtrow=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inc,sdate,""))
	 .s trakqty=+$p(^DHCLOCTOT(ldtrow),"^",4)
  i trakqty=qty q 0
  e  d
    .s newlatqty=qty-trakqty
    .s itmloc=$o(^INCI("IL_LOC",loc,inc,""))
    .i itmloc=""  d
    ..s itmclbrow=..InsertNoClb(inc,loc,"1",newlatqty)
    ..s itmloc=$o(^INCI("IL_LOC",loc,inc,""))
    .e  d
    ..s itmclb=$o(^INCI(inc,"IL",itmloc,"LB",""),-1)
    ..s itmclbrow=inc_"||"_itmloc_"||"_itmclb
    .s itmlocrowid=inc_"||"_itmloc
    .&sql(update sqluser.INC_ItmLoc set INCIL_LogQty=:qty,INCIL_AvailQty=:qty,INCIL_RepQty=:qty where INCIL_RowId=:itmlocrowid)
    .s retmainrow=##class(web.DHCOutPhModCZ).DoDhcTotalMain(inc,loc,newlatqty)
    .&sql(update inc_itmlcbt set INCLB_PhyQty=:qty where inclb_rowid=:itmclbrow)
    .s retsql=##class(web.DHCOutPhModCZ).DoDhcTotalTail(itmclbrow,loc,newlatqty,retmainrow)	
 q 0
}

ClassMethod InsertNoClb(inc, loc, batcode, xq)
{
  s incitmsub=""
  s incitmsub=$o(^INCI(inc,"IL",incitmsub),-1)
  i incitmsub="" s incitmsub=0
  s incitmsub=incitmsub+1
  &sql(insert into SQLUSER.Inc_itmLoc(incil_inci_parref,incil_childsub,incil_ctloc_dr) values(:inc,:incitmsub,:loc))
  s itmbatsub=""
  s itmbatsub=$o(^INCI(inc,"IB",itmbatsub),-1)
  i itmbatsub="" s itmbatsub=0
  &sql(insert into SQLUSER.Inc_itmbat(incib_inci_parref,incib_childsub,incib_no) values(:inc,:itmbatsub,:batcode))
  s litmlocrow=inc_"||"_incitmsub
  s incibrow=inc_"||"_itmbatsub
  &sql(insert into SQLUSER.Inc_itmlcbt(inclb_incil_parref,inclb_childsub,inclb_incib_dr) values(:litmlocrow,1,:incibrow))
  s inclbrowid=litmlocrow_"||"_1
  q inclbrowid
}

ClassMethod tb()
{
   n SQLCODE
   ;TSTART  s SQLCODE=$zu(34)
  q
}

ClassMethod tr()
{
	n SQLCODE
	;TRo  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
	n SQLCODE
    ;TCOMMIT  s SQLCODE=$zu(34)
	q
}

ClassMethod GetMessageToLoc()
{
}

ClassMethod PutMessageToMachineA(DisMachString)
{
  ;DisMachString=pmino_"^"_phl_"^"_prescno_"^"_phpywin_$c(2)_orditm1_"^"_qty1_$c(1)__orditm2_"^"_qty2
  s sysdate="",systime=""
  s sysdate=+$h
  s systime=$p($h,",",2)
  ;s DisMachString="0000196167^2^O08061900625^2"_$c(2)_"1394||19^2"
  s dispstr1="",dispstr2=""
  s dispstr1=$p(DisMachString,$c(2),1)
  s dispstr2=$p(DisMachString,$c(2),2)
  i dispstr2="" q -1
  s pmino="",phl="",prescno="",reqnum="",outnum="",comnum=""
  s pmino=$p(dispstr1,"^",1)
  s phl=$p(dispstr1,"^",2)
  s dispmachine=""
  i $d(^GLobDHCPHLOC(phl)) s dispmachine=$p(^GLobDHCPHLOC(phl),"^",4)
  i dispmachine'="1" q -1
  s pywin=$p(dispstr1,"^",4)
  s prescno=$p(dispstr1,"^",3)
  s reqnum=$p(^DHCPHPYBOX(pywin),"^",3)
  s outnum=$p(^DHCPHPYBOX(pywin),"^",3)
  //s reqnum=$p(dispstr1,"^",4)
  //s outnum=$p(dispstr1,"^",5)
  s comnum=..GetSysCommit(phl)
  s pmidr=""
  s pmidr=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(pmino),""))
  &sql(insert into dhc_phsendmsg(phsm_date,phsm_time,phsm_papmi_dr,phsm_phl_dr,phsm_prescno,phsm_reqnum,phsm_outnum,phsm_ordnum)
    values(:sysdate,:systime,:pmidr,:phl,:prescno,:reqnum,:outnum,:comnum))
  s phsendrow=0,m=0
  s phsendrow=$g(%ROWID)
  i phsendrow=0 q -1
 k mainobj,obj,objsub
 set mainobj=##class(DHCCPH.DITAN.InterFace.Cmd.ACmd.WaWi).%New()
 set obj=##class(DHCCPH.DITAN.InterFace.Cmd.ACmd.ACmd).%New()
 s obj.RequesterNumber=reqnum
 s obj.OutputNumber=outnum
 s obj.OrderNumber=comnum
 s m=$l(dispstr2,$c(1))
 s m=m+1  ;add 
  s adm=""  ;new add  tang 080927
  f i=1:1:m  d
   .s orditm="",ordstr="",qty=0
   .set subobj=##class(DHCCPH.DITAN.InterFace.Cmd.ACmd.Record).%New()
   .s subobj.Code="2"
   .s subobj.Country="086"
   .s subobj.Flag="3"
   .i m=i  d
    ..s subobj.BarCode="9999999"
    ..s subobj.Quantity=0
   .e  d
   ..s ordstr=$p(dispstr2,$c(1),i)
   ..s orditm=$p(ordstr,"^",1)
   ..s qty=$p(ordstr,"^",2)
   ..s ord="",itm=""
   ..s ord=$p(orditm,"||",1)
   ..s itm=$p(orditm,"||",2)
   ..s adm=+$p(^OEORD(ord),"^",1)  ;new add  tang 080927
   ..s itmmast=""
   ..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2) ;arc_itmmast
   ..s inci="",itmmastid="",itmmastver="",phuomid="",basuom=""
   ..s itmmastid=$p(itmmast,"||",1)
   ..s itmmastver=$p(itmmast,"||",2)
   ..s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
   ..q:inci=""
   ..s incbarcode="",puruom=""
   ..s incbarcode=$p(^INCI(inci,3),"^",9)
   ..s phuomid=+$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
   ..s puruom=+$p(^INCI(inci,3),"^",6)
   ..s basuom=+$p(^INCI(inci,1),"^",10)
   ..s basqty=0,confact=1
   ..s confact=##class(web.DHCOutPhReturn).GetConFac(phuomid,basuom)
   ..s basqty=qty*confact
   ..s confact2=1
   ..s confact2=##class(web.DHCOutPhReturn).GetConFac(puruom,basuom)
   ..s purqty=0
   ..s purqty=basqty/confact2
   ..s subobj.BarCode=incbarcode
   ..s subobj.Quantity=purqty
   ..&sql(insert into DHC_PHSENDMSGITM(phsmi_phsm_parref,phsmi_childsub,phsmi_barcode,phsmi_qty,phsmi_orditm_dr)
      values(:phsendrow,:m,:incbarcode,:purqty,:orditm))
   ..;&sql(update dhc_phsend set phs_qty=phs_qty-:basqty where phs_inci_dr=:inci)
  .d obj.Record.Insert(subobj)
 s mainobj.ACmd=obj
 s sendsum=0  ;new add  tang 080927
 i '$d(^TANGTMPSend)  d  ;new add  tang 080927
    .s sendsum=1  ;new add  tang 080927
    .s ^TANGTMPSend=1  ;new add  tang 080927
 e  d  ;new add  tang 080927
    .s sendsum=$g(^TANGTMPSend)+1 ;new add  tang 080927
    .s ^TANGTMPSend=$g(^TANGTMPSend)+1 ;new add  tang 080927
 
 set sc=mainobj.XMLExportToString(.result)
 s ^zTMPPHCSEND(adm,sendsum)=$h_"^"_result  ;new add  tang 080927
 s soap=##class(PackPharmacyToMa.DHCCPHOUTSoap).%New()
 d soap.Wawi(result)

 quit result
}

ClassMethod PutMessageToMachineB(DisMachString)
{
  ;DisMachString=barcode
  s sysdate="",systime=""
  s sysdate=+$h
  s pmino="",phl="",prescno="",reqnum="",outnum="",barcode=""
  s reqnum="1"
  s barcode=DisMachString
 k mainobj,obj,objsub
 set mainobj=##class(DHCCPH.DITAN.InterFace.Cmd.BCmd.WaWi).%New()
 set obj=##class(DHCCPH.DITAN.InterFace.Cmd.BCmd.BCmd).%New()
 s obj.RequesterNumber=reqnum
 s obj.Country="086"
 s obj.Code="2"
 s obj.BarCode=barcode
 s mainobj.BCmd=obj
 set sc=mainobj.XMLExportToString(.result)
 s soap=##class(PackPharmacyToMa.DHCCPHOUTSoap).%New()
 d soap.Wawi(result)

 quit result
}

ClassMethod GetSysCommit(phl)
{
	s mmit=""
	i '$d(^DHCTMPPharCommit(+$h,phl))  d
	  .s $p(^DHCTMPPharCommit(+$h,phl),"^",1)=1
	  .s mmit=1
	e  d
	  .s mmit=$p(^DHCTMPPharCommit(+$h,phl),"^",1)+1
	  .s $p(^DHCTMPPharCommit(+$h,phl),"^",1)=mmit
	 q mmit
}

ClassMethod GetXMLFrMach(adj As %GlobalCharacterStream)
{
	s allstr=""
	s ret=0
 	d adj.Rewind()
 	Set reader = ##class(%XML.Reader).%New()
	set sc=reader.OpenStream(adj)
	d reader.Correlate("WaWi","DHCCPM.Msg.Reponse.DITAN.WaWi")
	;d ..tb()
	While reader.Next(.mainobj,.sc)
	 {
		s wawiobj=mainobj.AMsg
		s reqnum=wawiobj.RequesterNumber
        s outnum=wawiobj.OutputNumber
        s comnum=wawiobj.OrderNumber
        
		s warecord=wawiobj.Record
		s m=warecord.Count()
		for i=1:1:m 
		{
			s phcode="",price="",lret=0
			s phcode=warecord.GetAt(i).PhCode
			s price=warecord.GetAt(i).Price
			s lret=..ADJTarPrice(stdate, phcode, price)
			s ret=ret+lret
			
		}
		
		set sc=obj.%Save()
		If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
		  
	}
	;i ret'=0 d ..tr()
	;e  d ..tc()
	q 1
}

//web.DHCOutPhInterFace.ReceiveMsg("<WaWi><IMsg RequesterNumber=""999"" OrderNumber=""10052"" DeliveryNumber=""Wareneingang"" Country=""86"" Code=""2"" BarCode=""6905863718106"" Quantity=""1"" Date=""1899-12-30"" State=""0""/></WaWi>")

ClassMethod ReceiveMsg(StrXml)
{
 
   set ^zWBtemp(^j)=StrXml
   Set ^j=^j+1
  ;s StrXml="<WaWi><PMsg RequesterNumber='999' Country='086' Code='0' Barcode='543216789012'/></WaWi>"
  ;s StrXml="<WaWi><IMsg RequesterNumber='999' OrderNumber='1234' DeliveryNumber='4711' Country='086' Code='0' Barcode='5432167890123' Quantity='1' Date='0005-05-03' State='0'/></WaWi>"
  ;i StrXml="" q -1
  ;s StrXml="<WaWi><IMsg RequesterNumber=""123"" OrderNumber=""456"" DeliveryNumber="""" Country=""86"" Code=""0"" BarCode="""" Quantity=""1"" Date=""1899-12-30"" State=""0""/></WaWi>" 
  ; s $ZT="ERROR^DHCINReceiveMsgERR"
  ;s StrXml="<WaWi><IMsg RequesterNumber='999' OrderNumber='10019' DeliveryNumber='tttt' Country='0' Code='0' BarCode='' Quantity='0' Date='2008-07-16' State='2'/></WaWi>"
  i '$d(^TANGD) s ^TANGD=0
  s ^TANGD= $g(^TANGD)+1
  s ph=$g(^TANGD)
  ;s systime=$p($h,",",2)
  s ^TANGHALL(ph)=StrXml
  s CheckMsg=..CheckMsgXML(StrXml)
  s retxml="",retstr="",ret=""
  i CheckMsg="IMsg"  d
    .;s ^TANGHH(systime)=StrXml
    .s recstr=..JXIMsg(StrXml) 
    .s retxml=..PutMsgICmd(recstr)
    .s ^TANGHPut(ph)=retxml
    .s soap=##class(PackPharmacyToMa.DHCCPHOUTSoap).%New()
    .d soap.Wawi(retxml)
   e  i CheckMsg="AMsg"  d
    .s recstr=..JXAMsg(StrXml)
    .d ..UpdateLocMachTable(recstr)
   e  i CheckMsg="BMsg"  d
    .s recstr=..JXBMsg(StrXml)
    .s ret=..ModifyPhsend(recstr)
   e  i CheckMsg="PMsg"  d
    .
    .s recstr=..JXPMsg(StrXml)
    .s retxml=..PutMsgPCmd(recstr)
    .s ^TANGHPCmdPut(ph)=recstr
    .s soap=##class(PackPharmacyToMa.DHCCPHOUTSoap).%New()
    .d soap.Wawi(retxml)
   e  i CheckMsg="KMsg"  d
     .s recstr=..JXKMsg(StrXml)
     .i recstr'=""  d
     ..s retxml=..PutMsgKCmd(recstr)
     ..s soap=##class(PackPharmacyToMa.DHCCPHOUTSoap).%New()
     ..d soap.Wawi(retxml)
 
   e  q CheckMsg
  q retxml
}

ClassMethod JXIMsg(StrXml)
{
	;d StrXml.Rewind()
    s recstr="",chrkok=""
 	Set reader = ##class(%XML.Reader).%New()
    set sc=reader.OpenString(StrXml)
	d reader.Correlate("WaWi","DHCCPH.DITAN.InterFace.Msg.IMsg.WaWi")
	While reader.Next(.mainobj,.sc){
        s wawiobj=mainobj.IMsg
		s reqnum=wawiobj.RequesterNumber
        s ordnum=wawiobj.OrderNumber
        s delivernum=wawiobj.DeliveryNumber
        s country=wawiobj.Country
        s code=wawiobj.Code
        s barcode=wawiobj.BarCode
        s qty=wawiobj.Quantity
        s state=wawiobj.State
        ;i state>2 s chrkok="-1"
        ;set sc=mainobj.%Save()
        s recstr=reqnum_"^"_ordnum_"^"_country_"^"_code_"^"_barcode_"^"_qty_"^"_state
       
	 }
	;i chrkok="-1" q ""
	 q recstr
}

ClassMethod JXAMsg(StrXml)
{
    s ret=""
 	Set reader = ##class(%XML.Reader).%New()
    set sc=reader.OpenString(StrXml)
	d reader.Correlate("WaWi","DHCCPH.DITAN.InterFace.Msg.AMsg.WaWi")
   	While reader.Next(.mainobj,.sc){
	    s wawiobj=mainobj.AMsg
		s reqnum=wawiobj.RequesterNumber
        s outnum=wawiobj.OutputNumber
        s ordnum=wawiobj.OrderNumber
		s warecord=wawiobj.Record
		s ordstate=wawiobj.OrderState
		s m=warecord.Count()
		s ret=reqnum_"^"_outnum_"^"_ordnum_"^"_ordstate
		s lret=""
		for i=1:1:m 
		{
			s barcode="",qty=0
			s barcode=warecord.GetAt(i).BarCode
			s qty=warecord.GetAt(i).Quantity
			i lret=""  d
			 .s lret=barcode_"^"_qty
			e  d
			 .s lret=lret_$c(1)_barcode_"^"_qty
			
		}
		
		s ret=ret_$c(2)_lret
		;set sc=obj.%Save()
		
		}
	q ret
}

ClassMethod JXBMsg(StrXml)
{
 ;BMsg RequesterNumber="1" Country="0" Code="0" Barcode="17" Quantity="0"/>
 ;s StrXml="<WaWi><BMsg RequesterNumber='1' Country='86' Code='0' BarCode='6932662400031' Quantity='0'/></WaWi>"
    s recstr=""
 	Set reader = ##class(%XML.Reader).%New()
    set sc=reader.OpenString(StrXml)
	d reader.Correlate("WaWi","DHCCPH.DITAN.InterFace.Msg.BMsg.WaWi")
	While reader.Next(.mainobj,.sc){
        s wawiobj=mainobj.BMsg
		s reqnum=wawiobj.RequesterNumber
        ;s ordnum=wawiobj.OrderNumber
        ;s delivernum=wawiobj.DeliveryNumber
        s country=wawiobj.Country
        s code=wawiobj.Code
        s barcode=wawiobj.BarCode
        s qty=wawiobj.Quantity
        ;s state=wawiobj.State
        ;set sc=mainobj.%Save()
        s recstr=reqnum_"^"_barcode_"^"_qty
	 }
	 q recstr
}

ClassMethod JXKMsg(StrXml)
{
    s ret=""
 	Set reader = ##class(%XML.Reader).%New()
    set sc=reader.OpenString(StrXml)
	d reader.Correlate("WaWi","DHCCPH.DITAN.InterFace.Msg.KMsg.WaWi")
   	While reader.Next(.mainobj,.sc){
	    s wawiobj=mainobj.KMsg
	   
		s reqnum=wawiobj.RequesterNumber
        s outnum=wawiobj.StartCountry
        s ordnum=wawiobj.StartCode
        
        s startbarcode=wawiobj.StartBarCode
		s warecord=wawiobj.Record
		
		s m=warecord.Count()
		s lret="",firstbarcode=""
		for i=1:1:m 
		{
			s barcode="",qty=0
			s barcode=warecord.GetAt(i).BarCode
			s qty=warecord.GetAt(i).Quantity
			q:barcode=""
            s sysdate=+$h,inc=""
            s inc=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(barcode),""))
            s puruom="",basuom="",confac=1
            s puruom=$p(^INCI(inc,3),"^",6)
            s basuom=$p(^INCI(inc,1),"^",10)
            s confac=##class(web.DHCOutPhReturn).GetConFac(puruom,basuom)
            s basqty=qty*confac
            i inc'=""  d
	         .s phsendrow=""
	         .s phsendrow=$o(^DHCPHSENDi("INCI",inc,"")) 
  	         .&sql(update dhc_phsend set phs_qty=:basqty where phs_rowid=:phsendrow)
			i i=10  d
			  .s firstbarcode=barcode
			i lret=""  d
			 .s lret=barcode_"^"_qty
			e  d
			 .s lret=lret_$c(1)_barcode_"^"_qty
			
		}
		
		}
	q firstbarcode
}

ClassMethod JXPMsg(StrXml)
{
 ;BMsg RequesterNumber="1" Country="0" Code="0" Barcode="17" Quantity="0"/>
    s recstr=""
 	Set reader = ##class(%XML.Reader).%New()
    set sc=reader.OpenString(StrXml)
	d reader.Correlate("WaWi","DHCCPH.DITAN.InterFace.Msg.PMsg.WaWi")
	While reader.Next(.mainobj,.sc){
        s wawiobj=mainobj.PMsg
		s reqnum=wawiobj.RequesterNumber
        s country=wawiobj.Country
        s code=wawiobj.Code
        s barcode=wawiobj.BarCode
        ;set sc=mainobj.%Save()
        s recstr=reqnum_"^"_country_"^"_code_"^"_barcode

	 }
	 q recstr
}

ClassMethod ModifyPhsend(recstr)
{
  s barcode=$p(recstr,"^",2)
  i barcode="" q -1
  s qty=$p(recstr,"^",3)
  s sysdate=+$h,inc=""
  s inc=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(barcode),""))
  s puruom="",basuom="",confac=1
  s puruom=$p(^INCI(inc,3),"^",6)
  s basuom=$p(^INCI(inc,1),"^",10)
  s confac=##class(web.DHCOutPhReturn).GetConFac(puruom,basuom)
  s basqty=qty*confac
  i inc'=""  d
	  .s phsendrow=""
	  .s phsendrow=$o(^DHCPHSENDi("INCI",inc,"")) 
	  .&sql(update dhc_phsend set phs_qty=:basqty where phs_rowid=:phsendrow)
 q SQLCODE
}

ClassMethod PutMsgKCmd(kstr)
{
	
 k mainobj,obj
 set mainobj=##class(DHCCPH.DITAN.InterFace.Cmd.KCmd.WaWi).%New()
 set obj=##class(DHCCPH.DITAN.InterFace.Cmd.KCmd.KCmd).%New()
 s obj.RequesterNumber="1"
 s obj.StartCountry="86"
 s obj.StartCode=2
 s obj.StartBarCode=kstr
 s obj.Count=10
 s mainobj.KCmd=obj
 set sc=mainobj.XMLExportToString(.result)
 quit result
}

ClassMethod UpdateLocMachTable(upstr)
{
 ;s upstr="3^3^15^4"_$c(2)_"6926197060051^1"_$c(1)_"9999999^1"
 s fstr=$p(upstr,$c(2),1)
 s chstr=$p(upstr,$c(2),2)
 s reqnum=$p(fstr,"^",1)
 s outnum=$p(fstr,"^",2)
 s ordnum=$p(fstr,"^",3)
 s status=$p(fstr,"^",4)
 s itmnum=$l(chstr,$c(1))
 i status="4"  d
   .;i $d(^TANGHOU) d
   .;.s ^TANGPO($g(^TANGHOU))=itmnum
   .;.s ^TANGHOU=$g(^TANGHOU)+1
   .;e  d
     .;.s ^TANGHOU=1
   .for t=1:1:itmnum d
   ..s phstr="",barcode="",qty=0,retval=""
   ..s phstr=$p(chstr,$c(1),t)
   ..s barcode=$p(phstr,"^",1)
   ..s qty=$p(phstr,"^",2)
   ..s retval=..UpdateSend(reqnum,ordnum,barcode,qty)
   ..
   
   
 q
}

ClassMethod UpdateSend(reqnum, ordnum, barcode, qty)
{
	s sysdate=+$h,inc=""
	s inc=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(barcode),""))
	i inc="" q 0
	s puruom="",basuom="",confac=1
    s puruom=$p(^INCI(inc,3),"^",6)
    s basuom=$p(^INCI(inc,1),"^",10)
    s confac=##class(web.DHCOutPhReturn).GetConFac(puruom,basuom)
    s basqty=qty*confac
	;f  s msgrow=$o(^DHCPHSMi("COMMIT",ordnum,sysdate,msgrow)) q:msgrow=""  d
	i inc'=""  d
	  .s phsendrow=""
	  .s phsendrow=$o(^DHCPHSENDi("INCI",inc,"")) 
	  .b
	  .&sql(update dhc_phsend set phs_qty=phs_qty-:basqty where phs_rowid=:phsendrow)
 q SQLCODE
}

ClassMethod PutMsgBCmd(str)
{
 ;str=reqnum_"^"_ordnum_"^"_country_"^"_code_"^"_barcode_"^"_qty	
 s reqnum=$p(str,"^",1)
 s ordnum=$p(str,"^",2)
 s country=$p(str,"^",3)
 s code=$p(str,"^",4)
 s barcode=$p(str,"^",5)
 s qty=$p(str,"^",6)
 
 k mainobj,obj
 set mainobj=##class(DHCCPH.DITAN.InterFace.Cmd.BCmd.WaWi).%New()
 set obj=##class(DHCCPH.DITAN.InterFace.Cmd.BCmd.BCmd).%New()
 s obj.RequesterNumber=reqnum
 s obj.OrderNumber=ordnum
 s obj.Country=country
 s obj.Code=2
 s obj.BarCode=barcode
 s obj.Quantity=qty
 s obj.Date="2008-08-08"
 s obj.State="1"
 s obj.Text="abcde"
 s mainobj.BCmd=obj
 set sc=mainobj.XMLExportToString(.result)
 quit result
}

ClassMethod PutMsgICmd(str)
{
 ;str=reqnum_"^"_ordnum_"^"_country_"^"_code_"^"_barcode_"^"_qty_"^"_state	
 s reqnum=$p(str,"^",1)
 s ordnum=$p(str,"^",2)
 s country=$p(str,"^",3)
 s code=$p(str,"^",4)
 s barcode=$p(str,"^",5)
 s qty=$p(str,"^",6)
 s state=$p(str,"^",7)
 ;s ^zWB(99)=state
 i barcode="-1" q -1
 s phdesc="",sucode=""
 s inc=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(barcode),""))
 s puruom="",basuom="",basqty=0,confac=1
 i inc'=""  d
   .s puruom=+$p(^INCI(inc,3),"^",6)
   .s basuom=+$p(^INCI(inc,1),"^",10)
   .s confac=##class(web.DHCOutPhReturn).GetConFac(puruom,basuom)
   .s basqty=qty*confac
   .s phdesc=$p(^INCI(inc,1),"^",2)
   .s loc=..GetLocFrMachine()
   .s retchkc=..CheckKCFrBarCode(inc,basqty,loc)
   .i retchkc="0"  d
    ..s sucode=1
   .e  d
    ..s sucode=0
 s retsend=""
 i phdesc=""  s phdesc="该药品不存在"
 i (inc'="")&(state="6")  d
 .s retsend=..InsertPhSend(inc,basqty,loc)
 i state="6" q "入药成功"
 i state="7" q "入药失败"
 
 k mainobj,obj
 set mainobj=##class(DHCCPH.DITAN.InterFace.Cmd.ICmd.WaWi).%New()
 set obj=##class(DHCCPH.DITAN.InterFace.Cmd.ICmd.ICmd).%New()
 s obj.RequesterNumber=reqnum
 s obj.OrderNumber=ordnum
 s obj.Country=country
 s obj.Code=2
 s obj.BarCode=barcode
 s obj.Quantity=1
 s obj.Date="2010-08-08"
 s obj.Text=""
 i sucode=1  d
  .s obj.State="0"
 e  d
  .s obj.State="1"
 s mainobj.ICmd=obj
 set sc=mainobj.XMLExportToString(.result)
 quit result
}

ClassMethod InsertPhSend(inc, basqty, loc)
{
 s phsendrow=""
 s phsendrow=$o(^DHCPHSENDi("INCI",inc,""))
 i phsendrow=""  d
   .&sql(insert into dhc_phsend(phs_inci_dr,phs_ctloc_dr,phs_sendflag,phs_qty)
     values(:inc,:loc,'1',:basqty))
 e  d
   .&sql(update dhc_phsend set phs_qty=phs_qty+:basqty where phs_rowid=:phsendrow)
  q SQLCODE
}

ClassMethod CheckKCFrBarCode(inc, basqty, ctloc)
{
  s kcqty=0,ret=0
  s kcqty=##class(web.DHCOutPhDisp).GetIncLocTotal(inc,ctloc)
  i basqty>kcqty  d
   .s ret=-1
  e  d
   .s ret=0	
  q ret
}

ClassMethod GetLocFrMachine()
{
  s loc="",phl=""
  f  s phl=$o(^DHCPHLOC(phl)) q:(phl="")!(loc'="")  d
    .s tomachine=""
    .s tomachine=$p(^GLobDHCPHLOC(phl),"^",4)
    .q:tomachine'="1"
    .s loc=+$p(^DHCPHLOC(phl),"^",1)
  q loc
}

ClassMethod PutMsgPCmd(str)
{
 ;str=reqnum_"^"_country_"^"_code_"^"_barcode	
 s reqnum=$p(str,"^",1)
 ;s ordnum=$p(str,"^",2)
 s country=$p(str,"^",2)
 s code=$p(str,"^",3)
 s barcode=$p(str,"^",4)
 ;s qty=$p(str,"^",6)
 s inc=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(barcode),""))
 s phdesc=""
 i inc="" q -1
 
 s phdesc=$p(^INCI(inc,1),"^",2)
 s puruom="",puruomdesc=""
 s puruom=+$p(^INCI(inc,3),"^",6)
 s puruomdesc=$p(^CT("UOM",puruom),"^",2)
 

 k mainobj,obj
 set mainobj=##class(DHCCPH.DITAN.InterFace.Cmd.PCmd.WaWi).%New()
 set obj=##class(DHCCPH.DITAN.InterFace.Cmd.PCmd.PCmd).%New()
 s obj.RequesterNumber=reqnum
 s obj.Country=country
 s obj.Code=2
 s obj.BarCode=barcode
 s obj.ItemName=phdesc
 s obj.ItemTyp="0"
 s obj.ItemUnit=puruomdesc
 s obj.Date="2011-08-08"
 s mainobj.PCmd=obj
 set sc=mainobj.XMLExportToString(.result)
 quit result
}

ClassMethod CheckMsgXML(StrXml)
{
  s $ZTrap="ERROR"
 ;s StrXml=##Class(web.DHCEQCommon).Replace(StrXml,"""""","""-1""")
 s pInput=##class(%GlobalCharacterStream).%New()
 d pInput.Write(StrXml)
 
 
 s tStatus = ##class(%XML.XPATH.Document).CreateFromStream(pInput, .tDocument)
 Set tStatus = tDocument.EvaluateExpression("/WaWi/*", "name()", .tResults)
 s retstr= tResults.GetAt(1).Value	
 q retstr
ERROR
 set $ZTrap=""
 set retstr="出错"
 Quit retstr
}

}
