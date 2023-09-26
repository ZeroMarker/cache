Import sqluser

/// 	门诊医保结算审核
/// 	xubaobao
/// 	2020 04 21
Class web.INSUOPDivideAudit Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 	获取一段时间内的发票信息
/// d ##class(%ResultSet).RunQuery("web.INSUOPDivideAudit","OPDivAuditApp","2022-07-31","2022-09-30","0000000291","","Y")
Query OPDivAuditApp(StartDate, EndDate, RegNo, InvNo, CPPFlag) As %Query(ROWSPEC = "Tind,TInvNo,TInvId,TRegNo,TPatName,TPatID,TTotalAmout:%Double,TInvDate,TInvTime,TInsuMark")
{
}

ClassMethod OPDivAuditAppExecute(ByRef qHandle As %Binary, StartDate, EndDate, RegNo, InvNo, CPPFlag) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s i=0
 	
 	i StartDate="" s StartDate=+$H
	i EndDate="" s EndDate=+$H
	s TInsuMark="N"
	
	s ^TMP("OPDivAuditApp")=$lb(StartDate, EndDate, RegNo, InvNo, CPPFlag)
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s Tind="0"
	s PrtRowid="" 
	s StrPrtRowid=""
 	i CPPFlag="Y" d
 	.f Date=StartDate:1:EndDate d    //EndDate  StartDate 
	..s InvTapDr="",TInvNo="",TInsuMark=""
	..f  s InvTapDr=$o(^DHCINVPRTAPi(0,"Date",Date,InvTapDr)) q:InvTapDr=""  d
	...s TInvNo=$p(^DHCINVPRTAP(InvTapDr),"^",6)
	...q:(TInvNo'=InvNo)&&(InvNo'="")
	...s Papmi=$p($g(^DHCINVPRTAP(InvTapDr)),"^",11)	//病人ID
	...s TPatName=$p(^PAPER(Papmi,"ALL"),"^",1)	//病人姓名
	...s TRegNo=$p(^PAPER(Papmi,"PAT",1),"^",1)  //登记号
	...q:(TRegNo'=RegNo)&&(RegNo'="")
	...s TPatID=$p(^PAPER(Papmi,"ALL"),"^",9)	//身份证号
	...s TTotalAmout=$fn($p(^DHCINVPRTAP(InvTapDr),"^",1),"",2)  //发票金额
	...s TInvDate=$p(^DHCINVPRTAP(InvTapDr),"^",3)		//收费日期
	...s TInvFlag=$p(^DHCINVPRTAP(InvTapDr),"^",2)		//状态
	...q:TInvFlag'="N"
	...s:TInvDate'="" TInvDate=$zd(TInvDate,3)
	...s TInvTime=$p(^DHCINVPRTAP(InvTapDr),"^",4)		//收费时间
	...s:TInvTime'="" TInvTime=$zt(TInvTime,1)
	...s Tind=Tind+1
	...b ;zw InvTapDr
	...s AcpDr="",PrtRowidStr="",InsuFlag="",Zstr07=""
	...f  s AcpDr=$o(^DHCINVPRTCAPi(0,"APINVDR",InvTapDr,AcpDr)) q:(AcpDr="")!(InsuFlag="I")  d
	....s TInsuMark=""
	....s PrtRowid=$p(^DHCINVPRTCAP(AcpDr),"^",1)    //发票ID
	....b ;zw PrtRowid
	....s flag=##class(web.INSUOPDivideAudit).GetFlagByInv(PrtRowid)
	....i flag="Y" d
	.....s TInsuMark="Y"
	....;add by xubaobao 2020 04 24 获取医保结算标识--------------
	....s AudDr=$o(^INSUDIVAUD(0,"INV",PrtRowid,""))
	....i AudDr="" d 
	.....s DivDr=##class(web.INSUOPDivideAudit).GetDivIdByinvprt(PrtRowid)
	.....q:DivDr=""
	.....s InsuFlag=$p($g(^DHCINDIV(DivDr)),"^",5)
	....s:PrtRowidStr'="" PrtRowidStr=PrtRowidStr_"^"_PrtRowid
	....s:PrtRowidStr="" PrtRowidStr=PrtRowid
	....b ;zw PrtRowidStr
	....s TInvId=PrtRowidStr
	...q:(InsuFlag="I")		;已经做过医保结算的不在统计
 	...d Build1
 	e   d
	.f Date=StartDate:1:EndDate d
	..s PrtRowid="",TInvNo="",InvDrStr="",Zstr07="",TInsuMark=""
	..f  s PrtRowid=$o(^DHCINVPRT(0,"Date",Date,PrtRowid)) q:PrtRowid=""  d    //走发票表
	...;b ;zw PrtRowid
	...s TInvNo="",TInvId="",TRegNo="",TPatName="",TPatID="",TTotalAmout="",TInvDate="",TInvTime="",TInsuMark="",InsuFlag=""
	...s TInvId=PrtRowid
	...s TInvNo=$p(^DHCINVPRT(PrtRowid),"^",14) 	//发票号
	...q:(TInvNo'=InvNo)&&(InvNo'="")
	...s Flag=$p(^DHCINVPRT(PrtRowid),"^",8)     //结算状态
	...s AccInvDr=$p(^DHCINVPRT(PrtRowid),"^",4)
	
	...b ;zw AccInvDr
	...q:AccInvDr'=""   						    //过滤集中打印发票的数据
	...q:TInvNo=""			//过滤没有发票号的数据
	...b ;zw 2
	...s InsDivDr=$p(^DHCINVPRT(PrtRowid),"^",30)
	...q:InsDivDr'=""  								//门诊收费做过医保结算的数据过滤
	...s Papmi=$p(^DHCINVPRT(PrtRowid),"^",15)	//病人ID
	...s TPatName=$p(^PAPER(Papmi,"ALL"),"^",1)	//病人姓名
	...s TRegNo=$p(^PAPER(Papmi,"PAT",1),"^",1)  //登记号
	...b ;zw 5
	...q:(TRegNo'=RegNo)&&(RegNo'="")
	...s flag=##class(web.INSUOPDivideAudit).GetFlagByInv(PrtRowid)
	...b ;zw 3
	...i flag="Y" d
	....s TInsuMark="Y"
	...;add by xubaobao 2020 04 24 获取医保结算标识--------------
	...s AudDr=$o(^INSUDIVAUD(0,"INV",PrtRowid,""))
	...b ;zw 4
	...i AudDr'="" d 
	....s DivDr=##class(web.INSUOPDivideAudit).GetDivIdByinvprt(PrtRowid)
	....q:DivDr=""
	....s InsuFlag=$p($g(^DHCINDIV(DivDr)),"^",5)
	...i AudDr="" d 
	....s DivDr=##class(web.INSUOPDivideAudit).GetDivIdByinvprt(PrtRowid)
	....q:DivDr=""
	....s InsuFlag=$p($g(^DHCINDIV(DivDr)),"^",5)
	...q:(InsuFlag="I")			;已经做过医保结算的不在统计..
	...;add by xubaobao 2020 04 24 获取医保结算标识--------------
	
	...s TPatID=$p(^PAPER(Papmi,"ALL"),"^",9)	//身份证号
	...s TTotalAmout=$fn(+$p(^DHCINVPRT(PrtRowid),"^",1),"",2)  //发票金额
	...s TInvDate=$p(^DHCINVPRT(PrtRowid),"^",5)		//收费日期
	...s:TInvDate'="" TInvDate=$zd(TInvDate,3)
	...s TInvTime=$p(^DHCINVPRT(PrtRowid),"^",20)		//收费时间
	...s:TInvTime'="" TInvTime=$zt(TInvTime,1)
	...s Tind=Tind+1
 	...d Build1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build1    
	set Data=$lb(Tind,TInvNo,TInvId,TRegNo,TPatName,TPatID,TTotalAmout,TInvDate,TInvTime,TInsuMark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod OPDivAuditAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPDivAuditAppExecute ]
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
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod OPDivAuditAppClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPDivAuditAppExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 根据发票ID获取医嘱信息
/// d ##class(%ResultSet).RunQuery("web.INSUOPDivideAudit","OPOEListAuditApp","50588")
Query OPOEListAuditApp(PrtRowidStr) As %Query(ROWSPEC = "TOEind,TCoverMainIns,TOEID,TOEDesc,TInsuxmmc,TInsuxmdj,TOEDept,TOEDate,TOEDoctor,TOEPrice,TOEQty,TOEAmt,BillDr,Insubz")
{
}

