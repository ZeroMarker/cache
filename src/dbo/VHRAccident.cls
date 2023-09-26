Class dbo.VHRAccident [ ClassType = view, CompileAfter = (dbo.BTHRStaff, dbo.HRAccident, dbo.SYSUser), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_HR_Accident, ViewQuery = { SELECT     dbo.HR_Accident.RowID, dbo.HR_Accident.StaffDR, dbo.HR_Accident.AddDate, dbo.HR_Accident.AddTime, dbo.HR_Accident.AddUserDR, dbo.HR_Accident.AuthDate, 
 dbo.HR_Accident.AuthTime, dbo.HR_Accident.AuthUserDR, dbo.HR_Accident.OccurDate, dbo.HR_Accident.OccurTime, dbo.HR_Accident.Description, 
 dbo.HR_Accident.Reason, dbo.HR_Accident.Aftermath, dbo.HR_Accident.Remark, dbo.HR_Accident.CancelDate, dbo.HR_Accident.CancelTime, 
 dbo.HR_Accident.CancelUserDR, dbo.HR_Accident.CancelRemark, dbo.HR_Accident.Status, dbo.BTHR_Staff.Code AS StaffCode, dbo.BTHR_Staff.CName AS StaffName,
 AddUser.Code AS AddUserCode, AddUser.CName AS AddUserName, AuthUser.Code AS AuthUserCode, AuthUser.CName AS AuthUserName, 
 CancelUser.Code AS CancelUserCode, CancelUser.CName AS CancelUserName
 FROM         dbo.HR_Accident LEFT OUTER JOIN
 dbo.BTHR_Staff ON dbo.HR_Accident.StaffDR = dbo.BTHR_Staff.RowID LEFT OUTER JOIN
 dbo.SYS_User AS AddUser ON dbo.HR_Accident.AddUserDR = AddUser.RowID LEFT OUTER JOIN
 dbo.SYS_User AS AuthUser ON dbo.HR_Accident.AuthUserDR = AuthUser.RowID LEFT OUTER JOIN
 dbo.SYS_User AS CancelUser ON dbo.HR_Accident.CancelUserDR = CancelUser.RowID} ]
{

}
