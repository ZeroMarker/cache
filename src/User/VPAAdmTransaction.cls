/// View Updated Ward and Bed 
Class User.VPAAdmTransaction [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 TRANS_ParRef,
 TRANS_StartDate,
 TRANS_StartTime,
 TRANS_EndDate,
 TRANS_EndTime,
 TRANS_Ward_DR->Ward_Code,
 TRANS_Bed_DR->Bed_Code,
 TRANS_Ward_DR->Ward_Desc,
 TRANS_CTCP_DR->CTPCP_Code,
 TRANS_CTCP_DR->CTPCP_Desc,
 TRANS_CTLOC_DR->CTLOC_Code,
 TRANS_CTLOC_DR->CTLOC_Desc,
 TRANS_Room_DR->Room_Code,
 TRANS_Room_DR->Room_Desc,
 TRANS_UpdateDate,
 TRANS_UpdateTime	
 FROM	PA_AdmTransaction
} ]
{

}
