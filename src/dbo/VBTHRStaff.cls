Class dbo.VBTHRStaff [ ClassType = view, CompileAfter = (dbo.BTABOBG, dbo.BTEthnicity, dbo.BTHREmployType, dbo.BTHRStaff, dbo.BTHospital, dbo.BTRHBG, dbo.BTSpecies, dbo.BTWorkGroup, dbo.SYSUser), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BTHR_Staff, ViewQuery = { SELECT     dbo.BTHR_Staff.RowID, dbo.BTHR_Staff.Code, dbo.BTHR_Staff.CName, dbo.BTHR_Staff.UserDR, dbo.BTHR_Staff.HospitalDR, dbo.BTHR_Staff.WorkGroupDR, 
 dbo.BTHR_Staff.SpeciesDR, dbo.BTHR_Staff.BirthDate, dbo.BTHR_Staff.Photo, dbo.BTHR_Staff.Sign, dbo.BTHR_Staff.NationDR, dbo.BTHR_Staff.Mobile, 
 dbo.BTHR_Staff.Phone, dbo.BTHR_Staff.Address, dbo.BTHR_Staff.PostNo, dbo.BTHR_Staff.EMail, dbo.BTHR_Staff.IDNumber, dbo.BTHR_Staff.AboDR, 
 dbo.BTHR_Staff.RhDR, dbo.BTHR_Staff.Height, dbo.BTHR_Staff.Weight, dbo.BTHR_Staff.NativePlace, dbo.BTHR_Staff.PoliticalStatus, dbo.BTHR_Staff.Faith, 
 dbo.BTHR_Staff.Married, dbo.BTHR_Staff.GraduateDate, dbo.BTHR_Staff.GraduateSchool, dbo.BTHR_Staff.Specialty, dbo.BTHR_Staff.HighestDegree, 
 dbo.BTHR_Staff.Speciality, dbo.BTHR_Staff.EntryDate, dbo.BTHR_Staff.Duty, dbo.BTHR_Staff.Rank, dbo.BTHR_Staff.EmployTypeDR, dbo.BTHR_Staff.BasicSalary, 
 dbo.BTHR_Staff.ContractDate, dbo.BTHR_Staff.ContractExpirtyDate, dbo.BTHR_Staff.WorkStatus, dbo.BTHR_Staff.DimissionDate, dbo.BTHR_Staff.DimissionReason, 
 dbo.BTHR_Staff.AddDate, dbo.BTHR_Staff.AddTime, dbo.BTHR_Staff.AddUserDR, dbo.BTHR_Staff.Remark, dbo.BTHR_Staff.Sequence, 
 dbo.SYS_User.Code AS UserCode, dbo.SYS_User.CName AS UserName, dbo.BT_Hospital.Code AS HospitalCode, dbo.BT_Hospital.CName AS HospitalName, 
 dbo.BT_WorkGroup.Code AS WorkGroupCode, dbo.BT_WorkGroup.CName AS WorkGroupName, dbo.BT_Species.Code AS SpeciesCode, 
 dbo.BT_Species.CName AS SpeciesName, dbo.BT_Ethnicity.Code AS EthnicityCode, dbo.BT_Ethnicity.CName AS EthnicityName, 
 dbo.BT_ABOBG.Code AS ABOBGCode, dbo.BT_ABOBG.CName AS ABOBGName, dbo.BT_RHBG.Code AS RHBGCode, dbo.BT_RHBG.CName AS RHBGName, 
 dbo.BTHR_EmployType.Code AS EmployTypeCode, dbo.BTHR_EmployType.CName AS EmployTypeName
 FROM         dbo.BTHR_Staff LEFT OUTER JOIN
 dbo.SYS_User ON dbo.BTHR_Staff.AddUserDR = dbo.SYS_User.RowID LEFT OUTER JOIN
 dbo.BT_Hospital ON dbo.BTHR_Staff.HospitalDR = dbo.BT_Hospital.RowID LEFT OUTER JOIN
 dbo.BT_WorkGroup ON dbo.BTHR_Staff.WorkGroupDR = dbo.BT_WorkGroup.RowID LEFT OUTER JOIN
 dbo.BT_Species ON dbo.BTHR_Staff.SpeciesDR = dbo.BT_Species.RowID LEFT OUTER JOIN
 dbo.BT_Ethnicity ON dbo.BTHR_Staff.NationDR = dbo.BT_Ethnicity.RowID LEFT OUTER JOIN
 dbo.BT_ABOBG ON dbo.BTHR_Staff.AboDR = dbo.BT_ABOBG.RowID LEFT OUTER JOIN
 dbo.BT_RHBG ON dbo.BTHR_Staff.RhDR = dbo.BT_RHBG.RowID LEFT OUTER JOIN
 dbo.BTHR_EmployType ON dbo.BTHR_Staff.EmployTypeDR = dbo.BTHR_EmployType.RowID} ]
{

}
