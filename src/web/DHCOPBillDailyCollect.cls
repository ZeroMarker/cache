Import SQLUser

/// Lid
/// 2010-11-22
/// 门诊收费员日报汇总业务类（包含发票和押金）
Class web.DHCOPBillDailyCollect Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2018-03-10
/// Description: 接收
/// Table: DHC_INVPRTReports, DHC_OPBillReceive
/// Input: footIdStr: 结账RowId串, sessionStr: 操作员Id^安全组Id^登录科室Id^医院Id
/// Return: rtn:错误代码,  =0:成功, <>0:失败
/// Debug: w ##class(web.DHCOPBillDailyCollect).Receive("33051^33052^33053^33055^33058^33059", "5")
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
	for i=1:1:count  {
		set footId=$p(footIdStr,"^",i)
		continue:(+footId=0)
		set footDate=$p(^DHCOPInsFoot(footId),"^",2)
		if ((minDate="")||(+footDate<+minDate)) {
			set minDate=footDate
		}
		if ((maxDate="")||(+footDate>+maxDate)) {
			set maxDate=footDate
		}
	}
	
	set stDate=minDate
	set endDate=maxDate

	set receDate=+$h
	set receTime=$p($h,",",2)
	
	set rtn=0
	
    ts
    
	&SQL(
    	INSERT INTO DHC_OPBillReceive (
    		OPRec_Date, OPRec_Time, OPRec_User_DR, OPRec_StDate, OPRec_EndDate
    	)
    	VALUES (
    		CONVERT(DATE, NOW()), CONVERT(TIME, NOW()), :userId, :stDate, :endDate
    	)
    )
	set rtn=SQLCODE
	set rowId=$g(%ROWID)
	
	set count=$l(footIdStr,"^")
	for i=1:1:count {
		set footId=$p(footIdStr,"^",i)
		continue:(+footId=0)
		set myReceiveDR=$p(^DHCOPInsFoot(footId),"^",65)
		continue:(+myReceiveDR'=0)
		&SQL(
			UPDATE DHC_INVPRTReports
			SET HIS_OPReceive_DR = :rowId, HIS_ReceiveFlag = 'Y'
			WHERE %ID = :footId
		)
		set rtn=SQLCODE
		quit:(+rtn)
	}
	
	set msg="接收成功"
	if (+rtn=0) {
		tc
	}else {
		tro
		set msg="接收失败"
	}
	
	//保存日志 2021-4-9 tangzf start
	set obj=##class(%ArrayOfDataTypes).%New()
	set userCode=$p($g(^SSU("SSUSR",userId)),"^",1)
	set userName=$p($g(^SSU("SSUSR",userId)),"^",2)
	do obj.SetAt(userCode,"INMSGUserCode") 	        //收费员工号
    do obj.SetAt(+$h,"INMSGDate")
    do obj.SetAt($p($h,",",2),"INMSGTime")
    do obj.SetAt("FEE-11","INMSGYWLX")
    do obj.SetAt(userName,"INMSGC1iName")
    do obj.SetAt("门诊日报汇总接收"_msg,"INMSGMsg")
    do obj.SetAt("OP-03","INMSGProductLine")         //产品线
    do obj.SetAt(hospId,"INMSGHospDr")               //院区
    do obj.SetAt(rowId,"INMSGBusinessId") 			 //业务ID
	do ##class(INSU.COM.Tools).Log(obj, "array")
	
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
/// CreatDate: 2017-12-09
/// Description: 撤销接收
/// Table: DHC_INVPRTReports, DHC_OPBillReceive
/// Input: receId: DHC_OPBillReceive.OPREC_RowId, sessionStr: 操作员Id^安全组Id^登录科室Id^医院Id
/// Return: rtn:错误代码,  =0:成功, <>0:失败
/// Debug: w ##class(web.DHCOPBillDailyCollect).CancelReceive(27, "5")
ClassMethod CancelReceive(receId As %String, sessionStr As %String) As %String
{
    set $zt="ERROR"
    
    set userId=$p(sessionStr,"^",1)
    set groupId=$p(sessionStr,"^",2)
    set ctLocId=$p(sessionStr,"^",3)
    set hospId=$p(sessionStr,"^",4)
    
    ts
    
	&SQL(DELETE FROM DHC_OPBillReceive WHERE %ID = :receId)
	set rtn=SQLCODE
	
	&SQL(SELECT count(*) INTO :num FROM DHC_INVPRTReports WHERE HIS_OPReceive_DR = :receId)
	if (num>0) {
		&SQL(
			UPDATE DHC_INVPRTReports
			SET HIS_OPReceive_DR = NULL, HIS_ReceiveFlag = 'N'
			WHERE HIS_OPReceive_DR = :receId
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
	do obj.SetAt(userCode,"INMSGUserCode")     //收费员工号
    do obj.SetAt(+$h,"INMSGDate")
    do obj.SetAt($p($h,",",2),"INMSGTime")
    do obj.SetAt("FEE-11","INMSGYWLX")
    do obj.SetAt(userName,"INMSGC1iName")
    do obj.SetAt("门诊日报汇总撤销接收"_msg,"INMSGMsg")
    do obj.SetAt("OP-03","INMSGProductLine")    //产品线
    do obj.SetAt(hospId,"INMSGHospDr")          //院区
    do obj.SetAt(receId,"INMSGBusinessId")      //业务ID
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
/// CreatDate: 2018-03-12
/// Description: 门诊日结汇总查询
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillDailyCollect","FindDailyCollect", "2022-01-04","2022-01-04","","","2","239")
Query FindDailyCollect(stDate As %String, endDate As %String, guserStr As %Text, receId As %String, hospDR As %String, groupDR As %String, langId As %String = "", verifyStatus As %String = "") As websys.Query(ROWSPEC = "TRowId:%String,TUserId:%String,TUserName:%String,TDate:%String,TTime:%String,TStDate:%String,TStTime:%String,TEndDate:%String,TEndTime:%String,TReceId:%String,TAccPreNum:%String,TAccPreSum:%String,TNorAccPreNum:%String,TNorAccPreSum:%String,TRefAccPreNum:%String,TRefAccPreSum:%String,TInvNum:%String,TInvSum:%String,TInvNoStr:%String,TParkInvNum:%String,TParkInvSum:%String,TParkInvNoStr:%String,TRefInvNum:%String,TRefInvSum:%String,TRefInvNoStr:%String,TVoidInvNum:%String,TVoidInvNoStr:%String,verifyStatus:%String")
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
 	
	set (accPreTotalNum, accPreTotalSum, norAccPreTotalNum, norAccPreTotalSum, refAccPreTotalNum, refAccPreTotalSum)=0
	set (invTotalNum, invTotalSum, parkInvTotalNum, parkInvTotalSum, refInvTotalNum, refInvTotalSum)=0
	set voidInvTotalNum=0
	
	//收费组长接收标识
	set baseConfig=##class(web.UDHCOPGSConfig).ReadCFByGRowID(groupDR, hospDR)
	set receConfig=$p(baseConfig,"^",21)
	
	if (receConfig=1) {
		if (receId="") {
			//查询未接收结账记录
			set footId=0
			while($o(^DHCOPInsFootI(0,"RECEIVEFLAG","N",footId))) {
				set footId=$o(^DHCOPInsFootI(0,"RECEIVEFLAG","N",footId))
				set footData=$g(^DHCOPInsFoot(footId))
				continue:(footData="")
				set preHandinFlag=$p(footData,"^",68)       
				continue:(preHandinFlag="Y")                        //过滤预结算记录
				set footHospDR=$p(footData,"^",66)
				continue:((hospDR'="")&&(hospDR'=footHospDR))
				set footDate=$p(footData,"^",2)
				continue:((endDate'="")&&(footDate>endDate))
				set userDR=$p(footData,"^",8)
			 	continue:((guserStr'="")&&(("^"_guserStr_"^")'[("^"_userDR_"^")))             //按收费员过滤
				do GetCollectInfo
			}
		}else {
			//查询已接收结账记录
			set footId=0
			while($o(^DHCOPInsFootI(0,"RECEIVEDR",receId,footId))) {
				set footId=$o(^DHCOPInsFootI(0,"RECEIVEDR",receId,footId))
				set footData=$g(^DHCOPInsFoot(footId))
				continue:(footData="")
				set preHandinFlag=$p(footData,"^",68)
				continue:(preHandinFlag="Y")                        //过滤预结算记录
				set footHospDR=$p(footData,"^",66)              //HIS_HospitalDR
			 	continue:((hospDR'="")&&(hospDR'=footHospDR))     
				set userDR=$p(footData,"^",8)
			 	continue:((guserStr'="")&&(("^"_guserStr_"^")'[("^"_userDR_"^")))             //按收费员过滤
				do GetCollectInfo
			}
		}
	}else  {
		//不接收时按照日期查询
		for date=stDate:1:endDate {
			set footId=0
			while($o(^DHCOPInsFootI(0,"Date",date,footId))) {
				set footId=$o(^DHCOPInsFootI(0,"Date",date,footId))
				set footData=$g(^DHCOPInsFoot(footId))
				continue:(footData="")
				set preHandinFlag=$p(footData,"^",68)
				continue:(preHandinFlag="Y")                        //过滤预结算记录
				set footHospDR=$p(footData,"^",66)                 //HIS_HospitalDR
			 	continue:((hospDR'="")&&(hospDR'=footHospDR))     
				set userDR=$p(footData,"^",8)
			 	continue:((guserStr'="")&&(("^"_guserStr_"^")'[("^"_userDR_"^")))             //按收费员过滤
				do GetCollectInfo
			}
		}
	}
	set (footId,userDR,footDate,footTime,footStDate,footStTime,footEndDate,footEndTime,footReceDR,invNoStr,parkInvNoStr,refInvNoStr,voidInvNoStr)=""
	set userName=##class(websys.Translation).Get("", "合计", langId)
	set accPreNum=accPreTotalNum
	set accPreSum=$fn(accPreTotalSum,"",2)
	set norAccPreNum=norAccPreTotalNum
	set norAccPreSum=$fn(norAccPreTotalSum,"",2)
	set refAccPreNum=refAccPreTotalNum
	set refAccPreSum=$fn(refAccPreTotalSum,"",2)
	set invNum=invTotalNum
	set invSum=$fn(invTotalSum,"",2)
	set parkInvNum=parkInvTotalNum
	set parkInvSum=$fn(parkInvTotalSum,"",2)
	set refInvNum=refInvTotalNum
	set refInvSum=$fn(refInvTotalSum,"",2)
	set voidInvNum=voidInvTotalNum
	set VerifyStatus=""
 	do OutputDailyCollect

 	quit $$$OK

GetCollectInfo
	set userName=$p(^SSU("SSUSR",userDR),"^",2)
	set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
	set footDate=$p(footData,"^",2)
	set footStDate=$p(footData,"^",5)               //HIS_StartDate
	set footStTime=$p(footData,"^",6)               //HIS_StartTime
	set footEndDate=$p(footData,"^",3)              //HIS_EndDate
	set footEndTime=$p(footData,"^",4)              //HIS_EndTime
	set footTime=$p(footData,"^",7)                 //HIS_Time
	set footReceDR=$p(footData,"^",65)              //HIS_OPReceive_DR
	set VerifyStatus=$p(footData,"^",78)   
	quit:(verifyStatus'="3")&&(verifyStatus'=VerifyStatus) // 核销状态过滤 XiaoShuai
	set footDate=##class(websys.Conversions).DateLogicalToHtml(footDate)
	set footTime=##class(websys.Conversions).TimeLogicalToHtml(footTime, 1)
 	set footStDate=##class(websys.Conversions).DateLogicalToHtml(footStDate)
 	set footStTime=##class(websys.Conversions).TimeLogicalToHtml(footStTime, 1)
 	set footEndDate=##class(websys.Conversions).DateLogicalToHtml(footEndDate)
 	set footEndTime=##class(websys.Conversions).TimeLogicalToHtml(footEndTime, 1)
	
	kill ^||TMP("OPBILL",job,userDR)
	
 	//取预交金信息
 	set accM=0
 	while($o(^DHCACDi("AccM",0,"PDFootDR",footId,accM))) {
	 	set accM=$o(^DHCACDi("AccM",0,"PDFootDR",footId,accM))
		set accPreSub=0
		while($o(^DHCACDi("AccM",0,"PDFootDR",footId,accM,"AccPD",accPreSub))) {
			set accPreSub=$o(^DHCACDi("AccM",0,"PDFootDR",footId,accM,"AccPD",accPreSub))
			set accPreData=$g(^DHCACD("AccM",accM,"AccPD",accPreSub))
			set preSum=$p(accPreData,"^",2)
		 	set serialNo=$p(accPreData,"^",6)
			set ^||TMP("OPBILL",job,userDR,"ALLACCPRENO",serialNo)=""       //存储门诊预交金流水号
			set ^||TMP("OPBILL",job,userDR,"ALLACCPRENUM")=$i(^||TMP("OPBILL",job,userDR,"ALLACCPRENUM"))           //存储门诊预交金数量
			set ^||TMP("OPBILL",job,userDR,"ALLACCPREAMT")=$i(^||TMP("OPBILL",job,userDR,"ALLACCPREAMT"), preSum)   //存储门诊预交金金额
		 	set preStatus=$p(accPreData,"^",1)
			if (preStatus="P") {
				set ^||TMP("OPBILL",job,userDR,"NORACCPRENO")=$s(('$d(^||TMP("OPBILL",job,userDR,"NORACCPRENO"))):serialNo,1:($g(^||TMP("OPBILL",job,userDR,"NORACCPRENO"))_", "_serialNo))   //存储门诊预交金充值流水号
				set ^||TMP("OPBILL",job,userDR,"NORACCPRENUM")=$i(^||TMP("OPBILL",job,userDR,"NORACCPRENUM"))                //存储门诊预交金充值数量
				set ^||TMP("OPBILL",job,userDR,"NORACCPREAMT")=$i(^||TMP("OPBILL",job,userDR,"NORACCPREAMT"), preSum)         //存储门诊预交金充值金额
			}
		 	if (" R F "[(" "_preStatus_" ")) {
			 	set ^||TMP("OPBILL",job,userDR,"REFACCPRENO")=$s(('$d(^||TMP("OPBILL",job,userDR,"REFACCPRENO"))):serialNo,1:($g(^||TMP("OPBILL",job,userDR,"REFACCPRENO"))_", "_serialNo))  //存储门诊预交金退款流水号
			 	set ^||TMP("OPBILL",job,userDR,"REFACCPRENUM")=$i(^||TMP("OPBILL",job,userDR,"REFACCPRENUM"))                //存储门诊预交金充值数量
				set ^||TMP("OPBILL",job,userDR,"REFACCPREAMT")=$i(^||TMP("OPBILL",job,userDR,"REFACCPREAMT"), preSum)        //存储门诊预交金充值金额
		 	}
		}
	}
 	
 	set accPreNum=+$g(^||TMP("OPBILL",job,userDR,"ALLACCPRENUM"))
	set accPreTotalNum=$i(accPreTotalNum, accPreNum)
 	set accPreSum=$fn($g(^||TMP("OPBILL",job,userDR,"ALLACCPREAMT")),"",2)
 	set accPreTotalSum=$i(accPreTotalSum, accPreSum)
 	set norAccPreNum=+$g(^||TMP("OPBILL",job,userDR,"NORACCPRENUM"))
	set norAccPreTotalNum=$i(norAccPreTotalNum, norAccPreNum)
 	set norAccPreSum=$fn($g(^||TMP("OPBILL",job,userDR,"NORACCPREAMT")),"",2)
	set norAccPreTotalSum=$i(norAccPreTotalSum, norAccPreSum)
 	set refAccPreNum=+$g(^||TMP("OPBILL",job,userDR,"REFACCPRENUM"))
	set refAccPreTotalNum=$i(refAccPreTotalNum, refAccPreNum)
 	set refAccPreSum=$fn($g(^||TMP("OPBILL",job,userDR,"REFACCPREAMT")),"",2)
	set refAccPreTotalSum=$i(refAccPreTotalSum, refAccPreSum)
	
 	//门诊收费信息
	set invId=0
	while($o(^DHCINVPRT(0,"Report",footId,invId))) {
		set invId=$o(^DHCINVPRT(0,"Report",footId,invId))
		set invData=$g(^DHCINVPRT(invId))
	 	set invFairType=$p(invData,"^",34)
	 	continue:(" F R "'[(" "_invFairType_" "))
	 	set initInvDR=$p(invData,"^",13)        //PRT_initInv_DR  指向被作废或红冲的发票rowId
	 	continue:($d(^DHCINVPRTCAPi(0,"INVPRTDR",invId))||((initInvDR'="")&&($d(^DHCINVPRTCAPi(0,"INVPRTDR",initInvDR)))))  //过滤做了集中打印发票记录
		set invAmt=$p(invData,"^",1)
	 	set invFlag=$p(invData,"^",8)
		set invNo=$p(invData,"^",14)
		set initInvNo=invNo
		if ((initInvNo="")&&(+initInvDR'=0)) {
			set initInvNo=$p(^DHCINVPRT(initInvDR),"^",14)          //负记录不走号时取原记录发票号
		}
		do BuildInvNoInfo
	}
	
 	//集中打印发票信息
 	set accPInvId=0
 	while($o(^DHCINVPRTAPi(0,"INVRep",footId,accPInvId))) {
	 	set accPInvId=$o(^DHCINVPRTAPi(0,"INVRep",footId,accPInvId))
	 	set accPInvData=$g(^DHCINVPRTAP(accPInvId))
		set invAmt=$p(accPInvData,"^",1)           //API_Amount
		set invFlag=$p(accPInvData,"^",2)          //API_Flag
	 	set invNo=$p(accPInvData,"^",6)            //API_INVNo
	 	set initInvDR=$p(accPInvData,"^",10)       //API_PayINV_DR
		set initInvNo=invNo
		if ((initInvNo="")&&(+initInvDR'=0)) {
			set initInvNo=$p(^DHCINVPRTAP(initInvDR),"^",6)          //负记录不走号时取原记录发票号
		}
		do BuildInvNoInfo
	}

	set invNum=+$g(^||TMP("OPBILL",job,userDR,"AllINVNUM"))
	set invTotalNum=$i(invTotalNum, invNum)
 	set invSum=$fn($g(^||TMP("OPBILL",job,userDR,"ALLINVAMT")),"",2)
	set invTotalSum=$i(invTotalSum, invSum)
	set invNoStr=##class(web.DHCBillCommon).GetInvNoInfo("^||TMP", "OPBILL", job, userDR, "AllINVNO")
 	set parkInvNum=+$g(^||TMP("OPBILL",job,userDR,"PARKINVNUM"))
	set parkInvTotalNum=$i(parkInvTotalNum, parkInvNum)
 	set parkInvSum=$fn($g(^||TMP("OPBILL",job,userDR,"PARKINVAMT")),"",2)
	set parkInvTotalSum=$i(parkInvTotalSum, parkInvSum)
	set parkInvNoStr=$g(^||TMP("OPBILL",job,userDR,"PARKINVNO"))
 	set refInvNum=+$g(^||TMP("OPBILL",job,userDR,"REFINVNUM"))
	set refInvTotalNum=$i(refInvTotalNum, refInvNum)
 	set refInvSum=$fn($g(^||TMP("OPBILL",job,userDR,"REFINVAMT")),"",2)
	set refInvTotalSum=$i(refInvTotalSum, refInvSum)
	set refInvNoStr=$g(^||TMP("OPBILL",job,userDR,"REFINVNO"))
 	//跳号信息
 	set voidInvNoStr=$p(footData,"^",73)              //HIS_VoidINVInfo
 	set voidInvNum=$s((voidInvNoStr'=""):$l(voidInvNoStr,","),1:0)
 	set voidInvTotalNum=$i(voidInvTotalNum, voidInvNum)
 	
	kill ^||TMP("OPBILL",job,userDR)
	
	do OutputDailyCollect

	quit 
	
BuildInvNoInfo
	if (invNo'="") {
		set ^||TMP("OPBILL",job,userDR,"AllINVNO",invNo)=""                                                  
		set ^||TMP("OPBILL",job,userDR,"AllINVNUM")=$i(^||TMP("OPBILL",job,userDR,"AllINVNUM"))          //存储门诊收费发票张数
		set ^||TMP("OPBILL",job,userDR,"ALLINVAMT")=$g(^||TMP("OPBILL",job,userDR,"ALLINVAMT"))+invAmt   //存储门诊收费发票金额
	}
	if ((invFlag="A")&&(+initInvDR'=0)) {
		if (initInvNo'="") {
			set ^||TMP("OPBILL",job,userDR,"PARKINVNO")=$s(('$d(^||TMP("OPBILL",job,userDR,"PARKINVNO"))):initInvNo,1:($g(^||TMP("OPBILL",job,userDR,"PARKINVNO"))_", "_initInvNo))
			set ^||TMP("OPBILL",job,userDR,"PARKINVNUM")=$i(^||TMP("OPBILL",job,userDR,"PARKINVNUM"))
			set ^||TMP("OPBILL",job,userDR,"PARKINVAMT")=$i(^||TMP("OPBILL",job,userDR,"PARKINVAMT"), invAmt)         //存储门诊收费作废金额
		}
	}
	if ((invFlag="S")&&(+initInvDR'=0)) {
		if (initInvNo'="") {
			set ^||TMP("OPBILL",job,userDR,"REFINVNO")=$s(('$d(^||TMP("OPBILL",job,userDR,"REFINVNO"))):initInvNo,1:($g(^||TMP("OPBILL",job,userDR,"REFINVNO"))_", "_initInvNo))
			set ^||TMP("OPBILL",job,userDR,"REFINVNUM")=$i(^||TMP("OPBILL",job,userDR,"REFINVNUM"))
			set ^||TMP("OPBILL",job,userDR,"REFINVAMT")=$i(^||TMP("OPBILL",job,userDR,"REFINVAMT"), invAmt)         //存储门诊收费红冲金额
		}
	}
	
 	quit
 
OutputDailyCollect
 	set Data=$lb(footId,userDR,userName,footDate,footTime,footStDate,footStTime,footEndDate,footEndTime,footReceDR,accPreNum,accPreSum,norAccPreNum,norAccPreSum,refAccPreNum,refAccPreSum,invNum,invSum,invNoStr,parkInvNum,parkInvSum,parkInvNoStr,refInvNum,refInvSum,refInvNoStr,voidInvNum,voidInvNoStr,$g(VerifyStatus))
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
 	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-12-06
/// Description: 生成日结汇总接收记录树
/// Input: 
/// Output: 
/// Debug: w ##class(web.DHCOPBillDailyCollect).BuildReceiveTree(5)
ClassMethod BuildReceiveTree(guser As %String, langId As %String = "") As %String
{
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	set lastDate=""
	kill receList
	set receId=0
	while($o(^DHCOPBILLRECEIVEi(0,"USERDR",guser,receId))) {
		set receId=$o(^DHCOPBILLRECEIVEi(0,"USERDR",guser,receId))
		set receData=$g(^DHCOPBILLRECEIVE(receId))
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
					set receData=$g(^DHCOPBILLRECEIVE(receId))
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
	.s preflag=$p(^DHCOPInsFoot(footId),"^",78)
	.s:preflag'="1" err=-footId
	
	quit err
ERROR
	do ..AppException()
	set json={}
	set json.msg=$ze
	set json.success=-1
	quit json.%ToJSON()
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
		set VerifyStatus=$p(^DHCOPInsFoot(footId),"^",78)
		//continue:(VerifyStatus=Status)				 //如果相同状态的则过滤掉 XiaoShuai 2022-07-05
		&SQL(
			UPDATE DHC_INVPRTReports
			SET HIS_VerifyDate = :verifyDate, HIS_VerifyTime = :verifyTime, HIS_VerifyUser = :guser, HIS_VerifyStatus=:Status
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

}
