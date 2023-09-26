Include webimport

IncludeGenerator webimport

Class web.PACAdmissionMethod Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 59;

Parameter SQLDATEFROM = "ADMETH_DateFrom";

Parameter SQLDATETO = "ADMETH_DateTo";

Parameter SQLCODE = "ADMETH_Code";

Parameter SQLDESCRIPTION = "ADMETH_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((ADMETH_DateFrom <= CURRENT_DATE OR ADMETH_DateFrom IS NULL) AND (ADMETH_DateTo >= CURRENT_DATE OR ADMETH_DateTo IS NULL))";

Parameter SQLROWID = "ADMETH_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

}
