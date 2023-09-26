Class web.UDHCJFEPDailyHand Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

//急诊卡预交金收费员日报表

ClassMethod FindPreDepositExecute(ByRef qHandle As %Binary, StDate, EndDate, Guser, Handin, JkDr) As %Status
{
    //dhc_predeposit,dhc_accprepaymode
    //d ##class(%ResultSet).RunQuery("web.UDHCJFEPDailyHand","FindPreDeposit","61010","61111","5","Y","")
    s Job=$j
    Set repid=$I(^CacheTemp)
    i (StDate="") Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    s ind=1
    if $d(^TMP("MZJF","EPPreDeptDailyHand",Guser,Job))  k ^TMP("MZJF","EPPreDeptDailyHand",Guser,Job)
    s (PrtStatus,PrtDate,PrtTime,PatName,PatNo,PayAmt,PayModeDesc,PreRowid)=""
    i JkDr="" d   //未交帐日报表
    .d ..GetPreDepositNotHandin(StDate, EndDate,Guser,Handin,JkDr)
    e  d         //已交帐报表
    .d ..GetPreDepositHandin(StDate, EndDate,JkDr)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindPreDepositFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPreDepositExecute ]
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

ClassMethod FindPreDepositClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPreDepositExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

//显示预交金明细打印日期，打印时间,病人姓名，登记号，金额，支付方式，rowid,job

Query FindPreDeposit(StDate, EndDate, Guser, Handin, JkDr) As %Query(ROWSPEC = "TPrtDate:%String,TPrtTime:%String,TPatName:%String,TPatNo:%String,TPayAmt:%String,TPayMode:%String,TPrtStatus:%String,TRowId:%String,TJob:%String,TBillNum:%String,TEncryptLevel,TPatLevel")
{
}

