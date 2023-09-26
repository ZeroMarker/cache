/// DICOM Patient info from MEDTRAK
Class User.VWDCMPatientDetails [ ClassType = view, CompileAfter = (CTSex, PAAdm, PAPatMas, ARCItmMast, OEOrder, OEOrdItem, PACRefDoctor), Not ProcedureBlock, SqlTableName = VW_DCM_PatientDetails, ViewQuery = { SELECT OEORI_ItmMast_DR->ARCIM_Desc, OEORI_RowId, OEORI_PRN
 AS PatientID,
 OEORI_OEORD_ParRef->OEORD_Adm_DR->PAADM_PAPMI_DR->PAPMI_Name,
 OEORI_OEORD_ParRef->OEORD_Adm_DR->PAADM_PAPMI_DR->PAPMI_Name2,
 OEORI_OEORD_ParRef->OEORD_Adm_DR->PAADM_PAPMI_DR->PAPMI_DOB,
 OEORI_OEORD_ParRef->OEORD_Adm_DR->PAADM_PAPMI_DR->PAPMI_Name3,
 OEORI_OEORD_ParRef->OEORD_Adm_DR->PAADM_PAPMI_DR->PAPMI_Sex_DR->CTSEX_Code
 AS PatientSex,
 OEORI_OEORD_ParRef->OEORD_Adm_DR->PAADM_RefDocList_DR->REFD_Desc
 AS RefDoctorName FROM OE_OrdItem
} ]
{

}
