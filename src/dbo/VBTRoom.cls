Class dbo.VBTRoom [ ClassType = view, CompileAfter = (dbo.BTHospital, dbo.BTRoom), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_Room, ViewQuery = { SELECT     dbo.BT_Room.RowID, dbo.BT_Room.Code, dbo.BT_Room.CName, dbo.BT_Room.HospitalDR, dbo.BT_Room.Sequence, dbo.BT_Room.Active, 
 dbo.BT_Hospital.Code AS HospitalCode, dbo.BT_Hospital.CName AS HospitalName
 FROM         dbo.BT_Room LEFT OUTER JOIN
 dbo.BT_Hospital ON dbo.BT_Room.HospitalDR = dbo.BT_Hospital.RowID} ]
{

}
