/// 费用监控模块
Class web.DHCCPW.MR.CtrModuleFeeControl Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyang
/// CreatDate：   2011-02-14
/// Description:  通过Adm号查询费用列表
/// Input：       EpisodeID : 就诊号
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.CtrModuleFeeControl","QueryFee","73237")
Query QueryFee(argEpisodeID As %String) As %Query(ROWSPEC = "FeeType:%String:项目,Number:%String:费用,Percent:%String:百分比")
{
}

ClassMethod QueryFeeExecute(ByRef qHandle As %Binary, argEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set strCost=##class(web.DHCCPW.MR.Interface).GetAdmCateFees(argEpisodeID)
	Quit:strCost="" $$$OK
	
	Set CountCost=0
	For Cnt=1:1:$l(strCost,"&")
	{
		Set CountCost=CountCost+$p($p(strCost,"&",Cnt),"^",2)
	}
	
	For Cnt=1:1:$l(strCost,"&")
	{
		Set FeeType=$p($p(strCost,"&",Cnt),"^",1)
		Set FeeCost=$p($p(strCost,"&",Cnt),"^",2)
		Set CostRatio=$s(CountCost>0:$fn((FeeCost/CountCost)*100,"",2)_"%",1:"0.00%")
		//Continue:FeeCost="0.00"
		Continue:+FeeCost=0      //Add By NiuCaicai 2011-8-3 FixBug:118   实施管理--临床路径监控-住院费用-统计图下方图例说明显示不完全
		
		Set Data=$lb(FeeType,FeeCost,CostRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QueryFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryFeeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Add By LiYang 2011-04-07
/// 用来监控费用，一旦费用超过费用高限就触发
ClassMethod ProcessFeeControl(repid, PathWayID)
{
	n (repid,PathWayID)
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
	Set MRAdm=objPathWay.CPWMRADMDR
	Set EpisodeID=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
	Set strCost=##Class(web.DHCCPW.MR.Interface).GetAdmCateFee(EpisodeID)
	Set CountCost=+$p(strCost,"^",1)  //住院总费用
	s flag=0
	s minFee=$p(objPathWay.CPWPathwayDR.CPWCost,"-",1)
	s maxFee=$p(objPathWay.CPWPathwayDR.CPWCost,"-",2)
	s:maxFee<minFee maxFee=minFee                      //add by wuqk 2012-09-19
	i CountCost>maxFee  d
	.s flag=1
	.s ^CacheTemp("CPWControl",repid,"paadm",EpisodeID,"IsFired")=1
	.s ^CacheTemp("CPWControl",repid,"paadm",EpisodeID,"IsFired","Fee")="" //表明触发了费用监控项目，回头可以通过$d来判断触发了多少个类别的监控
	d objPathWay.%Close()
	k objPathWay
	q flag
}

}
