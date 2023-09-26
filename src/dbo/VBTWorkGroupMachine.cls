Class dbo.VBTWorkGroupMachine [ ClassType = view, CompileAfter = (dbo.BTRoom, dbo.BTWorkGroup, dbo.BTWorkGroupMachine), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_WorkGroupMachine, ViewQuery = { SELECT     dbo.BT_WorkGroupMachine.RowID, dbo.BT_WorkGroupMachine.Code, dbo.BT_WorkGroupMachine.CName, dbo.BT_WorkGroupMachine.WorkGroupDR, 
 dbo.BT_WorkGroupMachine.Leader, dbo.BT_WorkGroupMachine.Telephone, dbo.BT_WorkGroupMachine.ReportTempl, dbo.BT_WorkGroupMachine.RoomDR, 
 dbo.BT_WorkGroupMachine.Sequence, dbo.BT_WorkGroupMachine.Active, dbo.BT_Room.Code AS RoomCode, dbo.BT_Room.CName AS RoomName, 
 dbo.BT_WorkGroup.Code AS WorkGroupCode, dbo.BT_WorkGroup.CName AS WorkGroupName
 FROM         dbo.BT_WorkGroupMachine LEFT OUTER JOIN
 dbo.BT_Room ON dbo.BT_WorkGroupMachine.RoomDR = dbo.BT_Room.RowID LEFT OUTER JOIN
 dbo.BT_WorkGroup ON dbo.BT_WorkGroupMachine.WorkGroupDR = dbo.BT_WorkGroup.RowID} ]
{

}
