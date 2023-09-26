Import SQLUser

/// Lid
/// 2011-04-05
/// 自助机，科室卡消费结算业务
Class web.DHCOPBillAccDaily Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod FindAccPrtInvDailyExecute(ByRef qHandle As %Binary, StDate, EndDate, Guser, Handin, JkDr) As %Status
{
	;                                                                       62509$62509$3088$$
    ;w ##class(%ResultSet).RunQuery("web.DHCOPBillAccDaily","FindAccPrtInvDaily",62509,62509,"3088","","")
  
    i $g(Guser)=""  s Guser=$G(%session.Data("LOGON.USERID"))
	Set repid=$I(^CacheTemp)
    i (StDate="") Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    i (JkDr="")&&(Handin="Y")   Set qHandle=$lb(0,repid,0) 	  Quit $$$OK
    s ind=1
    s job=$j
    s (invno,prtuser,prtdate,prttime,PatName,PatNo,paymsum,paym,flag,amt,handdr,RoundErr)=""
 	s tmp=$zdh("2012-02-10",3)
    s:StDate<tmp StDate=tmp
    i JkDr=""  d   ;未交帐日报表
    .d ..GetInvNotHandin(StDate, EndDate,Guser,Handin,JkDr)
    e  d           ;已交帐报表
    .d ..GetInvHandin(JkDr,Guser)
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindAccPrtInvDailyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAccPrtInvDailyExecute ]
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

ClassMethod FindAccPrtInvDailyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAccPrtInvDailyExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindAccPrtInvDaily(StDate, EndDate, Guser, Handin, JkDr) As %Query(ROWSPEC = "TRowId,TPrtUserCode,TPrtUserName,TPrtDate,TPrtTime,TPatName,TPatNo,Tamt,TPrtStatus,THandleDr,TJob,TRoundErr,TPaym1,TPaym2,TPaym3,TPaym4,TPaym5,TPaym6,TPaym7,TPaym8,TPaym9,TPaym10,TPaym11,TPaym12,TPaym13,TPaym14,TPaym15,TPaym16")
{
}

