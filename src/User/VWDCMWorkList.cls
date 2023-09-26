Class User.VWDCMWorkList [ ClassType = view, CompileAfter = (CTLoc, CTSex, PAAdm, PAPatMas, CTCareProv, ARCItmMast, OEOrdItem, DICOMWorkList), Not ProcedureBlock, SqlTableName = VW_DCM_WorkList, ViewQuery = { SELECT WL_AccessionNumber AS StudyAccessionNo, WL_Modality,
 WL_OEORI_DR->OEORI_RowId, WL_OEORI_DR->OEORI_SttDat AS OrderStartDate,
 WL_PAPMI_DR->PAPMI_No AS PatientID, WL_PAPMI_DR->PAPMI_Name
 AS PatientName, WL_PAPMI_DR->PAPMI_Name2 AS PatientName2,
 WL_PAPMI_DR->PAPMI_DOB AS PatientDOB, WL_PAPMI_DR->PAPMI_Name3
 AS PatientName3, WL_PAPMI_DR->PAPMI_Sex_DR->CTSEX_Desc AS PatientSex,
 WL_PAADM_DR->PAADM_DepCode_DR->CTLOC_Desc AS PatientLocation,
 WL_PAADM_DR->PAADM_AdmDocCodeDR->CTPCP_Desc AS PerformingPhysician,
 WL_OEORI_DR->OEORI_Doctor_DR->CTPCP_Desc AS ReferringPhysician,
 WL_OEORI_DR->OEORI_RecDep_DR->CTLOC_Desc AS OEORI_RecDep_DR,
 WL_OEORI_DR->OEORI_ItmMast_DR->ARCIM_Desc FROM DICOM_WorkList
} ]
{

}
