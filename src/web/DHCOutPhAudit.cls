Import sqluser

Class web.DHCOutPhAudit Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod CheckPrescDsp(presc, prt)
{
  s phdrow="",p=0
  f  s phdrow=$o(^DHCPHDISPi("PRESCNO",presc,phdrow)) q:phdrow=""  d
  .s phdfyflag="",phdprt="",prtflag=""
  .s phdprt=+$p(^DHCPHDISP(phdrow),"^",2)
  .q:phdprt'=prt
  .s p=p+1
  q p
}

ClassMethod FormatAge(AgeYear As %String, AgeMonth As %String, AgeDay As %String) As %String
{
	if AgeYear>14 s AgeDesc=AgeYear_"岁"
	else  d
	.i AgeYear=0 s AgeYear=""
	.e  s AgeYear=AgeYear_"岁"
	.i AgeMonth=0 s AgeMonth=""
	.e  s AgeMonth=AgeMonth_"月"
	.i AgeDay=0 s AgeDay=""
	.e  s AgeDay=AgeDay_"天"
	.s AgeDesc=AgeYear_AgeMonth_AgeDay
	Q AgeDesc
}

ClassMethod GetPatientAgeDesc(PatientID As %String) As %String
{
	s PatientDOB=$P($G(^PAPER(PatientID,"ALL")),"^",6)
	s Age=$$CalAge^at182(PatientDOB,+$H,"","","")
	s AgeYear=$P(Age,"|",12)
	s AgeMonth=$P(Age,"|",13)
	s AgeDay=$P(Age,"|",14)
	s AgeDesc=..FormatAge(AgeYear,AgeMonth,AgeDay)
	Q AgeDesc
}

