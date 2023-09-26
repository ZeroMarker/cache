Import sqluser

/// creator: 	yunhaibao
/// createdate: 2018-07-06
/// description:排班详情
Class web.DHCSTPIVAS.SchedulDetail Extends %RegisteredObject
{

/// description:  表格列
/// input:		 monthDateHtml(2018-01-01 格式)
/// w ##class(web.DHCSTPIVAS.SchedulDetail).SchedulCols("2018-01-01")
ClassMethod SchedulCols(monthDateHtml)
{
	s curDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(+$h)
	s retJson=""
	s title="field^title^width^halign^align"
	q:monthDateHtml="" "[]"
	s field="psaId^排班主表Id^250^left^left^true"
	s retJson=##class(web.DHCSTJQUERYCOMMON).getJsonData(title_"^hidden",field,"^")
	s field="userId^用户Id^250^left^left^true"
	s retJson=##class(web.DHCSTJQUERYCOMMON).getJsonData(title_"^hidden",field,"^")
	//人员姓名在js固定列
	//s field="userName^人员姓名^100^left^left"
	//s retJson=retJson_","_##class(web.DHCSTJQUERYCOMMON).getJsonData(title,field,"^")
	s monthIdStr=..MonthIdStr(monthDateHtml)
	s monLen=$l(monthIdStr,"^")
	f mI=1:1:monLen d
	.s monthId=$p(monthIdStr,"^",mI)
	.q:monthId=""
	.s monthDesc=""
	.i curDateHtml["-" d
	..s monthDesc=$e(monthId,2,5)_"-"_$e(monthId,6,7)_"-"_$e(monthId,8,9)
	.e  s monthDesc=$e(monthId,8,9)_"/"_$e(monthId,6,7)_"/"_$e(monthId,2,5)
	.s field=monthId_"^"_monthDesc_"^100^left^left"
	.s retJson=retJson_","_##class(web.DHCSTJQUERYCOMMON).getJsonData(title,field,"^")
	q "["_retJson_"]"
}

/// description: 月份列
/// input:		 monthDateHtml(2018-01-01 格式)
/// return:		 logical格式的
/// w ##class(web.DHCSTPIVAS.SchedulDetail).MonthIdStr("2018-01-01")
ClassMethod MonthIdStr(monthDateHtml)
{
	s curYear=+$p(monthDateHtml,"-",1)
	s curMonth=+$p(monthDateHtml,"-",2)
	i curMonth=12 s endMonth=1,endYear=curYear+1
	e  s endMonth=curMonth+1,endYear=curYear
	s endMonthHtml=endYear_"-"_endMonth_"-"_"01"
	s startDate=$zdh(monthDateHtml,3)
	s endDate=$zdh(endMonthHtml,3)-1
	s monStr="",month=""
	f month=startDate:1:endDate d
	.s monthId="m"_$zd(month,8)
	.s monStr=$s(monStr="":monthId,1:monStr_"^"_monthId)
	q monStr
}

/// description: 排班明细输出
/// w ##class(web.DHCSTPIVAS.SchedulDetail).JsGetSchedulDetail("248^2019-4-01")
ClassMethod JsGetSchedulDetail(inputStr)
{
	s LocId=$p(inputStr,"^",1)
	s MonthDateHtml=$p(inputStr,"^",2)
	s MonthDate=$zdh(MonthDateHtml,3)	
	&SQL(SELECT PSA_RowId INTO :psaId FROM PIVA_ScheArrange WHERE PSA_Loc_Dr=:LocId AND PSA_Month=:MonthDate)
	q:psaId="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s MonthIdStr=..MonthIdStr(MonthDateHtml)
	s MonthLen=$l(MonthIdStr,"^")
	s preLen=4
	s DataLen=preLen+MonthLen
	s Title="psaId^userId^userName^dutyDesc^"_MonthIdStr
	s psaItm=""
	f  s psaItm=$o(^Busi.PIVA.ScheArrange(psaId,"I",psaItm)) q:psaItm=""  d
	.q:+psaItm=0
	.s psaItmId=psaId_"||"_psaItm
	.s psaItmData=^Busi.PIVA.ScheArrange(psaId,"I",psaItm)
	.s psaItmDate=$p(psaItmData,"^",1)
	.s psaItmUserId=$p(psaItmData,"^",2)
	.s psaItmScheId=$p(psaItmData,"^",3)
	.q:(+psaItmDate=0)||(+psaItmUserId=0)||(+psaItmScheId=0)
	.s psaItmDutyCode=""
	.s pduId=$o(^Config.PIVA.DutyUser(0,"User",psaItmUserId,""))
	.i pduId'="" d
	..s dutyId=$p(^Config.PIVA.DutyUser(pduId),"^",1)
	..s psaItmDutyCode=$p($g(^Code.PIVA.Duty(+dutyId)),"^",2)
	.i psaItmDutyCode="" s psaItmDutyCode="99999"
	.// 顺序
	.s psaScheNum=$i(ScheItmDateI(psaItmUserId,psaItmDate))
	.s JsGetSchedulDetailData(psaItmDutyCode,psaItmUserId,psaScheNum,psaItmDate)=psaItmId
	b ///
	s count=0
	s psaItmDutyCode=""
	f  s psaItmDutyCode=$o(JsGetSchedulDetailData(psaItmDutyCode)) q:psaItmDutyCode=""  d
	.s psaItmUserId=""
	.f  s psaItmUserId=$o(JsGetSchedulDetailData(psaItmDutyCode,psaItmUserId)) q:psaItmUserId=""  d
	..q:+psaItmUserId=0
	..s userName=##class(User.SSUser).%OpenId(psaItmUserId,0).SSUSRName
	..s psaScheNum=""
	..f  s psaScheNum=$o(JsGetSchedulDetailData(psaItmDutyCode,psaItmUserId,psaScheNum)) q:psaScheNum=""  d
	...s data=""
	...s $p(data,"^",DataLen)="" // 固定数据长度
	...s $p(data,"^",1)=""
	...s $p(data,"^",2)=psaItmUserId
	...s $p(data,"^",3)=userName
	...s $p(data,"^",4)=psaItmDutyCode
	...s psaItmDate=""
	...f  s psaItmDate=$o(JsGetSchedulDetailData(psaItmDutyCode,psaItmUserId,psaScheNum,psaItmDate)) q:psaItmDate=""  d
	....s psaItmId=JsGetSchedulDetailData(psaItmDutyCode,psaItmUserId,psaScheNum,psaItmDate)
	....s psaItmScheId=$p(^Busi.PIVA.ScheArrange(+psaItmId,"I",$p(psaItmId,"||",2)),"^",3)
	....s schedulDesc=$p($g(^Code.PIVA.Schedul(+psaItmScheId)),"^",3)
	....q:schedulDesc=""
	....s monthDay=+$p($zd(psaItmDate,3),"-",3)
	....s scheNum=preLen+monthDay
	....s $p(data,"^",scheNum)=psaItmId_"!!"_psaItmScheId_"!!"_schedulDesc
	....s $p(data,"^",1)=+psaItmId
	...s count=count+1
	...i count=1 d
	....w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(9999)
	....w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data,"^")
	...e  d
	....w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data,"^")
	i count>0   w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q ""
}

}
