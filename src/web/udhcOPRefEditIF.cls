Class web.udhcOPRefEditIF Extends BILL.COM.Abstract
{

/// 此函数是正常发票的退费函数
/// 主要针对于DHC_INVPRT表
/// w ##class(web.udhcOPRefEditIF).RefundReceipt("236381","10207","S","2637||4^2637||5","1.39","238","1","238","1","1","N^^^^")
ClassMethod RefundReceipt(INVPRTRowid As %String, rUser As %String, sFlag As %String, StopOrdStr As %String, NInvPay As %String, gloc As %String, RebillFlag As %String, ULoadLocDR As %String, RPayModeDR As %String, NewInsType As %String = "", ExpStr As %String = "") As %String
{
	set ^TMP("RefundReceipt")=$lb(INVPRTRowid, rUser, sFlag, StopOrdStr, NInvPay, gloc, RebillFlag, ULoadLocDR, RPayModeDR, NewInsType, ExpStr)
	
	set rtn=0
	
	set myVer=##class(web.DHCOPConfig).GetVersion()	
	if (+myVer=0) {
		set rtn=0
	}else{
		set rtn=##class(web.udhcOPRefEdit1).RefundReceipt(INVPRTRowid, rUser, sFlag, StopOrdStr, NInvPay, gloc, RebillFlag, ULoadLocDR, RPayModeDR, NewInsType, ExpStr)
	}
	quit rtn
}

/// 专门为集中打印过发票的进行退费	
/// w ##class(web.udhcOPRefEditIF).AccPayINVRefund()
ClassMethod AccPayINVRefund(APIRowID As %String, PRTOrdStr As %String, rUser As %String, sFlag As %String, gloc As %String, ULoadLocDR As %String, RPayModeDR As %String, RefPaySum As %String, RebillFlag As %String, ExpStr As %String) As %String
{
	set ^TMP("AccPayINVRefund")=$lb(APIRowID, PRTOrdStr, rUser, sFlag, gloc, ULoadLocDR, RPayModeDR, RefPaySum, RebillFlag, ExpStr)

	set rtn=0
	set myVer=##class(web.DHCOPConfig).GetVersion()	
	if (+myVer=0) {
		set rtn=0
	}else {
		set rtn=##class(web.udhcOPRefEdit1).AccPayINVRefund(APIRowID, PRTOrdStr, rUser, sFlag, gloc, ULoadLocDR, RPayModeDR, RefPaySum, RebillFlag, ExpStr)
	}
	quit rtn
}

/// w ##class(web.udhcOPRefEditIF).CancleRefundINVPRT("154","6","","")
ClassMethod CancleRefundINVPRT(INVPRTRowid As %String, rUser As %String, gloc As %String, ULoadLocDR As %String) As %String
{
	set rtn=0
	
	set rtn=##class(web.udhcOPRefEdit1).CancleRefundINVPRT(INVPRTRowid, rUser, gloc, ULoadLocDR)
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2019-04-29
/// Description: 过号重打
/// Input: invRowId:发票rowid, invFlag:(API:集中打印发票, PRT:门诊结算发票), sessionStr:扩展串(格式：userId^groupId^ctLocId^hospId)
/// Return: 
/// Other: 
/// Debug: w ##class(web.udhcOPRefEditIF).PassNoRePrint("3851","PRT","5^122^238^2")
ClassMethod PassNoRePrint(invRowId As %String, invFlag As %String, sessionStr As %String) As %String
{
	set myVer=##class(web.DHCOPConfig).GetVersion()
	if (+myVer=0) {
		set rtn=0
	}else{
		set rtn=##class(web.udhcOPRefEdit1).PassNoRePrint(invRowId, invFlag, sessionStr)
	}
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2020-07-09
/// Description: 补掉医保接口后更新发票费别和找平支付方式
/// Input: prtRowId:DHC_INVPRT.RowId, insTypeId:PAC_AdmReason.RowId, userId:SS_User.RowId
/// Return: rtn_"^"_insuPaySum (rtn =0:成功, <>0:失败)
/// Debug: w ##class(web.udhcOPRefEditIF).UpdateInvInsuDiv(4403, 4, 12173)
ClassMethod UpdateInvInsuDiv(prtRowId As %String, insTypeId As %String, userId As %String) As %String
{
	set rtn=##class(web.udhcOPRefEdit1).UpdateInvInsuDiv(prtRowId, insTypeId, userId)
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2021-04-19
/// Description: 撤销集中打印发票
/// Input: AccPInvId:DHC_AccPayInv.RowId，UserId:SS_User.RowId
/// Return: 
/// Debug: w ##class(web.udhcOPRefEditIF).WriteOffAPI("22513","639")
ClassMethod WriteOffAPI(AccPInvId As %String, UserId As %String) As %String
{
	set rtn=##class(web.udhcOPRefEdit1).WriteOffAPI(AccPInvId, UserId)
	quit rtn
}

}
