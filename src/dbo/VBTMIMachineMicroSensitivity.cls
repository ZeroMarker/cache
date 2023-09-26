Class dbo.VBTMIMachineMicroSensitivity [ ClassType = view, CompileAfter = (dbo.BTMIMachineMicroSens, dbo.BTMIMachineParameter, dbo.BTSensitivity), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTMI_MachineMicroSensitivity, ViewQuery = { SELECT     dbo.BTMI_MachineMicroSens.RowID, dbo.BTMI_MachineMicroSens.MachineParameterDR, dbo.BTMI_MachineMicroSens.MachineSensitivity, 
 dbo.BTMI_MachineMicroSens.SensitivityDR, dbo.BTMI_MachineParameter.Code AS MachineParameterCode, 
 dbo.BTMI_MachineParameter.CName AS MachineParameterName, dbo.BT_Sensitivity.Code AS SensitivityCode, dbo.BT_Sensitivity.CName AS SensitivityName
 FROM         dbo.BTMI_MachineMicroSens LEFT OUTER JOIN
 dbo.BTMI_MachineParameter ON dbo.BTMI_MachineMicroSens.MachineParameterDR = dbo.BTMI_MachineParameter.RowID LEFT OUTER JOIN
 dbo.BT_Sensitivity ON dbo.BTMI_MachineMicroSens.SensitivityDR = dbo.BT_Sensitivity.RowID} ]
{

}
