Class dbo.VBTOrganismAntibioticsAll [ ClassType = view, CompileAfter = (dbo.BTAntibiotics, dbo.BTOrganism, dbo.BTOrganismAnt), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_OrganismAntAll, ViewQuery = { SELECT     dbo.BT_OrganismAnt.RowID, dbo.BT_OrganismAnt.OrganismDR, dbo.BT_OrganismAnt.AntibioticsDR, dbo.BT_OrganismAnt.Reported, 
 dbo.BT_OrganismAnt.Sequence, dbo.BT_Organism.RowID AS OrganismRowID, dbo.BT_Organism.Code, dbo.BT_Organism.CName, dbo.BT_Organism.EName, 
 dbo.BT_Organism.SName, dbo.BT_Organism.WCode, dbo.BT_Organism.Gram, dbo.BT_Organism.Status, dbo.BT_Organism.OrganismGroupDR, 
 dbo.BT_Organism.GenusDR, dbo.BT_Organism.Sequence AS OrganismSequence, dbo.BT_Organism.Active, dbo.BT_Antibiotics.RowID AS AntibioticsRowID, dbo.BT_Antibiotics.Code AS AntibioticsCode, 
 dbo.BT_Antibiotics.CName AS AntibioticsCName, dbo.BT_Antibiotics.EName AS AntibioticsEName, dbo.BT_Antibiotics.SName AS AntibioticsSName, dbo.BT_Antibiotics.WCode AS AntibioticsWCode, 
 dbo.BT_Antibiotics.WhoND, dbo.BT_Antibiotics.WhoNM, dbo.BT_Antibiotics.WhoNE, dbo.BT_Antibiotics.Potency, dbo.BT_Antibiotics.Dosage1, 
 dbo.BT_Antibiotics.Surem1, dbo.BT_Antibiotics.Urine1, dbo.BT_Antibiotics.Dosage2, dbo.BT_Antibiotics.Surem2, dbo.BT_Antibiotics.Urine2, 
 dbo.BT_Antibiotics.Sequence AS AntibioticsSequence, dbo.BT_Antibiotics.Active AS AntibioticsActive
 FROM         dbo.BT_OrganismAnt LEFT OUTER JOIN
 dbo.BT_Organism ON dbo.BT_OrganismAnt.OrganismDR = dbo.BT_Organism.RowID LEFT OUTER JOIN
 dbo.BT_Antibiotics ON dbo.BT_OrganismAnt.AntibioticsDR = dbo.BT_Antibiotics.RowID} ]
{

}