ClassMethod OPOEListAuditAppExecute(ByRef qHandle As %Binary, PrtRowidStr) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s i=0
 	
 	q:PrtRowidStr="" $$$OK
 	 s ^tmpOPOEListAuditApp=$lb(PrtRowidStr)
	s TOEind="0"
	s (TCoverMainIns,TOEID,TOEDesc,TInsuxmmc,TInsuxmdj,TOEDept,TOEDate,TOEDoctor,TOEPrice,TOEQty,TOEAmt,BillDr)=""
	
	f i=1:1:$l(PrtRowidStr,"^") d
	.s PrtRowid=$p(PrtRowidStr,"^",i)
	.s BCIDr=$o(^DHCBCI(0,"INV",PrtRowid,""))
	.q:BCIDr=""
	.s PaadmDr=$p(^DHCBCI(BCIDr),"^",3)		;就诊号
	.s BillDr=$p(^DHCBCI(BCIDr),"^",2)		;账单号
	.b ;zw BillDr
	.s PaadmInfo=$g(^PAADM(PaadmDr))
	.q:PaadmInfo=""
	.s visitstatus=$p($g(^PAADM(PaadmDr)),"^",20)
	.q:(visitstatus="")||(visitstatus="C")
	
	.s CTLocDr=$p($g(^PAADM(PaadmDr)),"^",4)
	.i CTLocDr="" d
	..s TOEDept=""
	.e  d
	..s TOEDept=$p(^CTLOC(CTLocDr),"^",2)
	
	
	.s OEORDDr=""
	.s PBOSub=0
	.f  s PBOSub=$o(^DHCPB(BillDr,"O",PBOSub)) q:PBOSub=""  d
	..s OEORIRowId=$p(^DHCPB(BillDr,"O",PBOSub),"^",4)
	..s OEORDDr=$p(OEORIRowId,"||",1)
	..s OEORIDr=$p(OEORIRowId,"||",2)
	..s TOEID=OEORIRowId					;医嘱ID
	..s TOEDate=$p($g(^OEORD(OEORDDr,"I",OEORIDr,3)),"^",7)		;7开医嘱日期
	..s TOETime=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",17)		;8开医嘱时间
	..s TOEDate=$zd(TOEDate,3)
	..s TOETime=$zt(TOETime,1)
	..s TOEDoctorDr=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",11)	
	..i TOEDoctorDr="" d
	...s TOEDoctorDr=""
	..e  d
	...s TOEDoctor=$p($g(^CTPCP(TOEDoctorDr,1)),"^",2)		;9开医嘱医生
	..s TOEQty=$p(^DHCPB(BillDr,"O",PBOSub),"^",5)
	..s ItmMastDR=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",2)
	..s TOEPrice=$p(^DHCPB(BillDr,"O",PBOSub),"^",7)
	..s TOEPrice=$fn(TOEPrice,"",2)								;10医嘱单位价格	
	..s TOEAmt=$fn($p(^DHCPB(BillDr,"O",PBOSub),"^",8),"",2)						;12医嘱总价   
	..s TOEDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)			;13医嘱名称
	..s TCoverMainIns=$p($g(^OEORD(OEORDDr,"I",OEORIDr,3)),"^",3)	;add by xubaobao 2020 04 02
  	..s:TCoverMainIns'="Y" TCoverMainIns="N"
  	..s InsuTarStr=##class(web.DHCINSUPort).ArcimLinkInsu(ItmMastDR,"48",2)
  	..s TInsuxmdj=$p(InsuTarStr,"^",1)
  	..s:(TInsuxmdj="-1")||(TInsuxmdj="-3")||(TInsuxmdj="-2") TInsuxmdj=""
  	..s TInsuxmmc=$p(InsuTarStr,"^",10)
  	..s Insubz=""
	..s Insubz=$p(InsuTarStr,"^",3)
	..;s Insubz=$p(Insubz,"|",2)
	..s TOEind=TOEind+1
 	..d Build2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build2    
	set Data=$lb(TOEind,TCoverMainIns,TOEID,TOEDesc,TInsuxmmc,TInsuxmdj,TOEDept,TOEDate,TOEDoctor,TOEPrice,TOEQty,TOEAmt,BillDr,Insubz)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod OPOEListAuditAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPOEListAuditAppExecute ]
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
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod OPOEListAuditAppClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPOEListAuditAppExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 根据医嘱ID获取收费项目
/// d ##class(%ResultSet).RunQuery("web.INSUOPDivideAudit","OPItmListAuditApp","65186","7311308||5")
Query OPItmListAuditApp(BillDr, OeOrdDr) As %Query(ROWSPEC = "TItmind,TarID,TarCode,TarDesc,InsuItmID,InsuCode,InsuDesc,Insuxmdj,ItmPrice,ItmQty,ItmAmt")
{
}

