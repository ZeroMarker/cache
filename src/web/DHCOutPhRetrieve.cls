Class web.DHCOutPhRetrieve Extends %Library.RegisteredObject [ Not Abstract, ClassType = "", Not ProcedureBlock ]
{

ClassMethod QueryLocPatienCXClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocPatienCXExecute ]
{
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// w ##class(%ResultSet).RunQuery("web.DHCOutPhRetrieve","QueryLocPatienCX","2018-11-06","2018-11-06","310","","","","","","","1","00:00","23:59","0","","")
ClassMethod QueryLocPatienCXExecute(ByRef QHandle As %Binary, CDateSt As %Library.String = "", CDateEnd As %Library.String = "", ctloc As %Library.String = "", CPmiNo As %Library.String = "", CPerName As %Library.String = "", CPrtInv As %Library.String = "", inci As %Library.String = "", CPydr As %Library.String = "", CFydr As %Library.String = "", FyFlag As %Library.String = "", sttime As %Library.String = "", endtime As %Library.String = "", glflag As %Library.String = "", CDepCode, CDoctor) As %Status
{
	n (QHandle,CDateSt, CDateEnd, ctloc, CPmiNo, CPerName, CPrtInv, inci, CPydr, CFydr, FyFlag, sttime, endtime, glflag, CDepCode, CDoctor)
	s ^TMPDHCSTPARAMS("web.DHCOutPhRetrieve","QueryLocPatienCX")=$lb(CDateSt, CDateEnd, ctloc, CPmiNo, CPerName, CPrtInv, inci, CPydr, CFydr, FyFlag, sttime, endtime, glflag, CDepCode, CDoctor)
	Set repid=$I(^CacheTemp)
	s indi=1,st="",end=""
	s contentstr=""
	i $g(ctloc)=""  Set QHandle=$lb(0,repid,0) Quit $$$OK
	s CDateSt=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateSt)
	s CDateEnd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateEnd)
	s sttime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(sttime)
	s endtime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(endtime)
	s st=CDateSt
	s end=CDateEnd
	i CDateSt="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	i CDateEnd="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	i st>end  Set QHandle=$lb(0,repid,0) Quit $$$OK
	s pmino=CPmiNo
	s pername=CPerName
	s prtinv=CPrtInv
	s inci=$g(inci)
	s pydr=CPydr
	s fydr=CFydr
	s phmoney=0,phcount=0
	s phl=""

	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl=""  Set QHandle=$lb(0,repid,0) Quit $$$OK

	s cyflag="",dfflag="" 
	s cyflag=$p(^DHCPHLOC(phl),"^",6)
	//FyFlag - 1 发  -0配  2 -未发 3 - 未配 4- 已打印
	i (FyFlag'="2")&&(FyFlag'=3) 
	{ 
		s phddate = "", t = 0
		f phddate=st:1:end  d
		.s phdrow = ""
		.i (FyFlag="0")||(FyFlag="4") d //yunhaibao20160217,修正为发药按发药日期,配药按配药日期查询
		..f  s phdrow=$o(^DHCPHDISPi(phddate,phl,phdrow)) q:phdrow=""  d
		...d OutPutDispData
		.i FyFlag="1" d 
		..f  s phdrow=$o(^DHCPHDISPi("FYDATE",phddate,phl,phdrow)) q:phdrow=""  d
		...d OutPutDispData
	}
	else
	{
		s locdr=$p(^DHCPHLOC(phl),"^",1)
		s leadlocdr=##class(web.DHCOutPhDisp).GetLeadLoc(locdr)
		s mainphl=$o(^DHCPHLOCi("LOC",leadlocdr,""))  //主科室
		s phl=mainphl
		s locdr=leadlocdr
		s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(locdr)
		s HospID=$p(CustStr,"^",5)
		s CustID=$p(CustStr,"^",1)
		s pid=##CLASS(web.DHCSTKUTIL).GetOutStatCounter()
		
		s preason=""
		s phadate=0
		f phadate=st:1:end  d
		.s pha=0
		.f  s pha=$o(^DHCPHARWi(phadate,phl,pha)) q:pha=""  d
		..s phw="",finflag="",nouse="",printflag="",arrcpdr="",prt="",prescno="",rpamt=0
		..s finflag=$p(^DHCPHARW(pha),"^",6)
		..q:(finflag="1")
		..s printflag=$p(^DHCPHARW(pha),"^",8)
		..q:(FyFlag=3)&&(printflag="1")
		..s nouse=$p(^DHCPHARW(pha),"^",7)
		..q:nouse="1"
		..s prttime=$p(^DHCPHARW(pha),"^",5)       
		..q:(sttime'="")&(phadate=st)&(prttime<sttime)
		..q:(sttime'="")&(phadate=end)&(prttime>endtime)
		..s pydate=$p(^DHCPHARW(pha),"^",11)
		..i pydate'="" s pydate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(pydate)
		..s pytime=$p(^DHCPHARW(pha),"^",18)
		..i pytime'="" s pytime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(pytime)
		..s prttime=$zt(prttime,1)
		..s prescno=$p(^DHCPHARW(pha),"^",16)
		..s pyname=""
		..i printflag=1 d
		...s phdid=$o(^DHCPHDISPi("PRESCNO",prescno,""))
		...i phdid'="" d
		....s pydr=+$p(^DHCPHDISP(phdid,1),"^",3)
		....i pydr'="" d
		.....i $d(^DHCPHPER(pydr))  s pyname=$p(^DHCPHPER(pydr),"^",2)
		..s adm=""
		..s qq=0,existInci=0
		..s tmpord="",tmpitm=""
		..s ord=""
		..f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:(ord="")  d
		...s adm=$p(^OEORD(ord),"^",1)
		...s itm=""
		...f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:(itm="")   d
		....s billed=$p(^OEORD(ord,"I",itm,3),"^",5)
		....q:billed'="P"
		....s adm=+$P(^OEORD(ord),"^",1)
		....s recplocdr=""
		....s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
		....q:recplocdr=""
		....q:recplocdr'=locdr		
		....s presc=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
		....q:presc=""
		....q:presc'=prescno
		....s OrdItm=ord_"||"_itm
		....s dsp=$o(^DHCOEDISQTY(0,"OEORI",OrdItm,""))
		....q:dsp=""
		....i $d(^DHCOEDISQTY(dsp,"I")) d
		.....s dspSub=0
		.....f  s dspSub=$o(^DHCOEDISQTY(dsp,"I",dspSub)) q:dspSub=""  d
		......s inc=$p(^DHCOEDISQTY(dsp,"I",dspSub),"^",5) 
		......i (inci'="")&&(inc=inci) s existInci=1
	    ......s incmanflag=""
	    ......s incich=$o(^INCI("IL_LOC",recplocdr,inc,""))
	    ......s incil=inc_"||"_incich
	    ......i $D(^DHCINCIL(0,"INCIL",incil)) d //管理药,管理组用DHC_IncItmLoc维护
	    .......s dhcincil=$o(^DHCINCIL(0,"INCIL",incil,""))
	    .......s incmanflag=$p(^DHCINCIL(dhcincil),"^",9)  //1,0
		......i (incmanflag="1")&(glflag="1") s qq=qq+1
		....s tmpord=ord
		....s tmpitm=itm
		..q:(glflag="1")&&(+qq="0")
		..q:(inci'="")&&(existInci=0)
		..s ord=tmpord
		..s itm=tmpitm
		..s arraldr=""
		..s papmidr="",papmino="",payamount0=0,phatime=""
		..s prtInfoStr=##class(web.DHCOutPhCommon).GetHandTime(prescno) 
		..s prtflag=$p(prtInfoStr,"^",1)
		..q:prtflag=0   
		..s prt=$p(prtInfoStr,"^",4)   
		..s prtcode=$p(prtInfoStr,"^",5)  
		..q:(prtinv'="")&&($lf($lfs(prtcode,","),prtinv)=0)      
		..s prtdate=""
		..s prtdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(phadate)
		..s phatime=$p(^DHCPHARW(pha),"^",5)        
		..s phatime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(phatime)
		..
		..s papmidr=$p($g(^PAADM(adm)),"^",1)
		..s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
		..q:(papmino'=pmino)&(pmino'="")
		..s patienname=""
		..s patienname=$p(^PAPER(papmidr,"ALL"),"^",1)
		..q:(patienname'=pername)&(pername'="")
		..s age=##class(web.DHCSTKUTIL).GetAge(papmidr)
		..s sexdr=$p(^PAPER(papmidr,"ALL"),"^",7)
		..s sex=$p(^CT("SEX",sexdr),"^",2)
		..s doclocinfo=##class(web.DHCOutPhCommon).GetOrdDocLoc(ord_"||"_itm)
		..s doclocdr=$p(doclocinfo,"^",1)
		..s docloc=$p(doclocinfo,"^",2)
		..s warddesc=""
		..s currwarddr=$p(^PAADM(adm),"^",70)
		..i currwarddr'="" d
		...s ctlocdr=$p(^PAWARD(currwarddr),"^",5)
		...s warddesc=$p(^CTLOC(ctlocdr),"^",2)
		...i warddesc["-" s warddesc=$p(warddesc,"-",2)
    	...s docloc=docloc_"["_warddesc_"]"
		..q:(doclocdr'=CDepCode)&(CDepCode'="")
		..s doctorinfo=##class(web.DHCOutPhCommon).GetOrdDoctor(ord_"||"_itm)
		..s doctordr=$p(doctorinfo,"^",1)
		..s doctor=$p(doctorinfo,"^",2)
		..q:(doctordr'=CDoctor)&(CDoctor'="")
		..s ordate=##class(web.DHCOutPhCommon).GetOrdDate(ord_"||"_itm)
		..s diagnodesc=##class(web.DHCOutPhCommon).GetMRDiagnosDesc(adm,",")		//诊断
		..s mricd=diagnodesc
		..s pmoney=0,pret="",pfact=""
		..s prescmoney=##class(web.DHCOutPhDisp).GetPrescAmt(prescno,recplocdr)
		..s pmoney=$p(prescmoney,"^",1)							//处方金额
		..s presctypedesc=$p(prescmoney,"^",2)
		..s rpamt=$p(prescmoney,"^",3)
		..s dhcprescrow=$o(^DHCPAQPT(0,"PrescNo",prescno,""))
		..i dhcprescrow '=""  d
		...s psonrow="",pson="",psoncode=""
		...s psonrow=+$p(^DHCPAQPT(dhcprescrow),"^",2)
		...s pson=+$p(^DHCPAADMPrescType(psonrow),"^",2)
		...s PrescTypeCode=pson
		...s presctypedesc=$p(^PAC("ADMREA",PrescTypeCode),"^",2)
		..s phmoney=phmoney+pmoney
		..s phcount=phcount+1
		..s ^TMP("DHCST","web.DHCOutPhRetrieve","QueryLocPatienCX",pid,"PRESCINFO",pid,"Presc",prescno)=""
		..i $d(^PAQUE1(0,"PrescNo",prescno)) d
		...s paque=$o(^PAQUE1(0,"PrescNo",prescno,""))
		...s ordremark=$P($g(^PAQUE1(paque,"DHC")),"^",21)
		..e  s ordremark=""
		..s EncryptLevelInfo=""
		..s EncryptLevel=""
		..s PatLevel=""
		..s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
		..i EncryptFlag=1 d
		...s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmidr,"")
		...s EncryptLevel=$p(EncryptLevelInfo,"^",1)
		...s PatLevel=$p(EncryptLevelInfo,"^",2)
		...i contentstr="" d
		....s contentstr=patienname_"^"_papmino_"^"_prtdate_"^"_pmoney_"^"_pyname_"^"_""_"^"_prtcode_"^"_prt_"^"_prescno_"^"_""_"^"_""_"^"_""
		..set Data=$lb(patienname,papmino,prtdate,pmoney,pyname,"",prtcode,"",prescno,presctypedesc,prttime,pfact,adm,mricd,"",docloc,doctor,ordate,ordremark,diagnodesc,rpamt,prt,EncryptLevel,PatLevel,age,sex,pydate,pytime,"")
		..Set ^CacheTemp(repid,indi)=Data	
		..Set indi=indi+1

		//留观
		s prt=""
		f orddate=st:1:end  d
		.s phadate="" //收费日期
		.s ord=""
		.f  s ord=$o(^OEORDi(0,"LocStDtArr",locdr,0,orddate,ord)) q:ord=""  d
		..s chl=""
		..f  s chl=$o(^OEORDi(0,"LocStDtArr",locdr,0,orddate,ord,chl)) q:chl=""  d
		...s adm=$p(^OEORD(ord),"^",1) 
		...s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
		...q:prescno=""
		...q:$d(^TMP("DHCST","web.DHCOutPhRetrieve","QueryLocPatienCX",pid,"PRESCINFO",pid,"Presc",prescno))
		...s AdmType=$p($g(^PAADM(adm)),"^",2)
		...q:(AdmType'="O")
		...s papmidr=$p($g(^PAADM(adm)),"^",1)
		...q:papmidr=""
		...s OrderStatusDr=$p(^OEORD(ord,"I",chl,1),"^",13)
		...q:OrderStatusDr=""
		...s OeFlag=$p($g(^OEC("OSTAT",OrderStatusDr)),"^",1)
		...q:(OeFlag'="V")&(OeFlag'="E")
		...s ordstatus=$p(^OEORD(ord,"I",chl,3),"^",5)
		...s preason=$p(^OEORD(ord,"I",chl,11),"^",18)
		...s EmLGflag=$p($g(^OEORD(ord,"I",chl,"DHC")),"^",17)
		...s ReadyToBill=$p($g(^OEORD(ord,"I",chl,12)),"^",26)
		...q:(EmLGflag'="1")&(ReadyToBill'="Y")	//急诊留观和先就诊后收费的才能不判断收费就发药
		...s OrdItm=ord_"||"_chl
		...s (existInci,qq)=0
		...s dsp=$o(^DHCOEDISQTY(0,"OEORI",OrdItm,""))
		...q:dsp=""
		...i $d(^DHCOEDISQTY(dsp,"I")) d
		....s dspSub=0
		....f  s dspSub=$o(^DHCOEDISQTY(dsp,"I",dspSub)) q:dspSub=""  d
		.....s inc=$p(^DHCOEDISQTY(dsp,"I",dspSub),"^",5) 
		.....i (inci'="")&&(inc=inci) s existInci=1
	    .....s incmanflag=""
	    .....s incich=$o(^INCI("IL_LOC",locdr,inc,""))
	    .....s incil=inc_"||"_incich
	    .....i $D(^DHCINCIL(0,"INCIL",incil)) d //管理药,管理组用DHC_IncItmLoc维护
	    ......s dhcincil=$o(^DHCINCIL(0,"INCIL",incil,""))
	    ......s incmanflag=$p(^DHCINCIL(dhcincil),"^",9)  //1,0
		.....i (incmanflag="1")&&(glflag="1") s qq=qq+1
		...q:(glflag="1")&&(+qq="0")
		...q:(inci'="")&&(existInci=0)
		...s ^TMP("DHCST","web.DHCOutPhRetrieve","QueryLocPatienCX",pid,"PRESCINFO",adm,prescno)=""
		...
		..
		s adm="" 
		f  s adm=$o(^TMP("DHCST","web.DHCOutPhRetrieve","QueryLocPatienCX",pid,"PRESCINFO",adm)) q:adm=""  d
		.s papmidr=$p($g(^PAADM(adm)),"^",1)
		.q:papmidr=""
		.s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
		.q:(papmino'=pmino)&(pmino'="")
		.s patienname=""
		.s patienname=$p(^PAPER(papmidr,"ALL"),"^",1)
		.q:(patienname'=pername)&(pername'="")
		.s age=##class(web.DHCSTKUTIL).GetAge(papmidr)
		.s sexdr=$p(^PAPER(papmidr,"ALL"),"^",7)
		.s sex=$p(^CT("SEX",sexdr),"^",2)
		.s diagnodesc=##class(web.DHCOutPhCommon).GetMRDiagnosDesc(adm,",")
		.
		.s prescno=""
		.f  s prescno=$o(^TMP("DHCST","web.DHCOutPhRetrieve","QueryLocPatienCX",pid,"PRESCINFO",adm,prescno)) q:prescno=""  d 
		..s papmidr=$p(^PAADM(adm),"^",1) 
		..s chkerr=##class(web.DHCOutPhDisp).CheckBeforUpdate(prescno,phl)
		..q:chkerr=1
		..s arraldr=""
		..s prtInfoStr=##class(web.DHCOutPhCommon).GetHandTime(prescno)   
		..s prtstr=$p(prtInfoStr,"^",4)           
		..s prtdate=$p(prtInfoStr,"^",2)
		..s phatime=$p(prtInfoStr,"^",3)
		..s prtcode=$p(prtInfoStr,"^",5)
		..q:(prtinv'="")&&($lf($lfs(prtcode,","),prtinv)=0)      
		..s doclocinfo=##class(web.DHCOutPhCommon).GetOrdDoc(prescno,locdr)
		..s doclocdr=$p(doclocinfo,"^",5)
		..s doctordr=$p(doclocinfo,"^",4)
		..s ordate=$p(doclocinfo,"^",3)
		..s docloc=$p(doclocinfo,"^",1)
		..s doctor=$p(doclocinfo,"^",2)
		..q:(doclocdr'=CDepCode)&(CDepCode'="")
		..q:(doctordr'=CDoctor)&(CDoctor'="")
		..s warddesc=""
		..s currwarddr=$p(^PAADM(adm),"^",70)
		..i currwarddr'="" d
		...s ctlocdr=$p(^PAWARD(currwarddr),"^",5)
		...s warddesc=$p(^CTLOC(ctlocdr),"^",2)
		...i warddesc["-" s warddesc=$p(warddesc,"-",2)
    	...s docloc=docloc_"["_warddesc_"]"
		..i $d(^PAQUE1(0,"PrescNo",prescno)) d
		...s paque=$o(^PAQUE1(0,"PrescNo",prescno,""))
		...s ordremark=$P($g(^PAQUE1(paque,"DHC")),"^",21)
		..e  s ordremark=""
		..
		..s pmoney=0,pret="",pfact=""
		..s prescmoney=##class(web.DHCOutPhDisp).GetPrescAmt(prescno,locdr)
		..s pmoney=$p(prescmoney,"^",2)
		..s presctype=$p(prescmoney,"^",2)
		..s rpamt=$p(prescmoney,"^",3)
		..s phmoney=phmoney+pmoney
		..s dhcprescrow=$o(^DHCPAQPT(0,"PrescNo",prescno,""))
		..i dhcprescrow '=""  d
		...s psonrow="",pson="",psoncode=""
		...s psonrow=+$p(^DHCPAQPT(dhcprescrow),"^",2)
		...s pson=+$p(^DHCPAADMPrescType(psonrow),"^",2)
		...s PrescTypeCode=pson
		...s presctypedesc=$p(^PAC("ADMREA",PrescTypeCode),"^",2)
		..s EncryptLevelInfo=""
		..s EncryptLevel=""
		..s PatLevel=""
		..s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
		..i EncryptFlag=1 d
		...s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmidr,"")
		...s EncryptLevel=$p(EncryptLevelInfo,"^",1)
		...s PatLevel=$p(EncryptLevelInfo,"^",2)
		...i contentstr="" d
		....s contentstr=patienname_"^"_papmino_"^"_prtdate_"^"_pmoney_"^"_""_"^"_""_"^"_prtcode_"^"_prt_"^"_prescno
		..s phcount=phcount+1
		..set Data=$lb(patienname,papmino,prtdate,pmoney,"","",prtcode,"",prescno,presctypedesc,prttime,pfact,adm,mricd,"",docloc,doctor,ordate,ordremark,diagnodesc,rpamt,prt,EncryptLevel,PatLevel,age,sex,"","","")
		..Set ^CacheTemp(repid,indi)=Data	
		..Set indi=indi+1
	}
	i $g(pid)'="" k ^TMP("DHCST","web.DHCOutPhRetrieve","QueryLocPatienCX",pid,"PRESCINFO")
	i $g(pid)'="" k ^TMP("DHCST","web.DHCOutPhRetrieve","QueryLocPatienCX",pid,"Presc")
	s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
	i (EncryptFlag=1)&(contentstr'="") d
	.s condition=##class(web.DHCSTCOMMONSRV).ChangeToJson("CDateSt^CDateEnd^ctloc^CPmiNo^CPerName^CPrtInv^inci^CPydr^CFydr^FyFlag^sttime^endtime^glflag^CDepCode^CDoctor",CDateSt_"^"_CDateEnd_"^"_ctloc_"^"_CPmiNo_"^"_CPerName_"^"_CPrtInv_"^"_inci_"^"_CPydr_"^"_CFydr_"^"_FyFlag_"^"_sttime_"^"_endtime_"^"_glflag_"^"_CDepCode_"^"_CDoctor)
	.s content=##class(web.DHCSTCOMMONSRV).ChangeToJson("pname^perno^pydate^phdmoney^pyname^fyname^inv^phdrow^prescno",contentstr)
	.s EncryptCode=$o(^User.DHCSecretLevelI("Code",""))
	.s eventlogret=##class(web.DHCSTCOMMONSRV).CreateEventLog("DHCOUTDISPQUERY",condition,content,EncryptCode)   //记录日志
	set Data=$lb("合计",phcount_"条","",phmoney,"","","","","","","","","","")
	Set ^CacheTemp(repid,indi)=Data	
	Set indi=indi+1
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutDispData
	s ppyflag="",pfyflag="",pydr1="",fydr1="",prt="",inv="",pydate="",use="",perno="",pname="",rpamt=0
	s ppyflag=$p(^DHCPHDISP(phdrow,1),"^",6)
	s pfyflag=$p(^DHCPHDISP(phdrow),"^",4)
	s pprintflag=$p(^DHCPHDISP(phdrow,1),"^",9)
	// 1(已发药) 0(已配药) 4(已打印)
	q:(FyFlag=0)&&(ppyflag'=1)
	q:(FyFlag=4)&&(pprintflag'=1)
	q:(FyFlag=1)&&(pfyflag'=1)
	q:(FyFlag'=1)&&(pfyflag=1)
	s fydate=$p(^DHCPHDISP(phdrow),"^",3)
	s pydate=$p(^DHCPHDISP(phdrow,1),"^",5)
	i fydate'="" s fydate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(fydate)
	i pydate'="" s pydate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(pydate)
	s pydr1=+$p(^DHCPHDISP(phdrow,1),"^",3)
	s fydr1=+$p(^DHCPHDISP(phdrow,1),"^",2)
	q:(fydr1'=fydr)&(fydr'="")
	q:(pydr1'=pydr)&(pydr'="") 
	s prescno=""
	s prescno=$p(^DHCPHDISP(phdrow,2),"^",1)
	s pytime=""
	s pytime=$p(^DHCPHDISP(phdrow,1),"^",7)
	s fytime=$p(^DHCPHDISP(phdrow),"^",5)
	s exitflag=0
	i FyFlag'=1  d
	.i (sttime'="")&(phddate=st)&(+fytime<sttime) s exitflag=1
	.i (endtime'="")&(phddate=end)&(+fytime>endtime) s exitflag=1
	e  d
	.i (sttime'="")&(phddate=st)&(pytime<sttime) s exitflag=1
	.i (sttime'="")&(phddate=end)&(pytime>endtime) s exitflag=1
	q:exitflag=1
	
	s pmi=""
	s pmi=+$p(^DHCPHDISP(phdrow),"^",7)
	s perno=$p(^PAPER(pmi,"PAT",1),"^",2)
	q:(perno'=pmino)&(pmino'="")
	s pname=$p(^PAPER(pmi,"ALL"),"^",1)
	q:(pname'[pername)&(pername'="")
	s age=##class(web.DHCSTKUTIL).GetAge(pmi)
	s sexdr=$p(^PAPER(pmi,"ALL"),"^",7)
	s sex=$p(^CT("SEX",sexdr),"^",2)
	s (pyname,fyname)=""
	i $d(^DHCPHPER(pydr1))  s pyname=$p(^DHCPHPER(pydr1),"^",2)
	i $d(^DHCPHPER(fydr1))  s fyname=$p(^DHCPHPER(fydr1),"^",2)
	s prt=""
	s prtdate=""

	s prtInfoStr=##class(web.DHCOutPhCommon).GetHandTime(prescno)
	s prtflag=$p(prtInfoStr,"^",1) 
	q:prtflag=0
	s prtdate=$p(prtInfoStr,"^",2) 
	s prttime=$p(prtInfoStr,"^",3) 
	s prt=$p(prtInfoStr,"^",4) 
	s inv=$p(prtInfoStr,"^",5) 
	q:(prtinv'="")&&($lf($lfs(inv,","),prtinv)=0)  
	
	i fytime'="" s fytime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(fytime)
	i pytime'="" s pytime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(pytime)

	s phdi="",phdmoney=0,preason=""
	s pp=0,qq=0
	s adm="",mricd=""
	;s mricd=##class(web.DHCOutPhDisp).GPerIcd(phl,prt,prescno)
	f  s phdi=$o(^DHCPHDI(phdrow,"PHDI",phdi)) q:phdi=""  d
	.s money=0
	.s orditm="",ord="",itm="",durfact=""
	.s orditm=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",5)
	.s ord=$p(orditm,"||",1)
	.s itm=$p(orditm,"||",2)
	.s adm=+$P(^OEORD(ord),"^",1)
	.s duratdr="" s duratdr=+$p($g(^OEORD(ord,"I",itm,2)),"^",6)
	.i duratdr'="" s durfact=$p($g(^PHCDU(duratdr)),"^",2)
	.i cyflag'="1" s durfact=""
	.s preason=$p(^OEORD(ord,"I",itm,11),"^",18)
	.s itmmast="",inc=""
	.s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
	.s ItemCatDR="",ordertype=""
	.s ItemCatDR=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),1),"^",10)
	.s ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
	.q:(ordertype'="R")
	.s recplocdr=""
	.s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	.q:recplocdr=""
	.s phdmoney=0
	.s sub=""
	.f  s sub=$o(^DHCPHDI(phdrow,"PHDI",phdi,"INCLB",sub)) q:sub=""  d 
	..s rpsubamt=+$p(^DHCPHDI(phdrow,"PHDI",phdi,"INCLB",sub),"^",6)
	..s money=+$p(^DHCPHDI(phdrow,"PHDI",phdi,"INCLB",sub),"^",8)
	..s inclb=+$p(^DHCPHDI(phdrow,"PHDI",phdi,"INCLB",sub),"^",3)
	..s rpamt=rpamt+rpsubamt
	..s inc=+inclb
	..s incil=$p(inclb,"||",1,2)
	..s incmanflag=""
	..i $D(^DHCINCIL(0,"INCIL",incil)) d 			//管理药,管理组用DHC_IncItmLoc维护
	...s dhcincil=$o(^DHCINCIL(0,"INCIL",incil,""))
	...s incmanflag=$p(^DHCINCIL(dhcincil),"^",9)  //1,0
	..i (incmanflag="1")&(glflag="1") s qq=qq+1
	..i (inc=inci)&(inci'="") s pp=pp+1
	..s phdmoney=phdmoney+money
	q:(pp=0)&(inci'="")
	q:(qq=0)&(glflag="1")
	s doclocinfo=##class(web.DHCOutPhCommon).GetOrdDocLoc(ord_"||"_itm)
	s doclocdr=$p(doclocinfo,"^",1)
	s docloc=$p(doclocinfo,"^",2)
	q:(doclocdr'=CDepCode)&(CDepCode'="")
	s warddesc=""
	s currwarddr=$p(^PAADM(adm),"^",70)
	i currwarddr'="" d
	.s ctlocdr=$p(^PAWARD(currwarddr),"^",5)
	.s warddesc=$p(^CTLOC(ctlocdr),"^",2)
	.i warddesc["-" s warddesc=$p(warddesc,"-",2)
    .s docloc=docloc_"["_warddesc_"]"
	s doctorinfo=##class(web.DHCOutPhCommon).GetOrdDoctor(ord_"||"_itm)
	s doctordr=$p(doctorinfo,"^",1)
	s doctor=$p(doctorinfo,"^",2)
	q:(doctordr'=CDoctor)&(CDoctor'="")
	s ordate=##class(web.DHCOutPhCommon).GetOrdDate(ord_"||"_itm)
	i $d(^PAQUE1(0,"PrescNo",prescno)) d
	.s paque=$o(^PAQUE1(0,"PrescNo",prescno,""))
	.s ordremark=$P($g(^PAQUE1(paque,"DHC")),"^",21)
	s diagnodesc=##class(web.DHCOutPhCommon).GetMRDiagnosDesc(adm,",")
	s mricd=diagnodesc 
	s dhcprescrow="",PrescTypeCode="",presctypedesc=""
	s dhcprescrow=$o(^DHCPAQPT(0,"PrescNo",prescno,""))
	i dhcprescrow '=""  d
	.s psonrow="",pson="",psoncode=""
	.s psonrow=+$p(^DHCPAQPT(dhcprescrow),"^",2)
	.s pson=+$p(^DHCPAADMPrescType(psonrow),"^",2)
	.s PrescTypeCode=pson
	.s presctypedesc=$p(^PAC("ADMREA",PrescTypeCode),"^",2)
	e  d
	.s PrescTypeCode=preason
	.i PrescTypeCode'="" s presctypedesc=$p(^PAC("ADMREA",PrescTypeCode),"^",2)
	.e  s presctypedesc=""
	s phmoney=phmoney+phdmoney
	s EncryptLevelInfo=""
	s EncryptLevel=""
	s PatLevel=""
	s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
	i EncryptFlag=1 d
	.s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(pmi,"")
	.s EncryptLevel=$p(EncryptLevelInfo,"^",1)
	.s PatLevel=$p(EncryptLevelInfo,"^",2)
	.i contentstr="" d
	..s contentstr=pname_"^"_perno_"^"_pydate_"^"_phdmoney_"^"_pyname_"^"_fyname_"^"_inv_"^"_phdrow_"^"_prescno
	s phcount=phcount+1
	set Data=$lb(pname,perno,prtdate,phdmoney,pyname,fyname,inv,phdrow,prescno,presctypedesc,prttime,durfact,adm,mricd,fytime,docloc,doctor,ordate,ordremark,diagnodesc,rpamt,"",EncryptLevel,PatLevel,age,sex,pydate,pytime,fydate)
	Set ^CacheTemp(repid,indi)=Data	
	Set indi=indi+1
}

ClassMethod QueryLocPatienCXFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocPatienCXExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" { Set AtEnd=1
  Set Row="" }
 Else      { Set Row=^CacheTemp(repid,ind) }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryLocPatienCX(CDateSt As %String, CDateEnd As %String, ctloc As %String, CPmiNo As %String, CPerName As %String, CPrtInv As %String, inci As %String, CPydr As %String, CFydr As %String, FyFlag As %String, sttime As %String, endtime As %String, glflag As %String, CDepCode, CDoctor) As %Query(ROWSPEC = "TPerName:%String,TPmiNo:%String,TPrtDate:%String,TPhMoney:%String,TPyName:%String,TFyName:%String,TPrtInv:%String,tphd:%String,TPrescNo:%String,TPrescType:%String,TPrtTime:%String,TJS:%String,TAdm:%String,TMR:%String,TDispTime:%String,TDocloc:%String,TDoctor:%String,TOrdate:%String,TOrdremark:%String,TDiag:%String,TRpAmt:%String,TPrtID:%String,TEncryptLevel:%String,TPatLevel:%String,TAge:%String,TSex:%String,TPyDate:%String,TPyTime:%String,TDispDate:%String") [ SqlProc ]
{
}

ClassMethod QueryGPersonOrdClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryGPersonOrdExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCOutPhRetrieve","QueryGPersonOrd","229","undefined","99","O17051500001")
/// d ##class(%ResultSet).RunQuery("web.DHCOutPhRetrieve","QueryGPersonOrd","72","1","316","O181107000027")
ClassMethod QueryGPersonOrdExecute(ByRef QHandle As %Binary, rPhd As %Library.String = "", FyFlag As %Library.String = "", rCtloc As %Library.String = "", rPrescNo As %Library.String = "") As %Status
{
	s ^TMPDHCSTPARAMS("web.DHCOutPhRetrieve","QueryGPersonOrdExecute")=$lb(rPhd, FyFlag, rCtloc, rPrescNo)
 	Set repid=$I(^CacheTemp)
	s ind=1
	s phd=""
	s phd=rPhd
	s phl="",ctloc="",yprescno=""
	s ctloc=rCtloc,yprescno=rPrescNo
	i yprescno="" Set QHandle=$lb(0,repid,0)	Quit $$$OK
	s pid=##class(web.DHCSTKUTIL).NewPid($this,"OP")
    s FyFlag="2"
    i FyFlag'="2"{
 	}
 	else {
		s leadlocdr=##class(web.DHCOutPhDisp).GetLeadLoc(ctloc)
		s recloc=leadlocdr
		s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(recloc)
		s HospID=$p(CustStr,"^",5)
		s CustID=$p(CustStr,"^",1)
		s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)	//进价规则
		s prt=""
		k ^TMP("DHCST",$this,"QueryGPersonOrd",pid)
		s ord=""
		f  s ord=$o(^OEORD(0,"PrescNo",yprescno,ord))  q:ord=""  d 
		.s patadm=$p(^OEORD(ord),"^",1)
		.s itm=""
		.f  s itm=$o(^OEORD(0,"PrescNo",yprescno,ord,itm)) q:itm=""  d
		..s reclocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
		..q:reclocdr=""
		..q:reclocdr'=recloc
		..s prescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
		..s orditm=ord_"||"_itm
		..s BillFlag=$p(^OEORD(ord,"I",itm,3),"^",5)    
		..s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
		..q:dsp=""
		..i $d(^DHCOEDISQTY(dsp,"I")) d  
		...s dspSub=0
		...f  s dspSub=$o(^DHCOEDISQTY(dsp,"I",dspSub)) q:dspSub=""  d
		....s inci=$p(^DHCOEDISQTY(dsp,"I",dspSub),"^",5)
		....s qty=$p(^DHCOEDISQTY(dsp,"I",dspSub),"^",2)
		....s dspbat=dsp_"||"_dspSub
		....i BillFlag="P" d 
		.....s ordpriceinfo=##class(web.DHCOutPhCommon).GetBasePriceByOe(orditm,dspbat)
		.....s ordprice=$p(ordpriceinfo,"^",1)
		.....s pmoney=+$p(ordpriceinfo,"^",2)
		....e  d
		.....s dspInclb=$p(^DHCOEDISQTY(dsp,"I",dspSub),"^",1) 
		.....s getSpInc=$s(dspInclb'="":dspInclb,1:inci)
		.....s ordprice=##class(web.DHCSTPRICE).GetSp(getSpInc,+$h,"",HospID,"","")	//没发票的需要按最新进价
		.....s pmoney=ordprice*qty
		....i $d(^TMP("DHCST",$this,"QueryGPersonOrd",pid,"PRESCNO",prescno,itm,inci))  d
		.....s $p(^TMP("DHCST",$this,"QueryGPersonOrd",pid,"PRESCNO",prescno,itm,inci),"^",1)=$p(^TMP("DHCST",$this,"QueryGPersonOrd",pid,"PRESCNO",prescno,itm,inci),"^",1)+qty
		.....s $p(^TMP("DHCST",$this,"QueryGPersonOrd",pid,"PRESCNO",prescno,itm,inci),"^",2)=$p(^TMP("DHCST",$this,"QueryGPersonOrd",pid,"PRESCNO",prescno,itm,inci),"^",2)+pmoney
		....e  d
		.....s $p(^TMP("DHCST",$this,"QueryGPersonOrd",pid,"PRESCNO",prescno,itm,inci),"^",1)=qty
		.....s $p(^TMP("DHCST",$this,"QueryGPersonOrd",pid,"PRESCNO",prescno,itm,inci),"^",2)=pmoney
		.....s $p(^TMP("DHCST",$this,"QueryGPersonOrd",pid,"PRESCNO",prescno,itm,inci),"^",3)=ordprice  
		.....s $p(^TMP("DHCST",$this,"QueryGPersonOrd",pid,"PRESCNO",prescno,itm,inci),"^",4)=orditm 
		.....s $p(^TMP("DHCST",$this,"QueryGPersonOrd",pid,"PRESCNO",prescno,itm,inci),"^",5)=inci 
    	
		d PhdInci
		
		s first=""
		f  s first=$o(^TMP("DHCST",$this,"QueryGPersonOrd",pid,"PRESCNO",yprescno,first)) q:first=""  d
		.s second=""
		.f  s second=$o(^TMP("DHCST",$this,"QueryGPersonOrd",pid,"PRESCNO",yprescno,first,second)) q:second=""  d
		..s dispqty=0,dispmoney=0,price=0
		..s tmpdata=^TMP("DHCST",$this,"QueryGPersonOrd",pid,"PRESCNO",yprescno,first,second)
		..s dispqty=+$p(tmpdata,"^",1)
		..s dispmoney=+$p(tmpdata,"^",2)
		..s price=0
		..i dispqty'=0 s price=dispmoney/dispqty
		..e  s price=$p(tmpdata,"^",3)
		..s orditm=$p(tmpdata,"^",4)
		..s inci=$p(tmpdata,"^",5)
		..
		..s ord=+orditm
		..s itm=$p(orditm,"||",2)
		..s itmmast=""
		..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast
		..s recplocdr=""
		..s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
		..q:recplocdr=""
		..q:recplocdr'=recloc
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
		..i (doseqty<1)&&($p(doseqty,".",1)="") s doseqty="0"_doseqty
		..s unitdr="" s unitdr=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
		..i unitdr="" s doseqty=""
		..s phfragdr="" s phfragdr=$p($g(^OEORD(ord,"I",itm,2)),"^",4)
		..s duratdr="" s duratdr=$p($g(^OEORD(ord,"I",itm,2)),"^",6)
		..s instrdr="" s instrdr=$p($g(^OEORD(ord,"I",itm,2)),"^",7)
		..s unitdesc=""
		..i unitdr'="" s unitdesc=$p($g(^CT("UOM",unitdr)),"^",2)			//剂量单位
		..	
		..q:inci=""
		..s incil="",yphw="",incstb=""
		..s incil=$o(^INCI("IL_LOC",ctloc,inci,""))
		..i incil'=""  d
		...s incilt=inci_"||"_incil
		...s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incilt,",","","") //改为取新的科室货位表DHCIncItmLocBin（可多货位）
		...s stkbinstr=$p(stkbinret,":",2)
		...s yphw=stkbinstr
		..s puruom="",puruomdesc="",basuom="",basuomdesc=""
		..s puruom=+$p(^INCI(inci,3),"^",6)
		..s puruomdesc=$p($g(^CT("UOM",puruom)),"^",2)
		..s basuom=+$p(^INCI(inci,1),"^",10)
		..s basuomdesc=$p($g(^CT("UOM",basuom)),"^",2)
		..s phgg=""
		..s phgg=$p($g(^INCI(inci,3)),"^",9)
		..s qty=0,newunit="",newunitdesc="",newprice=0
		..s itmstr=$g(PHDINCI(inci))
		..s retqty=$p(itmstr,"^",1)
		..s yppc=$p(itmstr,"^",2)
		..s dispuomdr=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)
		..i (dispuomdr'="")  d
		...s Fac=##class(web.DHCSTCOMMONSRV).UOMFac(dispuomdr,basuom)
		...s newunit=dispuomdr
		...s qty=dispqty/Fac
		...s retqty=retqty/Fac
		...s newunitdesc=$p($g(^CT("UOM",dispuomdr)),"^",2)
		...s newprice=price*Fac
		..e  d
		...s Fac=##class(web.DHCSTCOMMONSRV).UOMFac(puruom,basuom)
		...i (dispqty/Fac)=(dispqty\Fac) d
		....s newunit=puruom
		....s newunitdesc=puruomdesc
		....s qty=dispqty/Fac
		....s retqty=retqty/Fac
		....s newprice=price*Fac
		...e  d
		....s newunit=basuom
		....s newunitdesc=basuomdesc
		....s qty=dispqty
		....s retqty=retqty
		....s newprice=price
		..s phdesc=$p(^INCI(inci,1),"^",2)
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
		..s jlflag=""
		..s jlflag=doseqty_unitdesc
		..i userdoctype'["DOC"  d
		..s error="",t=0,cc=0,notes=""
		..s notes=$p(^OEORD(ord,"I",itm,2),"^",8)
		..s oeflag="",inclbid="",disstatu=""
		..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",2)       ;????
		..i t=0 s error="1"
		..s doctcode=""
		..i (orddoctco'=0)&(orddoctco'="") d
		...s doctcode=$p(^CTPCP(orddoctco,1),"^",1)
		...s username=$p(^CTPCP(orddoctco,1),"^",2)
		..s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inci)
		..s StkTypeDesc=$P(CatGrpStr,"^",4)
		..s Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
		..s dispmoney=##Class(web.DHCSTCOMMPARA).GetNumbFN(dispmoney,Perv,"FmtSA",1)
		..s newprice=$fn(newprice,"",4)
		..s OENotes=##Class(web.DHCOutPhNewAddCommit).GetNotes(ord_"||"_itm)	//医嘱备注
		..//s phdesc=$tr(phdesc,"\","/")
		..set Data=$lb(ord_"||"_itm,phdesc,newunitdesc,newprice,qty,dispmoney,oeflag,jlflag,phfragdesc,instrdesc,duratdesc,username,yppc,yphw,retqty,OENotes)
		..Set ^CacheTemp(repid,ind)=Data
		..Set ind=ind+1
 	 }
 	k ^TMP("DHCST",$this,"QueryGPersonOrd",pid)
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK

PhdInci
	q:+phd=0
	s phdi=0
	f  s phdi=$o(^DHCPHDI(phd,"PHDI",phdi)) q:phdi=""  d
	.s sub=0
	.f  s sub=$o(^DHCPHDI(phd,"PHDI",phdi,"INCLB",sub)) q:sub=""  d
	..s retqty=$p(^DHCPHDI(phd,"PHDI",phdi,"INCLB",sub),"^",2)
	..s inclb=$p(^DHCPHDI(phd,"PHDI",phdi,"INCLB",sub),"^",3)
	..s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	..s batno=$p(^INCI($p(incib,"||",1),"IB",$p(incib,"||",2)),"^",1)
	..i $d(PHDINCI(+inclb)) d
	...s $p(PHDINCI(+inclb),"^",1)=$p(PHDINCI(+inclb),"^",1)+retqty
	...s $p(PHDINCI(+inclb),"^",2)=$p(PHDINCI(+inclb),"^",2)_";"_batno
	..e  d
	...s PHDINCI(+inclb)=retqty_"^"_batno
	...
	q
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

Query QueryGPersonOrd(rPhd As %String, FyFlag As %String, rCtloc As %String, rPrescNo As %String) As %Query(ROWSPEC = "tphditm:%String,TPhDesc:%String,TPhUom:%String,TPrice:%String,TPhQty:%String,TPhMoney:%String,TStatus:%String,TJL:%String,TPC:%String,TYF:%String,TLC:%String,TDoctor:%String,TIncPC:%String,TIncHW:%String,TRetQty:%String,TOENotes:%String") [ SqlProc ]
{
}

ClassMethod QueryPhDescClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryPhDescExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryPhDescExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "", input As %Library.String = "") As %Status
{
  Set repid=$I(^CacheTemp)
	s ind=1
	s stkgrptype="",stkgrpcode=""
	i input="" S QHandle=$lb(0,repid,0)	Quit $$$OK 
	s input=$g(input)
	s input=$ZCVT(input,"U") 
	k ^DHCTMPSAME($j)
	s num=0
	k ^DHCPHTMP($j,"Itmrowid"),^DHCPHTMP($j,"Itmcode"),^DHCPHTMP($j,"Itmdesc"),^DHCPHTMP($j,"ItmUO")
    s inca="0"
    f  s inca=$o(^INCALIAS(inca)) q:(inca="")!(inca="0")  d
     .s incatext=""
     .s incatext=$p(^INCALIAS(inca),"^",4)
     .s incatext=$ZCVT(incatext,"U")
     .q:incatext'[input
     .s inci=""
     .s inci=+$p(^INCALIAS(inca),"^",1)
     .q:$d(^DHCTMPSAME($j,inci))
     .s ^DHCTMPSAME($j,inci)="ok"
     .s incil="",pp=0
     .f  s incil=$o(^INCI("IL_LOC",ctloc,inci,incil)) q:incil=""  d
	    ..s pp=pp+1
	  .q:pp=0
	  .s num=num+1
	  .s ^DHCPHTMP($j,"Itmrowid",num)=inci
	  .s ^DHCPHTMP($j,"Itmcode",num)=$p(^INCI(inci,1),"^",1)
	  .s ^DHCPHTMP($j,"Itmdesc",num)=$p(^INCI(inci,1),"^",2)
	  .s uomdr=$p(^INCI(inci,1),"^",10)
	  .s ^DHCPHTMP($j,"ItmUO",num)="" i uomdr'="" s ^DHCPHTMP($j,"ItmUO",num)=$p(^CT("UOM",+uomdr),"^",2)
   s ii=1
   s sysdate=""
   s sysdate=+$h+1
   s ii=1
   for ii=1:1:num 
     { s itmrowid="",itmcode="",itmdesc=""
      s itmrowid=^DHCPHTMP($j,"Itmrowid",ii)
      s itmcode=^DHCPHTMP($j,"Itmcode",ii)
      s itmdesc=^DHCPHTMP($j,"Itmdesc",ii)
	  set Data=$lb(itmdesc,itmrowid)
	  Set ^CacheTemp(repid,ind)=Data
	  Set ind=ind+1
	   }
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryPhDescFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPhDescExecute ]
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

Query QueryPhDesc(ctloc As %String, input As %String) As %Query(ROWSPEC = "名称:%String,ID:%String")
{
}

ClassMethod CatGrpCode(inci As %String) As %String
{
	 n (inci)
	s INCSC=$p(^INCI(inci,2),"^",2) q:INCSC="" ""
	s SCG=$o(^DHCSCG("STKCAT",+INCSC,"")) q:SCG="" ""
	;s CH=$o(^DHCSCG("STKCAT",INCSC,SCG,"")) q:CH="" ""
	s CATGRPCODE=$P(^DHCSCG(+SCG),"^",1)
	q $g(CATGRPCODE)
}

ClassMethod CatType(inci As %String) As %String
{
 n (inci)
	s INCSC=$p(^INCI(inci,2),"^",2) q:INCSC="" ""
	s SCG=$o(^DHCSCG("STKCAT",+INCSC,"")) q:SCG="" ""
	;s CH=$o(^DHCSCG("STKCAT",INCSC,SCG,"")) q:CH="" ""
	s CATTYPE=$P(^DHCSCG(+SCG),"^",3)
	q $g(CATTYPE)
}

ClassMethod QueryGZLClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryGZLExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryGZLExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "", CDateSt As %Library.String = "", CDateEnd As %Library.String = "", CStTime As %Library.String = "", CEndTime As %Library.String = "") As %Status
{
 Set repid=$I(^CacheTemp)
	s ind=1
	i ctloc="" Set QHandle=$lb(0,repid,0) Quit $$$OK
	s phloc=""
	s phloc=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phloc=""  Set QHandle=$lb(0,repid,0) Quit $$$OK
	s stdate="",enddate=""
	s sttime="",endtime=""
	s sttime=CStTime,endtime=CEndTime
	i CDateSt="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	i CDateEnd="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	s stdate=CDateSt,enddate=CDateEnd
	i stdate>enddate Set QHandle=$lb(0,repid,0) Quit $$$OK
	s cyflag=""
	s cyflag=$p(^DHCPHLOC(phloc),"^",6)
	k ^TMP("DHCST",$this,"QueryGZLNew",pid),^DHCPHGZLList($j)
	s phddate=""
	f  s phddate=$o(^DHCPHDISPi(phddate)) q:phddate=""  d
	  .q:phddate<stdate
	  .q:phddate>enddate
	  .s phdrow=""
	  .f  s phdrow=$o(^DHCPHDISPi(phddate,phloc,phdrow)) q:phdrow=""  d
	    ..s phwrow=""
	    ..s phwrow=+$p(^DHCPHDISP(phdrow,1),"^",4)
	    ..s phdpyflag="",phdfyflag=""
	    ..s phdfyflag=$p(^DHCPHDISP(phdrow),"^",4)
	    ..s phdpyflag=$p(^DHCPHDISP(phdrow,1),"^",6)
	    ..s phdpydr="",phdfydr="",phdtime=""
	    ..s phdtime=+$p(^DHCPHDISP(phdrow,1),"^",7)
	    ..q:(phddate=stdate)&(phdtime<sttime)&(sttime'="")
	    ..q:(phddate=enddate)&(phdtime>endtime)&(endtime'="")
	    ..s phdnouse=""
	    ..;s phdnouse=$p(^DHCPHDISP(phdrow,1),"^",11)
	    ..;q:phdnouse="1"
	    ..s presc="",prescrow="",jytype=""
	    ..s presc=$p(^DHCPHDISP(phdrow,2),"^",1)
	    ..s prescrow=$o(^PAQUE1(0,"PrescNo",presc,""))
	    ..i prescrow'=""  d
	      ...i $d(^PAQUE1(prescrow,"DHC")) s jytype=$p(^PAQUE1(prescrow,"DHC"),"^",15)
	    ..s phdpydr=+$p(^DHCPHDISP(phdrow,1),"^",3)
	    ..s phdfydr=+$p(^DHCPHDISP(phdrow,1),"^",2)
	    ..q:(phdpyflag'="1")&(phdfyflag'="1")
	    ..s phdmoney=0,count=0
	    ..s phdi="0",cyfs=1
	    ..f  s phdi=$o(^DHCPHDI(phdrow,"PHDI",phdi)) q:(phdi="")!(phdi="0")  d
	      ...s phdimoney=0,count=count+1
	      ...s phdimoney=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",3)
	      ...s cyfs=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",9)
	      ...i cyfs=""  s cyfs=1
	      ...s phdimoney=$p(phdimoney,$c(1),1)
	      ...s phdmoney=phdmoney+phdimoney
	    ..i $d(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr))  d
	      ...i cyflag="1"  d
	        ....;s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",10)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",10)+cyfs
	        ....;i jytype["代"  d
	          ....;.s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",15)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",15)+cyfs
	          ....;.s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",16)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",16)+1
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",1)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",1)+1
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",2)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",2)+phdmoney
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",5)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",5)+count
	    ..i '$d(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr))  d
	      ...i cyflag="1"  d
	        ....;s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",10)=cyfs
	        ....;i jytype["代"  d
	          ....;.s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",15)=cyfs
	          ....;.s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",16)=1

	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",1)=1
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",2)=phdmoney
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",5)=count
	    ..i $d(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr))  d
	      ...i cyflag="1"  d
	        ....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",11)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",11)+cyfs
	        ....i jytype["代"  d
	          .....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",15)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",15)+cyfs
	          .....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",16)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",16)+1

	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",3)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",3)+1
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",4)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",4)+phdmoney
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",6)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",6)+count
	    ..i '$d(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr))  d
	      ...i cyflag="1"  d
	        ....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",11)=cyfs
	        ....i jytype["代"  d
	          .....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",15)=cyfs
	          .....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",16)=1

	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",3)=1
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",4)=phdmoney
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",6)=count
     s phddate = "", t = 0
     f  s phddate=$o(^DHCPHUNDi(phddate)) q:phddate=""  d
       .q:phddate<stdate
       .q:phddate>enddate
       .s phdrow = ""
       .f  s phdrow=$o(^DHCPHUNDi(phddate,phloc,phdrow)) q:phdrow=""  d
         ..s pyflag="",fyflag="",pydr="",pyname="",prt="",inv="",pydate="",use="",perno="",pname=""
         ..s unpersondr="",unpersonname="",unpersonpmi=""
         ..s unpersondr=+$p(^DHCPHUND(phdrow),"^",8)
         ..s pydr=+$p(^DHCPHUND(phdrow),"^",10)
         ..s phdtime=""
         ..s phdtime=+$p(^DHCPHUND(phdrow),"^",12)
	     ..q:(phddate=stdate)&(phdtime<sttime)&(sttime'="")
	     ..q:(phddate=enddate)&(phdtime>endtime)&(endtime'="")
         ..s phdi="",phdmoney=0,count=0
         ..f  s phdi=$o(^DHCPHUND(phdrow,"I",phdi)) q:phdi=""  d
            ...s money=0,qty=0,ctuom="",price=0,inc=""
            ...s money=+$p(^DHCPHUND(phdrow,"I",phdi),"^",5)
            ...s phdmoney=phdmoney+money
            ...s count=count+1
         ..i $d(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr))  d
	        ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",1)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",1)+1
	        ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",2)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",2)+phdmoney
	        ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",5)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",5)+count
	     ..i '$d(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr))  d
	        ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",1)=1
	        ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",2)=phdmoney
	        ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",5)=count
         ..i $d(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr))  d
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",3)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",3)+1
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",4)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",4)+phdmoney
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",6)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",6)+count
	    ..i '$d(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr))  d
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",3)=1
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",4)=phdmoney
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",6)=count
    s phddate = "", t = 0
    f  s phddate=$o(^DHCPHUNRi(phddate)) q:phddate=""  d
      .q:phddate<stdate
      .q:phddate>enddate
      .s phdrow = ""
      .f  s phdrow=$o(^DHCPHUNRi(phddate,phloc,phdrow)) q:phdrow=""  d
        ..s pyflag="",fyflag="",pydr="",pyname="",prt="",inv="",pydate="",use="",perno="",pname=""
        ..s pydr=+$p(^DHCPHUNR(phdrow),"^",11)
        ..s phdtime=""
        ..s phdtime=+$p(^DHCPHUNR(phdrow),"^",12)
	    ..q:(phddate=stdate)&(phdtime<sttime)&(sttime'="")
	    ..q:(phddate=enddate)&(phdtime>endtime)&(endtime'="")
        ..s phdi="",phdmoney=0,count=0
        ..f  s phdi=$o(^DHCPHUNRI(phdrow,"I",phdi)) q:phdi=""  d
          ...s money=0,qty=0,ctuom="",price=0,inc=""
          ...s money=+$p(^DHCPHUNRI(phdrow,"I",phdi),"^",5)
          ...s ctuom=+$p(^DHCPHUNRI(phdrow,"I",phdi),"^",1)
          ...s qty=+$p(^DHCPHUNRI(phdrow,"I",phdi),"^",4)
          ...s inc=+$p(^DHCPHUNRI(phdrow,"I",phdi),"^",2)
          ...s phdmoney=phdmoney+money
          ...s count=count+1
  	    ..i $d(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr))  d
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",1)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",1)+1
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",2)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",2)+phdmoney
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",5)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",5)+count
	    ..i '$d(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr))  d
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",1)=1
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",2)=phdmoney
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",5)=count
	    ..i $d(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr))  d
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",3)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",3)+1
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",4)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",4)+phdmoney
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",6)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",6)+count
	    ..i '$d(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr))  d
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",3)=1
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",4)=phdmoney
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,pydr),"^",6)=count

     s phretdate=""
     f phretdate=stdate:1:enddate  d
       .s phretrow=""
       .f  s phretrow=$o(^DHCPHRETi(phretdate,phloc,phretrow)) q:phretrow=""  d
         ..s retphp=""
         ..s retphp=+$p(^DHCPHRET(phretrow),"^",8)
         ..s phdtime=""
         ..s phdtime=+$p(^DHCPHRET(phretrow),"^",10)
	     ..q:(phretdate=stdate)&(phdtime<sttime)&(sttime'="")
	     ..q:(phretdate=enddate)&(phdtime>endtime)&(endtime'="")
         ..s retsub="",phdmoney=0,count=0
         ..s phdid=""
         ..s phdid=+$p(^DHCPHRET(phretrow),"^",6)
         ..s phdi="0",cyfs=1
	     ..f  s phdi=$o(^DHCPHDI(phdid,"PHDI",phdi)) q:(phdi="")!(phdi="0")  d
	      ...s cyfs=$p(^DHCPHDI(phdid,"PHDI",phdi),"^",9)
         ..f  s retsub=$o(^DHCPHRTI(phretrow,"RTI",retsub)) q:retsub=""  d
           ...s money=0,qty=0,ctuom="",price=0,inc=""
           ...s money=+$p(^DHCPHRTI(phretrow,"RTI",retsub),"^",1)
           ...s phdmoney=phdmoney+money
           ...s count=count+1
         ..i $d(^TMP("DHCST",$this,"QueryGZLNew",pid,retphp))  d
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,retphp),"^",7)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,retphp),"^",7)+1
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,retphp),"^",8)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,retphp),"^",8)+phdmoney
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,retphp),"^",9)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,retphp),"^",9)+count
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,retphp),"^",12)=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,retphp),"^",12)+cyfs
	    ..i '$d(^TMP("DHCST",$this,"QueryGZLNew",pid,retphp))  d
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,retphp),"^",7)=1
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,retphp),"^",8)=phdmoney
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,retphp),"^",9)=count
	      ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,retphp),"^",12)=cyfs

     
	 s phw=""
	 s n=0
	 s hjpyrc=0,hjfyrc=0,hjpyje=0,hjfyje=0,hjpyl=0,hjfyl=0
	 s hjtyrc=0,hjtyje=0,hjtyl=0,hjfyfs=0,hjpyfs=0,hjtyfs=0
	 s hjjyfs=0,hjjycf=0
     s phdper=""
	 f  s phdper=$o(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper)) q:phdper=""  d
	    .s phwfyrc=0,phwpyrc=0,phwfyje=0,phwpyje=0,phwpycount=0,phwfycount=0
	    .q:phdper=0
	    .s jyfs=0,jycf=0
	    .s tyrc=0,tyje=0,tyl=0,pyfs=0,fyfs=0,tyfs=0
	    .s phwpyrc=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",1)
	    .s phwpyje=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",2)
	    .s phwfyrc=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",3)
	    .s phwfyje=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",4)
	    .s phwpycount=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",5)
	    .s phwfycount=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",6)
	    .s tyrc=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",7)
	    .s tyje=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",8)
	    .s tyl=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",9)
	    .s pyfs=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",10)
	    .s fyfs=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",11)
	    .s tyfs=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",12)
	    .s jyfs=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",15)
	    .s jycf=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",16)
	    .s hjpyrc=hjpyrc+phwpyrc
	    .s hjfyrc=hjfyrc+phwfyrc
	    .s hjpyje=hjpyje+phwpyje
	    .s hjfyje=hjfyje+phwfyje
	    .s hjpyl=hjpyl+phwpycount
	    .s hjfyl=hjfyl+phwfycount
	    .s hjtyrc=hjtyrc+tyrc
	    .s hjtyje=hjtyje+tyje
	    .s hjtyl=hjtyl+tyl
	    .s hjpyfs=hjpyfs+pyfs
	    .s hjfyfs=hjfyfs+fyfs
	    .s hjtyfs=hjtyfs+tyfs
	    .s hjjyfs=hjjyfs+jyfs
	    .s hjjycf=hjjycf+jycf
	    .s phwdesc="",phdpname=""
	    .s phdpname=$p(^DHCPHPER(phdper),"^",2)
	    .i phdpname["#" s phdpname=$p(phdpname,"#",2)
	    .set Data=$lb(phdpname,phwpyrc,phwfyrc,phwpyje,phwfyje,phwpycount,phwfycount,tyrc,tyje,tyl,pyfs,fyfs,tyfs,jyfs,jycf)
	    .Set ^CacheTemp(repid,ind)=Data	
 	    .Set ind=ind+1
	 if ind>1 d
	  .set Data=$lb("合计",hjpyrc,hjfyrc,hjpyje,hjfyje,hjpyl,hjfyl,hjtyrc,hjtyje,hjtyl,hjpyfs,hjfyfs,hjtyfs,hjjyfs,hjjycf)
	  .Set ^CacheTemp(repid,ind)=Data	
 	  .Set ind=ind+1
   	 Set QHandle=$lb(0,repid,0)
	 Quit $$$OK
}

