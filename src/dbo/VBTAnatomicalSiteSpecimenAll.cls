Class dbo.VBTAnatomicalSiteSpecimenAll [ ClassType = view, CompileAfter = (dbo.BTAnatomicalSite, dbo.BTAnatomicalSiteSpecimen, dbo.BTSpecimen), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_AnatomicalSiteSpecimenAll, ViewQuery = { SELECT     dbo.BT_AnatomicalSiteSpecimen.RowID, dbo.BT_AnatomicalSiteSpecimen.AnatomicalSiteDR, dbo.BT_AnatomicalSiteSpecimen.SpecimenDR, 
 dbo.BT_AnatomicalSiteSpecimen.Sequence, dbo.BT_AnatomicalSite.RowID AS AnatomicalSiteRowID, dbo.BT_AnatomicalSite.Code, dbo.BT_AnatomicalSite.CName, 
 dbo.BT_AnatomicalSite.HospitalDR, dbo.BT_AnatomicalSite.Sequence AS AnatomicalSiteSequence, dbo.BT_AnatomicalSite.Active, dbo.BT_Specimen.RowID AS SpecimenRowID, 
 dbo.BT_Specimen.Code AS SpecimenCode, dbo.BT_Specimen.IName, dbo.BT_Specimen.XName, dbo.BT_Specimen.EName, dbo.BT_Specimen.HospitalDR AS SpecimenHospitalDR, 
 dbo.BT_Specimen.HISCode, dbo.BT_Specimen.WCode, dbo.BT_Specimen.SpecimenGroupDR, dbo.BT_Specimen.Sequence AS SpecimenSequence, 
 dbo.BT_Specimen.Active AS SpecimenActive
 FROM         dbo.BT_AnatomicalSiteSpecimen LEFT OUTER JOIN
 dbo.BT_AnatomicalSite ON dbo.BT_AnatomicalSiteSpecimen.AnatomicalSiteDR = dbo.BT_AnatomicalSite.RowID LEFT OUTER JOIN
 dbo.BT_Specimen ON dbo.BT_AnatomicalSiteSpecimen.SpecimenDR = dbo.BT_Specimen.RowID} ]
{

}
