Class dbo.VBTMIMachineParameter [ ClassType = view, CompileAfter = (dbo.BTHospital, dbo.BTMIMachineParameter, dbo.BTRegisterDevice, dbo.BTRoom, dbo.BTWorkGroupMachine), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTMI_MachineParameter, ViewQuery = { SELECT     dbo.BTMI_MachineParameter.RowID, dbo.BTMI_MachineParameter.Code, dbo.BTMI_MachineParameter.CName, dbo.BTMI_MachineParameter.HospitalDR, 
 dbo.BTMI_MachineParameter.LName, dbo.BTMI_MachineParameter.WorkGroupMachineDR, dbo.BTMI_MachineParameter.RoomDR, dbo.BTMI_MachineParameter.IsTempSave, dbo.BTMI_MachineParameter.EpisNo, 
 dbo.BTMI_MachineParameter.RegisterDeviceDR, dbo.BTMI_MachineParameter.IPAddress, dbo.BTMI_MachineParameter.PortNo, 
 dbo.BTMI_MachineParameter.CommDirection, dbo.BTMI_MachineParameter.DelimiterForTests, dbo.BTMI_MachineParameter.DelimiterForResults, 
 dbo.BTMI_MachineParameter.DelimiterForAnt, dbo.BTMI_MachineParameter.DelimiterForSen, dbo.BTMI_MachineParameter.IFProgram, 
 dbo.BTMI_MachineParameter.ComPort, dbo.BTMI_MachineParameter.BaudRate, dbo.BTMI_MachineParameter.DataBits, dbo.BTMI_MachineParameter.StopBits, 
 dbo.BTMI_MachineParameter.Parity, dbo.BTMI_MachineParameter.DeviceCode, dbo.BTMI_MachineParameter.Sequence, dbo.BTMI_MachineParameter.Active, 
 dbo.BT_WorkGroupMachine.Code AS WorkGroupMachineCode, dbo.BT_WorkGroupMachine.CName AS WorkGroupMachineName, 
 dbo.BT_Hospital.Code AS HospitalCode, dbo.BT_Hospital.CName AS HospitalName, dbo.BT_Room.Code AS RoomCode, dbo.BT_Room.CName AS RoomName, 
 dbo.BT_RegisterDevice.Code AS RegisterDeviceCode, dbo.BT_RegisterDevice.CName AS RegisterDeviceName
 FROM         dbo.BTMI_MachineParameter LEFT OUTER JOIN
 dbo.BT_WorkGroupMachine ON dbo.BTMI_MachineParameter.WorkGroupMachineDR = dbo.BT_WorkGroupMachine.RowID LEFT OUTER JOIN
 dbo.BT_Hospital ON dbo.BTMI_MachineParameter.HospitalDR = dbo.BT_Hospital.RowID LEFT OUTER JOIN
 dbo.BT_Room ON dbo.BTMI_MachineParameter.RoomDR = dbo.BT_Room.RowID LEFT OUTER JOIN
 dbo.BT_RegisterDevice ON dbo.BTMI_MachineParameter.RegisterDeviceDR = dbo.BT_RegisterDevice.RowID} ]
{

}
