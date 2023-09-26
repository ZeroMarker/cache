/// View Ref Doc Clinic details 
Class User.VPACRefDocClinic [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 CLN_ParRef,
 CLN_Code,
 CLN_ProviderNo,
 CLN_Address1,
 CLN_Address2,
 CLN_City_DR->CTCIT_Desc,
 CLN_Zip_DR->CTZIP_Code
 FROM	PAC_RefDoctorClinic
} ]
{

}
