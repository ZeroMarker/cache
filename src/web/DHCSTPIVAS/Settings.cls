Import sqluser

/// description: 配液中心配置参数
Class web.DHCSTPIVAS.Settings Extends %RegisteredObject
{

/// creator:	yunhaibao
/// createdate: 2018-03-02
/// description:各界面的初始化设置参数获取
/// input:		morePropStr(获取指定参数,^分割)
/// return:		json
/// w ##class(web.DHCSTPIVAS.Settings).GetAppProp(1,248,"Arrange","")
ClassMethod GetAppProp(userId, locId, appCode, morePropStr = "")
{
	s morePropList=$lfs(morePropStr,"^")
	s ssaCode="DHCSTINPIVA"
	&SQL(SELECT SSA_RowId into :ssaId FROM DHC_StkSysApp WHERE SSA_Code=:ssaCode)
	q:ssaId="" "{}"
	s hospId=$p($g(^CTLOC(+locId)),"^",22)
	s lgStrParam="^"_locId_"^"_userId_"^"_hospId
	s propTitle=""
	s propData=""
	s ssapId="",propNum=0
	f  s ssapId=$o(^DHCSSA(ssaId,"AP",ssapId)) q:ssapId=""  d
	.s ssapCode=$p(^DHCSSA(ssaId,"AP",ssapId),"^",1)
	.q:(ssapCode'[".")&&($lf(morePropList,ssapCode)=0)
	.i ssapCode["." d
	..s ssapAppCode=$p(ssapCode,".",1)
	..s ssapAppProp=$p(ssapCode,".",2)
	.e  d
	..s ssapAppCode=ssapCode
	..s ssapAppProp=ssapCode
	.q:(ssapCode[".")&&(ssapAppCode'=appCode)
	.
	.s propValue=##class(web.DHCST.Common.AppCommon).GetAppPropValue(ssaCode, ssapCode, lgStrParam)
	.i (ssapAppProp["Date")&&(propValue["t") s propValue=##class(web.DHCSTKUTIL).GetDate("","",propValue)
	.s propNum=propNum+1
	.s propTitle=$s(propNum=1:ssapAppProp,1:propTitle_"^"_ssapAppProp)
	.s propData=$s(propNum=1:propValue,1:propData_"^"_propValue)
	i (appCode="Arrange")&&(locId'="") d
	.s ps30Id=$o(^PIVAS(0,"LOCTYPENUMBER",locId,"I",30,""))
	.i ps30Id'="" s psSingle=$p($g(^PIVAS(ps30Id)),"^",8)
	.e  s psSingle=""
	.s propNum=propNum+1
	.s ssapAppProp="Single",propValue=psSingle
	.s propTitle=$s(propNum=1:ssapAppProp,1:propTitle_"^"_ssapAppProp)
	.s propData=$s(propNum=1:propValue,1:propData_"^"_propValue)
	q:propTitle="" "{}"
	q ##class(web.DHCSTJQUERYCOMMON).getJsonData(propTitle,propData)
}

/// creator:	yunhaibao
/// createdate: 2018-03-36
/// description:初始化显示医院等标题
/// return:		json
/// w ##class(web.DHCSTPIVAS.Settings).LogonData(101)
ClassMethod LogonData(locId)
{
	q:locId="" "{}"
	s locId=+locId
	s locDesc=##class(PHA.COM.Data.Base).LocDesc(locId)
	s hospId=$p($g(^CTLOC(locId)),"^",22)
	s hospDesc=##class(PHA.COM.Data.Base).HospDesc(hospId)
	s logonData=hospDesc_"^"_locDesc
	s logonTitle="HOSPDESC^CTLOCDESC"
	q ##class(web.DHCSTJQUERYCOMMON).getJsonData(logonTitle,logonData)
}

/// creator:	yunhaibao
/// createdate: 2018-05-17
/// description:单参数获取
/// return:		string
/// w ##class(web.DHCSTPIVAS.Settings).GetAppParamProp("",2,"OeAudit","AuditDays")
ClassMethod GetAppParamProp(userId, locId, appCode, appParam)
{
	s ssaCode="DHCSTINPIVA"
	&SQL(SELECT SSA_RowId into :ssaId FROM DHC_StkSysApp WHERE SSA_Code=:ssaCode)
	q:ssaId="" "{}"
	s hospId=$p($g(^CTLOC(+locId)),"^",22)
	s lgStrParam="^"_locId_"^"_userId_"^"_hospId
	s ssapId="",propNum=0
	i (appCode'="")&&(appParam'="") s appPropCode=appCode_"."_appParam
	e  s appPropCode=appParam
	s propValue=##class(web.DHCST.Common.AppCommon).GetAppPropValue(ssaCode,appPropCode , lgStrParam)
	q propValue
}

/// creator:	yunhaibao
/// createdate: 2018-07-17
/// description:是否需要护士审核参数
/// return:		Y/N
ClassMethod GetNeedNurseAudit(locId)
{
	q:locId="" "N"
	s phaLocId=$o(^DHCPL(0,"Loc",locId,""))
	q:phaLocId="" "N"
	s nurAudit=$p($g(^DHCPL(phaLocId)),"^",14)
	q $s(nurAudit'="Y":"N",1:"Y")
}

}
