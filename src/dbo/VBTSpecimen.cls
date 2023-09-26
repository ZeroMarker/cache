Class dbo.VBTSpecimen [ ClassType = view, CompileAfter = (dbo.BTHospital, dbo.BTSpecimen, dbo.BTSpecimenGroup), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_Specimen, ViewQuery = { SELECT     dbo.BT_Specimen.RowID, dbo.BT_Specimen.Code, dbo.BT_Specimen.IName, dbo.BT_Specimen.XName, dbo.BT_Specimen.EName, dbo.BT_Specimen.HospitalDR, 
 dbo.BT_Specimen.HISCode, dbo.BT_Specimen.WCode, dbo.BT_Specimen.SpecimenGroupDR, dbo.BT_Specimen.Sequence, dbo.BT_Specimen.Active, 
 dbo.BT_SpecimenGroup.Code AS SpecimenGroupCode, dbo.BT_SpecimenGroup.CName AS SpecimenGroupName, dbo.BT_Hospital.Code AS HospitalCode, 
 dbo.BT_Hospital.CName AS HospitalName, dbo.BT_Specimen.CollectPrompt
 FROM         dbo.BT_Specimen LEFT OUTER JOIN
 dbo.BT_Hospital ON dbo.BT_Specimen.HospitalDR = dbo.BT_Hospital.RowID LEFT OUTER JOIN
 dbo.BT_SpecimenGroup ON dbo.BT_Specimen.SpecimenGroupDR = dbo.BT_SpecimenGroup.RowID} ]
{

}
