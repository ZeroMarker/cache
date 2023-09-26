Import SQLUser

/// created by jdl
Class web.DHCPE.InvPrt Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod YesNoAllList(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=Y>是</option>"
	w "<option value=N>否</option>"
	w "</select>",!
}

Query FindInvPrtList(InvNo As %Library.String = "", PatName As %Library.String = "", RegNo As %Library.String = "", User As %Library.String = "", BeginDate As %Library.String = "", EndDate As %Library.String = "", RPFlag As %Library.String = "", isApply As %Library.String = "", SelfOnlyFlag As %Library.String = "", EntryLoc As %Library.String = "", FocusPrint As %String = "", CardNo As %String = "", InvStatus As %String = "", InvPayMode As %String = "", CashierStat As %String = "", LocID As %String = "", GroupID As %String = "") As %Query(ROWSPEC = "RecordSum:%String,TRowId:%String,TInvNo:%String,TPatName:%String,TRegNo:%String,TAmount:%String,TFlag:%String,TUser:%String,TInvDate:%String,TRPFlag:%String,TRPDate:%String,TSex:%String,TAge:%String,TDropDate:%String,TAdmType:%String,TGIAdm:%String,TAccountAmount:%String,TRInvNo:%String,TPayMode:%String,TRoundInfo:%String,TInvName:%String,Tsswr:%String,TPosition:%String,TOPInfo:%String,namestr:%String,TApplyUser,TPrintEInv,TEInvNo")
{
}

