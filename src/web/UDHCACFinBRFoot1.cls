Class web.UDHCACFinBRFoot1 Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 提供给服务器的自动结算类方法；
/// d ##class(web.UDHCACFinBRFoot0).ACFinDataAutoFoot()
ClassMethod ACFinDataAutoFoot() As %String
{
	s myfootinfo=..ReadACFinData()
	s myrtn=$p(myfootinfo,$c(3),1)
	
	;写一次日志写到^TMP
	i (+myrtn=0) d
	.s myFootUserDR=""
	.s myaccinfo=$p(myfootinfo,$c(3),2)
	.s $p(myACFInfo,"^",1)=""
	.s $p(myACFInfo,"^",2)=""
	.s $p(myACFInfo,"^",3)=($p(myaccinfo,"^",3))			;PFBCurrentDate
	.s $p(myACFInfo,"^",4)=($p(myaccinfo,"^",4))			;PFBCurrentTime
	.s $p(myACFInfo,"^",5)=myFootUserDR			            ;LOGON.USERID
	.s $p(myACFInfo,"^",6)=($p(myaccinfo,"^",1))			;PFBLastDate
	.s $p(myACFInfo,"^",7)=($p(myaccinfo,"^",2))			;PFBLastTime
	.s $p(myACFInfo,"^",8)=$p(myaccinfo,"^",5)			;LastPDLeft
	.s $p(myACFInfo,"^",9)=$p(myaccinfo,"^",6)			;PDIncomeSum
	.s $p(myACFInfo,"^",10)=$p(myaccinfo,"^",8)			;AccPaySum
	.s $p(myACFInfo,"^",11)=$p(myaccinfo,"^",9)			;PDLeft
	.s $p(myACFInfo,"^",12)=$p(myaccinfo,"^",7)			;PDReturnSum
	.s $p(myACFInfo,"^",13)=$p(myaccinfo,"^",10)			;PrtAccPaySum
	.s $p(myACFInfo,"^",14)=$p(myaccinfo,"^",11)			;NOPrtAccPaySum
	.s ExpStr=""
	.s myfootsaveinfo=..ACFinDataFoot(myFootUserDR, myACFInfo, ExpStr)
	.s myrtn=$p(myfootinfo,$c(3),1)
	.i (+myrtn=0) d
	..;结算成功！
	..s ^TMPDHCACFinDataFoot($j,"S",+$h,$p($h,",",2))="系统自动结算成功,时间："_$zd(+$h,3)_" "_$zt($p($h,",",2))
	..s ^TMPDHCACFinDataFoot($j,"S",+$h,$p($h,",",2),"ACFInfo")=myACFInfo
	.e  d
	..;结算失败日志
	..s ^TMPDHCACFinDataFoot($j,"F",+$h,$p($h,",",2))="系统自动结算失败,时间："_$zd(+$h,3)_" "_$zt($p($h,",",2))
	..s ^TMPDHCACFinDataFoot($j,"F",+$h,$p($h,",",2),"ACFInfo")=myACFInfo
	..s ^TMPDHCACFinDataFoot($j,"F",+$h,$p($h,",",2),"FailInfo")=myfootsaveinfo
	
	q 0
}

/// w ##class(web.UDHCACFinBRFoot1).GetDate()
ClassMethod GetDate() As %String
{
	;得到一个开始和结束日期
	;获取方式：
	;在表DHC_AccFoot表中
	;由于此结算是全部的结算。只是寻找最大的时间
	n (ad)
	
	s myBDate=""
	s myBTime=""
	s myPFRowID=""
	
	s curdate=+$h+1    ;技巧在当前的日前一定加上1  变成当前日期的明天。
	s maxtime=$zth("23:59:59",3)
	i $d(^DHCACDi("AccPF",0,"CurDateT")) d
	.s myBDate=$o(^DHCACDi("AccPF",0,"CurDateT",""),-1)   ;最大的日期
	.q:(myBDate="")
	.s myPFRowID=$o(^DHCACDi("AccPF",0,"CurDateT",myBDate,""),-1)
	.s myBTime=$p($g(^DHCACD("AccPF",myPFRowID)),"^",2)
	else  d   ;没有办理结算时取账户管理的最小时间。
	.s myBDate=$o(^DHCACDi("AccM",0,"OCDate",myBDate))     ;最小时间
	.q:(myBDate="")
	.s myAccRowID=$o(^DHCACDi("AccM",0,"OCDate",myBDate,0))
	.s myBTime=$p($g(^DHCACD("AccM",myAccRowID)), "^", 6)
	.;i myBDate'="" d
	.;.s myBTime=$o(^DHCACDi("AccM",0,"OCDate",myBDate,myBTime))
	
	i (myBDate="") d
	.s myBDate=+$h
	i (myBTime="") d
	.s myBTime=$p($h,",",2)
	
	;s myBDate=$zd(myBDate,3)
	;s myBTime=$zt(myBTime)
	s curdate=+$h
	;$zd(+$h,3)
	s curtime=$p($h,",",2)
	;$zt($p($h,",",2),3)
	
	q myBDate_"^"_myBTime_"^"_curdate_"^"_curtime_"^"_myPFRowID
}

