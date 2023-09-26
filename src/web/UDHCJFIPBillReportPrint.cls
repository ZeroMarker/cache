Class web.UDHCJFIPBillReportPrint Extends %RegisteredObject [ Not ProcedureBlock ]
{

Query FindZYJSHzInfo(stDate, endDate, hospDr, CatType, DateType) As websys.Query(ROWSPEC = "footUser:%String,footDate:%String,CatDesc:%String,type:%String,footAmt:%Float") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.UDHCJFIPBillReportPrint","FindZYJSHzInfo","62825","62829","","ACCat")
ClassMethod FindZYJSHzInfoExecute(ByRef qHandle As %Binary, stDate, endDate, hospDr, CatType, DateType) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    set job=$j
    k ^TMP("DHCIPJSHZ",job)
 	i DateType=1 d
 	.f pdate=stDate:1:endDate d
	..s prtrowid="0" 
	..f  s prtrowid=$o(^DHCINVPRTZY(0,"DATE",pdate,prtrowid)) q:prtrowid=""  d
	...s s=^DHCINVPRTZY(prtrowid)
	...s prtuser=$p(s,"^",7)
	...s invno=$p(s,"^",1)
	...s oldrowid=$p(s,"^",13)
	...s prtdate=$p(s,"^",2)
	...s prtstatus=$p(s,"^",8)
	...q:prtstatus="A"
	...s deposit=$p(s,"^",22)
	...s admno=$p(s,"^",4)
	...s billno=$p(s,"^",5) 
	...s printtime=$p(s,"^",3)  ;yyx
	...s prttime=$zt($p(s,"^",3))
	...i +deposit'=0  s ^TMP("DHCIPJSHZ",job,prtuser,prtdate,"PayM",1000)=$g(^TMP("DHCIPJSHZ",job,prtuser,prtdate,"PayM",1000))+deposit ;冲预交金写死1000
	...d ..GetIPBill(job,prtuser,prtdate,billno,CatType)
	...s arrcp=""
	...f  s arrcp=$o(^ARRCP("ARPBL",billno,arrcp)) q:arrcp=""  d
	....s arral="" 
	....f  s arral=$o(^ARRCP("ARPBL",billno,arrcp,arral)) q:arral=""  d
	.....s s=^ARRCP(arrcp,"RAL",arral),type=$p(s,"^",9),m1=+$p(s,"^",2),billnum=+$p(s,"^",18)   ;type->ARRAL_Deposit_DR(押金类型) billno->ARRAL_ARPBIL_DR
	.....i type="" d
	......s paym="0"
	......f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d
	.......s ss=^ARRCP(arrcp,"PAYM",paym) q:ss=""
	.......s mode=$p(ss,"^",1) q:$g(mode)=""
	.......s m2=$p(ss,"^",3) q:$g(m2)=""
	.......s paydesc=$p(^CT("CTPM",mode),"^",2)
 	.......s ^TMP("DHCIPJSHZ",job,prtuser,prtdate,"PayM",mode)=$g(^TMP("DHCIPJSHZ",job,prtuser,prtdate,"PayM",mode))+m2
 	e  d
 	.f pdate=stDate:1:endDate d
	..s prtrowid="0" 
	..f  s prtrowid=$o(^DHCINVPRTZY(0,"HANDDATE",pdate,prtrowid)) q:prtrowid=""  d
	...s s=^DHCINVPRTZY(prtrowid)
	...s prtuser=$p(s,"^",7)
	...s invno=$p(s,"^",1)
	...s oldrowid=$p(s,"^",13)
	...s prtdate=$p(s,"^",15)
	...s prtstatus=$p(s,"^",8)
	...q:prtstatus="A"
	...s deposit=$p(s,"^",22)
	...s admno=$p(s,"^",4)
	...s billno=$p(s,"^",5) 
	...s printtime=$p(s,"^",3)  ;yyx
	...s prttime=$zt($p(s,"^",3))
	...i +deposit'=0  s ^TMP("DHCIPJSHZ",job,prtuser,prtdate,"PayM",1000)=$g(^TMP("DHCIPJSHZ",job,prtuser,prtdate,"PayM",1000))+deposit ;冲预交金写死100
	...d ..GetIPBill(job,prtuser,prtdate,billno,CatType)
	...s arrcp=""
	...f  s arrcp=$o(^ARRCP("ARPBL",billno,arrcp)) q:arrcp=""  d
	....s arral="" 
	....f  s arral=$o(^ARRCP("ARPBL",billno,arrcp,arral)) q:arral=""  d
	.....s s=^ARRCP(arrcp,"RAL",arral),type=$p(s,"^",9),m1=+$p(s,"^",2),billnum=+$p(s,"^",18)   ;type->ARRAL_Deposit_DR(押金类型) billno->ARRAL_ARPBIL_DR
	.....i type="" d
	......s paym="0"
	......f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d
	.......s ss=^ARRCP(arrcp,"PAYM",paym) q:ss=""
	.......s mode=$p(ss,"^",1) q:$g(mode)=""
	.......s m2=$p(ss,"^",3) q:$g(m2)=""
	.......s paydesc=$p(^CT("CTPM",mode),"^",2)
 	.......s ^TMP("DHCIPJSHZ",job,prtuser,prtdate,"PayM",mode)=$g(^TMP("DHCIPJSHZ",job,prtuser,prtdate,"PayM",mode))+m2
	s myprtUser="",type="PayM"
 	f  s myprtUser=$o(^TMP("DHCIPJSHZ",job,myprtUser)) q:myprtUser=""  d
 	.s footUser=$p(^SSU("SSUSR",myprtUser),"^",2)
 	.s myDate=""
 	.f  s myDate=$o(^TMP("DHCIPJSHZ",job,myprtUser,myDate)) q:myDate=""  d
 	..s footDate=$zd(myDate,3)
 	..s CatDr=""
 	..f  s CatDr=$o(^TMP("DHCIPJSHZ",job,myprtUser,myDate,"PayM",CatDr)) q:CatDr=""  d
 	...s footAmt=$g(^TMP("DHCIPJSHZ",job,myprtUser,myDate,"PayM",CatDr))
 	...i CatDr=1000 s CatDesc="冲预交金"
 	...e  s CatDesc=$p($g(^CT("CTPM",CatDr)),"^",2)
 	...d OutputRow8
 	i CatType="IPCat" d
 	.s CatDr=0,type="IPCat"
 	.f  s CatDr=$o(^DHCTarC("TIC",CatDr)) q:CatDr=""  d
 	..s CatDesc=$p(^DHCTarC("TIC",CatDr),"^",2)
 	..s myprtUser=""
 	..f  s myprtUser=$o(^TMP("DHCIPJSHZ",job,myprtUser)) q:myprtUser=""  d
 	...s footUser=$p(^SSU("SSUSR",myprtUser),"^",2)
 	...s myDate=""
 	...f  s myDate=$o(^TMP("DHCIPJSHZ",job,myprtUser,myDate)) q:myDate=""  d
 	....s footDate=$zd(myDate,3)
 	....s footAmt=$g(^TMP("DHCIPJSHZ",job,myprtUser,myDate,"IPCat",CatDr))
 	....d OutputRow8
 	i CatType="ACCat" d
 	.s CatDr=0,type="ACCat"
 	.f  s CatDr=$o(^DHCTarC("TAC",CatDr)) q:CatDr=""  d
 	..s CatDesc=$p(^DHCTarC("TAC",CatDr),"^",2)
 	..s myprtUser=""
 	..f  s myprtUser=$o(^TMP("DHCIPJSHZ",job,myprtUser)) q:myprtUser=""  d
 	...s footUser=$p(^SSU("SSUSR",myprtUser),"^",2)
 	...s myDate=""
 	...f  s myDate=$o(^TMP("DHCIPJSHZ",job,myprtUser,myDate)) q:myDate=""  d
 	....s footDate=$zd(myDate,3)
 	....s footAmt=$g(^TMP("DHCIPJSHZ",job,myprtUser,myDate,"ACCat",CatDr))
 	....d OutputRow8
 	
 	k ^TMP("DHCIPJSHZ",job)
	quit $$$OK
OutputRow8
	set Data=$lb(footUser,footDate,CatDesc,type,footAmt)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// 2010-12-16
ClassMethod GetIPBill(job, prtUser, Date, Bill, CatType)
{
	n (job, prtUser, Date, Bill,CatType)
	i (CatType="") s CatType="IPCat"
	s BillOrd="0"
	f  s BillOrd=$o(^DHCPB(Bill,"O",BillOrd))  q:BillOrd=""   d
	.q:($d(^DHCPB(Bill,"O",BillOrd))=10)
	.s BillDetsub="0"
	.f  s BillDetsub=$o(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub))   q:BillDetsub=""   d
	..s tarid=$p($g(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub)),"^",3)
	..q:(tarid="")
	..i CatType="IPCat"  d
	...s IPSubCat=$p($g(^DHCTARI(tarid)),"^",14)      ;住院子类
	...s IPCat=$p($G(^DHCTarC("IC",IPSubCat)),"^",3)  ;大类
	..i CatType="ACCat"  d
	...s IPSubCat=$p($g(^DHCTARI(tarid)),"^",5)      ;会计子类
	...s IPCat=$p($G(^DHCTarC("AC",IPSubCat)),"^",3)  ;会计大类
	..s ^TMP("DHCIPJSHZ",job,prtUser,Date,CatType,IPCat)=$g(^TMP("DHCIPJSHZ",job,prtUser,Date,CatType,IPCat))+$p($g(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub)),"^",7)
	
	q
}

