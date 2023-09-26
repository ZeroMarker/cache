Class dbo.VBTLocation [ ClassType = view, CompileAfter = (dbo.BTHospital, dbo.BTLocation, dbo.BTLocationClass), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_Location, ViewQuery = { SELECT     dbo.BT_Location.RowID, dbo.BT_Location.Code, dbo.BT_Location.CName, dbo.BT_Location.HospitalDR, dbo.BT_Location.HISCode, dbo.BT_Location.WCode, 
 dbo.BT_Location.Leader, dbo.BT_Location.Telephone, dbo.BT_Location.LocationTypeDR, dbo.BT_Location.Sequence, dbo.BT_Location.Active, 
 dbo.BT_Hospital.Code AS HospitalCode, dbo.BT_Hospital.CName AS HospitalName, dbo.BT_LocationClass.Code AS LocationClassCode, 
 dbo.BT_LocationClass.CName AS LocationClassName
 FROM         dbo.BT_Location LEFT OUTER JOIN
 dbo.BT_Hospital ON dbo.BT_Location.HospitalDR = dbo.BT_Hospital.RowID LEFT OUTER JOIN
 dbo.BT_LocationClass ON dbo.BT_Location.LocationTypeDR = dbo.BT_LocationClass.RowID} ]
{

}