ClassMethod OPItmListAuditAppExecute(ByRef qHandle As %Binary, BillDr, OeOrdDr) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s i=0
 	
 	S ^TMP("WEBINSUOPDIVAUDIT","OPItmListAuditApp")=BillDr_"^"_OeOrdDr
 	q:OeOrdDr="" $$$OK
 	q:BillDr="" $$$OK
 	
 	s InsuType="00A"
	s TItmind="0"
	
	;s OEORIRowId=$p(OeOrdDr,"||",1)
	;s OEORIChildsub=$p(OeOrdDr,"||",2)
	;s ArcimRowid=$p(^OEORD(OEORIRowId,"I",OEORIChildsub,1),"^",2)
	
	s PBOSub="0"
	f  s PBOSub=$o(^DHCPBi(0,"OEORI",OeOrdDr,BillDr,PBOSub)) q:PBOSub=""  d
	.s PBDSub="0"
	.f  s PBDSub=$o(^DHCPB(BillDr,"O",PBOSub,"D",PBDSub)) q:PBDSub=""  d
	..s (TItmind,TarID,TarCode,TarDesc,InsuItmID,InsuCode,InsuDesc,Insuxmdj,ItmPrice,ItmQty,ItmAmt)=""
	..s mCurrRowPatBillDetails=$g(^DHCPB(BillDr,"O",PBOSub,"D",PBDSub)) 
	..q:mCurrRowPatBillDetails=""
	..s ItmQty=$p(mCurrRowPatBillDetails,"^",5)
	..s ItmPrice=$p(mCurrRowPatBillDetails,"^",4)
	..s ItmAmt=$p(mCurrRowPatBillDetails,"^",7)
	..s TarID=$p(mCurrRowPatBillDetails,"^",3)
	..s TarString=$$GetTarDetail^DHCINSUTarContrast(TarID)
	..s TarCode=$p(TarString,"^",2)
	..s TarDesc=$p(TarString,"^",3)
	..s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",InsuType,2),"^",6)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
 	..s InsuString=$$GetConInfo^DHCINSUTarContrast(TarID,InsuType,$zd(+$h,3),TariInsuFlag,2)
 	..i InsuString'="" d
	...s InsuItmID=$p(InsuString,"^",1)
	...s InsuCode=$p(InsuString,"^",3)
	...s InsuDesc=$p(InsuString,"^",4)
	...s lb=$p(InsuString,"^",23)
	...s Insuxmdj=##class(web.DHCINSUPort).RtnDicDescByDicCode("chrgitm_lv00A",lb,2)
	..s TItmind=TItmind+1
 	..d Build3
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build3    
	set Data=$lb(TItmind,TarID,TarCode,TarDesc,InsuItmID,InsuCode,InsuDesc,Insuxmdj,ItmPrice,ItmQty,ItmAmt)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod OPItmListAuditAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPItmListAuditAppExecute ]
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
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod OPItmListAuditAppClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPItmListAuditAppExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.INSUOPDivideAudit).UpdateOECoverMain("1863908||1","N")
ClassMethod UpdateOECoverMain(OEORIRowIdStr As %String = "", State As %String = "Y") As %String
{
	////存储医嘱表审核数据 OEORIRowIdStr 医嘱表rowid串  State "Y" 医保  "N" 自费 
	;n (TabOEORIRowIdStr,State,Guser)
	q:OEORIRowIdStr="" 0
	s SQLCODE="-1"
	s len=$L(OEORIRowIdStr,"^")
	f i=1:1:len d
	.s OEORIRowId=$P(OEORIRowIdStr,"^",i)
	.q:OEORIRowId=""
	.&SQL(UpDate OE_OrdItem set OEORI_CoverMainIns=:State WHERE OEORI_RowId=:OEORIRowId)
	
	q SQLCODE
}