/// isApply(0:退费申请 1：退费 2:发票重打)
/// d ##class(%ResultSet).RunQuery("web.DHCPE.InvPrt","FindInvPrtList","","","","体检01","2020-02-01","2020-02-19","","","","","","","","","TE")
ClassMethod FindInvPrtListExecute(ByRef qHandle As %Binary, InvNo As %Library.String = "", PatName As %Library.String = "", RegNo As %Library.String = "", User As %Library.String = "", BeginDate As %Library.String = "", EndDate As %Library.String = "", RPFlag As %Library.String = "", isApply As %Library.String = "", SelfOnlyFlag As %Library.String = "", EntryLoc As %Library.String = "", FocusPrint As %String = "", CardNo As %String = "", InvStatus As %String = "", InvPayMode As %String = "", CashierStat As %String = "", LocID As %String = "", GroupID As %String = "") As %Status
{
	new TRowId,TInvNo,TPatName,TRegNo,TAmount,TFlag,TUser,TInvDate,TRPFlag,TRPDate,TSex,TAge,TDropDate
	new paadm,admtype,patid,dob,giadmid
	new errs,i,hasdata
	Set repid=$I(^CacheTemp)
	s ^tmpdhcpe("FindInvPrtList")=$lb(InvNo ,PatName,RegNo,User,BeginDate,EndDate,RPFlag,isApply,SelfOnlyFlag,EntryLoc,FocusPrint,CardNo,InvStatus,InvPayMode,CashierStat,LocID,GroupID)
	Set qHandle=$lb(0,repid,0)
	if ((""=RegNo)&(""=PatName)&(""=InvNo)&(""=User)&(""=BeginDate)&(""=EndDate)&(""=RPFlag)&(""=CardNo)&(""=GroupID)) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	i BeginDate'=""  s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
	i EndDate'=""    s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
 	s PatName=##class(web.DHCPE.DHCPECommon).UnEscape(PatName)
 	i $g(UserDR)="" s UserDR=%session.Get("LOGON.USERID")
 	
 	s ind=2
 	s FactAmount=0
	s AccountAmount=0
	s RoundFee=0
	s sswrAmount=0
	s errs=""
 	s i=1
 	
 	i PatName'="" s PatNameU=$$ALPHAUP^SSUTIL4(PatName)
   
 	i InvNo'=""  
 	{
 		s TRowId=$o(^DHCPEINVPRT(0,"INV",InvNo,""))
 		if TRowId'=""  d
 		.d ClearInvPrt
 		.d GetInvPrt
 		.q:hasdata'=1
 		.d OutInvPrt
 		e  d
 		.s RFocusPrintID=$o(^User.DHCPEINVFocusPrtI("IFPINVNoIndex"," "_InvNo,""))
		.i RFocusPrintID'="" d
		..s TRowId=$LG(^User.DHCPEINVFocusPrtD(RFocusPrintID),2)
		..d ClearInvPrt
 		..d GetInvPrt
 		..q:hasdata'=1
 		..d OutInvPrt

 	} 	
	elseif RegNo'=""
	{
		new regno,patid,admid
		s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo,LocID)
		s regno=$ZCVT(RegNo,"U")
	 	s regno=$o(^PAPERi("PAPMI_PatNo",regno),-1)
	 	f  s regno=$o(^PAPERi("PAPMI_PatNo",regno)) q:((regno="")||(regno'[$ZCVT(RegNo,"U")))  d
	 	.s patid=""
	 	.f  s patid=$o(^PAPERi("PAPMI_PatNo",regno,patid)) q:((patid=""))  d
	 	..s admid=""
	 	..f  s admid=$o(^PAPERdr(patid,"ADM","H",admid)) q:((admid=""))  d
	 	...s TRowId=""
	 	...f  s TRowId=$o(^DHCPEINVPRT(0,"ADM",admid,TRowId)) q:((TRowId=""))  d
	 	....d ClearInvPrt
	 	....d GetInvPrt
	 	....q:hasdata'=1
	 	....d OutInvPrt
	}
	elseif PatName'=""
 	{   
	 	new patname,patid,admid
	 	
	 	s patname=$o(^PAPERi("PAPER_PatName",PatNameU),-1)
	 	f  s patname=$o(^PAPERi("PAPER_PatName",patname)) q:((patname="")||(patname'[PatNameU))  d
	 	.s patid=""
	 	.f  s patid=$o(^PAPERi("PAPER_PatName",patname,patid)) q:((patid=""))  d
	 	..s admid=""
	 	..f  s admid=$o(^PAPERdr(patid,"ADM","H",admid)) q:((admid=""))  d
	 	...s TRowId=""
	 	...f  s TRowId=$o(^DHCPEINVPRT(0,"ADM",admid,TRowId)) q:((TRowId=""))  d
	 	....d ClearInvPrt
	 	....d GetInvPrt
	 	....q:hasdata'=1
	 	....d OutInvPrt 	
	}
	else
	{   
	
		if EndDate="" s EndDate=+$h
		if BeginDate="" s BeginDate=+$H+30
		;s BeginDate=BeginDate-1
		s EndDate=EndDate+1
		s TRowId=""
		f  s EndDate=$o(^DHCPEINVPRT(0,"DATE",EndDate),-1) q:((EndDate="")||(EndDate<BeginDate))  d
	 	.f  s TRowId=$o(^DHCPEINVPRT(0,"DATE",EndDate,TRowId),-1) q:((TRowId=""))  d
	 	..d ClearInvPrt
	 	..d GetInvPrt
	 	..q:hasdata'=1
	 	..d OutInvPrt
	}	
 	
 	s ind=1 
	d ClearInvPrt
	s TRowId=""
	S TInvNo="合计"
	s TAmount=FactAmount
	s TAccountAmount=AccountAmount
	;s RoundInfo=$j(RoundFee,3,2)
	s RoundInfoFee=$j(RoundFee,3,2)
	s sswr=sswrAmount
	d OutInvPrt 

 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetInvPrt

	q:TRowId=""
	s InvData=$g(^DHCPEINVPRT(TRowId))
	s InvName=$G(^DHCPEDataEx("InvName",TRowId))
	
	;q:$p(InvData,"^",9)'=""   ///为作废发票不显示
	s hasDrop=$o(^DHCPEINVPRT(0,"REF",TRowId,""))
	q:(FocusPrint="1")&&(hasDrop'="")
	s paadm=$p(InvData,"^",2)
	
	s IsFeeLocFlag=$g(^DHCPESetting("DHCPE","IsFeeLocFlag",LocID)) //是否按科室计费
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",paadm,LocID,IsFeeLocFlag)
  	;q:(LocFlag=1)&&(EntryLoc'="0") 
  	q:LocFlag=1  

	s patid=$p($g(^PAADM(paadm)),"^",1)
	s PreGBID=""
	if patid="" q
	s giadmid=$o(^DHCPEIADM(0,"PAADM",paadm,""))
	i giadmid'=""  d
	.s admtype="I"
	e  d
	.s admtype="G"
	.s giadmid=$o(^DHCPEGADM(0,"DelegateADM",paadm,""))
	.S CRMGADM=$p($g(^DHCPEGADM(giadmid)),"^",2)
	.s PreGBID=$P($g(^DHCPEPreGADM(CRMGADM)),"^",1)
	q:(GroupID'="")&&(PreGBID'=GroupID)
	
	s TPatName=$p($g(^PAPER(patid,"ALL")),"^",1)
	s namestr=""
	i $d(^DHCPEINVPRT(TRowId,"MultipleADM")) d
	.s TPatName=TPatName_"<font color=red>(多)</font>"
	.s admstr=$g(^DHCPEINVPRT(TRowId,"MultipleADM"))
	.for loop=1:1:$l(admstr,",") d
	..s admloop=$p(admstr,",",loop)
	..i admtype="I" d
	...s paadmloop=$p($g(^DHCPEIADM(admloop)),"^",1)
	...s patidloop=$p($g(^PAADM(paadmloop)),"^",1)
	...s nameloop=$p($g(^PAPER(patidloop,"ALL")),"^",1)
	...i namestr="" s namestr=nameloop
	...e  s namestr=namestr_","_nameloop
	..i admtype="G" d
	...s paadmloop=$p($g(^DHCPEGADM(admloop)),"^",3)
	...s patidloop=$p($g(^PAADM(paadmloop)),"^",1)
	...s nameloop=$p($g(^PAPER(patidloop,"ALL")),"^",1)
	...i namestr="" s namestr=nameloop
	...e  s namestr=namestr_","_nameloop
	
	//s:InvName'="" TPatName=TPatName_"("_InvName_")"
	s TRegNo=$p($g(^PAPER(patid,"PAT",1)),"^",1)
	;q:(PatNameU'="")&&($ZCVT(TPatName,"U")'[PatNameU)
	q:TRegNo'[RegNo
	s TAge=""
	s TSex=""
	if admtype="I"
	{
		s TSex=$p($g(^PAPER(patid,"ALL")),"^",7)
		if TSex'="" s TSex=$p($g(^CT("SEX",TSex)),"^",2)
		s dob=$p($g(^PAPER(patid,"ALL")),"^",6)
		if dob'=""
		{	s dob=$zd(dob,3)
		    s TAge=##class(web.DHCBillInterface).GetPapmiAge(patid,paadm)
			//s TAge=$p($zd(+$h,3),"-",1)-$p(dob,"-",1)
		}
	}
	s TInvNo=$p(InvData,"^",1)
	
	s TOPInfo=""  ;异常操作信息
	s CurUser=%session.Get("LOGON.USERID")
	
	s TFlag=$p(InvData,"^",8)
	s TFlag=..ParseInvFlag(TFlag)
	
	q:(TInvNo'=("DHCPEYJS"_CurUser))&&(CashierStat="SE") //非预结算 //退费重收的发票
	i CashierStat="SE" s TOPInfo="SE^"_TRowId
	s isTE=##class(web.DHCPE.CashierEx).IsRefundException(TRowId)
	q:(isTE="")&&(CashierStat="TE")
	i CashierStat="TE" s TOPInfo="TE^"_isTE
	i TInvNo["DHCPEYJS" s TFlag="收费异常"
	i isTE'="" s TFlag="退费异常"
    
	q:(CashierStat="SE")&&(TInvNo'=("DHCPEYJS"_CurUser))
	q:(CashierStat="TE")&&(isTE="")
    q:(CashierStat="ALL")&&(TFlag'["异常") 
	i (CashierStat="ALL")&&(isTE'="") s TOPInfo="TE^"_isTE
	i (CashierStat="ALL")&&(isTE="")&&(TInvNo["DHCPEYJS") s TOPInfo="SE^"_TRowId

	
	/*
	
	i CashierStat="SE"
	{
		q:(TInvNo'=("DHCPEYJS"_CurUser))  //||($D(^DHCPEPRT(TRowId,"RefInvID")))  //非预结算 //退费重收的发票
		s TOPInfo="SE^"_TRowId
	}
	//退费异常的
	i CashierStat="TE"{
		s isTE=##class(web.DHCPE.CashierEx).IsRefundException(TRowId)
		q:isTE=""
		s TOPInfo="TE^"_isTE
	}
	*/
	i TInvNo["DHCPEYJS" s TFlag="收费异常"
	i isTE'="" s TFlag="退费异常"

	s TUser=$p(InvData,"^",10)
	//Q:(TUser'=UserDR)&&(SelfOnlyFlag=1)
	
	
	i TUser'="" 
	{
		s TInis=$p($g(^SSU("SSUSR",TUser)),"^",1)
		s TUser=$p($g(^SSU("SSUSR",TUser)),"^",2)
		q:(User'="")&&(TInis'[User)&&(TUser'[User)
	}
	s TInvDate=$p(InvData,"^",11)
	s TInvTime=$p(InvData,"^",12)
	if ((BeginDate'="")&&(TInvDate<+BeginDate)) q
	if ((EndDate'="")&&(TInvDate>+EndDate)) q
	if TInvDate'=""	s TInvDate=##class(websys.Conversions).DateLogicalToHtml(TInvDate)
	if TInvTime'="" s TInvTime=##class(websys.Conversions).TimeLogicalToHtml(TInvTime)
	
	s TRPFlag=$p(InvData,"^",24)
	i ((RPFlag'="")&&(RPFlag'=TRPFlag)) q
	s TRPDate=$p(InvData,"^",15)
	if TRPDate'=""	s TRPDate=##class(websys.Conversions).DateLogicalToHtml(TRPDate)
	s TRInvNo=""
	s TRInvNo=$p(InvData,"^",9)
	i TRInvNo'="" d
	.s TRInvNoID=TRInvNo
	.s TRInvNo=$P($G(^DHCPEINVPRT(TRInvNo)),"^",1)
	.s RFocusPrintID=$o(^User.DHCPEINVFocusPrtI("IFPINVDRIndex"," "_TRInvNoID,""))
	.i RFocusPrintID'="" d
	..s RealInvNo=$LG(^User.DHCPEINVFocusPrtD(RFocusPrintID),3)
	..s TRInvNo=TRInvNo_"("_RealInvNo_")"
	q:(FocusPrint="1")&&(TInvNo'[("DHCSSP"))
	s FocusPrintID=$o(^User.DHCPEINVFocusPrtI("IFPINVDRIndex"," "_TRowId,""))
	q:(FocusPrint="1")&&(FocusPrintID'="")
	i FocusPrintID'="" d
	.s RealInvNo=$LG(^User.DHCPEINVFocusPrtD(FocusPrintID),3)
	.;s TInvNo=TInvNo_"("_RealInvNo_")"
	.s TInvNo=RealInvNo_"("_TInvNo_")"
	//s TRInvNo=$p(DropInvData,"^",1)
	i (TInvNo="")&(TRInvNo'="") s TInvNo=TRInvNo_"<font color=red>(退)</font>"
	S tTFlag="0"		
	i hasDrop'=""
	{
		s DropInvData=$g(^DHCPEINVPRT(hasDrop))
		s TDropDate=$p(DropInvData,"^",11)
		if TDropDate'=""	s TDropDate=##class(websys.Conversions).DateLogicalToHtml(TDropDate)
		
		s TDropInvFlag=$p(DropInvData,"^",8)
		s TDropInvFlag=..ParseInvFlag(TDropInvFlag)
		i TDropInvFlag="作废" s TFlag=TDropInvFlag  //与门诊保持一致
		S tTFlag="1" 
	}
	
	q:(InvStatus'="")&(InvStatus'=TFlag)
	s flag=0
	// isApply(0:退费申请 1：退费 2:发票重打  M:修改支付方式  F:收费收据查询)
	i isApply=0 d
	.s:TFlag="作废" flag=1
	.s:TFlag="冲红" flag=1
	.s:tTFlag="1" flag=1
	.s:TFlag["异常" flag=1
	i isApply=1 d
	.s:TFlag="作废" flag=1
	.s:TFlag="冲红" flag=1
	.q:TRowId=""
	.s:tTFlag="1" flag=1
	.s:'$D(^DHCPEDataEx("DHCPERefundApply","SelectIds",TRowId)) flag=1
	.s:TFlag["异常" flag=1
	i isApply=2 d
	.s:TFlag="作废" flag=1
	.s:TFlag="冲红" flag=1
	.s:tTFlag="1" flag=1
	.q:TRowId=""	
	.s:$D(^DHCPEDataEx("DHCPERefundApply","SelectIds",TRowId)) flag=1
	.s:TFlag["异常" flag=1
	i isApply="M" d
	.s:TFlag["异常" flag=1

	q:flag=1	
	
	s TAmount=$p(InvData,"^",7)
	q:(FocusPrint="1")&&(TAmount<0)
	
	s sswr=$p(InvData,"^",21)
	;s TAmount=TAmount+sswr
	;s FactAmount=FactAmount+TAmount
	;s TAccountAmount=..GetAccountAmountByInv(TRowId)
	;s AccountAmount=AccountAmount+TAccountAmount
	
	s hasdata=1	
	s TInvDate=TInvDate_" "_TInvTime
	s Postiion=""
	s Postiion=##class(web.DHCPE.PreCommon).GetPosition("REG",TRegNo)
	i InvName="" s InvName=TPatName
	q
ClearInvPrt
	s hasdata=0
	s (TInvNo,TPatName,TRegNo,TAmount,TFlag,TUser,TInvDate,TRPFlag,TRPDate,TSex,TAge,TDropDate,admtype,giadmid,TAccountAmount,RoundInfo,TRInvNo,InvName,sswr,Postiion,TOPInfo,namestr,ApplyUserID,ApplyUser,PrintEInv,EInvNo)=""
	q
OutInvPrt
	s tpaymode=""
	i TRowId'=""{
	s arrcp=$P($G(^DHCPEINVPRT(TRowId)),"^",4)
	s paym="0"
    f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d
    .s ss=^ARRCP(arrcp,"PAYM",paym)
    .s mode=$p(ss,"^",1)
    .Q:'$D(^CT("CTPM",mode))
    .q:(InvPayMode'="")&&(InvPayMode'=mode)
    .s chequeno=$p(ss,"^",4)   
    .i mode'="" s pmdesc=$p(^CT("CTPM",mode),"^",2)
    .e  s pmdesc="现金"
    .s pmdesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTPayMode",pmdesc,"CTPMDesc","cls") //翻译
    .;s pdamt=+$p(ss,"^",3)+sswr
    .s pdamt=+$p(ss,"^",3)
    .s pdamt=$fn(pdamt,"",2)
    
    .s:chequeno'="" pdamt=pdamt_"("_chequeno_")"
    .i tpaymode="" s tpaymode=pmdesc_":"_pdamt
    .e  s tpaymode=tpaymode_","_pmdesc_":"_pdamt
    
    //退费申请人
    s ApplyUserID="",ApplyUser=""
	s ApplyUserID=$p($g(^DHCPEDataEx("DHCPERefundApply","SelectIdsUser",TRowId)),"^",1)
	i ApplyUserID'="" S ApplyUser=$p($g(^SSU("SSUSR",ApplyUserID)),"^",2)

	}
	q:(tpaymode="")&&(TInvNo'="合计")
	
	i TRowId'="" d
	.s FactAmount=FactAmount+$P($G(^DHCPEINVPRT(TRowId)),"^",7)
	.s sswrAmount=sswrAmount+$P($G(^DHCPEINVPRT(TRowId)),"^",21)

	i ind>1 d
	.s RoundInfo=##class(web.DHCPE.CashierEx).GetRoundFee(TRowId)
	.s RoundInfoFee=0
	.s RoundFeeLength=$L(RoundInfo,"$$")
	.f i=1:1:RoundFeeLength  d
	..s OneInfo=$P(RoundInfo,"$$",i)
	..s OneFee=+$P(OneInfo,"^",3)
	..s RoundFee=RoundFee+OneFee
	..s RoundInfoFee=RoundInfoFee+OneFee
	.i TRPFlag="Y" S TRPFlag="是"
	.e  S TRPFlag="否"

    //获取电子发票信息 start
    s ExsistFlag=##class(web.DHCPE.CT.Public.PubFun).IsValidMethodName("BILL.EINV.BL.COM.InvUpDetailsCtl","GetEInvPrintFlag")
	i ExsistFlag=1 d
	.s EInvInfo=##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetEInvPrintFlag("PE",TRowId,"E") 
	e  s EInvInfo=""
	s PrintEInv=$p(EInvInfo,"^",1)
	s EInvNo=$p(EInvInfo,"^",3)
	//获取电子发票信息 end
	
	/*** 翻译 start ***/
	s TFlag=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeinvlist.hisui.csp",TFlag)
	s TRPFlag=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeinvlist.hisui.csp",TRPFlag)
	s TSex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",TSex,"CTSEXDesc","cls")
	/*** 翻译 end ***/
	set Data=$lb(0,TRowId,TInvNo,TPatName,TRegNo,$j(TAmount,3,2),TFlag,TUser,TInvDate,TRPFlag,TRPDate,TSex,TAge,TDropDate,admtype,giadmid,TAccountAmount,TRInvNo,tpaymode,$j(RoundInfoFee,3,2),InvName,$j(sswr,3,2),Postiion,TOPInfo,namestr,ApplyUser,PrintEInv,EInvNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod ParseInvFlag(flag)
{
	if flag="N" q "正常"
	if flag="A" q "作废"
	if flag="S" q "冲红"
	q ""
}

ClassMethod FindInvPrtListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInvPrtListExecute ]
{

	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
	 	s RecordSum=$o(^CacheTemp(repid,""),-1)
 		s $LIST(^CacheTemp(repid,ind),1)=RecordSum
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindInvPrtListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInvPrtListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// d ##class(web.DHCPE.InvPrt).DeleteTable()

ClassMethod GetInvStatus(invid)
{
	if invid="" q ""
	if $p($g(^DHCPEINVPRT(invid)),"^",9)'="" q 1	///该发票已经作废
	i $o(^DHCPEINVPRT(0,"REF",invid,""))'="" q 1	///该发票已经作废
	q 0
}

ClassMethod DeleteTable()
{
	//&sql(delete from DHC_PE_PreIBaseInfo)
	&sql(delete from DHC_PE_PreIADM)
	&sql(delete from DHC_PE_PreIOrdEnt)
	&sql(delete from DHC_PE_PreIOrdItem)
	//&sql(delete from DHC_PE_PreGBaseInfo)
	&sql(delete from DHC_PE_PreGADM)
	&sql(delete from DHC_PE_PreGTeam)
	&sql(delete from DHC_PE_PreGTOrdEnt)
	&sql(delete from DHC_PE_PreGTOrdItem)
	&sql(delete from DHC_PE_PreAudit)
	
	&sql(delete from DHC_PE_IADM)
	//&sql(delete from DHC_PE_AsChargedOrder)
	&sql(delete from DHC_PE_CRMOrder)
	//&sql(delete from DHC_PE_GBaseInfo)
	&sql(delete from DHC_PE_GTeam)
	&sql(delete from DHC_PE_GADM)
	&sql(delete from DHC_PE_GeneralAdvice)
	&sql(delete from DHC_PE_GeneralAdviceDetail)
	&sql(delete from DHC_PE_GeneralSummarize)
	&sql(delete from DHC_PE_Report)
	&sql(delete from DHC_PE_Result)
	&sql(delete from DHC_PE_StationSummarize)
	&sql(delete from DHC_PE_StationWait)	
	
	&sql(delete from DHC_PE_INVPRT)
	&sql(delete from DHC_PE_USERREPORT)
	&sql(delete from DHC_PE_PAPBRelate)	
	
	K ^DHCPEGenED
}

/// w ##class(web.DHCPE.InvPrt).ImportARCSet()
ClassMethod ImportARCSet()
{
	new arcsetid,arcsetdateid,arcsetdateitemid,arcdata
	new arcitemid,arcitemsub,arcitemver,subcatid,count
	new datefrom,dateto,labStationid
	s labStationid=$G(^DHCPESetting("DHCPE","StationId_Lab"))
	q:labStationid=""
	s arcsetid=""
	s count=0
	f  s arcsetid=$o(^ARCOS(arcsetid)) q:(arcsetid="")  d
	.s arcitemid=""
	.s arcdata=$g(^ARCOS(arcsetid))
	.q:arcdata=""
	.s datefrom=$p(arcdata,"^",15)
	.q:datefrom>=+$h
	.s dateto=$p(arcdata,"^",16)
	.q:((dateto'="")&&(dateto<+$h))
	.s arcsetdateid=""
	.f  s arcsetdateid=$o(^ARCOS(arcsetid,"DATE",arcsetdateid)) q:((arcsetdateid="")||(arcitemid'=""))  d
	..s arcdata=$g(^ARCOS(arcsetid,"DATE",arcsetdateid))
	..q:arcdata=""
	..s datefrom=$p(arcdata,"^",1)
	..q:datefrom>=+$h
	..s dateto=$p(arcdata,"^",2)
	..q:((dateto'="")&&(dateto<+$h))
	..s arcsetdateitemid=""
	..f  s arcsetdateitemid=$o(^ARCOS(arcsetid,"DATE",arcsetdateid,"ITM",arcsetdateitemid)) q:((arcsetdateitemid="")||(arcitemid'=""))  d
	...s arcdata=$g(^ARCOS(arcsetid,"DATE",arcsetdateid,"ITM",arcsetdateitemid))
	...//w arcsetid_" "_arcsetdateid_" "_arcsetdateitemid,!
	...s arcitemid=$p(arcdata,"^",1)
	...s arcitemsub=$p(arcitemid,"||",1)
	...s arcitemver=$p(arcitemid,"||",2)
	...//w arcitemid,!
	...i ((arcitemsub="")||(arcitemver=""))  s arcitemid=""
	...q:arcitemid=""
	...s subcatid=$p($g(^ARCIM(arcitemsub,arcitemver,1)),"^",10)
	...i subcatid=""  s arcitemid=""
	...q:arcitemid=""
	...i ($p($g(^ARC("IC",subcatid)),"^",7)'="L")  s arcitemid=""
	...q:arcitemid=""
	...//b:(count#20)=0
	...//q:count>50
	...//
	...i $o(^DHCPEST(0,"STORD_ARCOS",arcsetid,""))="" d
	....&SQL(Insert into dhc_pe_stationorder(STORD_ParRef,STORD_ARCIM_DR,STORD_Diet,STORD_ARCOS_DR,STORD_ReportFormat) values (:labStationid,:arcitemid,'N',:arcsetid,'RF_LIS'))
	...d ##class(web.DHCPE.TransOrderDetail).Main(arcitemid)
	...s count=count+1
	...//w "count:"_count_"  arcset:"_arcsetid_"  arcitemid:"_arcitemid,!
}

/// w ##class(web.DHCPE.InvPrt).UpdateARCSet()
ClassMethod UpdateARCSet()
{
	new arcsetid,arcsetdateid,arcsetdateitemid,arcdata
	new arcitemid,arcitemsub,arcitemver,subcatid,count
	new datefrom,dateto,labStationid
	s labStationid=$G(^DHCPESetting("DHCPE","StationId_Lab"))
	q:labStationid=""
	s arcsetid=""
	s count=0
	f  s arcsetid=$o(^ARCOS(arcsetid)) q:(arcsetid="")  d
	.s arcitemid=""
	.s arcdata=$g(^ARCOS(arcsetid))
	.q:arcdata=""
	.s datefrom=$p(arcdata,"^",15)
	.q:datefrom>=+$h
	.s dateto=$p(arcdata,"^",16)
	.q:((dateto'="")&&(dateto<+$h))
	.s arcsetdateid=""
	.f  s arcsetdateid=$o(^ARCOS(arcsetid,"DATE",arcsetdateid)) q:((arcsetdateid="")||(arcitemid'=""))  d
	..s arcdata=$g(^ARCOS(arcsetid,"DATE",arcsetdateid))
	..q:arcdata=""
	..s datefrom=$p(arcdata,"^",1)
	..q:datefrom>=+$h
	..s dateto=$p(arcdata,"^",2)
	..q:((dateto'="")&&(dateto<+$h))
	..s arcsetdateitemid=""
	..f  s arcsetdateitemid=$o(^ARCOS(arcsetid,"DATE",arcsetdateid,"ITM",arcsetdateitemid)) q:((arcsetdateitemid="")||(arcitemid'=""))  d
	...s arcdata=$g(^ARCOS(arcsetid,"DATE",arcsetdateid,"ITM",arcsetdateitemid))
	...//w arcsetid_" "_arcsetdateid_" "_arcsetdateitemid,!
	...s arcitemid=$p(arcdata,"^",1)
	...s arcitemsub=$p(arcitemid,"||",1)
	...s arcitemver=$p(arcitemid,"||",2)
	...//w arcitemid,!
	...i ((arcitemsub="")||(arcitemver=""))  s arcitemid=""
	...q:arcitemid=""
	...s subcatid=$p($g(^ARCIM(arcitemsub,arcitemver,1)),"^",10)
	...i subcatid=""  s arcitemid=""
	...q:arcitemid=""
	...i ($p($g(^ARC("IC",subcatid)),"^",7)'="L")  s arcitemid=""
	...q:arcitemid=""
	...//b:(count#20)=0
	...//q:count>50
	...//
	...&SQL(update dhc_pe_stationorder set STORD_ARCOS_DR=:arcsetid where STORD_ARCIM_DR=:arcitemid)
	...
	...//i $o(^DHCPEST(0,"STORD_ARCOS",arcsetid,""))="" d
	...//.&SQL(Insert into dhc_pe_stationorder(STORD_ParRef,STORD_ARCIM_DR,STORD_Diet,STORD_ARCOS_DR,STORD_ReportFormat) values (:labStationid,:arcitemid,"N",:arcsetid,"RF_LIS"))
	...//d ##class(web.DHCPE.TransOrderDetail).Main(arcitemid)
	...s count=count+1
	...//w "count:"_count_"  arcset:"_arcsetid_"  arcitemid:"_arcitemid,!
}

/// 根据preiadmid获取个人的费用信息
/// 返回   应付金额^最终金额^公费金额^公费已付^公费未付^自费金额^自费已付^自费未付
/// w ##Class(web.DHCPE.InvPrt).GetAdmFee()
ClassMethod GetAdmFee(preiadmid)
{
	new itemsub,feesub,feedata,factamount,itemstat,publicflag,payedflag,errs
	new AccountSum,FactSum,PublicSum,PubllicPayed,PubllicUnPayed,SelfSum,SelfPayed,SelfUnPayed
	q:preiadmid="" ""
	s itemsub=""
	s (AccountSum,FactSum,PublicSum,PubllicPayed,SelfSum,SelfPayed)=0
	s errs=""
	
	//医嘱费用
	f  s itemsub=$o(^DHCPEPreIADM(preiadmid,"ORDITEM",itemsub)) q:((itemsub="")||(errs'=""))  d
	.s itemstat=$p($g(^DHCPEPreIADM(preiadmid,"ORDITEM",itemsub)),"^",16)
	.q:itemstat'="1"
	.s OrdEnt=$p($g(^DHCPEPreIADM(preiadmid,"ORDITEM",itemsub)),"^",2)
	./***注: iMedical8.5套餐价格已存在项目价格表,套餐价格表已不再存数据;***/
	./***注: iMedical8.5以前版本需要下面注释的代码***/
	.;q:OrdEnt'=""
	.s AccountSum=AccountSum+$p($g(^DHCPEPreIADM(preiadmid,"ORDITEM",itemsub)),"^",14)
	.s feesub=0
	.f  s feesub=$o(^DHCPEPreIADM(preiadmid,"ORDITEM",itemsub,"FEE",feesub)) q:((feesub="")||(errs'=""))  d
	..s feedata=$g(^DHCPEPreIADM(preiadmid,"ORDITEM",itemsub,"FEE",feesub))	
	..s preauditid=$p(feedata,"^",5)
	..s publicflag=0
	..s payedflag=0
	..q:preauditid=""
	..s UseFlag=$p($g(^DHCPEPreA(preauditid)),"^",21)
	..q:UseFlag="NU"
	..i $p($g(^DHCPEPreA(preauditid)),"^",1)="G" s publicflag=1
	..i $p($g(^DHCPEPreA(preauditid)),"^",14)="CHARGED" s payedflag=1
	..s factamount=+$p(feedata,"^",2)
	..s FactSum=FactSum+factamount
	..i publicflag=1  d
	...s PublicSum=PublicSum+factamount
	...i payedflag=1 s PubllicPayed=PubllicPayed+factamount
	..e  d
	...s SelfSum=SelfSum+factamount
	...i payedflag=1 s SelfPayed=SelfPayed+factamount
	
	//医嘱套费用
	f  s itemsub=$o(^DHCPEPreIADM(preiadmid,"ORDENT",itemsub)) q:((itemsub="")||(errs'=""))  d
	.s itemstat=$p($g(^DHCPEPreIADM(preiadmid,"ORDENT",itemsub)),"^",9)
	.q:itemstat'="1"
	.s AccountSum=AccountSum+$p($g(^DHCPEPreIADM(preiadmid,"ORDENT",itemsub)),"^",7)
	.s feesub=0
	.f  s feesub=$o(^DHCPEPreIADM(preiadmid,"ORDENT",itemsub,"FEE",feesub)) q:((feesub="")||(errs'=""))  d
	..s feedata=$g(^DHCPEPreIADM(preiadmid,"ORDENT",itemsub,"FEE",feesub))	
	..s preauditid=$p(feedata,"^",5)
	..s publicflag=0
	..s payedflag=0
	..q:preauditid=""
	..s UseFlag=$p($g(^DHCPEPreA(preauditid)),"^",21)
	..q:UseFlag="NU"
	..i $p($g(^DHCPEPreA(preauditid)),"^",1)="G" s publicflag=1
	..i $p($g(^DHCPEPreA(preauditid)),"^",14)="CHARGED" s payedflag=1
	..s factamount=+$p(feedata,"^",2)
	..s FactSum=FactSum+factamount
	..i publicflag=1  d
	...s PublicSum=PublicSum+factamount
	...i payedflag=1 s PubllicPayed=PubllicPayed+factamount
	..e  d
	...s SelfSum=SelfSum+factamount
	...i payedflag=1 s SelfPayed=SelfPayed+factamount
	
	s PubllicUnPayed=PublicSum-PubllicPayed
	s SelfUnPayed=SelfSum-SelfPayed
	
	q AccountSum_"^"_FactSum_"^"_PublicSum_"^"_PubllicPayed_"^"_PubllicUnPayed_"^"_SelfSum_"^"_SelfPayed_"^"_SelfUnPayed
}

/// 根据preiadmid获取个人的红冲金额和作废金额
/// 
/// 返回   作废金额^个人终止金额^公费金额金额
/// w ##Class(web.DHCPE.InvPrt).GetAdmAbortFee(507)
ClassMethod GetAdmAbortFee(preiadmid)
{
	q:preiadmid="" ""
	k ^DHCPETMP("AAF")
	// DHC_PE_PreAudit
	s paadmtype=""
	f  s paadmtype=$O(^DHCPEPreA(0,"CRMADM",paadmtype)) Q:(""=paadmtype)  d
	.s paid=""
	.f  s paid=$O(^DHCPEPreA(0,"CRMADM",paadmtype,preiadmid,paid)) Q:(""=paid)  d
	..
	..// DHC_PE_PreAudit.{ PA_Status }
	..//s pastatus=$P($G(^DHCPEPreA(paid)),"^",21)
	..//Q:("NU"=pastatus)
	..
	..// DHC_PE_PAPBRelate.{ PAPB_RowId }
	..s papbid=0
	..f  s papbid=$O(^DHCPEPAPBR(0,"PADR",paid,papbid)) Q:(""=papbid)  d
	...// DHC_PE_PAPBRelate.{ PAPB_PBType } Normal||N 正常收费 Abort||A 作废 Strike||S冲红
	...s pbtype=$P($G(^DHCPEPAPBR(papbid)), "^", 3)
	...Q:("N"=pbtype)||("Normal"=pbtype)
	...
	...// DHC_PE_PreAudit.{ PA_FactAmount }
	...s FactSum=$P($G(^DHCPEPreA(paid)),"^",9)
	...
	...s ^DHCPETMP("AAF",preiadmid,paadmtype)=FactSum+$G(^DHCPETMP("AAF",preiadmid,paadmtype))
	...s ^DHCPETMP("AAF",preiadmid)=FactSum+$G(^DHCPETMP("AAF",preiadmid))

	q $G(^DHCPETMP("AAF",preiadmid))_"^"_$G(^DHCPETMP("AAF",preiadmid,"I"))_"^"_$G(^DHCPETMP("AAF",preiadmid,"G"))
}

/// PAPMINo_"^"_Name_"^"_SexDRName_"^"_Dob_"^"_Age_"^"_Tel_"^"_IDCard_"^"_Company_"^"_Postalcode_"^"_Address_"^"_Nation_"^"_Email
/// w ##Class(web.DHCPE.InvPrt).GetPatInfo(paadm)
ClassMethod GetPatInfo(paadm)
{
	s info=""
	if paadm="" q info
	s iadm=$O(^DHCPEIADM(0,"PAADM",paadm,0))
	if (""=iadm) q info
	
	s CurData=$G(^DHCPEIADM(iadm))
	s AdmDate=$P(CurData,"^",5)
	i (""'=AdmDate) s AdmDate=$ZD(AdmDate,3)
	s piadm=$P(CurData,"^",4)
	i (""=piadm) q info
	
	s CurData=$G(^DHCPEPreIADM(piadm))
	s PIBIDR=$P(CurData,"^",1)
	if (""=PIBIDR) q info	
	s CurData=$G(^DHCPEPreIBI(PIBIDR))
	// PIBI_PAPMINo		登记号
	s PAPMINo=$p(CurData,"^",1)
	// PIBI_Name	姓名
	s Name=$p(CurData,"^",2)
	// PIBI_Sex_DR = CT_Sex.{}	性别
	s SexDR=$p(CurData,"^",3)
	i (""'=SexDR) s SexDRName=$p(^CT("SEX",SexDR),"^",2)
	// PIBI_DOB		出生日期
	s Dob=$p(CurData,"^",4)
 	i Dob'="" s PAPERDob=$ZD(Dob,3)
 	// 年龄 
 	s Age=""
 	i (""'=Dob) s Age=##class(web.DHCLCNUREXCUTE).CalAge(Dob,+$h)
 	s Age=$P(Age,"Y")_" 岁"
	// PIBI_PatType_DR 客户类型
	s PatTypeDR=$p(CurData,"^",5)
	// PIBI_Tel1 电话1 
	s Tel1=$p(CurData,"^",6)
	// PIBI_Tel2 电话1
	s Tel2=$p(CurData,"^",7)
	// PIBI_MobilePhone 手机
	s MobilePhone=$p(CurData,"^",8)
	s Tel=Tel2
	i (""'=Tel1) s Tel=Tel1
	i (""'=MobilePhone) s Tel=MobilePhone
	// PIBI_IDCard 身份证号
	s IDCard=$p(CurData,"^",9)
 	// PIBI_Company	工作单位
 	s Company=$p(CurData,"^",12)
 	// PIBI_Postalcode	邮编
 	s Postalcode=$p(CurData,"^",13)
 	// PIBI_Address	地址
 	s Address=$p(CurData,"^",14)
	// PIBI_Nation 民族
	s Nation=$p(CurData,"^",15)
	// PIBI_Email 电子邮件
	s Email=$p(CurData,"^",16)
	q PAPMINo_"^"_Name_"^"_SexDRName_"^"_Dob_"^"_Age_"^"_Tel_"^"_IDCard_"^"_Company_"^"_Postalcode_"^"_Address_"^"_Nation_"^"_Email
}

ClassMethod GetAccountAmountByInv(InvID)
{
	n (InvID)
	s RInvID=$p($g(^DHCPEINVPRT(InvID)),"^",9)
	s Flag=1
	i RInvID'="" s Flag=-1
	s PBID=$p($g(^DHCPEINVPRT(InvID)),"^",3)
	s Account=0
	s PAPBID=0
	f  s PAPBID=$o(^DHCPEPAPBR(0,"PBDR",PBID,PAPBID)) q:PAPBID=""  d
	.s PAID=$p(^DHCPEPAPBR(PAPBID),"^",1)
	.s OneAccount=+$p(^DHCPEPreA(PAID),"^",6)
	.s Account=Account+(OneAccount*Flag)
	q Account
}

// w ##class(web.DHCPE.InvPrt).GetTarItemInfo(109)

ClassMethod GetTarItemInfo(InvID, ordID)
{
	
	s paadm=$P(^DHCPEINVPRT(InvID),"^",2)
	s papmi=$p(^PAADM(paadm),"^",1)
	s OldOrdID=ordID
	s name=$P(^PAPER(papmi,"ALL"),"^",1)
	s regno=$P(^PAPER(papmi,"PAT",1),"^",1)
	s baseinfo=name_"^"_regno
	s NewordID=$O(^DHCPEOEITEM(InvID,"OEITEM",ordID))
	s c1=$C(1)
	s c2=$C(2)
	
	q:OldOrdID="" NewordID_c2_baseinfo
	q:ordID="" ""
	s ret=""
	s totalAmt=0
	s arcim=$P(^DHCPEPreIADM(+ordID,"ORDITEM",$P(ordID,"||",2)),"^",1)
	s SetID=$P(^DHCPEPreIADM(+ordID,"ORDITEM",$P(ordID,"||",2)),"^",2)
	
	s arcimDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(arcim)
	i SetID'="" d
	.s SetID=$P(^DHCPEPreIADM(+SetID,"ORDENT",$P(SetID,"||",2)),"^",1)
	.s arcimDesc=$P(^ARCOS(SetID),"^",2)
	s arcimDesc=##class(web.DHCPE.Public.Setting).Replace(arcimDesc,$C(10),"")
	s arcimDesc=##class(web.DHCPE.Public.Setting).Replace(arcimDesc,$C(9),"")
	s arcimDesc=##class(web.DHCPE.Public.Setting).Replace(arcimDesc,$C(13),"")
	s sub=0
	f  s sub=$O(^DHCPEOEITEM(InvID,"OEITEM",ordID,"TARITEM",sub)) q:sub=""  d
	.//TarItemID_"^"_price_"^"_qty_"^"_Amount
	.s info=$G(^DHCPEOEITEM(InvID,"OEITEM",ordID,"TARITEM",sub))
	.s tarItemID=$p(info,"^",1)
	.s uom=$P(^DHCTARI(tarItemID),"^",3)
	.i uom'="" s uom=$P(^CT("UOM",uom),"^",2)
	.s desc=$P(^DHCTARI(tarItemID),"^",2)
	.s price=+$p(info,"^",2)
	.s count=+$p(info,"^",3)
	.s amt=+$p(info,"^",4)
	.s totalAmt=totalAmt+amt
	.s oneInfo=arcimDesc_"^"_desc_"^"_uom_"^"_price_"^"_count_"^"_amt
	.s arcimDesc=""
	.i ret="" d
	..s ret=oneInfo
	.e  d
	..s ret=ret_c1_oneInfo
	i ret="" d
	.s ret=oneInfo
	e  d
	.s ret=ret_c1_oneInfo
	q NewordID_c2_ret
}

}
