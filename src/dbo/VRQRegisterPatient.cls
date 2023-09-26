Class dbo.VRQRegisterPatient [ ClassType = view, CompileAfter = (dbo.BTABOBG, dbo.BTAdmissionType, dbo.BTCardType, dbo.BTRHBG, dbo.BTSpecies, dbo.RQCard, dbo.RQMedicalRecord, dbo.RQPatient), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_RQ_RegisterPatient, ViewQuery = { 
SELECT     dbo.RQ_Patient.RowID, dbo.RQ_Patient.RegNo, dbo.RQ_Patient.SurName, dbo.RQ_Patient.GivenName, dbo.RQ_Patient.SpeciesDR, 
 dbo.BT_Species.CName AS SpeciesDesc, dbo.RQ_Patient.BirthDate, dbo.RQ_Patient.BirthTime, dbo.RQ_Patient.AboDR, 
 dbo.BT_ABOBG.CName AS AboDesc, dbo.RQ_Patient.RhDR, dbo.BT_RHBG.RH AS RHDesc, dbo.RQ_Patient.MobileNo, dbo.RQ_Patient.PhoneNo, 
 dbo.RQ_Patient.EMail, dbo.RQ_Patient.Address, dbo.RQ_Patient.PostCode, dbo.RQ_Patient.IDNumber, dbo.RQ_Card.CardNo, 
 dbo.RQ_Card.CardTypeDR, dbo.RQ_Card.HospitalDR, dbo.RQ_Card.Status, dbo.RQ_MedicalRecord.RecordNo, 
 dbo.RQ_MedicalRecord.AdmissionTypeDR, dbo.RQ_MedicalRecord.Used, dbo.BT_CardType.CName AS CardTypeDesc, 
 dbo.BT_AdmissionType.CName AS AdmissionTypeDesc
 FROM  dbo.RQ_Patient  LEFT OUTER JOIN
 dbo.RQ_Card ON dbo.RQ_Patient.RowID = dbo.RQ_Card.PatientDR  LEFT OUTER JOIN
 dbo.RQ_MedicalRecord ON dbo.RQ_Patient.RowID = dbo.RQ_MedicalRecord.PatientDR  LEFT OUTER JOIN
 dbo.BT_AdmissionType ON dbo.RQ_MedicalRecord.AdmissionTypeDR = dbo.BT_AdmissionType.RowID LEFT OUTER JOIN
 dbo.BT_CardType ON dbo.RQ_Card.CardTypeDR = dbo.BT_CardType.RowID LEFT OUTER JOIN
 dbo.BT_Species ON dbo.RQ_Patient.SpeciesDR = dbo.BT_Species.RowID LEFT OUTER JOIN
 dbo.BT_ABOBG ON dbo.RQ_Patient.AboDR = dbo.BT_ABOBG.RowID LEFT OUTER JOIN
 dbo.BT_RHBG ON dbo.RQ_Patient.RhDR = dbo.BT_RHBG.RowID} ]
{

}
