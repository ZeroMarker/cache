Import sqluser

Class web.DHCOutPhTQDisp Extends %RegisteredObject [ ProcedureBlock ]
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
	
	s AgeDesc=##class(web.DHCSTKUTIL).GetAge(PatientID) //年龄统一调用接口wyx 2015-01-29
	Q AgeDesc
}

ClassMethod QueryLocPatPYClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocPatPYExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCOutPhTQDisp","QueryLocPatPY",64932,64943,"14","40","0000000066","","50","","",0,"","","")
ClassMethod QueryLocPatPYExecute(ByRef QHandle As %Binary, CDateSt As %Library.String, CDateEnd As %Library.String = "", GPhl As %Library.String = "", GPhw As %Library.String = "", CPmiNo As %Library.String = "", CPatName As %Library.String = "", GPydr As %Library.String = "", GFydr As %Library.String = "", GPhwPos As %Library.String = "", CPrint As %Library.String = "", CPyUser As %Library.String = "", stopcon As %Library.String = "", SpecialID) As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	s phl="",userid="",t=0,yfpydr="",patnum=0
	s sysdate=+$h
	s systime=$p($h,",",2)
    s phl=GPhl
	i (phl="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	i (CPrint'="1")&&(CPmiNo="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s stdate=CDateSt
	s enddate=CDateEnd
	s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdate)
	s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(enddate)
	s yflocdr=+$p(^DHCPHLOC(phl),"^",1)
	s locdr=$p(^DHCPHLOC(phl),"^",1)
	s leadlocdr=##class(web.DHCOutPhDisp).GetLeadLoc(locdr)
	s mainphl=$o(^DHCPHLOCi("LOC",leadlocdr,""))  //主科室
	s phl=mainphl
	s yflocdr=leadlocdr
	s needauditflag=##class(web.DHCOutPhCommon).GetNeedOrdAuditFlag(phl)
	d GetFyWin 								//获取配药窗口可配的的发药窗口
	s cyflag=$p(^DHCPHLOC(phl),"^",6)

	s pid=##CLASS(web.DHCSTKUTIL).GetOutDispCounter()
	s prt=""
	s phadate=0,p=0
	f phadate=stdate:1:enddate  d
	.s phar=0
	.f  s phar=$o(^DHCPHARWi(phadate,phl,phar)) q:(phar="")!(phar=0)  d
	..s phw=+$p(^DHCPHARW(phar),"^",4) 
	..q:phw=0
	..q:'$d(PyFyWin(phw))								//窗口过滤				
	..s retflag=""
	..s retflag=$p(^DHCPHARW(phar),"^",13)
	..q:retflag'="1"
	..s finflag=$p(^DHCPHARW(phar),"^",6)				//发药标志
    ..s nouse=$p(^DHCPHARW(phar),"^",7)					//计费作废标志
	..q:nouse="1"	
    ..s printflag=$p(^DHCPHARW(phar),"^",8)				//打印标志(配药标志)
    ..q:(CPrint="1")&&(printflag'="1")
	..q:(CPrint'="1")&&(printflag="1")
    ..s retflag=$p(^DHCPHARW(phar),"^",13)				//收费成功标志
	..q:retflag'="1"
    ..s prescno=$p(^DHCPHARW(phar),"^",16)				//处方号
    ..s chkerr=##class(web.DHCOutPhDisp).CheckBeforInsertNew(prescno,phl,0)   //是否配药了(不管是否配药完成)
	..q:(CPrint="1")&&(chkerr'=1)	
	..q:(CPrint'="1")&&(chkerr="1")
	..s PyFlag=chkerr
	..s ord=$o(^OEORD(0,"PrescNo",prescno,"")) 
	..s adm=$p(^OEORD(ord),"^",1)
	..s papmidr=$p($g(^PAADM(adm)),"^",1)
	..q:papmidr=""
	..s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	..q:(CPmiNo'="")&&(papmino'=CPmiNo)
	..s ^TMPPRESCINFO("DHCST","web.DHCOutPhTQDisp","QueryLocPatPY",pid,"Prescno",adm,prescno)=PyFlag_"^"_phw			//配药标志^发药窗口  (后面用)
	.  

    f orddate=stdate:1:enddate  d
    .s phadate="" //收费日期
	.s ord=""
	.f  s ord=$o(^OEORDi(0,"LocStDtArr",yflocdr,0,orddate,ord)) q:ord=""  d
	..s adm=$p(^OEORD(ord),"^",1)
	..q:adm=""
	..s AdmType=$p($g(^PAADM(adm)),"^",2)
	..q:(AdmType'="O")&&(AdmType'="E")&&(AdmType'="H")
	..s papmidr=$p($g(^PAADM(adm)),"^",1)
	..q:papmidr=""
	..s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	..q:(CPmiNo'="")&&(papmino'=CPmiNo)
	..s chl=""
	..f  s chl=$o(^OEORDi(0,"LocStDtArr",yflocdr,0,orddate,ord,chl)) q:chl=""  d 
	...s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
	...q:prescno=""
	...q:$d(^DHCPHARi("PRESCNO",prescno))											//已经收过费
	...q:$d(^DHCPHDISPi("PRESCNO",prescno))&&(CPrint'="1")											//已经配过药  
	...q:'$d(^DHCPHDISPi("PRESCNO",prescno))&&(CPrint="1")											
	...q:$d(^TMPPRESCINFO("DHCST","web.DHCOutPhTQDisp","QueryLocPatPY",pid,"Prescno",adm,prescno))			//已经统计过
	...i $d(^DHCPHDISPi("PRESCNO",prescno)) s PyFlag=1
	...e  s PyFlag=""
    ...s OrderStatusDr=$p(^OEORD(ord,"I",chl,1),"^",13)
	...q:OrderStatusDr=""
	...s OeFlag=$p($g(^OEC("OSTAT",OrderStatusDr)),"^",1)
	...q:(OeFlag'="V")&(OeFlag'="E")
	...s EmLGflag=$p($g(^OEORD(ord,"I",chl,"DHC")),"^",17) 				//医嘱先诊疗后收费标识(包括急诊留观,有先诊疗后收费标识),统一到OEORI_EMStayFlag字段,yunhaibao,20160225
	...q:EmLGflag="1"  													//押金模式统一走直接发药
	...s oeori=ord_"||"_chl
	...s payDispFlag=##class(PHA.OP.COM.Method).GetDispBeforePay(oeori,AdmType)
	...q:payDispFlag'="Y"
	...s ^TMPPRESCINFO("DHCST","web.DHCOutPhTQDisp","QueryLocPatPY",pid,"Prescno",adm,prescno)=PyFlag_"^"_""
	...
	..
	
	s adm="" 
    f  s adm=$o(^TMPPRESCINFO("DHCST","web.DHCOutPhTQDisp","QueryLocPatPY",pid,"Prescno",adm)) q:adm=""  d
    .s papmidr=$p(^PAADM(adm),"^",1) 
    .s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	.q:(papmino'=CPmiNo)&(CPmiNo'="")
	.s patienname="",patid=""
	.s patienname=$p(^PAPER(papmidr,"ALL"),"^",1)
	.s patid=$p(^PAPER(papmidr,"ALL"),"^",9)
	.q:(patienname'[CPatName)&(CPatName'="")
	.s papsexdr="",papsex="",perold="",glord=""
	.s papsexdr=+$p(^PAPER(papmidr,"ALL"),"^",7)
	.s perold=..GetPatientAgeDesc(papmidr)				//年龄统一接口
	.i papsexdr'="" s papsex=$p(^CT("SEX",papsexdr),"^",2)
	.s patloc=+$p(^PAADM(adm),"^",4)
	.s patlocdesc=$p(^CTLOC(patloc),"^",2)
	.i patlocdesc["-" s patlocdesc=$p(patlocdesc,"-",2)
	.s pericd=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",")      //诊断
	.s pattype=""
    .s patstatudr=+$p(^PAPER(papmidr,"PER",1),"^",10)
    .i patstatudr'=0 s pattype=$p(^CT("SS",patstatudr),"^",2)		//病人类型   城职、医保、自费
    .i pattype["(" s pattype=$p(pattype,"(",1)
    .s tel=$p(^PAPER(papmidr,"PER",1),"^",11)   					//电话
    .s patadd=$p($g(^PAPER(papmidr,"PER",4)),"^",18)
    .s prescno=""
    .f  s prescno=$o(^TMPPRESCINFO("DHCST","web.DHCOutPhTQDisp","QueryLocPatPY",pid,"Prescno",adm,prescno)) q:prescno=""  d 
    ..s (finflag,printflag)=""
    ..s tmpData=^TMPPRESCINFO("DHCST","web.DHCOutPhTQDisp","QueryLocPatPY",pid,"Prescno",adm,prescno) 
    ..s PyFlag=$p(tmpData,"^",1) 
    ..s phw=$p(tmpData,"^",2) 
    ..s phwdesc=""	
    ..i phw'="" s phwdesc=$p(^DHCPHWIN(phw),"^",1)		
	..i PyFlag=1 s printflag="OK"		//配药标志
	..i printflag="OK" d
	...s chkerr=##class(web.DHCOutPhDisp).CheckBeforUpdate(prescno,phl)  
	...s chkerr=1 s finflag="OK"  		//发药标志
	..i (CPrint'="1") d
	...s chkerr=##class(web.DHCOutPhCommon).GetOrdXState(prescno,phl)
	..q:(CPrint'="1")&&(chkerr=1)
    ..s phd=##class(web.DHCOutPhDisp).GetPhdByPresc(prescno,"",phl)
    ..s prt=""
    ..d getdata
    d clearTmp
	    
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK    
	    
getdata	    
	s uselocdr=##class(web.DHCOutPhCommon).GetOrdUseLocByPresc(prescno)
	q:uselocdr'=""  //默认过滤基数药科室 
	s auditflag=""
	i needauditflag="1"  d
	.s auditflag=##class(web.DHCOutPhCommon).GetOrdAuditResultByPresc(prescno)
	q:(needauditflag="1")&(auditflag'="Y") //处理需要发药前审核

	s prtinfostr=##class(web.DHCOutPhCommon).GetHandTime(prescno)
	s prtdate=$p(prtinfostr,"^",2)
	s prttime=$p(prtinfostr,"^",3)
	s prt=$p(prtinfostr,"^",4)
	s prtcode=$p(prtinfostr,"^",5)
	

	s prescmoney=##class(PHA.OP.COM.Method).GetPrescAmt(prescno,yflocdr)
	s money=$p(prescmoney,"^",1)
	s presctype=$p(prescmoney,"^",2)
	q:money=0

	s (fs,syflag,jrflag,jytype)=""					//草药付数,输液标志,未知,煎药方式
	s querow=$O(^PAQUE1(0,"PrescNo",prescno,""))
	i querow'=""  d
	.i $d(^PAQUE1(querow,"DHC")) d
	..s jytype=$p(^PAQUE1(querow,"DHC"),"^",15)
	..s durdr=$p(^PAQUE1(querow,"DHC"),"^",10)
	..s fs=$p(^PHCDU(durdr),"^",2) ;剂数
	..i jytype["代"  s jytype="代煎"
	s presctitle=""
	s presctitle=##class(web.DHCOutPhTQDisp).GetPrescTitle(prescno)
	s phdispstat=##class(web.DHCOutPhCommon).GetPhdStatus(phd)	//发药状态
	s EncryptLevelInfo=""
	s EncryptLevel=""
	s PatLevel="" 
	s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
	i EncryptFlag=1 d
	.s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmidr,"")
	.s EncryptLevel=$p(EncryptLevelInfo,"^",1)
	.s PatLevel=$p(EncryptLevelInfo,"^",2)
	set Data=$lb(patienname,papmino,prtdate,printflag,finflag,prtcode,prttime,prt,prescno,money,papsex,perold,pericd,glord,patlocdesc,syflag,presctype,phwdesc,patid,fs,jytype,tel,patadd,presctitle,phd,EncryptLevel,PatLevel,phdispstat)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	q
clearTmp  
   k ^TMPPRESCINFO("DHCST","web.DHCOutPhTQDisp","QueryLocPatPY",pid,"Prescno")
   q
GetFyWin
	s pywinsub=0
	f  s pywinsub=$o(^DHCPHPY(GPhw,"PHW",pywinsub)) q:pywinsub=""  d
	.s pyfywin=+$p(^DHCPHPY(GPhw,"PHW",pywinsub),"^",1)
	.s PyFyWin(pyfywin)=""
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

Query QueryLocPatPY(CDateSt As %String, CDateEnd As %String, GPhl As %String, GPhw As %String, CPmiNo As %String, CPatName As %String, GPydr As %String, GFydr As %String, GPhwPos As %String, CPrint As %String, CPyUser As %String, stopcon As %String, SpecialID) As %Query(ROWSPEC = "TPatName:%String,TPmiNo:%String,TPrtDate:%String,TPrintFlag:%String,TFyFlag:%String,TPrtInv:%String,TPrtTime:%String,TPrt:%String,TPrescNo:%String,TPrescMoney:%String,TPerSex:%String,TPerAge:%String,TMR:%String,TGLOrd:%String,TPerLoc:%String,TSyFlag:%String,TPrescType:%String,TWinDesc:%String,TPatID:%String,TJS:%String,TJYType:%String,TCallCode:%String,TPatAdd:%String,TPrescTitle:%String,Tphdrowid:%String,TEncryptLevel:%String,TPatLevel:%String,TPhDispStat:%String")
{
}

ClassMethod CheckPyFyWin(pywin, fywin)
{
 q:+fywin=0 1
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
	q:prt="" ""
	s pharow="",retval=""
	f  s pharow=$o(^DHCPHARi("PRT",prt,pharow)) q:pharow=""  d
	  .s phapresc=""
	  .s phapresc=$p(^DHCPHARW(pharow),"^",16)
	  .q:phapresc'=presc
	  .s retflag=$p(^DHCPHARW(pharow),"^",13)
      .q:retflag'="1"
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
    Set QHandle=$lb(0,repid,0)
	s ind=1
	s phl="",userid="",t=0
	s sysdate=+$h
    s phl=GPhl
	//i (phl="")!(CPmiNo="") Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s CDateSt=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateSt)
	s CDateEnd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateEnd)
	s stdate=CDateSt
	s enddate=CDateEnd
	s yflocdr=+$p(^DHCPHLOC(phl),"^",1)
	s leadlocdr=##class(web.DHCOutPhDisp).GetLeadLoc(yflocdr)
	s yflocdr=leadlocdr
	
	s needauditflag=##class(web.DHCOutPhCommon).GetNeedOrdAuditFlag(phl)
	
	i CPrescNo'="" d
	.s phdrow=0
	.f  s phdrow=$o(^DHCPHDISPi("PRESCNO",CPrescNo,phdrow)) q:(phdrow="")!(phdrow="0")  d
	..s dispphl=$p(^DHCPHDISP(phdrow,1),"^",1) 
	..q:dispphl'=phl
	..s phpydate=$p(^DHCPHDISP(phdrow,1),"^",5) 
	..q:(phpydate>enddate)||(phpydate<stdate)
	..d OutPutRow
	.
	e  i CPmiNo'=""  d
	.s phdpapmidr=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(CPmiNo),""),-1)
	.q:phdpapmidr=""
	.s phdrow=0
	.f  s phdrow=$o(^DHCPHDISPi("PAPMI",phdpapmidr,phdrow)) q:(phdrow="")!(phdrow="0")  d
	..s dispphl=$p(^DHCPHDISP(phdrow,1),"^",1) 
	..q:dispphl'=phl
	..s phpydate=$p(^DHCPHDISP(phdrow,1),"^",5) 
	..q:(phpydate>enddate)||(phpydate<stdate)
	..d OutPutRow
	.
	e  d
	.s phpydate=""
	.f phpydate=stdate:1:enddate  d  
	..s phdrow=0
	..f  s phdrow=$o(^DHCPHDISPi(phpydate,phl,phdrow)) q:(phdrow="")!(phdrow="0")  d
	...d OutPutRow
	.	
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRow
	s phw="",finflag="",nouse="",printflag="",arrcpdr="",prt="",prescno=""
	s phadate=0
	
	s phw=+$p(^DHCPHDISP(phdrow,1),"^",4)
	q:(phw'=GPhw)&(cludeflag'="1")&(phw'=0)
	s finflag=$p(^DHCPHDISP(phdrow),"^",4)				//发药标志
	q:(finflag="1")&(fyflag'="1")
	q:(finflag'="1")&(fyflag="1")
	s pyflag=$p(^DHCPHDISP(phdrow,1),"^",6)				//配药标志
	q:pyflag'=1
	i printflag="1" s printflag="OK"
	i finflag="1" s fydesc="OK"		
	s chkflag=0
	i finflag'="1" d
	.s chkflag=##class(web.DHCOutPhDisp).CheckNotUseNew(prescno,yflocdr)			//判断处方是否作废
	q:chkflag'=0	
	s callflag=$p(^DHCPHDISP(phdrow,1),"^",15) 			//叫号PHD_RETFLAG as call flag

	s prt=$p(^DHCPHDISP(phdrow),"^",2)
	s prescno=$p(^DHCPHDISP(phdrow,2),"^",1)
	q:(prescno'=CPrescNo)&(CPrescNo'="")
	s uselocdr=##class(web.DHCOutPhCommon).GetOrdUseLocByPresc(prescno)
	q:uselocdr'=""  //默认过滤基数药科室
	s auditflag=""
	s auditflag=##class(web.DHCOutPhCommon).GetOrdAuditResultByPresc(prescno)
    q:(needauditflag="1")&(auditflag'="Y") 		//处理需要发药前审核
	s ssresult=##class(web.DHCOutPhCommon).GetOrdRefResultByPresc(prescno)
	i ssresult="S" d
	.s appealreason=##class(web.DHCOutPhCommon).GetOrdAppealReasonByPresc(prescno) //申诉理由
	.s ssresult="申诉拒绝"_"("_appealreason_")"
	i ssresult="N" s ssresult="拒绝发药"
	i ssresult="A" s ssresult="拒绝发药(接受)"
	i ssresult="Y" s ssresult="通过"
	i ssresult="" d				//发药拒绝为空 -》处方审核
	.i auditflag="N" s ssresult="拒绝"
	.i auditflag="Y" s ssresult="通过"
	.i auditflag="S" s ssresult="申诉"

	
	s prtinfostr=##class(web.DHCOutPhCommon).GetHandTime(prescno)
	s prtdate=$p(prtinfostr,"^",2)
	s prttime=$p(prtinfostr,"^",3)
	s prt=+$p(prtinfostr,"^",4)
	s prtcode=$p(prtinfostr,"^",5)
	
	
	s (pycode,phaserial)=""
	s pydr=+$p(^DHCPHDISP(phdrow,1),"^",3)
	i pydr'=0 d
	.s pyuser=+$p(^DHCPHPER(pydr),"^",5)
	.q:pyuser=""
	.s pycode=$p(^SSU("SSUSR",pyuser),"^",1)

	s papmidr=##class(web.DHCOutPhCommon).GetPapmiByPresc(prescno)
	q:papmidr=""
	s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	q:(papmino'=CPmiNo)&(CPmiNo'="")
	s patienname=""
	s patienname=$p(^PAPER(papmidr,"ALL"),"^",1)
	q:(patienname'[CPatName)&(CPatName'="")
	s papsexdr="",papsex="",perold=""
	s papsexdr=+$p(^PAPER(papmidr,"ALL"),"^",7)
	s perold=..GetPatientAgeDesc(papmidr)
	i papsexdr'="" s papsex=$p(^CT("SEX",papsexdr),"^",2)
	s patadm=##class(web.DHCOutPhDisp).getadm(prescno)
	
	s prescmoney=##class(PHA.OP.COM.Method).GetPrescAmt(prescno,yflocdr,finflag)
	s money=$p(prescmoney,"^",1)
	s pericd=""
	s pericd=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(patadm,",")
	s t=t+1
	s EncryptLevelInfo=""
	s EncryptLevel=""
	s PatLevel="" 
	s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
	i EncryptFlag=1 d
	.s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmidr,"")
	.s EncryptLevel=$p(EncryptLevelInfo,"^",1)
	.s PatLevel=$p(EncryptLevelInfo,"^",2)
	s fydate=$p(^DHCPHDISP(phdrow),"^",3)
	s:fydate'="" fydate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(fydate)
	s jytype=""
	s prescrow=$o(^PAQUE1(0,"PrescNo",prescno,""))
	i prescrow'=""  d
	.i $d(^PAQUE1(prescrow,"DHC")) s jytype=$p(^PAQUE1(prescrow,"DHC"),"^",15)
	s phdispstat=##class(web.DHCOutPhCommon).GetPhdStatus(phdrow)
	set Data=$lb(patienname,papmino,prtdate,printflag,fydesc,prtcode,prt,prescno,money,papsex,perold,pericd,phaserial,pwcode,phdrow,callflag,pycode,ssresult,EncryptLevel,PatLevel,fydate,jytype,phdispstat)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	q
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

Query QueryLocPatFY(CDateSt As %String, CDateEnd As %String, GPhl As %String, GPhw As %String, CPmiNo As %String, CPatName As %String, cludeflag As %String, CPrescNo As %String, fyflag As %String, SpecialID) As %Query(ROWSPEC = "TPatName:%String,TPmiNo:%String,TPrtDate:%String,TPrintFlag:%String,TFyFlag:%String,TPrtInv:%String,TPrt:%String,TPrescNo:%String,TPrescMoney:%String,TPerSex:%String,TPerAge:%String,TMR:%String,TBoxNum:%String,TSerialNo:%String,phdrow:%String,TCallFlag:%String,TPyCode:%String,TDocSS:%String,TEncryptLevel:%String,TPatLevel:%String,TFyDate:%String,TJyType:%String,TPhDispStat:%String")
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

/// 获取自动配药信息
/// Liang Qiang
/// w ##class(web.DHCOutPhTQDisp).GetAutoDispInfo("2018-12-20","2018-12-20",11,21)
ClassMethod GetAutoDispInfo(CDateSt As %Library.String = "", CDateEnd As %Library.String = "", GPhl As %Library.String = "", GPhw As %Library.String = "")
{
	s m=0
	s sysdate=+$h
	s systime=$p($h,",",2)
	s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateSt)
	s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateEnd)
	s phl=GPhl
	s phw=""
	s yflocdr=+$p(^DHCPHLOC(phl),"^",1)
	s FindNum=0
	s pid=##CLASS(web.DHCSTKUTIL).GetOutDispCounter()		
	d GetFyWinListByPyWin							//获取配药窗口对应的发药窗口
	s needauditflag=##class(web.DHCOutPhCommon).GetNeedOrdAuditFlag(phl)
	
    f phadate=stdate:1:enddate  d
    .s pha="0"
    .f  s pha=$o(^DHCPHARWi(phadate,phl,pha)) q:(pha="")!(pha="0")  d
    ..s phw=+$p(^DHCPHARW(pha),"^",4)
    ..q:phw=0
    ..q:'$d(PyFyWin(phw))
    ..s phwdesc=$p(^DHCPHWIN(phw),"^",1)
    ..s retflag=""
    ..s retflag=$p(^DHCPHARW(pha),"^",13)			//收费成功标志
    ..q:retflag'="1"
    ..s finflag=$p(^DHCPHARW(pha),"^",6)			//发药标志
    ..q:(finflag="1")
    ..s nouse=$p(^DHCPHARW(pha),"^",7)				//计费作废标志
    ..q:nouse="1"
    ..s printflag=$p(^DHCPHARW(pha),"^",8)			//打印标志(配药标志)
    ..q:(printflag="1")
    ..s prescno=$p(^DHCPHARW(pha),"^",16)
    ..s phdId=$o(^DHCPHDISPi("PRESCNO",prescno,""),-1)
    ..q:(phdId'="")&&($p(^DHCPHDISP(phdId),"^",4)=1)
    ..//s chkerr=##class(web.DHCOutPhDisp).CheckBeforInsertNew(prescno,phl,1)				//是否配药完了
    ..//q:chkerr=1		// 中间表有有效数据																//只要是配药了，就过滤
	..s uselocdr=##class(web.DHCOutPhCommon).GetOrdUseLocByPresc(prescno)
    ..q:uselocdr'=""  //默认过滤基数药科室
    ..s auditflag=""
    ..i needauditflag="1" d
    ...s auditflag=##class(web.DHCOutPhCommon).GetOrdAuditResultByPresc(prescno)
    ..q:(needauditflag="1")&(auditflag'="Y") //处理需要发药前审核
    ..s m=m+1
    ..s prt=0
    ..s index=phadate_"^"_phl_"^"_phw_"^"_prt_"^"_prescno
	..s ^TMPDHCOUTAUTODISP(pid,index)=""
	..s FindNum=FindNum+1
    f orddate=stdate:1:enddate  d
	.s ord=""
	.f  s ord=$o(^OEORDi(0,"LocStDtArr",yflocdr,0,orddate,ord)) q:ord=""  d
	..s adm=$p(^OEORD(ord),"^",1)
	..q:adm=""
	..s AdmType=$p($g(^PAADM(adm)),"^",2)
	..q:(AdmType'="O")&(AdmType'="E")&(AdmType'="H") 
	..s chl=""
	..f  s chl=$o(^OEORDi(0,"LocStDtArr",yflocdr,0,orddate,ord,chl)) q:chl=""  d
	...s adm=$p(^OEORD(ord),"^",1) 
	...s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
	...q:prescno=""
	...q:$d(^DHCPHARi("PRESCNO",prescno))						//已经收过费
	...q:$d(^DHCPHDISPi("PRESCNO",prescno))						//已经配过药
	...q:$d(^TMPPRESCINFO(pid,adm,prescno))						//已经统计过
    ...s OrderStatusDr=$p(^OEORD(ord,"I",chl,1),"^",13)
	...q:OrderStatusDr=""
	...s OeFlag=$p($g(^OEC("OSTAT",OrderStatusDr)),"^",1)
	...q:(OeFlag'="V")&(OeFlag'="E")
	...s EmLGflag=$p($g(^OEORD(ord,"I",chl,"DHC")),"^",17)
	...q:EmLGflag="1" 											//押金模式,统一走直接发药
	...s oeori=ord_"||"_chl
	...s payDispFlag=##class(PHA.OP.COM.Method).GetDispBeforePay(oeori,AdmType)
	...q:payDispFlag'="Y"
	...s ^TMPPRESCINFO(pid,adm,prescno)=""
	...s FindNum=FindNum+1
	q:FindNum=0 0

	s adm="" 
    f  s adm=$o(^TMPPRESCINFO(pid,adm)) q:adm=""  d
    .s prescno=""
    .f  s prescno=$o(^TMPPRESCINFO(pid,adm,prescno)) q:prescno=""  d 
    ..s papmidr=$p(^PAADM(adm),"^",1)
	..s chkerr=##class(web.DHCOutPhDisp).CheckBeforInsertNew(prescno,phl,0)				//是否配药了(不管是否配药确认完成)
    ..q:chkerr=1	
	..s chkerr=##class(web.DHCOutPhCommon).GetOrdXState(prescno,phl)
	..q:chkerr=1
    ..s uselocdr=##class(web.DHCOutPhCommon).GetOrdUseLocByPresc(prescno)
    ..q:uselocdr'=""  //默认过滤基数药科室
    ..s auditflag=""
    ..i needauditflag="1" d
    ...s auditflag=##class(web.DHCOutPhCommon).GetOrdAuditResultByPresc(prescno)
    ..q:(needauditflag="1")&(auditflag'="Y") //处理需要发药前审核
    ..s prt=0
    ..s phw=0
    ..s phar=""
	..f  s phar=$o(^DHCPHARi("PRESCNO",prescno,phar)) q:phar=""  d
	...s notuse=$p(^DHCPHARW(phar),"^",7)
	...q:notuse=1
	...s retflag=$p(^DHCPHARW(phar),"^",13)
	...q:retflag'="1"
	...s prt=+$p(^DHCPHARW(phar),"^",1)
	...s phw=+$p(^DHCPHARW(phar),"^",4)
    ..s m=m+1
    ..s index=""_"^"_phl_"^"_phw_"^"_prt_"^"_prescno
	..s ^TMPDHCOUTAUTODISP(pid,index)=""
   
    k ^TMPPRESCINFO(pid)
    s ret=m_"^"_pid
	q ret
	
GetFyWinListByPyWin
	s pywinsub=0
	f  s pywinsub=$o(^DHCPHPY(GPhw,"PHW",pywinsub)) q:pywinsub=""  d
	.s pyfywin=+$p(^DHCPHPY(GPhw,"PHW",pywinsub),"^",1)
	.s PyFyWin(pyfywin)=""
	q
}

/// 自动配药
ClassMethod InsertPHDispAuto(cyflag, pid, GPhl, GPhw, GPydr, GFydr)
{
	s ret=""
	s index=""
	f  s index=$o(^TMPDHCOUTAUTODISP(pid,index)) q:index=""  d
	.s prt=$p(index,"^",4)
	.s prescno=$p(index,"^",5)
	.s phddrow=$o(^DHCPHDISPi("PRESCNO",prescno,""))
	.i phddrow'="" d
	..// 判断是否需要重新打印
	..s chkPrint=..ReCheckPrintPharWin(prescno)
	..i $p(chkPrint,"^",1)<0 s phddrow=""
	.e  s phddrow=##class(web.DHCOUTPHA.Disp.Dispen).InsertPHDisp(prt,GPhl,GPhw,GPydr,GFydr,prescno,"","")
	.i +phddrow>0 d
	..i ret="" d
	...s ret=phddrow_"$"_prescno
	..e  d
	...s ret=ret_"^"_phddrow_"$"_prescno
	k ^TMPDHCOUTAUTODISP(pid)
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

ClassMethod InsertPHDisp(prt As %Library.String = "", phl As %Library.String = "", phw As %Library.String = "", pydr As %Library.String = "", fydr As %Library.String = "", prescno As %Library.String = "", phwpos As %Library.String = "", pyusercode As %Library.String = "", ordstr = "", updflag = "")
{
	//wyx 增加loclog取自登录科室session里的科室
	s loclog=%session.Data("LOGON.CTLOCID")
	s hospid=$p(^CTLOC(loclog),"^",22)
	s Params="^"_loclog_"^^"_hospid
	s NeedSkinTest=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTOUTPH","SKINTESTFLAG",Params) //皮试配置,为Y时需要判断,yunhaibao20160531
	s chkreclocflag=##class(web.DHCOutPhCommon).GetChkRecLocFlag()
	///准备实发数量医嘱数据
	s owedr=$p(ordstr,"&&",4)
	s pid=##CLASS(web.DHCSTKUTIL).GetOutDispCounter()
	s sysdate="",systime="",phperson=""
	s sysdate=$p($h,",",1)
	s systime=$p($h,",",2)
	i pyusercode'="" s phperson=..GetPhpFrUserCode(pyusercode,phl)
	i phperson'="" s pydr=phperson
	s ctlocdr="" 
	s ctlocdr=+$p(^DHCPHLOC(phl),"^",1)
	s cyflag=$p(^DHCPHLOC(phl),"^",6)
	s box=0,pharw=""
	//i phw'="" s box=..GetCurrBox(phw)
	s pysure=""
	i $d(^GLobDHCPHLOC(phl))  d
	.s pysure=$p(^GLobDHCPHLOC(phl),"^",7)				//需配药确认
	s chkreclocflag=##class(web.DHCOutPhCommon).GetChkRecLocFlag()				//跨科室发药标志
    //s insertpresc=""
	//s insertpresc=##class(web.DHCOutPhDisp).GetDSPRowid(prescno,prt)
	//i insertpresc'="" q 0
	s papmidr=""
	s papmidr=##class(web.DHCOutPhCommon).GetPapmiByPresc(prescno)

	s prt=""       																//2018.03.26  zzd  忽视发票  
	s phause="",phaok="",winpycode=""
	s pha=""
	f  s pha=$o(^DHCPHARi("PRESCNO",prescno,pha)) q:pha=""  d           
	.s fphldr="" 
	.s fphldr=+$p(^DHCPHARW(pha),"^",3)
	.q:(fphldr'=phl)&(chkreclocflag=1)
	.s phaprescno=""
	.s phaprescno=$p(^DHCPHARW(pha),"^",16)
	.q:phaprescno'=prescno
	.q:owedr'="" ///如果是欠药发药，则不考虑状态
	.s phause=$p(^DHCPHARW(pha),"^",7)
	.s phaok=$p(^DHCPHARW(pha),"^",6)
	.s pharw=+$p(^DHCPHARW(pha),"^",4)
    i pharw'="" s winpycode=..GetWinDayPyCode(pharw)
    //i phause="1" q -9
    //i phaok="1" q -10
    //s phdinf=0
    //s phdinf=##class(web.DHCOutPhTQDisp).CheckPrescDsp(prescno,prt)
    //i phdinf'=0 q -1
    
    l +^DHCOEDISPENSING(prescno):5  e  q -50   ;加锁
            
    s chkerr=##class(web.DHCOutPhDisp).CheckNotUseNew(prescno,phl)			 //2018.03.26  zzd  忽视发票  
    i chkerr=1 d unlock
	q:chkerr=1 -1
	s chkerr=##class(web.DHCOutPhDisp).CheckBeforUpdate(prescno,phl)
	i (chkerr=1)&(owedr="")  d unlock
	q:(chkerr=1)&(owedr="") -3 ///如果是欠药发药，则不考虑已发状态
	s chkerr=##class(web.DHCOutPhDisp).CheckBeforInsertNew(prescno,phl,0)  //2018.03.26  zzd  忽视发票  
	i (chkerr=1)&(owedr="")&(updflag'="") d unlock
	q:(chkerr=1)&(owedr="")&(updflag'="") 0
	i (chkerr=1)&(owedr="")&(updflag="") d unlock
	q:(chkerr=1)&(owedr="")&(updflag="") -2 ///如果是欠药发药，则不考虑已配状态
	s chkerr=##class(web.DHCOutPhCommon).GetOrdXState(prescno,phl)
	//i chkerr=1 d unlock
	//q:chkerr=1 -4
	i (owedr'="")&(..GetOwdStatus(owedr)'="") d unlock
	q:(owedr'="")&(..GetOwdStatus(owedr)'="") -5                //如果是欠药,判断是否已配完
    s oeordqtystr=##class(web.DHCOutPhDisp).GetOrdQtyStr(prescno)
    TSTART
	Set $ZT="troll"
	///生成欠药单
	s retphow=""
	i ordstr'="" d
	.s retphow=..InsertOweData(sysdate,systime,pid,ordstr,phl,prt,prescno,fydr) 
	i retphow<0 Tro
	i retphow<0 d unlock
	i retphow=-10 q -10
	i retphow<0 q -99
	s chkallowe=$p(ordstr,"&&",2)
	//i $g(chkallowe)=1 TCOMMIT
	//i $g(chkallowe)=1 d unlock
	//i $g(chkallowe)=1 q retphow 
	s fyflag="-1",pyflag="",pyuserid=""
    i (pysure'="1")||(updflag'="")  d
	.s fyflag="0"
	.s pyflag="1"
	.s pyuserid=pydr
    ///生成配药单
    s prtflag=1  
	&sql(insert into SQLUSER.dhc_phdispen
		(phd_prtdate,phd_prt_dr,phd_papmi_dr,phd_phl_dr,
	     phd_phw_dr,phd_pydate,phd_pytime,phd_prescno,phd_pattype,phd_serialno,PHD_PRINTFLAG,
	     PHD_OWE_DR,PHD_PYFLAG,PHD_FYFLAG,PHD_PHP_PYDR)
		values
		(:sysdate,:prt,:papmidr,:phl,
		 :pharw,:sysdate,:systime,:prescno,:phwpos,:winpycode,:prtflag,
		 :owedr,:pyflag,:fyflag,:pyuserid)
		)
	i SQLCODE'=0 TRo
	i SQLCODE'=0 d unlock
	i SQLCODE q -6
	s phdrow=""
	s phdrow=+$g(%ROWID)
	s insubsuess=0  
	s m=0
	s ord=""
    f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:(ord="")!(insubsuess'=0)  d
    .s itm=""
    .f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:(itm="")!(insubsuess'=0)  d
    ..s oeori=ord_"||"_itm
    ..s nouseitm=""
    ..s OEPrescNo=$p(^OEORD(ord,"I",itm,1),"^",14)
    ..q:prescno'=OEPrescNo
    ..q:##class(web.DHCSTInterfaceFromElse).ICheckOrderIsRefundAudit(oeori)="Y" //已做退费申请
    ..//add wyx 2015-02-28 急诊留观病人增加欠费控制
    ..s EmLGflag=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",17)
    ..s patadm=##class(web.DHCOutPhDisp).getadm(prescno)
    ..s AmtRet=##class(web.DHCSTPCHCOLLS2).CheckArrearsNew("",patadm,oeordqtystr,loclog)
    ..i (EmLGflag="1")&(AmtRet="N") s insubsuess=100
    ..q:insubsuess'=0
    ..//add wyx 2015-02-28 急诊留观病人增加欠费控制
    ..s reclocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
    ..q:(ctlocdr'=reclocdr)&(chkreclocflag=1)   //是否需要判断科室
    ..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)                                      
    ..s payflag=$p(^OEORD(ord,"I",itm,3),"^",5)
	..q:(payflag'="P")&(oeflag'="V")&(oeflag'="E")  //急诊留观未交费过滤掉停医嘱     
    ..s priority=$p(^OEORD(ord,"I",itm,1),"^",8)    
	..s priordesc=""
	..i priority'="" s priordesc=$p(^OECPR(priority),"^",2)
	..q:priordesc["自备"
	..s prcode=""
	..s pr=$p(^OEORD(ord,"I",itm,1),"^",8)
    ..i pr'="" s prcode=$p(^OECPR(pr),"^",1)
    ..q:prcode["OM"
	..s qty=0,money=0
	..s qty=##class(web.DHCOutPhDisp).getDspQty(oeori)
	..;
	..s oldqty=qty
	..s realqty=+$g(^TMP(pid,"TMPRealQty",oeori)) ///获取实发数量
	..i ordstr'="" s qty=realqty
	..i +prt'=0 d
    ...s ordpriceinfo=##class(web.DHCOutPhCommon).GetBasPriceByInv(prt,oeori)
	...s paidFlag=$p(ordpriceinfo,"^",3)
	...i paidFlag=0 s nouseitm=0	//20160216改为判断是否有账单记录
	..q:$g(nouseitm)=0
    ..s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,"")) // 医嘱改造
    ..k ExistInclb
    ..s dspSub=0
    ..f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:(dspSub="")||(insubsuess'=0)  d
	...s dspInci=$p(^DHCOEDISQTY(dspId,"I",dspSub),"^",5) 
	...s dspInclb=$p(^DHCOEDISQTY(dspId,"I",dspSub),"^",1)
	...q:(dspInclb'="")&&($d(ExistInclb(+dspInclb))) 		//批次价一个药品只判断一次
	...s ExistInclb(+dspInclb)=""
	...s qty=$p(^DHCOEDISQTY(dspId,"I",dspSub),"^",2)
	...i dspInclb'="" s qty=##class(web.DHCSTCOMMONSRV).GetDspInciQtyByDsp(dspId,+dspInclb,3) 
	...s Inci=$s(dspInclb'="":+dspInclb,1:+dspInci)
	...s ch=$o(^INCI("IL_LOC",ctlocdr,Inci,""))
	...i ch="" s insubsuess=10
	...q:ch=""
    ...s incil=Inci_"||"_ch
    ...s inciQty=##class(web.DHCSTSTKQTY).GetPhaQty(incil,qty)
    ...i inciQty=0 s insubsuess=10
    ...q:inciQty=0
    ..q:insubsuess'=0
	..s m=m+1
	..&sql(insert into SQLUSER.DHC_PHDISITEM(phdi_phd_parref,phdi_childsub,phdi_oeori_dr)values(:phdrow,:m,:oeori))
	..i SQLCODE'=0 s insubsuess=insubsuess+1
	.
	i (m=0)&&(insubsuess=0) s insubsuess=11
	i NeedSkinTest="Y" d
	.s checkskintest=##class(web.DHCOutPhDisp).CheckSkinTestByPhd(phdrow)
	.i (checkskintest=1) s insubsuess=-123
	i insubsuess'=0 Tro
	i insubsuess'=0 d unlock
	q:insubsuess=10 -7
	q:insubsuess=100 -9
	q:insubsuess=-123 -123
	q:insubsuess'=0 -8
	
	s phaid="",updateflag=0
	f  s phaid=$o(^DHCPHARi("PRESCNO",prescno,phaid)) q:(phaid="")!(insubsuess'=0)!(updateflag'=0)  d   //2018.03.26  zzd  忽视发票 替换上一行
	.s phldr="",phwdr=""
	.s phldr=+$p(^DHCPHARW(phaid),"^",3)
	.q:(phldr'=phl)&(chkreclocflag=1)
	.s phwdr=+$p(^DHCPHARW(phaid),"^",4)
	.;q:phwdr'=phw
	.s phaprescno=""
	.s phaprescno=$p(^DHCPHARW(phaid),"^",16)
	.q:phaprescno'=prescno
	.s ret=##class(web.DHCOutPhDisp).UpdPyPharwin(phaid,prescno,box)   
    .s updateflag=ret
	i updateflag'="0" d unlock
	i updateflag'="0" tro
   q:updateflag'=0 updateflag
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
   	f  s phaid=$o(^DHCPHARi("PRESCNO",prescno,phaid)) q:phaid=""  d
	   .s phldr="",phwdr=""
	   .s phldr=+$p(^DHCPHARW(phaid),"^",3)
	   .q:phldr'=phl
	   .s phaprescno=""
	   .s phaprescno=$p(^DHCPHARW(phaid),"^",16)
	   .q:phaprescno'=prescno
	   .s $p(^DHCPHARW(phaid),"^",6)="1"
    
	s phdrow="",pharow="",ret="",suess=0
	f  s phdrow=$o(^DHCPHDISPi("PRESCNO",prescno,phdrow)) q:(phdrow="")!(suess'=0)  d
	  .s phdprescno=""
	  .s phdprescno=$p(^DHCPHDISP(phdrow,2),"^",1)
	  .q:phdprescno'=prescno
	  .&sql(update dhc_phdispen set phd_fydate=:currdate,PHD_FYTIME=:currtime,PHD_FYFLAG='1', 
	  		PHD_PHP_FYDR=:fydr where phd_rowid=:phdrow)
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
	    ..s dsptype="F"
	    ..s dspstatus="C"
	    ..&sql(update sqluser.dhc_oedispensing set dsp_pointer=:pointer,dsp_type=:dsptype,dsp_status=:dspstatus,dsp_date=:currdate,dsp_time=:currtime where dsp_oeori_dr=:oeori )
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

ClassMethod InsertPyScreenOld(ctloc, pmi, pername, prt, presc, windesc, roomtype)
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

ClassMethod InsertFyScreenOld(ctloc, pmi, pername, prt, presc, windesc, roomtype)
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
    .s mixflag=$p(^DHCPHPER(php),"^",8) //审核
    .i (pyflag'="1")&(flag=1) s ret="-1"
    .i (fyflag'="1")&(flag=2) s ret="-1"
    .i (mixflag'="1")&(flag=3) s ret="-1"
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
   s sysdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(+$h,"OP")
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
     .///注释 bianshuai 2015-12-11 窗口状态不自动设置
     .///&sql(update sqluser.dhc_phpywin set phpy_doflag='1' where phpy_rowid=:pywin)
     .///i SQLCODE'=0 d
     .///.&sql(update sqluser.dhc_phwper set phwp_doflag='1' where phwp_phw_dr=:pywin)
     .s ret=phl_"^"_pydr
     .
  q ret
}

/// w #class(web.DHCOutPhTQDisp).GDescFrid("","","2","")
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

ClassMethod GetPhpFrUserCode(usercode, phloc)
{
  //s phloc=$o(^DHCPHLOCi("LOC",ctloc,""))
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

/// w ##class(web.DHCOutPhTQDisp).CheckPyCode(702,100)
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
	l +^DHCTMPDAYPHWIN(+$h,win):5 e  q -1
	i $d(^DHCTMPDAYPHWIN(+$h,win)) d
	  .s retcode=$g(^DHCTMPDAYPHWIN(+$h,win))+1
	  .s ^DHCTMPDAYPHWIN(+$h,win)=retcode
	e  d
	  .s ^DHCTMPDAYPHWIN(+$h,win)=1
	  .s retcode=1
	l -^DHCTMPDAYPHWIN(+$h,win)
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
	f  s phdrow=$o(^DHCPHDISPi("PRESCNO",presc,phdrow)) q:phdrow=""  d
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
	.s phdprt=$p(^DHCPHDISP(phdrow),"^",2)
	.//zhouyg 20130711 对不收费就发药的也要认为是正常的
	.s prtuseflag=""
	.i phdprt'="" d
	..q:'$d(^DHCINVPRT(phdprt))
    ..s prtuseflag=$p(^DHCINVPRT(phdprt),"^",8)
    .q:(phdprt'="")&(prtuseflag'["N")
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

/// w ##class(web.DHCOutPhTQDisp).GetPydr("yf01","243")
ClassMethod GetPydr(usercode, ctloc)
{
	i usercode="" q "-1^未输入工号，请核实！"
	s usercode=$ZCVT(usercode,"U")
	s userid=""
	s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",usercode,""))
	i userid="" q "-2^该工号不存在，请核实!"
	s phl=""
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl="" q "-3^未在门诊药房科室维护中维护该药房，请核实!"
	s phprow="",retphp=""
	f  s phprow=$o(^DHCPHPERi("USR",userid,phprow)) q:phprow=""  d
	.s phpl=""
	.s phpl=+$p(^DHCPHPER(phprow),"^",3)
	.q:phpl'=phl
	.s phpy=$p(^DHCPHPER(phprow),"^",6)
	.s retphp=phprow
	i retphp="" q "-4^工号对应的配药人没有定义,请在药房人员代码维护中核实!"
	i phpy'=1 q "-5^工号对应的配药人没有配药权限，确认失败!"
	q retphp
}

/// 处方确认,减掉窗口工作量
/// w ##class(web.DHCOutPhTQDisp).UpdatePhdRowid(192,308)
ClassMethod UpdatePhdRowid(phd, ctloc, pydr, boxid = "")
{
    s phl=$o(^DHCPHLOCi("LOC",ctloc,"")) 
    s cyflag="",prt=""
    s cyflag=$p(^DHCPHLOC(phl),"^",6)
    s presc=$p(^DHCPHDISP(phd,2),"^",1)
    s sysDate=+$h
    s sysTime=$p($h,",",2)
    l +^DHCST("DHCOutPhTQDisp","UpdatePhdRowid",presc):5  E  Q -9
    Tstart
	&sql(update dhc_phdispen set phd_php_pydr=:pydr,phd_pyflag='1',PHD_FYFLAG='0',PHD_PYEDDATE=:sysDate,PHD_PYEDTIME=:sysTime where phd_rowid=:phd) 
	i SQLCODE'=0 d unlock
    q:SQLCODE'=0 -1
    s win=$p(^DHCPHDISP(phd,1),"^",4)
    s ret=##class(web.DHCMZYFXTYW02).GoToUpdCurrWinWork(phl,win,presc)
    i ret'=0 d unlock
    q:ret'=0 -2
    //增加药框号 hulihua 2016-07-06
    s errCode=""
   	i $d(^DHCPHARi("PRESCNO",presc)) d
    .&sql(update DHC_PHARWIN set pha_lcdserialno=:boxcode where Pha_PrescNo=:presc and PHA_NOUSER is null) 
	.i SQLCODE'=0 s errCode=-3 d unlock q
	q:errCode'="" errCode
    Tcommit
    l -^DHCST("DHCOutPhTQDisp","UpdatePhdRowid",presc)
    q 0

unlock
   Tro
   l -^DHCST("DHCOutPhTQDisp","UpdatePhdRowid",presc)
   q
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
	    ..s prtdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(prtdate,"OP")
	    ..s phatime=+$p(^DHCINVPRT(prt),"^",20)
	    ..s phatime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(phatime,"OP")
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
	    ..s prtdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(phadate,"OP")
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

/// Desc:把处方分类 
/// Creator:LiangQiang
/// Input:处方号
/// Output:1--普通，2--急诊，3--儿科，4--毒麻、精一，5--精二
ClassMethod GetPrescTitle(presc)
{
	s prescord="",prescitm="",retval=""
	s prescord=$o(^OEORD(0,"PrescNo",presc,""))
	i prescord="" q ""
	s prescitm=$o(^OEORD(0,"PrescNo",presc,prescord,""))
	s prescitmmast=""
    s prescitmmast=$p($g(^OEORD(prescord,"I",prescitm,1)),"^",2)
    s prescdrgform="",prescdrgmast=""
    s prescdrgform=$p(^ARCIM($p(prescitmmast,"||",1),$p(prescitmmast,"||",2),1),"^",12)
    s prescdrgmast=$p(prescdrgform,"||",1)
    s prescpoisondr=""
    i +prescdrgmast'=0 s prescpoisondr=+$p($g(^PHCD(prescdrgmast,1)),"^",4)
    i prescpoisondr'="" s poisondesc=$p($g(^PHCPO(prescpoisondr)),"^",2)
    s prescitmcat="",oeccat="",oecatdesc=""
    s prescitmcat=$p(^ARCIM($p(prescitmmast,"||",1),$p(prescitmmast,"||",2),1),"^",10)
	s oeccat=$p(^ARC("IC",prescitmcat),"^",8)
	s oecatdesc=$p(^OEC("ORCAT",oeccat),"^",2)
    i (poisondesc["毒")||(poisondesc["麻")||( (poisondesc["精")&(poisondesc["一") ) q "毒麻、精一"
    i (poisondesc["精")&(poisondesc["二")  q "精二"
    s useradddept=$p($g(^OEORD(prescord,"I",prescitm,7)),"^",2)
    q:$p($g(^CTLOC(+useradddept)),"^",2)["儿" "儿科"
    q:presc["E" "急诊"  
	q "普通"
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
	s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateSt)
	s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateEnd)
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
	    ..s prtdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(phadate,"OP")
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

/// 生成欠药单
/// 
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
    .s arcimid=$p(^OEORD(+tmpoeori,"I",$p(tmpoeori,"||",2),1),"^",2)  
    .s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
    .s buomdr=$p(^INCI(inci,1),"^",10)
    .s fac=##class(web.DHCSTCOMMONSRV).UOMFac(tmpunit,buomdr)
    .s oweqty=tmpphqty-tmprealqty
    .s oweqty=oweqty*fac
    .s tmprealqty=tmprealqty*fac
    .s ^TMP(pid,"TMPRealQty",tmpoeori)=tmprealqty
    .i oweqty'=0 s ^TMP(pid,"TMPOWEQty",prescno,tmpoeori)=oweqty
  
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
    q:(tmpowedr'="")&($G(exit)'="") -10  ///该欠药单已发
   
    i '$D(^TMP(pid,"TMPRealQty")) s ^tmprealdata(sysdate, systime, pid)=ordstr
    q:'$D(^TMP(pid,"TMPRealQty")) -109 
    q:'$D(^TMP(pid,"TMPOWEQty")) 0 
    
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
    f  s oeori=$o(^TMP(pid,"TMPOWEQty",prescno,oeori)) q:(oeori="")!(insubsuess'=0)  d
    .s oweqty=^TMP(pid,"TMPOWEQty",prescno,oeori)
    .s ord=$p(oeori,"||",1)
    .s itm=$p(oeori,"||",2)
    .s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
	.s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),""))
	.s BillFlag=$p(^OEORD(ord,"I",itm,3),"^",5)
    .;i prt'="" d
    .i BillFlag="P" d   //2018.03.26  zzd  忽视发票  根据医嘱是否结算判断，取价格方式
    ..s ordpriceinfo=##class(web.DHCOutPhCommon).GetBasePriceByOe(oeori)  //2018.03.26  zzd  忽视发票  根据医嘱是否结算判断，取价格方式
	..s spice=$p(ordpriceinfo,"^",1)
	.;i prt="" d
	.i BillFlag'="P" d   //2018.03.26  zzd  忽视发票  根据医嘱是否结算判断，取价格方式
	..s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(ctlocdr)
    ..s hospdr=$p(HospString,"^",1)
	..//s spice=##class(web.DHCSTCOMMONSRV).GetPriceElse(+inci,+$h,"",hospdr)
	..s exStr=oeori_"^"
	..s spice=##class(web.DHCSTPRICE).GetSp(+inci,+$h,"",hospdr,"",exStr)	//zhouyg 20150113
    .s i=i+1
    .&sql(insert into SQLUSER.DHC_PHOweListItm(PHOI_OrdItm,PHOI_Qty,PHOI_PHO_PARREF,PHOI_ChildSub,PHOI_Price)
	     values(:oeori,:oweqty,:phow,:i,:spice))
    .i SQLCODE'=0 s insubsuess=insubsuess+1
    .q:insubsuess'=0
    .//全部欠药时，直接置医嘱状态为已发
	.s dsp=""
    .f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,dsp)) q:dsp=""  d
    ..s dspstatus=$p(^DHCOEDISQTY(dsp),"^",7)
    ..q:dspstatus'="TC"
    ..i chkallowe="1" d
    ...;&sql(update sqluser.dhc_oedispensing set dsp_pointer="",dsp_type='F',dsp_status='C',dsp_date=:sysdate,dsp_time=:systime where DSP_RowId=:dsp )
    ...;i SQLCODE'=0 s insubsuess=insubsuess+1
    .q:insubsuess'=0
    q:insubsuess'=0 -4
    s phaid=""
	f  s phaid=$o(^DHCPHARi("PRESCNO",prescno,phaid)) q:phaid=""  d
	.s phprt=+$p(^DHCPHARW(phaid),"^",1)
	.q:+prt'=phprt
	.s phldr="",phwdr=""
	.s phldr=+$p(^DHCPHARW(phaid),"^",3)
	.q:(phldr'=phl)&(chkreclocflag=1)
	.s phwdr=+$p(^DHCPHARW(phaid),"^",4)
	.s phaprescno=""
	.s phaprescno=$p(^DHCPHARW(phaid),"^",16)
	.q:phaprescno'=prescno
	.;i $g(chkallowe)=1 s $p(^DHCPHARW(phaid),"^",6)="1"  //全部欠药时，则标志已发药
	.
	
    q phow
}

/// 撤消配药单 0 - 成功  <0 - 不成功
/// 
ClassMethod CancelPYD(phl, prescno, pydr, prt)
{
	q:prescno="" -99
	q:'$d(^DHCPHDISPi("PRESCNO",prescno)) -98 //未配
	TSTART
    Set $ZT="troll"
    l +^DHCOEDISPENSING(phl,prescno):5  e  q -50   ;加锁
	s ret=0
	s canclephar=""
	s phd="",fyflag=""
	f  s phd=$o(^DHCPHDISPi("PRESCNO",prescno,phd)) q:(phd="")||(ret'=0)  d
	.s phdphl=$p(^DHCPHDISP(phd,1),"^",1)
	.q:phdphl'=phl
	.s phprt=$p(^DHCPHDISP(phd),"^",2)
	.q:(prt'="")&(phprt'=prt)
	.s fyflag=$p(^DHCPHDISP(phd),"^",4)
	.i fyflag=1 s ret=-1
	.q:ret'=0
	.&sql(delete from DHC_PHDISPEN where PHD_ROWID=:phd)
	.i SQLCODE'=0 s ret=-2
	.q:ret'=0
	
	i ret'=0 tro
	i ret'=0 d unlock
	q:ret'=0 ret
	
	s ord=$o(^OEORD(0,"PrescNo",prescno,""))
	s adm=$p(^OEORD(ord),"^",1)
	s papmi=$p(^PAADM(adm),"^",1)
	s phow="" 
	f  s phow=$o(^DHCPHOWi(0,"PAPMI",papmi,prescno,phow)) q:(phow="")||(ret'=0)  d
	.s owestatus=$p(^DHCPHOW(phow),"^",8)
	.i owestatus'="" s ret=-3
	.q:ret'=0
	.s oweretdate=$p(^DHCPHOW(phow),"^",10)
	.i oweretdate'="" s ret=-4
	.q:ret'=0
	.&sql(delete from DHC_PHOweList where PHO_RowID=:phow)
	.i SQLCODE'=0 s ret=-5
	.q:ret'=0
	.s ret=..UpdUnDispen(prescno)
	.q:ret'=0

	i ret'=0 Tro
	i ret'=0 d unlock
	q:ret'=0 ret
	
	//处理中间表
	s phar=""
	f phar=$o(^DHCPHARi("PRESCNO",prescno,phar)) q:(phar="")||(ret'=0)  d
	.s pharprt=$p(^DHCPHARW(phar),"^",1)
	.q:(pharprt'=prt)&(prt'="")
	.s nouse=$p(^DHCPHARW(phar),"^",7)
	.q:nouse=1
	.s auditflag=$p(^DHCPHLOC(phl),"^",7)
	.i auditflag'="Y" d
	..&sql(update DHC_PHARWIN set PHA_PRINTFLAG=null where PHA_ROWID=:phar )
	..i SQLCODE'=0 s ret=-6
	.
	i ret'=0 Tro
	i ret'=0 d unlock
	q:ret'=0 ret
	
	d unlock
	TCOMMIT
	q 0
	
troll
   Set $ZT=""
   TRo
   d unlock
   s ErrorMsg=$ZE
   q ErrorMsg

unlock
   l -^DHCOEDISPENSING(phl,prescno)
   q
}

/// 判断欠药单已否已配
ClassMethod GetOwdStatus(owedr)
{
  q:owedr="" ""	
  s owestatus=$p(^DHCPHOW(owedr),"^",8)
  s oweretdate=$p(^DHCPHOW(owedr),"^",10)
  i oweretdate'="" q 1
  i owestatus'="" q 1
  q owestatus
}

/// 取欠药单状态
ClassMethod GetOwdStatusNum(owedr)
{
  q:owedr="" ""	
  s owestatus=$p(^DHCPHOW(owedr),"^",8)
  s oweretdate=$p(^DHCPHOW(owedr),"^",10)
  i oweretdate'="" q 3
  q owestatus
}

ClassMethod UpdUnDispen(prescNo)
{
    s exit=0
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescNo,ord)) q:(ord="")!(exit=1)  d
	.s chl=""
	.f  s chl=$o(^OEORD(0,"PrescNo",prescNo,ord,chl) ) q:(chl="")!(exit=1)  d
	..s oeori=ord_"||"_chl
	..s dsp=""
    ..f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,dsp)) q:dsp=""  d
    ...s dspcoll=$p(^DHCOEDISQTY(dsp),"^",7)
    ...s dspstatus="TC"
    ...&sql(update sqluser.dhc_oedispensing set dsp_pointer=null,dsp_type=null,dsp_status=:dspstatus,dsp_date=null,dsp_time=null where DSP_RowId=:dsp )
    ...i SQLCODE'=0 d
    ....s exit=1
    q exit
}

/// 获取窗口列表
ClassMethod GetFYWinListClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetFYWinListExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// w ##class(%ResultSet).RunQuery("web.DHCOutPhTQDisp","GetFYWinList",11,42,"1")
ClassMethod GetFYWinListExecute(ByRef QHandle As %Binary, GPhl As %String, GPhw, FYType = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	Set QHandle=$lb(0,repid,0)
	i GPhl=""  Quit $$$OK
	s pid=##CLASS(web.DHCSTKUTIL).GetOutDispCounter()
	k ^TMP("DHCOutPh","web.DHCOutPhTQDisp","GetFYWinList",pid)
	s ind=1
	s pydate=+$h
	s warnlevel=""
	/************用于直接发药**********/
    i FYType="1" d
	.s phar=""
	.f  s phar=$o(^DHCPHARWi(pydate,GPhl,phar)) q:phar=""  d
	..s phwindr=$p(^DHCPHARW(phar),"^",4)
	..//q:(GPhw'="")&(GPhw'=phwindr)  //过滤窗口,直接发药不过滤
	..s dispflag=$p(^DHCPHARW(phar),"^",6)
	..q:dispflag="1"  //已发药数据不在显示 
	..s nouseflag=$p(^DHCPHARW(phar),"^",7)  //发票作废
	..q:nouseflag="1"
	..s prescno=$p(^DHCPHARW(phar),"^",16)
	..q:prescno=""
	..s phdr=$o(^DHCPHDISPi("PRESCNO",prescno,""),-1)
	..q:(phdr'="")&&($p(^DHCPHDISP(phdr),"^",4)=1)
	..s ord=$o(^OEORD(0,"PrescNo",prescno,""))
	..q:+ord=0
	..s forditm=$o(^OEORD(0,"PrescNo",prescno,ord,""))
	..s ssresult=##class(web.DHCOutPhCommon).GetOrdAuditResultByPresc(prescno)
	..q:ssresult'="Y"
	..s RefResult=##class(web.DHCOutPhCommon).GetOrdRefResultByPresc(prescno)
	..q:(RefResult="A")||(RefResult="N")			//拒绝  或拒绝接受
	..s doclocstr=##class(web.DHCOutPhCommon).GetOrdUseLocByPresc(prescno)
    ..s uselocdr=$p(doclocstr,"^",1)
    ..q:uselocdr'="" // 默认不显示基数药,基数药不在药房发给病人
	..s payDispFlag=##class(PHA.OP.COM.Method).GetDispBeforePay(ord_"||"_forditm)
	..q:payDispFlag="Y"
    ..s warnlevel=##class(web.DHCOutPhCommon).GetPrescPrtTitle(prescno)
	..s paadm=$p(^OEORD(ord),"^",1)
	..s papmi=$p(^PAADM(paadm),"^",1)
    ..s patname=$p(^PAPER(papmi,"ALL"),"^",1)
	..s patid=$p(^PAPER(papmi,"PAT",1),"^",2)
	..s $p(^TMP("DHCOutPh","web.DHCOutPhTQDisp","GetFYWinList",pid,patname,patid),"^",1)=papmi
	..i (warnlevel["毒")||(warnlevel["麻") d
	...s $p(^TMP("DHCOutPh","web.DHCOutPhTQDisp","GetFYWinList",pid,patname,patid),"^",2)=warnlevel
	d OutPutGetFYWinList
 	i FYType="1" Quit $$$OK
    /*********************************/
    s warnlevel=""
    s phdr=""
    f  s phdr=$o(^DHCPHDISPi(pydate,GPhl,phdr)) q:phdr=""  d
    .s fyflag=$p(^DHCPHDISP(phdr),"^",4)
    .q:fyflag=1
    .s pyflag=$p(^DHCPHDISP(phdr,1),"^",6)
    .q:pyflag'=1
    .s phwindr=$p(^DHCPHDISP(phdr,1),"^",4)
    .q:(GPhw'="")&(GPhw'=phwindr)
    .s papmi=$p(^DHCPHDISP(phdr),"^",7)
    .s prt=+$p(^DHCPHDISP(phdr),"^",2)
    .s prescno=$p(^DHCPHDISP(phdr,2),"^",1)
    .s ssresult=##class(web.DHCOutPhCommon).GetOrdAuditResultByPresc(prescno)
	.q:ssresult'="Y"
	.s RefResult=##class(web.DHCOutPhCommon).GetOrdRefResultByPresc(prescno) 
	.q:(RefResult="A")||(RefResult="N")				//拒绝  或拒绝接受
    .s exitflag=0
    .i prt'=0 d
    ..s phar=""
    ..f  s phar=$o(^DHCPHARi("PRESCNO",prescno,phar) ) q:phar=""  d
    ...s nouse=$p(^DHCPHARW(phar),"^",7)
    ...q:nouse=1
    ...s exitflag=1
    .q:(prt'=0)&(exitflag=0)
    .s patname=$p(^PAPER(papmi,"ALL"),"^",1)
	.;s patid=$p(^PAPER(papmi,"ALL"),"^",9)
	.s patid=$p(^PAPER(papmi,"PAT",1),"^",2)
	.s warnlevel=##class(web.DHCOutPhCommon).GetPrescPrtTitle(prescno)
	.s $p(^TMP("DHCOutPh","web.DHCOutPhTQDisp","GetFYWinList",pid,patname,patid),"^",1)=papmi
	.i (warnlevel["毒")||(warnlevel["麻") d
	..s $p(^TMP("DHCOutPh","web.DHCOutPhTQDisp","GetFYWinList",pid,patname,patid),"^",2)=warnlevel
	d OutPutGetFYWinList
    Quit $$$OK
OutPutGetFYWinList
	s patname=""
	f  s patname=$o(^TMP("DHCOutPh","web.DHCOutPhTQDisp","GetFYWinList",pid,patname)) q:patname=""  d
	.s patid=""
	.f  s patid=$o(^TMP("DHCOutPh","web.DHCOutPhTQDisp","GetFYWinList",pid,patname,patid)) q:patid=""  d
	..s patData=^TMP("DHCOutPh","web.DHCOutPhTQDisp","GetFYWinList",pid,patname,patid)
	..s EncryptLevelInfo=""
    ..s EncryptLevel=""
    ..s PatLevel="" 
    ..s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
    ..i EncryptFlag=1 d
	...s papmidr=$p(patData,"^",1)
    ...s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmidr,"")
 	...s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 	...s PatLevel=$p(EncryptLevelInfo,"^",2)
 	..s WarnLevel=$p(patData,"^",2)
    ..s Data=$lb(patname,patid,EncryptLevel,PatLevel,WarnLevel)
    ..s ^CacheTemp(repid,ind)=Data	
 	..s ind=ind+1
 	k ^TMP("DHCOutPh","web.DHCOutPhTQDisp","GetFYWinList",pid)
	q
}

ClassMethod GetFYWinListFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFYWinListExecute ]
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

Query GetFYWinList(GPhl As %String, GPhw, FYType = "") As %Query(ROWSPEC = "tbname:%String,tbpatid:%String,TEncryptLevel:%String,TPatLevel:%String,TWarnLevel:%String") [ SqlProc ]
{
}

/// Description:根据处方取发药主表id
ClassMethod GetPhdFrPresc(prescno) As %String
{
	 q:prescno="" ""
	 q:'$d(^DHCPHDISPi("PRESCNO",prescno)) ""
	 s ret=""
     s phdisp=""
     f  s phdisp=$o(^DHCPHDISPi("PRESCNO",prescno,phdisp)) q:phdisp=""  d
     .s ret=phdisp
     q ret
}

ClassMethod InsertPyScreen(presc, curip)
{
  
  s phdrow=##class(web.DHCOutPhTQDisp).GetPhdFrPresc(presc)	
  q:phdrow="" 0
  s phl=$p(^DHCPHDISP(phdrow,1),"^",1) 
  s screenflag=$p(^GLobDHCPHLOC(phl),"^",5)
  q:screenflag'=1 0
  s ret=""
  s ret=##class(web.DHCOutPhInterFace).SendDHCall(presc,"",curip)
  q ret
}

ClassMethod InsertFyScreen(presc, curip)
{
  s phdrow=##class(web.DHCOutPhTQDisp).GetPhdFrPresc(presc)	
  q:phdrow="" 0
  s phl=$p(^DHCPHDISP(phdrow,1),"^",1) 
  s screenflag=$p(^GLobDHCPHLOC(phl),"^",5)
  q:screenflag'=1 0
  s ret=""
  s ret=##class(web.DHCOutPhInterFace).SendDHCall(presc,"1",curip)
  q ret
}

/// description: 自动打印配药单调用
ClassMethod ReCheckPrintPharWin(PrescNo)
{
	s curDate=+$h
	s curTime=$p($h,",",2)
	s flag=1
	s retFlag=-1
	s pharId=0
	f  s pharId=$o(^DHCPHARi("PRESCNO",PrescNo,pharId)) q:pharId=""  d
	.s pharData=$g(^DHCPHARW(pharId))
	.q:$p(pharData,"^",7)=1
	.q:$p(pharData,"^",13)'=1
	.s printFlag=$p(pharData,"^",8)
	.i printFlag="" d
	..&SQL(
		UPDATE DHC_PHARWIN 
		SET PHA_PRINTDATE=:curDate,PHA_PRINTTIME=:curTime,PHA_PRINTFLAG=:flag 
		WHERE PHA_ROWID=:pharId)
	..s retFlag=0
	q retFlag
}

ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"OP")
}

}
