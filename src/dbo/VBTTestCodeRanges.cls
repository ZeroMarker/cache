Class dbo.VBTTestCodeRanges [ ClassType = view, CompileAfter = (dbo.BTClinicalConditions, dbo.BTLocation, dbo.BTSpecies, dbo.BTSpecimen, dbo.BTTestCode, dbo.BTTestCodeRanges), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_TestCodeRanges, ViewQuery = { SELECT     dbo.BT_TestCodeRanges.RowID, dbo.BT_TestCodeRanges.TestCodeDR, dbo.BT_TestCodeRanges.OrderNo, dbo.BT_TestCodeRanges.SpeciesDR, 
 dbo.BT_TestCodeRanges.AgeLow, dbo.BT_TestCodeRanges.AgeHigh,dbo.BT_TestCodeRanges.Symptom, dbo.BT_TestCodeRanges.SpecimenDR, dbo.BT_TestCodeRanges.ClinicalConditionsDR, 
 dbo.BT_TestCodeRanges.LocationDR, dbo.BT_TestCodeRanges.ValueLow, dbo.BT_TestCodeRanges.ValueHigh, dbo.BT_TestCodeRanges.PanicLow, 
 dbo.BT_TestCodeRanges.PanicHigh, dbo.BT_TestCodeRanges.UnacceptLow, dbo.BT_TestCodeRanges.UnacceptHigh, dbo.BT_TestCodeRanges.IsDefault,dbo.BT_TestCodeRanges.RefRanges, dbo.BT_TestCodeRanges.StartDate, dbo.BT_TestCodeRanges.EndDate,  dbo.BT_TestCodeRanges.SAgeLowUnitDR,  dbo.BT_TestCodeRanges.SAgeHighUnitDR,  dbo.BT_TestCodeRanges.SAgeLow,  dbo.BT_TestCodeRanges.SAgeHigh, 
 dbo.BT_TestCode.Code AS TestCodeCode, dbo.BT_TestCode.CName AS TestCodeName, dbo.BT_Species.Code AS SpeciesCode, 
 dbo.BT_Species.CName AS SpeciesName, dbo.BT_Specimen.Code AS SpecimenCode, dbo.BT_Specimen.IName AS SpecimenIName, 
 dbo.BT_Specimen.XName AS SpecimenXName, dbo.BT_ClinicalConditions.Code AS ClinicalConditionsCode, 
 dbo.BT_ClinicalConditions.CName AS ClinicalConditionsName, dbo.BT_Location.Code AS LocationCode, dbo.BT_Location.CName AS LocationName
 FROM         dbo.BT_TestCodeRanges LEFT OUTER JOIN
 dbo.BT_TestCode ON dbo.BT_TestCodeRanges.TestCodeDR = dbo.BT_TestCode.RowID LEFT OUTER JOIN
 dbo.BT_Species ON dbo.BT_TestCodeRanges.SpeciesDR = dbo.BT_Species.RowID LEFT OUTER JOIN
 dbo.BT_Specimen ON dbo.BT_TestCodeRanges.SpecimenDR = dbo.BT_Specimen.RowID LEFT OUTER JOIN
 dbo.BT_ClinicalConditions ON dbo.BT_TestCodeRanges.ClinicalConditionsDR = dbo.BT_ClinicalConditions.RowID LEFT OUTER JOIN
 dbo.BT_Location ON dbo.BT_TestCodeRanges.LocationDR = dbo.BT_Location.RowID} ]
{

}
