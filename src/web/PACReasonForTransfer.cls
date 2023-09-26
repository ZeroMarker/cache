Include webimport

IncludeGenerator webimport

Class web.PACReasonForTransfer Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 88;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "RETRA_Code";

Parameter SQLDATEFROM = "RETRA_DateFrom";

Parameter SQLDATETO = "RETRA_DateTo";

Parameter SQLDESCRIPTION = "RETRA_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((RETRA_DateFrom <= CURRENT_DATE OR RETRA_DateFrom IS NULL) AND (RETRA_DateTo >= CURRENT_DATE OR RETRA_DateTo IS NULL))";

Parameter SQLROWID = "RETRA_RowId";

}
