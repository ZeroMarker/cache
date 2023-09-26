/// 名称: web.DHCOPBillDailyPrint.cls
/// 描述: 门诊日报及日报汇总打印业务类
/// 编写者: Lid
/// 编写日期: 2010-11-26
/// 产品组：计费医保组
Class web.DHCOPBillDailyPrint Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2017-10-18
/// Description: 获取门诊日结汇总支付方式统计信息
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        stTime:开始时间(不能为空,汇总为空)
///        endTime:结束时间(不能为空,汇总为空)
///        hospDR:CT_Hospital.RowID(不能为空)
///        footId:DHC_INVPRTReports.RowID(个人日报需传值，汇总传空)
///        receId:DHC_INVPRTReports.RowID(个人日报传空，汇总需传值)
///        guser:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息)
///        guserStr:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息，日报汇总用)
///        groupDR:SS_Group 根据安全组配置来判断组长是否需要接收
/// Output: TPaymCode:支付方式代码,TPaymDesc:支付方式描述,TTotalSum:总金额,TPrtPaySum:收费金额,TPrtPayNum:收费数量,TPrtRefSum:退费金额,TPrtRefNum:退费数量,TAPIPaySum:集中打印发票金额,TAPIPayNum:集中打印发票张数,TAPIRefSum:集中打印发票退票金额,TAPIRefNum:集中打印发票退票张数,TAccPDPaySum:收预交金金额,TAccPDPayNum:收预交金数量,TAccPDRefSum:退预交金金额,TAccPDRefNum:退预交金数量,TCardPaySum:建卡金额,TCardPayNum:建卡张数,TCardRefSum:退卡金额,TCardRefNum:退卡张数,TEPDPaySum:%Float:留观押金收费金额,TEPDPayNum:留观押金收费数量,TEPDRefSum:留观押金退费金额,TEPDRefNum:留观押金退费数量,TGiftcardPaySum:建代金卡金额,TGiftcardPayNum:%Integer:建代金卡数量,TGiftcardRefSum:退代金卡金额,TGiftcardRefNum:退代金卡数量,TchargeType:收费类型
/// Return: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillDailyPrint","GetOPBillDailyPayMHZReport", "2018-3-1", "2018-3-1","9:15:03","13:25:04", 2, "33050","")
Query GetOPBillDailyPayMHZReport(stDate As %String, endDate As %String, stTime As %String, endTime As %String, hospDR As %String, footId As %String = "", guser As %String = "", receId As %String = "", guserStr As %Text = "", groupDR As %String = "") As websys.Query(ROWSPEC = "TPaymCode:%String:支付方式代码,TPaymDesc:%String:支付方式描述,TTotalSum:%Float:总金额,TPrtPaySum:%Float:收费金额,TPrtPayNum:%Integer:收费数量,TPrtRefSum:%Float:退费金额,TPrtRefNum:%Integer:退费数量,TAPIPaySum:%Float:集中打印发票金额,TAPIPayNum:%Integer:集中打印发票张数,TAPIRefSum:%Float:集中打印发票退票金额,TAPIRefNum:%Integer:集中打印发票退票张数,TAccPDPaySum:%Float:收预交金金额,TAccPDPayNum:%Integer:收预交金数量,TAccPDRefSum:%Float:退预交金金额,TAccPDRefNum:%Integer:退预交金数量,TCardPaySum:%Float:建卡金额,TCardPayNum:%Integer:建卡张数,TCardRefSum:%Float:退卡金额,TCardRefNum:%Integer:退卡张数,TEPDPaySum:%Float:留观押金收费金额,TEPDPayNum:%Integer:留观押金收费数量,TEPDRefSum:%Float:留观押金退费金额,TEPDRefNum:%Integer:留观押金退费数量,TGiftcardPaySum:%Float:建代金卡金额,TGiftcardPayNum:%Integer:建代金卡数量,TGiftcardRefSum:%Float:退代金卡金额,TGiftcardRefNum:%Integer:退代金卡数量,TchargeType:%String:收费类型") [ SqlProc ]
{
}

ClassMethod GetOPBillDailyPayMHZReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, stTime As %String, endTime As %String, hospDR As %String, footId As %String = "", guser As %String = "", receId As %String = "", guserStr As %Text = "", groupDR As %String = "") As %Status
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
	kill ^||TMPPAYM(job)

	if (footId="") {
		if ((stTime="")&&(endTime="")) {
			do ..GetDailyPrintHZInfo(stDate, endDate, stTime, endTime, hospDR, guserStr, receId, "Paymode", groupDR, job)
		}
	}else {
		do ..GetPayMode(stDate, endDate, stTime, endTime, footId, hospDR, guser, job)
	}
	
	set chargeType=""
	while($o(^||TMPPAYM(job,chargeType))'="") {
		set chargeType=$o(^||TMPPAYM(job,chargeType))
		set paymID=0
		while($o(^CT("CTPM",paymID))) {
			set paymID=$o(^CT("CTPM",paymID))
			set paymCode=$p(^CT("CTPM",paymID),"^",1)
			set paymDesc=$p(^CT("CTPM",paymID),"^",2)
			//结算
			set prtPaySum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"PRT","N")),"^",1)      //收费金额
			set prtPayNum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"PRT","N")),"^",2)      //收费数量
			set prtRefSum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"PRT","S")),"^",1)      //退费金额
			set prtRefNum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"PRT","S")),"^",2)      //退费数量
			set prtTotalSum=prtPaySum+prtRefSum
			//集中打印发票
			set apiPaySum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"API","N")),"^",1)      //集中打印发票金额
			set apiPayNum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"API","N")),"^",2)      //集中打印发票张数
			set apiRefSum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"API","S")),"^",1)      //集中打印发票退票金额
			set apiRefNum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"API","S")),"^",2)      //集中打印发票退票张数
			set apiTotalSum=apiPaySum+apiRefSum
			//门诊预交金
			set accPDPaySum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"PD","N")),"^",1)     //收预交金金额
			set accPDPayNum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"PD","N")),"^",2)     //收预交金数量
			set accPDRefSum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"PD","S")),"^",1)     //退预交金金额
			set accPDRefNum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"PD","S")),"^",2)     //退预交金数量
			set accPDTotalSum=accPDPaySum+accPDRefSum
			//卡费
			set cardPaySum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"CARD","N")),"^",1)    //建卡金额
			set cardPayNum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"CARD","N")),"^",2)    //建卡张数
			set cardRefSum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"CARD","S")),"^",1)    //退卡金额
			set cardRefNum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"CARD","S")),"^",2)    //退卡张数
			set cardTotalSum=cardPaySum+cardRefSum
			//留观押金
			set EPDPaySum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"EPD","N")),"^",1)      //留观押金收费金额
			set EPDPayNum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"EPD","N")),"^",2)      //留观押金收费数量
			set EPDRefSum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"EPD","S")),"^",1)      //留观押金退费金额
			set EPDRefNum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"EPD","S")),"^",2)      //留观押金退费数量
			set EPDTotalSum=EPDPaySum+EPDRefSum
			//代金卡费
			set GiftcardPaySum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"GCARD","N")),"^",1)    //建代金卡金额
			set GiftcardPayNum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"GCARD","N")),"^",2)    //建代金卡张数
			set GiftcardRefSum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"GCARD","S")),"^",1)    //退代金卡金额
			set GiftcardRefNum=+$p($g(^||TMPPAYM(job,chargeType,paymID,"GCARD","S")),"^",2)    //退代金卡张数
			set GiftcardTotalSum=GiftcardPaySum+GiftcardRefSum
			//总金额
			set totalSum=prtTotalSum+apiTotalSum+accPDTotalSum+cardTotalSum+EPDTotalSum+GiftcardTotalSum
			set data=$lb(paymCode,paymDesc,totalSum,prtPaySum,prtPayNum,prtRefSum,prtRefNum,apiPaySum,apiPayNum,apiRefSum,apiRefNum,accPDPaySum,accPDPayNum,accPDRefSum,accPDRefNum,cardPaySum,cardPayNum,cardRefSum,cardRefNum,EPDPaySum,EPDPayNum,EPDRefSum,EPDRefNum,GiftcardPaySum,GiftcardPayNum,GiftcardRefSum,GiftcardRefNum,chargeType)
			set ^CacheTemp(repid,ind)=data
			set ind=$i(ind)
		}
	}
	
	kill ^||TMPPAYM(job)
	quit $$$OK
}

/// Creator: ZhYW
/// CreatDate: 2017-10-18
/// Description: 获取门诊日结汇总门诊收费分类/会计分类统计信息
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
/// Output: TTarTypeDesc:分类描述(会计,门诊) TAdmReaCode:费别代码,TAdmReaDesc:费别描述,TCateCode:大类代码,TCateDesc:大类描述,TSubCateCode:子类代码,TSubCateDesc:子类描述,TTotalSum:分类总金额,TCatePaySum:分类收费金额,TCateRefSum:分类退费金额,TCateDisSum:%Float:分类折扣金额,TCatePayOrShareSum:%Float:分类记账金额,TCatePatShareSum:%Float:分类自付金额
/// Return: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillDailyPrint","GetOPBillDailyCateFeeHZReport", "2018-06-08", "2018-06-20", "23:59:59", "23:59:59", "2","34775","4647","","","")
Query GetOPBillDailyCateFeeHZReport(stDate As %String, endDate As %String, stTime As %String, endTime As %String, hospDR As %String, footId As %String = "", guser As %String = "", receId As %String = "", guserStr As %Text = "", groupDR As %String = "") As websys.Query(ROWSPEC = "TTarTypeDesc:%String:分类描述,TAdmReaCode:%String:费别代码,TAdmReaDesc:%String:费别描述,TCateCode:%String:大类代码,TCateDesc:%String:大类描述,TSubCateCode:%String:子类代码,TSubCateDesc:%String:子类描述,TTotalSum:%Float:总金额,TCatePaySum:%Float:收费金额,TCateRefSum:%Float:退费金额,TCateDisSum:%Float:折扣金额,TCatePayOrShareSum:%Float:记账金额,TCatePatShareSum:%Float:自付金额") [ SqlProc ]
{
}

