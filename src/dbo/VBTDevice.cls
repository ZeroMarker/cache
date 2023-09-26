Class dbo.VBTDevice [ ClassType = view, CompileAfter = (dbo.BTDVServiceCompany, dbo.BTDevice, dbo.BTHospital, dbo.BTRegisterDevice, dbo.BTWorkGroup), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_Device, ViewQuery = { SELECT     dbo.BT_Device.RowID, dbo.BT_Device.Code, dbo.BT_Device.CName, dbo.BT_Device.LName, dbo.BT_Device.HospitalDR, dbo.BT_Device.WorkGroupDR, 
 dbo.BT_Device.RegisterDeviceDR, dbo.BT_Device.ServiceCompanyDR, dbo.BT_Device.Sequence, dbo.BT_Device.Active, dbo.BT_Hospital.Code AS HospitalCode, 
 dbo.BT_Hospital.CName AS HospitalName, dbo.BT_WorkGroup.Code AS WorkGroupCode, dbo.BT_WorkGroup.CName AS WorkGroupName, 
 dbo.BT_RegisterDevice.Code AS RegisterDeviceCode, dbo.BT_RegisterDevice.CName AS RegisterDeviceName, 
 dbo.BT_RegisterDevice.LName AS RegisterDeviceLName, dbo.BTDV_ServiceCompany.Code AS ServiceCompanyCode, 
 dbo.BTDV_ServiceCompany.CName AS ServiceCompanyName, dbo.BTDV_ServiceCompany.LName AS ServiceCompanyLName
 FROM         dbo.BT_Device LEFT OUTER JOIN
 dbo.BT_Hospital ON dbo.BT_Device.HospitalDR = dbo.BT_Hospital.RowID LEFT OUTER JOIN
 dbo.BT_WorkGroup ON dbo.BT_Device.WorkGroupDR = dbo.BT_WorkGroup.RowID LEFT OUTER JOIN
 dbo.BTDV_ServiceCompany ON dbo.BT_Device.ServiceCompanyDR = dbo.BTDV_ServiceCompany.RowID LEFT OUTER JOIN
 dbo.BT_RegisterDevice ON dbo.BT_Device.RegisterDeviceDR = dbo.BT_RegisterDevice.RowID} ]
{

}
