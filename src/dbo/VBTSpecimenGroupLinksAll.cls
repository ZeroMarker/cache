Class dbo.VBTSpecimenGroupLinksAll [ ClassType = view, CompileAfter = (dbo.BTSpecimen, dbo.BTSpecimenGroup, dbo.BTSpecimenGroupLinks), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_SpecimenGroupLinksAll, ViewQuery = { SELECT     dbo.BT_SpecimenGroupLinks.RowID, dbo.BT_SpecimenGroupLinks.SpecimenGroupDR, dbo.BT_SpecimenGroupLinks.SpecimenDR, 
 dbo.BT_SpecimenGroup.RowID AS SpecimenGroupRowID, dbo.BT_SpecimenGroup.Code, dbo.BT_SpecimenGroup.CName, dbo.BT_SpecimenGroup.HospitalDR, 
 dbo.BT_SpecimenGroup.Sequence, dbo.BT_SpecimenGroup.Active, dbo.BT_Specimen.RowID AS SpecimenRowID, dbo.BT_Specimen.Code AS SpecimenCode, dbo.BT_Specimen.IName, 
 dbo.BT_Specimen.XName, dbo.BT_Specimen.EName, dbo.BT_Specimen.HospitalDR AS SpecimenHospitalDR, dbo.BT_Specimen.HISCode, dbo.BT_Specimen.WCode, 
 dbo.BT_Specimen.SpecimenGroupDR AS SpecimenSpecimenGroupDR, dbo.BT_Specimen.Sequence AS SpecimenSequence, dbo.BT_Specimen.Active AS SpecimenActive
 FROM         dbo.BT_SpecimenGroupLinks LEFT OUTER JOIN
 dbo.BT_SpecimenGroup ON dbo.BT_SpecimenGroupLinks.SpecimenGroupDR = dbo.BT_SpecimenGroup.RowID LEFT OUTER JOIN
 dbo.BT_Specimen ON dbo.BT_SpecimenGroupLinks.SpecimenDR = dbo.BT_Specimen.RowID} ]
{

}
