/// 名称: web.DHCIPBillDailyPrint.cls
/// 描述: 住院日报及日报汇总打印业务类
/// 编写者: zhli
/// 编写日期: 2018-03-20
/// 产品组：计费医保组
Class web.DHCIPBillDailyPrint Extends BILL.COM.Abstract
{

/// Creator: zhli
/// CreatDate: 2018-03-20
/// Description: 获取住院日报号段统计信息
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        stTime:开始时间(不能为空,汇总为空)
///        endTime:结束时间(不能为空,汇总为空)
///        hospDR:CT_Hospital.RowID(不能为空)
///        footId:DHC_INVPRTReports.RowID(个人日报需传值，汇总传空)
///        receId:DHC_INVPRTReports.RowID(个人日报传空，汇总需传值)
///        guser:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息)
///        guserStr:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息,日报汇总用)
///        groupDR:SS_Group 根据安全组配置来判断组长是否需要接收
/// Output: TUserId:收费员id,TUserName:收费员姓名,TNorDepNum:押金收据张数,TNorDepSum:押金总金额,TNorDepRcptNoStr:押金总号段,TParkDepNum:作废押金张数,TParkDepSum:作废押金金额,TParkInvNoStr:作废押金号段,TRefDepNum:红冲押金张数,TRefDepSum:红冲押金金额,TRefDepRcptNoStr:红冲押金号段,TInvNum:发票张数,TInvSum:发票总金额,TInvNoStr:发票号段,TParkInvNum:作废发票张数,TParkInvSum:作废发票金额,TParkInvNoStr:作废发票号段,TRefInvNum:红冲发票张数,TRefInvSum:红冲发票金额,TRefInvNoStr:红冲发票号段,TVoidInvNum:跳号张数,TVoidInvNoStr:跳号号段
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillDailyPrint","GetIPBillDailyInvoHZReport","2022-04-12","2022-04-13","23:59:59","15:59:15","2","","17275","","","")
Query GetIPBillDailyInvoHZReport(stDate As %String, endDate As %String, stTime As %String, endTime As %String, hospDR As %String, footId As %String = "", guser As %String = "", receId As %String = "", guserStr As %Text = "", groupDR As %String = "") As websys.Query(ROWSPEC = "TUserId:%Integer,TUserName:%String,TNorDepNum:%Integer,TNorDepSum:%Float,TNorDepRcptNoStr:%String,TParkDepNum:%Integer,TParkDepSum:%Float,TparkDepRcptNoStr:%String,TRefDepNum:%Integer,TRefDepSum:%Float,TRefDepRcptNoStr:%String,TInvNum:%Integer,TInvSum:%Float,TInvNoStr:%String,TParkInvNum:%Integer,TParkInvSum:%Float,TParkInvNoStr:%String,TRefInvNum:%Integer,TRefInvSum:%Float,TRefInvNoStr:%String,TVoidInvNum:%Integer,TVoidInvNoStr:%String,TvoidDepNum:%Integer,TvoidDepNoStr:%String") [ SqlProc ]
{
}

ClassMethod GetIPBillDailyInvoHZReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, stTime As %String, endTime As %String, hospDR As %String, footId As %String = "", guser As %String = "", receId As %String = "", guserStr As %Text = "", groupDR As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    tro
	set ^TMP("GetIPBillDailyInvoHZReport")=$lb(stDate, endDate, stTime, endTime, hospDR, footId, guser, receId, guserStr, groupDR)
	if ((stDate="")||(endDate="")) quit $$$OK
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime)
	set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime)
	
	set job=$j
	kill ^||TMP("INV",job)
	
	if (footId="") {
		if ((stTime'="")||(endTime'="")) {   //区分个人和汇总
			do ..GetInv(stDate, endDate,stTime, endTime, "", hospDR, guser, job)
		}else {
			do ..GetDailyPrintHZInfo(stDate, endDate, stTime, endTime, hospDR, guserStr, receId, "InvNo", groupDR, job)
		}
	}else {
		do ..GetInv(stDate, endDate, stTime, endTime, footId, hospDR, guser, job)
	}
	
	set userDR=0
	while($o(^||TMP("INV",job,userDR))) {
		set userDR=$o(^||TMP("INV",job,userDR))
		set userName=$p(^SSU("SSUSR",userDR),"^",2)
		set norDepNum=+$g(^||TMP("INV",job,userDR,"NORRCPTNUM"))
		set norDepSum=+$g(^||TMP("INV",job,userDR,"NORKRCPTAMT"))
		set norDepRcptNoStr=##class(web.DHCBillCommon).GetInvNoInfo("^||TMP", "INV", job, userDR, "NORRCPTNO")
	 	set parkDepNum=+$g(^||TMP("INV",job,userDR,"PARKRCPTNUM"))
		set parkDepSum=+$g(^||TMP("INV",job,userDR,"PARKRCPTAMT"))
		set parkDepRcptNoStr=$g(^||TMP("INV",job,userDR,"PARKRCPTNO"))
	 	set refDepNum=+$g(^||TMP("INV",job,userDR,"REFRCPTNUM"))
		set refDepSum=+$g(^||TMP("INV",job,userDR,"REFRCPTAMT"))
		set refDepRcptNoStr=$g(^||TMP("INV",job,userDR,"REFRCPTNO"))
		set invNum=+$g(^||TMP("INV",job,userDR,"AllINVNUM"))
	 	set invSum=+$g(^||TMP("INV",job,userDR,"ALLINVAMT"))
		set invNoStr=##class(web.DHCBillCommon).GetInvNoInfo("^||TMP", "INV", job, userDR, "AllINVNO")
	 	set parkInvNum=+$g(^||TMP("INV",job,userDR,"PARKINVNUM"))
	 	set parkInvSum=+$g(^||TMP("INV",job,userDR,"PARKINVAMT"))
		set parkInvNoStr=$g(^||TMP("INV",job,userDR,"PARKINVNO"))
	 	set refInvNum=+$g(^||TMP("INV",job,userDR,"REFINVNUM"))
	 	set refInvSum=+$g(^||TMP("INV",job,userDR,"REFINVAMT"))
		set refInvNoStr=$g(^||TMP("INV",job,userDR,"REFINVNO"))
		set voidInvNum=+$g(^||TMP("INV",job,userDR,"AllVOIDNUM"))
	 	set voidInvNoStr=$g(^||TMP("INV",job,userDR,"AllVOIDNO"))
	 	set voidDepNum=+$g(^||TMP("INV",job,userDR,"AllDEPVOIDNUM"))
	 	set voidDepNoStr=$g(^||TMP("INV",job,userDR,"AllDEPVOIDNO"))
		do OutputInvoHZ
	}
 	
 	kill ^||TMP("INV",job)
 	quit $$$OK
	
OutputInvoHZ	
	set data=$lb(userDR,userName,norDepNum,norDepSum,norDepRcptNoStr,parkDepNum,parkDepSum,parkDepRcptNoStr,refDepNum,refDepSum,refDepRcptNoStr,invNum,invSum,invNoStr,parkInvNum,parkInvSum,parkInvNoStr,refInvNum,refInvSum,refInvNoStr,voidInvNum,voidInvNoStr,voidDepNum,voidDepNoStr)
	set ^CacheTemp(repid,ind)=data
	set ind=$i(ind)
	quit
}

