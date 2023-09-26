Class dbo.VBTSpecimenGroupLinks [ ClassType = view, CompileAfter = (dbo.BTSpecimen, dbo.BTSpecimenGroup, dbo.BTSpecimenGroupLinks), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_SpecimenGroupLinks, ViewQuery = { SELECT     dbo.BT_SpecimenGroupLinks.RowID, dbo.BT_SpecimenGroupLinks.SpecimenGroupDR, dbo.BT_SpecimenGroupLinks.SpecimenDR, 
 dbo.BT_SpecimenGroup.Code AS SpecimenGroupCode, dbo.BT_SpecimenGroup.CName AS SpecimenGroupName, dbo.BT_Specimen.Code AS SpecimenCode, 
 dbo.BT_Specimen.IName AS SpecimenIName, dbo.BT_Specimen.XName AS SpecimenXName
 FROM         dbo.BT_SpecimenGroupLinks LEFT OUTER JOIN
 dbo.BT_Specimen ON dbo.BT_SpecimenGroupLinks.SpecimenDR = dbo.BT_Specimen.RowID LEFT OUTER JOIN
 dbo.BT_SpecimenGroup ON dbo.BT_SpecimenGroupLinks.SpecimenGroupDR = dbo.BT_SpecimenGroup.RowID} ]
{

}
