Class dbo.VBTOrganismGroupAntibioticsAll [ ClassType = view, CompileAfter = (dbo.BTAntibiotics, dbo.BTOrganismGroup, dbo.BTOrganismGroupAnt), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_OrganismGroupAntAll, ViewQuery = { SELECT     dbo.BT_OrganismGroupAnt.RowID, dbo.BT_OrganismGroupAnt.OrganismGroupDR, dbo.BT_OrganismGroupAnt.AntibioticsDR, 
 dbo.BT_OrganismGroupAnt.Reported, dbo.BT_OrganismGroupAnt.Sequence, dbo.BT_OrganismGroup.RowID AS OrganismGroupRowID, dbo.BT_OrganismGroup.Code, 
 dbo.BT_OrganismGroup.CName, dbo.BT_OrganismGroup.Sequence AS OrganismGroupSequence, dbo.BT_OrganismGroup.Active, dbo.BT_Antibiotics.RowID AS AntibioticsRowID, 
 dbo.BT_Antibiotics.Code AS AntibioticsCode, dbo.BT_Antibiotics.CName AS AntibioticsCName, dbo.BT_Antibiotics.EName, dbo.BT_Antibiotics.SName, dbo.BT_Antibiotics.WCode, 
 dbo.BT_Antibiotics.WhoND, dbo.BT_Antibiotics.WhoNM, dbo.BT_Antibiotics.WhoNE, dbo.BT_Antibiotics.Potency, dbo.BT_Antibiotics.Dosage1, 
 dbo.BT_Antibiotics.Surem1, dbo.BT_Antibiotics.Urine1, dbo.BT_Antibiotics.Dosage2, dbo.BT_Antibiotics.Surem2, dbo.BT_Antibiotics.Urine2, 
 dbo.BT_Antibiotics.Sequence AS AntibioticsSequence, dbo.BT_Antibiotics.Active AS AntibioticsActive
 FROM         dbo.BT_OrganismGroupAnt LEFT OUTER JOIN
 dbo.BT_OrganismGroup ON dbo.BT_OrganismGroupAnt.OrganismGroupDR = dbo.BT_OrganismGroup.RowID LEFT OUTER JOIN
 dbo.BT_Antibiotics ON dbo.BT_OrganismGroupAnt.AntibioticsDR = dbo.BT_Antibiotics.RowID} ]
{

}
