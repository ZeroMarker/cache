Class dbo.VHRFurtherEducation [ ClassType = view, CompileAfter = (dbo.BTHRStaff, dbo.HRFurtherEducation, dbo.SYSUser), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_HR_FurtherEducation, ViewQuery = { SELECT     dbo.HR_FurtherEducation.RowID, dbo.HR_FurtherEducation.StaffDR, dbo.HR_FurtherEducation.AddDate, dbo.HR_FurtherEducation.AddTime, 
 dbo.HR_FurtherEducation.AddUserDR, dbo.HR_FurtherEducation.StartDate, dbo.HR_FurtherEducation.StartTime, dbo.HR_FurtherEducation.EndDate, 
 dbo.HR_FurtherEducation.EndTime, dbo.HR_FurtherEducation.SubjectName, dbo.HR_FurtherEducation.StudyType, dbo.HR_FurtherEducation.Credit, 
 dbo.HR_FurtherEducation.Score, dbo.HR_FurtherEducation.Comment, dbo.SYS_User.Code AS AddUserCode, dbo.SYS_User.CName AS AddUserName, 
 dbo.BTHR_Staff.Code AS StaffCode, dbo.BTHR_Staff.CName AS StaffName
 FROM         dbo.HR_FurtherEducation LEFT OUTER JOIN
 dbo.SYS_User ON dbo.HR_FurtherEducation.AddUserDR = dbo.SYS_User.RowID LEFT OUTER JOIN
 dbo.BTHR_Staff ON dbo.HR_FurtherEducation.StaffDR = dbo.BTHR_Staff.RowID} ]
{

}
