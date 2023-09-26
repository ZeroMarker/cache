Import SQLUser

Class web.UDHCJFOP9SpecialPatDaily Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 102;

/// 肿瘤医院门诊特种病人日报表
ClassMethod GetHandin(hUser As %String) As %String
{
        ;yyx2007-07-20
	n (hUser) 
	s zfinvno="",hcinvno="",stdate1="",sttime1="",enddate1="",endtime1=""
	;取到收费员要结算的开始日期，结束日期
	s EndDate=+$h		;$zdh(EndDate,3)
	s EndTime=$p($h,",",2)			;$zth(EndTime,1)
	s sttimeinfo=..GetDate(hUser,EndDate)
	s stdate=$p(sttimeinfo,"^",1)
	s sttime=$p(sttimeinfo,"^",2)
	s EndDate=$p(sttimeinfo,"^",3)
	s EndTime=$p(sttimeinfo,"^",4)
	i stdate'="" s stdate1=$zd(stdate,3)
	i sttime'="" s sttime1=$zt(sttime)
	i EndDate'="" s enddate1=$zd(EndDate,3)
	i EndTime'="" s endtime1=$zt(EndTime)
	;生成TMP  Global，返回票据的起止号码 
	;s myINVInfo=..SetINVRepInfo(stdate,sttime,EndDate,EndTime, hUser)
	s myIPRepInfo=..GetINVPRTRepInfo(stdate,sttime,EndDate,EndTime, hUser)

	q:('$d(^TMPMYINVINFOi($j,"INV"))) ""
	s myINVInfo=..GetINVNOinfo()
	
	k ^TMPMYINVINFO($j)
	k ^TMPMYINVINFOi($j)
	s job=$j
	s myINVInfo=$p(myINVInfo,",",1)
	;返回值顺序：发票区间，红冲发票号，作废发票号，收费总额，收费份数
	;退费金额，退费份数，作废金额，作废份数
	q myINVInfo_"^"_hcinvno_"^"_zfinvno_"^"_myIPRepInfo_"^"_stdate1_"^"_sttime1_"^"_enddate1_"^"_endtime1_"^"_job
}

ClassMethod GetINVPRTRepInfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, hUser As %String) As %String
{
    ;表dhc_invprt
	n (stdate,sttime,EndDate,EndTime, hUser,zfinvno,hcinvno)
	s spatfee=0,snum=0,tpatfee=0,tnum=0,zfpatfee=0,zfnum=0
	s zfinvno="",hcinvno=""
	d ..SetPayModeToTmp(hUser)
	i (stdate'="")&(sttime'="")  d
	.s snum=0
	.f pdate=stdate:1:EndDate  d
	..q:$d(^DHCINVPRT(0,"Date",pdate))=0
	..s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:PRTrowid=""  d
	...s PRTrowid=$p(PRTrowid,$c(1))   ;add by zhl
	...q:((PRTrowid="")||($d(^DHCINVPRT(PRTrowid))=0))   ;;;
	...s admreason=$p(^DHCINVPRT(PRTrowid),"^",9)
	...s reasondesc=$p(^PAC("ADMREA",admreason),"^",2)
	...;q:reasondesc'="特种病人"
	...s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
	...q:PRTUser'=hUser
	...s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	...q:(pdate=EndDate)&(PRTTime>=EndTime)
	...q:(pdate=stdate)&(PRTTime<sttime)
	...s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	...;q:Handin="Y"
	...s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1)  ;费用总额
	...s PrtPatPay=$p(^DHCINVPRT(PRTrowid),"^",16) ;病人自付金额
	...s PrtNO=$p(^DHCINVPRT(PRTrowid),"^",14)     ;发票号
	...i PrtNO'="" d
	....s ^TMPMYINVINFO($j,"INVCP",PRTrowid)=PrtNO			;^DHCINVPRT()
	....s ^TMPMYINVINFOi($j,"INV",PrtNO)=PRTrowid_"^CP"
	...s PrtinvDr=$p(^DHCINVPRT(PRTrowid),"^",13)  ;原票据的RowID  正常票据=??
	...s Flag=$p(^DHCINVPRT(PRTrowid),"^",8)       ;打印标志
	...i Flag="N" s spatfee=spatfee+PRTAcount,snum=snum+1
	...i Flag="S" d 
	....s tpatfee=tpatfee+PRTAcount,tnum=tnum+1
	....i hcinvno'="" s hcinvno=hcinvno+","+PrtNO 
	....e  s hcinvno=PrtNO
	...i Flag="A" d
	....s zfpatfee=zfpatfee+PRTAcount,zfnum=zfnum+1
	....i zfinvno'="" s zfinvno=zfinvno+","+PrtNO 
	....e  s zfinvno=PrtNO
	...s myPaySub="0"
	...;门诊支付方式表dhc_invpaymode
	...f  s myPaySub=$o(^DHCINVPRT(PRTrowid,"P",myPaySub)) q:(myPaySub="")  d
	....s myPMDR=$p(^DHCINVPRT(PRTrowid,"P",myPaySub),"^",1)
	....s:myPMDR'="" myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	....i Flag="N" s ^TMP("MZJF",$j,"PayMode",hUser,myPMCode)= ^TMP("MZJF",$j,"PayMode",hUser,myPMCode)+$p(^DHCINVPRT(PRTrowid,"P",myPaySub),"^",3)
	....i Flag="N" s ^TMP("MZJF",$j,"PayModeNum",hUser,myPMCode)=^TMP("MZJF",$j,"PayModeNum",hUser,myPMCode)+1
    s rtn=spatfee_"^"_snum_"^"_tpatfee_"^"_tnum_"^"_zfpatfee_"^"_zfnum
	quit rtn
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

