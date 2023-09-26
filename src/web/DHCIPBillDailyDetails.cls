/// 名称: web.DHCIPBillDailyDetails.cls
/// 描述: 计费住院日报明细
/// 编写者：ZhYW
/// 编写日期: 2018-03-16
Class web.DHCIPBillDailyDetails Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2018-03-16
/// Description: 住院押金明细
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillDailyDetails","FindIPDepDetails","2019-09-10","15:49:17","2019-09-10","15:49:17","","10207","2")
Query FindIPDepDetails(stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String, langId As %String = "") As websys.Query(ROWSPEC = "TDepDate:%String,TDepTime:%String,TPatName:%String,TMedicareNo:%String,TRegNo:%String,TRcptNo:%String,TDepAmt:%String,TPaymDesc:%String,TStatus:%String,TDepDeptDesc:%String,TRowId:%String,TDepFootDR:%String,TDepTypeDesc:%String,TEncryptLevel:%String,TPatLevel:%String")
{
}

ClassMethod FindIPDepDetailsExecute(ByRef qHandle As %Binary, stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindIPDepDetails")=$lb(stDate, stTime, endDate, endTime, footId, guser, hospDR)
	if ((footId="")&&((stDate="")||(endDate=""))) quit $$$OK
	
    set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime, 1)
	set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime, 1)
	
	set depTotalSum=0

    if (footId="") {
	    //未结算
	    for date=stDate:1:endDate {
			set depId=0
			while($o(^DHCSFPRINTDETAIL(0,"PrtDate",date,depId))) {
				set depId=$o(^DHCSFPRINTDETAIL(0,"PrtDate",date,depId))
				set depData=$g(^DHCSFPRINTDETAIL(depId))
			    continue:(depData="")
				set depFootDR=$p(depData,"^",30)    //prt_jk_dr
			    continue:(+depFootDR'=0)
			    set depDeptDR=$p(depData,"^",37)    //prt_currdept_dr
			    set depHospDR=$p(depData,"^",44)    //wangjian 2018-11-02
			    continue:(depHospDR'=hospDR)
				set userDR=$p(depData,"^",14)
			    continue:((guser'="")&&(guser'=userDR))
				set depTime=$p(depData,"^",3)
				continue:((date=endDate)&&(depTime>endTime))
				do GetIPDepDetails
			}
	    }
    }else {
		//已结算
		set depId=0
		while($o(^DHCSFPRINTDETAIL(0,"JKDR",footId,depId))) {
			set depId=$o(^DHCSFPRINTDETAIL(0,"JKDR",footId,depId))
			set depData=$g(^DHCSFPRINTDETAIL(depId))
			continue:(depData="")
			do GetIPDepDetails
		}
    }
    
	set (depTime, patName, mrNo, regNo, rcptNo, paymDesc, status, depDeptDesc, depId, depFootDR, depTypeDesc, encryptLevel, patLevel)=""
	set depDate=##class(websys.Translation).Get("", "合计")
	set depAmt=$fn(depTotalSum,"",2)
	do OutputIPDepDetails
	
	quit $$$OK

GetIPDepDetails
	set rcptNo=$p(depData,"^",1)
	set depTypeDR=$p(depData,"^",13)
	set depTypeDesc=$s((+depTypeDR'=0):$p($g(^ARC("ARCDT",depTypeDR)),"^",2),1:"")
	set depTypeDesc=##class(User.ARCDepType).GetTranByDesc("ARCDTDesc", depTypeDesc, langId)
	set depDate=$p(depData,"^",2)
	set depTime=$p(depData,"^",3)
	set depDate=##class(websys.Conversions).DateLogicalToHtml(depDate)
	set depTime=##class(websys.Conversions).TimeLogicalToHtml(depTime)
	set adm=$p(depData,"^",4)
	set papmi=$p(^PAADM(adm),"^",1)
	set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	set regNo=$p(^PAPER(papmi,"PAT",1),"^",1)
	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")   //住院号
	set patEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(papmi, "")
	set encryptLevel=$p(patEncryptLevel,"^",1)
	set patLevel=$p(patEncryptLevel,"^",2)
	set depDeptDR=$p(depData,"^",37)    //prt_currdept_dr
	set depDeptDesc=$s((+depDeptDR'=0):$p($g(^CTLOC(depDeptDR)),"^",2),1:"")
	set depDeptDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", depDeptDesc, langId)
	set depPMSub=$o(^DHCSFPRINTDETAIL(depId,"P",0))
	set depPMData=$g(^DHCSFPRINTDETAIL(depId,"P",+depPMSub))
	set paymDR=$p(depPMData,"^",1)
	set paymDesc=$s((+paymDR'=0):$p($g(^CT("CTPM",paymDR)),"^",2),1:"")
	set paymDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", paymDesc, langId)
	set depAmt=$p(depData,"^",6)
	set depAmt=$fn(depAmt,"",2)
	set depStatus=$p(depData,"^",8)
	set status=$case(depStatus,1:"正常",2:"作废",3:"冲红",4:"正常",:"")
	if (+depStatus'=2) set depTotalSum=depTotalSum+depAmt
	set status=##class(websys.Translation).Get("dhcbill.ipbill.dailyhand.csp", status)
	set depFootDR=$p(depData,"^",30)     //prt_jk_dr
	do OutputIPDepDetails
	
	quit
	
OutputIPDepDetails
	set Data=$lb(depDate,depTime,patName,mrNo,regNo,rcptNo,depAmt,paymDesc,status,depDeptDesc,depId,depFootDR,depTypeDesc,encryptLevel,patLevel)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-03-16
/// Description: 出院结算收费明细
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillDailyDetails","FindIPBillInvDetails", "11/07/2018","15:44:23","25/07/2018","14:28:12","","4632","2")
Query FindIPBillInvDetails(stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String, langId As %String = "") As websys.Query(ROWSPEC = "TInvDate:%String,TInvTime:%String,TPatName:%String,TMedicareNo:%String,TRegNo:%String,TInvNo:%String,TInvSum:%String,TStatus:%String,TRowId:%String,TInitInvDR:%String,TInvFootDR:%String,TAdmReaDesc:%String,TCTDepSum:%String,TCTDepRcptNoStr:%String,TEncryptLevel:%String,TPatLevel:%String,TPaym1:%String,TPaym2:%String,TPaym3:%String,TPaym4:%String,TPaym5:%String,TPaym6:%String,TPaym7:%String,TPaym8:%String,TPaym9:%String,TPaym10:%String,TPaym11:%String,TPaym12:%String,TPaym13:%String,TPaym14:%String,TPaym15:%String,TPaym16:%String,TPaym17:%String,TPaym18:%String,TPaym19:%String,TPaym20:%String,TPaym21:%String,TPaym22:%String,TPaym23:%String,TPaym24:%String,TPaym25:%String,TPaym26:%String,TPaym27:%String,TPaym28:%String,TPaym29:%String,TPaym30:%String")
{
}

ClassMethod FindIPBillInvDetailsExecute(ByRef qHandle As %Binary, stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String, langId As %String = "") As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if ((footId="")&&((stDate="")||(endDate=""))) quit $$$OK
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
    set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime, 1)
    set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime, 1)
    
    set invTotalSum=0
    set ctDepTotalSum=0
    set job=$j
	kill ^||TMPPAYMODE("TOTAL",job)    //存放支付方式汇总金额

    if (footId="") {
	    //未结算
	    for date=stDate:1:endDate {
		    set prtRowId=0
		    while($o(^DHCINVPRTZY(0,"DATE",date,prtRowId))) {
			    set prtRowId=$o(^DHCINVPRTZY(0,"DATE",date,prtRowId))
				set invData=$g(^DHCINVPRTZY(prtRowId))
			    continue:(invData="")
			    set invFootDR=$p(invData,"^",23)    //PRT_JK_DR
			    continue:(+invFootDR'=0)
			    set adm=$p(invData,"^",4)
				set admHospDR=$p(invData,"^",35)
			    continue:(admHospDR'=hospDR)
			    set userDR=$p(invData,"^",7)
			    continue:((guser'="")&&(guser'=userDR))
				set invTime=$p(invData,"^",3)
				continue:((date=endDate)&&(invTime>endTime))
				do GetIPBillInvDetails
			}
	    }
    }else {
	    //已结算
		set prtRowId=0
		while($o(^DHCINVPRTZY(0,"JK",footId,prtRowId))) {
			set prtRowId=$o(^DHCINVPRTZY(0,"JK",footId,prtRowId))
			set invData=$g(^DHCINVPRTZY(prtRowId))
			continue:(invData="")
			do GetIPBillInvDetails
		}
    }
    
	set invDate=##class(websys.Translation).Get("", "合计")
	set invSum=$fn(invTotalSum,"",2)
	set ctDepSum=$fn(ctDepTotalSum,"",2)
	set (invTime, patName, mrNo, regNo, status, invNo, prtRowId, initInvDR, invFootDR, admReaDesc, ctDepRcptNoStr, encryptLevel, patLevel)=""
	do BuildPaymAmtAry("TOTAL")
	
	do OutputIPBillInvDetails
	
	quit $$$OK

GetIPBillInvDetails
	set adm=$p(invData,"^",4)
	set admDeptDR=$p(^PAADM(adm),"^",4)
	set admDeptDesc=$s((+admDeptDR'=0):$p(^CTLOC(admDeptDR),"^",2),1:"")
	set papmi=$p(^PAADM(adm),"^",1)
	quit:(+papmi=0)
	set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")   //住院号
	set patEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(papmi, "")
	set encryptLevel=$p(patEncryptLevel,"^",1)
	set patLevel=$p(patEncryptLevel,"^",2)
	set invDate=$p(invData,"^",2)
	set invTime=$p(invData,"^",3)
	set invDate=##class(websys.Conversions).DateLogicalToHtml(invDate)
	set invTime=##class(websys.Conversions).TimeLogicalToHtml(invTime)
	set invFootDR=$p(invData,"^",23)            //PRT_JK_DR
	set insTypeDR=$p(invData,"^",9)             //PRT_PatType
	set admReaDesc=$s((+insTypeDR'=0):$p(^PAC("ADMREA",insTypeDR),"^",2),1:"")
	set admReaDesc=##class(User.PACAdmReason).GetTranByDesc("READesc", admReaDesc, langId)
	set initInvDR=$p(invData,"^",13)            //PRT_initInv
	set invNo=$p(invData,"^",1)
	set invFlag=$p(invData,"^",8)               //PRT_Flag
	set status=$case(invFlag,"A":"作废","S":"红冲",:"正常")
	set status=##class(websys.Translation).Get("dhcbill.ipbill.dailyhand.csp", status)
	set billNo=$p(invData,"^",5)                       //PRT_ARPBL
	set discSum=+$p(^DHCPB(billNo),"^",9)              //PB_DiscAmount
	set discSum=$fn(discSum,"",2)
	set payorShareSum=+$p(^DHCPB(billNo),"^",11)       //PB_PayorShare
	set payorShareSum=$fn(payorShareSum,"",2)
	set patShareSum=+$p(^DHCPB(billNo),"^",12)         //PB_PatientShare
	set patShareSum=$fn(patShareSum,"",2)
	//冲退押金号
	set ctDepRcptNoStr=""
	set conId=0
	while($o(^DHCINVPRTZYCONDEPi(0,"Inv",prtRowId,conId))) {
		set conId=$o(^DHCINVPRTZYCONDEPi(0,"Inv",prtRowId,conId))
		set conData=$g(^DHCINVPRTZYCONDEP(conId))
		continue:(conData="")
		set depId=$p(conData,"^",3)
		set depData=$g(^DHCSFPRINTDETAIL(depId))
		set depRcptNo=$p(depData,"^",1)
		continue:(depRcptNo="")
		set ctDepRcptNoStr=$s((ctDepRcptNoStr=""):depRcptNo,1:(ctDepRcptNoStr_", "_depRcptNo))
	}
	
	set invSum=$p(invData,"^",6)                       //PRT_Acount
	set invSum=$fn(invSum,"",2)
	set ctDepSum=$p(invData,"^",22)                    //PRT_Deposit
	set ctDepSum=$fn(ctDepSum,"",2)
	set invTotalSum=invTotalSum+invSum
	set ctDepTotalSum=ctDepTotalSum+ctDepSum
	
	kill ^||TMPPAYMODE("SINGLE",job)                   //存放单张发票支付方式金额
	set paymSub=0
	while($o(^DHCINVPRTZY(prtRowId,"P",paymSub))) {
		set paymSub=$o(^DHCINVPRTZY(prtRowId,"P",paymSub))
		set paymSubData=$g(^DHCINVPRTZY(prtRowId,"P",paymSub))
		continue:(paymSubData="")
		set paymDR=$p(paymSubData,"^",1)
		continue:(+paymDR=0)
	    set paymAmt=$p(paymSubData,"^",3)
	    set ^||TMPPAYMODE("SINGLE",job,paymDR)=$i(^||TMPPAYMODE("SINGLE",job,paymDR), paymAmt)
		set ^||TMPPAYMODE("TOTAL",job,paymDR)=$i(^||TMPPAYMODE("TOTAL",job,paymDR), paymAmt)
	}
	
	do BuildPaymAmtAry("SINGLE")
	
	do OutputIPBillInvDetails
	
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
	
OutputIPBillInvDetails
	set Data=$lb(invDate,invTime,patName,mrNo,regNo,invNo,invSum,status,prtRowId,initInvDR,invFootDR,admReaDesc,ctDepSum,ctDepRcptNoStr,encryptLevel,patLevel,paym(1),paym(2),paym(3),paym(4),paym(5),paym(6),paym(7),paym(8),paym(9),paym(10),paym(11),paym(12),paym(13),paym(14),paym(15),paym(16),paym(17),paym(18),paym(19),paym(20),paym(21),paym(22),paym(23),paym(24),paym(25),paym(26),paym(27),paym(28),paym(29),paym(30))
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2021-05-12
/// Description: 住院集中打印发票明细
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillDailyDetails","FindSPIDetails","2021-05-10","18:00:00","2021-05-12","15:34:19","","12173","2")
Query FindSPIDetails(stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String, langId As %String = "") As websys.Query(ROWSPEC = "TInvDate:%String,TInvTime:%String,TPatName:%String,TMedicareNo:%String,TRegNo:%String,TStatus:%String,TInvNo:%String,TInvSum:%String,TRowId:%String,TInitInvDR:%String,TInvFootDR:%String,TAdmReaDesc:%String,TEncryptLevel:%String,TPatLevel:%String")
{
}

ClassMethod FindSPIDetailsExecute(ByRef qHandle As %Binary, stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String, langId As %String = "") As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindSPIDetails")=$lb(stDate, stTime, endDate, endTime, footId, guser, hospDR)
	if ((footId="")&&((stDate="")||(endDate=""))) quit $$$OK

	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
    set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime, 1)
    set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime, 1)
    
    set invTotalSum=0
    
    if (footId="") {
	    //未结算
  		for date=stDate:1:endDate {
	  		set rowId=0
	  		while($o(^BILL.IP.SummaryPrtInvI("PrtDate",date,rowId))) {
		  		set rowId=$o(^BILL.IP.SummaryPrtInvI("PrtDate",date,rowId))
		  		set summInvData=$g(^BILL.IP.SummaryPrtInvD(rowId))
		  		set invRepDR=$lg(summInvData,13)    //SPI_Rep_DR
				continue:(+invRepDR'=0)
				set invHospDR=$lg(summInvData,14)
				continue:((hospDR'="")&&(hospDR'=invHospDR))
				set userDR=$lg(summInvData,5)
				continue:((guser'="")&&(guser'=userDR))
				set invTime=$lg(summInvData,6)
				continue:((date=endDate)&&(invTime>endTime))
				do GetSPIDetails
		  	}
	  	}
	}else {
		//已结算
		set rowId=0
		while($o(^BILL.IP.SummaryPrtInvI("RepDR",footId,rowId))) {
			set rowId=$o(^BILL.IP.SummaryPrtInvI("RepDR",footId,rowId))
			set summInvData=$g(^BILL.IP.SummaryPrtInvD(rowId))
			do GetSPIDetails
		}
	}
	
	set invDate=##class(websys.Translation).Get("", "合计")
	set invSum=$fn(invTotalSum,"",2)
	set (invTime,patName,mrNo,regNo,status,invNo,rowId,initInvDR,invFootDR,admReaDesc,encryptLevel,patLevel)=""	
	do OutputSPIDetails
	
	quit $$$OK

GetSPIDetails
	set papmi=$lg(summInvData,4)
	quit:(+papmi=0)
	set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
	set adm=$lg(summInvData,3)
	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")   //住院号
	set patEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(papmi, "")
	set encryptLevel=$p(patEncryptLevel,"^",1)
	set patLevel=$p(patEncryptLevel,"^",2)
	set invDate=$lg(summInvData,7)
	set invTime=$lg(summInvData,8)
	set invDate=##class(websys.Conversions).DateLogicalToHtml(invDate)
	set invTime=##class(websys.Conversions).TimeLogicalToHtml(invTime)
	set invFootDR=$lg(summInvData,13)
	set insTypeDR=$lg(summInvData,15)
	set admReaDesc=$s((+insTypeDR'=0):$p(^PAC("ADMREA",insTypeDR),"^",2),1:"")
	set admReaDesc=##class(User.PACAdmReason).GetTranByDesc("READesc", admReaDesc, langId)
	set initInvDR=$lg(summInvData,9)
	set invNo=$lg(summInvData,2)
	set invFlag=$lg(summInvData,6)
	set status=$case(invFlag,"A":"作废","S":"红冲",:"正常")
	set status=##class(websys.Translation).Get("dhcbill.ipbill.dailyhand.csp", status)
	
	set invSum=..GetSPInvSumByID(rowId)
	set invSum=$s((+initInvDR'=0):-invSum,1:invSum)   //作废/红冲记录，金额显示为负数
	set invSum=$fn(invSum,"",2)
	set invTotalSum=invTotalSum+invSum
	
	do OutputSPIDetails
	
	quit
	
OutputSPIDetails
	set Data=$lb(invDate,invTime,patName,mrNo,regNo,status,invNo,invSum,rowId,initInvDR,invFootDR,admReaDesc,encryptLevel,patLevel)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2021-07-14
/// Description: 根据集中打印发票RowId获取发票总金额
/// Input: spiRowId: BILL_IP.SummaryPrtInv.RowId
/// Return: 
/// Debug: w ##class(web.DHCIPBillDailyDetails).GetSPInvSumByID(5)
ClassMethod GetSPInvSumByID(spiRowId As %String) As %String
{
	set invSum=0
	quit:(+spiRowId=0) invSum
	set conDR=0
	while($o(^BILL.IP.SPInvConPRTI("SPInvDR",spiRowId,conDR))) {
		set conDR=$o(^BILL.IP.SPInvConPRTI("SPInvDR",spiRowId,conDR))
		set prtRowId=$lg(^BILL.IP.SPInvConPRTD(conDR),2)
		set prtAcount=$p(^DHCINVPRTZY(prtRowId),"^",6)
		set invSum=$i(invSum,prtAcount)
	}
	quit $fn(invSum,"",2)
}

}
