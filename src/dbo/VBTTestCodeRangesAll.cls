Class dbo.VBTTestCodeRangesAll [ ClassType = view, CompileAfter = (dbo.BTClinicalConditions, dbo.BTLocation, dbo.BTSpecies, dbo.BTSpecimen, dbo.BTTestCode, dbo.BTTestCodeRanges), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_TestCodeRangesAll, ViewQuery = { SELECT     dbo.BT_TestCodeRanges.RowID, dbo.BT_TestCodeRanges.TestCodeDR, dbo.BT_TestCodeRanges.OrderNo, dbo.BT_TestCodeRanges.SpeciesDR, 
 dbo.BT_TestCodeRanges.AgeLow, dbo.BT_TestCodeRanges.AgeHigh, dbo.BT_TestCodeRanges.SpecimenDR, dbo.BT_TestCodeRanges.ClinicalConditionsDR, 
 dbo.BT_TestCodeRanges.LocationDR, dbo.BT_TestCodeRanges.ValueLow, dbo.BT_TestCodeRanges.ValueHigh, dbo.BT_TestCodeRanges.PanicLow, 
 dbo.BT_TestCodeRanges.PanicHigh, dbo.BT_TestCodeRanges.UnacceptLow, dbo.BT_TestCodeRanges.UnacceptHigh, dbo.BT_TestCodeRanges.IsDefault, 
 dbo.BT_TestCode.RowID AS TestCodeRowID, dbo.BT_TestCode.Code, dbo.BT_TestCode.CName, dbo.BT_TestCode.HospitalDR, dbo.BT_TestCode.LName, 
 dbo.BT_TestCode.EName, dbo.BT_TestCode.Synonym, dbo.BT_TestCode.Units, dbo.BT_TestCode.ResultFormat, dbo.BT_TestCode.Precision, 
 dbo.BT_TestCode.TestMethodDR, dbo.BT_TestCode.IsCalculate, dbo.BT_TestCode.LonicCode, dbo.BT_TestCode.SCode, dbo.BT_TestCode.SOPContent, 
 dbo.BT_TestCode.SOPFile, dbo.BT_TestCode.HISCode, dbo.BT_TestCode.CostItemDR, dbo.BT_TestCode.Price, dbo.BT_TestCode.ClinicalSignifyS, 
 dbo.BT_TestCode.ClinicalSignifyL, dbo.BT_TestCode.TestSetDR, dbo.BT_TestCode.PrintOrder, dbo.BT_TestCode.Sequence, dbo.BT_TestCode.Active, 
 dbo.BT_Specimen.RowID AS SpecimenRowID, dbo.BT_Specimen.Code AS SpecimenCode, dbo.BT_Specimen.IName, dbo.BT_Specimen.XName, dbo.BT_Specimen.EName AS SpecimenEName, 
 dbo.BT_Specimen.HospitalDR AS SpecimenHospitalDR, dbo.BT_Specimen.HISCode AS SpecimenHISCode, dbo.BT_Specimen.WCode, dbo.BT_Specimen.SpecimenGroupDR, 
 dbo.BT_Specimen.Sequence AS SpecimenSequence, dbo.BT_Specimen.Active AS SpecimenActive, dbo.BT_Species.RowID AS SpeciesRowID, dbo.BT_Species.Code AS SpeciesCode, 
 dbo.BT_Species.CName AS SpeciesCName, dbo.BT_Species.Pregnant, dbo.BT_Species.HISCode AS SpeciesHISCode, dbo.BT_Species.STDCode, 
 dbo.BT_ClinicalConditions.RowID AS ClinicalConditionsRowID, dbo.BT_ClinicalConditions.Code AS ClinicalConditionsCode, dbo.BT_ClinicalConditions.CName AS ClinicalConditionsCName, 
 dbo.BT_ClinicalConditions.Sequence AS ClinicalConditionsSequence, dbo.BT_ClinicalConditions.Active AS ClinicalConditionsActive, dbo.BT_Location.RowID AS LocationRowID, dbo.BT_Location.Code AS LocationCode, 
 dbo.BT_Location.CName AS LocationCName, dbo.BT_Location.HospitalDR AS LocationHospitalDR, dbo.BT_Location.HISCode AS LocationHISCode, dbo.BT_Location.WCode AS LocationWCode, 
 dbo.BT_Location.Leader, dbo.BT_Location.Telephone, dbo.BT_Location.LocationTypeDR, dbo.BT_Location.Sequence AS LocationSequence, 
 dbo.BT_Location.Active AS LocationActive
 FROM         dbo.BT_TestCodeRanges LEFT OUTER JOIN
 dbo.BT_TestCode ON dbo.BT_TestCodeRanges.TestCodeDR = dbo.BT_TestCode.RowID LEFT OUTER JOIN
 dbo.BT_Specimen ON dbo.BT_TestCodeRanges.SpecimenDR = dbo.BT_Specimen.RowID LEFT OUTER JOIN
 dbo.BT_Species ON dbo.BT_TestCodeRanges.SpeciesDR = dbo.BT_Species.RowID LEFT OUTER JOIN
 dbo.BT_ClinicalConditions ON dbo.BT_TestCodeRanges.ClinicalConditionsDR = dbo.BT_ClinicalConditions.RowID LEFT OUTER JOIN
 dbo.BT_Location ON dbo.BT_TestCodeRanges.LocationDR = dbo.BT_Location.RowID} ]
{

}
