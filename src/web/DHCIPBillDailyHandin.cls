Import SQLUser

/// 名称: web.DHCIPBillDailyHandin.cls
/// 描述: 住院收费员日报业务类
/// 编写者：ZhYW
/// 编写日期: 2017-11-22
Class web.DHCIPBillDailyHandin Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2017-11-22
/// Description: 收费员日报结算业务
/// Input: guser:SS_User.RowID, hospDR:CT_Hospital.RowID, footInfo:"开始日期^开始时间^结束日期^结束时间"
/// Return: rtn_"^"_footId, rtn:结算成功标识,=0结算成功, <>0结算失败. JKRowID:DHC_JFUSERJK.RowID
/// Debug: w ##class(web.DHCIPBillDailyHandin).Handin("671","2","2018-01-02^16:46:51^2018-02-01^16:23:44")
ClassMethod Handin(guser As %String, hospDR As %String, footInfo As %String) As %String
{
	set $zt="ERROR"

	set stDate=$p(footInfo,"^",1)
	set stTime=$p(footInfo,"^",2)
	set endDate=$p(footInfo,"^",3)
	set endTime=$p(footInfo,"^",4)
	set autoFlag=$p(footInfo,"^",5)         //自动结账任务标识,(="Y":任务结账, <>"Y":手工结账)
		
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime, 1)
	set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime, 1)
	
	set jkDate=+$h
	set jkTime=$p($h,",",2)
	//自动结账任务时,结账时间取结束时间
	if (autoFlag="Y") {
		set jkDate=endDate
		set jkTime=endTime
	}
	//+2019-12-11 ZhYW 取日结结束时间配置
	set rtn=0
	set handinEndTime=..GetConfHandinEndTime(hospDR)
	if (handinEndTime'="") {
		if ((endDate>stDate)&&(stTime<handinEndTime)) {
			set endDate=stDate
			set endTime=handinEndTime
		}else {
			set endTime=$s(((+endTime)>(+handinEndTime)):handinEndTime, 1:endTime)
		}
		set rtn=..CheckIsHandedAtEndTime(guser, endDate, endTime, hospDR)    //验证该收费员此时有没有做过日结, 做过日结则不允许再结算
		quit:(+rtn) -1_"^"_"在系统配置时间已结账, 当天不能再次结账"
	}

	set secondDiff=$SYSTEM.SQL.DATEDIFF("ss", stDate_","_stTime, endDate_","_endTime)
	quit:(secondDiff<0) -1_"^"_"开始时间不能大于结束时间"
	
	set secondDiff=$SYSTEM.SQL.DATEDIFF("ss", endDate_","_endTime, $h)
	quit:(secondDiff<0) -1_"^"_"结束时间不能大于当前时间"
	
	set rtn=..GetDepNOAndInvNOInfo(guser, stDate, stTime, endDate, endTime, jkDate, jkTime, hospDR)
	set depInfo=$p(rtn,"#",1)
    set invInfo=$p(rtn,"#",2)
	
    set normalDepNoStr=$p(depInfo,"^",1), normalDepNum=$p(depInfo,"^",2)
    set strikeDepNoStr=$p(depInfo,"^",3), strikeDepNum=$p(depInfo,"^",4)
    set abortDepNoStr=$p(depInfo,"^",5), abortDepNum=$p(depInfo,"^",6)
    
    set normalInvNoStr=$p(invInfo,"^",1), normalInvNum=$p(invInfo,"^",2)
	set strikeInvNoStr=$p(invInfo,"^",3), strikeInvNum=$p(invInfo,"^",4)
    set abortInvNoStr=$p(invInfo,"^",5), abortInvNum=$p(invInfo,"^",6)
	
	ts
	
	&SQL(
		INSERT INTO DHC_JFUSERJK (
			JK_Date, JK_Time, JK_StDate, JK_EndDate, JK_User,
			JK_Flag, JK_StTime, JK_EndTime, JK_NormalDepNO, JK_StrikeDepNO,
			JK_AbortDepNO, JK_NormalDepNum, JK_StrikeDepNum, JK_AbortDepNum, JK_NormalInvNO,
			JK_StrikeInvNO, JK_AbortInvNO, JK_NormalInvNum, JK_StrikeInvNum, JK_AbortInvNum,
			JK_ReceiveFlag, JK_Hospital_DR
		)
		VALUES (
			:jkDate, :jkTime, :stDate, :endDate, :guser,
			'Single', :stTime, :endTime, :normalDepNoStr, :strikeDepNoStr,
			:abortDepNoStr, :normalDepNum, :strikeDepNum, :abortDepNum, :normalInvNoStr,
			:strikeInvNoStr, :abortInvNoStr, :normalInvNum, :strikeInvNum, :abortInvNum,
			'N', :hospDR
		)
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	set jkRowId=$g(%ROWID)
	
	for date=stDate:1:endDate  {
		//更新押金表
		set depRowID=0
		while($o(^DHCSFPRINTDETAIL(0,"PrtDate",date,depRowID))) {
			set depRowID=$o(^DHCSFPRINTDETAIL(0,"PrtDate",date,depRowID))
			set depData=$g(^DHCSFPRINTDETAIL(depRowID))
			continue:(depData="")
			set prtUserDR=$p(depData,"^",14)
			continue:(prtUserDR'=guser)
			set prtTime=$p(depData,"^",3)
			continue:((date=endDate)&&(prtTime>endTime))
		    set depHospDR=$p(depData,"^",44)    //wangjian 2018-10-15
		    continue:(hospDR'=depHospDR)
			set jkDR=$p(depData,"^",30)
			continue:(+jkDR'=0)
			&SQL(
				UPDATE dhc_sfprintdetail
				SET prt_jkuser_dr = :guser, prt_jkflag= 'Y', prt_jkdate = :jkDate, prt_jktime = :jkTime, prt_jk_dr = :jkRowId
				WHERE %ID = :depRowID
			)
			set rtn=SQLCODE
			if (rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
		quit:(+rtn)
		
		//更新发票表
		set invRowID=0
		while($o(^DHCINVPRTZY(0,"DATE",date,invRowID))) {
			set invRowID=$o(^DHCINVPRTZY(0,"DATE",date,invRowID))
			set invData=$g(^DHCINVPRTZY(invRowID))
			continue:(invData="")
			set prtUserDR=$p(invData,"^",7)
			continue:(prtUserDR'=guser)
			set prtTime=$p(invData,"^",3)
			continue:((date=endDate)&&(prtTime>endTime))
			set prtHospDR=$p(invData,"^",35)  //wangjian 2018-10-15
		    continue:(hospDR'=prtHospDR)
			set jkDR=$p(invData,"^",23)
			continue:(+jkDR'=0)
			&SQL(
				UPDATE DHC_INVPRTZY
				SET PRT_Handin = 'Y', PRT_HandDate = :jkDate, PRT_HandTime = :jkTime, PRT_JK_DR = :jkRowId
			 	WHERE %ID = :invRowID
			)
			set rtn=SQLCODE
			if (rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
		quit:(+rtn)
		
		//更新跳号表
		set voidId=0
		while($o(^DHCVoidInv(0,"UserDate",guser,date,voidId))) {
			set voidId=$o(^DHCVoidInv(0,"UserDate",guser,date,voidId))
			set voidData=$g(^DHCVoidInv(voidId))
			continue:(voidData="")
			set voidFootDR=$p(voidData,"^",6)
			continue:(+voidFootDR'=0)
			set voidHospDR=$p(voidData,"^",12)
			continue:(hospDR'=voidHospDR)
			set voidTime=$p(voidData,"^",2)
			continue:((date=endDate)&&(voidTime>endTime))
			set voidType=$p(voidData,"^",11)     //VOI_Type
			continue:(voidType'["I")             //过滤非住院跳号发票记录
			&SQL(
				UPDATE DHC_VoidInv
				SET VOI_Report_DR = :jkRowId, VOI_Handin = 'Y', VOI_HandDate = :jkDate, VOI_handTime = :jkTime
				WHERE %ID = :voidId
			)
			set rtn=SQLCODE
			if (rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
		quit:(+rtn)
		
		//更新欠费结算表
		set QFRowId=0
		while($o(^DHCJFQFTOTAL(0,"Date",date,QFRowId))) {
			set QFRowId=$o(^DHCJFQFTOTAL(0,"Date",date,QFRowId))
			set QFData=$g(^DHCJFQFTOTAL(QFRowId))
			continue:(QFData="")
			set QFUserDR=$p(QFData,"^",6)
			continue:(QFUserDR'=guser)
			set QFTime=$p(QFData,"^",3)
			continue:((date=endDate)&&(QFTime>endTime))
			set QFHospDR=$p(QFData,"^",18)
			continue:(hospDR'=QFHospDR)
			set QFJKDR=$p(QFData,"^",17)
			continue:(+QFJKDR'=0)
			&SQL(
				UPDATE DHC_JFQFTotal
				SET QF_JK_DR = :jkRowId, QF_HandIn = 'Y', QF_HandinDate = :jkDate, QF_HandinTime = :jkTime
				WHERE %ID = :QFRowId
			)
			set rtn=SQLCODE
			if (rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
		quit:(+rtn)
		
		//更新集中打印发票表
		set spiRowId=0
		while($o(^BILL.IP.SummaryPrtInvI("PrtDate",date,spiRowId))) {
			set spiRowId=$o(^BILL.IP.SummaryPrtInvI("PrtDate",date,spiRowId))
			set spiData=$g(^BILL.IP.SummaryPrtInvD(spiRowId))
			set spiUserDR=$lg(spiData,5)
			continue:(spiUserDR'=guser)
			set spiTime=$lg(spiData,8)
			continue:((date=endDate)&&(spiTime>endTime))
			set spiHospDR=$lg(spiData,14)
		    continue:(hospDR'=spiHospDR)
			set jkDR=$lg(spiData,13)
			continue:(+jkDR'=0)
			&SQL(
				UPDATE BILL_IP.SummaryPrtInv
				SET SPI_Handin = 'Y', SPI_HandDate = :jkDate, SPI_HandTime = :jkTime, SPI_Rep_DR = :jkRowId
				WHERE %ID = :spiRowId
			)
			set rtn=SQLCODE
			if (rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
		quit:(+rtn)
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
		
	quit rtn_"^"_jkRowId

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2017-11-22
/// Description: 取住院押金及发票信息
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillDailyHandin).GetDepNOAndInvNOInfo(639,  2, "")
ClassMethod GetDepNOAndInvNOInfo(guser As %String, stDate As %String, stTime As %String, endDate As %String, endTime As %String, jkDate As %String, jkTime As %String, hospDR As %String) As %String
{
	set job=$j
	do ..KillTMPGlobal(guser, job)

	//需结算押金及发票信息
	set normalDepNum=0
	set abortDepNum=0
	set strikeDepNum=0
	set normalInvNum=0
	set abortInvNum=0
	set strikeInvNum=0
	for date=stDate:1:endDate do
	.//押金信息
	.set depRowID=0
	.for  set depRowID=$o(^DHCSFPRINTDETAIL(0,"PrtDate",date,depRowID)) quit:(depRowID="")  do
	..set depData=$g(^DHCSFPRINTDETAIL(depRowID))
	..quit:(depData="")
	..set depTypeDR=$p(depData,"^",13)
	..set depTypeCode=$s((+depTypeDR'=0):$p($g(^ARC("ARCDT",depTypeDR)),"^",1),1:"")
	..set prtUserDR=$p(depData,"^",14)
	..quit:(prtUserDR'=guser)
    ..set depHospDR=$p(depData,"^",44)
    ..quit:(hospDR'=depHospDR)
	..set prtTime=$p(depData,"^",3)
	..quit:((date=endDate)&&(prtTime>endTime))
	..set jkDR=$p(depData,"^",30)
	..quit:(+jkDR'=0)
	..set prtStatus=$p(depData,"^",8)
	..set rcptNo=$p(depData,"^",1)
	..set initDepDR=$p(depData,"^",43)
	..if (rcptNo'="") do
	...set ^||TMP("IPBILL","DepositNo",guser,job,rcptNo)=""
	...set normalDepNum=$i(normalDepNum)
	..if ((+prtStatus=2)&&(+initDepDR=0)) do
	...if ('$d(^||TMP("IPBILL","AbortDepNo",guser,job))) do
	....set ^||TMP("IPBILL","AbortDepNo",guser,job)=rcptNo
	...else  do
	....set ^||TMP("IPBILL","AbortDepNo",guser,job)=$g(^||TMP("IPBILL","AbortDepNo",guser,job))_", "_rcptNo
	...set abortDepNum=$i(abortDepNum)
	..if (+prtStatus=3) do
	...set initRcptNo=rcptNo
	...if (initRcptNo="") set initRcptNo=$p(depData,"^",7)      //红冲票据为空时, 取原票据号
	...if ('$d(^||TMP("IPBILL","StrikeDepNo",guser,job))) do
	....set ^||TMP("IPBILL","StrikeDepNo",guser,job)=initRcptNo
	...else  do
	....set ^||TMP("IPBILL","StrikeDepNo",guser,job)=$g(^||TMP("IPBILL","StrikeDepNo",guser,job))_", "_initRcptNo
    ...set strikeDepNum=$i(strikeDepNum)
	.//发票信息
	.set invRowID=0
	.for  set invRowID=$o(^DHCINVPRTZY(0,"DATE",date,invRowID)) quit:(invRowID="")  do
	..set invData=$g(^DHCINVPRTZY(invRowID))
	..quit:(invData="")
	..set prtUserDR=$p(invData,"^",7)
	..quit:(prtUserDR'=guser)
	..set prtTime=$p(invData,"^",3)
	..quit:((date=endDate)&&(prtTime>endTime))
	..set prtHospDR=$p(invData,"^",35)
    ..quit:(hospDR'=prtHospDR)
	..set jkDR=$p(invData,"^",23)
	..quit:(+jkDR'=0)
	..set invNo=$p(invData,"^",1)
	..set initInvDR=$p(invData,"^",13)
	..set prtStatus=$p(invData,"^",8)
	..if (invNo'="") do
	...set ^||TMP("IPBILL","InvNo",guser,job,invNo)=""
	...set normalInvNum=$i(normalInvNum)
	..set initInvNo=invNo
 	..if ((initInvNo="")&&(+initInvDR'=0)) do     //取消结算未打印发票时,取原记录发票号
    ...set initInvNo=$p(^DHCINVPRTZY(initInvDR),"^",1)
	..if (prtStatus="A")  do
	...quit:(initInvNo="")
	...if ('$d(^||TMP("IPBILL","AbortInvNo",guser,job))) do
	....set ^||TMP("IPBILL","AbortInvNo",guser,job)=initInvNo
	...else  do
	....set ^||TMP("IPBILL","AbortInvNo",guser,job)=$g(^||TMP("IPBILL","AbortInvNo",guser,job))_", "_initInvNo
	...set abortInvNum=$i(abortInvNum)
	..if (prtStatus="S")  do
	...quit:(initInvNo="")
	...if ('$d(^||TMP("IPBILL","StrikeInvNo",guser,job)))  do
	....set ^||TMP("IPBILL","StrikeInvNo",guser,job)=initInvNo
	...else  do
	....set ^||TMP("IPBILL","StrikeInvNo",guser,job)=$g(^||TMP("IPBILL","StrikeInvNo",guser,job))_", "_initInvNo
	...set strikeInvNum=$i(strikeInvNum)
	.//集中打印发票信息
	.set spiRowId=0
	.for  set spiRowId=$o(^BILL.IP.SummaryPrtInvI("PrtDate",date,spiRowId)) quit:(spiRowId="")  do
	..set spiData=$g(^BILL.IP.SummaryPrtInvD(spiRowId))
	..set spiUserDR=$lg(spiData,5)
	..quit:(spiUserDR'=guser)
	..set spiTime=$lg(spiData,8)
	..quit:((date=endDate)&&(spiTime>endTime))
	..set spiHospDR=$lg(spiData,14)
    ..quit:(hospDR'=spiHospDR)
	..set jkDR=$lg(spiData,13)
	..quit:(+jkDR'=0)
	..set invNo=$lg(spiData,2)
	..set initInvDR=$lg(spiData,9)
	..set prtStatus=$lg(spiData,6)
	..if (invNo'="") do
	...set ^||TMP("IPBILL","InvNo",guser,job,invNo)=""
	...set normalInvNum=$i(normalInvNum)
	..set initInvNo=invNo
 	..if ((initInvNo="")&&(+initInvDR'=0)) do     //取消结算未打印发票时,取原记录发票号
    ...set initInvNo=$lg(spiData,2)
	..if (prtStatus="A")  do
	...quit:(initInvNo="")
	...if ('$d(^||TMP("IPBILL","AbortInvNo",guser,job))) do
	....set ^||TMP("IPBILL","AbortInvNo",guser,job)=initInvNo
	...else  do
	....set ^||TMP("IPBILL","AbortInvNo",guser,job)=$g(^||TMP("IPBILL","AbortInvNo",guser,job))_", "_initInvNo
	...set abortInvNum=$i(abortInvNum)
	..if (prtStatus="S")  do
	...quit:(initInvNo="")
	...if ('$d(^||TMP("IPBILL","StrikeInvNo",guser,job)))  do
	....set ^||TMP("IPBILL","StrikeInvNo",guser,job)=initInvNo
	...else  do
	....set ^||TMP("IPBILL","StrikeInvNo",guser,job)=$g(^||TMP("IPBILL","StrikeInvNo",guser,job))_", "_initInvNo
	...set strikeInvNum=$i(strikeInvNum)
	
	set normalDepNoStr=##class(web.DHCBillCommon).GetInvNoInfo("^||TMP", "IPBILL", "DepositNo", guser, job)
	set abortDepNoStr=$g(^||TMP("IPBILL","AbortDepNo",guser,job))
	set strikeDepNoStr=$g(^||TMP("IPBILL","StrikeDepNo",guser,job))
	set normalInvNoStr=##class(web.DHCBillCommon).GetInvNoInfo("^||TMP", "IPBILL", "InvNo", guser, job)
	set abortInvNoStr=$g(^||TMP("IPBILL","AbortInvNo",guser,job))
	set strikeInvNoStr=$g(^||TMP("IPBILL","StrikeInvNo",guser,job))
	
	do ..KillTMPGlobal(guser, job)

	set rtn=normalDepNoStr_"^"_normalDepNum_"^"_strikeDepNoStr_"^"_strikeDepNum_"^"_abortDepNoStr_"^"_abortDepNum
	set rtn=rtn_"#"_normalInvNoStr_"^"_normalInvNum_"^"_strikeInvNoStr_"^"_strikeInvNum_"^"_abortInvNoStr_"^"_abortInvNum
	
	quit rtn
}

/// Creator: ZhYW 
/// CreatDate: 2017-12-10
/// Description: 取收费员最后一次日结信息
/// Input: guser:SS_User.RowID
/// Debug: w ##class(web.DHCIPBillDailyHandin).GetLastHandinInfo()
ClassMethod GetLastHandinInfo(guser As %String, hospId As %String) As %String
{
	set footId=""
    set footDate="", footTime="", receFlag="N"
    
    set myId=""
	for  set myId=$o(^DHCJFUSERJK(0,"user",guser,myId),-1)  quit:((myId="")||(footId'=""))  do
	.set footInfo=$g(^DHCJFUSERJK(myId))
	.quit:(footInfo="")
	.set hospDR=$p(footInfo,"^",27)
	.quit:(hospId'=hospDR)
	.set footId=myId
	.set footDate=$p(footInfo,"^",1)
	.set footTime=$p(footInfo,"^",2)
	.set receFlag=$p(footInfo,"^",26)
	
	set todayFlag=$case(footDate,+$h:"Y",:"N")
	set footDate=##class(websys.Conversions).DateLogicalToHtml(footDate)
	set footTime=##class(websys.Conversions).TimeLogicalToHtml(footTime, 1)
	
	set rtn=footId_"^"_footDate_"^"_footTime_"^"_receFlag_"^"_todayFlag
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2018-03-16
/// Descripiton: 取消住院日结
/// Input: footId:DHC_JFUSERJK.RowId
/// Return: 
/// Debug: w ##class(web.DHCIPBillDailyHandin).CancelHandin(835)
ClassMethod CancelHandin(footId As %String) As %String
{
	set err=0
    quit:(+footId=0) err
    
	set $zt="ERROR"
	ts
	
	&SQL(DELETE FROM DHC_JFUSERJK WHERE jk_rowid=:footId)
	set err=SQLCODE
	
	//更新押金表
	&SQL(SELECT count(*) INTO :depNum FROM dhc_sfprintdetail WHERE prt_jk_dr = :footId)
	if (depNum>0) {
		&SQL(
			UPDATE dhc_sfprintdetail
			SET prt_jkuser_dr = NULL, prt_jkflag = 'N', prt_jkdate = NULL, prt_jktime = NULL, prt_jk_dr = NULL 
			WHERE prt_jk_dr = :footId
		)
		set err=err+SQLCODE
	}
	
	//更新发票表
	&SQL(SELECT count(*) INTO :invNum FROM DHC_INVPRTZY WHERE PRT_JK_DR = :footId)
	if (invNum>0) {
		&SQL(
			UPDATE DHC_INVPRTZY
			SET PRT_Handin = 'N', PRT_HandDate = NULL, PRT_HandTime = NULL, PRT_JK_DR = NULL 
			WHERE PRT_JK_DR = :footId
		)
		set err=err+SQLCODE
	}
   	
   	//更新跳号表
   	&SQL(SELECT count(*) INTO :voidNum FROM DHC_VoidInv WHERE VOI_Report_DR = :footId AND VOI_Type IN ('ID', 'IP'))
   	if (voidNum>0) {
		&SQL(
			UPDATE DHC_VoidInv
			SET VOI_Handin = 'N', VOI_HandDate = NULL, VOI_handTime = NULL, VOI_Report_DR = NULL 
			WHERE VOI_Report_DR = :footId  AND VOI_Type IN ('ID', 'IP')
		)
		set err=err+SQLCODE
	}
	
	//更新欠费结算表
	&SQL(SELECT count(*) INTO :QFNum FROM DHC_JFQFTotal WHERE QF_JK_DR = :footId)
   	if (QFNum>0) {
		&SQL(
			UPDATE DHC_JFQFTotal SET QF_HandIn = 'N', QF_HandinDate = NULL, QF_HandinTime = NULL, QF_JK_DR = NULL 
			WHERE QF_JK_DR = :footId
		)
		set err=err+SQLCODE
	}
	
	//更新集中打印发票表
	&SQL(SELECT count(*) INTO :spiNum FROM BILL_IP.SummaryPrtInv WHERE SPI_Rep_DR = :footId)
   	if (spiNum>0) {
		&SQL(
			UPDATE BILL_IP.SummaryPrtInv
			SET SPI_Handin = 'N', SPI_HandDate = NULL, SPI_HandTime = NULL, SPI_Rep_DR = NULL 
			WHERE SPI_Rep_DR = :footId
		)
		set err=err+SQLCODE
	}
	
	set errDesc="取消成功"
 	if (err=0) {
		if ($tl>0) tc
 	} else {
		tro
		set errDesc="取消失败"
 	}
 	
	quit "{""msg"":"""_errDesc_""",""success"":"_err_"}"

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2017-11-22
/// Description: 取收费员日结开始时间
/// Input: guser:SS_User.RowId, hospDR:CT_Hospital.RowId
/// Return: 
/// Debug: w ##class(web.DHCIPBillDailyHandin).GetStDate(12173, 2)
ClassMethod GetStDate(guser As %String, hospDR As %String = "") As %String
{
	set stDate=+$h, stTime=$p($h,",",2)
	
	set jkFlag="N"
	set footId=""
	while($o(^DHCJFUSERJK(0,"user",guser,footId),-1)&&(jkFlag="N")) {
		set footId=$o(^DHCJFUSERJK(0,"user",guser,footId),-1)
		set footData=$g(^DHCJFUSERJK(footId))
		set footHospDR=$p(footData,"^",27)
		continue:(hospDR'=footHospDR)
		set stDate=$p(footData,"^",4)
		set stTime=$p(footData,"^",12)
		set jkFlag="Y"
	}
	
	if (jkFlag="N") {
		//住院押金
		set depRowID=0
		while($o(^DHCSFPRINTDETAIL(0,"JKFLAG","N",guser,depRowID))) {
			set depRowID=$o(^DHCSFPRINTDETAIL(0,"JKFLAG","N",guser,depRowID))
			set depData=$g(^DHCSFPRINTDETAIL(depRowID))
			set depHospDR=$p(depData,"^",44)
			continue:(hospDR'=depHospDR)
			set depDate=$p(depData,"^",2)
			set depTime=$p(depData,"^",3)
			if ($SYSTEM.SQL.DATEDIFF("ss", stDate_","_stTime, depDate_","_depTime)<0) {
				set stDate=depDate
				set stTime=depTime
			}
			quit
		}
		
		//住院收费
		set invRowID=0
		while($o(^DHCINVPRTZY(0,"HandIn","N",guser,invRowID))) {
			set invRowID=$o(^DHCINVPRTZY(0,"HandIn","N",guser,invRowID))
			set invData=$g(^DHCINVPRTZY(invRowID))
			set invHospDR=$p(invData,"^",35)
			continue:(hospDR'=invHospDR)
			set invDate=$p(invData,"^",2)
			set invTime=$p(invData,"^",3)
			if ($SYSTEM.SQL.DATEDIFF("ss", stDate_","_stTime, invDate_","_invTime)<0) {
				set stDate=invDate
				set stTime=invTime
			}
			quit
		}
		
		//欠费结算表
		set QFEndDate=0, QFEndTime=0
		set QFRowId=0
		while($o(^DHCJFQFTOTAL(0,"HandIn","N",guser,QFRowId))) {
			set QFRowId=$o(^DHCJFQFTOTAL(0,"HandIn","N",guser,QFRowId))
			set QFData=$g(^DHCJFQFTOTAL(QFRowId))
			set QFHospDR=$p(QFData,"^",18)
			continue:(hospDR'=QFHospDR)
			set QFDate=$p(QFData,"^",2)
			set QFTime=$p(QFData,"^",3)
			if ($SYSTEM.SQL.DATEDIFF("ss", stDate_","_stTime, QFDate_","_QFTime)<0) {
				set stDate=QFDate
				set stTime=QFTime
			}
			quit
		}
		
		//集中打印发票表
		set spiRowId=0
		while($o(^BILL.IP.SummaryPrtInvI("HandinUserDR","N",guser,spiRowId))) {
			set spiRowId=$o(^BILL.IP.SummaryPrtInvI("HandinUserDR","N",guser,spiRowId))
			set spiData=$g(^BILL.IP.SummaryPrtInvD(spiRowId))
			set spiHospDR=$lg(spiData,14)
	 		continue:(hospDR'=spiHospDR)
	 		set spiDate=$lg(spiData,7)
	 		set spiTime=$lg(spiData,8)
	 		if ($SYSTEM.SQL.DATEDIFF("ss", stDate_","_stTime, spiDate_","_spiTime)<0) {
				set stDate=spiDate
				set stTime=spiTime
			}
	 		quit
		}
	}
	
	set stDate=##class(websys.Conversions).DateLogicalToHtml(stDate)
   	set stTime=##class(websys.Conversions).TimeLogicalToHtml(stTime, 1)
    set endDate=##class(websys.Conversions).DateLogicalToHtml(+$h)
    set endTime=##class(websys.Conversions).TimeLogicalToHtml($p($h,",",2), 1)
    
    quit stDate_"^"_stTime_"^"_endDate_"^"_endTime
}

ClassMethod KillTMPGlobal(guser As %String, job As %String) As %String
{
	kill ^||TMP("IPBILL","DepositNo",guser,job)
	kill ^||TMP("IPBILL","AbortDepNo",guser,job)
	kill ^||TMP("IPBILL","StrikeDepNo",guser,job)
	kill ^||TMP("IPBILL","InvNo",guser,job)
	kill ^||TMP("IPBILL","AbortInvNo",guser,job)
	kill ^||TMP("IPBILL","StrikeInvNo",guser,job)
	
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2019-12-06
/// Description: 生成日结记录树
/// Input: 
/// Output: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillDailyHandin).BuildReportsTree(671, 2)
ClassMethod BuildReportsTree(guser As %String, hospDR As %String, langId As %String = "") As %String
{
	set lastDate=""
	kill footList
	set footId=0
	while($o(^DHCJFUSERJK(0,"user",guser,footId))) {
		set footId=$o(^DHCJFUSERJK(0,"user",guser,footId))
		set footData=$g(^DHCJFUSERJK(footId))
		continue:(footData="")
		set myHospDR=$p(footData,"^",27)
		continue:(hospDR'=myHospDR)
		set footDate=$p(footData,"^",1)
		if (+footDate>+lastDate) {
			set lastDate=footDate
		}
		set year=$SYSTEM.SQL.YEAR(footDate)
		set month=$SYSTEM.SQL.MONTH(footDate)
		set day=$SYSTEM.SQL.DAYOFMONTH(footDate)
		set footList(year,month,day,footId)=""
	}
	
	if (+lastDate=0) {
		set lastDate=+$h
	}
	set lastYear=$SYSTEM.SQL.YEAR(lastDate)
	set lastMonth=$SYSTEM.SQL.MONTH(lastDate)
	set lastDay=$SYSTEM.SQL.DAYOFMONTH(lastDate)
	
	set o=[]
	set year=0
	while($o(footList(year))) {
		set year=$o(footList(year))
		set y={}
		set y.text=year_##class(websys.Translation).Get("", "年", langId)
		set y.state=$s((year=lastYear):"open",1:"closed")
		set yc=[]
		set month=0
		while($o(footList(year,month))) {
			set month=$o(footList(year,month))
			set m={}
			set m.text=month_##class(websys.Translation).Get("", "月", langId)
			set m.state=$s(((year_month)=(lastYear_lastMonth)):"open",1:"closed")
			do yc.%Push(m)
			set mc=[]
			set day=0
			while($o(footList(year,month,day))) {
				set day=$o(footList(year,month,day))
				set d={}
				set d.text=day_##class(websys.Translation).Get("", "日", langId)
				//set d.state=$s(((year_month_day)=(lastYear_lastMonth_lastDay)):"open",1:"closed")
				set d.state="closed"
				do mc.%Push(d)
				set dc=[]
				set footId=0
				while($o(footList(year,month,day,footId))) {
					set footId=$o(footList(year,month,day,footId))
					set footData=$g(^DHCJFUSERJK(footId))
					set stDate=$p(footData,"^",3)
					set stTime=$p(footData,"^",11)
					set endDate=$p(footData,"^",4)
					set endTime=$p(footData,"^",12)
					set stDate=##class(websys.Conversions).DateLogicalToHtml(stDate)
					set stTime=##class(websys.Conversions).TimeLogicalToHtml(stTime)
					set endDate=##class(websys.Conversions).DateLogicalToHtml(endDate)
					set endTime=##class(websys.Conversions).TimeLogicalToHtml(endTime)
					set f={}
					set f.id=footId
					set f.text=##class(websys.Translation).Get("dhcbill.ipbill.dailyhand.csp", "结账号：", langId)_footId
					set p={}
					set p.stDateTime=stDate_" "_stTime
					set p.endDateTime=endDate_" "_endTime
					set f.attributes=p
					do dc.%Push(f)
				}
				set d.children=dc
			}
			set m.children=mc
		}
		set y.children=yc
		do o.%Push(y)
	}
	
	set stream=##class(%GlobalCharacterStream).%New()
	do o.%ToJSON(.stream)
	do stream.OutputToDevice()
	
	quit ""
}

/// Creator: ZhYW
/// CreatDate: 2019-12-11
/// Description: 取配置的日结结束时间
/// Input: hospId: CT_Hospital.RowId
/// Return: handinEndTime
/// Debug: w ##class(web.DHCIPBillDailyHandin).GetConfHandinEndTime()
ClassMethod GetConfHandinEndTime(hospId As %String) As %String
{
	set handinEndTime=##class(web.DHCBillPageConf).GetPageConfValue("dhcbill.ipbill.dailyhand.csp", "HANDENDTIME", "", hospId)
	if (handinEndTime'=""){
		set handinEndTime=##class(websys.Conversions).TimeHtmlToLogical(handinEndTime)
	}
	quit handinEndTime
}

/// Creator: ZhYW
/// CreatDate: 2019-12-11
/// Description: 判断在此时间是否做过日结
/// Input: userId:SS_User.RowID, endDate: 结束日期, endTime:结束时间, hospId:CT_Hospital.RowID
/// Return: flag 0:未日结, 1:日结
/// Debug: w ##class(web.DHCIPBillDailyHandin).CheckIsHandedAtEndTime(1207, 64396, 86399, 2)
ClassMethod CheckIsHandedAtEndTime(userId As %String, endDate As %String, endTime As %String, hospId As %String) As %String
{
	set flag=0
	quit:(+userId=0) flag
	
	set myEndDate=endDate
	
	set rowId=""
	for  set rowId=$o(^DHCJFUSERJK(0,"user",userId,rowId),-1) quit:((rowId="")||(myEndDate<endDate)||(flag'=0))  do
	.set data=$g(^DHCJFUSERJK(rowId))
	.quit:(data="")
	.set myHospDR=$p(data,"^",27)
	.quit:(myHospDR'=hospId)
	.set myEndDate=$p(data,"^",4)
	.quit:(myEndDate'=endDate)
	.set myEndTime=$p(data,"^",12)
	.quit:(myEndTime'=endTime)
	.set flag=1
	
	quit flag
}

}
