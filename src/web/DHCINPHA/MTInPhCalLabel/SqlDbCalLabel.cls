Import sqluser

/// Description:撤销封箱签表操作相关
/// Creator:    hulihua
/// CreateDate: 2017-04-26
/// Table:      DHC_PHBox、DHC_PHDraw、DHC_InPhReq
Class web.DHCINPHA.MTInPhCalLabel.SqlDbCalLabel Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:更新发药主表护士签收相关信息
/// Creator:	hulihua
/// CreateDate:	2017-04-26
/// Table:      DHC_PHBox、DHC_PHDraw、DHC_InPhReq
/// Input:		物流箱ID#备药主表ID串#请领单主表ID串
/// Output:		
/// Return：	0-成功，非0-失败 
/// w ##class(web.DHCINPHA.MTInPhCalLabel.SqlDbCalLabel).HandleCalPhboxInfo("3##")
ClassMethod HandleCalPhboxInfo(listData As %String) As %String
{
	n (listData)
	s phboxid=$p(listData,"#",1)
	s phawidstr=$p(listData,"#",2)
	s inpheqstr=$p(listData,"#",3)
	l +^DHCINPHALOCK("HandleCalPhboxInfo"_phboxid):2 e  q ""   ;加锁
	s PhbNoUseFlag=$p(^DHCPHBOX(phboxid),"^",14)
	i PhbNoUseFlag="Y" d Unlock q 0
	s NoUseFlag="Y"
	tstart
	s err=0
	s $ZT="Error^DHCSTERROR"
	&sql(UPDATE DHC_PHBox SET PHB_NoUseFlag=:NoUseFlag WHERE PHB_RowID=:phboxid)
	i SQLCODE'=0  d
 	.s ret=$$SqlErrorRecord^DHCSTERROR("HandleCalPhboxInfo:DHC_PHBox",phboxid,SQLCODE_":"_%msg)
 	.s err=-5
 	i err'=0 trollback  d Unlock
	q:err'=0 err
	s phawlen=$l(phawidstr,"^")
	s statue="40"
	f j=1:1:phawlen  q:err'=0  d
	.s phawid=$p(phawidstr,"^",j)
	.q:phawid=""
	.&sql(UPDATE DHC_PHDraw SET PHDW_Status=:statue,PHDW_PHBox_Dr=null WHERE PHDW_RowID=:phawid)
	.i SQLCODE'=0  d
 	..s ret=$$SqlErrorRecord^DHCSTERROR("HandleCalPhboxInfo:DHC_PHDraw",phawid,SQLCODE_":"_%msg)
 	..s err=-6
 	.
 	i err'=0 trollback  d Unlock
	q:err'=0 err
	s inphreqlen=$l(inpheqstr,"^")
	f i=1:1:inphreqlen  q:err'=0  d
	.s inphreq=$p(inpheqstr,"^",i)
	.q:inphreq=""
	.&sql(UPDATE DHC_InPhReq SET PHR_Status=:statue WHERE PHR_RowID=:inphreq)
	.i SQLCODE'=0  d
 	..s ret=$$SqlErrorRecord^DHCSTERROR("HandleCalPhboxInfo:DHC_InPhReq",inphreq,SQLCODE_":"_%msg)
 	..s err=-7
 	.
 	i err'=0 trollback  d Unlock
	q:err'=0 err
	tcommit
	d Unlock
	q err
 	
Unlock		;去锁
	l -^DHCINPHALOCK("HandleCalPhboxInfo"_phboxid) 
	q
}

}
