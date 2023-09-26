Class dbo.VSYSUser [ ClassType = view, CompileAfter = (dbo.BTHospital, dbo.SYSLanguage, dbo.SYSUser), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_SYS_User, ViewQuery = { SELECT     dbo.SYS_User.RowID, dbo.SYS_User.Code, dbo.SYS_User.CName, dbo.SYS_User.Password, dbo.SYS_User.HospitalDR, dbo.SYS_User.LanguageDR, 
 dbo.SYS_User.SecurityType, dbo.SYS_User.PIN, dbo.SYS_User.Remark, dbo.SYS_User.Sequence, dbo.SYS_User.Active,dbo.SYS_User.PermissionDR, dbo.BT_Hospital.Code AS HospitalCode, 
 dbo.BT_Hospital.CName AS HospitalName, dbo.SYS_Language.Code AS LanguageCode, dbo.SYS_Language.CName AS LanguageName, dbo.SYS_Permission.Code AS PermissionCode, dbo.SYS_Permission.CName AS PermissionName
 FROM         dbo.SYS_User LEFT OUTER JOIN
 dbo.BT_Hospital ON dbo.SYS_User.HospitalDR = dbo.BT_Hospital.RowID LEFT OUTER JOIN
 dbo.SYS_Language ON dbo.SYS_User.LanguageDR = dbo.SYS_Language.RowID LEFT OUTER JOIN
 dbo.SYS_Permission ON dbo.SYS_User.PermissionDR = dbo.SYS_Permission.RowID} ]
{

}
