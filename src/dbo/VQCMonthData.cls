Class dbo.VQCMonthData [ ClassType = view, CompileAfter = (dbo.BTQCMaterialLot, dbo.BTTestCode, dbo.QCMonthData), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_QC_MonthData, ViewQuery = { SELECT     dbo.QC_MonthData.RowID, dbo.QC_MonthData.MaterialLotDR, dbo.QC_MonthData.TestCodeDR, dbo.QC_MonthData.LevelNo, dbo.QC_MonthData.Year, 
 dbo.QC_MonthData.Month, dbo.QC_MonthData.CurSum, dbo.QC_MonthData.CurMean, dbo.QC_MonthData.CurSD, dbo.QC_MonthData.AccSum, 
 dbo.QC_MonthData.AccMean, dbo.QC_MonthData.AccSD, dbo.QC_MonthData.CurMax, dbo.QC_MonthData.CurMin, dbo.QC_MonthData.AccMax, 
 dbo.QC_MonthData.AccMin, dbo.BTQC_MaterialLot.Code AS MaterialLotCode, dbo.BTQC_MaterialLot.LotNo AS MaterialLotLotNo, 
 dbo.BT_TestCode.Code AS TestCodeCode, dbo.BT_TestCode.CName AS TestCodeName
 FROM         dbo.QC_MonthData LEFT OUTER JOIN
 dbo.BTQC_MaterialLot ON dbo.QC_MonthData.MaterialLotDR = dbo.BTQC_MaterialLot.RowID LEFT OUTER JOIN
 dbo.BT_TestCode ON dbo.QC_MonthData.TestCodeDR = dbo.BT_TestCode.RowID} ]
{

}