ClassMethod QueryLocPatPYClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocPatPYExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryLocPatPYExecute(ByRef QHandle As %Binary, CDateSt As %Library.String, CDateEnd As %Library.String = "", GPhl As %Library.String = "", GPhw As %Library.String = "", CPmiNo As %Library.String = "", CPatName As %Library.String = "", GPydr As %Library.String = "", GFydr As %Library.String = "", GPhwPos As %Library.String = "", CPrint As %Library.String = "", CPyUser As %Library.String = "", stopcon As %Library.String = "", SpecialID) As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	s phl="",userid="",t=0,yfpydr="",patnum=0
	s sysdate=+$h
	s systime=$p($h,",",2)
    s phl=GPhl
	i (phl="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	i (CPmiNo="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s stdate=CDateSt
	s enddate=CDateEnd
	s yflocdr=+$p(^DHCPHLOC(phl),"^",1)
	s locdr=$p(^DHCPHLOC(phl),"^",1)
	s loginlocdr=locdr //登录科室
	s leadlocdr=##class(web.DHCOutPhDisp).GetLeadLoc(locdr)
	s mainphl=$o(^DHCPHLOCi("LOC",leadlocdr,""))  //主科室
	s phl=mainphl
	s yflocdr=leadlocdr
	s cyflag=""
	s cyflag=$p(^DHCPHLOC(phl),"^",6)
	
	s prt=""
	s phadate=0,p=0
	f phadate=stdate:1:enddate  d
	.q:SpecialID'=""
	.s phlstr=""
	.s chkreclocflag=##class(web.DHCOutPhCommon).GetChkRecLocFlag() 
	.i chkreclocflag=0 s phlStr=##class(web.DHCOutPhCommon).GetPatPhlStr()
	.i phlStr="" s phlStr=phl
	.s phlCnt=$l(phlStr,"^")
	.f xx=1:1:phlCnt d
	..s phl=$p(phlStr,"^",xx)
	..s phar=0
	..f  s phar=$o(^DHCPHARWi(phadate,phl,phar)) q:(phar="")!(phar=0)  d
    ...s phw="",finflag="",nouse="",printflag="",arrcpdr="",prt="",prescno=""
	...s phw=+$p(^DHCPHARW(phar),"^",4)
	...s phwdesc=""
	...i $d(^DHCPHWIN(phw)) s phwdesc=$p(^DHCPHWIN(phw),"^",1)
	...s ret=""
	...s prescno=$p(^DHCPHARW(phar),"^",16)
	...s ordstatus=##class(web.DHCOutPhCommon).CheckOrdState(prescno)
	...q:(ordstatus=1)&(CPrint'="1")
	...//s ret=##class(web.DHCOutPhTQDisp).CheckPyFyWin(GPhw,phw)
	...//q:ret=0
	...s retflag=""
	...s retflag=$p(^DHCPHARW(phar),"^",13)
	...q:retflag'="1"
	...s finflag=$p(^DHCPHARW(phar),"^",6)
	...i finflag="1"  s finflag="OK"
	...e  s finflag=""
	...s nouse=$p(^DHCPHARW(phar),"^",7)
	...q:nouse="1"
	...s printflag=$p(^DHCPHARW(phar),"^",8)
	...s phd=$o(^DHCPHDISPi("PRESCNO",prescno,""))
	...q:(CPrint="1")&(printflag'="1")
	...q:(CPrint="1")&(phd'="")   //2012-10-26
	...q:(CPrint'="1")&(printflag="1")
	...//q:(CPrint'="1")&(nouse="1")
	...
	...i printflag'="1" d
	....s printflag=""
	...e  d
	....s printflag="OK"
	...
	...s prt=+$p(^DHCPHARW(phar),"^",1)
	...//q:prt=""
	...s prescno=$p(^DHCPHARW(phar),"^",16)
	...s arraldr=""
	...s chkerr=##class(web.DHCOutPhDisp).CheckBeforUpdate(prescno,phl)
	...//q:(chkerr=1)&(CPrint'="1")
	...//i (chkerr=1)&(CPrint="1") s finflag="OK"
	...//s chkerr=##class(web.DHCOutPhDisp).CheckBeforInsert(prescno,phl,0)
	...//q:(chkerr=1)&(CPrint'="1")
	...s phd=##class(web.DHCOutPhDisp).GetPhdByPresc(prescno,phl)
	...s ord=$o(^OEORD(0,"PrescNo",prescno,""))
	...s adm=$p(^OEORD(ord),"^",1)
	...d getdata
	...
	;   
	s pid=0
    f orddate=stdate:1:enddate  d
    .q:$g(SpecialID)=""
    .s phadate="" //收费日期
    .s:$g(pid)=0 pid=##CLASS(web.DHCSTKUTIL).GetOutDispCounter()
	.s ord=""
	.f  s ord=$o(^OEORDi(0,"LocStDtArr",yflocdr,0,orddate,ord)) q:ord=""  d
	..s chl=""
	..f  s chl=$o(^OEORDi(0,"LocStDtArr",yflocdr,0,orddate,ord,chl)) q:chl=""  d
	...s adm=$p(^OEORD(ord),"^",1) 
	...s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
	...s ordstatus=$p(^OEORD(ord,"I",chl,3),"^",5)
	...s EmLGflag=$p($g(^OEORD(+ord,"I",chl,"DHC")),"^",17)
	...q:(EmLGflag="")&(SpecialID=1)
	...s tmpreclocdr=$p(^OEORD(ord,"I",chl,3),"^",6)
    ...q:tmpreclocdr'=yflocdr
	...s ^TMPPRESCINFO(pid,adm,prescno)=""
	...
	..
	s adm="" 
	
    f  s adm=$o(^TMPPRESCINFO(pid,adm)) q:adm=""  d
    .s prescno=""
    .f  s prescno=$o(^TMPPRESCINFO(pid,adm,prescno)) q:prescno=""  d 
    ..s papmidr=$p(^PAADM(adm),"^",1) 
	..s chkerr=##class(web.DHCOutPhDisp).CheckBeforUpdate(prescno,phl)
	..q:(chkerr=1)&(CPrint'="1")
	..i (chkerr=1)&(CPrint="1") s finflag="OK"
	..s chkerr=##class(web.DHCOutPhDisp).CheckBeforInsert(prescno,phl,0)
	..q:(chkerr=1)&(CPrint'="1")
	..//q:(chkerr'=1)&(CPrint="1")
	..i chkerr=1 s printflag="OK" 
	..s chkerr=##class(web.DHCOutPhCommon).GetOrdXState(prescno,phl)
	..q:(chkerr=1)&(CPrint'="1") 
    ..s phd=##class(web.DHCOutPhDisp).GetPhdByPresc(prescno,phl)
    ..d getdata
    
    d clearTmp
	    
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK    
	    
getdata	    

	    s papmino="",payamount0=0,phatime=""
	    s prtdate=""
	    i phadate'="" s prtdate=$zd(phadate,3)
	    i prt'="" s phatime=+$p(^DHCINVPRT(prt),"^",20)
	    s cytime=0
	    s cytime=systime-phatime
	    //q:(cytime<10)&(phadate=sysdate)
	    s phatime=$zt(phatime,3)
	    s papmidr=$p(^PAADM(adm),"^",1)
	    i prt'="" s papmidr=$p(^DHCINVPRT(prt),"^",15)
	    q:papmidr=""
	    s prtcode=""
	    i prt'="" s prtcode=$p(^DHCINVPRT(prt),"^",14)
	    s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	    q:(papmino'=CPmiNo)&(CPmiNo'="")
	    s patienname="",patid=""
	    s patienname=$p(^PAPER(papmidr,"ALL"),"^",1)
	    s patid=$p(^PAPER(papmidr,"ALL"),"^",9)
	    q:(patienname'[CPatName)&(CPatName'="")
	    s papsexdr="",papsex="",birthday="",difdate="",perold="",patMr="",glord=""
	    s papsexdr=+$p(^PAPER(papmidr,"ALL"),"^",7)
	    s perold=..GetPatientAgeDesc(papmidr)
	    i papsexdr'="" s papsex=$p(^CT("SEX",papsexdr),"^",2)
	    s m=0,p=0,error=""
	    s pp=0,money=0,deploc="" 
        s adm=##class(web.DHCOutPhDisp).getadm(prescno)
        s prescmoney=##class(web.DHCOutPhDisp).GetPrescMoney(adm,prescno,yflocdr)
	    s money=$p(prescmoney,"^",1)
	    s presctype=$p(prescmoney,"^",2)
	    i prt'="" s money=##class(web.DHCOutPhCommon).GetPriceByInv(phl,prt,prescno)
	    
        q:money=0
        s money=$fn(money,"",2)
        s fs="" //草药付数
        s doclocstr=##class(web.DHCOutPhCommon).GetBaseOrdUseLocByPresc(prescno)
        s uselocdr=$p(doclocstr,"^",1)
        q:uselocdr'="" //默认不显示基数药科室
        s patadm=""
        s patadm=##class(web.DHCOutPhDisp).getadm(prescno)
	    s patloc="",patlocdesc=""
	    s patloc=+$p(^PAADM(patadm),"^",4)
	    s patlocdesc=$p(^CTLOC(patloc),"^",2)
	    i patlocdesc["-" s patlocdesc=$p(patlocdesc,"-",2)
        s querow="",jytype=""
	    s querow=$O(^PAQUE1(0,"PrescNo",prescno,""))
	    i querow'=""  d
	    .i $d(^PAQUE1(querow,"DHC")) s jytype=$p(^PAQUE1(querow,"DHC"),"^",15)
	    i jytype["代"  s jytype="代煎"
        s pericd="",retval="",username="",billtype="",BillClass="",PoisonClass="",admdate=""
        s presctype="",ptype="",jrflag=""
	    s pericd=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(patadm,",")
	    //s ptype=##class(web.DHCOutPhDisp).CheckPydType(phl,prt,prescno)
 	    //s presctype=$p(ptype,"^",1)
	    //s jrflag=$p(ptype,"^",2)
	    s presctype=##class(web.DHCOutPhDisp).GetPrescType(prescno)
	    s pattype="",patstatudr="",tel="",patadd=""
        s patstatudr=+$p(^PAPER(papmidr,"PER",1),"^",10)
        s tel=$p(^PAPER(papmidr,"PER",1),"^",11)   //add by xuyj
        i patstatudr'=0 s pattype=$p(^CT("SS",patstatudr),"^",2)
        i pattype["(" s pattype=$p(pattype,"(",1)
        s patadd=$p($g(^PAPER(papmidr,"PER",4)),"^",18)
	    s presctitle=##class(web.DHCOutPhTQDisp).GetPrescTitle(prescno)
	    s reclocinfo=##class(web.DHCOutPhCommon).GetPrescRecLoc(prescno)
	    s reclocdesc=$p(reclocinfo,"^",1)
	    s reclocdr=$p(reclocinfo,"^",2)
	    s t=t+1
	    s money=$fn(money,"",2)
	    set Data=$lb(patienname,papmino,prtdate,printflag,finflag,prtcode,phatime,prt,prescno,money,papsex,perold,pericd,glord,patlocdesc,syflag,presctype,phwdesc,patid,fs,jytype,tel,patadd,presctitle,phd,reclocdesc,reclocdr)
 	    Set ^CacheTemp(repid,ind)=Data	
 	    Set ind=ind+1
        q
clearTmp  
   k ^TMPPRESCINFO(pid)
   q
}

ClassMethod QueryLocPatPYFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocPatPYExecute ]
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

Query QueryLocPatPY(CDateSt As %String, CDateEnd As %String, GPhl As %String, GPhw As %String, CPmiNo As %String, CPatName As %String, GPydr As %String, GFydr As %String, GPhwPos As %String, CPrint As %String, CPyUser As %String, stopcon As %String, SpecialID) As %Query(ROWSPEC = "TPatName:%String,TPmiNo:%String,TPrtDate:%String,TPrintFlag:%String,TFyFlag:%String,TPrtInv:%String,TPrtTime:%String,TPrt:%String,TPrescNo:%String,TPrescMoney:%String,TPerSex:%String,TPerAge:%String,TMR:%String,TGLOrd:%String,TPerLoc:%String,TSyFlag:%String,TPrescType:%String,TWinDesc:%String,TPatID:%String,TJS:%String,TJYType:%String,TCallCode:%String,TPatAdd:%String,TPrescTitle:%String,Tphdrowid:%String,Treclocdesc:%String,Treclocdr:%String")
{
}

ClassMethod CheckPyFyWin(pywin, fywin)
{
 
 s retval="",checkcount=0
 s pywinsub="0"
 f  s pywinsub=$o(^DHCPHPY(pywin,"PHW",pywinsub)) q:(pywinsub="0")!(pywinsub="")!(checkcount=1)  d
   .s pyfywin=""
   .s pyfywin=+$p(^DHCPHPY(pywin,"PHW",pywinsub),"^",1)
   .q:pyfywin'=fywin
   .s checkcount=checkcount+1
 q checkcount
}

ClassMethod GetPhaRowFrPrtPresc(prt, presc)
{
	s pharow="",retval=""
	f  s pharow=$o(^DHCPHARi("PRT",prt,pharow)) q:pharow=""  d
	  .s phapresc=""
	  .s phapresc=$p(^DHCPHARW(pharow),"^",16)
	  .q:phapresc'=presc
	  .s retval=pharow
	q retval
}

ClassMethod QueryLocPatFYClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocPatFYExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryLocPatFYExecute(ByRef QHandle As %Binary, CDateSt As %Library.String = "", CDateEnd As %Library.String = "", GPhl As %Library.String = "", GPhw As %Library.String = "", CPmiNo As %Library.String = "", CPatName As %Library.String = "", cludeflag As %Library.String = "", CPrescNo As %Library.String = "", fyflag As %Library.String = "", SpecialID) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	s phl="",userid="",t=0
	s sysdate=+$h
    s phl=GPhl
	i (phl="")!(CPmiNo="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s stdate=CDateSt
	s enddate=CDateEnd
	s yflocdr=+$p(^DHCPHLOC(phl),"^",1)
	s leadlocdr=##class(web.DHCOutPhDisp).GetLeadLoc(yflocdr)
	s yflocdr=leadlocdr
	s phpydate=""
	f phpydate=stdate:1:enddate  d  
	  .s phdrow=0
	  .f  s phdrow=$o(^DHCPHDISPi(phpydate,phl,phdrow)) q:(phdrow="")!(phdrow="0")  d
        ..s phw="",finflag="",nouse="",printflag="",arrcpdr="",prt="",prescno=""
        ..s phadate=0
	    ..s phw=+$p(^DHCPHDISP(phdrow,1),"^",4)
	    ..q:(phw'=GPhw)&(cludeflag'="1")&(phw'=0)
	    ..s finflag=$p(^DHCPHDISP(phdrow),"^",4)
	    ..q:(finflag="1")&(fyflag'="1")
	    ..q:(finflag'="1")&(fyflag="1")
        ..s pyflag=$p(^DHCPHDISP(phdrow,1),"^",6)
	    ..q:pyflag'=1
	    ..i printflag="1" s printflag="OK"
	    ..s fyflag=$p(^DHCPHDISP(phdrow),"^",4)
	    ..s fydesc=""
	    ..i fyflag="1" s fydesc="OK"
	    ..s callflag=""
	    ..s callflag=$p(^DHCPHDISP(phdrow,1),"^",15) ;phd_retflag as call flag
	    ..i callflag="1" s callflag="已叫"
	    ..s prt=$p(^DHCPHDISP(phdrow),"^",2)
	    ..q:(prt'="")&(SpecialID'="")
	    ..q:(prt="")&(SpecialID="")
	    ..s prescno=$p(^DHCPHDISP(phdrow,2),"^",1)
	    ..q:(prescno'=CPrescNo)&(CPrescNo'="")
	    ..
	    ..s pharow=""
	    ..//s pharow=..GetPhaRowFrPrtPresc(prt,prescno)
	    ..//q:pharow=""
	    ..
	    ..//s nouse=$p(^DHCPHARW(pharow),"^",7)
	    ..//q:nouse="1"
	    ..s prtdate=""
	    ..//s prtdate=+$p(^DHCPHARW(pharow),"^",2)
	    ..s chflag=""
	    ..s pydr="",pyuser="",pycode=""
	    ..s pydr=+$p(^DHCPHDISP(phdrow,1),"^",3)
	    ..i pydr'=0 s pyuser=+$p(^DHCPHPER(pydr),"^",5)
	    ..i pyuser'="" s pycode=$p(^SSU("SSUSR",pyuser),"^",1)
	    ..;s chflag=$p(^DHCPHARW(pha),"^",13)
	    ..;q:chflag="1"
	    ..s arraldr=""
	    ..s papmidr="",papmino="",payamount0=0,phatime=""
	    ..//q:'$d(^DHCINVPRT(prt))
	    ..s prtdate=$zd(prtdate,3)
	    ..s phatime=""
	    ..i prt'="" s phatime=+$p(^DHCINVPRT(prt),"^",20)
	    ..i phatime'="" s phatime=$zt(phatime,3)
	    ..i prt'="" s papmidr=$p(^DHCINVPRT(prt),"^",15)
	    ..s papmidr=##class(web.DHCOutPhCommon).GetPapmiByPresc(prescno)
	    ..q:papmidr=""
	    ..s prtcode=""
	    ..i prt'="" s prtcode=$p(^DHCINVPRT(prt),"^",14)
	    ..s pwcode=""
	    ..//s pwcode=$p(^DHCPHDISP(phdrow,1),"^",8)
	    ..s phaserial=""
	    ..//s phaserial=$p(^DHCPHARW(pharow),"^",12)
	    ..s prtdate="",phadate=""
	    ..i prt'="" s phadate=+$p(^DHCINVPRT(prt),"^",5)
	    ..i phadate'="" s prtdate=$zd(phadate,3)
	    ..//s papmidr=$p(^DHCINVPRT(prt),"^",15)
	    ..//q:papmidr=""
	    ..s prtcode=""
	    ..i prt'="" s prtcode=$p(^DHCINVPRT(prt),"^",14)
	    ..s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	    ..q:(papmino'=CPmiNo)&(CPmiNo'="")
	    ..s patienname=""
	    ..s patienname=$p(^PAPER(papmidr,"ALL"),"^",1)
	    ..q:(patienname'[CPatName)&(CPatName'="")
	    ..s papsexdr="",papsex="",birthday="",difdate="",perold="",patMr="",glord=""
	    ..s papsexdr=+$p(^PAPER(papmidr,"ALL"),"^",7)
	    ..s birthday=+$p(^PAPER(papmidr,"ALL"),"^",6)
	    ..s difdate=sysdate-birthday+1
	    ..s perold=difdate/365
	    ..i perold["." s perold=$p(perold,".",1)
	    ..i papsexdr'="" s papsex=$p(^CT("SEX",papsexdr),"^",2)
	    ..s m=0,p=0,error="",money=0
	    ..s pp=""
	    ..;s pp=##class(web.DHCOutPhDisp).GPerOrd(phl,prt,prescno)
        ..;i pp["^" s money=$p(pp,"^",1),deploc=$p(pp,"&",2),glord=$p(pp,"^",2) 
        ..;e  d
        ..;.s money=$p(pp,"&",1),deploc=$p(pp,"&",2)
        ..s patadm=##class(web.DHCOutPhDisp).getadm(prescno)
        ..
        ..s prescmoney=##class(web.DHCOutPhDisp).GetPrescMoney(patadm,prescno,yflocdr)
	    ..s money=$p(prescmoney,"^",1)
	    ..//s a =b
        ..//q:money=0
	    ..s pp=$fn(money,"",2)
	    ..s pericd="",retval="",syflag=""
	    ..;s retval=##class(web.DHCOutPhDisp).GPerIcd(phl,prt,prescno)
	    ..;s pericd=$p(retval,"&",1)
	    ..;s syflag=$p(retval,"&",2)
	    ..s pericd=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(patadm,",")
	    ..s t=t+1
	    ..;pname,perno,pydate,"",inv,prt,prescno,phdmoney,papsex,perold,pericd
	    ..set Data=$lb(patienname,papmino,prtdate,printflag,fydesc,prtcode,prt,prescno,pp,papsex,perold,pericd,phaserial,pwcode,phdrow,callflag,pycode)
 	    ..Set ^CacheTemp(repid,ind)=Data	
 	    ..Set ind=ind+1
 	    ..;
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryLocPatFYFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocPatFYExecute ]
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

Query QueryLocPatFY(CDateSt As %String, CDateEnd As %String, GPhl As %String, GPhw As %String, CPmiNo As %String, CPatName As %String, cludeflag As %String, CPrescNo As %String, fyflag As %String, SpecialID) As %Query(ROWSPEC = "TPatName:%String,TPmiNo:%String,TPrtDate:%String,TPrintFlag:%String,TFyFlag:%String,TPrtInv:%String,TPrt:%String,TPrescNo:%String,TPrescMoney:%String,TPerSex:%String,TPerAge:%String,TMR:%String,TBoxNum:%String,TSerialNo:%String,phdrow:%String,TCallFlag:%String,TPyCode:%String")
{
}

ClassMethod GetLocPatNum(phl As %String, pydr As %String)
{
 s ll=0,t=0
 f  s t=$o(^DHCTMPLocPat(phl,pydr,t)) q:(t="")!(t=0)  d
   .s ll=t
 q ll
}

ClassMethod GetLocPatList(phl As %String, pydr As %String, m As %String)
{
 s ret=""
 s ret=$g(^DHCTMPLocPat(phl,pydr,m))
 q ret
}

ClassMethod GetUnDispPat(proc, t)
{
  s ret=""
  s ret=$g(^DHCTMPPrintPY(proc,t))
  q ret
}

ClassMethod GetPatOrd(phl As %String, prt As %String, yprescno As %String)
{
	  s reclocdr=""
	  s reclocdr=+$p(^DHCPHLOC(phl),"^",1)
	  k ^DHCPHTMPPERORD(phl,prt,yprescno)
	  k ^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno)
	  s bci="0",t=0
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
	      ..i $d(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,ord,"I",itm))  d
	         ...s $p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,ord,"I",itm),"^",1)=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,ord,"I",itm),"^",1)+qty
	         ...s $p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,ord,"I",itm),"^",2)=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,ord,"I",itm),"^",2)+money
	      ..e  d
	         ...s $p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,ord,"I",itm),"^",1)=qty
	         ...s $p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",prescno,ord,"I",itm),"^",2)=money
	   s ord=""
	   f  s ord=$o(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,ord)) q:ord=""  d
	     .s itm=""
	     .s h=0,glord=""
	     .f  s itm=$o(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,ord,"I",itm)) q:itm=""  d
	       ..s dispqty=0,dispmoney=0,price=0
	       ..s glorditm=""
	       ..s glorditm=$p(^OEORD(ord,"I",itm,11),"^",39)
	       ..;i (glorditm'="")&(glord'=glorditm) s glord=glorditm,h=h+1
	       ..s dispqty=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,ord,"I",itm),"^",1)
	       ..s dispmoney=$p(^DHCPHTMPPRESCNO($j,prt,"PRESCNO",yprescno,ord,"I",itm),"^",2)
	       ..s price=dispmoney/dispqty
	 	   ..s itmmast=""
	       ..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast
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
	    ..s phcdrg="",phcform="",phfact="",ordertype="",ItemCatDR="",factdesc=""
	    ..s phcdrg=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),1),"^",12)
	    ..i phcdrg'=""  d
	    ..s phfact=$p(^PHCD($p(phcdrg,"||",1),2),"^",4)
	    ..i phfact=""  s factdesc="" 
        ..e  d
          ...i '$d(^PHMNF(phfact))  s factdesc="" 
          ...e  s factdesc=$p(^PHMNF(phfact),"^",2)
          ...i factdesc["-" s factdesc=$p(factdesc,"-",2)
	    ..s phbz="",bz=0,bb=0
	    ..s bz=$g(^OEORD(ord,"I",itm,"DEP",0))
	    ..f bb=1:1:bz  d
	      ...s phbz0=""
	      ...s phbz0=$g(^OEORD(ord,"I",itm,"DEP",bb))
	      ...s phbz=phbz_phbz0
	    ..s currdate=""
	    ..s currdate=$p($h,",",1)
	    ..s phuomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
	    ..s skinflag=""
	    ..s skintest=$p(^OEORD(ord,"I",itm,5),"^",2)
	    ..i skintest["Y"  d
	       ...s Abnormal=""
	       ...s Abnormal=$p(^OEORD(ord,"I",itm,11),"^",3)
	       ...i Abnormal["Y"  s skinflag="2"
	       ...i Abnormal["N"  s skinflag="1"
	       ...i Abnormal=""  s skinflag="3"
	    ..s inci=""
	    ..s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
	    ..q:inci=""
	    ..s inci=$p(inci,$c(1),1)
	    ..s manflag="",manrow=""
	    ..s manrow=$o(^DHCPHMCi(reclocdr,inci,manrow))
	    ..i (manrow'="")&(manrow'="0") d 
	      ...s useflag=""
	      ...s useflag=$p(^DHCPHMC(manrow),"^",4)
	      ...i useflag="1"  d
	        ....s mangroup=""
	        ....s mangroup=+$p(^DHCPHMC(manrow),"^",5)
	        ....s manflag=$p(^DHCLMG(mangroup),"^",2)
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
	      ...s newunit=puruom
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
	    ..i phfragdr'="" s phfragdesc=$p($g(^PHCFR(phfragdr)),"^",4)
	    ..s instrdesc=""
	    ..i instrdr'="" s instrdesc=$p($g(^PHCIN(instrdr)),"^",2)
	    ..s orddoctnam=""
	    ..i orduser'="" s orddoctnam=$p(^SSU("SSUSR",orduser),"^",2)
	    ..s doctype=""
	    ..;i orddoctco'=""  s doctype=$p(^CT("CPT",+$p(^CTPCP(orddoctco,1),"^",4)),"^",4)
	    ..s jlflag=""
	    ..;i unitdesc["?" s unitdesc=$p(unitdesc,"?",1) s unitdesc=unitdesc_"?"
	    ..i doseqty<1 s doseqty="0"_doseqty
	    ..s jlflag=doseqty_unitdesc
	    ..i userdoctype'["DOC"  d
	      ...s jlflag="",phfragdesc="",instrdesc="",duratdesc="",orddoctnam="",username=""
	    ..s cc=0,notes=""
	    ..s notes=$p(^OEORD(ord,"I",itm,2),"^",8)
	    ..s oeflag="",inclbid="",disstatu=""
	    ..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",2)       ;????
        ..q:oeflag["停"
        ..i newunitdesc["(" s newunitdesc=$p(newunitdesc,"(",1)
	    ..s newprice=$fn(newprice,"",4)
	    ..s dispmoney=$fn(dispmoney,"",2)
	    ..s t=t+1
	    ..s ^DHCPHTMPPERORD(phl,prt,yprescno,t)=phdesc_"^"_newunitdesc_"^"_qty_"^"_newprice_"^"_dispmoney_"^"_oeflag_"^"_jlflag_"^"_phfragdesc_"^"_instrdesc_"^"_duratdesc_"^"_username_"^"_ord_"||"_itm_"^"_newunit_"^"_yppc_"^"_phgg_"^"_factdesc_"^"_glorditm_"^"_manflag_"^"_skinflag
        ..;set Data=$lb(phdesc,newunitdesc,qty,newprice,dispmoney,oeflag,jlflag,phfragdesc,instrdesc,duratdesc,username,ord_"||"_itm,newunit,yppc,yphw,phtype,phgg,phbz,factdesc,glorditm)
 q t
}

ClassMethod GetPatOrdList(phl As %String, prt As %String, prescno As %String, m As %String)
{
  s ret=""
  s ret=^DHCPHTMPPERORD(phl,prt,prescno,m)
  q ret
}

/// 获取自动发药信息
/// Liang Qiang
ClassMethod GetAutoDispInfo(CDateSt As %Library.String = "", CDateEnd As %Library.String = "", GPhl As %Library.String = "", GPhw As %Library.String = "")
{
	s m=0
	s sysdate=+$h
	s systime=$p($h,",",2)
	s stdate=$zdh(CDateSt,4)
	s enddate=$zdh(CDateEnd,4)
	s phl=GPhl
	s yflocdr=+$p(^DHCPHLOC(phl),"^",1)

	
    f phadate=stdate:1:enddate  d
    .s pha="0"
    .f  s pha=$o(^DHCPHARWi(phadate,phl,pha)) q:(pha="")!(pha="0")  d
    ..s phw="",finflag="",nouse="",printflag="",arrcpdr="",prt="",prescno=""
    ..s phw=+$p(^DHCPHARW(pha),"^",4)
    ..;q:phw'=GPhw
    ..s phwdesc=$p(^DHCPHWIN(phw),"^",1)
    ..s ret=""
    ..s ret=##class(web.DHCOutPhTQDisp).CheckPyFyWin(GPhw,phw)
    ..q:ret=0
    ..s retflag=""
    ..s retflag=$p(^DHCPHARW(pha),"^",13)
    ..q:retflag'="1"
    ..s finflag=$p(^DHCPHARW(pha),"^",6)
    ..q:(finflag="1")
    ..s nouse=$p(^DHCPHARW(pha),"^",7)
    ..q:nouse="1"
    ..s printflag=$p(^DHCPHARW(pha),"^",8)
    ..q:(printflag="1")
    ..s prt=+$p(^DHCPHARW(pha),"^",1)
    ..s prescno=$p(^DHCPHARW(pha),"^",16)
    ..s chkerr=##class(web.DHCOutPhDisp).CheckBeforInsert(prescno,phl)
    ..q:chkerr=1
    ..s chkerr=##class(web.DHCOutPhDisp).CheckBeforUpdate(prescno,phl)
	..q:chkerr=1
    ..s m=m+1
    ..s index=phadate_"^"_phl_"^"_phw_"^"_prt_"^"_prescno
    ..s:$g(pid)="" pid=##CLASS(web.DHCSTKUTIL).GetOutDispCounter()
	..s ^TMPDHCOUTAUTODISP(pid,index)=""


    f orddate=stdate:1:enddate  d
	.s ord=""
	.f  s ord=$o(^OEORDi(0,"LocStDtArr",yflocdr,0,orddate,ord)) q:ord=""  d
	..s chl=""
	..f  s chl=$o(^OEORDi(0,"LocStDtArr",yflocdr,0,orddate,ord,chl)) q:chl=""  d
	...s adm=$p(^OEORD(ord),"^",1) 
	...s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
	...s ordstatus=$p(^OEORD(ord,"I",chl,3),"^",5)
	...s EmLGflag=$p($g(^OEORD(+ord,"I",chl,"DHC")),"^",17)
	... 
	...q:EmLGflag=""
	...s:$g(pid)="" pid=##CLASS(web.DHCSTKUTIL).GetOutDispCounter()
	...s ^TMPPRESCINFO(pid,adm,prescno)=""
	...
	..
	q:$g(pid)="" 0
	s adm="" 
    f  s adm=$o(^TMPPRESCINFO(pid,adm)) q:adm=""  d
    .s prescno=""
    .f  s prescno=$o(^TMPPRESCINFO(pid,adm,prescno)) q:prescno=""  d 
    ..s papmidr=$p(^PAADM(adm),"^",1)
    ..s chkerr=##class(web.DHCOutPhDisp).CheckBeforInsert(prescno,phl)
    ..q:chkerr=1
	..s chkerr=##class(web.DHCOutPhDisp).CheckBeforUpdate(prescno,phl)
	..q:chkerr=1
	..s chkerr=##class(web.DHCOutPhCommon).GetOrdXState(prescno,phl)
	..q:chkerr=1
    ..
    ..s m=m+1
    ..s index=""_"^"_phl_"^"_phw_"^"_""_"^"_prescno
    ..s:$g(pid)="" pid=##CLASS(web.DHCSTKUTIL).GetOutDispCounter()
	..s ^TMPDHCOUTAUTODISP(pid,index)=""
   
    k ^TMPPRESCINFO(pid)
    s ret=m_"^"_pid
	q ret
}

/// 自动配药
ClassMethod InsertPHDispAuto(cyflag, pid, GPhl, GPhw, GPydr, GFydr)
{
	
	s ret=""
	s index=""
	f  s index=$o(^TMPDHCOUTAUTODISP(pid,index)) q:index=""  d
	.s prt=$p(index,"^",4)
	.s prescno=$p(index,"^",5)
	.s phdrow=..InsertPHDisp(prt,GPhl,GPhw,GPydr,GFydr,prescno,"","")
	.i +phdrow>0 d
	..i ret="" d
	...s ret=phdrow
	..e  d
	...s ret=ret_"^"_phdrow
	
	q ret
}

ClassMethod GetCurrBox(pywin)
{
 s boxcode=""
 s boxcode=$p(^DHCPHPYBOX(pywin),"^",2)
 s retval=..UpdatePYBox(boxcode,pywin)
 i (boxcode="")!(boxcode=0) q 1
 q boxcode
}

ClassMethod UpdatePYBox(bcode, pywin)
{
  s totalnum=$p(^DHCPHPYBOX(pywin),"^",1)
  i (bcode="")!(bcode=0)  d
   .s $p(^DHCPHPYBOX(pywin),"^",2)=1
  e  d
   .i bcode'<totalnum  d
    ..s $p(^DHCPHPYBOX(pywin),"^",2)=1
   .e  d
    ..s $p(^DHCPHPYBOX(pywin),"^",2)=bcode+1
 q 0
}

ClassMethod InsertPHDisp(prt As %Library.String = "", phl As %Library.String = "", phw As %Library.String = "", pydr As %Library.String = "", fydr As %Library.String = "", prescno As %Library.String = "", phwpos As %Library.String = "", pyusercode As %Library.String = "")
{
	
	s sysdate="",systime="",phperson=""
	s sysdate=$p($h,",",1)
	s systime=$p($h,",",2)
	i pyusercode'="" s phperson=..GetPhpFrUserCode(pyusercode,phl)
	i phperson'="" s pydr=phperson
	s ctlocdr="" 
	s ctlocdr=+$p(^DHCPHLOC(phl),"^",1)
	s box=0,pharw=""
	s box=..GetCurrBox(phw)
	s pysure=""
	i $d(^GLobDHCPHLOC(phl))  d
	.s pysure=$p(^GLobDHCPHLOC(phl),"^",7)
	
	s chkerr=##class(web.DHCOutPhDisp).CheckNotUse(prt,phl,prescno)
	q:chkerr=1 -1
	s chkerr=##class(web.DHCOutPhDisp).CheckBeforUpdate(prescno,phl)
	q:chkerr=1 -3
	s chkerr=##class(web.DHCOutPhDisp).CheckBeforInsert(prescno,phl,0)
	q:chkerr=1 -2
	s chkerr=##class(web.DHCOutPhCommon).GetOrdXState(prescno,phl)
	q:chkerr=1 -4

    //s insertpresc=""
	//s insertpresc=##class(web.DHCOutPhDisp).GetDSPRowid(prescno,prt)
	//i insertpresc'="" q 0

	s papmidr=""
	s papmidr=##class(web.DHCOutPhCommon).GetPapmiByPresc(prescno)
	i prt'="" s papmidr=$p(^DHCINVPRT(prt),"^",15)
	s phause="",phaok="",winpycode=""
	i prt'="" d
	.s pha=""
	.f  s pha=$o(^DHCPHARi("PRT",prt,pha)) q:pha=""  d
	..s fphldr=""
	..s fphldr=+$p(^DHCPHARW(pha),"^",3)
	..q:fphldr'=phl
	..s phaprescno=""
	..s phaprescno=$p(^DHCPHARW(pha),"^",16)
	..q:phaprescno'=prescno
	..s phause=$p(^DHCPHARW(pha),"^",7)
	..s phaok=$p(^DHCPHARW(pha),"^",6)
	..s pharw=+$p(^DHCPHARW(pha),"^",4)
    .s winpycode=..GetWinDayPyCode(pharw)
    i phause="1" q -9
    i phaok="1" q -10
    //s phdinf=0
    //s phdinf=##class(web.DHCOutPhTQDisp).CheckPrescDsp(prescno,prt)
    //i phdinf'=0 q -1
 
    TSTART
	Set $ZT="troll"
    l +^DHCOEDISPENSING(phl,prescno):5  e  q -50   ;加锁
    
    s chkerr=##class(web.DHCOutPhDisp).CheckNotUse(prt,phl,prescno)
	q:chkerr=1 -1
	s chkerr=##class(web.DHCOutPhDisp).CheckBeforUpdate(prescno,phl)
	q:chkerr=1 -3
	s chkerr=##class(web.DHCOutPhDisp).CheckBeforInsert(prescno,phl,0)
	q:chkerr=1 -2
	s chkerr=##class(web.DHCOutPhCommon).GetOrdXState(prescno,phl)
	q:chkerr=1 -4
     
    s prtflag=1  
	&sql(insert into SQLUSER.dhc_phdispen(phd_prtdate,phd_prt_dr,phd_papmi_dr,phd_phl_dr,
	    phd_phw_dr,phd_pydate,phd_fydate,phd_pytime,phd_fytime,phd_prescno,phd_pattype,phd_serialno,PHD_PRINTFLAG)
	     values(:sysdate,:prt,:papmidr,:phl,:pharw,:sysdate,:sysdate,:systime,:systime,:prescno,:phwpos,:winpycode,:prtflag))
	i SQLCODE'=0 TRo
	i SQLCODE'=0 d unlock
	i SQLCODE q -6
	s phdrow=""
	s phdrow=+$g(%ROWID)
	i pysure'="1"  d
	.s $p(^DHCPHDISP(phdrow,1),"^",6)="1"
	.s $p(^DHCPHDISP(phdrow,1),"^",3)=pydr
	;  
	s insubsuess=0  
	s m=0
	s ord=""
    f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:(ord="")!(insubsuess'=0)  d
    .s itm=""
    .f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:(itm="")!(insubsuess'=0)  d
    ..s oeori=ord_"||"_itm
    ..s OEPrescNo=$p(^OEORD(ord,"I",itm,1),"^",14)
    ..q:prescno'=OEPrescNo
    ..s reclocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
    ..q:ctlocdr'=reclocdr
    ..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)                                     
    ..q:(oeflag'="V")&(oeflag'="E")
    ..s priority=$p(^OEORD(ord,"I",itm,1),"^",8)    
	..s priordesc=""
	..i priority'="" s priordesc=$p(^OECPR(priority),"^",2)
	..q:priordesc["自备"
	..s qty=0,money=0
	..s qty=##class(web.DHCOutPhDisp).getDspQty(oeori)
	..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
	..s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),""))
	..i prt="" d
	...s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(ctlocdr)
    ...s hospdr=$p(HospString,"^",1)
	...//s spice=##class(web.DHCSTCOMMONSRV).GetPriceElse(+inci,+$h,"",hospdr)
	...s exStr=oeori_"^"
	...s price=##class(web.DHCSTPRICE).GetSp(+inci,+$h,"",hospdr,"",exStr)	//zhouyg 20150113
	...s money=spice*qty
	..e  d
    ...s ordpriceinfo=##class(web.DHCOutPhCommon).GetBasPriceByInv(prt,oeori)
	...s spice=$p(ordpriceinfo,"^",1)
	...s money=$p(ordpriceinfo,"^",2)
	..s ch=$o(^INCI("IL_LOC",ctlocdr,inci,""))
    ..s incil=inci_"||"_ch
    ..s inciQty=##class(web.DHCSTSTKQTY).GetPhaQty(incil,qty)
    ..i inciQty=0 TRo
    ..i inciQty=0 s insubsuess=10
    ..q:inciQty=0
	..s m=m+1  
	..&sql(insert into SQLUSER.DHC_PHDISITEM(phdi_phd_parref,phdi_childsub,phdi_qty,phdi_payamount,phdi_oeori_dr) 
	             values(:phdrow,:m,:qty,:money,:oeori))
	..i SQLCODE'=0 s insubsuess=insubsuess+1
	..i SQLCODE'=0 Tro
	i insubsuess'=0 d unlock
	q:insubsuess=10 -7
	q:insubsuess'=0 -8
	i prt="" d unlock
	i prt="" TCOMMIT
	q:prt="" phdrow 
	//
	s phaid=""
	f  s phaid=$o(^DHCPHARi("PRT",prt,phaid)) q:(phaid="")!(insubsuess'=0)  d
	.s phldr="",phwdr=""
	.s phldr=+$p(^DHCPHARW(phaid),"^",3)
	.q:phldr'=phl
	.s phwdr=+$p(^DHCPHARW(phaid),"^",4)
	.;q:phwdr'=phw
	.s phaprescno=""
	.s phaprescno=$p(^DHCPHARW(phaid),"^",16)
	.q:phaprescno'=prescno
	.s $p(^DHCPHARW(phaid),"^",8)="1"
	.s $p(^DHCPHARW(phaid),"^",11)=sysdate
	.s $p(^DHCPHARW(phaid),"^",12)=box
	   
    /*
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
	   ...q:recplocdr=""
	   ...q:recplocdr'=ctlocdr 
	   ...s dispflag=$p($g(^OEORD(ord,"I",itm,6)),"^",7)
	   ...s invprescno=$p(^OEORD(ord,"I",itm,1),"^",14)
	   ...q:invprescno=""
	   ...q:invprescno'=prescno
	   ...s qty=0,money=0
	   ...s qty=+$p(^DHCPB(patbill,"O",patbillsub),"^",5)
	   ...q:qty=0
	   ...s money=+$p(^DHCPB(patbill,"O",patbillsub),"^",8)
	   ...q:(dispflag="1")
	   ...s m=m+1
	   ...&sql(insert into SQLUSER.DHC_PHDISITEM(phdi_phd_parref,phdi_childsub,phdi_qty,phdi_payamount,phdi_oeori_dr) 
	             values(:phdrow,:m,:qty,:money,:orditm))
	   ...i SQLCODE'=0 s insubsuess=insubsuess+1
	   ...i SQLCODE'=0 Tro
       i insubsuess'=0 q -1
       
   */
   
   TCOMMIT
   d unlock
   q phdrow
   
unlock
   l -^DHCOEDISPENSING(phl,prescno)
   q
   
troll
   Set $ZT=""
   TRo
   l -^DHCOEDISPENSING(phl,prescno)
   s ErrorMsg=$ZE
   q ErrorMsg
}

ClassMethod UpdatePyd(prt As %Library.String = "", phl As %Library.String = "", fydr As %Library.String = "", prescno As %Library.String = "", pycode As %Library.String = "")
{
	s currdate=$p($h,",",1)
	s currtime=$p($h,",",2)
	s ctloc=+$P(^DHCPHLOC(phl),"^",1)
	s pycode=$ZCVT(pycode,"U")
	s pydr=""
	i pycode'=""  d
	  .s pyuserowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",pycode,""))
	  .s uppydr="",pydr=""
   	  .f  s uppydr=$o(^DHCPHPERi("USR",pyuserowid,uppydr)) q:uppydr=""  d
  	    ..s pyloc=""
  	    ..s pyloc=+$p(^DHCPHPER(uppydr),"^",3)
  	    ..q:pyloc'=phl
  	    ..s pydr=uppydr
  	s prtflag=""
  	s prtflag=$p(^DHCINVPRT(prt),"^",8)
  	i prtflag="A" q -1
	s send=$p(^GLobDHCPHLOC(phl),"^",1)
	s pyusr="",shusr="",prescok=0
	s cyflag=""
	s cyflag=$p(^DHCPHLOC(phl),"^",6)
	s prescok=..CheckPhdPY(prescno,prt)
	i prescok=0 q -1
	s ssusr=""
	i fydr="" q -1
	s ssusr=+$p(^DHCPHPER(fydr),"^",5)
	s phdisprowid=""
    TSTART
    
   	s phaid=""
   	f  s phaid=$o(^DHCPHARi("PRT",prt,phaid)) q:phaid=""  d
	   .s phldr="",phwdr=""
	   .s phldr=+$p(^DHCPHARW(phaid),"^",3)
	   .q:phldr'=phl
	   .s phaprescno=""
	   .s phaprescno=$p(^DHCPHARW(phaid),"^",16)
	   .q:phaprescno'=prescno
	   .s $p(^DHCPHARW(phaid),"^",6)="1"
    
	s phdrow="",pharow="",ret="",suess=0
	f  s phdrow=$o(^DHCPHDISPi("PRT",phl,prt,phdrow)) q:(phdrow="")!(suess'=0)  d
	  .s phdprescno=""
	  .s phdprescno=$p(^DHCPHDISP(phdrow,2),"^",1)
	  .q:phdprescno'=prescno
	  .
	  .s $p(^DHCPHDISP(phdrow),"^",4)="1"
	  .s $p(^DHCPHDISP(phdrow),"^",5)=currtime
	  .s $p(^DHCPHDISP(phdrow,1),"^",2)=fydr
	  .&sql(update dhc_phdispen set phd_fydate=:currdate where phd_rowid=:phdrow)
      .s chpresckc=0
	  .s chpresckc=##class(web.DHCOutPhDisp).CheckPhdKC(phdrow)
	  .i chpresckc'=0  d
	  ..TRo
	  ..s suess=suess+1
	  ..
	  .q:chpresckc'=0

	  .i pydr'="" s $p(^DHCPHDISP(phdrow,1),"^",3)=pydr
	  .s phdisprowid=phdrow
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
	    ..s pointer=""
	    ..s pointer=phdrow_"||"_phdsub 
	    ..&sql(update sqluser.dhc_oedispensing set dsp_pointer=:pointer,dsp_type='F',dsp_status='C',dsp_date=:currdate,dsp_time=:currtime where dsp_oeori_dr=:oeori )
	    ..i SQLCODE'=0 d
	    ...Tro
	    ...s suess=suess+1
	    ..i cyflag="1"  d
	      ...s $p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",9)=fs
	    ..s itmmast="",puruom="",basuom="",inci=""
	    ..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2) 
	    ..s puruom=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),8),"^",14)
	    ..s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),inci))
	    ..q:inci=""
	    ..s basuom=+$p(^INCI(inci,1),"^",10)
	    ..s parowid=""
	    ..s parowid=phdrow_"||"_phdsub
	    ..k ^TMPGETCLB($j)
	    ..d ##CLASS(web.DHCOutPhDisp).GInclb(inci,qty,ctloc)
	    ..s ret=0
	    ..s ret=##CLASS(web.DHCOutPhDisp).InsertPhdisItmClb(parowid)
	    ..i ret'=0  d
	    ...TRo
	    ...s suess=suess+1
	    ..;d ##CLASS(web.DHCOutPhModCZ).ModPhdispitm(parowid,ssusr)
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
          .... s suess=suess+1
      
   
   i suess'=0 q -1  
   e  d
    .TCOMMIT
   ;Send Message to LK system
   ;"1" 利康药房
   ;"2" 精神药房
   ;i send="1"  d
   ;    .s lstream=##class(web.DHCOutPhInterFace).PutMessagePharmacy("1",phdisprowid)
   ;    .s soap=##class(web.PhaServiceSoap).%New()
   ;    .d soap.Phamarcy(lstream)
 
   q 0
}

