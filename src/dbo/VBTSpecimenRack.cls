Class dbo.VBTSpecimenRack [ ClassType = view, CompileAfter = (dbo.BTFridge, dbo.BTRackType, dbo.BTSpecimenGroup, dbo.BTSpecimenRack), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_SpecimenRack, ViewQuery = { SELECT     dbo.BT_SpecimenRack.RowID, dbo.BT_SpecimenRack.Code, dbo.BT_SpecimenRack.CName, dbo.BT_SpecimenRack.FridgeDR, dbo.BT_SpecimenRack.LayerNo, 
 dbo.BT_SpecimenRack.RackTypeDR, dbo.BT_SpecimenRack.SpecimenClassDR, dbo.BT_SpecimenRack.HoldDays, dbo.BT_SpecimenRack.WarningDays, 
 dbo.BT_SpecimenRack.Barcode, dbo.BT_SpecimenRack.Active, dbo.BT_Fridge.Code AS FridgeCode, dbo.BT_Fridge.CName AS FridgeName, 
 dbo.BT_RackType.Code AS RackTypeCode, dbo.BT_RackType.CName AS RackTypeName, dbo.BT_SpecimenGroup.Code AS SpecimenGroupCode, 
 dbo.BT_SpecimenGroup.CName AS SpecimenGroupName
 FROM         dbo.BT_SpecimenRack LEFT OUTER JOIN
 dbo.BT_Fridge ON dbo.BT_SpecimenRack.FridgeDR = dbo.BT_Fridge.RowID LEFT OUTER JOIN
 dbo.BT_RackType ON dbo.BT_SpecimenRack.RackTypeDR = dbo.BT_RackType.RowID LEFT OUTER JOIN
 dbo.BT_SpecimenGroup ON dbo.BT_SpecimenRack.SpecimenClassDR = dbo.BT_SpecimenGroup.RowID} ]
{

}