ClassMethod GetOPBillDailyCateFeeHZReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, stTime As %String, endTime As %String, hospDR As %String, footId As %String = "", guser As %String = "", receId As %String = "", guserStr As %Text = "", groupDR As %String = "") As %Status
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
	kill ^||TMPCATE(job)
	if (footId="") {
		if ((stTime="")&&(endTime="")) {
			do ..GetDailyPrintHZInfo(stDate, endDate, stTime, endTime, hospDR, guserStr, receId, "CateType", groupDR, job)
		}
	}else {
		do ..GetCateType(stDate, endDate, stTime, endTime, footId, hospDR, guser, job)
	}
	
	set tarType1=""
	set tarType=""
	while($o(^||TMPCATE(job,tarType))'="") {
		set tarType=$o(^||TMPCATE(job,tarType))
		set tarTypeDesc=""
		if (tarType["OC") {
			set tarTypeDesc="门诊"
			set tarType1="OC"
		}
		if (tarType["AC") {
			set tarTypeDesc="会计"
			set tarType1="AC"
		}
		continue:(tarTypeDesc="")
		set admReaID=0
		while($o(^||TMPCATE(job,tarType,admReaID))) {
			set admReaID=$o(^||TMPCATE(job,tarType,admReaID))
			set admReaCode=$p(^PAC("ADMREA",admReaID),"^",1)
			set admReaDesc=$p(^PAC("ADMREA",admReaID),"^",2)
			set cateID=0
			while($o(^||TMPCATE(job,tarType,admReaID,cateID))) {
				set cateID=$o(^||TMPCATE(job,tarType,admReaID,cateID))
				set cateCode=$p(^DHCTarC("T"_tarType1,cateID),"^",1)
				set cateDesc=$p(^DHCTarC("T"_tarType1,cateID),"^",2)
				set subCateID=0
				while($o(^||TMPCATE(job,tarType,admReaID,cateID,subCateID))) {
					set subCateID=$o(^||TMPCATE(job,tarType,admReaID,cateID,subCateID))
					set subCateCode=$p(^DHCTarC(tarType1,subCateID),"^",1)
					set subCateDesc=$p(^DHCTarC(tarType1,subCateID),"^",2)
					set catePaySum=+$p($g(^||TMPCATE(job,tarType,admReaID,cateID,subCateID)),"^",1)
					set cateRefSum=+$p($g(^||TMPCATE(job,tarType,admReaID,cateID,subCateID)),"^",2)
					set cateDisSum=+$p($g(^||TMPCATE(job,tarType,admReaID,cateID,subCateID)),"^",3)
					set catePayOrShareSum=+$p($g(^||TMPCATE(job,tarType,admReaID,cateID,subCateID)),"^",4)
					set catePatShareSum=+$p($g(^||TMPCATE(job,tarType,admReaID,cateID,subCateID)),"^",5)
					set totalSum=catePaySum+cateRefSum
					set data=$lb(tarTypeDesc,admReaCode,admReaDesc,cateCode,cateDesc,subCateCode,subCateDesc,totalSum,catePaySum,cateRefSum,cateDisSum,catePayOrShareSum,catePatShareSum)
					set ^CacheTemp(repid,ind)=data
					set ind=$i(ind)
				}
			}
		}
	}
	
	kill ^||TMPCATE(job)
	quit $$$OK
}

/// Creator: ZhYW
/// CreatDate: 2017-10-18
/// Description: 获取门诊日结汇总费别信息
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
/// Output: TAdmReaCode:费别代码,TAdmReaDesc:费别描述,TPaymCode:支付方式代码,TPaymDesc:支付方式描述,TTtotalSum:总金额,TPrtPaySum:收费金额,TPrtPayNum:收费数量,TPrtRefSum:退费金额,TPrtRefNum:退费数量,TAPIPaySum:集中打印发票金额,TAPIPayNum:集中打印发票数量,TAPIRefSum:集中打印发票退票金额,TAPIRefNum:集中打印发票退票数量
/// Return: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillDailyPrint","GetOPBillDailyInsTypeHZReport", "2018-3-1", "2018-3-1", 2,"")
Query GetOPBillDailyInsTypeHZReport(stDate As %String, endDate As %String, stTime As %String, endTime As %String, hospDR As %String, footId As %String = "", guser As %String = "", receId As %String = "", guserStr As %Text = "", groupDR As %String = "") As websys.Query(ROWSPEC = "TAdmReaCode:%String:费别代码,TAdmReaDesc:%String:费别描述,TPaymCode:%String:支付方式代码,TPaymDesc:%String:支付方式描述,TTtotalSum:%Float:总金额,TPrtPaySum:%Float:收费金额,TPrtPayNum:%Integer:收费数量,TPrtRefSum:%Float:退费金额,TPrtRefNum:%Integer:退费数量,TAPIPaySum:%Float:集中打印发票金额,TAPIPayNum:%Integer:集中打印发票数量,TAPIRefSum:%Float:集中打印发票退票金额,TAPIRefNum:%Integer:集中打印发票退票数量") [ SqlProc ]
{
}

ClassMethod GetOPBillDailyInsTypeHZReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, stTime As %String, endTime As %String, hospDR As %String, footId As %String = "", guser As %String = "", receId As %String = "", guserStr As %Text = "", groupDR As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	if ((stDate="")||(endDate=""))  quit $$$OK
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime)
	set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime)
	set job=$j
	kill ^||TMPINSTYPE(job)
	
	if (footId="") {
		if ((stTime="")&&(endTime="")) {
			do ..GetDailyPrintHZInfo(stDate, endDate, stTime, endTime, hospDR, guserStr, receId, "AdmReason", groupDR, job)
		}
	}else {
		do ..GetAdmReason(stDate, endDate, stTime, endTime, footId, hospDR, guser, job)
	}
	
	set admReaID=0
	while($o(^PAC("ADMREA",admReaID))) {
		set admReaID=$o(^PAC("ADMREA",admReaID))
		set admReaCode=$p(^PAC("ADMREA",admReaID),"^",1)
		set admReaDesc=$p(^PAC("ADMREA",admReaID),"^",2)
		set paymID=0
		while($o(^CT("CTPM",paymID))) {
			set paymID=$o(^CT("CTPM",paymID))
			set paymCode=$p(^CT("CTPM",paymID),"^",1)
			set paymDesc=$p(^CT("CTPM",paymID),"^",2)
			//结算
			set prtPaySum=+$p($g(^||TMPINSTYPE(job,admReaID,paymID,"PRT","N")),"^",1)      //收费金额
			set prtPayNum=+$p($g(^||TMPINSTYPE(job,admReaID,paymID,"PRT","N")),"^",2)      //收费数量
			set prtRefSum=+$p($g(^||TMPINSTYPE(job,admReaID,paymID,"PRT","S")),"^",1)      //退费金额
			set prtRefNum=+$p($g(^||TMPINSTYPE(job,admReaID,paymID,"PRT","S")),"^",2)      //退费数量
			set prtTotalSum=prtPaySum+prtRefSum
			//集中打印发票
			set apiPaySum=+$p($g(^||TMPINSTYPE(job,admReaID,paymID,"API","N")),"^",1)      //集中打印发票金额
			set apiPayNum=+$p($g(^||TMPINSTYPE(job,admReaID,paymID,"API","N")),"^",2)      //集中打印发票张数
			set apiRefSum=+$p($g(^||TMPINSTYPE(job,admReaID,paymID,"API","S")),"^",1)      //集中打印发票退票金额
			set apiRefNum=+$p($g(^||TMPINSTYPE(job,admReaID,paymID,"API","S")),"^",2)      //集中打印发票退票数量
			set apiTotalSum=apiPaySum+apiRefSum
			//总金额
			set totalSum=prtTotalSum+apiTotalSum
			set data=$lb(admReaCode,admReaDesc,paymCode,paymDesc,totalSum,prtPaySum,prtPayNum,prtRefSum,prtRefNum,apiPaySum,apiPayNum,apiRefSum,apiRefNum)
			set ^CacheTemp(repid,ind)=data
			set ind=$i(ind)
		}
	}
	
	kill ^||TMPINSTYPE(job)
	quit $$$OK
}

/// Creator: ZhYW
/// CreatDate: 2017-10-18
/// Description: 获取门诊日结汇总发票信息(按收费员汇总)
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
/// Output: TUserCode:工号,TUserName:姓名,TInvNOStr:发票号,TInvNum:发票张数,TAbortInvNOStr:作废发票号,TAbortInvNum:作废发票张数,TStrikeInvNOStr:红冲发票号,TStrikeInvNum:红冲发票张数,TVoidInvNOStr:跳号发票号,TVoidInvNum:跳号发票张数,TinvRoundSum:分币误差金额,abortPEInvNOStr:作废体检发票号,abortPEInvNum:作废体检发票张数,strikePEInvNOStr:红冲体检发票号,strikePEInvNum:红冲体检发票张数,PEinvRoundSum:体检分币误差,PEMakeupRoundSum:体检凑整误差金额
/// Return: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillDailyPrint","GetOPBillDailyInvNOHZReport","23/07/2018","27/07/2018","","","2","","","122","","122")
Query GetOPBillDailyInvNOHZReport(stDate As %String, endDate As %String, stTime As %String, endTime As %String, hospDR As %String, guser As %String, footId As %String = "", receId As %String = "", guserStr As %Text = "", groupDR As %String = "") As websys.Query(ROWSPEC = "TUserCode:%String:工号,TUserName:%String:姓名,TInvNOStr:%String:发票号,TInvNum:%Integer:发票张数,TAbortInvNOStr:%String:作废发票号,TAbortInvNum:%Integer:作废发票张数,TStrikeInvNOStr:%String:红冲发票号,TStrikeInvNum:%Integer:红冲发票张数,TVoidInvNOStr:%String:跳号发票号,TVoidInvNum:%Integer:跳号发票张数,TinvRoundSum:%Float:分币误差金额,abortPEInvNOStr:%String:作废体检发票号,abortPEInvNum:%Integer:作废体检发票张数,strikePEInvNOStr:%String:红冲体检发票号,strikePEInvNum:%Integer:红冲体检发票张数,PEinvRoundSum:%Float:体检分币误差,PEMakeupRoundSum:%Float:体检凑整误差金额") [ SqlProc ]
{
}

