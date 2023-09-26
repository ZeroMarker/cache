Class dbo.VBTAnatomicalSiteSpecimen [ ClassType = view, CompileAfter = (dbo.BTAnatomicalSite, dbo.BTAnatomicalSiteSpecimen, dbo.BTSpecimen), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_AnatomicalSiteSpecimen, ViewQuery = { SELECT     dbo.BT_AnatomicalSiteSpecimen.RowID, dbo.BT_AnatomicalSiteSpecimen.AnatomicalSiteDR, dbo.BT_AnatomicalSiteSpecimen.SpecimenDR, 
 dbo.BT_AnatomicalSiteSpecimen.Sequence, dbo.BT_Specimen.Code AS SpecimenCode, dbo.BT_Specimen.IName AS SpecimenIName, 
 dbo.BT_Specimen.XName AS SpecimenXName, dbo.BT_AnatomicalSite.Code AS AnatomicalSiteCode, dbo.BT_AnatomicalSite.CName AS AnatomicalSiteName
 FROM         dbo.BT_AnatomicalSiteSpecimen LEFT OUTER JOIN
 dbo.BT_Specimen ON dbo.BT_AnatomicalSiteSpecimen.SpecimenDR = dbo.BT_Specimen.RowID LEFT OUTER JOIN
 dbo.BT_AnatomicalSite ON dbo.BT_AnatomicalSiteSpecimen.AnatomicalSiteDR = dbo.BT_AnatomicalSite.RowID} ]
{

}
