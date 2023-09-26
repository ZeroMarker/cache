/// View Admission for Triage Form 
Class User.VPAAdmTriage [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 PAADM_ROWID,
 PAADM_TriageDate,
 PAADM_TriageTime,
 PAADM_UpdateUser_DR->SSUSR_Name,
 PAADM_UpdateUser_DR->SSUSR_Initials,
 PAADM_LikelihoodAdmit,
 PAADM_Priority_DR->CTACU_Code,
 PAADM_AdmDocCodeDR->CTPCP_Desc,
 PAADM_CurrentBed_DR->BED_Code,
 PAADM_PAPMI_DR,
 PAADM_PAPMI_DR->PAPMI_DOB,
 PAPMI_RowId->PAPER_AgeYr,
 PAADM_PAPMI_DR->PAPMI_Name, 
 PAADM_PAPMI_DR->PAPMI_Name2, 
 PAADM_PAPMI_DR->PAPMI_No,
 PAADM_PAPMI_DR->PAPMI_Allergy,
 PAPMI_RowId->PAPER_Marital_DR->CTMAR_Code, 
 PAPMI_RowId->PAPER_Sex_DR->CTSEX_Code,
 PAPMI_RowId->PAPER_PrefLanguage_DR->PREFL_Desc,
 PAADM_MainMRADM_DR,
 PAADM_MainMRADM_DR->MRADM_PresentComplaint,
 PAADM_MainMRADM_DR->MRADM_BPDiastolic,
 PAADM_MainMRADM_DR->MRADM_BPSystolic,
 PAADM_MainMRADM_DR->MRADM_Resp,
 PAADM_MainMRADM_DR->MRADM_Temp,
 PAADM_MainMRADM_DR->MRADM_OxygenSaturation,
 PAADM_MainMRADM_DR->MRADM_PulseRate,
 PAADM_MainMRADM_DR->MRADM_PreHospTreatment
 FROM	PA_Adm, PA_PatMas
 WHERE	PAADM_PAPMI_DR=PAPMI_RowId
} ]
{

}
