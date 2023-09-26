/// 存放账户汇总级别的查询
Class web.UDHCACFinBRRSQuery Extends %RegisteredObject
{

/// w ##class(web.UDHCACFinBRRSQuery).ReadACDFootData()
ClassMethod ReadACDFootData(PFRowID As %String) As %String
{
	set myStr=""
	quit:(PFRowID="") 0_$c(3)_"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
	
	quit:('$d(^DHCACD("AccPF",PFRowID))) 0_$c(3)_"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"

	set myPFBLastDate=$p(^DHCACD("AccPF",PFRowID),"^",4)
	set myPFBLastTime=$p(^DHCACD("AccPF",PFRowID),"^",5)
	set myPFBCurrentDate=$p(^DHCACD("AccPF",PFRowID),"^",1)
	set myPFBCurrentTime=$p(^DHCACD("AccPF",PFRowID),"^",2)
	set myLastPDLeft=$p(^DHCACD("AccPF",PFRowID),"^",6)
	set myPDIncomeSum=$p(^DHCACD("AccPF",PFRowID),"^",7)
	set myPDReturnSum=$p(^DHCACD("AccPF",PFRowID),"^",10)
	set myAccPaySum=$p(^DHCACD("AccPF",PFRowID),"^",8)
	set myPDLeft=$p(^DHCACD("AccPF",PFRowID),"^",9)

	set myPFBLastDate=##class(websys.Conversions).DateLogicalToHtml(myPFBLastDate)
	set myPFBLastTime=##class(websys.Conversions).TimeLogicalToHtml(myPFBLastTime)
	set myPFBCurrentDate=##class(websys.Conversions).DateLogicalToHtml(myPFBCurrentDate)
	set myPFBCurrentTime=##class(websys.Conversions).TimeLogicalToHtml(myPFBCurrentTime)
	
	set myStr=myPFBLastDate_"^"_myPFBLastTime_"^"_myPFBCurrentDate_"^"_myPFBCurrentTime
	set myStr=myStr_"^"_$fn(myLastPDLeft,"",2)_"^"_$fn(myPDIncomeSum,"",2)_"^"_$fn(myPDReturnSum,"",2)
	set myStr=myStr_"^"_$fn(myAccPaySum,"",2)_"^"_$fn(myPDLeft,"",2)
	
	quit 0_$c(3)_myStr
}

/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCACFinBRRSQuery","ReadPFootList","","2021-12-14","2021-12-14",2)
Query ReadPFootList(StDate As %String, EndDate As %String, HospId As %String, LangId As %String = "") As websys.Query(ROWSPEC = "TBDate:%String:开始日期,TBTime:%String:开始时间,TEDate:%String:结束日期,TETime:%String:结束时间,UserName:%String:汇总人员,PreLeftSum:%Float:前期余额,PreSum:%Float:收预交金额,RefundPreSum:%Float:退预交金额,CardPaySum:%Float:卡支付额,LeftSum:%Float:当前余额,PFRowID:%String:结算ID")
{
}

ClassMethod ReadPFootListExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, HospId As %String, LangId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("ReadPFootList")=$lb(StDate, EndDate, HospId, LangId)
	
	if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	if ((StDate="")||(EndDate=""))  quit $$$OK

	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	for myDate=StDate:1:EndDate {
		set myPFRowID=0
		while($o(^DHCACDi("AccPF",0,"CurDateT",myDate,myPFRowID))) {
			set myPFRowID=$o(^DHCACDi("AccPF",0,"CurDateT",myDate,myPFRowID))
			set myPFData=$g(^DHCACD("AccPF",myPFRowID))
			continue:(myPFData="")
			set myEndDate=$p(myPFData,"^",1)				//AccPF_Date
			set myEndDate=##class(websys.Conversions).DateLogicalToHtml(myEndDate)
			set myEndTime=$p(myPFData,"^",2)				//AccPF_Time
			set myEndTime=##class(websys.Conversions).TimeLogicalToHtml(myEndTime)
			set myUserDR=$p(myPFData,"^",3)				   //AccPF_User_DR
			set myUserName=$p($g(^SSU("SSUSR",myUserDR)),"^",2)
			set myUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", myUserName, LangId)
			set myHospDR=$p(myPFData,"^",20)				//AccPFHospitalDR
			continue:((HospId'="")&&(myHospDR'=HospId))
			set myBDate=$p(myPFData,"^",4)				    //AccPF_LastDate
			set myBDate=##class(websys.Conversions).DateLogicalToHtml(myBDate)
			set myBTime=$p(myPFData,"^",5)				   //AccPF_LastTime
			set myBTime=##class(websys.Conversions).TimeLogicalToHtml(myBTime)
			set myPreLeftSum=$p(myPFData,"^",6)			//AccPF_PreLeftSum
			set myPreSum=$p(myPFData,"^",7)				//AccPF_PreSum
			set myCardPaySum=$p(myPFData,"^",8)			//AccPF_CardPaySum
			set myLeftSum=$p(myPFData,"^",9)			//AccPF_LeftSum
			set myRefundPreSum=$p(myPFData,"^",10)		//AccPF_RefundPreSum
			set myPreLeftSum=$fn(myPreLeftSum,"",2)
			set myPreSum=$fn(myPreSum,"",2)
			set myRefundPreSum=$fn(myRefundPreSum,"",2)
			set myCardPaySum=$fn(myCardPaySum,"",2)
			set myLeftSum=$fn(myLeftSum,"",2)
			do OutputFR
		}
	}
	
	quit $$$OK
OutputFR
	set Data=$lb(myBDate,myBTime,myEndDate,myEndTime,myUserName,myPreLeftSum,myPreSum,myRefundPreSum,myCardPaySum,myLeftSum,myPFRowID)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCACFinBRRSQuery","FootDeposit","589","2021-10-30","2021-11-02")
Query FootDeposit(PFRowID As %String, StDate As %String, EndDate As %String, LangId As %String = "") As websys.Query(ROWSPEC = "TCashierCode:%String:收费员代码,TCashierName:%String:收费员,TPayMode:%String:支付方式,TPayNum:%String:收预交金张数,TPayAmount:%Float:收预交金金额,TRefundNum:%String:退预交金张数,TRefundAmount:%Float:退预交金金额,TNo:%String:序号,TTotalAmount:%String:合计,StTime:%String:开始时间,EndTime:%String:结束时间")
{
}

ClassMethod FootDepositExecute(ByRef qHandle As %Binary, PFRowID As %String, StDate As %String, EndDate As %String, LangId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FootDeposit")=$lb(PFRowID, StDate, EndDate)
	
	if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	kill ^||TMP("DHCOPFD",$j)
	kill ^||TMP("DHCOPFDPM",$j)
	
	set StTime=""
	set EndTime=""

	if (PFRowID="") {
		for myDate=StDate:1:EndDate {
			set myPFRowID=0
			while($o(^DHCACDi("AccPF",0,"CurDateT",myDate,myPFRowID))) {
				set myPFRowID=$o(^DHCACDi("AccPF",0,"CurDateT",myDate,myPFRowID))
				do GetFootDeposit
			}
		}
	}else {
		set myPFRowID=PFRowID
		do GetFootDeposit
	}
	
	set (PayNumSum, PayAmountSum, RefundNumSum, RefundAmountSum)=0
	set myUserNum=0
	set myUserID=""
	for  set myUserID=$o(^||TMP("DHCOPFD",$j,myUserID)) quit:(myUserID="")  do
	.set CashierCode=$p($g(^SSU("SSUSR",myUserID)),"^",1)
	.set CashierName=$p($g(^SSU("SSUSR",myUserID)),"^",2)
	.set CashierName=##class(User.SSUser).GetTranByDesc("SSUSRName", CashierName, LangId)
	.set myUserNum=$i(myUserNum)
	.set myPM=""
	.for  set myPM=$o(^||TMP("DHCOPFD",$j,myUserID,"PM",myPM)) quit:(myPM="")  do
	..if (myPM=0) do
	...set PayMode=##class(websys.Translation).Get("", "全部", LangId)
	...set PayNumSum=+$g(^||TMP("DHCOPFD",$j,myUserID,"PM",myPM,"PayNum"))+PayNumSum
	...set PayAmountSum=+$g(^||TMP("DHCOPFD",$j,myUserID,"PM",myPM,"PayAmt"))+PayAmountSum
	...set RefundNumSum=+$g(^||TMP("DHCOPFD",$j,myUserID,"PM",myPM,"RefNum"))+RefundNumSum
	...set RefundAmountSum=+$g(^||TMP("DHCOPFD",$j,myUserID,"PM",myPM,"RefAmt"))+RefundAmountSum
	...set No=myUserNum
	..else  do
	...set PayMode=$p($g(^CT("CTPM",myPM)),"^",2)
	...set PayMode=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", PayMode, LangId)
	...set CashierCode=""
	...set CashierName=##class(websys.Translation).Get("", "其中", LangId)
	...set No=""
	..set PayNum=+$g(^||TMP("DHCOPFD",$j,myUserID,"PM",myPM,"PayNum"))
	..set PayAmount=+$g(^||TMP("DHCOPFD",$j,myUserID,"PM",myPM,"PayAmt"))
	..set RefundNum=+$g(^||TMP("DHCOPFD",$j,myUserID,"PM",myPM,"RefNum"))
	..set RefundAmount=+$g(^||TMP("DHCOPFD",$j,myUserID,"PM",myPM,"RefAmt"))
	..set TotalAmount=PayAmount+RefundAmount
	..do OutputFootDeposit
	
	if (myUserNum>1) do
	.set CashierCode=##class(websys.Translation).Get("", "合计", LangId)
	.set CashierName=##class(websys.Translation).Get("", "全部", LangId)
	.set PayMode=##class(websys.Translation).Get("", "全部", LangId)
	.set PayNum=PayNumSum
	.set PayAmount=PayAmountSum
	.set RefundNum=RefundNumSum
	.set RefundAmount=RefundAmountSum
	.set No=""
	.set TotalAmount=$i(PayAmount,RefundAmount)
	.do OutputFootDeposit
	.set myPM=""
	.for  set myPM=$o(^||TMP("DHCOPFDPM",$j,myPM)) quit:(myPM="")  do
	..set PayMode=$p($g(^CT("CTPM",myPM)),"^",2)
	..set PayMode=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", PayMode, LangId)
	..set CashierCode=""
	..set CashierName=##class(websys.Translation).Get("", "其中", LangId)
	..set PayNum=+$g(^||TMP("DHCOPFDPM",$j,myPM,"PayNum"))
	..set PayAmount=+$g(^||TMP("DHCOPFDPM",$j,myPM,"PayAmt"))
	..set RefundNum=+$g(^||TMP("DHCOPFDPM",$j,myPM,"RefNum"))
	..set RefundAmount=+$g(^||TMP("DHCOPFDPM",$j,myPM,"RefAmt"))
	..set TotalAmount=$i(PayAmount,RefundAmount)
	..do OutputFootDeposit
	
	kill ^||TMP("DHCOPFD",$j)
	kill ^||TMP("DHCOPFDPM",$j)
	
	quit $$$OK
	
GetFootDeposit
	quit:(myPFRowID="")
	set myFootDate=$p($g(^DHCACD("AccPF",myPFRowID)),"^",1)
	set myFootTime=$p($g(^DHCACD("AccPF",myPFRowID)),"^",2)
	set myFootLastDate=$p($g(^DHCACD("AccPF",myPFRowID)),"^",4)
	set myFootLastTime=$p($g(^DHCACD("AccPF",myPFRowID)),"^",5)
	set StTime=##class(websys.Conversions).TimeLogicalToHtml(myFootLastTime)
	set EndTime=##class(websys.Conversions).TimeLogicalToHtml(myFootTime)
	set myPreDate=myFootLastDate-1
	for  set myPreDate=$o(^DHCACDi("AccM",0,"APDDate",myPreDate)) quit:((myPreDate="")||(myPreDate>myFootDate))  do
	.set myAccID=0
	.for  set myAccID=$o(^DHCACDi("AccM",0,"APDDate",myPreDate,myAccID)) quit:(myAccID="")  do
	..set myPDSub=0
	..for  set myPDSub=$o(^DHCACDi("AccM",0,"APDDate",myPreDate,myAccID,"AccPD",myPDSub)) quit:(myPDSub="")  do
	...set myPDVal=$g(^DHCACD("AccM",myAccID,"AccPD",myPDSub))
	...set myPreTime=$p(myPDVal,"^",4)
	...quit:((myPreDate=myFootLastDate)&&(myPreTime<myFootLastTime))
	...quit:((myPreDate=myFootDate)&&(myPreTime>myFootTime))
	...set myPayAmt=+$p(myPDVal,"^",2)
	...quit:(+myPayAmt=0)
	...set myUserID=$p(myPDVal,"^",5)
	...set myPMSub=$o(^DHCACD("AccM",myAccID,"AccPD",myPDSub,"P",0))
	...set myPayMDR=$p($g(^DHCACD("AccM",myAccID,"AccPD",myPDSub,"P",myPMSub)),"^",1)
	...if (myPayAmt>0) do
	....set ^||TMP("DHCOPFD",$j,myUserID,"PM",0,"PayNum")=$i(^||TMP("DHCOPFD",$j,myUserID,"PM",0,"PayNum"))
	....set ^||TMP("DHCOPFD",$j,myUserID,"PM",0,"PayAmt")=$i(^||TMP("DHCOPFD",$j,myUserID,"PM",0,"PayAmt"), myPayAmt)
	....set ^||TMP("DHCOPFD",$j,myUserID,"PM",myPayMDR,"PayNum")=$i(^||TMP("DHCOPFD",$j,myUserID,"PM",myPayMDR,"PayNum"))
	....set ^||TMP("DHCOPFD",$j,myUserID,"PM",myPayMDR,"PayAmt")=$i(^||TMP("DHCOPFD",$j,myUserID,"PM",myPayMDR,"PayAmt"), myPayAmt)
	....set ^||TMP("DHCOPFDPM",$j,myPayMDR,"PayNum")=$i(^||TMP("DHCOPFDPM",$j,myPayMDR,"PayNum"))
	....set ^||TMP("DHCOPFDPM",$j,myPayMDR,"PayAmt")=$i(^||TMP("DHCOPFDPM",$j,myPayMDR,"PayAmt"), myPayAmt)
	...else  do
	....set ^||TMP("DHCOPFD",$j,myUserID,"PM",0,"RefNum")=$i(^||TMP("DHCOPFD",$j,myUserID,"PM",0,"RefNum"))
	....set ^||TMP("DHCOPFD",$j,myUserID,"PM",0,"RefAmt")=$i(^||TMP("DHCOPFD",$j,myUserID,"PM",0,"RefAmt"), myPayAmt)
	....set ^||TMP("DHCOPFD",$j,myUserID,"PM",myPayMDR,"RefNum")=$i(^||TMP("DHCOPFD",$j,myUserID,"PM",myPayMDR,"RefNum"))
	....set ^||TMP("DHCOPFD",$j,myUserID,"PM",myPayMDR,"RefAmt")=$i(^||TMP("DHCOPFD",$j,myUserID,"PM",myPayMDR,"RefAmt"), myPayAmt)
	....set ^||TMP("DHCOPFDPM",$j,myPayMDR,"RefNum")=$i(^||TMP("DHCOPFDPM",$j,myPayMDR,"RefNum"))
	....set ^||TMP("DHCOPFDPM",$j,myPayMDR,"RefAmt")=$i(^||TMP("DHCOPFDPM",$j,myPayMDR,"RefAmt"), myPayAmt)
	
	quit
	
OutputFootDeposit
	set Data=$lb(CashierCode,CashierName,PayMode,PayNum,$fn(PayAmount,"",2),RefundNum,$fn(RefundAmount,"",2),No,$fn(TotalAmount,"",2),StTime,EndTime)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

}