ClassMethod GetInvNotHandin(StDate, EndDate, Guser, Handin, JkDr)
{
  	k ^TMP("OPBILL","CateFee",Guser,job)
    k ^TMP("OPBILL","PayMode",Guser,job)
    k ^TMP("OPBILL","OPRoundErr",Guser,job)
    k ^TMP("DHCOPBILL","AdmReason",Guser,job)
    k ^TMP("DHCOPBill","DailyHandin")  //打印
    k ^TMP("invDailyHandin") //
    s myHospDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(Guser)
	s TabFlag="",n=0,Sum=0,PaySum=0,RoundErrSum=0
	;
    ;存放支付方式金额
    ;b ;122
	f i=1:1:16  d
	.s paym(i)=0.00
	f Date=StDate:1:EndDate d
    .s RowId=""
    .f  s RowId=$o(^DHCINVPRT(0,"Date",Date,RowId)) q:RowId=""  d
    ..s invInfo=$g(^DHCINVPRT(RowId))
    ..s prtuser=$p(invInfo,"^",21)
	..s prtUserName=$p(^SSU("SSUSR",prtuser),"^",2)
    ..s invHospDR=$p(invInfo,"^",39)  ;医院ID
    ..;q:(+myHospDr'=+invHospDR)
    ..;s:prtuser'="" prtuser=$p($g(^SSU("SSUSR",prtuser)),"^",2)
    ..s handdr=$p(invInfo,"^",6)
    ..q:handdr'=""  ;过滤已结算记录
    ..s prtfairtype=$p(invInfo,"^",34)  ;prt_fairtype (F:发票，R:挂号)
    ..q:(prtfairtype'="F")&(prtfairtype'="R")
    ..;q:(prtfairtype'="F")
    ..s prtUserCode=$p(^SSU("SSUSR",prtuser),"^",1)
    ..q:$e(prtUserCode,1,4)'="zzsf"	
    ..s prinvptrflag=$p(invInfo,"^",3)  ;PRT_INVPrintFlag
    ..s invSub=$o(^DHCINVPRT(RowId,"P",0))  ;dhc_invpaymode
    ..s paymDesc=""
    ..s IPM="0"
	..f  s IPM=$o(^DHCINVPRT(RowId,"P",IPM)) q:IPM=""  d
	...s s=$g(^DHCINVPRT(RowId,"P",IPM))
	...s payMDr=$p(s,"^",1)
	...s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	...s PayMHandDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",payMDr)
	...i +PayMHandDr>0 d
	....s paymsum=$p(s,"^",3)
	....s paymDesc=$p(^CT("CTPM",payMDr),"^",2)
    ...e  d
    ....s paymDesc=""
    ....s paymsum=0
	..q:+PayMHandDr=0
    ..s amt=$p(invInfo,"^",1)
    ..s prtdate=$p(invInfo,"^",5)
    ..s:prtdate'="" prtdate=$zd(prtdate,3)
    ..s prttime=$p(invInfo,"^",20)
    ..s:prttime'="" prttime=$zt(prttime)
    ..s flag=$p(invInfo,"^",8)
    ..i flag="N"  s flagDesc="正常"
    ..i flag="A"  s flagDesc="作废"
    ..;i flag="S"  s flagDesc="红冲"
    ..i (flag="S") d
    ...i +amt<0 s flagDesc="红冲"
    ...e  s flagDesc="正常"
    ..s invno=$p(invInfo,"^",14)
    ..q:invno'=""   ;自助机、科室卡消费不打印发票  
    ..s initinv=$p(invInfo,"^",13)
    ..s sFlag="PRT"
    ..d ..BuildOPCatFee(Guser,job,RowId)
    ..d ..BuildOPPayM(Guser, job, RowId,.paym,sFlag)
    ..s papmi=$p($p(invInfo,"^",15),$c(1))
    ..s PatName=$p(^PAPER(papmi,"ALL"),"^",1)
    ..s PatNo=$p(^PAPER(papmi,"PAT",1),"^",1)
    ..s RoundErr=$p(invInfo,"^",37)
    ..s RoundErrSum=RoundErrSum+RoundErr
    ..s paymsum=$fn(paymsum,"",2)
    ..s TabFlag="Inv"
    ..d OutputRow3
    ..s n=n+1
    ..s Sum=Sum+amt
    ..s PaySum=PaySum+paymsum
    if (n>0)
    {
	    s (prtUserCode,prtUserName,prtuser,prtdate,prttime,PatName,PatNo,paymsum,paym,flag,amt,handdr,initinv)=""
	    s paydr="0",k=0
	    f  s paydr=$o(^CT("CTPM",paydr))  q:(paydr="")||(k>16)  d
	    .s:paydr'="" paymCode=$p($g(^CT("CTPM",paydr)),"^",1)
	    .s k=k+1
	    .s paym(k)=+$g(^TMP("OPBILL","PayMode",Guser,job,paymCode))
	    s paymsum=PaySum
	    s amt=Sum
	    s RoundErr=RoundErrSum
	    s prtUserName="合计"
	    s Guser=""
	    d OutputRow3
    }
    
    q
OutputRow3
     s:Guser'="" ^TMP("MZJF","EPInvDailyHand",Guser,job,ind)=invno_"^"_prtuser_"^"_prtdate_"^"_prttime_"^"_PatName_"^"_PatNo_"^"_paymsum_"^"_paym_"^"_flagDesc_"^"_amt_"^"_handdr_"^"_initinv_"^"_job_"^"_RowId_"^"_RoundErr_"^"_sFlag
    ;s:Guser'="" ^TMP("MZJF","EPInvDailyHand",Guser,job,ind)=prtuser_"^"_prtdate_"^"_prttime_"^"_PatName_"^"_PatNo_"^"_amt_"^"_handdr_"^"_job_"^"_RoundErr
	set Data=$lb(RowId,prtUserCode,prtUserName,prtdate,prttime,PatName,PatNo,amt,flag,handdr,job,RoundErr,paym(1),paym(2),paym(3),paym(4),paym(5),paym(6),paym(7),paym(8),paym(9),paym(10),paym(11),paym(12),paym(13),paym(14),paym(15),paym(16))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetInvHandin(JkDr, Guser)
{
    k ^TMP("OPBILL","CateFee",Guser,job)
    k ^TMP("OPBILL","PayMode",Guser,job)
    k ^TMP("OPBILL","OPRoundErr",Guser,job)
    k ^TMP("DHCOPBILL","AdmReason",Guser,job)
    k ^TMP("DHCOPBill","DailyHandin")  //打印
    k ^TMP("invDailyHandin") //
    ;s myHospDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(Guser)
     ;存放支付方式金额
	f i=1:1:16  d
	.s paym(i)=0.00
    s n=0,Sum=0,PaySum=0,RoundErrSum=0
    s TabFlag=""
    s RowId=""
    f  s RowId=$o(^DHCINVPRT(0,"Report",JkDr,RowId)) q:RowId=""  d
    .s invInfo=$g(^DHCINVPRT(RowId))
    .s prtuser=$p(invInfo,"^",21)
    .s prtUserCode=$p(^SSU("SSUSR",prtuser),"^",1)
	.s prtUserName=$p(^SSU("SSUSR",prtuser),"^",2)
    .s invHospDR=$p(invInfo,"^",39)  ;医院ID
    .;q:(+myHospDr'=+invHospDR)
    .;s:prtuser'="" prtuser=$p($g(^SSU("SSUSR",prtuser)),"^",2)
    .s invSub=$o(^DHCINVPRT(RowId,"P",0))  ;dhc_invpaymode
    .s paymDesc=""
    .s IPM="0"
	.f  s IPM=$o(^DHCINVPRT(RowId,"P",IPM)) q:IPM=""  d
	..s s=$g(^DHCINVPRT(RowId,"P",IPM))
	..s payMDr=$p(s,"^",1)
	..s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	..s PayMHandDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",payMDr)
	..i +PayMHandDr>0 d
	...s paymsum=$p(s,"^",3)
	...s paymDesc=$p(^CT("CTPM",payMDr),"^",2)
    ..e  d
    ...s paymDesc=""
    ...s paymsum=0
	.q:+PayMHandDr=0
    .s amt=$p(invInfo,"^",1)
    .s prtdate=$p(invInfo,"^",5)
    .s:prtdate'="" prtdate=$zd(prtdate,3)
    .s prttime=$p(invInfo,"^",20)
    .s:prttime'="" prttime=$zt(prttime)
    .s flag=$p(invInfo,"^",8)
    .s flag=$p(invInfo,"^",8)
    .i flag="N"  s flagDesc="正常"
    .i flag="A"  s flagDesc="作废"
    .;i flag="S"  s flagDesc="红冲"
    .i (flag="S") d
    ..i +amt<0 s flagDesc="红冲"
    ..e  s flagDesc="正常"
    .s invno=$p(invInfo,"^",14)   
    .q:invno'=""
    .s initinv=$p(invInfo,"^",13)
    .s prtUserCode=$p(^SSU("SSUSR",prtuser),"^",1)
    .q:$e(prtUserCode,1,4)'="zzsf"	
    .;q:'$d(^DHCINVPRTCAPi(0,"INVPRTDR",RowId))
    .;q:((initinv'="")&&('$d(^DHCINVPRTCAPi(0,"INVPRTDR",initinv))))
    .s sFlag="PRT"
    .d ..BuildOPCatFee(Guser,job,RowId)
    .d ..BuildOPPayM(Guser, job, RowId,.paym,sFlag) ;生成支付方式信息
    .s handdr=$p(invInfo,"^",6)
    .s papmi=$p($p(invInfo,"^",15),$c(1))
    .s PatName=$p(^PAPER(papmi,"ALL"),"^",1)
    .s PatNo=$p(^PAPER(papmi,"PAT",1),"^",1)
    .;s paym=$o(^DHCINVPRT(RowId,"P",""),-1)  
    .s paym=$p(^DHCINVPRT(RowId,"P",1),"^",1)
    .s:paym'="" paym=$p($g(^CT("CTPM",paym)),"^",2)
    .s paymsum=$p($g(^DHCINVPRT(RowId,"P",1)),"^",3)
    .s RoundErr=$p(invInfo,"^",37)
    .s RoundErrSum=RoundErrSum+RoundErr
    .s paymsum=$fn(paymsum,"",2)
    .s TabFlag="Inv"
    .d OutputRow4
    .s n=n+1
    .s Sum=Sum+amt
    .s PaySum=PaySum+paymsum
    if (n>0)
    {
	    s (prtUserCode,prtUserName,prtuser,prtdate,prttime,PatName,PatNo,paymsum,paym,flag,amt,handdr,initinv)=""
	   	s paydr="0",k=0
	    f  s paydr=$o(^CT("CTPM",paydr))  q:(paydr="")||(k>16)  d
	    .s:paydr'="" paymCode=$p($g(^CT("CTPM",paydr)),"^",1)
	    .s k=k+1
	    .s paym(k)=+$g(^TMP("OPBILL","PayMode",Guser,job,paymCode))
		s paymsum=PaySum
	    s amt=Sum
	     s RoundErr=RoundErrSum
	    s prtUserName="合计"
	    s Guser=""
	    d OutputRow4
	}   
    
    q
    
OutputRow4
 	b ;111
    s:Guser'="" ^TMP("MZJF","EPInvDailyHand",Guser,job,ind)=invno_"^"_prtuser_"^"_prtdate_"^"_prttime_"^"_PatName_"^"_PatNo_"^"_paymsum_"^"_paym_"^"_flagDesc_"^"_amt_"^"_handdr_"^"_initinv_"^"_job_"^"_RowId_"^"_RoundErr_"^"_sFlag
    ;s:Guser'="" ^TMP("MZJF","EPInvDailyHand",Guser,job,ind)=invno_"^"_prtuser_"^"_prtdate_"^"_prttime_"^"_PatName_"^"_PatNo_"^"_paymsum_"^"_amt_"^"_handdr_"^"_job_"^"_RoundErr
	set Data=$lb(RowId,prtUserCode,prtUserName,prtdate,prttime,PatName,PatNo,amt,flag,handdr,job,RoundErr,paym(1),paym(2),paym(3),paym(4),paym(5),paym(6),paym(7),paym(8),paym(9),paym(10),paym(11),paym(12),paym(13),paym(14),paym(15),paym(16))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod AccInvHandin(sUser As %String, HospDR As %String, FootInfo As %String)
{
    ;2465%%%2%%%21/09/2011^19:29:05^12/02/2012^17:15:22"
	;w ##class(web.DHCOPBillAccDaily).AccInvHandin("2465",2,"21/09/2011^19:29:05^12/02/2012^17:15:22")
    s ^TMPHandin=sUser_"%%%"_HospDR_"%%%"_FootInfo
	
	s $ZT="ERROR^SSERR"
	s StDate=$zdh($p(FootInfo,"^",1),4)
	s StTime=$zth($p(FootInfo,"^",2),1)
	s EndDate=$zdh($p(FootInfo,"^",3),4)
	s EndTime=$zth($p(FootInfo,"^",4),1)
	;
	s tmp=$zdh("2012-02-10",3)
    s:StDate<tmp StDate=tmp
	;
	s hdate=+$h
	s htime=$p($h,",",2)
	
	;Q:$d(^TMPOPCat($j))=0 1
	;q:$d(^TMPCatSub($j))=0 1
	
	d ..KillTmp()

	;把发票重新生成，门诊大类项目
	s myrtn=..BuildOPINVItem(sUser,StDate, StTime, EndDate, EndTime)

	s myrtn0=$p(myrtn,"^",1)
	q:(myrtn0) myrtn0_"^"

	d ..tb()
	
	k PLIST
	s PLIST(2)=hdate		;HIS_Date
	s PLIST(3)=htime		;HIS_Time
	s PLIST(4)=$zdh($p(FootInfo,"^",1),4)		;HIS_StartDate
	s PLIST(5)=$zth($p(FootInfo,"^",2),1)		; HIS_StartTime
	s PLIST(6)=$zdh($p(FootInfo,"^",3),4)		;HIS_EndDate
	s PLIST(7)=$zth($p(FootInfo,"^",4),1)		;HIS_EndTime
	;s PLIST(8)=$p(FootInfo,"^",5)		;HIS_Amount应收额
	s PLIST(8)=$p(myrtn,"^",4)
	
	s PLIST(9)=sUser					;HIS_User
	s PLIST(10)=$p(myrtn,"^",3)		;His_Num	打印票据数量
	s PLIST(11)=$p(myrtn,"^",2)		;HIS_RcptNO

	s PLIST(17)=$p(myrtn,"^",5)		;HIS_PatSum
	s PLIST(22)=$p(myrtn,"^",7)		;HIS_RefundNum
	s PLIST(23)=$p(myrtn,"^",8)		;HIS_RefundSum
	s PLIST(24)=$p(myrtn,"^",11)		;HIS_ParkNum
	s PLIST(25)=$p(myrtn,"^",12)		;HIS_ParkSum
	s PLIST(26)=$p(myrtn,"^",10)		;HIS_ParkINVInfo
	s PLIST(27)=$p(myrtn,"^",6)		;HIS_RefundINVInfo
	s PLIST(30)=$p(myrtn,"^",14)    ;;;   HIS_INVRoundSum
	s PLIST(61)="S"
	//s myHospDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(sUser) ;Lid 2011-03-22
	s PLIST(67)=HospDR
	;结算主表
	s mycat=""
	s mycatsub=""
	s HISParref=""
	s myrtn=##class(web.UDHCINVPRTReports).Insert()

	i myrtn=0 d
	.s HISParref=PLIST(1)
	
	;b ;;;;;
	i myrtn=0 d
	.;门诊类别大类和子类表
	.;^TmpCatSub($j,ItmOPCat,ItmOPSubCat)
	.f  s mycat=$o(^TMPCatSub($j,mycat)) q:(mycat=""||myrtn'=0)  d
	..s mycatsub=""
	..f  s mycatsub=$o(^TMPCatSub($j,mycat,mycatsub)) q:(mycatsub=""||myrtn'=0)  d
	...s myPatpay=$g(^TMPCatSub($j,mycat,mycatsub))
	...k PLIST
	...s PLIST(0)=HISParref
	...s PLIST(3)=mycat
	...s PLIST(4)=$fn(myPatpay,"",2)
	...s PLIST(5)=mycatsub
	...s PLIST(7)="OP"
	...s myrtn=##class(web.UDHCINVPRTReportsSub).Insert()
	
	i myrtn=0  d  
	.;;;门诊结算支付方式统计
	.s paysub=0
	.f  s paysub=$o(^TMPOPPayM($j,paysub))  q:(paysub=""||myrtn'=0)   d
	..s Amt=$g(^TMPOPPayM($j,paysub))
	..q:+Amt=0
	..k PLIST
	..s PLIST(3)=$fn(Amt,"",2)
	..s PLIST(0)=HISParref
	..s PLIST(4)=paysub
	..s myrtn=##class(web.UDHCINVPRTReportsPaymode).Insert()
	k ^TMPOPPayM($j)
	
	;更新票据流水表
	i myrtn=0 d
	.d ..UpdateFootForUserNoCard(sUser,StDate,StTime,EndDate,EndTime,HISParref,hdate,htime,HospDR)
	
	i myrtn=0 d
		.d ..tc()
	e  d
		.Trollback
	
	d ..KillTmp()
	
	quit myrtn_"^"_HISParref
}

/// Lid
/// 2012-02-22
/// 自助机自动结算任务
/// d ##class(web.DHCOPBillAccDaily).AccInvHandinTask()
ClassMethod AccInvHandinTask()
{
	;
	;总院
	s sUser="3088"
	s HospDR="2"
	s FootInfo=(+$h-1)_"^"_$zth("00:00:00",1)_"^"_(+$h-1)_"^"_$zth("23:59:59",1)
	s rtn=..AccInvHandinAuto(sUser,HospDR,FootInfo)
	i +$p(rtn,"^",1)'=0 d
	.s ^AccInvHandin("DHCBILL","HandinErrLog",HospDR,$zd(+$h,3))=rtn
	;
	/*分院暂屏蔽
	s sUser="3089"
	s HospDR="3"
	s rtn=AccInvHandinAuto(sUser,HospDR,FootInfo)
	i +$p(rtn,"^",1)'=0 d
	.s ^AccInvHandin("DHCBILL","HandinErrLog",HospDR,$zd(+$h,3))=rtn
	*/
}

/// 自助结算
ClassMethod AccInvHandinAuto(sUser As %String, HospDR As %String, FootInfo As %String)
{
    ;2465%%%2%%%21/09/2011^19:29:05^12/02/2012^17:15:22"
	;w ##class(web.DHCOPBillAccDaily).AccInvHandin()
    ;s ^TMPHandin=sUser_"%%%"_HospDR_"%%%"_FootInfo

	//s $ZT="ERROR^SSERR"
	s StDate=$p(FootInfo,"^",1)
	s StTime=$p(FootInfo,"^",2)
	s EndDate=$p(FootInfo,"^",3)
	s EndTime=$p(FootInfo,"^",4)
	s tmp=$zdh("2012-02-10",3)
    s:StDate<tmp StDate=tmp
	;
	s hdate=+$h
	s htime=$p($h,",",2)
	;Q:$d(^TMPOPCat($j))=0 1
	;q:$d(^TMPCatSub($j))=0 1
	d ..KillTmp()
	;把发票重新生成，门诊大类项目
	s myrtn=..BuildOPINVItem(sUser,StDate, StTime, EndDate, EndTime)
	s myrtn0=$p(myrtn,"^",1)
	q:(myrtn0) myrtn0_"^"
	d ..tb()
	k PLIST
	s PLIST(2)=hdate		;HIS_Date
	s PLIST(3)=htime		;HIS_Time
	s PLIST(4)=$p(FootInfo,"^",1)		;HIS_StartDate
	s PLIST(5)=$p(FootInfo,"^",2)		; HIS_StartTime
	s PLIST(6)=$p(FootInfo,"^",3)		;HIS_EndDate
	s PLIST(7)=$p(FootInfo,"^",4)		;HIS_EndTime
	;s PLIST(8)=$p(FootInfo,"^",5)		;HIS_Amount应收额
	s PLIST(8)=$p(myrtn,"^",4)
	s PLIST(9)=sUser					;HIS_User
	s PLIST(10)=$p(myrtn,"^",3)		;His_Num	打印票据数量
	s PLIST(11)=$p(myrtn,"^",2)		;HIS_RcptNO
	s PLIST(17)=$p(myrtn,"^",5)		;HIS_PatSum
	s PLIST(22)=$p(myrtn,"^",7)		;HIS_RefundNum
	s PLIST(23)=$p(myrtn,"^",8)		;HIS_RefundSum
	s PLIST(24)=$p(myrtn,"^",11)		;HIS_ParkNum
	s PLIST(25)=$p(myrtn,"^",12)		;HIS_ParkSum
	s PLIST(26)=$p(myrtn,"^",10)		;HIS_ParkINVInfo
	s PLIST(27)=$p(myrtn,"^",6)		;HIS_RefundINVInfo
	s PLIST(30)=$p(myrtn,"^",14)    ;;;   HIS_INVRoundSum
	s PLIST(61)="S"
	;s myHospDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(sUser) ;Lid 2011-03-22
	s PLIST(67)=HospDR
	;结算主表
	s mycat=""
	s mycatsub=""
	s HISParref=""
	s myrtn=##class(web.UDHCINVPRTReports).Insert()
	i myrtn=0 d
	.s HISParref=PLIST(1)
	;b ;;;;;
	i myrtn=0 d
	.;门诊类别大类和子类表
	.;^TmpCatSub($j,ItmOPCat,ItmOPSubCat)
	.f  s mycat=$o(^TMPCatSub($j,mycat)) q:(mycat=""||myrtn'=0)  d
	..s mycatsub=""
	..f  s mycatsub=$o(^TMPCatSub($j,mycat,mycatsub)) q:(mycatsub=""||myrtn'=0)  d
	...s myPatpay=$g(^TMPCatSub($j,mycat,mycatsub))
	...k PLIST
	...s PLIST(0)=HISParref
	...s PLIST(3)=mycat
	...s PLIST(4)=$fn(myPatpay,"",2)
	...s PLIST(5)=mycatsub
	...s PLIST(7)="OP"
	...s myrtn=##class(web.UDHCINVPRTReportsSub).Insert()
	
	i myrtn=0  d  
	.;;;门诊结算支付方式统计
	.s paysub=0
	.f  s paysub=$o(^TMPOPPayM($j,paysub))  q:(paysub=""||myrtn'=0)   d
	..s Amt=$g(^TMPOPPayM($j,paysub))
	..q:+Amt=0
	..k PLIST
	..s PLIST(3)=$fn(Amt,"",2)
	..s PLIST(0)=HISParref
	..s PLIST(4)=paysub
	..s myrtn=##class(web.UDHCINVPRTReportsPaymode).Insert()
	k ^TMPOPPayM($j)
	
	;更新票据流水表
	i myrtn=0 d
	.d ..UpdateFootForUserNoCard(sUser,StDate,StTime,EndDate,EndTime,HISParref,hdate,htime,HospDR)
	
	i myrtn=0 d
	.d ..tc()
	e  d
	.Trollback
	d ..KillTmp()
	quit myrtn_"^"_HISParref
}

ClassMethod KillTmp()
{
	k ^TMPOPHand($j)
	k ^TMPOPHandsub($j)
	k ^TMPCatSub($j)
	k ^TMPCatSubOther($j)
	k ^TMPOPCat($j)
}

/// 结算发票表
ClassMethod UpdateFootForUserNoCard(UserDR As %String, StDate As %String, StTime As %String, EndDate As %String, EndTime As %String, INVRepRef As %String, HDate As %String, HTime As %String, hospDr) As %String
{
	;
	n (UserDR, StDate, StTime, EndDate, EndTime, INVRepRef, HDate, HTime,hospDr)
	s $ZT="ERROR^DHCSSERR"
	s myrtn=0
	
	;如果是CPP支付，结算标志不做
	;对于打印发票CPP支付要求结算  在DHC_INVPRT表中发票操作员结算，没有发票财务代理结算
	;
	;^DHCINVPRT(0,"Date",{PRT_Date},{PRT_Rowid})
	s myDate=StDate-1
	f  s myDate=$o(^DHCINVPRT(0,"Date",myDate)) q:((myDate="")!(myrtn'=0)!(+myDate>+EndDate))  d
	.s myPrtRowID=0
	.f  s myPrtRowID=$o(^DHCINVPRT(0,"Date",myDate,myPrtRowID)) q:((myPrtRowID="")||(myrtn'=0))  d
	..s myTime=$p(^DHCINVPRT(myPrtRowID),"^",20)
	..s myPRTNo=$p(^DHCINVPRT(myPrtRowID),"^",14)		;PRT_inv
	..s myUser=$p(^DHCINVPRT(myPrtRowID),"^",21)
	..s prtUserCode=$p(^SSU("SSUSR",myUser),"^",1)
    ..q:$e(prtUserCode,1,4)'="zzsf"	
	..s myHandin=$p(^DHCINVPRT(myPrtRowID),"^",10)
	..s myHospDr=$p(^DHCINVPRT(myPrtRowID),"^",39)
	..q:((hospDr'="")&(myHospDr'=hospDr))
	..q:(myHandin="Y")
	..q:((myDate=StDate)&&(myTime<StTime))
	..q:((myDate=EndDate)&&(myTime>=EndTime))
	..;^DHCINVPRT({DHC_INVPRT.PRT_Rowid},"P",{IPM_Sub})
	..;s IPMSub=$o(^DHCINVPRT(myPrtRowID,"P","0"))
	..;s myPMDR=$p(^DHCINVPRT(myPrtRowID,"P",IPMSub),"^",1)
	..;s payMCode=$p(^CT("CTPM",myPMDR),"^",1)
    ..;q:payMCode'["CPP"
    ..b ;000000
    ..s IPM="0",PayMHandDr=0
	..f  s IPM=$o(^DHCINVPRT(myPrtRowID,"P",IPM)) q:((IPM="")!(+PayMHandDr'=0))  d
	...s s=$g(^DHCINVPRT(myPrtRowID,"P",IPM))
	...s payMDr=$p(s,"^",1)
	...s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	...s PayMHandDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",payMDr)
	...b ;33333
	..q:+PayMHandDr=0
	..b ;11111
	..;i myPMDR'="" d
	..;.s myPMSub=$o(^DHCINVPRTi(0,"PMDR",myPrtRowID,myPMDR,"P",0))
	..;s myCKPRTNO=##class(web.UDHCINVPRT).CheckCPPPRTNO(myPrtRowID)
	..;s myPRTNo=$p(myCKPRTNO,"^",1)
	..;q:((myPMSub'="")&(myPRTNo=""))
	..s myrtn=##class(web.DHCOPInvoice).SELECT(myPrtRowID)
	..q:myrtn
	..s PLIST(7)="Y"
	..s PLIST(8)=HDate		; PRT_HandinDate
	..s PLIST(9)=HTime		;PRT_HandinTime
	..s PLIST(5)=INVRepRef
	..s myrtn=##class(web.DHCOPInvoice).UPDATE(myPrtRowID)
	..q:myrtn
	
	q myrtn
}

ClassMethod getsubcat() As %String
{
	;;门诊收费大类或子类?最好是子类
	s n=1
	s ret=""
	s itmrowid=0 f  s itmrowid=$o(^DHCTarC("TOC",itmrowid)) q:itmrowid=""  d
	.s itm=$p(^DHCTarC("TOC",itmrowid),"^",2)
	.i $g(^TMPOPHandsub($j))="" s ^TMPOPHandsub($j)=0
	.s ^TMPOPHandsub($j,itm)=0
	.i $g(^TMPdhcsfdaily1)="" s ^TMPdhcsfdaily1=0
	.s ^TMPdhcsfdaily1(n)=itmrowid
	.i ret=""  s ret=itm
	.e  s ret=ret_"^"_itm
	.s ^TMPOPHandsub($j)=n
	.s ^TMPdhcsfdaily1=n
	.s n=n+1
	q ret
}

ClassMethod STATtoOPCAT(INVPRTRowid As %String, AFlag As %String = "")
{
	;把一张票据转化为门诊收费大类或子类
	;
	s conRowid=0 F  S conRowid=$o(^DHCBCI(0,"INV",INVPRTRowid,conRowid)) Quit:conRowid=""  d
	.S Bill=$p(^DHCBCI(conRowid),"^",2)
	.q:'$D(^DHCPB(Bill))
	.S Ord="" F  S Ord=$o(^DHCPB(Bill,"O",Ord)) q:Ord=""  d
	..S Itm=0 For  Set Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) q:Itm=""  Do
	...;b DHC_TarOutpatCate	  DHC_TarOC
	...S ItmDr=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",3)
	...S TotalAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",7)
	...S DiscAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",8)
	...S PayorShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",9)
	...S PatientShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",10)	
	...S ItmOPSubCat=$p(^DHCTARI(ItmDr),"^",15)
	...q:$g(ItmOPSubCat)=""
	...s ItmOPSubCatDesc=$p(^DHCTarC("OC",ItmOPSubCat),"^",2)
	...S ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	...q:$g(ItmOPCat)=""
	...s OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
	...s totmp=+$g(^TMPOPHandsub($j,OPCatDesc))
	...s:$g(AFlag)="A" TotalAmount=0-TotalAmount
	...s totmp=totmp+TotalAmount
	...;定义一个^TmpCatSub($j,Cat,CatSub)
	...i +ItmOPCat=18  s ^TMP("ZHLTest","Hand",Bill_"||"_Ord_"||"_Itm,AFlag)=AFlag_"^"_TotalAmount
	...s ^TMPCatSub($j,ItmOPCat,ItmOPSubCat)=+$g(^TMPCatSub($j,ItmOPCat,ItmOPSubCat))+TotalAmount
	...s ^TMPCatSubOther($j,"SubCat",ItmOPSubCat)=+$g(^TMPCatSubOther($j,"SubCat",ItmOPSubCat))+TotalAmount
	...s ^TMPOPHandsub($j,OPCatDesc)=totmp
	...s ^TMPOPCat($j,ItmOPCat)=+TotalAmount+$g(^TMPOPCat($j,ItmOPCat))
	q 0
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
	n SQLCODE
	TCOMMIT  s SQLCODE=$zu(34)
	q
}

ClassMethod GetINVNOList() As %String
{
   ;;;creat by zhl  090818  
	;w ##class(web.udhcOPHandin).GetINVNOinfo("1")
	s INVNOinfo=""
	s Count = 0,newflag=0
	s startno="",endno=""
	
	s num=0 f  s num=$o(^TMPOPHand($j,"INVNO",num)) q:num=""  d
	.s invtmp=$p(^TMPOPHand($j,"INVNO",num),"^",2)
	.;q:+invtmp=0
	.i (+$g(startno)=0)!(newflag=1)  d
	..s newflag=0
	..s startno = invtmp
	..s endno = invtmp
	..s lenReceipNo = $l(startno)
	.i $o(^TMPOPHand($j,"INVNO",num))'=""  d
	..s next=$o(^TMPOPHand($j,"INVNO",num))
	..s newinv=$p(^TMPOPHand($j,"INVNO",next),"^",2)
	..i (+newinv-1=+endno)  d
	...s endno=endno+1
	..e  d
	...s Count=Count+1
	...;sss
	...s endno=..FormatINVNO(endno,lenReceipNo)
	...s INVNOinfo = INVNOinfo _"  "_startno_"--"_endno_", "
	...s startno="", endno=""
	...s newflag=1
	
	i (INVNOinfo="")!(Count >= 1) d
	.s endno=..FormatINVNO(endno,lenReceipNo)
	.s INVNOinfo = INVNOinfo_"  "_startno_"--"_endno
	
	q INVNOinfo
}

ClassMethod GetINVNOinfo(znum As %String) As %String
{
	;w ##class(web.udhcOPHandin).GetINVNOinfo("1")
	s INVNOinfo=""
	s Count = 0,newflag=0
	s num=0 f  s num=$o(^TMPOPHand($j,"INV",num)) q:num=""  d
	.s invtmp=^TMPOPHand($j,"INV",num)
	.i (num=1)!(newflag=1)  d
	..s newflag=0
	..s startno = invtmp
	..s endno = invtmp
	..s lenReceipNo = $l(startno)
	.i $d(^TMPOPHand($j,"INV",num+1))'=0  d
	..s newinv=^TMPOPHand($j,"INV",num+1)
	..i (+newinv-1=+endno)  d
	...s endno=endno+1
	..e  d
	...s Count=Count+1
	...s endno=..FormatINVNO(endno,lenReceipNo)
	...s INVNOinfo = INVNOinfo _"  "_startno_"--"_endno_", "
	...s startno="", endno=""
	...s newflag=1
	
	i (INVNOinfo="")!(Count >= 1) d
	.s endno=..FormatINVNO(endno,lenReceipNo)
	.s INVNOinfo = INVNOinfo_"  "_startno_"--"_endno
	q INVNOinfo
}

ClassMethod FormatINVNO(INVNO As %String, len As %String)
{
	
	if $l(INVNO)<len d
	.s prelen=len-$l(INVNO)
	.for i=1:1:prelen s INVNO="0"_INVNO
	Q INVNO
}

ClassMethod BuildOPINVItem(hUser As %String, stdate As %String, sttime As %String, EndDate As %String, EndTime As %String) As %String
{

	n (hUser, stdate, sttime, EndDate, EndTime)
	s (INVNOinfo,RefundINVInfo,ParkINVInfo)=""
	s (snum,TotSum,PatPaySum,refundnum,RefTotSum,RefPatPaySum,cancelnum,AbTotSum,AbPatPaySum,RoundSum)=0
	s rtn=0
	k ^TMPOPPayM($j)
	s myHospDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(hUser)
	i (stdate'="")&(sttime'="")  d
	.s catret=..getsubcat()
	.s snum=0
	.f pdate=stdate:1:EndDate  q:(rtn'=0)  d
	..q:$d(^DHCINVPRT(0,"Date",pdate))=0
	..s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:((PRTrowid="")!(rtn'=0))  d
	...s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
    ...s invHospDR=$p(^DHCINVPRT(PRTrowid),"^",39)  ;医院ID
    ...q:(+myHospDr'=+invHospDR)
	...s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	...q:(pdate=EndDate)&(PRTTime>EndTime)
	...s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	...q:Handin="Y"
	...s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1)+$p(^DHCINVPRT(PRTrowid),"^",37)
	...s PrtPatPay=$p(^DHCINVPRT(PRTrowid),"^",16)+$p(^DHCINVPRT(PRTrowid),"^",37)
	...s Round=$p(^DHCINVPRT(PRTrowid),"^",37)
	...s PrtNO=$p(^DHCINVPRT(PRTrowid),"^",14)
	...q:PrtNO'=""
	...s PrtinvDr=$p(^DHCINVPRT(PRTrowid),"^",13)		;原票据的RowID  正常票据=??
	...s IPMSub=$o(^DHCINVPRT(PRTrowid,"P","0"))
    ...s payMDr=$p(^DHCINVPRT(PRTrowid,"P",IPMSub),"^",1)
    ...s payMCode=$p(^CT("CTPM",payMDr),"^",2)
    ...q:payMCode'["CPP"
	...;q:($d(^DHCINVPRTCAPi(0,"INVPRTDR",PRTrowid))||((PrtinvDr'="")&&($d(^DHCINVPRTCAPi(0,"INVPRTDR",PrtinvDr)))))   ;;;zhl 20100109   
	...s Flag=$p(^DHCINVPRT(PRTrowid),"^",8)
	...i PrtNO'=""  d
	....s snum=snum+1
	...i ((Flag="N")||((PrtinvDr="")&&(Flag'="N")))  d
	....s PatPaySum=PatPaySum+$g(PrtPatPay)
	....s TotSum=TotSum+$g(PRTAcount)
	....s RoundSum=RoundSum+$g(Round)
	...i (Flag="A")&&(PrtinvDr'="")  d
	....s AbPatPaySum=AbPatPaySum+$g(PrtPatPay)
	....s AbTotSum=AbTotSum+$g(PRTAcount)
	....s RoundSum=RoundSum+$g(Round)
	....s cancelnum=cancelnum+1
	...i (Flag="S")&&(PrtinvDr'="")  d
	....s RefPatPaySum=RefPatPaySum+$g(PrtPatPay)
	....s RefTotSum=RefTotSum+$g(PRTAcount)
	....s RoundSum=RoundSum+$g(Round)
	....s refundnum=refundnum+1
	...s stat=..STATtoOPCAT(PRTrowid,"N")
	...s InvPaySub="0"
	...f  s InvPaySub=$o(^DHCINVPRT(PRTrowid,"P",InvPaySub))  q:InvPaySub=""   d
	....s Paym=$p($g(^DHCINVPRT(PRTrowid,"P",InvPaySub)),"^",1)
	....s PayAmt=$p($g(^DHCINVPRT(PRTrowid,"P",InvPaySub)),"^",3)
    ....q:(Paym="")||('$d(^CT("CTPM",Paym)))
	....s ^TMPOPPayM($j,Paym)=$g(^TMPOPPayM($j,Paym))+PayAmt
	
	.i snum>0  d
	..s INVNOinfo=..GetINVNOList()

	s rtn=rtn_"^"_INVNOinfo_"^"_snum_"^"_TotSum_"^"_PatPaySum_"^"_RefundINVInfo_"^"_refundnum_"^"_RefTotSum_"^"_RefPatPaySum_"^"_ParkINVInfo
	s rtn=rtn_"^"_cancelnum_"^"_AbTotSum_"^"_AbPatPaySum_"^"_RoundSum
	q rtn
}

/// Lid
/// 2010-04-06 
/// 根据发票Rowid获取门诊大类
/// ^TMP("OPBILL","CateFee",Guser,job,cateCode):
/// 节点:"OPBILL","CateFee",用户Rowid,job,住院大类Code
/// w ##class(web.UDHCJFEPDailyHand).BuildOPCatFee(639,3124,"175681")
ClassMethod BuildOPCatFee(Guser, job, InvDr)
{
	 s Condr=""
	 f  s Condr=$o(^DHCBCI(0,"INV",InvDr,Condr))  q:Condr=""  d
	 .s Bill=$p($g(^DHCBCI(Condr)),"^",2)
	 .s BillOrd=""
	 .f  s BillOrd=$o(^DHCPB(Bill,"O",BillOrd))  q:BillOrd=""   d
	 ..s BillDetsub=""
	 ..f  s BillDetsub=$o(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub))   q:BillDetsub=""   d
	 ...s tarid=$p($g(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub)),"^",3)
	 ...q:tarid=""
	 ...s OPSubCat=$p($g(^DHCTARI(tarid)),"^",15)      ;门诊子类
	 ...s OPCat=$p($G(^DHCTarC("OC",OPSubCat)),"^",3)  ;门诊大类
	 ...s cateDesc=$p(^DHCTarC("TOC",OPCat),"^",2)     
	 ...s cateCode=$p(^DHCTarC("TOC",OPCat),"^",1)
	 ...s ^TMP("OPBILL","CateFee",Guser,job,cateCode)=$g(^TMP("OPBILL","CateFee",Guser,job,cateCode))+$p($g(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub)),"^",7)
}

/// Lid
/// 2010-04-06 
/// 根据发票Rowid获取支付方式信息
/// ^TMP("OPBILL","PayMode",Guser,job,paym)
/// 节点:"OPBILL","PayMode",用户Rowid,job,支付方式Code
/// w ##class(web.UDHCJFEPDailyHand).BuildOPPayM(639,3124,"175681")
ClassMethod BuildOPPayM(Guser, job, RowId, paymAry, sFlag)
{
	k ^TMP("OPBILL","PayMode","SingleInv",Guser,job) ;存放一张发票的支付方式
	if (sFlag="PRT"){
		s Paysub=0
    	s YBPay=0
    	f  s Paysub=$o(^DHCINVPRT(RowId,"P",Paysub))  q:Paysub=""  d
    	.s paymDr=$p(^DHCINVPRT(RowId,"P",Paysub),"^",1)
    	.s:paymDr'="" paymCode=$p($g(^CT("CTPM",paymDr)),"^",1)
    	.s paymsum2=$p($g(^DHCINVPRT(RowId,"P",Paysub)),"^",3)
    	.s:paymCode["YB" YBPay=YBPay+paymsum2
    	.i paymDr=13  s paymDr=11    //合并cpp
    	.i paymDr=14  s paymDr=12
    	.i paymCode="CPPCARD1" s paymCode="CARD1"
    	.i paymCode="CPPCARD2" s paymCode="CARD2"
    	.s ^TMP("OPBILL","PayMode","SingleInv",Guser,job,paymDr)=+$g(^TMP("OPBILL","PayMode","SingleInv",Guser,job,paymDr))+paymsum2 ;一张发票金额
    	.i paymCode["YB"  s ^TMP("OPBILL","PayMode",Guser,job,"YBZF")=+$g(^TMP("OPBILL","PayMode",Guser,job,"YBZF"))+paymsum2 ;累计医保金额
    	.s ^TMP("OPBILL","PayMode",Guser,job,paymCode)=+$g(^TMP("OPBILL","PayMode",Guser,job,paymCode))+paymsum2 ;合计
	}
	;卡消费
	if (sFlag="API"){
		;^DHCINVPRTAP	
	    s Paysub=0
    	s YBPay=0
    	f  s Paysub=$o(^DHCINVPRTAP(RowId,"P",Paysub))  q:Paysub=""  d
    	.s paymDr=$p(^DHCINVPRTAP(RowId,"P",Paysub),"^",1)
    	.s:paymDr'="" paymCode=$p($g(^CT("CTPM",paymDr)),"^",1)
    	.s paymsum2=$p($g(^DHCINVPRTAP(RowId,"P",Paysub)),"^",3)
    	.s:paymCode["YB" YBPay=YBPay+paymsum2
    	.i paymDr=13  s paymDr=11    //合并cpp
    	.i paymDr=14  s paymDr=12
    	.i paymCode="CPPCARD1" s paymCode="CARD1"
    	.i paymCode="CPPCARD2" s paymCode="CARD2"
    	.s ^TMP("OPBILL","PayMode","SingleInv",Guser,job,paymDr)=+$g(^TMP("OPBILL","PayMode","SingleInv",Guser,job,paymDr))+paymsum2 ;api一张发票金额
    	.i paymCode["YB"  s ^TMP("OPBILL","PayMode",Guser,job,"YBZF")=+$g(^TMP("OPBILL","PayMode",Guser,job,"YBZF"))+paymsum2 ;累计医保金额
    	.s ^TMP("OPBILL","PayMode",Guser,job,paymCode)=+$g(^TMP("OPBILL","PayMode",Guser,job,paymCode))+paymsum2 ;合计
	
	}   
	
    s paydr="0",j=0
	f  s paydr=$o(^CT("CTPM",paydr))  q:(paydr="")||(j>16)  d
	.s j=j+1
	.s paym(j)=+$g(^TMP("OPBILL","PayMode","SingleInv",Guser,job,paydr))
    
    ;清除临时数据
    k ^TMP("OPBILL","PayMode","SingleInv",Guser,job)
}

}
