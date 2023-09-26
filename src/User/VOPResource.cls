/// View OP Resource details 
Class User.VOPResource [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 RES_RowId,
 RES_CTLOC_DR,
 RES_Desc,
 RES_CTLOC_DR->CTLoc_RowId,
 RES_CTLOC_DR->CTLoc_Code,
 RES_CTLOC_DR->CTLoc_Desc,
 RES_CTPCP_DR->CTPCP_RowId,
 RES_CTPCP_DR->CTPCP_RowId1,
 RES_CTPCP_DR->CTPCP_Code,
 RES_CTPCP_DR->CTPCP_Desc,
 RES_CTLOC_DR->CTLOC_NFMI_DR,
 RES_CTLOC_DR->CTLOC_Hospital_DR->HOSP_RowId,
 RES_CTLOC_DR->CTLOC_Hospital_DR->HOSP_Code,
 RES_CTLOC_DR->CTLOC_Hospital_DR->HOSP_Desc,
 RES_CTLOC_DR->CTLOC_NFMI_DR->DEP_Code,
 RES_CTLOC_DR->CTLOC_NFMI_DR->DEP_Desc
 FROM	RB_Resource 

} ]
{

}
