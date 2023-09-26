Class dbo.VBTMIMachineMicroAntiBiotics [ ClassType = view, CompileAfter = (dbo.BTAntibiotics, dbo.BTMIMachineMicroAntiBio, dbo.BTMIMachineParameter), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTMI_MachineMicroAntiBiotics, ViewQuery = { SELECT     dbo.BTMI_MachineMicroAntiBio.RowID, dbo.BTMI_MachineMicroAntiBio.MachineParameterDR, dbo.BTMI_MachineMicroAntiBio.MachineAntiBiotic, 
 dbo.BTMI_MachineMicroAntiBio.AntiBioticsDR, dbo.BTMI_MachineParameter.Code AS MachineParameterCode, 
 dbo.BTMI_MachineParameter.CName AS MachineParameterName, dbo.BT_Antibiotics.Code AS AntiBioticsCode, dbo.BT_Antibiotics.CName AS AntiBioticsName
 FROM         dbo.BTMI_MachineMicroAntiBio LEFT OUTER JOIN
 dbo.BTMI_MachineParameter ON dbo.BTMI_MachineMicroAntiBio.MachineParameterDR = dbo.BTMI_MachineParameter.RowID LEFT OUTER JOIN
 dbo.BT_Antibiotics ON dbo.BTMI_MachineMicroAntiBio.AntiBioticsDR = dbo.BT_Antibiotics.RowID} ]
{

}
