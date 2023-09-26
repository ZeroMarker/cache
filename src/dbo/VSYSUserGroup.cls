Class dbo.VSYSUserGroup [ ClassType = view, CompileAfter = (dbo.BTWorkGroup, dbo.SYSGroup, dbo.SYSUser, dbo.SYSUserGroup, dbo.BTWorkGroupMachine), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_SYS_UserGroup, ViewQuery = { SELECT     dbo.SYS_UserGroup.RowID, dbo.SYS_UserGroup.UserDR, dbo.SYS_UserGroup.WorkGroupDR, dbo.SYS_UserGroup.GroupDR,dbo.SYS_UserGroup.DefWGMachineDR, dbo.SYS_UserGroup.Sequence,dbo.SYS_UserGroup.WorkStatus,dbo.SYS_UserGroup.PostDR, 
 dbo.SYS_UserGroup.IsDefault, dbo.SYS_Group.Code AS GroupCode, dbo.SYS_Group.CName AS GroupName, dbo.SYS_User.Code AS UserCode, 
 dbo.SYS_User.CName AS UserName, dbo.BT_WorkGroup.Code AS WorkGroupCode, dbo.BT_WorkGroup.CName AS WorkGroupName,dbo.BT_WorkGroupMachine.Code As WGMCode,dbo.BT_WorkGroupMachine.CName As WGMCName,dbo.SYS_Post.CName as PostName
 FROM         dbo.SYS_UserGroup LEFT OUTER JOIN
 dbo.SYS_Group ON dbo.SYS_UserGroup.GroupDR = dbo.SYS_Group.RowID LEFT OUTER JOIN
 dbo.SYS_User ON dbo.SYS_UserGroup.UserDR = dbo.SYS_User.RowID LEFT OUTER JOIN
 dbo.BT_WorkGroup ON dbo.SYS_UserGroup.WorkGroupDR = dbo.BT_WorkGroup.RowID LEFT OUTER JOIN
 dbo.BT_WorkGroupMachine ON dbo.SYS_UserGroup.DefWGMachineDR = dbo.BT_WorkGroupMachine.RowID LEFT OUTER JOIN
 dbo.SYS_Post ON dbo.SYS_UserGroup.PostDR = dbo.SYS_Post.RowID} ]
{

}
