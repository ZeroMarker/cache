Class dbo.VBTTestCode [ ClassType = view, CompileAfter = (dbo.BTCostItem, dbo.BTHospital, dbo.BTTestCode, dbo.BTTestMethod, dbo.BTTestSet), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_TestCode, ViewQuery = { SELECT     dbo.BT_TestCode.RowID, dbo.BT_TestCode.Code, dbo.BT_TestCode.CName, dbo.BT_TestCode.HospitalDR, dbo.BT_TestCode.LName, dbo.BT_TestCode.EName, 
 dbo.BT_TestCode.Synonym, dbo.BT_TestCode.Units, dbo.BT_TestCode.ResultFormat, dbo.BT_TestCode.Precision, dbo.BT_TestCode.TestMethodDR, 
 dbo.BT_TestCode.IsCalculate, dbo.BT_TestCode.LonicCode, dbo.BT_TestCode.SCode, dbo.BT_TestCode.SOPContent, dbo.BT_TestCode.SOPFile, dbo.BT_TestCode.CalculateFormula,
 dbo.BT_TestCode.HISCode, dbo.BT_TestCode.CostItemDR, dbo.BT_TestCode.Price, dbo.BT_TestCode.ClinicalSignifyS, dbo.BT_TestCode.ClinicalSignifyL, 
 dbo.BT_TestCode.TestSetDR, dbo.BT_TestCode.PrintOrder, dbo.BT_TestCode.Sequence, dbo.BT_TestCode.Active, dbo.BT_Hospital.Code AS HospitalCode, 
 dbo.BT_Hospital.CName AS HospitalName, dbo.BT_TestMethod.CName AS TestMethodName, dbo.BT_CostItem.Code AS CostItemCode, 
 dbo.BT_CostItem.CName AS CostItemName, dbo.BT_TestSet.Code AS TestSetCode, dbo.BT_TestSet.CName AS TestSetName
 FROM         dbo.BT_TestCode LEFT OUTER JOIN
 dbo.BT_Hospital ON dbo.BT_TestCode.HospitalDR = dbo.BT_Hospital.RowID LEFT OUTER JOIN
 dbo.BT_TestMethod ON dbo.BT_TestCode.TestMethodDR = dbo.BT_TestMethod.RowID LEFT OUTER JOIN
 dbo.BT_CostItem ON dbo.BT_TestCode.CostItemDR = dbo.BT_CostItem.RowID LEFT OUTER JOIN
 dbo.BT_TestSet ON dbo.BT_TestCode.TestSetDR = dbo.BT_TestSet.RowID} ]
{

}
