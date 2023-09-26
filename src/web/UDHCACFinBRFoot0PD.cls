Import SQLUser

Class web.UDHCACFinBRFoot0PD Extends BILL.COM.Abstract
{

/// 专门提供一个按照流水缴退预交金的时间来生成总账
/// 功能：
/// 1.按照  预交金缴退款流水时间
/// 2.按照  卡支付时间点
/// 3.按照  能够按照设置能够自动截取时间段/或者不截取直接按照(上次时间--当前时间)
/// Debug: w ##class(web.UDHCACFinBRFoot0PD).ACFinDataAFFor()
ClassMethod ACFinDataAFFor() As %String
{
	set count=0
	set myflag=0
	while (myflag=0){
		set count=$i(count)
		set myrtnstr=..ACFinDataAutoFootTask()
		set mybd=$p(myrtnstr,"^",2)
		set myetime=$p(myrtnstr,"^",3)
		//set mybd=+$h
		if ((+mybd>=+$h)&(+myetime>0)) {
			set myflag=1
		}
		if (+count>20) {
			set myflag=1
		}
	}
	
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2021-09-09
/// Description: 预交金账结算任务
/// Input: 
/// Return: 
/// Debug: do ##class(web.UDHCACFinBRFoot0PD).ACFinDataAutoFootTask()
ClassMethod ACFinDataAutoFootTask() As %String
{
	set rtn=0
	set pageId=##class(web.DHCBillWebPage).GetWebPageRowId("opaccdepaccount")
	quit:(+pageId=0) rtn
	set cfgId=0
	while($o(^DHCBillWP(0,pageId,"Site","HOSPITAL","Code","FOOTUSER","C",cfgId))) {
		set cfgId=$o(^DHCBillWP(0,pageId,"Site","HOSPITAL","Code","FOOTUSER","C",cfgId))
		set cfgData=$g(^DHCBillWP(pageId,"C",cfgId))
		continue:(cfgData="")
		set hospId=$p(cfgData,"^",2)
		set userId=$p(cfgData,"^",4)
		set rtn=..ACFinDataAutoFoot(userId, hospId)
	}
	
	quit rtn
}

/// 提供给服务器的自动结算类方法
/// 提供一个按照预交金收退款时间点计算的账户总账
/// Debug: do ##class(web.UDHCACFinBRFoot0PD).ACFinDataAutoFoot()
ClassMethod ACFinDataAutoFoot(userId As %String, hospId As %String) As %String
{
	set myfootinfo=..ReadACFinData(hospId)
	set myrtn=$p(myfootinfo,$c(3),1)
	quit:(+myrtn) 0
	
	set myaccinfo=$p(myfootinfo,$c(3),2)
	set mybdate=##class(websys.Conversions).DateHtmlToLogical($p(myaccinfo,"^",1))
	set myedate=##class(websys.Conversions).DateHtmlToLogical($p(myaccinfo,"^",3))
	set myetime=##class(websys.Conversions).TimeHtmlToLogical($p(myaccinfo,"^",4), 1)

	quit:((+mybdate>+$h)||((+myedate>=+$h)&&(+myetime'=0))) 0
	
	//写一次日志写到^TMP
	set $p(myACFInfo,"^",1)=""
	set $p(myACFInfo,"^",2)=""
	set $p(myACFInfo,"^",3)=$p(myaccinfo,"^",3)		        ;PFBCurrentDate
	set $p(myACFInfo,"^",4)=$p(myaccinfo,"^",4)			    ;PFBCurrentTime
	set $p(myACFInfo,"^",5)=userId			                ;PFUserDR
	set $p(myACFInfo,"^",6)=$p(myaccinfo,"^",1)			    ;PFBLastDate
	set $p(myACFInfo,"^",7)=$p(myaccinfo,"^",2)			    ;PFBLastTime
	set $p(myACFInfo,"^",8)=$p(myaccinfo,"^",5)			    ;LastPDLeft
	set $p(myACFInfo,"^",9)=$p(myaccinfo,"^",6)			    ;PDIncomeSum
	set $p(myACFInfo,"^",10)=$p(myaccinfo,"^",8)			;AccPaySum
	set $p(myACFInfo,"^",11)=$p(myaccinfo,"^",9)		    ;PDLeft
	set $p(myACFInfo,"^",12)=$p(myaccinfo,"^",7)			;PDReturnSum
	set $p(myACFInfo,"^",13)=$p(myaccinfo,"^",10)			;PrtAccPaySum
	set $p(myACFInfo,"^",14)=$p(myaccinfo,"^",11)			;NOPrtAccPaySum
	set $p(myACFInfo,"^",18)=$p(myaccinfo,"^",12)			;HSDate
	set $p(myACFInfo,"^",19)=$p(myaccinfo,"^",13)			;RoundSum
	set $p(myACFInfo,"^",20)=$p(myaccinfo,"^",14)			;PaySumByNoCard
	set $p(myACFInfo,"^",21)=$p(myaccinfo,"^",15)			;myYBPaySum
	set $p(myACFInfo,"^",22)=hospId							;AccPF_Hospital_DR
	set expStr=""
	set rtnValue=..ACFinDataFoot(myACFInfo, expStr)
	set myrtn=$p(rtnValue,$c(3),1)
	if (+myrtn=0) {
		//结算成功
		set ^TMPDHCACFinDataFoot("S",$h)="系统自动结算成功,时间："_$zd(+$h,3)_" "_$zt($p($h,",",2))
		set ^TMPDHCACFinDataFoot("S",$h,"ACFInfo")=myACFInfo
	}else {
		//结算失败日志
		set ^TMPDHCACFinDataFoot("F",$h)="系统自动结算失败,时间："_$zd(+$h,3)_" "_$zt($p($h,",",2))
		set ^TMPDHCACFinDataFoot("F",$h,"ACFInfo")=myACFInfo
		set ^TMPDHCACFinDataFoot("F",$h,"FailInfo")=rtnValue
	}
	
	quit 0
}

/// 得到一个开始和结束日期
/// 获取方式：在表DHC_AccFoot表中
/// 由于此结算是全部的结算。只是寻找最大的时间
/// Debug: w ##class(web.UDHCACFinBRFoot0PD).GetDate(2)
ClassMethod GetDate(hospId As %String) As %String
{
	set myBDate=""
	set myBTime=""
	set myPFRowID=""
	
	set myId=""
	while($o(^DHCACD("AccPF",myId),-1)&&(+myPFRowID=0)) {
		set myId=$o(^DHCACD("AccPF",myId),-1)
		set myData=$g(^DHCACD("AccPF",myId))
		continue:(myData="")
		set myHospDR=$p(myData,"^",20)
		continue:((hospId'="")&&(hospId'=myHospDR))
		set myPFRowID=myId
		set myBDate=$p(myData,"^",1)
		set myBTime=$p(myData,"^",2)
	}

	//没有办理结算时取账户管理的最小时间
	if (+myPFRowID=0) {
		set myBDate=$o(^DHCACDi("AccM",0,"OCDate",myBDate))     //最小时间
		if (myBDate'="") {
			set myAccRowID=$o(^DHCACDi("AccM",0,"OCDate",myBDate,0))
			set myBTime=$p($g(^DHCACD("AccM",myAccRowID)),"^",6)
		}
	}
	if (myBDate="") {
		set myBDate=+$h
	}
	if (myBTime="") {
		set myBTime=$p($h,",",2)
	}
	
	set myDateInfo=..AutoGetDT(myBDate, myBTime, +$h, hospId)
	set curDate=$p(myDateInfo,"^",1)
	set curTime=$p(myDateInfo,"^",2)
	
	set myHSDate=0
	if (+myBDate=+curDate) {
		set myHSDate=+curDate
	}elseif((+myBDate'=+curDate)&&(curTime=0)) {
		set myHSDate=+curDate-1
	}else {
		set myHSDate=curDate
	}
	
	quit myBDate_"^"_myBTime_"^"_curDate_"^"_curTime_"^"_myPFRowID_"^"_myHSDate
}

/// Description: 自动获取有效的时间段(时间段内包含数据)
/// Debug: w ##class(web.UDHCACFinBRFoot0PD).AutoGetDT("65804","49611",65999,2)
ClassMethod AutoGetDT(BDate As %String, BTime As %String, EndDate As %String, HospId As %String) As %String
{
	//自动获取0  --0 点
	set myrtn=+$h_"^"_$p($h,",",2)
	
	if (+BDate>=+$h) {
		quit myrtn
	}
	
	//截取为0点
	set myEndTime=0
	set myEndDate=EndDate
	
	for myDate=BDate:1:EndDate {
		quit:(+myDate>=+$h)
		set myTime=$s((myDate>BDate):0,1:BTime)
		set myCount=..CheckAccFlag(myDate, myTime, (myDate+1), myEndTime, HospId)
		if (+myCount'=0) {
			//如果当天存在要结算数据, 把结束时间定为明天的0分
			set myEndDate=myDate+1
			set myEndTime=0
			set myrtn=myEndDate_"^"_myEndTime
			quit
		}
	}

	quit myrtn
}

/// Debug: w ##class(web.UDHCACFinBRFoot0PD).CheckAccFlag(60446, 0, 60447, 0, 2)
ClassMethod CheckAccFlag(BDate As %String, BTime As %String, EndDate As %String, EndTime As %String, HospId As %String) As %String
{
	set myCount=0
	
	for myDate=BDate:1:EndDate {
		quit:(+myCount'=0)
		
		//预交金
		set myAccRowID=0
		while($o(^DHCACDi("AccM",0,"APDDate",myDate,myAccRowID))&&(+myCount=0)) {
			set myAccRowID=$o(^DHCACDi("AccM",0,"APDDate",myDate,myAccRowID))
			set mySub=0
			while($o(^DHCACDi("AccM",0,"APDDate",myDate,myAccRowID,"AccPD",mySub))&&(+myCount=0)) {
				set mySub=$o(^DHCACDi("AccM",0,"APDDate",myDate,myAccRowID,"AccPD",mySub))
				set myPDData=$g(^DHCACD("AccM",myAccRowID,"AccPD",mySub))
				set myHospDR=$p(myPDData,"^",15)
				continue:((HospId'="")&&(HospId'=myHospDR))
				set myTime=$p(myPDData,"^",4)
				continue:((+myDate=+BDate)&&(+myTime<+BTime))
				continue:((+myDate=+EndDate)&&(+myTime>=+EndTime))
				set myCount=$i(myCount)
			}
		}
		
		//消费流水
		set myAccRowID=0
		while($o(^DHCACDi("AccM",0,"PayDate",myDate,myAccRowID))&&(+myCount=0)) {
			set myAccRowID=$o(^DHCACDi("AccM",0,"PayDate",myDate,myAccRowID))
			set mySub=0
			while($o(^DHCACDi("AccM",0,"PayDate",myDate,myAccRowID,"AccPL",mySub))&&(+myCount=0)) {
				set mySub=$o(^DHCACDi("AccM",0,"PayDate",myDate,myAccRowID,"AccPL",mySub))
				set myPLData=$g(^DHCACD("AccM",myAccRowID,"AccPL",mySub))
				set myHospDR=$p(myPLData,"^",16)
				continue:((HospId'="")&&(HospId'=myHospDR))
				set myTime=$p(myPLData,"^",7)
				continue:((+myDate=+BDate)&&(+myTime<+BTime))
				continue:((+myDate=+EndDate)&&(+myTime>=+EndTime))
				set myCount=$i(myCount)
			}
		}
	}
	
	quit myCount
}

/// Description: 门诊预交金的收入
/// Debug: w ##class(web.UDHCACFinBRFoot0PD).ReadACFinData(2)
ClassMethod ReadACFinData(hospId As %String) As %String
{
	set myrtn=..GetDate(hospId)
	
	set myCount=0
	set myBDate=$p(myrtn,"^",1)
	set myBTime=$p(myrtn,"^",2)
	set myEndDate=$p(myrtn,"^",3)
	set myEndTime=$p(myrtn,"^",4)
	set myPFRowID=$p(myrtn,"^",5)
	set myHSDate=$p(myrtn,"^",6)
	
	set myPreLeftSum=0
	if (myPFRowID'="") {
		//本次的期初=上次的期末
		set myPreLeftSum=$p($g(^DHCACD("AccPF",myPFRowID)),"^",9)
	}
	
	//获取操作员上缴的预交金金额 DHC_AccPreDeposit
	set myPreSum=0
	set myRefundPreSum=0
	
	set myDate=myBDate-1
	for  set myDate=$o(^DHCACDi("AccM",0,"APDDate",myDate)) quit:((myDate="")||(myDate>myEndDate))  do
	.set myAccRowID=0
	.for  set myAccRowID=$o(^DHCACDi("AccM",0,"APDDate",myDate,myAccRowID)) quit:(myAccRowID="")  do
	..set myPDSub=0
	..for  set myPDSub=$o(^DHCACDi("AccM",0,"APDDate",myDate,myAccRowID,"AccPD",myPDSub)) quit:(myPDSub="")  do
	...set myPDData=$g(^DHCACD("AccM",myAccRowID,"AccPD",myPDSub))
	...quit:(myPDData="")
	...set myHospDR=$p(myPDData,"^",15)
	...quit:((hospId'="")&&(hospId'=myHospDR))
	...set myTime=$p(myPDData,"^",4)			//AccPD_PreTime
	...quit:((+myDate=+myBDate)&&(myTime<myBTime))
	...quit:((+myDate=+myEndDate)&&(myTime>=myEndTime))
	...set myPreType=$p(myPDData,"^",1)		//AccPD_Type
	...set myPreAmt=$p(myPDData,"^",2)		//AccPD_PreSum
	...set myCount=$i(myCount)
	...if (+myPreAmt>0) do
	....set myPreSum=$i(myPreSum, myPreAmt)
	...else  do
	....set myRefundPreSum=$i(myRefundPreSum, myPreAmt)
	
	//获取门诊卡支付金额合计
	//因为这个没有提前财务人员的结算，只有查询流水账
	set myAPSum=0
	set myAPPRTSum=0
	set myAPNoPRTSum=0

	set myDate=myBDate-1
	for  set myDate=$o(^DHCACDi("AccM",0,"PayDate",myDate))  quit:((myDate="")||(myDate>myEndDate))  do
	.set myAccRowID=0
	.for  set myAccRowID=$o(^DHCACDi("AccM",0,"PayDate",myDate,myAccRowID))  quit:(myAccRowID="")  do
	..set mySub=0
	..for  set mySub=$o(^DHCACDi("AccM",0,"PayDate",myDate,myAccRowID,"AccPL",mySub))  quit:(mySub="")  do
	...set myPLData=$g(^DHCACD("AccM",myAccRowID,"AccPL",mySub))
	...quit:(myPLData="")
	...set myHospDR=$p(myPLData,"^",16)
	...quit:((hospId'="")&&(hospId'=myHospDR))
	...set myTime=$p(myPLData,"^",7)
	...quit:((+myDate=+myBDate)&&(myTime<myBTime))
	...quit:((+myDate=+myEndDate)&&(myTime>=myEndTime))
	...set myPayNum=+$p(myPLData,"^",8)
	...set myCount=$i(myCount)
	...set myAPSum=$i(myAPSum, myPayNum)
	...set myAccPLRowID=myAccRowID_"||"_mySub
	...set myPRTRowID=$p(myPLData,"^",2)
	...set myBusiType=$p(myPLData,"^",11)
	...set myPRTNo=""
	...if ((myBusiType="OP")&&(myPRTRowID'="")) do
	....set myCKPRTNO=##class(web.UDHCINVPRT).CheckCPPPRTNO(myPRTRowID)
	....set myPRTNo=$p(myCKPRTNO,"^",1)
	...if (myPRTNo'="")  do
	....//打印发票的卡支付显示在界面中
	....set myAPPRTSum=$i(myAPPRTSum, myPayNum)
	...else  do
	....set myAPNoPRTSum=$i(myAPNoPRTSum, myPayNum)
	
	//对于折扣的一个计算
	//计算非卡支付的金额
	//对于其他支付在INVPRT表走
	set myYBPaySum=0			//医保支付额度 可能存在于DHC_INVPRT 或者DHC_AccPayINV表
	set myRoundSum=0
	set myNoCardPaySum=0

	set myDate=myBDate-1
	for  set myDate=$o(^DHCINVPRT(0,"Date",myDate)) quit:((myDate="")||(myDate>myEndDate))  do
	.set myPRTRowID=0
	.for  set myPRTRowID=$o(^DHCINVPRT(0,"Date",myDate,myPRTRowID)) quit:(myPRTRowID="")  do
	..set myPRTData=$g(^DHCINVPRT(myPRTRowID))
	..set myHospDR=$p(myPRTData,"^",39)
	..quit:((hospId'="")&&(hospId'=myHospDR))
	..set myTime=$p(myPRTData,"^",20)
	..quit:((+myDate=+myBDate)&&(myTime<myBTime))
	..quit:((+myDate=+myEndDate)&&(myTime>=myEndTime))
	..set myYBPayAmt=$p(myPRTData,"^",31)
	..set myYBPaySum=$i(myYBPaySum, myYBPayAmt)
	..set myRoundErr=$p(myPRTData,"^",37)
	..set myRoundSum=$i(myRoundSum, myRoundErr)		//PRT_OPCRoundErr
	..set myPMSub=0
	..for  set myPMSub=$o(^DHCINVPRT(myPRTRowID,"P",myPMSub)) quit:(myPMSub="")  do
	...set myPMData=$g(^DHCINVPRT(myPRTRowID,"P",myPMSub))
	...set myPMDR=$p(myPMData,"^",1)
	...quit:(myPMDR="")
	...set myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	...quit:(myPMCode="CPP")			//卡支付退出
	...set myPMAmt=$p(myPMData,"^",3)
	...set myNoCardPaySum=$i(myNoCardPaySum, myPMAmt)
	
	set myDate=myBDate-1
	for  set myDate=$o(^DHCINVPRTAPi(0,"Date",myDate)) quit:((myDate="")||(myDate>myEndDate))  do
	.set myAPIRowID=0
	.for  set myAPIRowID=$o(^DHCINVPRTAPi(0,"Date",myDate,myAPIRowID)) quit:(myAPIRowID="")  do
	..set myAPIData=$g(^DHCINVPRTAP(myAPIRowID))
	..set myHospDR=$p(myAPIData,"^",30)
	..quit:((hospId'="")&&(hospId'=myHospDR))
	..set myTime=$p(myAPIData,"^",4)
	..quit:((+myDate=+myBDate)&&(myTime<myBTime))
	..quit:((+myDate=+myEndDate)&&(myTime>=myEndTime))
	..set mySelfYBPay=$p(myAPIData,"^",17)		//API_SelfYBPay
	..set myYBPaySum=$i(myYBPaySum, mySelfYBPay)
	
	set myRoundSum=$fn(myRoundSum,"",2)
	set myAPSum=$fn(myAPSum,"",2)
	set myPreLeftSum=$fn(myPreLeftSum,"",2)
	
	set myPreSum=$fn(myPreSum,"",2)
	set myRefundPreSum=$fn(myRefundPreSum,"",2)
	
	set myLeftSum=myPreLeftSum+myPreSum+myRefundPreSum-myAPSum
	set myLeftSum=$fn(myLeftSum,"",2)
	set myAPPRTSum=$fn(myAPPRTSum,"",2)
	set myAPNoPRTSum=$fn(myAPNoPRTSum,"",2)
	set myNoCardPaySum=$fn(myNoCardPaySum,"",2)
	set myYBPaySum=$fn(myYBPaySum,"",2)
	
	set myBDate=##class(websys.Conversions).DateLogicalToHtml(myBDate)
	set myBTime=##class(websys.Conversions).TimeLogicalToHtml(myBTime, 1)
	set myEndDate=##class(websys.Conversions).DateLogicalToHtml(myEndDate)
	set myEndTime=##class(websys.Conversions).TimeLogicalToHtml(myEndTime, 1)
	
	set rtn=(myCount=0)
	
	set myAccInfo=myBDate_"^"_myBTime_"^"_myEndDate_"^"_myEndTime
	set myAccInfo=myAccInfo_"^"_myPreLeftSum_"^"_myPreSum_"^"_myRefundPreSum
	set myAccInfo=myAccInfo_"^"_myAPSum_"^"_myLeftSum_"^"_myAPPRTSum_"^"_myAPNoPRTSum
	set myAccInfo=myAccInfo_"^"_myHSDate_"^"_myRoundSum_"^"_myNoCardPaySum_"^"_myYBPaySum

	quit rtn_$c(3)_myAccInfo
}

/// 更新DHC_INVPRT
/// 最好写DHC_INVPRTReports
/// 写DHC_AccFoot
/// 汇总个人的帐户信息(在这段时间内发生费用的账户)
/// 在这之前结算的帐户不计算在内
/// Debug: w ##class(web.UDHCACFinBRFoot0PD).ACFinDataFoot("^^09/06/2006^16:15:44^23331^09/06/2006^16:14:27^2688456.77^377761.00^0.00^3040144.77^-26073.00")
ClassMethod ACFinDataFoot(ACFInfo As %String, ExpStr As %String) As %String
{
	set $zt="ERROR"
	
	set ^TMP("ACFinDataFoot")=$lb(ACFInfo, ExpStr)
	
	do ..KillTMP()
	
	set rtn=0
	
	set EndDate=$p(ACFInfo,"^",3)		    //AccPF_Date
	set EndTime=$p(ACFInfo,"^",4)		    //AccPF_Time
	set FootUserDR=$p(ACFInfo,"^",5)		//AccPF_User_DR
	set BDate=$p(ACFInfo,"^",6)			    //AccPF_LastDate
	set BTime=$p(ACFInfo,"^",7)			    //AccPF_LastTime
	set PreLeftSum=$p(ACFInfo,"^",8)		//AccPF_PreLeftSum 上期余额
	set PreSum=$p(ACFInfo,"^",9)            //AccPF_PreSum 收预交金
	set CardPaySum=$p(ACFInfo,"^",10)       //AccPF_CardPaySum
	set LeftSum=$p(ACFInfo,"^",11)          //AccPF_LeftSum  期末余额
	set RefundPreSum=$p(ACFInfo,"^",12)     //AccPF_RefundPreSum  退预交金
	set AccPayINVSum=$p(ACFInfo,"^",13)     //AccPF_AccPayINVSum
	set AccDepPaySum=$p(ACFInfo,"^",14)     //AccPF_AccDepPaySum
	set HSDate=$p(ACFInfo,"^",18)           //AccPF_HSDate
	set RoundSum=$p(ACFInfo,"^",19)         //AccPF_RoundSum
	set PaySumByNoCard=$p(ACFInfo,"^",20)   //AccPF_PaySumByNoCard
	set YBPaySum=$p(ACFInfo,"^",21)         //AccPF_YBPaySum
	set HospId=$p(ACFInfo,"^",22)			//AccPF_Hospital_DR
	
	set BDate=##class(websys.Conversions).DateHtmlToLogical(BDate)
	set BTime=##class(websys.Conversions).TimeHtmlToLogical(BTime, 1)

	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	set EndTime=##class(websys.Conversions).TimeHtmlToLogical(EndTime, 1)
	
	//必须预先生成^TMP  否则报错
	do ..ReadFBRAccPreLeft()
	do ##class(web.UDHCACFinBRFootIF).ReadFBRAccPayList(BDate, BTime, EndDate, EndTime, HospId)
	do ##class(web.UDHCACFinBRFootIF).ReadFBRAccPreDList(BDate, BTime, EndDate, EndTime, HospId)
	
	set myQFInfo=..BulidAccQFList()
	set QFCurSum=$p(myQFInfo,"^",1)     //AccPF_CurQFSum
	set myQFLeftSum=$p(myQFInfo,"^",2)  //AccPF_CurLeftQFSum
	
	ts

	&SQL(
		INSERT INTO DHC_AccPFoot (
			AccPF_Date, AccPF_Time, AccPF_User_DR, AccPF_LastDate, AccPF_LastTime,
			AccPF_PreLeftSum, AccPF_PreSum, AccPF_CardPaySum, AccPF_LeftSum, AccPF_RefundPreSum,
			AccPF_AccPayINVSum, AccPF_AccDepPaySum, AccPF_CurQFSum, AccPF_CurLeftQFSum, AccPF_HSDate,
			AccPF_RoundSum, AccPF_PaySumByNoCard, AccPF_YBPaySum, AccPF_Hospital_DR
		)
		VALUES (
			:EndDate, :EndTime, :FootUserDR, :BDate, :BTime,
			:PreLeftSum, :PreSum, :CardPaySum, :LeftSum, :RefundPreSum,
			:AccPayINVSum, :AccDepPaySum, :QFCurSum, :myQFLeftSum, :HSDate,
			:RoundSum, :PaySumByNoCard, :YBPaySum, :HospId
		)
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	set myPFParRef=$g(%ROWID)
	
	//保存到FootSub中
	//先生成TMP，然后保存
	//+2017-05-31 ZhYW 是否做明细账走配置
	set detailsSaveFlag=##class(web.DHCBillParamConfig).%GetParameter("DetailsSaveFlag")
	if (+detailsSaveFlag=1) {
		set myAccRowID=0
		while($o(^TMPAcc($j,myAccRowID))) {
			set myAccRowID=$o(^TMPAcc($j,myAccRowID))
			set myPreLeftSum=+$g(^TMPAcc($j,myAccRowID,"PLeft"))
			set myPreSum=+$g(^TMPAcc($j,myAccRowID,"GPD"))
			set myRefPreSum=+$g(^TMPAcc($j,myAccRowID,"RPD"))
			set myCPSum=+$g(^TMPAcc($j,myAccRowID,"CP"))
			set myCurLeftSum=myPreLeftSum+myPreSum+myRefPreSum-myCPSum	    //+$g(^TMPAcc($j,myAccRowID))
			set myQFLeftSum=+$g(^TMPAcc($j,myAccRowID,"QFLeft"))
			set myQFSum=+$g(^TMPAcc($j,myAccRowID,"QFSum"))
			set myRoundSum=+$g(^TMPAcc($j,myAccRowID,"ROUND"))
			&SQL(
				INSERT INTO DHC_AccPFootSub (
					AccPFS_ParRef, AccPFS_AccM_DR, AccPFS_PreLeft, AccPFS_CardPay, AccPFS_CurLeft,
					AccPFS_RefundPrePay, AccPFS_PrePay, AccPFS_CurQFSum, AccPFS_Note4
				)
				VALUES (
					:myPFParRef, :myAccRowID, :myPreLeftSum, :myCPSum, :myCurLeftSum,
					:myRefPreSum, :myPreSum, :myQFSum, :myRoundSum
				)
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	do ..KillTMP()
	
	quit rtn_"^"_myPFParRef

ERROR
	quit ..AppException()
}

/// 利用前面生成的记录，生成账户的欠费TMP
/// ^TMPAcc($j,myAccRowID,"CP")
ClassMethod BulidAccQFList(ExpStr As %String = "") As %String
{
	set myQFLeftSum=0
	set myQFCurSum=0
	set myAccRowID=0
	for  set myAccRowID=$o(^TMPAcc($j,myAccRowID)) quit:(myAccRowID="")  do
	.set myPreLeftSum=+$g(^TMPAcc($j,myAccRowID,"PLeft"))
	.set myPreSum=+$g(^TMPAcc($j,myAccRowID,"GPD"))
	.set myRefPreSum=+$g(^TMPAcc($j,myAccRowID,"RPD"))
	.set myCPSum=+$g(^TMPAcc($j,myAccRowID,"CP"))
	.set myCurLeftSum=myPreLeftSum+myPreSum+myRefPreSum-myCPSum	  //+$g(^TMPAcc($j,myAccRowID))
	.if (+myCurLeftSum<0) do
	..//欠费余额
	..set ^TMPAcc($j,myAccRowID,"QFLeft")=myCurLeftSum
	..set myQFLeftSum=$i(myQFLeftSum, myCurLeftSum)
	..//当前的发生额中欠费额
	..quit:(+myCPSum=0)		//没有发生额
	..set ^TMPAcc($j,myAccRowID,"QFSum")=$s((+myCPSum>+myCurLeftSum):myCurLeftSum,1:myCPSum)
	..set myQFCurSum=myQFCurSum+$g(^TMPAcc($j,myAccRowID,"QFSum"))
	
	quit myQFCurSum_"^"_myQFLeftSum
}

ClassMethod KillTMP() As %String
{
	kill ^TMPAcc($j)
}

/// 用户的消费额, 期间数据发生额
/// Table: DHC_AccPayList
ClassMethod ReadFBRAccPayList(BDate As %String, BTime As %String, EndDate As %String, EndTime As %String, HospId As %String) As %String
{
	set myDate=BDate-1
	for  set myDate=$o(^DHCACDi("AccM",0,"PayDate",myDate)) quit:((myDate="")||(+myDate>+EndDate))  do
	.set myAccRowID=0
	.for  set myAccRowID=$o(^DHCACDi("AccM",0,"PayDate",myDate,myAccRowID)) quit:(myAccRowID="")  do
	..set mySub=0
	..for  set mySub=$o(^DHCACDi("AccM",0,"PayDate",myDate,myAccRowID,"AccPL",mySub)) quit:(mySub="")  do
	...set myPLData=$g(^DHCACD("AccM",myAccRowID,"AccPL",mySub))
	...quit:(myPLData="")
	...set myHospDR=$p(myPLData,"^",16)
	...quit:((HospId'="")&&(HospId'=myHospDR))
	...set myTime=$p(myPLData,"^",7)
	...quit:((myDate=BDate)&&(myTime<BTime))
	...quit:((myDate=EndDate)&&(myTime>=EndTime))
	...set myPayAmt=$p(myPLData,"^",8)
	...set ^TMPAcc($j,myAccRowID,"CP")=$g(^TMPAcc($j,myAccRowID,"CP"))+myPayAmt
	
	quit 0
}

Query ReadFBRAccFoot(BDate As %String, BTime As %String, EndDate As %String, EndTime As %String, HospId As %String) As websys.Query(ROWSPEC = "No:%String,AccRID:%String,PAPMINo:%String,PAName:%String,CADateT:%String,PreLeftSum:%String,PreSum:%String,RefPreSum:%String,CPSum:%String,CurLeftSum:%String,AccStatus:%String")
{
}

ClassMethod ReadFBRAccFootExecute(ByRef qHandle As %Binary, BDate As %String, BTime As %String, EndDate As %String, EndTime As %String, HospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	do ..KillTMP()
	set BDate=##class(websys.Conversions).DateHtmlToLogical(BDate)
	set BTime=##class(websys.Conversions).TimeHtmlToLogical(BTime, 1)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	set EndTime=##class(websys.Conversions).TimeHtmlToLogical(EndTime, 1)
	
	set:(BDate="") BDate=+$h
	set:(BTime="") BTime=$p($h,",",2)
	set:(EndDate="") EndDate=+$h
	set:(EndTime="") EndTime=$p($h,",",2)
	
	do ..ReadFBRAccPreLeft()
	do ##class(web.UDHCACFinBRFootIF).ReadFBRAccPayList(BDate, BTime, EndDate, EndTime, HospId)
	do ##class(web.UDHCACFinBRFootIF).ReadFBRAccPreDList(BDate, BTime, EndDate, EndTime, HospId)
	do ..BulidAccQFList()
	
	set PreLeftTSum=0
	set PreTSum=0
	set RefPreTSum=0
	set CPTSum=0
	set CurLeftTSum=0
	
	set myIdx=0
	set myAccRowID=0
	for  set myAccRowID=$o(^TMPAcc($j,myAccRowID)) quit:(myAccRowID="")  do
	.set myIdx=$i(myIdx)
	.set myAccRID=myAccRowID
	.set myPAPMINo=$p(^DHCACD("AccM",myAccRowID),"^",3)
	.set myPAPMDR=$p(^DHCACD("AccM",myAccRowID),"^",2)
	.set myPAName=$p($g(^PAPER(myPAPMDR,"ALL")),"^",1)
	.set myCADate=$p(^DHCACD("AccM",myAccRowID),"^",5)
	.set myCADate=##class(websys.Conversions).DateLogicalToHtml(myCADate)
	.set myCATime=$p(^DHCACD("AccM",myAccRowID),"^",6)
	.set myCATime=##class(websys.Conversions).TimeLogicalToHtml(EndTime, 1)
	.set myCADateT=myCADate_" "_myCATime
	.set myPreLeftSum=+$g(^TMPAcc($j,myAccRowID,"PLeft"))
	.set PreLeftTSum=$i(PreLeftTSum, myPreLeftSum)
	.set myPreSum=+$g(^TMPAcc($j,myAccRowID,"GPD"))
	.set PreTSum=$i(PreTSum, myPreSum)
	.set myRefPreSum=+$g(^TMPAcc($j,myAccRowID,"RPD"))
	.set RefPreTSum=$i(RefPreTSum, myRefPreSum)
	.set myCPSum=+$g(^TMPAcc($j,myAccRowID,"CP"))
	.set CPTSum=$i(CPTSum, myCPSum)
	.set myCurLeftSum=myPreLeftSum+myPreSum+myRefPreSum-myCPSum	//+$g(^TMPAcc($j,myAccRowID))
	.set CurLeftTSum=$i(CurLeftTSum, myCurLeftSum)
	.set myAccSCode=$p(^DHCACD("AccM",myAccRowID),"^",13)
	.set myAccStatus=$case(myAccSCode,"N":"正常","F":"结算","S":"挂起",:"")
	.set No=myIdx
	.do OutputFR
	
	//合计
	do ResetVariablesFR
	set No="合计"
	set myPreLeftSum=$fn(PreLeftTSum,"",2)
	set myPreSum=$fn(PreTSum,"",2)
	set myRefPreSum=$fn(RefPreTSum,"",2)
	set myCPSum=$fn(CPTSum,"",2)
	set myCurLeftSum=$fn(CurLeftTSum,"",2)
	
	do OutputFR

	do ..KillTMP()
	
	quit $$$OK
ResetVariablesFR
	set (No,myAccRID,myPAPMINo,myPAName,myCADateT,myPreLeftSum,myPreSum,myRefPreSum,myCPSum,myCurLeftSum,myAccStatus)=""
	quit
OutputFR
	set Data=$lb(No,myAccRID,myPAPMINo,myPAName,myCADateT,myPreLeftSum,myPreSum,myRefPreSum,myCPSum,myCurLeftSum,myAccStatus)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Description: 操作员上缴额的财务结算预交金，期间数据发生额
/// Debug: w ##class(web.UDHCACFinBRFoot0PD).ReadFBRAccPreDList(60329, 57970, 60410, 79366, 2)
ClassMethod ReadFBRAccPreDList(BDate As %String, BTime As %String, EndDate As %String, EndTime As %String, HospId As %String) As %String
{
	for myDate=BDate:1:EndDate do
	.set myAccRowID=0
	.for  set myAccRowID=$o(^DHCACDi("AccM",0,"APDDate",myDate,myAccRowID)) quit:(myAccRowID="")  do
	..set mySub=0
	..for  set mySub=$o(^DHCACDi("AccM",0,"APDDate",myDate,myAccRowID,"AccPD",mySub)) quit:(mySub="")  do
	...set myPDData=$g(^DHCACD("AccM",myAccRowID,"AccPD",mySub))
	...quit:(myPDData="")
	...set myHospDR=$p(myPDData,"^",15)
	...quit:((HospId'="")&&(HospId'=myHospDR))
	...set myTime=$p(myPDData,"^",4)
	...quit:((+myDate=+BDate)&&(myTime<BTime))
	...quit:((+myDate=+EndDate)&&(myTime>=EndTime))
	...set myPreAmt=$p(myPDData,"^",2)
	...if (+myPreAmt>0) do
	....set ^TMPAcc($j,myAccRowID,"GPD")=$g(^TMPAcc($j,myAccRowID,"GPD"))+myPreAmt
	...else  do
	....set ^TMPAcc($j,myAccRowID,"RPD")=$g(^TMPAcc($j,myAccRowID,"RPD"))+myPreAmt
	
	quit 0
}

/// Description: 读取预交金的前期余额
/// Debug: w ##class(web.UDHCACFinBRFoot0PD).ReadFBRAccPreLeft()
ClassMethod ReadFBRAccPreLeft() As %String
{
	set myMRowID=$o(^DHCACD("AccPF",""),-1)
	set myPFDate=$o(^DHCACDi("AccPF",0,"CurDateT",""),-1)
	quit:(myPFDate="") 0
	set myMRowID=$o(^DHCACDi("AccPF",0,"CurDateT",myPFDate,""),-1)
	quit:(myMRowID="") 0

	set mySub=0
	for  set mySub=$o(^DHCACD("AccPF",myMRowID,"PF",mySub)) quit:(mySub="")  do
	.set mySubData=$g(^DHCACD("AccPF",myMRowID,"PF",mySub))
	.quit:(mySubData="")
	.set myAccRowID=$p(mySubData,"^",1)
	.set myCurLeft=+$p(mySubData,"^",5)
	.quit:(+myCurLeft=0)
	.set ^TMPAcc($j,myAccRowID,"PLeft")=+myCurLeft
	
	quit 0
}

/// Description: 取上期余额
ClassMethod GetPreLeftNew(RowID, predate)
{
	set file="c:\account.txt"
	;b ;o file:("NRW"):5
	;b ;2
	;;u file
	;b ;3
	set upleftsum=0, ind=0
	set predate=$zdh(predate,3)
	set accmrowid=0, sdepsum=0, tdepsum=0, allpaylistsum=0
	for  set accmrowid=$o(^DHCACD("AccM",accmrowid)) quit:(accmrowid="")!($g(accmrowid)>=256110)  do
	.set papmi=$p(^DHCACD("AccM",accmrowid),"^",2)
	.set papminame=$p(^PAPER(papmi,"ALL"),"^",1)
	.set papmino=$p(^PAPER(papmi,"PAT",1),"^",1)
	.;set cardno=$p(^DHCACD("AccM",accmrowid),"^",4)
	.set cardref=$o(^DHCCARDi("CF",0,"AccNoDR",accmrowid,""),-1)
	.if cardref'="" do
	..set cardno=$p(^DHCCARD("CF",cardref),"^",2)

	.set predsub=0, predepositsum=0, paylistsum=0, sdep=0, tdep=0
	.;w !,accmrowid
	.for  set predsub=$o(^DHCACD("AccM",accmrowid,"AccPD",predsub)) quit:(predsub="")  do
	..if $d(^DHCACD("AccM",accmrowid,"AccPD",predsub))=10 do
	...w !,accmrowid
	..quit:$d(^DHCACD("AccM",accmrowid,"AccPD",predsub))=10
	..quit:predsub=0
	..set preddate=$p(^DHCACD("AccM",accmrowid,"AccPD",predsub),"^",3)
	..quit:(preddate>=predate)
	..set predtime=$p(^DHCACD("AccM",accmrowid,"AccPD",predsub),"^",4)
	..set predsum=$p(^DHCACD("AccM",accmrowid,"AccPD",predsub),"^",8)  ;预交金余额
	..set predep=$p(^DHCACD("AccM",accmrowid,"AccPD",predsub),"^",2)
	..if (+predep>0) do
	...set sdep=sdep+predep
	...set sdepsum=+sdepsum+predep
	..else  do
	...set tdep=tdep+predep
	...set tdepsum=+tdepsum+predep
	..set predepositsum=predepositsum+predep
	.set paysub=0
	.for  set paysub=$o(^DHCACD("AccM",accmrowid,"AccPL",paysub)) quit:(paysub="")  do
	..set paydate=$p(^DHCACD("AccM",accmrowid,"AccPL",paysub),"^",6)
	..quit:paydate>=predate
	..set paylist=$p(^DHCACD("AccM",accmrowid,"AccPL",paysub),"^",8)
	..set paytime=$p(^DHCACD("AccM",accmrowid,"AccPL",paysub),"^",7)
	..set payleft=$p(^DHCACD("AccM",accmrowid,"AccPL",paysub),"^",9)
	..set paylistsum=paylistsum+paylist
	..set allpaylistsum=+allpaylistsum+paylist
	.;比较取余额
	.set upleft=predepositsum-paylistsum
	.quit:(+upleft=0)
	.set ind=$i(ind)
	.w !,ind_"^"_accmrowid_"^"_cardno_"^"_papminame_"^"_papmino_"^"_upleft
	.set ^TMPudhcacd("UDHCACF",+$h,ind)=accmrowid_"^"_cardno_"^"_papminame_"^"_papmino_"^"_upleft
	.;if (saveleft'=upleft) do ;&(+saveleft>0)
	..;w !,accmrowid_"^"_saveleft_"^"_upleft
	.set upleftsum=upleftsum+upleft
	.if $d(^DHCACDi(0,"AccPF",0,"AccMDR",accmrowid)) do
	..set pfparref=$O(^DHCACDi(0,"AccPF",0,"AccMDR",accmrowid,""))
	..set sub=$O(^DHCACDi(0,"AccPF",0,"AccMDR",accmrowid,pfparref,""))
	..set pfrowid=pfparref_"^"_sub
	;c file
	w !
	quit upleftsum  ;_"^"_sdepsum_"^"_tdepsum_"^"_allpaylistsum
}

}
