Import SQLUser

/// 名称: web.DHCIPBillDailyCollect.cls
/// 描述: 住院收费员日报汇总业务类
/// 编写者：ZhYW
/// 编写日期: 2018-03-17
Class web.DHCIPBillDailyCollect Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2018-03-16
/// Description: 接收
/// Table: DHC_JFUSERJK, DHC_IPBillReceive
/// Input: footIdStr: 结账RowId串, sessionStr: 操作员Id^安全组Id^登录科室Id^医院Id
/// Return: rtn:错误代码, =0:成功, <>0:失败
/// Debug: w ##class(web.DHCIPBillDailyCollect).Receive("671","882")
ClassMethod Receive(footIdStr As %String, sessionStr As %String) As %String
{
	set $zt="ERROR"

	set userId=$p(sessionStr,"^",1)
    set groupId=$p(sessionStr,"^",2)
    set ctLocId=$p(sessionStr,"^",3)
    set hospId=$p(sessionStr,"^",4)
    
	//取结账的最小日期、最大日期作为接收的开始日期、结束日期
	set minDate=""
	set maxDate=""
	set count=$l(footIdStr,"^")
	for i=1:1:count {
		set footId=$p(footIdStr,"^",i)
		continue:(+footId=0)
		set footDate=$p(^DHCJFUSERJK(footId),"^",1)
		if ((minDate="")||(+footDate<+minDate)) {
			set minDate=footDate
		}
		if ((maxDate="")||(+footDate>+maxDate)) {
			set maxDate=footDate
		}
	}
	
	set stDate=minDate
	set endDate=maxDate
		
    set rtn=0
	set msg="接收成功"

    ts
    
    &SQL(
    	INSERT INTO DHC_IPBillReceive (
    		IPRec_Date, IPRec_Time, IPRec_User_DR, IPRec_StDate, IPRec_EndDate
    	)
    	VALUES (
    		CONVERT(DATE, NOW()), CONVERT(TIME, NOW()), :userId, :stDate, :endDate
    	)
    )
	set rtn=SQLCODE
	set rowId=$g(%ROWID)
	if (+rtn) {
		set msg=$g(%msg)
	}
	
	set count=$l(footIdStr,"^")
	for i=1:1:count {
		quit:(+rtn)
		set footId=$p(footIdStr,"^",i)
		continue:(+footId=0)
		set myReceiptDR=$p(^DHCJFUSERJK(footId),"^",25)
		continue:(+myReceiptDR'=0)
		&SQL(
			UPDATE DHC_JFUSERJK
			SET JK_IPReceive_DR = :rowId, JK_ReceiveFlag = 'Y'
			WHERE %ID = :footId
		)
		set rtn=SQLCODE
		if (+rtn) {
			set msg=$g(%msg)
			quit
		}
	}
	
	if (+rtn=0) {
		if ($tl>0) tc
	}else {
		tro
	}
	//保存日志 2021-04-09 tangzf start
	set obj=##class(%ArrayOfDataTypes).%New()
	set userCode=$p($g(^SSU("SSUSR",userId)),"^",1)
	set userName=$p($g(^SSU("SSUSR",userId)),"^",2)
	do obj.SetAt(userCode,"INMSGUserCode")                       //收费员工号
    do obj.SetAt(+$h,"INMSGDate")
    do obj.SetAt($p($h,",",2),"INMSGTime")
    do obj.SetAt("FEEZ-11","INMSGYWLX")
    do obj.SetAt(userName,"INMSGC1iName")
    do obj.SetAt("住院日报汇总接收"_msg,"INMSGMsg")
    do obj.SetAt("IP-02","INMSGProductLine")                      //产品线
    do obj.SetAt(hospId,"INMSGHospDr")                            //院区
    do obj.SetAt(rowId,"INMSGBusinessId")                         //业务ID
	do ##class(INSU.COM.Tools).Log(obj,"array")
	
	set json={}
	set json.msg=msg
	set json.success=rtn
	set json.rowId=rowId
	quit json.%ToJSON()

ERROR
	do ..AppException()
	set json={}
	set json.msg=$ze
	set json.success=-1
	quit json.%ToJSON()
}

/// Creator: ZhYW
/// CreatDate: 2018-03-16
/// Description: 撤销接收
/// Table: DHC_JFUSERJK, DHC_IPBillReceive
/// Input: 
/// Return: rtn:错误代码,  =0:成功, <>0:失败
/// Debug: w ##class(web.DHCIPBillDailyCollect).CancelReceive()
ClassMethod CancelReceive(receId As %String, sessionStr As %String) As %String
{
    set $zt="ERROR"
    
    set userId=$p(sessionStr,"^",1)
    set groupId=$p(sessionStr,"^",2)
    set ctLocId=$p(sessionStr,"^",3)
    set hospId=$p(sessionStr,"^",4)
    
    ts
    
	&SQL(DELETE FROM DHC_IPBillReceive WHERE %ID = :receId)
	set rtn=SQLCODE

	&SQL(SELECT count(*) INTO :num FROM DHC_JFUSERJK WHERE JK_IPReceive_DR = :receId)
	if (num>0) {
		&SQL(
			UPDATE DHC_JFUSERJK
			SET JK_IPReceive_DR = NULL, JK_ReceiveFlag = 'N'
			WHERE JK_IPReceive_DR = :receId
		)
		set rtn=rtn+SQLCODE
	}
	
	set msg="取消成功"
	if (+rtn=0) {
		tc
	}else {
		tro
		set msg="取消失败"
	}
	
	//保存日志 2021-4-9 tangzf
	set obj=##class(%ArrayOfDataTypes).%New()
	set userCode=$p($g(^SSU("SSUSR",userId)),"^",1)
	set userName=$p($g(^SSU("SSUSR",userId)),"^",2)
	do obj.SetAt(userCode,"INMSGUserCode")   //收费员工号
    do obj.SetAt(+$h,"INMSGDate")
    do obj.SetAt($p($h,",",2),"INMSGTime")
    do obj.SetAt("FEEZ-11","INMSGYWLX")
    do obj.SetAt(userName,"INMSGC1iName")
    do obj.SetAt("住院日报汇总撤销接收"_msg,"INMSGMsg")
    do obj.SetAt("IP-02","INMSGProductLine")  //产品线
    do obj.SetAt(hospId,"INMSGHospDr")        //院区
    do obj.SetAt(receId,"INMSGBusinessId")    //业务ID
	do ##class(INSU.COM.Tools).Log(obj, "array")
	
	set json={}
	set json.msg=msg
	set json.success=rtn
	quit json.%ToJSON()

ERROR
	do ..AppException()
	set json={}
	set json.msg=$ze
	set json.success=-1
	quit json.%ToJSON()
}

/// Creator: ZhYW
/// CreatDate: 2018-03-17
/// Description: 住院日结汇总查询
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillDailyCollect","FindDailyCollect", "2022-04-27","2022-04-27","","","2","241","20")
Query FindDailyCollect(stDate As %String, endDate As %String, guserStr As %Text, receId As %String, hospDR As %String, groupDR As %String, langId As %String = "", verifyStatus As %String = "") As websys.Query(ROWSPEC = "TRowId:%String,TUserId:%String,TUserName:%String,TDate:%String,TTime:%String,TStDate:%String,TStTime:%String,TEndDate:%String,TEndTime:%String,TReceId:%String,TNorDepNum:%String,TNorDepSum:%String,TNorDepRcptNoStr:%String,TParkDepNum:%String,TParkDepSum:%String,TParkDepRcptNoStr:%String,TRefDepNum:%String,TRefDepSum:%String,TRefDepRcptNoStr:%String,TInvNum:%String,TInvSum:%String,TInvNoStr:%String,TParkInvNum:%String,TParkInvSum:%String,TParkInvNoStr:%String,TRefInvNum:%String,TRefInvSum:%String,TRefInvNoStr:%String,TVoidDepNum:%String,TVoidDepNoStr:%String,TVoidInvNum:%String,TVoidInvNoStr:%String,verifyStatus:%String")
{
}

ClassMethod FindDailyCollectExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, guserStr As %Text, receId As %String, hospDR As %String, groupDR As %String, langId As %String = "", verifyStatus As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
	set ^TMP("FindDailyCollect")=$lb(stDate, endDate, guserStr, receId, hospDR, groupDR, langId,verifyStatus)
	if ((stDate="")||(endDate="")) quit $$$OK
	
 	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}

 	set job=$j
	
 	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
 	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
 	
	set (norDepTotalNum, norDepTotalSum, parkDepTotalNum, parkDepTotalSum, refDepTotalNum, refDepTotalSum)=0
	set (invTotalNum, invTotalSum, parkInvTotalNum, parkInvTotalSum, refInvTotalNum, refInvTotalSum)=0
	set (voidDepTotalNum, voidInvTotalNum)=0
	
	//收费组长接收标识
	set baseConfig=##class(web.UDHCOPGSConfig).ReadCFByGRowID(groupDR, hospDR)
	set receConfig=$p(baseConfig,"^",21)

	if (receConfig=1) do
	.if (receId="") do
	..//查询未接收结账记录
	..set footId=0
	..for  set footId=$o(^DHCJFUSERJK(0,"RECEIVEFLAG","N",footId)) quit:(footId="")  do
	...set footData=$g(^DHCJFUSERJK(footId))
	...quit:(footData="")
	...set footDate=$p(footData,"^",1)
	...quit:((endDate'="")&&(footDate>endDate))
	...set userDR=$p(footData,"^",5)
 	...quit:((guserStr'="")&&(("^"_guserStr_"^")'[("^"_userDR_"^")))             //按收费员过滤
 	...set footHospDR=$p(footData,"^",27)    //wangjian 2018-11-02
	...quit:((footHospDR'=hospDR)&&(hospDR'=""))
	...set tverifyStatus=$p(footData,"^",31)
	...quit:(verifyStatus'="3")&&(verifyStatus'=tverifyStatus) // 核销状态过滤 XiaoShuai
	...do GetCollectInfo
	.else  do
	..//查询已接收结账记录
	..set footId=0
	..for  set footId=$o(^DHCJFUSERJK(0,"RECEIVEDR",receId,footId)) quit:(footId="")  do
	...set footData=$g(^DHCJFUSERJK(footId))
	...quit:(footData="")
	...set userDR=$p(footData,"^",5)
 	...quit:((guserStr'="")&&(("^"_guserStr_"^")'[("^"_userDR_"^")))             //按收费员过滤
 	...set footHospDR=$p(footData,"^",27)   //wangjian 2018-11-02
	...quit:((footHospDR'=hospDR)&&(hospDR'=""))
	...set tverifyStatus=$p(footData,"^",31)
	...quit:(verifyStatus'="3")&&(verifyStatus'=tverifyStatus) // 核销状态过滤 XiaoShuai 
	...do GetCollectInfo
	else  do
	.//不接收时按照日期查询
	.for date=stDate:1:endDate  do
	..set footId=0
	..for  set footId=$o(^DHCJFUSERJK(0,"date",date,footId)) quit:(footId="")  do
	...set footData=$g(^DHCJFUSERJK(footId))
	...quit:(footData="")
	...set userDR=$p(footData,"^",5)
 	...quit:((guserStr'="")&&(("^"_guserStr_"^")'[("^"_userDR_"^")))             //按收费员过滤
 	...set footHospDR=$p(footData,"^",27)     //wangjian 2018-11-02
	...quit:((footHospDR'=hospDR)&&(hospDR'=""))
	...set tverifyStatus=$p(footData,"^",31)
	...quit:(verifyStatus'="3")&&(verifyStatus'=tverifyStatus) // 核销状态过滤 XiaoShuai
	...do GetCollectInfo
	
	set (footId,userDR,footDate,footTime,footStDate,footStTime,footEndDate,footEndTime,footReceDR,norDepRcptNoStr,parkDepRcptNoStr,refDepRcptNoStr,invNoStr,parkInvNoStr,refInvNoStr,voidDepNoStr,voidInvNoStr)=""
	set userName=##class(websys.Translation).Get("", "合计")
	set norDepNum=norDepTotalNum
	set norDepSum=$fn(norDepTotalSum,"",2)
	set parkDepNum=parkDepTotalNum
	set parkDepSum=$fn(parkDepTotalSum,"",2)
	set refDepNum=refDepTotalNum
	set refDepSum=$fn(refDepTotalSum,"",2)
	set invNum=invTotalNum
	set invSum=$fn(invTotalSum,"",2)
	set parkInvNum=parkInvTotalNum
	set parkInvSum=$fn(parkInvTotalSum,"",2)
	set refInvNum=refInvTotalNum
	set refInvSum=$fn(refInvTotalSum,"",2)
	set voidDepNum=voidDepTotalNum
	set voidInvNum=voidInvTotalNum
 	do OutputDailyCollect

 	quit $$$OK

GetCollectInfo
	set userName=$p(^SSU("SSUSR",userDR),"^",2)
	set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
	set footDate=$p(footData,"^",1)
	set footStDate=$p(footData,"^",3)               //JK_StDate
	set footStTime=$p(footData,"^",11)              //JK_StTime
	set footEndDate=$p(footData,"^",4)              //JK_EndDate
	set footEndTime=$p(footData,"^",12)             //JK_EndTime
	set footTime=$p(footData,"^",2)                 //JK_Time
	set footReceDR=$p(footData,"^",25)              //JK_IPReceive_DR
	set footDate=##class(websys.Conversions).DateLogicalToHtml(footDate)
	set footTime=##class(websys.Conversions).TimeLogicalToHtml(footTime)
 	set footStDate=##class(websys.Conversions).DateLogicalToHtml(footStDate)
 	set footStTime=##class(websys.Conversions).TimeLogicalToHtml(footStTime)
 	set footEndDate=##class(websys.Conversions).DateLogicalToHtml(footEndDate)
 	set footEndTime=##class(websys.Conversions).TimeLogicalToHtml(footEndTime)

	kill ^||TMP("IPBILL",job,userDR)
	
 	//押金信息
	set depRowId=0
	for  set depRowId=$o(^DHCSFPRINTDETAIL(0,"JKDR",footId,depRowId)) quit:(depRowId="")  do    
	.set depData=$g(^DHCSFPRINTDETAIL(depRowId))
	.quit:(depData="")
	.set rcptNo=$p(depData,"^",1)
	.set payAmt=$p(depData,"^",6)
	.set payAmt=$fn(payAmt,"",2)
	.set prtStatus=$p(depData,"^",8)
	.set initDepDR=$p(depData,"^",43)
	.set initRcptNo=rcptNo
	.if ((initRcptNo="")&&(+initDepDR'=0)) do
	..set initRcptNo=$p($g(^DHCSFPRINTDETAIL(initDepDR)),"^",1)          //负记录不走号时取原记录收据号
	.if (" 1 4 "[(" "_+prtStatus_" ")) do
	..if (rcptNo'="") do
	...set ^||TMP("IPBILL",job,userDR,"NORRCPTNO",rcptNo)=""
	..set ^||TMP("IPBILL",job,userDR,"NORRCPTNUM")=$i(^||TMP("IPBILL",job,userDR,"NORRCPTNUM"))
	..set ^||TMP("IPBILL",job,userDR,"NORRCPTAMT")=$g(^||TMP("IPBILL",job,userDR,"NORRCPTAMT"))+payAmt
	.if ((+prtStatus=2)&&(+initDepDR'=0)) do
	..if (initRcptNo'="") do
	...if ('$d(^||TMP("IPBILL",job,userDR,"PARKRCPTNO")))  do
	....set ^||TMP("IPBILL",job,userDR,"PARKRCPTNO")=initRcptNo
	...else  do
	....set ^||TMP("IPBILL",job,userDR,"PARKRCPTNO")=$g(^||TMP("IPBILL",job,userDR,"PARKRCPTNO"))_", "_initRcptNo
	..set ^||TMP("IPBILL",job,userDR,"PARKRCPTNUM")=$i(^||TMP("IPBILL",job,userDR,"PARKRCPTNUM"))
	..set ^||TMP("IPBILL",job,userDR,"PARKRCPTAMT")=$g(^||TMP("IPBILL",job,userDR,"PARKRCPTAMT"))+payAmt
	.if ((+prtStatus=3)&&(+initDepDR'=0)) do
	..if (initRcptNo'="") do
	...if ('$d(^||TMP("IPBILL",job,userDR,"REFRCPTNO"))) do
	....set ^||TMP("IPBILL",job,userDR,"REFRCPTNO")=initRcptNo
	...else  do
	....set ^||TMP("IPBILL",job,userDR,"REFRCPTNO")=$g(^||TMP("IPBILL",job,userDR,"REFRCPTNO"))_", "_initRcptNo
	..set ^||TMP("IPBILL",job,userDR,"REFRCPTNUM")=$i(^||TMP("IPBILL",job,userDR,"REFRCPTNUM"))
	..set ^||TMP("IPBILL",job,userDR,"REFRCPTAMT")=$g(^||TMP("IPBILL",job,userDR,"REFRCPTAMT"))+payAmt

 	set norDepNum=+$g(^||TMP("IPBILL",job,userDR,"NORRCPTNUM"))
	set norDepTotalNum=$i(norDepTotalNum, norDepNum)
	set norDepSum=$fn($g(^||TMP("IPBILL",job,userDR,"NORRCPTAMT")),"",2)
	set norDepTotalSum=$i(norDepTotalSum, norDepSum)
	set norDepRcptNoStr=##class(web.DHCBillCommon).GetInvNoInfo("^||TMP", "IPBILL", job, userDR, "NORRCPTNO")
 	set parkDepNum=+$g(^||TMP("IPBILL",job,userDR,"PARKRCPTNUM"))
	set parkDepTotalNum=$i(parkDepTotalNum, parkDepNum)
	set parkDepSum=$fn($g(^||TMP("IPBILL",job,userDR,"PARKRCPTAMT")),"",2)
	set parkDepTotalSum=$i(parkDepTotalSum, parkDepSum)
	set parkDepRcptNoStr=$g(^||TMP("IPBILL",job,userDR,"PARKRCPTNO"))
 	set refDepNum=+$g(^||TMP("IPBILL",job,userDR,"REFRCPTNUM"))
	set refDepTotalNum=$i(refDepTotalNum, refDepNum)
	set refDepSum=$fn($g(^||TMP("IPBILL",job,userDR,"REFRCPTAMT")),"",2)
	set refDepTotalSum=$i(refDepTotalSum, refDepSum)
	set refDepRcptNoStr=$g(^||TMP("IPBILL",job,userDR,"REFRCPTNO"))
	
	//发票信息
	set invRowId=0
	for  set invRowId=$o(^DHCINVPRTZY(0,"JK",footId,invRowId)) quit:(invRowId="")  do
	.set invData=$g(^DHCINVPRTZY(invRowId))
	.quit:(invData="")
	.set invNo=$p(invData,"^",1)
	.set invAmt=+$p(invData,"^",6)
	.set invAmt=$fn(invAmt,"",2)
	.set invFlag=$p(invData,"^",8)
	.set initInvDR=$p(invData,"^",13)
	.do BuildInvNoInfo
	
	//集中打印发票信息
	set spiRowId=0
	for  set spiRowId=$o(^BILL.IP.SummaryPrtInvI("RepDR",footId,spiRowId)) quit:(spiRowId="")  do
	.set spiData=$g(^BILL.IP.SummaryPrtInvD(spiRowId))
	.set invNo=$lg(spiData,2)
	.set invFlag=$lg(spiData,6)
	.set initInvDR=$lg(spiData,9)
	.set invAmt=##class(web.DHCIPBillDailyDetails).GetSPInvSumByID(spiRowId)
	.do BuildSumInvNoInfo
	
	set invNum=+$g(^||TMP("IPBILL",job,userDR,"AllINVNUM"))
	set invTotalNum=$i(invTotalNum, invNum)
 	set invSum=$fn($g(^||TMP("IPBILL",job,userDR,"ALLINVAMT")),"",2)
	set invTotalSum=$i(invTotalSum, invSum)
	set invNoStr=##class(web.DHCBillCommon).GetInvNoInfo("^||TMP", "IPBILL", job, userDR, "AllINVNO")
 	set parkInvNum=+$g(^||TMP("IPBILL",job,userDR,"PARKINVNUM"))
	set parkInvTotalNum=$i(parkInvTotalNum, parkInvNum)
 	set parkInvSum=$fn($g(^||TMP("IPBILL",job,userDR,"PARKINVAMT")),"",2)
	set parkInvTotalSum=$i(parkInvTotalSum, parkInvSum)
	set parkInvNoStr=$g(^||TMP("IPBILL",job,userDR,"PARKINVNO"))
 	set refInvNum=+$g(^||TMP("IPBILL",job,userDR,"REFINVNUM"))
	set refInvTotalNum=$i(refInvTotalNum, refInvNum)
 	set refInvSum=$fn($g(^||TMP("IPBILL",job,userDR,"REFINVAMT")),"",2)
	set refInvTotalSum=$i(refInvTotalSum, refInvSum)
	set refInvNoStr=$g(^||TMP("IPBILL",job,userDR,"REFINVNO"))

 	//跳号信息
 	set voidDepNum=0
 	set voidDepNoStr=""
	set voidInvNum=0
 	set voidInvNoStr=""
 	set voidId=0
 	for  set voidId=$o(^DHCVoidInv(0,"RepDr",footId,voidId)) quit:(voidId="")  do
 	.set voidInvData=$g(^DHCVoidInv(voidId))
 	.quit:(voidInvData="")
 	.set invType=$p(voidInvData,"^",11)
 	.quit:(invType'["I")
 	.set invNo=$p(voidInvData,"^",3)
 	.if (invType="ID") do
 	..set voidDepNum=$i(voidDepNum)
 	..set voidDepNoStr=$s((voidDepNoStr=""):invNo,1:(voidDepNoStr_", "_invNo))
 	.else  if (invType="IP") do
 	..set voidInvNum=$i(voidInvNum)
 	..set voidInvNoStr=$s((voidInvNoStr=""):invNo,1:(voidInvNoStr_", "_invNo))
 	set voidDepTotalNum=$i(voidDepTotalNum, voidDepNum)
 	set voidInvTotalNum=$i(voidInvTotalNum, voidInvNum)
	
	kill ^||TMP("IPBILL",job,userDR)
	
	do OutputDailyCollect

	quit
	
BuildInvNoInfo
	set initInvNo=invNo
	if ((initInvNo="")&&(+initInvDR'=0)) do
	.set initInvNo=$p(^DHCINVPRTZY(initInvDR),"^",1)          //负记录不走号时取原记录发票号
	if (invNo'="") do
	.set ^||TMP("IPBILL",job,userDR,"AllINVNO",invNo)=""                                                  
	.set ^||TMP("IPBILL",job,userDR,"AllINVNUM")=$i(^||TMP("IPBILL",job,userDR,"AllINVNUM"))          //存储门诊收费发票张数
	.set ^||TMP("IPBILL",job,userDR,"ALLINVAMT")=$g(^||TMP("IPBILL",job,userDR,"ALLINVAMT"))+invAmt   //存储门诊收费发票金额(作废发票不统计,取消结算的统计)
	if (invFlag="A")&&((+initInvDR'=0)) do
	.if (initInvNo'="") do
	..quit:((", "_$g(^||TMP("IPBILL",job,userDR,"PARKINVNO"))_", ")[(", "_initInvNo_", "))
	..if ('$d(^||TMP("IPBILL",job,userDR,"PARKINVNO"))) do
	...set ^||TMP("IPBILL",job,userDR,"PARKINVNO")=initInvNo
	..else  do
	...set ^||TMP("IPBILL",job,userDR,"PARKINVNO")=$g(^||TMP("IPBILL",job,userDR,"PARKINVNO"))_", "_initInvNo
	..set ^||TMP("IPBILL",job,userDR,"PARKINVNUM")=$i(^||TMP("IPBILL",job,userDR,"PARKINVNUM"))
	..set ^||TMP("IPBILL",job,userDR,"PARKINVAMT")=$g(^||TMP("IPBILL",job,userDR,"PARKINVAMT"))+invAmt         //存储门诊收费作废金额
	if ((invFlag="S")&&(+initInvDR'=0)) do
	.if (initInvNo'="") do
	..quit:((", "_$g(^||TMP("IPBILL",job,userDR,"REFINVNO"))_", ")[(", "_initInvNo_", "))
	..if ('$d(^||TMP("IPBILL",job,userDR,"REFINVNO"))) do
	...set ^||TMP("IPBILL",job,userDR,"REFINVNO")=initInvNo
	..else  do
	...set ^||TMP("IPBILL",job,userDR,"REFINVNO")=$g(^||TMP("IPBILL",job,userDR,"REFINVNO"))_", "_initInvNo
	..set ^||TMP("IPBILL",job,userDR,"REFINVNUM")=$i(^||TMP("IPBILL",job,userDR,"REFINVNUM"))
	..set ^||TMP("IPBILL",job,userDR,"REFINVAMT")=$g(^||TMP("IPBILL",job,userDR,"REFINVAMT"))+invAmt          //存储门诊收费红冲金额
 	
 	quit

BuildSumInvNoInfo
	set initInvNo=invNo
	if ((initInvNo="")&&(+initInvDR'=0)) do
	.set initInvNo=$lg(^BILL.IP.SummaryPrtInvD(initInvDR),2)          //负记录不走号时取原记录发票号
	if (invNo'="") do
	.set ^||TMP("IPBILL",job,userDR,"AllINVNO",invNo)=""                                                  
	.set ^||TMP("IPBILL",job,userDR,"AllINVNUM")=$i(^||TMP("IPBILL",job,userDR,"AllINVNUM"))          //存储门诊收费发票张数
	.set ^||TMP("IPBILL",job,userDR,"ALLINVAMT")=$g(^||TMP("IPBILL",job,userDR,"ALLINVAMT"))+invAmt   //存储门诊收费发票金额(作废发票不统计,取消结算的统计)
	if (invFlag="A")&&((+initInvDR'=0)) do
	.if (initInvNo'="") do
	..quit:((", "_$g(^||TMP("IPBILL",job,userDR,"PARKINVNO"))_", ")[(", "_initInvNo_", "))
	..if ('$d(^||TMP("IPBILL",job,userDR,"PARKINVNO"))) do
	...set ^||TMP("IPBILL",job,userDR,"PARKINVNO")=initInvNo
	..else  do
	...set ^||TMP("IPBILL",job,userDR,"PARKINVNO")=$g(^||TMP("IPBILL",job,userDR,"PARKINVNO"))_", "_initInvNo
	..set ^||TMP("IPBILL",job,userDR,"PARKINVNUM")=$i(^||TMP("IPBILL",job,userDR,"PARKINVNUM"))
	..set invAmt=-invAmt   //集中打印发票作废时，并没有取消结算，关联的金额还是原结算金额，故这里将红冲金额取负
	..set ^||TMP("IPBILL",job,userDR,"PARKINVAMT")=$g(^||TMP("IPBILL",job,userDR,"PARKINVAMT"))+invAmt         //存储门诊收费作废金额
	if ((invFlag="S")&&(+initInvDR'=0)) do
	.if (initInvNo'="") do
	..quit:((", "_$g(^||TMP("IPBILL",job,userDR,"REFINVNO"))_", ")[(", "_initInvNo_", "))
	..if ('$d(^||TMP("IPBILL",job,userDR,"REFINVNO"))) do
	...set ^||TMP("IPBILL",job,userDR,"REFINVNO")=initInvNo
	..else  do
	...set ^||TMP("IPBILL",job,userDR,"REFINVNO")=$g(^||TMP("IPBILL",job,userDR,"REFINVNO"))_", "_initInvNo
	..set ^||TMP("IPBILL",job,userDR,"REFINVNUM")=$i(^||TMP("IPBILL",job,userDR,"REFINVNUM"))
	..set invAmt=-invAmt    //集中打印发票红冲时，并没有取消结算，关联的金额还是原结算金额，故这里将红冲金额取负
	..set ^||TMP("IPBILL",job,userDR,"REFINVAMT")=$g(^||TMP("IPBILL",job,userDR,"REFINVAMT"))+invAmt          //存储门诊收费红冲金额
	
	quit
	
OutputDailyCollect
 	set Data=$lb(footId,userDR,userName,footDate,footTime,footStDate,footStTime,footEndDate,footEndTime,footReceDR,norDepNum,norDepSum,norDepRcptNoStr,parkDepNum,parkDepSum,parkDepRcptNoStr,refDepNum,refDepSum,refDepRcptNoStr,invNum,invSum,invNoStr,parkInvNum,parkInvSum,parkInvNoStr,refInvNum,refInvSum,refInvNoStr,voidDepNum,voidDepNoStr,voidInvNum,voidInvNoStr,tverifyStatus)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
 	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-12-06
/// Description: 生成日结汇总接收记录树
/// Input: 
/// Output: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillDailyCollect).BuildReceiveTree(671)
ClassMethod BuildReceiveTree(guser As %String, langId As %String = "") As %String
{
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	set lastDate=""
	kill receList
	set receId=0
	while($o(^DHCIPBILLRECEIVEi(0,"USERDR",guser,receId))) {
		set receId=$o(^DHCIPBILLRECEIVEi(0,"USERDR",guser,receId))
		set receData=$g(^DHCIPBILLRECEIVE(receId))
		continue:(receData="")
		set receDate=$p(receData,"^",1)
		if (+receDate>+lastDate) {
			set lastDate=receDate
		}
		set year=$SYSTEM.SQL.YEAR(receDate)
		set month=$SYSTEM.SQL.MONTH(receDate)
		set day=$SYSTEM.SQL.DAYOFMONTH(receDate)
		set receList(year,month,day,receId)=""
	}
	
	if (+lastDate=0) {
		set lastDate=+$h
	}
	set lastYear=$SYSTEM.SQL.YEAR(lastDate)
	set lastMonth=$SYSTEM.SQL.MONTH(lastDate)
	set lastDay=$SYSTEM.SQL.DAYOFMONTH(lastDate)
	
	set o=[]
	set year=0
	while($o(receList(year))) {
		set year=$o(receList(year))
		set y={}
		set y.text=year_##class(websys.Translation).Get("", "年", langId)
		set y.state=$s((year=lastYear):"open",1:"closed")
		set yc=[]
		set month=0
		while($o(receList(year,month))) {
			set month=$o(receList(year,month))
			set m={}
			set m.text=month_##class(websys.Translation).Get("", "月", langId)
			set m.state=$s(((year_month)=(lastYear_lastMonth)):"open",1:"closed")
			do yc.%Push(m)
			set mc=[]
			set day=0
			while($o(receList(year,month,day))) {
				set day=$o(receList(year,month,day))
				set d={}
				set d.text=day_##class(websys.Translation).Get("", "日", langId)
				//set d.state=$s(((year_month_day)=(lastYear_lastMonth_lastDay)):"open",1:"closed")
				set d.state="closed"
				do mc.%Push(d)
				set dc=[]
				set receId=0
				while($o(receList(year,month,day,receId))) {
					set receId=$o(receList(year,month,day,receId))
					set receData=$g(^DHCIPBILLRECEIVE(receId))
					set stDate=$p(receData,"^",4)
					set endDate=$p(receData,"^",5)
					set stDate=##class(websys.Conversions).DateLogicalToHtml(stDate)
					set endDate=##class(websys.Conversions).DateLogicalToHtml(endDate)
					set r={}
					set r.id=receId
					set r.text=##class(websys.Translation).Get("", "接收号", langId)_"："_receId
					set p={}
					set p.stDate=stDate
					set p.endDate=endDate
					set r.attributes=p
					do dc.%Push(r)
				}
				set d.children=dc
			}
			set m.children=mc
		}
		set y.children=yc
		do o.%Push(y)
	}
	
	set stream=##class(%Stream.GlobalCharacter).%New()
	do o.%ToJSON(.stream)
	do stream.OutputToDevice()
	
	quit ""
}

/// Creator: XiaoShuai
/// CreatDate: 2022-07-05
/// Description: 日结数据核销
/// Table: DHC_JFUSERJK
/// Input: guser: 结算人, footIdStr: 结账RowId串 Status: 核销状态(1:核销 -1:取消核销)
/// Return: rtn:错误代码, =0:成功, <>0:失败
/// Debug: w ##class(web.DHCIPBillDailyCollect).Verify("5","46007^46008","1")
ClassMethod Verify(guser As %String, footIdStr As %String, Status As %String) As %String
{
	set $zt="ERROR"

	set verifyDate=+$h
	set verifyTime=$p($h,",",2)
	
	set rtn=0
	set msg="成功"

    ts
    
	set count=$l(footIdStr,"^")
	for i=1:1:count {
		set footId=$p(footIdStr,"^",i)
		continue:(+footId=0)
		set VerifyStatus=$p($g(^DHCJFUSERJK(footId)),"^",31)
		//continue:(VerifyStatus=Status)				 //如果相同状态的则过滤掉 XiaoShuai 2022-07-05
		&SQL(
			UPDATE DHC_JFUSERJK
			SET JK_VerifyDate = :verifyDate, JK_VerifyTime = :verifyTime, JK_VerifyUser = :guser, JK_VerifyStatus=:Status
			WHERE %ID = :footId
		)
		set rtn=SQLCODE
		if (rtn) {
			set msg=$g(%msg)
			quit
		}
	}
	if (+rtn=0) {
		if ($tl>0) tc
	}else {
		tro
	}
	
	set json={}
	set json.msg=msg
	set json.success=rtn
	quit json.%ToJSON()
	
ERROR
	do ..AppException()
	set json={}
	set json.msg=$ze
	set json.success=-1
	quit json.%ToJSON()
}

/// 校验是否预接收
ClassMethod CheckPreRec(guser As %String, footIdStr As %String)
{
	
	set $zt="ERROR"
	set count=$l(footIdStr,"^")
	set err = "0"
	set count=$l(footIdStr,"^")
	for i=1:1:count  quit:(+err'=0)  do
	.set footId=$p(footIdStr,"^",i)
	.quit:(+footId=0)
	.s preflag=$p(^DHCJFUSERJK(footId),"^",31)
	.s:preflag'="1" err=-footId
	
	quit err
ERROR
	do ..AppException()
	set json={}
	set json.msg=$ze
	set json.success=-1
	quit json.%ToJSON()
}

}
