Include webimport

IncludeGenerator webimport

Class web.PAPersonAdmInsurance Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 39;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PAINS_RowId";

Parameter SQLDESCRIPTION = "PAINS_RowId";

Parameter SQLROWID = "PAINS_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// Log 60875(QP) - 19/10/2006 - Return Payor details at Patient level
ClassMethod GetPayorForPatient(PatientID As %Library.String)
{
}

/// Log 60875(QP) - 19/10/2006 - Return Plan details at Patient level
ClassMethod GetPlanForPatient(PatientID As %Library.String)
{
}

/// Log 60931 - 11/10/2006 - To valid if Patient has a valid agreement in the current hospital/clinic
ClassMethod ValPaymentAgreemnt(PatientID As %String = "") As %Library.String
{
	quit ""
}

}
