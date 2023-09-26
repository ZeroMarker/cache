/// View Patient Labels fields 
Class User.VPAPMILabelfields [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 PAPMI_ROWID,
 PAPMI_PAPER_DR,
 PAPMI_DOB,
 PAPMI_Medicare, 
 PAPMI_MedicareCode, 
 PAPMI_Name, 
 PAPMI_Name2, 
 PAPMI_No, 
 PAPMI_PAPER_DR->PAPER_StName, 
 PAPMI_PAPER_DR->PAPER_TelH, 
 PAPMI_PAPER_DR->PAPER_Marital_DR->CTMAR_Code, 
 PAPMI_MedicareSuffix_DR->MEDSUF_Code, 
 PAPMI_PAPER_DR->PAPER_Religion_DR->CTRLG_Code, 
 PAPMI_PAPER_DR->PAPER_InsType_DR->INST_Desc,
 PAPMI_PAPER_DR->PAPER_Zip_DR->CTZIP_Code, 
 PAPMI_PAPER_DR->PAPER_CityCode_DR->CTCIT_Desc, 
 PAPMI_PAPER_DR->PAPER_Sex_DR->CTSEX_Code,
 PAPMI_PAPER_DR->PAPER_InsType_DR
 FROM	PA_PatMas
} ]
{

}