ClassMethod GetOPBillDailyInvNOHZReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, stTime As %String, endTime As %String, hospDR As %String, guser As %String, footId As %String = "", receId As %String = "", guserStr As %Text = "", groupDR As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    set ^TMP("GetOPBillDailyInvNOHZReport")=$lb(stDate, endDate, stTime, endTime, hospDR, guser, footId, receId, guserStr, groupDR)
	if ((stDate="")||(endDate="")) quit $$$OK
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime)
	set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime)
	set job=$j
	kill ^||TMPINVNO(job)
	
	if (footId="") {
		if ((stTime="")&&(endTime="")) {
			do ..GetDailyPrintHZInfo(stDate, endDate, stTime, endTime, hospDR, guserStr, receId, "Invno", groupDR, job)
		}
	}else {
		do ..GetDailyInvNO(stDate, endDate, stTime, endTime, footId, hospDR, guser, job)
	}
	
	set userID=0
	while($o(^||TMPINVNO(job,userID))) {
		set userID=$o(^||TMPINVNO(job,userID))
		set userCode=$p(^SSU("SSUSR",userID),"^",1)
		set userName=$p(^SSU("SSUSR",userID),"^",2)
		set invNOStr=$p($g(^||TMPINVNO(job,userID,"N")),"^",1)
		set invNum=+$p($g(^||TMPINVNO(job,userID,"N")),"^",2)
		set abortInvNOStr=$p($g(^||TMPINVNO(job,userID,"A")),"^",1)
		set abortInvNum=+$p($g(^||TMPINVNO(job,userID,"A")),"^",2)
		set strikeInvNOStr=$p($g(^||TMPINVNO(job,userID,"S")),"^",1)
		set strikeInvNum=+$p($g(^||TMPINVNO(job,userID,"S")),"^",2)
		set voidInvNOStr=$p($g(^||TMPINVNO(job,userID,"V")),"^",1)
		set voidInvNum=+$p($g(^||TMPINVNO(job,userID,"V")),"^",2)
		set invRoundSum=+$p($g(^||TMPINVNO(job,userID,"Round")),"^",1)
		set abortPEInvNOStr=$p($g(^||TMPINVNO(job,userID,"PEParkINV")),"^",1)        //作废体检发票信息
		set abortPEInvNum=+$p($g(^||TMPINVNO(job,userID,"PEParkINV")),"^",2)
		set strikePEInvNOStr=$p($g(^||TMPINVNO(job,userID,"PERefundINV")),"^",1)     //红冲体检发票信息
		set strikePEInvNum=+$p($g(^||TMPINVNO(job,userID,"PERefundINV")),"^",2)
		set PEinvRoundSum=+$p($g(^||TMPINVNO(job,userID,"PEINVRound")),"^",1)        //体检分币误差金额 
		set PEMakeupRoundSum=+$p($g(^||TMPINVNO(job,userID,"PEINVRoundInt")),"^",1)  //体检凑整误差金额 
		if (abortInvNOStr'="") {
			if (abortPEInvNOStr'="") {
				set abortInvNOStr=abortInvNOStr_", "_abortPEInvNOStr
			}
		}else {
			set abortInvNOStr=abortPEInvNOStr
		}
		if (strikeInvNOStr'="") {
			if (strikePEInvNOStr'="") {
				set strikeInvNOStr=strikeInvNOStr_", "_strikePEInvNOStr
			}
		}else {
			set strikeInvNOStr=strikePEInvNOStr
		}
		set abortInvNum=abortInvNum+abortPEInvNum
		set strikeInvNum=strikeInvNum+strikePEInvNum
		set data=$lb(userCode,userName,invNOStr,invNum,abortInvNOStr,abortInvNum,strikeInvNOStr,strikeInvNum,voidInvNOStr,voidInvNum,invRoundSum,abortPEInvNOStr,abortPEInvNum,strikePEInvNOStr,strikePEInvNum,PEinvRoundSum,PEMakeupRoundSum)
		set ^CacheTemp(repid,ind)=data
		set ind=$i(ind)
	}
	
	kill ^||TMPINVNO(job)
	quit $$$OK
}

/// Creator: QCN
/// CreatDate: 2018-03-14
/// Description: 获取门诊日结、汇总表头信息
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        stTime:开始时间(不能为空)
///        endTime:结束时间(不能为空)
/// 	   footId:DHC_INVPRTReports.Rowid(可以为空,为空时输出所有的结算记录)
///        hospDR:CT_Hospital.RowID(不能为空)
///        receId:DHC_INVPRTReports.RowID(个人日报传空，汇总需传值)
///        guserStr:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息,日报汇总用)
///        groupDR:SS_Group 根据安全组配置来判断组长是否需要接收
/// Output: HISDate:结算日期,HISTime:结算时间,HISStartDate:开始日期,HISStartTime:开始时间,HISEndDate:结束日期,HISEndTime:结束时间,HISUserDesc:收费员,HISReceiveDesc:预结算标志
/// Return: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillDailyPrint","GetOPBillDailyTitleInfoReport", "28/06/2021","01/07/2021","23:59:59","19:03:39","","2","","","12173")
Query GetOPBillDailyTitleInfoReport(stDate As %String, endDate As %String, stTime As %String, endTime As %String, footId As %String = "", hospDR As %String = "", receId As %String = "", guserStr As %Text = "", groupDR As %String = "") As websys.Query(ROWSPEC = "HISDate:%String:结算日期,HISTime:%String:结算时间,HISStartDate:%String:开始日期,HISStartTime:%String:开始时间,HISEndDate:%String:结束日期,HISEndTime:%String:结束时间,HISUserDesc:%String:收费员,HISReceiveDesc:%String:预结算标志") [ SqlProc ]
{
}

ClassMethod GetOPBillDailyTitleInfoReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, stTime As %String, endTime As %String, footId As %String = "", hospDR As %String = "", receId As %String = "", guserStr As %Text = "", groupDR As %String = "") As %Status
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
	kill ^||TMPDATE(job)
	
	set (HISDate, HISTime, HISStartDate, HISStartTime, HISEndDate, HISEndTime, HISUserDesc, HISReceiveDesc)=""
	if (footId="") {
		if ((stTime="")&&(endTime="")) {
			do ..GetStEndDate(stDate, endDate, stTime, endTime, footId, guserStr, receId, job, groupDR, hospDR)
			set myStDate=$o(^||TMPDATE(job,""))
			set myEndDate=$o(^||TMPDATE(job,""),-1)
			set myStDate=##class(websys.Conversions).DateLogicalToHtml(myStDate)
			set myEndDate=##class(websys.Conversions).DateLogicalToHtml(myEndDate)
			set HISDate=myStDate_"至"_myEndDate
		}
	}else {
		set footData=$g(^DHCOPInsFoot(footId))
		set HISDate=##class(websys.Conversions).DateLogicalToHtml($p(footData,"^",2)) //结算日期   
		set HISTime=##class(websys.Conversions).TimeLogicalToHtml($p(footData,"^",7)) //结算时间
		set HISStartDate=##class(websys.Conversions).DateLogicalToHtml($p(footData,"^",5)) //开始日期
		set HISStartTime=##class(websys.Conversions).TimeLogicalToHtml($p(footData,"^",6)) //开始时间
		set HISEndDate=##class(websys.Conversions).DateLogicalToHtml($p(footData,"^",3)) //结束日期
		set HISEndTime=##class(websys.Conversions).TimeLogicalToHtml($p(footData,"^",4)) //结束时间
		set HISUser=$p(footData,"^",8)
		set HISUserDesc=$p(^SSU("SSUSR",HISUser),"^",2) //操作员
		set HISReceiveFlag=$p(footData,"^",68)            //预结算标志
		set HISReceiveDesc=$s((HISReceiveFlag="Y"):"预结算",1:("结账号："_footId))
	}
	
	kill ^||TMPDATE(job)
	
	set data=$lb(HISDate,HISTime,HISStartDate,HISStartTime,HISEndDate,HISEndTime,HISUserDesc,HISReceiveDesc)
	set ^CacheTemp(repid,ind)=data
	set ind=$i(ind)
	quit $$$OK
}

