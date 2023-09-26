Class dbo.VRPCarryDetails [ ClassType = view, CompileAfter = (dbo.BTLocation, dbo.RPCarry, dbo.RPCarryDetails, dbo.RPVisitNumber, dbo.SYSUser), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_RP_CarryDetails, ViewQuery = { 
SELECT     dbo.RP_CarryDetails.RowID, dbo.RP_CarryDetails.CarryDR, dbo.RP_CarryDetails.OrderNo, dbo.RP_CarryDetails.VisitNumberDR, 
 dbo.RP_VisitNumber.VisitNumber, dbo.RP_CarryDetails.PackDR, dbo.RP_CarryDetails.Status, dbo.RP_CarryDetails.Notes, 
 dbo.RP_CarryDetails.AddDate, dbo.RP_CarryDetails.AddTime, dbo.RP_CarryDetails.AddUserDR, dbo.RP_Carry.CarryNo, dbo.RP_Carry.HospitalDR, 
 dbo.RP_Carry.ReceiveDate, dbo.RP_Carry.ReceiveTime, dbo.RP_Carry.ReceiveUserDR, dbo.RP_Carry.CarryUserDR, dbo.RP_Carry.CarryUserName, 
 dbo.RP_Carry.ContainerNo, dbo.RP_Carry.CarryType, dbo.RP_Carry.LocationDR, dbo.BT_Location.CName AS LocationDesc, 
 dbo.RP_Carry.AddDate AS CarryAddDate, dbo.RP_Carry.AddTime AS CarryAddTime, dbo.RP_Carry.AddUserDR AS CarryAddUserDR, 
 dbo.RP_Carry.Status AS CarryStatus, b.CName AS AddUserDesc, c.CName AS ReceiveUserDesc, d.CName AS CarryAddUser
 FROM         dbo.RP_CarryDetails INNER JOIN
 dbo.RP_Carry ON dbo.RP_CarryDetails.CarryDR = dbo.RP_Carry.RowID INNER JOIN
 dbo.RP_VisitNumber ON dbo.RP_CarryDetails.VisitNumberDR = dbo.RP_VisitNumber.RowID INNER JOIN
 dbo.BT_Location ON dbo.RP_Carry.LocationDR = dbo.BT_Location.RowID LEFT OUTER JOIN
 dbo.SYS_User AS b ON dbo.RP_CarryDetails.AddUserDR = b.RowID LEFT OUTER JOIN
 dbo.SYS_User AS c ON dbo.RP_Carry.ReceiveUserDR = c.RowID LEFT OUTER JOIN
 dbo.SYS_User AS d ON dbo.RP_Carry.AddUserDR = d.RowID} ]
{

}
