Class dbo.VTCHumitureRecord [ ClassType = view, CompileAfter = (dbo.TCHumidityRecord, dbo.TCTempRecord, dbo.BTDevice, dbo.SYSUser, dbo.BTTCWarningLevel, dbo.BTWorkGroup), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_TC_HumitureRecord, ViewQuery = {
SELECT     (CASE WHEN dbo.TC_HumidityRecord.DeviceDR > 0 THEN dbo.TC_HumidityRecord.DeviceDR ELSE dbo.TC_TempRecord.DeviceDR END) AS DeviceDR,
                          (SELECT     CName
                            FROM          dbo.BT_Device
                            WHERE      (RowID = (CASE WHEN dbo.TC_HumidityRecord.DeviceDR > 0 THEN dbo.TC_HumidityRecord.DeviceDR ELSE dbo.TC_TempRecord.DeviceDR END))) 
                      AS DeviceName,
                          (SELECT     Code
                            FROM          dbo.BT_Device AS BT_Device_1
                            WHERE      (RowID = (CASE WHEN dbo.TC_HumidityRecord.DeviceDR > 0 THEN dbo.TC_HumidityRecord.DeviceDR ELSE dbo.TC_TempRecord.DeviceDR END))) 
                      AS DeviceCode, (CASE WHEN dbo.TC_TempRecord.CollectDate > 0 THEN dbo.TC_TempRecord.CollectDate ELSE dbo.TC_HumidityRecord.CollectDate END) 
                      AS CollectDate, (CASE WHEN dbo.TC_TempRecord.CollectTime > 0 THEN dbo.TC_TempRecord.CollectTime ELSE dbo.TC_HumidityRecord.CollectTime END) 
                      AS CollectTime, (CASE WHEN dbo.TC_TempRecord.CollectType > 0 THEN dbo.TC_TempRecord.CollectType ELSE dbo.TC_HumidityRecord.CollectType END) 
                      AS CollectType, (CASE WHEN dbo.TC_TempRecord.CollectUserDR > 0 THEN dbo.TC_TempRecord.CollectUserDR ELSE dbo.TC_HumidityRecord.CollectUserDR END) 
                      AS CollectUserDR,
                          (SELECT     CName
                            FROM          dbo.SYS_User
                            WHERE      (RowID = (CASE WHEN dbo.TC_TempRecord.CollectUserDR > 0 THEN dbo.TC_TempRecord.CollectUserDR ELSE dbo.TC_HumidityRecord.CollectUserDR END)))
                       AS CollectUserName, 
                      (CASE WHEN dbo.TC_TempRecord.WorkGroupDR > 0 THEN dbo.TC_TempRecord.WorkGroupDR ELSE dbo.TC_HumidityRecord.WorkGroupDR END) AS WorkGroupDR,
                          (SELECT     CName
                            FROM          dbo.BT_WorkGroup
                            WHERE      (RowID = (CASE WHEN dbo.TC_TempRecord.WorkGroupDR > 0 THEN dbo.TC_TempRecord.WorkGroupDR ELSE dbo.TC_HumidityRecord.WorkGroupDR END)))
                       AS WorkGroup, (CASE WHEN dbo.TC_TempRecord.AddDate > 0 THEN dbo.TC_TempRecord.AddDate ELSE dbo.TC_HumidityRecord.AddDate END) AS AddDate, 
                      (CASE WHEN dbo.TC_TempRecord.AddTime > 0 THEN dbo.TC_TempRecord.AddTime ELSE dbo.TC_HumidityRecord.AddTime END) AS AddTime, 
                      (CASE WHEN dbo.TC_TempRecord.AddUserDR > 0 THEN dbo.TC_TempRecord.AddUserDR ELSE dbo.TC_HumidityRecord.AddUserDR END) AS AddUserDR,
                          (SELECT     CName
                            FROM          dbo.SYS_User AS SYS_User_1
                            WHERE      (RowID = (CASE WHEN dbo.TC_TempRecord.AddUserDR > 0 THEN dbo.TC_TempRecord.AddUserDR ELSE dbo.TC_HumidityRecord.AddUserDR END))) 
                      AS AddUserName, dbo.TC_HumidityRecord.Result AS HumidityResult,
                          (SELECT     CName
                            FROM          dbo.BTTC_WarningLevel
                            WHERE      (RowID = dbo.TC_HumidityRecord.WarningLevelDR)) AS HumidityWarningLevel, dbo.TC_TempRecord.Result AS TempResult,
                          (SELECT     CName
                            FROM          dbo.BTTC_WarningLevel AS BTTC_WarningLevel_1
                            WHERE      (RowID = dbo.TC_TempRecord.WarningLevelDR)) AS TempWarningLevel, dbo.TC_HumidityRecord.RowID AS HumidityRecordRowID, 
                      dbo.TC_TempRecord.RowID AS TempRecordRowID,
                          (SELECT     ColorValue
                            FROM          dbo.BTTC_WarningLevel AS BTTC_WarningLevel_3
                            WHERE      (RowID = dbo.TC_TempRecord.WarningLevelDR)) AS TempWarningColor,
                          (SELECT     ColorValue
                            FROM          dbo.BTTC_WarningLevel AS BTTC_WarningLevel_2
                            WHERE      (RowID = dbo.TC_HumidityRecord.WarningLevelDR)) AS HumidityWarningColor
FROM         dbo.TC_HumidityRecord FULL OUTER JOIN
                      dbo.TC_TempRecord ON dbo.TC_HumidityRecord.DeviceDR = dbo.TC_TempRecord.DeviceDR AND 
                      dbo.TC_HumidityRecord.CollectDate = dbo.TC_TempRecord.CollectDate AND dbo.TC_HumidityRecord.CollectTime = dbo.TC_TempRecord.CollectTime
                      } ]
{

}
