Import sqluser

Class web.DHCST.DHCPayQuery Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 设置付款确认（采购）
/// Author:zhwh
/// Date:2012-08-31
/// Argu:
///  pay- 付款单主表rowid
/// Return :
/// 0 -success
/// <0 -failure
ClassMethod SetPayAck1(pay As %String, user As %String) As %String
{
  s appName=##class(web.DHCST.DHCPay).%GetParameter("AppName")
  q:##class(web.DHCST.Common.AppCommon).Lock(appName_pay)<0 -99
  //查看是否完成
  &sql(select pay_completed,pay_ack1,pay_ack2 into :comp,:ack1,:ack2 from dhc_pay where %ID=:pay)
  i SQLCODE'=0 d ..uLock(pay) q -1
  i comp'="Y" d ..uLock(pay) q -2  //未完成
  i ack1="Y" d ..uLock(pay) q -3  //已经确认
  s yes="Y"
  s user=$G(user)
  s ackdate=+$h
  &sql(update dhc_pay set pay_ack1=:yes,pay_date_ack1=:ackdate,pay_ssusr_ack1=:user where %ID=:pay)
  i SQLCODE'=0 d ..uLock(pay) q -4
  d ..uLock(pay)
  q 0
}

/// 设置付款确认（会计）
/// Author:zhwh
/// Date:2012-08-31
/// Argu:
///  pay- 付款单主表rowid
/// Return :
/// 0 -success
/// <0 -failure
ClassMethod SetPayAck2(pay As %String, user As %String, PayInfo As %String) As %String
{
  s appName=##class(web.DHCST.DHCPay).%GetParameter("AppName")
  q:##class(web.DHCST.Common.AppCommon).Lock(appName_pay)<0 -99
 
 
  //查看是否完成
  &sql(select pay_completed,pay_ack1,pay_ack2 into :comp,:ack1,:ack2 from dhc_pay where %ID=:pay)
  i SQLCODE'=0 d ..uLock(pay) q -1
  i comp'="Y" d ..uLock(pay) q -2  //未完成
  i ack2="Y" d ..uLock(pay) q -3  //已经确认
  
 s payMode=$p(PayInfo,"^",1)
 s checkDate=$p(PayInfo,"^",2)
 s checkNo=$p(PayInfo,"^",3)
 s checkAmt=+$p(PayInfo,"^",4)
 
 s ackdate=+$h
  s yes="Y"
  i checkDate'="" s checkDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(checkDate)
  &sql(update dhc_pay set pay_ack2=:yes,
  pay_date_ack2=:ackdate,
  pay_ssusr_ack2=:user,
  pay_mode=:payMode,
  pay_checkno=:checkNo,
  pay_checkdate=:checkDate,
  pay_checkamt=:checkAmt 
   where %ID=:pay)
  i SQLCODE'=0 d ..uLock(pay) q -4
  d ..uLock(pay)
  q 0
}

/// 解锁
ClassMethod uLock(pay As %String)
{
	s appName=##class(web.DHCST.DHCPay).%GetParameter("AppName")
 d ##class(web.DHCST.Common.AppCommon).UnLock(appName_pay)	
 q
}

/// Description:查询付款单的相关信息，用于一些验证
/// Creator:	hulihua
/// CreateDate:	2018-4-2
/// Table:      DHC_Pay
/// Input:		pay-付款单ID
/// Output:		
/// Return：	完成标志^采购确认标志^会计确认标志    
/// Debug:		w ##class(web.DHCST.DHCPayQuery).GetPayInfo
ClassMethod GetPayInfo(pay As %String)
{
	n (pay)
	s Ack1=$p(^DHCPAY(pay),"^",8) 
	s Ack2=$p(^DHCPAY(pay),"^",9) 
	s CompFlag=$p(^DHCPAY(pay),"^",19)
	s ReturnInfo=Ack1_"^"_Ack2_"^"_CompFlag
	q ReturnInfo
}

}
