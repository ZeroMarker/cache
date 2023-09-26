Class dbo.VBTQCMaterialLotTestCode [ ClassType = view, CompileAfter = (dbo.BTQCMaterialLotTestCode, dbo.BTTestCode, dbo.VBTQCMaterialLot), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTQC_MaterialLotTestCode, ViewQuery = { SELECT     dbo.BTQC_MaterialLotTestCode.RowID, dbo.BTQC_MaterialLotTestCode.MaterialLotDR, dbo.BTQC_MaterialLotTestCode.TestCodeDR, 
 dbo.BTQC_MaterialLotTestCode.LevelNo, dbo.BTQC_MaterialLotTestCode.Mean, dbo.BTQC_MaterialLotTestCode.SD, dbo.BTQC_MaterialLotTestCode.FloatMean, 
 dbo.BTQC_MaterialLotTestCode.FloatSD, dbo.BTQC_MaterialLotTestCode.TestMethod, dbo.BTQC_MaterialLotTestCode.CalcType, 
 dbo.BTQC_MaterialLotTestCode.Precision, dbo.BTQC_MaterialLotTestCode.AccSum, dbo.BTQC_MaterialLotTestCode.AccMean, 
 dbo.BTQC_MaterialLotTestCode.AccSD, dbo.BTQC_MaterialLotTestCode.Dilutions, dbo.BTQC_MaterialLotTestCode.Remark, 
 dbo.BTQC_MaterialLotTestCode.Sequence, dbo.BTQC_MaterialLotTestCode.Active, dbo.V_BTQC_MaterialLot.Code AS MaterialLotCode, 
 dbo.V_BTQC_MaterialLot.LotNo AS MaterialLotNo, dbo.V_BTQC_MaterialLot.MaterialCode, dbo.V_BTQC_MaterialLot.MaterialName, 
 dbo.BT_TestCode.Code AS TestCodeCode, dbo.BT_TestCode.CName AS TestCodeName,dbo.V_BTQC_MaterialLot.MaterialDR AS MaterialDR,dbo.BTQC_MaterialLevel.CName AS LevelNoName
 FROM         dbo.BTQC_MaterialLotTestCode LEFT OUTER JOIN
 dbo.V_BTQC_MaterialLot ON dbo.BTQC_MaterialLotTestCode.MaterialLotDR = dbo.V_BTQC_MaterialLot.RowID LEFT OUTER JOIN
 dbo.BT_TestCode ON dbo.BTQC_MaterialLotTestCode.TestCodeDR = dbo.BT_TestCode.RowID
 LEFT OUTER JOIN dbo.BTQC_MaterialLevel ON (dbo.V_BTQC_MaterialLot.MaterialDR = dbo.BTQC_MaterialLevel.MaterialDR and dbo.BTQC_MaterialLotTestCode.LevelNo = dbo.BTQC_MaterialLevel.LevelNo)
 } ]
{

}
