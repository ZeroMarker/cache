/// View OP Deaths 
Class User.VOPDeaths [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 PAADM_DepCode_DR->CTLOC_Code,
 PAADM_DepCode_DR->CTLOC_Desc,
 PAADM_AdmDocCodeDR->CTPCP_Desc,
 PAADM_Appoint_DR->APPT_RowId,
 PAADM_Appoint_DR->APPT_AS_ParRef,
 PAADM_RowId,
 PAADM_Type,
 PAADM_RefDate,
 PAPMI_No,
 PAPMI_Name,
 PAPMI_Name2,
 PAPMI_PAPER_DR->PAPER_Deceased_Date
 FROM	PA_Adm,PA_Patmas
 WHERE	PAADM_PAPMI_DR=PAPMI_RowID
} ]
{

}
