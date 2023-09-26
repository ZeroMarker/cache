Class dbo.VBTDoctor [ ClassType = view, CompileAfter = (dbo.BTDoctor, dbo.BTHospital, dbo.BTPositionTitle), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_Doctor, ViewQuery = { SELECT     dbo.BT_Doctor.RowID, dbo.BT_Doctor.Code, dbo.BT_Doctor.CName, dbo.BT_Doctor.HISCode, dbo.BT_Doctor.HospitalDR, dbo.BT_Doctor.Telephone, 
 dbo.BT_Doctor.PositionTitleDR, dbo.BT_Doctor.Sequence, dbo.BT_Doctor.Active, dbo.BT_Hospital.Code AS HospitalCode, dbo.BT_Hospital.CName AS HospitalName, 
 dbo.BT_PositionTitle.Code AS PositionTitleCode, dbo.BT_PositionTitle.CName AS PositionTitleName
 FROM         dbo.BT_Doctor LEFT OUTER JOIN
 dbo.BT_Hospital ON dbo.BT_Doctor.HospitalDR = dbo.BT_Hospital.RowID LEFT OUTER JOIN
 dbo.BT_PositionTitle ON dbo.BT_Doctor.PositionTitleDR = dbo.BT_PositionTitle.RowID} ]
{

}
