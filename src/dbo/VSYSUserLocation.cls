Class dbo.VSYSUserLocation [ ClassType = view, CompileAfter = (dbo.BTLocation, dbo.SYSGroup, dbo.SYSUser, dbo.SYSUserLocation), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_SYS_UserLocation, ViewQuery = { SELECT     dbo.SYS_UserLocation.RowID, dbo.SYS_UserLocation.UserDR, dbo.SYS_UserLocation.LocationDR, dbo.SYS_UserLocation.GroupDR, 
 dbo.SYS_UserLocation.Sequence, dbo.SYS_UserLocation.IsDefault, dbo.SYS_Group.Code AS GroupCode, dbo.SYS_Group.CName AS GroupName, 
 dbo.SYS_User.Code AS UserCode, dbo.SYS_User.CName AS UserName, dbo.BT_Location.Code AS LocationCode, dbo.BT_Location.CName AS LocationName
 FROM         dbo.SYS_UserLocation LEFT OUTER JOIN
 dbo.SYS_Group ON dbo.SYS_UserLocation.GroupDR = dbo.SYS_Group.RowID LEFT OUTER JOIN
 dbo.SYS_User ON dbo.SYS_UserLocation.UserDR = dbo.SYS_User.RowID LEFT OUTER JOIN
 dbo.BT_Location ON dbo.SYS_UserLocation.LocationDR = dbo.BT_Location.RowID} ]
{

}
