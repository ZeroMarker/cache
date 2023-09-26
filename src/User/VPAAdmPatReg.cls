/// View Admission for Registration Reports 
Class User.VPAAdmPatReg [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 PAADM_ROWID,
 PAADM_ADMNo,
 PAADM_AdmDate,
 PAADM_AdmTime,
 PAADM_DischgDate,
 PAADM_DischgTime,
 PAADM_Occupation_DR->CTOCC_Desc,
 PAADM_CurrentWard_DR->WARD_Desc,
 PAADM_PAPMI_DR,
 PAPMI_RowId,
 PAPMI_DOB,
 PAPMI_Medicare, 
 PAPMI_MedicareCode, 
 PAPMI_Name, 
 PAPMI_Name2, 
 PAPMI_No, 
 PAPMI_RowId->PAPER_AgeYr,
 PAPMI_RowId->PAPER_StName, 
 PAPMI_RowId->PAPER_TelH, 
 PAPMI_RowId->PAPER_Marital_DR->CTMAR_Code, 
 PAADM_PAPMI_DR->PAPMI_MedicareSuffix_DR->MEDSUF_Code, 
 PAPMI_RowId->PAPER_Religion_DR->CTRLG_Code, 
 PAPMI_RowId->PAPER_Zip_DR->CTZIP_Code, 
 PAPMI_RowId->PAPER_CityCode_DR->CTCIT_Desc,
 PAPMI_RowId->PAPER_Title_DR->TTL_Desc,
 PAPMI_RowId->PAPER_Sex_DR->CTSEX_Code,
 PAPMI_RowId->PAPER_InsType_DR->INST_Desc,
 PAPMI_RowId->PAPER_AuxInsType_DR->AUXIT_Desc,
 PAPMI_RowId->PAPER_IndigStat_DR->INDST_Code,
 PAPMI_RowId->PAPER_FamilyDoctor_DR,
 PAADM_MainMRADM_DR->MRADM_PresentComplaint,
 PAADM_TrafficAccident_DR,
 PAPMI_RowId->PAPER_PrefLanguage_DR->PREFL_Desc		
 FROM	PA_Adm, PA_PatMas
 WHERE	PAADM_PAPMI_DR=PAPMI_RowId
} ]
{

}
