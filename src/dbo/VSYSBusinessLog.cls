Class dbo.VSYSBusinessLog [ ClassType = view, CompileAfter = (dbo.SYSBusinessLog, dbo.SYSUser), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_SYS_BusinessLog, ViewQuery = { SELECT     dbo.SYS_BusinessLog.RowID, dbo.SYS_BusinessLog.ObjectType, dbo.SYS_BusinessLog.ObjectID, dbo.SYS_BusinessLog.Action, dbo.SYS_BusinessLog.LogData, 
 dbo.SYS_BusinessLog.AddDate, dbo.SYS_BusinessLog.AddTime, dbo.SYS_BusinessLog.AddUserDR, dbo.SYS_BusinessLog.ClientIPAddress, 
 dbo.SYS_BusinessLog.ActionDesc, dbo.SYS_User.CName AS AddUserCName, dbo.SYS_User.Code AS AddUserCode
 FROM         dbo.SYS_BusinessLog INNER JOIN
 dbo.SYS_User ON dbo.SYS_BusinessLog.AddUserDR = dbo.SYS_User.RowID} ]
{

}
