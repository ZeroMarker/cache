Class web.PADentist Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 110;

Parameter SQLDATEFROM = "DENT_DateFrom";

Parameter SQLDATETO = "DENT_DateTo";

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "DENT_RowId";

Parameter SQLDESCRIPTION = "DENT_RowId";

Parameter SQLROWID = "DENT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod CheckDentOverlap(compref As %Library.String, ToPID As %Library.String, FromPID As %Library.String) As %Library.String
{
}

ClassMethod UpdateLatest(PatientID As %Library.String, DentistID As %Library.String, DentClinID As %Library.String)
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String, newdto As %Library.String, newdfrom As %Library.String, PatID As %Library.String) As %Boolean
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String)
{
}

/// cjb 03/08/2004 44284 - removed - AND DENT_DateTo is not NULL
Query FindDentistDates(PatientID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "fromdate:%Library.Date,todate:%Library.Date")
{
SELECT DENT_DateFrom,DENT_DateTo
FROM SQLUser.PA_Dentist
WHERE DENT_ParRef=:PatientID
}

}
