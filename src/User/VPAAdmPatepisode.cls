/// View Patient Epsiode details 
Class User.VPAAdmPatepisode [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 PAADM_ROWID,
 PAADM_ADMNo,
 PAADM_PAPMI_DR,
 PAADM_AdmDate,
 PAADM_AdmTime,
 PAADM_SeenDate,
 PAADM_SeenTime,
 PAADM_TriageTime,
 PAADM_TriageDate,
 PAADM_DischgDate,
 PAADM_DischgTime,
 PAADM_Type,	
 PAADM_InpatBedReqDate,
 PAADM_InpatBedReqTime,
 PAADM_RefDate,
 PAADM_VisitStatus,
 PAADM_DepCode_DR->CTLOC_Code,
 PAADM_DepCode_DR->CTLOC_Desc,
 PAADM_AdmDocCodeDR->CTPCP_Code,
 PAADM_AdmDocCodeDR->CTPCP_Desc,
 PAADM_MainMRADM_DR->MRADM_RowId,
 PAADM_MainMRADM_DR->MRADM_PresentComplaint,
 PAADM_MainMRADM_DR->MRADM_DischClassif_DR->DSCL_Code,
 PAADM_MainMRADM_DR->MRADM_DischClassif_DR->DSCL_Desc,
 PAADM_MainMRADM_DR->MRADM_DRG_DR->DRG_Code,
 PAADM_MainMRADM_DR->MRADM_DRG_DR->DRG_Desc,
 PAADM_MainMRADM_DR->MRADM_VisitType_DR->VST_Desc,
 PAADM_MainMRADM_DR->MRADM_ReasonTransfer_DR->RETRA_Code,
 PAADM_MainMRADM_DR->MRADM_ReasonTransfer_DR->RETRA_Desc,
 PAADM_MainMRADM_DR->MRADM_TransfDest_DR->TRD_Code,
 PAADM_MainMRADM_DR->MRADM_TransfDest_DR->TRD_Desc,
 PAADM_MainMRADM_DR->MRADM_GPConsent,
 PAADM_Priority_DR->CTACU_Code,
 PAADM_Priority_DR->CTACU_Desc,
 PAADM_CurrentRoom_DR->ROOM_Code,
 PAADM_CurrentRoom_DR->ROOM_Desc,
 PAADM_Current,
 PAADM_RefDocList_DR,
 PAADM_CurrentWard_DR->WARD_Code,
 PAADM_CurrentWard_DR->WARD_Desc,	
 PAADM_CurrentBed_DR->BED_Code,
 PAADM_RefClinic_DR->CTRFC_Desc,
 PAPMI_DOB,
 PAPMI_Medicare, 
 PAPMI_MedicareCode, 
 PAPMI_Name, 
 PAPMI_Name2, 
 PAPMI_Name3,
 PAPMI_No,
 PAPMI_RowId,
 PAADM_Occupation_DR->CTOCC_Desc,
 PAPMI_RowId->PAPER_FamilyDoctor_DR,
 PAPMI_RowId->PAPER_IndigStat_DR->INDST_Code,
 PAPMI_RowId->PAPER_Title_DR->TTL_Code,
 PAPMI_RowId->PAPER_Title_DR->TTL_Desc,
 PAPMI_RowId->PAPER_Deceased_Date,
 PAPMI_RowId->PAPER_DeceasedTime,
 PAPMI_RowId->PAPER_Deceased,
 PAPMI_RowId->PAPER_StName, 
 PAPMI_RowId->PAPER_TelH, 
 PAPMI_RowId->PAPER_AgeYr,
 PAPMI_RowId->PAPER_Marital_DR->CTMAR_Code, 
 PAPMI_MedicareSuffix_DR->MEDSUF_Code, 
 PAPMI_RowId->PAPER_Religion_DR->CTRLG_Code,
 PAPMI_RowId->PAPER_Religion_DR->CTRLG_Desc,
 PAPMI_RowId->PAPER_InsType_DR->INST_Code,
 PAPMI_RowId->PAPER_InsType_DR->INST_Desc,
 PAPMI_RowId->PAPER_Zip_DR->CTZIP_Code, 
 PAPMI_RowId->PAPER_CityCode_DR->CTCIT_Desc, 
 PAPMI_RowId->PAPER_Sex_DR->CTSEX_Code
 FROM	PA_Adm, PA_PatMas
 WHERE	PAADM_PAPMI_DR=PAPMI_RowId
} ]
{

}
