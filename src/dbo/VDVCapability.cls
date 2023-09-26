Class dbo.VDVCapability [ ClassType = view, CompileAfter = (dbo.BTDevice, dbo.BTWorkGroup, dbo.DVCapability, dbo.SYSUser), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_DV_Capability, ViewQuery = { SELECT     dbo.DV_Capability.RowID, dbo.DV_Capability.CapabilityNo, dbo.DV_Capability.DeviceDR, dbo.DV_Capability.AddDate, dbo.DV_Capability.AddTime, 
 dbo.DV_Capability.WorkGroupDR, dbo.DV_Capability.AddUserDR, dbo.DV_Capability.AbnormalContent, dbo.DV_Capability.StopDate, dbo.DV_Capability.StopTime, 
 dbo.DV_Capability.StartDate, dbo.DV_Capability.StartTime, dbo.DV_Capability.HandleRemark, dbo.DV_Capability.AuthDate, dbo.DV_Capability.AuthTime, 
 dbo.DV_Capability.AuthUserDR, dbo.DV_Capability.AuthRemark, dbo.DV_Capability.CancelDate, dbo.DV_Capability.CancelTime, dbo.DV_Capability.CancelUserDR, 
 dbo.DV_Capability.CancelRemark, dbo.DV_Capability.Status, dbo.BT_Device.Code AS DeviceCode, dbo.BT_Device.CName AS DeviceName, 
 dbo.BT_WorkGroup.Code AS WorkGroupCode, dbo.BT_WorkGroup.CName AS WorkGroupName, AddUser.Code AS AddUserCode, AddUser.CName AS AddUserName, 
 AuthUser.Code AS AuthUserCode, AuthUser.CName AS AuthUserName, CancelUser.Code AS CancelUserCode, CancelUser.CName AS CancelUserName
 FROM         dbo.DV_Capability LEFT OUTER JOIN
 dbo.BT_Device ON dbo.DV_Capability.DeviceDR = dbo.BT_Device.RowID LEFT OUTER JOIN
 dbo.BT_WorkGroup ON dbo.DV_Capability.WorkGroupDR = dbo.BT_WorkGroup.RowID LEFT OUTER JOIN
 dbo.SYS_User AS AddUser ON dbo.DV_Capability.AddUserDR = AddUser.RowID LEFT OUTER JOIN
 dbo.SYS_User AS AuthUser ON dbo.DV_Capability.AuthUserDR = AuthUser.RowID LEFT OUTER JOIN
 dbo.SYS_User AS CancelUser ON dbo.DV_Capability.CancelUserDR = CancelUser.RowID} ]
{

}