ClassMethod QueryGZLFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGZLExecute ]
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

Query QueryGZL(ctloc As %String, CDateSt As %String, CDateEnd As %String, CStTime As %String, CEndTime As %String) As %Query(ROWSPEC = "TPhName:%String,TPYRC:%String,TFYRC:%String,TPYJE:%String,TFYJE:%String,TPYL:%String,TFYL:%String,TRetPresc:%String,TRetMoney:%String,TRetYL:%String,TPyFS:%String,TFyFS:%String,TTyFs:%String,TJYFS:%String,TJYCF:%String")
{
}

/// 工作量统计LiangQiang 2012-03-26
/// 统计列:
/// 发药金额 +非正常发药金额 ^ 发药量(品种数) + 非正常发药量(品种数) ^ 发药处方数 ^发药草药付数 ^ 配药金额 ^ 配药品种数 ^ 配药处方数 _
/// 退药金额 + 非正常退药金额 ^ 退药量(品种数) + 非正常退药量(品种数) ^ 退药处方数 ^ 退药草药付数 
/// 
ClassMethod QueryGZLNewClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryGZLNewExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// w ##class(%ResultSet).RunQuery("web.DHCOutPhRetrieve","QueryGZLNew","99","11/02/2018","11/02/2018","00:00","23:59")
ClassMethod QueryGZLNewExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "", CDateSt As %Library.String = "", CDateEnd As %Library.String = "", CStTime As %Library.String = "", CEndTime As %Library.String = "") As %Status
{
     Set repid=$I(^CacheTemp)
	 s CDateSt=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateSt)
	 s CDateEnd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateEnd)
	 s CStTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(CStTime)
	 s CEndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(CEndTime)
	 s ind=1
	 i ctloc="" Set QHandle=$lb(0, repid,0) Quit $$$OK
	 s phloc=""
	 s phloc=$o(^DHCPHLOCi("LOC",ctloc,""))
	 i phloc=""  Set QHandle=$lb(0,repid,0) Quit $$$OK
	 s stdate="",enddate=""
	 s sttime="",endtime=""
	 s sttime=CStTime,endtime=CEndTime
	 i CDateSt="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	 i CDateEnd="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	 s stdate=CDateSt,enddate=CDateEnd
	 i stdate>enddate Set QHandle=$lb(0,repid,0) Quit $$$OK
	 s cyflag=""
	 s cyflag=$p(^DHCPHLOC(phloc),"^",6)
	 s pid=##class(web.DHCSTKUTIL).NewPid($this,"OP")
	 //发药
	 f intrdate=stdate:1:enddate  d
	 .s intr=""
	 .f  s intr=$o(^DHCINTR(0,"TypeDate","F",intrdate,intr)) q:intr=""  d
	 ..s inclb=$p(^DHCINTR(intr),"^",7)
	 ..s intrloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
	 ..q:intrloc'=ctloc
	 ..s phdclb=$p(^DHCINTR(intr),"^",9)
	 ..s phdrow=$p(phdclb,"||",1)
	 ..s phdi=$p(phdclb,"||",2)
	 ..s phwrow=""
	 ..q:'$d(^DHCPHDISP(phdrow,1))
	 ..s phwrow=+$p(^DHCPHDISP(phdrow,1),"^",4)
	 ..s intrtime=$p(^DHCINTR(intr),"^",3)
	 ..q:(intrdate=stdate)&(intrtime<sttime)&(sttime'="")
	 ..q:(intrdate=enddate)&(intrtime>endtime)&(endtime'="")
	 ..s presc=$p(^DHCPHDISP(phdrow,2),"^",1)
	 ..s phdfydr=+$p(^DHCPHDISP(phdrow,1),"^",2)
	 ..q:'$d(^DHCPHDI(phdrow,"PHDI",phdi))
	 ..s amt=$p(^DHCINTR(intr),"^",8)
	 ..i amt<0 s amt=-amt
	 ..s que1Id=##class(web.DHCSTCOMMONORDER).PrescCYQueId(presc)
	 ..s cyfs=0
	 ..i que1Id>0 d 
	 ...s duraId=$p(^PAQUE1(que1Id,"DHC"),"^",10)
	 ...s cyfs=$s(duraId'="":$p($g(^PHCDU(duraId)),"^",2),1:0)
	 ..i $D(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr)) d
	 ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",1)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",1)+amt //发药金额
	 ...i '$d(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr,"ExistPhdi",phdrow,phdi)) d
	 ....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",2)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",2)+1   //发药量(品种数)
	 ...s ^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr,"ExistPhdi",phdrow,phdi)=""
	 ...i '$D(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr,presc)) d
	 ....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",3)=+($p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",3))+1  //发药处方数
	 ....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",4)=+($p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr),"^",4))+cyfs  //草药付数
	 ....s ^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr,presc)=""
	 ..e  d
	 ...s ^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr,presc)=""
	 ...s ^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr,"ExistPhdi",phdrow,phdi)=""
	 ...s ^TMP("DHCST",$this,"QueryGZLNew",pid,phdfydr)=amt_"^"_"1"_"^"_"1"_"^"_cyfs_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
	 ..
     //配药
     f phddate=stdate:1:enddate  d
	 .s phdrow=""
	 .f  s phdrow=$o(^DHCPHDISPi(phddate,phloc,phdrow)) q:phdrow=""  d
	 ..s phwrow=""
	 ..s phwrow=+$p(^DHCPHDISP(phdrow,1),"^",4)
	 ..s phdpyflag="",phdfyflag=""
	 ..s phdfyflag=$p(^DHCPHDISP(phdrow),"^",4)
	 ..s phdpyflag=$p(^DHCPHDISP(phdrow,1),"^",6)
	 ..s phdpydr="",phdfydr="",phdtime=""
	 ..s phdtime=+$p(^DHCPHDISP(phdrow,1),"^",7)
	 ..q:(phddate=stdate)&(phdtime<sttime)&(sttime'="")
	 ..q:(phddate=enddate)&(phdtime>endtime)&(endtime'="")
	 ..s presc="",prescrow="",jytype=""
	 ..s presc=$p(^DHCPHDISP(phdrow,2),"^",1)
	 ..s phdpydr=+$p(^DHCPHDISP(phdrow,1),"^",3)
	 ..s phdi="0",cyfs=1,phdmoney=0
	 ..f  s phdi=$o(^DHCPHDI(phdrow,"PHDI",phdi)) q:(phdi="")!(phdi="0")  d
	 ...s phdimoney=0
	 ...i $d(^DHCPHDI(phdrow,"PHDI",phdi,"INCLB")) d
	 ....s phdLb=0
	 ....f  s phdLb=$o(^DHCPHDI(phdrow,"PHDI",phdi,"INCLB",phdLb)) q:phdLb=""  d
	 .....s phdLbMoney=$p(^DHCPHDI(phdrow,"PHDI",phdi,"INCLB",phdLb),"^",8)
	 .....s phdimoney=phdimoney+phdLbMoney
	 ....e  d
	 .....s oeori=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",5)
	 .....s billFlag=$p(^OEORD(+oeori,"I",+$p(oeori,"||",2),3),"^",5) 
	 .....s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	 .....q:dspId=""
	 .....s dspSub=0
	 .....f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
	 ......s dspSubData=^DHCOEDISQTY(dspId,"I",dspSub)
	 ......s qty=$p(dspSubData,"^",2)
	 ......// 如果已经收费,按收费金额显示
	 ......i billFlag="P" d
	 .......s prtPriceStr=##class(web.DHCOutPhCommon).GetBasePriceByOe(oeori,dspId_"||"_dspSub)
	 .......s sp=$p(prtPriceStr,"^",1)
	 .......s spAmt=$p(prtPriceStr,"^",2)
	 .......s phdimoney=phdimoney+spAmt
	 ......e  d
	 .......s sp=$p(dspSubData,"^",4)
	 .......s spAmt=qty*sp
	 .......s phdimoney=phdimoney+spAmt
	 ...s que1Id=##class(web.DHCSTCOMMONORDER).PrescCYQueId(presc)
	 ...s cyfs=0
	 ...i que1Id>0 d 
	 ....s duraId=$p(^PAQUE1(que1Id,"DHC"),"^",10)
	 ....s cyfs=$s(duraId'="":$p($g(^PHCDU(duraId)),"^",2),1:0)
	 ...s phdimoney=$p(phdimoney,$c(1),1)
	 ...//s phdmoney=phdmoney+phdimoney  
	 ...i $d(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr))  d
	 ....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",5)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",5)+phdimoney //配药金额
	 ....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",7)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",7)+1  //配药品种数
	 ....i '$d(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr,"py",presc))  d 
	 .....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",6)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",6)+1  //配药处方数
	 .....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",12)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr),"^",12)+cyfs  //配药处方数
	 .....s ^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr,"py",presc)=""
	 ....
	 ...e  d
	 ....s ^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr,"py",presc)=""
	 ....s ^TMP("DHCST",$this,"QueryGZLNew",pid,phdpydr)=0_"^"_0_"^"_0_"^"_0_"^"_phdimoney_"^"_1_"^"_1 _"^"_0_"^"_0_"^"_0_"^"_0_"^"_cyfs
	 	 
     //退药 
    f intrdate=stdate:1:enddate  d
    .s intr=""
    .f  s intr=$o(^DHCINTR(0,"TypeDate","H",intrdate,intr)) q:intr=""  d
    ..s inclb=$p(^DHCINTR(intr),"^",7)
    ..s intrloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
    ..q:intrloc'=ctloc
    ..s phreti=$p(^DHCINTR(intr),"^",9)
    ..s phretrow=+phreti
    ..q:'$d(^DHCPHRET(phretrow))
    ..s retper=+$p(^DHCPHRET(phretrow),"^",8)
    ..s phrettime=+$p(^DHCINTR(intr),"^",3)
    ..q:(sttime'="")&(intrdate=stdate)&(phrettime<sttime)
    ..q:(sttime'="")&(intrdate=enddate)&(phrettime>endtime)
    ..s phretchid=$p(phreti,"||",2)
    ..q:'$d(^DHCPHRTI(phretrow,"RTI",phretchid))
    ..s retori=$p(^DHCPHRTI(phretrow,"RTI",phretchid),"^",2)
    ..s phretmoney=$p(^DHCINTR(intr),"^",8)
    ..s phdi=$p(^DHCPHRTI(phretrow,"RTI",phretchid),"^",7)
    ..s phd=$p(phdi,"||",1)
    ..s phdsub=$p(phdi,"||",2)
	..s retQty=$p(^DHCPHRTI(phretrow,"RTI",phretchid),"^",3)
	..s phdQty=$p(^DHCPHDI(phd,"PHDI",phdsub),"^",4)
	..s presc=$p(^DHCPHDISP(phd,2),"^",1)
	..s que1Id=##class(web.DHCSTCOMMONORDER).PrescCYQueId(presc)
	..s cyfs=0
	..i que1Id>0 d 
	...s duraId=$p(^PAQUE1(que1Id,"DHC"),"^",10)
	...s cyfs=$s(duraId'="":$p($g(^PHCDU(duraId)),"^",2),1:0)
    ..i $D(^TMP("DHCST",$this,"QueryGZLNew",pid,retper)) d
	...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,retper),"^",8)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,retper),"^",8)+phretmoney //退药金额
	...i '$d(^TMP("DHCST",$this,"QueryGZLNew",pid,retper,"ExistPhReti",phretrow,phretchid)) d
	....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,retper),"^",9)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,retper),"^",9)+1   //退药量(品种数),yunhaibao20170109,一个明细算1,并非品种数
	...i '$D(^TMP("DHCST",$this,"QueryGZLNew",pid,retper,"ret",presc)) d
	....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,retper),"^",10)=+($p($g(^TMP("DHCST",$this,"QueryGZLNew",pid,retper)),"^",10))+1  //退药处方数
	....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,retper),"^",11)=+($p($g(^TMP("DHCST",$this,"QueryGZLNew",pid,retper)),"^",11))+cyfs  //退药草药付数
	....s ^TMP("DHCST",$this,"QueryGZLNew",pid,retper,"ret",presc)=""
	...s ^TMP("DHCST",$this,"QueryGZLNew",pid,retper,"ExistPhReti",phretrow,phretchid)=""
	..e  d
	...s ^TMP("DHCST",$this,"QueryGZLNew",pid,retper,"ExistPhReti",phretrow,phretchid)=""
	...s ^TMP("DHCST",$this,"QueryGZLNew",pid,retper,"ret",presc)=""
	...s ^TMP("DHCST",$this,"QueryGZLNew",pid,retper)=0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_phretmoney_"^"_1_"^"_1_"^"_cyfs
     
     //非正常发药
     
 	f intrdate=stdate:1:enddate  d
    .s intr=""
    .f  s intr=$o(^DHCINTR(0,"TypeDate","S",intrdate,intr)) q:intr=""  d
    ..s phundclb=$p(^DHCINTR(intr),"^",9)
    ..s inclb=$p(^DHCINTR(intr),"^",7)
    ..s intrloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
    ..q:intrloc'=ctloc
    ..s phundrow=+phundclb
    ..q:'$D(^DHCPHUND(phundrow))
    ..s phuser=+$p(^DHCPHUND(phundrow),"^",10)
    ..s newwinpos=""
    ..s phundtime=""
    ..s phundtime=+$p(^DHCPHUND(phundrow),"^",12)
    ..q:(sttime'="")&(intrdate=stdate)&(phundtime<sttime)
    ..q:(sttime'="")&(intrdate=enddate)&(phundtime>endtime)
    ..s phunditm=$p(phundclb,"||",2)
    ..s undinci=+$p(^DHCPHUND(phundrow,"I",phunditm),"^",2)
    ..s ctuom=+$p(^DHCPHUND(phundrow,"I",phunditm),"^",1)
    ..s qty=+$p(^DHCINTR(intr),"^",6)
    ..s money=$p(^DHCINTR(intr),"^",8)
    ..s price=$p(^DHCINTR(intr),"^",14)
    ..i $D(^TMP("DHCST",$this,"QueryGZLNew",pid,phuser)) d
	...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phuser),"^",1)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phuser),"^",1)+money //非正常发药金额
	...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phuser),"^",2)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phuser),"^",2)+1   //非正常发药量(品种数)
	..e  d
	...s ^TMP("DHCST",$this,"QueryGZLNew",pid,phuser)=money_"^"_1_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
     
    //非正常退药
  	f intrdate=stdate:1:enddate  d
    .s intr=""
    .f  s intr=$o(^DHCINTR(0,"TypeDate","Z",intrdate,intr)) q:intr=""  d
    ..s phunretrowid=$p(^DHCINTR(intr),"^",9)
    ..s inclb=$p(^DHCINTR(intr),"^",7)
    ..s intrloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
    ..q:intrloc'=ctloc
    ..s phunrrow=+phunretrowid
    ..s phunditm=$p(phunretrowid,"||",2)
    ..s phuser=+$p(^DHCPHUNR(phunrrow),"^",11)
    ..s phunrtime=""
    ..s phunrtime=+$p(^DHCPHUNR(phunrrow),"^",12)
    ..q:(sttime'="")&(intrdate=stdate)&(phunrtime<sttime)
    ..q:(sttime'="")&(intrdate=enddate)&(phunrtime>endtime)
    ..s unrinci=+$p(^DHCPHUNRI(phunrrow,"I",phunditm),"^",2)
    ..s ctuom=+$p(^DHCPHUNRI(phunrrow,"I",phunditm),"^",1)
    ..s qty=+$p(^DHCINTR(intr),"^",6)
    ..s money=$p(^DHCINTR(intr),"^",8)
    ..i $D(^TMP("DHCST",$this,"QueryGZLNew",pid,phuser)) d
	...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phuser),"^",8)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phuser),"^",8)+money //非正常退药金额
	...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,phuser),"^",9)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phuser),"^",9)+1   //非正常退药量(品种数)
	..e  d
	...s ^TMP("DHCST",$this,"QueryGZLNew",pid,phuser)=0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_money_"^"_1_"^"_0_"^"_0
     
     //合计输出
    
	 s phw=""
	 s n=0
	 s hjpyrc=0,hjfyrc=0,hjpyje=0,hjfyje=0,hjpyl=0,hjfyl=0
	 s hjtyrc=0,hjtyje=0,hjtyl=0,hjfyfs=0,hjpyfs=0,hjtyfs=0
	 s hjjyfs=0,hjjycf=0
     s phdper=""
	 f  s phdper=$o(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper)) q:phdper=""  d
     .s phwfyrc=0,phwpyrc=0,phwfyje=0,phwpyje=0,phwpycount=0,phwfycount=0
     .q:phdper=0
     .s jyfs=0,jycf=0
     .s tyrc=0,tyje=0,tyl=0,pyfs=0,fyfs=0,tyfs=0
     .s phwpyrc=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",6)  //配药处方
     .s phwpyje=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",5)  //配药金额
     .s phwfyrc=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",3)  //发药处方
     .s phwfyje=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",1)  //发药金额
     .s phwpycount=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",7) //配药量
     .s phwfycount=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",2) //发药量
     .s tyrc=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",10) //退药处方数
     .s tyje=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",8) //退药金额
     .s tyl=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",9)  //退药量
     .s pyfs=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",12) //配药付数
     .s fyfs=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",4)  //发药付数
     .s tyfs=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",11)  //退药付数
     .s jyfs="0" //$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",15)
     .s jycf="0" //$p(^TMP("DHCST",$this,"QueryGZLNew",pid,phdper),"^",16)
     .
     .s hjpyrc=hjpyrc+phwpyrc
     .s hjfyrc=hjfyrc+phwfyrc
     .s hjpyje=hjpyje+phwpyje
     .s hjfyje=hjfyje+phwfyje
     .s hjpyl=hjpyl+phwpycount
     .s hjfyl=hjfyl+phwfycount
     .s hjtyrc=hjtyrc+tyrc
     .s hjtyje=hjtyje+tyje
     .s hjtyl=hjtyl+tyl
     .s hjpyfs=hjpyfs+pyfs
     .s hjfyfs=hjfyfs+fyfs
     .s hjtyfs=hjtyfs+tyfs
     .s hjjyfs=hjjyfs+jyfs
     .s hjjycf=hjjycf+jycf
     .s phwdesc="",phdpname=""
     .s phdpname=$p(^DHCPHPER(phdper),"^",2)
     .i phdpname["#" s phdpname=$p(phdpname,"#",2)
     .set Data=$lb(phdpname,phwpyrc,phwfyrc,phwpyje,phwfyje,phwpycount,phwfycount,tyrc,tyje,tyl,pyfs,fyfs,tyfs,jyfs,jycf)
     .Set ^CacheTemp(repid,ind)=Data	
     .Set ind=ind+1
     if ind>1 d
     .set Data=$lb("合计",hjpyrc,hjfyrc,hjpyje,hjfyje,hjpyl,hjfyl,hjtyrc,hjtyje,hjtyl,hjpyfs,hjfyfs,hjtyfs,hjjyfs,hjjycf)
     .Set ^CacheTemp(repid,ind)=Data	
     .Set ind=ind+1
     k ^TMP("DHCST",$this,"QueryGZLNew",pid)
     Set QHandle=$lb(0,repid,0)
     Quit $$$OK
}

