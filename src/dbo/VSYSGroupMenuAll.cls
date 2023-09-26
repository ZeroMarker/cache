Class dbo.VSYSGroupMenuAll [ ClassType = view, CompileAfter = (dbo.SYSGroup, dbo.SYSGroupMenu, dbo.SYSMenu), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_SYS_GroupMenuAll, ViewQuery = { SELECT     dbo.SYS_GroupMenu.RowID, dbo.SYS_GroupMenu.GroupDR, dbo.SYS_GroupMenu.MenuDR, dbo.SYS_Menu.Code AS MenuCode, 
 dbo.SYS_Menu.CName AS MenuName, dbo.SYS_Group.Code AS GroupCode, dbo.SYS_Group.CName AS GroupName, dbo.SYS_Group.MainType, 
 dbo.SYS_Group.SysType, dbo.SYS_Group.Sequence AS GroupSequence,dbo.SYS_Form.Path As URL, dbo.SYS_Menu.ParentID, dbo.SYS_Menu.LevelNo, 
 dbo.SYS_Menu.Description, dbo.SYS_Menu.Icon, dbo.SYS_Menu.Sequence AS MenuSequence, dbo.SYS_Menu.Active AS MenuActive, 
 dbo.SYS_Group.Active AS GroupActive
 FROM         dbo.SYS_GroupMenu LEFT OUTER JOIN
 dbo.SYS_Group ON dbo.SYS_GroupMenu.GroupDR = dbo.SYS_Group.RowID LEFT OUTER  JOIN
 dbo.SYS_Menu ON dbo.SYS_GroupMenu.MenuDR = dbo.SYS_Menu.RowID LEFT OUTER JOIN
 dbo.SYS_Form ON dbo.SYS_Menu.URL = dbo.SYS_Form.RowID} ]
{

}
