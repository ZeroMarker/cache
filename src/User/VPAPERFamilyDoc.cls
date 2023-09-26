/// View Family Doctor 
Class User.VPAPERFamilyDoc [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 REFD_RowId,
 REFD_Desc,
 REFD_Address,
 REFD_Phone,
 REFD_fax,
 REFD_email,
 RefD_CITY_DR->CTCIT_Desc,
 RefD_CTZip_DR->CTZIP_Desc,
 RefD_CTZip_DR->CTZIP_Code
 FROM	PAC_RefDoctor
} ]
{

}
