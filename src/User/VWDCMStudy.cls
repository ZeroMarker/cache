/// DICOM Study
Class User.VWDCMStudy [ ClassType = view, CompileAfter = (DICOMPatient, DICOMStudy), Not ProcedureBlock, SqlTableName = VW_DCM_Study, ViewQuery = { SELECT DCSTY_AccessionNumber AS StudyAccessionNo, DCSTY_StudyDate
 AS StudyDate, DCSTY_StudyID AS StudyID, DCSTY_StudyInstanceUID
 AS StudyInstanceUID, DCSTY_StudyTime AS StudyTime, DCSTY_RefDoctorName
 AS RefDoctorName, DCSTY_DeleteStatusDate AS DeleteStatusDate, 
 DCSTY_DeleteStatus AS DeleteStatus, DCSTY_DeleteStatusTime AS DeleteStatusTime,
 DCSTY_Description AS Description, DCSTY_Patient_DR->DCPAT_PatientDOB AS PatientDOB,
 DCSTY_Patient_DR->DCPAT_PatientID AS PatientID,
 DCSTY_Patient_DR->DCPAT_PatientName AS PatientName,
 DCSTY_Patient_DR->DCPAT_Sex AS PatientSex FROM DICOM_Study
} ]
{

}
