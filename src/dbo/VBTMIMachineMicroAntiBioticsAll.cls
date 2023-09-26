Class dbo.VBTMIMachineMicroAntiBioticsAll [ ClassType = view, CompileAfter = (dbo.BTAntibiotics, dbo.BTMIMachineMicroAntiBio, dbo.BTMIMachineParameter), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTMI_MachineMicroAntiBioticsAll, ViewQuery = { SELECT     dbo.BTMI_MachineMicroAntiBio.RowID, dbo.BTMI_MachineMicroAntiBio.MachineParameterDR, dbo.BTMI_MachineMicroAntiBio.MachineAntiBiotic, 
 dbo.BTMI_MachineMicroAntiBio.AntiBioticsDR, dbo.BTMI_MachineParameter.RowID AS MachineParameterRowID, dbo.BTMI_MachineParameter.Code, 
 dbo.BTMI_MachineParameter.CName, dbo.BTMI_MachineParameter.HospitalDR, dbo.BTMI_MachineParameter.LName, dbo.BTMI_MachineParameter.WorkGroupMachineDR, 
 dbo.BTMI_MachineParameter.RoomDR, dbo.BTMI_MachineParameter.RegisterDeviceDR, dbo.BTMI_MachineParameter.IPAddress, 
 dbo.BTMI_MachineParameter.PortNo, dbo.BTMI_MachineParameter.CommDirection, dbo.BTMI_MachineParameter.DelimiterForTests, 
 dbo.BTMI_MachineParameter.DelimiterForResults, dbo.BTMI_MachineParameter.DelimiterForAnt, dbo.BTMI_MachineParameter.DelimiterForSen, 
 dbo.BTMI_MachineParameter.IFProgram, dbo.BTMI_MachineParameter.ComPort, dbo.BTMI_MachineParameter.BaudRate, dbo.BTMI_MachineParameter.DataBits, 
 dbo.BTMI_MachineParameter.StopBits, dbo.BTMI_MachineParameter.Parity, dbo.BTMI_MachineParameter.DeviceCode, dbo.BTMI_MachineParameter.Sequence, 
 dbo.BTMI_MachineParameter.Active, dbo.BT_Antibiotics.RowID AS AntibioticsRowID, dbo.BT_Antibiotics.Code AS AntibioticsCode, dbo.BT_Antibiotics.CName AS AntibioticsCName, 
 dbo.BT_Antibiotics.EName, dbo.BT_Antibiotics.SName, dbo.BT_Antibiotics.WCode, dbo.BT_Antibiotics.WhoND, dbo.BT_Antibiotics.WhoNM, 
 dbo.BT_Antibiotics.WhoNE, dbo.BT_Antibiotics.Potency, dbo.BT_Antibiotics.Dosage1, dbo.BT_Antibiotics.Surem1, dbo.BT_Antibiotics.Urine1, 
 dbo.BT_Antibiotics.Dosage2, dbo.BT_Antibiotics.Surem2, dbo.BT_Antibiotics.Urine2, dbo.BT_Antibiotics.Sequence AS AntibioticsSequence, dbo.BT_Antibiotics.Active AS AntibioticsActive
 FROM         dbo.BTMI_MachineMicroAntiBio LEFT OUTER JOIN
 dbo.BTMI_MachineParameter ON dbo.BTMI_MachineMicroAntiBio.MachineParameterDR = dbo.BTMI_MachineParameter.RowID LEFT OUTER JOIN
 dbo.BT_Antibiotics ON dbo.BTMI_MachineMicroAntiBio.AntiBioticsDR = dbo.BT_Antibiotics.RowID} ]
{

}
