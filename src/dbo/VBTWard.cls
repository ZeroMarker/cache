Class dbo.VBTWard [ ClassType = view, CompileAfter = (dbo.BTLocation, dbo.BTWard), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_Ward, ViewQuery = { SELECT     dbo.BT_Ward.RowID, dbo.BT_Ward.Code, dbo.BT_Ward.CName, dbo.BT_Ward.HISCode, dbo.BT_Ward.LocationDR, dbo.BT_Ward.Sequence, dbo.BT_Ward.Active, 
 dbo.BT_Location.Code AS LocationCode, dbo.BT_Location.CName AS LocationName
 FROM         dbo.BT_Ward LEFT OUTER JOIN
 dbo.BT_Location ON dbo.BT_Ward.LocationDR = dbo.BT_Location.RowID} ]
{

}
