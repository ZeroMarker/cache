Class dbo.VDVMaintenancePlan [ ClassType = view, CompileAfter = (dbo.BTDVMaintenceType, dbo.BTDVServiceCompany, dbo.BTDevice, dbo.BTWorkGroup, dbo.DVMaintenancePlan, dbo.SYSUser), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_DV_MaintenancePlan, ViewQuery = { SELECT     dbo.DV_MaintenancePlan.RowID, dbo.DV_MaintenancePlan.PlanNo, dbo.DV_MaintenancePlan.DeviceDR, dbo.DV_MaintenancePlan.AddDate, 
 dbo.DV_MaintenancePlan.AddTime, dbo.DV_MaintenancePlan.WorkGroupDR, dbo.DV_MaintenancePlan.AddUserDR, dbo.DV_MaintenancePlan.PlanDate, 
 dbo.DV_MaintenancePlan.PlanTime, dbo.DV_MaintenancePlan.ServiceCompanyDR, dbo.DV_MaintenancePlan.MaintenceTypeDR, 
 dbo.DV_MaintenancePlan.PlanContent, dbo.DV_MaintenancePlan.PlanUserDR, dbo.DV_MaintenancePlan.ExecuteDate, dbo.DV_MaintenancePlan.ExecuteTime, 
 dbo.DV_MaintenancePlan.ExecuteUserDR, dbo.DV_MaintenancePlan.ExecuteRemark, dbo.DV_MaintenancePlan.CancelDate, dbo.DV_MaintenancePlan.CancelTime, 
 dbo.DV_MaintenancePlan.CancelUserDR, dbo.DV_MaintenancePlan.CancelRemark, dbo.DV_MaintenancePlan.Status, dbo.BT_Device.Code AS DeviceCode, 
 dbo.BT_Device.CName AS DeviceName, dbo.BT_WorkGroup.Code AS WorkGroupCode, dbo.BT_WorkGroup.CName AS WorkGroupName, 
 AddUser.Code AS AddUserCode, AddUser.CName AS AddUserName, dbo.BTDV_ServiceCompany.Code AS ServiceCompanyCode, 
 dbo.BTDV_ServiceCompany.CName AS ServiceCompanyName, dbo.BTDV_MaintenceType.Code AS MaintenceTypeCode, 
 dbo.BTDV_MaintenceType.CName AS MaintenceTypeName, PlanUser.Code AS PlanUserCode, PlanUser.CName AS PlanUserName, 
 ExecuteUser.Code AS ExecuteUserCode, ExecuteUser.CName AS ExecuteUserName, CancelUser.Code AS CancelUserCode, 
 CancelUser.CName AS CancelUserName
 FROM         dbo.DV_MaintenancePlan LEFT OUTER JOIN
 dbo.BT_Device ON dbo.DV_MaintenancePlan.DeviceDR = dbo.BT_Device.RowID LEFT OUTER JOIN
 dbo.BT_WorkGroup ON dbo.DV_MaintenancePlan.WorkGroupDR = dbo.BT_WorkGroup.RowID LEFT OUTER JOIN
 dbo.SYS_User AS AddUser ON dbo.DV_MaintenancePlan.AddUserDR = AddUser.RowID LEFT OUTER JOIN
 dbo.BTDV_ServiceCompany ON dbo.DV_MaintenancePlan.ServiceCompanyDR = dbo.BTDV_ServiceCompany.RowID LEFT OUTER JOIN
 dbo.BTDV_MaintenceType ON dbo.DV_MaintenancePlan.MaintenceTypeDR = dbo.BTDV_MaintenceType.RowId LEFT OUTER JOIN
 dbo.SYS_User AS PlanUser ON dbo.DV_MaintenancePlan.PlanUserDR = PlanUser.RowID LEFT OUTER JOIN
 dbo.SYS_User AS ExecuteUser ON dbo.DV_MaintenancePlan.ExecuteUserDR = ExecuteUser.RowID LEFT OUTER JOIN
 dbo.SYS_User AS CancelUser ON dbo.DV_MaintenancePlan.CancelUserDR = CancelUser.RowID} ]
{

}
