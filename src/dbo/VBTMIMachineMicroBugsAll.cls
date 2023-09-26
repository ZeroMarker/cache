Class dbo.VBTMIMachineMicroBugsAll [ ClassType = view, CompileAfter = (dbo.BTMIMachineMicroBugs, dbo.BTMIMachineParameter, dbo.BTOrganism), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTMI_MachineMicroBugsAll, ViewQuery = { SELECT     dbo.BTMI_MachineMicroBugs.RowID, dbo.BTMI_MachineMicroBugs.MachineParameterDR, dbo.BTMI_MachineMicroBugs.MachineBug, 
 dbo.BTMI_MachineMicroBugs.OrganismDR, dbo.BTMI_MachineParameter.RowID AS MachineParameterRowID, dbo.BTMI_MachineParameter.Code, 
 dbo.BTMI_MachineParameter.CName, dbo.BTMI_MachineParameter.HospitalDR, dbo.BTMI_MachineParameter.LName, dbo.BTMI_MachineParameter.WorkGroupMachineDR, 
 dbo.BTMI_MachineParameter.RoomDR, dbo.BTMI_MachineParameter.RegisterDeviceDR, dbo.BTMI_MachineParameter.IPAddress, 
 dbo.BTMI_MachineParameter.PortNo, dbo.BTMI_MachineParameter.CommDirection, dbo.BTMI_MachineParameter.DelimiterForTests, 
 dbo.BTMI_MachineParameter.DelimiterForResults, dbo.BTMI_MachineParameter.DelimiterForAnt, dbo.BTMI_MachineParameter.DelimiterForSen, 
 dbo.BTMI_MachineParameter.IFProgram, dbo.BTMI_MachineParameter.ComPort, dbo.BTMI_MachineParameter.BaudRate, dbo.BTMI_MachineParameter.DataBits, 
 dbo.BTMI_MachineParameter.StopBits, dbo.BTMI_MachineParameter.Parity, dbo.BTMI_MachineParameter.DeviceCode, dbo.BTMI_MachineParameter.Sequence, 
 dbo.BTMI_MachineParameter.Active, dbo.BT_Organism.RowID AS OrganismRowID, dbo.BT_Organism.Code AS OrganismCode, dbo.BT_Organism.CName AS OrganismCName, 
 dbo.BT_Organism.EName, dbo.BT_Organism.SName, dbo.BT_Organism.WCode, dbo.BT_Organism.Gram, dbo.BT_Organism.Status, 
 dbo.BT_Organism.OrganismGroupDR, dbo.BT_Organism.GenusDR, dbo.BT_Organism.Sequence AS OrganismSequence, dbo.BT_Organism.Active AS OrganismActive
 FROM         dbo.BTMI_MachineMicroBugs LEFT OUTER JOIN
 dbo.BTMI_MachineParameter ON dbo.BTMI_MachineMicroBugs.MachineParameterDR = dbo.BTMI_MachineParameter.RowID LEFT OUTER JOIN
 dbo.BT_Organism ON dbo.BTMI_MachineMicroBugs.OrganismDR = dbo.BT_Organism.RowID} ]
{

}
