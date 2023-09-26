Class dbo.VSYSGridConfigure [ ClassType = view, CompileAfter = (dbo.BTWorkGroupMachine, dbo.SYSGridConfigure, dbo.SYSMenu), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_SYS_GridConfigure, ViewQuery = { SELECT     dbo.SYS_GridConfigure.RowID, dbo.SYS_GridConfigure.MenuDR, dbo.SYS_GridConfigure.GridID, dbo.SYS_GridConfigure.WorkGroupMachineDR, 
 dbo.SYS_GridConfigure.Title, dbo.SYS_GridConfigure.Field, dbo.SYS_GridConfigure.Width, dbo.SYS_GridConfigure.Align, dbo.SYS_GridConfigure.Sortable, 
 dbo.SYS_GridConfigure.Resizeable, dbo.SYS_GridConfigure.Hidden, dbo.SYS_GridConfigure.Checkbox, dbo.SYS_Menu.Code AS MenuCode, 
 dbo.SYS_Menu.CName AS MenuName, dbo.BT_WorkGroupMachine.Code AS WorkGroupMachineCode, 
 dbo.BT_WorkGroupMachine.CName AS WorkGroupMachineName
 FROM         dbo.SYS_GridConfigure LEFT OUTER JOIN
 dbo.SYS_Menu ON dbo.SYS_GridConfigure.MenuDR = dbo.SYS_Menu.RowID LEFT OUTER JOIN
 dbo.BT_WorkGroupMachine ON dbo.SYS_GridConfigure.WorkGroupMachineDR = dbo.BT_WorkGroupMachine.RowID} ]
{

}