ClassMethod GetPreDepositNotHandin(StDate, EndDate, Guser, Handin, JkDr)
{
    ;收费员未交帐预交金明细
    ;s StDate=$zdh(StDate,1)
    ;s EndDate=$zdh(EndDate,1)
    s n=0,Sum=0
    s AcBillNo="",JSDate="",JSTime=""	
    f PreDate=StDate:1:EndDate   d
    .s RowId="0"
    .f  s RowId=$o(^DHCACDi("AccM",0,"APDDate",PreDate,RowId)) q:RowId=""  d
    ..s ChildSub="0"
    ..f  s ChildSub=$o(^DHCACDi("AccM",0,"APDDate",PreDate,RowId,"AccPD",ChildSub)) q:ChildSub=""  d
    ...s PrtDepositInfo=$g(^DHCACD("AccM",RowId,"AccPD",ChildSub))
    ...s PrtDate=PreDate
    ...s:PrtDate'="" PrtDate=$zd(PrtDate,3)
    ...s PrtTime=$p(PrtDepositInfo,"^",4)
    ...s:PrtTime'="" PrtTime=$zt(PrtTime)
    ...s PapmiRowid=$p(^DHCACD("AccM",RowId),"^",2)
    ...s AcBillNo=$p(PrtDepositInfo,"^",6)
    ...q:(PapmiRowid="")
    ...q:($d(^PAPER(PapmiRowid))=0)
    ...s PatName=$p(^PAPER(PapmiRowid,"ALL"),"^",1)
    ...s PatNo=$p(^PAPER(PapmiRowid,"PAT",1),"^",1)
    ...;add by wangjian 2015-01-15 增加病人密级和级别
	...Set EncryptLevel="",PatLevel=""
    ...Set PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(PapmiRowid,"")
    ...Set EncryptLevel=$p(PatEncryptLevel,"^",1)
    ...Set PatLevel=$p(PatEncryptLevel,"^",2)
    ...;end
    ...s PrtStatus=$p(PrtDepositInfo,"^",1)
    ...s Status=PrtStatus
    ...i PrtStatus["P"  s Status="交款"
    ...i PrtStatus["R"  s Status="退款"
    ...s PrtUser=$p(PrtDepositInfo,"^",5)   ;;;;Guser
    ...s PrtJKDr=$p(PrtDepositInfo,"^",7)
    ...q:((Handin="N")&&(PrtJKDr'=""))
    ...q:((Handin="")&&(PrtJKDr'=""))
    ...q:(PrtUser'=Guser)&(Guser'="")
    ...s n=n+1
    ...s PayAmt=0
    ...s PayModeChildSub="0"
    ...f  s PayModeChildSub=$o(^DHCACD("AccM",RowId,"AccPD",ChildSub,"P",PayModeChildSub)) q:PayModeChildSub=""  d
    ....s PayAmt=$p(^DHCACD("AccM",RowId,"AccPD",ChildSub,"P",PayModeChildSub),"^",6)
    ....s PayMode=$p(^DHCACD("AccM",RowId,"AccPD",ChildSub,"P",PayModeChildSub),"^",1)
    ....i (PayMode'="")&&($d(^CT("CTPM",PayMode))) d
    .....s PayModeDesc=$p($g(^CT("CTPM",PayMode)),"^",2)
    ....s PreRowid=RowId_"||"_ChildSub
    ...d OutputRow
    ...s Sum=Sum+PayAmt
    if (n>0)
    {
	    s (PrtDate,PrtTime,PatName,PatNo,PayModeDesc,Status,PreRowid,AcBillNo,JSDate,JSTime,EncryptLevel,PatLevel)=""
	    s Guser=""
	    s PayAmt=Sum
	    s PatName="合计"
	    d OutputRow
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    s:Guser'="" ^TMP("MZJF","EPPreDeptDailyHand",Guser,Job,ind)=PrtDate_"^"_PrtTime_"^"_PatName_"^"_PatNo_"^"_PayAmt_"^"_PayModeDesc_"^"_PrtStatus_"^"_PreRowid_"^"_Job_"^"_AcBillNo_"^"_JSDate_"^"_JSTime //add by wangli 2008-07-27
	set Data=$lb(PrtDate,PrtTime,PatName,PatNo,PayAmt,PayModeDesc,Status,PreRowid,Job,AcBillNo,EncryptLevel,PatLevel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPreDepositHandin(StDate, EndDate, JkDr)
{
   //按照交帐Rowid，查询收费员预交金交款明细
    s n=0,Sum=0
    s AcBillNo="",PayModeDesc=""
    s RowId=""
    f  s RowId=$o(^DHCACDi("AccM",0,"PDFootDR",JkDr,RowId)) q:RowId=""  d
    .s ChildSub="0"
    .;f  s ChildSub=$o(^DHCACDi("AccM",0,"APDDate",PreDate,RowId,"AccPD",ChildSub)) q:ChildSub=""  d  
    .f  s ChildSub=$o(^DHCACDi("AccM",0,"PDFootDR",JkDr,RowId,"AccPD",ChildSub)) q:ChildSub=""  d       ;;update by zhl  081110
    ..s PrtDepositInfo=^DHCACD("AccM",RowId,"AccPD",ChildSub)
    ..s PrtDate=$p(PrtDepositInfo,"^",3),PrtTime=$p(PrtDepositInfo,"^",4)
    ..S JKRowid=$p(PrtDepositInfo,"^",7)
    ..Q:JkDr'=JKRowid
    ..s JSDate=$p(PrtDepositInfo,"^",11),JSTime=$p(PrtDepositInfo,"^",12)
    ..s:PrtDate'="" PrtDate=$zd(PrtDate,3)
    ..s:PrtTime'="" PrtTime=$zt(PrtTime)
    ..s PapmiRowid=$p(^DHCACD("AccM",RowId),"^",2)
    ..s AcBillNo=$p(PrtDepositInfo,"^",6)
    ..q:($d(^PAPER(PapmiRowid))=0)
    ..s PatName=$p(^PAPER(PapmiRowid,"ALL"),"^",1)
    ..s PatNo=$p(^PAPER(PapmiRowid,"PAT",1),"^",1)
    ..;add by wangjian 2015-01-15 增加病人密级和级别
	..Set EncryptLevel="",PatLevel=""
    ..Set PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(PapmiRowid,"")
    ..Set EncryptLevel=$p(PatEncryptLevel,"^",1)
    ..Set PatLevel=$p(PatEncryptLevel,"^",2)
    ..;end
    ..s PrtStatus=$p(PrtDepositInfo,"^",1)
    ..s Status=PrtStatus
    ..i PrtStatus["P"  s Status="交款"
    ..i PrtStatus["R"  s Status="退款"
    ..i PrtStatus["F"  s Status="结算"
    ..s PrtUser=$p(PrtDepositInfo,"^",5)
    ..q:(PrtUser'=Guser)&(Guser'="")
    ..s PrtJKDr=$p(PrtDepositInfo,"^",7)
    ..s n=n+1
    ..s PayAmt=0
    ..s PayModeChildSub="0"
    ..f  s PayModeChildSub=$o(^DHCACD("AccM",RowId,"AccPD",ChildSub,"P",PayModeChildSub)) q:PayModeChildSub=""  d
    ...s PayAmt=$p(^DHCACD("AccM",RowId,"AccPD",ChildSub,"P",PayModeChildSub),"^",6)
    ...s PayMode=$p(^DHCACD("AccM",RowId,"AccPD",ChildSub,"P",PayModeChildSub),"^",1)
    ...i (PayMode'="")&&($d(^CT("CTPM",PayMode)))  d
    ....s PayModeDesc=$p(^CT("CTPM",PayMode),"^",2)
    ...s PreRowid=RowId_"||"_ChildSub
    ..d OutputRow1
    ..s Sum=Sum+PayAmt
    if (n>0)
    {
	    s (PrtDate,PrtTime,PatName,PatNo,PayModeDesc,Status,PreRowid,AcBillNo,JSDate,JSTime,EncryptLevel,PatLevel)=""
	    s Guser=""
	    s PayAmt=Sum
	    s PatName="合计"
	    d OutputRow1
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
    s:Guser'="" ^TMP("MZJF","EPPreDeptDailyHand",Guser,Job,ind)=PrtDate_"^"_PrtTime_"^"_PatName_"^"_PatNo_"^"_PayAmt_"^"_PayModeDesc_"^"_PrtStatus_"^"_PreRowid_"^"_Job_"^"_AcBillNo_"^"_JSDate_"^"_JSTime //add by wangli 2008-07-27
	set Data=$lb(PrtDate,PrtTime,PatName,PatNo,PayAmt,PayModeDesc,Status,PreRowid,Job,AcBillNo,EncryptLevel,PatLevel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindInvDailyExecute(ByRef qHandle As %Binary, StDate, EndDate, Guser, Handin, JkDr, AccountFlag, UserCode) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.UDHCJFEPDailyHand","FindInvDaily","61977","61980","639","on","1518","")
    //dhc_predeposit,dhc_accprepaymode
    ;s ^TMPOPINV=StDate_"^"_EndDate_"^"_Guser_"^"_Handin_"^"_JkDr_"^"_AccountFlag_"^"_UserCode
	Set repid=$I(^CacheTemp)
    i (StDate="") Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    s ind=1
    s job=$j
    s ZCInvNum=1,YYInvNum=1,TZInvNum=1
    if AccountFlag="on" d 
    .i UserCode="" s Guser="ALL"
    .e  s Guser=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))                                        
 
    k ^TMP("OPCate",Guser,job)
	k ^TMP("AllOPCate",Guser,job)
	k ^TMP("HZOPCate",Guser,job)
	k ^TMP("OPPayMode",Guser,job)
	k ^TMP("OPRegType",Guser,job)
	k ^TMP("ZYJF","ZCINV",Guser)
	k ^TMP("ZYJF","TZINV",Guser)
	k ^TMP("ZYJF","YYINV",Guser)
	k ^TMP("MZJF","EPInvCTDaily",Guser)
	s TarOcRowID=0
    f  s TarOcRowID=$o(^DHCTarC("TOC",TarOcRowID))  q:TarOcRowID=""  d
    .s OPCatDesc=$p(^DHCTarC("TOC",TarOcRowID),"^",2)
    .s SessionRowID=0
    .f  s SessionRowID=$o(^PAC("IPAT",SessionRowID)) q:SessionRowID=""  d
    ..s SessionTypeCode=$p(^PAC("IPAT",SessionRowID),"^",1)
	..s ^TMP("OPCate",Guser,job,SessionTypeCode,OPCatDesc)=0
	
	s CTNum=1
    if $d(^TMP("MZJF","EPInvDailyHand",Guser,job))  k ^TMP("MZJF","EPInvDailyHand",Guser,job)
    if $d(^TMP("EPInvDailyHand/No",Guser))  k ^TMP("EPInvDailyHand/No",Guser)
    s (invno,prtuser,prtdate,prttime,PatName,PatNo,paymsum,paym,flag,amt,handdr)=""
   
    i Handin=""  d
    .d ..GetInvNotHandin(StDate, EndDate,Guser,Handin,JkDr,Guser)
    e  d         //已交帐报表
    .d ..GetInvHandin(JkDr,Guser)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindInvDailyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInvDailyExecute ]
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

ClassMethod FindInvDailyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInvDailyExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

//显示预交金明细打印日期，打印时间,病人姓名，登记号，金额，支付方式，rowid,job

Query FindInvDaily(StDate, EndDate, Guser, Handin, JkDr, AccountFlag, UserCode) As %Query(ROWSPEC = "TINVno:%String,TPrtuser:%String,TPrtDate:%String,TPrtTime:%String,TPatName:%String,TPatNo:%String,TPayAmt:%String,TPayMode:%String,TPrtStatus:%String,Tamt:%String,TRowId:%String,Tinitinv:%String,TJob:%String")
{
}

ClassMethod GetInvNotHandin(StDate, EndDate, Guser, Handin, JkDr, CurUserId)
{
   //收费员未交帐预交金明细???门诊收费日报--未交账发票明细 add by wangli
    s n=0,Sum=0,PaySum=0
    s refaccdr="",initinv="",StrikeFeeSum=0
	f Date=StDate:1:EndDate d
    .s RowId=""
    .f  s RowId=$o(^DHCINVPRT(0,"Date",Date,RowId)) q:RowId=""  d
    ..s invInfo=$g(^DHCINVPRT(RowId))
    ..s handdr=$p(invInfo,"^",6)
    ..q:handdr'=""
    ..s flag=$p(invInfo,"^",8)
    ..//add by lichao 20100510
    ..s BilConInv="0"
	..f  s BilConInv=$o(^DHCBCI(0,"INV",RowId,BilConInv)) q:BilConInv=""  d
	...s PatBillDr=$p(^DHCBCI(BilConInv),"^",2) 
	...s PBAmt=$p(^DHCPB(PatBillDr),"^",8)
	...s PatAdm=$p(^DHCBCI(BilConInv),"^",3)
	...s PaadmSession=$p(^PAADM(PatAdm,2),"^",28)  ;区分特诊，正常诊，业务诊
	...i PaadmSession'="" s SessionTypeCode=$p(^PAC("IPAT",PaadmSession),"^",1)  ;PAC_InPatAdmissionType
    ...e  s SessionTypeCode="Z"
    ..s prtfairtype=$p(invInfo,"^",34)
    ..//q:prtfairtype'="F"
    ..s prinvptrflag=$p(invInfo,"^",3)
    ..q:prinvptrflag'="P"
    ..s prtaccdr=$p(invInfo,"^",4)
    ..q:prtaccdr'=""
    ..s prtuser=$p(invInfo,"^",21)
    ..q:((Guser'="ALL")&(prtuser'=Guser))
    ..s prtuser=$p(invInfo,"^",21)
    ..s paym=$p(^DHCINVPRT(RowId,"P",1),"^",1)
    ..s amt=$p(invInfo,"^",1)
    ..s prtdate=$p(invInfo,"^",5)
    ..s prttime=$p(invInfo,"^",20)
    ..s invno=$p(invInfo,"^",14)   
    ..s initinv=$p(invInfo,"^",13)
    ..;start add by tangtao 2010-09-01
    ..s oldinv=$p(^DHCINVPRT(RowId),"^",13)
    ..i oldinv'="" d
    ...s NewInvRowID=""
    ...s NewInvRowID=$o(^DHCINVPRT(0,"OldINV",oldinv,NewInvRowID))
    ...i NewInvRowID'="" d
    ....s newinv=$p(^DHCINVPRT(NewInvRowID),"^",14)
    ....s newamt=$p(^DHCINVPRT(NewInvRowID),"^",1)
    ...e  d
    ....s newamt=0
    ....s newinv=""
    ...s StrikeFee=$g(amt)+$g(newamt)
    ...s StrikeFeeSum=StrikeFeeSum+StrikeFee

    ..;end
    ..s refaccdr=""
    ..i initinv'=""  s refaccdr=$p(^DHCINVPRT(initinv),"^",4)
    ..q:refaccdr'=""  
    ..s papmi=$p($p(invInfo,"^",15),$c(1))
    ..s paymsum=$p($g(^DHCINVPRT(RowId,"P",1)),"^",3)
    ..s:paym'="" paym=$p($g(^CT("CTPM",paym)),"^",2)
    ..i initinv'=""  s initinv=$p(^DHCINVPRT(initinv),"^",14)
    ..s:prtuser'="" prtuser=$p($g(^SSU("SSUSR",prtuser)),"^",2)
    ..s PatName=$p(^PAPER(papmi,"ALL"),"^",1)
    ..s PatNo=$p(^PAPER(papmi,"PAT",1),"^",1)
    ..i flag="N"  s flag="正常"
    ..i flag="A"  s flag="作废"
    ..i flag="S"  s flag="红冲"
    ..s:prtdate'="" prtdate=$zd(prtdate,3)
    ..s:prttime'="" prttime=$zt(prttime)
    ..d ..GetInvDetail(RowId,Guser,SessionTypeCode)
    ..d OutputRow3
    ..s n=n+1
    ..s Sum=Sum+amt
  
    .s accrowid=""
    .f  s accrowid=$o(^DHCINVPRTAPi(0,"Date",Date,accrowid)) q:accrowid=""  d
    ..s handdr=$p(^DHCINVPRTAP(accrowid),"^",20)
    ..q:handdr'=""
    ..s invno=$p(^DHCINVPRTAP(accrowid),"^",6)
    ..s prtuser=$p(^DHCINVPRTAP(accrowid),"^",5)
    ..q:((Guser'="")&(prtuser'=Guser))
    ..s prtdate=$p(^DHCINVPRTAP(accrowid),"^",3)
    ..s prttime=$p(^DHCINVPRTAP(accrowid),"^",4)
    ..s papmi=$p(^DHCINVPRTAP(accrowid),"^",11)
    ..s paymsum=$p(^DHCINVPRTAP(accrowid),"^",1)
    ..s paym=$p(^DHCINVPRTAP(accrowid,"P",1),"^",1)
    ..s flag=$p(^DHCINVPRTAP(accrowid),"^",2)
    ..s amt=$p(^DHCINVPRTAP(accrowid),"^",1)
    ..s initinv=$p(^DHCINVPRTAP(accrowid),"^",10)
    ..s:paym'="" paym=$p($g(^CT("CTPM",paym)),"^",2)
    ..s:prtuser'="" prtuser=$p($g(^SSU("SSUSR",prtuser)),"^",2)
    ..s PatName=$p(^PAPER(papmi,"ALL"),"^",1)
    ..s PatNo=$p(^PAPER(papmi,"PAT",1),"^",1)
    ..i flag="N"  s flag="正常"
    ..i flag="A"  s flag="作废"
    ..i flag="S"  s flag="红冲"
    ..s:prtdate'="" prtdate=$zd(prtdate,3)
    ..s:prttime'="" prttime=$zt(prttime)
    ..s RowId=accrowid
     ..s SessionTypeCode="Z"
    ..s AccLink=""  //User.DHCAccPINVCONPRT
    ..f  s AccLink=$o(^DHCINVPRTCAPi(0,"APINVDR",accrowid,AccLink))  q:AccLink=""  d
    ...s AccLInv=$p($g(^DHCINVPRTCAP(AccLink)),"^",1) //dhc_invprt.prt_rowid
    ...i flag="正常" d
    ....d ..GetInvDetail(AccLInv,Guser,SessionTypeCode)
    ..d OutputRow3
    ..s n=n+1
    ..s Sum=Sum+amt
   
    ..;s StrikeFee=$g(amt)+$g(newamt)   
	s (newinv,invno,prtuser,prtdate,prttime,PatName,PatNo,StrikeFee,PayModeList,flag,amt,handdr,initinv,paym)=""

	s StrikeFee=StrikeFeeSum
	s amt=Sum
	s PatName="合计"
	s Guser=""
    s ^TMP("MZJF","EPInvCTDaily",CurUserId,CTNum)=invno_"^"_prtuser_"^"_prtdate_" "_prttime_"^"_PatName_"^"_PatNo_"^"_StrikeFee_"^"_flag_"^"_paym_"^"_initinv_"^"_newinv
	d OutputRow3
    q
OutputRow3   
    i ((flag'="正常")&&(amt<0))  d
    .s ^TMP("MZJF","EPInvCTDaily",CurUserId,CTNum)=invno_"^"_prtuser_"^"_prtdate_" "_prttime_"^"_PatName_"^"_PatNo_"^"_StrikeFee_"^"_flag_"^"_paym_"^"_initinv_"^"_newinv
    .s CTNum=CTNum+1
    s:Guser'="" ^TMP("MZJF","EPInvDailyHand",Guser,job,ind)=invno_"^"_prtuser_"^"_prtdate_"^"_prttime_"^"_PatName_"^"_PatNo_"^"_amt_"^"_PayModeList_"^"_flag_"^"_amt_"^"_handdr_"^"_initinv_"^"_job_"^"_RowId
	
	set Data=$lb(invno,prtuser,prtdate,prttime,PatName,PatNo,amt,PayModeList,flag,amt,handdr,initinv,job)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetInvHandin(JkDr, CurUserId)
{
   //按照交帐Rowid，查询收费员预交金交款明细
   //^TMP add accrowid 在取数据的时候判断是否集中打印发票  wangli 2009-09-03
    s n=0,Sum=0,PaySum=0,StrikeFeeSum=0
    q:JkDr=""
    s refaccdr=""
    s RowId=""
    f  s RowId=$o(^DHCINVPRT(0,"Report",JkDr,RowId)) q:RowId=""  d
    .s invInfo=$g(^DHCINVPRT(RowId))
    .s prtfairtype=$p(invInfo,"^",34)
    .s flag=$p(invInfo,"^",8)
    .//add by lichao 20100510
    .s BilConInv="0"
	.f  s BilConInv=$o(^DHCBCI(0,"INV",RowId,BilConInv)) q:BilConInv=""  d
	..s PatBillDr=$p(^DHCBCI(BilConInv),"^",2) 
	..s PBAmt=$p(^DHCPB(PatBillDr),"^",8)
	..s PatAdm=$p(^DHCBCI(BilConInv),"^",3)
	..s PaadmSession=$p(^PAADM(PatAdm,2),"^",28)
	..i PaadmSession'="" s SessionTypeCode=$p(^PAC("IPAT",PaadmSession),"^",1)
	..e  s SessionTypeCode="Z"
    .s prinvptrflag=$p(invInfo,"^",3)
    .q:prinvptrflag'="P"
    .s prtaccdr=$p(invInfo,"^",4)
    .q:prtaccdr'=""
    .s prtuser=$p(invInfo,"^",21)
    .q:(Guser'="ALL")&&(Guser'=prtuser)
    .s:prtuser'="" prtuser=$p($g(^SSU("SSUSR",prtuser)),"^",2)
    .s amt=$p(invInfo,"^",1)
    .s prtdate=$p(invInfo,"^",5)
    .s:prtdate'="" prtdate=$zd(prtdate,3)
    .s prttime=$p(invInfo,"^",20)
    .s:prttime'="" prttime=$zt(prttime)
    .i flag="N"  s flag="正常"
    .i flag="A"  s flag="作废"
    .i flag="S"  s flag="红冲"
    .s invno=$p(invInfo,"^",14)  
    .s initinv=$p(invInfo,"^",13)
    .;start add by tangtao 2010-09-01
    .s oldinv=$p(^DHCINVPRT(RowId),"^",13)
    .i oldinv'="" d
    ..s NewInvRowID=""
    ..s NewInvRowID=$o(^DHCINVPRT(0,"OldINV",oldinv,NewInvRowID))
    ..i NewInvRowID'="" d
    ...s newinv=$p(^DHCINVPRT(NewInvRowID),"^",14)
    ...s newamt=$p(^DHCINVPRT(NewInvRowID),"^",1)
    ..e  d
    ...s newamt=0
    ...s newinv=""
    ..s StrikeFee=$g(amt)+$g(newamt)
    ..s StrikeFeeSum=StrikeFeeSum+StrikeFee
    .;end
    .s refaccdr=""
    .i initinv'=""  s refaccdr=$p(^DHCINVPRT(initinv),"^",4)
    .q:refaccdr'="" 
    .s handdr=$p(invInfo,"^",6)
    .s papmi=$p($p(invInfo,"^",15),$c(1))
    .s PatName=$p(^PAPER(papmi,"ALL"),"^",1)
    .s PatNo=$p(^PAPER(papmi,"PAT",1),"^",1)
    .//add by wangli 12-02
    .i initinv'=""  s initinv=$p(^DHCINVPRT(initinv),"^",14)
    .s IPMSub=""
    .f  s IPMSub=$o(^DHCINVPRT(RowId,"P",IPMSub))  q:IPMSub=""  d
    ..s paym=$P(^DHCINVPRT(RowId,"P",IPMSub),"^",1)
    ..//s paym=$o(^DHCINVPRT(RowId,"P",""),-1)  
    ..s:paym'="" paym=$p($g(^CT("CTPM",paym)),"^",2)
    .;s paymsum=$p($g(^DHCINVPRT(RowId,"P",1)),"^",3)
    .s accrowid=""
    .d ..GetInvDetail(RowId,CurUserId,SessionTypeCode)
    .d OutputRow4
    .s n=n+1
    .s Sum=Sum+amt

    s accrowid=""
    f  s accrowid=$o(^DHCINVPRTAPi(0,"INVRep",JkDr,accrowid)) q:accrowid=""  d
    .s handdr=$p(^DHCINVPRTAP(accrowid),"^",20)
    .s invno=$p(^DHCINVPRTAP(accrowid),"^",6)
    .s prtuser=$p(^DHCINVPRTAP(accrowid),"^",5)
    .q:((Guser'="")&(prtuser'=Guser))
    .s prtdate=$p(^DHCINVPRTAP(accrowid),"^",3)
    .s prttime=$p(^DHCINVPRTAP(accrowid),"^",4)
    .s papmi=$p(^DHCINVPRTAP(accrowid),"^",11)
    .s paymsum=$p(^DHCINVPRTAP(accrowid),"^",1)
    .s paym=$p(^DHCINVPRTAP(accrowid,"P",1),"^",1)
    .s flag=$p(^DHCINVPRTAP(accrowid),"^",2)
    .s amt=$p(^DHCINVPRTAP(accrowid),"^",1)
    .s initinv=$p(^DHCINVPRTAP(accrowid),"^",10)
    .s:paym'="" paym=$p($g(^CT("CTPM",paym)),"^",2)
    .s:prtuser'="" prtuser=$p($g(^SSU("SSUSR",prtuser)),"^",2)
    .s PatName=$p(^PAPER(papmi,"ALL"),"^",1)
    .s PatNo=$p(^PAPER(papmi,"PAT",1),"^",1)
    .i flag="N"  s flag="正常"
    .i flag="A"  s flag="作废"
    .i flag="S"  s flag="红冲"
    .s:prtdate'="" prtdate=$zd(prtdate,3)
    .s:prttime'="" prttime=$zt(prttime)
    .s RowId=accrowid
    .s SessionTypeCode="Z"
    .s AccLink=""  //User.DHCAccPINVCONPRT
    .f  s AccLink=$o(^DHCINVPRTCAPi(0,"APINVDR",accrowid,AccLink))  q:AccLink=""  d
    ..s AccLInv=$p($g(^DHCINVPRTCAP(AccLink)),"^",1) //dhc_invprt.prt_rowid
    ..i flag="正常" d
    ...d ..GetInvDetail(AccLInv,Guser,SessionTypeCode)
    .d OutputRow4
    .s n=n+1
    .s Sum=Sum+amt
   
	s (newinv,invno,prtuser,prtdate,prttime,PatName,PatNo,StrikeFee,PayModeList,flag,amt,handdr,initinv,paym)=""

	s StrikeFee=StrikeFeeSum
	s amt=Sum
	s PatName="合计"
	s Guser=""
    s ^TMP("MZJF","EPInvCTDaily",CurUserId,CTNum)=invno_"^"_prtuser_"^"_prtdate_" "_prttime_"^"_PatName_"^"_PatNo_"^"_StrikeFee_"^"_flag_"^"_paym_"^"_initinv_"^"_newinv
	d OutputRow4
    q
    
OutputRow4
    i ((flag'="正常")&&(amt<0))  d
    .s ^TMP("MZJF","EPInvCTDaily",CurUserId,CTNum)=invno_"^"_prtuser_"^"_prtdate_" "_prttime_"^"_PatName_"^"_PatNo_"^"_StrikeFee_"^"_flag_"^"_paym_"^"_initinv_"^"_newinv
    .s CTNum=CTNum+1
    s:Guser'="" ^TMP("MZJF","EPInvDailyHand",Guser,job,ind)=invno_"^"_prtuser_"^"_prtdate_"^"_prttime_"^"_PatName_"^"_PatNo_"^"_paymsum_"^"_paym_"^"_flag_"^"_amt_"^"_handdr_"^"_initinv_"^"_job_"^"_RowId_"^"_accrowid
	set Data=$lb(invno,prtuser,prtdate,prttime,PatName,PatNo,amt,PayModeList,flag,amt,handdr,initinv,job)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPreDepositHzExecute(ByRef qHandle As %Binary, StDate, EndDate, Guser, userid, JkDr, Handin, RecDr) As %Status
{
    //dhc_predeposit,dhc_accprepaymode
	;s ^TMP("OPCash")=Handin
	Set repid=$I(^CacheTemp)
    i (StDate="")  Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    i (Guser="")  Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    s ind=1
    s Job=$j
    //s StDate=$ZDH(StDate,4),EndDate=$ZDH(EndDate,4)
    if $d(^TMP("MZJF","EPAccDailyHZ",Guser,Job))  k ^TMP("MZJF","EPAccDailyHZ",Guser,Job)
    if $d(^TMP("MZJF","PrintOPAccdailyHz",Guser,Job))  k ^TMP("MZJF","PrintOPAccdailyHz",Guser,Job)
    ;s ^TMP("MZJF","EPAccDailyHZ",Guser)=""
    ;s ^TMP("MZJF","PrintOPAccdailyHz",Guser)=""   ;;;;???
    s (footdate,foottime,footuser,recptuser,recptdate,recpttime,handdr,footsum)=""
    s allno="",sfno="",tfno=""
    s allnum=0,sfnum=0,tfnum=0
    s allsum=0,sfsum=0,tfsum=0
    f date=StDate:1:EndDate  d
    .s PDFL=""
    .f  s PDFL=$o(^DHCACDi("AccPDFL",0,"FootDT",date,PDFL))   q:PDFL=""   d
    ..q:(JkDr'="")&&(JkDr'=PDFL)
    ..s data=$g(^DHCACD("AccPDFL",PDFL))
    ..s footdate=$p(data,"^",1)
    ..s:footdate'="" footdate=$zd(footdate,3)
    ..s foottime=$p(data,"^",2)
    ..s:foottime'="" foottime=$zt(foottime)
    ..s footuser=$p(data,"^",3)
    ..q:(userid'="")&&(userid'=footuser)
    ..s:footuser'="" footuser=$p($g(^SSU("SSUSR",footuser)),"^",2)
    ..s recptuser=$p(data,"^",7)
    ..s Recid=$p(data,"^",23)
    ..q:(Handin="on")&&(recptuser="")
    ..q:(Handin'="on")&&(recptuser'="")
    ..q:(Handin="on")&&(RecDr'=Recid)
    ..s:recptuser'="" recptuser=$p($g(^SSU("SSUSR",recptuser)),"^",2)
    ..q:(Handin="on")&&(recptuser="")
    ..s recptdate=$p(data,"^",8)
    ..//q:recptdate>EndDate
    ..s:recptdate'="" recptdate=$zd(recptdate,3)
    ..s recpttime=$p(data,"^",9)
    ..s:recpttime'="" recpttime=$zt(recpttime)
    ..s handdr=PDFL
    ..s footsum=$p(data,"^",16)
    ..d getdetail(PDFL)
    ..d OutputRow5
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
getdetail(pdfdr)
    s allno="",sfno="",tfno=""
    s allnum=0,sfnum=0,tfnum=0
    s allsum=0,sfsum=0,tfsum=0
    s accid=""
    f  s accid=$o(^DHCACDi("AccM",0,"PDFootDR",pdfdr,accid))  q:accid=""   d
    .s sub=""
    .f  s sub=$o(^DHCACDi("AccM",0,"PDFootDR",pdfdr,accid,"AccPD",sub))  q:sub=""   d
    ..s datastr=$g(^DHCACD("AccM",accid,"AccPD",sub))
    ..s type=$p(datastr,"^",1)
    ..s sum=$p(datastr,"^",2)
    ..s accno=$p(datastr,"^",6)
    ..i type["P"  d
    ...s allnum=allnum+1
    ...s allsum=allsum+(+sum)
    ...s sfnum=sfnum+1
    ...s sfsum=sfsum+(+sum)
    ...s ^TMP("MZJF","YJHZA",Guser,Job,accno)=accno
    ...s ^TMP("MZJF","YJHZS",Guser,Job,accno)=accno
    ...;d linkno(allno,accno)
    ...;d linkno(sfno,accno)
    ..i ((type["R")!(type["F"))  d
    ...s ^TMP("MZJF","YJHZA",Guser,Job,accno)=accno
    ...s ^TMP("MZJF","YJHZT",Guser,Job,accno)=accno
    ...s allnum=allnum+1
    ...s allsum=allsum+(+sum)
    ...s tfnum=tfnum+1
    ...s tfsum=tfsum+(+sum)
    ...;d linkno(allno,accno)
    ...;d linkno(tfno,accno)
    s yjnodr=""
    f  s yjnodr=$o(^TMP("MZJF","YJHZA",Guser,Job,yjnodr)) q:yjnodr=""  d
    .s yjno=$p(^TMP("MZJF","YJHZA",Guser,Job,yjnodr),"^",1)
    .d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","AllYJ",Guser,yjno)
    s allno=$g(^TMP("EPInvDailyHand/No",Guser,"AllYJ","no"))
    s yjnodrs=""
    f  s yjnodrs=$o(^TMP("MZJF","YJHZS",Guser,Job,yjnodrs)) q:yjnodrs=""  d
    .s yjnos=$p(^TMP("MZJF","YJHZS",Guser,Job,yjnodrs),"^",1)
    .d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","SYJ",Guser,yjnos)
    s sfno=$g(^TMP("EPInvDailyHand/No",Guser,"SYJ","no"))
    s yjnodrt=""
    f  s yjnodrt=$o(^TMP("MZJF","YJHZT",Guser,Job,yjnodrt)) q:yjnodrt=""  d
    .s yjnot=$p(^TMP("MZJF","YJHZT",Guser,Job,yjnodrt),"^",1)
    .d ##class(web.UDHCJFOPdailyhand).checklike("EPInvDailyHand/No","TYJ",Guser,yjnot)
    s tfno=$g(^TMP("EPInvDailyHand/No",Guser,"TYJ","no"))
    k ^TMP("MZJF","YJHZA",Guser,Job)
    k ^TMP("MZJF","YJHZS",Guser,Job)
    k ^TMP("MZJF","YJHZT",Guser,Job)
    k ^TMP("EPInvDailyHand/No",Guser,"AllYJ","no")
    k ^TMP("EPInvDailyHand/No",Guser,"SYJ","no")
    k ^TMP("EPInvDailyHand/No",Guser,"TYJ","no")
    q
OutputRow5
    s:Guser'="" ^TMP("MZJF","EPAccDailyHZ",Guser,Job,ind)=footdate_"^"_foottime_"^"_footuser_"^"_recptuser_"^"_recptdate_"^"_recpttime_"^"_handdr_"^"_footsum_"^"_Job_"^"_allno_"^"_sfno_"^"_tfno_"^"_allnum_"^"_sfnum_"^"_tfnum_"^"_allsum_"^"_sfsum_"^"_tfsum
	set Data=$lb(footdate,foottime,footuser,recptuser,recptdate,recpttime,handdr,footsum,Job,allno,sfno,tfno,allnum,sfnum,tfnum,allsum,sfsum,tfsum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPreDepositHzFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPreDepositHzExecute ]
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

ClassMethod FindPreDepositHzClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPreDepositHzExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

//显示预交金明细打印日期，打印时间,病人姓名，登记号，金额，支付方式，rowid,job

Query FindPreDepositHz(StDate, EndDate, Guser, userid, JkDr, Handin, RecDr) As %Query(ROWSPEC = "footdate,foottime,footuser,recptuser,recptdate,recpttime,handdr,footsum,Job,allno,sfno,tfno,allnum,sfnum,tfnum,allsum,sfsum,tfsum")
{
}

ClassMethod FindJSHisExecute(ByRef qHandle As %Binary, stdate, enddate, Guser, findflag, AccountFlag, UserCode) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.UDHCJFEPDailyHand","FindJSHis","24/04/2007","24/04/2008","5","PreDept")
    ////DHC_AccPDFootLog; DHC_INVPRTReports
	Set repid=$I(^CacheTemp)
    i (stdate="")||(Guser="") Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    s ind=1
    s Tjob=$j
   
    if AccountFlag="true" d 
    .i UserCode="" s Guser="ALL"
    .e  s Guser=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
    ;w !,AccountFlag_"^"_Guser
    ;s stdate=$zdh(stdate,4)
    ;s enddate=$zdh(enddate,4)
    i findflag=""  s findflag="INV"
    s (footdate,foottime,footuser,footstdate,footenddate,handdr)=""
    i findflag="PreDept"  d
    .f date=stdate:1:enddate  d
    ..s PDFL=""
    ..f  s PDFL=$o(^DHCACDi("AccPDFL",0,"FootDT",date,PDFL))   q:PDFL=""   d
    ...s data=$g(^DHCACD("AccPDFL",PDFL))
    ...s footdate=$p(data,"^",1)
    ...s:footdate'="" footdate=$zd(footdate,3)
    ...s foottime=$p(data,"^",2)
    ...s:foottime'="" foottime=$zt(foottime)
    ...s footuser=$p(data,"^",3)
    ...q:(Guser'="ALL")&&(Guser'=footuser)
    ...s:footuser'="" footuser=$p($g(^SSU("SSUSR",footuser)),"^",2)
    ...s footstdate=$p(data,"^",4)
    ...s:footstdate'="" footstdate=$zd(footstdate,3)
    ...s footsttime=$p(data,"^",5)
    ...s:footsttime'="" footsttime=$zt(footsttime)
    
    ...s footenddate=$p(data,"^",8)
    ...s:footenddate'="" footenddate=$zd(footenddate,3)
    ...s footendtime=$p(data,"^",9)
    ...s:footendtime'="" footendtime=$zt(footendtime)
    ...s handdr=PDFL
    ...d OutputRow6
    i findflag="INV"  d
    .f date=stdate:1:enddate  d
    ..s PDFL=""
    ..f  s PDFL=$o(^DHCOPInsFootI(0,"Date",date,PDFL)) q:PDFL=""   d
    ...s data=$g(^DHCOPInsFoot(PDFL))
    ...s ReportType=$p(data,"^",60)
    ...q:ReportType="S"
    ...s footdate=$p(data,"^",2)
    ...s:footdate'="" footdate=$zd(footdate,3)
    ...s foottime=$p(data,"^",7)
    ...s:foottime'="" foottime=$zt(foottime)
    ...s footuser=$p(data,"^",8)
    ...q:(Guser'="ALL")&&(Guser'=footuser)
    ...s:footuser'="" footuser=$p($g(^SSU("SSUSR",footuser)),"^",2) 
    ...s footstdate=$p(data,"^",5)
    ...s:footstdate'="" footstdate=$zd(footstdate,3)
    ...s footsttime=$p(data,"^",6)
    ...s:footsttime'="" footsttime=$zt(footsttime)

    ...s footenddate=$p(data,"^",3)
    ...s:footenddate'="" footenddate=$zd(footenddate,3)
    ...s footendtime=$p(data,"^",4)
    ...s:footendtime'="" footendtime=$zt(footendtime)

    ...s handdr=PDFL
    ...d OutputRow6
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	set Data=$lb(footdate,foottime,footuser,footstdate,footsttime,footenddate,footendtime,handdr,Tjob)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindJSHisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindJSHisExecute ]
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

ClassMethod FindJSHisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindJSHisExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

//显示预交金明细打印日期，打印时间,病人姓名，登记号，金额，支付方式，rowid,job

Query FindJSHis(stdate, enddate, Guser, findflag, AccountFlag, UserCode) As %Query(ROWSPEC = "Tjsdate:%String,Tjstime:%String,Tjsuser:%String,Tstdate:%String,Tsttime:%String,Tenddate:%String,Tendtime:%String,RowId:%String,Tjob:%String")
{
}

ClassMethod KillTmp(flag, Guser, job)
{
	  if (flag="")||(Guser="")||(job="")  q 0
	  if $d(^TMP("MZJF",flag,Guser,job))  k ^TMP("MZJF",flag,Guser,job)
	  q 1
}

ClassMethod FindRecDetailExecute(ByRef qHandle As %Binary, StDate, EndDate, Guser, Flag) As %Status
{
  
	Set repid=$I(^CacheTemp)
    i (StDate="")  Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    i EndDate=""  s EndDate=$h
    s ind=1
    
    f date=StDate:1:EndDate  d
    .s RecDr=""
    .f  s RecDr=$o(^DHCOPReceipt(0,"RecDate",date,RecDr))   q:RecDr=""  d
    ..s data=$g(^DHCOPReceipt(RecDr))
    ..s RecUser=$p(data,"^",1)
    ..s RecFlag=$p(data,"^",7)
    ..//q:(Flag'=RecFlag)||(RecUser'=Guser)
    ..q:(Flag'=RecFlag)
    ..s Date=$p(data,"^",2)
    ..s:Date'="" Date=$zd(Date,3)
    ..s time=$p(data,"^",3)
    ..s:time'="" time=$zt(time)
    ..s Sum=$p(data,"^",4)
    ..s StDate=$p(data,"^",5)
    ..s:StDate'="" StDate=$zd(StDate,3)
    ..s EndDate=$p(data,"^",6)
    ..s:EndDate'="" EndDate=$zd(EndDate,3)
    ..s Recid=RecDr
    
    ..s Count=0
    ..f FootDate=$zdh(StDate,3):1:$zdh(EndDate,3)  d
    ...s RowId=""
    ...q:$g(Count)=1
    ...f  s RowId=$o(^DHCOPInsFootI(0,"Date",FootDate,RowId)) q:RowId=""   d
    ....q:$g(Count)=1
    ....s data=$g(^DHCOPInsFoot(RowId))
    ....s ReportType=$p(data,"^",60)
    ....q:ReportType="S"
    ....s FootStTime=$p(data,"^",7)
    ....q:FootStTime=""
    ....s FootStTime=$zt(FootStTime),Count=Count+1
    
    ..s Count=0
    ..f FootDate=$zdh(EndDate,3):-1:$zdh(StDate,3)  d
    ...s Index=""
    ...q:$g(Count)=1
    ...f  s Index=$o(^DHCOPInsFootI(0,"Date",FootDate,Index),-1) q:Index=""   d
    ....q:$g(Count)=1
    ....s data=$g(^DHCOPInsFoot(Index))
    ....s ReportType=$p(data,"^",60)
    ....q:ReportType="S"
    ....s FootEndTime=$p(data,"^",7)
    ....q:FootEndTime="" 
    ....q:(+FootEndTime>+$zth(time))&(+FootDate=+$zdh(Date,3))
    ....s FootEndTime=$zt(FootEndTime),Count=Count+1

    ..d OutputRowRec
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRowRec
   	set Data=$lb(StDate,EndDate,RecUser,Sum,Date,time,Recid,$g(FootStTime),$g(FootEndTime))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindRecDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRecDetailExecute ]
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

ClassMethod FindRecDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRecDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindRecDetail(StDate, EndDate, Guser, Flag) As %Query(ROWSPEC = "TStDate:%String,TEndDate:%String,TRecUser:%String,TRecSum:%String,TDate:%String,TTime:%String,TRecId:%String,TStTime:%String,TEndTime:%String")
{
}

ClassMethod GetInvDetail(InvRowid, CurUserId, SessionTypeCode)
{
	//d ##class(web.UDHCJFEPDailyHand).GetInvDetail("4","1")
	q:InvRowid=""
	s PrtFairType=$p(^DHCINVPRT(InvRowid),"^",34)
	s PrtAcout=$p(^DHCINVPRT(InvRowid),"^",1)
	s PrtFlag=$p(^DHCINVPRT(InvRowid),"^",8)
	s PayModeList=""
	s PrtInv=""
	s PrtInv=$p(^DHCINVPRT(InvRowid),"^",14)
	
	s PaySub="0"
	f  s PaySub=$o(^DHCINVPRT(InvRowid,"P",PaySub)) q:PaySub=""  d
	.s PayModeDr=$p(^DHCINVPRT(InvRowid,"P",PaySub),"^",1)
	.s PayDesc=$p(^CT("CTPM",PayModeDr),"^",2)
	.s PayModeAmt=$p(^DHCINVPRT(InvRowid,"P",PaySub),"^",3)
   
	.i PayModeList'="" s PayModeList=PayModeList_" "_PayDesc_":"_PayModeAmt
	.e  s PayModeList=PayDesc_":"_PayModeAmt
	
	.s ^TMP("OPPayMode",CurUserId,job,SessionTypeCode,PayDesc)=+$g(PayModeAmt)+(+$g(^TMP("OPPayMode",CurUserId,job,SessionTypeCode,PayDesc)))

	i ((PrtInv="")&&(PrtFlag="S"))  d
	.s PrtIntInvDr=$p(^DHCINVPRT(InvRowid),"^",13)
	.;s PrtInv=$p(^DHCINVPRT(PrtIntInvDr),"^",14)
	s BilConInv="0"
	f  s BilConInv=$o(^DHCBCI(0,"INV",InvRowid,BilConInv)) q:BilConInv=""  d
	.s PatBillDr=$p(^DHCBCI(BilConInv),"^",2) 
	.s PBAmt=$p(^DHCPB(PatBillDr),"^",8)
	.s PatAdm=$p(^DHCBCI(BilConInv),"^",3) 
	.;s Admi=" "_PatAdm,SessionTypeCode=""
	.i PrtInv'=""  d
	..s ^TMP("ZYJF","ZCINV",CurUserId,job,ZCInvNum)=PrtInv
	..s ZCInvNum=ZCInvNum+1
	.q:'$D(^DHCPB(PatBillDr))
	.s Ord="" f  s Ord=$o(^DHCPB(PatBillDr,"O",Ord)) q:Ord=""  d
	..s Itm=0 f  s Itm=$o(^DHCPB(PatBillDr,"O",Ord,"D",Itm)) q:Itm=""  d
	...s ItmDr=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",3)
	...s TotalAmount=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",7)
	...s DiscAmount=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",8)
	...s PayorShare=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",9)
	...s PatientShare=$p(^DHCPB(PatBillDr,"O",Ord,"D",Itm),"^",10)	
	...s ItmOPSubCat=$p(^DHCTARI(ItmDr),"^",15)
	...q:$g(ItmOPSubCat)=""
	...s ItmOPSubCatDesc=$p(^DHCTarC("OC",ItmOPSubCat),"^",2)
	...S ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	...q:$g(ItmOPCat)=""
	...s OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
	...s ^TMP("OPCate",CurUserId,job,SessionTypeCode,OPCatDesc)=+TotalAmount++($g(^TMP("OPCate",CurUserId,job,SessionTypeCode,OPCatDesc)))
	...s ^TMP("AllOPCate",CurUserId,job,SessionTypeCode)=+TotalAmount++($g(^TMP("AllOPCate",CurUserId,job,SessionTypeCode)))
	q
}

ClassMethod GetPrtDetail(CurUserId, job, SessionTypeCode)
{
	//w ##class(web.UDHCJFEPDailyHand).GetPrtDetail("4707",246218,"T")
	q:CurUserId="" "-1"
	s Str=""
	s ZCStr=""
	s ZCInvNo=##class(UDHCJFBaseCommon).GetINVNOinfoMZ(CurUserId,"ZCINV",job)
	i $d(^TMP("AllOPCate",CurUserId,job,SessionTypeCode))  d
	.s AllZCSum=+$g(^TMP("AllOPCate",CurUserId,job,SessionTypeCode))

	s ZCCateStr="",ACcateFeeStr=""  ;门诊大类，会计分类
	;ACCateFee(1),医疗收入=挂号收入+诊查收入+检查收入+治疗收入+手术收入+化验收入+其他收入
	;ACCateFee(2),挂号收入=挂号费
	;ACCateFee(3)诊查收入=诊察费
	;ACCateFee(4)检查收入=检查费+核磁共振费+CT费+B超费+ECT费+放射费
	;ACCateFee(5)治疗收入=介入治疗费+透析费+治疗费
	;ACCateFee(6)手术收入=手术费
	;ACCateFee(7)化验收入=化验费
	;ACCateFee(8)其他收入=卫生材料费+氧气费+其他费
    ;ACCateFee(9)药品收入=西药收入,中成药收入,中草药收入
    ;ACCateFee(10)西药收入=西药费
    ;ACCateFee(11)中成药收入=中成药
    ;ACCateFee(12)中草药收入=中草药费
    ;ACCateFee(13) 合计
    f i=1:1:12 d
    .s ACCateFee(i)=0

	i $d(^TMP("OPCate",CurUserId,job,SessionTypeCode))  d
	.s ZCCateDesc="",num=0,ZCCateStr=""
	.f  s ZCCateDesc=$o(^TMP("OPCate",CurUserId,job,SessionTypeCode,ZCCateDesc)) q:ZCCateDesc=""  d
	..s CateFee=$j(+$g(^TMP("OPCate",CurUserId,job,SessionTypeCode,ZCCateDesc)),3,2)
	..i (ZCCateStr="")&(num=0)  d
	...s ZCCateStr=ZCCateDesc_"^"_CateFee
	..i num=1 d
	...s ZCCateStr=ZCCateStr_"^"_ZCCateDesc_"^"_CateFee
	..i num=2 d
	...s ZCCateStr=ZCCateStr_"!"_ZCCateDesc_"^"_CateFee
	...s num=0
	..s num=num+1
    ..i ZCCateDesc["挂号费" s ACCateFee(2)=ACCateFee(1)+CateFee 
    ..e  i ZCCateDesc["诊察费" s ACCateFee(3)=ACCateFee(2)+CateFee 
    ..e  i "检查费^核磁共振费^CT费^B超费^ECT费^放射费" [ZCCateDesc s ACCateFee(4)=ACCateFee(4)+CateFee 
    ..e  i "介入治疗费^透析费^治疗费"[ZCCateDesc s ACCateFee(5)=ACCateFee(5)+CateFee 
    ..e  i ZCCateDesc="手术费" s ACCateFee(6)=ACCateFee(6)+CateFee 
    ..e  i ZCCateDesc="化验费" s ACCateFee(7)=ACCateFee(7)+CateFee 
    ..e  i ZCCateDesc="西药费" s ACCateFee(10)=ACCateFee(10)+CateFee 
    ..e  i ZCCateDesc="中成药费" s ACCateFee(11)=ACCateFee(11)+CateFee 
    ..e  i ZCCateDesc="中草药费" s ACCateFee(12)=ACCateFee(12)+CateFee 
    ..e  s ACCateFee(8)=ACCateFee(8)+CateFee 
   
    f i=2:1:8 d
    .s ACCateFee(1)=ACCateFee(1)+ACCateFee(i)
    f i=10:1:12 d
    .s ACCateFee(9)=ACCateFee(9)+ACCateFee(i)
    s ZCCateStr=ZCCateStr_"!"_"合计"_"^"_$j(+$g(AllZCSum),3,2)
    s ACCateFee(13)=ACCateFee(1)+ACCateFee(9)
    
    f i=1:1:13 d
    .i ACcateFeeStr="" s ACcateFeeStr=ACCateFee(1)
    .e  s ACcateFeeStr=ACcateFeeStr_"^"_ACCateFee(i)
    
	s ZCPayModeStr=""
	s (XJSum,ZPSum,CZKSum,TJKSum,CInsuSum,PInsuSum)=0
	s (TLInsuSum,LTDKSum,YLKSum,QTSum)=0
	s AllPaySum=0
	s PayModeStr="",PayModeSum=0
	i $d(^TMP("OPPayMode",CurUserId,job,SessionTypeCode))  d
	.s ZCPaySub=""
	.f  s ZCPaySub=$o(^TMP("OPPayMode",CurUserId,job,SessionTypeCode,ZCPaySub)) q:ZCPaySub=""  d
	..s PayAmt=+$g(^TMP("OPPayMode",CurUserId,job,SessionTypeCode,ZCPaySub))
	..s PayModeSum=PayModeSum+PayAmt
	..q:+$g(PayAmt)=0
	..i PayModeStr="" s PayModeStr=ZCPaySub_"^"_PayAmt
	..e  s PayModeStr=PayModeStr_"&"_ZCPaySub_"^"_PayAmt
	..s ^PayModeStr=PayModeStr
	s PayModeStr=PayModeStr_"&"_"合计"_"^"_PayModeSum
	s ^PayModeStr=PayModeStr
	/*..i ZCPaySub["现金"  d
	...s XJSum=+$g(^TMP("OPPayMode",CurUserId,job,SessionTypeCode,ZCPaySub))
	...s AllPaySum=AllPaySum+XJSum
	..e  i ZCPaySub["支票"  d
	...s ZPSum=+$g(^TMP("OPPayMode",CurUserId,job,SessionTypeCode,ZCPaySub))
	...s AllPaySum=AllPaySum+ZPSum
	..e  i ZCPaySub["储值卡"  d
	...s CZKSum=+$g(^TMP("OPPayMode",CurUserId,job,SessionTypeCode,ZCPaySub))
	...s AllPaySum=AllPaySum+CZKSum
	..e  i ZCPaySub["体检卡"  d
	...s TJKSum=+$g(^TMP("OPPayMode",CurUserId,job,SessionTypeCode,ZCPaySub))
	...s AllPaySum=AllPaySum+TJKSum
	..e  i ZCPaySub["市医保"  d
	...s CInsuSum=+$g(^TMP("OPPayMode",CurUserId,job,SessionTypeCode,ZCPaySub))
	...s AllPaySum=AllPaySum+CInsuSum
	..e  i ZCPaySub["省医保"  d
	...s PInsuSum=+$g(^TMP("OPPayMode",CurUserId,job,SessionTypeCode,ZCPaySub))
	...s AllPaySum=AllPaySum+PInsuSum
	..e  i ZCPaySub["铁路医保"  d
	...s TLInsuSum=+$g(^TMP("OPPayMode",CurUserId,job,SessionTypeCode,ZCPaySub))
	...s AllPaySum=AllPaySum+TLInsuSum
	..e  i ZCPaySub["联通代扣"  d
	...s LTDKSum=+$g(^TMP("OPPayMode",CurUserId,job,SessionTypeCode,ZCPaySub))
	...s AllPaySum=AllPaySum+LTDKSum
	..e  i ZCPaySub["银行卡"  d
	...s YLKSum=+$g(^TMP("OPPayMode",CurUserId,job,SessionTypeCode,ZCPaySub))
	...s AllPaySum=AllPaySum+YLKSum
	..e  d
	...s QTSum=+$g(QTSum)++$g(^TMP("OPPayMode",CurUserId,job,SessionTypeCode,ZCPaySub))
	...s AllPaySum=AllPaySum+QTSum
	*/
	
	;s ZCPayModeStr=XJSum_"^"_ZPSum_"^"_CZKSum_"^"_TJKSum_"^"_CInsuSum_"^"_PInsuSum
	;s ZCPayModeStr=ZCPayModeStr_"^"_TLInsuSum_"^"_LTDKSum_"^"_YLKSum_"^"_QTSum_"^"_AllPaySum
	s ZCStr=ZCInvNo_"@"_ZCCateStr_"@"_PayModeStr_"@"_ACcateFeeStr_"@"_PayModeSum
	s Str=ZCStr  
	q Str
}

ClassMethod GetcurDate(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	//w ##class(web.UDHCJFEPDailyHand).GetcurDate("4707")
	s Rtn=""
	s Date=$p($h,",",1)
	s DateN=$zd(Date,3)
	s Year=$p(DateN,"-",1)
	s Month=$p(DateN,"-",2)
	s Day=$p(DateN,"-",3)
	s CurDate=Year_"年"_Month_"月"_Day_"日"
	s Time=$p($h,",",2)
	s Time=$zt(Time,1)
	s CurTime=$p(Time,":",1)_"时"_$p(Time,":",2)_"分"_$p(Time,":",3)_"秒"
	q CurDate_CurTime
}

ClassMethod GetInvNum(Guser)
{
	//w ##class(web.UDHCJFEPDailyHand).GetInvNum("4707")
	s gnum=$o(^TMP("MZJF","EPInvCTDaily",Guser,""),-1)
 	q gnum
}

ClassMethod GetInvData(Guser, ind)
{
	//w ##class(web.UDHCJFEPDailyHand).GetInvData("4707","")
	s str=^TMP("MZJF","EPInvCTDaily",Guser,ind)
 	q str
}

ClassMethod admtypelookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admtypelookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod admtypelookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
    s Desc="正常诊"
    d OutputRow24
    s Desc="业余诊"
    d OutputRow24
    s Desc="特诊"
    d OutputRow24
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow24
	set Data=$lb(Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod admtypelookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admtypelookupExecute ]
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

Query admtypelookup() As %Query(ROWSPEC = "Tdesc:%String")
{
}

/// Creator:yyx
/// CreateDate:2010-08-30
/// Function:取挂号的诊别，用于日报打印
ClassMethod GetInPatAdmissionType()
{
	s IPatRowID=0,AdmissType=""
	f  s IPatRowID=$o(^PAC("IPAT",IPatRowID)) q:IPatRowID=""  d
    .s InPatType=$p(^PAC("IPAT",IPatRowID),"^",1)
    .i AdmissType'="" d
    ..s AdmissType=AdmissType_"^"_InPatType
    .e  s AdmissType=InPatType
    q AdmissType
}

}
