Import sqluser

/// Description:移动药房护士审核表操作相关
/// Creator:    hulihua
/// CreateDate: 2017-04-20
/// Table:      DHC_PHACollected
Class web.DHCINPHA.MTNurseCheck.SqlDbPhacAuitCheck Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:更新发药主表护士签收相关信息
/// Creator:	hulihua
/// CreateDate:	2017-04-20
/// Table:      DHC_PHACollected
/// Input:		发药主表ID^审核标志^审核人^审核时间^审核时间
/// Output:		
/// Return：	0-成功，空-失败 
/// w ##class(web.DHCINPHA.MTNurseCheck.SqlDbPhacAuitCheck).UpdateAuditInfo("1")
ClassMethod UpdateAuditInfo(listData As %String) As %String
{
	n (listData)
	s phac=$p(listData,"^",1)
	s auditflag=$p(listData,"^",2)
	s auditdate=$p(listData,"^",3)
	s audittime=$p(listData,"^",4)
	s audituser=$p(listData,"^",5)
	s:audituser="" audituser=$p(^DHCPHAC(phac),"^",24)
	l +^DHCINPHALOCK("UpdateAuditInfo"_phac):2 e  q ""   ;加锁
	s tmpauditflag=$p(^DHCPHAC(phac),"^",25)
	i tmpauditflag="Y" l -^DHCINPHALOCK("UpdateAuditInfo"_phac) q 0
	s err=0
	&sql(UPDATE DHC_PHACollected SET DHC_PHAAuditFlag=:auditflag, DHC_PHAAuditDate=:auditdate,  
	DHC_PHAAuditTime=:audittime,DHC_PHAAuditor=:audituser WHERE DHC_PHACollect_RowID=:phac)
	i SQLCODE'=0  d
 	.s ret=$$SqlErrorRecord^DHCSTERROR("UpdateAuditInfo:DHC_PHACollected",phac,SQLCODE_":"_%msg)
 	.s err=-1
 	l -^DHCINPHALOCK("UpdateAuditInfo"_phac)
 	q:err'=0 ""
 	q:SQLCODE ""
 	q err
}

}
