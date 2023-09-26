Import sqluser

/// creator: 	yunhaibao
/// createdate: 2018-08-27
/// description:排班汇总
Class web.DHCSTPIVAS.SchedulSum Extends %RegisteredObject
{

/// description:  表格列
/// input:		  配液中心Id
/// w ##class(web.DHCSTPIVAS.SchedulSum).SchedulCols("555")
ClassMethod SchedulCols(inputStr)
{
	s retJson=""
	s LocId=$p(inputStr,"^",1)
	q:+LocId="" "[]"
	s scheDataStr=..SchedulStr(LocId)
	q:scheDataStr="" "[]"
	s title="field^title^width^halign^align"
	s scheLen=$l(scheDataStr,",")
	f sI=1:1:scheLen d
	.s scheStr=$p(scheDataStr,",",sI)
	.q:scheStr=""
	.s scheId="sche"_$p(scheStr,"^",1)
	.s scheDesc=$p(scheStr,"^",2)
	.s field=scheId_"^"_scheDesc_"^100^left^left"
	.i retJson="" s retJson=##class(web.DHCSTJQUERYCOMMON).getJsonData(title,field,"^")
	.e  d
	..s retJson=retJson_","_##class(web.DHCSTJQUERYCOMMON).getJsonData(title,field,"^")
	q "["_retJson_"]"
}

/// description:班次
/// w ##class(web.DHCSTPIVAS.SchedulSum).SchedulStr(101)
ClassMethod SchedulStr(locId)
{
	s scheDataStr=""
	s scheId=""
	f  s scheId=$o(^Code.PIVA.Schedul(scheId)) q:scheId=""  d
	.q:+scheId=0
	.s shceData=^Code.PIVA.Schedul(scheId)
	.s scheLocId=$p(shceData,"^",1)
	.q:locId'=scheLocId
	.s scheDesc=$p(shceData,"^",3)
	.s scheStr=scheId_"^"_scheDesc
	.i scheDataStr="" s scheDataStr=scheStr
	.e  s scheDataStr=scheDataStr_","_scheStr
	q scheDataStr
}

/// description: 查询排班班次汇总
/// w ##class(web.DHCSTPIVAS.SchedulSum).JsGetSchedulSum("248^2019-07-01")
ClassMethod JsGetSchedulSum(inputStr)
{
	s LocId=$p(inputStr,"^",1)
	s MonthDateHtml=$p(inputStr,"^",2)
	s MonthDate=$zdh(MonthDateHtml,3)	
	&SQL(SELECT PSA_RowId INTO :psaId FROM PIVA_ScheArrange WHERE PSA_Loc_Dr=:LocId AND PSA_Month=:MonthDate)
	q:psaId="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()	// 没排班
	// 获取需要显示的列
	s scheFieldStr=""
	s scheDataStr=..SchedulStr(LocId)
	s scheLen=$l(scheDataStr,",")
	s sI=""
	f sI=1:1:scheLen d
	.s scheStr=$p(scheDataStr,",",sI)
	.q:scheStr=""
	.s scheId="sche"_$p(scheStr,"^",1)
	.s scheFieldStr=$s(scheFieldStr="":scheId,1:scheFieldStr_"^"_scheId)
	s preLen=1
	s DataLen=preLen+scheLen
	s Title="scheDate^"_scheFieldStr
	s psaItm=""
	f  s psaItm=$o(^Busi.PIVA.ScheArrange(psaId,"I",psaItm)) q:psaItm=""  d
	.q:+psaItm=0
	.s psaItmId=psaId_"||"_psaItm
	.s psaItmData=^Busi.PIVA.ScheArrange(psaId,"I",psaItm)
	.s psaItmDate=$p(psaItmData,"^",1)
	.s psaItmDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(psaItmDate)
	.s psaItmScheId=$p(psaItmData,"^",3)
	.q:(+psaItmDate=0)||(+psaItmScheId=0)
	.s JsGetSchedulSumData(psaItmDate,psaItmScheId)=1+$g(JsGetSchedulSumData(psaItmDate,psaItmScheId))
	// 输出
	s count=0
	s psaItmDate=""
	f  s psaItmDate=$o(JsGetSchedulSumData(psaItmDate)) q:psaItmDate=""  d
	.q:+psaItmDate=0
	.s scheData=""
	.s sI=""
	.f sI=1:1:scheLen d
	..s scheStr=$p(scheDataStr,",",sI)
	..q:scheStr=""
	..s scheId=$p(scheStr,"^",1)
	..s scheSum=+$g(JsGetSchedulSumData(psaItmDate,scheId))
	..s scheData=$s(scheData="":scheSum,1:scheData_"^"_scheSum)
	.//s data=$p($zd(psaItmDate,3),"-",2,3)_"^"_scheData
	.s data=psaItmDate_"^"_scheData
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(9999)
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data,"^")
	i count>0   w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q ""
}

/// deccription:对应日期的班次人员
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.SchedulSum","SchedulUser","248^16/03/2020^sche6")
Query SchedulUser(inputStr = "") As websys.Query(ROWSPEC = "userId,userCode,userName")
{
}

ClassMethod SchedulUserExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.SchedulSum","SchedulUser")=inputStr
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s LocId=$p(inputStr,"^",1)
	s ScheDate=$p(inputStr,"^",2)
	s ScheField=$p(inputStr,"^",3)
	s ScheDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ScheDate)
	s ScheMonth=$p($zd(ScheDate,3),"-",1,2)_"-"_"01"
	s ScheMonth=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ScheMonth)
	s ScheId=+$replace(ScheField,"sche","")
	q:ScheId=0 $$$OK
	q:+LocId=0 $$$OK
	q:ScheMonth="" $$$OK
	s psaId=""
	&SQL(SELECT PSA_RowId INTO :psaId FROM PIVA_ScheArrange WHERE PSA_Loc_Dr=:LocId AND PSA_Month=:ScheMonth)
	q:psaId="" $$$OK
	s psaItm=""
	f  s psaItm=$o(^Busi.PIVA.ScheArrange(psaId,"I",psaItm)) q:psaItm=""  d
	.q:+psaItm=0
	.s psaItmId=psaId_"||"_psaItm
	.s psaItmData=^Busi.PIVA.ScheArrange(psaId,"I",psaItm)
	.q:($p(psaItmData,"^",1)'=ScheDate)
	.q:($p(psaItmData,"^",3)'=ScheId)
	.s userId=$p(psaItmData,"^",2)
	.s userObj=##class(User.SSUser).%OpenId(userId,0)
	.q:userObj=""
	.s userCode=userObj.SSUSRInitials
	.s userName=userObj.SSUSRName
	.s Data=$lb(userId,userCode,userName)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	q $$$OK
}

}
