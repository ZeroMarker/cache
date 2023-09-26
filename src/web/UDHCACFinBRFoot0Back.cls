Class web.UDHCACFinBRFoot0Back Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 285;

ClassMethod ACFinDataAutoFoot() As %String
{
	///使用此方法来校正总帐字表；
	///校正按照操作员日报的点的预交金方案
	;专门用来校正数据
	;提供给服务器的自动结算类方法；
	;d ##class(web.UDHCACFinBRFoot0Back).ACFinDataAutoFoot()
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
	b		;;;;FootInfo
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
	;b	;;;
	;写一次日志写到^TMP
	i +myrtn=0 d
	.s myFootUserDR="10368"		;;sfsys  门诊账户系统作账
	.s myaccinfo=$p(myfootinfo,$c(3),2)
	.s $p(myACFInfo,"^",1)=""
	.s $p(myACFInfo,"^",2)=""
	.s $p(myACFInfo,"^",3)=$p(myaccinfo,"^",3)			;PFBCurrentDate
	.s $p(myACFInfo,"^",4)=$p(myaccinfo,"^",4)			;PFBCurrentTime
	.s $p(myACFInfo,"^",5)=myFootUserDR			;LOGON.USERID
	.s $p(myACFInfo,"^",6)=$p(myaccinfo,"^",1)			;PFBLastDate
	.s $p(myACFInfo,"^",7)=$p(myaccinfo,"^",2)			;PFBLastTime
	.s $p(myACFInfo,"^",8)=$p(myaccinfo,"^",5)			;LastPDLeft
	.s $p(myACFInfo,"^",9)=$p(myaccinfo,"^",6)			;PDIncomeSum
	.s $p(myACFInfo,"^",10)=$p(myaccinfo,"^",8)			;AccPaySum
	.s $p(myACFInfo,"^",11)=$p(myaccinfo,"^",9)			;PDLeft
	.s $p(myACFInfo,"^",12)=$p(myaccinfo,"^",7)			;PDReturnSum
	.s $p(myACFInfo,"^",13)=$p(myaccinfo,"^",10)			;PrtAccPaySum
	.s $p(myACFInfo,"^",14)=$p(myaccinfo,"^",11)			;NOPrtAccPaySum
	.s myAccPFRowID=$p(myaccinfo,"^",12)				;当前的结算RowID
	.s ExpStr=""
	.;b	;;;
	.s myfootsaveinfo=..ACFinDataFoot(myFootUserDR ,myACFInfo,myAccPFRowID, ExpStr)
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

/// ///北京积水潭医院专用
/// ///Version：0
ClassMethod GetDate() As %String
{
	;得到一个开始和结束日期
	;获取方式：
	;在表DHC_AccFoot表中
	;w ##class(web.UDHCACFinBRFoot0Back).GetDate()
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
	
	s myTMPRowID=$g(^TMPDDDDDDDDDDDDDD)

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
	
	;b		;; GetDate
	
	s myBDate=$p(^DHCACDBack("AccPF",myAccPFRowID),"^",4)
	s myBTime=$p(^DHCACDBack("AccPF",myAccPFRowID),"^",5)
	s curdate=$p(^DHCACDBack("AccPF",myAccPFRowID),"^",1)
	s curtime=$p(^DHCACDBack("AccPF",myAccPFRowID),"^",2)
	
	w "当前的号:"_myPFRowID_"^"_myAccPFRowID
	
	;b			;GetDate;Test
	q myBDate_"^"_myBTime_"^"_curdate_"^"_curtime_"^"_myPFRowID_"^"_myAccPFRowID
}

ClassMethod ReadACFinData() As %String
{
	n (ad)
	;w ##class(web.UDHCACFinBRFoot0Back).ReadACFinData()
	;北京积水潭医院获取门诊预交金的收入实现
	;s $ZT="ERROR^DHCSSERR"
	
	s myrtn=..GetDate()
	
	;b	;getDate
	s myCount=0
	s myBDate=$p(myrtn,"^",1)
	s myBTime=$p(myrtn,"^",2)
	s myEndDate=$p(myrtn,"^",3)
	s myEndTime=$p(myrtn,"^",4)
	
	s myPFRowID=$p(myrtn,"^",5)
	
	s myAccPFRowID=$p(myrtn,"^",6)
	
	s myPreLeftSum=0
	i (myPFRowID'="") d
	.;本次的期初=上次的期末
	.s myPreLeftSum=$p($g(^DHCACD("AccPF",myPFRowID)),"^",9)
			;
	s myPreSum=0
	s myRefundPreSum=0
	;获取操作员上缴的预交金金额；
	;1。
	;此处按照财务审核后的计算
	;对于积水潭计算的是操作员的日报日期
	;^DHCOPInsFootI(0,"INSFDate",{HIS_INSFootDate},{HIS_Rowid})
	;^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	s myDate=myBDate-1
	f  s myDate=$o(^DHCOPInsFootI(0,"Date",myDate)) q:((myDate="")!(myDate>myEndDate))  d
	.s myHISRowID=0
	.f  s myHISRowID=$o(^DHCOPInsFootI(0,"Date",myDate, myHISRowID))  q:(myHISRowID="")  d
	..q:($d(^DHCOPInsFoot(myHISRowID))=10)
	..;s myTime=$p(^DHCOPInsFoot(myHISRowID),"^",14)			;HIS_INSFootTime
	..s myTime=$p(^DHCOPInsFoot(myHISRowID),"^",7)			;;HIS_Time
	..q:((+myDate=+myBDate)&&(myTime<myBTime))
	..q:((+myDate=+myEndDate)&&(myTime>=myEndTime))
	..
	..s myPreSum=+myPreSum+$p(^DHCOPInsFoot(myHISRowID),"^",52)
	..s myRefundPreSum=+myRefundPreSum+$p(^DHCOPInsFoot(myHISRowID),"^",54)
	
	;获取门诊卡支付金额合计
	;因为这个没有提前财务人员的结算，只有查询流水账
	///^DHCACDi("AccM",0,"PayDate",{AccPL_PayDate},                      x
	///x           {DHC_AccManager.AccM_RowID},"AccPL",{AccPL_Sub})	
	s myAPSum=0
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
	
	q rtn_$c(3)_myAccInfo
}

ClassMethod ACFinDataFoot(FootUserDR As %String, ACFInfo As %String, PFParRef As %String, ExpStr As %String) As %String
{
	;更新DHC_INVPRT
	;最好写DHC_INVPRTReports
	;写DHC_AccFoot
	;汇总个人的帐户信息(在这段时间内发生费用的账户)
	;在这之前结算的帐户不计算在内；
	;w ##class(web.UDHCACFinBRFoot0Back).ACFinDataFoot("23331","^^09/06/2006^16:15:44^23331^09/06/2006^16:14:27^2688456.77^377761.00^0.00^3040144.77^-26073.00")
	
	s $ZT="ERROR^DHCSSERR" 
	n (FootUserDR, ACFInfo, PFParRef, ExpStr)
	
	s ^TMPACFin=FootUserDR_"%%%%"_ACFInfo
	
	d ..KillTMP()
	
	;ACFInfo=BDate, BTime, EDate, ETime, myPreLeftSum, myPreSum, myCardPaySum, myLeftSum
	;myRefundPreSum, 
	s rtn=0
	;b		;begin
	
	d ..tb()
	
	s ^TMPDDDDDDDDDDDDDD=PFParRef
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
	d ..ReadFBRAccPreLeft(PFParRef)
	d ..ReadFBRAccPayList(BDate,BTime,EndDate,EndTime)
	d ..ReadFBRAccPreDList(BDate,BTime,EndDate,EndTime)
	
	;b		;TMP
	
	s mylen=$l(ACFInfo,"^")
	
	k PLIST
	f i=1:1:mylen  d
	.;q:($P(ACFInfo,"^",i+1)="")
	.;s PLIST(i)=$P(ACFInfo,"^",i+1)
	
	s rtn=##class(web.UDHCAccPFoot).SELECT(PFParRef)
	
	s PLIST(7)=$P(ACFInfo,"^",7+1)
	s PLIST(8)=$P(ACFInfo,"^",8+1)
	s PLIST(9)=$P(ACFInfo,"^",9+1)
	s PLIST(10)=$P(ACFInfo,"^",10+1)
	s PLIST(11)=$P(ACFInfo,"^",11+1)
	s PLIST(12)=$P(ACFInfo,"^",12+1)
	s PLIST(13)=$P(ACFInfo,"^",13+1)
	
	;s myCardPaySum=$fn(PLIST(9),"",2)
	
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
	..k PLIST
	..s PLIST(0)=myPFParRef
	..s PLIST(3)=myAccRowID
	..s PLIST(4)=+myPreLeftSum
	..s PLIST(5)=+myCPSum
	..s PLIST(6)=+myCurLeftSum
	..s PLIST(7)=+myRefPreSum
	..s PLIST(8)=+myPreSum
	..s rtn=##class(web.UDHCAccPFootSub).INSERT()
	
	
	;需要对Reports表与账户总帐的值
	;写表DHC_INVPRTReports，同时作财务人员结算操作HIS_Date写，HIS_INSFootDate也写；
	
	;b		;;;;Update INVPRT  EndDate
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
	
	q 0
}

ClassMethod ReadFBRAccFootExecute(ByRef qHandle As %Binary, BDate As %String, BTime As %String, EndDate As %String, EndTime As %String) As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;2
	;d ##class(%ResultSet).RunQuery("web.UDHCACFinBRFoot0Back","ReadFBRAccFoot",60562,25826,60562,86399)
	;7
	;d ##class(%ResultSet).RunQuery("web.UDHCACFinBRFoot0Back","ReadFBRAccFoot",60562,86399,60563,86399)
	
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
	;w ##class(web.UDHCACFinBRFoot0Back).ReadFBRAccPreDList(60562,25826,60562,86399)
	n (BDate, BTime, EndDate, EndTime)
	;
	s $ZT="ERROR^DHCSSERR"
	
	s myDate=BDate-1
	
	;此处按照财务审核后的计算
	;^DHCOPInsFootI(0,"INSFDate",{HIS_INSFootDate},{HIS_Rowid})
	s myDate=BDate-1
	f  s myDate=$o(^DHCOPInsFootI(0,"Date",myDate)) q:((myDate="")!(myDate>EndDate))  d
	.s myHISRowID=0
	.f  s myHISRowID=$o(^DHCOPInsFootI(0,"Date",myDate, myHISRowID))  q:(myHISRowID="")  d
	..q:($d(^DHCOPInsFoot(myHISRowID))=10)
	..;s myTime=$p(^DHCOPInsFoot(myHISRowID),"^",14)			;HIS_INSFootTime
	..s myTime=$p(^DHCOPInsFoot(myHISRowID),"^",7)			;HIS_Time
	..q:((+myDate=+BDate)&&(myTime<BTime))
	..q:((+myDate=+EndDate)&&(myTime>=EndTime))
	..
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
