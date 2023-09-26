/// 用于监控住院天数等杂项信息的模块
/// 创建日期：2011-04-11
/// 创建者：李阳
Class web.DHCCPW.MR.CtrModuleExtraControl Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod ProcessDaysControl(repid, PathWayID)
{
		n (repid,PathWayID)
		set summary=##class(web.DHCCPW.MR.CtrModulePatSummary).GetPathWaySummary(PathWayID)
		Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
		Set MRAdm=objPathWay.CPWMRADMDR
		Set EpisodeID=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm) 
		set minDay=+$p(objPathWay.CPWPathwayDR.CPWDays,"-",1)
		set maxDay=+$p(objPathWay.CPWPathwayDR.CPWDays,"-",2)  // "^" to "-"
		set:maxDay<minDay maxDay=minDay                      //add by wuqk 2012-09-19
		set tmpDay=$p(summary,"^",3)
		s flag=0
		i tmpDay>maxDay  d
		.s flag=1
		.s ^CacheTemp("CPWControl",repid,"paadm",EpisodeID,"IsFired")=1
		.s ^CacheTemp("CPWControl",repid,"paadm",EpisodeID,"IsFired","Days")="" //表明触发了住院日监控项目，回头可以通过$d来判断触发了多少个类别的监控
		d objPathWay.%Close()
		k objPathWay
		q flag
}

}
