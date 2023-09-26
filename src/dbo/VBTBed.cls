Class dbo.VBTBed [ ClassType = view, CompileAfter = (dbo.BTBed, dbo.BTWard), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_Bed, ViewQuery = { SELECT     dbo.BT_Bed.RowID, dbo.BT_Bed.Code, dbo.BT_Bed.CName, dbo.BT_Bed.HISCode, dbo.BT_Bed.WardDR, dbo.BT_Bed.Sequence, dbo.BT_Bed.Active, 
 dbo.BT_Ward.Code AS WardCode, dbo.BT_Ward.CName AS WardName
 FROM         dbo.BT_Bed LEFT OUTER JOIN
 dbo.BT_Ward ON dbo.BT_Bed.WardDR = dbo.BT_Ward.RowID} ]
{

}
