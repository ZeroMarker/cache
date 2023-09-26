/// View Admission for Patient Labels 
Class User.VPAAdmPatLabel [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 PAADM_ROWID,
 PAADM_PAPMI_DR,
 PAADM_AdmDate,
 PAPMI_DOB,
 PAPMI_Medicare, 
 PAPMI_MedicareCode, 
 PAPMI_Name, 
 PAPMI_Name2, 
 PAPMI_No, 
 PAPMI_RowID,
 PAPMI_RowId->PAPER_StName, 
 PAPMI_RowId->PAPER_TelH, 
 PAPMI_RowId->PAPER_Marital_DR->CTMAR_Code, 
 PAPMI_MedicareSuffix_DR->MEDSUF_Code, 
 PAPMI_RowId->PAPER_Religion_DR->CTRLG_Code, 
 PAPMI_RowId->PAPER_InsType_DR->INST_Desc,
 PAPMI_RowID->PAPER_InsType_DR->INST_Code,
 PAPMI_RowID->PAPER_AgeYr,
 PAPMI_RowId->PAPER_Zip_DR->CTZIP_Code, 
 PAPMI_RowId->PAPER_CityCode_DR->CTCIT_Desc, 
 PAPMI_RowId->PAPER_Sex_DR->CTSEX_Code,
 PAPMI_RowId->PAPER_RowId
 FROM	PA_Adm, PA_PatMas
 WHERE	PAADM_PAPMI_DR=PAPMI_RowId
} ]
{

}
