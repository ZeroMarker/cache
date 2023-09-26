Class dbo.VBTFridge [ ClassType = view, CompileAfter = (dbo.BTDevice, dbo.BTFridge, dbo.BTHospital, dbo.BTRoom), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_Fridge, ViewQuery = { SELECT     dbo.BT_Fridge.RowID, dbo.BT_Fridge.Code, dbo.BT_Fridge.CName, dbo.BT_Fridge.HospitalDR, dbo.BT_Fridge.Layers, dbo.BT_Fridge.DeviceDR, 
 dbo.BT_Fridge.RoomDR, dbo.BT_Fridge.Sequence, dbo.BT_Fridge.Active, dbo.BT_Hospital.Code AS HospitalCode, dbo.BT_Hospital.CName AS HospitalName, 
 dbo.BT_Device.Code AS DeviceCode, dbo.BT_Device.CName AS DeviceName, dbo.BT_Room.Code AS RoomCode, dbo.BT_Room.CName AS RoomName
 FROM         dbo.BT_Fridge LEFT OUTER JOIN
 dbo.BT_Hospital ON dbo.BT_Fridge.HospitalDR = dbo.BT_Hospital.RowID LEFT OUTER JOIN
 dbo.BT_Device ON dbo.BT_Fridge.DeviceDR = dbo.BT_Device.RowID LEFT OUTER JOIN
 dbo.BT_Room ON dbo.BT_Fridge.RoomDR = dbo.BT_Room.RowID} ]
{

}