/// Description: 根据交账id获取号段信息
/// Creator: zhli
/// CreatDate: 2018-03-12
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        stTime:开始时间(不能为空)
///        endTime:结束时间(不能为空)
///        hospDR:CT_Hospital.RowID(不能为空)
///        jkDR:DHC_INVPRTReports.RowID(个人日报需传值，汇总传空)
///        guser:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息)
/// Return: 
/// Debug: w ##class(web.DHCOPBillDailyPrint).GetDailyInvNO("33050", 2, "")
ClassMethod GetDailyInvNO(stDate As %String, endDate As %String, stTime As %String, endTime As %String, jkDR As %String, hospDR As %String, guser As %String, job As %String) As %String
{
	quit:($d(^DHCOPInsFoot(jkDR))=10)
	set footData=$g(^DHCOPInsFoot(jkDR))
	set hospital=$p(footData,"^",66)                 //HIS_HospitalDR->CT_Hospital
	quit:((hospDR'="")&&(hospital'=hospDR))
	set userDR=$p(footData,"^",8)                    //HIS_User->SS_User
	quit:((guser'="")&&(guser'=userDR))
	set footStDate=$p(footData,"^",5)
	set footStTime=$p(footData,"^",6)
	set footEndDate=$p(footData,"^",3)
	set footEndTime=$p(footData,"^",4)
	//quit:((stDate=footStDate)&&(stTime<footStTime))
	quit:((stDate=footEndDate)&&(stTime>=footEndTime)&&(stTime'=""))
	//打印发票信息
	set invNum=$p(footData,"^",9)                  //His_Num           发票数量
	set invNOStr=$p(footData,"^",10)               //HIS_RcptNO        发票号串
	if ('$d(^||TMPINVNO(job,userDR,"N"))) {
		set $p(^||TMPINVNO(job,userDR,"N"),"^",1)=invNOStr
	}else {
		set $p(^||TMPINVNO(job,userDR,"N"),"^",1)=$p($g(^||TMPINVNO(job,userDR,"N")),"^",1)_","_invNOStr
	}
	set $p(^||TMPINVNO(job,userDR,"N"),"^",2)=$p($g(^||TMPINVNO(job,userDR,"N")),"^",2)+invNum
	//作废发票信息
	//set abortInvNum=$p(footData,"^",23)          //HIS_ParkNum       作废发票数量
	set abortInvNOStr=$p(footData,"^",25)          //HIS_ParkINVInfo   作废发票号串
	set $p(^||TMPINVNO(job,userDR,"A"),"^",1)=abortInvNOStr
	set $p(^||TMPINVNO(job,userDR,"A"),"^",2)=$l(abortInvNOStr,",")
	if (abortInvNOStr="") set $p(^||TMPINVNO(job,userDR,"A"),"^",2)=0
	
	//红冲发票信息
	//set strikeInvNum=$p(footData,"^",21)          //HIS_RefundNum     红冲数量
	set strikeInvNOStr=$p(footData,"^",26)          //HIS_RefundINVInfo 红冲发票号串
	set $p(^||TMPINVNO(job,userDR,"S"),"^",1)=strikeInvNOStr
	set $p(^||TMPINVNO(job,userDR,"S"),"^",2)=$l(strikeInvNOStr,",")
	if (strikeInvNOStr="") set $p(^||TMPINVNO(job,userDR,"S"),"^",2)=0
	
	//跳号发票信息
	set voidInvNOStr=$p(footData,"^",73)            //HIS_VoidINVInfo 跳号发票
	set $p(^||TMPINVNO(job,userDR,"V"),"^",1)=voidInvNOStr
	set $p(^||TMPINVNO(job,userDR,"V"),"^",2)=$l(voidInvNOStr,",")
	if (voidInvNOStr="") set $p(^||TMPINVNO(job,userDR,"V"),"^",2)=0
	
	//分币误差金额
	set invRoundSum=$fn($p(footData,"^",29),"",2)             //HIS_INVRoundSum  分币误差
	set $p(^||TMPINVNO(job,userDR,"Round"),"^",1)=$p($g(^||TMPINVNO(job,userDR,"Round")),"^",1)+invRoundSum
	
	//作废体检发票信息
	set abortPEInvNOStr=$p(footData,"^",70)            //HIS_PEParkINV 体检作废发票
	set $p(^||TMPINVNO(job,userDR,"PEParkINV"),"^",1)=abortPEInvNOStr
	set $p(^||TMPINVNO(job,userDR,"PEParkINV"),"^",2)=$l(abortPEInvNOStr,",")
	if (abortPEInvNOStr="") set $p(^||TMPINVNO(job,userDR,"PEParkINV"),"^",2)=0
	
	//红冲体检发票信息
	set strikePEInvNOStr=$p(footData,"^",71)            //HIS_PERefundINV 体检红冲发票
	set $p(^||TMPINVNO(job,userDR,"PERefundINV"),"^",1)=strikePEInvNOStr
	set $p(^||TMPINVNO(job,userDR,"PERefundINV"),"^",2)=$l(strikePEInvNOStr,",")
	if (strikePEInvNOStr="") set $p(^||TMPINVNO(job,userDR,"PERefundINV"),"^",2)=0
	
	//体检分币误差金额
	set PEinvRoundSum=$fn($p(footData,"^",72),"",2)     //HIS_PEINVRoundSum  体检分币误差
	set $p(^||TMPINVNO(job,userDR,"PEINVRound"),"^",1)=$p($g(^||TMPINVNO(job,userDR,"PEINVRound")),"^",1)+PEinvRoundSum
	
	//体检凑整金额
	set PEINVRoundIntSum=$p(footData,"^",74)             //HIS_PEINVRoundSum  体检凑整金额
	set $p(^||TMPINVNO(job,userDR,"PEINVRoundInt"),"^",1)=$p($g(^||TMPINVNO(job,userDR,"PEINVRoundInt")),"^",1)+PEINVRoundIntSum
	
	quit
}

/// Description: 根据交账id获取费别信息
/// Creator: zhli
/// CreatDate: 2018-03-12
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        stTime:开始时间(不能为空)
///        endTime:结束时间(不能为空)
///        hospDR:CT_Hospital.RowID(不能为空)
///        admReason:PAC_AdmReaon.RowID(可以不传或为空)
///        jkDR:DHC_INVPRTReports.RowID(个人日报需传值，汇总传空)
///        guser:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息)
/// Return: 
/// Debug: w ##class(web.DHCOPBillDailyPrint).GetAdmReason("33050", 2, "","")
ClassMethod GetAdmReason(stDate As %String, endDate As %String, stTime As %String, endTime As %String, jkDR As %String, hospDR As %String, guser As %String, job As %String) As %String
{
	set footData=$g(^DHCOPInsFoot(jkDR))
	set hospital=$p(footData,"^",66)              //HIS_HospitalDR->CT_Hospital
	quit:((hospDR'="")&&(hospital'=hospDR))
	set userDR=$p(footData,"^",8)                  //HIS_User->SS_User
	quit:((guser'="")&&(guser'=userDR))
	set footStDate=$p(footData,"^",5)
	set footStTime=$p(footData,"^",6)
	set footEndDate=$p(footData,"^",3)
	set footEndTime=$p(footData,"^",4)
	//quit:((stDate=footStDate)&&(stTime<footStTime))
	quit:((stDate=footEndDate)&&(stTime>=footEndTime)&&(stTime'=""))
	set insTypeSub=0
	for  set insTypeSub=$o(^DHCOPInsFoot(jkDR,"IC",insTypeSub)) quit:(insTypeSub="")  do
	.set insTypeInfo=$g(^DHCOPInsFoot(jkDR,"IC",insTypeSub))
	.quit:(insTypeInfo="")
	.set admReasonDR=$p(insTypeInfo,"^",1)       //ITC_InsType_DR->PAC_AdmReaon
	.set paymodeDR=$p(insTypeInfo,"^",2)         //ITC_Paymode_DR->CT_PayMode
	.//结算信息
	.set prtPayAmt=$p(insTypeInfo,"^",3)        //收费金额
	.set prtPayNum=$p(insTypeInfo,"^",4)        //收费数量
	.set $p(^||TMPINSTYPE(job,admReasonDR,paymodeDR,"PRT","N"),"^",1)=$p($g(^||TMPINSTYPE(job,admReasonDR,paymodeDR,"PRT","N")),"^",1)+prtPayAmt
	.set $p(^||TMPINSTYPE(job,admReasonDR,paymodeDR,"PRT","N"),"^",2)=$p($g(^||TMPINSTYPE(job,admReasonDR,paymodeDR,"PRT","N")),"^",2)+prtPayNum
	.set prtRefAmt=$p(insTypeInfo,"^",5)       //退费金额
	.set prtRefNum=$p(insTypeInfo,"^",6)       //退费数量
	.set $p(^||TMPINSTYPE(job,admReasonDR,paymodeDR,"PRT","S"),"^",1)=$p($g(^||TMPINSTYPE(job,admReasonDR,paymodeDR,"PRT","S")),"^",1)+prtRefAmt
	.set $p(^||TMPINSTYPE(job,admReasonDR,paymodeDR,"PRT","S"),"^",2)=$p($g(^||TMPINSTYPE(job,admReasonDR,paymodeDR,"PRT","S")),"^",2)+prtRefNum
	.//集中打印发票信息
	.set apiPayAmt=$p(insTypeInfo,"^",7)        //集中打印发票金额
	.set apiPayNum=$p(insTypeInfo,"^",8)        //集中打印发票数量
	.set $p(^||TMPINSTYPE(job,admReasonDR,paymodeDR,"API","N"),"^",1)=$p($g(^||TMPINSTYPE(job,admReasonDR,paymodeDR,"API","N")),"^",1)+apiPayAmt
	.set $p(^||TMPINSTYPE(job,admReasonDR,paymodeDR,"API","N"),"^",2)=$p($g(^||TMPINSTYPE(job,admReasonDR,paymodeDR,"API","N")),"^",2)+apiPayNum
	.set apiRefAmt=$p(insTypeInfo,"^",9)        //集中打印发票退票金额
	.set apiRefNum=$p(insTypeInfo,"^",10)       //集中打印发票退票数量
	.set $p(^||TMPINSTYPE(job,admReasonDR,paymodeDR,"API","S"),"^",1)=$p($g(^||TMPINSTYPE(job,admReasonDR,paymodeDR,"API","S")),"^",1)+apiRefAmt
	.set $p(^||TMPINSTYPE(job,admReasonDR,paymodeDR,"API","S"),"^",2)=$p($g(^||TMPINSTYPE(job,admReasonDR,paymodeDR,"API","S")),"^",2)+apiRefNum
	
	quit
}

/// Creator: zhli
/// CreatDate: 2018-03-12
/// Description: 根据交账id获取分类项目明细
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        stTime:开始时间(不能为空)
///        endTime:结束时间(不能为空)
///        hospDR:CT_Hospital.RowID(不能为空)
///        admReason:PAC_AdmReaon.RowID(可以不传或为空)
///        type:"TOC"(门诊收费大类) "OC"(门诊收费子类) "TAC"(会计大类) "AC"(会计分类) (可以为空,为空时按门诊收费大类统计)
///        jkDR:DHC_INVPRTReports.RowID(个人日报需传值，汇总传空)
///        guser:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息)
/// Return: 
/// Debug: w ##class(web.DHCOPBillDailyPrint).GetCateType("33050", 2, "","")
ClassMethod GetCateType(stDate As %String, endDate As %String, stTime As %String, endTime As %String, jkDR As %String, hospDR As %String, guser As %String, job As %String) As %String
{
	set footData=$g(^DHCOPInsFoot(jkDR))
	set hospital=$p(footData,"^",66)                 //HIS_HospitalDR->CT_Hospital
	quit:((hospDR'="")&&(hospital'=hospDR))
	set userDR=$p(footData,"^",8)                    //HIS_User->SS_User
	quit:((guser'="")&&(guser'=userDR))
	set footStDate=$p(footData,"^",5)
	set footStTime=$p(footData,"^",6)
	set footEndDate=$p(footData,"^",3)
	set footEndTime=$p(footData,"^",4)
	//quit:((stDate=footStDate)&&(stTime<footStTime))
	quit:((stDate=footEndDate)&&(stTime>=footEndTime)&&(stTime'=""))
	set cateSub=0
	for  set cateSub=$o(^DHCOPInsFoot(jkDR,"C",cateSub)) quit:(cateSub="")  do
	.set cateInfo=$g(^DHCOPInsFoot(jkDR,"C",cateSub))
	.quit:(cateInfo="")
	.set cateDR=$p(cateInfo,"^",1)              //->门诊收费大类/会计大类
	.set admReasonDR=$p(cateInfo,"^",2)         //HisSub_InsType_DR->PAC_AdmReason
	.set subCateDR=$p(cateInfo,"^",3)           //->门诊收费子类/会计分类
	.set tarType=$p(cateInfo,"^",4)
	.set:(tarType="OP") tarType="OC"			    //global节点做个转换
	.set:(tarType="PEOP") tarType="PEOC"			//global节点做个转换
	.set catePayAmt=$p(cateInfo,"^",5)
	.set cateRefAmt=$p(cateInfo,"^",6)
	.set cateDiscAmt=$p(cateInfo,"^",7)         //折扣金额
	.set catePayOrShareAmt=$p(cateInfo,"^",8)   //记账金额
	.set catePatShareAmt=$p(cateInfo,"^",9)     //自付金额
	.set $p(^||TMPCATE(job,tarType,admReasonDR,cateDR,subCateDR),"^",1)=$p($g(^||TMPCATE(job,tarType,admReasonDR,cateDR,subCateDR)),"^",1)+catePayAmt
	.set $p(^||TMPCATE(job,tarType,admReasonDR,cateDR,subCateDR),"^",2)=$p($g(^||TMPCATE(job,tarType,admReasonDR,cateDR,subCateDR)),"^",2)+cateRefAmt	
	.set $p(^||TMPCATE(job,tarType,admReasonDR,cateDR,subCateDR),"^",3)=$p($g(^||TMPCATE(job,tarType,admReasonDR,cateDR,subCateDR)),"^",3)+cateDiscAmt
	.set $p(^||TMPCATE(job,tarType,admReasonDR,cateDR,subCateDR),"^",4)=$p($g(^||TMPCATE(job,tarType,admReasonDR,cateDR,subCateDR)),"^",4)+catePayOrShareAmt	
	.set $p(^||TMPCATE(job,tarType,admReasonDR,cateDR,subCateDR),"^",5)=$p($g(^||TMPCATE(job,tarType,admReasonDR,cateDR,subCateDR)),"^",5)+catePatShareAmt
	
	quit
}

/// Creator: zhli
/// CreatDate: 2018-03-12
/// Description: 获取门诊日结汇总支付方式统计信息
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        stTime:开始时间(不能为空)
///        endTime:结束时间(不能为空)
///        hospDR:CT_Hospital.RowID(不能为空)
///        jkDR:DHC_INVPRTReports.RowID(个人日报需传值，汇总传空)
///        guser:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息)
/// Return: 
/// Debug: w ##class(web.DHCOPBillDailyPrint).GetPayMode("33050", 2, "","")
ClassMethod GetPayMode(stDate As %String, endDate As %String, stTime As %String, endTime As %String, jkDR As %String, hospDR As %String, guser As %String, job As %String) As %String
{
	set footData=$g(^DHCOPInsFoot(jkDR))
	set hospital=$p(footData,"^",66)               //HIS_HospitalDR->CT_Hospital
	quit:((hospDR'="")&&(hospital'=hospDR))
	set userDR=$p(footData,"^",8)                  //HIS_User->SS_User
	quit:((guser'="")&&(guser'=userDR))
	set footStDate=$p(footData,"^",5)
	set footStTime=$p(footData,"^",6)
	set footEndDate=$p(footData,"^",3)
	set footEndTime=$p(footData,"^",4)
	//quit:((stDate=footStDate)&&(stTime<footStTime)&&(stTime'=""))
	quit:((stDate=footEndDate)&&(stTime>=footEndTime)&&(stTime'=""))
	set paymSub=0
	while($o(^DHCOPInsFoot(jkDR,"P",paymSub))) {
		set paymSub=$o(^DHCOPInsFoot(jkDR,"P",paymSub))
		set paymSubData=$g(^DHCOPInsFoot(jkDR,"P",paymSub))
		continue:(paymSubData="")
		set chargeType=$p(paymSubData,"^",22)      //业务类型
		if (chargeType="") {
			set chargeType="OP"
		}
		set paymodeDR=$p(paymSubData,"^",1)        //HisPay_Paymode->CT_PayMode
		//结算信息
		set prtPayAmt=$p(paymSubData,"^",2)        //收费金额
		set prtPayNum=$p(paymSubData,"^",3)        //收费数量
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"PRT","N"),"^",1)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"PRT","N")),"^",1)+prtPayAmt
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"PRT","N"),"^",2)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"PRT","N")),"^",2)+prtPayNum
		set prtRefAmt=$p(paymSubData,"^",4)       //退费金额
		set prtRefNum=$p(paymSubData,"^",5)       //退费数量
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"PRT","S"),"^",1)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"PRT","S")),"^",1)+prtRefAmt
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"PRT","S"),"^",2)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"PRT","S")),"^",2)+prtRefNum
		//集中打印发票信息
		set apiPayAmt=$p(paymSubData,"^",6)       //集中打印发票金额
		set apiPayNum=$p(paymSubData,"^",7)       //集中打印发票张数
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"API","N"),"^",1)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"API","N")),"^",1)+apiPayAmt
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"API","N"),"^",2)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"API","N")),"^",2)+apiPayNum
		set apiRefAmt=$p(paymSubData,"^",8)       //集中打印发票退票金额
		set apiRefNum=$p(paymSubData,"^",9)       //集中打印发票退票张数
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"API","S"),"^",1)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"API","S")),"^",1)+apiRefAmt
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"API","S"),"^",2)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"API","S")),"^",2)+apiRefNum
		//预交金信息
		set accPDPayAmt=$p(paymSubData,"^",10)     //收预交金金额
		set accPDPayNum=$p(paymSubData,"^",11)     //收预交金数量
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"PD","N"),"^",1)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"PD","N")),"^",1)+accPDPayAmt
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"PD","N"),"^",2)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"PD","N")),"^",2)+accPDPayNum
		set accPDRefAmt=$p(paymSubData,"^",12)     //退预交金金额
		set accPDRefNum=$p(paymSubData,"^",13)     //退预交金数量
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"PD","S"),"^",1)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"PD","S")),"^",1)+accPDRefAmt
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"PD","S"),"^",2)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"PD","S")),"^",2)+accPDRefNum
		//卡发票信息
		set cardPayAmt=$p(paymSubData,"^",14)      //建卡金额
		set cardPayNum=$p(paymSubData,"^",15)      //建卡张数
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"CARD","N"),"^",1)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"CARD","N")),"^",1)+cardPayAmt
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"CARD","N"),"^",2)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"CARD","N")),"^",2)+cardPayNum
		set cardRefAmt=$p(paymSubData,"^",16)      //退卡金额
		set cardRefNum=$p(paymSubData,"^",17)      //退卡张数
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"CARD","S"),"^",1)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"CARD","S")),"^",1)+cardRefAmt
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"CARD","S"),"^",2)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"CARD","S")),"^",2)+cardRefNum
		//留观押金信息
		set EPDPayAmt=$p(paymSubData,"^",18)       //留观押金收费金额
		set EPDPayNum=$p(paymSubData,"^",19)       //留观押金收费数量
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"EPD","N"),"^",1)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"EPD","N")),"^",1)+EPDPayAmt
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"EPD","N"),"^",2)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"EPD","N")),"^",2)+EPDPayNum
		set EPDRefAmt=$p(paymSubData,"^",20)       //留观押金退费金额
		set EPDRefNum=$p(paymSubData,"^",21)       //留观押金退费数量
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"EPD","S"),"^",1)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"EPD","S")),"^",1)+EPDRefAmt
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"EPD","S"),"^",2)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"EPD","S")),"^",2)+EPDRefNum
		//代金卡发票信息
		set GiftCardPayAmt=$p(paymSubData,"^",23)      //建代金卡金额
		set GiftCardPayNum=$p(paymSubData,"^",24)      //建代金卡张数
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"GCARD","N"),"^",1)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"GCARD","N")),"^",1)+GiftCardPayAmt
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"GCARD","N"),"^",2)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"GCARD","N")),"^",2)+GiftCardPayNum
		set GiftCardRefundAmt=$p(paymSubData,"^",25)      //退代金卡金额
		set GiftCardRefundNum=$p(paymSubData,"^",26)      //退代金卡张数
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"GCARD","S"),"^",1)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"GCARD","S")),"^",1)+GiftCardRefundAmt
		set $p(^||TMPPAYM(job,chargeType,paymodeDR,"GCARD","S"),"^",2)=$p($g(^||TMPPAYM(job,chargeType,paymodeDR,"GCARD","S")),"^",2)+GiftCardRefundNum
	}
	
	quit
}