ClassMethod QueryGZLNewFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGZLNewExecute ]
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

Query QueryGZLNew(ctloc As %String, CDateSt As %String, CDateEnd As %String, CStTime As %String, CEndTime As %String) As %Query(ROWSPEC = "TPhName:%String,TPYRC:%String,TFYRC:%String,TPYJE:%String,TFYJE:%String,TPYL:%String,TFYL:%String,TRetPresc:%String,TRetMoney:%String,TRetYL:%String,TPyFS:%String,TFyFS:%String,TTyFS:%String,TJYFS:%String,TJYCF:%String")
{
}

ClassMethod DoCreatYfrxb(phloc As %String, stdate As %String, enddate As %String, php As %String, winpos As %String, sttime As %String, endtime As %String)
{
	
	///注意本方法中:发药为负，退药为正
	s pid=##CLASS(web.DHCSTKUTIL).GetInclbCounter()
	s ctloc="",stt="",endt=""
	s ctloc=$p(^DHCPHLOC(phloc),"^",1)
	s ctloc=$p(ctloc,$c(1),1)
	s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(ctloc)
	s HospID=$p(CustStr,"^",5)
	s CustID=$p(CustStr,"^",1)
	f intrdate=stdate:1:enddate  d
	.s intr=""
	.f  s intr=$o(^DHCINTR(0,"TypeDate","F",intrdate,intr)) q:intr=""  d
	..s inclb=$p(^DHCINTR(intr),"^",7)
	..s intrloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
	..q:intrloc'=ctloc
	..s phdclb=$p(^DHCINTR(intr),"^",9)
	..s phdrow=$p(phdclb,"||",1)
	..s phwrow=""
	..q:'$d(^DHCPHDISP(phdrow,1))
	..s phwrow=+$p(^DHCPHDISP(phdrow,1),"^",4)
	..s phdpyflag="",phdfyflag=""
	..s phdfyflag=+$p(^DHCPHDISP(phdrow),"^",4)
	..s phdpyflag=+$p(^DHCPHDISP(phdrow,1),"^",6)
	..s phdpydr="",phdfydr=""
	..s pytime=""
	..s pytime=+$p(^DHCPHDISP(phdrow,1),"^",7)
	..s fytime=$p(^DHCPHDISP(phdrow),"^",5)
	..q:(sttime'="")&(intrdate=stdate)&(fytime<sttime)&(fytime'="")
	..q:(endtime'="")&(intrdate=enddate)&(fytime>endtime)&(fytime'="")
	..s phdnouse=""
	..s phdnouse=$p(^DHCPHDISP(phdrow,1),"^",11)
	..q:phdnouse="1"
	..s newwinpos=""
	..s newwinpos=$p(^DHCPHDISP(phdrow,1),"^",19)
	..;q:(newwinpos'=winpos)&(winpos'="")
	..q:(newwinpos'=winpos)&(winpos'="")&(winpos'="O")
	..q:(newwinpos'="")&(winpos="O")
	..s phdpydr=+$p(^DHCPHDISP(phdrow,1),"^",3)
	..s phdfydr=+$p(^DHCPHDISP(phdrow,1),"^",2)
	..q:(phdfydr'=php)&(php'="")
	..q:(phdfyflag'="1")
	..s phdchid=$p(phdclb,"||",2)
	..s ori=$p(^DHCPHDI(phdrow,"PHDI",phdchid),"^",5)
	..q:ori=""
	..s phdqty=+$p(^DHCINTR(intr),"^",6)
	..s phdmoney=+$p(^DHCINTR(intr),"^",8)
	..s price=+$p(^DHCINTR(intr),"^",14)
	..s sub=$p(phdclb,"||",3)
	..s rp=$p(^DHCPHDI(phdrow,"PHDI",phdchid,"INCLB",sub),"^",5)
	..s rpamt=$p(^DHCPHDI(phdrow,"PHDI",phdchid,"INCLB",sub),"^",6)
	..s ord=$p(ori,"||",1)
	..s itm=$p(ori,"||",2)
	..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
	..s itmmastid=$p(itmmast,"||",1)
	..s itmmastver=$p(itmmast,"||",2)
	..s phuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	..q:phuomid=""
	..s phuomid=$p(phuomid,$c(1),1)
	..
	..s finci=$o(^INCI(0,"ARCIM_DR",itmmastid,""))
	..s basuom="",conrow="",confac=1
	..s basuom=+$p(^INCI(finci,1),"^",10)
	..i basuom=phuomid d
	...s confac=1
	..e  d
	...s conrow=$o(^CT("CTCF",0,"UOM",phuomid,basuom,conrow))
	...i conrow'="" d
	....s confac=+$p($g(^CT("CTCF",conrow)),"^",3)
	..s index=price_"||"_rp
	..i $d(^DHCPHTMPYPXC(pid,finci,index))  d
	...s $p(^DHCPHTMPYPXC(pid,finci,index),"^",1)=$p(^DHCPHTMPYPXC(pid,finci,index),"^",1)+phdqty
	...s $p(^DHCPHTMPYPXC(pid,finci,index),"^",2)=$p(^DHCPHTMPYPXC(pid,finci,index),"^",2)+phdmoney
	...s $p(^DHCPHTMPYPXC(pid,finci,index),"^",6)=$p(^DHCPHTMPYPXC(pid,finci,index),"^",6)-rpamt
	..e  d
	...s $p(^DHCPHTMPYPXC(pid,finci,index),"^",1)=phdqty
	...s $p(^DHCPHTMPYPXC(pid,finci,index),"^",2)=phdmoney
	...s $p(^DHCPHTMPYPXC(pid,finci,index),"^",3)=basuom
	...s $p(^DHCPHTMPYPXC(pid,finci,index),"^",4)=price
	...s $p(^DHCPHTMPYPXC(pid,finci,index),"^",5)=rp
	...s $p(^DHCPHTMPYPXC(pid,finci,index),"^",6)=-rpamt
	//退药
	f intrdate=stdate:1:enddate  d
	.s intr=""
	.f  s intr=$o(^DHCINTR(0,"TypeDate","H",intrdate,intr)) q:intr=""  d
	..s inclb=$p(^DHCINTR(intr),"^",7)
	..s intrloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
	..q:intrloc'=ctloc
	..s phreti=$p(^DHCINTR(intr),"^",9)
	..s phretrow=+phreti
	..q:'$d(^DHCPHRET(phretrow))
	..s retper=+$p(^DHCPHRET(phretrow),"^",8)
	..q:(retper'=php)&(php'="")
	..s phrettime=+$p(^DHCINTR(intr),"^",3)
	..q:(sttime'="")&(intrdate=stdate)&(phrettime<sttime)
	..q:(sttime'="")&(intrdate=enddate)&(phrettime>endtime)
	..s newwinpos=""
	..s newwinpos=$p(^DHCPHRET(phretrow),"^",14)
	..q:(newwinpos'=winpos)&(winpos'="")&(winpos'="O")
	..q:(newwinpos'="")&(winpos="O")
	..s phretchid=$p(phreti,"||",2)
	..s retori=$p(^DHCPHRTI(phretrow,"RTI",phretchid),"^",2)
	..s phretqty=+$p(^DHCINTR(intr),"^",6)
	..s phretmoney=$p(^DHCINTR(intr),"^",8)
	..s retprice=$p(^DHCINTR(intr),"^",14)
	..s phdrp=+$p(^DHCINTR(intr),"^",16)
	..s phdrpamt=+$p(^DHCINTR(intr),"^",17)
	..//s phditm=$p(^DHCPHRTI(phretrow,"RTI",phretchid),"^",7)
	..//s phdsub=""
	..//f  s phdsub=$o(^DHCPHDI(+phditm,"PHDI",$p(phditm,"||",2),"INCLB",phdsub)) q:phdsub=""  d
	..//.s phdinclb=$p(^DHCPHDI(+phditm,"PHDI",$p(phditm,"||",2),"INCLB",phdsub),"^",3)
	..//.q:phdinclb'=inclb
	..//.s phdrp=$p(^DHCPHDI(+phditm,"PHDI",$p(phditm,"||",2),"INCLB",phdsub),"^",5)
	..//.s phdrpamt=$p(^DHCPHDI(+phditm,"PHDI",$p(phditm,"||",2),"INCLB",phdsub),"^",6)
	..s phretuom=$p(^DHCINTR(intr),"^",10)
	..s phretuom=$p(phretuom,$c(1),1)
	..s ord=$p(retori,"||",1)
	..s itm=$p(retori,"||",2)
	..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
	..s itmmastid="",itmmastver=""
	..s itmmastid=$p(itmmast,"||",1)
	..s itmmastver=$p(itmmast,"||",2)
	..s retinci=$o(^INCI(0,"ARCIM_DR",itmmastid,""))
	..s retinci=$p(retinci,$c(1),1)
	..s index=retprice_"||"_phdrp
	..
	..i $d(^DHCPHTMPYPXC(pid,retinci,index))  d
	...s $p(^DHCPHTMPYPXC(pid,retinci,index),"^",1)=$p(^DHCPHTMPYPXC(pid,retinci,index),"^",1)+phretqty
	...s $p(^DHCPHTMPYPXC(pid,retinci,index),"^",2)=$p(^DHCPHTMPYPXC(pid,retinci,index),"^",2)+phretmoney
	...s $p(^DHCPHTMPYPXC(pid,retinci,index),"^",6)=$p(^DHCPHTMPYPXC(pid,retinci,index),"^",6)+phdrpamt
	..e  d
	...s $p(^DHCPHTMPYPXC(pid,retinci,index),"^",1)=+phretqty
	...s $p(^DHCPHTMPYPXC(pid,retinci,index),"^",2)=+phretmoney
	...s $p(^DHCPHTMPYPXC(pid,retinci,index),"^",3)=phretuom
	...s $p(^DHCPHTMPYPXC(pid,retinci,index),"^",4)=retprice
	...s $p(^DHCPHTMPYPXC(pid,retinci,index),"^",5)=phdrp
	...s $p(^DHCPHTMPYPXC(pid,retinci,index),"^",6)=phdrpamt

	//非正常发药
	f intrdate=stdate:1:enddate  d
	.s intr=""
	.f  s intr=$o(^DHCINTR(0,"TypeDate","S",intrdate,intr)) q:intr=""  d
	..s phundclb=$p(^DHCINTR(intr),"^",9)
	..s inclb=$p(^DHCINTR(intr),"^",7)
	..s intrloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
	..q:intrloc'=ctloc
	..s phundrow=+phundclb
	..s phuser=+$p(^DHCPHUND(phundrow),"^",10)
	..q:(phuser'=php)&(php'="")
	..s finflag=$p(^DHCPHUND(phundrow),"^",5)
	..q:finflag'="1"
	..s newwinpos=""
	..s phundtime=""
	..s phundtime=+$p(^DHCPHUND(phundrow),"^",12)
	..q:(sttime'="")&(intrdate=stdate)&(phundtime<sttime)
	..q:(sttime'="")&(intrdate=enddate)&(phundtime>endtime)
	..s newwinpos=$p(^DHCPHUND(phundrow),"^",1)
	..q:(newwinpos'=winpos)&(winpos'="")&(winpos'="O")
	..q:(newwinpos'="")&(winpos="O")
	..s phunditm=$p(phundclb,"||",2)
	..s undinci=+$p(^DHCPHUND(phundrow,"I",phunditm),"^",2)
	..s ctuom=+$p(^DHCPHUND(phundrow,"I",phunditm),"^",1)
	..s qty=+$p(^DHCINTR(intr),"^",6)
	..s money=$p(^DHCINTR(intr),"^",8)
	..s price=$p(^DHCINTR(intr),"^",14)
	..s buom=$p(^INCI(undinci,1),"^",10)
	..//s rp=##class(web.DHCSTPRICE).GetClbRp(inclb,buom)
	..s rp=##class(web.DHCSTPRICE).GetCurRp(inclb,buom,HospID)
	..s rpamt=rp*qty
	..s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inci)
	..s StkTypeDesc=$P(CatGrpStr,"^",4)
	..s Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
	..s rpamt=##Class(web.DHCSTCOMMPARA).GetNumbDec(rpamt,Perv,"FmtSA",1)
	..s index=price_"||"_rp
	..
	..i $d(^DHCPHTMPYPXC(pid,undinci,index))  d
	...s $p(^DHCPHTMPYPXC(pid,undinci,index),"^",1)=$p(^DHCPHTMPYPXC(pid,undinci,index),"^",1)+qty
	...s $p(^DHCPHTMPYPXC(pid,undinci,index),"^",2)=$p(^DHCPHTMPYPXC(pid,undinci,index),"^",2)+money
	...s $p(^DHCPHTMPYPXC(pid,undinci,index),"^",6)=$p(^DHCPHTMPYPXC(pid,undinci,index),"^",6)-rpamt
	..e  d
	...s $p(^DHCPHTMPYPXC(pid,undinci,index),"^",1)=qty
	...s $p(^DHCPHTMPYPXC(pid,undinci,index),"^",2)=money
	...s $p(^DHCPHTMPYPXC(pid,undinci,index),"^",3)=ctuom
	...s $p(^DHCPHTMPYPXC(pid,undinci,index),"^",4)=price
	...s $p(^DHCPHTMPYPXC(pid,undinci,index),"^",5)=rp
	...s $p(^DHCPHTMPYPXC(pid,undinci,index),"^",6)=-rpamt

	f intrdate=stdate:1:enddate  d
	.s intr=""
	.f  s intr=$o(^DHCINTR(0,"TypeDate","Z",intrdate,intr)) q:intr=""  d
	..s phunretrowid=$p(^DHCINTR(intr),"^",9)
	..s inclb=$p(^DHCINTR(intr),"^",7)
	..s intrloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
	..q:intrloc'=ctloc
	..s phunrrow=+phunretrowid
	..s phunditm=$p(phunretrowid,"||",2)
	..s phuser=+$p(^DHCPHUNR(phunrrow),"^",11)
	..q:(phuser'=php)&(php'="")
	..s finflag=$p(^DHCPHUNR(phunrrow),"^",5)
	..q:finflag'="1"
	..s phunrtime=""
	..s phunrtime=+$p(^DHCPHUNR(phunrrow),"^",12)
	..q:(sttime'="")&(intrdate=stdate)&(phunrtime<sttime)
	..q:(sttime'="")&(intrdate=enddate)&(phunrtime>endtime)
	..s newwinpos=""
	..s newwinpos=$p(^DHCPHUNR(phunrrow),"^",1)
	..q:(newwinpos'=winpos)&(winpos'="")&(winpos'="O")
	..q:(newwinpos'="")&(winpos="O")
	..s unrinci=+$p(^DHCPHUNRI(phunrrow,"I",phunditm),"^",2)
	..s ctuom=+$p(^DHCPHUNRI(phunrrow,"I",phunditm),"^",1)
	..s qty=+$p(^DHCINTR(intr),"^",6)
	..s money=$p(^DHCINTR(intr),"^",8)
	..s price=$p(^DHCINTR(intr),"^",14)
	..s buom=$p(^INCI(unrinci,1),"^",10)
	..//s rp=##class(web.DHCSTPRICE).GetClbRp(inclb,buom)
	..s rp=##class(web.DHCSTPRICE).GetCurRp(inclb,buom,HospID)
	..s rpamt=rp*rpamt
	..s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inci)
	..s StkTypeDesc=$P(CatGrpStr,"^",4)
	..s Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
	..s rpamt=##Class(web.DHCSTCOMMPARA).GetNumbDec(rpamt,Perv,"FmtSA",1)
	..s index=price_"||"_rp
	..
	..i $d(^DHCPHTMPYPXC(pid,unrinci,index))  d
	...s $p(^DHCPHTMPYPXC(pid,unrinci,index),"^",1)=$p(^DHCPHTMPYPXC(pid,unrinci,index),"^",1)+qty
	...s $p(^DHCPHTMPYPXC(pid,unrinci,index),"^",2)=$p(^DHCPHTMPYPXC(pid,unrinci,index),"^",2)+money
	...s $p(^DHCPHTMPYPXC(pid,unrinci,index),"^",6)=$p(^DHCPHTMPYPXC(pid,unrinci,index),"^",6)+rpamt
	..e  d
	...s $p(^DHCPHTMPYPXC(pid,unrinci,index),"^",1)=qty
	...s $p(^DHCPHTMPYPXC(pid,unrinci,index),"^",2)=+money
	...s $p(^DHCPHTMPYPXC(pid,unrinci,index),"^",3)=ctuom
	...s $p(^DHCPHTMPYPXC(pid,unrinci,index),"^",4)=price
	...s $p(^DHCPHTMPYPXC(pid,unrinci,index),"^",5)=rp
	...s $p(^DHCPHTMPYPXC(pid,unrinci,index),"^",6)=+rpamt

	q pid
}

ClassMethod QueryGYFRXBClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryGYFRXBExecute ]
{
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryGYFRXBExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "", CDateSt As %Library.String = "", CDateEnd As %Library.String = "", fydr As %Library.String = "", inci As %Library.String = "", CIncCatID As %Library.String = "", CIncPrice As %Library.String = "", CPhCatID As %Library.String = "", ChManFlag As %Library.String = "", CManGroupID As %Library.String = "", userid As %Library.String = "", CWinPosCode As %Library.String = "", CStTime As %Library.String = "", CEndTime As %Library.String = "", NewPhcCat As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1,m=0
	s systime=$p($h,",",2)
	s CDateSt=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateSt)
	s CDateEnd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateEnd)
	s CStTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(CStTime)
	s CEndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(CEndTime)
	s phl=""
	s manflag="",mangroup="",sttime="",endtime=""
	s sttime=CStTime,endtime=CEndTime
	i ChManFlag'="N"  s manflag="1" 
	s mangroup=CManGroupID
	i CDateSt="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	i CDateEnd="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	i CDateSt>CDateEnd  Set QHandle=$lb(0,repid,0) Quit $$$OK 
    i ctloc=""  Set QHandle=$lb(0,repid,0) Quit $$$OK 
   	s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(ctloc)
	s HospID=$p(CustStr,"^",5)
	s CustID=$p(CustStr,"^",1)
    s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
    i phl=""  Set QHandle=$lb(0,repid,0) Quit $$$OK 
    i userid'="" k ^TMP(ctloc,userid,$j)
    s pid=..DoCreatYfrxb(phl,CDateSt,CDateEnd,fydr,CWinPosCode,sttime,endtime)
    s ctlocdesc="",cyflag="",total=0
    s ctlocdesc=$p(^CTLOC(ctloc),"^",2)
    s cyflag=$p(^DHCPHLOC(phl),"^",6)
    s currdate=$p($h,",",1)
    s total=0,totalrpamt=0
	s pinci=""
	f  s pinci=$o(^DHCPHTMPYPXC(pid,pinci)) q:pinci=""  d
	  .q:(pinci'=inci)&(inci'="")
	  .s incmanflag="",manrow="",incmangroup=""
	  .s incich=$o(^INCI("IL_LOC",ctloc,pinci,""))
	  .s incil=pinci_"||"_incich
	  .s incmanflag="",incmangroup=""
	  .i $D(^DHCINCIL(0,"INCIL",incil)) d //管理药,管理组用DHC_IncItmLoc维护,yunhaibao20160526
	  ..s dhcincil=$o(^DHCINCIL(0,"INCIL",incil,""))
	  ..s incmanflag=$p(^DHCINCIL(dhcincil),"^",9)  //1,0
	  ..s incmangroup=$p(^DHCINCIL(dhcincil),"^",7)
	  .q:(incmangroup'=mangroup)&(mangroup'="")
	  .q:(incmanflag'="1")&(manflag="1")
	  .s baseuom=$p(^INCI(pinci,1),"^",10)
	  .s puruom=$p(^INCI(pinci,3),"^",6)
	  .s incsc="",itmmast=""
	  .s incsc=+$p(^INCI(pinci,2),"^",2)
	  .q:(incsc'=CIncCatID)&(CIncCatID'="")
	  .s itmmast=$p(^INCI(pinci,1),"^",3)
	  .s phuomid=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),8),"^",14)
	  .i phuomid="" s phuomid=$p(^INCI(pinci,1),"^",12)
	  .s phcdrg="",phcform="",phfact="",ordertype="",ItemCatDR=""
	  .s phcdrg=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),1),"^",12)
	  .s subcat="",phcat="",minsubcat=""
	  .s confac=1
	  .i phuomid=baseuom  s confac=1
	  .e  d
	  ..s conrow=""
	  ..s conrow=$o(^CT("CTCF",0,"UOM",phuomid,baseuom,""))
	  ..s confac=+$p(^CT("CTCF",conrow),"^",3)
      .s subcat=$p(^PHCD($p(phcdrg,"||",1),1),"^",3)
      .i subcat'=""  d
	   ..s phcat=$p(subcat,"||",1)
      .q:(CPhCatID'="")&(CPhCatID'=phcat)
      .s dhcphccat=$p($g(^PHCD(+$p(phcdrg,"||",1),"DF",1,"DHC")),"^",20)
      .q:(NewPhcCat'="")&&(NewPhcCat'=dhcphccat)
      .s ItemCatDR=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),1),"^",10)
	  .s ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
	  .i phcdrg'=""  d
	  ..s phcform=$p(^PHCD($p(phcdrg,"||",1),"DF",$p(phcdrg,"||",2),1),"^",1)
	  ..s phfact=$p(^PHCD($p(phcdrg,"||",1),2),"^",4)
	  .e  d
	  ..s phcform="",phfact=""
      .s phcode=$p(^INCI(pinci,1),"^",1)
      .s phdesc=$p(^INCI(pinci,1),"^",2)
      .i phfact=""  s factdesc="" 
      .e  d
      ..i '$d(^PHMNF(phfact))  s factdesc="" 
      ..e  s factdesc=$p(^PHMNF(phfact),"^",2)
      .s puruomdesc=""
      .i phuomid'="" s puruomdesc=$p(^CT("UOM",phuomid),"^",2)
      .s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+pinci)
      .s StkTypeDesc=$P(CatGrpStr,"^",4)
      .s Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
	  .s index=""
	  .f  s index=$o(^DHCPHTMPYPXC(pid,pinci,index)) q:index=""  d
	   ..s ckmoney=$p(^DHCPHTMPYPXC(pid,pinci,index),"^",2)
	   ..s ckqty=$p(^DHCPHTMPYPXC(pid,pinci,index),"^",1)
	   ..s ckuom=$p(^DHCPHTMPYPXC(pid,pinci,index),"^",3)
	   ..s sp=$p(^DHCPHTMPYPXC(pid,pinci,index),"^",4)
	   ..s rp=$p(^DHCPHTMPYPXC(pid,pinci,index),"^",5)
	   ..s rpamt=$p(^DHCPHTMPYPXC(pid,pinci,index),"^",6)
	   ..s currprice=sp*confac
	   ..s rp=rp*confac
	   ..i confac>1 d
	   ...s currprice=+##Class(web.DHCSTCOMMPARA).GetNumbFN(currprice,Perv,"FmtSP",1)
	   ...s rp=+##Class(web.DHCSTCOMMPARA).GetNumbFN(rp,Perv,"FmtSP",1)
	   ..q:(currprice<CIncPrice)&(CIncPrice'="")
	   ..s ckqty=ckqty/confac
       ..q:ckqty=0
       ..s total=total+ckmoney
       ..s totalrpamt=totalrpamt+rpamt
       ..i $f(factdesc,"-") s factdesc=$p(factdesc,"-",2)
       ..s stkqty=##class(web.DHCSTSTKQTY).CurQtyU(phcode,ctlocdesc,puruomdesc)
       ..s stkqty=+$fn(stkqty,"",3)
       ..s Data=$lb(phcode,phdesc,factdesc,puruomdesc,currprice,ckqty,ckmoney,rp,rpamt,stkqty)
       ..s m=m+1
       ..s ^TMP(ctloc,userid,$j,m)=phcode_"^"_phdesc_"^"_puruomdesc_"^"_currprice_"^"_ckqty_"^"_ckmoney
 	   ..S ^CacheTemp(repid,ind)=Data	
 	   ..S ind=ind+1
 	   
 	   s Data=$lb(" 合计","","","","","",total,"",totalrpamt)
 	   S ^CacheTemp(repid,1)=Data	
 	   S ind=ind+1
 	   s m=m+1
       s ^TMP(ctloc,userid,$j,m)="合计"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_total_"^"_""_"^"_totalrpamt
 	   S QHandle=$lb(0,repid,0)
	   Quit $$$OK
}

ClassMethod QueryGYFRXBFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGYFRXBExecute ]
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

Query QueryGYFRXB(ctloc As %String, CDateSt As %String, CDateEnd As %String, fydr As %String, inci As %String, CIncCatID As %String, CIncPrice As %String, CPhCatID As %String, ChManFlag As %String, CManGroupID As %String, userid As %String, CWinPosCode As %String, CStTime As %String, CEndTime As %String, NewPhcCat As %String = "") As %Query(ROWSPEC = "TPhCode:%String,TPhDesc:%String,TFactory:%String,TPhUom:%String,TPrice:%String,TOutQty:%String,TOutMoney:%String,TOutRp:%String,TOutRpAmt:%String,TOutStkQty:%String")
{
}

ClassMethod QueryGRETDJCXClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryGRETDJCXExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCOutPhRetrieve","QueryGRETDJCX","18/07/2018","21/07/2018","308")

ClassMethod QueryGRETDJCXExecute(ByRef QHandle As %Binary, CDateSt As %Library.String = "", CDateEnd As %Library.String = "", ctloc As %Library.String = "") As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1
  s CDateSt=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateSt)
  s CDateEnd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateEnd)
  k ^DHCPHTMPRETPHCX($j),^DHCPHTMPRETPHhz($j)
  s stdate="",enddate=""
  i CDateSt="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
  i CDateEnd="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
  s stdate=CDateSt
  s enddate=CDateEnd
  s phl=""
  i ctloc=""  S QHandle=$lb(0,repid,0)	Quit $$$OK
  s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
  i phl=""   S QHandle=$lb(0,repid,0)	Quit $$$OK
  s phretdate = "",ret=0,t=0,l=0
  s totalmoney=0
  s phretdate=""
  f phretdate=stdate:1:enddate d
          .s retrow = ""
          .f  s retrow=$o(^DHCPHRETi(phretdate,phl,retrow)) q:retrow=""  d
            ..s retdate=""
            ..s retdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(phretdate)
            ..s prt="",retmoney=0,retuser="",username="",papmi=""
            ..s prt=+$p(^DHCPHRET(retrow),"^",9)
            ..s retmoney=+$p(^DHCPHRET(retrow),"^",11)
            ..s retuser=+$p(^DHCPHRET(retrow),"^",8)
            ..s username=$p(^DHCPHPER(retuser),"^",2)
            ..i username["#" s username=$p(username,"#",2)
            ..s phdrow="",phddate=""
            ..s phdrow=+$p(^DHCPHRET(retrow),"^",6)
            ..s phddate=$p(^DHCPHDISP(phdrow,1),"^",5)
            ..s phddate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(phddate)
            ..s rfr="",rfrdesc="",ghloc="",ghlocdesc="",ldoctor="",ldoctorname=""
            ..s rfr=+$p(^DHCPHRET(retrow),"^",13)
            ..;i rfr'="0" s rfrdesc=$p(^BLC("RFR",rfr),"^",2)
            ..i (rfr'="0")&($d(^DHCINVOPREFR(rfr))) s rfrdesc=$p(^DHCINVOPREFR(rfr),"^",2)    ///取退费原因 by caoting
            ..s retsub=""
            ..f  s retsub=$o(^DHCPHRTI(retrow,"RTI",retsub)) q:retsub=""  d
               ...s rmoney=0,retqty=0,retunit="",retoeori=""
               ...s rmoney=+$p(^DHCPHRTI(retrow,"RTI",retsub),"^",1)
               ...s retmoney=retmoney+rmoney
               ...s retqty=$p(^DHCPHRTI(retrow,"RTI",retsub),"^",3)
               ...s retqty=$p(retqty,$c(1),1)
               ...s retunit=$p(^DHCPHRTI(retrow,"RTI",retsub),"^",4)
               ...s retunit=$p(retunit,$c(1),1)
               ...s retoeori=$p(^DHCPHRTI(retrow,"RTI",retsub),"^",2)
               ...s ord="",itm="",itmmast="",inci=""
               ...s ord=$p(retoeori,"||",1)
               ...s itm=$p(retoeori,"||",2)
               ...s adm=""
               ...s adm=+$p(^OEORD(ord),"^",1)
               ...s papmi=$p(^PAADM(adm),"^",1)
               ...s patname=$p(^PAPER(papmi,"ALL"),"^",1)
               ...s papmino=$p(^PAPER(papmi,"PAT",1),"^",2)
               ...s ghloc=+$p(^PAADM(adm),"^",4)
               ...s ldoctor=+$p(^OEORD(ord,"I",itm,1),"^",11)
               ...i ghloc'=0 s ghlocdesc=$p(^CTLOC(ghloc),"^",2)
               ...i ghlocdesc["-" s ghlocdesc=$p(ghlocdesc,"-",2)
               ...s warddesc=""
	    	   ...s currwarddr=$p(^PAADM(adm),"^",70)
	    	   ...i currwarddr'="" d
	    	   ....s ctlocdr=$p(^PAWARD(currwarddr),"^",5)
	    	   ....s warddesc=$p(^CTLOC(ctlocdr),"^",2)
	    	   ....i warddesc["-" s warddesc=$p(warddesc,"-",2)
	    	   ....s ghlocdesc=ghlocdesc_"["_warddesc_"]"
               ...s orddoctdr=""
               ...i ldoctor'=0  d
               ....s ldoctorname=$p(^CTPCP(ldoctor,1),"^",2)
   			   ...e  d
   			   ....s orddoctdr=$p($g(^OEORD(ord,"I",itm,7)),"^",1) ;医师    
   			   ....i orddoctdr'=""  d
   			   .....s ldoctorname=$p($g(^SSU("SSUSR",orddoctdr)),"^",2)
               ...s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
               ...s itmmastid="",itmmastver=""
               ...s itmmastid=$p(itmmast,"||",1)
               ...s itmmastver=$p(itmmast,"||",2)
               ...s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
               ...s inci=$p(inci,$c(1),1)
               ...i '$d(^TMPRETPH(phl,inci))  d
               ....s $p(^DHCPHTMPRETPHhz($j,phl,inci),"^",1)=retmoney
               ....s $p(^DHCPHTMPRETPHhz($j,phl,inci),"^",2)=retqty
               ....s $p(^DHCPHTMPRETPHhz($j,phl,inci),"^",3)=retunit
               ...e  d
               ....s $p(^DHCPHTMPRETPHhz($j,phl,inci),"^",1)=$p(^TMPRETPH(phl,inci),"^",1)+retmoney
               ....s $p(^DHCPHTMPRETPHhz($j,phl,inci),"^",2)=$p(^TMPRETPH(phl,inci),"^",2)+retqty
	          ..s EncryptLevelInfo=""
	          ..s EncryptLevel=""
	          ..s PatLevel=""
	          ..s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
	          ..i (EncryptFlag=1)&&(papmi'="") d
		      ...s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmi,"")
	 	      ...s EncryptLevel=$p(EncryptLevelInfo,"^",1)
	 	      ...s PatLevel=$p(EncryptLevelInfo,"^",2)
    
           ..s ^DHCPHTMPRETPHCX($j,ret)=retdate_"^"_papmino_"^"_patname_"^"_rfrdesc_"^"_retmoney_"^"_ghlocdesc_"^"_ldoctor_"^"_EncryptLevel_"^"_PatLevel
           ..s retmoney=$j(retmoney,12,2)
           ..s totalmoney=totalmoney+retmoney
           ..s Data=$lb(papmino,patname,retdate,rfrdesc,retmoney,username,retrow,phddate,ghlocdesc,ldoctorname,EncryptLevel,PatLevel)   
   	       ..S ^CacheTemp(repid,ind)=Data	
 	       ..S ind=ind+1
 	       ;s Data=$lb("合计","","","",totalmoney,"","","","","")   
   	       ;S ^CacheTemp(repid,ind)=Data	
 	       ;S ind=ind+1
 	S QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryGRETDJCXFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGRETDJCXExecute ]
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

Query QueryGRETDJCX(CDateSt As %String, CDateEnd As %String, ctloc As %String) As %Query(ROWSPEC = "TPmiNo:%String,TPatName:%String,TRetDate:%String,TRetReason:%String,TRetMoney:%String,TRetUser:%String,TRetRowid:%String,TDispDate:%String,TLocDesc:%String,TDoctor:%String,TEncryptLevel:%String,TPatLevel:%String")
{
}

ClassMethod QueryGRetPhClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryGRetPhExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCOutPhRetrieve","QueryGRetPh",36)
ClassMethod QueryGRetPhExecute(ByRef QHandle As %Binary, ret As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	i ret=""  S QHandle=$lb(0,repid,0) Quit $$$OK
	s ind=1
	s retsub=""
	f  s retsub=$o(^DHCPHRTI(ret,"RTI",retsub)) q:retsub=""  d
	.s oeori="",retmoney=0,retqty=0,retunit=""
	.s oeori=$p(^DHCPHRTI(ret,"RTI",retsub),"^",2)
	.s retmoney=$p(^DHCPHRTI(ret,"RTI",retsub),"^",1)
	.s retmoney=$p(retmoney,$c(1),1)
	.s retqty=$p(^DHCPHRTI(ret,"RTI",retsub),"^",3)
	.s retqty=$p(retqty,$c(1),1)	// 退药表现在存的基本单位
	.s retunit=$p(^DHCPHRTI(ret,"RTI",retsub),"^",4)
	.s price=$p(^DHCPHRTI(ret,"RTI",retsub),"^",6)
	.s retunit=$p(retunit,$c(1),1)
	.s ord="",itm="",itmmast="",inci="",phdesc="",uomdesc=""
	.s ord=$p(oeori,"||",1)
	.s itm=$p(oeori,"||",2)
	.s dispUomId=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)
	.s retInclb=$p(^DHCPHRTI(ret,"RTI",retsub),"^",13)
	.s phdesc=$p(^INCI(+retInclb,1),"^",2)
	.i dispUomId="" d
	..s fmtQtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(+retInclb,retqty)
	.e  d
	..s fmtQtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(+retInclb,retqty,dispUomId)
	.s conFac=$p(fmtQtyUomStr,"^",3)
	.s uomId=$p(fmtQtyUomStr,"^",2)
	.s qty=$p(fmtQtyUomStr,"^",1)
	.s uomDesc=$p($g(^CT("UOM",uomId)),"^",2)
	.s price=price*conFac
	.s batexpstr=""
	.s intr=""
    .f  s intr=$o(^DHCINTR(0,"TypePointer","H",ret_"||"_retsub,intr)) q:intr=""  d
    ..s inclb=$p(^DHCINTR(intr),"^",7)
    ..s incib=$p($g(^INCI(+inclb,"IL",+$p(inclb,"||",2),"LB",+$p(inclb,"||",3))),"^",1)
    ..q:incib=""
    ..s batno=$p($g(^INCI(+incib,"IB",$p(incib,"||",2))),"^",1)
    ..s expdate=$p($g(^INCI(+incib,"IB",$p(incib,"||",2))),"^",2)
    ..s expdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expdate)
    ..i batno'="" s batexpstr=$s(batexpstr="":batno_"~"_expdate,1:batexpstr_"</br>"_batno_"~"_expdate)
	.s Data=$lb(phdesc,uomDesc,qty,retmoney,price,batexpstr)   
	.S ^CacheTemp(repid,ind)=Data	
	.S ind=ind+1
	.;s ^TMPRETPH($j,m)=phdesc_"^"_newunitdesc_"^"_qty_"^"_retmoney

	S QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryGRetPhFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGRetPhExecute ]
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

Query QueryGRetPh(ret As %String) As %Query(ROWSPEC = "TPhDesc:%String,TPhUom:%String,TRetQty:%String,TRetMoney:%String,TPhprice:%String,TBatExpStr")
{
}

ClassMethod QueryGRetPhHZClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryGRetPhHZExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// w ##class(%ResultSet).RunQuery("web.DHCOutPhRetrieve","QueryGRetPhHZ","310","2018-11-15","2018-11-15")
ClassMethod QueryGRetPhHZExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "", CDateSt As %Library.String = "", CDateEnd As %Library.String = "", CDepCode As %Library.String = "", CDoctor As %Library.String = "") As %Status
{
	n (QHandle,ctloc,CDateSt,CDateEnd,CDepCode,CDoctor)
	s ^TMPDHCSTPARAMS("web.DHCOutPhRetrieve","QueryGRetPhHZ")=$lb(ctloc,CDateSt,CDateEnd)	
	Set repid=$I(^CacheTemp)
	s ind=1
	k QueryGRetPhHZData
	s CDateSt=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateSt)
	s CDateEnd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateEnd)
	s stdate="",enddate="" 	  
	s stdate=CDateSt
	s enddate=CDateEnd
	i CDateSt="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	i CDateEnd="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	s phl=""
	i ctloc=""  S QHandle=$lb(0,repid,0)	Quit $$$OK
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl=""   S QHandle=$lb(0,repid,0)	Quit $$$OK
	s phretdate = "",ret=0,t=0,l=0
	f  s phretdate=$o(^DHCPHRETi(phretdate)) q:phretdate=""  d
	.s retrow = ""
	.q:phretdate<stdate
	.q:phretdate>enddate
	.f  s retrow=$o(^DHCPHRETi(phretdate,phl,retrow)) q:retrow=""  d
	..s retdate=""
	..s retdate=$zd(phretdate,3)
	..s prt="",retmoney=0,retuser="",username=""
	..s retsub=""
	..f  s retsub=$o(^DHCPHRTI(retrow,"RTI",retsub)) q:retsub=""  d
	...q:+retsub=0
	...s retSubData=^DHCPHRTI(retrow,"RTI",retsub)
	...s rmoney=0,retqty=0,retunit="",retoeori=""
	...s rmoney=+$p(retSubData,"^",1)
	...s retmoney=retmoney+rmoney
	...s retqty=$p(retSubData,"^",3)
	...s retqty=$p(retqty,$c(1),1)
	...s retunit=$p(retSubData,"^",4)
	...s retunit=$p(retunit,$c(1),1)
	...s retoeori=$p(retSubData,"^",2)
	...s retinclb=$p(retSubData,"^",13)
	...s inci=+retinclb
	...s ord=$p(retoeori,"||",1)
	...s itm=$p(retoeori,"||",2)
	...s adm="",ghloc="",ldoctor=""
	...s adm=+$p(^OEORD(ord),"^",1)
	...s ghloc=+$p(^PAADM(adm),"^",4)
	...s ldoctor=+$p(^OEORD(ord,"I",itm,1),"^",11)
	...q:(ghloc'=CDepCode)&(CDepCode'="")
	...q:(ldoctor'=CDoctor)&(CDoctor'="")
	...i '$d(QueryGRetPhHZData(phl,inci))  d
	....s $p(QueryGRetPhHZData(phl,inci),"^",1)=rmoney
	....s $p(QueryGRetPhHZData(phl,inci),"^",2)=retqty
	....s $p(QueryGRetPhHZData(phl,inci),"^",3)=retunit
	...e  d
	....s $p(QueryGRetPhHZData(phl,inci),"^",1)=$p(QueryGRetPhHZData(phl,inci),"^",1)+rmoney
	....s $p(QueryGRetPhHZData(phl,inci),"^",2)=$p(QueryGRetPhHZData(phl,inci),"^",2)+retqty
	s phid = "",total=0
	f  s phid=$o(QueryGRetPhHZData(phl,phid)) q:phid=""  d
	.s money = 0, qty = 0, unit = "",uomdesc=""
	.s money=$p(QueryGRetPhHZData(phl,phid),"^",1)
	.s qty=$p(QueryGRetPhHZData(phl,phid),"^",2)
	.s unit=$p(QueryGRetPhHZData(phl,phid),"^",3)
	.s phdesc=$p(^INCI(phid,1),"^",2)
	.s fmtQtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(phid,qty)
	.s qty=$p(fmtQtyUomStr,"^",1)
	.i (qty<1)&&($p(qty,".",1)="") s qty=0_qty
	.s uomId=$p(fmtQtyUomStr,"^",2)
	.s uomDesc=$p($g(^CT("UOM",+uomId)),"^",2)
	.s total=total+money
	.s money=$fn(money,"",2)
	.i (money<1)&&($p(money,".",1)="") s money=0_money
	.s iii=0
	.s Data=$lb(phdesc,uomDesc,qty,money)   
	.S ^CacheTemp(repid,ind)=Data	
	.S ind=ind+1
	s total=$fn(total,"",2)
	s Data=$lb("合计","","",total)   
	S ^CacheTemp(repid,ind)=Data	
	S ind=ind+1
	S QHandle=$lb(0,repid,0)
	k QueryGRetPhHZData
	Quit $$$OK
}

