/// 集中打印发票
Class web.DHCPE.INVFocusPrt Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

// 集中打印发票记录打印信

ClassMethod Save(InvPrtID, InvInfo, UserID, CheckFlag As %String = "0", HospitalID, LocID As %String = "")
{
	i $L(InvPrtID,"||")>1 q ..APSave(InvPrtID, InvInfo, UserID, CheckFlag,HospitalID,LocID)
	s InvNo=$P(InvInfo,"^",1)
	s InvName=$P(InvInfo,"^",2)
	s RealAdmReason=$P(InvInfo,"^",3)
	s INSUFlag="N"
	s:RealAdmReason'="" INSUFlag="Y"
	;判断是否已经是医保
	s InsuID=$P(^DHCPEOEITEM(InvPrtID),"^",4)
	q:(InsuID'="")&&(INSUFlag="Y") "-1^已经使用医保结算了，不允许再次使用医保打印发票"
	
	s RefInvid=$P(^DHCPEINVPRT(InvPrtID),"^",9)
	
	q:RefInvid'="" "-1^发票已经退费，不能打印发票"
	q:$D(^User.DHCPEINVFocusPrtI("IFPINVDRIndex"," "_InvPrtID)) "-1^发票已经打印，不能再次打印"
	//判断当前票号信息是否正确
	s CurInvNo=##class(web.DHCPE.DHCPEPAY).getcurinvno(UserID,"N",LocID)
	s Title=$p(CurInvNo,"^",3)
	if InvNo'=$p(CurInvNo,"^",1) q "-1^传入发票号不正确,请刷新后重试!"
	S InvNo=Title_InvNo 
	s RID=$p(CurInvNo,"^",2)
	q:CheckFlag="1" "0^验证通过"
	///走发票号
	TSTART
	s err=..incre(RID,InvNo,UserID,LocID)
	i err'=0
	{
		TROLLBACK
		q "-1^更新发票号信息错误"
	}
	/*
	//更新his表中的发票号
	s ARRcp=$P(^DHCPEINVPRT(InvPrtID),"^",4)
	i (ARRcp'="")&(invno'="") d
	.&sql(update AR_Receipts set ARRCP_Number=:InvNo where ARRCP_ROWID=:ARRcp)
	.s err=err+SQLCODE
	q:err'=0 "-1^更新发票号信息错误"
	*/
	//插入集中打印发票信息
	s Date=+$H
	s Time=$P($H,",",2)
	
	&SQL(Insert into SQLUser.DHC_PE_INVFocusprt (IFP_INV_DR,IFP_INVNo,IFP_USER_DR,IFP_Date,IFP_Time,IFP_ReportFlag,IFP_Invoice_DR,IFP_INSUFlag,IFP_INVType,IFP_Hospital_DR) values (:InvPrtID,:InvNo,:UserID,:Date,:Time,'N',:RID,:INSUFlag,'N',:HospitalID) )
	
	i SQLCODE'=0
	{
		TROLLBACK
		q "-1^插入集中打印发票信息错误"
	}
	//记录发票上打印的名字
	s:InvName'="" ^DHCPEDataEx("InvName",InvPrtID)=InvName
	//记录医保支付时真实的费别
	s:RealAdmReason'="" $P(^DHCPEOEITEM(InvPrtID),"^",6)=RealAdmReason
	TCOMMIT
	q "0^操作成功"
}

ClassMethod APSave(InvPrtID, InvInfo, UserID, CheckFlag As %String = "0", HospitalID, LocID As %String = "")
{
	s InvNo=$P(InvInfo,"^",1)
	s InvName=$P(InvInfo,"^",2)
	s RealAdmReason=$P(InvInfo,"^",3)
	s INSUFlag="N"
	q:RealAdmReason'="" "-1^预交金不能使用医保结算"
	;判断是否已经是医保
	
	q:$D(^DHCPEDataEx("InvFocusprt",InvPrtID)) "-1^发票已经打印，不能再次打印"
	//判断当前票号信息是否正确
	s CurInvNo=##class(web.DHCPE.DHCPEPAY).getcurinvno(UserID,"N",LocID)
	s Title=$p(CurInvNo,"^",3)
	if InvNo'=$p(CurInvNo,"^",1) q "-1^传入发票号不正确,请刷新后重试!"
	S InvNo=Title_InvNo 
	s RID=$p(CurInvNo,"^",2)
	q:CheckFlag="1" "0^验证通过"
	///走发票号
	TSTART
	s err=..incre(RID,InvNo,UserID,LocID)
	i err'=0
	{
		TROLLBACK
		q "-1^更新发票号信息错误"
	}
	//插入集中打印发票信息
	s Date=+$H
	s Time=$P($H,",",2)
	&SQL(Insert into SQLUser.DHC_PE_INVFocusprt (IFP_INV_DR,IFP_INVNo,IFP_USER_DR,IFP_Date,IFP_Time,IFP_ReportFlag,IFP_Invoice_DR,IFP_INSUFlag,IFP_INVType,IFP_Hospital_DR) values (:InvPrtID,:InvNo,:UserID,:Date,:Time,"N",:RID,:INSUFlag,'Y',:HospitalID) )
	i SQLCODE'=0
	{
		TROLLBACK
		q "-1^插入集中打印发票信息错误"
	}
	s RowID=%ROWID
	s ^DHCPEDataEx("InvFocusprt",InvPrtID,RowID)=""
	//记录发票上打印的名字
	s:InvName'="" ^DHCPEDataEx("InvName",InvPrtID)=InvName
	//记录医保支付时真实的费别
	s:RealAdmReason'="" $P(^DHCPEOEITEM(InvPrtID),"^",6)=RealAdmReason
	TCOMMIT
	q "0^操作成功"
}

// w ##class(web.DHCPE.INVFocusPrt).Cancel(121,933)

ClassMethod Cancel(InvID, UserID)
{
	s FocusPrtID=$O(^User.DHCPEINVFocusPrtI("IFPINVDRIndex"," "_InvID,""))
	q:FocusPrtID="" "-1^未集中打印，无须撤销"
	s RptFlag=$LG(^User.DHCPEINVFocusPrtD(FocusPrtID),7)
	q:RptFlag="Y" "-1^发票已结算，不允许撤销"
	s hasDrop=$o(^DHCPEINVPRT(0,"REF",InvID,""))
	q:hasDrop'="" "-1^发票已作废，不允许撤销"

	s InvoiceID=$LG(^User.DHCPEINVFocusPrtD(FocusPrtID),10)
	s Title=$P(^DHCINVOICE(InvoiceID),"^",16)
	s InvNo=$LG(^User.DHCPEINVFocusPrtD(FocusPrtID),3)
	s:Title'="" InvNo=$P(InvNo,Title,2)
	s CurInvNo=##class(web.DHCPE.DHCPEPAY).getcurinvno(UserID)
	s NewInvoiceID=$p(CurInvNo,"^",2)
	s SQLCODE=0
	TSTART
	i NewInvoiceID=InvoiceID d  ;没有更换发票
	.&SQL(Update Sqluser.dhc_invoice set INV_LastNum=:InvNo where INV_rowid=:InvoiceID)
	e  d  ;更换发票
	.s FinalFlag=$P(^DHCINVOICE(InvoiceID),"^",7)
	.i FinalFlag="Y" d
	..s FinalFlag="N"
	.e  d
	..s FinalFlag="Y"
	.&SQL(Update Sqluser.dhc_invoice set INV_Finalflag=:FinalFlag where INV_rowid=:InvoiceID)
	.q:SQLCODE'=0
	.i FinalFlag="Y" d
	..s FinalFlag="N"
	.e  d
	..s FinalFlag="Y"
	.&SQL(Update Sqluser.dhc_invoice set INV_Finalflag=:FinalFlag where INV_rowid=:NewInvoiceID)
	i SQLCODE'=0
	{
		TROLLBACK
		q "-1^回退发票错误"
	}
	&SQL(Delete From Sqluser.DHC_PE_INVFocusprt where ID=:FocusPrtID)
	i SQLCODE'=0
	{
		TROLLBACK
		q "-1^回退发票错误"
	}
	TCOMMIT
	q "0^回退发票成功"
}

// 走发票号

ClassMethod incre(RID, InvNo, UserID, LocID)
{
	s err=0
	s finalflag=##class(web.DHCPE.DHCPEPAY).GetFinalFlag(LocID)
	s err=##CLASS(web.UDHCJFINV).SELECT(RID)
	s endinv=+PLIST(3)
	s Title=PLIST(17)
	i Title'="" d
	.s tmpinvno=$P(InvNo,Title,2)
	e  d
	.s tmpinvno=InvNo
	i +tmpinvno=+endinv d      ;如果是最后一张领取的发票??标记为已用完
	.s err=##class(web.DHCPE.DHCPEPAY).invrefund(RID,tmpinvno,UserID,LocID)
	.s err=err+SQLCODE
	i +tmpinvno<endinv d
	.i finalflag="Y" s lastnum=##class(web.DHCPE.DHCPEPAY).incre(tmpinvno)
	.i finalflag="N" s lastnum=tmpinvno
	.i finalflag="" s lastnum=##class(web.DHCPE.DHCPEPAY).incre(tmpinvno)
	.&sql(update SQLUser.DHC_INVOICE set inv_lastnum=:lastnum where inv_rowid=:RID)   
	.s err=err+SQLCODE
	q err
}

// 取收费时是否留了发票抬头、以及医保支付默认的费别

ClassMethod GetInvInfo(InvID)
{
	if ($L(InvID,"||")>1)
	{
		s ARowID=$p(InvID,"||",1)
		s Sub=$p(InvID,"||",2)
		s InvName=$p($G(^DHCPEDataEx("DHCPEAD","Info",ARowID)),"^",1)
		s DefaultReason=""
	}
	else
	{
		s PAADM=$p(^DHCPEINVPRT(InvID),"^",2)
		s patid=$p($g(^PAADM(PAADM)),"^",1)
		s PatName=$p($g(^PAPER(patid,"ALL")),"^",1)
		s InvName=$G(^DHCPEDataEx("InvName",InvID))
		;s:InvName="" InvName=PatName
		s DefaultReason=$P(^PAADM(PAADM,1),"^",7)
		i DefaultReason'="" d
		.s ReasonType=$P(^PAC("ADMREA",DefaultReason),"^",9)
		.s:ReasonType="" DefaultReason=""
	}
	q InvName_"^"_DefaultReason
}

// 集中打印发票结算发票号段

// w ##class(web.DHCPE.INVFocusPrt).SaveReport(933)

ClassMethod SaveReport(UserID)
{
	s InvNoStr=..GetInvStr("",UserID,1)
	s Amt=$P(InvNoStr,"^",2)
	s InvNum=$P(InvNoStr,"^",3)
	s InvNoStr=$P(InvNoStr,"^",1)
	q:InvNoStr="" "-1^没有需要结算的数据"
	s Date=+$H
	s Time=$P($H,",",2)
	TSTART
	&SQL(Insert Into Sqluser.DHC_PE_FocusPrtReport (FPR_Date,FPR_USER_DR,FPR_Time,FPR_INVStr,FPR_Amt,FPR_InvNum) values (:Date,:UserID,:Time,:InvNoStr,:Amt,:InvNum))
	i SQLCODE'=0
	{
		TROLLBACK
		q "-1^插入日结表错误"
	}
	s ID=%ROWID
	&SQL(Update Sqluser.DHC_PE_INVFocusprt Set IFP_ReportFlag='Y',IFP_Report_DR=:ID Where IFP_ReportFlag='N' and IFP_USER_DR=:UserID)
	i SQLCODE'=0
	{
		TROLLBACK
		q "-1^更新集中打印发票表错误"
	}
	TCOMMIT
	q ID_"^结算成功"
}

// 根据日结ID或者用户ID获取发票号段

// w ##class(web.DHCPE.INVFocusPrt).GetInvStr("",933)

ClassMethod GetInvStr(ReportID, UserID, IncludeAmt As %String = "0")
{
	i ReportID'=""
	{
		s InvNoStr=$LG(^User.DHCPEFocusPrtReportD(ReportID),5)
		s Amt=$LG(^User.DHCPEFocusPrtReportD(ReportID),6)
		s InvNum=$LG(^User.DHCPEFocusPrtReportD(ReportID),7)
		q:IncludeAmt="1" InvNoStr_"^"_Amt_"^"_InvNum
		q InvNoStr
	}
	s Job=$J
	s Amt=0
	s InvNum=0
	s Date=""
	f  s Date=$O(^User.DHCPEINVFocusPrtI("FlagUserDateIndex","N",UserID,Date)) q:Date=""  d
	.s ID=""
	.f  s ID=$O(^User.DHCPEINVFocusPrtI("FlagUserDateIndex","N",UserID,Date,ID)) q:ID=""  d
	..s InvNo=$LG(^User.DHCPEINVFocusPrtD(ID),3)
	..s InvID=$LG(^User.DHCPEINVFocusPrtD(ID),2)
	..s OneAmt=$P($G(^DHCPEINVPRT(InvID)),"^",7)
	..s Amt=Amt+OneAmt
	..s InvNum=InvNum+1
	..;s ^TEMPDHCPEInv(Job,UserID,InvNo)=""
	..s rcptstr=##class(web.DHCPE.DHCPEUSERREPORT).getrcptstr("",InvNo,"1",UserID)
	s InvNoStr=##class(web.DHCPE.DHCPEUSERREPORT).getrcptstr("","","2",UserID)
	k ^TEMPDHCPEInv(Job,UserID)
	q:IncludeAmt="1" InvNoStr_"^"_Amt_"^"_InvNum
	q InvNoStr
}

Query FindFocusReport(UserID As %String, StartDate As %String = "", EndDate As %String = "", OnlyUser As %String = "") As %Query(ROWSPEC = "TID:%String,TUserName:%String,TDate:%String,TTime:%String,TInvStr:%String,TAmt:%String,TInvNum:%String,TUserID:%String")
{
}

ClassMethod FindFocusReportExecute(ByRef qHandle As %Binary, UserID As %String, StartDate As %String = "", EndDate As %String = "", OnlyUser As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	;i ($g(UserID)="")!(StartDate="")!(EndDate="") Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s:StartDate'="" StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate) 
	s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	
	s:StartDate="" StartDate=1
	s:EndDate="" EndDate=+$H
	
	s:OnlyUser="1" UserID=%session.Get("LOGON.USERID")
	s Date=EndDate+1
	f  s Date=$O(^User.DHCPEFocusPrtReportI("FPRDateIndex",Date),-1) q:(Date="")||(Date<StartDate)  d
	.s ID=""
	.f  s ID=$O(^User.DHCPEFocusPrtReportI("FPRDateIndex",Date,ID),-1) q:ID=""  d
	..s TID=ID
	..s TDate=##class(websys.Conversions).DateLogicalToHtml(Date)
	..s TTime=$LG(^User.DHCPEFocusPrtReportD(ID),4)
	..s TTime=$ZT(TTime)
	..s TUserID=$LG(^User.DHCPEFocusPrtReportD(ID),3)
	..q:(UserID'="")&&(UserID'=TUserID)
	..s TUserName=$P(^SSU("SSUSR",TUserID),"^",2)
	..s TInvStr=$LG(^User.DHCPEFocusPrtReportD(ID),5)
	..s TAmt=$LG(^User.DHCPEFocusPrtReportD(ID),6)
	..s TInvNum=$LG(^User.DHCPEFocusPrtReportD(ID),7)
 	..Do OutputRow	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(TID,TUserName,TDate,TTime,TInvStr,TAmt,TInvNum,%session.Get("LOGON.USERID"))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindFocusReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFocusReportExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindFocusReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFocusReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindFocusReportDetail(ReportID As %String = "", UserID As %String = "") As %Query(ROWSPEC = "TID:%String,TPrintDate:%String,TInvName:%String,TInvNo:%String,TInvAmt:%String,TInvTime:%String,TBillDate:%String,TInvType:%String")
{
}

ClassMethod FindFocusReportDetailExecute(ByRef qHandle As %Binary, ReportID As %String, UserID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if (ReportID="")&&(UserID="")
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	if (ReportID'=""){
	 	s ID=""
	 	f  s ID=$O(^User.DHCPEINVFocusPrtI("IFPReportDRIndex",ReportID,ID)) q:ID=""  d
	 	.d OutOneInfo
 	}else{
	 	s Date=""
	 	f  s Date=$O(^User.DHCPEINVFocusPrtI("FlagUserDateIndex","N",UserID,Date)) q:Date=""  d
	 	.s ID=""
	 	.f  s ID=$O(^User.DHCPEINVFocusPrtI("FlagUserDateIndex","N",UserID,Date,ID)) q:ID=""  d
	 	..d OutOneInfo
 	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutOneInfo
	s TID=ID
	s TPrintDate=$LG(^User.DHCPEINVFocusPrtD(ID),5)
	s:TPrintDate'="" TPrintDate=##class(websys.Conversions).DateLogicalToHtml(TPrintDate)
	s TInvTime=$LG(^User.DHCPEINVFocusPrtD(ID),6)
	s:TInvTime'="" TInvTime=$ZT(TInvTime)
	s TInvNo=$LG(^User.DHCPEINVFocusPrtD(ID),3)
	s InvID=$LG(^User.DHCPEINVFocusPrtD(ID),2)
	s InvType=$LG(^User.DHCPEINVFocusPrtD(ID),11)
	i InvType="Y" d
	.s TBillDate=$p(^DHCPEAP(+InvID,"AC",$p(InvID,"||",2)),"^",5)
	.s:TBillDate'="" TBillDate=##class(websys.Conversions).DateLogicalToHtml(TBillDate)
	.s TInvAmt=$p(^DHCPEAP(+InvID,"AC",$p(InvID,"||",2)),"^",2)
	.s patname=$p($G(^DHCPEDataEx("DHCPEAD","Info",+InvID)),"^",1)
	.s TInvType=$p(^DHCPEAP(+InvID),"^",3)
	.s:TInvType="R" TInvType="预缴金"
	.s:TInvType="C" TInvType="代金卡"
	e  d
	.s TBillDate=$P(^DHCPEINVPRT(InvID),"^",11)
	.s:TBillDate'="" TBillDate=##class(websys.Conversions).DateLogicalToHtml(TBillDate)
	.s TInvAmt=$P(^DHCPEINVPRT(InvID),"^",7)
	.s paadm=$P(^DHCPEINVPRT(InvID),"^",2)
	.s patid=$p($g(^PAADM(paadm)),"^",1)
	.s patname=$p($g(^PAPER(patid,"ALL")),"^",1)
	.s InvName=$G(^DHCPEDataEx("InvName",InvID))
	.s:InvName'="" patname=patname_"("_InvName_")"
	.s TInvType=""
	s TInvName=patname
	d DetailOutputRow
	q
   
DetailOutputRow
	set Data=$lb(TID,TPrintDate,TInvName,TInvNo,TInvAmt,TInvTime,TBillDate,TInvType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindFocusReportDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFocusReportDetailExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindFocusReportDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFocusReportDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// d ##class(web.DHCPE.INVFocusPrt).OutDetailButton()

ClassMethod OutDetailButton(ReportID)
{
	w "<button onclick='ShowDetail22(this)' id='"_ReportID_"' name='ShowDetail'>明细</button>"
}

Query FindInvFocusPrtList(InvNo As %Library.String = "", PatName As %Library.String = "", RegNo As %Library.String = "", User As %Library.String = "", BeginDate As %Library.String = "", EndDate As %Library.String = "", RPFlag As %Library.String = "", isApply As %Library.String = "", SelfOnlyFlag As %Library.String = "", EntryLoc As %Library.String = "", FocusPrint As %String = "", CardNo As %String = "", InvType As %String = "0", CTLocID As %String = "") As %Query(ROWSPEC = "RecordSum:%String,TRowId:%String,TInvNo:%String,TPatName:%String,TRegNo:%String,TAmount:%String,TFlag:%String,TUser:%String,TInvDate:%String,TRPFlag:%String,TRPDate:%String,TSex:%String,TAge:%String,TDropDate:%String,TAdmType:%String,TGIAdm:%String,TAccountAmount:%String,TRInvNo:%String,TPayMode:%String,TRoundInfo:%String,TCardType:%String,TCardNo:%String,Tsswr:%String")
{
}

///  d ##class(%ResultSet).RunQuery("web.DHCPE.INVFocusPrt","FindInvFocusPrtList","","","","","2018-05-10","","","","","","1","","1")
ClassMethod FindInvFocusPrtListExecute(ByRef qHandle As %Binary, InvNo As %Library.String = "", PatName As %Library.String = "", RegNo As %Library.String = "", User As %Library.String = "", BeginDate As %Library.String = "", EndDate As %Library.String = "", RPFlag As %Library.String = "", isApply As %Library.String = "", SelfOnlyFlag As %Library.String = "", EntryLoc As %Library.String = "", FocusPrint As %String = "", CardNo As %String = "", InvType As %String = "0", CTLocID As %String = "") As %Status
{
	new TRowId,TInvNo,TPatName,TRegNo,TAmount,TFlag,TUser,TInvDate,TRPFlag,TRPDate,TSex,TAge,TDropDate
	new paadm,admtype,patid,dob,giadmid
	new errs,i,hasdata
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	
	i BeginDate'=""  s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
	i EndDate'=""    s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
 	s PatName=##class(web.DHCPE.DHCPECommon).UnEscape(PatName)
 	
 	i $g(UserDR)="" d
 	.s:$D(%session) UserDR=%session.Get("LOGON.USERID")
 	.s:'$D(%session) UserDR=1021
 	
 	s ind=2
 	s FactAmount=0
	s AccountAmount=0
	s RoundFee=0
	s sswrAmount=0
	s errs=""
 	s i=1
 	s HospID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetHospIDByLocID(CTLocID)
 	/*
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
	else
	*/
	if ((BeginDate'="")||(EndDate'=""))
	{
		if (InvType=0)
		{
			if EndDate="" s EndDate=+$h
			if BeginDate="" s BeginDate=0
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
		else
		{
			if EndDate="" s EndDate=+$h
			if BeginDate="" s BeginDate=0
			s EndDate=EndDate+1
			s ARowID=""
			f  s EndDate=$o(^DHCPEAP(0,"Date",EndDate),-1) q:((EndDate="")||(EndDate<BeginDate))  d
			.f  s ARowID=$o(^DHCPEAP(0,"Date",EndDate,ARowID)) q:((ARowID=""))  d
			..s Sub=""
			..f  s Sub=$o(^DHCPEAP(0,"Date",EndDate,ARowID,Sub)) q:((Sub=""))  d
			...d ClearInvPrt
			...d GetAPInvPrt
			...q:hasdata'=1
			...d OutAPInvPrt
		}
	}	
	elseif RegNo'=""
	{
		if (InvType=0)
		{
			new regno,patid,admid
			s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
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
		else
		{
			//s RegNo=+RegNo
			i '$D(^DHCPEAP(0,"RegNo",RegNo)) d
			.s ARowID=0
			.f  s ARowID=$O(^DHCPEAP(0,"CardNo",RegNo,ARowID)) q:(ARowID="")  d
			..s Sub=""
			..f  s Sub=$o(^DHCPEAP(ARowID,"AC",Sub)) q:((Sub=""))  d
			...d ClearInvPrt
			...d GetAPInvPrt
			...q:hasdata'=1
			...d OutAPInvPrt
			e  d
			.s ARowID=0
			.f  s ARowID=$O(^DHCPEAP(0,"RegNo",RegNo,ARowID)) q:(ARowID="")  d
			..s Sub=""
			..f  s Sub=$o(^DHCPEAP(ARowID,"AC",Sub)) q:((Sub=""))  d
			...d ClearInvPrt
			...d GetAPInvPrt
			...q:hasdata'=1
			...d OutAPInvPrt
			
		}
	}
	elseif PatName'=""
 	{
	 	new patname,patid,admid
	 	s patname=$ZCVT(PatName,"U")
	 	s patname=$o(^PAPERi("PAPER_PatName",patname),-1)
	 	f  s patname=$o(^PAPERi("PAPER_PatName",patname)) q:((patname="")||(patname'[$ZCVT(PatName,"U")))  d
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
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	if (InvType=0)
 	{
	 	s ind=1 
		d ClearInvPrt
		s TRowId=""
		s TInvNo="合计"
		s TAmount=FactAmount
		s TAccountAmount=AccountAmount
		s RoundInfo=RoundFee
		s sswr=sswrAmount
		d OutInvPrt 
 	}
 	else
 	{
	 	s ind=1 
		d ClearInvPrt
		s TRowId=""
		s tpaymode=""
		s TInvNo="合计"
		s TAmount=FactAmount
		s sswr=0
		d OutAPInvPrt 
	}

 	
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
	//s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",paadm)
	s IsFeeLocFlag=$g(^DHCPESetting("DHCPE","IsFeeLocFlag",CTLocID)) ////是否按科室计费
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",paadm,CTLocID,IsFeeLocFlag)
  	q:(LocFlag=1)&&(EntryLoc'="0")
  	q:paadm=""	
	s patid=$p($g(^PAADM(paadm)),"^",1)
	if patid="" q
	s giadmid=$o(^DHCPEIADM(0,"PAADM",paadm,""))
	i giadmid'=""  d
	.s admtype="I"
	e  d
	.s admtype="G"
	.s giadmid=$o(^DHCPEGADM(0,"DelegateADM",paadm,""))
	s TPatName=$p($g(^PAPER(patid,"ALL")),"^",1)
	//s:InvName'="" TPatName=TPatName_"("_InvName_")"
	s TRegNo=$p($g(^PAPER(patid,"PAT",1)),"^",1)
	q:$ZCVT(TPatName,"U")'[$ZCVT(PatName,"U")
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
		    //s TAge=##class(web.DHCBillInterface).GetPapmiAge(patid,paadm)
			//s TAge=$p($zd(+$h,3),"-",1)-$p(dob,"-",1)
			s TAge=##class(web.DHCPE.DHCPECommon).GetPapmiAge(patid,HospID,CTLocID)
		}
	}
	s TInvNo=$p(InvData,"^",1)
	q:(FocusPrint="1")&&(InvNo'=TInvNo)&&(InvNo'="")
	s TFlag=$p(InvData,"^",8)
	s TFlag=..ParseInvFlag(TFlag)
	s TUser=$p(InvData,"^",10)
	//Q:(TUser'=UserDR)&&(SelfOnlyFlag=1)
	//User
	
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
	i TRPFlag="Y" S TRPFlag="是"
	e  s TRPFlag="否"
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
	q:(FocusPrint="2")&&(FocusPrintID="")
	i FocusPrintID'="" d
	.s RealInvNo=$LG(^User.DHCPEINVFocusPrtD(FocusPrintID),3)
	.;s TInvNo=TInvNo_"("_RealInvNo_")"
	.s TInvNo=RealInvNo_"("_TInvNo_")"
	//s TRInvNo=$p(DropInvData,"^",1)
	q:(FocusPrint="2")&&(InvNo'=RealInvNo)&&(InvNo'="")&&(RealInvNo'="")
	S tTFlag="0"		
	i hasDrop'=""
	{
		s DropInvData=$g(^DHCPEINVPRT(hasDrop))
		s TDropDate=$p(DropInvData,"^",11)
		if TDropDate'=""	s TDropDate=##class(websys.Conversions).DateLogicalToHtml(TDropDate)
		;s TFlag=$p(DropInvData,"^",8)
		;s TFlag=..ParseInvFlag(TFlag)
		S tTFlag="1" 
	}
	s flag=0
	i isApply=0 d
	.s:TFlag="作废" flag=1
	.s:TFlag="冲红" flag=1
	.s:tTFlag="1" flag=1
	i isApply=1 d
	.s:TFlag="作废" flag=1
	.s:TFlag="冲红" flag=1
	.q:TRowId=""
	.s:tTFlag="1" flag=1
	.s:'$D(^DHCPEDataEx("DHCPERefundApply","SelectIds",TRowId)) flag=1
	i isApply=2 d
	.s:TFlag="作废" flag=1
	.s:TFlag="冲红" flag=1
	.q:TRowId=""
	.s:$D(^DHCPEDataEx("DHCPERefundApply","SelectIds",TRowId)) flag=1
	
	q:flag=1	
	
	s TAmount=$p(InvData,"^",7)
	q:(FocusPrint="1")&&(TAmount<0)
	
	s sswr=0
	s sswr=$p(InvData,"^",21)
	//s TAmount=TAmount+sswr
	s TAmount=TAmount
	s FactAmount=FactAmount+TAmount
	;s TAccountAmount=..GetAccountAmountByInv(TRowId)
	;s AccountAmount=AccountAmount+TAccountAmount
	
	s hasdata=1	
	s TInvDate=TInvDate_" "_TInvTime
	q
GetAPInvPrt
	q:ARowID=""
	s AInvData=$G(^DHCPEAP(ARowID,"AC",Sub))
	q:1=##class(web.DHCPE.AdvancePayment).IsCurLocCard(ARowID,CTLocID)
	s Type=$p(AInvData,"^",1)
	q:(Type'="B")&&(Type'="R")
	s TInvNo=$p(AInvData,"^",4)
	q:TInvNo'=""
	S FocusPrtID=$O(^User.DHCPEINVFocusPrtI("IFPINVDRIndex"," "_ARowID_"||"_Sub,""))
	I FocusPrtID'="" S TInvNo=$LG(^User.DHCPEINVFocusPrtD(FocusPrtID),3)
	q:$D(^DHCPEAP(0,"SourceNo","RF",ARowID_"||"_Sub))
	q:(FocusPrint="1")&&(FocusPrtID'="")
	q:(FocusPrint="2")&&(FocusPrtID="")

	;q:$D(^DHCPEDataEx("InvFocusprt",ARowID_"||"_Sub))
	s TCardType=$p(^DHCPEAP(ARowID),"^",3)
	i TCardType="R" d
	.s TRegNo=$p($g(^DHCPEAP(ARowID)),"^",1)
	.q:TRegNo=""
	.s ID=$O(^PAPERi("PAPMI_PatNo",TRegNo,""))
	.q:ID=""
	.s TPatName=$P(^PAPER(ID,"ALL"),"^",1)
	.s Sex=$p($g(^PAPER(ID,"ALL")),"^",7)
	.s:Sex'="" TSex=$p($g(^CT("SEX",Sex)),"^",2)
    .;s TAge=##class(web.DHCBillInterface).GetPapmiAge(ID)
    .s TAge=##class(web.DHCPE.DHCPECommon).GetPapmiAge(ID,HospID,CTLocID)
    e  d
	.s TPatName=$p($G(^DHCPEDataEx("DHCPEAD","Info",ARowID)),"^",1)
	.s TSex=$p($G(^DHCPEDataEx("DHCPEAD","Info",ARowID)),"^",2)
	.s TAge=$p($G(^DHCPEDataEx("DHCPEAD","Info",ARowID)),"^",3)
	.i (TAge'["岁")&(TAge'="") S TAge=TAge_"岁"
	.s TRegNo=""

	s TCardNo=$p(^DHCPEAP(ARowID),"^",2)
	s sswr=0
	s TAmount=$p(AInvData,"^",2)
	s TUser=$p(AInvData,"^",7)
	i TUser'="" 
	{
		s TInis=$p($g(^SSU("SSUSR",TUser)),"^",1)
		s TUser=$p($g(^SSU("SSUSR",TUser)),"^",2)
		q:(User'="")&&(TInis'[User)&&(TUser'[User)
	}
	s TInvDate=$p(AInvData,"^",5)
	if TInvDate'=""	s TInvDate=##class(websys.Conversions).DateLogicalToHtml(TInvDate)
	
	i FocusPrint="1" d
	.s TRPFlag=""
	.s TRPFlag=$p(AInvData,"^",9)
	.i TRPFlag'="" s TRPFlag="是"
	.e  s TRPFlag="否"
	i FocusPrint="2" d
	.s TRPFlag=""
	.s TRPFlag=$LG(^User.DHCPEINVFocusPrtD(FocusPrtID),7)
	.i TRPFlag="Y" s TRPFlag="是"
	.e  s TRPFlag="否"
	

	i FocusPrint="1" d
	.s TRPDate=""
	.S TRPDate=$p(AInvData,"^",16)
	.if TRPDate'=""	s TRPDate=##class(websys.Conversions).DateLogicalToHtml(TRPDate)
	i FocusPrint="2" d
	.s TRPDate=""
	.S TRPDate=$LG(^User.DHCPEINVFocusPrtD(FocusPrtID),13)
	.if TRPDate'=""	s TRPDate=##class(websys.Conversions).DateLogicalToHtml(TRPDate)
	s mode=$p(AInvData,"^",10)
	s tpaymode=$p(^CT("CTPM",mode),"^",2)
	s tpaymode=tpaymode_":"_TAmount
	s:TCardType="R" TCardType="预缴金"
	s:TCardType="C" TCardType="代金卡"
	s FactAmount=FactAmount+TAmount
	s TRowID=ARowID_"||"_Sub
	s (TFlag,TDropDate,admtype,giadmid,TAccountAmount,TRInvNo,RoundInfo,sswr)=""
	s hasdata=1	
	
	q
OutAPInvPrt	
    set Data=$lb(0,TRowID,TInvNo,TPatName,TRegNo,$j(TAmount,3,2),TFlag,TUser,TInvDate,TRPFlag,TRPDate,TSex,TAge,TDropDate,admtype,giadmid,TAccountAmount,TRInvNo,tpaymode,RoundInfo,TCardType,TCardNo,$j(sswr,3,2))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	
	q
ClearInvPrt
	s hasdata=0
	s (TRowID,TInvNo,TPatName,TRegNo,TAmount,TFlag,TUser,TInvDate,TRPFlag,TRPDate,TSex,TAge,TDropDate,admtype,giadmid,TAccountAmount,RoundInfo,TRInvNo,TCardType,TCardNo,sswr)=""
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
    .s chequeno=$p(ss,"^",4)   
    .i mode'="" s pmdesc=$p(^CT("CTPM",mode),"^",2)
    .e  s pmdesc="现金"
    .;s pdamt=+$p(ss,"^",3)+sswr
    .s pdamt=+$p(ss,"^",3)
    .s pdamt=$fn(pdamt,"",2)
    .s:chequeno'="" pdamt=pdamt_"("_chequeno_")"
    .i tpaymode="" s tpaymode=pmdesc_":"_pdamt
    .e  s tpaymode=tpaymode_","_pmdesc_":"_pdamt
     
     s sswrAmount=sswrAmount+$P($G(^DHCPEINVPRT(TRowId)),"^",21)
	}
	i ind>1 d
	.s RoundInfo=##class(web.DHCPE.CashierEx).GetRoundFee(TRowId)
	.s RoundFeeLength=$L(RoundInfo,"$$")
	.f i=1:1:RoundFeeLength  d
	..s OneInfo=$P(RoundInfo,"$$",i)
	..s OneFee=+$P(OneInfo,"^",3)
	..s RoundFee=RoundFee+OneFee
	s TCardType=""
	set Data=$lb(0,TRowId,TInvNo,TPatName,TRegNo,$j(TAmount,3,2),TFlag,TUser,TInvDate,TRPFlag,TRPDate,TSex,TAge,TDropDate,admtype,giadmid,TAccountAmount,TRInvNo,tpaymode,RoundInfo,TCardType,"",$j(sswr,3,2))
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

ClassMethod FindInvFocusPrtListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInvFocusPrtListExecute ]
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

ClassMethod FindInvFocusPrtListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInvFocusPrtListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Description: 集中打印获取发票信息
/// debug：w ##class(web.DHCPE.INVFocusPrt).GetInvoiceInfo()
ClassMethod GetInvoiceInfo(InvID, InvInfo, Type, locid As %String = "", UserID As %String = "")
{
	q:InvID="" ""
	s APID=$p(InvID,"||",1)
	s Sub=$p(InvID,"||",2)
	s Fee=$p($G(^DHCPEAP(APID,"AC",Sub)),"^",2)
	s RegNo=$p($G(^DHCPEAP(APID)),"^",1)

	
	s (defaultfeeid,defaultfeename)=""
	d ##class(web.DHCPE.Cashier).GetDefaultFee(.defaultfeeid,.defaultfeename,.locid)

	if Type=2
	{   
		//s invcolSet=^DHCPESetting("DHCPE","InvColSortType")
		s invcolSet=^DHCPESetting("DHCPE","InvColSortType",locid)
		s Fee=$j(Fee,3,2)
		//s Info=defaultfeename_"^"_Fee_"^1^"_Fee_"^^^^"
		i invcolSet=1 s Info=defaultfeename_"^"_Fee_"^"_1_"^"_Fee
		i invcolSet=2 s Info=defaultfeename_"^"_"次"_"^"_1_"^"_Fee
		i invcolSet=3 s Info=defaultfeename_"^"_"次"_"^"_1_"^"_Fee_"^"_Fee
	
	}
	
	else
	{  
		//发票号
		s InvNo=$p(InvInfo,"^",1)
		//发票人
		s username=""
		s userno=$p($G(^DHCPEAP(APID,"AC",Sub)),"^",7)
		if userno'=""   d
		.s username=$p($g(^SSU("SSUSR",userno)),"^",2)
		.s userno=$p($g(^SSU("SSUSR",userno)),"^",1)
		//发票日期
		s invdate=$p($G(^DHCPEAP(APID,"AC",Sub)),"^",5)
		i invdate'="" s invdate=$zd(invdate,3)
		//金额大写
		s hzamount=##Class(web.DHCPE.DHCPEPAY).RMBDXXZH("","",Fee)
		//金额
		s amount=$j(Fee,3,2)
		//支付方式
	
		s paymode="" 
		s paymode=$p($G(^DHCPEAP(APID,"AC",Sub)),"^",10)
		i paymode'="" s paymode=$p($g(^CT("CTPM",paymode)),"^",2)
		//基本信息
		
		s AType=$p($G(^DHCPEAP(APID)),"^",3)
		
		i RegNo'=""
		{  
			s patid=$O(^PAPERi("PAPMI_PatNo",RegNo,0))
			s patname=$p($g(^PAPER(patid,"ALL")),"^",1)
		
			s age=""
			s sex=""
			s pattype=""
			s compony=""
			s sex=$p($g(^PAPER(patid,"ALL")),"^",7)
			if sex'="" s sex=$p($g(^CT("SEX",sex)),"^",2)
			s dob=$p($g(^PAPER(patid,"ALL")),"^",6)
			if dob'=""
		
			{
					
				s dob=$zd(dob,3)
				s age=$p($zd(+$h,3),"-",1)-$p(dob,"-",1)
			}
			s pattype=$p($g(^PAPER(patid,"PER",5)),"^",1)
			i pattype'="" s pattype=$P($G(^CT("SS",pattype)),"^",2)
		}
		else
		{
			s patid=""
			s patStr=$G(^DHCPEDataEx("DHCPEAD","InvID",APID_"||"_Sub))
			s patname=$p(patStr,"^",1)
			s age=$p(patStr,"^",3)
			s sex=$p(patStr,"^",2)
			s pattype=""
			s compony=""
			
		}
		s InvName=$p(InvInfo,"^",2)
		i InvName'="" s patname=InvName
		//$p($G(^DHCACD("AccM",+DepositID,"AccPD",$p(DepositID,"||",2))),"^",3)
		s c=$c(2)
		s rtn="PatName"_c_patname        
		s rtn=rtn_"^"_"RegNo"_c_RegNo
		s rtn=rtn_"^"_"PAAdm"_c_"" 
		
		s rtn=rtn_"^"_"FB1"_c_defaultfeename
		s rtn=rtn_"^"_"FBSum1"_c_amount
		
		s rtn=rtn_"^"_"PaySumAll"_c_hzamount_" "_amount
		s rtn=rtn_"^"_"PaySumPY"_c_hzamount
		s rtn=rtn_"^"_"PaySum"_c_amount_" 元"
		s rtn=rtn_"^"_"PayMode"_c_paymode
		
		s rtn=rtn_"^"_"OpenID"_c_userno    
		s rtn=rtn_"^"_"OpenName"_c_username  
		s rtn=rtn_"^"_"InvNo"_c_InvNo
		
		s rtn=rtn_"^"_"Date"_c_invdate
		s rtn=rtn_"^"_"Year"_c_$p(invdate,"-",1)
		s rtn=rtn_"^"_"Month"_c_$p(invdate,"-",2)
		s rtn=rtn_"^"_"Day"_c_$p(invdate,"-",3)
		
		s rtn=rtn_"^"_"Sex"_c_sex  
		s rtn=rtn_"^"_"Age"_c_age  
		s rtn=rtn_"^"_"Type"_c_pattype  
		s rtn=rtn_"^"_"Company"_c_compony  
	    s ^DHCPEDataEx("Invprt",InvID)=$h_"^"_UserID  //记录打印发票时间^操作人
		///s rtn=patname_"^"_regno_"^"_amount_"^"_hzamount_"^"_invdate_"^"_userno
		s Info=rtn
	}
	q Info
}

}
