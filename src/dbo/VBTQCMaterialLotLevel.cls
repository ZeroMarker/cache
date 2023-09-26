Class dbo.VBTQCMaterialLotLevel [ ClassType = view, CompileAfter = (dbo.BTQCMaterialLotLevel, dbo.VBTQCMaterialLot), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTQC_MaterialLotLevel, ViewQuery = { SELECT     dbo.BTQC_MaterialLotLevel.RowID, dbo.BTQC_MaterialLotLevel.MaterialLotDR, dbo.BTQC_MaterialLotLevel.LevelNo, dbo.BTQC_MaterialLotLevel.LotNo, 
 dbo.V_BTQC_MaterialLot.Code AS MaterialLotCode, dbo.V_BTQC_MaterialLot.LotNo AS MaterialLotNo, dbo.V_BTQC_MaterialLot.MaterialCode, 
 dbo.V_BTQC_MaterialLot.MaterialName, dbo.V_BTQC_MaterialLot.MaterialDR,dbo.BTQC_MaterialLevel.CName AS LevelNoName
 FROM         dbo.BTQC_MaterialLotLevel LEFT OUTER JOIN
 dbo.V_BTQC_MaterialLot ON dbo.BTQC_MaterialLotLevel.MaterialLotDR = dbo.V_BTQC_MaterialLot.RowID
 LEFT OUTER JOIN dbo.BTQC_MaterialLevel ON (dbo.V_BTQC_MaterialLot.MaterialDR = dbo.BTQC_MaterialLevel.MaterialDR and dbo.BTQC_MaterialLotLevel.LevelNo = dbo.BTQC_MaterialLevel.LevelNo)
 } ]
{

}
