Class dbo.VBTTestCodeComments [ ClassType = view, CompileAfter = (dbo.BTTestCode, dbo.BTTestCodeComments), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_TestCodeComments, ViewQuery = { SELECT     dbo.BT_TestCodeComments.RowID, dbo.BT_TestCodeComments.TestCodeDR, dbo.BT_TestCodeComments.Code, dbo.BT_TestCodeComments.CName, 
 dbo.BT_TestCodeComments.AbFlag, dbo.BT_TestCodeComments.Sequence, dbo.BT_TestCodeComments.Active, dbo.BT_TestCode.Code AS TestCodeCode, 
 dbo.BT_TestCode.CName AS TestCodeName
 FROM         dbo.BT_TestCodeComments LEFT OUTER JOIN
 dbo.BT_TestCode ON dbo.BT_TestCodeComments.TestCodeDR = dbo.BT_TestCode.RowID} ]
{

}
