Class dbo.VBTMIMachineMoveLog [ ClassType = view, CompileAfter = (dbo.BTMIMachineMovelog, dbo.BTRoom, dbo.BTWorkGroupMachine), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTMI_MachineMoveLog, ViewQuery = { SELECT     dbo.BTMI_MachineMovelog.RowID, dbo.BTMI_MachineMovelog.MachineParameterDR, dbo.BTMI_MachineMovelog.WorkGroupMachineDR, 
 dbo.BTMI_MachineMovelog.RoomDR, dbo.BTMI_MachineMovelog.StartDate, dbo.BTMI_MachineMovelog.StartTime, dbo.BT_Room.Code AS RoomCode, 
 dbo.BT_Room.CName AS RoomName, dbo.BT_WorkGroupMachine.Code AS WorkGroupMachineCode, 
 dbo.BT_WorkGroupMachine.CName AS WorkGroupMachineName
 FROM         dbo.BTMI_MachineMovelog LEFT OUTER JOIN
 dbo.BT_Room ON dbo.BTMI_MachineMovelog.RoomDR = dbo.BT_Room.RowID LEFT OUTER JOIN
 dbo.BT_WorkGroupMachine ON dbo.BTMI_MachineMovelog.WorkGroupMachineDR = dbo.BT_WorkGroupMachine.RowID} ]
{

}
