Class dbo.VRPVisitNumberReportBacteriaResult [ ClassType = view, CompileAfter = (dbo.RPVisitNumber, dbo.RPVisitNumberReport, dbo.RPVisitNumberReportResult, dbo.RPVisitNumberReportResSen, dbo.BTTestCode, dbo.BTTestSet), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_RP_VisitNumberReportBacteriaResult, ViewQuery = {
SELECT dbo.RP_VisitNumberReportResult.RowID as RptResultDR,
c1.RowID as ReportDR,
c2.VisitNumber,
c2.SurName As PatName,
c5.CName AS Species,
c2.Age||c6.CName AS Age,
substr(c2.BirthDate,1,4) _'-'_ substr(c2.BirthDate,5,2) _'-'_ substr(c2.BirthDate,7,2) AS BirthDate,
c2.RegNo,
c2.MedicalRecordNo AS HospNo,
c2.AdmNo,
c7.CName AS AdmType,
c8.Code AS SpecimenCode,
c8.IName AS SpecimenName,
c9.Code AS ContainerCode,
c9.CName AS ContainerName,
c9.Color AS Color,
c10.Code AS LocationCode,
c10.CName AS LocationName,
c11.Code AS WardCode,
c11.CName AS WardName,
c2.BedNo,
c2.Symptom AS Diagnose,
c12.Code AS DoctorCode,
c12.CName AS DoctorName,
substr(c2.RequestDate,1,4) _'-'_ substr(c2.RequestDate,5,2) _'-'_ substr(c2.RequestDate,7,2) AS RequestDate,
TO_CHAR(c2.RequestTime, 'HH24:MI:SS') AS RequestTime,
c13.Code AS CollectUserCode,
c13.CName AS CollectUserName,
substr(c2.CollectDate,1,4) _'-'_ substr(c2.CollectDate,5,2) _'-'_ substr(c2.CollectDate,7,2) AS CollectDate,
TO_CHAR(c2.CollectTime, 'HH24:MI:SS') AS CollectTime,
c19.Code AS CarryUserCode,
c19.CName AS CarryUserName,
substr(c2.CarryDate,1,4) _'-'_ substr(c2.CarryDate,5,2) _'-'_ substr(c2.CarryDate,7,2) AS CarryDate,
TO_CHAR(c2.CarryTime, 'HH24:MI:SS') AS CarryTime,
c20.Code AS ReceiveUserCode,
c20.CName AS ReceiveUserName,
substr(c2.ReceiveDate,1,4) _'-'_ substr(c2.ReceiveDate,5,2) _'-'_ substr(c2.ReceiveDate,7,2) AS ReceiveDate,
TO_CHAR(c2.ReceiveTime, 'HH24:MI:SS') AS ReceiveTime,
c21.Code AS AcceptUserCode,
c21.CName AS AcceptUserName,
substr(c1.AcceptDate,1,4) _'-'_ substr(c1.AcceptDate,5,2) _'-'_ substr(c1.AcceptDate,7,2) AS AcceptDate,
TO_CHAR(c1.AcceptTime, 'HH24:MI:SS') AS AcceptTime,
c22.Code AS EntryUserCode,
c22.CName AS EntryUserName,
substr(c1.EntryDate,1,4) _'-'_ substr(c1.EntryDate,5,2) _'-'_ substr(c1.EntryDate,7,2) AS EntryDate,
TO_CHAR(c1.EntryTime, 'HH24:MI:SS') AS EntryTime,
c23.Code AS AuthUserCode,
c23.CName AS AuthUserName,
substr(c1.AuthDate,1,4) _'-'_ substr(c1.AuthDate,5,2) _'-'_ substr(c1.AuthDate,7,2) AS AuthDate,
TO_CHAR(c1.AuthTime, 'HH24:MI:SS') AS AuthTime,
c14.Code AS WorkGroupMichineCode,
c14.CName AS WorkGroupMichineName,
c15.Code AS WorkGroupCode,
c15.CName AS WorkCroupName,
c1.EpisodeNo AS Epis,
c1.MajorConclusion,
c16.Code AS SpecimenQualityCode,
c16.CName AS SpecimenQualityName,
c2.IDNumber,
c2.CertNo,
c17.CName AS CerType,
dbo.RP_VisitNumberReportResult.TestCodeDR,
c3.Code As TestCodeCode,
c3.CName As TestCodeName,
dbo.RP_VisitNumberReportResult.TestSetDR,
c4.Code As TestSetCode,
c4.CName As TestSetName,
dbo.RP_VisitNumberReportResult.Result,
dbo.RP_VisitNumberReportResult.ExtraRes,
dbo.RP_VisitNumberReportResult.OtherRes,
dbo.RP_VisitNumberReportResult.AbFlag,
dbo.RP_VisitNumberReportResult.Unit,
dbo.RP_VisitNumberReportResult.RefRanges,
c18.CName AS TCMethod,
dbo.RP_VisitNumberReportResult.Sequence,
c24.Code AS BacteriaCode,
c24.CName AS BacteriaName,
c24.WCode AS WhoNetBact,
dbo.RP_VisitNumberReportResult.Unit as ColonyCount
from  dbo.RP_VisitNumberReportResult LEFT OUTER JOIN
dbo.RP_VisitNumberReport AS c1 ON dbo.RP_VisitNumberReportResult.VisitNumberReportDR = c1.RowID LEFT OUTER JOIN
dbo.RP_VisitNumber AS c2 ON c1.VisitNumberDR =c2.RowID LEFT OUTER JOIN
dbo.BT_TestCode As c3 on c3.RowID = dbo.RP_VisitNumberReportResult.TestCodeDR LEFT OUTER JOIN
dbo.BT_TestSet As c4 on c4.RowID = dbo.RP_VisitNumberReportResult.TestSetDR LEFT OUTER JOIN
dbo.BT_Species AS c5 ON c2.SpeciesDR = c5.RowID LEFT OUTER JOIN
dbo.BT_AgeUnit AS c6 ON c2.AgeUnitDR = c6.RowID LEFT OUTER JOIN
dbo.BT_AdmissionType AS c7 ON c2.AdmissionTypeDR = c7.RowID LEFT OUTER JOIN
dbo.BT_Specimen AS c8 ON c2.SpecimenDR = c8.RowID LEFT OUTER JOIN
dbo.BT_Container AS c9 ON c2.ContainerDR = c9.RowID LEFT OUTER JOIN
dbo.BT_Location AS c10 ON c2.LocationDR = c10.RowID LEFT OUTER JOIN
dbo.BT_Ward AS c11 ON c2.WardDR = c11.RowID LEFT OUTER JOIN
dbo.BT_Doctor AS c12 ON c2.DoctorDR = c12.RowID LEFT OUTER JOIN
dbo.SYS_User AS c13 ON c2.CollectUserDR= c13.RowID LEFT OUTER JOIN
dbo.BT_WorkGroupMachine AS c14 ON c1.WorkGroupMachineDR = c14.RowID LEFT OUTER JOIN
dbo.BT_WorkGroup AS c15 ON c14.WorkGroupDR = c15.RowID LEFT OUTER JOIN
dbo.BT_SpecimenQuality AS c16 ON c2.SpecimenQualityDR = c16.RowID LEFT OUTER JOIN
dbo.BT_CertType AS c17 ON c2.CertTypeDR = c17.RowID LEFT OUTER JOIN
dbo.BT_TestMethod AS c18 ON dbo.RP_VisitNumberReportResult.MethodDR = c18.RowID LEFT OUTER JOIN
dbo.SYS_User AS c19 ON c2.CarryUserDR= c19.RowID LEFT OUTER JOIN
dbo.SYS_User AS c20 ON c2.ReceiveUserDR= c20.RowID LEFT OUTER JOIN
dbo.SYS_User AS c21 ON c1.AcceptUserDR= c21.RowID LEFT OUTER JOIN
dbo.SYS_User AS c22 ON c1.EntryUserDR= c22.RowID LEFT OUTER JOIN
dbo.SYS_User AS c23 ON c1.AuthUserDR= c23.RowID LEFT OUTER JOIN
dbo.BT_Organism AS c24 ON dbo.RP_VisitNumberReportResult.Result = c24.RowID 
WHERE c3.ResultFormat = 'M'} ]
{

}
