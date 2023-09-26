/// View Projected Appt details 
Class User.VOPProjApptRpt [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 RB_Resource.RES_Code, RB_Resource.RES_Desc,
 CT_Loc.CTLOC_RowID, CT_Loc.CTLOC_Code,
 RB_ApptSchedule.AS_RowId, RB_ApptSchedule.AS_Date, RB_ApptSchedule.AS_SessStartTime,
 APPT_AS_ParRef, PAPMI_No, PAPMI_Name
 FROM
 SQLUser.RB_Resource RB_Resource,
 SQLUser.CT_Loc CT_Loc,
 SQLUser.RB_ApptSchedule RB_ApptSchedule,
 SQLUSER.RB_Appointment RB_Appointment,
 sqluser.PA_PatMas PA_PatMas
 WHERE
 PAPMI_RowId = APPT_PAPMI_DR AND
 RB_Appointment.APPT_AS_ParRef = RB_ApptSchedule.AS_RowId AND
 RB_Resource.RES_CTLOC_DR = CT_Loc.CTLOC_RowID AND
 RB_Resource.RES_RowId = RB_ApptSchedule.AS_RES_ParRef
 UNION
 SELECT
 RB_Resource.RES_Code, RB_Resource.RES_Desc,
 CT_Loc.CTLOC_RowID, CT_Loc.CTLOC_Code,
 RB_ApptSchedule.AS_RowId, RB_ApptSchedule.AS_Date, RB_ApptSchedule.AS_SessStartTime,
 APPT_AS_ParRef, "", "DOCTOR ON LEAVE"
 FROM
 SQLUser.RB_Resource RB_Resource,
 SQLUser.CT_Loc CT_Loc,
 SQLUser.RB_ApptSchedule RB_ApptSchedule,
 SQLUSER.RB_Appointment RB_Appointment,
 sqluser.PA_PatMas PA_PatMas,
 sqluser.rb_notavail RB_NotAvail
 WHERE
 PAPMI_RowId = APPT_PAPMI_DR AND
 RB_Appointment.APPT_AS_ParRef = RB_ApptSchedule.AS_RowId AND
 RB_Resource.RES_CTLOC_DR = CT_Loc.CTLOC_RowID AND
 RB_Resource.RES_RowId = RB_ApptSchedule.AS_RES_ParRef AND
 APPT_AS_ParRef = RB_ApptSchedule.AS_RowId and
 RB_NotAvail.NA_RES_DR = RB_Resource.RES_RowId and
 RB_ApptSchedule.AS_Date between RB_NotAvail.NA_frdate and NA_todate
} ]
{

}
