/// View Referral Doctor details 
Class User.VPACRefDoctor [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 REFD_ROWID,
 REFD_Code,
 REFD_Desc,
 REFD_Address,
 REFD_Phone,
 REFD_City_DR->CTCIT_Desc,
 REFD_CTZIP_DR->CTZIP_Code,
 REFD_DateActiveFrom,
 REFD_DateActiveTo,
 REFD_Fax,
 REFD_email,
 REFD_BusPhone,
 CLN_ProviderNo,
 CLN_Address1,
 CLN_Address2,
 CLN_City_DR,
 CLN_Zip_DR
 FROM	PAC_RefDoctor, PAC_RefDoctorClinic
 WHERE	REFD_RowId=CLN_ParRef
} ]
{

}
