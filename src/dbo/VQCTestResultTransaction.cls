Class dbo.VQCTestResultTransaction [ ClassType = view, CompileAfter = (dbo.QCTestResult, dbo.QCTestResultTransaction, dbo.SYSUser), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_QC_TestResultTransaction, ViewQuery = { SELECT     dbo.QC_TestResultTransaction.RowID, dbo.QC_TestResultTransaction.TestResultDR, dbo.QC_TestResultTransaction.AddDate, 
 dbo.QC_TestResultTransaction.AddTime, dbo.QC_TestResultTransaction.AddUserDR, dbo.QC_TestResultTransaction.Remark, 
 dbo.QC_TestResultTransaction.Reported, dbo.QC_TestResult.LevelNo AS TestResultLevelNo, dbo.QC_TestResult.SampleID AS TestResultSampleID, 
 AddUser.Code AS AddUserCode, AddUser.CName AS AddUserName
 FROM         dbo.QC_TestResultTransaction LEFT OUTER JOIN
 dbo.QC_TestResult ON dbo.QC_TestResultTransaction.TestResultDR = dbo.QC_TestResult.RowID LEFT OUTER JOIN
 dbo.SYS_User AS AddUser ON dbo.QC_TestResultTransaction.AddUserDR = AddUser.RowID} ]
{

}
