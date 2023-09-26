Class dbo.VDVRepair [ ClassType = view, CompileAfter = (dbo.BTDVServiceCompany, dbo.BTDevice, dbo.BTWorkGroup, dbo.DVRepair, dbo.SYSUser), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_DV_Repair, ViewQuery = { SELECT     dbo.DV_Repair.RowID, dbo.DV_Repair.RepairNo, dbo.DV_Repair.DeviceDR, dbo.DV_Repair.AddDate, dbo.DV_Repair.AddTime, dbo.DV_Repair.WorkGroupDR, 
 dbo.DV_Repair.AddUserDR, dbo.DV_Repair.RepairDate, dbo.DV_Repair.RepairTime, dbo.DV_Repair.ServiceCompanyDR, dbo.DV_Repair.RepairMan, 
 dbo.DV_Repair.RepairRemark, dbo.DV_Repair.RepairCost, dbo.DV_Repair.ReceiptNo, dbo.DV_Repair.AuthDate, dbo.DV_Repair.AuthTime, dbo.DV_Repair.AuthUserDR, 
 dbo.DV_Repair.AuthRemark, dbo.DV_Repair.CancelDate, dbo.DV_Repair.CancelTime, dbo.DV_Repair.CancelUserDR, dbo.DV_Repair.CancelRemark, 
 dbo.DV_Repair.Status, dbo.BT_Device.Code AS DeviceCode, dbo.BT_Device.CName AS DeviceName, dbo.BT_WorkGroup.Code AS WorkGroupCode, 
 dbo.BT_WorkGroup.CName AS WorkGroupName, AddUser.Code AS AddUserCode, AddUser.CName AS AddUserName, 
 dbo.BTDV_ServiceCompany.Code AS ServiceCompanyCode, dbo.BTDV_ServiceCompany.CName AS ServiceCompanyName, AuthUser.Code AS AuthUserCode, 
 AuthUser.CName AS AuthUserName, CancelUser.Code AS CancelUserCode, CancelUser.CName AS CancelUserName
 FROM         dbo.DV_Repair LEFT OUTER JOIN
 dbo.BT_Device ON dbo.DV_Repair.DeviceDR = dbo.BT_Device.RowID LEFT OUTER JOIN
 dbo.BT_WorkGroup ON dbo.DV_Repair.WorkGroupDR = dbo.BT_WorkGroup.RowID LEFT OUTER JOIN
 dbo.SYS_User AS AddUser ON dbo.DV_Repair.AddUserDR = AddUser.RowID LEFT OUTER JOIN
 dbo.BTDV_ServiceCompany ON dbo.DV_Repair.ServiceCompanyDR = dbo.BTDV_ServiceCompany.RowID LEFT OUTER JOIN
 dbo.SYS_User AS AuthUser ON dbo.DV_Repair.AuthUserDR = AuthUser.RowID LEFT OUTER JOIN
 dbo.SYS_User AS CancelUser ON dbo.DV_Repair.CancelUserDR = CancelUser.RowID} ]
{

}
