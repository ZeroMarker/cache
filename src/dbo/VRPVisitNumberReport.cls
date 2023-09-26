Class dbo.VRPVisitNumberReport [ ClassType = view, CompileAfter = (dbo.BTWorkGroupMachine, dbo.RPVisitNumberReport, dbo.SYSUser), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_RP_VisitNumberReport, ViewQuery = { 
 SELECT c0.RowID as ReportDR,
c1.VisitNumber,
c1.SurName As PatName,
c2.CName AS Species,
c1.Age||c3.CName AS Age,
substr(c1.BirthDate,1,4) _'-'_ substr(c1.BirthDate,5,2) _'-'_ substr(c1.BirthDate,7,2) AS BirthDate,
c1.RegNo,
c1.MedicalRecordNo AS HospNo,
c1.AdmNo,
c4.CName AS AdmType,
c5.Code AS SpecimenCode,
c5.IName AS SpecimenName,
c6.Code AS ContainerCode,
c6.CName AS ContainerName,
c6.Color AS Color,
c7.Code AS LocationCode,
c7.CName AS LocationName,
c8.Code AS WardCode,
c8.CName AS WardName,
c1.BedNo,
c1.Symptom AS Diagnose,
c9.Code AS DoctorCode,
c9.CName AS DoctorName,
substr(c1.RequestDate,1,4) _'-'_ substr(c1.RequestDate,5,2) _'-'_ substr(c1.RequestDate,7,2) AS RequestDate,
TO_CHAR(c1.RequestTime, 'HH24:MI:SS') AS RequestTime,
c10.Code AS CollectUserCode,
c10.CName AS CollectUserName,
substr(c1.CollectDate,1,4) _'-'_ substr(c1.CollectDate,5,2) _'-'_ substr(c1.CollectDate,7,2) AS CollectDate,
TO_CHAR(c1.CollectTime, 'HH24:MI:SS') AS CollectTime,
c15.Code AS CarryUserCode,
c15.CName AS CarryUserName,
substr(c1.CarryDate,1,4) _'-'_ substr(c1.CarryDate,5,2) _'-'_ substr(c1.CarryDate,7,2) AS CarryDate,
TO_CHAR(c1.CarryTime, 'HH24:MI:SS') AS CarryTime,
c16.Code AS ReceiveUserCode,
c16.CName AS ReceiveUserName,
substr(c1.ReceiveDate,1,4) _'-'_ substr(c1.ReceiveDate,5,2) _'-'_ substr(c1.ReceiveDate,7,2) AS ReceiveDate,
TO_CHAR(c1.ReceiveTime, 'HH24:MI:SS') AS ReceiveTime,
c17.Code AS AcceptUserCode,
c17.CName AS AcceptUserName,
substr(c0.AcceptDate,1,4) _'-'_ substr(c0.AcceptDate,5,2) _'-'_ substr(c0.AcceptDate,7,2) AS AcceptDate,
TO_CHAR(c0.AcceptTime, 'HH24:MI:SS') AS AcceptTime,
c18.Code AS EntryUserCode,
c18.CName AS EntryUserName,
substr(c0.EntryDate,1,4) _'-'_ substr(c0.EntryDate,5,2) _'-'_ substr(c0.EntryDate,7,2) AS EntryDate,
TO_CHAR(c0.EntryTime, 'HH24:MI:SS') AS EntryTime,
c19.Code AS AuthUserCode,
c19.CName AS AuthUserName,
substr(c0.AuthDate,1,4) _'-'_ substr(c0.AuthDate,5,2) _'-'_ substr(c0.AuthDate,7,2) AS AuthDate,
TO_CHAR(c0.AuthTime, 'HH24:MI:SS') AS AuthTime,
c11.Code AS WorkGroupMichineCode,
c11.CName AS WorkGroupMichineName,
c12.Code AS WorkGroupCode,
c12.CName AS WorkCroupName,
c0.EpisodeNo AS Epis,
c0.MajorConclusion,
c13.Code AS SpecimenQualityCode,
c13.CName AS SpecimenQualityName,
c1.IDNumber,
c1.CertNo,
c14.CName AS CerType,
c21.Code As TestSetCode,
c21.CName As TestSetName
from  dbo.RP_VisitNumberReport AS c0 LEFT OUTER JOIN
dbo.RP_VisitNumber AS c1 ON c0.VisitNumberDR = c1.RowID LEFT OUTER JOIN
dbo.BT_Species AS c2 ON c1.SpeciesDR = c2.RowID LEFT OUTER JOIN
dbo.BT_AgeUnit AS c3 ON c1.AgeUnitDR = c3.RowID LEFT OUTER JOIN
dbo.BT_AdmissionType AS c4 ON c1.AdmissionTypeDR = c4.RowID LEFT OUTER JOIN
dbo.BT_Specimen AS c5 ON c1.SpecimenDR = c5.RowID LEFT OUTER JOIN
dbo.BT_Container AS c6 ON c1.ContainerDR = c6.RowID LEFT OUTER JOIN
dbo.BT_Location AS c7 ON c1.LocationDR = c7.RowID LEFT OUTER JOIN
dbo.BT_Ward AS c8 ON c1.WardDR = c8.RowID LEFT OUTER JOIN
dbo.BT_Doctor AS c9 ON c1.DoctorDR = c9.RowID LEFT OUTER JOIN
dbo.SYS_User AS c10 ON c1.CollectUserDR= c10.RowID LEFT OUTER JOIN
dbo.BT_WorkGroupMachine AS c11 ON c0.WorkGroupMachineDR = c11.RowID LEFT OUTER JOIN
dbo.BT_WorkGroup AS c12 ON c11.WorkGroupDR = c12.RowID LEFT OUTER JOIN
dbo.BT_SpecimenQuality AS c13 ON c1.SpecimenQualityDR = c13.RowID LEFT OUTER JOIN
dbo.BT_CertType AS c14 ON c1.CertTypeDR = c14.RowID LEFT OUTER JOIN
dbo.SYS_User AS c15 ON c1.CarryUserDR = c15.RowID LEFT OUTER JOIN
dbo.SYS_User AS c16 ON c1.ReceiveUserDR = c16.RowID LEFT OUTER JOIN
dbo.SYS_User AS c17 ON c0.AcceptUserDR = c17.RowID LEFT OUTER JOIN
dbo.SYS_User AS c18 ON c0.EntryUserDR = c18.RowID LEFT OUTER JOIN
dbo.SYS_User AS c19 ON c0.AuthUserDR = c19.RowID LEFT OUTER JOIN
dbo.RP_VisitNumberTestSet AS c20 ON c0.RowID = c20.VisitNumberReportDR LEFT OUTER JOIN
dbo.BT_TestSet AS c21 ON c20.TestSetDR = c21.RowID
 } ]
{

}
