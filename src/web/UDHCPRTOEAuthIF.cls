/// 审批结果的接口，写数据到审批表中或读审批判断到其他程序中
Class web.UDHCPRTOEAuthIF Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 读取票据级别的是否需要审批
/// 增加一个特殊限制标志
/// 此特殊标志，使界面的操作员退自己出的发票失效
/// =Y  表示失效, =N  或  ""  表示无效
/// w ##class(web.UDHCPRTOEAuthIF).ReadINVAuthFlag("","")
ClassMethod ReadINVAuthFlag(PRTRowID As %String, ExpStr As %String) As %String
{
	n (PRTRowID, ExpStr)
	
	;ExpStr=gLocDR^ULoadDRLoc
	s mygLocDR=$p(ExpStr,"^",1)
	s myULoadDRLoc=$p(ExpStr,"^",2)
	s myrtn=##class(web.UDHCPRTOEAuthCommon).ReadINVAuthFlag(PRTRowID, mygLocDR, myULoadDRLoc)

	q myrtn
}

/// 读取每条医嘱的审批标志
/// 对于所有的医嘱只有审批JS才能退费，
/// 分为DHC_INVPRT审批或OEOrdItem审批两级
ClassMethod ReadOEORDAuthFlag(PRTRowID As %String, OEORDDR As %String = "", ExpStr As %String) As %String
{
	n (PRTRowID, OEORDDR, ExpStr)
	s myrtn=##class(web.UDHCPRTOEAuthCommon).ReadOEORDAuthFlag(PRTRowID, OEORDDR, ExpStr)
	q myrtn
}

}
