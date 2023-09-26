Class dbo.VBTMIMachineMicroSensitivityAll [ ClassType = view, CompileAfter = (dbo.BTMIMachineMicroSens, dbo.BTMIMachineParameter, dbo.BTSensitivity), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTMI_MachineMicroSensitivityAll, ViewQuery = { SELECT     dbo.BTMI_MachineMicroSens.RowID, dbo.BTMI_MachineMicroSens.MachineParameterDR, dbo.BTMI_MachineMicroSens.MachineSensitivity, 
 dbo.BTMI_MachineMicroSens.SensitivityDR, dbo.BTMI_MachineParameter.RowID AS MachineParameterRowID, dbo.BTMI_MachineParameter.Code, 
 dbo.BTMI_MachineParameter.CName, dbo.BTMI_MachineParameter.HospitalDR, dbo.BTMI_MachineParameter.LName, dbo.BTMI_MachineParameter.WorkGroupMachineDR, 
 dbo.BTMI_MachineParameter.RoomDR, dbo.BTMI_MachineParameter.RegisterDeviceDR, dbo.BTMI_MachineParameter.IPAddress, 
 dbo.BTMI_MachineParameter.PortNo, dbo.BTMI_MachineParameter.CommDirection, dbo.BTMI_MachineParameter.DelimiterForTests, 
 dbo.BTMI_MachineParameter.DelimiterForResults, dbo.BTMI_MachineParameter.DelimiterForAnt, dbo.BTMI_MachineParameter.DelimiterForSen, 
 dbo.BTMI_MachineParameter.IFProgram, dbo.BTMI_MachineParameter.ComPort, dbo.BTMI_MachineParameter.BaudRate, dbo.BTMI_MachineParameter.DataBits, 
 dbo.BTMI_MachineParameter.StopBits, dbo.BTMI_MachineParameter.Parity, dbo.BTMI_MachineParameter.DeviceCode, dbo.BTMI_MachineParameter.Sequence, 
 dbo.BTMI_MachineParameter.Active, dbo.BT_Sensitivity.RowID AS SensitivityRowID, dbo.BT_Sensitivity.Code AS SensitivityCode, dbo.BT_Sensitivity.CName AS SensitivityCName, 
 dbo.BT_Sensitivity.ResultType, dbo.BT_Sensitivity.Sequence AS SensitivitySequence, dbo.BT_Sensitivity.Active AS SensitivityActive
 FROM         dbo.BTMI_MachineMicroSens LEFT OUTER JOIN
 dbo.BTMI_MachineParameter ON dbo.BTMI_MachineMicroSens.MachineParameterDR = dbo.BTMI_MachineParameter.RowID LEFT OUTER JOIN
 dbo.BT_Sensitivity ON dbo.BTMI_MachineMicroSens.SensitivityDR = dbo.BT_Sensitivity.RowID} ]
{

}
