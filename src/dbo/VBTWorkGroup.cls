Class dbo.VBTWorkGroup [ ClassType = view, CompileAfter = (dbo.BTRoom, dbo.BTWorkGroup, dbo.VBTDepartment), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_WorkGroup, ViewQuery = { SELECT     dbo.BT_WorkGroup.RowID, dbo.BT_WorkGroup.Code, dbo.BT_WorkGroup.CName, dbo.BT_WorkGroup.DepartmentDR, dbo.BT_WorkGroup.Leader, 
 dbo.BT_WorkGroup.Telephone, dbo.BT_WorkGroup.ShowOperator, dbo.BT_WorkGroup.DoubleCheck, dbo.BT_WorkGroup.ReportTempl, dbo.BT_WorkGroup.RoomDR, 
 dbo.BT_WorkGroup.WPath, dbo.BT_WorkGroup.Sequence, dbo.BT_WorkGroup.Active, dbo.V_BT_Department.Code AS DepartmentCode, 
 dbo.V_BT_Department.CName AS DepartmentName, dbo.V_BT_Department.HospitalDR, dbo.V_BT_Department.HospitalCode, dbo.V_BT_Department.HospitalName, 
 dbo.BT_Room.Code AS RoomCode, dbo.BT_Room.CName AS RoomName,dbo.BT_WorkGroup.LabType
 FROM         dbo.BT_WorkGroup LEFT OUTER JOIN
 dbo.V_BT_Department ON dbo.BT_WorkGroup.DepartmentDR = dbo.V_BT_Department.RowID LEFT OUTER JOIN
 dbo.BT_Room ON dbo.BT_WorkGroup.RoomDR = dbo.BT_Room.RowID} ]
{

}