/// 	获取一段时间内的医保结算信息
Query OPDivInfo(StartDate, EndDate, RegNo, Guser) As %Query(ROWSPEC = "TRowid,TFlag,TRegNo,TPatName,TPatID,TAmt,TDate,TTime,Tjjzfe,Tzhzfe,Tgrzfe,TUserID,TUserName,Tdjlsh")
{
}

/// d ##class(%ResultSet).RunQuery("web.INSUOPDivideAudit","OPDivInfo","17/10/2021","20/10/2021","0001306039","1019")
ClassMethod OPDivInfoExecute(ByRef qHandle As %Binary, StartDate, EndDate, RegNo, Guser) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s i=0
 	
 	i StartDate="" s StartDate=+$H
	i EndDate="" s EndDate=+$H
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	;s ^tmp("OPDivInfo")=$lb(StartDate,EndDate,RegNo,Guser)
	s Tind="0"
	f Date=StartDate:1:EndDate d
	.s DivDr=""
	.f  s DivDr=$o(^DHCINDIV("0","IDate",Date,DivDr)) q:DivDr=""  d
	..s (TRowid,TFlag,TRegNo,TPatName,TPatID,TAmt,TDate,TTime,Tjjzfe,Tzhzfe,Tgrzfe,TUserID,TUserName,Tdjlsh)=""
	..s DivInfo=$g(^DHCINDIV(DivDr))
	..q:DivInfo=""
	..s Flag=$p(DivInfo,"^",5)
	..s AdmDr=$p(DivInfo,"^",1)
	..q:Flag'="I"					//过滤未结算数据
	..s Zstr05=$p(DivInfo,"^",40)
	..;b ;zw Zstr05    
	..;q:Zstr05'="INSU"				//过滤自费患者按医保结算的数据
	..;b ;zw 1
	..s Zstr08=$p(DivInfo,"^",43)
	..q:Zstr08'="INSU"				//过滤不是事后医保结算的数据 +HanZH 20221104
	..s TRowid=DivDr
	..s TFlag=$case(Flag,"I":"正常","S":"退费",:"")
	..s Papmi=$p(^PAADM(AdmDr),"^",1)
	..s TPatName=$p(^PAPER(Papmi,"ALL"),"^",1)	//病人姓名
	..s TRegNo=$p(^PAPER(Papmi,"PAT",1),"^",1)  //登记号
	..s TPatID=$p(^PAPER(Papmi,"ALL"),"^",9)	//身份证号
	..q:(TRegNo'=RegNo)&&(RegNo'="")
	..b ;zw RegNo
	..s Tdjlsh=$p(DivInfo,"^",8)
	..s TDate=$p(DivInfo,"^",16)		//结算日期
	..s:TDate'="" TDate=$zd(TDate,3) 
	..s TTime=$p(DivInfo,"^",17)		//结算时间
	..s:TTime'="" TTime=$zt(TTime,1) 
	..s TAmt=$p(DivInfo,"^",7)		 //总金额
	..s Tjjzfe=$p(DivInfo,"^",19)    //基金支付
	..s Tzhzfe=$p(DivInfo,"^",28)	 //账户支付
	..s Tgrzfe=$p(DivInfo,"^",15)    //现金支付
	..s TUserID=$p(DivInfo,"^",21)	 //结算人ID
	..;q:(TUserID'=Guser)&&(Guser'="")			//过滤非当前操作员的数据
	..s:TUserID'="" TUserName=$p($g(^SSU("SSUSR",TUserID)),"^",2)
 	..d Build5
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build5    
	set Data=$lb(TRowid,TFlag,TRegNo,TPatName,TPatID,TAmt,TDate,TTime,Tjjzfe,Tzhzfe,Tgrzfe,TUserID,TUserName,Tdjlsh)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod OPDivInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPDivInfoExecute ]
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
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod OPDivInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPDivInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.INSUOPDivideAudit).GetDivIdByinvprt("11214113")
ClassMethod GetDivIdByinvprt(invprt As %String) As %String
{
	s DivDr=""
	s TRowid=""
	f  s DivDr=$o(^DHCINDIV("0","DHCInvPrt",invprt,DivDr)) q:DivDr=""  d
	.s DivInfo=$g(^DHCINDIV(DivDr))
	.q:DivInfo=""
	.s Flag=$p(DivInfo,"^",5)
	.s AdmDr=$p(DivInfo,"^",1)
	.q:Flag'="I"				
	.s TRowid=DivDr
	q TRowid
}

/// w ##class(web.INSUOPDivideAudit).GetFlagByInv("10937")
ClassMethod GetFlagByInv(Prtinv)
{
	n (Prtinv)
	s Rowid="" 
	s flag="N"
	f  s Rowid=$o(^DHCBCI(0,"INV",Prtinv,Rowid)) q:Rowid=""  d
	.s DataInfo=$g(^DHCBCI(Rowid))
	.s BillNo=$p(DataInfo,"^",2)
	.s flag1=$d(^DHCINDIS("0","PBDr",BillNo))
	.i flag1="10" d
	..s Rid=""
	..s Rid=$o(^DHCINDIS("0","PBDr",BillNo,-1))
	..s Divsub=$g(^DHCINDIS(Rid))
	..s UpFlag=$p(Divsub,"^","18")
	..i UpFlag="N" d
	...s flag="Y"
	q flag
}

}
