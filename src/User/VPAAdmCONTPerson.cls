/// View Contact Person 
Class User.VPAAdmCONTPerson [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 CONT_ParRef->PAADM_RowId,
 CONT_ContType_DR,
 CONT_Person_DR,
 CONT_ContType_DR->CONTTP_Desc,
 CONT_Person_DR->PAPER_Name,
 CONT_Person_DR->PAPER_Name2,
 CONT_Person_DR->PAPER_TelH,
 CONT_Person_DR->PAPER_StName,
 CONT_Person_DR->PAPER_StNameLine1,
 CONT_Person_DR->PAPER_CityCode_DR->CTCIT_Desc,
 CONT_Person_DR->PAPER_Zip_DR->CTZIP_Code,
 CONT_Person_DR->PAPER_NokCTRLT_DR->CTRLT_Desc		
 FROM	PA_AdmContactPerson
} ]
{

}
