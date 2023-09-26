Class web.DHCOutPhNewAddCommit Extends %Library.RegisteredObject [ Not Abstract, ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetCardTypeDef()
{
	s myTypeID=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myDataFlag=0
	s myIdx=0
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myval=myTypeID
	.s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.i myDefault="Y" d
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s myFindFlag=1
	.i +myDataFlag  d
	..s myFindFlag=myPEObj.FindCardTypeByDR(myTypeID)
	..i myPEObj.DefaultCardTypeDR=myTypeID  d
	...s mySelFlag=1
	.q:(+myFindFlag=0)
	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	q 0
}

ClassMethod QueryPhNoteClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryPhNoteExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryPhNoteExecute(ByRef QHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp)
	s ind=1
	s phsrow=""
	f  s phsrow=$o(^DHCPHSEND(phsrow)) q:phsrow=""  d
	  .s loc="",locdesc="",inc="",incdesc="",sendflag=""
	  .s loc=+$p(^DHCPHSEND(phsrow),"^",1)
	  .s inc=+$p(^DHCPHSEND(phsrow),"^",2)
	  .s locdesc=$p(^CTLOC(loc),"^",2)
	  .i locdesc["-" s locdesc=$p(locdesc,"-",2)
	  .s incdesc=$p(^INCI(inc,1),"^",2)
	  .s sendflag=$p(^DHCPHSEND(phsrow),"^",3)
	  .i sendflag="1"  d
	  ..s sendflag="是"
	  .e  d
	  ..s sendflag="否"
	  .s Data=$lb(incdesc,inc,sendflag,locdesc,phsrow)
      .S ^CacheTemp(repid,ind)=Data	
      .S ind=ind+1
 S QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryPhNoteFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPhNoteExecute ]
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

Query QueryPhNote() As %Query(ROWSPEC = "TPhDesc:%String,TInc:%String,药房ID:%String")
{
}

ClassMethod GetPatNoteInf(ctloc, pmino)
{
  s currdate=+$h
  s xh=0
  i '$d(^DHCLOCWINNUM(+$h,ctloc))  d
    .s xh=1
  e  d
    .s xh=$g(^DHCLOCWINNUM(+$h,ctloc))	 
  s pmidr="",patname=""
  s pmidr=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(pmino),""))
  i pmidr="" q -1
  s phl=""
  s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
  i phl="" q -1
  s retch=0
  s retch=..CheckNote(currdate,pmidr,phl)
  i retch'=0 q -2
  s prt="0",phw="",phwdesc=""
  f  s prt=$o(^DHCINVPRT(0,"DatePAPMI",currdate,pmidr,prt)) q:(prt="")!(phw'="")  d
    .s pha=""
    .f  s pha=$o(^DHCPHARi("PRT",prt,pha)) q:(pha="")!(phw'="")  d
      ..s phaloc=""
      ..s phaloc=+$p(^DHCPHARW(pha),"^",3)
      ..q:phaloc'=phl
      ..s phw=+$p(^DHCPHARW(pha),"^",4)
  i phw="" q -1
  s phwdesc=$p(^DHCPHWIN(phw),"^",1)
  s patname=$p(^PAPER(pmidr,"ALL"),"^",1) 
  s ret=patname_"^"_phwdesc_"^"_xh_"^"_pmidr_"^"_phw 
  q ret
}

ClassMethod CheckNote(dat, pmi, phl)
{
  s phnot="",retval=0
  f  s phnot=$o(^DHCPHNOTEi("DATE",dat,pmi,phl,phnot)) q:(phnot="")!(retval'=0)  d
    .s canc=""
    .s canc=$p(^DHCPHNOTE(phnot),"^",5)
    .q:canc="1"
    .s retval=retval+1
  q retval
}

ClassMethod GetNoteCode(dat, pmi, phl)
{
  s phnot="",retval=0
  f  s phnot=$o(^DHCPHNOTEi("DATE",dat,pmi,phl,phnot)) q:(phnot="")!(retval'=0)  d
    .s canc=""
    .s canc=$p(^DHCPHNOTE(phnot),"^",5)
    .q:canc="1"
    .s retval=$p(^DHCPHNOTE(phnot),"^",4)
  q retval
}

ClassMethod InsertUnNoteCode(phl, pmino)
{
	s sysdate=+$h,unnoterow="",ret=0
	s loc=+$p(^DHCPHLOC(phl),"^",1)
	i '$d(^DHCDateUnNoteDT(sysdate,loc,pmino))  d
	 .s ^DHCDateUnNoteDT(sysdate,loc,pmino)="no"
	q 0
}

ClassMethod GetNoteRow(dat, pmi, phl)
{
  s phnot="",retval=0
  f  s phnot=$o(^DHCPHNOTEi("DATE",dat,pmi,phl,phnot)) q:(phnot="")!(retval'=0)  d
    .s canc=""
    .s canc=$p(^DHCPHNOTE(phnot),"^",5)
    .q:canc="1"
    .s retval=phnot
  q retval
}

ClassMethod InsertPhNote(pmi, ctloc, phw, xh)
{
  s currdate="",currtime="",phl=""
  s currdate=+$h
  s currtime=$p($h,",",2)
  s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
  &sql(insert into sqluser.DHC_PhNote(phn_papmi_dr,phn_phl_dr,phn_phw_dr,phn_serialno,phn_date,phn_time)
   values(:pmi,:phl,:phw,:xh,:currdate,:currtime))
  i SQLCODE=0  d
   .i '$d(^DHCLOCWINNUM(+$h,ctloc))  d
    ..s ^DHCLOCWINNUM(+$h,ctloc)=2
   .e  d
    ..s ^DHCLOCWINNUM(+$h,ctloc)=$g(^DHCLOCWINNUM(+$h,ctloc))+1
  q SQLCODE
}

ClassMethod ChDispMachine(loc, orditm, qty)
{
 s ord=$p(orditm,"||",1)
 s itm=$p(orditm,"||",2)
 s itmmast=""
 s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast
 s phuomid="",phuomdesc="",itmmastid="",itmmastver=""
 s itmmastid=$p(itmmast,"||",1)
 s itmmastver=$p(itmmast,"||",2)
 s phuomid=+$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
 s phuomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
 s inci=""
 s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
 s basuom=""
 s basuom=+$p(^INCI(inci,1),"^",10)
 s phl=""
 s phl=$o(^DHCPHLOCi("LOC",loc,""))
 i phl="" q 0
 s dispmachine=""
 s dispmachine=$p(^GLobDHCPHLOC(phl),"^",4)
 i dispmachine'="1" q 0
 s fact=1
 s fact=##class(web.DHCOutPhReturn).GetConFac(phuomid,basuom)
 s basqty=0
 s basqty=qty*fact	  
 s phsrow="",retsend=0
 f  s phsrow=$o(^DHCPHSENDi("INCI",inci,phsrow)) q:phsrow=""  d
   .s phsloc="",phsend="",phsqty=0
   .s phsloc=+$p(^DHCPHSEND(phsrow),"^",1)
   .q:phsloc'=loc
   .s phsend=$p(^DHCPHSEND(phsrow),"^",3)
   .q:phsend'="1"
   .s phsqty=+$p(^DHCPHSEND(phsrow),"^",6)	
   .i phsqty'<basqty s retsend=phsend
 q retsend
}

ClassMethod GetSysDateTime()
{
	s sysdate="",systime=""
	s sysdate=+$h
	s systime=$p($h,",",2)
	s sysdate=$zd(sysdate,3)
	s systime=$zt(systime,1)
	s ret=""
	s ret=sysdate_"^"_systime
	q ret
}

ClassMethod UpdatePhNote(notrow)
{
 s $p(^DHCPHNOTE(notrow),"^",5)="1"
 q 0
}

ClassMethod GetScreenPath(phl)
{
	i '$d(^GLobDHCPHLOC(phl)) q -1
	i $p(^GLobDHCPHLOC(phl),"^",5)'="1" q -1
	s scpath=""
	s scpath=$p(^GLobDHCPHLOC(phl),"^",6)
    q scpath
}

ClassMethod UpSendDate(ctloc)
{
  s phs="",t=0
  s ret=""
  &sql(update sqluser.dhc_phsend set phs_qty=0)
  s retxml=##class(web.DHCOutPhInterFace).PutMsgKCmd("")
  s soap=##class(PackPharmacyToMa.DHCCPHOUTSoap).%New()
  d soap.Wawi(retxml)
 
  /*
  k ^TANGF
  f  s phs=$o(^DHCPHSEND(phs)) q:phs=""  d
    .s inc="",loc="",send=""
    .s loc=+$p(^DHCPHSEND(phs),"^",1)
    .s inc=+$p(^DHCPHSEND(phs),"^",2)
    .s send=$p(^DHCPHSEND(phs),"^",3)
    .q:loc'=ctloc
    .q:send'="1"
    .s incbarcode=""
    .s t=t+1
    .s incbarcode=$p(^INCI(inc,3),"^",9)
    .s ret=##class(web.DHCOutPhInterFace).PutMessageToMachineB(incbarcode)
    .s ^TANGF(t)=ret
    */
  q
}

ClassMethod UpdateWinStatus(phl, win, type)
{
	s phwprow=""
	s phwprow=$o(^DHCPHWPi("WINDOW",phl,win,""))
	i phwprow="" q -1
	s doflag=""
	s $p(^DHCPHWP(phwprow),"^",1)=type
	s userid=%session.Get("LOGON.USERID")
	s sysdate=+$h
	s systime=$p($h,",",2)
	/*
	&sql(insert into sqluser.DHC_PHWPTAIL(phwpt_phw_dr,phwpt_user_dr,phwpt_phl_dr,phwpt_date,phwpt_time,
	phwpt_opflag) values(:win,:userid,:phl,:sysdate,:systime,:type))
	*/
 q 0
}

ClassMethod GetWinStatus(phl, win)
{
	s phwprow=""
	s phwprow=$o(^DHCPHWPi("WINDOW",phl,win,""))
	i phwprow="" q 0
	s doflag=""
	s doflag=$p($g(^DHCPHWP(phwprow)),"^",1)
	i doflag="" q 0 
 q doflag
}

ClassMethod OtherLocDisp(GPhl, otherloc, prt, prescno)
{
	s currloc="",otherphl=""
	s currloc=+$p(^DHCPHLOC(GPhl),"^",1)
	s otherphl=$o(^DHCPHLOCi("LOC",otherloc,""))
	i otherphl=""  q -1
	s uprecloc=0,uppharwin=0
	TSTART
	
	s uprecloc=##class(web.DHCOutPhNewAddCommit).UpdateItmRecDep(prt,prescno,currloc,otherloc)
	i uprecloc'=0 TRo
	i uprecloc'=0 q -1
	s phw=##class(web.DHCOutPhNewAddCommit).GetOKWinFrPHL(GPhl)
	s uppharwin=##class(web.DHCOutPhNewAddCommit).UpdatePharwin(prt,prescno,GPhl,otherphl,phw)
	i uppharwin'=0 TRo
	i uppharwin'=0 q -1
	s chkc=0
	s chkc=##class(web.DHCOutPhDisp).CheckPhKC(currloc,prt,prescno)
	i chkc'=0  TRo
	i chkc'=0  q -2
	
	TCommit

	q 0
}

ClassMethod UpdateItmRecDep(prt, yprescno, curloc, otherloc)
{
	 n (prt, yprescno, curloc, otherloc)
	 
	  s bci="0",upsuess=0
	  f  s bci=$o(^DHCBCI(0,"INV",prt,bci)) q:(bci="")!(bci="0")!(upsuess'=0)  d
	    .s patbill=""
	    .s patbill=+$p(^DHCBCI(bci),"^",2)
	    .s patbillsub="0"
	    .s t=0
	    .f  s patbillsub=$o(^DHCPB(patbill,"O",patbillsub)) q:(patbillsub="")!(patbillsub="")!(upsuess'=0)  d
	      ..s orditm="",ord="",itm="",dispflag="",tprescno=""
	      ..s orditm=$p(^DHCPB(patbill,"O",patbillsub),"^",4)
	      ..s ord=$p(orditm,"||",1),itm=$p(orditm,"||",2)
	      ..s recplocdr=""
	      ..s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	      ..q:recplocdr=""
	      ..q:recplocdr'=otherloc
	      ..s dispflag="" 
	      ..s dispflag=$p($g(^OEORD(ord,"I",itm,6)),"^",7)
	      ..;q:dispflag="1"
	      ..;s dispflag=##class(web.DHCOutPhDisp).GetDHCOEDisp(orditm,"W")
	      ..;q:dispflag="0"
	      ..s tprescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
	      ..q:tprescno=""
	      ..q:tprescno'=yprescno
	      ..&sql(update sqluser.oe_orditem set oeori_recdep_dr=:curloc where oeori_rowid=:orditm)
	      ..i SQLCODE'=0 s upsuess=upsuess+1
	   q upsuess
}

ClassMethod UpdatePharwin(prt, prescno, phl, otherphl, okphw)
{
	n (prt, prescno, phl, otherphl, okphw)
	s pha="",upsuess=0
	f  s pha=$o(^DHCPHARi("PRT",prt,pha)) q:(pha="")!(upsuess'=0)  d
	.s phapresc=""
	.s phapresc=$p(^DHCPHARW(pha),"^",16)
	.q:phapresc'=prescno
	.&sql(update sqluser.DHC_Pharwin set pha_phl_dr=:phl,pha_phw_dr=:okphw where pha_rowid=:pha)
	.i SQLCODE'=0 s upsuess=upsuess+1
 q upsuess
}

ClassMethod CFDispPresc(GPhl, win, otherwin, prt, prescno, orditminf, dfflag)
{
	s otherphl="",sysdate=+$h,systime=$p($h,",",2),otherphw=""
	;s otherphl=$o(^DHCPHLOCi("LOC",otherloc,""))
	s loc=+$p(^DHCPHLOC(GPhl),"^",1)
	s allkc=0
	;s allkc=##class(web.DHCOutPhNewAddCommit).CheckCFKC(prt,orditminf,loc,otherloc,prescno)
	;i allkc'=0 q -2
	;i otherphl="" q -1
	;s otherphw=##class(web.DHCOutPhNewAddCommit).GetOKWinFrPHL(otherphl)
	s paqrow=""
	s paqrow=$o(^PAQUE1(0,"PrescNo",prescno,""))
	i paqrow=""  q -1
	s paqadm="",carvrow="",otherpresc=""
	s paqadm=+$p(^PAQUE1(paqrow),"^",3)
	s carvrow=+$p(^PAQUE1(paqrow),"^",5)
	TSTART
	s otherpresc=prescno_"10"
	&sql(insert into sqluser.PA_QUE1(QUE1_PAADM_DR,QUE1_TransDate,QUE1_TransTime,QUE1_PrescNo,QUE1_CareProviderDR)
	    values(:paqadm,:sysdate,:systime,:otherpresc,:carvrow))
	i SQLCODE'=0  TRo
	i SQLCODE'=0 q -1
	s ord=""
	s ord=$o(^OEORD(0,"PrescNo",prescno,""))
	s itm="",sqlnum=0
	f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:(itm="")!(sqlnum'=0)  d
	  .s checkhaveitm=0
	  .s curorditm=ord_"||"_itm
	  .s checkhaveitm=##class(web.DHCOutPhNewAddCommit).CheckOrdItm(curorditm,orditminf)
	  .i checkhaveitm=1  d
	  ..&sql(update sqluser.oe_orditem set oeori_prescno=:otherpresc where oeori_rowid=:curorditm)
	  ..i SQLCODE'=0 s sqlnum=sqlnum+1
	i sqlnum'=0   TRo
	i sqlnum'=0 q -1
	&sql(insert into sqluser.dhc_pharwin(pha_prt_dr,pha_phl_dr,pha_phw_dr,pha_retflag,pha_date,pha_time,pha_prescno)
	values(:prt,:GPhl,:otherwin,'1',:sysdate,:systime,:otherpresc))
	s pharowid=""
	s pharowid=$g(%ROWID)
	i SQLCODE'=0  TRo
	i SQLCODE'=0 q -1
	s phdrow="",pmi="",pydr=""
	f  s phdrow=$o(^DHCPHDISPi("PRESCNO",prescno,phdrow)) q:(phdrow="")!(sqlnum'=0)  d
	  .s phdprt=""
	  .s phdprt=+$p(^DHCPHDISP(phdrow),"^",2)
	  .q:phdprt'=prt
	  .s pmi=+$p(^DHCPHDISP(phdrow),"^",7)
	  .s pydr=+$p(^DHCPHDISP(phdrow,1),"^",3)
	  .s phdsub=""
	  .s phdsub=$o(^DHCPHDI(phdrow,"PHDI",phdsub)) q:(phdsub="")!(sqlnum'=0)  d
	    ..s phdoeori=""
	    ..s phdoeori=$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",5)
	    ..s checkhaveitm=0
	    ..s curorditm=ord_"||"_itm
	    ..s checkhaveitm=##class(web.DHCOutPhNewAddCommit).CheckOrdItm(curorditm,orditminf)
	    ..i checkhaveitm=1  d
	    ..&sql(delete from sqluser.dhc_phdisitem where phdi_phd_parref=:phdrow and phdi_childsub=:phdsub)
	    ..i SQLCODE'=0 s sqlnum=sqlnum+1
	s newphdrow=""
	i dfflag="1"  d
	  .&sql(update sqluser.dhc_pharwin set pha_printflag='1' where pha_rowid=:pharowid)
	  .i SQLCODE'=0 s sqlnum=sqlnum+1
	  .i SQLCODE'=0  TRo
	  .q:SQLCODE'=0 
	  .&sql(insert into sqluser.dhc_phdispen(phd_prt_dr,phd_phl_dr,phd_phw_dr,phd_papmi_dr,phd_pydate,phd_fydate,phd_prescno,phd_php_pydr,phd_pytime,phd_pyflag)
	   values(:prt,:GPhl,:otherwin,:pmi,:sysdate,:sysdate,:otherpresc,:pydr,:systime,'1'))
	  .i SQLCODE'=0 s sqlnum=sqlnum+1
	  .i SQLCODE'=0  TRo
	  .q:SQLCODE'=0 
	  .s newphdrow=$g(%ROWID)
	  .s lsub=$l(orditminf,"^")
	  .s t=0
	  .b
	  .f t=1:1:lsub  d
	    ..s suborditm="",subqty=0,submoney=0,substr=""
	    ..s suborditm=$p(orditminf,"^",t)
	    ..q:suborditm=""
	    ..s substr=##class(web.DHCOutPhNewAddCommit).GetOrdItmFrBill(prt,suborditm)
	    ..s subqty=$p(substr,"^",1)
	    ..s submoney=$p(substr,"^",2)
	    ..b
	    ..&sql(insert into sqluser.dhc_phdisitem(phdi_phd_parref,phdi_childsub,phdi_qty,PHDI_PAYAMOUNT,phdi_oeori_dr)
	      values(:newphdrow,:t,:subqty,:submoney,:suborditm))
	    ..i SQLCODE'=0 s sqlnum=sqlnum+1
	    ..i SQLCODE'=0  TRo
    i sqlnum'=0   TRo
	i sqlnum'=0 q -1
 	TCommit
	q 0
}

ClassMethod CheckOrdItm(curorditm, ordinf)
{
	
	s lenitm=$l(ordinf,"^")
	s lt=0,lm=0
	f lt=1:1:lenitm  d
	  .s ltord=""
	  .s ltord=$p(ordinf,"^",lt)
	  .i ltord=curorditm  s lm=lm+1
	q lm
}

ClassMethod GetOKWinFrPHL(phl)
{
	n (phl)
	s curwin="",retwin=""
	f  s curwin=$o(^DHCPHWINi(phl,curwin)) q:curwin=""  d
	  .s winok=""
	  .s winok=$p(^DHCPHWIN(curwin),"^",3)
	  .q:winok'=1
	  .s retwin=curwin
	q retwin
}

ClassMethod CheckCFKC(prt, orditminf, loc, othloc, prescno)
{
		  s bci="0",lnkc=0
	  f  s bci=$o(^DHCBCI(0,"INV",prt,bci)) q:(bci="")!(bci="0")!(lnkc'=0)  d
	    .s patbill=""
	    .s patbill=+$p(^DHCBCI(bci),"^",2)
	    .s patbillsub="0"
	    .s t=0
	    .f  s patbillsub=$o(^DHCPB(patbill,"O",patbillsub)) q:(patbillsub="")!(patbillsub="")!(lnkc'=0)  d
	      ..s curorditm="",ord="",itm="",dispflag="",patprescno=""
	      ..s curorditm=$p(^DHCPB(patbill,"O",patbillsub),"^",4)
	      ..s ord=$p(curorditm,"||",1),itm=$p(curorditm,"||",2)
	      ..s recplocdr=""
	      ..s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	      ..q:recplocdr=""
	      ..q:recplocdr'=loc
	      
	      ..s chord=0
	      ..s chord=##class(web.DHCOutPhNewAddCommit).CheckOrdItm(curorditm,orditminf)
	      ..q:chord=0
	      ..s patprescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
	      ..q:patprescno=""
	      ..q:prescno'=patprescno
	      ..s qty=0,money=0
	      ..s qty=+$p(^DHCPB(patbill,"O",patbillsub),"^",5)
	      
	      ..s chordkc=0
	      ..s chordkc=##class(web.DHCOutPhNewAddCommit).CheckOrdKC(curorditm,qty,othloc)
	      ..i chordkc'=0 s lnkc=lnkc+1
	
 q lnkc
}

ClassMethod CheckOrdKC(orditm, qty, othloc)
{
	s sysdate=+$h
	s ord="",itm=""
	s ord=$p(orditm,"||",1)
	s itm=$p(orditm,"||",2)
	s itmmast=""
	s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast

    s phuomid="",phuomdesc="",itmmastid="",itmmastver=""
	s itmmastid=$p(itmmast,"||",1)
	s itmmastver=$p(itmmast,"||",2)
	s inci=""
	s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
    s sdate="",qtyend=0,ldtrow=""
	s sdate=$o(^DHCLOCTOT(0,"LOCITMDATE",othloc,inci,sysdate+1),-1)        
	i sdate'="" d
	    .s ldtrow=$o(^DHCLOCTOT(0,"LOCITMDATE",othloc,inci,sdate,""))
	    .i ldtrow'=""  s qtyend=+$p(^DHCLOCTOT(ldtrow),"^",4)
    i qtyend<qty  q -1
	q 0
}

ClassMethod GetDTXML(prt, presc)
{
      s bci="0",Para="",adm="",doccode="",docrowid=""
	  f  s bci=$o(^DHCBCI(0,"INV",prt,bci)) q:(bci="")!(bci="0")  d
	    .s patbill=""
	    .s patbill=+$p(^DHCBCI(bci),"^",2)
	    .s patbillsub="0"
	    .s t=0
	    .f  s patbillsub=$o(^DHCPB(patbill,"O",patbillsub)) q:(patbillsub="")!(patbillsub="")  d
	      ..s orditm="",ord="",itm="",dispflag="",argprescno=""
	      ..s orditm=$p(^DHCPB(patbill,"O",patbillsub),"^",4)
	      ..s ord=$p(orditm,"||",1),itm=$p(orditm,"||",2)
	      ..s recplocdr=""
	      ..s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	      ..s argprescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
	      ..q:argprescno=""
	      ..q:argprescno'=presc
	      ..s itmmast="",DurRowid="",FreqRowid="",InstrRowid="",DoseQty=0,DoseUomRowid="",SeqNo="",OrderDrugFormRowid=""
	      ..s adm=+$p(^OEORD(ord),"^",1)
	      ..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
	      ..s docrowid=+$p($g(^OEORD(ord,"I",itm,7)),"^",1)
	      ..s doccode=$p(^SSU("SSUSR",docrowid),"^",1)
	      ..s itmmastid=""
	      ..s itmmastid=$p(itmmast,"||",1)
	      ..s DurRowid=$p($g(^OEORD(ord,"I",itm,2)),"^",6)
	      ..s InstrRowid=$p($g(^OEORD(ord,"I",itm,2)),"^",7)
	      ..s FreqRowid=$p($g(^OEORD(ord,"I",itm,2)),"^",4)
	      ..s DoseQty=+$p($g(^OEORD(ord,"I",itm,2)),"^",1)
	      ..i DoseQty'=0  d
	        ...i DoseQty<1  s DoseQty="0"_DoseQty
	      ..s DoseUomRowid=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
	      ..s SeqNo=$p($g(^OEORD(ord,"I",itm,3)),"^",4)
	      ..s OrderDrugFormRowid=+$p(^ARCIM(itmmastid,1,1),"^",12)
	      ..s Para1=""
	      ..s Para1=itmmast_"!"_DoseQty_"!"_DoseUomRowid_"!"_FreqRowid_"!"_DurRowid_"!"_InstrRowid_"!"_OrderDrugFormRowid_"!"_SeqNo
          ..i Para=""  s Para=Para1
          ..e  s Para=Para_"^"_Para1

	i Para="" q -1
	s ret="",patstr=""
	s patstr=adm_"^"_doccode_"^"_docrowid
	
	s ret=patstr_"#"_Para 
	
	q ret
}

ClassMethod GetPWFlag(ctloc)
{
	s phl="",pw=0
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl="" q 0
	s pw=$p(^GLobDHCPHLOC(phl),"^",7)
	q pw
}

ClassMethod GetPatienDisp(stdate, enddate, phl, pmino, GPhw, cludeflag, twodisp, otherloc)
{
	
   ;stdate,enddate,GPhl,CPmiNo,GPhw,cludeflag,"1"
	s st=$zdh(stdate,4)
	s end=$zdh(enddate,4)
	i pmino="" q -1
	s phadate=0
	s othphl=""
	i otherloc'="" s othphl=$o(^DHCPHLOCi("LOC",otherloc,""))
	i othphl'=""  d
	  .s phl=othphl
	  .s GPhw=""
	s wintype=""
	i GPhw'="" s wintype=$g(^DHCPHWINTYPE(GPhw))
	s lpy=0,lup=0
    f phadate=st:1:end  d
      .s pha=0
	  .f  s pha=$o(^DHCPHARWi(phadate,phl,pha)) q:pha=""  d
        ..s phw="",finflag="",nouse="",printflag="",arrcpdr="",prt="",prescno=""
	    ..s phw=+$p(^DHCPHARW(pha),"^",4)
	    ..q:(phw'=GPhw)&(wintype=5)
	    ..q:(phw'=GPhw)&(wintype=6)
	    ..q:(phw'=GPhw)&(cludeflag'="1")
	    ..;&(twodisp="1")
	    ..;q:(phw'=GPhw)&(GPhw'="")&(twodisp="1")
	    ..s finflag=$p(^DHCPHARW(pha),"^",6)
	    ..q:(finflag="1")
	    ..s nouse=$p(^DHCPHARW(pha),"^",7)
	    ..q:nouse="1"
	    ..s phaserial=""
	    ..s phaserial=$p(^DHCPHARW(pha),"^",12)
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
	    ..s prtcode=""
	    ..s prtcode=$p(^DHCINVPRT(prt),"^",14)
	    ..s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	    ..q:(papmino'=pmino)&(pmino'="")
	    ..s printflag=$p(^DHCPHARW(pha),"^",8)
	    ..i twodisp="1"  d
	      ...i printflag="1"  d
	        ....s lpy=lpy+1
	      ...e  d
	        ....s lup=lup+1
	    ..e  d
	      ...s lpy=lpy+1
	   
 s ret=0
 i (lpy=0)&(lup=0)  d
   .s ret=0
 e  s ret=lpy_"^"_lup
     
	    

 q ret
}

ClassMethod GetPatienDispOthWin(stdate, enddate, phl, pmino, GPhw, twodisp)
{
	s st=$zdh(stdate,4)
	s end=$zdh(enddate,4)
	i pmino="" q -1
	s phadate=0
	s wintype="",retwin=""
	s wintype=$g(^DHCPHWINTYPE(GPhw))
	s lpy=0,lup=0
    f phadate=st:1:end  d
      .s pha=0
	  .f  s pha=$o(^DHCPHARWi(phadate,phl,pha)) q:pha=""  d
        ..s phw="",finflag="",nouse="",printflag="",arrcpdr="",prt="",prescno="",windesc=""
	    ..s phw=+$p(^DHCPHARW(pha),"^",4)
	    ..q:(phw=GPhw)
	    ..s finflag=$p(^DHCPHARW(pha),"^",6)
	    ..q:(finflag="1")
	    ..s nouse=$p(^DHCPHARW(pha),"^",7)
	    ..q:nouse="1"
	    ..s phaserial=""
	    ..s phaserial=$p(^DHCPHARW(pha),"^",12)
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
	    ..s prtcode=""
	    ..s prtcode=$p(^DHCINVPRT(prt),"^",14)
	    ..s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	    ..q:(papmino'=pmino)&(pmino'="")
	    ..s windesc=$p(^DHCPHWIN(phw),"^",1)
	    ..i retwin="" s retwin=windesc
	    ..e  s retwin=retwin_";"_windesc
	   
 s ret=0
 s ret=retwin
  

 q ret
}

ClassMethod GetPatienDispOthLoc(stdate, enddate, phl, pmino, twodisp)
{
	s st=$zdh(stdate,4)
	s end=$zdh(enddate,4)
	i pmino="" q -1
	s phadate=0
	
	s wintype="",retwin="",retloc="",retlocdesc=""
    
	s lpy=0,lup=0
    f phadate=st:1:end  d
      .s othphl=""
      .f  s othphl=$o(^DHCPHARWi(phadate,othphl)) q:(othphl="")  d
      ..s pha=0
      ..q:othphl=phl
	  ..f  s pha=$o(^DHCPHARWi(phadate,othphl,pha)) q:(pha="")  d
        ...s phw="",finflag="",nouse="",printflag="",arrcpdr="",prt="",prescno="",windesc="",othloc=""
	    ...s phw=+$p(^DHCPHARW(pha),"^",4)
	    ...s finflag=$p(^DHCPHARW(pha),"^",6)
	    ...q:(finflag="1")
	    ...s nouse=$p(^DHCPHARW(pha),"^",7)
	    ...q:nouse="1"
	    ...s phaserial=""
	    ...s phaserial=$p(^DHCPHARW(pha),"^",12)
	    ...s prt=+$p(^DHCPHARW(pha),"^",1)
	    ...s prescno=$p(^DHCPHARW(pha),"^",16)
	    ...s arraldr=""
	    ...s papmidr="",papmino="",payamount0=0,phatime=""
	    ...q:'$d(^DHCINVPRT(prt))
	    ...s prtdate=""
	    ...s prtdate=$zd(phadate,3)
	    ...s phatime=+$p(^DHCINVPRT(prt),"^",20)
	    ...s phatime=$zt(phatime,3)
	    ...s papmidr=$p(^DHCINVPRT(prt),"^",15)
	    ...q:papmidr=""
	    ...s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	    ...q:(papmino'=pmino)&(pmino'="")
	    ...s othloc=$p(^DHCPHLOC(othphl),"^",1)
	    ...s windesc=$p(^DHCPHWIN(phw),"^",1)
	    ...s othlocdesc=""
	    ...s othlocdesc=$p(^CTLOC(othloc),"^",2)
        ...i othlocdesc["-" s othlocdesc=$p(othlocdesc,"-",2)
        ...i othlocdesc="" s retloc=othlocdesc_" "_windesc
        ...e  s retloc=retloc_";"_othlocdesc_" "_windesc
	    
  
	   
 s ret=0
 
 i retloc=""  d
   .s ret=""
 e  d
  .s ret=retloc
  

 q ret
}

ClassMethod GetIncItmLockFlag(locdr, incid)
{
 n (locdr,incid)
 q:locdr="" ""
 q:incid="" ""
 s chl=$o(^INCI("IL_LOC",locdr,incid,"")) 
 q:chl="" ""
 s incil=incid_"||"_chl
 s dhcincil=$o(^DHCINCIL(0,"INCIL",incil,""))
 q:dhcincil="" ""
 s lockflag=$p(^DHCINCIL(dhcincil),"^",1)
 q lockflag
  ;1--加锁
}

ClassMethod CheckStock()
{
  s ret=0
  s ret=$g(^DHCDocConfig("NotCheckStock"))
  i ret'="1" q 0
  q ret
  ;1--不用判断实库存
}

ClassMethod CheckPrescLock(loc, presc)
{
 n (loc,presc)

 s ord="0",lockflag=0
 f  s ord=$o(^OEORD(0,"PrescNo",presc,ord)) q:(ord="")!(ord=0)  d
  .s itm=""
  .s itm=$o(^OEORD(0,"PrescNo",presc,ord,itm)) q:itm=""  d
  .s itmmast=""
  .s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast
  .s inci=""
  .s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),inci))
  .q:inci=""
  .s inclock=""
  .s inclock=##class(web.DHCOutPhNewAddCommit).GetIncItmLockFlag(loc,inci)
  .i inclock="1" s lockflag=lockflag+1
 i lockflag>0 q 1
 
 q 0
}

ClassMethod GetOrdItmFrBill(prt, orditm)
{
	n (prt,orditm)
	  s bci="0",ret=""
	  f  s bci=$o(^DHCBCI(0,"INV",prt,bci)) q:(bci="")!(bci="0")  d
	    .s patbill=""
	    .s patbill=+$p(^DHCBCI(bci),"^",2)
	    .s patbillsub="0"
	    .s t=0
	    .f  s patbillsub=$o(^DHCPB(patbill,"O",patbillsub)) q:(patbillsub="")!(patbillsub="")  d
	      ..s argorditm=""
	      ..s argorditm=$p(^DHCPB(patbill,"O",patbillsub),"^",4)
	      ..q:argorditm'=orditm
	      ..s qty=0,money=0
	      ..s qty=+$p(^DHCPB(patbill,"O",patbillsub),"^",5)
	      ..s money=+$p(^DHCPB(patbill,"O",patbillsub),"^",8)
	      ..s ret=qty_"^"_money
	 q ret
}

ClassMethod RefuseDisp(prescno, ycdesc, prtinv, patno, patname)
{
  s refusr="",recusr="",retval=0
  s refusr=%session.Get("LOGON.USERID")
  s ord=""
  f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:ord=""  d
    .s itm=""
    .f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:itm=""  d
    ..s oldbz="",newbz=""
    ..s phbz="",bz=0,bb=0
    ..i recusr="" s recusr=+$p($g(^OEORD(ord,"I",itm,7)),"^",1)
	..s bz=$g(^OEORD(ord,"I",itm,"DEP",0))
	..i bz="" s bz=0
	..s bz=bz+1
	..s ^OEORD(ord,"I",itm,"DEP",0)=bz
	..s ^OEORD(ord,"I",itm,"DEP",bz)=ycdesc
  i refusr="" q -1
  s sendinf=""
  s sendinf="患者"_patname_" "_patno_" 收据号"_prtinv_" 处方"_prescno_" 出现"_ycdesc
  s retval=##class(web.DHCOutPhNewAddCommit).SendMessage(refusr,sendinf,recusr)
 
 q retval
}

ClassMethod SendMessage(creatuser, message, receiveuser)
{
	s creatdate=+$H
	s creattime=$P($H,",",2)
	//测试数据
	;s creatuser=1    //发送人
    ;s message="你的处方有问题"   //发送的消息
	;s receiveuser=2091   //接收人
	//测试数据
 &SQL(insert into sqluser.SS_Message (MESS_DateCreated,MESS_TimeCreated,MESS_UserCreated_DR)
   values (:creatdate,:creattime,:creatuser))
	i SQLCODE=0 s Par=+%ROWID
	s ^SST("MESS",Par,"TXT",0)=1
	s ^SST("MESS",Par,"TXT",1)=message
	q:SQLCODE'=0 -1
	s MessageDR=+Par
	s MESSRECUserDR=receiveuser
 &SQL(insert into sqluser.SS_MessageRecipient (MESSREC_Message_DR,MESSREC_User_DR)
    values (:MessageDR,:MESSRECUserDR))   
	q SQLCODE
}

ClassMethod GetStDate(days)
{
	s sysdate=+$h
	s currdate=sysdate-days
	s retdate=$zd(currdate,4)
 q retdate
}

ClassMethod GetPrintPatient(prescno, prt, phl)
{
	
	    s locdr=$p(^DHCPHLOC(phl),"^",1)
	    s leadlocdr=##class(web.DHCOutPhDisp).GetLeadLoc(locdr)
	    s mainphl=$o(^DHCPHLOCi("LOC",leadlocdr,""))  //主科室
	    s phl=mainphl 
	    
	    s papmidr="",papmino="",payamount0=0,phatime=""
	    //q:'$d(^DHCINVPRT(prt)) -1
	    s prtdate=""
	    i prt'="" s prtdate=+$p(^DHCINVPRT(prt),"^",5)
	    s phwdesc=""
	    i prt'="" s phwdesc=..GetPhWinDesc(prt,prescno)
	    s prtdate=$zd(prtdate,3)
	    s phatime=""
	    i prt'="" s phatime=+$p(^DHCINVPRT(prt),"^",20)
	    i phatime'="" s phatime=$zt(phatime,1)
	    s papmidr=##class(web.DHCOutPhCommon).GetPapmiByPresc(prescno)
	    i prt'="" s papmidr=$p(^DHCINVPRT(prt),"^",15)
	    q:papmidr="" -1
	    s prtcode=""
	    i prt'="" s prtcode=$p(^DHCINVPRT(prt),"^",14)
	    s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	    s patienname="",patid=""
	    s patienname=$p(^PAPER(papmidr,"ALL"),"^",1)
	    s patid=$p(^PAPER(papmidr,"ALL"),"^",9)
	    s papsexdr="",papsex="",birthday="",difdate="",perold="",patMr="",glord=""
	    s papsexdr=+$p(^PAPER(papmidr,"ALL"),"^",7)
	    s perold=##class(web.DHCOutPhTQDisp).GetPatientAgeDesc(papmidr)
	    i papsexdr'="" s papsex=$p(^CT("SEX",papsexdr),"^",2)
	    //s pp=""
	    //s pp=##class(web.DHCOutPhDisp).GPerOrd(phl,prt,prescno)
	    //i pp["^" s money=$p(pp,"^",1),glord=$p(pp,"^",2)
	    //e  s money=pp
	    //s pfact=""
	    //s pfact=$p(pp,"&",3)
	    ;
	    s glord="",pfact=""
	    s patadm=##class(web.DHCOutPhDisp).getadm(prescno)
	    s prescmoney=##class(web.DHCOutPhDisp).GetPrescMoney(patadm,prescno,locdr)
	    s money=$p(prescmoney,"^",1)
	    s mricd="",retval=""
	    //s retval=##class(web.DHCOutPhDisp).GPerIcd(phl,prt,prescno)
	    s retval=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(patadm,",")
	    s mricd=$p(retval,"&",1)
	    s patorditem="",patord="",patitm="",patcosdesc="",patcos=""
	    //s patorditem=##class(web.DHCOutPhDisp).GetPatOrditm(phl,prt,prescno)
	    //q:patorditem="" -1
	    //s patord=$p(patorditem,"||",1)
	    //s patitm=$p(patorditem,"||",2)
	    //s patcos=+$p(^OEORD(patord,"I",patitm,3),"^",10)
	    //i patcos'=0 d
	    //.s patcosdesc=$p(^ARCOS(patcos),"^",2)
	    s patcosdesc=""
	    s deploc="",deplocdesc=""
	    s deploc=$p(^PAADM(patadm),"^",4)
	    s deplocdesc=$p(^CTLOC(deploc),"^",2)
	    i deplocdesc["-" s deplocdesc=$p(deplocdesc,"-",2)
	    s presctype="",ptype="",jrflag=""
	    //s ptype=##class(web.DHCOutPhDisp).CheckPydType(phl,prt,prescno)
	    s ptype="" 
	    s presctype=$p(ptype,"^",1)
	    s jrflag=$p(ptype,"^",2)
	    s ybstr="",ybcode=""
	    s ybstr=##class(web.DHCINSUAdmInfoCtl).GetInfoByAdm(patadm)
	    i ybstr'=-100  d
	    .s bycode=$p(ybstr,"^",3)
	    s querow="",jytype="", cyyl=""
	    s querow=$O(^PAQUE1(0,"PrescNo",prescno,""))
	    i querow'=""  d
	     .i $d(^PAQUE1(querow,"DHC"))   d
	       ..s jytype=$p(^PAQUE1(querow,"DHC"),"^",15)
	       ..s cyyl=$p(^PAQUE1(querow,"DHC"),"^",13)
	    i jytype["代"  s jytype="代煎"
        
	    s admreason="",admreasondr=""
	    s admreasondr=+$p(^PAADM(patadm,1),"^",7)
	    s admreason=$p(^PAC("ADMREA",admreasondr),"^",2)
	    s dhcorditm="",ybshuser="",ybshname=""
	    //s dhcorditm=$o(^DHCORDItem(0,patorditem,""))
	    i dhcorditm'=""  d
	    .s ybshuser=+$p(^DHCORDItem(dhcorditm,2),"^",2)
	    i (ybshuser'="")&(ybshuser'=0)  d
	    .s byshname=$p(^SSU("SSUSR",byshuser),"^",2)
	   
	    s pattype="",patstatudr="",tel="",patadd=""
        s patstatudr=+$p(^PAPER(papmidr,"PER",1),"^",10)
        s tel=$p(^PAPER(papmidr,"PER",1),"^",11)   //add by xuyj
        i patstatudr'=0 s pattype=$p(^CT("SS",patstatudr),"^",2)
        i pattype["(" s pattype=$p(pattype,"(",1)
        s patadd=$p($g(^PAPER(papmidr,"PER",4)),"^",18)
	    //s ptype=##class(web.DHCOutPhDisp).CheckPydType(phl,prt,prescno)
	    s ptype=""
	    s presctype=$p(ptype,"^",1)
	    s jrflag=$p(ptype,"^",2)
	    s printdatetime=""
	    s printdatetime=prtdate_" "_phatime
	    s presctitle=""
	    s presctitle=##class(web.DHCOutPhTQDisp).GetPrescTitle(prescno)
        s kfdatetime=""
        s kfdatetime=##class(web.DHCOutPhNewAddCommit).GetPrescDate(prescno)
        s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(patorditem)
	    s dispinfo=..GetDispUserInfo(phl,prt,patadm,prescno)
	    s pyname=$p(dispinfo,"^",1)
	    s fyname=$p(dispinfo,"^",2)
	    s pydate=$p(dispinfo,"^",3)
	    i pydate="" s pydate=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	    s fydate=$p(dispinfo,"^",4)
	    
	    //s ArcimRowid=$p(^OEORD(patord,"I",patitm,1),"^",2)
	    s AdmReasonDr=$p(^PAADM(patadm,1),"^",7)
	    
	    //s drugtypestr=##class(web.DHCINSUPort).ArcimLinkInsu(ArcimRowid, AdmReasonDr)
	   // s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(patord_"||"_patitm)
	    s doctor=""
	    s drugtype="" //$p(drugtypestr,"^",1)
	    s ret=patienname_"^"_papmino_"^"_kfdatetime_"^"_prtcode_"^"_prt_"^"_prescno_"^"_papsex_"^"_perold_"^"_deplocdesc_"^"_mricd_"^"_presctype_"^"_phwdesc_"^"_patid_"^"_pfact_"^"_jytype_"^"_tel_"^"_patadd_"^"_presctitle_"^"_cyyl
        s ret=ret_"^"_pyname_"^"_fyname_"^"_pydate_"^"_fydate_"^"_drugtype_"^"_doctor
        
	    q ret
}

/// liangqiang
/// 取发药信息
ClassMethod GetDispUserInfo(phl, prt, adm, prescno)
{
	
	s papmi=$p(^PAADM(adm),"^",1)
	s phdr=""
	f  s phdr=$o(^DHCPHDISPi("PAPMI",papmi,phdr)) q:phdr=""  d
	.s tmpphl=$p(^DHCPHDISP(phdr,1),"^",1)
	.s tPrescNo=$p(^DHCPHDISP(phdr,2),"^",1)
	.
	.q:tmpphl'=phl
	.q:tPrescNo'=prescno
	.s pyname=""
	.s pyuserdr=$p(^DHCPHDISP(phdr,1),"^",3)
	.i pyuserdr'="" s pyname=$p(^DHCPHPER(pyuserdr),"^",2)
	.s fyname=""
	.s fyuserdr=$p(^DHCPHDISP(phdr,1),"^",2)
	.i fyuserdr'="" s fyname=$p(^DHCPHPER(fyuserdr),"^",2)
	.s pydate=$p(^DHCPHDISP(phdr,1),"^",5)
	.i pydate'="" s pydate=$zd(pydate,3)
	.s pytime=$p(^DHCPHDISP(phdr,1),"^",7)
	.i pytime'="" s pytime=$zt(pytime,1)
	.s pydate=pydate_" "_pytime
	.; 
	.s fydate=$p(^DHCPHDISP(phdr),"^",3)
	.i fydate'="" s fydate=$zd(fydate,3)
	.s fytime=$p(^DHCPHDISP(phdr),"^",5)
	.i fytime'="" s fytime=$zt(fytime,1)
	.s fydate=fydate_" "_fytime
	q $g(pyname)_"^"_$g(fyname)_"^"_$g(pydate)_"^"_$g(fydate)
}

ClassMethod GetPhWinDesc(prt, presc)
{
	  s pharow="",retpha="",phw=""
	  f  s pharow=$o(^DHCPHARi("PRT",prt,pharow)) q:pharow=""  d
	    .s phapresc=""
	    .s phapresc=$p(^DHCPHARW(pharow),"^",16)
	    .q:phapresc'=presc
	    .s retpha=pharow
	 i retpha'=""  s phw=+$p(^DHCPHARW(retpha),"^",4)
	 s windesc=""
	 i phw'=""  d
	     .s windesc=$p(^DHCPHWIN(phw),"^",1)
     q windesc
}

ClassMethod GetPrescDate(presc)
{
	s neword=""
	s neword=$o(^OEORD(0,"PrescNo",presc,""))
	i neword="" q ""
	s newitm=""
	s newitm=$o(^OEORD(0,"PrescNo",presc,neword,""))
	i newitm="" q ""
	s orddate="",ordtime=""
	s orddate=+$p(^OEORD(neword,"I",newitm,3),"^",7)
	s ordtime=+$p(^OEORD(neword,"I",newitm,1),"^",17)
	s retval=""
	s orddate=$zd(orddate,3)
	s ordtime=$zt(ordtime,1)
	s retval=orddate_" "_ordtime
 q retval
}

ClassMethod QueryGPersonOrdClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryGPersonOrdExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// w ##class(%ResultSet).RunQuery("web.DHCOutPhNewAddCommit","QueryGPersonOrd",193,310)
ClassMethod QueryGPersonOrdExecute(ByRef QHandle As %Binary, rPhd As %Library.String = "", rCtloc As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s phd=""
	s phl="",ctloc="",yprescno=""
	s pmi="",patname=""
	s ctloc=rCtloc
	i ctloc="" Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s phl=$o(^DHCPHLOCi("LOC",ctloc,"")) 
	i phl="" Set QHandle=$lb(0,repid,0)	Quit $$$OK
	i rPhd="" Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s cyflag="",prt=""

	s cyflag=$p(^DHCPHLOC(phl),"^",6)
	s pmi=+$p(^DHCPHDISP(rPhd),"^",7)
	s patname=$p(^PAPER(pmi,"ALL"),"^",1)
	s EncryptLevelInfo=""
	s EncryptLevel=""
	s PatLevel="" 
	s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
	i EncryptFlag=1 d
	.s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(pmi,"")
	.s EncryptLevel=$p(EncryptLevelInfo,"^",1)
	.s PatLevel=$p(EncryptLevelInfo,"^",2) 	   
	s phdrow=rPhd
	s pyflag=$p(^DHCPHDISP(phdrow,1),"^",6)
	s phdphl=""
	s phdphl=+$p(^DHCPHDISP(phdrow,1),"^",1)
	i phdphl'=phl Set QHandle=$lb(0,repid,0)	Quit $$$OK
	i pyflag="1"  Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s prtid=$p(^DHCPHDISP(phdrow),"^",2)
	s hospdr=$p(^CTLOC(ctloc),"^",22)
	s custstr=##Class(web.DHCSTCOMMO).GetLocCust(ctloc)
	s phdi = "", m = 0
	f  s phdi=$o(^DHCPHDI(phdrow,"PHDI",phdi)) q:phdi=""  d
	.s orditm = ""
	.s orditm=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",5)
	.s ord = "", ordi = ""
	.s ord=$p(orditm,"||",1)
	.s ordi=$p(orditm,"||",2)
	.
	.s itmmast = ""
	.s itmmast=$p(^OEORD(ord,"I",ordi,1),"^",2)      ;arc_itmmast
	.s itmmastid=$p(itmmast,"||",1)
	.s itmmastver=$p(itmmast,"||",2)
	.s inci = ""
	.s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
	.q:inci=""
	.s priority = ""
	.s dispqty = "",retqty=0
	.s dispqty=+$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",4)      ;药品数量
	.s retqty=+$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",6)
	.s catgrpstr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inci)
	.s catgrpdesc=$p(catgrpstr,"^",2)
	.s perv="^^^"_catgrpdesc_"^"_hospdr_"^DHC"
	.s price = 0, totprice = 0
	.i prtid="" d ; 无发票模式
	..s dspdate=##class(web.DHCOutPhDisp).getDspDate(orditm)
	..i dspdate="" s dspdate=+$h
	..s spdate=+$h
	..s firstinclb=##class(web.DHCOutPhCommon).GetFirstInclbByOe(orditm)
	..i firstinclb="" s firstinclb=+inci,spdate=+$p($g(^OEORD(ord,"I",ordi,3)),"^",7)
	..i spdate=0 s spdate=+$h
	..s price=##class(web.DHCSTPRICE).GetSp(firstinclb,+spdate,"",hospdr,"","")	//zhouyg 20150113,yunhaibao20170210,没发票的需要按最新进价
	..s totprice=price*dispqty
	..s totprice=##Class(web.DHCSTCOMMPARA).GetNumbDec(totprice,perv,"FmtSA",1)
	.e  d
	..s ordpriceinfo=##class(web.DHCOutPhCommon).GetBasPriceByInv(prtid,orditm)
	..s price=$p(ordpriceinfo,"^",1)
	..s totprice=+$p(ordpriceinfo,"^",2)
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
	.s phuomid = "", phuomdesc = ""
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
	.s inci=$p(inci,$c(1),1)
	.s yppc="",inclb="",incib=""
	.s incil="",yphw="",incstb=""
	.s incil=$o(^INCI("IL_LOC",ctloc,inci,""))
	.s incilnew=inci_"||"_incil
	.s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incilnew,",","","") //改为取新的科室货位表DHCIncItmLocBin（可多货位）add wyx 2013-11-21
	.s stkchkflag=$p(stkbinret,":",1)
	.s stkbinstr=$p(stkbinret,":",2)
	.s yphw=stkbinstr
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
	.// 转计价单位
	.i getnum=(dispqty/confac)  d
	..s newunit=phuomid
	..s newunitdesc=phuomdesc
	..s newqty=getnum
	..s newprice=price*confac
	..s newretqty=retqty/confac
	..i confac>1 s newprice=##Class(web.DHCSTCOMMPARA).GetNumbFN(newprice,perv,"FmtSP",1)
	.e  d
	..s newunit=basuom
	..s newunitdesc=basuomdesc
	..s newqty=dispqty
	..s newretqty=retqty
	..s newprice=price
	.s basuomdr=+$p(^INCI(inci,1),"^",10)
	.s dispuomdr=$p($g(^OEORD(ord,"I",ordi,"DHC")),"^",13)
	.//wyx add 发药单位 2014-01-08
	.i dispuomdr'="" d
	..s confac=##class(web.DHCSTCOMMONSRV).UOMFac(dispuomdr,basuomdr)
	..s dispqty2=dispqty/confac
	..s unit=$p($g(^CT("UOM",dispuomdr)),"^",2)
	..s newqty=dispqty2
	..s retqty2=retqty/confac
	..s newretqty=retqty2
	..s newprice=price*confac
	..s newunitdesc=unit
	..i confac>1 s newprice=##Class(web.DHCSTCOMMPARA).GetNumbFN(newprice,perv,"FmtSP",1)
	..//wyx add 发药单位 2014-01-08
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
	.set Data=$lb(patname,orditem,phdesc,newunitdesc,newprice,newqty,totprice,oeflag,pc,phfragdesc,instrdesc,duratdesc,username,yppc,yphw,newretqty,EncryptLevel,PatLevel,phdrow)
	.Set ^CacheTemp(repid,ind)=Data	
	.Set ind=ind+1
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryGPersonOrdFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGPersonOrdExecute ]
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

Query QueryGPersonOrd(rPhd As %String, rCtloc As %String) As %Query(ROWSPEC = "TPatName:%String,tphditm:%String,TPhDesc:%String,TPhUom:%String,TPrice:%String,TPhQty:%String,TPhMoney:%String,TStatus:%String,TJL:%String,TPC:%String,TYF:%String,TLC:%String,TDoctor:%String,TIncPC:%String,TIncHW:%String,TRetQty:%String,TEncryptLevel:%String,TPatLevel:%String,TPhdRow:%String") [ SqlProc ]
{
}

ClassMethod GetPhlFrLoc(ctloc)
{
	s phl=""
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl="" q 0  
 
  q phl
}

ClassMethod GetPhwFrPrt(prt, ctloc)
{
	s phl="",phw="",retval=""
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl="" q 0  
	s cyflag=""
	s cyflag=$p(^DHCPHLOC(phl),"^",6)
   i cyflag'="1"  
   { s phdrow=""
    f  s phdrow=$o(^DHCPHDISPi("PRT",phl,prt,phdrow)) q:phdrow=""  d
    .s phw=+$p(^DHCPHDISP(phdrow,1),"^",4)
    i phw'="" s phwdesc=$p(^DHCPHWIN(phw),"^",1)
    i phw=""  s retval=""
    e  d
    .s retval=phw_"^"_phwdesc
   }
   else
   {
	   
	  s phdrow=prt
	  s phw=+$p(^DHCPHDISP(phdrow,1),"^",4)
	   i phw'="" s phwdesc=$p(^DHCPHWIN(phw),"^",1)
    i phw="" s retval=""
    e  d
    .s retval=phw_"^"_phwdesc
	  
   }
  q retval
}

ClassMethod GetPmiFrCard(cardcode)
{
	s pmi="",pmino="",cardrow=0,card=0,myPAPMIInfo=""
	f  s cardrow=$o(^DHCCARD("CF",cardrow)) q:(cardrow="")!(cardrow=0)  d
	 .s cardno=""
	 .s cardno=$p(^DHCCARD("CF",cardrow),"^",2)
	 .q:cardno'=cardcode
	 .s pmi=$p($g(^DHCCARD("CF",cardrow)),"^",6)
    ;s pmi=$p($g(^DHCCARD("CF",cardrow)),"^",6)
	;i pmi'="" s pmino=$p(^PAPER(pmi,"PAT",1),"^",2) 
	q pmi
}

ClassMethod GetCardFrPmi(pmino)
{
	s pmi="",cardinf="",cardno=""
    s pmi=$o(^PAPERi("PAPMI_PatNo",pmino,pmi))
    s cardrow=""
    s cardrow=$o(^DHCCARDi("CF",0,"PAPMIDR",pmi,""))
	s cardno=$p($g(^DHCCARD("CF",cardrow)),"^",2)
	q cardno
}

ClassMethod SendDHCall(presc, dispflag)
{
	s patname="",patno="",patpmi="",pydr="",pyuser="",sysdate="",phwin=""
	s phdrow=""
	i dispflag="1"  d
		.s phdrow=..GetPhdFrPresc(presc)
    e  s phdrow=presc
	i phdrow'="" s pydr=+$p(^DHCPHDISP(phdrow,1),"^",3)
	s patpmi=+$p(^DHCPHDISP(phdrow),"^",7)
	s patname=$p(^PAPER(patpmi,"ALL"),"^",1)

	s patno=$p(^PAPER(patpmi,"PAT",1),"^",2)
	
	i pydr'=0 s pyuser=+$p(^DHCPHPER(pydr),"^",5)
	s phwin=+$p(^DHCPHDISP(phdrow,1),"^",4)
	s windesc="",callinf="",prt="",prescno="",sreeninf=""
	s windesc=$p(^DHCPHWIN(phwin),"^",1)
	s prt=+$p(^DHCPHDISP(phdrow),"^",2)
	s prescno=$p(^DHCPHDISP(phdrow,2),"^",1)
	i dispflag'="1"  d
	 .s callinf="请"_patname_"到"_windesc_"取药"
	s screeninf=windesc_","_patname_","_patno_","_prescno_","_dispflag
	s retval=""
	s retval=##class(web.DHCVISVoiceCall).InsertVoiceQueue(callinf,pyuser,"","D","LR","N",screeninf,screeninf,"","")
	q retval
}

ClassMethod GetPhdFrPresc(prescno)
{
	;n (prescno)
	s phd="",phdrowid=""
	f  s phd=$o(^DHCPHDISPi("PRESCNO",prescno,phd)) q:phd=""  d
	  .s phdprt="",prtflag=""
	  .s phdprt=+$p(^DHCPHDISP(phd),"^",2)
	  .s prtflag=$p(^DHCINVPRT(phdprt),"^",8)
	  .q:prtflag'="N"
	  .s phdrowid=phd
   q phdrowid
}

ClassMethod GetPYSureFlag(ctloc)
{
	s phl=""
	s phl=$O(^DHCPHLOCi("LOC",ctloc,""))
	i phl="" q 0
	s pysureflag="0"
	s pysureflag=$p($g(^GLobDHCPHLOC(phl)),"^",6)
	q pysureflag
}

ClassMethod GetFYCodeFlag(ctloc)
{
	s phl=""
	s phl=$O(^DHCPHLOCi("LOC",ctloc,""))
	i phl="" q 0
	s pysureflag="0"
	s pysureflag=$p($g(^GLobDHCPHLOC(phl)),"^",7)
	q pysureflag
}

ClassMethod GetUnDisp(phl, phw)
{
  ;s st=$zdh(stdate,4)
  ;s end=$zdh(enddate,4)
  s st=+$h
  s end=+$h
  s cyflag=""
  s cyflag=$p(^DHCPHLOC(phl),"^",6)
  k ^DHCTMPPHLPMI($j)
  s phddate = "", t = 0
  s retname=""
  f phddate=st:1:end  d
    .s phdrow = ""
    .f  s phdrow=$o(^DHCPHDISPi(phddate,phl,phdrow)) q:phdrow=""  d
         ..s ppyflag="",pfyflag="",pydr1="",fydr1="",prt="",inv="",pydate="",use="",perno="",pname=""
         ..s ppyflag=$p(^DHCPHDISP(phdrow,1),"^",6)
         ..s pfyflag=$p(^DHCPHDISP(phdrow),"^",4)
         ..q:ppyflag'="1"
         ..q:pfyflag="1"
         ..s curphw=""
         ..s curphw=+$p(^DHCPHDISP(phdrow,1),"^",4)
         ..q:curphw'=phw
         ..s prescno="",flag=""
         ..s prt=+$p(^DHCPHDISP(phdrow),"^",2)
         ..s flag=$p(^DHCINVPRT(prt),"^",8)
         ..q:flag'["N"
         ..s prescno=$p(^DHCPHDISP(phdrow,2),"^",1)
         ..s jyfs=""
         ..i cyflag="1"  d
         ...s jyfs=##class(web.DHCOutPhAdd).GetJYFS(prescno)
         ..;q:jyfs["代煎"
         ..s pmi="",patname=""
         ..s pmi=+$p(^DHCPHDISP(phdrow),"^",7)
         ..q:$d(^DHCTMPPHLPMI($j,phl,pmi))
         ..s ^DHCTMPPHLPMI($j,phl,pmi)=1
         ..s patname=$p(^PAPER(pmi,"ALL"),"^",1)
         ..i retname="" s retname=patname
         ..e  s retname=retname_"^"_patname
   k ^DHCTMPPHLPMI($j)
   i retname="" q -1
   q retname
}

ClassMethod GetFileName(windesc)
{
  i windesc'["窗口" q -1
  s filecode=""
  s filecode=$p(windesc,"窗口",2)
  i filecode="" q -1
  q filecode
}

ClassMethod CheckLocPresc(phl, presc, loc)
{
    s ord="0",adm="",inc="",m=0
	f  s ord=$o(^OEORD(0,"PrescNo",presc,ord)) q:(ord="")!(ord="0")  d
	.s adm=+$P(^OEORD(ord),"^",1)
	.s itm=""
	.s itm=$o(^OEORD(0,"PrescNo",presc,ord,itm))
	.s doctloc=""
	.s doctloc=+$p(^OEORD(ord,"I",itm,7),"^",2)
	.q:doctloc'=loc
	.s itmmast=""
	.s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast
	.s inc=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),""))

  i inc="" q 0
   s ldirow=""
   f  s ldirow=$O(^DHCPHLADDINCIi("INCI",inc,ldirow)) q:ldirow=""  d
     .s ldphl="",ldflag="",ldcrow=""
     .s ldphl=+$P(^DHCPHLADDINCI(ldirow),"^",4)
     .q:ldphl'=phl
     .s ldflag=$P(^DHCPHLADDINCI(ldirow),"^",1)
     .q:ldflag="1"
     .s ldcrow=+$P(^DHCPHLADDINCI(ldirow),"^",3)
     .s ldcloc="",ldcflag=""
     .s ldcloc=+$p(^DHCPHLADDCODE(ldcrow),"^",1)
     .q:ldcloc'=loc
     .s ldcflag=$p(^DHCPHLADDCODE(ldcrow),"^",2)
     .q:ldcflag="1"
     .s m=m+1
   q m
}

ClassMethod CheckPhlPresc(phl, presc)
{
    s ord="0",adm="",inc="",m=0,ordloc=""
	f  s ord=$o(^OEORD(0,"PrescNo",presc,ord)) q:(ord="")!(ord="0")  d
	.s adm=+$P(^OEORD(ord),"^",1)
	.s patloc=""
	.s itm=""
	.s itm=$o(^OEORD(0,"PrescNo",presc,ord,itm))
	.s itmmast=""
	.s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast
	.s inc=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),""))
	.s ordloc=+$p(^OEORD(ord,"I",itm,7),"^",2)
	.
  i inc="" q 0
  i (ordloc="")!(ordloc=0) q 0
   s ldirow=""
   f  s ldirow=$O(^DHCPHLADDINCIi("INCI",inc,ldirow)) q:ldirow=""  d
     .s ldphl="",ldflag="",ldcrow=""
     .s ldphl=+$P(^DHCPHLADDINCI(ldirow),"^",4)
     .q:ldphl'=phl
     .s ldflag=$P(^DHCPHLADDINCI(ldirow),"^",1)
     .q:ldflag="1"
     .s ldcrow=+$P(^DHCPHLADDINCI(ldirow),"^",3)
     .s ldcloc="",ldcflag=""
     .s ldcloc=+$p(^DHCPHLADDCODE(ldcrow),"^",1)
     .q:ldcloc'=ordloc
     .s ldcflag=$p(^DHCPHLADDCODE(ldcrow),"^",2)
     .q:ldcflag="1"
     .s m=m+1
   q m
}

ClassMethod QueryLocPatClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocPatExecute ]
{
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryLocPatExecute(ByRef QHandle As %Binary, CDateSt As %Library.String, CDateEnd As %Library.String = "", GPhl As %Library.String = "", GPhw As %Library.String = "", CPmiNo As %Library.String = "", CPatName As %Library.String = "", GPydr As %Library.String = "", GFydr As %Library.String = "", GPhwPos As %Library.String = "", fyflag As %Library.String = "", ordloc As %Library.String = "", OrdLocDesc As %Library.String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	s phl=""
	s sysdate=+$h
    s phl=GPhl
    
	i (phl="")!(ordloc="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s stdate=CDateSt
	s enddate=CDateEnd
	s cyflag="",dfflag="" 
	s cyflag=$p(^DHCPHLOC(phl),"^",6)
	s yflocdr=+$p(^DHCPHLOC(phl),"^",1)
	s fpflag=""
	s phadate=0
	
	f phadate=stdate:1:enddate  d
	  .s pha=0
	  .f  s pha=$o(^DHCPHARWi(phadate,phl,pha)) q:(pha="")!(pha=0)  d
        ..s phwdesc="",phw="",finflag="",nouse="",printflag="",arrcpdr="",prt="",prescno=""
	    ..s phw=+$p(^DHCPHARW(pha),"^",4)
	    ..;q:phw'=GPhw
	    ..s phwdesc=$p(^DHCPHWIN(phw),"^",1)
	    ..s finflag=$p(^DHCPHARW(pha),"^",6)
	    ..;i finflag'="1" s finflag=""
	    ..
	    ..q:(finflag="1")&(fyflag'="1")
	    ..
	    ..q:(finflag'="1")&(fyflag="1")
	    ..i finflag="1"  s finflag="OK"
	    ..e  s finflag=""
	    ..
	    ..s nouse=$p(^DHCPHARW(pha),"^",7)
	    ..q:(nouse="1")&(finflag'="1")
	    ..s printflag=$p(^DHCPHARW(pha),"^",8)
	    ..
	    ..i printflag'="1" s printflag=""
	    ..e  s printflag="OK"
	    ..s prt=+$p(^DHCPHARW(pha),"^",1)
	    ..s prescno=$p(^DHCPHARW(pha),"^",16)
	    ..s arraldr=""
	    ..
	    ..s papmidr="",papmino="",payamount0=0,phatime=""
	    ..q:'$d(^DHCINVPRT(prt))
	    ..s prtdate=""
	    ..s prtdate=$zd(phadate,3)
	    ..s phatime=+$p(^DHCINVPRT(prt),"^",20)
	    ..s phatime=$zt(phatime,3)
	    ..s papmidr=$p(^DHCINVPRT(prt),"^",15)
	    ..q:papmidr=""
	    ..s prtcode=""
	    ..
	    ..s prtcode=$p(^DHCINVPRT(prt),"^",14)
	    ..s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	    ..q:(papmino'=CPmiNo)&(CPmiNo'="")
	    ..s patienname=""
	    ..s patienname=$p(^PAPER(papmidr,"ALL"),"^",1)
	    ..q:(patienname'=CPatName)&(CPatName'="")
	    ..s papsexdr="",papsex="",birthday="",difdate="",perold="",deploc="",deplocdr="" 
	    ..s papsexdr=+$p(^PAPER(papmidr,"ALL"),"^",7)
	    ..s birthday=+$p(^PAPER(papmidr,"ALL"),"^",6)
	    ..s difdate=sysdate-birthday+1
	    ..s perold=difdate/365
	    ..i perold["." s perold=$p(perold,".",1)
	    ..i papsexdr'="" s papsex=$p(^CT("SEX",papsexdr),"^",2)
	    ..s m=0,p=0,error=""
	    ..s pp=0,pmoney=0,pret="",pfact=""
	    ..;s pp=##class(web.DHCOutPhDisp).GPerOrd(phl,prt,prescno,fyflag)
	    ..s pp=##class(web.DHCOutPhNewAddCommit).GPerOrd(phl,prt,prescno,fyflag)
	    ..s mricd="",patadm="",retval=""
	    ..s presctype=""
	    ..s presctype=##class(web.DHCOutPhDisp).CheckPydType(phl,prt,prescno)
	    ..s retval=##class(web.DHCOutPhDisp).GPerIcd(GPhl,prt,prescno)
	    ..;s retval=##class(web.DHCOutPhDisp).GPerIcd(phl,prt,prescno)
	    ..s mricd=$p(retval,"&",1)
	    ..s patadm=##class(web.DHCOutPhDisp).getadm(prescno)
	    ..
	    ..s deplocdr=+$p(^PAADM(patadm),"^",4)
	    ..s deploc=$p(^CTLOC(deplocdr),"^",2)
	    ..i deploc["-" s deploc=$p(deploc,"-",2)
	    ..i pp["&"  d  
	     ...s pret=$p(pp,"&",1)
	     ...s pfact=$p(pp,"&",3)
	     ...i pret["^" s unflag="1",pmoney=$p(pret,"^",1)
	     ...e  s pmoney=pret
	    ..e  d
	    ...i pp["^" s unflag="1",pmoney=$p(pp,"^",1)
	    ...e  s pmoney=pp
	    ..;q:pmoney=0
	    ..s pmoney=$fn(pmoney,"",2)
	    ..s retcheckfzloc=0
	    ..s retcheckfzloc=##class(web.DHCOutPhNewAddCommit).CheckLocPresc(phl,prescno,ordloc)
	    ..q:retcheckfzloc=0
	    ..set Data=$lb(patienname,papmino,prtdate,printflag,finflag,prtcode,phatime,prt,prescno,pmoney,pfact,phwdesc,phw,phw,mricd,patadm,presctype,papsex,perold,deploc)
 	    ..Set ^CacheTemp(repid,ind)=Data	
 	    ..Set ind=ind+1
 	    ..
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

Query QueryLocPat(CDateSt As %String, CDateEnd As %String, GPhl As %String, GPhw As %String, CPmiNo As %String, CPatName As %String, GPydr As %String, GFydr As %String, GPhwPos As %String, fyflag As %String, ordloc As %String, OrdLocDesc As %String) As %Query(ROWSPEC = "TPatName:%String,TPmiNo:%String,TPrtDate:%String,TPrintFlag:%String,TFyFlag:%String,TPrtInv:%String,TPrtTime:%String,TPrt:%String,TPrescNo:%String,TPrescMoney:%String,TJS:%String,TWinDesc:%String,TWinID:%String,TNewWinID:%String,TMR:%String,TAdm:%String,TPrescType:%String,TPerSex:%String,TPerAge:%String,TPerLoc:%String")
{
}

ClassMethod GetPatBasInf(pmi)
{
	s patname="",patno="",patsex="",patage=""
	s patno=$p(^PAPER(pmi,"PAT",1),"^",2)
	s papsexdr="",papsex="",birthday="",difdate="",perold="",patage=""
	s papsexdr=+$p(^PAPER(pmi,"ALL"),"^",7)
	s patage=##class(web.DHCOutPhTQDisp).GetPatientAgeDesc(pmi)
 	i papsexdr'="" s patsex=$p(^CT("SEX",papsexdr),"^",2)
    s patname=$p(^PAPER(pmi,"ALL"),"^",1)
	s ret=patname_"^"_patno_"^"_patsex_"^"_patage
	q ret
}

ClassMethod GetPhdPatient(phdrow)
{
  	
  	s papmi="",patname="",patsex="",patage="",patno=""
  	s papmi=+$p(^DHCPHDISP(phdrow),"^",7)
  	s patinf=""
  	s patinf=##class(web.DHCOutPhNewAddCommit).GetPatBasInf(papmi)
  	s patname=$p(patinf,"^",1)
  	s patno=$p(patinf,"^",2)
  	s patsex=$p(patinf,"^",3)
  	s patage=$p(patinf,"^",4)
  	s prescno=""
  	s prescno=$p(^DHCPHDISP(phdrow,2),"^",1)
  	s patadm=##class(web.DHCOutPhDisp).getadm(prescno)
  	S weight=##class(web.DHCSTPIVA).GetPatWeight(patadm)
    s patloc="",patlocdesc=""
	s patloc=+$p(^PAADM(patadm),"^",4)
	s patlocdesc=$p(^CTLOC(patloc),"^",2)
	i patlocdesc["-" s patlocdesc=$p(patlocdesc,"-",2)
    s phl="",prt=""
    s phl=+$p(^DHCPHDISP(phdrow,1),"^",1)
    s prt=+$p(^DHCPHDISP(phdrow),"^",2)
  	s presctype="",ptype="",icdval="",paticd=""
    s ptype=##class(web.DHCOutPhDisp).CheckPydType(phl,prt,prescno)
  	s presctype=$p(ptype,"^",1) 
    s ord="",itm="",orddoct="",orddoctname="",orddoctcode=""
    s ord=$o(^OEORD(0,"PrescNo",prescno,""))
    s itm=$o(^OEORD(0,"PrescNo",prescno,ord,""))
    s orddoct=$p($g(^OEORD(ord,"I",itm,1)),"^",11)
    i orddoct'=""  d
	  .s orddoctname=$p($g(^CTPCP(orddoct,1)),"^",2)
	  .s orddoctcode=$p($g(^CTPCP(orddoct,1)),"^",1)
	  .s orddoctname=orddoctcode_"-"_orddoctname
    s oeori=ord_"||"_itm
    s notes=..GetNotes(oeori)
    s notes=$e(notes,2,$l(notes))

  	s icdval=##class(web.DHCOutPhDisp).GPerIcd(phl,prt,prescno)
	s paticd=$p(icdval,"&",1)
  	s pydr="",pyuser="",pyname="",fydr="",fyuser="",fyname=""
  	s pydr=+$p(^DHCPHDISP(phdrow,1),"^",3)
    s fydr=+$p(^DHCPHDISP(phdrow,1),"^",2)
    i pydr'=0 s pyuser=+$p(^DHCPHPER(pydr),"^",5)
    i fydr'=0 s fyuser=+$p(^DHCPHPER(fydr),"^",5)
    i pyuser'="" s pyname=$p(^SSU("SSUSR",pyuser),"^",2)	
  	i fyuser'="" s fyname=$p(^SSU("SSUSR",fyuser),"^",2)
  	s presctitle=""
  	s presctitle=##class(web.DHCOutPhTQDisp).GetPrescTitle(prescno)
  	s FYDATE=$p(^DHCPHDISP(phdrow),"^",3)
  	i FYDATE'=""  s FYDATE=$zd(FYDATE,3)    ;发药日期
  	s prescmoney=0
  	s phdsub=""
  	f  s phdsub=$o(^DHCPHDI(phdrow,"PHDI",phdsub)) q:phdsub=""  d
  	  .s phdmoney=0
  	  .s phdmoney=+$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",3)
  	  .s prescmoney=prescmoney+phdmoney
  	s retval=""
  	s zhb=""  ;诊别
  	s admtypedr=""
  	s admtypedr=+$p(^PAADM(patadm,2),"^",28)
  	i admtypedr'=0 s zhb=$p(^PAC("IPAT",admtypedr),"^",2)
  	s retval=patname_"^"_patno_"^"_patsex_"^"_patage_"^"_prescno_"^"_prescmoney_"^"_patlocdesc_"^"_presctype_"^"_zhb_"^"_orddoctname_"^"_paticd_"^"_pyname_"^"_fyname_"^"_presctitle_"^"_FYDATE_"^"_weight_"^"_notes
  q retval
}

ClassMethod GetWinSerial(phl, prt, presc)
{
	s pharow="",retserial=""
	f  s pharow=$o(^DHCPHARi("PRT",prt,pharow)) q:pharow=""  d
	   .s phapresc=""
	   .s phapresc=$p(^DHCPHARW(pharow),"^",16)
	   .q:phapresc'=presc
	   .s retserial=$p(^DHCPHARW(pharow),"^",12)
	q retserial
}

ClassMethod GPerOrd(rPHL As %Library.String = "", rPRT As %Library.String = "", rPrescNo As %Library.String = "", fyflag As %Library.String = "")
{
	new (rPHL,rPRT,rPrescNo,fyflag)
	  s phl=$g(rPHL)
	  s prt=$g(rPRT),hh=0,allmoney=0
	  s yprescno=$g(rPrescNo)
	  s unflag=""
	  s sysdate=+$h
	 ; k ^DHCPHTMPPRESCNO
	  i (phl="")!(prt="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	  s reclocdr=""
	  s reclocdr=+$p(^DHCPHLOC(phl),"^",1)
	  s currflag=""
	  i fyflag="1" s currflag="Y"
	  e  s currflag="W"
	  s cy=""
	  s cy=$p(^DHCPHLOC(phl),"^",6)
	  s ^TFDHC=currflag
	  k ^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno)
	  s bci="0"
	  f  s bci=$o(^DHCBCI(0,"INV",prt,bci)) q:(bci="")!(bci="0")  d
	    .s patbill=""
	    .s patbill=+$p(^DHCBCI(bci),"^",2)
	    .s patbillsub="0"
	    .f  s patbillsub=$o(^DHCPB(patbill,"O",patbillsub)) q:(patbillsub="")!(patbillsub="")  d
	      ..s orditm="",ord="",itm="",dispflag="",prescno=""
	      ..s orditm=$p(^DHCPB(patbill,"O",patbillsub),"^",4)
	      ..;s dispflag=""
	      ..;s dispflag=##class(web.DHCOutPhDisp).GetDHCOEDisp(orditm,"W")
	      ..s dispflag=""
	      ..s dispflag=##class(web.DHCOutPhDisp).GetDHCOEDisp(orditm,currflag)
	      ..q:dispflag="0"
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
	      ..i $d(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm))  d
	         ...s $p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",1)=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",1)+qty
	         ...s $p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",2)=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",2)+money
	      ..e  d
	         ...s $p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",1)=qty
	         ...s $p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,orditm),"^",2)=money
	   s ordi="",durfact=""
	   k ^DHCTMPINCLOC($j)
	   f  s ordi=$o(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,ordi)) q:ordi=""  d
	     .s dispqty=0,dispmoney=0,price=0
	     .s dispqty=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,ordi),"^",1)
	     .s dispmoney=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,ordi),"^",2)
	     .s price=dispmoney/dispqty
	     .s ord="",itm=""
	     .s ord=$p(ordi,"||",1)
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
	    .i $d(^DHCTMPINCLOC($j,reclocdr,inci)) d
	    ..s ^DHCTMPINCLOC($j,reclocdr,inci)=$g(^DHCTMPINCLOC($j,reclocdr,inci))+dispqty
	    .e  d
	    ..s ^DHCTMPINCLOC($j,reclocdr,inci)=dispqty
	    .s bjqty=0
	    .s bjqty=$g(^DHCTMPINCLOC($j,reclocdr,inci))

	    .s sdate="",qtyend=0
	    .s sdate=$o(^DHCLOCTOT(0,"LOCITMDATE",reclocdr,inci,sysdate+1),-1)        
	    .i sdate'="" d
	      ..s ldtrow=$o(^DHCLOCTOT(0,"LOCITMDATE",reclocdr,inci,sdate,""))
	      ..s qtyend=+$p(^DHCLOCTOT(ldtrow),"^",4)
        .i qtyend<bjqty s unflag="1"
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
	    .s phgg=##class(web.DHCSTKUTIL).GetSpec(inci)		;$p($g(^INCI(inci,3)),"^",9)
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
   k ^DHCTMPINCLOC($j)
   i unflag="1" s allmoney=allmoney_"^"_"1"
   i cy="1" s allmoney=allmoney_"&"_durfact
 q allmoney
}

ClassMethod GetPatOrdLoc(phl, prt, presc, userid)
{
	  s sysdate=""
	  s yprescno=$g(presc)
	  s reclocdr=""
	  s reclocdr=+$p(^DHCPHLOC(phl),"^",1)
	  k ^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno)
	  k ^TMPDHCPH($j,"ItmPrescINC",yprescno)
	  s bci="0"
	  f  s bci=$o(^DHCBCI(0,"INV",prt,bci)) q:(bci="")!(bci="0")  d
	    .s patbill=""
	    .s patbill=+$p(^DHCBCI(bci),"^",2)
	    .s patbillsub="0"
	    .s t=0
	    .f  s patbillsub=$o(^DHCPB(patbill,"O",patbillsub)) q:(patbillsub="")!(patbillsub="0")  d
	      ..s orditm="",ord="",itm="",dispflag="",prescno=""
	      ..s orditm=$p(^DHCPB(patbill,"O",patbillsub),"^",4)
	      ..s ord=$p(orditm,"||",1),itm=$p(orditm,"||",2)
	      ..s recplocdr=""
	      ..s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	      ..;s ^TANGD(patbillsub)=orditm_"^"_recplocdr
	      ..q:recplocdr=""
	      ..q:recplocdr'=reclocdr
	      ..s dispflag="" 
	      ..s dispflag=$p($g(^OEORD(ord,"I",itm,6)),"^",7)
	      ..;q:dispflag="1"
	      ..;s dispflag=##class(web.DHCOutPhDisp).GetDHCOEDisp(orditm,"W")
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
	     .;s price=dispmoney/dispqty
	     .s price=##CLASS(web.DHCOutPhDisp).GetBasPrice(prt,orditem)
	     .;s price=$fn(price,"",4)
	 	 .s itmmast=""
	     .s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast
	     .s ordadm="",admreasrow="",yblb="",ybret=""
	     .s ordadm=+$p(^OEORD(ord),"^",1)

	     .s priority=""
	     .s priority=$p(^OEORD(ord,"I",itm,1),"^",8)     ;????
	     .s priordesc=""
	     .i priority'="" s priordesc=$p(^OECPR(priority),"^",2)
	     .q:priordesc["自备"
	     .s orddoctco=""
	     .s orduser="",ordusertypedr="",ordusercare="",careprovtype="",userdoctype=""
	     .s orddoctco=$p($g(^OEORD(ord,"I",itm,1)),"^",11) ;??
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
	     .s unitdesc=""
	     .i unitdr'="" s unitdesc=$p($g(^CT("UOM",unitdr)),"^",2)
	     .s phuomid="",phuomdesc="",itmmastid="",itmmastver=""
	     .s itmmastid=$p(itmmast,"||",1)
	     .s itmmastver=$p(itmmast,"||",2)
	     .s itmcat="",itmcatdesc="",syflag=""
	     .s itmcat=+$p(^ARCIM(itmmastid,itmmastver,1),"^",10)
	     .s genric=""
	     .s genric=$p(^ARCIM(itmmastid,itmmastver,8),"^",20)
	     .s incTYdesc=""
	     .i genric'="" s incTYdesc=$p(^PHCGE("GE",genric),"^",2)
	     .i incTYdesc["-" s incTYdesc=$p(incTYdesc,"-",2)
	     .s itmcatdesc=$p(^ARC("IC",itmcat),"^",2)
	     .i itmcatdesc["输液"  s syflag="1"
	     .s drgform="",drgmast="",phtype=""
	     .s drgform=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
	     .i drgform'="" s drgmast=$p(drgform,"||",1)
	     .i drgmast'=""  d
	      ..s phtype=$p($g(^PHCD(drgmast,4)),"^",2)
	     .s dxsl="",dxunit="",phfact="",factdesc=""
	     .s dxrowid="0"
	     .s dxrowid=$o(^PHCD(drgmast,"DF",$p(drgform,"||",2),"EQ",dxrowid))
	  	 .i drgform'=""  d
	       ..s phcform=$p(^PHCD($p(drgform,"||",1),"DF",$p(drgform,"||",2),1),"^",1)
	       ..s phfact=$p(^PHCD($p(drgform,"||",1),2),"^",4)
	     .e  d
	       ..s phcform="",phfact=""
         .i phfact=""  s factdesc="" 
         .e  d
           ..i '$d(^PHMNF(phfact))  s factdesc="" 
           ..e  s factdesc=$p(^PHMNF(phfact),"^",2)  
         .i factdesc["-" s factdesc=$p(factdesc,"-",2)  
	     .s phuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	     .q:phuomid=""
	     .s phuomid=$p(phuomid,$c(1),1)
	    .s currdate=""
	    .s currdate=$p($h,",",1)
	    .s phuomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
		 .s incil="",yphw="",incstb=""
		 .s inci=""
	    .s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))

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
	    .i dxrowid'=""  d
	        ..s dxsl=+$p(^PHCD(drgmast,"DF",$p(drgform,"||",2),"EQ",dxrowid),"^",2) 
	        ..s dxunit=+$p(^PHCD(drgmast,"DF",$p(drgform,"||",2),"EQ",dxrowid),"^",1) 
	        ..i unitdr=dxunit  d
	          ...;s doseqty=doseqty/dxsl
	          ...;i doseqty["."  s doseqty=$fn(doseqty,"",2)


	    .s phgg=""
	    .;s phgg=$p($g(^INCI(inci,3)),"^",9)
	    .s phgg=##class(web.DHCOutPhDisp).GetPhgg(inci)
	    .s confac=1,conrow=""
	    .i basuom=phuomid s confac=1
	    .e  d
	      ..s conrow=$o(^CT("CTCF",0,"UOM",phuomid,basuom,conrow))
	      ..i conrow'="" s confac=+$p(^CT("CTCF",conrow),"^",3)
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
	    .s instrdesc=""
	    .i instrdr'="" s instrdesc=$p($g(^PHCIN(instrdr)),"^",2)
	    .s orddoctnam=""
	    .i orduser'="" s orddoctnam=$p(^SSU("SSUSR",orduser),"^",2)
	    .s doctype=""
	    .;i orddoctco'=""  s doctype=$p(^CT("CPT",+$p(^CTPCP(orddoctco,1),"^",4)),"^",4)
	    .s jlflag=""
	    .;i unitdesc["?" s unitdesc=$p(unitdesc,"?",1) s unitdesc=unitdesc_"?"
	    .s jlflag=doseqty_unitdesc
	    .i userdoctype'["DOC"  d
	      ..s jlflag="",phfragdesc="",instrdesc="",duratdesc="",orddoctnam="",username=""
	      ..i orddoctco'="" s username=$p(^CTPCP(orddoctco,1),"^",2)
	    .s error="",t=0,cc=0,notes=""
	    .s notes=$p(^OEORD(ord,"I",itm,2),"^",8)
	    .s oeflag="",inclbid="",disstatu=""
	    .s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",2)       ;????
        .q:oeflag["停"
        .i newunitdesc["(" s newunitdesc=$p(newunitdesc,"(",1)
	    .i t=0 s error="1"
	    .s newprice=$fn(newprice,"",4)
	    .s dispmoney=$fn(dispmoney,"",2)
	    .i phdesc["(" s phdesc=$p(phdesc,"(",1)
	    .i phdesc["[" s phdesc=$p(phdesc,"[",1)
	    .;s phdesc=dlgtype_phdesc
	    .;s phdesc="("_yblb_")"_phdesc
        .i '$d(^DHCTMPPHIncLoc(phl,userid,inci))  d
        ..s ^DHCTMPPHIncLoc(phl,userid,inci)=getnum_"^"_dispmoney_"^"_newprice_"^"_phdesc_"^"_newunitdesc_"^"_phgg_"^"_factdesc
        .e  d
        ..s $p(^DHCTMPPHIncLoc(phl,userid,inci),"^",1)=$p(^DHCTMPPHIncLoc(phl,userid,inci),"^",1)+getnum
        ..s $p(^DHCTMPPHIncLoc(phl,userid,inci),"^",2)=$p(^DHCTMPPHIncLoc(phl,userid,inci),"^",2)+dispmoney
     q 0
}

ClassMethod QueryChOrdHZClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryChOrdHZExecute ]
{
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryChOrdHZExecute(ByRef QHandle As %Binary, GPhl As %Library.String = "", userid As %Library.String = "", OrdLocDesc As %Library.String = "", stdate As %Library.String = "", enddate As %Library.String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	s phl=""
	s sysdate=+$h
    s phl=GPhl
	i (phl="")!(userid="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	
	s yflocdr=+$p(^DHCPHLOC(phl),"^",1)
	s inci=""
	f  s inci=$o(^DHCTMPPHIncLoc(GPhl,userid,inci)) q:inci=""  d
	.s dispqty=0,dispmoney=0,price=0,phdesc="",unitdesc="",phgg="",factdesc=""
	.s dispqty=$p($g(^DHCTMPPHIncLoc(GPhl,userid,inci)),"^",1)
	.s dispmoney=$p($g(^DHCTMPPHIncLoc(GPhl,userid,inci)),"^",2)
	.s price=$p($g(^DHCTMPPHIncLoc(GPhl,userid,inci)),"^",3)
	.s phdesc=$p($g(^DHCTMPPHIncLoc(GPhl,userid,inci)),"^",4)
	.s unitdesc=$p($g(^DHCTMPPHIncLoc(GPhl,userid,inci)),"^",5)
	.s phgg=$p($g(^DHCTMPPHIncLoc(GPhl,userid,inci)),"^",6)
	.s factdesc=$p($g(^DHCTMPPHIncLoc(GPhl,userid,inci)),"^",7)
	.s dispmoney=$fn(dispmoney,"",2)
    .set Data=$lb(phdesc,unitdesc,phgg,price,dispqty,dispmoney,factdesc)
 	.Set ^CacheTemp(repid,ind)=Data	
 	.Set ind=ind+1
    k ^DHCTMPPHIncLoc(GPhl,userid)
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryChOrdHZFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryChOrdHZExecute ]
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

Query QueryChOrdHZ(GPhl As %String, userid As %String, OrdLocDesc As %String, stdate As %String, enddate As %String) As %Query(ROWSPEC = "TPhDesc:%String,TPhUom:%String,TPhgg:%String,TPrice:%String,TPhQty:%String,TPhMoney:%String,TFactory:%String")
{
}

/// Descript: 取备注
/// Creater:	caoting
/// CreateDate:	2011-05-10
/// w ##class(web.DHCOutPhNewAddCommit).GetNotes("1897||6")
ClassMethod GetNotes(moeori As %String) As %String
{
	N (moeori)
	Q:moeori="" ""
	s Notes=""
	S ord=$P(moeori,"||",1) Q:ord="" ""
	S itm=$P(moeori,"||",2) Q:itm="" ""
	s rnum=0
	f  s rnum=$o(^OEORD(ord,"I",itm,"DEP",rnum)) q:rnum=""  d
    .s Notes=Notes_$G(^OEORD(ord,"I",itm,"DEP",rnum))
    i Notes="" s Notes=$p($g(^OEORD(ord,"I",itm,2)),"^",8)
    ;w "Notes"_Notes
    Q Notes
}

}