/// w ##class(web.UDHCACFinBRFoot1).AutoGetDT()
ClassMethod AutoGetDT(BDate As %String, BTime As %String, ExpStr As %String) As %String
{
	n (BDate, BTime, ExpStr)
	
	s myrtn=+$h_"^"_$p($h,"^",2)
	
	q myrtn
}

/// w ##class(web.UDHCACFinBRFoot1).ReadACFinData()
ClassMethod ReadACFinData() As %String
{
	n (ad)

	s $zt="ERROR^DHCSSERR"
	
	s myrtn=..GetDate()
	
	s myCount=0
	s myBDate=$p(myrtn,"^",1)
	s myBTime=$p(myrtn,"^",2)
	s myEndDate=$p(myrtn,"^",3)
	s myEndTime=$p(myrtn,"^",4)
	
	s myPFRowID=$p(myrtn,"^",5)
	
	s myPreLeftSum=0
	i (myPFRowID'="") d
	.;本次的期初=上次的期末
	.s myPreLeftSum=$p($g(^DHCACD("AccPF",myPFRowID)),"^",9)
	
	s myPreSum=0
	s myRefundPreSum=0
	;获取操作员上缴的预交金金额；
	;1。
	;此处按照财务审核后的计算
	s myDate=myBDate-1
	f  s myDate=$o(^DHCOPInsFootI(0,"INSFDate",myDate)) q:((myDate="")||(myDate>myEndDate))  d
	.s myHISRowID=0
	.f  s myHISRowID=$o(^DHCOPInsFootI(0,"INSFDate",myDate,myHISRowID))  q:(myHISRowID="")  d
	..q:($d(^DHCOPInsFoot(myHISRowID))=10)
	..s myTime=$p(^DHCOPInsFoot(myHISRowID),"^",14)
	..q:((+myDate=+myBDate)&&(myTime<myBTime))
	..q:((+myDate=+myEndDate)&&(myTime>=myEndTime))
	..
	..s myPreSum=+myPreSum+$p(^DHCOPInsFoot(myHISRowID),"^",52)
	..s myRefundPreSum=+myRefundPreSum+$p(^DHCOPInsFoot(myHISRowID),"^",54)
	
	;获取门诊卡支付金额合计
	;因为这个没有提前财务人员的结算，只有查询流水账
	s myAPSum=0
	s myAPPRTSum=0
	s myAPNoPRTSum=0
	s myDate=myBDate-1
	f  s myDate=$o(^DHCACDi("AccM",0,"PayDate",myDate))  q:((myDate="")||(myDate>myEndDate))  d
	.s myAccRowID=0
	.f  s myAccRowID=$o(^DHCACDi("AccM",0,"PayDate",myDate,myAccRowID))  q:(myAccRowID="")  d
	..s mySub=0
	..f  s mySub=$o(^DHCACDi("AccM",0,"PayDate",myDate,myAccRowID,"AccPL",mySub))  q:(mySub="")  d
	...q:($d(^DHCACD("AccM",myAccRowID,"AccPL",mySub))=10)
	...s myPayNum=+$p(^DHCACD("AccM",myAccRowID,"AccPL",mySub),"^",8)
	...s myTime=$p(^DHCACD("AccM",myAccRowID,"AccPL",mySub),"^",7)
	...q:((+myDate=+myBDate)&&(myTime<myBTime))
	...q:((+myDate=+myEndDate)&&(myTime>=myEndTime))
	...s myAccPLRowID=myAccRowID_"||"_mySub
	...s myPRTRowID=$o(^DHCINVPRTi(0,"AccPLDR",myAccPLRowID,0))
	...s myPRTNo=$p(^DHCINVPRT(myPRTRowID),"^",14)		;PRT_inv
	...s myCKPRTNO=##class(web.UDHCINVPRT).CheckCPPPRTNO(myPRTRowID)
	...s myPRTNo=$p(myCKPRTNO,"^",1)
	...s myHandin=$p(^DHCINVPRT(myPRTRowID),"^",10)		;PRT_Handin
	...;q:((myPRTNo'="")&&(myHandin'="Y"))
	...;&(myHandin="Y")
	...i (myPRTNo'="")  d
	....;打印发票的卡支付显示在界面中
	....s myAPPRTSum=+myAPPRTSum+myPayNum
	...i (myPRTNo="")  d
	....s myAPNoPRTSum=+myAPNoPRTSum+myPayNum
	...s myAPSum=+myAPSum+myPayNum
	...s myCount=myCount+1
	
	s myAPSum=$fn(+myAPSum,"",2)
	s myPreLeftSum=$fn(myPreLeftSum,"",2)
	
	s myPreSum=$fn(myPreSum,"",2)
	s myRefundPreSum=$fn(myRefundPreSum,"",2)
	
	s myLeftSum=myPreLeftSum+myPreSum+myRefundPreSum-myAPSum
	s myLeftSum=$fn(myLeftSum,"",2)
	s myAPPRTSum=$fn(myAPPRTSum,"",2)
	s myAPNoPRTSum=$fn(myAPNoPRTSum,"",2)
	
	s myBDate=$zd(myBDate,4)
	s myBTime=$zt(myBTime)
	s myEndDate=$zd(myEndDate,4)
	s myEndTime=$zt(myEndTime)
	
	s rtn=0
	i (+myCount=0)&(+myPreSum=0)&(+myRefundPreSum=0) d
	.s rtn=1
	
	s myAccInfo=myBDate_"^"_myBTime_"^"_myEndDate_"^"_myEndTime
	s myAccInfo=myAccInfo_"^"_myPreLeftSum_"^"_myPreSum_"^"_myRefundPreSum
	s myAccInfo=myAccInfo_"^"_myAPSum_"^"_myLeftSum_"^"_myAPPRTSum_"^"_myAPNoPRTSum
	
	q rtn_$c(3)_myAccInfo
}

/// w ##class(web.UDHCACFinBRFoot1).ACFinDataFoot("23331","^^09/06/2006^16:15:44^23331^09/06/2006^16:14:27^2688456.77^377761.00^0.00^3040144.77^-26073.00")
ClassMethod ACFinDataFoot(FootUserDR As %String, ACFInfo As %String, ExpStr As %String) As %String
{
	;更新DHC_INVPRT
	;最好写DHC_INVPRTReports
	;写DHC_AccFoot
	;汇总个人的帐户信息(在这段时间内发生费用的账户)
	;在这之前结算的帐户不计算在内；
	
	s $zt="ERROR^DHCSSERR" 
	n (FootUserDR, ACFInfo, ExpStr)
		
	d ..KillTMP()
	
	;ACFInfo=BDate, BTime, EDate, ETime, myPreLeftSum, myPreSum, myCardPaySum, myLeftSum, myRefundPreSum, 
	s rtn=0
	
	d ..tb()

	s BDate=$P(ACFInfo,"^",5+1)			;PLIST(5)
	s BTime=$P(ACFInfo,"^",6+1)			;PLIST(6)
	s EndDate=$P(ACFInfo,"^",2+1)		;PLIST(2)
	s EndTime=$P(ACFInfo,"^",3+1)		;PLIST(3)
	
	i (EndDate["-") d
	.s EndDate=$zdh(EndDate,3)
	i (EndDate["/") d
	.s EndDate=$zdh(EndDate,4)
	s EndTime=$zth(EndTime)
	
	i (BDate["-") d
	.s BDate=$zdh(BDate,3)
	i (BDate["/") d
	.s BDate=$zdh(BDate,4)
	s BTime=$zth(BTime)
	
	;必须预先生成^TMP  否则报错
	d ..ReadFBRAccPreLeft()
	d ##class(web.UDHCACFinBRFootIF).ReadFBRAccPayList(BDate, BTime, EndDate, EndTime)
	d ##class(web.UDHCACFinBRFootIF).ReadFBRAccPreDList(BDate, BTime, EndDate, EndTime)
		
	s mylen=$l(ACFInfo,"^")
	
	k PLIST
	f i=1:1:mylen  d
	.q:($P(ACFInfo,"^",i+1)="")
	.s PLIST(i)=$P(ACFInfo,"^",i+1)
	
	i (PLIST(2)["-") d
	.s PLIST(2)=$zdh(PLIST(2),3)
	i (PLIST(2)["/") d
	.s PLIST(2)=$zdh(PLIST(2),4)
	s PLIST(3)=$zth(PLIST(3))
	i (PLIST(5)["-") d
	.s PLIST(5)=$zdh(PLIST(5),3)
	i (PLIST(5)["/") d
	.s PLIST(5)=$zdh(PLIST(5),4)
	s PLIST(6)=$zth(PLIST(6))
	
	s myCardPaySum=$fn(PLIST(9),"",2)
	
	s rtn=##class(web.UDHCAccPFoot).INSERT()
	
	s myPFParRef=PLIST(1)
	
	;保存到FootSub中
	;先生成TMP，然后保存
	s myAccRowID=0
	i +rtn=0 d
	.f  s myAccRowID=$o(^TMPAcc($j,myAccRowID)) q:((myAccRowID="")!(+rtn'=0))  d
	..s myAccRID=myAccRowID
	..s myPAPMINo=$p(^DHCACD("AccM",myAccRowID),"^",3)
	..s myPAPMDR=$p(^DHCACD("AccM",myAccRowID),"^",2)
	..s myPAName=$p(^PAPER(myPAPMDR,"ALL"),"^",1)
	..s myCADateT=$zd($p(^DHCACD("AccM",myAccRowID),"^",5),3)
	..s myCADateT=myCADateT_" "_$zt($p(^DHCACD("AccM",myAccRowID),"^",6))
	..s myPreLeftSum=+$g(^TMPAcc($j,myAccRowID,"PLeft"))
	..s myPreSum=+$g(^TMPAcc($j,myAccRowID,"GPD"))
	..s myRefPreSum=+$g(^TMPAcc($j,myAccRowID,"RPD"))
	..s myCPSum=+$g(^TMPAcc($j,myAccRowID,"CP"))
	..s myCurLeftSum=myPreLeftSum+myPreSum+myRefPreSum-myCPSum
	..s myAccSCode=$p(^DHCACD("AccM",myAccRowID),"^",13)
	..k PLIST
	..s PLIST(0)=myPFParRef
	..s PLIST(3)=myAccRowID
	..s PLIST(4)=+myPreLeftSum
	..s PLIST(5)=+myCPSum
	..s PLIST(6)=+myCurLeftSum
	..s PLIST(7)=+myRefPreSum
	..s PLIST(8)=+myPreSum
	..s rtn=##class(web.UDHCAccPFootSub).INSERT()
	
	;写表DHC_INVPRTReports，同时作财务人员结算操作HIS_Date写，HIS_INSFootDate也写；
	k PLIST
	s myHISParRef=""
	i (+rtn=0) d
	.s PLIST(2)=+$h
	.s PLIST(3)=$p($h,",",2)
	.s PLIST(4)=BDate
	.s PLIST(5)=BTime
	.s PLIST(6)=EndDate
	.s PLIST(7)=EndTime
	.s PLIST(9)=FootUserDR			;HIS_User
	.s PLIST(13)="Y"				;HIS_Collect
	.s PLIST(14)=+EndDate			;HIS_INSFootDate
	.s PLIST(15)=+EndTime-1			;HIS_INSFootTime
	.s PLIST(16)=FootUserDR			;HIS_INSFootUser
	.s PLIST(59)=myPFParRef
	.s PLIST(60)=myCardPaySum
	.s PLIST(61)="S"			;表示系统结算， U 表示用户结算
	.s rtn=##class(web.UDHCINVPRTReports).Insert()
	.q:(rtn)
	.s myHISParRef=PLIST(1)
	
	;更新DHC_INVPRT表中的所有卡支付记录，不包括直接打印发票的   因为打印发票的是财务人员
	;
	;这个有些顾虑，。。。。。。。。。
	;(StDate, StTime, EndDate, EndTime, INVRepRef, HDate, HTime)
	i (+rtn=0) d
	.s rtn=##class(web.UDHCINVPRT).UpdateFootByCard(BDate, BTime, EndDate, EndTime, myHISParRef, EndDate, EndTime)
	
	;更新DHC_INVPRTReports表
	s myDate=BDate-1
	f  s myDate=$o(^DHCOPInsFootI(0,"INSFDate",myDate)) q:((myDate="")!(myDate>EndDate)!(rtn'=0))  d
	.s myHISRowID=0
	.f  s myHISRowID=$o(^DHCOPInsFootI(0,"INSFDate",myDate, myHISRowID))  q:(myHISRowID="")  d
	..q:($d(^DHCOPInsFoot(myHISRowID))=10)
	..s myTime=$p(^DHCOPInsFoot(myHISRowID),"^",14)
	..q:((+myDate=+BDate)&&(myTime<BTime))
	..q:((+myDate=+EndDate)&&(myTime>=EndTime))
	..s rtn=##class(web.UDHCINVPRTReports).SELECT(myHISRowID)
	..q:rtn
	..s PLIST(59)=myPFParRef
	..s rtn=##class(web.UDHCINVPRTReports).UPDATE(myHISRowID)
	..q:rtn
		
	if +rtn=0  d
	.d ..tc()
	e  d
	.tro
	
	d ..KillTMP()
	
	q rtn_$c(3)_myPFParRef
}

ClassMethod KillTMP() As %String
{
	k ^TMPAcc($j)
}

/// Description: 获取帐户的明细
/// Debug: d ##class(%ResultSet).RunQuery("web.UDHCACFinBRFoot1","ReadFBRAccDetails","6")
Query ReadFBRAccDetails(APFRowID As %String, LangId As %String = "") As websys.Query(ROWSPEC = "PAPMINo:%String:登记号,PAName:%String:患者姓名,CADate:%String:开户日期,CATime:%String:开户时间,PreLeftSum:%Float:前期余额,PreSum:%Float:收预交金金额,RefPreSum:%Float:退预交金金额,CPSum:%Float:卡支付额,CurLeftSum:%Float:账户余额,AccStatus:%String:账户状态") [ SqlProc ]
{
}

ClassMethod ReadFBRAccDetailsExecute(ByRef qHandle As %Binary, APFRowID As %String, LangId As %String = "") As %Status
{
	new repid, ind
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	if (APFRowID="") quit $$$OK
	
	set PreLeftTSum=0
	set PreTSum=0
	set RefPreTSum=0
	set CPTSum=0
	set CurLeftTSum=0
	
	set mysub=0
	while($o(^DHCACD("AccPF",APFRowID,"PF",mysub))) {
		set mysub=$o(^DHCACD("AccPF",APFRowID,"PF",mysub))
		set myData=$g(^DHCACD("AccPF",APFRowID,"PF",mysub))
		continue:(myData="")
		set myAccRowID=$p(myData,"^", 1)			//AccPFS_AccM_DR
		set myAccMData=$g(^DHCACD("AccM",myAccRowID))
		set myPAPMINo=$p(myAccMData,"^",3)
		set myPAPMDR=$p(myAccMData,"^",2)
		set myPAName=$p(^PAPER(myPAPMDR,"ALL"),"^",1)
		set myCADate=$p(myAccMData,"^",5)
		set myCATime=$p(myAccMData,"^",6)
		set myCADate=##class(websys.Conversions).DateLogicalToHtml(myCADate)
		set myCATime=##class(websys.Conversions).TimeLogicalToHtml(myCATime, 1)
		set myAccSCode=$p(myAccMData,"^",13)
		set myAccStatus=$case(myAccSCode,"N":"正常","F":"结算","S":"挂起",:"")
		set myAccStatus=##class(websys.Translation).Get("", myAccStatus, LangId)
		set myPreLeftSum=$p(myData,"^",2)			//AccPFS_PreLeft
		set myPreLeftSum=$fn(myPreLeftSum,"",2)
		set PreLeftTSum=$i(PreLeftTSum, myPreLeftSum)
		set myPreSum=$p(myData,"^",3)				//AccPFS_PrePay
		set myPreSum=$fn(myPreSum,"",2)
		set PreTSum=$i(PreTSum, myPreSum)
		set myRefPreSum=$p(myData,"^",6)			//AccPFS_RefundPrePa
		set myRefPreSum=$fn(myRefPreSum,"",2)
		set RefPreTSum=$i(RefPreTSum, myRefPreSum)
		set myCPSum=+$p(myData,"^",4)				//AccPFS_CardPay
		set myCPSum=$fn(myCPSum,"",2)
		set CPTSum=$i(CPTSum, myCPSum)
		set myCurLeftSum=myPreLeftSum+myPreSum+myRefPreSum-myCPSum
		set myCurLeftSum=$fn(myCurLeftSum,"",2)
		set CurLeftTSum=$i(CurLeftTSum, myCurLeftSum)
		do OutputAD
	}
	
	do ResetVariablesAD	
	set myPAPMINo=##class(websys.Translation).Get("", "合计", LangId)
	set myPreLeftSum=$fn(PreLeftTSum,"",2)
	set myPreSum=$fn(PreTSum,"",2)
	set myRefPreSum=$fn(RefPreTSum,"",2)
	set myCPSum=$fn(CPTSum,"",2)
	set myCurLeftSum=$fn(CurLeftTSum,"",2)
	
	do OutputAD
	
	quit $$$OK
ResetVariablesAD
	set (myPAPMINo,myPAName,myCADate,myCATime,myPreLeftSum,myPreSum,myRefPreSum,myCPSum,myCurLeftSum,myAccStatus)=""
	quit
OutputAD
	set Data=$lb(myPAPMINo,myPAName,myCADate,myCATime,myPreLeftSum,myPreSum,myRefPreSum,myCPSum,myCurLeftSum,myAccStatus)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// 用户的消费额，,期间数据发生额
/// 从DHC_AccPayList表中去消费数据，同时要兼顾DHC_INVPRT表
ClassMethod ReadFBRAccPayList(BDate As %String, BTime As %String, EndDate As %String, EndTime As %String) As %String
{
	n (BDate, BTime, EndDate, EndTime)
	
	s $zt="ERROR^DHCSSERR"
		
	s myDate=BDate-1
	f  s myDate=$o(^DHCACDi("AccM",0,"PayDate",myDate)) q:((myDate="")||(+myDate>+EndDate))  d
	.s myAccRowID=0
	.f  s myAccRowID=$o(^DHCACDi("AccM",0,"PayDate",myDate, myAccRowID)) q:(myAccRowID="")  d
	..s mySub=0
	..f  s mySub=$o(^DHCACDi("AccM",0,"PayDate",myDate, myAccRowID,"AccPL",mySub)) q:(mySub="")  d
	...q:($d(^DHCACD("AccM",myAccRowID,"AccPL",mySub))=10)		;去掉虚节点
	...s myTime=$p(^DHCACD("AccM",myAccRowID,"AccPL",mySub),"^",7)
	...q:((myDate=BDate)&&(myTime<BTime))
	...q:((myDate=EndDate)&&(myTime>=EndTime))
	...s myAccPLRowID=myAccRowID_"||"_mySub
	...s myPRTRowID=$o(^DHCINVPRTi(0,"AccPLDR",myAccPLRowID,0))
	...s myPRTNo=$p(^DHCINVPRT(myPRTRowID),"^",14)		;PRT_inv
	...s myHandin=$p(^DHCINVPRT(myPRTRowID),"^",10)		;PRT_Handin
	...//q:((myPRTNo'="")&(myHandin'="Y"))
	...s myPaySum=$p(^DHCACD("AccM",myAccRowID,"AccPL",mySub),"^",8)
	...s ^TMPAcc($j,myAccRowID,"CP")=$i(^TMPAcc($j,myAccRowID,"CP"), myPaySum)
	
	q 0
}

/// d ##class(%ResultSet).RunQuery("web.UDHCACFinBRFoot1","ReadFBRAccFoot","")
Query ReadFBRAccFoot(BDate As %String, BTime As %String, EndDate As %String, EndTime As %String) As websys.Query(ROWSPEC = "No:%String,AccRID:%String,PAPMINo:%String,PAName:%String,CADateT:%String, PreLeftSum:%String, PreSum:%String, RefPreSum:%String, CPSum:%String, CurLeftSum:%String, AccStatus:%String,TEncryptLevel:%String,TPatLevel:%String")
{
}

ClassMethod ReadFBRAccFootExecute(ByRef qHandle As %Binary, BDate As %String, BTime As %String, EndDate As %String, EndTime As %String) As %Status
{
	new repid, ind
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	s BDate=##class(websys.Conversions).DateHtmlToLogical(BDate)
	s BTime=##class(websys.Conversions).TimeHtmlToLogical(BTime, 1)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s EndTime=##class(websys.Conversions).TimeHtmlToLogical(EndTime, 1)
	d ..KillTMP()
			
	d ResetVariablesFR
	
	//+2017-05-31 ZhYW 
	s detailsSaveFlag=##class(web.DHCBillParamConfig).%GetParameter("DetailsSaveFlag")
	i (+detailsSaveFlag=1)&&(BDate'="") d   ;打开界面不需要显示，点刷新再显示数据 add zhli 17.11.2
	.d ..ReadFBRAccPreLeft()
	d ##class(web.UDHCACFinBRFootIF).ReadFBRAccPayList(BDate, BTime, EndDate, EndTime)
	d ##class(web.UDHCACFinBRFootIF).ReadFBRAccPreDList(BDate, BTime, EndDate, EndTime)
	s PreLeftTSum=0
	s PreTSum=0
	s RefPreTSum=0
	s CPTSum=0
	s CurLeftTSum=0
	
	s myIdx=0
	s myAccRowID=0
	f  s myAccRowID=$o(^TMPAcc($j,myAccRowID)) q:(myAccRowID="")  d
	.s myIdx=$i(myIdx)
	.s myAccRID=myAccRowID
	.s myPAPMINo=$p(^DHCACD("AccM",myAccRowID),"^",3)
	.s myPAPMDR=$p(^DHCACD("AccM",myAccRowID),"^",2)
	.s myPAName=$p($g(^PAPER(myPAPMDR,"ALL")),"^",1)
	.;add by wangjian 2015-01-15 增加病人密级和级别
    .s PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(myPAPMDR, "")
    .s EncryptLevel=$p(PatEncryptLevel,"^",1)
    .s PatLevel=$p(PatEncryptLevel,"^",2)
    .;end
    .s myCADateT=$p(^DHCACD("AccM",myAccRowID),"^",5)
	.s myCADateT=##class(websys.Conversions).DateLogicalToHtml(myCADateT)
	.s myCAtime=$p(^DHCACD("AccM",myAccRowID),"^",6)
	.s myCAtime=##class(websys.Conversions).TimeLogicalToHtml(myCAtime,1)
	.s myCADateT=myCADateT_" "_myCAtime
	.s myPreLeftSum=+$g(^TMPAcc($j,myAccRowID,"PLeft"))
	.s PreLeftTSum=+PreLeftTSum+myPreLeftSum
	.s myPreSum=+$g(^TMPAcc($j,myAccRowID,"GPD"))
	.s PreTSum=+PreTSum+myPreSum
	.s myRefPreSum=+$g(^TMPAcc($j,myAccRowID,"RPD"))
	.s RefPreTSum=+RefPreTSum+myRefPreSum
	.s myCPSum=+$g(^TMPAcc($j,myAccRowID,"CP"))
	.s CPTSum=+CPTSum+myCPSum
	.s myCurLeftSum=myPreLeftSum+myPreSum+myRefPreSum-myCPSum
	.s CurLeftTSum=+CurLeftTSum+myCurLeftSum
	.
	.s myAccSCode=$p(^DHCACD("AccM",myAccRowID),"^",13)
	.s myAccStatus=$case(myAccSCode,"N":"正常","F":"结算","S":"挂起",:"")
	.s No=myIdx
	.d OutputFR
	
	;合计
	d ResetVariablesFR
	
	s No="合计"
	s myPreLeftSum=$fn(PreLeftTSum,"",2)
	s myPreSum=$fn(PreTSum,"",2)
	s myRefPreSum=$fn(RefPreTSum,"",2)
	s myCPSum=$fn(CPTSum,"",2)
	s myCurLeftSum=$fn(CurLeftTSum,"",2)
	
	d OutputFR

	d ..KillTMP()
	
	quit $$$OK
ResetVariablesFR
	set (No,myAccRID,myPAPMINo,myPAName,myCADateT,myPreLeftSum,myPreSum,myRefPreSum, myCPSum, myCurLeftSum, myAccStatus,EncryptLevel,PatLevel)=""
	quit
OutputFR
	set Data=$lb(No,myAccRID,myPAPMINo,myPAName,myCADateT,$fn(myPreLeftSum,"",2),$fn(myPreSum,"",2),$fn(myRefPreSum,"",2), $fn(myCPSum,"",2), $fn(myCurLeftSum,"",2), myAccStatus,EncryptLevel,PatLevel)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// w ##class(web.UDHCACFinBRFoot1).ReadFBRAccPreDList(60329,57970,60410,79366)
/// 操作员上缴额的财务结算预交金,期间数据发生额
ClassMethod ReadFBRAccPreDList(BDate As %String, BTime As %String, EndDate As %String, EndTime As %String) As %String
{
	;从DHC_INVPRTReports 表中取数据
	;此处按照财务审核后的计算
	n (BDate, BTime, EndDate, EndTime)
	;
	s $zt="ERROR^DHCSSERR"
	
	s myDate=BDate-1
	
	;此处按照财务审核后的计算
	;^DHCOPInsFootI(0,"INSFDate",{HIS_INSFootDate},{HIS_Rowid})
	s myDate=BDate-1
	f  s myDate=$o(^DHCOPInsFootI(0,"INSFDate",myDate)) q:((myDate="")||(myDate>EndDate))  d
	.s myHISRowID=0
	.f  s myHISRowID=$o(^DHCOPInsFootI(0,"INSFDate",myDate, myHISRowID))  q:(myHISRowID="")  d
	..q:($d(^DHCOPInsFoot(myHISRowID))=10)
	..s myTime=$p(^DHCOPInsFoot(myHISRowID),"^",14)
	..q:((+myDate=+BDate)&&(myTime<BTime))
	..q:((+myDate=+EndDate)&&(myTime>=EndTime))
	..s myAccRowID=0
	..f  s myAccRowID=$o(^DHCACDi("AccM",0,"IPDR",myHISRowID,myAccRowID)) q:(myAccRowID="")  d
	...s mySub=0
	...f  s mySub=$o(^DHCACDi("AccM",0,"IPDR",myHISRowID, myAccRowID,"AccPD",mySub)) q:(mySub="")  d
	....q:($d(^DHCACD("AccM",myAccRowID,"AccPD",mySub))=10)
	....s myPreSum=$p($g(^DHCACD("AccM",myAccRowID,"AccPD",mySub)),"^",2)
	....i (+myPreSum>0) d
	.....s ^TMPAcc($j,myAccRowID,"GPD")=+myPreSum+$g(^TMPAcc($j,myAccRowID,"GPD"))
	....e  d
	.....s ^TMPAcc($j,myAccRowID,"RPD")=+myPreSum+$g(^TMPAcc($j,myAccRowID,"RPD"))
	....
	
	q 0
}

/// 读取预交金的前期余额
/// w ##class(web.UDHCACFinBRFoot1).ReadFBRAccPreLeft()
ClassMethod ReadFBRAccPreLeft() As %String
{
	n (dd)

	s $zt="ERROR^DHCSSERR"
	
	s myMRowID=$o(^DHCACD("AccPF",""),-1)
	;有个Bug  ，如果数据回滚就会产生虚节点，最好用索引的节点来求，才不会产生错误；
	;^DHCACDi("AccPF",0,"CurDateT",{AccPF_Date},{AccPF_RowID})
	s myPFDate=$o(^DHCACDi("AccPF",0,"CurDateT",""),-1)
	q:(myPFDate="")
	s myMRowID=$o(^DHCACDi("AccPF",0,"CurDateT",myPFDate, ""),-1)
	q:(myMRowID="")

	s mySub=0
	f  s mySub=$o(^DHCACD("AccPF",myMRowID,"PF",mySub)) q:(mySub="")  d
	.q:($d(^DHCACD("AccPF",myMRowID,"PF",mySub))=10)
	.s myAccRowID=$p(^DHCACD("AccPF",myMRowID,"PF",mySub),"^",1)
	.s myCurLeft=+$p($g(^DHCACD("AccPF",myMRowID,"PF",mySub)),"^",5)
	.q:(+myCurLeft=0)
	.s ^TMPAcc($j,myAccRowID,"PLeft")=+myCurLeft
	
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

}
