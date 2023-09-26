Class dbo.VBTTCWarningParameter [ ClassType = view, CompileAfter = (dbo.BTDevice, dbo.BTTCWarningLevel, dbo.BTTCWarningParameter), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTTC_WarningParameter, ViewQuery = { SELECT     dbo.BTTC_WarningParameter.RowID, dbo.BTTC_WarningParameter.DeviceDR, dbo.BTTC_WarningParameter.WarningLevelDR, 
 dbo.BTTC_WarningParameter.TempLow, dbo.BTTC_WarningParameter.TempHigh, dbo.BTTC_WarningParameter.HumiLow, dbo.BTTC_WarningParameter.HumiHigh, 
 dbo.BTTC_WarningLevel.Code AS WarningLevelCode, dbo.BTTC_WarningLevel.CName AS WarningLevelName, dbo.BT_Device.Code AS DeviceCode, 
 dbo.BT_Device.CName AS DeviceName
 FROM         dbo.BTTC_WarningParameter LEFT OUTER JOIN
 dbo.BTTC_WarningLevel ON dbo.BTTC_WarningParameter.WarningLevelDR = dbo.BTTC_WarningLevel.RowID LEFT OUTER JOIN
 dbo.BT_Device ON dbo.BTTC_WarningParameter.DeviceDR = dbo.BT_Device.RowID} ]
{

}
