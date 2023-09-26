Class dbo.VRQAdmission [ ClassType = view, CompileAfter = (dbo.BTABOBG, dbo.BTAdmissionType, dbo.BTBed, dbo.BTDoctor, dbo.BTLocation, dbo.BTRHBG, dbo.BTWard, dbo.RQAdmission, dbo.SYSUser), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_RQ_Admission, ViewQuery = { 
SELECT     dbo.RQ_Admission.RowID, dbo.RQ_Admission.PatientDR, dbo.RQ_Admission.AdmissionTypeDR, dbo.RQ_Admission.AdmDate, 
 dbo.RQ_Admission.AdmTime, dbo.RQ_Admission.LocationDR, dbo.RQ_Admission.WardDR, dbo.RQ_Admission.BedDR, dbo.RQ_Admission.DoctorDR, 
 dbo.RQ_Admission.Pregnant, dbo.RQ_Admission.PregnantWeeks, dbo.RQ_Admission.CheckOut, dbo.RQ_Admission.OutDate, 
 dbo.RQ_Admission.OutTime, dbo.RQ_Admission.AddDate, dbo.RQ_Admission.AddTime, dbo.RQ_Admission.AddUserDR, 
 dbo.RQ_Admission.DiseaseDR, dbo.RQ_Admission.CancelDate, dbo.RQ_Admission.CancelTime, dbo.RQ_Admission.CancelUserDR, 
 dbo.RQ_Admission.AdmStatus, dbo.BT_AdmissionType.CName AS AdmTypeDesc, dbo.BT_Location.CName AS LocationDesc, 
 dbo.BT_Ward.CName AS WardDesc, dbo.BT_Bed.CName AS BedDesc, dbo.BT_Doctor.CName AS DoctorDesc, dbo.BT_Disease.CName AS DiseaseDesc,
 dbo.RQ_Admission.Symptom,b.CName AS AddUserDesc, c.CName AS CancelUserDesc
 FROM         dbo.RQ_Admission LEFT OUTER JOIN
 dbo.BT_AdmissionType ON dbo.RQ_Admission.AdmissionTypeDR = dbo.BT_AdmissionType.RowID LEFT OUTER JOIN
 dbo.BT_Location ON dbo.RQ_Admission.LocationDR = dbo.BT_Location.RowID LEFT OUTER JOIN
 dbo.BT_ABOBG ON dbo.RQ_Admission.RowID = dbo.BT_ABOBG.RowID LEFT OUTER JOIN
 dbo.BT_Bed ON dbo.RQ_Admission.BedDR = dbo.BT_Bed.RowID LEFT OUTER JOIN
 dbo.BT_RHBG ON dbo.RQ_Admission.RowID = dbo.BT_RHBG.RowID LEFT OUTER JOIN
 dbo.BT_Ward ON dbo.RQ_Admission.WardDR = dbo.BT_Ward.RowID LEFT OUTER JOIN
 dbo.BT_Doctor ON dbo.RQ_Admission.DoctorDR = dbo.BT_Doctor.RowID LEFT OUTER JOIN
 dbo.BT_Disease ON dbo.RQ_Admission.DiseaseDR = dbo.BT_Disease.RowID LEFT OUTER JOIN
 dbo.SYS_User AS b ON dbo.RQ_Admission.AddUserDR = b.RowID LEFT OUTER JOIN
 dbo.SYS_User AS c ON dbo.RQ_Admission.CancelUserDR = c.RowID} ]
{

}
