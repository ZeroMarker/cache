Class dbo.VHRMovePositon [ ClassType = view, CompileAfter = (dbo.BTHRStaff, dbo.BTWorkGroup, dbo.HRMovePositon, dbo.SYSUser), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_HR_MovePositon, ViewQuery = { SELECT     dbo.HR_MovePositon.RowID, dbo.HR_MovePositon.StaffDR, dbo.HR_MovePositon.AddDate, dbo.HR_MovePositon.AddTime, dbo.HR_MovePositon.AddUserDR, 
 dbo.HR_MovePositon.AuthDate, dbo.HR_MovePositon.AuthTime, dbo.HR_MovePositon.AuthUserDR, dbo.HR_MovePositon.MoveDate, 
 dbo.HR_MovePositon.WorkGroupDR, dbo.HR_MovePositon.Remark, dbo.HR_MovePositon.MoveType, dbo.HR_MovePositon.CancelDate, 
 dbo.HR_MovePositon.CancelTime, dbo.HR_MovePositon.CancelUserDR, dbo.HR_MovePositon.CancelRemark, dbo.HR_MovePositon.Status, 
 dbo.BTHR_Staff.Code AS StaffCode, dbo.BTHR_Staff.CName AS StaffName, AddUser.Code AS AddUserCode, AddUser.CName AS AddUserName, 
 AuthUser.Code AS AuthUserCode, AuthUser.CName AS AuthUserName, CancelUser.Code AS CancelUserCode, CancelUser.CName AS CancelUserName, 
 dbo.BT_WorkGroup.Code AS WorkGroupCode, dbo.BT_WorkGroup.CName AS WorkGroupName
 FROM         dbo.HR_MovePositon LEFT OUTER JOIN
 dbo.BTHR_Staff ON dbo.HR_MovePositon.StaffDR = dbo.BTHR_Staff.RowID LEFT OUTER JOIN
 dbo.SYS_User AS AddUser ON dbo.HR_MovePositon.AddUserDR = AddUser.RowID LEFT OUTER JOIN
 dbo.SYS_User AS AuthUser ON dbo.HR_MovePositon.AuthUserDR = AuthUser.RowID LEFT OUTER JOIN
 dbo.SYS_User AS CancelUser ON dbo.HR_MovePositon.CancelUserDR = CancelUser.RowID LEFT OUTER JOIN
 dbo.BT_WorkGroup ON dbo.HR_MovePositon.WorkGroupDR = dbo.BT_WorkGroup.RowID} ]
{

}
