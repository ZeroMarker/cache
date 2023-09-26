/// View In Patient meals 
Class User.VPAMeals [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 PAADM_ROWID,
 PAADM_ADMNo,
 PAADM_PAPMI_DR,
 PAADM_AdmDate,
 PAADM_AdmTime,
 PAADM_DischgDate,
 PAADM_DischgTime,
 PAADM_EstimDischargeDate,
 PAADM_Type,	
 PAADM_DepCode_DR->CTLOC_RowId,
 PAADM_DepCode_DR->CTLOC_Code,
 PAADM_DepCode_DR->CTLOC_Desc,
 PAADM_CurrentWard_DR->WARD_LocationDR->CTLOC_Hospital_DR->Hosp_RowId,
 PAADM_CurrentWard_DR->WARD_LocationDR->CTLOC_Hospital_DR->Hosp_Code,
 PAADM_CurrentWard_DR->WARD_LocationDR->CTLOC_Hospital_DR->Hosp_Desc,
 PAADM_DepCode_DR->CTLOC_RespUnit_DR->RU_RowId,
 PAADM_DepCode_DR->CTLOC_RespUnit_DR->RU_Code,
 PAADM_DepCode_DR->CTLOC_RespUnit_DR->RU_Desc,
 PAADM_AdmDocCodeDR->CTPCP_RowId,
 PAADM_AdmDocCodeDR->CTPCP_Code,
 PAADM_AdmDocCodeDR->CTPCP_Desc,
 PAADM_MainMRADM_DR->MRADM_RowId,
 PAADM_Current,
 PAADM_CurrentWard_DR->WARD_RowId,
 PAADM_CurrentWard_DR->WARD_Code,
 PAADM_CurrentWard_DR->WARD_Desc,	
 PAADM_CurrentBed_DR->BED_Code,
 PAPMI_DOB,
 PAPMI_Name, 
 PAPMI_Name2, 
 PAPMI_Name3,
 PAPMI_No,
 PAPMI_RowId,
 PAPMI_Sex_DR->CTSEX_Code
 FROM	PA_Adm, PA_PatMas
 WHERE	PAADM_PAPMI_DR=PAPMI_RowId
} ]
{

}
