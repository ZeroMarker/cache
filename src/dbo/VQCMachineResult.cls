Class dbo.VQCMachineResult [ ClassType = view, CompileAfter = (dbo.BTMIMachineParameter, dbo.BTQCMaterialLot, dbo.BTTestCode, dbo.QCMachineResult), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_QC_MachineResult, ViewQuery = { SELECT     dbo.QC_MachineResult.RowID, dbo.QC_MachineResult.MaterialLotDR, dbo.QC_MachineResult.TestCodeDR, dbo.QC_MachineResult.LevelNo, 
 dbo.QC_MachineResult.MachineParameterDR, dbo.QC_MachineResult.SampleID, dbo.QC_MachineResult.TestDate, dbo.QC_MachineResult.TestTime, 
 dbo.QC_MachineResult.TransmitDate, dbo.QC_MachineResult.TransmitTime, dbo.QC_MachineResult.Result, dbo.QC_MachineResult.TextRes, 
 dbo.QC_MachineResult.MachineFlag, dbo.BTQC_MaterialLot.Code AS MaterialLotCode, dbo.BTQC_MaterialLot.LotNo AS MaterialLotLotNo, 
 dbo.BT_TestCode.Code AS TestCodeCode, dbo.BT_TestCode.CName AS TestCodeName, dbo.BTMI_MachineParameter.Code AS MachineParameterCode, 
 dbo.BTMI_MachineParameter.CName AS MachineParameterName
 FROM         dbo.QC_MachineResult LEFT OUTER JOIN
 dbo.BTQC_MaterialLot ON dbo.QC_MachineResult.MaterialLotDR = dbo.BTQC_MaterialLot.RowID LEFT OUTER JOIN
 dbo.BT_TestCode ON dbo.QC_MachineResult.TestCodeDR = dbo.BT_TestCode.RowID LEFT OUTER JOIN
 dbo.BTMI_MachineParameter ON dbo.QC_MachineResult.MachineParameterDR = dbo.BTMI_MachineParameter.RowID} ]
{

}
