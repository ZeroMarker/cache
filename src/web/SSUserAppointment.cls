Class web.SSUserAppointment Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 79;

Parameter SQLDATEFROM = "APPT_DateFrom";

Parameter SQLDATETO = "APPT_DateTo";

Parameter SQLCODE = "APPT_RowId";

Parameter SQLDESCRIPTION = "APPT_RowId";

Parameter SQLROWID = "APPT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %Library.String, ByRef id As %Library.String, new As %Library.Boolean) As %Library.Boolean
{
}

Query ListAll(SSUserID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "APPTRowId,USAPTLDesc,APPTDateFrom,APPTDateTo,APPTCareProvNumber,APPTDocProvNumber,PAYCLSDesc,APPTHoursPerFortnight,APPTCostCenter,APPTDiscount,APPTComments,APPTAppointmentNumber,HOSPDesc,APPTAdmittingRights,RUDesc,APPTMaxNumPatients,RURowId")
{
Select APPT_RowId,APPT_Title_DR->USAPTL_Desc,
APPT_DateFrom,APPT_DateTo,APPT_CareProvNumber,APPT_DocProvNumber,
APPT_Classification_DR->PAYCLS_Desc,
APPT_HoursPerFortnight,APPT_CostCenter_DR->GLCCC_Desc,APPT_Discount,
APPT_Comments,APPT_AppointmentNumber,
APPT_Hospital_DR->HOSP_Desc,APPT_AdmittingRights,
APPT_RespUnit_DR->RU_Desc,APPT_MaxNumPatients,APPT_RespUnit_DR->RU_RowId
FROM SQLUser.SS_UserAppointment
WHERE APPT_ParRef=:SSUserID
}

}
