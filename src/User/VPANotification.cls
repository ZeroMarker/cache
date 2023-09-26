/// View Admitting Doctor and Unit 
Class User.VPANotification [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 NOT_PAADM_DR->PAADM_RowId,
 NOT_PAADM_DR,
 NOT_CTLOC_DR->CTLOC_Code,
 NOT_CTLOC_DR->CTLOC_Desc,
 NOT_CTCP_DR->CTPCP_Code,
 NOT_CTCP_DR->CTPCP_Desc
 FROM	PA_Notification
} ]
{

}
