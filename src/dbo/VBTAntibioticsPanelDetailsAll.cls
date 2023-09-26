Class dbo.VBTAntibioticsPanelDetailsAll [ ClassType = view, CompileAfter = (dbo.BTAntibiotics, dbo.BTAntibioticsPanel, dbo.BTAntibioticsPanelDetails), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_AntibioticsPanelDetailsAll, ViewQuery = { SELECT     dbo.BT_AntibioticsPanelDetails.RowID, dbo.BT_AntibioticsPanelDetails.AntibioticsPanelDR, dbo.BT_AntibioticsPanelDetails.AntibioticsDR, 
 dbo.BT_AntibioticsPanelDetails.Reported, dbo.BT_AntibioticsPanelDetails.Sequence, dbo.BT_AntibioticsPanel.RowID AS AntibioticsPanelRowID, dbo.BT_AntibioticsPanel.Code, 
 dbo.BT_AntibioticsPanel.CName, dbo.BT_AntibioticsPanel.Sequence AS AntibioticsPanelSequence, dbo.BT_AntibioticsPanel.Active, dbo.BT_Antibiotics.RowID AS AntibioticsRowID, 
 dbo.BT_Antibiotics.Code AS AntibioticsCode, dbo.BT_Antibiotics.CName AS AntibioticsCName, dbo.BT_Antibiotics.EName, dbo.BT_Antibiotics.SName, dbo.BT_Antibiotics.WCode, 
 dbo.BT_Antibiotics.WhoND, dbo.BT_Antibiotics.WhoNM, dbo.BT_Antibiotics.WhoNE, dbo.BT_Antibiotics.Potency, dbo.BT_Antibiotics.Dosage1, 
 dbo.BT_Antibiotics.Surem1, dbo.BT_Antibiotics.Urine1, dbo.BT_Antibiotics.Dosage2, dbo.BT_Antibiotics.Surem2, dbo.BT_Antibiotics.Urine2, 
 dbo.BT_Antibiotics.Sequence AS AntibioticsSequence, dbo.BT_Antibiotics.Active AS AntibioticsActive
 FROM         dbo.BT_AntibioticsPanelDetails LEFT OUTER JOIN
 dbo.BT_AntibioticsPanel ON dbo.BT_AntibioticsPanelDetails.AntibioticsPanelDR = dbo.BT_AntibioticsPanel.RowID LEFT OUTER JOIN
 dbo.BT_Antibiotics ON dbo.BT_AntibioticsPanelDetails.AntibioticsDR = dbo.BT_Antibiotics.RowID} ]
{

}
