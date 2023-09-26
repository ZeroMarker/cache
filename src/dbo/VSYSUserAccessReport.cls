Class dbo.VSYSUserAccessReport [ ClassType = view, CompileAfter = (dbo.BTWorkGroup, dbo.SYSUser, dbo.SYSUserAccessReport), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_SYS_UserAccessReport, ViewQuery = { SELECT     dbo.SYS_UserAccessReport.RowID, dbo.SYS_UserAccessReport.UserDR, dbo.SYS_UserAccessReport.WorkGroupDR, dbo.SYS_UserAccessReport.Active, 
 dbo.SYS_User.Code AS UserCode, dbo.SYS_User.CName AS UserName, dbo.BT_WorkGroup.Code AS WorkGroupCode, 
 dbo.BT_WorkGroup.CName AS WorkGroupName
 FROM         dbo.SYS_UserAccessReport LEFT OUTER JOIN
 dbo.BT_WorkGroup ON dbo.SYS_UserAccessReport.WorkGroupDR = dbo.BT_WorkGroup.RowID LEFT OUTER JOIN
 dbo.SYS_User ON dbo.SYS_UserAccessReport.UserDR = dbo.SYS_User.RowID} ]
{

}
