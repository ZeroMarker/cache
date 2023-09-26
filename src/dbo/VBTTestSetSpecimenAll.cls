Class dbo.VBTTestSetSpecimenAll [ ClassType = view, CompileAfter = (dbo.BTContainer, dbo.BTSpecimen, dbo.BTTestSet, dbo.BTTestSetSpecimen), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_TestSetSpecimenAll, ViewQuery = { SELECT     dbo.BT_TestSetSpecimen.RowID, dbo.BT_TestSetSpecimen.TestSetDR, dbo.BT_TestSetSpecimen.SpecimenDR, dbo.BT_TestSetSpecimen.ContainerDR, 
 dbo.BT_TestSetSpecimen.MergeType, dbo.BT_TestSetSpecimen.IsDefault, dbo.BT_TestSetSpecimen.Sequence, dbo.BT_TestSet.RowID AS Expr1, 
 dbo.BT_TestSet.Code, dbo.BT_TestSet.CName, dbo.BT_TestSet.HospitalDR, dbo.BT_TestSet.EName, dbo.BT_TestSet.Description, dbo.BT_TestSet.HISCode, 
 dbo.BT_TestSet.SpeciesDR, dbo.BT_TestSet.Urgent, dbo.BT_TestSet.WorkGroupMachineDR, dbo.BT_TestSet.SpecimenDR AS Expr2, dbo.BT_TestSet.ContainerDR AS Expr3, 
 dbo.BT_TestSet.MergeType AS Expr4, dbo.BT_TestSet.CostItemDR, dbo.BT_TestSet.CollectPromptDR, dbo.BT_TestSet.ReportPromptDR, 
 dbo.BT_TestSet.Sequence AS Expr5, dbo.BT_TestSet.Active, dbo.BT_Specimen.RowID AS Expr6, dbo.BT_Specimen.Code AS Expr7, dbo.BT_Specimen.IName, 
 dbo.BT_Specimen.XName, dbo.BT_Specimen.EName AS Expr8, dbo.BT_Specimen.HospitalDR AS Expr9, dbo.BT_Specimen.HISCode AS Expr10, 
 dbo.BT_Specimen.WCode, dbo.BT_Specimen.SpecimenGroupDR, dbo.BT_Specimen.Sequence AS Expr11, dbo.BT_Specimen.Active AS Expr12, 
 dbo.BT_Container.RowID AS Expr13, dbo.BT_Container.Code AS Expr14, dbo.BT_Container.CName AS Expr15, dbo.BT_Container.HospitalDR AS Expr16, 
 dbo.BT_Container.Volumn, dbo.BT_Container.Color, dbo.BT_Container.Remark, dbo.BT_Container.Sequence AS Expr17, dbo.BT_Container.Active AS Expr18
 FROM         dbo.BT_TestSetSpecimen LEFT OUTER JOIN
 dbo.BT_TestSet ON dbo.BT_TestSetSpecimen.TestSetDR = dbo.BT_TestSet.RowID LEFT OUTER JOIN
 dbo.BT_Specimen ON dbo.BT_TestSetSpecimen.SpecimenDR = dbo.BT_Specimen.RowID LEFT OUTER JOIN
 dbo.BT_Container ON dbo.BT_TestSetSpecimen.ContainerDR = dbo.BT_Container.RowID} ]
{

}
