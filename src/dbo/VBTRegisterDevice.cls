Class dbo.VBTRegisterDevice [ ClassType = view, CompileAfter = (dbo.BTDVManufacturer, dbo.BTDVServiceCompany, dbo.BTDVSupplier, dbo.BTHospital, dbo.BTRegisterDevice, dbo.SYSUser), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_RegisterDevice, ViewQuery = { SELECT     dbo.BT_RegisterDevice.RowID, dbo.BT_RegisterDevice.Code, dbo.BT_RegisterDevice.CName, dbo.BT_RegisterDevice.LName, dbo.BT_RegisterDevice.HospitalDR, 
 dbo.BT_RegisterDevice.ModelNo, dbo.BT_RegisterDevice.DeviceManufacturerDR, dbo.BT_RegisterDevice.ProductDate, dbo.BT_RegisterDevice.DeviceID, 
 dbo.BT_RegisterDevice.SerialNo, dbo.BT_RegisterDevice.DeviceNo, dbo.BT_RegisterDevice.BuyDate, dbo.BT_RegisterDevice.CheckDate, 
 dbo.BT_RegisterDevice.CheckUserDR, dbo.BT_RegisterDevice.InStatus, dbo.BT_RegisterDevice.DeviceAgentDR, dbo.BT_RegisterDevice.DeviceServiceCoDR, 
 dbo.BT_RegisterDevice.Barcode, dbo.BT_RegisterDevice.Status, dbo.BT_RegisterDevice.ScrapDate, dbo.BT_RegisterDevice.ScrapUserDR, 
 dbo.BT_RegisterDevice.ScrapRemark, dbo.BT_RegisterDevice.AddDate, dbo.BT_RegisterDevice.AddTime, dbo.BT_RegisterDevice.AddUserDR, 
 dbo.BT_RegisterDevice.Sequence, dbo.BT_Hospital.Code AS HospitalCode, dbo.BT_Hospital.CName AS HospitalName, 
 dbo.BTDV_Manufacturer.Code AS ManufacturerCode, dbo.BTDV_Manufacturer.CName AS ManufacturerName, dbo.BTDV_Supplier.Code AS SupplierCode, 
 dbo.BTDV_Supplier.CName AS SupplierName, dbo.BTDV_Supplier.LName AS SupplierLName, dbo.BTDV_ServiceCompany.Code AS ServiceCompanyCode, 
 dbo.BTDV_ServiceCompany.CName AS ServiceCompanyName, dbo.BTDV_ServiceCompany.LName AS ServiceCompanyLName, ScrapUser.Code AS ScrapUserCode, 
 ScrapUser.CName AS ScrapUserName, AddUser.Code AS AddUserCode, AddUser.CName AS AddUserName
 FROM         dbo.BT_RegisterDevice LEFT OUTER JOIN
 dbo.BT_Hospital ON dbo.BT_RegisterDevice.HospitalDR = dbo.BT_Hospital.RowID LEFT OUTER JOIN
 dbo.BTDV_Manufacturer ON dbo.BT_RegisterDevice.DeviceManufacturerDR = dbo.BTDV_Manufacturer.RowID LEFT OUTER JOIN
 dbo.BTDV_Supplier ON dbo.BT_RegisterDevice.DeviceAgentDR = dbo.BTDV_Supplier.RowID LEFT OUTER JOIN
 dbo.BTDV_ServiceCompany ON dbo.BT_RegisterDevice.DeviceServiceCoDR = dbo.BTDV_ServiceCompany.RowID LEFT OUTER JOIN
 dbo.SYS_User AS ScrapUser ON dbo.BT_RegisterDevice.ScrapUserDR = ScrapUser.RowID LEFT OUTER JOIN
 dbo.SYS_User AS AddUser ON dbo.BT_RegisterDevice.AddUserDR = AddUser.RowID} ]
{

}
