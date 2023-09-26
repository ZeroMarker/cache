Class web.DHCEQ.Process.DHCEQVisualizationTocken Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by zx 2017-05-30  BUG ZX0049
/// 大屏系统登录session值保存处理
/// w ##Class(web.DHCEQ.Process.DHCEQVisualizationTocken).SaveSession()
ClassMethod SaveSession(UserID, LocID, GroupID)
{
	s %session.Data("LOGON.EQDPUSERID")=UserID
	s %session.Data("LOGON.EQDPCTLOCID")=LocID
	s %session.Data("LOGON.EQDPGROUPID")=GroupID
	s %session.Data("LOGON.TOKEN")="LocID"_LocID_"UserID"_UserID_"GroupID"_GroupID
	
	q "0"
}

/// add by zx 2017-05-30
/// 大屏系统ajax调用验证处理
/// 返回值为0时表示有权限 不为0时表示没有权限
ClassMethod CheckToken(UserID, LocID, GroupID)
{
	n ReturnFlag,curToken
	s ReturnFlag="0"
	i 0'=##Class(web.DHCEQ.Process.DHCEQVisualization).CheckFunction(UserID, LocID, GroupID, "2") s ReturnFlag="1" //菜单权限判断
	i ReturnFlag="1" q ReturnFlag
	s curToken=%session.Get("LOGON.TOKEN")
	i ("LocID"_LocID_"UserID"_UserID_"GroupID"_GroupID)'=curToken s ReturnFlag="1"
	
	q ReturnFlag
}

}
