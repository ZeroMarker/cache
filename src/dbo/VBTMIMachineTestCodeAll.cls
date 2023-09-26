Class dbo.VBTMIMachineTestCodeAll [ ClassType = view, CompileAfter = (dbo.BTMIMachineParameter, dbo.BTMIMachineTestCode, dbo.BTTestCode), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTMI_MachineTestCodeAll, ViewQuery = { SELECT     dbo.BTMI_MachineTestCode.RowID, dbo.BTMI_MachineTestCode.MachineParameterDR, dbo.BTMI_MachineTestCode.TestCodeDR, 
 dbo.BTMI_MachineTestCode.UPChannel, dbo.BTMI_MachineTestCode.ResultChannel, dbo.BTMI_MachineTestCode.Scale, dbo.BTMI_MachineTestCode.Active, 
 dbo.BTMI_MachineParameter.RowID AS MachineParameterRowID, dbo.BTMI_MachineParameter.Code, dbo.BTMI_MachineParameter.CName, dbo.BTMI_MachineParameter.HospitalDR, 
 dbo.BTMI_MachineParameter.LName, dbo.BTMI_MachineParameter.WorkGroupMachineDR, dbo.BTMI_MachineParameter.RoomDR, 
 dbo.BTMI_MachineParameter.RegisterDeviceDR, dbo.BTMI_MachineParameter.IPAddress, dbo.BTMI_MachineParameter.PortNo, 
 dbo.BTMI_MachineParameter.CommDirection, dbo.BTMI_MachineParameter.DelimiterForTests, dbo.BTMI_MachineParameter.DelimiterForResults, 
 dbo.BTMI_MachineParameter.DelimiterForAnt, dbo.BTMI_MachineParameter.DelimiterForSen, dbo.BTMI_MachineParameter.IFProgram, 
 dbo.BTMI_MachineParameter.ComPort, dbo.BTMI_MachineParameter.BaudRate, dbo.BTMI_MachineParameter.DataBits, dbo.BTMI_MachineParameter.StopBits, 
 dbo.BTMI_MachineParameter.Parity, dbo.BTMI_MachineParameter.DeviceCode, dbo.BTMI_MachineParameter.Sequence, 
 dbo.BTMI_MachineParameter.Active AS MachineParameterActive, dbo.BT_TestCode.RowID AS TestCodeRowID, dbo.BT_TestCode.Code AS TestCodeCode, dbo.BT_TestCode.CName AS TestCodeCName, 
 dbo.BT_TestCode.HospitalDR AS TestCodeHospitalDR, dbo.BT_TestCode.LName AS TestCodeLName, dbo.BT_TestCode.EName, dbo.BT_TestCode.Synonym, dbo.BT_TestCode.Units, 
 dbo.BT_TestCode.ResultFormat, dbo.BT_TestCode.Precision, dbo.BT_TestCode.TestMethodDR, dbo.BT_TestCode.IsCalculate, dbo.BT_TestCode.LonicCode, 
 dbo.BT_TestCode.SCode, dbo.BT_TestCode.SOPContent, dbo.BT_TestCode.SOPFile, dbo.BT_TestCode.HISCode, dbo.BT_TestCode.CostItemDR, 
 dbo.BT_TestCode.Price, dbo.BT_TestCode.ClinicalSignifyS, dbo.BT_TestCode.ClinicalSignifyL, dbo.BT_TestCode.TestSetDR, dbo.BT_TestCode.PrintOrder, 
 dbo.BT_TestCode.Sequence AS TestCodeSequence, dbo.BT_TestCode.Active AS TestCodeActive
 FROM         dbo.BTMI_MachineTestCode LEFT OUTER JOIN
 dbo.BTMI_MachineParameter ON dbo.BTMI_MachineTestCode.MachineParameterDR = dbo.BTMI_MachineParameter.RowID LEFT OUTER JOIN
 dbo.BT_TestCode ON dbo.BTMI_MachineTestCode.TestCodeDR = dbo.BT_TestCode.RowID} ]
{

}