ClassMethod CheckGlobScreen(ctloc As %Library.String = "")
{
  s ret=""
  i '$d(^DHCScreenForPharmacy(ctloc)) s ret=""
  e  d
    .s ret=$g(^DHCScreenForPharmacy(ctloc))
  q ret
}

ClassMethod GetGlobScreen(ctloc As %Library.String = "")
{
  s ret=""
  s ret=$g(^DHCScreenForPharmacy(ctloc))
  q ret
}

ClassMethod InsertPyScreen(ctloc, pmi, pername, prt, presc, windesc, roomtype)
{
  s ret="",phl="",phd=""
  s sysdate=+$h
  s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
  i phl="" q -2
  s phpd=""
  f  s phpd=$o(^DHCPHDISPi("PRT",phl,prt,phpd)) q:phpd=""  d
    .s phpresc=""
    .s phpresc=$p(^DHCPHDISP(phpd,2),"^",1)
    .q:phpresc'=presc
    .s phd=phpd
   ;&sql(insert into sqluser.dhc_phpyscreen(phpy_pername,phpy_pmino,phpy_window,phpy_date,phpy_phd_dr,phpy_phl_dr,phpy_roomtype)
   ; values(:pername,:pmi,:windesc,:sysdate,:phd,:phl,:roomtype))
  s ret=SQLCODE
  q ret
}

