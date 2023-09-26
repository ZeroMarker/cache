/// View Referral Doctor 
Class User.VPAAdmRefDoc [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 RefD_RowId,
 REFD_Desc,
 REFD_Address,
 REFD_Phone,
 REFD_BusPhone,
 REFD_Fax,
 REFD_Email,
 REFD_PreferredContact,
 REFD_CITY_DR->CTCIT_Desc,
 REFD_CTZIP_DR->CTZIP_Desc,
 REFD_CTZIP_DR->CTZIP_Code
 FROM	PAC_RefDoctor
} ]
{

}
