Class dbo.VBTDisease [ ClassType = view, CompileAfter = (dbo.BTDisease, dbo.BTSpecies), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_Disease, ViewQuery = { SELECT     dbo.BT_Disease.RowID, dbo.BT_Disease.Code, dbo.BT_Disease.CodeClass, dbo.BT_Disease.CName, dbo.BT_Disease.LName, dbo.BT_Disease.EName, 
 dbo.BT_Disease.Serious, dbo.BT_Disease.SpeciesDR, dbo.BT_Disease.AgeLow, dbo.BT_Disease.AgeHigh, dbo.BT_Disease.Sequence, dbo.BT_Disease.Active, 
 dbo.BT_Species.Code AS SpeciesCode, dbo.BT_Species.CName AS SpeciesName
 FROM         dbo.BT_Disease LEFT OUTER JOIN
 dbo.BT_Species ON dbo.BT_Disease.SpeciesDR = dbo.BT_Species.RowID} ]
{

}
