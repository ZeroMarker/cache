Class dbo.VHRJobPerformance [ ClassType = view, CompileAfter = (dbo.BTHRStaff, dbo.HRJobPerformance, dbo.SYSUser), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_HR_JobPerformance, ViewQuery = { SELECT     dbo.HR_JobPerformance.RowID, dbo.HR_JobPerformance.StaffDR, dbo.HR_JobPerformance.AddDate, dbo.HR_JobPerformance.AddTime, 
 dbo.HR_JobPerformance.AddUserDR, dbo.HR_JobPerformance.RewardDate, dbo.HR_JobPerformance.RewardTime, dbo.HR_JobPerformance.Description, 
 dbo.HR_JobPerformance.Reward, dbo.SYS_User.Code AS AddUserCode, dbo.SYS_User.CName AS AddUserName, dbo.BTHR_Staff.Code AS StaffCode, 
 dbo.BTHR_Staff.CName AS StaffName
 FROM         dbo.HR_JobPerformance LEFT OUTER JOIN
 dbo.SYS_User ON dbo.HR_JobPerformance.AddUserDR = dbo.SYS_User.RowID LEFT OUTER JOIN
 dbo.BTHR_Staff ON dbo.HR_JobPerformance.StaffDR = dbo.BTHR_Staff.RowID} ]
{

}
