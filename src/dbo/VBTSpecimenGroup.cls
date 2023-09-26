Class dbo.VBTSpecimenGroup [ ClassType = view, CompileAfter = (dbo.BTHospital, dbo.BTSpecimenGroup), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_SpecimenGroup, ViewQuery = { SELECT     dbo.BT_SpecimenGroup.RowID, dbo.BT_SpecimenGroup.Code, dbo.BT_SpecimenGroup.CName, dbo.BT_SpecimenGroup.HospitalDR, 
 dbo.BT_SpecimenGroup.Sequence, dbo.BT_SpecimenGroup.Active, dbo.BT_Hospital.Code AS HospitalCode, dbo.BT_Hospital.CName AS HospitalName
 FROM         dbo.BT_SpecimenGroup LEFT OUTER JOIN
 dbo.BT_Hospital ON dbo.BT_SpecimenGroup.HospitalDR = dbo.BT_Hospital.RowID} ]
{

}