/// Creator: zhli
/// CreatDate: 2018-03-16
/// Description: 获取门诊日结汇总统计信息
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        stTime:开始时间(不能为空,汇总为空)
///        endTime:结束时间(不能为空,汇总为空)
///        hospDR:CT_Hospital.RowID(不能为空)
///        receId:DHC_INVPRTReports.RowID(个人日报传空，汇总需传值)
///        guserStr:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息,日报汇总用)
///        callType:调用哪个方法的标志 "Paymode":GetPayMode;"CateType":GetCateType;"AdmReason":GetAdmReason;"Invno":GetDailyInvNO;
///        groupDR:SS_Group 根据安全组配置来判断组长是否需要接收
/// Return: 
/// Debug: w ##class(web.DHCOPBillDailyPrint).GetDailyPrintHZInfo("33050", 2, "","")
ClassMethod GetDailyPrintHZInfo(stDate As %String, endDate As %String, stTime As %String, endTime As %String, hospDR As %String, guserStr As %Text, receId As %String, callType As %String, groupDR As %String, job As %String) As %String
{
	//收费组长接收标识
	set baseConfig=##class(web.UDHCOPGSConfig).ReadCFByGRowID(groupDR, hospDR)
	set receConfig=$p(baseConfig,"^",21)

	if (receConfig=1) do
	.if (receId="") do
	..//查询未接收结账记录
	..set footId=0
	..for  set footId=$o(^DHCOPInsFootI(0,"RECEIVEFLAG","N",footId)) quit:(footId="")  do
	...set footData=$g(^DHCOPInsFoot(footId))
	...quit:(footData="")
	...set preHandinFlag=$p(footData,"^",68)       
	...quit:(preHandinFlag="Y")                        //过滤预结算记录
	...set footHospDR=$p(footData,"^",66)
	...quit:((hospDR'="")&&(hospDR'=footHospDR))
	...set footDate=$p(footData,"^",2)
	...quit:((endDate'="")&&(footDate>endDate))
	...set userDR=$p(footData,"^",8)
	...set footEndDate=$p(footData,"^",3)
	...set footEndTime=$p(footData,"^",4)
	...quit:((stDate=footEndDate)&&(stTime>=footEndTime)&&(stTime'=""))
 	...quit:((guserStr'="")&&(("^"_guserStr_"^")'[("^"_userDR_"^")))             //按收费员过滤
	...if (callType="Paymode") do ..GetPayMode(stDate, endDate, stTime, endTime, footId, hospDR, userDR, job)
	...if (callType="CateType") do ..GetCateType(stDate, endDate, stTime, endTime, footId, hospDR, userDR, job)
	...if (callType="AdmReason") do ..GetAdmReason(stDate, endDate, stTime, endTime, footId, hospDR, userDR, job)
	...if (callType="Invno") do ..GetDailyInvNO(stDate, endDate, stTime, endTime, footId, hospDR, userDR, job)
	.else  do
	..//查询已接收结账记录
	..set footId=0
	..for  set footId=$o(^DHCOPInsFootI(0,"RECEIVEDR",receId,footId)) quit:(footId="")  do
	...set footData=$g(^DHCOPInsFoot(footId))
	...quit:(footData="")
	...set preHandinFlag=$p(footData,"^",68)
	...quit:(preHandinFlag="Y")                        //过滤预结算记录
	...set footHospDR=$p(footData,"^",66)              //HIS_HospitalDR
 	...quit:((hospDR'="")&&(hospDR'=footHospDR))
	...set userDR=$p(footData,"^",8)
	...set footEndDate=$p(footData,"^",3)
	...set footEndTime=$p(footData,"^",4)
	...quit:((stDate=footEndDate)&&(stTime>=footEndTime)&&(stTime'=""))
 	...quit:((guserStr'="")&&(("^"_guserStr_"^")'[("^"_userDR_"^")))             //按收费员过滤
	...if (callType="Paymode") do ..GetPayMode(stDate, endDate, stTime, endTime, footId, hospDR, userDR, job)
	...if (callType="CateType") do ..GetCateType(stDate, endDate, stTime, endTime, footId, hospDR, userDR, job)
	...if (callType="AdmReason") do ..GetAdmReason(stDate, endDate, stTime, endTime, footId, hospDR, userDR, job)
	...if (callType="Invno") do ..GetDailyInvNO(stDate, endDate, stTime, endTime, footId, hospDR, userDR, job)
	else  do
	.//不接收时按照日期查询
	.for date=stDate:1:endDate  do
	..set footId=0
	..for  set footId=$o(^DHCOPInsFootI(0,"Date",date,footId)) quit:(footId="")  do
	...set footData=$g(^DHCOPInsFoot(footId))
	...quit:(footData="")
	...set preHandinFlag=$p(footData,"^",68)
	...quit:(preHandinFlag="Y")                        //过滤预结算记录
	...set footHospDR=$p(footData,"^",66)              //HIS_HospitalDR
 	...quit:((hospDR'="")&&(hospDR'=footHospDR))     
	...set userDR=$p(footData,"^",8)
	...set footEndDate=$p(footData,"^",3)
	...set footEndTime=$p(footData,"^",4)
	...quit:((stDate=footEndDate)&&(stTime>=footEndTime)&&(stTime'=""))
 	...quit:((guserStr'="")&&(("^"_guserStr_"^")'[("^"_userDR_"^")))             //按收费员过滤
	...if (callType="Paymode") do ..GetPayMode(stDate, endDate, stTime, endTime, footId, hospDR, userDR, job)
	...if (callType="CateType") do ..GetCateType(stDate, endDate, stTime, endTime, footId, hospDR, userDR, job)
	...if (callType="AdmReason") do ..GetAdmReason(stDate, endDate, stTime, endTime, footId, hospDR, userDR, job)
	...if (callType="Invno") do ..GetDailyInvNO(stDate, endDate, stTime, endTime, footId, hospDR, userDR, job)
	
	quit
}

/// Creator: zhli
/// CreatDate: 2018-03-21
/// Description: 取汇总的开始结束日期，根据接收配置来
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        stTime:开始时间(不能为空)
///        endTime:结束时间(不能为空)
///        hospDR:CT_Hospital.RowID(不能为空)
///        UserID:SS_User.RowID(可以为空,为空时获取对应日期时间段内所有的收费员信息)
///        groupDR:SS_Group 根据安全组配置来判断组长是否需要接收
/// Return: 
/// Debug: d ##class(web.DHCIPBillDailyPrint).GetStEndDate("64708","64714","0","86399",2,4832)
ClassMethod GetStEndDate(stDate As %String, endDate As %String, stTime As %String, endTime As %String, footId As %String, guserStr As %Text, receId As %String, job As %String, groupDR As %String, hospDR As %String)
{
	//收费组长接收标识
	set baseConfig=##class(web.UDHCOPGSConfig).ReadCFByGRowID(groupDR, hospDR)
	set receConfig=$p(baseConfig,"^",21)

	if (receConfig=1) do
	.if (receId="") do
	..//查询未接收结账记录
	..set footId=0
	..for  set footId=$o(^DHCOPInsFootI(0,"RECEIVEFLAG","N",footId)) quit:(footId="")  do
	...set footData=$g(^DHCOPInsFoot(footId))
	...quit:(footData="")
	...set preHandinFlag=$p(footData,"^",68)       
	...quit:(preHandinFlag="Y")                        //过滤预结算记录
	...set footHospDR=$p(footData,"^",66)
	...quit:((hospDR'="")&&(hospDR'=footHospDR))
	...set footDate=$p(footData,"^",2)
	...quit:((endDate'="")&&(footDate>endDate))
	...set userDR=$p(footData,"^",8)
	...set footEndDate=$p(footData,"^",3)
	...set footEndTime=$p(footData,"^",4)
	...quit:((stDate=footEndDate)&&(stTime>=footEndTime)&&(stTime'=""))
 	...quit:((guserStr'="")&&(("^"_guserStr_"^")'[("^"_userDR_"^")))             //按收费员过滤
 	...set ^||TMPDATE(job,footDate)=""
	.else  do
	..//查询已接收结账记录
	..set footId=0
	..for  set footId=$o(^DHCOPInsFootI(0,"RECEIVEDR",receId,footId)) quit:(footId="")  do
	...set footData=$g(^DHCOPInsFoot(footId))
	...quit:(footData="")
	...set preHandinFlag=$p(footData,"^",68)
	...quit:(preHandinFlag="Y")                        //过滤预结算记录
	...set footHospDR=$p(footData,"^",66)              //HIS_HospitalDR
 	...quit:((hospDR'="")&(hospDR'=footHospDR))     
	...set userDR=$p(footData,"^",8)
	...set footEndDate=$p(footData,"^",3)
	...set footEndTime=$p(footData,"^",4)
	...quit:((stDate=footEndDate)&&(stTime>=footEndTime)&&(stTime'=""))
 	...quit:((guserStr'="")&&(("^"_guserStr_"^")'[("^"_userDR_"^")))             //按收费员过滤
 	...set footDate=$p(footData,"^",2)
 	...set ^||TMPDATE(job,footDate)=""
	else  do
	.//不接收时按照日期查询
	.for date=stDate:1:endDate  do
	..set footId=0
	..for  set footId=$o(^DHCOPInsFootI(0,"Date",date,footId)) quit:(footId="")  do
	...set footData=$g(^DHCOPInsFoot(footId))
	...quit:(footData="")
	...set preHandinFlag=$p(footData,"^",68)
	...quit:(preHandinFlag="Y")                        //过滤预结算记录
	...set footHospDR=$p(footData,"^",66)              //HIS_HospitalDR
 	...quit:((hospDR'="")&&(hospDR'=footHospDR))     
	...set userDR=$p(footData,"^",8)
	...set footEndDate=$p(footData,"^",3)
	...set footEndTime=$p(footData,"^",4)
	...quit:((stDate=footEndDate)&&(stTime>=footEndTime)&&(stTime'=""))
 	...quit:((guserStr'="")&&(("^"_guserStr_"^")'[("^"_userDR_"^")))             //按收费员过滤
	.set ^||TMPDATE(job,stDate)=""
	.set ^||TMPDATE(job,endDate)=""
	
	quit
}

/// 医院核销发票统计报表
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillDailyPrint","ConfirmInvprtQuery","2022-05-23","2022-08-16")
Query ConfirmInvprtQuery(startDate As %String, endDate As %String) As websys.Query(ROWSPEC = "ind,invType:%String,num:%String,startNo:%String,endNo:%String,StDate:%String,EndDate:%String,totalAmt:%Float,zfNum:%Integer,hcNum:%Integer") [ SqlProc ]
{
}

ClassMethod ConfirmInvprtQueryExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
 	if ((startDate="")||(endDate=""))  quit $$$OK
	set sDate=$zdh(startDate,3)
    set eDate=$zdh(endDate,3)
    
    for date=sDate:1:eDate  do
    .s conInvRowid=""
 	.f  s conInvRowid=$o(^DHCCONFIRMINVOICE(0,"Date",date,conInvRowid)) quit:(conInvRowid="")  do
	..s userDr=$p(^DHCCONFIRMINVOICE(conInvRowid),"^",4)
    ..s invRowid=$p(^DHCCONFIRMINVOICE(conInvRowid),"^",1)
    ..q:($p($g(^DHCINVOICE(invRowid)),"^",15)'="")
    ..s startNo=$p($g(^DHCINVOICE(invRowid)),"^",1)
	..s endNo=$p($g(^DHCINVOICE(invRowid)),"^",2)
    ..s invType=$p($g(^DHCINVOICE(invRowid)),"^",8)
    ..s invTitle=$p($g(^DHCINVOICE(invRowid)),"^",16)
    ..i invType="O" set invType="门诊"
    ..i invType="R" set invType="挂号"
    ..i invType="I" set invType="住院"
    ..s num=+endNo-(+startNo)+1
    ..s StDate="", EndDate=""
    ..i (startNo'="") d
   	...i $d(^DHCINVPRT(0,"INV",invTitle_startNo)) d
   	....s StPrtRowId=$o(^DHCINVPRT(0,"INV",invTitle_startNo,""))
   	....s StDate=$p(^DHCINVPRT(StPrtRowId),"^",5)
   	...e  i $d(^DHCINVPRTAPi(0,"INVNo",invTitle_startNo)) d
   	....s StPrtRowId=$o(^DHCINVPRTAPi(0,"INVNo",invTitle_startNo,""))
   	....s StDate=$p(^DHCINVPRTAP(StPrtRowId),"^",3)
   	...e  i $d(^DHCINVPRTZY(0,"INV",invTitle_startNo)) d
   	....s StPrtRowId=$o(^DHCINVPRTZY(0,"INV",invTitle_startNo,""))
   	....s StDate=$p(^DHCINVPRTZY(StPrtRowId),"^",2)
   	..i (endNo'="") d
   	...i $d(^DHCINVPRT(0,"INV",invTitle_endNo)) d
   	....s EndPrtRowId=$o(^DHCINVPRT(0,"INV",invTitle_endNo,""))
   	....s EndDate=$p(^DHCINVPRT(EndPrtRowId),"^",5)
   	...e  i $d(^DHCINVPRTAPi(0,"INVNo",invTitle_endNo)) d
   	....s EndPrtRowId=$o(^DHCINVPRTAPi(0,"INVNo",invTitle_endNo,""))
   	....s EndDate=$p(^DHCINVPRTAP(EndPrtRowId),"^",3)
   	...e  i $d(^DHCINVPRTZY(0,"INV",invTitle_endNo)) d
   	....s EndPrtRowId=$o(^DHCINVPRTZY(0,"INV",invTitle_endNo,""))
   	....s EndDate=$p(^DHCINVPRTZY(EndPrtRowId),"^",2)
   	..s StDate=##class(websys.Conversions).DateLogicalToHtml(StDate)
   	..s EndDate=##class(websys.Conversions).DateLogicalToHtml(EndDate)
   	..s totalAmt=0
   	..s zfNum=0,hcNum=0
   	..s invLen=$l(startNo)
   	..f curNo=(+startNo):1:(+endNo) do
   	...s myNo=invTitle_""_##class(web.UDHCJFBaseCommon).FormatINVNO(curNo, invLen)
   	...i invType="住院" do
   	....s prt=$o(^DHCINVPRTZY(0,"INV",myNo,""))
   	....i (prt'="") do
   	.....s account=$p(^DHCINVPRTZY(prt),"^",6)
   	.....s flag=$p(^DHCINVPRTZY(prt),"^",8)
   	.....s totalAmt=totalAmt+account
   	.....s:flag="A" zfNum=zfNum+1
	.....s:flag="S" hcNum=hcNum+1
   	...e  do
   	....i $d(^DHCINVPRT(0,"INV",myNo)) d
   	.....s prt=$o(^DHCINVPRT(0,"INV",myNo,""))
   	.....i prt'="" d
   	......s account=$p(^DHCINVPRT(prt),"^",1)
   	......s totalAmt=totalAmt+account
   	......s flag=$p(^DHCINVPRT(prt),"^",8)
   	......s:flag="A" zfNum=zfNum+1
	......s:flag="S" hcNum=hcNum+1
	....e  i $d(^DHCINVPRTAPi(0,"INVNo",myNo)) d
	.....s prt=$o(^DHCINVPRTAPi(0,"INVNo",myNo,""))
	.....i (prt'="") d
	......s account=$p(^DHCINVPRTAP(prt),"^",1)
	......s totalAmt=totalAmt+account
	......s flag=$p(^DHCINVPRTAP(prt),"^",2)
	......s:flag="A" zfNum=zfNum+1
	......s:flag="S" hcNum=hcNum+1
   	..q:((startNo="")&&(endNo="")&&(StDate="")&&(EndDate=""))
    ..d ConfirmInvprtQuery

  	quit $$$OK

ConfirmInvprtQuery
	set Data=$lb(ind,invType,num,startNo,endNo,StDate,EndDate,totalAmt,zfNum,hcNum)
    set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: 
/// CreatDate: 20220314
/// Description: 获取门诊日结办事处辖区打折金额 日报子表没有存(按收费员汇总)
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        hospDR:CT_Hospital.RowID(不能为空)
///        guser:SS_User.RowID(可以为空,为空时按收费员输出对应发票信息)
///        Name:患者姓名
/// Output: 
/// Return: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillDailyPrint","GetOPBillYCFDiscMXReport","2022-03-19","2022-07-31","2","","","","")
Query GetOPBillYCFDiscMXReport(stDate As %String, endDate As %String, hospDR As %String, guser As %String, Name As %String) As websys.Query(ROWSPEC = "ind,PRTRowid,PRTDisc,PaName,papmiid,PAPMINO,Invno,PRTAcount:%Float,PRTDiscAmount:%Float,PRTPatientShare:%Float,READesc,PRTDate,PRTUsr,Tel,PaSex,DocDesc") [ SqlProc ]
{
}

ClassMethod GetOPBillYCFDiscMXReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, hospDR As %String, guser As %String, Name As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    set ^TMP("GetOPBillYCFDiscMXReport")=$lb(stDate, endDate, hospDR, guser,Name)
	if ((stDate="")||(endDate="")) quit $$$OK
	s:stDate'="" stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
    s:endDate'="" endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)

	for date=stDate:1:endDate  do
	.s PRTRowid=0
	.f  s PRTRowid=$o(^DHCINVPRT(0,"Date",date,PRTRowid))  quit:(PRTRowid="")  do
	..s PRTData=$g(^DHCINVPRT(PRTRowid))
	..s Invno=$p(PRTData,"^",14)
	..s PRTAcount=$p(PRTData,"^",1)  //总金额
	..s PRTAcount=$fn(PRTAcount,"",2)
	..s PRTPatientShare=$p(PRTData,"^",16)
	..s PRTPatientShare=$fn(PRTPatientShare,"",2)
	..s PRTDiscAmount=$p(PRTData,"^",7) //折扣金额
	..s PRTDiscAmount=$fn(PRTDiscAmount,"",2)
	..s PRTFairType=$p(PRTData,"^",34)
	..q:(PRTFairType="R")
	..s PRTFlag=$p(PRTData,"^",8)
	..s PRTInsTypeDR=$p(PRTData,"^",9)
	..s READesc=$p(^PAC("ADMREA",PRTInsTypeDR),"^",2)  //费别描述
	..s PRTDisc=""
	..s PRTPAPMIDR=$p(PRTData,"^",15)
	..s papmiid=$p(^PAPER(PRTPAPMIDR,"ALL"),"^",9)  //身份证号
	..s PaName=$p(^PAPER(PRTPAPMIDR,"ALL"),"^",1)    //姓名
	..q:((Name'="")&&(PaName'[Name))
	..s PAPMINO=$p(^PAPER(PRTPAPMIDR,"PAT",1),"^",1) //登记号
	..s PaSex=$p(^PAPER(PRTPAPMIDR,"ALL"),"^",7) //
 	..s PaSex=$p(^CT("SEX",PaSex),"^",2)        //性别 
 	..s Condr=$o(^DHCBCI(0,"INV",PRTRowid,""),-1)
	..s ADMRowID=$p($g(^DHCBCI(Condr)),"^",3)
 	..s DocID=$p(^PAADM(ADMRowID),"^",9)
	..i (DocID="")  d
	...s DocCode=""
	...s DocDesc=""
	..e  d
	...i ('$d(^CTPCP(DocID))) d
	....s DocCode=""
	....s DocDesc=""
	...e  d
	....s DocCode=$p(^CTPCP(DocID,1),"^",1) //医生号
	....s DocDesc=$p(^CTPCP(DocID,1),"^",2) //医生
	..s PRTDate=$p(PRTData,"^",5)
	..s PRTDate=##class(websys.Conversions).DateLogicalToHtml(PRTDate)
	..s PRTTime=$p(PRTData,"^",20)
	..s PRTTime=##class(websys.Conversions).TimeLogicalToHtml(PRTTime)
	..s PRTDate=PRTDate_" "_PRTTime
	..s PRTUsr=$p(PRTData,"^",21)
	..q:(guser'="")&&(guser'=PRTUsr)
	..s PRTUsr=$p($g(^SSU("SSUSR",PRTUsr)),"^",2)
	..s Tel=$p(^PAPER(PRTPAPMIDR,"PER",1),"^",11)
	..s HospDr = $p(PRTData,"^",39) //2023-03-15 LUANZH 增加院区过滤条件
	..q:(HospDr'=hospDR)
    ..d YCFDisc
	
	quit $$$OK
YCFDisc
	set data=$lb(ind,PRTRowid,PRTDisc,PaName,papmiid,PAPMINO,Invno,PRTAcount,PRTDiscAmount,PRTPatientShare,READesc,PRTDate,PRTUsr,Tel,PaSex,DocDesc)
	set ^CacheTemp(repid,ind)=data
	set ind=$i(ind)
	quit
}

/// do ##class(%ResultSet).RunQuery("web.DHCOPBillDailyPrint","FindOPIPPrtByDate","2022-10-31","2022-10-31")
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
	s globel=""
	;s:DateType=""||DateType="0" globel="PrtDate" ; 按结算日期查
	;s:DateType="1" globel="JkDate"  ; 按日结日期查
	; Date HandDate
	
	s SSUSRName="",DepDesc=""
	f date=StDate:1:EndDate d
 	.set rowid="",IUDID="",OPIPInfoRowid=""
 	.for  set rowid=$o(^DHCINVPRT(0,"Date",date,rowid)) quit:(rowid="")  do ; DHC_OPIPADMCON这张表
 	..set PrtInfo=$g(^DHCINVPRT(rowid))
 	..set PRTAcount=$p(PrtInfo,"^",16)
 	..q:PRTAcount>=0
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
	..Q:DeptId'=""&&(DeptId'=DepID)
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
	..s Amount=$p(Info,"^",1)   ; 差额
	..s UserDR=$p(Info,"^",2)	; 负票操作员
	..s InitPrtDate=$p(Info,"^",3)	; 负票时间
	..;q:(InitPrtDate>=EndDate)
	..;q:(InitPrtDate<=StDate)
	..s:InitPrtDate'="" InitPrtDate=$zd(InitPrtDate,3)
	..s:UserDR'="" SSUSRName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
	..s IUDID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxEInvFlg","OP",PRTinitInvDR,"E","B",IUDID))
	..s:IUDID="" Invno="无"
    ..i IUDID'="" d
    ...s objUpDetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(IUDID,0)
    ...s Invno=objUpDetail.EinvprtNo
	
	..do FindOPIPPrtByDate

	quit $$$OK
	

	
FindOPIPPrtByDate
	set Data=$lb(ind,MediCare,PaName,Invno,Amount,PRTDate,DepDesc,VisitStatus,SSUSRName,InitPrtDate)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

///  根据最开始的正票 算出部分退和全退的差额
/// w ##class(web.DHCIPBillDailyPrint).GetAmountByPrtRowid("1750235")
/// w ##class(web.DHCIPBillDailyPrint).GetAmountByPrtRowid("1750233")
ClassMethod GetAmountByPrtRowid(InvDr)
{
	s Amount=0,UserDr="",InitInvDR=""
	;^DHCINVPRT(0,"InitInvDR",{PRT_initInv_DR},{PRT_Rowid}) 全退的负票
	;^DHCINVPRT(0,"OldINV",{PRT_OldINV_DR},{PRT_Rowid}) 部分退正票
	i ($d(^DHCINVPRT(0,"OldINV",InvDr)))&&($d(^DHCINVPRT(0,"InitInvDR",InvDr))) d
	.s OldINV=$o(^DHCINVPRT(0,"OldINV",InvDr,""),-1)
	.s InitInvDR=$o(^DHCINVPRT(0,"InitInvDR",InvDr,""),-1)
	.s OldINVAmount=$p(^DHCINVPRT(OldINV),"^",16)  ; 取优惠金额还是真正金额？
	.s InitInvDRAmount=$p($g(^DHCINVPRT(InitInvDR)),"^",16) ; 取优惠金额还是真正金额？
	.s UserDr=$p(^DHCINVPRT(InitInvDR),"^",21)
	.s Amount=OldINVAmount+InitInvDRAmount
	.s PRTDate=$p($g(^DHCINVPRT(InitInvDR)),"^",5)
	.;i (PRTDate<StDate)&&(PRTDate>PRTDate) s Amount=0 ; 负票不在开始结束日期节点的金额变成0
	i $d(^DHCINVPRT(0,"InitInvDR",InvDr))&&('$d(^DHCINVPRT(0,"OldINV",InvDr)))  d
	.s InitInvDR=$o(^DHCINVPRT(0,"InitInvDR",InvDr,""),-1)
	.s InitInvDRAmount=$p(^DHCINVPRT(InitInvDR),"^",16) ; 取优惠金额还是真正金额？
	.s Amount=InitInvDRAmount
	.s UserDr=$p(^DHCINVPRT(InitInvDR),"^",21)
	.s PRTDate=$p($g(^DHCINVPRT(InitInvDR)),"^",5)
	.;i (PRTDate<StDate)&&(PRTDate>PRTDate) s Amount=0
	
	q Amount_"^"_UserDr_"^"_PRTDate
}

/// 单位记账统计报表
/// d ##class(%ResultSet).RunQuery("web.DHCOPBillDailyPrint","GetHCPChargeInfo","2023-02-01","2023-02-09","","2")
Query GetHCPChargeInfo(StartDate As %String, EndDate As %String, Unit As %String, HOSPID As %String = "") As websys.Query(ROWSPEC = "ind,PatNo:%String,PRTDate:%String,PatName:%String,PatDep:%String,JZAmt:%Float,YPAmt:%Float,JCAmt:%Float,JYAmt:%Float,Acount:%Float,PRTPatientShare:%Float,AdmSource:%String,EInvNo:%String,QTAmt:%Float,UnitDesc:%String") [ SqlProc ]
{
}

ClassMethod GetHCPChargeInfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, Unit As %String, HOSPID As %String = "") As %Status
{
	set ^licheng("GetHCPChargeInfoExecute")=$lb(StartDate,EndDate,Unit)
	Set repid=$I(^CacheTemp)
	s ind=1
	
	Set qHandle=$lb(0,repid,0)
	quit:StartDate="" $$$OK
    quit:EndDate="" $$$OK
	set StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	For seDate = StartDate:1:EndDate Do
	.set PrtRowid="" for  set PrtRowid=$o(^DHCINVPRT(0,"Date",seDate,PrtRowid))  quit:PrtRowid=""  do
	..set PrtUser=$p(^DHCINVPRT(PrtRowid),"^",21)
	..set papmi=$p(^DHCINVPRT(PrtRowid),"^",15)
	..set invFlag=$p(^DHCINVPRT(PrtRowid),"^",8)
	..quit:invFlag'="N"
	..set PRTPatientShare=$p(^DHCINVPRT(PrtRowid),"^",16)
	..set hospDR=$p(^DHCINVPRT(PrtRowid),"^",39)
	..quit:(hospDR'=HOSPID)&&(HOSPID'="")
	..set:PrtRowid'="" InvNo=$p(^DHCINVPRT(PrtRowid),"^",14) //取发票号
	..set InsTypeDR=$p(^DHCINVPRT(PrtRowid),"^",9)
	..set AdmSource=$p(^PAC("ADMREA",InsTypeDR),"^",2)
	..set Acount=$p(^DHCINVPRT(PrtRowid),"^",1)
	..set PatNo=$p(^PAPER(papmi,"PAT",1),"^",1) //登记号
	..set PatName=$p(^PAPER(papmi,"ALL"),"^",1) //姓名
	..set PRTDate=$p(^DHCINVPRT(PrtRowid),"^",5)
	..set PRTDate=$zd(PRTDate,3)
	..set BCIRowId=$O(^DHCBCI(0,"INV",PrtRowid,0))
	..set ADMRowID=$p(^DHCBCI(BCIRowId),"^",3)
	..set DepId=$p(^PAADM(ADMRowID),"^",4)
	..set PatDep=$p(^CTLOC(DepId),"^",2)
	..set JZAmt=0,YPAmt=0,JCAmt=0,JYAmt=0,payUnit=""
	..set IPM=0 for  set IPM=$o(^DHCINVPRT(PrtRowid,"P",IPM)) quit:IPM=""  do
	...set s=$g(^DHCINVPRT(PrtRowid,"P",IPM))
	...set payMDr=$p(s,"^",1)
	...set payAmt=$p(s,"^",3)
	...set payModeDesc=$p(^CT("CTPM",payMDr),"^",2)
	...set payModeCode=$p(^CT("CTPM",payMDr),"^",1)
	...set payUnit=$p(s,"^",9)
	...if payModeCode="CCP" set JZAmt=JZAmt+payAmt
	..quit:(payUnit'=Unit)&&(Unit'="")
	..quit:JZAmt=0
	..;b ;1
	..set UnitDesc=""
	..set:payUnit'="" UnitDesc=$p(^CT("HCP",payUnit),"^",2) //单位名称
	..set Condr=""
	..for  set Condr=$o(^DHCBCI(0,"INV",PrtRowid,Condr))  quit:Condr=""  do
	...set Bill=$p($g(^DHCBCI(Condr)),"^",2)
	...set BillOrd=0
	...for  set BillOrd=$o(^DHCPB(Bill,"O",BillOrd))  quit:BillOrd=""   do
	....set ARCItmMast=$p(^DHCPB(Bill,"O",BillOrd),"^",3)
	....set PatientShare=$p(^DHCPB(Bill,"O",BillOrd),"^",11)
	....set ARCIMRowid=$P(ARCItmMast,"||",1)
	....set ARCIMSub=$P(ARCItmMast,"||",2)  
	....set ItemCatDR=$P(^ARCIM(ARCIMRowid,ARCIMSub,1),"^",10)
	....set OrderType=$p(^ARC("IC",ItemCatDR),"^",7)
	....set:OrderType="R" YPAmt=YPAmt+PatientShare
	....set:OrderType="L" JYAmt=JYAmt+PatientShare
	....set:OrderType="X" JCAmt=JCAmt+PatientShare
	..set QTAmt=PRTPatientShare-YPAmt-JYAmt-JCAmt
	..w PrtRowid,!
	..do GetHCPChargeInfo
	
  	Set qHandle=$lb(0,repid,0)
  	Quit $$$OK
GetHCPChargeInfo
	set Data=$lb(ind,PatNo,PRTDate,PatName,PatDep,JZAmt,YPAmt,JCAmt,JYAmt,Acount,PRTPatientShare,AdmSource,InvNo,QTAmt,UnitDesc)
				
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-06-15
/// Description: 查询合同单位
/// Table: CT_HealthCareProvider
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillDailyPrint","HCPList","2")
Query HCPList(HOSPID As %String, langId As %String = "") As websys.Query(ROWSPEC = "HCPRowId:%String,HCPName:%String") [ SqlProc ]
{
}

ClassMethod HCPListExecute(ByRef qHandle As %Binary, HOSPID As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}

	set HCPRowId=""
	set HCPName="　"	//此处是一个全角空格
	do OutputHCPList
	
	set HCPRowId=0
	while ($o(^CT("HCP",HCPRowId))) {
		set HCPRowId=$o(^CT("HCP",HCPRowId))
		set data=$g(^CT("HCP",HCPRowId))
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_HealthCareProvider", HCPRowId, HOSPID)
		continue:(showFlag="N")
		set isActive=$p(data,"^",6)
		continue:(isActive'="Y")
		set HCPName=$p(data,"^",2)
		set HCPName=##class(User.CTHealthCareProvider).GetTranByDesc("HCPDesc", HCPName, langId)
		do OutputHCPList
	}
	
	quit $$$OK
OutputHCPList
	set Data=$lb(HCPRowId,HCPName)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

}
