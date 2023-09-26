Class dbo.VBTDepartment [ ClassType = view, CompileAfter = (dbo.BTDepartment, dbo.BTHospital), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_Department, ViewQuery = { SELECT     dbo.BT_Department.RowID, dbo.BT_Department.Code, dbo.BT_Department.CName, dbo.BT_Department.HospitalDR, dbo.BT_Department.Sequence, 
 dbo.BT_Department.Active, dbo.BT_Hospital.Code AS HospitalCode, dbo.BT_Hospital.CName AS HospitalName
 FROM         dbo.BT_Department LEFT OUTER JOIN
 dbo.BT_Hospital ON dbo.BT_Department.HospitalDR = dbo.BT_Hospital.RowID} ]
{

}
