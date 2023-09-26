Class dbo.VBTAntibioticsPanelDetails [ ClassType = view, CompileAfter = (dbo.BTAntibiotics, dbo.BTAntibioticsPanel, dbo.BTAntibioticsPanelDetails), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_AntibioticsPanelDetails, ViewQuery = { SELECT     dbo.BT_AntibioticsPanelDetails.RowID, dbo.BT_AntibioticsPanelDetails.AntibioticsPanelDR, dbo.BT_AntibioticsPanelDetails.AntibioticsDR, 
 dbo.BT_AntibioticsPanelDetails.Reported, dbo.BT_AntibioticsPanelDetails.SensitivityDR, dbo.BT_AntibioticsPanelDetails.Sequence, dbo.BT_AntibioticsPanel.Code AS AntibioticsPanelCode, 
 dbo.BT_AntibioticsPanel.CName AS AntibioticsPanelName, dbo.BT_Antibiotics.Code AS AntibioticsCode, dbo.BT_Antibiotics.CName AS AntibioticsName
 FROM         dbo.BT_AntibioticsPanelDetails LEFT OUTER JOIN
 dbo.BT_AntibioticsPanel ON dbo.BT_AntibioticsPanelDetails.AntibioticsPanelDR = dbo.BT_AntibioticsPanel.RowID LEFT OUTER JOIN
 dbo.BT_Antibiotics ON dbo.BT_AntibioticsPanelDetails.AntibioticsDR = dbo.BT_Antibiotics.RowID} ]
{

}
