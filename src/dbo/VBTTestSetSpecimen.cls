Class dbo.VBTTestSetSpecimen [ ClassType = view, CompileAfter = (dbo.BTContainer, dbo.BTSpecimen, dbo.BTTestSet, dbo.BTTestSetSpecimen), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_TestSetSpecimen, ViewQuery = { SELECT     dbo.BT_TestSetSpecimen.RowID, dbo.BT_TestSetSpecimen.TestSetDR, dbo.BT_TestSetSpecimen.SpecimenDR, dbo.BT_TestSetSpecimen.ContainerDR, 
 dbo.BT_TestSetSpecimen.MergeType, dbo.BT_TestSetSpecimen.IsDefault, dbo.BT_TestSetSpecimen.Sequence, dbo.BT_TestSet.Code AS TestSetCode, 
 dbo.BT_TestSet.CName AS TestSetName, dbo.BT_Specimen.Code AS SpecimenCode, dbo.BT_Specimen.IName AS SpecimenIName, 
 dbo.BT_Specimen.XName AS SpecimenXName, dbo.BT_Container.Code AS ContainerCode, dbo.BT_Container.CName AS ContainerName
 FROM         dbo.BT_TestSetSpecimen LEFT OUTER JOIN
 dbo.BT_TestSet ON dbo.BT_TestSetSpecimen.TestSetDR = dbo.BT_TestSet.RowID LEFT OUTER JOIN
 dbo.BT_Specimen ON dbo.BT_TestSetSpecimen.SpecimenDR = dbo.BT_Specimen.RowID LEFT OUTER JOIN
 dbo.BT_Container ON dbo.BT_TestSetSpecimen.ContainerDR = dbo.BT_Container.RowID} ]
{

}