ClassMethod QueryGRetPhHZFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGRetPhHZExecute ]
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

Query QueryGRetPhHZ(ctloc As %String, CDateSt As %String, CDateEnd As %String, CDepCode As %String, CDoctor As %String) As %Query(ROWSPEC = "TPhDesc:%String,TPhUom:%String,TRetQty:%String,TRetMoney:%String")
{
}

ClassMethod QueryStkCatClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryStkCatExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryStkCatExecute(ByRef QHandle As %Binary) As %Status
{
  
	Set repid=$I(^CacheTemp)
	s ind=1
	s stkcat=""
	f  s stkcat=$o(^INC("SC",stkcat)) q:stkcat=""  d
	.q:stkcat="0"
	.s desc=$p(^INC("SC",stkcat),"^",2)
	.set Data=$lb(desc,stkcat)
	.Set ^CacheTemp(repid,ind)=Data
	.Set ind=ind+1
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryStkCatFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStkCatExecute ]
{

	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query QueryStkCat() As %Query(ROWSPEC = "名称:%String,ID:%String")
{
}

ClassMethod QueryPhCatClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryPhCatExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryPhCatExecute(ByRef QHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s stkcat="0"
	f  s stkcat=$o(^PHCC(stkcat)) q:(stkcat="")!(stkcat="0")  d
	.s phcatdesc=""
	.q:stkcat["M"
	.q:stkcat["SC"
	.s phcatdesc=$p(^PHCC(stkcat),"^",2)
	.set Data=$lb(phcatdesc,stkcat)
	.Set ^CacheTemp(repid,ind)=Data
	.Set ind=ind+1
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryPhCatFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPhCatExecute ]
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

Query QueryPhCat() As %Query(ROWSPEC = "名称:%String,ID:%String")
{
}

ClassMethod QueryUnDispLocPatienCXClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryUnDispLocPatienCXExecute ]
{
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryUnDispLocPatienCXExecute(ByRef QHandle As %Binary, CDateSt As %Library.String = "", CDateEnd As %Library.String = "", ctloc As %Library.String = "", flag As %Library.String = "", CReasID As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1,st="",end=""
	i $g(ctloc)=""  Set QHandle=$lb(0,repid,0) Quit $$$OK
	s st=CDateSt
	s end=CDateEnd
	i CDateSt="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	i CDateEnd="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	i st>end  Set QHandle=$lb(0,repid,0) Quit $$$OK
	s phl="",total=0
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl=""  Set QHandle=$lb(0,repid,0) Quit $$$OK
	i flag="1"  d
	 .s phddate = "", t = 0
     .f  s phddate=$o(^DHCPHUNDi(phddate)) q:phddate=""  d
       ..q:phddate<st
       ..q:phddate>end
       ..s phdrow = ""
       ..f  s phdrow=$o(^DHCPHUNDi(phddate,phl,phdrow)) q:phdrow=""  d
         ...s pyflag="",fyflag="",pydr="",pyname="",prt="",inv="",pydate="",use="",perno="",pname=""
         ...s unpersondr="",unpersonname="",unpersonpmi=""
         ...s pydate=phddate
         ...s fyyy="",yydr=""
         ...s yydr=+$p(^DHCPHUND(phdrow),"^",14)
         ...q:(yydr'=CReasID)&(CReasID'="")
         ...i yydr'=0 s fyyy=$p(^DHCPHUNDR(yydr),"^",1)
         ...s pydate=$zd(pydate,3)
         ...s unpersondr=+$p(^DHCPHUND(phdrow),"^",8)
         ...s unpersonname=$p(^DHCPHINP(unpersondr),"^",2)
         ...s unpersonpmi=$p(^DHCPHINP(unpersondr),"^",9)
         ...s pydr=+$p(^DHCPHUND(phdrow),"^",10)
         ...s pyname=$p(^DHCPHPER(pydr),"^",2)
         ...s bz=""
         ...s bz=$p(^DHCPHINP(unpersondr),"^",7)
         ...s phdi="",phdmoney=0
         ...f  s phdi=$o(^DHCPHUND(phdrow,"I",phdi)) q:phdi=""  d
            ....s money=0,qty=0,ctuom="",price=0,inc=""
            ....s money=+$p(^DHCPHUND(phdrow,"I",phdi),"^",5)
            ....s ctuom=+$p(^DHCPHUND(phdrow,"I",phdi),"^",1)
            ....s qty=+$p(^DHCPHUND(phdrow,"I",phdi),"^",4)
            ....s inc=+$p(^DHCPHUND(phdrow,"I",phdi),"^",2)
            ....s price=+$p(^DHCPHUND(phdrow,"I",phdi),"^",3)
            ....s phdmoney=phdmoney+money
  	      ...//q:phdmoney=0
  	      ...s total=total+phdmoney
  	      ...set Data=$lb(unpersonname,unpersonpmi,pydate,phdmoney,pyname,phdrow,fyyy,bz)
 	      ...Set ^CacheTemp(repid,ind)=Data	
 	      ...Set ind=ind+1
   e  d
     .s phddate = "", t = 0
     .f  s phddate=$o(^DHCPHUNRi(phddate)) q:phddate=""  d
       ..q:phddate<st
       ..q:phddate>end
       ..s phdrow = ""
       ..f  s phdrow=$o(^DHCPHUNRi(phddate,phl,phdrow)) q:phdrow=""  d
         ...s pyflag="",fyflag="",pydr="",pyname="",prt="",inv="",pydate="",use="",perno="",pname=""
         ...s unpersondr="",unpersonname="",unpersonpmi=""
         ...s pydate=phddate
         ...s pydate=$zd(pydate,3)
         ...s unpersondr=+$p(^DHCPHUNR(phdrow),"^",9)
         ...s unpersonname=$p(^DHCPHINP(unpersondr),"^",2)
         ...s unpersonpmi=$p(^DHCPHINP(unpersondr),"^",9)
         ...s pydr=+$p(^DHCPHUNR(phdrow),"^",11)
         ...s fyyy="",yydr=""
         ...s yydr=+$p(^DHCPHUNR(phdrow),"^",14)
         ...q:(yydr'=CReasID)&(CReasID'="")
         ...i yydr'=0 s fyyy=$p(^DHCPHUNDR(yydr),"^",1)
         ...s pyname=$p(^DHCPHPER(pydr),"^",2)
         ...s bz=""
         ...s bz=$p(^DHCPHINP(unpersondr),"^",7)
         ...s phdi="",phdmoney=0
         ...f  s phdi=$o(^DHCPHUNRI(phdrow,"I",phdi)) q:phdi=""  d
            ....s money=0,qty=0,ctuom="",price=0,inc=""
            ....s money=+$p(^DHCPHUNRI(phdrow,"I",phdi),"^",5)
            ....s ctuom=+$p(^DHCPHUNRI(phdrow,"I",phdi),"^",1)
            ....s qty=+$p(^DHCPHUNRI(phdrow,"I",phdi),"^",4)
            ....s inc=+$p(^DHCPHUNRI(phdrow,"I",phdi),"^",2)
            ....s price=+$p(^DHCPHUNRI(phdrow,"I",phdi),"^",3)
            ....s phdmoney=phdmoney+money
  	      ...//q:phdmoney=0
  	      ...s total=total+phdmoney
  	      ...set Data=$lb(unpersonname,unpersonpmi,pydate,phdmoney,pyname,phdrow,fyyy,bz)
 	      ...Set ^CacheTemp(repid,ind)=Data	
 	      ...Set ind=ind+1
    s total=$fn(total,"",2)
    set Data=$lb("合计","","",total,"","")
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1

    Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryUnDispLocPatienCXFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUnDispLocPatienCXExecute ]
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

Query QueryUnDispLocPatienCX(CDateSt As %String, CDateEnd As %String, ctloc As %String, flag As %String, CReasID As %String) As %Query(ROWSPEC = "TPerName:%String,TPmiNo:%String,TPrtDate:%String,TPhMoney:%String,TPyName:%String,tphd:%String,TReasDesc:%String,TNote:%String") [ SqlProc ]
{
}

ClassMethod GetPrintRow(ctloc As %String, userid As %String)
{
 s ll=0,t=0
 f  s t=$o(^TMP(ctloc,userid,$j,t)) q:(t="")!(t=0)  d
 .s ll=t
 .
 q ll
}

ClassMethod GetPrintPageRow(ctloc As %String, userid As %String, m As %String)
{
 s ret=""
 s ret=$g(^TMP(ctloc,userid,$j,m))
 q ret
}

ClassMethod GetUnDispPrintRow(Rowid As %String, flag As %String)
{
 q:Rowid="" 0
 q:flag="" 0	
 s ll=0,t=0
 f  s t=$o(^DHCTMPUNDISPPRINT(Rowid,flag,t)) q:(t="")!(t=0)  d
   .s ll=t
 q ll
}

ClassMethod GetUnDispPrintPageRow(Rowid As %String, flag As %String, m As %String)
{
 q:Rowid="" ""
 q:flag="" ""
 q:m="" ""
 q:'$d(^DHCTMPUNDISPPRINT(Rowid,flag,m)) ""	
 s ret=""
 s ret=$g(^DHCTMPUNDISPPRINT(Rowid,flag,m))
 q ret
}

ClassMethod GetPerUnDispRetClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetPerUnDispRetExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetPerUnDispRetExecute(ByRef QHandle As %Binary, Rowid As %Library.String = "", flag As %Library.String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1,p=0
	s phl="",ctloc=""
	
	i Rowid="" Set QHandle=$lb(0,repid,0)	Quit $$$OK
	i flag="" Set QHandle=$lb(0,repid,0)	Quit $$$OK
	k ^DHCTMPUNDISPPRINT(Rowid,flag)
	i flag="1"  d
	  .s itm=""
	  .f  s itm=$o(^DHCPHUND(Rowid,"I",itm)) q:itm=""  d
	    ..s inci="",ctuom="",qty=0,money=0,price=0,incdesc="",uomdesc=""
	    ..s inci=+$p(^DHCPHUND(Rowid,"I",itm),"^",2)
	    ..s incicode=$p(^INCI(inci,1),"^",1)
	    ..s incdesc=$p(^INCI(inci,1),"^",2)
	    ..s ctuom=+$p(^DHCPHUND(Rowid,"I",itm),"^",1)
	    ..s uomdesc=$p($g(^CT("UOM",ctuom)),"^",2)
	    ..s qty=+$p(^DHCPHUND(Rowid,"I",itm),"^",4)
	    ..s incibuom=$p(^INCI(inci,1),"^",10)
	    ..s confac=##class(web.DHCSTCOMMONSRV).UOMFac(ctuom,incibuom)
	    ..s qty=qty/confac
	    ..s money=+$p(^DHCPHUND(Rowid,"I",itm),"^",5)
	    ..s price=+$p(^DHCPHUND(Rowid,"I",itm),"^",3)
	    ..s p=p+1
	    ..s ^DHCTMPUNDISPPRINT(Rowid,flag,p)=incdesc_"^"_uomdesc_"^"_price_"^"_qty_"^"_money
	    ..set Data=$lb(incdesc,uomdesc,price,qty,money)
 	    ..Set ^CacheTemp(repid,ind)=Data	
 	    ..Set ind=ind+1
 	    ..
 	 e  d
 	  .s itm=""
	  .f  s itm=$o(^DHCPHUNRI(Rowid,"I",itm)) q:itm=""  d
	    ..s inci="",ctuom="",qty=0,money=0,price=0,incdesc="",uomdesc=""
	    ..s inci=+$p(^DHCPHUNRI(Rowid,"I",itm),"^",2)
	    ..s incdesc=$p(^INCI(inci,1),"^",2)
	    ..s ctuom=+$p(^DHCPHUNRI(Rowid,"I",itm),"^",1)
	    ..s uomdesc=$p($g(^CT("UOM",ctuom)),"^",2)
	    ..s qty=+$p(^DHCPHUNRI(Rowid,"I",itm),"^",4)
	    ..s incibuom=$p(^INCI(inci,1),"^",10)
	    ..s confac=##class(web.DHCSTCOMMONSRV).UOMFac(ctuom,incibuom)
	    ..s qty=qty/confac
	    ..s money=+$p(^DHCPHUNRI(Rowid,"I",itm),"^",5)
	    ..s price=+$p(^DHCPHUNRI(Rowid,"I",itm),"^",3)
	    ..s p=p+1
	    ..s ^DHCTMPUNDISPPRINT(Rowid,flag,p)=incdesc_"^"_uomdesc_"^"_price_"^"_qty_"^"_money
	    ..set Data=$lb(incdesc,uomdesc,price,qty,money)
 	    ..Set ^CacheTemp(repid,ind)=Data	
 	    ..Set ind=ind+1
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetPerUnDispRetFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPerUnDispRetExecute ]
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

Query GetPerUnDispRet(Rowid As %String, flag As %String) As %Query(ROWSPEC = "TPhDesc:%String,TPhUom:%String,TPrice:%String,TPhQty:%String,TPhMoney:%String") [ SqlProc ]
{
}

ClassMethod GetSysTime()
{
  s ret="",systime=""
  s systime=$p($h,",",2)
  s ret=$zt(systime,2)
  q ret
}

ClassMethod GetLocDesc(ctloc As %String)
{
  s locdesc=""
  s locdesc=$p(^CTLOC(ctloc),"^",2)
  i locdesc["-" s locdesc=$p(locdesc,"-",2)
  q locdesc
}

ClassMethod QueryMZYPClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryMZYPExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// w ##class(%ResultSet).RunQuery("web.DHCOutPhRetrieve","QueryMZYP","01/11/2018","12/11/2018","308","","1")
ClassMethod QueryMZYPExecute(ByRef QHandle As %Binary, CDateSt As %Library.String = "", CDateEnd As %Library.String = "", ctloc As %Library.String = "", CIncCatID As %Library.String = "", PoisonRowid As %Library.String = "") As %Status
{
	s ^TMPDHCSTPARAMS("web.DHCOutPhRetrieve","QueryMZYP")=$lb(CDateSt, CDateEnd, ctloc, CIncCatID, PoisonRowid)
	k QueryMZYP("AdmData")
	Set repid=$I(^CacheTemp)
	s ind=2
	s CDateSt=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateSt)
	s CDateEnd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateEnd)
	s stdate="",enddate=""
	i CDateSt="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	i CDateEnd="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	s stdate=CDateSt
	s enddate=CDateEnd
	s sysdate=+$h
	s phloc=""
	i PoisonRowid="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	i ctloc=""  S QHandle=$lb(0,repid,0)	Quit $$$OK
	s phloc=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phloc=""   S QHandle=$lb(0,repid,0)	Quit $$$OK
	s phddate = "",ret=0,t=0,l=0,hjmoney=0
	f phddate=stdate:1:enddate  d
	.s phdrow=""
	.f  s phdrow=$o(^DHCPHDISPi("FYDATE",phddate,phloc,phdrow)) q:phdrow=""  d
	..s phdpyflag="",phdfyflag=""
	..s phdfyflag=+$p(^DHCPHDISP(phdrow),"^",4)
	..s phdpyflag=+$p(^DHCPHDISP(phdrow,1),"^",6)
	..q:(phdfyflag'="1")
	..s phdpydr="",phdfydr=""
	..s phdpydr=+$p(^DHCPHDISP(phdrow,1),"^",3)
	..s phdfydr=+$p(^DHCPHDISP(phdrow,1),"^",2)
	..s prt="",prescno="",pmidr="",patname="",patID="",patloc="",doctname="",pmino=""
	..s prt=+$p(^DHCPHDISP(phdrow),"^",2)
	..s prescno=$p(^DHCPHDISP(phdrow,2),"^",1)
	..q:prescno=""
	..s tmpOrd=$o(^OEORD(0,"PrescNo",prescno,""))
	..s adm=+$p(^OEORD(tmpOrd),"^",1)
	..s admData=$$GetAdmData(adm)
	..s patID=$p(admData,"^",1)
	..s phdicd=$p(admData,"^",2)
	..s perold=$p(admData,"^",3)
	..s patlocdesc=$p(admData,"^",4)
	..s patname=$p(admData,"^",5)
	..s patsex=$p(admData,"^",6)
	..s pmino=$p(admData,"^",7)
	..s fydate="",fyname=""
	..s fydate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(phddate)
	..s fyname=$p(^DHCPHPER(phdfydr),"^",2)
	..s phdchid="0"
	..f  s phdchid=$o(^DHCPHDI(phdrow,"PHDI",phdchid)) q:(phdchid="")!(phdchid="0")  d
	...s itmmast="",phdqty=0,itm="",ori="",phdmoney=0
	...s oeori=$p(^DHCPHDI(phdrow,"PHDI",phdchid),"^",5)
	...q:oeori=""
	...s ord=+oeori
	...s itm=+$p(oeori,"||",2)
	...s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
	...s itmmastid=$p(itmmast,"||",1)
	...s itmmastver=$p(itmmast,"||",2)
	...s phcdf=$p($g(^ARCIM(itmmastid,itmmastver,1)),"^",12)
	...s poisondr=$p($g(^PHCD(+phcdf,1)),"^",4)
	...// 过滤条件-管制分类
	...q:(PoisonRowid'="")&(PoisonRowid'=poisondr) //注意单词拼写 by dhy
	...s instrdesc=$p(##class(web.DHCSTCOMMONORDER).OeoriInstruc(oeori),"^",2)
	...s doctname=$p(##class(web.DHCSTCOMMONORDER).OeoriDoctor(oeori),"^",2)
	...s Notes=$g(^OEORD(ord,"I",itm,"DEP",1)) ;医嘱备注
	...s remark=$p(^OEORD(ord,"I",itm,2),"^",8) //草药备注
	...S Notes=$tr($tr($tr(Notes,$c(10)),$C(13))," ")
	...i Notes'="" d
	....i remark'="" d
	.....s Notes=Notes_"("_remark_")"
	...e  i remark'="" d
	....s Notes=remark
	...s dispUomId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),"DHC")),"^",13)
	...s phdic=0
	...f  s phdic=$o(^DHCPHDI(phdrow,"PHDI",phdchid,"INCLB",phdic)) q:phdic=""  d
	....s phdicData=^DHCPHDI(phdrow,"PHDI",phdchid,"INCLB",phdic)
	....s inclb=$p(phdicData,"^",3)
	....s qty=$p(phdicData,"^",1)
	....s sp=$p(phdicData,"^",7)
	....s spAmt=$p(phdicData,"^",8)
	....s incId=$p(inclb,"||",1)
	....s incCh=$p(inclb,"||",2)
	....s incLb=$p(inclb,"||",3)
	....// 过滤条件-管制分类
	....q:(CIncCatID'="")&&(CIncCatID'=$p(^INCI(incId,2),"^",2))
	....s incdesc=$p(^INCI(incId,1),"^",2)
	....s incib=$p(^INCI(incId,"IL",incCh,"LB",incLb),"^",1)
	....s incIb=$p(incib,"||",2)
	....s libno=$p(^INCI(incId,"IB",incIb),"^",1)
	....i dispUomId'="" d 
	.....s fmtQtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(incId,qty,dispUomId)
	....e  d
	.....s fmtQtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(incId,qty)
	....s qty=$p(fmtQtyUomStr,"^",1)
	....s uomId=$p(fmtQtyUomStr,"^",2)
	....s uomdesc=$p($g(^CT("UOM",+uomId)),"^",2)
	....s fac=$p(fmtQtyUomStr,"^",3)
	....s sp=sp*fac
	....i (sp<1)&&($p(sp,".",1)="") s sp=0_sp
	....i (qty<1)&&($p(qty,".",1)="") s qty=0_qty
	....i (spAmt<1)&&($p(spAmt,".",1)="") s spAmt=0_spAmt
	....s t=t+1
	....s hjmoney=hjmoney+spAmt
	....s Data=$lb(fydate,pmino,patname,patsex,perold,patID,phdicd,prescno,incdesc,uomdesc,+qty,libno,instrdesc,patlocdesc,doctname,fyname,Notes,+spAmt)   
	....S ^CacheTemp(repid,ind)=Data	
	....S ind=ind+1
	k QueryMZYP("AdmData")
	s Data=$lb("合计","","","","","","","","","","","","","","","","",hjmoney)
	S ^CacheTemp(repid,1)=Data	
	S ind=ind+1
	s hj=0
	s hj=t
	s t=t+1
	S QHandle=$lb(0,repid,0)
	Quit $$$OK
GetAdmData(adm)
	q:$d(QueryMZYP("AdmData",adm)) QueryMZYP("AdmData",adm)
	s patID=$p((^PAADM(+adm,"DHC")),"^",35)
	i patID'="" s patID="(代)"_patID
	s phdicd=..GetMRDiagnosDesc(adm,",")
	s patloc=+$p(^PAADM(adm),"^",4)
	s patlocdesc=$p(^CTLOC(patloc),"^",2)
	i patlocdesc["-" s patlocdesc=$p(patlocdesc,"-",2)
	s warddesc=""
	s currwarddr=$p(^PAADM(adm),"^",70)
	i currwarddr'="" d
	.s ctlocdr=$p(^PAWARD(currwarddr),"^",5)
	.s warddesc=$p(^CTLOC(ctlocdr),"^",2)
	.i warddesc["-" s warddesc=$p(warddesc,"-",2)
	.s patlocdesc=patlocdesc_"["_warddesc_"]"
	s pmidr=+$p((^PAADM(+adm)),"^",1)
	s patname=$p(^PAPER(pmidr,"ALL"),"^",1)
	s patsexdr="",patsex="",birthday="",difdate="",perold=""
	s patsexdr=+$p(^PAPER(pmidr,"ALL"),"^",7)
	s birthday=+$p(^PAPER(pmidr,"ALL"),"^",6)
	s pmino=$p(^PAPER(pmidr,"PAT",1),"^",2)
	s difdate=sysdate-birthday+1
	i patsexdr'="" s patsex=$p($g(^CT("SEX",patsexdr)),"^",2)
	e  s patsex=""
	s perold=##class(web.DHCSTKUTIL).GetAge(pmidr,adm) //年龄统一调用接口wyx 2015-01-29
	s patID=$p(^PAPER(pmidr,"ALL"),"^",9)
	s patID=##class(web.DHCDocOrderEntry).FindPAPMIID(pmidr) //获取身份证号用于毒麻交验 wyx 2015-01-29
	s getAdmData1=patID_"^"_phdicd_"^"_perold_"^"_patlocdesc_"^"_patname
	s getAdmData2=patsex_"^"_pmino
	s QueryMZYP("AdmData",adm)=getAdmData1_"^"_getAdmData2
	q QueryMZYP("AdmData",adm)
}

ClassMethod QueryMZYPFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMZYPExecute ]
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

Query QueryMZYP(CDateSt As %String, CDateEnd As %String, ctloc As %String, CIncCatID As %String, PoisonRowid) As %Query(ROWSPEC = "TPhDate:%String,TPmiNo:%String,TPatName:%String,TPatSex:%String,TPatAge:%String,TPatSN:%String,TMR:%String,TPrescNo:%String,TPhDesc:%String,TPhUom:%String,TPhQty:%String,TIncBatCode:%String,TYF:%String,TPatLoc:%String,TDoctor:%String,TFYUser:%String,TBZ:%String,TPhMoney:%String")
{
}

ClassMethod GetMZYPRow(ctloc As %String)
{
 s ll=0,t=0
 f  s t=$o(^DHCPHTMPMZYP(ctloc,t)) q:(t="")!(t=0)  d
 .s ll=t
 q ll
}

ClassMethod GetMZYPRowInf(ctloc As %String, t As %String)
{
 s ret=""
 s ret=$g(^DHCPHTMPMZYP(ctloc,t))
 q ret
}

ClassMethod GetFyry(ctloc, userid)
{
	s ret=""
	s loc=""
	s phl=""
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	s php="",getphp=""
	f  s php=$o(^DHCPHPERi("USR",userid,php)) q:php=""  d
	.s phyp=""
	.s phyp=+$p(^DHCPHPER(php),"^",3)
	.q:phyp'=phl
	.s getphp=php
	i getphp="" q ""
	s phlp=""
	f  s phlp=$o(^DHCPHPER(phlp)) q:phlp=""  d
	.s phwl="",phwdesc=""
	.s phwl=+$p(^DHCPHPER(phlp),"^",3)
	.q:phwl'=phl
	.s use=""
	.s use=$p(^DHCPHPER(phlp),"^",9)
	.q:use="1"
	.s phwdesc=$p(^DHCPHPER(phlp),"^",2)
	.i ret="" s ret=phlp_$c(1)_phwdesc
	.e  s ret=ret_"^"_phlp_$c(1)_phwdesc
	q ret
}

ClassMethod GetStkCat()
{
	s ret=""
	s stkcat="0"
	f  s stkcat=$o(^INC("SC",stkcat)) q:stkcat=""  d
	.q:stkcat="0"
	.s desc=$p(^INC("SC",stkcat),"^",2)
	.i ret="" s ret=stkcat_$c(1)_desc
	.e  s ret=ret_"^"_stkcat_$c(1)_desc
	q ret
}

ClassMethod GetPhCat()
{
	s ret=1
	s stkcat="0"
	f  s stkcat=$o(^PHCC(stkcat)) q:(stkcat="")!(stkcat="0")  d
	.s phcatdesc=""
	.q:stkcat["M"
	.q:stkcat["SC"
	.s phcatdesc=$p(^PHCC(stkcat),"^",2)
	.i ret="" s ret=stkcat_$c(1)_phcatdesc
	.e  s ret=ret_"^"_stkcat_$c(1)_phcatdesc
	q ret
}

ClassMethod GetManGroup(ctloc)
{
	s ret=""
	s mangrp="0"
	f  s mangrp=$o(^DHCLMG(0,"LOC",ctloc,mangrp)) q:(mangrp="")!(mangrp="0")  d
	.s phcatdesc=""
	.s phcatdesc=$p(^DHCLMG(mangrp),"^",3)
	.i ret="" s ret=mangrp_$c(1)_phcatdesc
	.e  s ret=ret_"^"_mangrp_$c(1)_phcatdesc
	q ret
}

ClassMethod GetWinPos()
{
    s ret=""
	set myrowid=1
    s CTCode="E"
    s CTDesc="东侧"
    s ret=CTCode_$c(1)_CTDesc
    s CTCode="W"
    s CTDesc="西侧"
    s ret=ret_"^"_CTCode_$c(1)_CTDesc
    s CTCode="O"
    s CTDesc="无位"
    s ret=ret_"^"_CTCode_$c(1)_CTDesc
 	q ret
}

ClassMethod QueryUnDispDetailClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryUnDispDetailExecute ]
{
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryUnDispDetailExecute(ByRef QHandle As %Binary, sdate As %Library.String, edate As %Library.String, OnlyDisp As %Library.String, OnlyReturn As %Library.String, ctloc) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1,st="",end=""
	i $g(ctloc)=""  Set QHandle=$lb(0,repid,0) Quit $$$OK
	i sdate="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	i edate="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	i sdate>edate  Set QHandle=$lb(0,repid,0) Quit $$$OK
	s phl="",total=0
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl=""  Set QHandle=$lb(0,repid,0) Quit $$$OK
	
	i OnlyDisp="on" s OnlyDisp=1 
    e  s OnlyDisp=0
    i OnlyReturn="on" s OnlyReturn=1 
    e  s OnlyReturn=0
	
	s pid=$I(^TMP("DHCOut","UnDisp","Detail"))
	s phddate=sdate-1
	s t=0
    f  s phddate=$o(^DHCPHUNDi(phddate)) q:phddate=""  d
    .q:OnlyReturn=1
    .q:phddate>edate
    .s total=0
    .s phdrow = ""
    .f  s phdrow=$o(^DHCPHUNDi(phddate,phl,phdrow)) q:phdrow=""  d
    ..s unpersondr=+$p(^DHCPHUND(phdrow),"^",8)
    ..s unpersonname=$p(^DHCPHINP(unpersondr),"^",2)
    ..s unpersonpmi=$p(^DHCPHINP(unpersondr),"^",9)
    ..s pydr=+$p(^DHCPHUND(phdrow),"^",10)
    ..s pyname=$p(^DHCPHPER(pydr),"^",2)
    ..s bz=$p(^DHCPHINP(unpersondr),"^",7)
    ..s pydate=$zd(phddate,3)
    ..s reason=""
    ..s reasondr=+$p(^DHCPHUND(phdrow),"^",14)
    ..i reasondr'=0 s reason=$p(^DHCPHUNDR(reasondr),"^",1)
    ..s phdi="",phdmoney=0
    ..f  s phdi=$o(^DHCPHUND(phdrow,"I",phdi)) q:phdi=""  d
    ...s money=+$p(^DHCPHUND(phdrow,"I",phdi),"^",5)
    ...s ctuomdr=+$p(^DHCPHUND(phdrow,"I",phdi),"^",1)
    ...s uom=$p(^CT("UOM",ctuomdr),"^",2)
    ...s qty=+$p(^DHCPHUND(phdrow,"I",phdi),"^",4)
    ...s inc=+$p(^DHCPHUND(phdrow,"I",phdi),"^",2)
    ...s incdesc=$p(^INCI(inc,1),"^",2)
    ...s locdesc=$p(^CTLOC(ctloc),"^",2)
    ...i $f(locdesc,"-") s locdesc=$p(locdesc,"-",2)
    ...s price=+$p(^DHCPHUND(phdrow,"I",phdi),"^",3)
  	...s total=total+money
  	...s optype="发药"
  	...s index=optype_"^"_phddate_"^"_unpersonpmi
  	...s index2=incdesc
  	...s datailinfo=unpersonname_"^"_unpersonpmi_"^"_pydate_"^"_price_"^"_pyname_"^"_phdrow_"^"_reason_"^"_bz_"^"_incdesc_"^"_uom_"^"_qty_"^"_money_"^"_optype_"^"_locdesc
  	...i '$d(^TMP("UnDispDetail",pid,index,index2)) d
  	....s ^TMP("UnDispDetail",pid,index,index2)=datailinfo
  	...e  d
  	....s $p(^TMP("UnDispDetail",pid,index,index2),"^",12)=$p(^TMP("UnDispDetail",pid,index,index2),"^",12)+money
  	....s $p(^TMP("UnDispDetail",pid,index,index2),"^",11)=$p(^TMP("UnDispDetail",pid,index,index2),"^",11)+qty
  	...
  	s phddate=sdate-1
    s t=0
    f  s phddate=$o(^DHCPHUNRi(phddate)) q:phddate=""  d
    .q:OnlyDisp=1
    .q:phddate>edate
    .s phdrow = ""
    .f  s phdrow=$o(^DHCPHUNRi(phddate,phl,phdrow)) q:phdrow=""  d
    ..s pydate=phddate
    ..s pydate=$zd(pydate,3)
    ..s unpersondr=+$p(^DHCPHUNR(phdrow),"^",9)
    ..s unpersonname=$p(^DHCPHINP(unpersondr),"^",2)
    ..s unpersonpmi=$p(^DHCPHINP(unpersondr),"^",9)
    ..s pydr=+$p(^DHCPHUNR(phdrow),"^",11)
    ..s reason=""
    ..s reasondr=+$p(^DHCPHUNR(phdrow),"^",14)
    ..i reasondr'=0 s reason=$p(^DHCPHUNDR(reasondr),"^",1)
    ..s pyname=$p(^DHCPHPER(pydr),"^",2)
    ..s bz=""
    ..s bz=$p(^DHCPHINP(unpersondr),"^",7)
    ..s phdi=""
    ..f  s phdi=$o(^DHCPHUNRI(phdrow,"I",phdi)) q:phdi=""  d
    ...s money=0,qty=0,ctuom="",price=0,inc=""
    ...s money=+$p(^DHCPHUNRI(phdrow,"I",phdi),"^",5)
    ...s money=-money
    ...s ctuomdr=+$p(^DHCPHUNRI(phdrow,"I",phdi),"^",1)
    ...s uom=$p(^CT("UOM",ctuomdr),"^",2)
    ...s qty=+$p(^DHCPHUNRI(phdrow,"I",phdi),"^",4)
    ...s qty=-qty
    ...s inc=+$p(^DHCPHUNRI(phdrow,"I",phdi),"^",2)
    ...s price=+$p(^DHCPHUNRI(phdrow,"I",phdi),"^",3)
    ...s incdesc=$p(^INCI(inc,1),"^",2)
  	...s total=total+money
    ...s optype="退药"
    ...s locdesc=$p(^CTLOC(ctloc),"^",2)
    ...i $f(locdesc,"-") s locdesc=$p(locdesc,"-",2)
  	...s index=optype_"^"_phddate_"^"_unpersonpmi
  	...s index2=incdesc
  	...s datailinfo=unpersonname_"^"_unpersonpmi_"^"_pydate_"^"_price_"^"_pyname_"^"_phdrow_"^"_reason_"^"_bz_"^"_incdesc_"^"_uom_"^"_qty_"^"_money_"^"_optype_"^"_locdesc
  	...i '$d(^TMP("UnDispDetail",pid,index,index2)) d
  	....s ^TMP("UnDispDetail",pid,index,index2)=datailinfo
  	...e  d
  	....s $p(^TMP("UnDispDetail",pid,index,index2),"^",12)=$p(^TMP("UnDispDetail",pid,index,index2),"^",12)+money
  	....s $p(^TMP("UnDispDetail",pid,index,index2),"^",11)=$p(^TMP("UnDispDetail",pid,index,index2),"^",11)+qty
  	...
  	s i=0
  	s total=0
    s index=""
    f  s index=$o(^TMP("UnDispDetail",pid,index)) q:index=""  d
    .s sum=0
    .s h=0
    .s index2=""
    .f  s index2=$o(^TMP("UnDispDetail",pid,index,index2)) q:index2=""  d
    ..s info=^TMP("UnDispDetail",pid,index,index2)
    ..s i=i+1
    ..s h=h+1
    ..s sum=sum+$p(info,"^",12)
    ..s total=total+$p(info,"^",12)
    ..s ^TMP("UnDispDetailString",pid,i)=h_"^"_info
    .s i=i+1
    .s info="小计^^^^^^^^^^^"_sum_"^"_""
    .s ^TMP("UnDispDetailString",pid,i)=""_"^"_info 
    s i=i+1
    s info="^合计^^^^^^^^^^^"_total_"^"_""
    s ^TMP("UnDispDetailString",pid,i)=info
    k ^TMP("UnDispDetail",pid)
    
    s num=""
    f  s num=$o(^TMP("UnDispDetailString",pid,num)) q:num=""  d
    .s info=^TMP("UnDispDetailString",pid,num)
  	.s no=$p(info,"^",1)
  	.s name=$p(info,"^",2)
  	.s patno=$p(info,"^",3)
  	.s pydate=$p(info,"^",4)
  	.s price=$p(info,"^",5)
  	.s pyname=$p(info,"^",6)
  	.s phdrow=$p(info,"^",7)
  	.s reason=$p(info,"^",8)
  	.s bz=$p(info,"^",9)
  	.s incidesc=$p(info,"^",10)
  	.s uom=$p(info,"^",11)
  	.s qty=$p(info,"^",12)
  	.s money=$p(info,"^",13) 
  	.s optype=$p(info,"^",14)
  	.s loc=$p(info,"^",15)
  	.set Data=$lb(no,name,patno,pydate,price,pyname,phdrow,reason,bz,incidesc,uom,qty,money,optype,pid,loc)
 	.Set ^CacheTemp(repid,ind)=Data	
 	.Set ind=ind+1
 	
    Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryUnDispDetailFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUnDispDetailExecute ]
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

Query QueryUnDispDetail(sdate As %Library.String, edate As %Library.String, OnlyDisp As %Library.String, OnlyReturn As %Library.String, ctloc) As %Query(ROWSPEC = "TNo:%String,TPerName:%String,TPmiNo:%String,TPrtDate:%String,TPrice:%String,TPyName:%String,TPhd:%String,TReasDesc:%String,TNote:%String,Tinc:%String,Tuom:%String,Tqty:%String,Tmoney:%String,Toptype:%String,Tpid:%String,Tloc:%String") [ SqlProc ]
{
}

ClassMethod GetDetailNum(pid) As %String
{
    q $o(^TMP("UnDispDetailString",pid,""),-1)
}

ClassMethod ListDetail(pid, num) As %String
{
    q ^TMP("UnDispDetailString",pid,num)
}

ClassMethod KillDetail(pid) As %String
{
    i $D(^TMP("UnDispDetailString",pid)) k ^TMP("UnDispDetailString",pid)
}

ClassMethod QueryLocPrintPrescClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocPrintPrescExecute ]
{
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryLocPrintPrescExecute(ByRef QHandle As %Binary, CDateSt As %Library.String = "", CDateEnd As %Library.String = "", ctloc As %Library.String = "", CPmiNo As %Library.String = "", sttime As %Library.String = "", endtime As %Library.String = "", CAdmLoc As %Library.String = "", CPrescType As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1,st="",end=""
	i $g(ctloc)=""  Set QHandle=$lb(0,repid,0) Quit $$$OK
    s CDateSt=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateSt)
	s CDateEnd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateEnd)
	s sttime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(sttime)
	s endtime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(endtime)
	s st=CDateSt
	s CurrIP=%session.Get("REMOTE_ADDR")
	k ^DHCTMPLocPrescPrint(CurrIP)
	s end=CDateEnd
	i CDateSt="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	i CDateEnd="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	i st>end  Set QHandle=$lb(0,repid,0) Quit $$$OK
	s pmino=CPmiNo
	
	s phmoney=0,phcount=0
	s phl="",lm=0

	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl=""  Set QHandle=$lb(0,repid,0) Quit $$$OK
 
 	s cyflag="",dfflag="" 
	s cyflag=$p(^DHCPHLOC(phl),"^",6)

	s phddate = "", t = 0
	f phddate=st:1:end  d
	.s phdrow = ""
	.f  s phdrow=$o(^DHCPHDISPi("FYDATE",phddate,phl,phdrow)) q:phdrow=""  d
	..s ppyflag="",pfyflag="",pydr1="",fydr1="",prt="",inv="",pydate="",use="",perno="",pname=""
	..s ppyflag=$p(^DHCPHDISP(phdrow,1),"^",6)
	..s pfyflag=$p(^DHCPHDISP(phdrow),"^",4)
	..q:(pfyflag'="1")
	..s pydate=phddate
	..s pydate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(pydate)
	..s pydr1=+$p(^DHCPHDISP(phdrow,1),"^",3)
	..s fydr1=+$p(^DHCPHDISP(phdrow,1),"^",2)
	..s lsh=0
	..s lsh=$p(^DHCPHDISP(phdrow,1),"^",8)
	..s prescno=""
	..s prescno=$p(^DHCPHDISP(phdrow,2),"^",1)
	..s patadm=##class(web.DHCOutPhDisp).getadm(prescno)
	..s patloc=+$p(^PAADM(patadm),"^",4)
	..q:(patloc'=CAdmLoc)&(CAdmLoc'="")
	..s patlocdesc=$p(^CTLOC(patloc),"^",2)
	..i patlocdesc["-" s patlocdesc=$p(patlocdesc,"-",2)
	..s warddesc=""
	..s currwarddr=$p(^PAADM(patadm),"^",70)
	..i currwarddr'="" d
	...s ctlocdr=$p(^PAWARD(currwarddr),"^",5)
	...s warddesc=$p(^CTLOC(ctlocdr),"^",2)
	...i warddesc["-" s warddesc=$p(warddesc,"-",2)
	...s patlocdesc=patlocdesc_"["_warddesc_"]"
	..s presctypedesc=""
	..s presctypedesc=##class(web.DHCOutPhTQDisp).GetPrescTitle(prescno)
	..q:(presctypedesc'="普通")&&(CPrescType="1")
	..q:(presctypedesc'="急诊")&&(CPrescType="2")
	..q:(presctypedesc'="儿科")&&(CPrescType="3")
	..q:(presctypedesc'="毒麻、精一")&&(CPrescType="4")
	..q:(presctypedesc'="精二")&&(CPrescType="5")
	..s pytime=""
	..s phw="",windesc=""
	..s phw=+$p(^DHCPHDISP(phdrow,1),"^",4)
	..i phw'=0 s windesc=$p(^DHCPHWIN(phw),"^",1)
	..s fytime=""
	..i pfyflag="1" s fytime=+$p(^DHCPHDISP(phdrow),"^",5)
	..s pytime=+$p(^DHCPHDISP(phdrow,1),"^",7)
	..q:(sttime'="")&(phddate=st)&(fytime<sttime)
	..q:(sttime'="")&(phddate=end)&(fytime>endtime)
	..i fytime'=0 s fytime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(fytime)
	..s pmi=""
	..s pmi=+$p(^DHCPHDISP(phdrow),"^",7)
	..s perno=$p(^PAPER(pmi,"PAT",1),"^",2)
	..q:(perno'=CPmiNo)&(CPmiNo'="")
	..s pname=$p(^PAPER(pmi,"ALL"),"^",1)
	..s pyname="",fyname=""
	..i $d(^DHCPHPER(pydr1))  s pyname=$p(^DHCPHPER(pydr1),"^",2)
	..i $d(^DHCPHPER(fydr1))  s fyname=$p(^DHCPHPER(fydr1),"^",2)
	..s prt=""
	..s inv="",prtflag="",prttime="",prtdate="",phadate=""
	..s prtInfoStr=##class(web.DHCOutPhCommon).GetHandTime(prescno)
	..s prtdate=$p(prtInfoStr,"^",2) 
	..s prttime=$p(prtInfoStr,"^",3) 
	..s prt=$p(prtInfoStr,"^",4) 
	..s inv=$p(prtInfoStr,"^",5)
	..s phdi="",phdmoney=0
	..s adm="",mricd=""
	..s mricdstr=##class(web.DHCOutPhCommon).GetMRDiagnosDesc(patadm,",")
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
	...i $d(^DHCPHDI(phdrow,"PHDI",phdi,"INCLB")) d
	....s phdclb=0
	....f  s phdclb=$o(^DHCPHDI(phdrow,"PHDI",phdi,"INCLB",phdclb)) q:phdclb=""  d
	.....s money=$p(^DHCPHDI(phdrow,"PHDI",phdi,"INCLB",phdclb),"^",8)
	.....s phdmoney=phdmoney+money
	...e  d
	....s MoneyStr=##class(web.DHCOutPhCommon).GetOrdItmMoney(orditm)
	....s money=$p(MoneyStr,"^",2)
	....s phdmoney=phdmoney+money
	..s phmoney=phmoney+phdmoney
	..s phcount=phcount+1
	..s lm=lm+1
	..
	..s EncryptLevelInfo=""
	..s EncryptLevel=""
	..s PatLevel=""
	..s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
	..i EncryptFlag=1 d
	...s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(pmi,"")
	...s EncryptLevel=$p(EncryptLevelInfo,"^",1)
	...s PatLevel=$p(EncryptLevelInfo,"^",2)
	..i lm=1 d
	...s ^DHCTMPLocPrescPrint(CurrIP,0)="姓名"_"^"_"登记号"_"^"_"发药日期"_"^"_"药费"_"^"_"配药人"_"^"_"发药人"_"^"_"收据号"_"^"_"处方号"_"^"_"处方类型"_"^"_"收费时间"_"^"_"发药时间"_"^"_"窗口"_"^"_"科室"_"^"_"收费日期"_"^"_"流水号"_"^"_"诊断"_"^"_"phdrow"_"^"_"病人密级"_"^"_"病人级别"  //修改此处时需要修改对应js导出功能的列数
	..s ^DHCTMPLocPrescPrint(CurrIP,lm)=pname_"^"_perno_"^"_pydate_"^"_phdmoney_"^"_pyname_"^"_fyname_"^"_inv_"^"_prescno_"^"_presctypedesc_"^"_prttime_"^"_fytime_"^"_windesc_"^"_patlocdesc_"^"_##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(phadate)_"^"_lsh_"^"_mricdstr_"^"_phdrow_"^"_EncryptLevel_"^"_PatLevel  
	..set Data=$lb(pname,perno,pydate,phdmoney,pyname,fyname,inv,phdrow,prescno,presctypedesc,prttime,durfact,adm,mricd,fytime,windesc,prtdate,patlocdesc,lsh,mricdstr,EncryptLevel,PatLevel)
	..Set ^CacheTemp(repid,ind)=Data	
	..Set ind=ind+1
    set Data=$lb("合计",phcount_"条","",phmoney,"","","","","","","","","","")
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
    Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryLocPrintPrescFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocPrintPrescExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" { Set AtEnd=1
  Set Row="" }
 Else      { Set Row=^CacheTemp(repid,ind) }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryLocPrintPresc(CDateSt As %String, CDateEnd As %String, ctloc As %String, CPmiNo As %String, sttime As %String, endtime As %String, CAdmLoc As %String, CPrescType As %String) As %Query(ROWSPEC = "TPerName:%String,TPmiNo:%String,TPrtDate:%String,TPhMoney:%String,TPyName:%String,TFyName:%String,TPrtInv:%String,tphd:%String,TPrescNo:%String,TPrescType:%String,TPrtTime:%String,TJS:%String,TAdm:%String,TMR:%String,TDispTime:%String,TDispWinDesc:%String,prtdate:%String,patlocdesc:%String,TLSH:%String,TDignose:%String,TEncryptLevel,TPatLevel") [ SqlProc ]
{
}

ClassMethod GetLocPrintPrescNum()
{
	s ip=%session.Get("REMOTE_ADDR")
	s retNum=0
	s retNum=$o(^DHCTMPLocPrescPrint(ip,""),-1)
	q retNum
}

ClassMethod GetLocPrintPrescVal(row)
{
	s ip=%session.Get("REMOTE_ADDR")
	s retval=""
	s retval=$g(^DHCTMPLocPrescPrint(ip,row))
	q retval
}

ClassMethod GetPrescOrd(phdrow)
{
	s seqind=1
	
		s prt=""
	  s prt=+$p(^DHCPHDISP(phdrow),"^",2)
	 s phdi = "", m = 0,retval="",phl=+$p(^DHCPHDISP(phdrow,1),"^",1)
	 s ctloc=+$p(^DHCPHLOC(phl),"^",1)
    f  s phdi=$o(^DHCPHDI(phdrow,"PHDI",phdi)) q:phdi=""  d
      .s orditm = ""
      .s orditm=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",5)
      .s ord = "", ordi = ""
      .s ord=$p(orditm,"||",1)
      .s ordi=$p(orditm,"||",2)
      
      .s itmmast = ""
      .s itmmast=$p(^OEORD(ord,"I",ordi,1),"^",2)      ;arc_itmmast
      .s priority = ""
      .s dispqty = "",retqty=0
      .s dispqty=+$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",4)      ;药品数量
      .s retqty=+$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",6)
      .s price = 0, totprice = 0
      .s totprice=+$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",3)
      .q:totprice=""
      .s price=##class(web.DHCOutPhDisp).GetBasPrice(prt, orditm)
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
      .s genric=""
	  .s genric=$p(^ARCIM(itmmastid,itmmastver,8),"^",20)
	  .s incTYdesc=""
	  .i genric'="" s incTYdesc=$p(^PHCGE("GE",genric),"^",2)
      .i incTYdesc["-" s incTYdesc=$p(incTYdesc,"-",2)

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
      .s phgg=""
      .s phgg=##class(web.DHCOutPhDisp).GetPhgg(inci) 
	  
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
      .;s oeseqno=$p(^OEORD(ord,"I",ordi,3),"^",4)      ;医嘱序号
      .s orditem=ord_"||"_ordi
      .s ^TMP("SEQNUM",orditem)=seqind
      .S mainoeori=##class(web.DHCSTPIVA).GetMainOeori(orditem)
      .i '$d(^TMP("SEQPOINT",mainoeori)) d
      ..s ^TMP("SEQPOINT",orditem)=0
      .i mainoeori'=orditem d
      ..s ^TMP("SEQPOINT",mainoeori)=^TMP("SEQPOINT",mainoeori)+1
      ..s oeseqno=^TMP("SEQNUM",mainoeori)_"."_^TMP("SEQPOINT",mainoeori)
      .e  d
      ..s oeseqno=seqind
      ..s seqind=seqind+1
      .s incTYdesc=oeseqno_"&"_incTYdesc
	  .s pc=""
	  .s pc=doseqty_unitdesc
	  .s ret=""
	  .s ret=orditem_"^"_incTYdesc_"^"_basuomdesc_"^"_price_"^"_dispqty_"^"_totprice_"^"_oeflag_"^"_pc_"^"_phfragdesc_"^"_instrdesc_"^"_duratdesc_"^"_username_"^"_yppc_"^"_yphw_"^"_newretqty_"^"_phgg
      .i retval="" s retval=ret
      .e  s retval=retval_$c(1)_ret
   
     
    k ^TMP("SEQNUM")
	k ^TMP("SEQPOINT")   
 q retval
}

ClassMethod GetWinFrLoc(ctloc)
{
	s phl="",ret=""
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl="" q ""
	s phw=""
	f  s phw=$o(^DHCPHWINi(phl,phw)) q:phw=""  d
	  .s windesc=""
	  .s windesc=$p(^DHCPHWIN(phw),"^",1)
	  .i ret=""  s ret=phw_$C(1)_windesc
	  .e  s ret=ret_"^"_phw_$C(1)_windesc
  q ret
}

ClassMethod GetPrescTypeCMB()
{
	;1--普通，2--急诊，3--儿科，4--毒麻、精一，5--精二
	s ret=""
	s ret="1"_$c(1)_"普通"_"^"_"2"_$c(1)_"急诊"_"^"_"3"_$c(1)_"儿科"_"^"_"4"_$c(1)_"毒麻、精一"_"^"_"5"_$c(1)_"精二"
	
  q ret
}

/// 处方存在发药记录，看每个医嘱是否存在，不存在则为欠药
/// 1 - 非欠药  0 - 欠药
ClassMethod GetChkPhdFlag(phdrow, oeori) As %String
{
 
   q:phdrow="" 1
   s ord=+oeori
   s itm=$p(oeori,"||",2)
   s prescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
   s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))  
   s dspqty=$p(^DHCOEDISQTY(dsp),"^",5)
   s chkflag=0
   s phdi=""
   f  s phdi=$o(^DHCPHDI(phdrow,"PHDI",phdi)) q:(phdi="")!(chkflag'=0)  d
   .s phoeori=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",5)
   .i phoeori=oeori d
   ..s chkflag=1
   .
   q chkflag
}

/// 处方某医嘱发药数量入库单位
ClassMethod GetRealPhQty(phdrow, oeori) As %String
{
   
   q:phdrow="" 0
   s ord=+oeori
   s itm=$p(oeori,"||",2)
   s prescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
   s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))  
   s dspqty=$p(^DHCOEDISQTY(dsp),"^",5)
   s phqty=0
   s phdi=""
   f  s phdi=$o(^DHCPHDI(phdrow,"PHDI",phdi)) q:(phdi="")!(phqty'=0)  d
   .s phoeori=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",5)
   .i phoeori=oeori d
   ..s phqty=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",4)
   .
   s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)  
   s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
   //s puruom=+$p(^INCI(inci,3),"^",6)
   s puruom=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),8),"^",14)
   s buomdr=$p(^INCI(inci,1),"^",10)
   s confac=##class(web.DHCSTCOMMONSRV).UOMFac(puruom,buomdr)
   s dispqty=phqty
   s getnum=$p((dispqty/confac),".",1)
   i getnum="" s getnum=0
   s dispuomdr=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)
   
   i (dispuomdr'="")&(dispuomdr'=puruom)&(dispuomdr'=buomdr)  d
   .s Fac=##class(web.DHCSTCOMMONSRV).UOMFac(dispuomdr,buomdr)
   .s phqty=dispqty/Fac
   e  d
   .i getnum=(dispqty/confac)  d
   ..s phqty=phqty/confac
   .e  d
   ..s phqty=dispqty
   ;add by xiaohe 20140609 发药单位  实发数量转换
   //i getnum=(dispqty/confac)  d
   //.s phqty=phqty/confac
   //e  d
   //.s phqty=dispqty

   q phqty
}

/// 处方某医嘱发药数量基本单位
ClassMethod GetRealPhQtyBuom(phdrow, oeori) As %String
{

   q:phdrow="" 0
   s ord=+oeori
   s itm=$p(oeori,"||",2)
   s prescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
   s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))  
   s dspqty=$p(^DHCOEDISQTY(dsp),"^",5)
   s phqty=0
   s phdi=""
   f  s phdi=$o(^DHCPHDI(phdrow,"PHDI",phdi)) q:(phdi="")!(phqty'=0)  d
   .s phoeori=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",5)
   .i phoeori=oeori d
   ..s phqty=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",4)
   .
   q phqty
}

/// 获取某打包子表记录在发药孙表中的实际发药数量
/// w ##class(web.DHCOutPhRetrieve).GetRealPhQtyByDspBat("2292285","10398031||1")
ClassMethod GetRealPhQtyByDspBat(phdrow, DspBatchId) As %String
{
	q:(phdrow="")&&(DspBatchId="") 0
	s sumphqty=0,sumphretqty=0
	s phdi=""
	f  s phdi=$o(^DHCPHDIi("DSPB",DspBatchId,phdrow,phdi)) q:phdi=""  d
	.s phdsub=""
	.f  s phdsub=$o(^DHCPHDIi("DSPB",DspBatchId,phdrow,phdi,phdsub))  q:phdsub=""  d
	..s phqty=+$p(^DHCPHDI(phdrow,"PHDI",phdi,"INCLB",phdsub),"^",1)
	..s sumphqty=sumphqty+phqty
	..s phretqty=+$p(^DHCPHDI(phdrow,"PHDI",phdi,"INCLB",phdsub),"^",2)
	..s sumphretqty=sumphretqty+phretqty
	q sumphqty_"^"_sumphretqty
}

ClassMethod GetPhdItmData(phd, oeori, fac)
{
	s ret="",retqty="",batno=""
	q:phd="" retqty_"^"_batno
	s phdi=""
	s batno=""	
    f  s phdi=$o(^DHCPHDI(phd,"PHDI",phdi)) q:phdi=""  d
      .s orditm = ""
      .s orditm=$p(^DHCPHDI(phd,"PHDI",phdi),"^",5)
      .q:orditm'=oeori
      .s ord = "", ordi = ""
      .s ord=$p(orditm,"||",1)
      .s ordi=$p(orditm,"||",2)
      .s itmmast = ""
      .s itmmast=$p(^OEORD(ord,"I",ordi,1),"^",2)      ;arc_itmmast
      .s priority = ""
      .s dispqty = "",retqty=0
      .s dispqty=+$p(^DHCPHDI(phd,"PHDI",phdi),"^",4)      ;药品数量
      .s retqty=+$p(^DHCPHDI(phd,"PHDI",phdi),"^",6)
      .s retqty=retqty/fac
      .s sub=""
      .f  s sub=$o(^DHCPHDI(phd,"PHDI",phdi,"INCLB",sub)) q:sub=""  d
      ..s inclb=$p(^DHCPHDI(phd,"PHDI",phdi,"INCLB",sub),"^",3)
      ..s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
      ..i batno="" s batno=$p(^INCI($p(incib,"||",1),"IB",$p(incib,"||",2)),"^",1)
      ..e  s batno=batno_";"_$p(^INCI($p(incib,"||",1),"IB",$p(incib,"||",2)),"^",1)
      ..
      s ret=retqty_"^"_batno
      q ret
}

/// ADD wyx 当有润乾调用时使用此方法，防止与润乾冲突
/// w ##class(web.DHCOutPhRetrieve).GetMRDiagnosDesc(494,",")
ClassMethod GetMRDiagnosDesc(MRAdmRowid As %String, DelimStr As %String) As %String
{
 n (MRAdmRowid,DelimStr)
 q:MRAdmRowid="" ""
 s MRAdmRowid=$p(^PAADM(MRAdmRowid),"^",61)
 q:MRAdmRowid="" ""
 s retval=""
 s i=0
 s sub=0
 f  s sub=$o(^MR(MRAdmRowid,"DIA",sub)) q:sub=""  d
 .s CodeDr=$p(^MR(MRAdmRowid,"DIA",sub),"^",1)
 .s Desc=""
 .s:CodeDr'="" Desc=$p(^MRC("ID",CodeDr),"^",2)
 .s Rowid=MRAdmRowid_"||"_sub
 .s MRDesc=$g(^MR(MRAdmRowid,"DIA",sub,"DES",1))
 .//if MRDesc'="" s MRDesc=$LIST(MRDesc,1)
 .i Desc="" s Desc=MRDesc
 .e  d
 ..i MRDesc'="" s Desc=Desc_"("_MRDesc_")"
 .s i=i+1
 .s Desc=Desc
 .if retval="" s retval=Desc
 .e  s retval=retval_DelimStr_Desc
 q $ZCVT($g(retval),"O","JS")
}

}
