Class dbo.VQCTestResultLog [ ClassType = view, CompileAfter = (dbo.QCTestResult, dbo.QCTestResultLog, dbo.SYSUser), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_QC_TestResultLog, ViewQuery = { SELECT     dbo.QC_TestResultLog.RowID, dbo.QC_TestResultLog.TestResultDR, dbo.QC_TestResultLog.AddDate, dbo.QC_TestResultLog.AddTime, 
 dbo.QC_TestResultLog.OldResult, dbo.QC_TestResultLog.OldUserDR, dbo.QC_TestResultLog.NewResult, dbo.QC_TestResultLog.AddUserDR, 
 dbo.QC_TestResultLog.Remark, dbo.QC_TestResultLog.IPAddress, dbo.QC_TestResult.LevelNo AS TestResultLevelNo, 
 dbo.QC_TestResult.SampleID AS TestResultSampleID, OldUser.Code AS OldUserCode, OldUser.CName AS OldUserName, AddUser.Code AS AddUserCode, 
 AddUser.CName AS AddUserName
 FROM         dbo.QC_TestResultLog LEFT OUTER JOIN
 dbo.QC_TestResult ON dbo.QC_TestResultLog.TestResultDR = dbo.QC_TestResult.RowID LEFT OUTER JOIN
 dbo.SYS_User AS OldUser ON dbo.QC_TestResultLog.OldUserDR = OldUser.RowID LEFT OUTER JOIN
 dbo.SYS_User AS AddUser ON dbo.QC_TestResultLog.AddUserDR = AddUser.RowID} ]
{

}
