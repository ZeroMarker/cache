Class dbo.VTCTempRecord [ ClassType = view, CompileAfter = (dbo.BTDevice, dbo.BTTCWarningLevel, dbo.BTWorkGroup, dbo.SYSUser, dbo.TCTempRecord), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_TC_TempRecord, ViewQuery = { SELECT     dbo.TC_TempRecord.RowID, dbo.TC_TempRecord.DeviceDR, dbo.TC_TempRecord.CollectDate, dbo.TC_TempRecord.CollectTime, 
 dbo.TC_TempRecord.WorkGroupDR, dbo.TC_TempRecord.AddDate, dbo.TC_TempRecord.AddTime, dbo.TC_TempRecord.CollectType, 
 dbo.TC_TempRecord.CollectUserDR, dbo.TC_TempRecord.AddUserDR, dbo.TC_TempRecord.Result, dbo.TC_TempRecord.WarningLevelDR, 
 dbo.BT_Device.Code AS DeviceCode, dbo.BT_Device.CName AS DeviceName, dbo.BTTC_WarningLevel.Code AS WarningLevelCode, 
 dbo.BTTC_WarningLevel.CName AS WarningLevelName, AddUser.Code AS AddUserCode, AddUser.CName AS AddUserName, CollectUser.Code AS CollectUserCode, 
 CollectUser.CName AS CollectUserName, dbo.BT_WorkGroup.Code AS WorkGroupCode, dbo.BT_WorkGroup.CName AS WorkGroupName
 FROM         dbo.TC_TempRecord LEFT OUTER JOIN
 dbo.BT_Device ON dbo.TC_TempRecord.DeviceDR = dbo.BT_Device.RowID LEFT OUTER JOIN
 dbo.BTTC_WarningLevel ON dbo.TC_TempRecord.WarningLevelDR = dbo.BTTC_WarningLevel.RowID LEFT OUTER JOIN
 dbo.SYS_User AS AddUser ON dbo.TC_TempRecord.AddUserDR = AddUser.RowID LEFT OUTER JOIN
 dbo.SYS_User AS CollectUser ON dbo.TC_TempRecord.CollectUserDR = CollectUser.RowID LEFT OUTER JOIN
 dbo.BT_WorkGroup ON dbo.TC_TempRecord.WorkGroupDR = dbo.BT_WorkGroup.RowID} ]
{

}
