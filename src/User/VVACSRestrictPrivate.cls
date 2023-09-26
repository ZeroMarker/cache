/// View For VACS Private Restrict Report 
Class User.VVACSRestrictPrivate [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 RES_Desc, RES_CTLOC_DR->CTLOC_NFMI_DR->DEP_Code, RES_CTLOC_DR->CTLOC_NFMI_DR->DEP_Desc,
 AS_Date,
 AS_RBEffDateSession_DR->SESS_Desc,
 RES_CTLOC_DR->CTLOC_Desc,
 APPT_Status, APPT_RowId,
 APPT_PAPMI_DR,
 INS_InsType_DR->INST_Code,
 RESTR_InsType_DR,
 PA_Weight,
 PA_Date,
 RESTR_RowId
 FROM
 SQLUser.RB_Resource,
 SQLUser.RB_ApptSchedule,
 SQLUser.RB_Appointment,
 SQLUser.PA_AdmInsurance,
 SQLUser.CT_NFMI_CategDepart,
 SQLUser.CT_NFMICategDepPayor,
 SQLUser.RB_ResEffDateSessPayorRestr
 WHERE
 RES_RowId = AS_RES_ParRef AND
 AS_RowId = APPT_AS_ParRef AND
 RES_CTLOC_DR->CTLOC_NFMI_DR = DEP_RowId AND
 APPT_ADM_DR = INS_ParRef AND
 DEP_RowId =* PA_ParRef AND
 AS_RBEffDateSession_DR =* RESTR_ParRef AND
 EXISTS (SELECT RESTR_RowId 
 FROM SQLUser.RB_ResEffDateSessPayorRestr
 WHERE SQLUser.RB_ApptSchedule.AS_RBEffDateSession_DR = RB_ResEffDateSessPayorRestr.RESTR_ParRef)
} ]
{

}
