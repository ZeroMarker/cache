Class web.PAPersonCareProvider Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 145;

Parameter SQLDATEFROM = "CP_DateFrom";

Parameter SQLDATETO = "CP_DateTo";

Parameter SQLCODE = "CP_RowID";

Parameter SQLDESCRIPTION = "CP_RowID";

Parameter SQLROWID = "CP_RowID";

Property dummy As %String(TRUNCATE = 1);

Query Find(PatientID As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,CTPCPDesc,CTPCPRowID,RUDesc,RURowID,CPDateFrom,CPDateTo,CPCancelReason")
{
SELECT CP_RowId,CP_CareProv_DR->CTPCP_Desc,CP_CareProv_DR->CTPCP_RowID,
CP_RespUnit_DR->RU_Desc,CP_RespUnit_DR->RU_RowID,CP_DateFrom,CP_DateTo,CP_CancelReason
FROM SQLUser.PA_PersonCareProvider
WHERE CP_ParRef->PAPER_RowId = :PatientID
ORDER BY CP_DateFrom DESC
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// ab 11.05.03 - 41581 -  dont allow more than one care provider entry per responsible unit
ClassMethod checkRespUnit(compref As %String, id As %String = "") As %Boolean
{
}

/// ab 11.05.03 - 41581
ClassMethod checkMaxPatients(compref As %String, id As %String = "") As %Boolean
{
}

/// number of patients with this care provider assigned
/// called from above and SSUserAppointment.List
ClassMethod NumPatsForCareProv(CareProv As %String = "", ru As %String = "", id As %String = "", DateFrom As %String = "", DateTo As %String = "") As %String
{
}

}
