Class dbo.VBTTestSetWorkGroupMachine [ ClassType = view, CompileAfter = (dbo.BTTestSet, dbo.BTTestSetWorkGroupMachine, dbo.BTWorkGroupMachine), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_TestSetWorkGroupMachine, ViewQuery = { SELECT     dbo.BT_TestSetWorkGroupMachine.RowID, dbo.BT_TestSetWorkGroupMachine.TestSetDR, dbo.BT_TestSetWorkGroupMachine.WorkGroupMachineDR, 
 dbo.BT_TestSetWorkGroupMachine.IsDefault, dbo.BT_TestSetWorkGroupMachine.Sequence, dbo.BT_TestSet.Active, 
 dbo.BT_TestSet.Code AS TestSetCode, dbo.BT_TestSet.CName AS TestSetName, dbo.BT_WorkGroupMachine.Code AS WorkGroupMachineCode, 
 dbo.BT_WorkGroupMachine.CName AS WorkGroupMachineName
 FROM         dbo.BT_TestSetWorkGroupMachine LEFT OUTER JOIN
 dbo.BT_TestSet ON dbo.BT_TestSetWorkGroupMachine.TestSetDR = dbo.BT_TestSet.RowID LEFT OUTER JOIN
 dbo.BT_WorkGroupMachine ON dbo.BT_TestSetWorkGroupMachine.WorkGroupMachineDR = dbo.BT_WorkGroupMachine.RowID} ]
{

}
