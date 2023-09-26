Class dbo.VBTOrganismAntibiotics [ ClassType = view, CompileAfter = (dbo.BTAntibiotics, dbo.BTOrganism, dbo.BTOrganismAnt), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_OrganismAnt, ViewQuery = { SELECT     dbo.BT_OrganismAnt.RowID, dbo.BT_OrganismAnt.OrganismDR, dbo.BT_OrganismAnt.AntibioticsDR, dbo.BT_OrganismAnt.Reported, 
 dbo.BT_OrganismAnt.Sequence, dbo.BT_Organism.Code AS OrganismCode, dbo.BT_Organism.CName AS OrganismName, 
 dbo.BT_Antibiotics.Code AS AntibioticsCode, dbo.BT_Antibiotics.CName AS AntibioticsName
 FROM         dbo.BT_OrganismAnt LEFT OUTER JOIN
 dbo.BT_Organism ON dbo.BT_OrganismAnt.OrganismDR = dbo.BT_Organism.RowID LEFT OUTER JOIN
 dbo.BT_Antibiotics ON dbo.BT_OrganismAnt.AntibioticsDR = dbo.BT_Antibiotics.RowID} ]
{

}
