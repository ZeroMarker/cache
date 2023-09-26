Class web.UDHCACFinBRFoot0PDBack Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 311;

/// ///北京积水潭医院专用
/// ///Version：0
/// ///自动校正的数据, 按照缴预交金时间 
/// ///专门提供一个按照流水缴退预交金的时间来生成总账
/// ///功能：
/// ///1.按照  预交金缴退款流水时间
/// ///2.按照  卡支付时间点
/// ///3.按照  能够按照设置能够自动截取时间段/或者不截取直接按照(上次时间--当前时间)
/// ///4.
/// ///增加校正 5舍6入的误差
/// ///1.
/// ///2.
ClassMethod ACFinDataRound() As %String
{
	;w ##class(web.UDHCACFinBRFoot0PDBack).ACFinDataRound()
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
	
	i myBDate="" d
		.s myBDate=+$h
	i myBTime="" d
		.s myBTime=$p($h,",",2)
	
	;s myBDate=$zd(myBDate,3)
	;s myBTime=$zt(myBTime)
	s curdate=+$h
	;$zd(+$h,3)
	s curtime=$p($h,",",2)
	;$zt($p($h,",",2),3)
	
	s myTMPRowID=$g(^TMPDDDDDDDDDDDDDDPDBack2)

	s myddd=0
	;s myTMPRowID=myPFRowID
	s myMRowID=""
	s myTMPMRowID=myTMPRowID
	
	f  s myTMPMRowID=$o(^DHCACD("AccPF",myTMPMRowID))  q:((myTMPMRowID="")!(+myddd'=0))  d
	.q:($d(^DHCACD("AccPF",myTMPMRowID))=10)
	.s myMRowID=myTMPMRowID
	.;;b		;;;
	.s myddd=1
	
	s myAccPFRowID=myMRowID	;;
	
	s myPFRowID=""
	s myddd=0
	s myTMPRowID=myAccPFRowID
	s myTMPMRowID=myTMPRowID
	s myMRowID=""
	
	f  s myTMPMRowID=$o(^DHCACD("AccPF",myTMPMRowID),-1)  q:((myTMPMRowID="")!(+myddd'=0))  d
	.q:($d(^DHCACD("AccPF",myTMPMRowID))=10)
	.s myMRowID=myTMPMRowID
	.;;b		;;;
	.s myddd=1
	
	s myPFRowID=myMRowID
	
	s myBDate=$p(^DHCACD("AccPF",myAccPFRowID),"^",4)
	s myBTime=$p(^DHCACD("AccPF",myAccPFRowID),"^",5)
	s curdate=$p(^DHCACD("AccPF",myAccPFRowID),"^",1)
	s curtime=$p(^DHCACD("AccPF",myAccPFRowID),"^",2)
	
	s myHSDate=0
	i (+myBDate=+curdate) {
		s myHSDate=+curdate
	}elseif((+myBDate'=+curdate)&(curtime=0)){
		s myHSDate=+curdate-1
	}else{
		s myHSDate=curdate
	}
	w "当前的号:"_myPFRowID_"^"_myAccPFRowID
	
	;b			;GetDate;Test
	;q myBDate_"^"_myBTime_"^"_curdate_"^"_curtime_"^"_myPFRowID_"^"_myAccPFRowID_"^"_myHSDate
	
	
	s myEndDate=curdate
	s myEndTime=curtime
	
	;s myHSDate=$p(myrtn,"^",7)
	///自动校正每笔舍入金额
	;获取门诊卡支付金额合计
	;因为这个没有提前财务人员的结算，只有查询流水账
	///^DHCACDi("AccM",0,"PayDate",{AccPL_PayDate},                      x
	///x           {DHC_AccManager.AccM_RowID},"AccPL",{AccPL_Sub})	
	s myAPSum=0
	s myCount=0
	s myRoundSum=0
	s myNoCardPaySum=0
	s myAPPRTSum=0
	s myAPNoPRTSum=0
	s myDate=myBDate-1
	f  s myDate=$o(^DHCACDi("AccM",0,"PayDate",myDate))  q:((myDate="")!(myDate>myEndDate))  d
	.s myAccRowID=0
	.f  s myAccRowID=$o(^DHCACDi("AccM",0,"PayDate",myDate,myAccRowID))  q:(myAccRowID="")  d
	..s mySub=0
	..f  s mySub=$o(^DHCACDi("AccM",0,"PayDate",myDate,myAccRowID,"AccPL",mySub))  q:(mySub="")  d
	...q:($d(^DHCACD("AccM",myAccRowID,"AccPL",mySub))=10)
	...s myPayNum=+$p(^DHCACD("AccM",myAccRowID,"AccPL",mySub),"^",8)
	...s myTime=$p(^DHCACD("AccM",myAccRowID,"AccPL",mySub),"^",7)
	...q:((+myDate=+myBDate)&&(myTime<myBTime))
	...q:((+myDate=+myEndDate)&&(myTime>=myEndTime))
	...;^DHCINVPRTi(0,"AccPLDR",{IPM_AccPL_DR},{DHC_INVPRT.PRT_Rowid}
	...s myAccPLRowID=myAccRowID_"||"_mySub
	...s myPRTRowID=$o(^DHCINVPRTi(0,"AccPLDR",myAccPLRowID,0))
	...s myPRTNo=$p(^DHCINVPRT(myPRTRowID),"^",14)		;PRT_inv
	...s myCKPRTNO=##class(web.UDHCINVPRT).CheckCPPPRTNO(myPRTRowID)
	...s myPRTNo=$p(myCKPRTNO,"^",1)
	...s myHandin=$p(^DHCINVPRT(myPRTRowID),"^",10)		;PRT_Handin
	...;myAPPRTSum   myAPNoPRTSum
	...;q:((myPRTNo'="")&(myHandin'="Y"))
	...;&(myHandin="Y")
	...i ((myPRTNo'=""))  d
	....;打印发票的卡支付显示在界面中
	....s myAPPRTSum=+myAPPRTSum+myPayNum
	...i (myPRTNo="")  d
	....s myAPNoPRTSum=+myAPNoPRTSum+myPayNum
	...s myAPSum=+myAPSum+myPayNum
	...s myCount=myCount+1
	...s myRoundSum=+myRoundSum+$p(^DHCINVPRT(myPRTRowID),"^",37)			;PRT_OPCRoundErr
	
	;对于其他支付在INVPRT表走；
	s myYBPaySum=0
	s myPRTRowID=0
	s myRoundSum=0
	s myRoundSum=0
	s myDate=myBDate-1
	f  s myDate=$o(^DHCINVPRT(0,"Date",myDate)) q:(myDate="")  d
	.q:(myDate>myEndDate)
	.f  s myPRTRowID=$o(^DHCINVPRT(0,"Date",myDate,myPRTRowID)) q:(myPRTRowID="")  d
	..s myTime=$p(^DHCINVPRT(myPRTRowID),"^",20)
	..q:((+myDate=+myBDate)&&(myTime<myBTime))
	..q:((+myDate=+myEndDate)&&(myTime>=myEndTime))
	..s myRoundSum=+myRoundSum+$p(^DHCINVPRT(myPRTRowID),"^",37)			;PRT_OPCRoundErr
	..s mypaysub=0
	..f  s mypaysub=$o(^DHCINVPRT(myPRTRowID,"P",mypaysub)) q:(mypaysub="")  d
	...s myPMDR=$p(^DHCINVPRT(myPRTRowID,"P",mypaysub),"^",1)
	...q:(myPMDR="")
	...s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	...q:(myPMCode="CPP")			;卡支付退出
	...s myNoCardPaySum=+myNoCardPaySum+($p(^DHCINVPRT(myPRTRowID,"P",mypaysub),"^",3))
	..;b		;;;myNoCardPaySum

	;^DHCINVPRTAPi(0,"Date",{API_Date},{API_RowID})
	s myAPIRowID=0
	s myDate=myBDate-1
	
	f  s myDate=$o(^DHCINVPRTAPi(0,"Date",myDate)) q:((myDate="")!(myDate>myEndDate))  d
	.s myAPIRowID=0
	.f  s myAPIRowID=$o(^DHCINVPRTAPi(0,"Date",myDate, myAPIRowID)) q:(myAPIRowID="")  d
	..s myTime=$p(^DHCINVPRTAP(myAPIRowID),"^",4)			;API_Time
	..q:((+myDate=+myBDate)&&(myTime<myBTime))
	..q:((+myDate=+myEndDate)&&(myTime>=myEndTime))
	..s mySelfYBPay=$p(^DHCINVPRTAP(myAPIRowID),"^",17)				;API_SelfYBPay
	..s myYBPaySum=+myYBPaySum+mySelfYBPay
	
	///更新误差数值
	d ..tb()
	
	s myNoCardPaySum=$fn(myNoCardPaySum,"",2)
	
	s rtn=##class(web.UDHCAccPFoot).SELECT(myAccPFRowID)
	;s PLIST(18)=myRoundSum			;AccPF_RoundSum
	;s PLIST(19)=myNoCardPaySum
	s PLIST(20)=myYBPaySum
	
	i +rtn=0 d
	.s rtn=##class(web.UDHCAccPFoot).UPDATE(myAccPFRowID)
	
	s ^TMPDDDDDDDDDDDDDDPDBack2=+myAccPFRowID
	;b	;Tro
	
	if +rtn=0  d
		.d ..tc()
	e  d
		.Trollback
	q rtn
}

ClassMethod ACFinDataAutoFoot() As %String
{
	;提供给服务器的自动结算类方法；
	;提供一个按照预交金收退款时间点计算的账户总账
	;d ##class(web.UDHCACFinBRFoot0PDBack).ACFinDataAutoFoot()
	;专门用来校正数据
	;提供给服务器的自动结算类方法；
	;复制Global
	;m ^DHCACDBack("AccPF")=^DHCACD("AccPF")
	;m ^DHCACDiBack("AccPF")=^DHCACDi("AccPF")
	;
	;复原Global
	;m ^DHCACD("AccPF")=^DHCACDBack("AccPF")
	;m ^DHCACDi("AccPF")=^DHCACDiBack("AccPF")
	;
	;使用方法来
	
	s myfootinfo=..ReadACFinData()
	s myrtn=$p(myfootinfo,$c(3),1)
	
	;b		;;Getdddd
	;"^^09/06/2006^16:15:44^23331^09/06/2006^16:14:27^2688456.77^377761.00^0.00^3040144.77^-26073.00"
		;var myary=myrtn.split(String.fromCharCode(3))
		;var myAcInfo=myary[1].split("^");
		;DHCWebD_SetObjValueA("PFBLastDate",myAcInfo[0]);
		;DHCWebD_SetObjValueA("PFBLastTime",myAcInfo[1]);
		;DHCWebD_SetObjValueA("PFBCurrentDate",myAcInfo[2]);
		;DHCWebD_SetObjValueA("PFBCurrentTime",myAcInfo[3]);
		;DHCWebD_SetObjValueA("LastPDLeft",myAcInfo[4]);
		;DHCWebD_SetObjValueA("PDIncomeSum",myAcInfo[5]);
		;DHCWebD_SetObjValueA("PDReturnSum",myAcInfo[6]);
		;DHCWebD_SetObjValueA("AccPaySum",myAcInfo[7]);
		;DHCWebD_SetObjValueA("PDLeft",myAcInfo[8]);
		;DHCWebD_SetObjValueA("PrtAccPaySum",myAcInfo[9]);
		;DHCWebD_SetObjValueA("NOPrtAccPaySum",myAcInfo[10]);
	
	;写一次日志写到^TMP
	i +myrtn=0 d
	.s myFootUserDR=""
	.s myaccinfo=$p(myfootinfo,$c(3),2)
	.s $p(myACFInfo,"^",1)=""
	.s $p(myACFInfo,"^",2)=""
	.s $p(myACFInfo,"^",3)=($p(myaccinfo,"^",3))			;PFBCurrentDate
	.s $p(myACFInfo,"^",4)=($p(myaccinfo,"^",4))			;PFBCurrentTime
	.s $p(myACFInfo,"^",5)=myFootUserDR			;LOGON.USERID
	.s $p(myACFInfo,"^",6)=($p(myaccinfo,"^",1))			;PFBLastDate
	.s $p(myACFInfo,"^",7)=($p(myaccinfo,"^",2))			;PFBLastTime
	.s $p(myACFInfo,"^",8)=$p(myaccinfo,"^",5)			;LastPDLeft
	.s $p(myACFInfo,"^",9)=$p(myaccinfo,"^",6)			;PDIncomeSum
	.s $p(myACFInfo,"^",10)=$p(myaccinfo,"^",8)			;AccPaySum
	.s $p(myACFInfo,"^",11)=$p(myaccinfo,"^",9)			;PDLeft
	.s $p(myACFInfo,"^",12)=$p(myaccinfo,"^",7)			;PDReturnSum
	.s $p(myACFInfo,"^",13)=$p(myaccinfo,"^",10)			;PrtAccPaySum
	.s $p(myACFInfo,"^",14)=$p(myaccinfo,"^",11)			;NOPrtAccPaySum
	.s myAccPFRowID=$p(myaccinfo,"^",12)					;当前的结算RowID
	.s $p(myACFInfo,"^",18)=$p(myaccinfo,"^",13)			;HSDate
	.s $p(myACFInfo,"^",19)=$p(myaccinfo,"^",14)			;RoundSum
	.q:(myAccPFRowID="")
	.;b		;;;GetACFInfo
	.s ExpStr=""
	.s myfootsaveinfo=..ACFinDataFoot(myFootUserDR ,myACFInfo, myAccPFRowID, ExpStr)
	.s myrtn=$p(myfootinfo,$c(3),1)
	.i +myrtn=0 d
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

ClassMethod GetDate() As %String
{
	;得到一个开始和结束日期
	;获取方式：
	;在表DHC_AccFoot表中
	;w ##class(web.UDHCACFinBRFoot1).GetDate()
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
	
	i myBDate="" d
		.s myBDate=+$h
	i myBTime="" d
		.s myBTime=$p($h,",",2)
	
	;s myBDate=$zd(myBDate,3)
	;s myBTime=$zt(myBTime)
	s curdate=+$h
	;$zd(+$h,3)
	s curtime=$p($h,",",2)
	;$zt($p($h,",",2),3)
	
	s myTMPRowID=$g(^TMPDDDDDDDDDDDDDDPDBack)

	s myddd=0
	;s myTMPRowID=myPFRowID
	s myMRowID=""
	s myTMPMRowID=myTMPRowID
	
	f  s myTMPMRowID=$o(^DHCACD("AccPF",myTMPMRowID))  q:((myTMPMRowID="")!(+myddd'=0))  d
	.q:($d(^DHCACD("AccPF",myTMPMRowID))=10)
	.s myMRowID=myTMPMRowID
	.;;b		;;;
	.s myddd=1
	
	s myAccPFRowID=myMRowID	;;
	
	s myPFRowID=""
	s myddd=0
	s myTMPRowID=myAccPFRowID
	s myTMPMRowID=myTMPRowID
	s myMRowID=""
	
	f  s myTMPMRowID=$o(^DHCACD("AccPF",myTMPMRowID),-1)  q:((myTMPMRowID="")!(+myddd'=0))  d
	.q:($d(^DHCACD("AccPF",myTMPMRowID))=10)
	.s myMRowID=myTMPMRowID
	.;;b		;;;
	.s myddd=1
	
	s myPFRowID=myMRowID
	
	
	s myBDate=$p(^DHCACDBack("AccPF",myAccPFRowID),"^",4)
	s myBTime=$p(^DHCACDBack("AccPF",myAccPFRowID),"^",5)
	s curdate=$p(^DHCACDBack("AccPF",myAccPFRowID),"^",1)
	s curtime=$p(^DHCACDBack("AccPF",myAccPFRowID),"^",2)
	
	s myHSDate=0
	i (+myBDate=+curdate) {
		s myHSDate=+curdate
	}elseif((+myBDate'=+curdate)&(curtime=0)){
		s myHSDate=+curdate-1
	}else{
		s myHSDate=curdate
	}
	w "当前的号:"_myPFRowID_"^"_myAccPFRowID
	
	b			;GetDate;Test
	q myBDate_"^"_myBTime_"^"_curdate_"^"_curtime_"^"_myPFRowID_"^"_myAccPFRowID_"^"_myHSDate
}

ClassMethod GetDateOld() As %String
{
	;得到一个开始和结束日期
	;获取方式：
	;在表DHC_AccFoot表中
	;w ##class(web.UDHCACFinBRFoot0PDBack).GetDate()
	;由于此结算是全部的结算。只是寻找最大的时间
	;m ^DHCACDBack("AccPF")=^DHCACD("AccPF")
	;m ^DHCACDiBack("AccPF")=^DHCACDi("AccPF")
	
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
	
	i myBDate="" d
		.s myBDate=+$h
	i myBTime="" d
		.s myBTime=$p($h,",",2)
	
	;s myBDate=$zd(myBDate,3)
	;s myBTime=$zt(myBTime)
	s curdate=+$h
	s curtime=$p($h,",",2)
	
	s myDateInfo=..AutoGetDT(myBDate, myBTime, +$h, "")
	s curdate=$p(myDateInfo,"^",1)
	s curtime=$p(myDateInfo,"^",2)
	;s curdate=$zdh("2006-10-10",3)
	;s curtime=$zth("23:59:59")
	
	q myBDate_"^"_myBTime_"^"_curdate_"^"_curtime_"^"_myPFRowID
}

ClassMethod AutoGetDT(BDate As %String, BTime As %String, EndDate As %String, ExpStr As %String) As %String
{
	n (BDate, BTime, EndDate, ExpStr)
	
	;w ##class(web.UDHCACFinBRFoot0PDBack).AutoGetDT(+$h-2,0,+$h,0)
	;自动获取有效的时间段,(时间段内包含数据)
	;积水潭医院自动获取0  --0 点
	s myrtn=+$h_"^"_$p($h,",",2)
	
	;积水潭医院自动截取为0 点
	s myEndTime=0
	s myEndDate=EndDate
	
	i (+BDate<+$h) d
	.s myCount=0
	.s mypdate=""
	.f mypdate=BDate:1:EndDate  q:(+myCount'=0)  d
	..q:(+mypdate>=+$h)			;要求当前日期
	..s myTMPEndDate=mypdate+1
	..s myTMPEndTime=myEndTime
	..s myCount=..CheckAccFlag(mypdate, BTime, myTMPEndDate,myTMPEndTime)
	..i +myCount'=0  d
	...;如果当天存在要要结算数据, 把结束时间定为明天的0分
	...s myEndDate=mypdate+1
	...s myEndTime=0
	...s myrtn=myEndDate_"^"_myEndTime
	
	q myrtn
}

ClassMethod CheckAccFlag(BDate As %String, BTime As %String, EndDate As %String, EndTime As %String) As %String
{
	;w ##class(web.UDHCACFinBRFoot0PDBack).CheckAccFlag(60446,0,60447,0)
	n (BDate, BTime, EndDate, EndTime)
	s myCount=0
	
	;查找这段时间内的预交金笔数
	;^DHCACDi("AccM",0,"APDDate",{AccPD_PreDate},
	;{DHC_AccManager.AccM_RowID},"AccPD",{AccPD_Sub})
	;^DHCACD("AccM",{DHC_AccManager.AccM_RowID},"AccPD",{AccPD_Sub})
	s mydate=""
	f mydate=BDate:1:EndDate d
	.s myAccRowID=0
	.f  s myAccRowID=$o(^DHCACDi("AccM",0,"APDDate",mydate,myAccRowID)) q:(myAccRowID="")  d
	..s mySub=0
	..f  s mySub=$o(^DHCACDi("AccM",0,"APDDate",mydate,myAccRowID, "AccPD", mySub)) q:(mySub="")  d
	...q:($d(^DHCACD("AccM",myAccRowID,"AccPD",mySub))=10)
	...s myPreInfo=$g(^DHCACD("AccM",myAccRowID,"AccPD",mySub))
	...s myTime=$p(myPreInfo,"^",4)			;AccPD_PreTime
	...q:((+mydate=+BDate)&(+myTime<+BTime))
	...q:((+mydate=+EndDate)&(+myTime>=+EndTime))
	...s myCount=myCount+1
	
	;b	;
	;查找这段时间内的消费金额
	;^DHCACDi("AccM",0,"PayDate",{AccPL_PayDate},
	;{DHC_AccManager.AccM_RowID},"AccPL",{AccPL_Sub})
	;^DHCACD("AccM",{DHC_AccManager.AccM_RowID},"AccPL",{AccPL_Sub})
	s mydate=""
	f mydate=BDate:1:EndDate d
	.s myAccRowID=0
	.f  s myAccRowID=$o(^DHCACDi("AccM",0,"PayDate",mydate, myAccRowID)) q:(myAccRowID="")  d
	..s mySub=0
	..f  s mySub=$o(^DHCACDi("AccM",0,"PayDate",mydate, myAccRowID,"AccPL",mySub)) q:(mySub="")  d
	...q:($d(^DHCACD("AccM",myAccRowID,"AccPL",mySub))=10)
	...s myPayInfo=$g(^DHCACD("AccM",myAccRowID,"AccPL",mySub))
	...s myTime=$p(myPayInfo,"^",7)
	...q:((+mydate=+BDate)&(+myTime<+BTime))
	...q:((+mydate=+EndDate)&(+myTime>=+EndTime))
	...s myCount=myCount+1
	
	q myCount
}

ClassMethod ReadACFinData() As %String
{
	n (ad)
	;w ##class(web.UDHCACFinBRFoot0PDBack).ReadACFinData()
	;北京积水潭医院获取门诊预交金的收入实现
	s $ZT="ERROR^DHCSSERR"
	
	s myrtn=..GetDate()
	
	;b	;getDate
	s myCount=0
	s myBDate=$p(myrtn,"^",1)
	s myBTime=$p(myrtn,"^",2)
	s myEndDate=$p(myrtn,"^",3)
	s myEndTime=$p(myrtn,"^",4)
		
	s myPFRowID=$p(myrtn,"^",5)
	
	s myAccPFRowID=$p(myrtn,"^",6)
	
	s myHSDate=$p(myrtn,"^",7)
	
	s myPreLeftSum=0
	i (myPFRowID'="") d
	.;本次的期初=上次的期末
	.s myPreLeftSum=$p($g(^DHCACD("AccPF",myPFRowID)),"^",9)
	
	s myPreSum=0
	s myRefundPreSum=0
	;获取操作员上缴的预交金金额；
	;1。
	;此处按照财务审核后的计算
	;对于积水潭计算的是操作员的日报日期
	;
	;^DHCOPInsFootI(0,"INSFDate",{HIS_INSFootDate},{HIS_Rowid})
	;^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	
	;对于积水潭计算
	;增加一个预交金按照缴退款收费的时间查询；
	;表：DHC_AccPreDeposit
	;^DHCACDi("AccM",0,"APDDate",{AccPD_PreDate},
	;{DHC_AccManager.AccM_RowID},"AccPD",{AccPD_Sub})
	s myPreSum=0
	s myRefundPreSum=0
	
	s myDate=myBDate-1
	f  s myDate=$o(^DHCACDi("AccM",0,"APDDate",myDate)) q:((myDate="")!(myDate>myEndDate))  d
	.s myAccRowID=0
	.f  s myAccRowID=$o(^DHCACDi("AccM",0,"APDDate",myDate, myAccRowID)) q:(myAccRowID="")  d
	..s myPDSub=0
	..f  s myPDSub=$o(^DHCACDi("AccM",0,"APDDate",myDate, myAccRowID,"AccPD",myPDSub)) q:(myPDSub="")  d
	...q:($d(^DHCACD("AccM",myAccRowID,"AccPD",myPDSub))=10)
	...s myTMPGInfo=$g(^DHCACD("AccM",myAccRowID,"AccPD",myPDSub))
	...s myTime=$p(myTMPGInfo,"^",4)			;AccPD_PreTime
	...q:((+myDate=+myBDate)&&(myTime<myBTime))
	...q:((+myDate=+myEndDate)&&(myTime>=myEndTime))
	...s myPreType=$p(myTMPGInfo,"^",1)			;AccPD_Type
	...s myTMPPreSum=$p(myTMPGInfo,"^",2)			;AccPD_PreSum
	...i (+myTMPPreSum>0) d
	....s myPreSum=myPreSum+myTMPPreSum
	...e  d
	....s myRefundPreSum=myRefundPreSum + myTMPPreSum
	;b		;得到PreSum
	
	;获取门诊卡支付金额合计
	;因为这个没有提前财务人员的结算，只有查询流水账
	///^DHCACDi("AccM",0,"PayDate",{AccPL_PayDate},                      x
	///x           {DHC_AccManager.AccM_RowID},"AccPL",{AccPL_Sub})	
	s myAPSum=0
	s myRoundSum=0
	s myAPPRTSum=0
	s myAPNoPRTSum=0
	s myDate=myBDate-1
	f  s myDate=$o(^DHCACDi("AccM",0,"PayDate",myDate))  q:((myDate="")!(myDate>myEndDate))  d
	.s myAccRowID=0
	.f  s myAccRowID=$o(^DHCACDi("AccM",0,"PayDate",myDate,myAccRowID))  q:(myAccRowID="")  d
	..s mySub=0
	..f  s mySub=$o(^DHCACDi("AccM",0,"PayDate",myDate,myAccRowID,"AccPL",mySub))  q:(mySub="")  d
	...q:($d(^DHCACD("AccM",myAccRowID,"AccPL",mySub))=10)
	...s myPayNum=+$p(^DHCACD("AccM",myAccRowID,"AccPL",mySub),"^",8)
	...s myTime=$p(^DHCACD("AccM",myAccRowID,"AccPL",mySub),"^",7)
	...q:((+myDate=+myBDate)&&(myTime<myBTime))
	...q:((+myDate=+myEndDate)&&(myTime>=myEndTime))
	...;^DHCINVPRTi(0,"AccPLDR",{IPM_AccPL_DR},{DHC_INVPRT.PRT_Rowid}
	...s myAccPLRowID=myAccRowID_"||"_mySub
	...s myPRTRowID=$o(^DHCINVPRTi(0,"AccPLDR",myAccPLRowID,0))
	...s myPRTNo=$p(^DHCINVPRT(myPRTRowID),"^",14)		;PRT_inv
	...s myCKPRTNO=##class(web.UDHCINVPRT).CheckCPPPRTNO(myPRTRowID)
	...s myPRTNo=$p(myCKPRTNO,"^",1)
	...s myHandin=$p(^DHCINVPRT(myPRTRowID),"^",10)		;PRT_Handin
	...;myAPPRTSum   myAPNoPRTSum
	...;q:((myPRTNo'="")&(myHandin'="Y"))
	...;&(myHandin="Y")
	...i ((myPRTNo'=""))  d
	....;打印发票的卡支付显示在界面中
	....s myAPPRTSum=+myAPPRTSum+myPayNum
	...i (myPRTNo="")  d
	....s myAPNoPRTSum=+myAPNoPRTSum+myPayNum
	...s myAPSum=+myAPSum+myPayNum
	...s myCount=myCount+1
	...s myRoundSum=+myRoundSum+$p(^DHCINVPRT(myPRTRowID),"^",37)			;PRT_OPCRoundErr
	
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
	s myAccInfo=myAccInfo_"^"_myAPSum_"^"_myLeftSum_"^"_myAPPRTSum_"^"_myAPNoPRTSum_"^"_myAccPFRowID
	s myAccInfo=myAccInfo_"^"_myHSDate_"^"_myRoundSum
	
	q rtn_$c(3)_myAccInfo
}

ClassMethod ACFinDataFoot(FootUserDR As %String, ACFInfo As %String, PFParRef As %String, ExpStr As %String) As %String
{
	;更新DHC_INVPRT
	;最好写DHC_INVPRTReports
	;写DHC_AccFoot
	;汇总个人的帐户信息(在这段时间内发生费用的账户)
	;在这之前结算的帐户不计算在内；
	;w ##class(web.UDHCACFinBRFoot1).ACFinDataFoot("23331","^^09/06/2006^16:15:44^23331^09/06/2006^16:14:27^2688456.77^377761.00^0.00^3040144.77^-26073.00")
	
	s $ZT="ERROR^DHCSSERR" 
	n (FootUserDR, ACFInfo,PFParRef, ExpStr)
	
	;s ^TMPACFin=FootUserDR_"%%%%"_ACFInfo
	
	d ..KillTMP()
	
	;ACFInfo=BDate, BTime, EDate, ETime, myPreLeftSum, myPreSum, myCardPaySum, myLeftSum
	;myRefundPreSum, 
	s rtn=0
	;b		;begin
	
	d ..tb()
	
	s myAccPFRowID=PFParRef
	
	s ^TMPDDDDDDDDDDDDDDPDBack=PFParRef
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
	;b   ;INSERT AccPFoot
	d ..ReadFBRAccPreLeft(myAccPFRowID)
	d ..ReadFBRAccPayList(BDate,BTime,EndDate,EndTime)
	d ..ReadFBRAccPreDList(BDate,BTime,EndDate,EndTime)
	
	s myQFInfo=##class(web.UDHCACFinBRFootIF).BulidAccQFList("")
	s myQFCurSum=$p(myQFInfo,"^",1)
	s myQFLeftSum=$p(myQFInfo,"^",2)
	
	;b		;TMP
	
	s mylen=$l(ACFInfo,"^")
	
	k PLIST
	f i=1:1:mylen  d
	
	s rtn=##class(web.UDHCAccPFoot).SELECT(PFParRef)
	
	s PLIST(7)=$P(ACFInfo,"^",7+1)
	s PLIST(8)=$P(ACFInfo,"^",8+1)
	s PLIST(9)=$P(ACFInfo,"^",9+1)
	s PLIST(10)=$P(ACFInfo,"^",10+1)
	s PLIST(11)=$P(ACFInfo,"^",11+1)
	s PLIST(12)=$P(ACFInfo,"^",12+1)
	s PLIST(13)=$P(ACFInfo,"^",13+1)
	
	
	s PLIST(17)=$P(ACFInfo,"^",17+1)
	s PLIST(18)=$P(ACFInfo,"^",18+1)
	;s myCardPaySum=$fn(PLIST(9),"",2)
	s PLIST(15)=+myQFCurSum		;AccPF_CurQFSum
	s PLIST(16)=+myQFLeftSum		;AccPF_CurLeftQFSum
	
	;b	;
	i +rtn=0 d
	.s rtn=##class(web.UDHCAccPFoot).UPDATE(PFParRef)
	
	s myPFParRef=PFParRef				;PLIST(1)
	
	;保存到FootSub中
	;先生成TMP，然后保存
	;b		;TMP
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
	..s myCurLeftSum=myPreLeftSum+myPreSum+myRefPreSum-myCPSum	;+$g(^TMPAcc($j,myAccRowID))
	..s myAccSCode=$p(^DHCACD("AccM",myAccRowID),"^",13)
	..s myQFLeftSum=+$g(^TMPAcc($j,myAccRowID,"QFLeft"))
	..s myQFSum=+$g(^TMPAcc($j,myAccRowID,"QFSum"))
	..s myRoundSum=+$g(^TMPAcc($j,myAccRowID,"ROUND"))
	..k PLIST
	..s PLIST(0)=myPFParRef
	..s PLIST(3)=myAccRowID
	..s PLIST(4)=+myPreLeftSum
	..s PLIST(5)=+myCPSum
	..s PLIST(6)=+myCurLeftSum
	..s PLIST(7)=+myRefPreSum
	..s PLIST(8)=+myPreSum
	..s PLIST(10)=+myQFSum
	..s PLIST(11)=+myRoundSum
	..s rtn=##class(web.UDHCAccPFootSub).INSERT()
	
	;写表DHC_INVPRTReports，同时作财务人员结算操作HIS_Date写，HIS_INSFootDate也写；
	
	;更新DHC_INVPRT表中的所有卡支付记录，不包括直接打印发票的   因为打印发票的是财务人员
	;
	;这个有些顾虑，。。。。。。。。。
	;(StDate , StTime , EndDate , EndTime , INVRepRef , HDate , HTime )
	
	;更新DHC_INVPRTReports表
	
	b	;Tro
	
	if +rtn=0  d
		.d ..tc()
	e  d
		.Trollback
	
	d ..KillTMP()
	
	q rtn_$c(3)_myPFParRef
}

ClassMethod KillTMP() As %String
{
	k ^TMPAcc($j)
}

ClassMethod ReadFBRAccFootClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadFBRAccFootExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 用户的消费额，,期间数据发生额
ClassMethod ReadFBRAccPayList(BDate As %String, BTime As %String, EndDate As %String, EndTime As %String) As %String
{
	;从DHC_AccPayList表中去消费数据，同时要兼顾DHC_INVPRT表
	n (BDate, BTime, EndDate, EndTime)
	
	s $ZT="ERROR^DHCSSERR"
	
	;^DHCACDi("AccM",0,"PayDate",{AccPL_PayDate},
	;{DHC_AccManager.AccM_RowID},"AccPL",{AccPL_Sub})
	
	s myDate=BDate-1
	f  s myDate=$o(^DHCACDi("AccM",0,"PayDate",myDate)) q:((myDate="")!(+myDate>+EndDate))  d
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
	...;q:((myPRTNo'="")&(myHandin'="Y"))
	...s myPaySum=$p(^DHCACD("AccM",myAccRowID,"AccPL",mySub),"^",8)
	...s ^TMPAcc($j,myAccRowID,"CP")=+myPaySum+$g(^TMPAcc($j,myAccRowID,"CP"))
	...;增加节点 为了金额误差结果  描述为每个帐户当天的优惠金额
	...;^TMPAcc($j,myAccRowID,"ROUND")
	...s myRoundSum=+$p(^DHCINVPRT(myPRTRowID),"^",37)			;PRT_OPCRoundErr
	...s ^TMPAcc($j,myAccRowID,"ROUND")=myRoundSum+$g(^TMPAcc($j,myAccRowID,"ROUND"))
	
	q 0
}

ClassMethod ReadFBRAccFootExecute(ByRef qHandle As %Binary, BDate As %String, BTime As %String, EndDate As %String, EndTime As %String) As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	d ..KillTMP()
	
	if (BDate["-")!(BDate["/") d
	.s BDate=$zdh(BDate,3)
	if BTime[":" d
	.s BTime=$zth(BTime)
	i EndDate["-" d
	.s EndDate=$zdh(EndDate,3)
	i EndTime[":" d
	.s EndTime=$zth(EndTime)
	
	s:BDate="" BDate=+$h
	s:BTime="" BTime=$p($h,",",2)
	s:EndDate="" EndDate=+$h
	s:EndTime="" EndTime=$p($h,",",2)
	
	;s ^TMPDD=BDate_"^"_BTime_"^"_EndDate_"^"_EndTime
	
	d ResetVariablesFR
	
	d ..ReadFBRAccPreLeft()
	d ..ReadFBRAccPayList(BDate,BTime,EndDate,EndTime)
	d ..ReadFBRAccPreDList(BDate,BTime,EndDate,EndTime)
	
	s PreLeftTSum=0
	s PreTSum=0
	s RefPreTSum=0
	s CPTSum=0
	s CurLeftTSum=0
	
	s myIdx=0
	s myAccRowID=0
	f  s myAccRowID=$o(^TMPAcc($j,myAccRowID)) q:(myAccRowID="")  d
	.s myIdx=myIdx+1
	.s myAccRID=myAccRowID
	.s myPAPMINo=$p(^DHCACD("AccM",myAccRowID),"^",3)
	.s myPAPMDR=$p(^DHCACD("AccM",myAccRowID),"^",2)
	.s myPAName=$p(^PAPER(myPAPMDR,"ALL"),"^",1)
	.s myCADateT=$zd($p(^DHCACD("AccM",myAccRowID),"^",5),3)
	.s myCADateT=myCADateT_" "_$zt($p(^DHCACD("AccM",myAccRowID),"^",6))
	.s myPreLeftSum=+$g(^TMPAcc($j,myAccRowID,"PLeft"))
	.s PreLeftTSum=+PreLeftTSum+myPreLeftSum
	.s myPreSum=+$g(^TMPAcc($j,myAccRowID,"GPD"))
	.s PreTSum=+PreTSum+myPreSum
	.s myRefPreSum=+$g(^TMPAcc($j,myAccRowID,"RPD"))
	.s RefPreTSum=+RefPreTSum+myRefPreSum
	.s myCPSum=+$g(^TMPAcc($j,myAccRowID,"CP"))
	.s CPTSum=+CPTSum+myCPSum
	.s myCurLeftSum=myPreLeftSum+myPreSum+myRefPreSum-myCPSum	;+$g(^TMPAcc($j,myAccRowID))
	.s CurLeftTSum=+CurLeftTSum+myCurLeftSum
	.
	.s myAccSCode=$p(^DHCACD("AccM",myAccRowID),"^",13)
	.i myAccSCode="N" s myAccStatus="正常"
	.i myAccSCode="F" s myAccStatus="结算"
	.i myAccSCode="S" s myAccStatus="挂起"
	.s No=myIdx
	.d OutputFR
	
	;合计
	;s (No,RepID,FootDate,FootTime,INVSum,HandSum,BegFootDT,EndFootDT)=""
	d ResetVariablesFR
	
	s No="合计"
	s myPreLeftSum=$fn(PreLeftTSum,"",2)
	s myPreSum=$fn(PreTSum,"",2)
	s myRefPreSum=$fn(RefPreTSum,"",2)
	s myCPSum=$fn(CPTSum,"",2)
	s myCurLeftSum=$fn(CurLeftTSum,"",2)
	
	d OutputFR

	d ..KillTMP()
	
	Quit $$$OK
ResetVariablesFR
	s (No,myAccRID,myPAPMINo,myPAName,myCADateT, myPreLeftSum,myPreSum,myRefPreSum, myCPSum, myCurLeftSum, myAccStatus)=""
	quit
OutputFR
	s Data=$lb(No,myAccRID,myPAPMINo,myPAName,myCADateT, myPreLeftSum,myPreSum,myRefPreSum, myCPSum, myCurLeftSum, myAccStatus)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

/// 操作员上缴额的财务结算预交金,期间数据发生额
ClassMethod ReadFBRAccPreDList(BDate As %String, BTime As %String, EndDate As %String, EndTime As %String) As %String
{
	;从DHC_INVPRTReports 表中取数据
	;此处按照财务审核后的计算
	;w ##class(web.UDHCACFinBRFoot1).ReadFBRAccPreDList(60329,57970,60410,79366)
	n (BDate, BTime, EndDate, EndTime)
	;
	s $ZT="ERROR^DHCSSERR"
	
	s myDate=BDate-1
	
	;此处按照财务审核后的计算
	;^DHCOPInsFootI(0,"INSFDate",{HIS_INSFootDate},{HIS_Rowid})
	
	;按照预交金缴退款时间计算
	;^DHCACDi("AccM",0,"APDDate",{AccPD_PreDate},
	;{DHC_AccManager.AccM_RowID},"AccPD",{AccPD_Sub})
	;^DHCACD("AccM",{DHC_AccManager.AccM_RowID},"AccPD",{AccPD_Sub})
	
	f myDate=BDate:1:EndDate d
	.s myAccRowID=0
	.f  s myAccRowID=$o(^DHCACDi("AccM",0,"APDDate",myDate, myAccRowID)) q:(myAccRowID="")  d
	..s mySub=0
	..f  s mySub=$o(^DHCACDi("AccM",0,"APDDate",myDate, myAccRowID, "AccPD", mySub)) q:(mySub="")  d
	...q:($d(^DHCACD("AccM",myAccRowID,"AccPD",mySub))=10)
	...s myTime=$p(^DHCACD("AccM",myAccRowID,"AccPD",mySub),"^",4)			;AccPD_PreTime
	...q:((+myDate=+BDate)&&(myTime<BTime))
	...q:((+myDate=+EndDate)&&(myTime>=EndTime))
	...s myPreSum=$p($g(^DHCACD("AccM",myAccRowID,"AccPD",mySub)),"^",2)
	...i (+myPreSum>0) d
	....s ^TMPAcc($j,myAccRowID,"GPD")=+myPreSum+$g(^TMPAcc($j,myAccRowID,"GPD"))
	...e  d
	....s ^TMPAcc($j,myAccRowID,"RPD")=+myPreSum+$g(^TMPAcc($j,myAccRowID,"RPD"))
	
	
	q 0
}

ClassMethod ReadFBRAccFootFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadFBRAccFootExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 读取预交金的前期余额
ClassMethod ReadFBRAccPreLeft(myPFRowID As %String) As %String
{
	n (dd, myPFRowID)
	;myPFRowID  前一个RowID
	;w ##class(web.UDHCACFinBRFoot0Back).ReadFBRAccPreLeft(7)
	s $ZT="ERROR^DHCSSERR"
	
	s myMRowID=$o(^DHCACD("AccPF",""),-1)
	;有个Bug  ，如果数据回滚就会产生虚节点，最好用索引的节点来求，才不会产生错误；
	;^DHCACDi("AccPF",0,"CurDateT",{AccPF_Date},{AccPF_RowID})
	s myPFDate=$o(^DHCACDi("AccPF",0,"CurDateT",""),-1)
	q:(myPFDate="")
	s myMRowID=$o(^DHCACDi("AccPF",0,"CurDateT",myPFDate, ""),-1)
	
	s myddd=0
	s myTMPMRowID=myPFRowID
	
	f  s myTMPMRowID=$o(^DHCACD("AccPF",myTMPMRowID),-1)  q:((myTMPMRowID="")!(+myddd'=0))  d
	.q:($d(^DHCACD("AccPF",myTMPMRowID))=10)
	.s myMRowID=myTMPMRowID
	.;;b		;;;
	.s myddd=1
	
	;b		;myddd
	q:(myMRowID="")
	;b		;;;TMPPPP
	s mySub=0
	f  s mySub=$o(^DHCACD("AccPF",myMRowID,"PF",mySub)) q:(mySub="")  d
	.q:($d(^DHCACD("AccPF",myMRowID,"PF",mySub))=10)
	.s myAccRowID=$p(^DHCACD("AccPF",myMRowID,"PF",mySub),"^",1)
	.s myCurLeft=+$p($g(^DHCACD("AccPF",myMRowID,"PF",mySub)),"^",5)
	.q:(+myCurLeft=0)
	.s ^TMPAcc($j,myAccRowID,"PLeft")=+myCurLeft
	
	;b		;;;Get PFCurLeft
	
	q 0
}

/// 读取预交金的前期余额
ClassMethod ReadFBRAccPreLeftOld() As %String
{
	n (dd)
	;w ##class(web.UDHCACFinBRFoot1).ReadFBRAccPreLeft()
	s $ZT="ERROR^DHCSSERR"
	
	s myMRowID=$o(^DHCACD("AccPF",""),-1)
	;有个Bug  ，如果数据回滚就会产生虚节点，最好用索引的节点来求，才不会产生错误；
	;^DHCACDi("AccPF",0,"CurDateT",{AccPF_Date},{AccPF_RowID})
	s myPFDate=$o(^DHCACDi("AccPF",0,"CurDateT",""),-1)
	q:(myPFDate="")
	s myMRowID=$o(^DHCACDi("AccPF",0,"CurDateT",myPFDate, ""),-1)
	
	q:(myMRowID="")
	b		;;;TMPPPP
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

Query ReadFBRAccFoot(BDate As %String, BTime As %String, EndDate As %String, EndTime As %String) As %Query(ROWSPEC = "No:%String,AccRID:%String,PAPMINo:%String,PAName:%String,CADateT:%String, PreLeftSum:%String, PreSum:%String, RefPreSum:%String, CPSum:%String, CurLeftSum:%String, AccStatus:%String")
{
}

}
