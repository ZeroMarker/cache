Class dbo.VBTTestSet [ ClassType = view, CompileAfter = (dbo.BTCollectPrompt, dbo.BTContainer, dbo.BTCostItem, dbo.BTHospital, dbo.BTReportPrompt, dbo.BTSpecies, dbo.BTSpecimen, dbo.BTTestSet, dbo.BTWorkGroupMachine), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_TestSet, ViewQuery = { SELECT     dbo.BT_TestSet.RowID, dbo.BT_TestSet.Code, dbo.BT_TestSet.CName, dbo.BT_TestSet.HospitalDR, dbo.BT_TestSet.EName, dbo.BT_TestSet.Description, 
 dbo.BT_TestSet.HISCode, dbo.BT_TestSet.SpeciesDR, dbo.BT_TestSet.Urgent, dbo.BT_TestSet.SpecimenDR, dbo.BT_TestSet.ContainerDR, 
 dbo.BT_TestSet.MergeType, dbo.BT_TestSet.WorkGroupMachineDR, dbo.BT_TestSet.CostItemDR, dbo.BT_TestSet.CollectPromptDR, 
 dbo.BT_TestSet.ReportPromptDR, dbo.BT_TestSet.Sequence, dbo.BT_TestSet.Active, dbo.BT_Hospital.Code AS HospitalCode, 
 dbo.BT_Hospital.CName AS HospitalName, dbo.BT_Species.Code AS SpeciesCode, dbo.BT_Species.CName AS SpeciesName, 
 dbo.BT_Specimen.Code AS SpecimenCode, dbo.BT_Specimen.IName AS SpecimenIName, dbo.BT_Specimen.XName AS SpecimenXName, 
 dbo.BT_Container.Code AS ContainerCode, dbo.BT_Container.CName AS ContainerName, dbo.BT_WorkGroupMachine.Code AS WorkGroupMachineCode, 
 dbo.BT_WorkGroupMachine.CName AS WorkGroupMachineName, dbo.BT_CostItem.Code AS CostItemCode, dbo.BT_CostItem.CName AS CostItemName, 
 dbo.BT_CollectPrompt.Code AS CollectPromptCode, dbo.BT_CollectPrompt.CName AS CollectPromptName, dbo.BT_ReportPrompt.Code AS ReportPromptCode, 
 dbo.BT_ReportPrompt.CName AS ReportPromptName
 FROM         dbo.BT_TestSet LEFT OUTER JOIN
 dbo.BT_Hospital ON dbo.BT_TestSet.HospitalDR = dbo.BT_Hospital.RowID LEFT OUTER JOIN
 dbo.BT_Species ON dbo.BT_TestSet.SpeciesDR = dbo.BT_Species.RowID LEFT OUTER JOIN
 dbo.BT_Specimen ON dbo.BT_TestSet.SpecimenDR = dbo.BT_Specimen.RowID LEFT OUTER JOIN
 dbo.BT_Container ON dbo.BT_TestSet.ContainerDR = dbo.BT_Container.RowID LEFT OUTER JOIN
 dbo.BT_WorkGroupMachine ON dbo.BT_TestSet.WorkGroupMachineDR = dbo.BT_WorkGroupMachine.RowID LEFT OUTER JOIN
 dbo.BT_CostItem ON dbo.BT_TestSet.CostItemDR = dbo.BT_CostItem.RowID LEFT OUTER JOIN
 dbo.BT_CollectPrompt ON dbo.BT_TestSet.CollectPromptDR = dbo.BT_CollectPrompt.RowID LEFT OUTER JOIN
 dbo.BT_ReportPrompt ON dbo.BT_TestSet.ReportPromptDR = dbo.BT_ReportPrompt.RowID} ]
{

}
