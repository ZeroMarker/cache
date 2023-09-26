Class dbo.VBTOrganism [ ClassType = view, CompileAfter = (dbo.BTGenus, dbo.BTOrganism, dbo.BTOrganismGroup), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_Organism, ViewQuery = { SELECT     dbo.BT_Organism.RowID, dbo.BT_Organism.Code, dbo.BT_Organism.CName, dbo.BT_Organism.EName, dbo.BT_Organism.SName, dbo.BT_Organism.WCode, 
 dbo.BT_Organism.Gram, dbo.BT_Organism.Status, dbo.BT_Organism.OrganismGroupDR, dbo.BT_Organism.GenusDR, dbo.BT_Organism.Sequence, 
 dbo.BT_Organism.Active, dbo.BT_OrganismGroup.Code AS OrganismGroupCode, dbo.BT_OrganismGroup.CName AS OrganismGroupName, 
 dbo.BT_Genus.Code AS GenusCode, dbo.BT_Genus.CName AS GenusName
 FROM         dbo.BT_Organism LEFT OUTER JOIN
 dbo.BT_OrganismGroup ON dbo.BT_Organism.OrganismGroupDR = dbo.BT_OrganismGroup.RowID LEFT OUTER JOIN
 dbo.BT_Genus ON dbo.BT_Organism.GenusDR = dbo.BT_Genus.RowID} ]
{

}
