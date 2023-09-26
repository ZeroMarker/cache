Class dbo.VTCHumidityRecord [ ClassType = view, CompileAfter = (dbo.BTDevice, dbo.BTTCWarningLevel, dbo.BTWorkGroup, dbo.SYSUser, dbo.TCHumidityRecord), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_TC_HumidityRecord, ViewQuery = { SELECT     dbo.TC_HumidityRecord.RowID, dbo.TC_HumidityRecord.DeviceDR, dbo.TC_HumidityRecord.CollectDate, dbo.TC_HumidityRecord.CollectTime, 
 dbo.TC_HumidityRecord.WorkGroupDR, dbo.TC_HumidityRecord.AddDate, dbo.TC_HumidityRecord.AddTime, dbo.TC_HumidityRecord.CollectType, 
 dbo.TC_HumidityRecord.CollectUserDR, dbo.TC_HumidityRecord.AddUserDR, dbo.TC_HumidityRecord.Result, dbo.TC_HumidityRecord.WarningLevelDR, 
 dbo.BT_Device.Code AS DeviceCode, dbo.BT_Device.CName AS DeviceName, dbo.BT_WorkGroup.Code AS WorkGroupCode, 
 dbo.BT_WorkGroup.CName AS WorkGroupName, dbo.BTTC_WarningLevel.Code AS WarningLevelCode, dbo.BTTC_WarningLevel.CName AS WarningLevelName, 
 AddUser.Code AS AddUserCode, AddUser.CName AS AddUserName, CollectUser.Code AS CollectUserCode, CollectUser.CName AS CollectUserName
 FROM         dbo.TC_HumidityRecord LEFT OUTER JOIN
 dbo.BT_Device ON dbo.TC_HumidityRecord.DeviceDR = dbo.BT_Device.RowID LEFT OUTER JOIN
 dbo.BT_WorkGroup ON dbo.TC_HumidityRecord.WorkGroupDR = dbo.BT_WorkGroup.RowID LEFT OUTER JOIN
 dbo.BTTC_WarningLevel ON dbo.TC_HumidityRecord.WarningLevelDR = dbo.BTTC_WarningLevel.RowID LEFT OUTER JOIN
 dbo.SYS_User AS AddUser ON dbo.TC_HumidityRecord.AddUserDR = AddUser.RowID LEFT OUTER JOIN
 dbo.SYS_User AS CollectUser ON dbo.TC_HumidityRecord.CollectUserDR = CollectUser.RowID} ]
{

}
