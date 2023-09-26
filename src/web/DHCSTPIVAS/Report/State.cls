/// Description:配液状态统计
/// Creator:	yunhaibao
/// CreateDate: 2017-12-13
Class web.DHCSTPIVAS.Report.State Extends %RegisteredObject
{

/// Description: 配液状态统计,日期范围内各流程的合计数
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Report.State","PIVAStat","2018-03-14","2018-03-15","101")
Query PIVAStat(startDate, endDate, pivaLoc) As websys.Query(ROWSPEC = "wardDesc,calcuCode,calcuDesc,batNo,batNoCnt") [ SqlProc ]
{
}

ClassMethod PIVAStatExecute(ByRef qHandle As %Binary, startDate, endDate, pivaLoc) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:(startDate="")||(endDate="")||(pivaLoc="") $$$OK
	s startDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
	s endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
	k PIVAStatArr // 排序用,组数,袋数
	s cacuDate=""
	f cacuDate=startDate:1:endDate d
	.s psId=""
	.f  s psId=$o(^PIVA(0,"DATELOC",pivaLoc,cacuDate,psId)) q:psId=""  d
	..s psDesc=$p(^PIVAS(psId),"^",2)
	..s pogId=""
	..f  s pogId=$o(^PIVA(0,"DATELOC",pivaLoc,cacuDate,psId,pogId)) q:pogId=""  d
	...q:+pogId=0
	...s batNo=$p(^PIVA(pogId),"^",3)_"批"
	...s mDsp=$p(^PIVA(pogId),"^",1)
	...q:$p($g(^PAADM(+$p(^DHCOEDISQTY(mDsp),"^",26))), "^", 2)'="I"
	...s wardLocId=$p(^DHCOEDISQTY(mDsp),"^",22)
	...q:wardLocId="" 
	...s wardDesc=$p(^CTLOC(wardLocId),"^",2)
	...s PIVAStatArr(wardDesc,batNo,psDesc)=$g(PIVAStatArr(wardDesc,batNo,psDesc))+1
	s pivaStateStr=..GetPivaState(pivaLoc)
	s pivaStateLen=$l(pivaStateStr,"^")
	s wardDesc=""
	f  s wardDesc=$o(PIVAStatArr(wardDesc)) q:wardDesc=""  d
	.s batNo=""
	.f  s batNo=$o(PIVAStatArr(wardDesc,batNo)) q:batNo=""  d
	..s i=0
	..f i=1:1:pivaStateLen d
	...s pivaState=$p(pivaStateStr,"^",i)
	...s pivaStateNumber=$p(pivaState,":",1)
	...i pivaStateNumber'="" s pivaStateNumber=1000+pivaStateNumber
	...s pivaStateName=$p(pivaState,":",2)
	...s batNoCnt=+$g(PIVAStatArr(wardDesc,batNo,pivaStateName))
	...s ^CacheTemp(repid,ind)=$lb(wardDesc,pivaStateNumber,pivaStateName,batNo,batNoCnt)  
	...s ind=ind+1
	q $$$OK
}

/// Description: 获取配液中心在用的流程
/// w ##class(web.DHCSTPIVAS.Report.State).GetPivaState(250)
ClassMethod GetPivaState(pivaLoc)
{
	s pivaStateStr=""
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT PS_Number as psNumber,Ps_Name as psName FROM PIVA_State WHERE PS_Loc_Dr="_pivaLoc_" AND PS_Flag='Y' AND PS_TypeFlag='I' ORDER BY PS_Number"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
	    s pivaState=result.Get("psNumber")_":"_result.Get("psName")
	    s pivaStateStr=$s(pivaStateStr="":pivaState,1:pivaStateStr_"^"_pivaState)
    }
    d result.Close()
    q pivaStateStr
}

/// description: 配液状态统计
/// 安贞,此为按打签日期,统计当前所处状态的合计
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Report.State","PIVAStatAnZhen","2018-01-14","2018-01-15","250")
Query PIVAStatAnZhen(startDate, endDate, pivaLoc) As websys.Query(ROWSPEC = "wardDesc,calcuCode,calcuDesc,batNo,batNoCnt") [ SqlProc ]
{
}

ClassMethod PIVAStatAnZhenExecute(ByRef qHandle As %Binary, startDate, endDate, pivaLoc) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:(startDate="")||(endDate="")||(pivaLoc="") $$$OK
	s startDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
	s endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
	k PIVAStatArr // 排序用,组数,袋数
	s cacuDate=""
	f cacuDate=startDate:1:endDate d
	.s cacuDateHtml=$zd(cacuDate,3)
	.s phacId=""
	.f  s phacId=$o(^DHCPHAC(0,"PHP",pivaLoc,"DATE",cacuDate,phacId)) q:phacId=""  d
	..S wardId=$p(^DHCPHAC(phacId),"^",4)
	..q:wardId=""
	..s wardDesc=$p(^PAWARD(wardId),"^",2)
	..s pogId=""
	..f  s pogId=$o(^PIVA(0,"PHAC",phacId,pogId)) q:pogId=""  d
	...s batNo=$p(^PIVA(pogId),"^",3)_"批"
	...s mDsp=$p(^PIVA(pogId),"^",1)
	...s mOeori=$P(^DHCOEDISQTY(mDsp),"^",3)
	...s pogStateDr=$p(^PIVA(pogId),"^",6)
	...s pogStateDesc=$p(^PIVAS(pogStateDr),"^",2)
	...s PIVAStatArr(wardDesc,batNo,pogStateDesc)=$g(PIVAStatArr(wardDesc,batNo,pogStateDesc))+1
	s pivaStateStr=##class(web.DHCSTPIVAREPORT).GetPivaState(pivaLoc)
	s pivaStateLen=$l(pivaStateStr,"^")
	s wardDesc=""
	f  s wardDesc=$o(PIVAStatArr(wardDesc)) q:wardDesc=""  d
	.s batNo=""
	.f  s batNo=$o(PIVAStatArr(wardDesc,batNo)) q:batNo=""  d
	..s i=0
	..f i=1:1:pivaStateLen d
	...s pivaState=$p(pivaStateStr,"^",i)
	...s pivaStateNumber=$p(pivaState,":",1)
	...s pivaStateName=$p(pivaState,":",2)
	...s batNoCnt=+$g(PIVAStatArr(wardDesc,batNo,pivaStateName))
	...s ^CacheTemp(repid,ind)=$lb(wardDesc,pivaStateNumber,pivaStateName,batNo,batNoCnt)  
	...s ind=ind+1
	q $$$OK
}

}