ClassMethod InsertFyScreen(ctloc, pmi, pername, prt, presc, windesc, roomtype)
{
  s ret="",phl="",phd=""
  s sysdate=+$h
  s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
  i phl="" q -2
  s phpd=""
  f  s phpd=$o(^DHCPHDISPi("PRT",phl,prt,phpd)) q:phpd=""  d
    .s phpresc=""
    .s phpresc=$p(^DHCPHDISP(phpd,2),"^",1)
    .q:phpresc'=presc
    .s phd=phpd
  ;&sql(insert into sqluser.dhc_phfyscreen(phfy_pername,phfy_pmino,phfy_window,phfy_date,phfy_phd_dr,phfy_phl_dr,phfy_roomtype)
   ; values(:pername,:pmi,:windesc,:sysdate,:phd,:phl,:roomtype))
 ; s ret=SQLCODE
  q ret
}

ClassMethod GetSureWin(ctloc As %Library.String = "", userid As %Library.String = "", winip As %Library.String = "")
{
 s phl="",ret="0",pk=0
 s phl=$o(^DHCPHLOCi("LOC",ctloc,"")) 	
 i phl="" s ret="-1" q ret
 s byfs="",windesc="",phw="",pk=0,winid="",phperson=""
 s byfs=$p(^DHCPHLOC(phl),"^",5)
 s php=""
 f  s php=$o(^DHCPHPERi("USR",userid,php)) q:php=""  d
   .s phpl=""
   .s phpl=+$p(^DHCPHPER(php),"^",3)
   .q:phpl'=phl
   .s phperson=php
 i phperson="" q ret
 f  s phw=$o(^DHCPHWINi("WIN",phl,phw)) q:(phw="")!(pk=1)  d
   .s sureflag="",ip=""
   .s sureflag=$p(^DHCPHWIN(phw),"^",3)
   .i $d(^DHCGlobPhFYWIN(phw)) s ip=$p($g(^DHCGlobPhFYWIN(phw)),"^",1)
   .q:(ip'=winip)&(winip'="")
   .;q:(sureflag'="1")&(winip="")
   .s pk=pk+1
   .s windesc=$p(^DHCPHWIN(phw),"^",1)
   .s winid=phw
   .s ret=windesc_"^"_winid_"^"_phl_"^"_phperson
 s phw=""
 i pk=0  d
   . f  s phw=$o(^DHCPHWINi("WIN",phl,phw)) q:(phw="")  d
   ..s sureflag="",ip=""
   ..s sureflag=$p(^DHCPHWIN(phw),"^",3)
   ..q:sureflag'="1"
   ..s windesc=$p(^DHCPHWIN(phw),"^",1)
   ..s winid=phw
   ..s ret=windesc_"^"_winid_"^"_phl_"^"_phperson
 q ret
}

ClassMethod GetSurePYWin(ctloc As %Library.String = "", userid As %Library.String = "", winip As %Library.String = "")
{
 s phl="",ret="0"
 s phl=$o(^DHCPHLOCi("LOC",ctloc,"")) 	
 i phl="" s ret="-1" q ret
 s byfs="",windesc="",phw="",pk=0,winid="",phperson=""
 s byfs=$p(^DHCPHLOC(phl),"^",5)
 s php=""
 f  s php=$o(^DHCPHPERi("USR",userid,php)) q:php=""  d
   .s phpl=""
   .s phpl=+$p(^DHCPHPER(php),"^",3)
   .q:phpl'=phl
   .s phperson=php
 i phperson="" q ret
 f  s phw=$o(^DHCPHPYi("LOC",phl,phw)) q:(phw="")!(pk=1)  d
   .s sureflag="",ip=""
   .i $d(^DHCGlobPhPYWIN(phw)) s ip=$p($g(^DHCGlobPhPYWIN(phw)),"^",1)
   .q:ip'=winip
   .s windesc=$p(^DHCPHPY(phw),"^",1)
   .s winid=phw
   .s ret=windesc_"^"_winid_"^"_phl_"^"_phperson
 q ret
}

ClassMethod GZhuShCS(prt As %Library.String = "")
{
   s bci="0",mricd="",byzscs=""
   f  s bci=$o(^DHCBCI(0,"INV",prt,bci)) q:(bci="")!(bci="0")!(byzscs="")  d
    .s patbill=""
    .s patbill=+$p(^DHCBCI(bci),"^",2)
    .s patbillsub="0"
    .f  s patbillsub=$o(^DHCPB(patbill,"O",patbillsub)) q:(patbillsub="")!(patbillsub="")  d
      ..s orditm="",ord="",itm="",dispflag="",prescno=""
      ..s orditm=$p(^DHCPB(patbill,"O",patbillsub),"^",4)
      ..s ord=$p(orditm,"||",1),itm=$p(orditm,"||",2)
      ..s itmmast="",itmcat="",itmcatdesc=""
      ..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
      ..s itmcat=+$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),1),"^",10)
      ..s itmcatdesc=$p(^ARC("IC",itmcat),"^",2)
      ..s qty=0,money=0
      ..s qty=+$p(^DHCPB(patbill,"O",patbillsub),"^",5)
      ..i (itmcatdesc["注射")&(byzscs="") s byzscs=qty
    q byzscs
}

