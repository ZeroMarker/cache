Class web.udhcOPRefBroker Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 此界面只是用来交互的
/// w ##class(web.udhcOPRefBroker).RefundReceipt("232128","5","A","157||2","800","122","1","238","1","1","N^^^^")
ClassMethod RefundReceipt(INVPRTRowid As %String, rUser As %String, sFlag As %String, StopOrdStr As %String, NInvPay As %String, gloc As %String, RebillFlag As %String, ULoadLocDR As %String, RPayModeDR As %String, NewInsType As %String, myExpStr As %String) As %String
{
	new (INVPRTRowid, rUser, sFlag, StopOrdStr, NInvPay, gloc, RebillFlag, ULoadLocDR, RPayModeDR, NewInsType, myExpStr)
	set ^TMP("RefundReceipt")=$lb(INVPRTRowid, rUser, sFlag, StopOrdStr, NInvPay, gloc, RebillFlag, ULoadLocDR, RPayModeDR, NewInsType, myExpStr)
	//q -1
	set myExpStr=$g(myExpStr)
	set rtn=##class(web.udhcOPRefEditIF).RefundReceipt(INVPRTRowid, rUser, sFlag, StopOrdStr, NInvPay, gloc, RebillFlag, ULoadLocDR, RPayModeDR, NewInsType, myExpStr)
	quit rtn
}

}
