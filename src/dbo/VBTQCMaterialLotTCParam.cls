Class dbo.VBTQCMaterialLotTCParam [ ClassType = view, CompileAfter = (dbo.BTQCMaterialLotTCParam, dbo.BTTestCode, dbo.VBTQCMaterialLot), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTQC_MaterialLotTCParam, ViewQuery = { SELECT     dbo.BTQC_MaterialLotTCParam.RowID, dbo.BTQC_MaterialLotTCParam.MaterialLotDR, dbo.BTQC_MaterialLotTCParam.TestCodeDR, 
 dbo.BTQC_MaterialLotTCParam.LevelNo, dbo.BTQC_MaterialLotTCParam.ClosingDate, dbo.BTQC_MaterialLotTCParam.LotNo, dbo.BTQC_MaterialLotTCParam.Mean, 
 dbo.BTQC_MaterialLotTCParam.SD, dbo.BTQC_MaterialLotTCParam.FloatMean, dbo.BTQC_MaterialLotTCParam.FloatSD, dbo.BTQC_MaterialLotTCParam.TestMethod, 
 dbo.BTQC_MaterialLotTCParam.Precision, dbo.BTQC_MaterialLotTCParam.AccSum, dbo.BTQC_MaterialLotTCParam.AccMean, dbo.BTQC_MaterialLotTCParam.AccSD, 
 dbo.BTQC_MaterialLotTCParam.Dilutions, dbo.BTQC_MaterialLotTCParam.Remark, dbo.V_BTQC_MaterialLot.Code AS MaterialLotCode, 
 dbo.V_BTQC_MaterialLot.LotNo AS MaterialLotNo, dbo.V_BTQC_MaterialLot.MaterialCode, dbo.V_BTQC_MaterialLot.MaterialName, 
 dbo.BT_TestCode.Code AS TestCodeCode, dbo.BT_TestCode.CName AS TestCodeName,dbo.V_BTQC_MaterialLot.MaterialDR AS MaterialDR,dbo.BTQC_MaterialLevel.CName AS LevelNoName
 FROM         dbo.BTQC_MaterialLotTCParam LEFT OUTER JOIN
 dbo.V_BTQC_MaterialLot ON dbo.BTQC_MaterialLotTCParam.MaterialLotDR = dbo.V_BTQC_MaterialLot.RowID LEFT OUTER JOIN
 dbo.BT_TestCode ON dbo.BTQC_MaterialLotTCParam.TestCodeDR = dbo.BT_TestCode.RowID
 LEFT OUTER JOIN dbo.BTQC_MaterialLevel ON (dbo.V_BTQC_MaterialLot.MaterialDR = dbo.BTQC_MaterialLevel.MaterialDR and dbo.BTQC_MaterialLotTCParam.LevelNo = dbo.BTQC_MaterialLevel.LevelNo)} ]
{

}
