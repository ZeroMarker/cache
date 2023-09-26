Class dbo.VSYSGroupMenuFunction [ ClassType = view, CompileAfter = (dbo.SYSFunction, dbo.SYSGroupMenuFunction, dbo.VSYSGroupMenu), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_SYS_GroupMenuFunction, ViewQuery = { SELECT     dbo.SYS_GroupMenuFunction.RowID, dbo.SYS_GroupMenuFunction.GroupMenuDR, dbo.SYS_GroupMenuFunction.FunctionDR, dbo.V_SYS_GroupMenu.GroupDR, 
 dbo.V_SYS_GroupMenu.MenuDR, dbo.V_SYS_GroupMenu.MenuCode, dbo.V_SYS_GroupMenu.MenuName, dbo.V_SYS_GroupMenu.GroupCode, 
 dbo.V_SYS_GroupMenu.GroupName, dbo.SYS_Function.Code AS FunctionCode, dbo.SYS_Function.CName AS FunctionName
 FROM         dbo.SYS_GroupMenuFunction LEFT OUTER JOIN
 dbo.V_SYS_GroupMenu ON dbo.SYS_GroupMenuFunction.GroupMenuDR = dbo.V_SYS_GroupMenu.RowID LEFT OUTER JOIN
 dbo.SYS_Function ON dbo.SYS_GroupMenuFunction.FunctionDR = dbo.SYS_Function.RowID} ]
{

}
