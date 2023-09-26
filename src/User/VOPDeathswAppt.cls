/// View OP Deaths w Appts
Class User.VOPDeathswAppt [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 APPT_RowId,
 APPT_AS_ParRef,
 PAPMI_No,
 PAPMI_Name,
 PAPMI_Name2,
 PAPMI_PAPER_DR->PAPER_Deceased_Date
 FROM	RB_Appointment,PA_Patmas
 WHERE	APPT_PAPMI_DR=PAPMI_RowID
} ]
{

}
