Import SQLUser

/// 名称: web.DHCBillReconciliations.cls
/// 描述: 第三方对账
/// 编写者：ZhYW
/// 编写日期: 2018-03-23
Class web.DHCBillReconciliations Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: ZhYW
/// CreatDate: 2018-03-23
/// Description: 查询支付渠道
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillReconciliations","FindPayChannel")
Query FindPayChannel() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindPayChannelExecute(ByRef qHandle As %Binary) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set paymDR=0
	for  set paymDR=$o(^User.DHCCTPayModeExpI("PMEPayModeDRIndex",paymDR))  quit:(paymDR="")  do
	.set rowId=$p(paymDR," ",2)
	.quit:(+rowId=0)
	.set desc=$p($g(^CT("CTPM",rowId)),"^",2)
	.do OutputPayChannel
	
	quit $$$OK
	
OutputPayChannel
	set Data=$lb(rowId,desc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-03-23
/// Description: 查询第三方交易明细
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillReconciliations","FindBankTradeDetails")
Query FindBankTradeDetails(stDate As %String, endDate As %String, hospDR As %String) As websys.Query(ROWSPEC = "TBankTradeNo:%String,TTerminalNo:%String,TBankTradeType:%String,TBankTradeAmt:%Float,TBankTradeDate:%String,TBankTradeTime:%String,THISTradeNo:%String")
{
}

ClassMethod FindBankTradeDetailsExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, hospDR As %String) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
	set bankTradeTotalSum=0
	
	for date=stDate:1:endDate do
	.set rowId="0"
	.for  set rowId=$o(^User.DHCINVBankBalanceI("BANKFINDATE",date,rowId)) quit:(rowId="")  do
	..set bankTradeNo=$LIST(^User.DHCINVBankBalanceD(rowId),5)	       //银行交易流水号
	..set hisTradeNo=$LIST(^User.DHCINVBankBalanceD(rowId),7)	       //订单号
	..set terminalNo=$LIST(^User.DHCINVBankBalanceD(rowId),11)	       //交易终端号
	..set myHospDR=$LIST(^User.DHCINVBankBalanceD(rowId),9)
	..quit:((hospDR'="")&&(hospDR'=myHospDR))
	..set hospName=""
	..if (+myHospDR'=0)  set hospName=$p(^CT("HOSP",myHospDR),"^",2)   
	..set trannelNo=$LIST(^User.DHCINVBankBalanceD(rowId),15)            //渠道代码
	..set paymDR=$LIST(^User.DHCINVBankBalanceD(rowId),10)		
	..set paymDesc=""
	..if (+paymDR'=0) set paymDesc=$p(^CT("CTPM",paymDR),"^",2)
	..set userDR=$LIST(^User.DHCINVBankBalanceD(rowId),16)
	..set userName=""
	..if (+userDR'=0) set userName=$p(^SSU("SSUSR",userDR),"^",2)
	..set hisTradeTime=$LIST(^User.DHCINVBankBalanceD(rowId),8)          //yyyyMMddHHmmss
	..set tradeDate=$e(hisTradeTime,1,8)
	..set tradeDate=$zdh(tradeDate,8)
	..set tradeDate=##class(websys.Conversions).DateLogicalToHtml(tradeDate)                        //HIS交易日期
	..set tradeTime=$e(hisTradeTime,9,10)_":"_$e(hisTradeTime,11,12)_":"_$e(hisTradeTime,13,14)	    //HIS交易时间
	..set tradeFlag=$LIST(^User.DHCINVBankBalanceD(rowId),13)
	..set bankTradeType=""
	..if (+tradeFlag=0) set bankTradeType="扣费"
	..if (+tradeFlag=1) set bankTradeType="退费"
	..set bankTradeAmt=$LIST(^User.DHCINVBankBalanceD(rowId),12)	       //银行交易金额
	..//set bankTradeAmt=$fn(bankTradeAmt/100,"",2)
	..if (+tradeFlag=0) set tradeTotalSum=tradeTotalSum+bankTradeAmt
	..if (+tradeFlag=1) set tradeTotalSum=tradeTotalSum-bankTradeAmt
	..set bankTradeTime=$LIST(^User.DHCINVBankBalanceD(rowId),6)
	..set bankTradeDate=$e(bankTradeTime,1,8)
	..set bankTradeDate=$zdh(bankTradeDate,8)
	..set bankTradeDate=##class(websys.Conversions).DateLogicalToHtml(bankTradeDate)               
	..set bankTradeTime=$e(bankTradeTime,9,10)_":"_$e(bankTradeTime,11,12)_":"_$e(bankTradeTime,13,14)    
	..do OutputBankTradeDetails
	
	set (terminalNo, bankTradeType, bankTradeDate, bankTradeTime, hisTradeNo)=""
	set bankTradeNo="合计"
	set bankTradeAmt=bankTradeTotalSum
	do OutputBankTradeDetails
	
	quit $$$OK
	
OutputBankTradeDetails
	set Data=$lb(bankTradeNo,terminalNo,bankTradeType,bankTradeAmt,bankTradeDate,bankTradeTime,hisTradeNo)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-03-23
/// Description: 查询HIS业务明细
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillReconciliations","FindHISTradeDetail")
Query FindHISTradeDetail(stDate As %String, endDate As %String, transType As %String, payChannel As %String, patientNo As %String, hospDR As %String) As websys.Query(ROWSPEC = "TRegNo:%String,TPatName:%String,TTradeMsg:%String,TBankTradeNo:%String,TTradeAmt:%Float,TPaymDesc:%String,TTradeType:%String,TUserName:%String,TTradeDate:%String,TTradeTime:%String,THISTradeNo:%String")
{
}

ClassMethod FindHISTradeDetailExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, transType As %String, payChannel As %String, patientNo As %String, hospDR As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
 	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
	set patientId=""
	if (patientNo'="") do
	.set patientId=$o(^PAPERi("PAPMI_PatNo",patientNo,""))
	
 	set tradeTotalAmt=0
 	
 	for date=stDate:1:endDate  do
 	.set tradeDate=##class(websys.Conversions).DateLogicalToHtml(date)
 	.//门诊预交金
 	.if (transType'="I") do
 	..set accM="0"
 	..for  set accM=$o(^DHCACDi("AccM",0,"APDDate",date,accM)) quit:(accM="")  do
 	...set papmi=$p(^DHCACD("AccM",accM),"^",2)
	...quit:(+papmi=0)
 	...quit:((patientId'="")&&(patientId'=papmi))
 	...set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	...set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
	...set accPreSub="0"
	...for  set accPreSub=$o(^DHCACDi("AccM",0,"APDDate",date,accM,"AccPD",accPreSub)) quit:(accPreSub="")  do
	....set accPreInfo=$g(^DHCACD("AccM",accM,"AccPD",accPreSub))
	....quit:(accPreInfo="")
	....set preHospDR=$p(accPreInfo,"^",15)
	....quit:((hospDR'="")&&(hospDR'=preHospDR))
	....set tradeTime=$p(accPreInfo,"^",4)
	....set tradeTime=##class(websys.Conversions).TimeLogicalToHtml(tradeTime, 1)
	....set userDR=$p(accPreInfo,"^",5)
	....set userName=$p(^SSU("SSUSR",userDR),"^",2)
	....set accPMSub=$o(^DHCACD("AccM",accM,"AccPD",accPreSub,"P","0"))
	....quit:(accPMSub="")
	....set accPMInfo=$g(^DHCACD("AccM",accM,"AccPD",accPreSub,"P",accPMSub))
	....set paymDR=$p(accPMInfo,"^",1)
	....quit:('$d(^User.DHCCTPayModeExpI("PMEPayModeDRIndex",(" "_paymDR))))    //过滤非第三方支付的
	....quit:((payChannel'="")&&(payChannel'=paymDR))
	....set paymDesc=$p(^CT("CTPM",paymDR),"^",2)
	....set tradeAmt=$p(accPMInfo,"^",6)
	....quit:(+tradeAmt=0)
	....set tradeTotalAmt=tradeTotalAmt+tradeAmt
	....set tradeType=""
	....if (+tradeAmt>0) do
	.....set tradeType="门诊预交金扣款"
	....else  do
	.....set tradeType="门诊预交金退款"
	....set IBPRowId=$o(^DHCINVBTPi(0,"TTypePM","PRE","PayM",(accM_"||"_accPreSub_"||"_accPMSub),"0"))
	....set bankTradeNo="", hisTradeNo="", tradeMsg=""
	....if (+IBPRowId'=0) do
	.....set tradeRc=$p(^DHCINVBTP(IBPRowId),"^",1)             //IBP_Rc
	.....if (tradeRc="00") do
	......set tradeMsg="交易成功"
	.....set bankTradeNo=$p(^DHCINVBTP(IBPRowId),"^",7)	       //银行交易流水号
	.....set hisTradeNo=$p(^DHCINVBTP(IBPRowId),"^",32)	       //订单号
	....do OutputHISTradeDetail
	..//门诊收费
	..set rowId="0"
    ..for  set rowId=$o(^DHCINVPRT(0,"Date",date,rowId)) quit:(rowId="")  do
	...set invInfo=$g(^DHCINVPRT(rowId))
	...quit:(invInfo="")
 	...set invHospDR=$p(invInfo,"^",39)
	...quit:((hospDR'="")&&(hospDR'=invHospDR))
	...set papmi=$p(invInfo,"^",15)
	...quit:(+papmi=0)
	...quit:((patientId'="")&&(patientId'=papmi))
	...set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	...set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
  	...set userDR=$p(invInfo,"^",21)
	...set userName=$p(^SSU("SSUSR",userDR),"^",2)
	...set tradeTime=$p(invInfo,"^",20)
	...set tradeTime=##class(websys.Conversions).TimeLogicalToHtml(tradeTime, 1)
	...set invPMSub="0"
	...for  set invPMSub=$o(^DHCINVPRT(rowId,"P",invPMSub))  quit:(invPMSub="")  do
	....set paymInfo=$g(^DHCINVPRT(rowId,"P",invPMSub))
	....quit:(paymInfo="")
	....set paymDR=$p(paymInfo,"^",1)
	....quit:('$d(^User.DHCCTPayModeExpI("PMEPayModeDRIndex",(" "_paymDR))))    //过滤非第三方支付的
	....quit:((payChannel'="")&&(payChannel'=paymDR))
	....set paymDesc=$p(^CT("CTPM",paymDR),"^",2)
    ....set tradeAmt=$p(paymInfo,"^",3)
 	....set tradeTotalAmt=tradeTotalAmt+tradeAmt
	....set tradeType=""
	....if (+tradeAmt>0) do
	.....set tradeType="门诊收费扣款"
	....else  do
	.....set tradeType="门诊收费退款"
	....set IBPRowId=$o(^DHCINVBTPi(0,"TTypePM","OP","PayM",(rowId_"||"_invPMSub),"0"))
	....set bankTradeNo="", hisTradeNo="", tradeMsg=""
	....if (+IBPRowId'=0) do
	.....set tradeRc=$p(^DHCINVBTP(IBPRowId),"^",1)             //IBP_Rc
	.....if (tradeRc="00") do
	......set tradeMsg="交易成功"
	.....set bankTradeNo=$p(^DHCINVBTP(IBPRowId),"^",7)	       //银行交易流水号
	.....set hisTradeNo=$p(^DHCINVBTP(IBPRowId),"^",32)	       //订单号
	....do OutputHISTradeDetail
	.if (transType'="O") do
	..//住院押金
	..set rowId="0"
	..for  set rowId=$o(^DHCSFPRINTDETAIL(0,"PrtDate",date,rowId)) quit:(rowId="")  do 
	...set depInfo=$g(^DHCSFPRINTDETAIL(rowId))
	...quit:(depInfo="")
	...set depDeptDR=$p(depInfo,"^",37)    //prt_currdept_dr
 	...set depHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(depDeptDR)
	...quit:((hospDR'="")&&(hospDR'=depHospDR))
	...set userDR=$p(depInfo,"^",14)
	...set userName=$p(^SSU("SSUSR",userDR),"^",2)
	...set tradeTime=$p(depInfo,"^",3)
	...set tradeTime=##class(websys.Conversions).TimeLogicalToHtml(tradeTime, 1)
	...set adm=$p(depInfo,"^",4)
	...set papmi=$p(^PAADM(adm),"^",1)
	...quit:(+papmi=0)
	...quit:((patientId'="")&&(patientId'=papmi))
	...set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	...set regNo=$p(^PAPER(papmi,"PAT",1),"^",1)
    ...set paymDR=$p(depInfo,"^",9)
	...quit:('$d(^User.DHCCTPayModeExpI("PMEPayModeDRIndex",(" "_paymDR))))    //过滤非第三方支付的
	...quit:((payChannel'="")&&(payChannel'=paymDR))
	...set paymDesc=$p(^CT("CTPM",paymDR),"^",2)
    ...set tradeAmt=$p(depInfo,"^",6)
 	...set tradeTotalAmt=tradeTotalAmt+tradeAmt
	...set tradeType=""
	...if (+tradeAmt>0) do
	....set tradeType="住院押金扣款"
	...else  do
	....set tradeType="住院押金退款"
	...set IBPRowId=$o(^DHCINVBTPi(0,"TTypePM","DEP","PayM",rowId,"0"))
	...set bankTradeNo="", hisTradeNo="", tradeMsg=""
	...if (+IBPRowId'=0) do
	....set tradeRc=$p(^DHCINVBTP(IBPRowId),"^",1)             //IBP_Rc
	....if (tradeRc="00") do
	.....set tradeMsg="交易成功"
	....set bankTradeNo=$p(^DHCINVBTP(IBPRowId),"^",7)	       //银行交易流水号
	....set hisTradeNo=$p(^DHCINVBTP(IBPRowId),"^",32)	       //订单号
	...do OutputHISTradeDetail
	..//出院结算
	..set rowId="0"
    ..for  set rowId=$o(^DHCINVPRTZY(0,"DATE",date,rowId)) quit:(rowId="")  do
	...set invInfo=$g(^DHCINVPRTZY(rowId))
 	...quit:(invInfo="")
 	...set adm=$p(invInfo,"^",4)
	...set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
 	...quit:((hospDR'="")&&(hospDR'=admHospDR))
  	...set userDR=$p(invInfo,"^",7)
	...set userName=$p(^SSU("SSUSR",userDR),"^",2)
	...set tradeTime=$p(invInfo,"^",3)
	...set tradeTime=##class(websys.Conversions).TimeLogicalToHtml(tradeTime, 1)
	...set papmi=$p(^PAADM(adm),"^",1)
	...quit:(+papmi=0)
	...quit:((patientId'="")&&(patientId'=papmi))
	...set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	...set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
	...set arrcp=$p(invInfo,"^",17)                       //PRT_ARRCP_DR
	...set arrPMSub="0"
	...for  set arrPMSub=$o(^ARRCP(arrcp,"PAYM",arrPMSub))  quit:(arrPMSub="")  do
	....set paymInfo=$g(^ARRCP(arrcp,"PAYM",arrPMSub))
	....quit:(paymInfo="")
	....set paymDR=$p(paymInfo,"^",1)
    ....quit:('$d(^User.DHCCTPayModeExpI("PMEPayModeDRIndex",(" "_paymDR))))    //过滤非第三方支付的
	....quit:((payChannel'="")&&(payChannel'=paymDR))
	....set paymDesc=$p(^CT("CTPM",paymDR),"^",2)
	....set tradeAmt=$p(paymInfo,"^",3)
	....set tradeTotalAmt=tradeTotalAmt+tradeAmt
	....set tradeType=""
	....if (+tradeAmt>0) do
	.....set tradeType="出院结算扣款"
	....else  do
	.....set tradeType="出院结算退款"
	....set IBPRowId=$o(^DHCINVBTPi(0,"TTypePM","IP","PayM",(arrcp_"||"_arrPMSub),"0"))
	....set bankTradeNo="", hisTradeNo="", tradeMsg=""
	....if (+IBPRowId'=0) do
	.....set tradeRc=$p(^DHCINVBTP(IBPRowId),"^",1)             //IBP_Rc
	.....if (tradeRc="00") do
	......set tradeMsg="交易成功"
	.....set bankTradeNo=$p(^DHCINVBTP(IBPRowId),"^",7)	       //银行交易流水号
	.....set hisTradeNo=$p(^DHCINVBTP(IBPRowId),"^",32)	       //订单号
	....do OutputHISTradeDetail

	set (patName, tradeMsg, bankTradeNo, tradeType, userName, paymDesc, tradeDate, tradeTime, hisTradeNo)=""
	set regNo="合计"
	set tradeAmt=tradeTotalAmt
	do OutputHISTradeDetail
	
	quit $$$OK
OutputHISTradeDetail
	set Data=$lb(regNo,patName,tradeMsg,bankTradeNo,tradeAmt,paymDesc,tradeType,userName,tradeDate,tradeTime,hisTradeNo)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-03-26
/// Description: 查询HIS交易明细
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillReconciliations","FindHISBankTradeDetail","01/03/2018","26/03/2018","","","","2")
Query FindHISBankTradeDetail(stDate As %String, endDate As %String, transType As %String, payChannel As %String, patientNo As %String, hospDR As %String) As websys.Query(ROWSPEC = "TRegNo:%String,TPatName:%String,TUserName:%String,TPaymDesc:%String,TBankTradeNo:%String,TTerminalNo:%String,TTradeType:%String,TBankTradeAmt:%Float,TTradeDate:%String,TTradeTime:%String,THISTradeAmt:%Float,THISTradeNo:%String")
{
}

ClassMethod FindHISBankTradeDetailExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, transType As %String, payChannel As %String, patientNo As %String, hospDR As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1

 	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
	set patientId=""
	if (patientNo'="") do
	.set patientId=$o(^PAPERi("PAPMI_PatNo",patientNo,""))
	
 	set hisTradeTotalAmt=0
 	set bankTradeTotalAmt=0
 	
 	for date=stDate:1:endDate  do
	.set IBPRowId="0"
 	.for  set IBPRowId=$o(^DHCINVBTPi(0,"TradeDate",date,IBPRowId))  quit:(IBPRowId="")  do
	..set tradeInfo=$g(^DHCINVBTP(IBPRowId))
 	..quit:(tradeInfo="")
 	..set tradeRc=$p(tradeInfo,"^",1)
 	..quit:(tradeRc'="00")
	..set tradeType=$p(tradeInfo,"^",26)
	..quit:((transType="O")&&(("^PRE^OP^")'[("^"_tradeType_"^")))
	..quit:((transType="I")&&(("^DEP^IP^")'[("^"_tradeType_"^")))
	..set tradeType=..GetTradeTypeDesc(tradeType)
	..set tradeHospDR=$p(tradeInfo,"^",28)
	..quit:((hospDR'="")&&(hospDR'=tradeHospDR))
	..set userDR=$p(tradeInfo,"^",25)
	..set userName=""
	..if (userDR'="") set userName=$p(^SSU("SSUSR",userDR),"^",2)
	..set tradeDate=$p(tradeInfo,"^",21)			   //HIS交易日期
	..set tradeTime=$p(tradeInfo,"^",22)			   //HIS交易时间
	..set tradeDate=##class(websys.Conversions).DateLogicalToHtml(tradeDate)
	..set tradeTime=##class(websys.Conversions).TimeLogicalToHtml(tradeTime, 1)
	..set bankTradeDate=$p(tradeInfo,"^",14)			   //银行交易日期
	..set bankTradeTime=$p(tradeInfo,"^",15)			   //银行交易时间
	..set bankTradeDate=##class(websys.Conversions).DateLogicalToHtml(bankTradeDate)
	..set bankTradeTime=##class(websys.Conversions).TimeLogicalToHtml(bankTradeTime, 1)
	..set IBPConSub=$o(^DHCINVBTP(IBPRowId,"C","0"))
	..set papmi="", paymDR=""
	..if (IBPConSub'="") do
	...set subPayModeDR=$p(^DHCINVBTP(IBPRowId,"C",IBPConSub),"^",3)
	...set subTradeType=$p(^DHCINVBTP(IBPRowId,"C",IBPConSub),"^",6)
	...if (subTradeType="PRE") do
	....set papmi=$p(^DHCACD("AccM",+subPayModeDR),"^",2)
	....set paymDR=$p(^DHCACD("AccM",+subPayModeDR,"AccPD",$p(subPayModeDR,"||",2),"P",$p(subPayModeDR,"||",3)),"^",3)
	...else  if (subTradeType="OP") do
	....set papmi=$p($g(^DHCINVPRT(+subPayModeDR)),"^",15)
	....set paymDR=$p($g(^DHCINVPRT(+subPayModeDR,"P",$p(subPayModeDR,"||",2))),"^",1)
	...else  if (subTradeType="DEP") do
	....set adm=$p(^DHCSFPRINTDETAIL(+subPayModeDR),"^",4)
	....set papmi=$p(^PAADM(adm),"^",1)
	....set paymDR=$p(^DHCSFPRINTDETAIL(+subPayModeDR),"^",9)
	...else  if (subTradeType="IP") do
	....set papmi=$p(^ARRCP(+subPayModeDR),"^",30)
	....set paymDR=$p(^ARRCP(+subPayModeDR,"PAYM",$p(subPayModeDR,"||",2)),"^",1)
	..quit:((payChannel'="")&&(payChannel'=paymDR))
	..quit:((patientId'="")&&(patientId'=papmi))
	..set paymDesc=""
	..if (+paymDR'=0) set paymDesc=$p(^CT("CTPM",paymDR),"^",2)
	..set regNo="", patName=""
	..if (papmi'="") do
	...set regNo=$p(^PAPER(papmi,"PAT",1),"^",1)
	...set patName=$p(^PAPER(papmi,"ALL"),"^",1)
	..set terminalNo=$p(tradeInfo,"^",9)	                //IBP_Tid
	..set bankTradeAmt=$p(tradeInfo,"^",4)		//交易金额
	..set bankTradeType=$p(tradeInfo,"^",24)                //IBP_BankTradeType
	..if (bankTradeType="C") do
	...set bankTradeTotalAmt=bankTradeTotalAmt+bankTradeAmt
	...set bankTradeType=tradeType_"扣款"
	..else  do
	...set bankTradeTotalAmt=bankTradeTotalAmt-bankTradeAmt
	...set bankTradeType=tradeType_"退款"
	..set bankTradeNo=$p(tradeInfo,"^",7)		    //银行交易流水号
	..set hisTradeNo=$p(tradeInfo,"^",32)		    //订单号
	..set hisTradeAmt=$p(tradeInfo,"^",23)			//应收金额
	..set hisTradeTotalAmt=hisTradeTotalAmt+hisTradeAmt
	..do OutputHISBankTradeDetail

	set (patName, userName, paymDesc, bankTradeNo, terminalNo, tradeType, tradeDate, tradeTime, hisTradeNo)=""
	set regNo="合计"
	set hisTradeAmt=hisTradeTotalAmt
	set bankTradeAmt=bankTradeTotalAmt
	do OutputHISBankTradeDetail
	
	quit $$$OK
OutputHISBankTradeDetail
	set Data=$lb(regNo,patName,userName,paymDesc,bankTradeNo,terminalNo,tradeType,bankTradeAmt,tradeDate,tradeTime,hisTradeAmt,hisTradeNo)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-03-26
/// Description: HIS与第三方对账
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillReconciliations","JudgeTradePay","01/03/2018","25/03/2018","O","","","2")
Query JudgeTradePay(stDate As %String, endDate As %String, transType As %String, payChannel As %String, result As %String, hospDR As %String) As websys.Query(ROWSPEC = "TRegNo:%String,TPatName:%String,TBankTradeNo:%String,TTerminalNo:%String,TBankTradeType:%String,TTradeAmt:%Float,TUserName:%String,TPaymDesc:%String,TBankTradeDate:%String,TBankTradeTime:%String,TJudgeResult:%String,THISTradeNo:%String,TResultMsg:%String")
{
}

ClassMethod JudgeTradePayExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, transType As %String, payChannel As %String, result As %String, hospDR As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
 	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
 	set tradeTotalAmt=0
 	set job=$j
 	kill ^||TMP(job)
 	
 	for date=stDate:1:endDate  do
 	.set tradeDate=##class(websys.Conversions).DateLogicalToHtml(date)
 	.set IBPRowId="0"
 	.for  set IBPRowId=$o(^DHCINVBTPi(0,"TradeDate",date,IBPRowId)) quit:(IBPRowId="")  do
 	..set tradeInfo=$g(^DHCINVBTP(IBPRowId))
 	..quit:(tradeInfo="")
 	..set tradeRc=$p(tradeInfo,"^",1)
 	..quit:(tradeRc'="00")
 	..set hisTradeNo=$p(tradeInfo,"^",32)		//订单号
	..set tradeAmt=$p(tradeInfo,"^",23)			//应收金额
	..set tradeType=$p(tradeInfo,"^",26)
	..quit:((transType="O")&&(("^PRE^OP^")'[("^"_tradeType_"^")))
	..quit:((transType="I")&&(("^DEP^IP^")'[("^"_tradeType_"^")))
	..set tradeType=..GetTradeTypeDesc(tradeType)
	..set tradeHospDR=$p(tradeInfo,"^",28)
	..quit:((hospDR'="")&&(hospDR'=tradeHospDR))
	..set userDR=$p(tradeInfo,"^",25)
	..set userName=""
	..if (userDR'="") set userName=$p(^SSU("SSUSR",userDR),"^",2)
	..set tradeDate=$p(tradeInfo,"^",21)			   //HIS交易日期
	..set tradeTime=$p(tradeInfo,"^",22)			   //HIS交易时间
	..set tradeDate=##class(websys.Conversions).DateLogicalToHtml(tradeDate)
	..set tradeTime=##class(websys.Conversions).TimeLogicalToHtml(tradeTime, 1)
	..set bankTradeDate=$p(tradeInfo,"^",14)			   //银行交易日期
	..set bankTradeTime=$p(tradeInfo,"^",15)			   //银行交易时间
	..set bankTradeDate=##class(websys.Conversions).DateLogicalToHtml(bankTradeDate)
	..set bankTradeTime=##class(websys.Conversions).TimeLogicalToHtml(bankTradeTime, 1)
	..set IBPConSub=$o(^DHCINVBTP(IBPRowId,"C","0"))
	..set papmi="", paymDR=""
	..if (IBPConSub'="") do
	...set subPayModeDR=$p(^DHCINVBTP(IBPRowId,"C",IBPConSub),"^",3)
	...set subTradeType=$p(^DHCINVBTP(IBPRowId,"C",IBPConSub),"^",6)
	...if (subTradeType="PRE") do
	....set papmi=$p(^DHCACD("AccM",+subPayModeDR),"^",2)
	....set paymDR=$p(^DHCACD("AccM",+subPayModeDR,"AccPD",$p(subPayModeDR,"||",2),"P",$p(subPayModeDR,"||",3)),"^",3)
	...else  if (subTradeType="OP") do
	....set papmi=$p($g(^DHCINVPRT(+subPayModeDR)),"^",15)
	....set paymDR=$p($g(^DHCINVPRT(+subPayModeDR,"P",$p(subPayModeDR,"||",2))),"^",1)
	...else  if (subTradeType="DEP") do
	....set adm=$p(^DHCSFPRINTDETAIL(+subPayModeDR),"^",4)
	....set papmi=$p(^PAADM(adm),"^",1)
	....set paymDR=$p(^DHCSFPRINTDETAIL(+subPayModeDR),"^",9)
	...else  if (subTradeType="IP") do
	....set papmi=$p(^ARRCP(+subPayModeDR),"^",30)
	....set paymDR=$p(^ARRCP(+subPayModeDR,"PAYM",$p(subPayModeDR,"||",2)),"^",1)
	..quit:((payChannel'="")&&(payChannel'=paymDR))
	..set paymDesc=""
	..if (+paymDR'=0) set paymDesc=$p(^CT("CTPM",paymDR),"^",2)
	..set regNo="", patName=""
	..if (papmi'="") do
	...set regNo=$p(^PAPER(papmi,"PAT",1),"^",1)
	...set patName=$p(^PAPER(papmi,"ALL"),"^",1)
	..set terminalNo=$p(tradeInfo,"^",9)	                //IBP_Tid
	..set bankTradeType=$p(tradeInfo,"^",24)                //IBP_BankTradeType
	..if (bankTradeType="C") do
	...set bankTradeType=tradeType_"扣款"
	..else  do
	...set bankTradeType=tradeType_"退款"
	..set bankTradeNo=$p(tradeInfo,"^",7)				//银行交易流水号
	..set IBTRowId=$o(^User.DHCINVBankBalanceI("TRADENO",hisTradeNo,""))
	..if (IBTRowId'="") do
	...set ^||TMP(job,IBTRowId)=IBTRowId
	...set IBTAmt=$LIST(^User.DHCINVBankBalanceD(IBTRowId),12)	       //银行交易金额
	...//set IBTAmt=$fn(IBTAmt/100,"",2)
	...set resultMsg=""
	...if ($zabs($fn(tradeAmt,"",2))=$zabs($fn(IBTAmt,"",2))) do
	....set judgeResult="平账"
	...else  do
	....if ($zabs($fn(tradeAmt,"",2))>$zabs($fn(IBTAmt,"",2))) do
	.....set judgeResult="HIS多"
	....else  do
	.....set judgeResult="第三方多"
	....set resultMsg="HIS交易金额:"_$zabs($fn(tradeAmt,"",2))_", "_"回款金额："_$zabs($fn(IBTAmt,"",2))
	..else  do
	...set judgeResult="HIS多"
	...set resultMsg="HIS存在交易记录,回款中不存在记录,交易表ID:"_IBPRowId
	..quit:((result="B")&&(judgeResult'=""))
	..quit:((result="H")&&(judgeResult="第三方多"))
	..quit:((result="T")&&(judgeResult="HIS多"))
	..set tradeTotalAmt=tradeTotalAmt+tradeAmt
	..do OutputJudgeTradePay
	.if (result'="H") do
	..//取对账表差错信息
	..set IBTRowId="0"
	..for  set IBTRowId=$o(^User.DHCINVAliBalanceI("BANKFINDATE",date,IBTRowId)) quit:(IBTRowId="")  do
	...quit:$d(^||TMP(job,IBTRowId))
	...set judgeResult="第三方多"
	...set resultMsg="交易回款中有记录,HIS无对应成功交易记录,回款表ID"_IBTRowId
	...set bankTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowId),5)	       //银行交易流水号
	...set hisTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowId),7)	       //订单号
	...set terminalNo=$LIST(^User.DHCINVBankBalanceD(IBTRowId),11)	       //交易终端号
	...set myHospDR=$LIST(^User.DHCINVBankBalanceD(IBTRowId),9)
	...quit:((hospDR'="")&&(hospDR'=myHospDR))
	...set hospName=""
	...if (+myHospDR'=0)  set hospName=$p(^CT("HOSP",myHospDR),"^",2)   
	...set trannelNo=$LIST(^User.DHCINVBankBalanceD(IBTRowId),15)            //渠道代码
	...set paymDR=$LIST(^User.DHCINVBankBalanceD(IBTRowId),10)		
	...quit:((payChannel'="")&&(payChannel'=paymDR))
	...set paymDesc=""
	...if (+paymDR'=0) set paymDesc=$p(^CT("CTPM",paymDR),"^",2)
	...set userDR=$LIST(^User.DHCINVBankBalanceD(IBTRowId),16)
	...set userName=""
	...if (+userDR'=0) set userName=$p(^SSU("SSUSR",userDR),"^",2)
	...set hisTradeTime=$LIST(^User.DHCINVBankBalanceD(IBTRowId),8)          //yyyyMMddHHmmss
	...set tradeDate=$e(hisTradeTime,1,8)
	...set tradeDate=$zdh(tradeDate,8)
	...set tradeDate=##class(websys.Conversions).DateLogicalToHtml(tradeDate)                        //HIS交易日期
	...set tradeTime=$e(hisTradeTime,9,10)_":"_$e(hisTradeTime,11,12)_":"_$e(hisTradeTime,13,14)	    //HIS交易时间
	...set tradeFlag=$LIST(^User.DHCINVBankBalanceD(IBTRowId),13)
	...set bankTradeType=""
	...if (+tradeFlag=0) set bankTradeType="扣费"
	...if (+tradeFlag=1) set bankTradeType="退费"
	...set tradeAmt=$LIST(^User.DHCINVBankBalanceD(IBTRowId),12)	       //银行交易金额
	...//set bankTradeAmt=$fn(bankTradeAmt/100,"",2)
	...if (+tradeFlag=0) set tradeTotalSum=tradeTotalSum+tradeAmt
	...if (+tradeFlag=1) set tradeTotalSum=tradeTotalSum-tradeAmt
	...set tradeTradeDateTime=$LIST(^User.DHCINVBankBalanceD(IBTRowId),6)
	...set bankTradeDate=$e(tradeTxtDateTime,1,8)
	...set bankTradeTime=$zdh(tradeTxtDateTime,8)
	...set bankTradeDate=##class(websys.Conversions).DateLogicalToHtml(bankTradeDate)
	...set bankTradeTime=$e(tradeTradeDateTime,9,10)_":"_$e(tradeTradeDateTime,11,12)_":"_$e(tradeTradeDateTime,13,14)    
	...do OutputJudgeTradePay
	
	set (patName, bankTradeNo, terminalNo, bankTradeType, userName, paymDesc, bankTradeDate, bankTradeTime, hisTradeNo, judgeResult, resultMsg)=""
	set regNo="合计"
	set tradeAmt=tradeTotalAmt
	do OutputJudgeTradePay
	
	quit $$$OK
OutputJudgeTradePay
	set Data=$lb(regNo,patName,bankTradeNo,terminalNo,bankTradeType,tradeAmt,userName,paymDesc,bankTradeDate,bankTradeTime,judgeResult,hisTradeNo,resultMsg)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-03-26
/// Description: 取交易类型描述
/// Input: 
/// Output:
/// Debug: w ##class(web.DHCBillReconciliations).GetTradeTypeDesc("OP")
ClassMethod GetTradeTypeDesc(code As %String)
{
	new (code)
	set desc=$case(code, "CARD":"卡费", "PRE":"门诊预交金", "OP":"门诊收费", "DEP":"住院押金", "IP":"出院结算", :"")
	quit desc
}

}