/// 显示预交金明细打印日期，打印时间,病人姓名，登记号，金额，支付方式，rowid,job
Query FindJSHzInfo(stDate, endDate, hospDr, CatType, DateType) As websys.Query(ROWSPEC = "footUser:%String,footDate:%String,CatDesc:%String,type:%String,footAmt:%Float") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCOPBillDailyPrint","FindJSHzInfo","62825","62829","","ACCat")
ClassMethod FindJSHzInfoExecute(ByRef qHandle As %Binary, stDate, endDate, hospDr, CatType, DateType) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    set job=$j
    k ^TMP("DHCOPJSHZ",job)
	i DateType=1 d
	.f pdate=stDate:1:endDate d 
	..s prtDr=""
	..f  s prtDr=$o(^DHCINVPRT(0,"Date",pdate,prtDr)) q:prtDr=""  d
	...q:'$d(^DHCINVPRT(prtDr))
	...s invInfo=$g(^DHCINVPRT(prtDr))
	...s prtFairType=$p(invInfo,"^",34)   ;PRT_FairType(F:收费，R:挂号)
	...q:((prtFairType'="F")&&(prtFairType'="R"))
	...s prtUser=$p(invInfo,"^",21)   ;PRT_Usr 收费员
	...s prtInsType=$p(invInfo,"^",9)  ;PRT_InsType_DR ;病人类型(费别)
	...s admSource=+$p(^PAC("ADMREA",prtInsType),"^",9) 
	...s prtAcount=$p(invInfo,"^",1)   ;PRT_Acount  ;总金额
	...s prtDate=$p(invInfo,"^",5)
	...s PrtHospDr=$p(invInfo,"^",39)
	...q:(hospDr'=0)&(PrtHospDr'=hospDr)
	...s prtFlag=$p(invInfo,"^",8)      ;PRT_Flag 发票状态
	...q:prtFlag="A"
	...s prtInvNO=$p(invInfo,"^",14)    ;PRT_inv   发票号
	...s prtInitDr=$p(invInfo,"^",13)   ;PRT_initInv_DR  指向被作废或红冲的发票Rowid
	...s refaccdr=""
	...i prtInitDr'=""  s refaccdr=$p(^DHCINVPRT(prtInitDr),"^",4) ;PRT_ACCPINV_DR->dhc_accpayinv 帐户支付的集中打印发票
	...q:refaccdr'=""  ;过滤卡消费记录
	...s Paysub=0
	...f  s Paysub=$o(^DHCINVPRT(prtDr,"P",Paysub))  q:Paysub=""  d
	....s paymDr=$p(^DHCINVPRT(prtDr,"P",Paysub),"^",1)
	....s:paymDr'="" paymCode=$p($g(^CT("CTPM",paymDr)),"^",1)
	....s paymAmt=$p($g(^DHCINVPRT(prtDr,"P",Paysub)),"^",3)
	....s ^TMP("DHCOPJSHZ",job,prtUser,prtDate,"PayM",paymDr)=$g(^TMP("DHCOPJSHZ",job,prtUser,prtDate,"PayM",paymDr))+paymAmt
	...d ..GetOPBillByInvDr(job, prtUser, prtDate, prtDr, CatType)
	e  d
	.f pdate=stDate:1:endDate d
	..s prtDr=""
	..f  s prtDr=$o(^DHCINVPRT(0,"HandDate",pdate,prtDr)) q:prtDr=""  d
	...q:'$d(^DHCINVPRT(prtDr))
	...s invInfo=$g(^DHCINVPRT(prtDr))
	...s prtFairType=$p(invInfo,"^",34)   ;PRT_FairType(F:收费，R:挂号)
	...q:((prtFairType'="F")&(prtFairType'="R"))
	...s prtUser=$p(invInfo,"^",21)   ;PRT_Usr 收费员
	...s prtInsType=$p(invInfo,"^",9)  ;PRT_InsType_DR ;病人类型(费别)
	...s admSource=+$p(^PAC("ADMREA",prtInsType),"^",9) 
	...s prtAcount=$p(invInfo,"^",1)   ;PRT_Acount  ;总金额
	...s prtHandDate=$p(invInfo,"^",11)
	...s PrtHospDr=$p(invInfo,"^",39)
	...q:(hospDr'=0)&&(PrtHospDr'=hospDr)
	...s prtFlag=$p(invInfo,"^",8)      ;PRT_Flag 发票状态
	...q:prtFlag="A"
	...s prtInvNO=$p(invInfo,"^",14)    ;PRT_inv   发票号
	...s prtInitDr=$p(invInfo,"^",13)   ;PRT_initInv_DR  指向被作废或红冲的发票Rowid
	...s refaccdr=""
	...i prtInitDr'=""  s refaccdr=$p(^DHCINVPRT(prtInitDr),"^",4) ;PRT_ACCPINV_DR->dhc_accpayinv 帐户支付的集中打印发票
	...q:refaccdr'=""  ;过滤卡消费记录
	...s Paysub="0"
	...f  s Paysub=$o(^DHCINVPRT(prtDr,"P",Paysub))  q:Paysub=""  d
	....s paymDr=$p(^DHCINVPRT(prtDr,"P",Paysub),"^",1)
	....s:paymDr'="" paymCode=$p($g(^CT("CTPM",paymDr)),"^",1)
	....s paymAmt=$p($g(^DHCINVPRT(prtDr,"P",Paysub)),"^",3)
	....s ^TMP("DHCOPJSHZ",job,prtUser,prtHandDate,"PayM",paymDr)=$g(^TMP("DHCOPJSHZ",job,prtUser,prtHandDate,"PayM",paymDr))+paymAmt
	...d ..GetOPBillByInvDr(job, prtUser, prtHandDate, prtDr, CatType)

	s myprtUser="",type="PayM"
	f  s myprtUser=$o(^TMP("DHCOPJSHZ",job,myprtUser)) q:myprtUser=""  d
	.s footUser=$p(^SSU("SSUSR",myprtUser),"^",2)
	.s myDate=""
	.f  s myDate=$o(^TMP("DHCOPJSHZ",job,myprtUser,myDate)) q:myDate=""  d
	..s footDate=$zd(myDate,3)
	..s CatDr=""
	..f  s CatDr=$o(^TMP("DHCOPJSHZ",job,myprtUser,myDate,"PayM",CatDr)) q:CatDr=""  d
	...s footAmt=$g(^TMP("DHCOPJSHZ",job,myprtUser,myDate,"PayM",CatDr))
	...s CatDesc=$p($g(^CT("CTPM",CatDr)),"^",2)
	...d OutputRow7
	i CatType="OPCat" d
	.s CatDr=0,type="OPCat"
	.f  s CatDr=$o(^DHCTarC("TOC",CatDr)) q:CatDr=""  d
	..s CatDesc=$p(^DHCTarC("TOC",CatDr),"^",2)
	..s myprtUser=""
	..f  s myprtUser=$o(^TMP("DHCOPJSHZ",job,myprtUser)) q:myprtUser=""  d
	...s footUser=$p(^SSU("SSUSR",myprtUser),"^",2)
	...s myDate=""
	...f  s myDate=$o(^TMP("DHCOPJSHZ",job,myprtUser,myDate)) q:myDate=""  d
	....s footDate=$zd(myDate,3)
	....s footAmt=$g(^TMP("DHCOPJSHZ",job,myprtUser,myDate,"OPCat",CatDr))
	....d OutputRow7

	i CatType="ACCat" d
	.s CatDr=0,type="ACCat"
	.f  s CatDr=$o(^DHCTarC("TAC",CatDr)) q:CatDr=""  d
	..s CatDesc=$p(^DHCTarC("TAC",CatDr),"^",2)
	..s myprtUser=""
	..f  s myprtUser=$o(^TMP("DHCOPJSHZ",job,myprtUser)) q:myprtUser=""  d
	...s footUser=$p(^SSU("SSUSR",myprtUser),"^",2)
	...s myDate=""
	...f  s myDate=$o(^TMP("DHCOPJSHZ",job,myprtUser,myDate)) q:myDate=""  d
	....s footDate=$zd(myDate,3)
	....s footAmt=$g(^TMP("DHCOPJSHZ",job,myprtUser,myDate,"ACCat",CatDr))
	....d OutputRow7
	kill ^TMP("DHCOPJSHZ",job)
	quit $$$OK
OutputRow7
	set Data=$lb(footUser,footDate,CatDesc,type,footAmt)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// 2010-12-16
ClassMethod GetOPBillByInvDr(job, prtUser, Date, InvDr, CatType)
{
	n (job,prtUser,Date, InvDr,CatType)
	i (CatType="") s CatType="OPCat"
	s Condr=""
	s pattype=$p(^DHCINVPRT(InvDr),"^",9)
	s Hisid=$p(^DHCINVPRT(InvDr),"^",6)
	f  s Condr=$o(^DHCBCI(0,"INV",InvDr,Condr))  q:Condr=""  d
	.s Bill=$p($g(^DHCBCI(Condr)),"^",2)
	.s prtAmt=$p(^DHCINVPRT(InvDr),"^",1)
	.s BillOrd=""
	.f  s BillOrd=$o(^DHCPB(Bill,"O",BillOrd))  q:BillOrd=""   d
	..s BillDetsub=""
	..f  s BillDetsub=$o(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub))   q:BillDetsub=""   d
	...s tarid=$p($g(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub)),"^",3)
	...q:tarid=""
	...i CatType="OPCat"  d
	....s OPSubCat=$p($g(^DHCTARI(tarid)),"^",15)      ;门诊子类
	....s OPCat=$p($G(^DHCTarC("OC",OPSubCat)),"^",3)  ;门诊大类
	...i CatType="ACCat"  d
	....s OPSubCat=$p($g(^DHCTARI(tarid)),"^",5)      ;会计子类
	....s OPCat=$p($G(^DHCTarC("AC",OPSubCat)),"^",3)  ;会计大类
	...s ^TMP("DHCOPJSHZ",job,prtUser,Date,CatType,OPCat)=$g(^TMP("DHCOPJSHZ",job,prtUser,Date,CatType,OPCat))+$p($g(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub)),"^",7)
	
	q
}

/// Creator:wangjian
/// Creatdate:2012-04-01
/// 智能报表工具打印退费汇总表
/// d ##class(%ResultSet).RunQuery("web.UDHCJFIPBillReportPrint","FindReturnHZ","2017-02-09","2017-02-09",2,0)
Query FindReturnHZ(StDate, EndDate, HOSPID, DateType) As websys.Query(ROWSPEC = "TUsername:%String,TOPCateDesc:%String,TOPCateFee:%Float,Tflag:%String") [ SqlProc ]
{
}

