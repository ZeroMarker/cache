Class dbo.VBTQCMaterialLot [ ClassType = view, CompileAfter = (dbo.BTQCMaterial, dbo.BTQCMaterialLot), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTQC_MaterialLot, ViewQuery = { SELECT     dbo.BTQC_MaterialLot.RowID, dbo.BTQC_MaterialLot.Code, dbo.BTQC_MaterialLot.MaterialDR, dbo.BTQC_MaterialLot.LotNo, dbo.BTQC_MaterialLot.StartDate, 
 dbo.BTQC_MaterialLot.EndDate, dbo.BTQC_MaterialLot.ProductDate, dbo.BTQC_MaterialLot.ExpiryDate, dbo.BTQC_MaterialLot.Manufacturer, 
 dbo.BTQC_MaterialLot.CurrentLot, dbo.BTQC_MaterialLot.Remark, dbo.BTQC_MaterialLot.Sequence, dbo.BTQC_MaterialLot.Active, 
 dbo.BTQC_Material.Code AS MaterialCode, dbo.BTQC_Material.CName AS MaterialName
 FROM         dbo.BTQC_MaterialLot LEFT OUTER JOIN
 dbo.BTQC_Material ON dbo.BTQC_MaterialLot.MaterialDR = dbo.BTQC_Material.RowID} ]
{

}
