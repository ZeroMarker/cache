Class dbo.VBTMIMachineSpecimenAll [ ClassType = view, CompileAfter = (dbo.BTMIMachineParameter, dbo.BTMIMachineSpecimen, dbo.BTSpecimen), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTMI_MachineSpecimenAll, ViewQuery = { SELECT     dbo.BTMI_MachineSpecimen.RowID, dbo.BTMI_MachineSpecimen.MachineParameterDR, dbo.BTMI_MachineSpecimen.SpecimenDR, 
 dbo.BTMI_MachineSpecimen.Channel, dbo.BTMI_MachineParameter.RowID AS MachineParameterRowID, dbo.BTMI_MachineParameter.Code, dbo.BTMI_MachineParameter.CName, 
 dbo.BTMI_MachineParameter.HospitalDR, dbo.BTMI_MachineParameter.LName, dbo.BTMI_MachineParameter.WorkGroupMachineDR, 
 dbo.BTMI_MachineParameter.RoomDR, dbo.BTMI_MachineParameter.RegisterDeviceDR, dbo.BTMI_MachineParameter.IPAddress, 
 dbo.BTMI_MachineParameter.PortNo, dbo.BTMI_MachineParameter.CommDirection, dbo.BTMI_MachineParameter.DelimiterForTests, 
 dbo.BTMI_MachineParameter.DelimiterForResults, dbo.BTMI_MachineParameter.DelimiterForAnt, dbo.BTMI_MachineParameter.DelimiterForSen, 
 dbo.BTMI_MachineParameter.IFProgram, dbo.BTMI_MachineParameter.ComPort, dbo.BTMI_MachineParameter.BaudRate, dbo.BTMI_MachineParameter.DataBits, 
 dbo.BTMI_MachineParameter.StopBits, dbo.BTMI_MachineParameter.Parity, dbo.BTMI_MachineParameter.DeviceCode, dbo.BTMI_MachineParameter.Sequence, 
 dbo.BTMI_MachineParameter.Active, dbo.BT_Specimen.RowID AS SpecimenRowID, dbo.BT_Specimen.Code AS SpecimenCode, dbo.BT_Specimen.IName, dbo.BT_Specimen.XName, 
 dbo.BT_Specimen.EName, dbo.BT_Specimen.HospitalDR AS SpecimenHospitalDR, dbo.BT_Specimen.HISCode, dbo.BT_Specimen.WCode, dbo.BT_Specimen.SpecimenGroupDR, 
 dbo.BT_Specimen.Sequence AS SpecimenSequence, dbo.BT_Specimen.Active AS SpecimenActive
 FROM         dbo.BTMI_MachineSpecimen LEFT OUTER JOIN
 dbo.BTMI_MachineParameter ON dbo.BTMI_MachineSpecimen.MachineParameterDR = dbo.BTMI_MachineParameter.RowID LEFT OUTER JOIN
 dbo.BT_Specimen ON dbo.BTMI_MachineSpecimen.SpecimenDR = dbo.BT_Specimen.RowID} ]
{

}
