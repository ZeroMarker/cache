Class dbo.VQCTestResult [ ClassType = view, CompileAfter = (dbo.BTMIMachineParameter, dbo.BTQCMaterialLot, dbo.BTQCMaterialLotTCParam, dbo.BTQCRules, dbo.BTTestCode, dbo.QCTestResult, dbo.SYSUser), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_QC_TestResult, ViewQuery = { SELECT     dbo.QC_TestResult.RowID, dbo.QC_TestResult.MaterialLotDR, dbo.QC_TestResult.TestCodeDR, dbo.QC_TestResult.LevelNo, dbo.QC_TestResult.TestDate, 
 dbo.QC_TestResult.TestTime, dbo.QC_TestResult.MachineParameterDR, dbo.QC_TestResult.SampleID, dbo.QC_TestResult.Result, dbo.QC_TestResult.TextRes, 
 dbo.QC_TestResult.MachineFlag, dbo.QC_TestResult.QCRulesDR, dbo.QC_TestResult.DQIV_Status, dbo.QC_TestResult.ExcludeType, dbo.QC_TestResult.ResultType, 
 dbo.QC_TestResult.OriginalValue, dbo.QC_TestResult.AddDate, dbo.QC_TestResult.AddTime, dbo.QC_TestResult.AddUserDR, dbo.QC_TestResult.UpdateDate, 
 dbo.QC_TestResult.UpdateTime, dbo.QC_TestResult.UpdateUserDR, dbo.QC_TestResult.Remark, dbo.QC_TestResult.MaterialLotTCParamDR, 
 dbo.BTQC_MaterialLot.Code AS MaterialLotCode, dbo.BTQC_MaterialLot.LotNo AS MaterialLotLotNo, dbo.BT_TestCode.Code AS TestCodeCode, 
 dbo.BT_TestCode.CName AS TestCodeName, dbo.BTMI_MachineParameter.Code AS MachineParameterCode, 
 dbo.BTMI_MachineParameter.CName AS MachineParameterName, dbo.BT_QCRules.Code AS QCRulesCode, dbo.BT_QCRules.CName AS QCRulesName, 
 AddUser.Code AS AddTUserCode, AddUser.CName AS AddTUserName, UpdateUser.Code AS UpdateTUserCode, UpdateUser.CName AS UpdateTUserName, 
 dbo.BTQC_MaterialLotTCParam.LevelNo AS MaterialLotTCParamLevelNo, dbo.BTQC_MaterialLotTCParam.LotNo AS MaterialLotTCParamLotNo
 FROM         dbo.QC_TestResult LEFT OUTER JOIN
 dbo.BTQC_MaterialLot ON dbo.QC_TestResult.MaterialLotDR = dbo.BTQC_MaterialLot.RowID LEFT OUTER JOIN
 dbo.BT_TestCode ON dbo.QC_TestResult.TestCodeDR = dbo.BT_TestCode.RowID LEFT OUTER JOIN
 dbo.BTMI_MachineParameter ON dbo.QC_TestResult.MachineParameterDR = dbo.BTMI_MachineParameter.RowID LEFT OUTER JOIN
 dbo.BT_QCRules ON dbo.QC_TestResult.QCRulesDR = dbo.BT_QCRules.RowID LEFT OUTER JOIN
 dbo.SYS_User AS AddUser ON dbo.QC_TestResult.AddUserDR = AddUser.RowID LEFT OUTER JOIN
 dbo.SYS_User AS UpdateUser ON dbo.QC_TestResult.UpdateUserDR = UpdateUser.RowID LEFT OUTER JOIN
 dbo.BTQC_MaterialLotTCParam ON dbo.QC_TestResult.MaterialLotTCParamDR = dbo.BTQC_MaterialLotTCParam.RowID} ]
{

}
