Class User.VWDCMSeries [ ClassType = view, CompileAfter = (DICOMPatient, DICOMSeries, DICOMStudy), Not ProcedureBlock, SqlTableName = VW_DCM_Series, ViewQuery = { SELECT DCSRS_SeriesModality AS SeriesModality, DCSRS_SeriesNumber
 AS SeriesNumber, DCSRS_SeriesInstanceUID AS SeriesInstanceUID,
 DCSRS_Study_DR->DCSTY_StudyDate AS StudyDate,
 DCSRS_Study_DR->DCSTY_StudyTime AS StudyTime,
 DCSRS_Study_DR->DCSTY_AccessionNumber AS StudyAccessionNo,
 DCSRS_Study_DR->DCSTY_StudyID AS StudyID,
 DCSRS_Study_DR->DCSTY_StudyInstanceUID AS StudyInstanceUID,
 DCSRS_Study_DR->DCSTY_Patient_DR->DCPAT_PatientName AS PatientName,
 DCSRS_Study_DR->DCSTY_Patient_DR->DCPAT_PatientID AS PatientID,
 DCSRS_Study_DR->DCSTY_Patient_DR->DCPAT_PatientDOB AS PatientDOB
 FROM DICOM_Series
} ]
{

}
