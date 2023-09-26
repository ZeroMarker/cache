Class dbo.VSYSGroupMenu [ ClassType = view, CompileAfter = (dbo.SYSGroup, dbo.SYSGroupMenu, dbo.SYSMenu), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_SYS_GroupMenu, ViewQuery = { SELECT     dbo.SYS_GroupMenu.RowID, dbo.SYS_GroupMenu.GroupDR, dbo.SYS_GroupMenu.MenuDR, dbo.SYS_Menu.Code AS MenuCode, 
 dbo.SYS_Menu.CName AS MenuName, dbo.SYS_Group.Code AS GroupCode, dbo.SYS_Group.CName AS GroupName
 FROM         dbo.SYS_GroupMenu LEFT OUTER JOIN
 dbo.SYS_Group ON dbo.SYS_GroupMenu.GroupDR = dbo.SYS_Group.RowID LEFT OUTER JOIN
 dbo.SYS_Menu ON dbo.SYS_GroupMenu.MenuDR = dbo.SYS_Menu.RowID} ]
{

}
