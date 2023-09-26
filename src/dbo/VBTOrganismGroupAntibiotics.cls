Class dbo.VBTOrganismGroupAntibiotics [ ClassType = view, CompileAfter = (dbo.BTAntibiotics, dbo.BTOrganismGroup, dbo.BTSensitivity, dbo.BTAntibioticsGroup, dbo.BTOrganismGroupAnt), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_OrganismGroupAntibiotics, ViewQuery = { SELECT     dbo.BT_OrganismGroupAnt.RowID, dbo.BT_OrganismGroupAnt.OrganismGroupDR, dbo.BT_OrganismGroupAnt.AntibioticsDR,  dbo.BT_OrganismGroupAnt.SensitivityDR,  dbo.BT_OrganismGroupAnt.AntibioticsGroupDR, 
 dbo.BT_OrganismGroupAnt.Reported, dbo.BT_OrganismGroupAnt.Sequence, dbo.BT_OrganismGroup.Code AS OrganismGroupCode, 
 dbo.BT_OrganismGroup.CName AS OrganismGroupName, dbo.BT_Antibiotics.Code AS AntibioticsCode, dbo.BT_Antibiotics.CName AS AntibioticsName,
 dbo.BT_AntibioticsGroup.Code AS AntibioticsGroupCode, dbo.BT_AntibioticsGroup.CName AS AntibioticsGroupName,
  dbo.BT_Sensitivity.Code AS SensitivityCode, dbo.BT_Sensitivity.CName AS SensitivityName
 FROM         dbo.BT_OrganismGroupAnt LEFT OUTER JOIN
 dbo.BT_OrganismGroup ON dbo.BT_OrganismGroupAnt.OrganismGroupDR = dbo.BT_OrganismGroup.RowID LEFT OUTER JOIN
 dbo.BT_AntibioticsGroup ON dbo.BT_OrganismGroupAnt.AntibioticsGroupDR = dbo.BT_AntibioticsGroup.RowID LEFT OUTER JOIN
 dbo.BT_Sensitivity ON dbo.BT_OrganismGroupAnt.SensitivityDR = dbo.BT_Sensitivity.RowID LEFT OUTER JOIN
 dbo.BT_Antibiotics ON dbo.BT_OrganismGroupAnt.AntibioticsDR = dbo.BT_Antibiotics.RowID} ]
{

}
