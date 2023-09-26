Class User.VWDCMImage [ ClassType = view, CompileAfter = (OEOrdResult, DICOMImage, DICOMPatient, DICOMSeries, DICOMStudy), Not ProcedureBlock, SqlTableName = VW_DCM_Image, ViewQuery = { SELECT DCIMG_ImageFileName AS ImageFileName, DCIMG_ImageNumber
 AS ImageNumber, DCIMG_SOPInstanceUID AS ImageSOPInstanceUID,
 DCIMG_Deleted AS Deleted, DCIMG_Series_DR->DCSRS_SeriesInstanceUID AS SeriesInstanceUID,
 DCIMG_Series_DR->DCSRS_SeriesModality AS SeriesModality,
 DCIMG_Series_DR->DCSRS_SeriesNumber AS SeriesNumber,
 DCIMG_Series_DR->DCSRS_Study_DR->DCSTY_AccessionNumber
 AS StudyAccessionNo, DCIMG_Series_DR->DCSRS_Study_DR->DCSTY_StudyDate
 AS StudyDate, DCIMG_Series_DR->DCSRS_Study_DR->DCSTY_StudyID
 AS StudyID, DCIMG_Series_DR->DCSRS_Study_DR->DCSTY_StudyInstanceUID
 AS StudyInstanceUID, DCIMG_Series_DR->DCSRS_Study_DR->DCSTY_StudyTime
 AS StudyTime,
 DCIMG_Series_DR->DCSRS_Study_DR->DCSTY_Patient_DR->DCPAT_PatientDOB
 AS PatientDOB,
 DCIMG_Series_DR->DCSRS_Study_DR->DCSTY_Patient_DR->DCPAT_PatientID
 AS PatientID,
 DCIMG_Series_DR->DCSRS_Study_DR->DCSTY_Patient_DR->DCPAT_PatientName
 AS PatientName, DCIMG_OeOrdRes_DR->RES_Archive FROM DICOM_Image
} ]
{

}