ClassMethod GetDate(hUser As %String, EndDate As %String)
{
	;;w ##class(web.udhcOPHandin0).GetDate("23298",+$h)
	s stdate="",sttime=""
	s myAPRowID=""
	s myPrtDate=""
	s myPrtTime=""
	s myAPDate=""
	s myAPTime=""
	s myPreDate=""
	s myPreTime=""
	
	&sql(select max(HIS_Rowid) into:rowid            
	     from DHC_INVPRTReports where HIS_User=:hUser)
	i rowid'="" d
	.&sql(select HIS_EndDate,HIS_EndTime into :stdate,:sttime
	      from DHC_INVPRTReports where HIS_Rowid=:rowid)
	e  d
	.&sql(select min(PRT_Rowid) into :rowid from DHC_INVPRT
	      where PRT_Date<=:EndDate and PRT_Usr=:hUser and PRT_Handin is null)
	.i rowid'="" d
	..&sql(select PRT_Date,PRT_Time into:stdate,:sttime
	       from DHC_INVPRT where PRT_Rowid=:rowid)
	..s myPrtDate=$p(^DHCINVPRT(rowid),"^",5)
	..s myPrtTime=$p(^DHCINVPRT(rowid),"^",20)
	.&sql(select min(API_RowID) into :myAPRowID from DHC_AccPayINV 
			where API_PUser_DR=:hUser and API_CheckDate is null)
	.i (myAPRowID'="")  d
	..s myAPDate=$p(^DHCINVPRTAP(myAPRowID),"^",3)
	..s myAPTime=$p(^DHCINVPRTAP(myAPRowID),"^",4)
	.;预交金的最小日期
	.s myPreDate=$o(^DHCACDi("AccM",0,"User",hUser,0))
	.q:(myPreDate="")
	.s myPreTime=""
	.s myAccDR=0
	.f  s myAccDR=$o(^DHCACDi("AccM",0,"User", hUser, myPreDate, myAccDR)) q:(myAccDR="")  d
	..s mySub=0
	..f  s mySub=$o(^DHCACDi("AccM",0,"User", hUser, myPreDate, myAccDR,"AccPD", mySub)) q:(mySub="")  d
	...s myTMPTime=$p(^DHCACD("AccM",myAccDR,"AccPD",mySub),"^",4)
	...s myFootUDR=$p(^DHCACD("AccM",myAccDR,"AccPD",mySub),"^",13)
	...q:(myFootUDR'="")
	...i (myPreTime="")||(+myTMPTime<+myPreTime) d
	....s myPreTime=myTMPTime
	...
	
	i (myAPDate'="")&&(myPrtDate'="") d
	.i ((+myAPDate<+myPrtDate)||((myPrtDate=myAPDate)&&(+myAPTime<+myPrtTime)))  d
	..s stdate=myAPDate
	..s sttime=myAPTime
	
	if ((myPrtDate="")&&(myAPDate'="")) d
	..s stdate=myAPDate
	..s sttime=myAPTime
	
	i (myPreDate'="") d
	.i ((stdate="")||((+stdate=+myPreDate)&&(+sttime>+myPreTime))||(+stdate>+myPreDate)) d
	..s stdate=myPreDate
	..s sttime=myPreTime
	
	i stdate="" d  s stdate=+$h
	i sttime="" d  s sttime=$p($h,",",2)
	
	;获取预交金的最小未结算日期
	
	;增加返回结束日期
	s myEndDate=+$h
	s myEndTime=+$p($h,",",2)
	
	;要求按照日期循环验证   等待
	s myCount=0
	i (+stdate<+$h) d
	.s myCount=0
	.s mypdate=""
	.f mypdate=stdate:1:myEndDate  q:(+myCount'=0)  d
	..q:(+mypdate>=+$h)			;要求当前日期
	..s myCount=..CheckINVFlag(hUser, mypdate, myEndDate)
	..
	..i +myCount'=0  d
	...;如果当天存在要要结算数据, 把结束时间定为明天的0分
	...s myEndDate=mypdate+1
	...s myEndTime=0
	
	q stdate_"^"_sttime_"^"_myEndDate_"^"_myEndTime
}

ClassMethod CheckINVFlag(hUser As %String, stdate As %String, EndDate As %String) As %String
{
	n (hUser,stdate,EndDate,EndTime)
	;目的是验证当天的数据是否有没有办理结算的
	
	s myCount=0
	;^DHCINVPRT(0,"UserDate",{PRT_Usr},{PRT_Date},{PRT_Rowid})
	s pddate=stdate
	i $d(^DHCINVPRT(0,"UserDate",hUser,pddate))'=0 d
	.;验证发票表
	.s Handin=""
	.s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"UserDate",hUser, pddate,PRTrowid),-1) q:((PRTrowid="")!(Handin="Y"))  d
	..s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
	..q:PRTUser'=hUser
	..s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	..;q:(pdate=EndDate)&(PRTTime>EndTime)
	..s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	..s myINVNo=$p(^DHCINVPRT(PRTrowid),"^",14)			;PRT_inv
	..s myPrtFlag=$p(^DHCINVPRT(PRTrowid),"^",3)		;PRT_INVPrintFlag
	..q:((myINVNo="")&(myPrtFlag="P"))
	..q:Handin="Y"
	..s myCount=+myCount+1
	
	;验证押金表，或者账户结算信息表
	i $d(^DHCACDi("AccM",0,"User",hUser))'=0 d
	.s myAccRowID=""
	.f  s myAccRowID=$o(^DHCACDi("AccM",0,"User",hUser,pddate, myAccRowID)) q:(myAccRowID="")  d
	..s myAccSub=0
	..f  s myAccSub=$o(^DHCACDi("AccM",0,"User",hUser,pddate, myAccRowID,"AccPD", myAccSub)) q:(myAccSub="")  d
	...q:($d(^DHCACD("AccM",myAccRowID,"AccPD",myAccSub))=10)
	...s myPLIST=^DHCACD("AccM",myAccRowID,"AccPD",myAccSub)
	...s myRepDR=$p(myPLIST,"^",10)
	...q:(myRepDR'="")
	...s myCount=+myCount+1
	
	;验证集中打印发票表
	;下面是：DHC_AccPayINV表的发票号码
	
	i $d(^DHCINVPRTAPi(0,"Date",pddate))'=0 d
	.s myAPRowID=""
	.f  s myAPRowID=$o(^DHCINVPRTAPi(0, "Date", pddate, myAPRowID))  q:(myAPRowID="")  d
	..s myAPUser=$p(^DHCINVPRTAP(myAPRowID),"^", 5)
	..q:(myAPUser'=hUser)
	..s myAPTime=$p(^DHCINVPRTAP(myAPRowID),"^", 4)
	..;q:((APdate=stdate)&&(myAPTime<sttime))
	..;q:((APdate=EndDate)&&(myAPTime>EndTime))
	..s myCheckDate=$p(^DHCINVPRTAP(myAPRowID),"^", 7)
	..q:(myCheckDate'="")	;已经结算的退出
	..s myCount=+myCount+1
	
	q myCount
}

ClassMethod getpaymode()
{
	s paymodestr=""
	s rowid="0"
	f  s rowid=$o(^CT("CTPM",rowid)) q:rowid=""  d
	.s paymodedesc=$p(^CT("CTPM",rowid),"^",2)
    .i paymodestr'="" s paymodestr=paymodestr_"^"_paymodedesc
    .e  s paymodestr=paymodedesc
    q paymodestr
}

ClassMethod SetPayModeToTmp(Guser)
{
   ;yyx
    ;支付方式置初值
    k ^TMP("MZJF",$j,"PayMode",Guser)
    k ^TMP("MZJF",$j,"PayModeNum",Guser)
	s paymodestr=""
	s rowid="0"
	f  s rowid=$o(^CT("CTPM",rowid)) q:rowid=""  d
	.s paymodecode=$p(^CT("CTPM",rowid),"^",1)
	.s paymodedesc=$p(^CT("CTPM",rowid),"^",2)
	.s ^TMP("MZJF",$j,"PayMode",Guser,paymodecode)=0
	.s ^TMP("MZJF",$j,"PayModeNum",Guser,paymodecode)=0
    .i paymodestr'="" s paymodestr=paymodestr_"^"_paymodedesc
    .e  s paymodestr=paymodedesc
    q paymodestr
}

ClassMethod SetINVRepInfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, hUser As %String) As %String
{
	n (hUser, stdate,sttime,EndDate,EndTime)
	;生成临时的Global
	k ^TMPMYINVINFO($j)
	k ^TMPMYINVINFOi($j)
	
	;生成一个票据号码的Global
	f pdate=stdate:1:EndDate  d
	.q:($d(^DHCINVPRT(0,"Date",pdate))=0)
	.s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:PRTrowid=""  d
	..s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
	..q:PRTUser'=hUser
	..s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	..q:(pdate=EndDate)&(PRTTime>=EndTime)
	..q:(pdate=stdate)&(PRTTime<sttime)
	..s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	..q:(Handin="Y")
	..
	..s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1)
	..s PrtPatPay=$p(^DHCINVPRT(PRTrowid),"^",16)
	..s PrtNO=$p(^DHCINVPRT(PRTrowid),"^",14)
	..s PrtinvDr=$p(^DHCINVPRT(PRTrowid),"^",13)		;原票据的RowID  正常票据=??
	..s Flag=$p(^DHCINVPRT(PRTrowid),"^",8)
	..i PrtNO'=""  d
	...s ^TMPMYINVINFO($j,"INVCP",PRTrowid)=PrtNO			;^DHCINVPRT()
	...s ^TMPMYINVINFOi($j,"INV",PrtNO)=PRTrowid_"^CP"
	
	;集中打印生成票据Global
	f APdate=stdate:1:EndDate  d
	.q:$d(^DHCINVPRTAPi(0,"Date",APdate))=0
	.s myAPRowID=""
	.f  s myAPRowID=$o(^DHCINVPRTAPi(0, "Date", APdate, myAPRowID))  q:(myAPRowID="")  d
	..s myAPUser=$p(^DHCINVPRTAP(myAPRowID),"^", 5)
	..q:(myAPUser'=hUser)
	..s myAPTime=$p(^DHCINVPRTAP(myAPRowID),"^", 4)
	..q:((APdate=stdate)&&(myAPTime<sttime))
	..q:((APdate=EndDate)&&(myAPTime>EndTime))
	..s myCheckDate=$p(^DHCINVPRTAP(myAPRowID),"^", 7)
	..q:(myCheckDate'="")
	..s YBAccAcount=$p(^DHCINVPRTAP(myAPRowID),"^", 1)		;发票费用总额API_Amount
	..s YBPatPay=$p(^DHCINVPRTAP(myAPRowID),"^", 16)		;发票患者卡支付总额  API_SelfPatPay
	..s AccPrtFlag=$p(^DHCINVPRTAP(myAPRowID),"^", 2)		;发票标志
	..s AccPrtNo=$p(^DHCINVPRTAP(myAPRowID),"^", 6)			;发票号码  API_INVNo
	..s AccPrtDR=$p(^DHCINVPRTAP(myAPRowID),"^", 10)		;API_PayINV_DR
	..i AccPrtNo'=""  d
	...s ^TMPMYINVINFO($j,"INVAP",myAPRowID)=AccPrtNo			;^DHCINVPRTAP(myAPRowID)
	...s ^TMPMYINVINFOi($j,"INV",AccPrtNo)=myAPRowID_"^AP"
	
	;合计发票
	q:('$d(^TMPMYINVINFOi($j,"INV"))) ""
	
	s myINVInfo=..GetINVNOinfo()
	
	k ^TMPMYINVINFO($j)
	k ^TMPMYINVINFOi($j)
	q:('$d(^TMPMYINVINFOi($j,"INV"))) ""
	
	s myINVInfo=..GetINVNOinfo()
	
	k ^TMPMYINVINFO($j)
	k ^TMPMYINVINFOi($j)
	q myINVInfo
}

ClassMethod GetINVNOinfo() As %String
{
	;w ##class(web.udhcOPHandin1).GetINVNOinfo()
	n (ab)
	
	s INVNOinfo=""
	s Count = 0,newflag=0
	s startno=""
	s endno=""
	s num=0
	s myPrtNo=0 f  s myPrtNo=$o(^TMPMYINVINFOi($j,"INV",myPrtNo)) q:myPrtNo=""  d
	.s num=num+1
	.s invtmp=myPrtNo				;$g(^TMPMYINVINFOi($j,"INV",num))
	.i (num=1)!(newflag=1)  d
	..s newflag=0
	..s startno = invtmp
	..s endno = invtmp
	..s lenReceipNo = $l(startno)
	.s myNextPrtNo=$o(^TMPMYINVINFOi($j,"INV",myPrtNo))
	.;当前发票+1=下一个发票  说明在一个段，否则分段；
	.i (+myNextPrtNo=(+myPrtNo+1)) d
	..
	.e  d
	..;下一个段；
	..s endno=myPrtNo
	..s endno=..FormatINVNO(endno,lenReceipNo)
	..s INVNOinfo = INVNOinfo _"  "_startno_"--"_endno_", "
	..s startno="", endno=""
	..s newflag=1
	
	q INVNOinfo
}

ClassMethod FormatINVNO(INVNO As %String, len As %String)
{
	
	if $l(INVNO)<len d
	.s prelen=len-$l(INVNO)
	.for i=1:1:prelen s INVNO="0"_INVNO
	Q INVNO
}

ClassMethod getdata(hUser As %String, job As %String)
{
   s hUser=$g(hUser)
    s job=$g(job)
    q:hUser=""
    q:job=""
    s (str,paysum,paynum)=""
    s modeid=""
	f  s modeid=$o(^TMP("MZJF",job,"PayMode",hUser,modeid))   q:modeid=""   d
	.s paysum=$g(^TMP("MZJF",job,"PayMode",hUser,modeid))
	.s paynum=$g(^TMP("MZJF",job,"PayModeNum",hUser,modeid))
	.i str=""  s str=1_"@"_modeid_"^"_paysum_"^"_paynum
	.i str'=""  d 
	..s $p(str,"@",1)=+$p(str,"@",1)+1
	..s str=str_"@"_modeid_"^"_paysum_"^"_paynum
	q str
}

ClassMethod insertjk(hUser As %String, val As %String)
{
    s hUser=$g(hUser)
    s val=$g(val)
    q:hUser=""
    q:val=""
    k PLIST
    
    s $ZT="ERROR^DHCSSERR" d ..tb()
    s PLIST(2)=+$h
    s PLIST(3)=$p($h,",",2)
    s stdate=$p($g(val),"^",1)
    i stdate'=""   d
    .s stdate=$zdh(stdate,3) 
    .s PLIST(4)=stdate
    s PLIST(5)=$zth($p($g(val),"^",2))
    s sttime=PLIST(5)
    s enddate=$p($g(val),"^",3)
    i enddate'=""  d
    .s enddate=$zdh(enddate,3) 
    .s PLIST(6)=enddate 
    s PLIST(7)=$zth($p($g(val),"^",4))
    s endtime=PLIST(7)
    s PLIST(9)=hUser
    k PLIST(1)
    &sql(INSERT INTO DHC_INVPRTReports Values PLIST())
    s invrptid=$g(%ROWID)
    q:invrptid="" 0
    s hddate=+$h
    s hdtime=$p($h,",",2)
    s hdflag="Y"
    for prtdate=stdate:1:enddate   d
    .s prtid=""
    .f  s prtid=$o(^DHCINVPRT(0,"Date",prtdate,prtid))  q:prtid=""  d
    ..q:$d(^DHCINVPRT(prtid))=0
    ..s prtdate=$p($g(^DHCINVPRT(prtid)),"^",5)
    ..s prttime=$p($g(^DHCINVPRT(prtid)),"^",20)
    ..s usr=$p($g(^DHCINVPRT(prtid)),"^",21)
    ..q:usr'=hUser
    ..q:(((prtdate=stdate)&&(prttime<sttime))||((prtdate=enddate)&&(prttime>endtime)))
    ..s jkdr=$p($g(^DHCINVPRT(prtid)),"^",6)
    ..q:jkdr'=""
    ..&sql(update DHC_INVPRT set PRT_Handin=:hdflag,PRT_HandinDate=:hddate,PRT_HandinTime=:hdtime,PRT_DHCINVPRTR_DR=:invrptid where PRT_Rowid=:prtid)
    d ..tc()
    q 1
}

}
