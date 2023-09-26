Import sqluser

/// 更新请求的频次的任务
/// 按照台账的次数计数
/// 2016-04-15
/// XuChao
Class web.DHCSTMHUI.DHCItmLocReqFre Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// d ##class(web.DHCSTMHUI.DHCItmLocReqFre).UpReqFre()
ClassMethod UpReqFre() As %String
{
	
	//统计的日期范围
	s d=+$h-7
	//统计转移入库
	s Type="K"  
	s loc=""
	f  s loc=$O(^DHCINTR(0,"LOCTYPEDATE",loc)) q:loc=""  d
	.&sql(update DHC_IncItmLoc set INCIL_ReqFre=0 where INCIL_INCIL_DR->INCIL_CTLOC_DR=:loc)
	.f  s d=$O(^DHCINTR(0,"LOCTYPEDATE",loc,Type,d)) q:d=""  d
	..s intr=0
	..f  s intr=$O(^DHCINTR(0,"LOCTYPEDATE",loc,Type,d,intr)) q:intr=""  d
	...s inci=$P(^DHCINTR(intr),"^",15)
	...&sql(update DHC_IncItmLoc set INCIL_ReqFre=(INCIL_ReqFre+1) where INCIL_INCIL_DR->INCIL_CTLOC_DR=:loc and INCIL_INCIL_DR->INCIL_INCI_ParRef=:inci)
	q 0
}

}
