/// 名称: web.DHCOPBillYJAcountPrint.cls
/// 描述: 门诊预交金账打印业务类
/// 编写者: zhli
/// 编写日期: 2018-08-29
/// 产品组：计费医保组
Class web.DHCOPBillYJAcountPrint Extends %RegisteredObject
{

/// Creator: zhli
/// CreatDate: 2018-08-29
/// Description: 统计门诊预交金账汇总
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
/// Output: TInd:序号,TEndDate:做账日期,TPreLeftSum:前期余额,TPreSum:收预交金金额,TRefundPreSum:退预交金金额,TCardPaySum:卡消费金额,TLeftSum:当前余额
/// Return: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillYJAcountPrint","GetOPBillYJAcountHZReport", "2020-07-08", "2020-07-08")
Query GetOPBillYJAcountHZReport(stDate As %String, endDate As %String, HOSPID = "") As websys.Query(ROWSPEC = "TInd:%String:序号,TEndDate:%String:做账日期,TPreLeftSum:%Float:前期余额,TPreSum:%Float:收预交金金额,TRefundPreSum:%Float:退预交金金额,TCardPaySum:%Float:卡消费金额,TLeftSum:%Float:当前余额") [ SqlProc ]
{
}

ClassMethod GetOPBillYJAcountHZReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	if ((stDate="")||(endDate="")) quit $$$OK
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
	for myDate=stDate:1:endDate do
	.set myPFRowID=0
	.for  set myPFRowID=$o(^DHCACDi("AccPF",0,"CurDateT",myDate,myPFRowID)) quit:(myPFRowID="")  do
	..set myPFData=$g(^DHCACD("AccPF",myPFRowID))
	..quit:(myPFData="")
	..//set myHospId=$p(myPFData,"^",19)
	..//quit:(myHospId'=HOSPID)
	..set myEndDate=$p(myPFData,"^",1)			    ;AccPF_Date
	..//set myEndTime=$p(myPFData,"^",2)			;AccPF_Time
	..set myUserDR=$p(myPFData,"^",3)				;AccPF_User_DR
	..set myUserName=$p(myPFData,"^",2)
	..set myPreLeftSum=$p(myPFData,"^",6)			;AccPF_PreLeftSum
	..set myPreSum=$p(myPFData,"^",7)				;AccPF_PreSum
	..set myCardPaySum=$p(myPFData,"^",8)			;AccPF_CardPaySum
	..set myLeftSum=$p(myPFData,"^",9)				;AccPF_LeftSum
	..set myRefundPreSum=$p(myPFData,"^",10)		;AccPF_RefundPreSum
	..set myPreLeftSum=$fn(myPreLeftSum,"",2)
	..set myPreSum=$fn(myPreSum,"",2)
	..set myRefundPreSum=$fn(myRefundPreSum,"",2)
	..set myCardPaySum=$fn(myCardPaySum,"",2)
	..set myLeftSum=$fn(myLeftSum,"",2)
	..set myEndDate=$zd(myEndDate,3)
	..set data=$lb(ind,myEndDate,myPreLeftSum,myPreSum,myRefundPreSum,myCardPaySum,myLeftSum)
	..set ^CacheTemp(repid,ind)=data
	..set ind=ind+1

	quit $$$OK
}

/// Creator: zhli
/// CreatDate: 2018-08-29
/// Description: 统计门诊预交金账明细
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
/// Output: TInd:序号,TCardNo:卡号,TPatName:姓名,TPreLeftSum:前期余额,TPreSum:本次充值,TRefPreSum:本次退款,TCPSum:本次消费,TCurLeftSum:期末余额
/// Return: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillYJAcountPrint","GetOPBillYJAcountDetailReport", "2018-5-18", "2018-5-18")
Query GetOPBillYJAcountDetailReport(stDate As %String, endDate As %String, HOSPID As %String) As websys.Query(ROWSPEC = "TInd:%String:序号,TCardNo:%String:卡号,TPatName:%String:姓名,TPreLeftSum:%Float:前期余额,TPreSum:%Float:本次充值,TRefPreSum:%Float:本次退款,TCPSum:%Float:本次消费,TCurLeftSum:%Float:期末余额") [ SqlProc ]
{
}

ClassMethod GetOPBillYJAcountDetailReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	if ((stDate="")||(endDate="")) quit $$$OK
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
	for myDate=stDate:1:endDate do
	.set APFRowID=0
	.for  set APFRowID=$o(^DHCACDi("AccPF",0,"CurDateT",myDate,APFRowID)) quit:(APFRowID="")  do
	..//set myHospId=$p(^DHCACD("AccPF",APFRowID),"^",19)
	..//quit:(myHospId'=HOSPID)
	..set mySub=0
	..for  set mySub=$o(^DHCACD("AccPF",APFRowID,"PF",mySub)) quit:(mySub="")  do
	...set mySubData=$g(^DHCACD("AccPF",APFRowID,"PF",mySub))
	...quit:(mySubData="")
	...set myAccRowID=$p(mySubData,"^",1)				;AccPFS_AccM_DR
	...set myPAPMINo=$p(^DHCACD("AccM",myAccRowID),"^",3)
	...set myPAPMDR=$p(^DHCACD("AccM",myAccRowID),"^",2)
	...set myPatName=$p(^PAPER(myPAPMDR,"ALL"),"^",1)
	...set myCardNo=##class(web.UDHCJFBaseCommon).GetCardNoByAccMRowId(myAccRowID)
	...set myPreLeftSum=+$p(mySubData,"^", 2)			;AccPFS_PreLeft
	...set myPreSum=+$p(mySubData,"^", 3)				;AccPFS_PrePay
	...set myRefPreSum=+$p(mySubData,"^", 6)			;AccPFS_RefundPrePa
	...set myCPSum=+$p(mySubData,"^", 4)				;AccPFS_CardPay
	...set myCurLeftSum=+$p(mySubData,"^", 5)			;AccPFS_CurLeft
	...set data=$lb(ind,myCardNo,myPatName,myPreLeftSum,myPreSum,myRefPreSum,myCPSum,myCurLeftSum)
	...set ^CacheTemp(repid,ind)=data
	...set ind=ind+1

	quit $$$OK
}

}