ClassMethod FindReturnHZExecute(ByRef qHandle As %Binary, StDate, EndDate, HOSPID, DateType) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	if ((StDate="")||(EndDate=""))  quit $$$OK
	if (StDate["-") set StDate=$zdh(StDate,3)
	if (StDate["/") set StDate=$zdh(StDate,4)
	if (EndDate["-") set EndDate=$zdh(EndDate,3)
	if (EndDate["/") s EndDate=$zdh(EndDate,4)
	
	kill ReturnOutpatCate
	if (DateType=1) {
		f Date=StDate:1:EndDate d
		.s PrtRowId=0
		.f  s PrtRowId=$o(^DHCINVPRT(0,"Date",Date,PrtRowId)) q:PrtRowId=""  d 
		..s PrtAcount=$p(^DHCINVPRT(PrtRowId),"^",1)
		..s PrtFlag=$p(^DHCINVPRT(PrtRowId),"^",8)
		..s PrtUserDR=$p(^DHCINVPRT(PrtRowId),"^",21)
		..;q:(PrtFlag="A")&(PrtAcount>0)
		..;q:(PrtFlag="S")&(PrtAcount>0)
		..q:$p(^DHCINVPRT(PrtRowId),"^",34)="R"     //不需要R类型的
		..s PrtHospDr=$p(^DHCINVPRT(PrtRowId),"^",39)
		..q:(PrtHospDr'=HOSPID)
		..s PrtInitDr=$p(^DHCINVPRT(PrtRowId),"^",13)
		..s OldInvDr=$p(^DHCINVPRT(PrtRowId),"^",29)
		..i (OldInvDr'="") d
		...;s TReturnType="部分退费"
		...s TPrtAcount=$p(^DHCINVPRT(OldInvDr),"^",1) ;最初发票金额
		...s TReAcount=PrtAcount-TPrtAcount ;退费金额
		...q:TReAcount=0 ;作废从打
		...s TReBalance=PrtAcount ;余额
		...d ..GetReturnOutpatCate("", OldInvDr, PrtRowId, PrtUserDR)
		..i (PrtInitDr'="")&&('$d(^DHCINVPRT(0,"OldINV", PrtInitDr))) d
		...;s TReturnType="全部退费"
		...d ..GetReturnOutpatCate(PrtInitDr,"",PrtRowId, PrtUserDR)
	}else  {
		f Date=StDate:1:EndDate d
		.s PrtRowId=0
		.f  s PrtRowId=$o(^DHCINVPRT(0,"HandDate",Date,PrtRowId)) q:PrtRowId=""  d 
		..s PrtAcount=$p(^DHCINVPRT(PrtRowId),"^",1)
		..s PrtFlag=$p(^DHCINVPRT(PrtRowId),"^",8)
		..s PrtUserDR=$p(^DHCINVPRT(PrtRowId),"^",21)
		..;q:(PrtFlag="A")&(PrtAcount>0)
		..;q:(PrtFlag="S")&(PrtAcount>0)
		..q:$p(^DHCINVPRT(PrtRowId),"^",34)="R"     //不需要R类型的
		..s PrtHospDr=$p(^DHCINVPRT(PrtRowId),"^",39)
		..q:(PrtHospDr'=HOSPID)
		..s PrtInitDr=$p(^DHCINVPRT(PrtRowId),"^",13)
		..s OldInvDr=$p(^DHCINVPRT(PrtRowId),"^",29)
		..i (OldInvDr'="") d
		...;s TReturnType="部分退费"
		...s TPrtAcount=$p(^DHCINVPRT(OldInvDr),"^",1) ;最初发票金额
		...s TReAcount=PrtAcount-TPrtAcount ;退费金额
		...q:TReAcount=0 ;作废从打
		...s TReBalance=PrtAcount ;余额
		...d ..GetReturnOutpatCate("",OldInvDr,PrtRowId,PrtUserDR)
		..i (PrtInitDr'="")&&('$d(^DHCINVPRT(0,"OldINV",PrtInitDr))) d
		...;s TReturnType="全部退费"
		...d ..GetReturnOutpatCate(PrtInitDr, "", PrtRowId, PrtUserDR)
	}
	;统计输出
	s MyPrtuser=""
	f  s MyPrtuser=$o(ReturnOutpatCate("ReturnHZ","User""TOC",MyPrtuser)) q:MyPrtuser=""  d
	.s TUsername=$p($g(^SSU("SSUSR",MyPrtuser)),"^",2)     ;收费员
	.s MyTotalAmt=0
	.;s MyOutpatCateStr="1^2^3^4^5^6^7^8^9^10^11^12^13^14^15^16"
	.;f i=1:1:$l(MyOutpatCateStr,"^") d
	.;.s MyOutpatCate=$p(MyOutpatCateStr,"^",i)
	.s MyOutpatCate=""
	.f  s MyOutpatCate=$o(ReturnOutpatCate("ReturnHZ","User""TOC",MyPrtuser,MyOutpatCate)) q:(MyOutpatCate="")  d
	..s TOPCateFee=0-$g(ReturnOutpatCate("ReturnHZ","User""TOC",MyPrtuser,MyOutpatCate))
	..s TOPCateDesc=$p(^DHCTarC("TOC",MyOutpatCate),"^",2)
	..i TOPCateDesc["药" s flag=1
	..e  s flag=0
	..q:+TOPCateFee=0
	..d OutputRow1
	
 	quit $$$OK
OutputRow1
	set Data=$lb(TUsername,TOPCateDesc,TOPCateFee,flag)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod GetReturnOutpatCate(PrtInitDr, OldInvDr, PrtRowId, PrtUserDR)
{
	i PrtInitDr'="" d
	.s DHCBCIRowid=""
	.f  s DHCBCIRowid=$o(^DHCBCI(0,"INV",PrtRowId,DHCBCIRowid)) q:DHCBCIRowid=""  d
	..s bill=$p(^DHCBCI(DHCBCIRowid),"^",2)
	..s totalamount=0,ordsub=""
	..f  s ordsub=$o(^DHCPB(bill,"O",ordsub)) q:ordsub=""  d
	...q:ordsub=0
    ...s detsub="0"
	...f  s detsub=$o(^DHCPB(bill,"O",ordsub,"D",detsub))  q:detsub=""  d
	....s taritem=$p(^DHCPB(bill,"O",ordsub,"D",detsub),"^",3)
	....s totalamount=$p(^DHCPB(bill,"O",ordsub,"D",detsub),"^",7) ;总额
	....q:(taritem="")
	....s outpatcate=$p(^DHCTARI(taritem),"^",15)     ;门诊费用子分类         
	....q:(outpatcate="")
	....s outcate=$p(^DHCTarC("OC",outpatcate),"^",3) 
	....q:(outcate="")
	....s ReturnOutpatCate("ReturnHZ","User""TOC",PrtUserDR,outcate)=$g(ReturnOutpatCate("ReturnHZ","User""TOC",PrtUserDR,outcate))+totalamount
	i OldInvDr'="" d
	.s DHCBCIRowid=""
	.f  s DHCBCIRowid=$o(^DHCBCI(0,"INV",PrtRowId,DHCBCIRowid)) q:DHCBCIRowid=""  d
	..s bill=$p(^DHCBCI(DHCBCIRowid),"^",2)
	..s ordsub="",totalamount=0
	..f  s ordsub=$o(^DHCPB(bill,"O",ordsub)) q:ordsub=""  d
	...q:ordsub=0
	...s detsub="0"
	...f  s detsub=$o(^DHCPB(bill,"O",ordsub,"D",detsub))  q:detsub=""  d
	....s taritem=$p(^DHCPB(bill,"O",ordsub,"D",detsub),"^",3)
	....s totalamount=$p(^DHCPB(bill,"O",ordsub,"D",detsub),"^",7) ;总额
	....q:(taritem="")
	....s outpatcate=$p(^DHCTARI(taritem),"^",15)     ;门诊费用子分类         
	....q:(outpatcate="")
	....s outcate=$p(^DHCTarC("OC",outpatcate),"^",3) 
	....q:(outcate="")
	....s ReturnOutpatCate("ReturnHZ","User""TOC",PrtUserDR,outcate)=$g(ReturnOutpatCate("ReturnHZ","User""TOC",PrtUserDR,outcate))+totalamount
	.;负数据
	.s strikeRowId=$o(^DHCINVPRT(0,"InitInvDR",OldInvDr,0))
	.s OldDHCBCIRowid=""
	.f  s OldDHCBCIRowid=$o(^DHCBCI(0,"INV",strikeRowId,OldDHCBCIRowid)) q:(OldDHCBCIRowid="")  d
	..s oldbill=$p(^DHCBCI(OldDHCBCIRowid),"^",2)
	..s oldordsub="",totalamount=0
	..f  s oldordsub=$o(^DHCPB(oldbill,"O",oldordsub)) q:(oldordsub="")  d
	...q:oldordsub=0
	...s olddetsub="0"
	...f  s olddetsub=$o(^DHCPB(oldbill,"O",oldordsub,"D",olddetsub))  q:(olddetsub="")  d
	....s taritem=$p(^DHCPB(oldbill,"O",oldordsub,"D",olddetsub),"^",3)
	....s totalamount=$p(^DHCPB(oldbill,"O",oldordsub,"D",olddetsub),"^",7)	      
	....q:(taritem="")
	....s outpatcate=$p(^DHCTARI(taritem),"^",15)     ;门诊费用子分类         
	....q:(outpatcate="")
	....s outcate=$p(^DHCTarC("OC",outpatcate),"^",3) 
	....q:(outcate="")
	....s ReturnOutpatCate("ReturnHZ","User""TOC",PrtUserDR,outcate)=$g(ReturnOutpatCate("ReturnHZ","User""TOC",PrtUserDR,outcate))+totalamount
	q
}

/// w ##class(%ResultSet).RunQuery("web.UDHCJFIPBillReportPrint","FindUser1","O","3","")
Query FindUser1(grp As %String, type As %String, username As %String = "", HOSPID) As websys.Query(ROWSPEC = "usrname:%String,rowid:%String") [ SqlProc ]
{
}

ClassMethod FindUser1Execute(ByRef qHandle As %Binary, grp As %String, type As %String, username As %String = "", HOSPID) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    if (grp="") quit $$$OK
    
    set rowid=$o(^DHCJFRcptGroupSet(0,"Type",grp,type,""))
    if (rowid="") quit $$$OK
    set defaultHosp=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_RcptGroupUser", HOSPID)
	set sub=0
	for  set sub=$o(^DHCJFRcptGroupSet(rowid,"Sub",sub)) quit:(sub="")  do
 	.set usrrowid=$p(^DHCJFRcptGroupSet(rowid,"Sub",sub),"^",4)
	.set usrgrp=$p(^DHCJFRcptGroupSet(rowid,"Sub",sub),"^",3)
	.s hospDR=$p(^DHCJFRcptGroupSet(rowid,"Sub",sub),"^",5)
	.q:(hospDR'=defaultHosp)
	.if $d(^SSU("SSUSR",usrrowid)) s usrname=$p(^SSU("SSUSR",usrrowid),"^",2)
	.if $d(^SSU("SSGRP",usrgrp)) s usrgrp=$p(^SSU("SSGRP",usrgrp),"^",1)
	.do OutputRow2
	quit $$$OK
OutputRow2
	set Data=$lb(usrname,usrrowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// 显示预交金明细打印日期，打印时间,病人姓名，登记号，金额，支付方式，rowid,job
/// d ##class(%ResultSet).RunQuery("web.UDHCJFIPBillReportPrint","GetYBFeeByAdmreason","62825","62829","","1")
Query GetYBFeeByAdmreason(stDate, endDate, hospDr, DateType) As websys.Query(ROWSPEC = "myTypeDesc:%String,patnum:%Integer,myYBPaySum:%Float,myPatSelfFee:%Float,myPatientShare:%Float") [ SqlProc ]
{
}

ClassMethod GetYBFeeByAdmreasonExecute(ByRef qHandle As %Binary, stDate, endDate, hospDr, DateType) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	k ^TMPYBFeeByAdmreasonArr("mzjf",$j)
	
	i DateType=1 d
	.f pdate=stDate:1:endDate d 
	..s prtDr=""
	..f  s prtDr=$o(^DHCINVPRT(0,"Date",pdate,prtDr)) q:(prtDr="")  d
	...q:'$d(^DHCINVPRT(prtDr))
	...s invInfo=$g(^DHCINVPRT(prtDr))
	...s prtFairType=$p(invInfo,"^",34)   ;PRT_FairType(F:收费，R:挂号)
	...q:((prtFairType'="F")&(prtFairType'="R"))
	...s prtUser=$p(invInfo,"^",21)   ;PRT_Usr 收费员
	...s prtInsType=$p(invInfo,"^",9)  ;PRT_InsType_DR ;病人类型(费别)
	...s:prtInsType="" prtInsType=1 ;默认自费
	...s admSource=+$p(^PAC("ADMREA",prtInsType),"^",9) 
	...s prtAcount=$p(invInfo,"^",1)   ;PRT_Acount  ;总金额
	...s prtDate=$p(invInfo,"^",5)
	...s PrtHospDr=$p(invInfo,"^",39)
	...q:(hospDr'=0)&(PrtHospDr'=hospDr)
	...s prtFlag=$p(invInfo,"^",8)      ;PRT_Flag 发票状态
	...q:prtFlag="A"
	...s prtInvNO=$p(invInfo,"^",14)    ;PRT_inv   发票号
	...s prtInitDr=$p(invInfo,"^",13)   ;PRT_initInv_DR  指向被作废或红冲的发票Rowid
	...s refaccdr=""
	...i prtInitDr'=""  s refaccdr=$p(^DHCINVPRT(prtInitDr),"^",4) ;PRT_ACCPINV_DR->dhc_accpayinv 帐户支付的集中打印发票
	...q:refaccdr'=""  ;过滤卡消费记录
	...s prtPatientShare=$p(invInfo,"^",16)+$p(invInfo,"^",37)
	...s prtYBPaySum=$p(invInfo,"^",31)
	...s prtPatSelfFee=prtPatientShare-prtYBPaySum
	...s DHCBCIRowid=$o(^DHCBCI(0,"INV",prtDr,""))
	...q:'$d(^DHCBCI(DHCBCIRowid))
	...s AdmId=$p(^DHCBCI(DHCBCIRowid),"^",3)
	...s ^TMPYBFeeByAdmreasonArr("mzjf",$j,prtInsType,AdmId,"prtYBPaySum")=$g(^TMPYBFeeByAdmreasonArr("mzjf",$j,prtInsType,AdmId,"prtYBPaySum"))+prtYBPaySum
	...s ^TMPYBFeeByAdmreasonArr("mzjf",$j,prtInsType,AdmId,"prtPatSelfFee")=$g(^TMPYBFeeByAdmreasonArr("mzjf",$j,prtInsType,AdmId,"prtPatSelfFee"))+prtPatSelfFee
	...s ^TMPYBFeeByAdmreasonArr("mzjf",$j,prtInsType,AdmId,"prtPatientShare")=$g(^TMPYBFeeByAdmreasonArr("mzjf",$j,prtInsType,AdmId,"prtPatientShare"))+prtPatientShare
	e  d
	.f pdate=stDate:1:endDate d
	..s prtDr=""
	..f  s prtDr=$o(^DHCINVPRT(0,"HandDate",pdate,prtDr)) q:prtDr=""  d
	...q:'$d(^DHCINVPRT(prtDr))
	...s invInfo=$g(^DHCINVPRT(prtDr))
	...s prtFairType=$p(invInfo,"^",34)   ;PRT_FairType(F:收费，R:挂号)
	...q:((prtFairType'="F")&(prtFairType'="R"))
	...s prtUser=$p(invInfo,"^",21)   ;PRT_Usr 收费员
	...s prtInsType=$p(invInfo,"^",9)  ;PRT_InsType_DR ;病人类型(费别)
	...s admSource=+$p(^PAC("ADMREA",prtInsType),"^",9) 
	...s prtAcount=$p(invInfo,"^",1)   ;PRT_Acount  ;总金额
	...s prtHandDate=$p(invInfo,"^",11)
	...s PrtHospDr=$p(invInfo,"^",39)
	...q:(hospDr'=0)&(PrtHospDr'=hospDr)
	...s prtFlag=$p(invInfo,"^",8)      ;PRT_Flag 发票状态
	...q:prtFlag="A"
	...s prtInvNO=$p(invInfo,"^",14)    ;PRT_inv   发票号
	...s prtInitDr=$p(invInfo,"^",13)   ;PRT_initInv_DR  指向被作废或红冲的发票Rowid
	...s refaccdr=""
	...i prtInitDr'=""  s refaccdr=$p(^DHCINVPRT(prtInitDr),"^",4) ;PRT_ACCPINV_DR->dhc_accpayinv 帐户支付的集中打印发票
	...q:refaccdr'=""  ;过滤卡消费记录
	...s prtPatientShare=$p(invInfo,"^",16)+$p(invInfo,"^",37)
	...s prtYBPaySum=$p(invInfo,"^",31)
	...s prtPatSelfFee=prtPatientShare-prtYBPaySum
	...s DHCBCIRowid=$o(^DHCBCI(0,"INV",prtDr,""))
	...q:'$d(^DHCBCI(DHCBCIRowid))
	...s AdmId=$p(^DHCBCI(DHCBCIRowid),"^",3)
	...s ^TMPYBFeeByAdmreasonArr("mzjf",$j,prtInsType,AdmId,"prtYBPaySum")=$g(^TMPYBFeeByAdmreasonArr("mzjf",$j,prtInsType,AdmId,"prtYBPaySum"))+prtYBPaySum
	...s ^TMPYBFeeByAdmreasonArr("mzjf",$j,prtInsType,AdmId,"prtPatSelfFee")=$g(^TMPYBFeeByAdmreasonArr("mzjf",$j,prtInsType,AdmId,"prtPatSelfFee"))+prtPatSelfFee
	...s ^TMPYBFeeByAdmreasonArr("mzjf",$j,prtInsType,AdmId,"prtPatientShare")=$g(^TMPYBFeeByAdmreasonArr("mzjf",$j,prtInsType,AdmId,"prtPatientShare"))+prtPatientShare
	
	;根据组织好的数组输出
	s pattype=""
	f  s pattype=$o(^TMPYBFeeByAdmreasonArr("mzjf",$j,pattype)) q:pattype=""  d
	.s myTypeDesc=$p(^PAC("ADMREA",pattype),"^",2)
	.s patnum=0,myYBPaySum=0,myPatSelfFee=0,myPatientShare=0
	.s adm=""
	.f  s adm=$o(^TMPYBFeeByAdmreasonArr("mzjf",$j,pattype,adm)) q:adm=""  d
	..s patnum=patnum+1
	..s myYBPaySum=myYBPaySum+$g(^TMPYBFeeByAdmreasonArr("mzjf",$j,pattype,adm,"prtYBPaySum"))
	..s myPatSelfFee=myPatSelfFee+$g(^TMPYBFeeByAdmreasonArr("mzjf",$j,pattype,adm,"prtPatSelfFee"))
	..s myPatientShare=myPatientShare+$g(^TMPYBFeeByAdmreasonArr("mzjf",$j,pattype,adm,"prtPatientShare"))
	.d OutputRow3
	k ^TMPYBFeeByAdmreasonArr("mzjf",$j)
	quit $$$OK
OutputRow3
	set Data=$lb(myTypeDesc,patnum,$fn(myYBPaySum,"",2),$fn(myPatSelfFee,"",2),$fn(myPatientShare,"",2))
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod GetOPInvInfo(Stdate, Enddate, HisId, user, job)
{
	i HisId'="" d
	.s PrtRowID=""
 	.f  s PrtRowID=$o(^DHCINVPRT(0,"Report",HisId,PrtRowID))  q:PrtRowID=""  d
 	..q:'$d(PrtRowID)
 	..s printflag=$p($g(^DHCINVPRT(PrtRowID)),"^",3)
    ..q:printflag'="P"
 	..s PrtFlag=$p(^DHCINVPRT(PrtRowID),"^",8)
 	..s Account=$p(^DHCINVPRT(PrtRowID),"^",1)
 	..s PrtUser=$p(^DHCINVPRT(PrtRowID),"^",21)
 	..q:PrtUser'=user
 	..s PrtHandin=$p(^DHCINVPRT(PrtRowID),"^",10)
 	..q:PrtHandin'="Y"
 	..s PrtInv=$p(^DHCINVPRT(PrtRowID),"^",14)
 	..s Paysub="0",PrtCashAmt=0
 	..f  s Paysub=$o(^DHCINVPRT(PrtRowID,"P",Paysub))  q:Paysub=""  d
 	...s paymDr=$p(^DHCINVPRT(PrtRowID,"P",Paysub),"^",1)
 	...s:paymDr'="" paymCode=$p($g(^CT("CTPM",paymDr)),"^",1)
 	...s paymAmt=$p($g(^DHCINVPRT(PrtRowID,"P",Paysub)),"^",3)
 	...i paymCode="CASH" s PrtCashAmt=PrtCashAmt+paymAmt
 	..i PrtInv'="" d 
 	...s ^TMP("ZYJF","HisIdInv",HisId,job,PrtInv)="" ;发票号
 	...s ^tmp("invsum",job,"HisId",HisId,1)=$g(^tmp("invsum",job,"HisId",HisId,1))+1 ;发票张数
 	..s ^tmp("invsum",job,"HisId",HisId,2)=$g(^tmp("invsum",job,"HisId",HisId,2))+PrtCashAmt ;现金金额
	e  d
	.f prtdate=Stdate:1:Enddate d
	..s PrtRowID=""
 	..f  s PrtRowID=$o(^DHCINVPRT(0,"Date",prtdate,PrtRowID))  q:PrtRowID=""  d
 	...q:'$d(PrtRowID)
 	...s printflag=$p($g(^DHCINVPRT(PrtRowID)),"^",3)
    ...q:printflag'="P"
 	...s PrtFlag=$p(^DHCINVPRT(PrtRowID),"^",8)
 	...s Account=$p(^DHCINVPRT(PrtRowID),"^",1)
 	...s PrtUser=$p(^DHCINVPRT(PrtRowID),"^",21)
 	...q:PrtUser'=user
 	...s PrtHandin=$p(^DHCINVPRT(PrtRowID),"^",10)
 	...q:PrtHandin'="Y"
 	...s PrtInv=$p(^DHCINVPRT(PrtRowID),"^",14)
 	...s HisId=$p(^DHCINVPRT(PrtRowID),"^",6)
 	...s Paysub="0",PrtCashAmt=0
 	...f  s Paysub=$o(^DHCINVPRT(PrtRowID,"P",Paysub))  q:Paysub=""  d
 	....s paymDr=$p(^DHCINVPRT(PrtRowID,"P",Paysub),"^",1)
 	....s:paymDr'="" paymCode=$p($g(^CT("CTPM",paymDr)),"^",1)
 	....s paymAmt=$p($g(^DHCINVPRT(PrtRowID,"P",Paysub)),"^",3)
 	....i paymCode="CASH" s PrtCashAmt=PrtCashAmt+paymAmt
 	...i PrtInv'="" d 
 	....s ^TMP("ZYJF","HisIdInv",HisId,job,PrtInv)="" ;发票号
 	....s ^tmp("invsum",job,"HisId",HisId,1)=$g(^tmp("invsum",job,"HisId",HisId,1))+1 ;发票张数
 	...s ^tmp("invsum",job,"HisId",HisId,2)=$g(^tmp("invsum",job,"HisId",HisId,2))+PrtCashAmt ;现金金额
	q
}

ClassMethod GetIPInvInfo(Stdate, Enddate, HisId, user, job, type)
{
	i HisId'="" d
	.s PrtRowID=""
 	.f  s PrtRowID=$o(^DHCINVPRTZY("0","JK",HisId,PrtRowID))  q:PrtRowID=""  d
 	..q:'$d(PrtRowID)
 	..s PrtFlag=$p(^DHCINVPRTZY(PrtRowID),"^",8)
 	..s Account=$p(^DHCINVPRTZY(PrtRowID),"^",6)
 	..s PrtUser=$p(^DHCINVPRTZY(PrtRowID),"^",7)
 	..s PrtPattype=$p(^DHCINVPRTZY(PrtRowID),"^",9)
 	..s NationalCode=+$p(^PAC("ADMREA",PrtPattype),"^",5)
 	..q:(type="Z")&&(PrtPattype'=2)&&(PrtPattype'=14)
 	..q:(type="J")&&(PrtPattype'=3)
 	..q:(type="I")&&(NationalCode>0)
 	..q:PrtUser'=user
 	..s PrtHandin=$p(^DHCINVPRTZY(PrtRowID),"^",14)
 	..q:PrtHandin'="Y"
 	..s HisId=$p(^DHCINVPRTZY(PrtRowID),"^",23)
 	..s Billno=$p(^DHCINVPRTZY(PrtRowID),"^",5)
 	..s PrtInv=$p(^DHCINVPRTZY(PrtRowID),"^",1)
 	..s arrcp="",PrtCashAmt=0
	..f  s arrcp=$o(^ARRCP("ARPBL",Billno,arrcp)) q:arrcp=""  d
	...s arral="" 
	...f  s arral=$o(^ARRCP("ARPBL",Billno,arrcp,arral)) q:arral=""  d
	....s s=^ARRCP(arrcp,"RAL",arral),mytype=$p(s,"^",9),m1=+$p(s,"^",2),billnum=+$p(s,"^",18)   ;type->ARRAL_Deposit_DR(押金类型) billno->ARRAL_ARPBIL_DR
	....i mytype="" d
	.....s paym="0"
	.....f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d
	......s ss=^ARRCP(arrcp,"PAYM",paym) q:ss=""
	......s mode=$p(ss,"^",1) q:$g(mode)=""
	......s m2=$p(ss,"^",3) q:$g(m2)=""
	......s paycode=$p(^CT("CTPM",mode),"^",1)
	......i paycode="CASH" s PrtCashAmt=PrtCashAmt+m2
 	..i PrtInv'="" d 
 	...s ^TMP("ZYJF","HisIdInv",HisId,job,PrtInv)="" ;发票号
 	...s ^tmp("invsum",job,"HisId",HisId,1)=$g(^tmp("invsum",job,"HisId",HisId,1))+1 ;发票张数
 	..s ^tmp("invsum",job,"HisId",HisId,2)=$g(^tmp("invsum",job,"HisId",HisId,2))+PrtCashAmt ;现金金额
	e  d
	.f prtdate=Stdate:1:Enddate d
	..s PrtRowID=""
 	..f  s PrtRowID=$o(^DHCINVPRTZY("0","DATE",prtdate,PrtRowID))  q:PrtRowID=""  d
 	...q:'$d(PrtRowID)
 	...s PrtFlag=$p(^DHCINVPRTZY(PrtRowID),"^",8)
 	...s Account=$p(^DHCINVPRTZY(PrtRowID),"^",6)
 	...s PrtUser=$p(^DHCINVPRTZY(PrtRowID),"^",7)
 	...q:PrtUser'=user
 	...s PrtPattype=$p(^DHCINVPRTZY(PrtRowID),"^",9)
 	...s NationalCode=+$p(^PAC("ADMREA",PrtPattype),"^",5)
 	...q:(type="Z")&&(PrtPattype'=2)&&(PrtPattype'=14)
 	...q:(type="J")&&(PrtPattype'=3)
 	...q:(type="I")&&(NationalCode>0)
 	...s PrtHandin=$p(^DHCINVPRTZY(PrtRowID),"^",14)
 	...q:PrtHandin'="Y"
 	...s HisId=$p(^DHCINVPRTZY(PrtRowID),"^",23)
 	...s Billno=$p(^DHCINVPRTZY(PrtRowID),"^",5)
 	...s PrtInv=$p(^DHCINVPRTZY(PrtRowID),"^",1)
 	...s arrcp="",PrtCashAmt=0
	...f  s arrcp=$o(^ARRCP("ARPBL",Billno,arrcp)) q:arrcp=""  d
	....s arral="" 
	....f  s arral=$o(^ARRCP("ARPBL",Billno,arrcp,arral)) q:arral=""  d
	.....s s=^ARRCP(arrcp,"RAL",arral),mytype=$p(s,"^",9),m1=+$p(s,"^",2),billnum=+$p(s,"^",18)   ;type->ARRAL_Deposit_DR(押金类型) billno->ARRAL_ARPBIL_DR
	.....i mytype="" d
	......s paym="0"
	......f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d
	.......s ss=^ARRCP(arrcp,"PAYM",paym) q:ss=""
	.......s mode=$p(ss,"^",1) q:$g(mode)=""
	.......s m2=$p(ss,"^",3) q:$g(m2)=""
	.......s paycode=$p(^CT("CTPM",mode),"^",1)
	.......i paycode="CASH" s PrtCashAmt=PrtCashAmt+m2
 	...i PrtInv'="" d 
 	....s ^TMP("ZYJF","HisIdInv",HisId,job,PrtInv)="" ;发票号
 	....s ^tmp("invsum",job,"HisId",HisId,1)=$g(^tmp("invsum",job,"HisId",HisId,1))+1 ;发票张数
 	...s ^tmp("invsum",job,"HisId",HisId,2)=$g(^tmp("invsum",job,"HisId",HisId,2))+PrtCashAmt ;现金金额
	q
}

Query Findinvsum(user, type, stdate, enddate, stnum, endnum, Exp, datetype) As websys.Query(ROWSPEC = "mylqno:%String,myHisDate:%String,myHisDailyDate:%String,invno:%String,invnum:%Integer,invsum:%Float,myFootDate:%String,usrname:%String,mylqdate:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.UDHCJFIPBillReportPrint"," Findinvsum","566","O","","","0307001","0310000","",3)
ClassMethod FindinvsumExecute(ByRef qHandle As %Binary, user, type, stdate, enddate, stnum, endnum, Exp, datetype) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    set job=$j
    if (((stnum'="")&(endnum'=""))!(datetype=3)) { 
    d ..GetInvoiceStr1(user,type, stdate, enddate, stnum, endnum)
    s InvnumStr=$g(^TMPInvChek("JFInv","InvStr",$j))
    f aa=1:1:$l(InvnumStr,"#") d
    .s Invnumarr=$p(InvnumStr,"#",aa)
    .q:Invnumarr=""
    .s StInv=$p(Invnumarr,"^",2),EnInv=$p(Invnumarr,"^",3),InvRowid=$p(Invnumarr,"^",1)
    .s Exp=$p(^DHCINVOICE(InvRowid),"^",16)
    .d ..FindInvsumByInvStr(user,type,StInv,EnInv,Exp)
    s myHisId="" ,No=0,mylqno="",mylqdate=""
	f  s myHisId=$o(^TMPDHCINVInfo("JFInv",$j,"HisId",myHisId)) q:myHisId=""  d
	.s usrno=$p(^SSU("SSUSR",user),"^",1)
	.s usrname=$p(^SSU("SSUSR",user),"^",2)
	.s invnum=$g(^TMPDHCINVInfo("JFInv",$j,"HisId",myHisId,1))
	.s invsum=$g(^TMPDHCINVInfo("JFInv",$j,"HisId",myHisId,2))
	.s invno=##class(web.UDHCJFBaseCommon).GetINVNOinfo(myHisId,"HisIdInv",$j)
	.s mytmpno=$p(invno,"--",2)
	.s mytmpnoStr=##class(web.UDHCJFBaseCommon).GetINVPreABCInfo(mytmpno)
	.s mytmpno=$p(mytmpnoStr,"^",1)
	.s myinvid="",myinvflag=0
	.f  s myinvid=$o(^DHCINVOICE(0,"USER",user,myinvid),-1) q:(myinvid="")!(myinvflag=1)  d
	..s myinvstno=$p(^DHCINVOICE(myinvid),"^",1)
	..s myinvendno=$p(^DHCINVOICE(myinvid),"^",2)
	..i (mytmpno'<myinvstno)&&(mytmpno'>myinvendno) d
	...s mylqno=myinvstno_"-"_myinvendno
	...s mylqdate=$zd($p(^DHCINVOICE(myinvid),"^",4),3)
	...s myinvflag=1
	.i (type="O")!(type="E") d
	..s HisDate=$p(^DHCOPInsFoot(myHisId),"^",2)
 	..s FootDate=$p(^DHCOPInsFoot(myHisId),"^",13)
 	..s HisStDate=$p(^DHCOPInsFoot(myHisId),"^",5)
 	..s HisEndDate=$p(^DHCOPInsFoot(myHisId),"^",3)
	.e  d
	..s HisDate=$p(^DHCJFUSERJK(myHisId),"^",1)
 	..s FootDate=$p(^DHCJFUSERJK(myHisId),"^",7)
 	..s HisStDate=$p(^DHCJFUSERJK(myHisId),"^",3)
 	..s HisEndDate=$p(^DHCJFUSERJK(myHisId),"^",4)
 	.k ^TMPDHCINVInfo("JFInv",$j,"HisId",myHisId)
	.k ^TMP("ZYJF","HisIdInv",myHisId,$j)
	.s myHisDate=$zd(HisDate,3)
	.s myFootDate=""
 	.s:FootDate'="" myFootDate=$zd(FootDate,3)
 	.s myHisDailyDate=$zd(HisStDate,3)_"至"_$zd(HisEndDate,3)
	.Do OutputRow4    
    }else{
	i datetype="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s stdate=$g(stdate)
    i stdate=""  s stdate=$h
    s enddate=$g(enddate)
    i enddate=""  s enddate=$h
    s job=$j
    i (type="O")!(type="E") d
    .i datetype=0 s IndexDate="Date" ;按日报日期
    .i datetype=1 s IndexDate="INSFDate" ;按接收日期
    .i datetype'=2 d
  	..f pdate=stdate:1:enddate d
    ...s FootHisid=""
    ...f  s FootHisid=$o(^DHCOPInsFootI(0,IndexDate,pdate,FootHisid)) q:FootHisid=""  d
    ....q:$d(^DHCOPInsFoot(FootHisid))=10
    ....d ..GetOPInvInfo(stdate,enddate,FootHisid,user,job)
    .e  d
    ..d ..GetOPInvInfo(stdate,enddate,"",user,job)
    
    e  d
    .i datetype=0 s IndexDate="date" ;按日报日期
    .i datetype=1 s IndexDate="inceptdate" ;按接收日期
    .i datetype'=2 d
  	..f pdate=stdate:1:enddate d
    ...s FootHisid=""
    ...f  s FootHisid=$o(^DHCJFUSERJK(0,IndexDate,pdate,FootHisid)) q:FootHisid=""  d
    ....q:$d(^DHCJFUSERJK(FootHisid))=10
    ....d ..GetIPInvInfo(stdate,enddate,FootHisid,user,job,type)
    .e  d
    ..d ..GetIPInvInfo(stdate,enddate,"",user,job,type)
    
    s myHisId="" ,No=0,mylqno="",mylqdate=""
	f  s myHisId=$o(^tmp("invsum",job,"HisId",myHisId)) q:myHisId=""  d
	.s usrno=$p(^SSU("SSUSR",user),"^",1)
	.s usrname=$p(^SSU("SSUSR",user),"^",2)
	.s invnum=$g(^tmp("invsum",job,"HisId",myHisId,1))
	.s invsum=$g(^tmp("invsum",job,"HisId",myHisId,2))
	.s invno=##class(web.UDHCJFBaseCommon).GetINVNOinfo(myHisId,"HisIdInv",$j)
	.s mytmpno=$p(invno,"--",2)
	.s mytmpnoStr=##class(web.UDHCJFBaseCommon).GetINVPreABCInfo(mytmpno)
	.s mytmpno=$p(mytmpnoStr,"^",1)
	.s myinvid="",myinvflag=0
	.f  s myinvid=$o(^DHCINVOICE(0,"USER",user,myinvid),-1) q:(myinvid="")!(myinvflag=1)  d
	..s myinvstno=$p(^DHCINVOICE(myinvid),"^",1)
	..s myinvendno=$p(^DHCINVOICE(myinvid),"^",2)
	..i (mytmpno'<myinvstno)&&(mytmpno'>myinvendno) d
	...s mylqno=myinvstno_"-"_myinvendno
	...s mylqdate=$zd($p(^DHCINVOICE(myinvid),"^",4),3)
	...s myinvflag=1
	.i (type="O")!(type="E") d
	..s HisDate=$p(^DHCOPInsFoot(myHisId),"^",2)
 	..s FootDate=$p(^DHCOPInsFoot(myHisId),"^",13)
 	..s HisStDate=$p(^DHCOPInsFoot(myHisId),"^",5)
 	..s HisEndDate=$p(^DHCOPInsFoot(myHisId),"^",3)
	.e  d
	..s HisDate=$p(^DHCJFUSERJK(myHisId),"^",1)
 	..s FootDate=$p(^DHCJFUSERJK(myHisId),"^",7)
 	..s HisStDate=$p(^DHCJFUSERJK(myHisId),"^",3)
 	..s HisEndDate=$p(^DHCJFUSERJK(myHisId),"^",4)
	.k ^TMP("ZYJF","HisIdInv",myHisId,job)
	.k ^tmp("invsum",job,"HisId",myHisId)
	.s myHisDate=$zd(HisDate,3)
	.s myFootDate=""
 	.s:FootDate'="" myFootDate=$zd(FootDate,3)
 	.s myHisDailyDate=$zd(HisStDate,3)_"至"_$zd(HisEndDate,3)
	.Do OutputRow4
	}
	Quit $$$OK
OutputRow4
	set Data=$lb(mylqno,myHisDate,myHisDailyDate,invno,invnum,invsum,myFootDate,usrname,mylqdate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query FindInvChek(type, stdate, enddate, stnum, endnum, Exp) As websys.Query(ROWSPEC = "lydate:%String,lyqsnum:%String,lynum:%Integer,lyuser:%String,invno:%String,invsum:%Float,AbortNum:%Integer,AbortStr:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.UDHCJFIPBillReportPrint","FindZYJSHzInfo","62825","62829","","ACCat")
ClassMethod FindInvChekExecute(ByRef qHandle As %Binary, type, stdate, enddate, stnum, endnum, Exp) As %Status
{
    set repid=$I(^CacheTemp)
   	set qHandle=$lb(0,repid,0)
    set ind=1
    k ^TMPInvChek("JFInv","InvStr",$j)
    d ..GetInvoiceStr(type,stdate,enddate, stnum, endnum)
    s InvnumStr=$g(^TMPInvChek("JFInv","InvStr",$j))
    f aa=1:1:$l(InvnumStr,"#") d
    .s Invnumarr=$p(InvnumStr,"#",aa)
    .q:Invnumarr=""
    .s StInv=$p(Invnumarr,"^",2),EnInv=$p(Invnumarr,"^",3),InvRowid=$p(Invnumarr,"^",1)
    .;初始化数据
    .s DHCINVInfo("JFInv",$j,"ChekInv",InvRowid,1)=0	;使用张数
 	.s DHCINVInfo("JFInv",$j,"ChekInv",InvRowid,2)=0 ;发票总额
    .s DHCINVInfo("JFInv",$j,"ChekInv",InvRowid,3)=0	;作废张数
 	.s DHCINVInfo("JFInv",$j,"ChekInv",InvRowid,4)="" ;作废发票
	.i (type="O")!(type="E") d
	..s InvEndFlag=0
    ..f Inv=StInv:1:EnInv q:InvEndFlag=1  d
 	...s invlenth=$l(EnInv)-$l(Inv)
 	...i invlenth'=0 d
    ....f i=invlenth:-1:1 d
 	.....s Inv="0"_Inv
 	...i (Exp'="") d
 	....s PrtInv=Exp_Inv
 	...e  s PrtInv=Inv
 	...i '$d(^DHCINVPRT("0","INV",PrtInv)) s InvEndFlag=1
 	...q:InvEndFlag=1
 	...s PrtRowID=""
 	...f  s PrtRowID=$o(^DHCINVPRT("0","INV",PrtInv,PrtRowID))  q:PrtRowID=""  d
 	....q:'$d(PrtRowID)
 	....s printflag=$p($g(^DHCINVPRT(PrtRowID)),"^",3)
    ....q:printflag'="P"
 	....s PrtFlag=$p(^DHCINVPRT(PrtRowID),"^",8)
 	....s Account=$p(^DHCINVPRT(PrtRowID),"^",1)
 	....s PrtUser=$p(^DHCINVPRT(PrtRowID),"^",21)
 	....s ^TMP("ZYJF","ChekInv",InvRowid,$j,PrtInv)="" ;发票号
 	....s DHCINVInfo("JFInv",$j,"ChekInv",InvRowid,1)=$g(DHCINVInfo("JFInv",$j,"ChekInv",InvRowid,1))+1 ;发票张数
 	....i PrtFlag'="A" s DHCINVInfo("JFInv",$j,"ChekInv",InvRowid,2)=$g(DHCINVInfo("JFInv",$j,"ChekInv",InvRowid,2))+Account
 	....i PrtFlag="A" d
 	.....s DHCINVInfo("JFInv",$j,"ChekInv",InvRowid,3)=$g(DHCINVInfo("JFInv",$j,"ChekInv",InvRowid,3))+1 ;作废张数
 	.....s DHCINVInfo("JFInv",$j,"ChekInv",InvRowid,4)=PrtInv_","_$g(DHCINVInfo("JFInv",$j,"ChekInv",InvRowid,4)) ;作废发票
	.i ((type="I")!(type="J")!(type="I")) d
	..s InvEndFlag=0
    ..f Inv=StInv:1:EnInv q:InvEndFlag=1  d
 	...s invlenth=$l(EnInv)-$l(Inv)
 	...i invlenth'=0 d
    ....f i=invlenth:-1:1 d
 	.....s Inv="0"_Inv
 	...i (Exp'="") d
 	....s PrtInv=Exp_Inv
 	...e  s PrtInv=Inv
 	...s PrtRowID=""
 	...f  s PrtRowID=$o(^DHCINVPRTZY("0","INV",PrtInv,PrtRowID))  q:PrtRowID=""  d
 	....i '$d(PrtRowID) s InvEndFlag=1
 	....q:'$d(PrtRowID)
 	....s PrtFlag=$p(^DHCINVPRTZY(PrtRowID),"^",8)
 	....s Account=$p(^DHCINVPRTZY(PrtRowID),"^",6)
 	....s PrtUser=$p(^DHCINVPRTZY(PrtRowID),"^",7)
 	....s ^TMP("ZYJF","ChekInv",InvRowid,$j,PrtInv)="" ;发票号
 	....s DHCINVInfo("JFInv",$j,"ChekInv",InvRowid,1)=$g(DHCINVInfo("JFInv",$j,"ChekInv",InvRowid,1))+1 ;发票张数
 	....i PrtFlag'="A" s DHCINVInfo("JFInv",$j,"ChekInv",InvRowid,2)=$g(DHCINVInfo("JFInv",$j,"ChekInv",InvRowid,2))+Account
 	....i PrtFlag="A" d
 	.....s DHCINVInfo("JFInv",$j,"ChekInv",InvRowid,3)=$g(DHCINVInfo("JFInv",$j,"ChekInv",InvRowid,3))+1 ;作废张数
 	.....s DHCINVInfo("JFInv",$j,"ChekInv",InvRowid,4)=PrtInv_","_$g(DHCINVInfo("JFInv",$j,"ChekInv",InvRowid,4)) ;作废发票
	s myInvRowid="" ,No=0
	f  s myInvRowid=$o(DHCINVInfo("JFInv",$j,"ChekInv",myInvRowid)) q:myInvRowid=""  d
	.s lydate=$p(^DHCINVOICE(myInvRowid),"^",4) ;领用时间
	.s:lydate'="" lydate=$zd(lydate,3)
	.s userdr=$p(^DHCINVOICE(myInvRowid),"^",3)	;
	.s lyuser=$p(^SSU("SSUSR",userdr),"^",2)
	.s Invstnum=$p(^DHCINVOICE(myInvRowid),"^",1)
	.s Invendnum=$p(^DHCINVOICE(myInvRowid),"^",2)
	.s lyqsnum=Invstnum_"-"_Invendnum ;领用起始号
	.s lynum=Invendnum-Invstnum+1 ;领用数量
	.s invnum=$g(DHCINVInfo("JFInv",$j,"ChekInv",myInvRowid,1))
	.s invsum=$g(DHCINVInfo("JFInv",$j,"ChekInv",myInvRowid,2))
	.s AbortNum=$g(DHCINVInfo("JFInv",$j,"ChekInv",myInvRowid,3))
	.s AbortStr=$g(DHCINVInfo("JFInv",$j,"ChekInv",myInvRowid,4))
	.s invno=##class(web.UDHCJFBaseCommon).GetINVNOinfo(myInvRowid,"ChekInv",$j)
	.k DHCINVInfo("JFInv",$j,"ChekInv",myInvRowid)
	.k ^TMP("ZYJF","ChekInv",myInvRowid,$j)
	.Do OutputRow6    
    
	Quit $$$OK
OutputRow6
	set Data=$lb(lydate,lyqsnum,lynum,lyuser,invno,invsum,AbortNum,AbortStr)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod GetInvoiceStr(type, stdate, enddate, stnum, endnum)
{
	n (type, stdate, enddate,stnum,endnum)
	k ^TMPInvChek("JFInv","InvStr",$j)
	s StInvflag=0,Nextnum=""
	s StInv=stnum,EnInv=endnum
	if (StInv'="")&&(EnInv'=""){
	f Inv=StInv:1:EnInv q:StInvflag=1  d
 	.s invlenth=$l(EnInv)-$l(Inv)
 	.i invlenth'=0 d
    ..f i=invlenth:-1:1 d
 	...s Inv="0"_Inv
	.q:'$d(^DHCINVOICE(0,"STNO",Inv))
	.s Invrowid=""
	.f  s Invrowid=$o(^DHCINVOICE(0,"STNO",Inv,Invrowid)) q:Invrowid=""  d
	..s Invtype=$p(^DHCINVOICE(Invrowid),"^",8)
	..q:Invtype'=type
	..s Invstnum=$p(^DHCINVOICE(Invrowid),"^",1)
	..s Invendnum=$p(^DHCINVOICE(Invrowid),"^",2)
	..s StInvflag=1
	..s ^TMPInvChek("JFInv","InvStr",$j)=Invrowid_"^"_Invstnum_"^"_Invendnum
	..s Nextnum=Invendnum+1
	s mynextnum=Nextnum
	i (Nextnum'="")&&(Nextnum<EnInv) d
	.s i=1
	.f i=i:-1:0 d
	..s mynextnum=..GetNextInvoice(type,mynextnum,EnInv)
	..i mynextnum<EnInv s i=1
	}else{
	f pdate=stdate:1:enddate d
	.s Invrowid=""
	.f  s Invrowid=$o(^DHCINVOICE(0,"DAT",pdate,Invrowid)) q:(Invrowid="")  d
	..s Invtype=$p(^DHCINVOICE(Invrowid),"^",8)
	..q:Invtype'=type
	..s Invstnum=$p(^DHCINVOICE(Invrowid),"^",1)
	..s Invendnum=$p(^DHCINVOICE(Invrowid),"^",2)
	..s ^TMPInvChek("JFInv","InvStr",$j)=$g(^TMPInvChek("JFInv","InvStr",$j))_"#"_Invrowid_"^"_Invstnum_"^"_Invendnum	
	}
}

ClassMethod GetNextInvoice(type, Nextnum, EnInv)
{
 	n (type,Nextnum,EnInv)
 	s myNextnum=EnInv
 	s Inv=Nextnum
 	s invlenth=$l(EnInv)-$l(Inv)
 	i invlenth'=0 d
    .f i=invlenth:-1:1 d
 	..s Inv="0"_Inv
	q:'$d(^DHCINVOICE(0,"STNO",Inv)) myNextnum
	s Invrowid=""
	f  s Invrowid=$o(^DHCINVOICE(0,"STNO",Inv,Invrowid)) q:Invrowid=""  d
	.s Invtype=$p(^DHCINVOICE(Invrowid),"^",8)
	.q:Invtype'=type
	.s Invstnum=$p(^DHCINVOICE(Invrowid),"^",1)
	.s Invendnum=$p(^DHCINVOICE(Invrowid),"^",2)
	.s ^TMPInvChek("JFInv","InvStr",$j)=$g(^TMPInvChek("JFInv","InvStr",$j))_"#"_Invrowid_"^"_Invstnum_"^"_Invendnum
	.s myNextnum=Invendnum+1
	q myNextnum
}

ClassMethod FindInvsumByInvStr(user, type, stnum, endnum, Exp)
{
	n (user,type,stnum,endnum,Exp)
	i (type'="O")&&(type'="E") s type="I"
	s StInv=stnum,EnInv=endnum
	i (type="O")!(type="E") d
    .f Inv=StInv:1:EnInv d
 	..s invlenth=$l(EnInv)-$l(Inv)
 	..i invlenth'=0 d
    ...f i=invlenth:-1:1 d
 	....s Inv="0"_Inv
 	..i (Exp'="") d
 	...s PrtInv=Exp_Inv
 	..e  s PrtInv=Inv
 	..s PrtRowID=""
 	..f  s PrtRowID=$o(^DHCINVPRT("0","INV",PrtInv,PrtRowID))  q:PrtRowID=""  d
 	...q:'$d(PrtRowID)
 	...s printflag=$p($g(^DHCINVPRT(PrtRowID)),"^",3)
    ...q:printflag'="P"
 	...s PrtFlag=$p(^DHCINVPRT(PrtRowID),"^",8)
 	...s Account=$p(^DHCINVPRT(PrtRowID),"^",1)
 	...s PrtUser=$p(^DHCINVPRT(PrtRowID),"^",21)
 	...q:PrtUser'=user
 	...s PrtHandin=$p(^DHCINVPRT(PrtRowID),"^",10)
 	...q:PrtHandin'="Y"
 	...s HisId=$p(^DHCINVPRT(PrtRowID),"^",6)
 	...s Paysub="0",PrtCashAmt=0
 	...f  s Paysub=$o(^DHCINVPRT(PrtRowID,"P",Paysub))  q:Paysub=""  d
 	....s paymDr=$p(^DHCINVPRT(PrtRowID,"P",Paysub),"^",1)
 	....s:paymDr'="" paymCode=$p($g(^CT("CTPM",paymDr)),"^",1)
 	....s paymAmt=$p($g(^DHCINVPRT(PrtRowID,"P",Paysub)),"^",3)
 	....i paymCode="CASH" s PrtCashAmt=PrtCashAmt+paymAmt
 	...s ^TMP("ZYJF","HisIdInv",HisId,$j,PrtInv)="" ;发票号
 	...s ^TMPDHCINVInfo("JFInv",$j,"HisId",HisId,1)=$g(^TMPDHCINVInfo("JFInv",$j,"HisId",HisId,1))+1 ;发票张数
 	...s ^TMPDHCINVInfo("JFInv",$j,"HisId",HisId,2)=$g(^TMPDHCINVInfo("JFInv",$j,"HisId",HisId,2))+PrtCashAmt ;现金金额
	
	i type="I" d
    .f Inv=StInv:1:EnInv d
 	..s invlenth=$l(EnInv)-$l(Inv)
 	..i invlenth'=0 d
    ...f i=invlenth:-1:1 d
 	....s Inv="0"_Inv
 	..i (Exp'="") d
 	...s PrtInv=Exp_Inv
 	..e  s PrtInv=Inv
 	..s PrtRowID=""
 	..f  s PrtRowID=$o(^DHCINVPRTZY("0","INV",PrtInv,PrtRowID))  q:PrtRowID=""  d
 	...q:'$d(PrtRowID)
 	...s PrtFlag=$p(^DHCINVPRTZY(PrtRowID),"^",8)
 	...s Account=$p(^DHCINVPRTZY(PrtRowID),"^",6)
 	...s PrtUser=$p(^DHCINVPRTZY(PrtRowID),"^",7)
 	...q:PrtUser'=user
 	...s PrtHandin=$p(^DHCINVPRTZY(PrtRowID),"^",14)
 	...q:PrtHandin'="Y"
 	...s HisId=$p(^DHCINVPRTZY(PrtRowID),"^",23)
 	...s Billno=$p(^DHCINVPRTZY(PrtRowID),"^",5)
 	...s arrcp="",PrtCashAmt=0
	...f  s arrcp=$o(^ARRCP("ARPBL",Billno,arrcp)) q:arrcp=""  d
	....s arral="" 
	....f  s arral=$o(^ARRCP("ARPBL",Billno,arrcp,arral)) q:arral=""  d
	.....s s=^ARRCP(arrcp,"RAL",arral),mytype=$p(s,"^",9),m1=+$p(s,"^",2),billnum=+$p(s,"^",18)   ;type->ARRAL_Deposit_DR(押金类型) billno->ARRAL_ARPBIL_DR
	.....i mytype="" d
	......s paym="0"
	......f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d
	.......s ss=^ARRCP(arrcp,"PAYM",paym) q:ss=""
	.......s mode=$p(ss,"^",1) q:$g(mode)=""
	.......s m2=$p(ss,"^",3) q:$g(m2)=""
	.......s paycode=$p(^CT("CTPM",mode),"^",1)
	.......i paycode="CASH" s PrtCashAmt=PrtCashAmt+m2
 	...s ^TMP("ZYJF","HisIdInv",HisId,$j,PrtInv)="" ;发票号
 	...s ^TMPDHCINVInfo("JFInv",$j,"HisId",HisId,1)=$g(^TMPDHCINVInfo("JFInv",$j,"HisId",HisId,1))+1 ;发票张数
	...s ^TMPDHCINVInfo("JFInv",$j,"HisId",HisId,2)=$g(^TMPDHCINVInfo("JFInv",$j,"HisId",HisId,2))+PrtCashAmt ;现金金额
}

Query FindUser(grp As %String, fptype As %String) As websys.Query(ROWSPEC = "usrname:%String,rowid:%String") [ SqlProc ]
{
}

ClassMethod FindUserExecute(ByRef qHandle As %Binary, grp As %String, fptype As %String) As %Status
{
    set repid=$I(^CacheTemp)
    set qHandle=$lb(0,repid,0)
    set ind=1
    if (grp="")  Quit $$$OK
    s type=fptype 
    s rowid=""
    s rowid=$o(^DHCJFRcptGroupSet(0,"Type",grp,type,""))
    i rowid'="" d
    .s sub=0
    .f  s sub=$o(^DHCJFRcptGroupSet(rowid,"Sub",sub)) q:sub=""  d
    ..s usrrowid=$p(^DHCJFRcptGroupSet(rowid,"Sub",sub),"^",4)
    ..s usrgrp=$p(^DHCJFRcptGroupSet(rowid,"Sub",sub),"^",3)
    ..i $d(^SSU("SSUSR",usrrowid)) s usrname=$p(^SSU("SSUSR",usrrowid),"^",2)
    ..i $d(^SSU("SSGRP",usrgrp)) s usrgrp=$p(^SSU("SSGRP",usrgrp),"^",1)
    ..Do OutputRow15
	Quit $$$OK
OutputRow15
	set Data=$lb(usrname,usrrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetInvoiceStr1(user, type, stdate, enddate, stnum, endnum)
{
	n (user,type, stdate, enddate,stnum,endnum)
	k ^TMPInvChek("JFInv","InvStr",$j)
	s StInvflag=0,Nextnum=""
	s StInv=stnum,EnInv=endnum
	if (StInv'="")&&(EnInv'=""){
	f Inv=StInv:1:EnInv q:StInvflag=1  d
 	.s invlenth=$l(EnInv)-$l(Inv)
 	.i invlenth'=0 d
    ..f i=invlenth:-1:1 d
 	...s Inv="0"_Inv
	.q:'$d(^DHCINVOICE(0,"STNO",Inv))
	.s Invrowid=""
	.f  s Invrowid=$o(^DHCINVOICE(0,"STNO",Inv,Invrowid)) q:Invrowid=""  d
	..s Invtype=$p(^DHCINVOICE(Invrowid),"^",8)
	..q:Invtype'=type
	..s invuser=$p(^DHCINVOICE(Invrowid),"^",3)
	..q:invuser'=user
	..s Invstnum=$p(^DHCINVOICE(Invrowid),"^",1)
	..s Invendnum=$p(^DHCINVOICE(Invrowid),"^",2)
	..s StInvflag=1
	..s ^TMPInvChek("JFInv","InvStr",$j)=Invrowid_"^"_Invstnum_"^"_Invendnum
	..s Nextnum=Invendnum+1
	s mynextnum=Nextnum
	i (Nextnum'="")&&(Nextnum<EnInv) d
	.s i=1
	.f i=i:-1:0 d
	..s mynextnum=..GetNextInvoice(type,mynextnum,EnInv)
	..i mynextnum<EnInv s i=1
	}else{
	f pdate=stdate:1:enddate d
	.s Invrowid=""
	.f  s Invrowid=$o(^DHCINVOICE(0,"DAT",pdate,Invrowid)) q:(Invrowid="")  d
	..s Invtype=$p(^DHCINVOICE(Invrowid),"^",8)
	..q:Invtype'=type
	..s invuser=$p(^DHCINVOICE(Invrowid),"^",3)
	..q:invuser'=user
	..s Invstnum=$p(^DHCINVOICE(Invrowid),"^",1)
	..s Invendnum=$p(^DHCINVOICE(Invrowid),"^",2)
	..s ^TMPInvChek("JFInv","InvStr",$j)=$g(^TMPInvChek("JFInv","InvStr",$j))_"#"_Invrowid_"^"_Invstnum_"^"_Invendnum	
	}
}

Query FindRcptsum(user, type, stdate, enddate, stnum, endnum, Exp, datetype) As websys.Query(ROWSPEC = "mylqno:%String,myHisDate:%String,myHisDailyDate:%String,invno:%String,invnum:%Integer,invsum:%Float,myFootDate:%String,usrname:%String,mylqdate:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.UDHCJFIPBillReportPrint","FindRcptsum","639","","","","0001","1100","")
ClassMethod FindRcptsumExecute(ByRef qHandle As %Binary, user, type, stdate, enddate, stnum, endnum, Exp, datetype) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    set ind=1
    set job=$j
    if (((stnum'="")&(endnum'=""))!(datetype=3))
    { 
    d ..GetReceiptStr(user,type, stdate, enddate, stnum, endnum)
    s InvnumStr=$g(^TMPInvChek("JFInv","RcptStr",$j))
    f aa=1:1:$l(InvnumStr,"#") d
    .s Invnumarr=$p(InvnumStr,"#",aa)
    .q:Invnumarr=""
    .s StInv=$p(Invnumarr,"^",2),EnInv=$p(Invnumarr,"^",3),InvRowid=$p(Invnumarr,"^",1)
    .s Exp="" ;$p(^DHCINVOICE(InvRowid),"^",16)
    .d ..FindReceiptsumByInvStr(user,type,StInv,EnInv,Exp)
    s myHisId="" ,No=0,mylqno="",mylqdate=""
	f  s myHisId=$o(^TMPDHCINVInfo("JFInv",$j,"HisId",myHisId)) q:myHisId=""  d
	.s usrno=$p(^SSU("SSUSR",user),"^",1)
	.s usrname=$p(^SSU("SSUSR",user),"^",2)
	.s invnum=$g(^TMPDHCINVInfo("JFInv",$j,"HisId",myHisId,1))
	.s invsum=$g(^TMPDHCINVInfo("JFInv",$j,"HisId",myHisId,2))
	.s invno=##class(web.UDHCJFBaseCommon).GetINVNOinfo(myHisId,"HisIdInv",$j)
	.s mytmpno=$p(invno,"--",2)
	.s mytmpnoStr=##class(web.UDHCJFBaseCommon).GetINVPreABCInfo(mytmpno)
	.s mytmpno=$p(mytmpnoStr,"^",1)
	.s myinvid="",myinvflag=0
	.f  s myinvid=$o(^DHCSFRECEIPT(0,"user",user,myinvid),-1) q:(myinvid="")!(myinvflag=1)  d
	..s myinvstno=$p(^DHCSFRECEIPT(myinvid),"^",3)
	..s myinvendno=$p(^DHCSFRECEIPT(myinvid),"^",4)
	..i (mytmpno'<myinvstno)&&(mytmpno'>myinvendno) d
	...s mylqno=myinvstno_"-"_myinvendno
	...s mylqdate=$zd($p(^DHCSFRECEIPT(myinvid),"^",1),3)
	...s myinvflag=1
	.s HisDate=$p(^DHCJFUSERJK(myHisId),"^",1)
 	.s FootDate=$p(^DHCJFUSERJK(myHisId),"^",7)
 	.s HisStDate=$p(^DHCJFUSERJK(myHisId),"^",3)
 	.s HisEndDate=$p(^DHCJFUSERJK(myHisId),"^",4)
 	.k ^TMPDHCINVInfo("JFInv",$j,"HisId",myHisId)
	.k ^TMP("ZYJF","HisIdInv",myHisId,$j)
	.s myHisDate=$zd(HisDate,3)
	.s myFootDate=""
 	.s:FootDate'="" myFootDate=$zd(FootDate,3)
 	.s myHisDailyDate=$zd(HisStDate,3)_"至"_$zd(HisEndDate,3)
	.Do OutputRow13    
    }else{
	i datetype="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s stdate=$g(stdate)
    i stdate=""  s stdate=$h
    s enddate=$g(enddate)
    i enddate=""  s enddate=$h
    s job=$j
    
    i datetype=0 s IndexDate="date" ;按日报日期
    i datetype=1 s IndexDate="inceptdate" ;按接收日期
    i datetype'=2 d
  	.f pdate=stdate:1:enddate d
    ..s FootHisid=""
    ..f  s FootHisid=$o(^DHCJFUSERJK(0,IndexDate,pdate,FootHisid)) q:FootHisid=""  d
    ...q:$d(^DHCJFUSERJK(FootHisid))=10
    ...d ..GetIPRcptInfo(stdate,enddate,FootHisid,user,job,type)
    e  d
    .d ..GetIPRcptInfo(stdate,enddate,"",user,job,type)
    s myHisId="" ,No=0,mylqno="",mylqdate=""
	f  s myHisId=$o(^tmp("invsum",job,"HisId",myHisId)) q:myHisId=""  d
	.s usrno=$p(^SSU("SSUSR",user),"^",1)
	.s usrname=$p(^SSU("SSUSR",user),"^",2)
	.s invnum=$g(^tmp("invsum",job,"HisId",myHisId,1))
	.s invsum=$g(^tmp("invsum",job,"HisId",myHisId,2))
	.s invno=##class(web.UDHCJFBaseCommon).GetINVNOinfo(myHisId,"HisIdInv",$j)
	.s mytmpno=$p(invno,"--",2)
	.s mytmpnoStr=##class(web.UDHCJFBaseCommon).GetINVPreABCInfo(mytmpno)
	.s mytmpno=$p(mytmpnoStr,"^",1)
	.s myinvid="",myinvflag=0
	.f  s myinvid=$o(^DHCSFRECEIPT(0,"user",user,myinvid),-1) q:(myinvid="")!(myinvflag=1)  d
	..s myinvstno=$p(^DHCSFRECEIPT(myinvid),"^",3)
	..s myinvendno=$p(^DHCSFRECEIPT(myinvid),"^",4)
	..i (mytmpno'<myinvstno)&&(mytmpno'>myinvendno) d
	...s mylqno=myinvstno_"-"_myinvendno
	...s mylqdate=$zd($p(^DHCSFRECEIPT(myinvid),"^",1),3)
	...s myinvflag=1
	.s HisDate=$p(^DHCJFUSERJK(myHisId),"^",1)
 	.s FootDate=$p(^DHCJFUSERJK(myHisId),"^",7)
 	.s HisStDate=$p(^DHCJFUSERJK(myHisId),"^",3)
 	.s HisEndDate=$p(^DHCJFUSERJK(myHisId),"^",4)
	.k ^TMP("ZYJF","HisIdInv",myHisId,job)
	.k ^tmp("invsum",job,"HisId",myHisId)
	.s myHisDate=$zd(HisDate,3)
	.s myFootDate=""
 	.s:FootDate'="" myFootDate=$zd(FootDate,3)
 	.s myHisDailyDate=$zd(HisStDate,3)_"至"_$zd(HisEndDate,3)
	.Do OutputRow13
	}
    
	quit $$$OK
OutputRow13
	set Data=$lb(mylqno,myHisDate,myHisDailyDate,invno,invnum,invsum,myFootDate,usrname,mylqdate)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod GetReceiptStr(user, type, stdate, enddate, stnum, endnum)
{
	n (user,type, stdate, enddate,stnum,endnum)
	k ^TMPInvChek("JFInv","RcptStr",$j)
	s Stflag=0,Nextnum=""
	s St=stnum,En=endnum
	if (St'="")&&(En'=""){
	f Rcpt=St:1:En q:Stflag=1  d
 	.s invlenth=$l(En)-$l(Rcpt)
 	.i invlenth'=0 d
    ..f i=invlenth:-1:1 d
 	...s Rcpt="0"_Rcpt
	.q:'$d(^DHCSFRECEIPT(0,"STNO",Rcpt))
	.s rcptrowid=""
	.f  s rcptrowid=$o(^DHCSFRECEIPT(0,"STNO",Rcpt,rcptrowid)) q:rcptrowid=""  d
	..s Rcptuser=$p(^DHCSFRECEIPT(rcptrowid),"^",8)
	..q:Rcptuser'=user
	..s Rcptstnum=$p(^DHCSFRECEIPT(rcptrowid),"^",3)
	..s Rcptendnum=$p(^DHCSFRECEIPT(rcptrowid),"^",4)
	..s Stflag=1
	..s ^TMPInvChek("JFInv","RcptStr",$j)=rcptrowid_"^"_Rcptstnum_"^"_Rcptendnum
	..s Nextnum=Rcptendnum+1
	s mynextnum=Nextnum
	i (Nextnum'="")&&(Nextnum<En) d
	.s i=1
	.f i=i:-1:0 d
	..s mynextnum=..GetNextRcpt(type,mynextnum,En)
	..i mynextnum<En s i=1
	}else{
	f pdate=stdate:1:enddate d
	.s rcptrowid=""
	.f  s rcptrowid=$o(^DHCSFRECEIPT(0,"Date",pdate,rcptrowid)) q:(rcptrowid="")  d
	..s invuser=$p(^DHCSFRECEIPT(rcptrowid),"^",8)
	..q:invuser'=user
	..s Rcptstnum=$p(^DHCSFRECEIPT(rcptrowid),"^",3)
	..s Rcptendnum=$p(^DHCSFRECEIPT(rcptrowid),"^",4)
	..s ^TMPInvChek("JFInv","RcptStr",$j)=$g(^TMPInvChek("JFInv","RcptStr",$j))_"#"_rcptrowid_"^"_Rcptstnum_"^"_Rcptendnum	
	}
}

ClassMethod FindReceiptsumByInvStr(user, type, stnum, endnum, Exp)
{
	n (user,type,stnum,endnum,Exp)
	s StRcpt=stnum,EnRcpt=endnum
    f Rcpt=StRcpt:1:EnRcpt d
 	.s invlenth=$l(EnRcpt)-$l(Rcpt)
 	.i invlenth'=0 d
    ..f i=invlenth:-1:1 d
 	...s Rcpt="0"_Rcpt
 	.i (Exp'="") d
 	..s PrtRcpt=Exp_Rcpt
 	.e  s PrtRcpt=Rcpt
 	.s PrtRowID=""
 	.f  s PrtRowID=$o(^DHCSFPRINTDETAIL("0","RcptNo",PrtRcpt,PrtRowID))  q:PrtRowID=""  d
 	..q:'$d(PrtRowID)
 	..s PrtFlag=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",8)
 	..s Account=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",6)
 	..s PrtUser=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",14)
 	..q:PrtUser'=user
 	..s PrtHandin=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",23)
 	..q:PrtHandin'="Y"
 	..s HisId=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",30)
 	..s ^TMP("ZYJF","HisIdInv",HisId,$j,PrtRcpt)="" ;发票号
 	..s ^TMPDHCINVInfo("JFInv",$j,"HisId",HisId,1)=$g(^TMPDHCINVInfo("JFInv",$j,"HisId",HisId,1))+1 ;发票张数
 	..i PrtFlag'=2 s ^TMPDHCINVInfo("JFInv",$j,"HisId",HisId,2)=$g(^TMPDHCINVInfo("JFInv",$j,"HisId",HisId,2))+Account ;现金金额
}

ClassMethod GetNextRcpt(type, Nextnum, En)
{
	n (type,Nextnum,En)
 	s myNextnum=En
 	s Rcpt=Nextnum
 	s invlenth=$l(En)-$l(Rcpt)
 	i invlenth'=0 d
    .f i=invlenth:-1:1 d
 	..s Rcpt="0"_Rcpt
	q:$d(^DHCSFRECEIPT(0,"STNO",Rcpt))=0 myNextnum
	s rcptrowid=""
	f  s rcptrowid=$o(^DHCSFRECEIPT(0,"STNO",Rcpt,rcptrowid)) q:rcptrowid=""  d
	.s Rcptstnum=$p(^DHCSFRECEIPT(rcptrowid),"^",3)
	.s Rcptendnum=$p(^DHCSFRECEIPT(rcptrowid),"^",4)
	.s ^TMPInvChek("JFInv","RcptStr",$j)=$g(^TMPInvChek("JFInv","RcptStr",$j))_"#"_rcptrowid_"^"_Rcptstnum_"^"_Rcptendnum
	.s myNextnum=Rcptendnum+1
	q myNextnum
}

ClassMethod GetIPRcptInfo(Stdate, Enddate, HisId, user, job, type)
{
	i HisId'="" d
	.s PrtRowID=""
 	.f  s PrtRowID=$o(^DHCSFPRINTDETAIL("0","JKDR",HisId,PrtRowID))  q:PrtRowID=""  d
 	..q:'$d(PrtRowID)
 	..s PrtFlag=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",8)
 	..s Account=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",6)
 	..s PrtUser=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",14)
 	..q:PrtUser'=user
 	..s PrtHandin=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",23)
 	..q:PrtHandin'="Y"
 	..s HisId=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",30)
 	..s PrtInv=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",1)
 	..i PrtInv'="" d 
 	...s ^TMP("ZYJF","HisIdInv",HisId,job,PrtInv)="" ;发票号
 	...s ^tmp("invsum",job,"HisId",HisId,1)=$g(^tmp("invsum",job,"HisId",HisId,1))+1 ;发票张数
 	..s ^tmp("invsum",job,"HisId",HisId,2)=$g(^tmp("invsum",job,"HisId",HisId,2))+Account ;现金金额
	e  d
	.f prtdate=Stdate:1:Enddate d
	..s PrtRowID=""
 	..f  s PrtRowID=$o(^DHCSFPRINTDETAIL(0,"PrtDate",prtdate,PrtRowID))  q:PrtRowID=""  d
 	...q:'$d(PrtRowID)
 	...s PrtFlag=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",8)
 	...s Account=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",6)
 	...s PrtUser=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",14)
 	...q:PrtUser'=user
 	...s PrtHandin=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",23)
 	...q:PrtHandin'="Y"
 	...s HisId=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",30)
 	...s PrtInv=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",1)
 	...i PrtInv'="" d 
 	....s ^TMP("ZYJF","HisIdInv",HisId,job,PrtInv)="" ;发票号
 	....s ^tmp("invsum",job,"HisId",HisId,1)=$g(^tmp("invsum",job,"HisId",HisId,1))+1 ;发票张数
 	...s ^tmp("invsum",job,"HisId",HisId,2)=$g(^tmp("invsum",job,"HisId",HisId,2))+Account ;现金金额
 	
 	q
}

}
