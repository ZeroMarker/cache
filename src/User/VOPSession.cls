/// View OP Session details 
Class User.VOPSession [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 AS_RowId,
 AS_RES_ParRef,
 AS_Date,
 AS_SessStartTime,
 AS_RBEffDateSession_DR->Sess_RowId,
 AS_RBEffDateSession_DR->Sess_Desc,
 AS_RBEffDateSession_DR->Sess_Room_DR->CTLOC_Code,
 AS_RBEffDateSession_DR->Sess_Room_DR->CTLOC_Desc,
 AS_RBEffDateSession_DR->Sess_Room_DR->CTLOC_Type,
 AS_RBEffDateSession_DR->Sess_Room_DR->CTLOC_Hospital_DR->Hosp_Code,
 AS_RBEffDateSession_DR->Sess_Room_DR->CTLOC_Hospital_DR->Hosp_Desc
 FROM	RB_ApptSchedule
} ]
{

}
