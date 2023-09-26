Class dbo.VSYSMenu [ ClassType = view, CompileAfter = (dbo.SYSForm, dbo.SYSMenu), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_SYS_Menu, ViewQuery = { SELECT     dbo.SYS_Menu.RowID, dbo.SYS_Menu.Code, 
 dbo.SYS_Menu.CName,dbo.SYS_Form.Path As URL, dbo.SYS_Menu.ParentID, dbo.SYS_Menu.LevelNo, 
 dbo.SYS_Menu.Description, dbo.SYS_Menu.Icon, dbo.SYS_Menu.Sequence, dbo.SYS_Menu.Active
 FROM dbo.SYS_Menu LEFT OUTER JOIN
 dbo.SYS_Form ON dbo.SYS_Menu.URL = dbo.SYS_Form.RowID} ]
{

}
