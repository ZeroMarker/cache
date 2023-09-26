Class dbo.VBTAnatomicalSite [ ClassType = view, CompileAfter = (dbo.BTAnatomicalSite, dbo.BTHospital), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_AnatomicalSite, ViewQuery = { SELECT     dbo.BT_AnatomicalSite.RowID, dbo.BT_AnatomicalSite.Code, dbo.BT_AnatomicalSite.CName, dbo.BT_AnatomicalSite.HospitalDR, dbo.BT_AnatomicalSite.Sequence, 
 dbo.BT_AnatomicalSite.Active, dbo.BT_Hospital.Code AS HospitalCode, dbo.BT_Hospital.CName AS HospitalName
 FROM         dbo.BT_AnatomicalSite LEFT OUTER JOIN
 dbo.BT_Hospital ON dbo.BT_AnatomicalSite.HospitalDR = dbo.BT_Hospital.RowID} ]
{

}
