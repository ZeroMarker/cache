/// 名称: web.DHCOPBillDailyDetails.cls
/// 描述: 计费日报明细
/// 编写者：ZhYW
/// 编写日期: 2018-03-08
Class web.DHCOPBillDailyDetails Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator: ZhYW
/// CreatDate: 2018-03-08
/// Description: 卡费明细
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillDailyDetails","FindCardInvDetails","","","","","33050", "5", "2")
Query FindCardInvDetails(stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String, langId As %String) As websys.Query(ROWSPEC = "TCardInvDate:%String,TCardInvTime:%String,TPatName:%String,TRegNo:%String,TCardInvSum:%String,TPaymDesc:%String,TStatus:%String,TCardInvId:%String,TCardInvFootDR:%String,TEncryptLevel:%String,TPatLevel:%String")
{
}

ClassMethod FindCardInvDetailsExecute(ByRef qHandle As %Binary, stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String, langId As %String) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if ((footId="")&&((stDate="")||(endDate=""))) quit $$$OK
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
    set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime, 1)
    set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime, 1)
    
    //若footId是预结算记录，查询明细按未结算查询
	set footId=..GetTMPFootID(footId)
    
	set cardInvTotalSum=0

    if (footId="") do
    .//未结算
    .for date=stDate:1:endDate  do
    ..set cardInvId=0
    ..for  set cardInvId=$o(^DHCCARDINVPRTi(0,"Date",date,cardInvId)) quit:(cardInvId="")  do
    ...set cardInvInfo=$g(^DHCCARDINVPRT(cardInvId))
    ...quit:(cardInvInfo="")
    ...set cardInvFootDR=$p(cardInvInfo,"^",9)    //CIP_INVReports_DR
    ...quit:(+cardInvFootDR'=0)
    ...set cardInvHospDR=$p(cardInvInfo,"^",20)
    ...quit:((hospDR'="")&&(hospDR'=cardInvHospDR))
    ...set userDR=$p(cardInvInfo,"^",6)
    ...quit:((guser'="")&&(guser'=userDR))
	...set cardInvTime=$p(cardInvInfo,"^",5)
	...quit:((date=endDate)&&(cardInvTime>endTime))
	...do GetCardInvDetails
    else  do
    .//已结算
	.set cardInvId=0
	.for  set cardInvId=$o(^DHCCARDINVPRTi(0,"Report",footId,cardInvId)) quit:(cardInvId="")  do
	..set cardInvInfo=$g(^DHCCARDINVPRT(cardInvId))
	..quit:(cardInvInfo="")
	..do GetCardInvDetails
	
	set cardInvDate=##class(websys.Translation).Get("", "合计")
	set cardInvSum=$fn(cardInvTotalSum,"",2)
	set (cardInvTime, patName, regNo, paymDesc, status, cardInvId, cardInvFootDR, encryptLevel, patLevel)=""
	do OutputCardInvDetails
	
	quit $$$OK

GetCardInvDetails
	set papmi=$p(cardInvInfo,"^",1)
	quit:(+papmi=0)
	set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
	set patEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(papmi, "")
	set encryptLevel=$p(patEncryptLevel,"^",1)
	set patLevel=$p(patEncryptLevel,"^",2)
	set cardInvDate=$p(cardInvInfo,"^",4)
	set cardInvTime=$p(cardInvInfo,"^",5)
	set cardInvDate=##class(websys.Conversions).DateLogicalToHtml(cardInvDate)
	set cardInvTime=##class(websys.Conversions).TimeLogicalToHtml(cardInvTime,1)
	set cardInvFootDR=$p(cardInvInfo,"^",9)      //CIP_INVReports_DR
	set cardInvStatus=$p(cardInvInfo,"^",2)      //CIP_Flag
	set status=$case(cardInvStatus,"N":"正常","S":"红冲","A":"作废",:"")
	set status=##class(websys.Translation).Get("", status)
	set cardInvSum=$p(cardInvInfo,"^",3)         //CIP_Amount
	set cardInvSum=$fn(cardInvSum,"",2)
	set cardInvTotalSum=$i(cardInvTotalSum, cardInvSum)    //合计金额
	set cardInvPMSub=$o(^DHCCARDINVPRT(cardInvId,"P",0))
	quit:(cardInvPMSub="")
	set cardInvPMInfo=$g(^DHCCARDINVPRT(cardInvId,"P",cardInvPMSub))
	set paymDR=$p(cardInvPMInfo,"^",1)
	set paymDesc=$s((+paymDR'=0):$p($g(^CT("CTPM",paymDR)),"^",2),1:"")
	set paymDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", paymDesc, langId)
	do OutputCardInvDetails
	
	quit 
	
OutputCardInvDetails
	set Data=$lb(cardInvDate,cardInvTime,patName,regNo,cardInvSum,paymDesc,status,cardInvId,cardInvFootDR,encryptLevel,patLevel)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-03-08
/// Description: 门诊预交金明细
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillDailyDetails","FindAccPreDetails","16/03/2018","20:00:00","19/03/2018","12:30:55","","5","2")
Query FindAccPreDetails(stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String, langId As %String) As websys.Query(ROWSPEC = "TPreDate:%String,TPreTime:%String,TPatName:%String,TRegNo:%String,TPreSum:%String,TPaymDesc:%String,TStatus:%String,TRowId:%String,TBillNo:%String,TPreFootDR:%String,TPreDepType:%String,TEncryptLevel:%String,TPatLevel:%String")
{
}

ClassMethod FindAccPreDetailsExecute(ByRef qHandle As %Binary, stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String, langId As %String) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if ((footId="")&&((stDate="")||(endDate=""))) quit $$$OK

	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
    set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime, 1)
    set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime, 1)
    
	//若footId是预结算记录，查询明细按未结算查询
    set footId=..GetTMPFootID(footId)
	
	kill ^||TMP($j)
    set preTotalSum=0
    
    if (footId="") do
    .//未结算
    .for date=stDate:1:endDate  do
    ..set accM=0
    ..for  set accM=$o(^DHCACDi("AccM",0,"APDDate",date,accM)) quit:(accM="")  do
    ...set accPreSub=0
    ...for  set accPreSub=$o(^DHCACDi("AccM",0,"APDDate",date,accM,"AccPD",accPreSub)) quit:(accPreSub="")  do
	....set accPreInfo=$g(^DHCACD("AccM",accM,"AccPD",accPreSub))
	....quit:(accPreInfo="")
	....set preFootDR=$p(accPreInfo,"^",7)        //AccPD_PDFoot_DR
    ....quit:(+preFootDR'=0)
    ....set preHospDR=$p(accPreInfo,"^",15)
    ....quit:((hospDR'="")&&(hospDR'=preHospDR))
    ....set preUserDR=$p(accPreInfo,"^",5)
    ....quit:((guser'="")&&(guser'=preUserDR))
    ....set preDate=$p(accPreInfo,"^",3)
	....set preTime=$p(accPreInfo,"^",4)
	....quit:((date=endDate)&&(preTime>endTime))
	....set rowId=accM_"||"_accPreSub
	....set ^||TMP($j,preDate,preTime,rowId)=""
    else  do
    .//已结算
    .set accM=0
    .for  set accM=$o(^DHCACDi("AccM",0,"PDFootDR",footId,accM)) quit:(accM="")  do
    ..set accPreSub=0
    ..for  set accPreSub=$o(^DHCACDi("AccM",0,"PDFootDR",footId,accM,"AccPD",accPreSub)) quit:(accPreSub="")  do
	...set accPreInfo=$g(^DHCACD("AccM",accM,"AccPD",accPreSub))
	...quit:(accPreInfo="")
	...set preDate=$p(accPreInfo,"^",3)
	...set preTime=$p(accPreInfo,"^",4)
	...set rowId=accM_"||"_accPreSub
	...set ^||TMP($j,preDate,preTime,rowId)=""
	
	set date=""
	for  set date=$o(^||TMP($j,date))  quit:(date="")  do
	.set time=""
	.for  set time=$o(^||TMP($j,date,time))  quit:(time="")  do
	..set rowId=""
	..for  set rowId=$o(^||TMP($j,date,time,rowId))  quit:(rowId="")  do
	...do GetAccPreDetails
	
	set preDate=##class(websys.Translation).Get("", "合计")
	set preSum=$fn(preTotalSum,"",2)
	set (preTime, patName, regNo, paymDesc, status, rowId, billNo, preFootDR, preDepType, encryptLevel, patLevel)=""
	do OutputAccPreDetails
	
	kill ^||TMP($j)
	quit $$$OK

GetAccPreDetails
	set accM=$p(rowId,"||",1)
	set accPreSub=$p(rowId,"||",2)
	set accPreInfo=$g(^DHCACD("AccM",accM,"AccPD",accPreSub))
	set papmi=$p(^DHCACD("AccM",accM),"^",2)
	quit:(+papmi=0)
	set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
	set patEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(papmi, "")
	set encryptLevel=$p(patEncryptLevel,"^",1)
	set patLevel=$p(patEncryptLevel,"^",2)
	set preStatus=$p(accPreInfo,"^",1)      //AccPD_Type
	set status=$case(preStatus,"P":"交款","R":"退款","F":"账户结算退款",:"")
	set status=##class(websys.Translation).Get("", status)
	set preDate=$p(accPreInfo,"^",3)
	set preTime=$p(accPreInfo,"^",4)
	set preDate=##class(websys.Conversions).DateLogicalToHtml(preDate)
	set preTime=##class(websys.Conversions).TimeLogicalToHtml(preTime,1)
	set billNo=$p(accPreInfo,"^",6)
	set preFootDR=$p(accPreInfo,"^",7)      //AccPD_PDFoot_DR
	set preSum=$p(accPreInfo,"^",2)         //AccPD_PreSum
	set preSum=$fn(preSum,"",2)
	set preTotalSum=$i(preTotalSum, preSum)      //合计金额
	set preDepTypeDR=$p(accPreInfo,"^",10)  //AccPD_DepType_DR
	set preDepType=$s((+preDepTypeDR'=0):$p($g(^ARC("ARCDT",preDepTypeDR)),"^",2),1:"")
	set preDepType=##class(User.ARCDepType).GetTranByDesc("ARCDTDesc", preDepType, langId)
	set accPMSub=$o(^DHCACD("AccM",accM,"AccPD",accPreSub,"P",0))
	quit:(accPMSub="")
	set accPMInfo=$g(^DHCACD("AccM",accM,"AccPD",accPreSub,"P",accPMSub))
	set paymDR=$p(accPMInfo,"^",1)
	set paymDesc=$s((+paymDR'=0):$p($g(^CT("CTPM",paymDR)),"^",2),1:"")
	set paymDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", paymDesc, langId)
	do OutputAccPreDetails
	
	quit
	
OutputAccPreDetails
	set Data=$lb(preDate,preTime,patName,regNo,preSum,paymDesc,status,rowId,billNo,preFootDR,preDepType,encryptLevel,patLevel)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-03-08
/// Description: 急诊留观押金明细
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillDailyDetails","FindEPPreDetails","16/03/2018","20:00:00","19/03/2018","12:30:55","","5","2")
Query FindEPPreDetails(stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String, langId As %String) As websys.Query(ROWSPEC = "TPreDate:%String,TPreTime:%String,TPatName:%String,TRegNo:%String,TPreSum:%String,TPaymDesc:%String,TStatus:%String,TRowId:%String,TBillNo:%String,TPreFootDR:%String,TEncryptLevel:%String,TPatLevel:%String")
{
}

ClassMethod FindEPPreDetailsExecute(ByRef qHandle As %Binary, stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String, langId As %String) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if ((footId="")&&((stDate="")||(endDate=""))) quit $$$OK

	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
    set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime, 1)
    set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime, 1)
    
	//若footId是预结算记录，查询明细按未结算查询
    set footId=..GetTMPFootID(footId)
    
	kill ^||TMP($j)
    set preTotalSum=0
    
    if (footId="") do
    .//未结算
    .for date=stDate:1:endDate  do
	..set epM=0
	..for  set epM=$o(^DHCEPMi("EPM",0,"EPMDPreDate",date,epM)) quit:(epM="")  do
	...set epPreSub=0
	...for  set epPreSub=$o(^DHCEPMi("EPM",0,"EPMDPreDate",date,epM,"EPMD",epPreSub)) quit:(epPreSub="")  do
	....set epPreInfo=$g(^DHCEPM("EPM",epM,"EPMD",epPreSub))
	....quit:(epPreInfo="")
	....set preFootDR=$p(epPreInfo,"^",7)
	....quit:(+preFootDR'=0)
	....set preHospDR=$p(epPreInfo,"^",13)
    ....quit:((hospDR'="")&&(hospDR'=preHospDR))
	....set preUserDR=$p(epPreInfo,"^",5)
	....quit:((guser'="")&&(guser'=preUserDR))
	....set preDate=$p(epPreInfo,"^",3)
	....set preTime=$p(epPreInfo,"^",4)
	....quit:((date=endDate)&&(preTime>endTime))
	....set rowId=epM_"||"_epPreSub
	....set ^||TMP($j,preDate,preTime,rowId)=""
    else  do
    .//已结算
    .set epM=0
    .for  set epM=$o(^DHCEPMi("EPM",0,"EPMDReport",footId,epM)) quit:(epM="")  do
    ..set epPreSub=0
    ..for  set epPreSub=$o(^DHCEPMi("EPM",0,"EPMDReport",footId,epM,"EPMD",epPreSub)) quit:(epPreSub="")  do
	...set epPreInfo=$g(^DHCEPM("EPM",epM,"EPMD",epPreSub))
	...quit:(epPreInfo="")
	...set preDate=$p(epPreInfo,"^",3)
	...set preTime=$p(epPreInfo,"^",4)
	...set rowId=epM_"||"_epPreSub
	...set ^||TMP($j,preDate,preTime,rowId)=""
	
	set date=""
	for  set date=$o(^||TMP($j,date))  quit:(date="")  do
	.set time=""
	.for  set time=$o(^||TMP($j,date,time))  quit:(time="")  do
	..set rowId=""
	..for  set rowId=$o(^||TMP($j,date,time,rowId))  quit:(rowId="")  do
	...do GetEPPreDetails
	
	set preDate=##class(websys.Translation).Get("",  "合计")
	set preSum=$fn(preTotalSum,"",2)
	set (preTime, patName, regNo, paymDesc, status, rowId, billNo, preFootDR, encryptLevel, patLevel)=""
	do OutputEPPreDetails
	
	kill ^||TMP($j)
	quit $$$OK

GetEPPreDetails
	set epM=$p(rowId,"||",1)
	set epPreSub=$p(rowId,"||",2)
	set epPreInfo=$g(^DHCEPM("EPM",epM,"EPMD",epPreSub))
	set papmi=$p(^DHCEPM("EPM",epM),"^",3)
	quit:(+papmi=0)
	set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
	set patEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(papmi, "")
	set encryptLevel=$p(patEncryptLevel,"^",1)
	set patLevel=$p(patEncryptLevel,"^",2)
	set preDate=$p(epPreInfo,"^",3)
	set preTime=$p(epPreInfo,"^",4)
	set preDate=##class(websys.Conversions).DateLogicalToHtml(preDate)
	set preTime=##class(websys.Conversions).TimeLogicalToHtml(preTime, 1)
	set billNo=$p(epPreInfo,"^",6)
	set preFootDR=$p(epPreInfo,"^",7)      //EPMD_Report_DR
	set preStatus=$p(epPreInfo,"^",1)      //EPMD_Type
	set status=$case(preStatus,"P":"交款","R":"退款","F":"账户结算退款",:"")
	set preStatus=##class(websys.Translation).Get("", preStatus)
	set preSum=$p(epPreInfo,"^",2)        //EPMD_PreSum
	set preSum=$fn(preSum,"",2)
	set preTotalSum=preTotalSum+preSum    //合计金额
	set epPMSub=$o(^DHCEPM("EPM",epM,"EPMD",epPreSub,"P",0))
	quit:(epPMSub="")
	set accPMInfo=$g(^DHCEPM("EPM",epM,"EPMD",epPreSub,"P",epPMSub))
	set paymDR=$p(accPMInfo,"^",1)
	set paymDesc=$s((+paymDR'=0):$p($g(^CT("CTPM",paymDR)),"^",2),1:"")
	set paymDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", paymDesc, langId)
	do OutputEPPreDetails
	
	quit
	
OutputEPPreDetails
	set Data=$lb(preDate,preTime,patName,regNo,preSum,paymDesc,status,rowId,billNo,preFootDR,encryptLevel,patLevel)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-03-08
/// Description: 门诊收费明细
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillDailyDetails","FindOPBillInvDetails","2021-11-22","23:59:59","2021-11-23","11:23:52","","5","2","1")
Query FindOPBillInvDetails(stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String, langId As %String) As websys.Query(ROWSPEC = "TInvDate:%String,TInvTime:%String,TPatName:%String,TRegNo:%String,TInvSum:%String,TStatus:%String,TInvNo:%String,TRowId:%String,TInitInvDR:%String,TInvFootDR:%String,TAdmReaDesc:%String,TInvRoundErrSum:%String,TEncryptLevel:%String,TPatLevel:%String,TPaym1:%String,TPaym2:%String,TPaym3:%String,TPaym4:%String,TPaym5:%String,TPaym6:%String,TPaym7:%String,TPaym8:%String,TPaym9:%String,TPaym10:%String,TPaym11:%String,TPaym12:%String,TPaym13:%String,TPaym14:%String,TPaym15:%String,TPaym16:%String,TPaym17:%String,TPaym18:%String,TPaym19:%String,TPaym20:%String,TPaym21:%String,TPaym22:%String,TPaym23:%String,TPaym24:%String,TPaym25:%String,TPaym26:%String,TPaym27:%String,TPaym28:%String,TPaym29:%String,TPaym30:%String")
{
}

ClassMethod FindOPBillInvDetailsExecute(ByRef qHandle As %Binary, stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String, langId As %String) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if ((footId="")&&((stDate="")||(endDate=""))) quit $$$OK
	Set ^TMP("FindOPBillInvDetails")=$lb(stDate , stTime, endDate , endTime , footId , guser, hospDR , langId)
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
    set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime, 1)
    set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime, 1)
    
	//若footId是预结算记录，查询明细按未结算查询
    set footId=..GetTMPFootID(footId)

    set invTotalSum=0
    set invRoundErrSum=0
    set job=$j
	kill ^||TMPPAYMODE("TOTAL",job)    //存放支付方式汇总金额

    if (footId="") do
    .//未结算
    .for date=stDate:1:endDate  do
    ..set rowId=0
    ..for  set rowId=$o(^DHCINVPRT(0,"Date",date,rowId)) quit:(rowId="")  do
    ...set invInfo=$g(^DHCINVPRT(rowId))
    ...quit:(invInfo="")
    ...set invFootDR=$p(invInfo,"^",6)    //PRT_DHCINVPRTR_DR
    ...quit:(+invFootDR'=0)
    ...set invHospDR=$p(invInfo,"^",39)
    ...quit:((hospDR'="")&&(hospDR'=invHospDR))
    ...set userDR=$p(invInfo,"^",21)
    ...quit:((guser'="")&&(guser'=userDR))
	...set invTime=$p(invInfo,"^",20)
	...quit:((date=endDate)&&(invTime>endTime))
	...do GetOPBillInvDetails
    else  do
    .//已结算
	.set rowId=0
	.for  set rowId=$o(^DHCINVPRT(0,"Report",footId,rowId)) quit:(rowId="")  do
	..set invInfo=$g(^DHCINVPRT(rowId))
	..quit:(invInfo="")
	..do GetOPBillInvDetails
	set invDate=##class(websys.Translation).Get("", "合计")
	set invSum=$fn(invTotalSum,"",2)
	set invRoundErr=$fn(invRoundErrSum,"",2)
	set (invTime, patName, regNo, status, invNo, rowId, initInvDR, invFootDR, admReaDesc, encryptLevel, patLevel)=""
	do BuildPaymAmtAry("TOTAL")
	
	do OutputOPBillInvDetails
		
	quit $$$OK

GetOPBillInvDetails
	set papmi=$p(invInfo,"^",15)
	quit:(+papmi=0)
	set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
	set patEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(papmi, "")
	set encryptLevel=$p(patEncryptLevel,"^",1)
	set patLevel=$p(patEncryptLevel,"^",2)
	set invDate=$p(invInfo,"^",5)
	set invTime=$p(invInfo,"^",20)
	set invDate=##class(websys.Conversions).DateLogicalToHtml(invDate)
	set invTime=##class(websys.Conversions).TimeLogicalToHtml(invTime,1)
	set invFootDR=$p(invInfo,"^",6)            //PRT_DHCINVPRTR_DR
	set insuTypeDR=$p(invInfo,"^",9)           //PRT_InsType_DR
	set admReaDesc=$s((+insuTypeDR'=0):$p(^PAC("ADMREA",insuTypeDR),"^",2),1:"")
	set admReaDesc=##class(User.PACAdmReason).GetTranByDesc("READesc", admReaDesc, langId)
	set initInvDR=$p(invInfo,"^",13)         //PRT_initInv_DR
	set invNo=$p(invInfo,"^",14)
	set invFlag=$p(invInfo,"^",8)            //PRT_Flag
	set status=$case(invFlag,"TP":"预结算","N":"正常","A":"作废","S":$s((+initInvDR'=0):"红冲",1:"正常"))
	set status=##class(websys.Translation).Get("", status)
	set invSum=$p(invInfo,"^",1)                      //PRT_Acount
	set invSum=$fn(invSum,"",2)
	set invTotalSum=$i(invTotalSum, invSum)
	set invRoundErr=$p(invInfo,"^",37)                //PRT_OPCRoundErr
	set invRoundErr=$fn(invRoundErr,"",2)
	set invRoundErrSum=$i(invRoundErrSum, invRoundErr)
	
	kill ^||TMPPAYMODE("SINGLE",job)      //存放单张发票支付方式金额
	
	set invPMSub=0
	for  set invPMSub=$o(^DHCINVPRT(rowId,"P",invPMSub))  quit:(invPMSub="")  do
	.set paymInfo=$g(^DHCINVPRT(rowId,"P",invPMSub))
	.quit:(paymInfo="")
	.set paymDR=$p(paymInfo,"^",1)
    .set paymAmt=$p(paymInfo,"^",3)
    .set ^||TMPPAYMODE("SINGLE",job,paymDR)=+$g(^||TMPPAYMODE("SINGLE",job,paymDR))+paymAmt
	.set ^||TMPPAYMODE("TOTAL",job,paymDR)=$g(^||TMPPAYMODE("TOTAL",job,paymDR))+paymAmt
	
	do BuildPaymAmtAry("SINGLE")
	
	do OutputOPBillInvDetails
	
	quit

BuildPaymAmtAry(note)
	kill paym
	set i=0
	set paymId=0
	while($o(^CT("CTPM",paymId))) {
		set paymId=$o(^CT("CTPM",paymId))
		set paymData=$g(^CT("CTPM",paymId))
		continue:(paymData="")
		set dateFrom=$p(paymData,"^",5)
		set dateTo=$p(paymData,"^",6)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set paymAmt=+$g(^||TMPPAYMODE(note,job,paymId))
		set paym($i(i))=$fn(paymAmt,"",2)
	}
	
	kill ^||TMPPAYMODE(note,job)
	
	quit 
	
OutputOPBillInvDetails
	set Data=$lb(invDate,invTime,patName,regNo,invSum,status,invNo,rowId,initInvDR,invFootDR,admReaDesc,invRoundErr,encryptLevel,patLevel,paym(1),paym(2),paym(3),paym(4),paym(5),paym(6),paym(7),paym(8),paym(9),paym(10),paym(11),paym(12),paym(13),paym(14),paym(15),paym(16),paym(17),paym(18),paym(19),paym(20),paym(21),paym(22),paym(23),paym(24),paym(25),paym(26),paym(27),paym(28),paym(29),paym(30))
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-03-08
/// Description: 门诊集中打印发票明细
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillDailyDetails","FindAccPayInvDetails","06/03/2018","14/03/2018","14/03/2018","16:55:19","","5","2")
Query FindAccPayInvDetails(stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String, langId As %String) As websys.Query(ROWSPEC = "TInvDate:%String,TInvTime:%String,TPatName:%String,TRegNo:%String,TInvSum:%String,TStatus:%String,TInvNo:%String,TRowId:%String,TInitInvDR:%String,TInvFootDR:%String,TAdmReaDesc:%String,TInvRoundErrSum:%String,TEncryptLevel:%String,TPatLevel:%String,TPaym1:%String,TPaym2:%String,TPaym3:%String,TPaym4:%String,TPaym5:%String,TPaym6:%String,TPaym7:%String,TPaym8:%String,TPaym9:%String,TPaym10:%String,TPaym11:%String,TPaym12:%String,TPaym13:%String,TPaym14:%String,TPaym15:%String,TPaym16:%String,TPaym17:%String,TPaym18:%String,TPaym19:%String,TPaym20:%String,TPaym21:%String,TPaym22:%String,TPaym23:%String,TPaym24:%String,TPaym25:%String,TPaym26:%String,TPaym27:%String,TPaym28:%String,TPaym29:%String,TPaym30:%String")
{
}

ClassMethod FindAccPayInvDetailsExecute(ByRef qHandle As %Binary, stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String, langId As %String) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if ((footId="")&&((stDate="")||(endDate=""))) quit $$$OK

	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
    set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime, 1)
    set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime, 1)
    
	//若footId是预结算记录，查询明细按未结算查询
    set footId=..GetTMPFootID(footId)

    set invTotalSum=0
    set invRoundErrSum=0
    set job=$j
	kill ^||TMPPAYMODE("TOTAL",job)    //存放支付方式汇总金额

    if (footId="") do
    .//未结算
    .for date=stDate:1:endDate  do
    ..set rowId=0
    ..for  set rowId=$o(^DHCINVPRTAPi(0,"Date",date,rowId)) quit:(rowId="")  do
    ...set invInfo=$g(^DHCINVPRTAP(rowId))
    ...quit:(invInfo="")
    ...set invFootDR=$p(invInfo,"^",20)    //API_INVRep_DR
    ...quit:(+invFootDR'=0)
    ...set invHospDR=$p(invInfo,"^",30)
    ...quit:((hospDR'="")&&(hospDR'=invHospDR))
    ...set userDR=$p(invInfo,"^",5)
    ...quit:((guser'="")&&(guser'=userDR))
	...set invTime=$p(invInfo,"^",4)
	...quit:((date=endDate)&&(invTime>endTime))
	...do GetAccPayInvDetails
    else  do
    .//已结算
	.set rowId=0
	.for  set rowId=$o(^DHCINVPRTAPi(0,"INVRep",footId,rowId)) quit:(rowId="")  do
	..set invInfo=$g(^DHCINVPRTAP(rowId))
	..quit:(invInfo="")
	..do GetAccPayInvDetails
	
	set invDate=##class(websys.Translation).Get("", "合计")
	set invSum=$fn(invTotalSum,"",2)
	set invRoundErr=$fn(invRoundErrSum,"",2)
	set (invTime, patName, regNo, status, invNo, rowId, initInvDR, invFootDR, admReaDesc, encryptLevel, patLevel)=""
	do BuildPaymAmtAry("TOTAL")
	
	do OutputAccPayInvDetails
		
	quit $$$OK

GetAccPayInvDetails
	set papmi=$p(invInfo,"^",11)
	quit:(+papmi=0)
	set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
	set patEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(papmi, "")
	set encryptLevel=$p(patEncryptLevel,"^",1)
	set patLevel=$p(patEncryptLevel,"^",2)
	set invDate=$p(invInfo,"^",3)
	set invTime=$p(invInfo,"^",4)
	set invDate=##class(websys.Conversions).DateLogicalToHtml(invDate)
	set invTime=##class(websys.Conversions).TimeLogicalToHtml(invTime, 1)
	set invFootDR=$p(invInfo,"^",20)      //API_INVRep_DR
	set insuTypeDR=$p(invInfo,"^",31)     //API_InsType_DR
	set admReaDesc=$s((+insuTypeDR'=0):$p(^PAC("ADMREA",insuTypeDR),"^",2),1:"")
	set admReaDesc=##class(User.PACAdmReason).GetTranByDesc("READesc", admReaDesc, langId)
	set initInvDR=$p(invInfo,"^",10)      //API_PayINV_DR
	set invNo=$p(invInfo,"^",6)           //API_INVNo
	set invFlag=$p(invInfo,"^",2)         //API_Flag
	set status=$case(invFlag,"N":"正常","A":"作废","S":$s((+initInvDR'=0):"红冲",1:"正常"))
	set status=##class(websys.Translation).Get("", status)
	set invSum=$p(invInfo,"^",1)                      //API_Amount
	set invSum=$fn(invSum,"",2)
	set invTotalSum=$i(invTotalSum, invSum)
	set invRoundErr=$p(invInfo,"^",23)                //API_OPCRoundSum
	set invRoundErr=$fn(invRoundErr,"",2)
	set invRoundErrSum=$i(invRoundErrSum, invRoundErr)
	
	kill ^||TMPPAYMODE("SINGLE",job)      //存放单张发票支付方式金额
	
	set invPMSub=0
	for  set invPMSub=$o(^DHCINVPRTAP(rowId,"P",invPMSub))  quit:(invPMSub="")  do
	.set paymInfo=$g(^DHCINVPRTAP(rowId,"P",invPMSub))
	.quit:(paymInfo="")
	.set paymDR=$p(paymInfo,"^",1)
    .set paymAmt=$p(paymInfo,"^",3)
    .set ^||TMPPAYMODE("SINGLE",job,paymDR)=+$g(^||TMPPAYMODE("SINGLE",job,paymDR))+paymAmt
	.set ^||TMPPAYMODE("TOTAL",job,paymDR)=$g(^||TMPPAYMODE("TOTAL",job,paymDR))+paymAmt
	
	do BuildPaymAmtAry("SINGLE")
	
	do OutputAccPayInvDetails
	
	quit
	
OutputAccPayInvDetails
	set Data=$lb(invDate,invTime,patName,regNo,invSum,status,invNo,rowId,initInvDR,invFootDR,admReaDesc,invRoundErr,encryptLevel,patLevel,paym(1),paym(2),paym(3),paym(4),paym(5),paym(6),paym(7),paym(8),paym(9),paym(10),paym(11),paym(12),paym(13),paym(14),paym(15),paym(16),paym(17),paym(18),paym(19),paym(20),paym(21),paym(22),paym(23),paym(24),paym(25),paym(26),paym(27),paym(28),paym(29),paym(30))
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-12-10
/// Description: 若footId是预结算记录，查询明细按未结算查询(结账ID返回空)
/// Input: DHC_INVPRTReports.RowID
/// Return: 
/// Debug: w ##class(web.DHCOPBillDailyDetails).GetTMPFootID()
ClassMethod GetTMPFootID(footId As %String) As %String
{
	new (footId)
	quit:(footId="") footId
	set preHandinFlag=$p($g(^DHCOPInsFoot(footId)),"^",68)
	quit $case(preHandinFlag,"Y":"",:footId)
}

}
