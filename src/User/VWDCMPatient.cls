/// DICOM Patient
Class User.VWDCMPatient [ ClassType = view, CompileAfter = DICOMPatient, Not ProcedureBlock, SqlTableName = VW_DCM_Patient, ViewQuery = { SELECT DCPAT_PatientDOB AS PatientDOB, DCPAT_PatientID AS PatientID,
 DCPAT_PatientName AS PatientName, DCPAT_Sex AS PatientSex
 FROM DICOM_Patient
} ]
{

}
