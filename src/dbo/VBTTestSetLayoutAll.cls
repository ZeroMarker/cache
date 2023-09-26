Class dbo.VBTTestSetLayoutAll [ ClassType = view, CompileAfter = (dbo.BTTestCode, dbo.BTTestSet, dbo.BTTestSetLayout, dbo.BTWorkGroup), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_TestSetLayoutAll, ViewQuery = { SELECT     dbo.BT_TestSetLayout.RowID, dbo.BT_TestSetLayout.TestSetDR, dbo.BT_TestSetLayout.WorkGroupDR, dbo.BT_TestSetLayout.TestCodeDR, 
 dbo.BT_TestSetLayout.Allowed, dbo.BT_TestSet.RowID AS TestSetRowID, dbo.BT_TestSet.Code, dbo.BT_TestSet.CName, dbo.BT_TestSet.HospitalDR, 
 dbo.BT_TestSet.EName, dbo.BT_TestSet.Description, dbo.BT_TestSet.HISCode, dbo.BT_TestSet.SpeciesDR, dbo.BT_TestSet.Urgent, 
 dbo.BT_TestSet.WorkGroupMachineDR AS TestSetWorkGroupMachineDR, dbo.BT_TestSet.SpecimenDR, dbo.BT_TestSet.ContainerDR, dbo.BT_TestSet.MergeType, dbo.BT_TestSet.CostItemDR, 
 dbo.BT_TestSet.CollectPromptDR, dbo.BT_TestSet.ReportPromptDR, dbo.BT_TestSet.Sequence, dbo.BT_TestSet.Active, dbo.BT_WorkGroup.RowID AS WorkGroupRowID, 
 dbo.BT_WorkGroup.Code AS WorkGroupCode, dbo.BT_WorkGroup.CName AS WorkGroupCName, dbo.BT_WorkGroup.DepartmentDR, dbo.BT_WorkGroup.Leader, 
 dbo.BT_WorkGroup.Telephone, dbo.BT_WorkGroup.ShowOperator, dbo.BT_WorkGroup.DoubleCheck, dbo.BT_WorkGroup.ReportTempl, dbo.BT_WorkGroup.RoomDR, 
 dbo.BT_WorkGroup.WPath, dbo.BT_WorkGroup.Sequence AS WorkGroupSequence, dbo.BT_WorkGroup.Active AS WorkGroupActive, dbo.BT_TestCode.RowID AS TestCodeRowID, 
 dbo.BT_TestCode.Code AS TestCodeCode, dbo.BT_TestCode.CName AS TestCodeCName, dbo.BT_TestCode.HospitalDR AS TestCodeHospitalDR, dbo.BT_TestCode.LName, 
 dbo.BT_TestCode.EName AS TestCodeEName, dbo.BT_TestCode.Synonym, dbo.BT_TestCode.Units, dbo.BT_TestCode.ResultFormat, dbo.BT_TestCode.Precision, 
 dbo.BT_TestCode.TestMethodDR, dbo.BT_TestCode.IsCalculate, dbo.BT_TestCode.LonicCode, dbo.BT_TestCode.SCode, dbo.BT_TestCode.SOPContent, 
 dbo.BT_TestCode.SOPFile, dbo.BT_TestCode.HISCode AS TestCodeHISCode, dbo.BT_TestCode.CostItemDR AS TestCodeCostItemDR, dbo.BT_TestCode.Price, 
 dbo.BT_TestCode.ClinicalSignifyS, dbo.BT_TestCode.ClinicalSignifyL, dbo.BT_TestCode.TestSetDR AS TestCode, dbo.BT_TestCode.PrintOrder, 
 dbo.BT_TestCode.Sequence AS TestCodeSequence, dbo.BT_TestCode.Active AS TestCodeActive
 FROM         dbo.BT_TestSetLayout LEFT OUTER JOIN
 dbo.BT_TestSet ON dbo.BT_TestSetLayout.TestSetDR = dbo.BT_TestSet.RowID LEFT OUTER JOIN
 dbo.BT_WorkGroup ON dbo.BT_TestSetLayout.WorkGroupDR = dbo.BT_WorkGroup.RowID LEFT OUTER JOIN
 dbo.BT_TestCode ON dbo.BT_TestSetLayout.TestCodeDR = dbo.BT_TestCode.RowID} ]
{

}
