Class dbo.VBTTestSetLayout [ ClassType = view, CompileAfter = (dbo.BTTestCode, dbo.BTTestSet, dbo.BTTestSetLayout, dbo.BTWorkGroup), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_TestSetLayout, ViewQuery = { SELECT     dbo.BT_TestSetLayout.RowID, dbo.BT_TestSetLayout.TestSetDR, dbo.BT_TestSetLayout.WorkGroupDR, dbo.BT_TestSetLayout.TestCodeDR, 
 dbo.BT_TestSetLayout.Allowed, dbo.BT_TestSet.Code AS TestSetCode, dbo.BT_TestSet.CName AS TestSetName, dbo.BT_TestCode.Code AS TestCodeCode,  dbo.BT_TestCode.Synonym AS TestCodeSynonym,
 dbo.BT_TestCode.CName AS TestCodeName,dbo.BT_TestCode.ResultFormat AS ResultFormat, dbo.BT_WorkGroup.Code AS WorkGroupCode, dbo.BT_WorkGroup.CName AS WorkGroupName, dbo.BT_TestSetLayout.IsMandatory AS IsMandatory,dbo.BT_TestSetLayout.DefResult AS DefResult
 FROM         dbo.BT_TestSetLayout LEFT OUTER JOIN
 dbo.BT_TestSet ON dbo.BT_TestSetLayout.TestSetDR = dbo.BT_TestSet.RowID LEFT OUTER JOIN
 dbo.BT_WorkGroup ON dbo.BT_TestSetLayout.WorkGroupDR = dbo.BT_WorkGroup.RowID LEFT OUTER JOIN
 dbo.BT_TestCode ON dbo.BT_TestSetLayout.TestCodeDR = dbo.BT_TestCode.RowID} ]
{

}
