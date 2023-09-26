Class web.PAUnmergePatient Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 68;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "UNMRG_RowId";

Parameter SQLDESCRIPTION = "UNMRG_RowId";

Parameter SQLROWID = "UNMRG_RowId";

/// cjb 22/03/2005 50935 - moved here from PAPerson
ClassMethod UnMergePatient(compref As %Library.String, PatientID As %Library.String, ToPatientID As %Library.String)
{
}

/// cjb 12/04/2005 50763 added funtion so password is validated
/// Invoked before websysSave - can be used to cancel the save
ClassMethod websysBeforeSave(compref As %String = "", ByRef id As %String = "") As %Boolean
{
}

}
