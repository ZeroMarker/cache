Class dbo.VBTMIMachineMicroBugs [ ClassType = view, CompileAfter = (dbo.BTMIMachineMicroBugs, dbo.BTMIMachineParameter, dbo.BTOrganism), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTMI_MachineMicroBugs, ViewQuery = { SELECT     dbo.BTMI_MachineMicroBugs.RowID, dbo.BTMI_MachineMicroBugs.MachineParameterDR, dbo.BTMI_MachineMicroBugs.MachineBug, 
 dbo.BTMI_MachineMicroBugs.OrganismDR, dbo.BTMI_MachineParameter.Code AS MachineParameterCode, 
 dbo.BTMI_MachineParameter.CName AS MachineParameterName, dbo.BT_Organism.Code AS OrganismCode, dbo.BT_Organism.CName AS OrganismName
 FROM         dbo.BTMI_MachineMicroBugs LEFT OUTER JOIN
 dbo.BTMI_MachineParameter ON dbo.BTMI_MachineMicroBugs.MachineParameterDR = dbo.BTMI_MachineParameter.RowID LEFT OUTER JOIN
 dbo.BT_Organism ON dbo.BTMI_MachineMicroBugs.OrganismDR = dbo.BT_Organism.RowID} ]
{

}