/// Creator: zhli
/// CreatDate: 2018-03-16
/// Description: 获取门诊日结汇总统计信息
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        stTime:开始时间(不能为空,汇总为空)
///        endTime:结束时间(不能为空,汇总为空)
///        hospId:CT_Hospital.RowID(不能为空)
///        receId:DHC_INVPRTReports.RowID(个人日报传空，汇总需传值)
///        guserStr:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息,日报汇总用)
///        callType:调用哪个方法的标志 "Paymode":GetPayMode;"CateType":GetCateType;"AdmReason":GetAdmReason;"InvNo":GetInv;
///        groupId:SS_Group 根据安全组配置来判断组长是否需要接收
/// Debug: w ##class(web.DHCIPBillDailyPrint).GetDailyPrintHZInfo("33050", 2, "","")
ClassMethod GetDailyPrintHZInfo(stDate As %String, endDate As %String, stTime As %String, endTime As %String, hospId As %String, guserStr As %Text, receId As %String, callType As %String, groupId As %String, job As %String) As %String
{
	//收费组长接收标识
	set baseConfig=##class(web.UDHCOPGSConfig).ReadCFByGRowID(groupId, hospId)
	set receConfig=$p(baseConfig,"^",21)

	if (receConfig=1) {
		if (receId="") {
			//查询未接收结账记录
			set footId=0
			while($o(^DHCJFUSERJK(0,"RECEIVEFLAG","N",footId))) {
				set footId=$o(^DHCJFUSERJK(0,"RECEIVEFLAG","N",footId))
				set footData=$g(^DHCJFUSERJK(footId))
				continue:(footData="")
				set footDate=$p(footData,"^",1)
				continue:((endDate'="")&&(footDate>endDate))
				do BuildJKData
			}
		}else {
			//查询已接收结账记录
			set footId=0
			while($o(^DHCJFUSERJK(0,"RECEIVEDR",receId,footId))) {
				set footId=$o(^DHCJFUSERJK(0,"RECEIVEDR",receId,footId))
				set footData=$g(^DHCJFUSERJK(footId))
				continue:(footData="")
				do BuildJKData
			}
		}
	}else {
		//不接收时按照日期查询
		for date=stDate:1:endDate {
			set footId=0
			while($o(^DHCJFUSERJK(0,"date",date,footId))) {
				set footId=$o(^DHCJFUSERJK(0,"date",date,footId))
				set footData=$g(^DHCJFUSERJK(footId))
				continue:(footData="")
				do BuildJKData
			}
		}
	}
	quit

BuildJKData
	set hospDR=$p(footData,"^",27)
	quit:(hospDR'=hospId)
	set userDR=$p(footData,"^",5)
	quit:((guserStr'="")&&(("^"_guserStr_"^")'[("^"_userDR_"^")))             //按收费员过滤
	if (callType="IPDep") {
		do ..GetDeposit(stDate, endDate, stTime, endTime, footId, hospDR, userDR, job)  //押金支付方式
		quit
	}
	if (callType="CateType") {
		do ..GetCateType(stDate, endDate, stTime, endTime, footId, hospDR, userDR, job)    //发票分类
		quit
	}
	if (callType="AdmReason") {
		do ..GetAdmReason(stDate, endDate, stTime, endTime, footId, hospDR, userDR, job)   //费别支付方式
		quit
	}
	if (callType="InvNo") {
		do ..GetInv(stDate, endDate, stTime, endTime, footId, hospDR, userDR, job)  //发票和押金号段
		quit
	}
	
	quit
}

/// Creator: zhli
/// CreatDate: 2018-03-20
/// Description:根据交账id获取号段信息
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        stTime:开始时间(不能为空)
///        endTime:结束时间(不能为空)
///        hospId:CT_Hospital.RowID(不能为空)
///        footId:DHC_INVPRTReports.RowID(个人日报可为空，汇总需传值)
///        userId:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息)
/// Debug: w ##class(web.DHCIPBillDailyPrint).GetInv("33050", 2, "")
ClassMethod GetInv(stDate As %String, endDate As %String, stTime As %String, endTime As %String, footId As %String, hospId As %String, userId As %String, job As %String) As %String
{
	if (footId'="") do
	.//押金信息
	.set depRowId=0
	.for  set depRowId=$o(^DHCSFPRINTDETAIL(0,"JKDR",footId,depRowId)) quit:(depRowId="")  do    
	..set depData=$g(^DHCSFPRINTDETAIL(depRowId))
	..quit:(depData="")
	..set userDR=$p(depData,"^",14)
	..do SetDepNoInfo
	.//发票信息
	.set invRowId=0
	.for  set invRowId=$o(^DHCINVPRTZY(0,"JK",footId,invRowId)) quit:(invRowId="")  do
	..set invData=$g(^DHCINVPRTZY(invRowId))
	..quit:(invData="")
	..set userDR=$p(invData,"^",7)
	..do SetInvNoInfo
 	.//集中打印发票信息
 	.set spiRowId=0
 	.for  set spiRowId=$o(^BILL.IP.SummaryPrtInvI("RepDR",footId,spiRowId))  quit:(spiRowId="")  do
 	..set spiData=$g(^BILL.IP.SummaryPrtInvD(spiRowId))
 	..quit:(spiData="")
 	..set userDR=$lg(spiData,5)
 	..do SetSPINoInfo
	.//跳号信息
 	.set voidId=0
 	.for  set voidId=$o(^DHCVoidInv(0,"RepDr",footId,voidId)) quit:(voidId="")  do
 	..set voidData=$g(^DHCVoidInv(voidId))
 	..quit:(voidData="")
 	..set invType=$p(voidData,"^",11)
 	..quit:(invType'["I")
 	..set userDR=$p(voidData,"^",5)
 	..do SetVoidInfo
	else  do
	.//押金信息
	.for prtDate=stDate:1:endDate do
	..set depRowId=0
	..for  set depRowId=$o(^DHCSFPRINTDETAIL(0,"PrtDate",prtDate,depRowId)) quit:(depRowId="")  do
	...set depData=$g(^DHCSFPRINTDETAIL(depRowId))
	...quit:(depData="")
	...set reportDR=$p(depData,"^",30)
	...quit:(+reportDR'=0)
	...set userDR=$p(depData,"^",14)
	...quit:(userDR'=userId)
	...set prtTime=$p(depData,"^",3)
	...quit:((prtDate=endDate)&&(prtTime>endTime)&&(endTime'=""))
	...set hospDR=$p(depData,"^",44)
	...quit:(hospDR'=hospId)
	...do SetDepNoInfo
	.//发票信息
	.for date=stDate:1:endDate do
	..set invRowId=0
	..for  set invRowId=$o(^DHCINVPRTZY(0,"DATE",date,invRowId)) quit:(invRowId="")  do
	...set invData=$g(^DHCINVPRTZY(invRowId))
	...quit:(invData="")
	...set userDR=$p(invData,"^",7)
	...quit:(userDR'=userId)
	...set reportDR=$p(invData,"^",23)
	...quit:(+reportDR'=0)
	...set prtTime=$p(invData,"^",3) 
	...quit:((date=endDate)&&(prtTime>endTime)&&(endTime'=""))
	...set hospDR=$p(invData,"^",35)
	...quit:(hospDR'=hospId)
	...do SetInvNoInfo
	..//集中打印发票信息
 	..set spiRowId=0
 	..for  set spiRowId=$o(^BILL.IP.SummaryPrtInvI("PrtDate",date,spiRowId))  quit:(spiRowId="")  do
 	...set spiData=$g(^BILL.IP.SummaryPrtInvD(spiRowId))
 	...quit:(spiData="")
 	...set userDR=$lg(spiData,5)
	...quit:(userDR'=userId)
	...set reportDR=$lg(spiData,13)
	...quit:(+reportDR'=0)
	...set spiTime=$lg(spiData,8)
	...quit:((date=endDate)&&(prtTime>endTime)&&(endTime'=""))
	...set hospDR=$lg(spiData,14)
	...quit:(hospDR'=hospId)
	...do SetSPINoInfo
	.//跳号信息
	.for voidDate=stDate:1:endDate do
 	..set voidId=0
 	..for  set voidId=$o(^DHCVoidInv(0,"UserDate",userId,voidDate,voidId)) quit:(voidId="")  do
 	...set voidData=$g(^DHCVoidInv(voidId))
 	...quit:(voidData="")
 	...set userDR=$p(voidData,"^",5)
 	...set invType=$p(voidData,"^",11)
 	...quit:(invType'["I")
 	...set reportDR=$p(voidData,"^",6)
 	...quit:(+reportDR'=0)
	...set voidTime=$p(voidData,"^",2)
	...quit:((voidDate=endDate)&&(voidTime>endTime)&&(endTime'=""))
	...set hospDR=$p(voidData,"^",12)
	...quit:(hospDR'=hospId)
 	...do SetVoidInfo
	
	quit
 
SetDepNoInfo
	set rcptNo=$p(depData,"^",1)
	set depAmt=+$p(depData,"^",6)
	set prtStatus=$p(depData,"^",8)
	set initDepDR=$p(depData,"^",43)
	set initRcptNo=rcptNo
	if ((initRcptNo="")&&(+initDepDR'=0)) do
	.set initRcptNo=$p($g(^DHCSFPRINTDETAIL(initDepDR)),"^",1)          //负记录不走号时取原记录收据号
	if (rcptNo'="") do
	.set ^||TMP("INV",job,userDR,"NORRCPTNO",rcptNo)=""
	.set ^||TMP("INV",job,userDR,"NORRCPTNUM")=$i(^||TMP("INV",job,userDR,"NORRCPTNUM"))
	if (" 1 4 "[(" "_prtStatus_" ")) do
	.set ^||TMP("INV",job,userDR,"NORKRCPTAMT")=$i(^||TMP("INV",job,userDR,"NORKRCPTAMT"), depAmt)
	if ((+prtStatus=2)&&(+initDepDR'=0)) do
	.if (initRcptNo'="") do
	..if ('$d(^||TMP("INV",job,userDR,"PARKRCPTNO")))  do
	...set ^||TMP("INV",job,userDR,"PARKRCPTNO")=initRcptNo
	..else  do
	...set ^||TMP("INV",job,userDR,"PARKRCPTNO")=$g(^||TMP("INV",job,userDR,"PARKRCPTNO"))_", "_initRcptNo
	.set ^||TMP("INV",job,userDR,"PARKRCPTNUM")=$i(^||TMP("INV",job,userDR,"PARKRCPTNUM"))
	.set ^||TMP("INV",job,userDR,"PARKRCPTAMT")=$i(^||TMP("INV",job,userDR,"PARKRCPTAMT"), depAmt)
	if ((+prtStatus=3)&&(+initDepDR'=0)) do
	.if (initRcptNo'="") do
	..if ('$d(^||TMP("INV",job,userDR,"REFRCPTNO"))) do
	...set ^||TMP("INV",job,userDR,"REFRCPTNO")=initRcptNo
	..else  do
	...set ^||TMP("INV",job,userDR,"REFRCPTNO")=$g(^||TMP("INV",job,userDR,"REFRCPTNO"))_", "_initRcptNo
	.set ^||TMP("INV",job,userDR,"REFRCPTNUM")=$i(^||TMP("INV",job,userDR,"REFRCPTNUM"))
	.set ^||TMP("INV",job,userDR,"REFRCPTAMT")=$i(^||TMP("INV",job,userDR,"REFRCPTAMT"), depAmt)
	
	quit
	
SetInvNoInfo
	set invNo=$p(invData,"^",1)
	set invAmt=+$p(invData,"^",6)
	set invFlag=$p(invData,"^",8)
	set initInvDR=$p(invData,"^",13)
	set initInvNo=invNo
	if ((initInvNo="")&&(+initInvDR'=0)) do
	.set initInvNo=$p(^DHCINVPRTZY(initInvDR),"^",1)          //负记录不走号时取原记录发票号
	if (invNo'="") do
	.set ^||TMP("INV",job,userDR,"AllINVNO",invNo)=""                                                  
	.set ^||TMP("INV",job,userDR,"AllINVNUM")=$i(^||TMP("INV",job,userDR,"AllINVNUM"))          //存储收费发票张数
	.set ^||TMP("INV",job,userDR,"ALLINVAMT")=$i(^||TMP("INV",job,userDR,"ALLINVAMT"), invAmt)   //存储收费发票金额
	if ((invFlag="A")&&(+initInvDR'=0)) do
	.if (initInvNo'="") do
	..quit:((", "_$g(^||TMP("INV",job,userDR,"PARKINVNO"))_", ")[(", "_initInvNo_", "))
	..if ('$d(^||TMP("INV",job,userDR,"PARKINVNO")))  do
	...set ^||TMP("INV",job,userDR,"PARKINVNO")=initInvNo
	..else  do
	...set ^||TMP("INV",job,userDR,"PARKINVNO")=$g(^||TMP("INV",job,userDR,"PARKINVNO"))_", "_initInvNo
	..set ^||TMP("INV",job,userDR,"PARKINVNUM")=$i(^||TMP("INV",job,userDR,"PARKINVNUM"))
	..set ^||TMP("INV",job,userDR,"PARKINVAMT")=$i(^||TMP("INV",job,userDR,"PARKINVAMT"), invAmt)        //存储作废金额
	if ((invFlag="S")&&(+initInvDR'=0)) do
	.if (initInvNo'="") do
	..quit:((", "_$g(^||TMP("INV",job,userDR,"REFINVNO"))_", ")[(", "_initInvNo_", "))
	..if ('$d(^||TMP("INV",job,userDR,"REFINVNO")))  do
	...set ^||TMP("INV",job,userDR,"REFINVNO")=initInvNo
	..else  do
	...set ^||TMP("INV",job,userDR,"REFINVNO")=$g(^||TMP("INV",job,userDR,"REFINVNO"))_", "_initInvNo
	..set ^||TMP("INV",job,userDR,"REFINVNUM")=$i(^||TMP("INV",job,userDR,"REFINVNUM"))
	..set ^||TMP("INV",job,userDR,"REFINVAMT")=$i(^||TMP("INV",job,userDR,"REFINVAMT"), invAmt)          //存储收费红冲金额
 	
 	quit

SetSPINoInfo
	set invNo=$lg(spiData,2)
	set invAmt=##class(web.DHCIPBillDailyDetails).GetSPInvSumByID(spiRowId)	
	set invFlag=$lg(spiData,6)
	set initInvDR=$lg(spiData,9)
	set initInvNo=invNo
	if ((initInvNo="")&&(+initInvDR'=0)) do
	.set initInvNo=$lg(^BILL.IP.SummaryPrtInvD(initInvDR),2)          //负记录不走号时取原记录发票号
	if (invNo'="") do
	.set ^||TMP("INV",job,userDR,"AllINVNO",invNo)=""                                                  
	.set ^||TMP("INV",job,userDR,"AllINVNUM")=$i(^||TMP("INV",job,userDR,"AllINVNUM"))          //存储收费发票张数
	.set ^||TMP("INV",job,userDR,"ALLINVAMT")=$i(^||TMP("INV",job,userDR,"ALLINVAMT"), invAmt)  //存储收费发票金额
	if ((invFlag="A")&&(+initInvDR'=0)) do
	.if (initInvNo'="") do
	..quit:((", "_$g(^||TMP("INV",job,userDR,"PARKINVNO"))_", ")[(", "_initInvNo_", "))
	..if ('$d(^||TMP("INV",job,userDR,"PARKINVNO"))) do
	...set ^||TMP("INV",job,userDR,"PARKINVNO")=initInvNo
	..else  do
	...set ^||TMP("INV",job,userDR,"PARKINVNO")=$g(^||TMP("INV",job,userDR,"PARKINVNO"))_", "_initInvNo
	..set ^||TMP("INV",job,userDR,"PARKINVNUM")=$i(^||TMP("INV",job,userDR,"PARKINVNUM"))
	..set invAmt=-invAmt   //集中打印发票作废时，并没有取消结算，关联的金额还是原结算金额，故这里将红冲金额取负
	..set ^||TMP("INV",job,userDR,"PARKINVAMT")=$i(^||TMP("INV",job,userDR,"PARKINVAMT"), invAmt)         //存储作废金额
	if ((invFlag="S")&&(+initInvDR'=0)) do
	.if (initInvNo'="") do
	..quit:((", "_$g(^||TMP("INV",job,userDR,"REFINVNO"))_", ")[(", "_initInvNo_", "))
	..if ('$d(^||TMP("INV",job,userDR,"REFINVNO"))) do
	...set ^||TMP("INV",job,userDR,"REFINVNO")=initInvNo
	..else  do
	...set ^||TMP("INV",job,userDR,"REFINVNO")=$g(^||TMP("INV",job,userDR,"REFINVNO"))_", "_initInvNo
	..set ^||TMP("INV",job,userDR,"REFINVNUM")=$i(^||TMP("INV",job,userDR,"REFINVNUM"))
	..set invAmt=-invAmt    //集中打印发票红冲时，并没有取消结算，关联的金额还是原结算金额，故这里将红冲金额取负
	..set ^||TMP("INV",job,userDR,"REFINVAMT")=$i(^||TMP("INV",job,userDR,"REFINVAMT"), invAmt)          //存储红冲金额

 	quit
SetVoidInfo
	set invNo=$p(voidData,"^",3)
 	if (invType="IP") do
  	.if ('$d(^||TMP("INV",job,userDR,"AllVOIDNO")))  do
 	..set ^||TMP("INV",job,userDR,"AllVOIDNO")=invNo
 	.else  do
 	..set ^||TMP("INV",job,userDR,"AllVOIDNO")=$g(^||TMP("INV",job,userDR,"AllVOIDNO"))_", "_invNo
  	.set ^||TMP("INV",job,userDR,"AllVOIDNUM")=$i(^||TMP("INV",job,userDR,"AllVOIDNUM"))
  	if (invType="ID") do
  	.if ('$d(^||TMP("INV",job,userDR,"AllDEPVOIDNO")))  do
 	..set ^||TMP("INV",job,userDR,"AllDEPVOIDNO")=invNo
 	.else  do
 	..set ^||TMP("INV",job,userDR,"AllDEPVOIDNO")=$g(^||TMP("INV",job,userDR,"AllDEPVOIDNO"))_", "_invNo
 	.set ^||TMP("INV",job,userDR,"AllDEPVOIDNUM")=$i(^||TMP("INV",job,userDR,"AllDEPVOIDNUM"))
 	
	quit
}

/// Creator: zhli
/// CreatDate: 2018-03-21
/// Description: 获取住院日结汇总住院收费分类统计信息
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        stTime:开始时间(不能为空,汇总为空)
///        endTime:结束时间(不能为空,汇总为空)
///        hospDR:CT_Hospital.RowID(不能为空)
///        footId:DHC_INVPRTReports.RowID(个人日报需传值，汇总传空)
///        receId:DHC_IPBillReceive.RowID(个人日报传空，汇总需传值)
///        guser:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息)
///        guserStr:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息,日报汇总用)
///        groupDR:SS_Group 根据安全组配置来判断组长是否需要接收
/// Output: userDR:收费员id,userName:收费员姓名,cateID:大类id,cateDesc:大类描述,subCateDR:子类id,subCateDesc:子类描述,catePaySum:分类金额
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillDailyPrint","GetIPBillDailyCateFeeHZReport", "2021-11-10","2021-11-10","10:16:48","13:18:47","2","","12173","","","")
Query GetIPBillDailyCateFeeHZReport(stDate As %String, endDate As %String, stTime As %String, endTime As %String, hospDR As %String, footId As %String = "", guser As %String = "", receId As %String = "", guserStr As %Text = "", groupDR As %String = "") As websys.Query(ROWSPEC = "userDR:%String:收费员id,userName:%String:收费员姓名,cateID:%String:大类id,cateDesc:%String:大类描述,subCateDR:%String:子类id,subCateDesc:%String:子类描述,catePaySum:%Float:分类金额") [ SqlProc ]
{
}

ClassMethod GetIPBillDailyCateFeeHZReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, stTime As %String, endTime As %String, hospDR As %String, footId As %String = "", guser As %String = "", receId As %String = "", guserStr As %Text = "", groupDR As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	
	if ((stDate="")||(endDate="")) quit $$$OK
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime)
	set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime)
	
	set job=$j
	kill ^||TMP("CATE",job)

	if (footId="") {
		if ((stTime'="")||(endTime'="")) {   //区分个人和汇总
			do ..GetCateType(stDate, endDate, stTime, endTime, "", hospDR, guser, job)
		}else {
			do ..GetDailyPrintHZInfo(stDate, endDate, stTime, endTime, hospDR, guserStr, receId, "CateType", groupDR, job)
		}
	}else {
		do ..GetCateType(stDate, endDate, stTime, endTime, footId, hospDR, guser, job)
	}
	
	set userDR=0
	while($o(^||TMP("CATE",job,userDR))) {
		set userDR=$o(^||TMP("CATE",job,userDR))
		set userName=$p(^SSU("SSUSR",userDR),"^",2)
		set subCateDR=0
		while($o(^||TMP("CATE",job,userDR,"IC",subCateDR))) {
			set subCateDR=$o(^||TMP("CATE",job,userDR,"IC",subCateDR))
			set catePaySum=$g(^||TMP("CATE",job,userDR,"IC",subCateDR))
			set subCateDesc=$p(^DHCTarC("IC",subCateDR),"^",2)
			set cateId=$p(^DHCTarC("IC",subCateDR),"^",3)
			set cateDesc=$p(^DHCTarC("TIC",cateId),"^",2)
			set data=$lb(userDR,userName,cateId,cateDesc,subCateDR,subCateDesc,catePaySum)
			set ^CacheTemp(repid,ind)=data
			set ind=$i(ind)
		}
	}
	
	kill ^||TMP("CATE",job)
	
	quit $$$OK
}

/// Creator: zhli
/// CreatDate: 2018-03-21
/// Description: 根据交账id获取分类项目明细
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        stTime:开始时间(不能为空)
///        endTime:结束时间(不能为空)
///        hospId:CT_Hospital.RowID(不能为空)
///        footId:DHC_INVPRTReports.RowID(个人日报需传值，汇总传空)
///        userId:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息)
///        job:进程号
/// Return: 
/// Debug: w ##class(web.DHCIPBillDailyPrint).GetCateType("33050", 2, "","")
ClassMethod GetCateType(stDate As %String, endDate As %String, stTime As %String, endTime As %String, footId As %String, hospId As %String, userId As %String, job As %String) As %String
{
	if (footId'="") {
		//发票信息
		set invRowId=0
		while($o(^DHCINVPRTZY(0,"JK",footId,invRowId))) {
			set invRowId=$o(^DHCINVPRTZY(0,"JK",footId,invRowId))
			set invData=$g(^DHCINVPRTZY(invRowId))
			continue:(invData="")
			set userDR=$p(invData,"^",7)
			do SetCate
		}
	}else {
		for date=stDate:1:endDate {
			set invRowId=0
			while($o(^DHCINVPRTZY(0,"DATE",date,invRowId))) {
				set invRowId=$o(^DHCINVPRTZY(0,"DATE",date,invRowId))
				set invData=$g(^DHCINVPRTZY(invRowId))
				continue:(invData="")
				set hospDR=$p(invData,"^",35)
				continue:(hospDR'=hospId)
				set reportDR=$p(invData,"^",23)
				continue:(+reportDR'=0)
				set userDR=$p(invData,"^",7)
				continue:(userDR'=userId)
				set prtTime=$p(invData,"^",3)
				continue:((date=endDate)&&(prtTime>endTime)&&(endTime'=""))
				do SetCate
			}
		}
	}
	quit
	
SetCate
	set bill=$p(invData,"^",5)
	set bizFlag=$p(invData,"^",20)   //PRT_BizFlag
	quit:(bizFlag'="")   //+2022-09-29 ZhYW PN(过号重打),AB(欠费补回)账单不变，不算入收入

	set catId=0
	while($o(^DHCJFPATIPSUBCATFEE(0,"DHCPB",bill,catId))) {
		set catId=$o(^DHCJFPATIPSUBCATFEE(0,"DHCPB",bill,catId))
		set data=$g(^DHCJFPATIPSUBCATFEE(catId))
		continue:(data="")
		set subCateDR=$p(data,"^",2)
		set subCateAmt=+$p(data,"^",3)
		set subCateType=$p(data,"^",4)
		set ^||TMP("CATE",job,userDR,subCateType,subCateDR)=$i(^||TMP("CATE",job,userDR,subCateType,subCateDR), subCateAmt)
	}
	
	quit
}

/// Creator: qcn
/// CreatDate: 2018-03-21
/// Description: 获取住院押金信息
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        stTime:开始时间(个人不为空,汇总为空)
///        endTime:结束时间(个人不为空,汇总为空)
///        hospDR:CT_Hospital.RowID(不能为空)
///        footId:DHC_INVPRTReports.RowID(个人已结算不能为空，个人未结算需传空，汇总传空)
///        receId:DHC_IPBillReceive.RowID
///        guser:SS_User.RowID
///        guserStr:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息,日报汇总用)
///        groupDR:SS_Group 根据安全组配置来判断组长是否需要接收
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillDailyPrint","GetIPBillDailyPayDepReport", "2018-3-1", "2018-3-1","00:00:00","23:59:59", 2, "","4632","","")
Query GetIPBillDailyPayDepReport(stDate As %String, endDate As %String, stTime As %String, endTime As %String, hospDR As %String, footId As %String = "", guser As %String = "", receId As %String = "", guserStr As %Text = "", groupDR As %String = "") As websys.Query(ROWSPEC = "userDR,paymCode,paymDesc,prtPaySum:%Float,prtPayNum:%Integer,prtRefSum:%Float,prtRefNum:%Integer") [ SqlProc ]
{
}

ClassMethod GetIPBillDailyPayDepReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, stTime As %String, endTime As %String, hospDR As %String, footId As %String = "", guser As %String = "", receId As %String = "", guserStr As %Text = "", groupDR As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    
	if ((stDate="")||(endDate="")) quit $$$OK
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime)
	set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime)
	
	set job=$j
	kill ^||TMP("DEP",job)
	
	//组织数据
	if (footId="") {
		if ((stTime'="")||(endTime'="")) { //区分个人和汇总
			do ..GetDeposit(stDate, endDate, stTime, endTime, "", hospDR, guser, job)
		}else {
			do ..GetDailyPrintHZInfo(stDate, endDate, stTime, endTime, hospDR, guserStr, receId, "IPDep", groupDR, job)
		}		
	}else {
		do ..GetDeposit(stDate, endDate, stTime, endTime, footId, hospDR, guser, job)
	}
	
	//输出数据
	set userDR=0
	while($o(^||TMP("DEP",job,userDR))) {
		set userDR=$o(^||TMP("DEP",job,userDR))
		set paymDR=0
		while($o(^CT("CTPM",paymDR))) {
			set paymDR=$o(^CT("CTPM",paymDR))
			set paymCode=$p(^CT("CTPM",paymDR),"^",1)
			set paymDesc=$p(^CT("CTPM",paymDR),"^",2)
			set prtPMData=$g(^||TMP("DEP",job,userDR,paymDR))
			set prtPaySum=+$lg(prtPMData,1)      //收费金额
			set prtPayNum=+$lg(prtPMData,2)      //收费数量
			set prtRefSum=+$lg(prtPMData,3)      //退费金额
			set prtRefNum=+$lg(prtPMData,4)      //退费数量
			set data=$lb(userDR,paymCode,paymDesc,prtPaySum,prtPayNum,prtRefSum,prtRefNum)
			set ^CacheTemp(repid,ind)=data
			set ind=$i(ind)
		}
	}
	
	kill ^||TMP("DEP",job)
	quit $$$OK
}

/// Creator: qcn
/// CreatDate: 2018-03-21
/// Description: 根据发票id获取住院押金的支付方式金额
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        stTime:开始时间(不能为空)
///        endTime:结束时间(不能为空)
///        hospId:CT_Hospital.RowID(不能为空)
///        footId:DHC_INVPRTReports.RowID(个人未结算传空，已结算和汇总需传值)
///        userId:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息)
/// Return: 
ClassMethod GetDeposit(stDate As %String, endDate As %String, stTime As %String, endTime As %String, footId As %String, hospId As %String, userId As %String, job As %String)
{
	if (footId="") {
		for date=stDate:1:endDate {
			set depRowId=0
			while($o(^DHCSFPRINTDETAIL(0,"PrtDate",date,depRowId))) {
				set depRowId=$o(^DHCSFPRINTDETAIL(0,"PrtDate",date,depRowId))
				set depData=$g(^DHCSFPRINTDETAIL(depRowId))
				set reportDR=$p(depData,"^",30)
				continue:(+reportDR'=0)   //个人预览时，过滤掉已经结算过的数据
				do SetDEPPayM
			}
		}
	}else {
		set depRowId=0
		while($o(^DHCSFPRINTDETAIL(0,"JKDR",footId,depRowId))) {
			set depRowId=$o(^DHCSFPRINTDETAIL(0,"JKDR",footId,depRowId))
			set depData=$g(^DHCSFPRINTDETAIL(depRowId))
			do SetDEPPayM
		}
	}
	
	quit
	
SetDEPPayM
	set hospDR=$p(depData,"^",44)
	quit:(hospDR'=hospId)
	set depAmt=$p(depData,"^",6)
	set prtStatus=$p(depData,"^",8)
	set userDR=$p(depData,"^",14)
	quit:((userId'="")&&(userId'=userDR))
	set prtDate=$p(depData,"^",2)
	set prtTime=$p(depData,"^",3)
	quit:((prtDate=endDate)&&(prtTime>endTime)&&(endTime'=""))
	set initDepDR=$p(depData,"^",43)
	set depPMSub=0
	while($o(^DHCSFPRINTDETAIL(depRowId,"P",depPMSub))) {
		set depPMSub=$o(^DHCSFPRINTDETAIL(depRowId,"P",depPMSub))
		set depPMData=$g(^DHCSFPRINTDETAIL(depRowId,"P",depPMSub))
		continue:(depPMData="")
		set paymDR=$p(depPMData,"^",1)
		if (+initDepDR=0) {
			set $li(^||TMP("DEP",job,userDR,paymDR),1)=$lg($g(^||TMP("DEP",job,userDR,paymDR)),1)+depAmt
			set $li(^||TMP("DEP",job,userDR,paymDR),2)=$lg($g(^||TMP("DEP",job,userDR,paymDR)),2)+1
		}else {
			set $li(^||TMP("DEP",job,userDR,paymDR),3)=$lg($g(^||TMP("DEP",job,userDR,paymDR)),3)+depAmt
			set $li(^||TMP("DEP",job,userDR,paymDR),4)=$lg($g(^||TMP("DEP",job,userDR,paymDR)),4)+1
		}
	}
	
	quit
}

/// Creator: YDF
/// CreatDate: 2018-03-21
/// Description: 获取住院日结汇总费别支付方式统计信息
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        stTime:开始时间(不能为空,汇总为空)
///        endTime:结束时间(不能为空,汇总为空)
///        hospDR:CT_Hospital.RowID(不能为空)
///        footId:DHC_INVPRTReports.RowID(个人日报需传值，汇总传空)
///        receId:DHC_IPBillReceive.RowID(个人日报传空，汇总需传值)
///        guser:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息)
///        guserStr:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息,日报汇总用)
///        groupDR:SS_Group 根据安全组配置来判断组长是否需要接收
/// Output: TuserDR:用户ID,TUserCode:工号,TUserName:收费员姓名,TInsTypeDesc:费别,TIsINSU:是否医保,TPayModeCode:支付方式代码,TPayModeDesc:支付方式名称,TJSum:结算交款金额,JNum:结算交款数量,TSum:结算退款金额,TNum:结算退款数量,TolSum:总金额,TolNum:总数量
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillDailyPrint","GetIPBillDailyInsPayMHZReport","2022-04-21","13:48:39","2022-04-21","14:48:38","2","","17275","","","")
Query GetIPBillDailyInsPayMHZReport(stDate As %String, endDate As %String, stTime As %String, endTime As %String, hospDR As %String, footId As %String = "", guser As %String = "", receId As %String = "", guserStr As %Text = "", groupDR As %String = "") As websys.Query(ROWSPEC = "TuserDR:%Integer:用户ID,TUserCode:%String:工号,TUserName:%String:收费员姓名,TInsTypeDesc:%String:费别,TPayModeCode:%String:支付方式代码,TPayModeDesc:%String:支付方式名称,TJSum:%Float:结算交款金额,TJNum:%Integer:结算交款数量,TSum:%Float:结算退款金额,TNum:%Integer:结算退款数量,TolSum:%Float:总金额,TolNum:%Integer:总数量") [ SqlProc ]
{
}

ClassMethod GetIPBillDailyInsPayMHZReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, stTime As %String, endTime As %String, hospDR As %String, footId As %String = "", guser As %String = "", receId As %String = "", guserStr As %Text = "", groupDR As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    tro
	set ^TMP("GetIPBillDailyInsPayMHZReport")=$lb(stDate, endDate, stTime, endTime, hospDR, footId, guser, receId, guserStr, groupDR)
	if ((stDate="")||(endDate="")) quit $$$OK
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime)
	set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime)
	
	set job=$j
	kill ^||TMP("INSPAYM",job)
		
	if (footId="") {
		if ((stTime'="")||(endTime'="")) {   //区分个人和汇总
			do ..GetAdmReason(stDate, endDate, stTime, endTime, "", hospDR, guser, job)
		}else {
			do ..GetDailyPrintHZInfo(stDate, endDate, stTime, endTime, hospDR, guserStr, receId, "AdmReason", groupDR, job)
		}
	}else {
		do ..GetAdmReason(stDate, endDate, stTime, endTime, footId, hospDR, guser, job)
	}
	
	set userDR=0
	while($o(^||TMP("INSPAYM",job,userDR))) {
		set userDR=$o(^||TMP("INSPAYM",job,userDR))
		set userCode=$p(^SSU("SSUSR",userDR),"^",1)
		set userName=$p(^SSU("SSUSR",userDR),"^",2)
		set insTypeDR=0
		while($o(^||TMP("INSPAYM",job,userDR,insTypeDR))) {
			set insTypeDR=$o(^||TMP("INSPAYM",job,userDR,insTypeDR))
			set insType=$p(^PAC("ADMREA",insTypeDR),"^",2)
			set paymDR=0
			while($o(^||TMP("INSPAYM",job,userDR,insTypeDR,paymDR))) {
				set paymDR=$o(^||TMP("INSPAYM",job,userDR,insTypeDR,paymDR))
				continue:(+paymDR=0)  //冲退预交金和优惠金额global节点不是支付方式id，故在此处需要退出
				set payMCode=$p(^CT("CTPM",paymDR),"^",1)
				set payMDesc=$p(^CT("CTPM",paymDR),"^",2)
				set prtPMData=$g(^||TMP("INSPAYM",job,userDR,insTypeDR,paymDR))
				set JSum=+$lg(prtPMData,1)
				set JNum=+$lg(prtPMData,2)
				set TSum=+$lg(prtPMData,3)
				set TNum=+$lg(prtPMData,4)
				set TolSum=JSum+TSum
				set TolNum=JNum+TNum
				do OutputInsPayMHZ
			}
			set (JSum, JNum, TSum, TNum, TolNum)=""
			set payMCode="StrikeDeposit"
			set payMDesc="冲退预交金"
			set TolSum=+$g(^||TMP("INSPAYM",job,userDR,insTypeDR,"StrikeDeposit"))
			do OutputInsPayMHZ
			set (payMCode, JSum, JNum, TSum, TNum, TolNum)=""
			set payMCode="Discount"
			set payMDesc="优惠金额"
			set TolSum=+$g(^||TMP("INSPAYM",job,userDR,insTypeDR,"Discount"))
			do OutputInsPayMHZ
		}
	}
 
 	kill ^||TMP("INSPAYM",job)
 	quit $$$OK
	
OutputInsPayMHZ	
	set data=$lb(userDR,userCode,userName,insType,payMCode,payMDesc,JSum,JNum,TSum,TNum,TolSum,TolNum)
	set ^CacheTemp(repid,ind)=data
	set ind=$i(ind)
	quit
}

/// Creator: YDF
/// CreatDate: 2018-03-21
/// Description: 根据日期时间获取住院发票费别支付方式信息
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        stTime:开始时间(不能为空)
///        endTime:结束时间(不能为空)
///        hospId:CT_Hospital.RowID(不能为空)
///        userId:SS_User.RowID(可以为空,为空时获取对应日期时间段内所有的收费员信息)
/// Return: 
/// Debug: do ##class(web.DHCIPBillDailyPrint).GetAdmReason("64708","64714","0","86399",2,4832)
ClassMethod GetAdmReason(stDate As %String, endDate As %String, stTime As %String, endTime As %String, footId As %String, hospId As %String, userId As %String, job As %String)
{
	if (footId'="") {
		set invRowId=0
		while($o(^DHCINVPRTZY(0,"JK",footId,invRowId))) {
			set invRowId=$o(^DHCINVPRTZY(0,"JK",footId,invRowId))
			set invData=$g(^DHCINVPRTZY(invRowId))
			continue:(invData="")
			set userDR=$p(invData,"^",7)
			quit:((userId'="")&&(userDR'=userId))
			do SetInsPayM
		}
	}else {
		for date=stDate:1:endDate {
			set invRowId=0
			while($o(^DHCINVPRTZY(0,"DATE",date,invRowId))) {
				set invRowId=$o(^DHCINVPRTZY(0,"DATE",date,invRowId))
				set invData=$g(^DHCINVPRTZY(invRowId))
				continue:(invData="")
				set reportDR=$p(invData,"^",23)
				continue:(+reportDR'=0)
				set userDR=$p(invData,"^",7)
				continue:((userId'="")&&(userDR'=userId))
				set prtTime=$p(invData,"^",3)
				continue:((date=endDate)&&(prtTime>endTime)&&(endTime'=""))
				set hospDR=$p(invData,"^",35)
				continue:(hospDR'=hospId)
				do SetInsPayM
			}
		}
	}
	
	quit
	
SetInsPayM
	set prtFlag=$p(invData,"^",8)
	set insTypeDR=$p(invData,"^",9)
	set initInvDR=$p(invData,"^",13)
	set strikeDepAmt=$p(invData,"^",22)    //PRT_Deposit
	set billDR=$p(invData,"^",5)
	quit:(billDR="")
	set billData=$g(^DHCPB(billDR))
	set discAmt=+$p(billData,"^",9)
	set payorAmt=+$p(billData,"^",11)
	set discAmount=$i(discAmt, payorAmt)
	//折扣金额
	set ^||TMP("INSPAYM",job,userDR,insTypeDR,"Discount")=$i(^||TMP("INSPAYM",job,userDR,insTypeDR,"Discount"), discAmount)
	//冲退押金金额
	set ^||TMP("INSPAYM",job,userDR,insTypeDR,"StrikeDeposit")=$i(^||TMP("INSPAYM",job,userDR,insTypeDR,"StrikeDeposit"), strikeDepAmt)
	//支付方式金额
	set paymSub=0
	while($o(^DHCINVPRTZY(invRowId,"P",paymSub))) {
		set paymSub=$o(^DHCINVPRTZY(invRowId,"P",paymSub))
		set paymSubData=$g(^DHCINVPRTZY(invRowId,"P",paymSub))
		continue:(paymSubData="")
		set paymDR=$p(paymSubData,"^",1)
		set paymAmt=$p(paymSubData,"^",3)
		if (+paymAmt>0) {
			set $li(^||TMP("INSPAYM",job,userDR,insTypeDR,paymDR),1)=$lg($g(^||TMP("INSPAYM",job,userDR,insTypeDR,paymDR)),1)+paymAmt
			set $li(^||TMP("INSPAYM",job,userDR,insTypeDR,paymDR),2)=$lg($g(^||TMP("INSPAYM",job,userDR,insTypeDR,paymDR)),2)+1
		}else {
			set $li(^||TMP("INSPAYM",job,userDR,insTypeDR,paymDR),3)=$lg($g(^||TMP("INSPAYM",job,userDR,insTypeDR,paymDR)),3)+paymAmt
			set $li(^||TMP("INSPAYM",job,userDR,insTypeDR,paymDR),4)=$lg($g(^||TMP("INSPAYM",job,userDR,insTypeDR,paymDR)),4)+1
		}
	}
	
	quit
}

/// Creator: zhli
/// CreatDate: 2018-03-22
/// Description: 获取住院日结、汇总表头信息
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        stTime:开始时间(不能为空)
///        endTime:结束时间(不能为空)
/// 	   footId:DHC_INVPRTReports.Rowid(可以为空,为空时输出所有的结算记录)
///        hospDR:CT_Hospital.RowID(不能为空)
///        receId:DHC_IPBillReceive.RowID(个人日报传空，汇总需传值)
///        guserStr:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息,日报汇总用)
///        groupDR:SS_Group 根据安全组配置来判断组长是否需要接收
/// Output: HISDateTime:结算时间,HISStDate:开始日期,HISStTime:开始时间,HISEndDate:结束日期,HISEndTime:结束时间,HISUserDesc:收费员,CurDate:打印日期
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillDailyPrint","GetIPBillDailyTitleInfoReport", "2019-08-08","2019-08-12","14:55:24","09:24:50","","2","","","")
Query GetIPBillDailyTitleInfoReport(stDate As %String, endDate As %String, stTime As %String, endTime As %String, footId As %String = "", hospDR As %String = "", receId As %String = "", guserStr As %Text = "", groupDR As %String = "") As websys.Query(ROWSPEC = "HISDateTime:%String:结算时间,HISStDate:%String:开始日期,HISStTime:%String:开始时间,HISEndDate:%String:结束日期,HISEndTime:%String:结束时间,HISUserDesc:%String:收费员") [ SqlProc ]
{
}

ClassMethod GetIPBillDailyTitleInfoReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, stTime As %String, endTime As %String, footId As %String = "", hospDR As %String = "", receId As %String = "", guserStr As %Text = "", groupDR As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    
	set ^TMP("GetOPBillDailyTitleInfoReport")=$lb(stDate, endDate, stTime, endTime, footId, hospDR, receId, guserStr, groupDR)
	if ((stDate="")||(endDate="")) quit $$$OK
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime)
	set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime)
	
	set job=$j
	kill ^||TMP("DATE",job)
	
	set (HISDateTime, HISStDate, HISStTime, HISEndDate, HISEndTime, HISUserDesc)=""
	
	if (footId="") {
		if ((stTime'="")||(endTime'="")) {
			set footId="预览"
			set HISStDate=stDate
			set HISStTime=stTime
			set HISEndDate=endDate
			set HISEndTime=endTime
			set myStDate=stDate
			set myEndDate=endDate
		}else {
			do ..GetStEndDate(stDate, endDate, stTime, endTime, guserStr, receId, job, groupDR, hospDR)
			set myStDate=$o(^||TMP("DATE",job,""))
			set myEndDate=$o(^||TMP("DATE",job,""),-1)
		}
		set myStDate=##class(websys.Conversions).DateLogicalToHtml(myStDate)
		set myEndDate=##class(websys.Conversions).DateLogicalToHtml(myEndDate)
		set HISDateTime=myStDate_"至"_myEndDate
	}else {
		set footData=$g(^DHCJFUSERJK(footId))
		set HISDate=##class(websys.Conversions).DateLogicalToHtml($p(footData,"^",1)) //结算日期   
		set HISTime=##class(websys.Conversions).TimeLogicalToHtml($p(footData,"^",2)) //结算时间
		set HISStDate=$p(footData,"^",3)   //开始日期
		set HISStTime=$p(footData,"^",11)  //开始时间
		set HISEndDate=$p(footData,"^",4)  //结束日期
		set HISEndTime=$p(footData,"^",12) //结束时间
		set HISUser=$p(footData,"^",5)
		set HISUserDesc=$p(^SSU("SSUSR",HISUser),"^",2)  //操作员
		set HISDateTime=HISDate_" "_HISTime
	}
	
	kill ^||TMP("DATE",job)
	
	set HISStDate=##class(websys.Conversions).DateLogicalToHtml(HISStDate)   //开始日期
	set HISStTime=##class(websys.Conversions).TimeLogicalToHtml(HISStTime)
	set HISEndDate=##class(websys.Conversions).DateLogicalToHtml(HISEndDate)
	set HISEndTime=##class(websys.Conversions).TimeLogicalToHtml(HISEndTime)
	set data=$lb(HISDateTime,HISStDate,HISStTime,HISEndDate,HISEndTime,HISUserDesc)
	set ^CacheTemp(repid,ind)=data
	set ind=$i(ind)
	quit $$$OK
}

/// Creator: zhli
/// CreatDate: 2018-03-21
/// Description: 取汇总的开始结束日期，根据接收配置来
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        stTime:开始时间(不能为空)
///        endTime:结束时间(不能为空)
///        hospId:CT_Hospital.RowID(不能为空)
///        guserStr:SS_User.RowID(可以为空,为空时获取对应日期时间段内所有的收费员信息)
///        groupId:SS_Group 根据安全组配置来判断组长是否需要接收
/// Return: 
/// Debug: do ##class(web.DHCIPBillDailyPrint).GetStEndDate("64708","64714","0","86399",2,4832)
ClassMethod GetStEndDate(stDate As %String, endDate As %String, stTime As %String, endTime As %String, guserStr As %Text, receId As %String, job As %String, groupId As %String, hospId As %String)
{
	//收费组长接收标识
	set baseConfig=##class(web.UDHCOPGSConfig).ReadCFByGRowID(groupId, hospId)
	set receConfig=$p(baseConfig,"^",21)

	if (receConfig=1) {
		if (receId="") {
			//查询未接收结账记录
			set footId=0
			while($o(^DHCJFUSERJK(0,"RECEIVEFLAG","N",footId))) {
				set footId=$o(^DHCJFUSERJK(0,"RECEIVEFLAG","N",footId))
				set footData=$g(^DHCJFUSERJK(footId))
				continue:(footData="")
				set hospDR=$p(footData,"^",27)
				continue:(hospDR'=hospId)
				set footDate=$p(footData,"^",1)
				continue:((endDate'="")&&(footDate>endDate))
				set userDR=$p(footData,"^",5)
			 	continue:((guserStr'="")&&(("^"_guserStr_"^")'[("^"_userDR_"^")))             //按收费员过滤
			 	set ^||TMP("DATE",job,footDate)=""
			}
		}else {
			//查询已接收结账记录
			set footId=0
			while($o(^DHCJFUSERJK(0,"RECEIVEDR",receId,footId))) {
				set footId=$o(^DHCJFUSERJK(0,"RECEIVEDR",receId,footId))
				set footData=$g(^DHCJFUSERJK(footId))
				continue:(footData="")
				set hospDR=$p(footData,"^",27)
				continue:(hospDR'=hospId)
				set userDR=$p(footData,"^",5)
			 	continue:((guserStr'="")&&(("^"_guserStr_"^")'[("^"_userDR_"^")))             //按收费员过滤
			 	set footDate=$p(footData,"^",1)
			 	set ^||TMP("DATE",job,footDate)=""
			}
		}
	}else {
		//不接收时按照日期查询
		set ^||TMP("DATE",job,stDate)=""
		set ^||TMP("DATE",job,endDate)=""
	}
	
	quit
}

/// do ##class(%ResultSet).RunQuery("web.DHCIPBillDailyPrint","FindOPIPPrtByDate","2022-10-31","2022-10-31")
Query FindOPIPPrtByDate(StDate As %String, EndDate As %String, DeptId As %String = "", Zyh As %String = "") As websys.Query(ROWSPEC = "ind,MediCare,PaName,Invno,Amount:%Float,PRTDate,DepDesc,VisitStatus,SSUSRName,InitPrtDate") [ SqlProc ]
{
}

ClassMethod FindOPIPPrtByDateExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, DeptId As %String = "", Zyh As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	q:$g(StDate)="" $$$OK
	q:$g(EndDate)="" $$$OK
	s:$l(StDate)=10 StDate=$zdh(StDate,3)
	s:$l(EndDate)=10 EndDate=$zdh(EndDate,3)
		
	s SSUSRName="", DepDesc=""
	f date=StDate:1:EndDate d
	.s IUDID="",OPIPInfoRowid=""
 	.set rowid=""
 	.for  set rowid=$o(^DHCINVPRT(0,"Date",date,rowid)) quit:(rowid="")  do ;DHC_OPIPADMCON这张表
 	..set PrtInfo=$g(^DHCINVPRT(rowid))
 	..set PRTAcount=$p(PrtInfo,"^",16)
 	..q:(PRTAcount>=0)
 	..s PRTinitInvDR=$p(PrtInfo,"^",13)
 	..q:PRTinitInvDR=""
 	..;s rowidIsOPToIP=PRTinitInvDR
 	..;q:'$d(^DHCOPIPADMCON(0,"InvPrt",rowid)) ; q出去不在急诊转住院明细表的rowid
 	..set Flag=##class(web.DHCOPBillEmergTrans2IP).CheckInvIsOPToIP(PRTinitInvDR_":PRT")
 	..quit:Flag="0"
 	..s Info=..GetAmountByPrtRowid(PRTinitInvDR)
 	..set OPIPInfoRowid=$O(^DHCOPIPADMCON(0,"InvPrt",PRTinitInvDR,""),-1)
 	..set OPIPInfo=$g(^DHCOPIPADMCON(OPIPInfoRowid))
 	..;s IPAdmDR=$p(OPIPInfo,"^",3)
 	..s PAPMIID=$p(PrtInfo,"^",15)
 	..s AdmDR=$p(OPIPInfo,"^",3)  ;..GetRowidByInput(rowid,"") 取住院的就诊号
 	..s VisitStatus=$p($g(^PAADM(AdmDR)),"^",20)
 	..s:VisitStatus="A" VisitStatus="在院"
 	..s:VisitStatus="D" VisitStatus="出院"
 	..s HospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDR)
 	..s DepID=$p(^PAADM(AdmDR),"^",4) 
	..Q:((DeptId'="")&&(DeptId'=DepID))
 	..s PAPMINO=$p(^PAPER(PAPMIID,"PAT",1),"^",1) //登记号
 	..s MediCare=##class(web.DHCINSUPortUse).IGetMrNoByPatientID(PAPMIID,"I",HospDr,"")
 	..q:(Zyh'="")&&(Zyh'=MediCare)
 	..s PaName=$p(^PAPER(PAPMIID,"ALL"),"^",1)    //姓名
 	..s DepID=$p(^PAADM(AdmDR),"^",4)  //就诊科室Dr
 	..s:DepID'="" DepDesc=$p(^CTLOC(DepID),"^",2) //科室
 	..s ADMDate=$p($g(^PAADM(AdmDR)),"^",6) //入院日期
 	..s:ADMDate'="" ADMDate=$zd(ADMDate,3)
 	..s ADMTime=$p($g(^PAADM(AdmDR)),"^",7) //入院时间
	..s:ADMTime'="" ADMTime=$zt(ADMTime,1)
	..s ADMDate=ADMDate_" "_ADMTime
	..s PRTDate=$p(PrtInfo,"^",5)
	..s:PRTDate'="" PRTDate=$zd(PRTDate,3)
	..s PRTTime=$p(PrtInfo,"^",20)
	..s:PRTTime'="" PRTTime=$zt(PRTTime,1)
	..s PRTDate=PRTDate_" "_PRTTime
	..s Amount=$p(Info,"^",4)   ; 差额 //2023-04-23 LUANZH 由之前取发票金额改为取账单金额
	..s UserDR=$p(Info,"^",2)	; 负票操作员
	..s InitPrtDate=$p(Info,"^",3)	; 负票时间
	..;q:(InitPrtDate>=EndDate)
	..;q:(InitPrtDate<=StDate)
	..s:InitPrtDate'="" InitPrtDate=$zd(InitPrtDate,3)
	..s:UserDR'="" SSUSRName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
	..;s IUDID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxEInvFlg","OP",PRTinitInvDR,"E","B",IUDID))
	..;s:IUDID="" Invno="无"
    ..;i IUDID'="" d
    ...;s objUpDetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(IUDID,0)
    ...;s Invno=objUpDetail.EinvprtNo
	..s Invno=$p($g(^DHCINVPRT(PRTinitInvDR)),"^",14)
	..do OutPutOPIPPrtByDate

	quit $$$OK
OutPutOPIPPrtByDate
	set Data=$lb(ind,MediCare,PaName,Invno,Amount,PRTDate,DepDesc,VisitStatus,SSUSRName,InitPrtDate)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Description: 根据最开始的正票 算出部分退和全退的差额
/// Debug: w ##class(web.DHCIPBillDailyPrint).GetAmountByPrtRowid("1750235")
ClassMethod GetAmountByPrtRowid(InvDr)
{
	s Amount=0,UserDr="",InitInvDR=""
	;^DHCINVPRT(0,"InitInvDR",{PRT_initInv_DR},{PRT_Rowid}) 全退的负票
	;^DHCINVPRT(0,"OldINV",{PRT_OldINV_DR},{PRT_Rowid}) 部分退正票
	i ($d(^DHCINVPRT(0,"OldINV",InvDr)))&&($d(^DHCINVPRT(0,"InitInvDR",InvDr))) d
	.s OldINV=$o(^DHCINVPRT(0,"OldINV",InvDr,""),-1)
	.s PartDHCBCIRowId=$o(^DHCBCI(0,"INV",OldINV,""),-1) //2023-04-23 LUANZH 取账单金额
	.s PartPBRowId=$p($g(^DHCBCI(PartDHCBCIRowId)),"^",2) 
	.s PartPBTotalAmount=$p($g(^DHCPB(PartPBRowId)),"^",8)
	.s InitInvDR=$o(^DHCINVPRT(0,"InitInvDR",InvDr,""),-1)
	.s DHCBCIRowId=$o(^DHCBCI(0,"INV",InitInvDR,""),-1)
	.s PBRowId=$p($g(^DHCBCI(DHCBCIRowId)),"^",2)
	.s PBTotalAmount=$p($g(^DHCPB(PBRowId)),"^",8)
	.s OldINVAmount=$p(^DHCINVPRT(OldINV),"^",16)  ; 取优惠金额还是真正金额？
	.s InitInvDRAmount=$p($g(^DHCINVPRT(InitInvDR)),"^",16) ; 取优惠金额还是真正金额？
	.s UserDr=$p(^DHCINVPRT(InitInvDR),"^",21)
	.s Amount=OldINVAmount+InitInvDRAmount
	.s NewAmount=$zabs(PartPBTotalAmount+PBTotalAmount)
	.s PRTDate=$p($g(^DHCINVPRT(InitInvDR)),"^",5)
	.;i (PRTDate<StDate)&&(PRTDate>PRTDate) s Amount=0 ; 负票不在开始结束日期节点的金额变成0
	i $d(^DHCINVPRT(0,"InitInvDR",InvDr))&&('$d(^DHCINVPRT(0,"OldINV",InvDr)))  d
	.s InitInvDR=$o(^DHCINVPRT(0,"InitInvDR",InvDr,""),-1)
	.s DHCBCIRowId=$o(^DHCBCI(0,"INV",InitInvDR,""),-1)
	.s PBRowId=$p($g(^DHCBCI(DHCBCIRowId)),"^",2)
	.s PBTotalAmount=$p($g(^DHCPB(PBRowId)),"^",8)
	.s InitInvDRAmount=$p(^DHCINVPRT(InitInvDR),"^",16) ; 取优惠金额还是真正金额？
	.s Amount=InitInvDRAmount
	.s NewAmount=$zabs(PBTotalAmount)
	.s UserDr=$p(^DHCINVPRT(InitInvDR),"^",21)
	.s PRTDate=$p($g(^DHCINVPRT(InitInvDR)),"^",5)
	.;i (PRTDate<StDate)&&(PRTDate>PRTDate) s Amount=0
	
	q Amount_"^"_UserDr_"^"_PRTDate_"^"_NewAmount
}

}
