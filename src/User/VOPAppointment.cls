/// View OP Appointment details 
Class User.VOPAppointment [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 APPT_Status,
 APPT_InterpreterRequired,
 APPT_AS_ParRef,
 APPT_TransDate,
 APPT_TransTime,
 APPT_Remarks,
 APPT_RowId,
 APPT_APPT_DR,
 APPT_ArrivalTime,
 APPT_Transport_DR->APTR_Code,
 APPT_Transport_DR->APTR_Desc,
 APPT_Outcome_DR->OUTC_Code,
 APPT_Outcome_DR->OUTC_Desc,
 PAPMI_RowId,
 PAPMI_No,
 PAPMI_Name,
 PAPMI_Name2,
 PAPMI_DOB,
 PAPMI_DVANumber,
 PAPMI_PAPER_DR->PAPER_AgeYr,
 PAPMI_PAPER_DR->PAPER_Sex_DR->CTSEX_Code,
 PAPMI_PAPER_DR->PAPER_Sex_DR->CTSEX_Desc,
 PAPMI_PAPER_DR->PAPER_InsType_DR->INST_Code,
 PAPMI_PAPER_DR->PAPER_InsType_DR->INST_Desc,
 PAPMI_PAPER_DR->PAPER_Deceased_Date,
 PAPMI_PAPER_DR->PAPER_Deceased,
 PAPMI_PAPER_DR->PAPER_PrefLanguage_DR->PREFL_Desc,
 PAPMI_PAPER_DR->PAPER_FamilyDoctor_DR,
 APPT_ADM_DR->PAADM_UpdateUser_DR->SSUSR_Initials,
 APPT_ADM_DR->PAADM_UpdateUser_DR->SSUSR_Name,
 APPT_RBCServ_DR->SER_ServGroup_DR->SG_Code,
 APPT_RBCServ_DR->SER_ServGroup_DR->SG_Desc,
 APPT_ReasonOverBook_DR->ROB_Code,
 APPT_ReasonOverBook_DR->ROB_Desc,
 APPT_RBCServ_DR->Ser_Desc
 FROM	RB_Appointment, PA_Patmas
 WHERE	APPT_PAPMI_DR=PAPMI_RowId
} ]
{

}
