Class dbo.VSYSUserLog [ ClassType = view, CompileAfter = (dbo.BTWorkGroup, dbo.SYSUser, dbo.SYSUserLog), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_SYS_UserLog, ViewQuery = { SELECT     dbo.SYS_UserLog.RowID, dbo.SYS_UserLog.UserDR, dbo.SYS_UserLog.AddDate, dbo.SYS_UserLog.AddTime, dbo.SYS_UserLog.SysCode, 
 dbo.SYS_UserLog.Site, dbo.SYS_UserLog.IPAddress, dbo.SYS_UserLog.LogType, dbo.SYS_UserLog.WorkGroupDR, dbo.SYS_UserLog.Remark, 
 dbo.SYS_User.Code AS UserCode, dbo.SYS_User.CName AS UserName, dbo.BT_WorkGroup.Code AS WorkGroupCode, dbo.BT_WorkGroup.CName AS WorkGroupName
 FROM         dbo.SYS_UserLog LEFT OUTER JOIN
 dbo.BT_WorkGroup ON dbo.SYS_UserLog.WorkGroupDR = dbo.BT_WorkGroup.RowID LEFT OUTER JOIN
 dbo.SYS_User ON dbo.SYS_UserLog.UserDR = dbo.SYS_User.RowID} ]
{

}