ClassMethod CheckPy(ctloc, userid, flag)
{
  s phl="",ret="0"
  s phl=$o(^DHCPHLOCi("LOC",ctloc,"")) 
  i phl="" s ret="-1" q ret
  s php=""
  f  s php=$o(^DHCPHPERi("USR",userid,php)) q:php=""  d
    .s pyflag="",fyflag=""
    .s phpl=""
    .s phpl=+$p(^DHCPHPER(php),"^",3)
    .q:phpl'=phl
    .s pyflag=$p(^DHCPHPER(php),"^",6)
    .s fyflag=$p(^DHCPHPER(php),"^",1)
    .i (pyflag'="1")&(flag=1) s ret="-1"
    .i (fyflag'="1")&(flag=2) s ret="-1"
  q ret
}

ClassMethod GetPyWin(ctloc As %String)
{
 	s ret=""
 	s phl=""
 	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
 	i phl="" q ""
	set phpw="0"
	f  s phpw=$o(^DHCPHPYi("LOC",phl,phpw)) q:(phpw="0")!(phpw="")  d
	     .s phwdesc="",useflag=""
	     .s phwdesc=$p(^DHCPHPY(phpw),"^",1)
         .set Data=$lb(phwdesc,phpw)
         .i ret'="" s ret=ret_"^"_phpw_$c(1)_phwdesc
         .e  s ret=phpw_$c(1)_phwdesc
 	 q ret
}

ClassMethod GetPyWinClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetPyWinExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetPyWinExecute(ByRef QHandle As %Binary, ctloc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s phl=""
 	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl=""  Set QHandle=$lb(0,repid,0) Quit $$$OK
	s ind=1
	set phpw="0"
	f  s phpw=$o(^DHCPHPYi("LOC",phl,phpw)) q:(phpw="0")!(phpw="")  d
	     .s phwdesc="",useflag=""
	     .s phwdesc=$p(^DHCPHPY(phpw),"^",1)
         .set Data=$lb(phwdesc,phpw)
         .Set ^CacheTemp(repid,ind)=Data	
 	     .Set ind=ind+1
 	Set QHandle=$lb(0,repid,0)
 	
	Quit $$$OK
}

ClassMethod GetPyWinFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPyWinExecute ]
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

Query GetPyWin(ctloc As %String) As %Query(ROWSPEC = "配药窗口:%String,ID:%String") [ SqlProc ]
{
}

ClassMethod UpdatePhWin(ctloc As %Library.String = "", pyusr As %Library.String = "", pywin As %Library.String = "")
{
   s phl="",ret="",sysdate=""
   s sysdate=$zd(+$h,4)
   s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
   s locdesc=$p(^CTLOC(ctloc),"^",2)
   i locdesc["-" s locdesc=$p(locdesc,"-",2)
   s pydr="",pyname=""

   s phper="0"
   f  s phper=$o(^DHCPHPERi("USR",pyusr,phper)) q:(phper="")!(phper="0")  d
     .s phpl=""
     .s phpl=$p(^DHCPHPER(phper),"^",3)
     .q:phpl'=phl
     .s pydr=phper
   i (phl="")!(pydr="") s ret="" 
   e  d 
     .s phwp=""
     .
     .&sql(update sqluser.dhc_phpywin set phpy_doflag='1' where phpy_rowid=:pywin)
     .i SQLCODE'=0 d
     ..&sql(update sqluser.dhc_phwper set phwp_doflag='1' where phwp_phw_dr=:pywin)
     .s ret=phl_"^"_pydr
     .
  q ret
}

ClassMethod GDescFrid(itmjs As %Library.String = "", itmjsex As %Library.String = "", phl As %Library.String = "", phw As %Library.String = "", pydr As %Library.String = "", fydr As %Library.String = "", wincode As %Library.String = "")
{
   s ret="",ctloc="",ctlocdesc="",phwdesc="",pyname="",fyname="",winposdesc=""
   s ctloc=+$p(^DHCPHLOC(phl),"^",1)
   s ctlocdesc=$p(^CTLOC(ctloc),"^",2)
   i ctlocdesc["-" s ctlocdesc=$p(ctlocdesc,"-",2)
   s phwdesc=$p(^DHCPHPY(phw),"^",1)
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

ClassMethod GetPhpFrUserCode(usercode, ctloc)
{
  s phloc=$o(^DHCPHLOCi("LOC",ctloc,""))
  s userrow="",phprow="",ret=""
  s usercode=$ZCVT(usercode,"U")
  s userrow=$o(^SSU("SSUSR",0,"SSUSR_Initials",usercode,""))

  i userrow="" q ""
  f  s phprow=$o(^DHCPHPERi("USR",userrow,phprow)) q:phprow=""  d
    .s phploc=""
    .s phploc=+$p(^DHCPHPER(phprow),"^",3)
    .q:phploc'=phloc
    .s ret=phprow
  q ret
}

ClassMethod CheckPyUser(usercode, ctloc)
{
  s phloc=$o(^DHCPHLOCi("LOC",ctloc,""))
  s userrow="",phprow="",ret=""
  s userrow=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))

  i userrow="" q -1
  f  s phprow=$o(^DHCPHPERi("USR",userrow,phprow)) q:phprow=""  d
    .s phploc=""
    .s phploc=+$p(^DHCPHPER(phprow),"^",3)
    .q:phploc'=phloc
    .s ret=phprow
  i ret="" q -2
  q 0
}

ClassMethod GetCurrPrint(phl, pywin, presctype)
{
  ;	s ^DHCPYPRINTDEF(phl,pywin,prowid)=printname_"^"_curflag_"^"_useflag
  s mob="",ret=""
  s printrow="",printname="",tsprintname="",curprintname="",curprintrow="",firstprint=""
  f  s printrow=$o(^DHCPYPRINTDEF(phl,pywin,printrow)) q:printrow=""  d
   .s pname="",curflag="",usflag=""
   .s pname=$P(^DHCPYPRINTDEF(phl,pywin,printrow),"^",1)
   .s curflag=$P(^DHCPYPRINTDEF(phl,pywin,printrow),"^",2)
   .s usflag=$P(^DHCPYPRINTDEF(phl,pywin,printrow),"^",3)
   .i usflag="1"  s tsprintname=pname
   .i (curflag="1")&(presctype'="1")  d
   ..s curprintname=pname
   ..s curprintrow=$p(pname,"Print",2)
   ..s $P(^DHCPYPRINTDEF(phl,pywin,printrow),"^",2)=""
  i presctype="1" d
    .s ret=curprintrow_"^"_tsprintname
  e  d
    .s ret=curprintrow_"^"_curprintname
    .s nextrow="",prow=curprintrow
    .s qt=0
    .f  s prow=$o(^DHCPYPRINTDEF(phl,pywin,prow)) q:(prow="")!(qt'=0)  d
     ..s usflag=""
     ..s usflag=$P(^DHCPYPRINTDEF(phl,pywin,prow),"^",3)
     ..q:usflag="1"
     ..s qt=qt+1
     ..s nextrow=prow
    .i nextrow=""  d
      ..s row="",pt=0
      ..f  s row=$o(^DHCPYPRINTDEF(phl,pywin,row)) q:(row="")!(pt'=0)  d
       ...s usflag=""
       ...s usflag=$P(^DHCPYPRINTDEF(phl,pywin,row),"^",3)
       ...q:usflag="1"
       ...s pt=pt+1
       ...s nextrow=row
     .s $P(^DHCPYPRINTDEF(phl,pywin,nextrow),"^",2)="1"
    i $p(ret,"^",1)="" s ret=..GetCurrPrint(phl, pywin, presctype)
  q ret
}

ClassMethod CheckPyCode(usercode, ctloc)
{
	s userrow="",phl="",mp=0
	i usercode="" q -1
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	s usercode=$ZCVT(usercode,"U")
  	s userrow=$o(^SSU("SSUSR",0,"SSUSR_Initials",usercode,""))
  	i userrow="" q -1
  	s pydr="" 
  	f  s pydr=$o(^DHCPHPERi("USR",userrow,pydr)) q:pydr=""  d
  	  .s pyloc=""
  	  .s pyloc=+$p(^DHCPHPER(pydr),"^",3)
  	  .q:pyloc'=phl
  	  .s mp=mp+1
  	i mp=0 q -1
  	q 0
}

ClassMethod GetPrtBox(phl, prt, presc)
{
  s pha="",serial=""
  f  s pha=$o(^DHCPHARi("PRT",prt,pha)) q:pha=""  d
   .s phapresc=""
   .s phapresc=$p(^DHCPHARW(pha),"^",16)
   .q:phapresc'=presc
   .s serial=$p(^DHCPHARW(pha),"^",12)
 q serial
}

ClassMethod CheckCall(ctloc)
{
	s phl="",ret=0
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl="" q -1
	s callflag=$p($g(^GLobDHCPHLOC(phl)),"^",4)
	s ret=callflag
	q ret
}

ClassMethod GetDispFileName(phl)
{
  s ret=""
  i $g(^DHCGlobCallCode(+$h,phl))=99  d
    .s ^DHCGlobCallCode(+$h,phl)=0
  i $d(^DHCGlobCallCode(+$h,phl))  d
    .s ^DHCGlobCallCode(+$h,phl)=$g(^DHCGlobCallCode(+$h,phl))+1
  e  d
    .s ^DHCGlobCallCode(+$h,phl)=1
  s ret=$g(^DHCGlobCallCode(+$h,phl))
  q ret
}

ClassMethod GetScreenPath(phl)
{
	s callpath=""
	s callpath=$p($g(^GLobDHCPHLOC(phl)),"^",5)
	
	q callpath
}

ClassMethod GetWinDayPyCode(win)
{
	s retcode=0
	i $d(^DHCTMPDAYPHWIN(+$h,win)) d
	  .s retcode=$g(^DHCTMPDAYPHWIN(+$h,win))+1
	  .s ^DHCTMPDAYPHWIN(+$h,win)=retcode
	e  d
	  .s ^DHCTMPDAYPHWIN(+$h,win)=1
	  .s retcode=1
  q retcode
}

ClassMethod UpdatePhdCall(phdrow)
{
  q:$g(phdrow)="" -1
  ;s $p(^DHCPHDISP(phdrow,1),"^",15)=1
  &sql(update dhc_phdispen set phd_retflag='1' where phd_rowid=:phdrow)
 ;q 0
  q SQLCODE
}

ClassMethod CheckDispUse(phl, prt, presc)
{
	s phdrow="",fyflag=""
	f  s phdrow=$o(^DHCPHDISPi("PRT",phl,prt,phdrow)) q:phdrow=""  d
	  .s phdpresc=""
	  .s phdpresc=$p(^DHCPHDISP(phdrow,2),"^",1)
	  .q:phdpresc'=presc
	  .s fyflag=$p(^DHCPHDISP(phdrow),"^",4)
	s useflag=""
	s useflag=$p(^DHCINVPRT(prt),"^",8)
	i useflag["A" q -1
	i fyflag="1" q -2
	q 0
}

ClassMethod ModifyPha(prt, presc)
{
  i prt="" q -1
  i presc="" q -1	
  s pha=""
  f  s pha=$o(^DHCPHARi("PRT",prt,pha)) q:pha=""  d
    .s phapresc=""
    .s phapresc=$p(^DHCPHARW(pha),"^",16)
    .q:phapresc'=presc
    .s $p(^DHCPHARW(pha),"^",13)="1"
  q 0
}

ClassMethod CheckPrintTitle(ctloc)
{
	s ret=""
	s phl=""
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl="" q ""
	i $d(^GLobDHCPHLOC(phl))  d
	  .s ret=$p(^GLobDHCPHLOC(phl),"^",2)
	q ret
}

ClassMethod CheckPT(ctloc, yfdesc)
{
	s ret=0
	i '$d(^DHCGLobIntrLoc("LOC",ctloc))  q 0
	set yfcoderow="0"
	f  s yfcoderow=$o(^DHCGLobIntrLoc("LOC",ctloc,yfcoderow)) q:(yfcoderow="0")!(yfcoderow="")!(ret=1)  d
	   .s intrdesc="",intr="",boxnum=0
	   .s intrdesc=$p(^DHCGLobIntrLoc("LOC",ctloc,yfcoderow),"^",1)
	   .q:intrdesc'=yfdesc
	   .s ret=ret+1
	q ret
}

ClassMethod GetPhdRowid(prtinv, ctloc)
{
  s phl=""
  s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
  s cyflag=""
  s cyflag=$p(^DHCPHLOC(phl),"^",6)
  s retval=0
 ; i cyflag="1"  {
	s prescno=prtinv
  s qrow=""
  s qrow=$o(^PAQUE1(0,"PrescNo",prescno,""))
  i qrow="" q 0
  s phdrow=""
  f  s phdrow=$o(^DHCPHDISPi("PRESCNO",prescno,phdrow)) q:phdrow=""  d
    .s pyflag="",fyflag=""
    .s pyflag=$p(^DHCPHDISP(phdrow,1),"^",6)
    .s fyflag=$p(^DHCPHDISP(phdrow),"^",4)
    .q:pyflag="1" 
    .s phdprt=""
	.s phdprt=+$p(^DHCPHDISP(phdrow),"^",2)
	.q:'$d(^DHCINVPRT(phdprt))
    .s prtuseflag=""
    .i phdprt'=0 s prtuseflag=$p(^DHCINVPRT(phdprt),"^",8)
    .q:prtuseflag'["N" 
    .s retval=phdrow
  ;  }
  ; else
  ; {
 ;	     s prt=""
  ;  s prt=$o(^DHCINVPRT(0,"INV",prtinv,""))
  ;  s retval=prt

  ; }

 q retval
}

ClassMethod GetPydr(usercode, ctloc)
{
   s userid=""
   i usercode="" q 0
   s usercode=$ZCVT(usercode,"U")
    s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",usercode,""))
    i userid="" q 0
    s phl=""
    s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
    i phl="" q 0
    s phprow="",retphp=""
    f  s phprow=$o(^DHCPHPERi("USR",userid,phprow)) q:phprow=""  d
      .s phpl=""
      .s phpl=+$p(^DHCPHPER(phprow),"^",3)
      .q:phpl'=phl
      .s retphp=phprow
    i retphp="" q 0
    q retphp
}

ClassMethod UpdatePhdRowid(phd, ctloc, pydr)
{
    s phl=$o(^DHCPHLOCi("LOC",ctloc,"")) 
    s cyflag="",prt=""
    
    s cyflag=$p(^DHCPHLOC(phl),"^",6)
  
	 &sql(update dhc_phdispen set phd_php_pydr=:pydr,phd_pyflag='1' where phd_rowid=:phd)  
  
  q 0
}

ClassMethod UpdatePhdFrFY(prescno, usercode, phl)
{
  s userid=""
  i usercode="" q -1
  s userocde=$ZCVT(usercode,"U")
  s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",userocde,userid))	
  i userid="" q -1
  s currphd=""
  i prescno="" q -1
  s currphd=..GetPhdRowFrPresc(prescno)
  i currphd="" q -1
  s pydr="",retpy=""
  f  s pydr=$o(^DHCPHPERi("USR",userid,pydr)) q:pydr=""  d
  .s pyloc=""
  .s pyloc=+$p(^DHCPHPER(pydr),"^",3)
  .q:pyloc'=phl
  .s retpy=pydr
 &sql(update sqluser.dhc_phdispen set phd_pyflag='1' ,phd_php_pydr=:retpy where phd_rowid=:currphd)
 q SQLCODE
}

ClassMethod GetPhdRowFrPresc(prescno)
{
	s phdrow="",retphd=""
	f  s phdrow=$o(^DHCPHDISPi("PRESCNO",prescno,phdrow)) q:phdrow=""  d
	  .s phdprt=""
	  .s phdprt=+$p(^DHCPHDISP(phdrow),"^",2)
	  .s prtuseflag=""
	  .i phdprt'=0 s prtuseflag=$p($g(^DHCINVPRT(phdprt)),"^",8)
	  .q:prtuseflag'["N" 
	  .s retphd=phdrow
	q retphd
}

ClassMethod GetUserCode(prescno)
{
	s phdrow="",ret=""
	i prescno="" q ""
	f  s phdrow=$o(^DHCPHDISPi("PRESCNO",prescno,phdrow)) q:phdrow=""  d
	.s pydr="",pyuser="",usercode="",prt="",prtflag=""
	.s pydr=+$p(^DHCPHDISP(phdrow,1),"^",3)
	.i pydr'=0  s pyuser=+$p(^DHCPHPER(pydr),"^",5)
	.i pydr'=0 s usercode=$p( ^SSU("SSUSR",pyuser),"^",1)
	.s prt=+$p(^DHCPHDISP(phdrow),"^",2)
	.i prt'=0  s prtflag=$p(^DHCINVPRT(prt),"^",8)
	.q:prtflag'["N"
	.s ret=usercode
 q ret
}

ClassMethod QueryLocPatZFClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocPatZFExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryLocPatZFExecute(ByRef QHandle As %Binary, GPhl As %Library.String = "", GPhw As %Library.String = "", cludeflag As %Library.String = "") As %Status
{
 Set repid=$I(^CacheTemp)
	s ind=1
	s phl="",userid="",t=0
	s sysdate=+$h
    s phl=GPhl
	i (phl="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s stdate=+$h
	s enddate=+$h
	s yflocdr=+$p(^DHCPHLOC(phl),"^",1)
	s phpydate=""
	f phpydate=stdate:1:enddate  d  
	  .s phdrow=0
	  .f  s phdrow=$o(^DHCPHDISPi(phpydate,phl,phdrow)) q:(phdrow="")!(phdrow="0")  d
        ..s phw="",finflag="",nouse="",printflag="",arrcpdr="",prt="",prescno=""
        ..s phadate=0
	    ..s phw=+$p(^DHCPHDISP(phdrow,1),"^",4)
	    ..q:(phw'=GPhw)&(cludeflag'="1")
	    ..s finflag=$p(^DHCPHDISP(phdrow),"^",4)
	    ..q:(finflag="1")
        ..s printflag=$p(^DHCPHDISP(phdrow,1),"^",6)
	    ..;q:printflag'="1
	    ..i printflag="1" s printflag="OK"
	    ..s callflag=""
	    ..s callflag=$p(^DHCPHDISP(phdrow,1),"^",15) ;phd_retflag as call flag
	    ..i callflag="1" s callflag="已叫"
	    ..s prt=+$p(^DHCPHDISP(phdrow),"^",2)
	    ..s prescno=$p(^DHCPHDISP(phdrow,2),"^",1)
	    ..;q:(prescno'=CPrescNo)&(CPrescNo'="")
	    ..s pharow=""
	    ..s pharow=..GetPhaRowFrPrtPresc(prt,prescno)
	    ..q:pharow=""
	    ..s nouse=$p(^DHCPHARW(pharow),"^",7)
	    ..q:nouse'="1"
	    ..q:$d(^DHCTMPPharmacyZF(phdrow))
	    ..s prtdate=""
	    ..s prtdate=+$p(^DHCPHARW(pharow),"^",2)
	    ..s pydr="",pyuser="",pyname=""
	    ..s pydr=+$p(^DHCPHDISP(phdrow,1),"^",3)
	    ..i pydr'=0 s pyuser=+$p(^DHCPHPER(pydr),"^",5)
	    ..i pyuser'="" s pyname=$p(^SSU("SSUSR",pyuser),"^",2)
	    ..s chflag=""
	    ..;s chflag=$p(^DHCPHARW(pha),"^",13)
	    ..;q:chflag="1"
	    ..s arraldr=""
	    ..s papmidr="",papmino="",payamount0=0,phatime=""
	    ..q:'$d(^DHCINVPRT(prt))
	    ..s prtdate=$zd(prtdate,3)
	    ..s phatime=+$p(^DHCINVPRT(prt),"^",20)
	    ..s phatime=$zt(phatime,3)
	    ..s papmidr=$p(^DHCINVPRT(prt),"^",15)
	    ..q:papmidr=""
	    ..s prtcode=""
	    ..s prtcode=$p(^DHCINVPRT(prt),"^",14)
	    ..s pwcode=""
	    ..s pwcode=$p(^DHCPHDISP(phdrow,1),"^",8)
	    ..s phaserial=""
	    ..s phaserial=$p(^DHCPHARW(pharow),"^",12)
	    ..s prtdate=""
	    ..s phadate=+$p(^DHCINVPRT(prt),"^",5)
	    ..s prtdate=$zd(phadate,3)
	    ..s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	    ..;q:(papmino'=CPmiNo)&(CPmiNo'="")
	    ..s patienname=""
	    ..s patienname=$p(^PAPER(papmidr,"ALL"),"^",1)
	    ..;q:(patienname'[CPatName)&(CPatName'="")
	    ..s papsexdr="",papsex="",birthday="",difdate="",perold="",patMr="",glord=""
	    ..s papsexdr=+$p(^PAPER(papmidr,"ALL"),"^",7)
	    ..s birthday=+$p(^PAPER(papmidr,"ALL"),"^",6)
	    ..s difdate=sysdate-birthday+1
	    ..s perold=difdate/365
	    ..i perold["." s perold=$p(perold,".",1)
	    ..i papsexdr'="" s papsex=$p(^CT("SEX",papsexdr),"^",2)
	    ..s m=0,p=0,error="",money=0
	    ..s pp=""
	    ..s pp=##class(web.DHCOutPhDisp).GPerOrd(phl,prt,prescno)
	    ..i pp["^" s money=$p(pp,"^",1),glord=$p(pp,"^",2)
	    ..e  s money=pp
	    ..;q:money=0
	    ..s pp=$fn(money,"",2)
	    ..s pericd="",retval="",syflag=""
	    ..s retval=##class(web.DHCOutPhDisp).GPerIcd(phl,prt,prescno)
	    ..s pericd=$p(retval,"&",1)
	    ..s syflag=$p(retval,"&",2)
	    ..s t=t+1
	    ..;pname,perno,pydate,"",inv,prt,prescno,phdmoney,papsex,perold,pericd
	    ..set Data=$lb(patienname,papmino,prtdate,pyname,"",prtcode,prt,prescno,pp,papsex,perold,pericd,phaserial,pwcode,phdrow,callflag)
 	    ..Set ^CacheTemp(repid,ind)=Data	
 	    ..Set ind=ind+1
 	    ..;
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryLocPatZFFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocPatZFExecute ]
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

Query QueryLocPatZF(GPhl As %String, GPhw As %String, cludeflag As %String) As %Query(ROWSPEC = "TPatName:%String,TPmiNo:%String,TPrtDate:%String,TPrintFlag:%String,TFyFlag:%String,TPrtInv:%String,TPrt:%String,TPrescNo:%String,TPrescMoney:%String,TPerSex:%String,TPerAge:%String,TMR:%String,TBoxNum:%String,TSerialNo:%String,phdrow:%String,TCallFlag:%String")
{
}

ClassMethod CheckZFDisp(phl, GPhw, cludeflag)
{
	s stdate=+$h
	s enddate=+$h
	s yflocdr=+$p(^DHCPHLOC(phl),"^",1)
	s phpydate="",t=0
	f phpydate=stdate:1:enddate  d  
	  .s phdrow=0
	  .f  s phdrow=$o(^DHCPHDISPi(phpydate,phl,phdrow)) q:(phdrow="")!(phdrow="0")  d
        ..s phw="",finflag="",nouse="",printflag="",arrcpdr="",prt="",prescno=""
        ..s phadate=0
	    ..s phw=+$p(^DHCPHDISP(phdrow,1),"^",4)
	    ..q:(phw'=GPhw)&(cludeflag'="1")
	    ..s finflag=$p(^DHCPHDISP(phdrow),"^",4)
	    ..q:(finflag="1")
        ..s printflag=$p(^DHCPHDISP(phdrow,1),"^",6)
	    ..;q:printflag'="1
	    ..i printflag="1" s printflag="OK"
	    ..s callflag=""
	    ..s callflag=$p(^DHCPHDISP(phdrow,1),"^",15) ;phd_retflag as call flag
	    ..i callflag="1" s callflag="已叫"
	    ..s prt=+$p(^DHCPHDISP(phdrow),"^",2)
	    ..s prescno=$p(^DHCPHDISP(phdrow,2),"^",1)
	    ..;q:(prescno'=CPrescNo)&(CPrescNo'="")
	    ..s pharow=""
	    ..s pharow=..GetPhaRowFrPrtPresc(prt,prescno)
	    ..q:pharow=""
	    ..s nouse=$p(^DHCPHARW(pharow),"^",7)
	    ..q:nouse'="1"
	    ..q:$d(^DHCTMPPharmacyZF(phdrow))
	    ..s prtdate=""
	    ..s prtdate=+$p(^DHCPHARW(pharow),"^",2)
	    ..s chflag=""
	    ..;s chflag=$p(^DHCPHARW(pha),"^",13)
	    ..;q:chflag="1"
	    ..s arraldr=""
	    ..s papmidr="",papmino="",payamount0=0,phatime=""
	    ..q:'$d(^DHCINVPRT(prt))
	    ..s t=t+1
	q t
}

ClassMethod UpdateZFPhdrow(phdrow)
{
	s ^DHCTMPPharmacyZF(phdrow)="1"
	q 0
}

ClassMethod CheckPhdPY(prescno, prt)
{
	s prescphd="",retpy=0
	f  s prescphd=$o(^DHCPHDISPi("PRESCNO",prescno,prescphd)) q:prescphd=""  d
	  .s prescprt="",prescpyflag=""
	  .s prescprt=+$p(^DHCPHDISP(prescphd),"^",2)
	  .q:prescprt'=prt
	  .s prescpyflag=$p(^DHCPHDISP(prescphd,1),"^",6)
	  .q:prescpyflag'="1"
	  .s retpy=retpy+1
 q retpy
}

ClassMethod GetPrescTitle(presc)
{
	s prescord="",prescitm="",retval=""
	s prescord=$o(^OEORD(0,"PrescNo",presc,""))
	i prescord="" q ""
	s prescitm=$o(^OEORD(0,"PrescNo",presc,prescord,""))
	s prescitmmast=""
    s prescitmmast=$p(^OEORD(prescord,"I",prescitm,1),"^",2)
    s prescdrgform="",prescdrgmast=""
    s prescdrgform=$p(^ARCIM($p(prescitmmast,"||",1),$p(prescitmmast,"||",2),1),"^",12)
    s prescdrgmast=$p(prescdrgform,"||",1)
    s prescpoisondr=""
    i prescdrgmast'=0 s prescpoisondr=+$p(^PHCD(prescdrgmast,1),"^",4)
    i prescpoisondr'="" s poisondesc=$p(^PHCPO(prescpoisondr),"^",2)
    s prescitmcat="",oeccat="",oecatdesc=""
    s prescitmcat=$p(^ARCIM($p(prescitmmast,"||",1),$p(prescitmmast,"||",2),1),"^",10)
	s oeccat=$p(^ARC("IC",prescitmcat),"^",8)
	s oecatdesc=$p(^OEC("ORCAT",oeccat),"^",2)
	s poisonflag=0
	s poisonflag=..CheckPoison(poisondesc)
	i poisonflag=1 s retval=poisondesc
	e  s retval=oecatdesc
	q retval
}

ClassMethod CheckPoison(poisondesc)
{
  i poisondesc="" q 0
  i poisondesc["毒" q 1
  i poisondesc["麻" q 1
  i poisondesc["精" q 1
  q 0
}

/// 获取自动配药数据
/// 
ClassMethod CheckPat(CDateSt As %Library.String = "", CDateEnd As %Library.String = "", GPhl As %Library.String = "", GPhw As %Library.String = "")
{
	s m=0,currproc=""
	s phl=""
	s sysdate=+$h
	s systime=$p($h,",",2)
	
	s currproc=$i(^DHCTMPPharmacyPY(sysdate))
    s phl=GPhl
    k ^DHCTMPPrintPY(currproc)
	s stdate=$zdh(CDateSt,4)
	s enddate=$zdh(CDateEnd,4)
	s yflocdr=+$p(^DHCPHLOC(phl),"^",1)
	s phadate=0
	f phadate=stdate:1:enddate  d
	  .s pha="0"
	  .f  s pha=$o(^DHCPHARWi(phadate,phl,pha)) q:(pha="")!(pha="0")  d
        ..s phw="",finflag="",nouse="",printflag="",arrcpdr="",prt="",prescno=""
	    ..s phw=+$p(^DHCPHARW(pha),"^",4)
	    ..;q:phw'=GPhw
	    ..s phwdesc=$p(^DHCPHWIN(phw),"^",1)
	    ..s ret=""
	    ..s ret=##class(web.DHCOutPhTQDisp).CheckPyFyWin(GPhw,phw)
	    ..q:ret=0
	    ..s retflag=""
	    ..s retflag=$p(^DHCPHARW(pha),"^",13)
	    ..q:retflag'="1"
	    ..s finflag=$p(^DHCPHARW(pha),"^",6)
	    ..;i finflag'="1" s finflag=""
	    ..q:(finflag="1")
	    ..s nouse=$p(^DHCPHARW(pha),"^",7)
	    ..q:nouse="1"
	    ..s printflag=$p(^DHCPHARW(pha),"^",8)
	    ..q:(printflag="1")
	    ..s prt=+$p(^DHCPHARW(pha),"^",1)
	    ..s prescno=$p(^DHCPHARW(pha),"^",16)
	    ..s arraldr=""
	    ..s papmidr="",papmino="",payamount0=0,phatime=""
	    ..q:'$d(^DHCINVPRT(prt))
	    ..s prtdate=""
	    ..s prtdate=$zd(phadate,3)
	    ..s phatime=+$p(^DHCINVPRT(prt),"^",20)
	    ..s cytime=0
	    ..s cytime=systime-phatime
	    ..;q:(cytime<10)&(phadate=sysdate)
	    ..s phatime=$zt(phatime,1)
	    ..s papmidr=$p(^DHCINVPRT(prt),"^",15)
	    ..q:papmidr=""
	    ..s prtcode=""
	    ..s prtcode=$p(^DHCINVPRT(prt),"^",14)
	    ..s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	    ..s patienname="",patid=""
	    ..s patienname=$p(^PAPER(papmidr,"ALL"),"^",1)
	    ..s patid=$p(^PAPER(papmidr,"ALL"),"^",9)
	    ..;q:(patienname'=CPatName)&(CPatName'="")
	    ..s papsexdr="",papsex="",birthday="",difdate="",perold="",patMr="",glord=""
	    ..s papsexdr=+$p(^PAPER(papmidr,"ALL"),"^",7)
	    ..s birthday=+$p(^PAPER(papmidr,"ALL"),"^",6)
	    ..s difdate=sysdate-birthday+1
	    ..s perold=..GetPatientAgeDesc(papmidr)
	    ..;i perold["." s perold=$p(perold,".",1)
	    ..i papsexdr'="" s papsex=$p(^CT("SEX",papsexdr),"^",2)
	    ..s pp=""
	    ..s pp=##class(web.DHCOutPhDisp).GPerOrd(phl,prt,prescno)
	    ..s cffs=0
	    ..s cffs=$p(pp,"&",3)
	    ..i pp["^" s money=$p(pp,"^",1),glord=$p(pp,"^",2)
	    ..e  s money=pp
	    ..q:money=0
	    ..
	    ..s mricd="",patadm="",retval=""
	    ..s retval=##class(web.DHCOutPhDisp).GPerIcd(phl,prt,prescno)
	    ..s mricd=$p(retval,"&",1)
	    ..s patadm=##class(web.DHCOutPhDisp).getadm(prescno)
	    ..s deploc="",deplocdesc=""
	    ..s deploc=$p(^PAADM(patadm),"^",4)
	    ..s deplocdesc=$p(^CTLOC(deploc),"^",2)
	    ..i deplocdesc["-" s deplocdesc=$p(deplocdesc,"-",2)
	    ..s presctype="",ptype="",jrflag=""
	    ..s querow="",jytype="",cyyl=""
	    ..s querow=$O(^PAQUE1(0,"PrescNo",prescno,""))
	    ..i querow'=""  d
	     ...i $d(^PAQUE1(querow,"DHC"))  d
	      .... s jytype=$p(^PAQUE1(querow,"DHC"),"^",15)
	      ....s cyyl=$p(^PAQUE1(querow,"DHC"),"^",13)
	    ..i jytype["代"  s jytype="代煎"

	    ..s pattype="",patstatudr="",tel="",patadd=""
        ..s patstatudr=+$p(^PAPER(papmidr,"PER",1),"^",10)
        ..s tel=$p(^PAPER(papmidr,"PER",1),"^",11)   //add by xuyj
        ..i patstatudr'=0 s pattype=$p(^CT("SS",patstatudr),"^",2)
        ..i pattype["(" s pattype=$p(pattype,"(",1)
        ..s patadd=$p($g(^PAPER(papmidr,"PER",4)),"^",18)
         ..s kfdatetime=""
         ..s kfdatetime=##class(web.DHCOutPhNewAddCommit).GetPrescDate(prescno)
	    ..s ptype=##class(web.DHCOutPhDisp).CheckPydType(phl,prt,prescno)
	    ..s presctype=$p(ptype,"^",1)
	    ..s jrflag=$p(ptype,"^",2)
	    ..s printdatetime=""
	    ..;s printdatetime=$zdt($h,3)
	    ..s printdatetime=kfdatetime
	    ..;prtdate_" "_phatime
	    ..s presctitle=""
	    ..s presctitle=##class(web.DHCOutPhTQDisp).GetPrescTitle(prescno)
	    
	    ..s m=m+1
	    ..s ^DHCTMPPrintPY(currproc,pha)=patienname_"^"_papmino_"^"_printdatetime_"^"_prtcode_"^"_prt_"^"_prescno_"^"_papsex_"^"_perold_"^"_deplocdesc_"^"_mricd_"^"_presctype_"^"_phwdesc_"^"_patid_"^"_cffs_"^"_jytype_"^"_tel_"^"_patadd_"^"_presctitle_"^"_cyyl
	    s ret=""
	    i m=0 q 0
	    e  s ret=m_"^"_currproc
	    q ret
}

/// Description:从科室获取phl
ClassMethod GetPhlFrmLoc(ctlocdr)
{
   q:ctlocdr="" ""
   q:'$d(^DHCPHLOCi("LOC",ctlocdr)) ""
   s phl=$o(^DHCPHLOCi("LOC",ctlocdr,""))
   q phl
}

/// Description:审核处方
ClassMethod AuditPharWin(prt, phl, prescno, pydr, datestr)
{
	
	//s prt="176966"
	//s phl="7"
	//s prescno="O11080100040"
	//s pydr="2995"
	//s datestr="01/08/2011^01/08/2011"
	s tmpphl=phl
	s chkreclocflag=##class(web.DHCOutPhCommon).GetChkRecLocFlag()
	s phl=""
	l +^TMP("AuditPharWin",prescno):10  e  q -100
	
	TSTART   
	s sysdate=$p($h,",",1)
	s systime=$p($h,",",2)
	s chkerr=0
	s chkerr=##class(web.DHCOutPhDisp).CheckNotUse(prt,phl,prescno)
	i chkerr=1 d unlock
	q:chkerr=1 -1
	//s chkerr=##class(web.DHCOutPhDisp).CheckBeforUpdate(prescno,phl)
    //i chkerr=1 d unlock
	//q:chkerr=1 -3
	//s chkerr=##class(web.DHCOutPhDisp).CheckBeforInsert(prescno,phl,0)
	//i chkerr=1 d unlock
	//q:chkerr=1 -2
	//s chkerr=##class(web.DHCOutPhCommon).GetOrdXState(prescno,phl)
	//i chkerr=1 d unlock
	//q:chkerr=1 -4
	s chkerr=##class(web.DHCOutPhDisp).CheckNotPrtint(prt,phl,prescno)
	i chkerr=1 d unlock
	q:chkerr=1 -5
	
	///审方
	//i phl'="" d
	//.s phar=$o(^DHCPHARi("PRESCNO",prescno,""))
	//.&sql(update DHC_PHARWIN set PHA_PRINTFLAG='1' ,PHA_PRINTDATE=:sysdate,PHA_PRINTTIME=:systime,PHA_PRINTUSER_DR=:pydr where PHA_PHL_DR=:phl and PHA_PrescNo=:prescno )
	//e  d
	//.&sql(update DHC_PHARWIN set PHA_PRINTFLAG='1' ,PHA_PRINTDATE=:sysdate,PHA_PRINTTIME=:systime,PHA_PRINTUSER_DR=:pydr where PHA_PrescNo=:prescno )
	//i SQLCODE'=0 d unlock
	
	s updpharflag=0
	s phar=""
	f  s phar=$o(^DHCPHARi("PRESCNO",prescno,phar)) q:(phar="")||(updpharflag'=0)  d
	.&sql(update DHC_PHARWIN set PHA_PRINTFLAG='1' ,PHA_PRINTDATE=:sysdate,PHA_PRINTTIME=:systime,PHA_PRINTUSER_DR=:pydr where PHA_ROWID=:phar )
	.i SQLCODE'=0 s updpharflag=-1
	.
	i updpharflag'=0 d unlock
	q:updpharflag'=0 -6
	
	///排队
	//s chkerr=..UpdQueue(sysdate,tmpphl,prescno,datestr)
	//i chkerr<0 Trollback
	//i chkerr<0 d unlock
	//q:chkerr<0 -7
 
    TCOMMIT
	d unlock
	q chkerr
	
unlock
    Trollback
    l -^TMP("AuditPharWin",prescno)
    q
}

/// Description:检查该患者所有处方是否全部审核完毕
/// 1 -是 0-否
ClassMethod ChkAllAudited(phl, prescno, datestr)
{
	 s stdate=$p(datestr,"^",1)
	 s stdate=$zdh(stdate,4)
	 s enddate=$p(datestr,"^",2)
	 s enddate=$zdh(enddate,4)
	 s ord=$o(^OEORD(0,"PrescNo",prescno,""))
     s adm=$p(^OEORD(ord),"^",1)
     s papmi=+$p(^PAADM(adm),"^",1)
     s CPmiNo=$p(^PAPER(papmi,"PAT",1),"^",2)
     s retvalue=1
	 s oldpresc="",retStr=""
	 f phadate=stdate:1:enddate q:retvalue=0  d
	 .s phlstr=""
	 .s chkreclocflag=##class(web.DHCOutPhCommon).GetChkRecLocFlag() 
	 .i chkreclocflag=0 s phlStr=##class(web.DHCOutPhCommon).GetPatPhlStr()
	 .i phlStr="" s phlStr=phl
	 .s phlCnt=$l(phlStr,"^")
	 .f xx=1:1:phlCnt q:retvalue=0  d
	 ..s phl=$p(phlStr,"^",xx)
	 ..s phar=0
	 ..f  s phar=$o(^DHCPHARWi(phadate,phl,phar)) q:(phar="")!(phar=0)!(retvalue=0)  d
	 ...s prt=$p(^DHCPHARW(phar),"^",1)
	 ...s papmidr=$p(^DHCINVPRT(prt),"^",15)
	 ...s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	 ...q:papmino'=CPmiNo
	 ...s retflag=$p(^DHCPHARW(phar),"^",13)
	 ...q:retflag'="1"
	 ...s nouse=$p(^DHCPHARW(phar),"^",7)
	 ...q:nouse="1"
	 ...s finflag=$p(^DHCPHARW(phar),"^",6)
	 ...q:finflag="1"
	 ...s OEPrescNo=$p(^DHCPHARW(phar),"^",16)
	 ...i oldpresc'=OEPrescNo d
     ....i retStr="" d
     .....s retStr=OEPrescNo
     ....e  d
     .....s retStr=retStr_$c(1)_OEPrescNo
     ...s oldpresc=OEPrescNo
     ...s printflag=$p(^DHCPHARW(phar),"^",8)
     ...q:printflag=1
     ...s retvalue=0
	 ..
	 .
	 q retvalue_"^"_retStr
	 
	 /*
	 
	 s retStr="",oldpresc=""
     s flag="P"
     s retvalue=1
     s ord=""
     s ord=$o(^OEORD(0,"PrescNo",prescno,ord))
     s adm=$p(^OEORD(ord),"^",1)
     s itm=0
     f  s itm=$o(^OEORD(ord,"I",itm)) q:(itm="")||(itm=0)||(retvalue=0)  d
     .s oeori=ord_"||"_itm
     .s OEPrescNo=$p(^OEORD(ord,"I",itm,1),"^",14)
     .q:OEPrescNo=""
     .s ordstatus=$p(^OEORD(ord,"I",itm,3),"^",5)
     .q:ordstatus'=flag
     .s phar=$o(^DHCPHARi("PRESCNO",OEPrescNo,""))
     .q:phar=""
     .s retflag=$p(^DHCPHARW(phar),"^",13)
     .q:retflag'=1
     .s nouseflag=$p(^DHCPHARW(phar),"^",7)
     .q:nouseflag=1
     .s printflag=$p(^DHCPHARW(phar),"^",8)
     .i oldpresc'=OEPrescNo d
     ..i retStr="" d
     ...s retStr=OEPrescNo
     ..e  d
     ...s retStr=retStr_$c(1)_OEPrescNo
     .s oldpresc=OEPrescNo
     .q:printflag=1
     .s retvalue=0
     q retvalue_"^"_retStr
     
     */
}

/// Description:检查该患者所有处方是否全部审核完毕
/// 1 -是 0-否
ClassMethod UpdQueue(sysdate, phl, prescno, datestr)
{
	
	s chkStr=..ChkAllAudited(phl,prescno,datestr)
	s chkflag=$p(chkStr,"^",1)
	q:chkflag=0 0
	s prescinfo=$p(chkStr,"^",2)
	///分配窗口
	//s newwin=##class(web.DHCMZYFXTYW02).GetCurrNewWin(prescinfo,phl)
    //q:newwin="" -7
    //s windr=$p(newwin,"^",2)
    s ret=..CreateQueNo(sysdate, phl, prescinfo, 1)
    i +ret>0 q ret
    q 0
}

/// Description:生成排队序号
/// >0 成功 ,windr'="" 再次取号 windr="" 首次取号
ClassMethod CreateQueNo(sysdate, phl, prescno, flag)
{
	s err=0
	///单独取号时,取同时间内的打印处方,分配窗口
	i flag="" d
	.s phar=$o(^DHCPHARi("PRESCNO",prescno,""))
	.s prtdate=$p(^DHCPHARW(phar),"^",11)
	.s prtflag=$p(^DHCPHARW(phar),"^",8)
    .q:prtflag'=1
	.s prescnoinfo=""
	.s phar=""
	.f  s phar=$o(^DHCPHARi("PRTDATE",prtdate,prescno,phar)) q:phar=""  d
	..s tmpno=$p(^DHCPHARW(phar),"^",16)
	..i prescnoinfo="" d
	...s prescnoinfo=tmpno
	..e  d
	...s prescnoinfo=prescnoinfo_$c(1)_tmpno
	.s prescno=prescnoinfo
	q:prescno="" -2
	///分配窗口
	s newwin=##class(web.DHCMZYFXTYW02).GetCurrNewWin(prescno,phl)
    q:newwin="" -7
    s windr=$p(newwin,"^",2)
    i sysdate="" s sysdate=+$h
    ///排队列
    s Prefix=$p(^DHCPHWIN(windr),"^",6)
    i Prefix="" s Prefix="C"
	s ctlocdr=$p(^DHCPHLOC(phl),"^",1)
	l +^TMP("AuditPharWin",ctlocdr,Prefix):10  e  q -100
	s ord=$o(^OEORD(0,"PrescNo",$p(prescno,$C(1)),""))
	s adm=$p(^OEORD(ord),"^",1)
	s papmi=+$p(^PAADM(adm),"^",1)
	s number=0
	s phwqu=$o(^DHCPHWQUi("CTLOC",sysdate,ctlocdr,Prefix,""),-1)
	i phwqu="" d
	.s number=1
	e  d
	.s num=$p(^DHCPHWQU(phwqu),"^",4)
	.s number=num+1
    .s phwqu=$o(^DHCPHWQUi("PAPMI",sysdate,ctlocdr,papmi,""),-1)
    .i phwqu'="" d
    ..s status=+$p(^DHCPHWQU(phwqu),"^",5) // 1 正常 2过号
    ..i status=1 d
    ...//再次取号
    ...s number=0
    ...
    .. 
    .
    s reterr=0
    i number'=0 d
    .&SQL(insert into DHC_PHWINQUEUE (PHWQU_Date,PHWQU_Time,PHWQU_Ctloc_DR,PHWQU_No,PHWQU_Status,PHWQU_PAPMI_DR,PHWQU_Prefix) VALUES (:sysdate,:systime,:ctlocdr,:number,'1',:papmi,:Prefix) )
    .i SQLCODE'=0 d
    ..s reterr=-1
    .i SQLCODE=0 d 
    ..s phwqu=%ROWID
    i reterr'=0 d unlock
    q:reterr=-1 -8
    
    ///更新中间表窗口
    s cnt=$l(prescno,$C(1))
    f i=1:1:cnt  q:reterr=-1  d
    .s singleno=$p(prescno,$C(1),i)
    .&sql(update DHC_PHARWIN set PHA_PHW_DR=:windr,PHA_QueueNo=:phwqu where Pha_PrescNo=:singleno )
    .i SQLCODE'=0 s reterr=-1
    i reterr'=0 d unlock
    q:reterr'=0 -9
    d unlock
    q phwqu
    
unlock
    l -^TMP("AuditPharWin",ctlocdr,Prefix)
    q
}

/// Description:获取队列数据
ClassMethod GetQueueList(phwqu)
{
}

}
