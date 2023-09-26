Include webimport

IncludeGenerator webimport

Class web.PACHumanIntent Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 92;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "HUMINT_Code";

Parameter SQLDATEFROM = "HUMINT_DateFrom";

Parameter SQLDATETO = "HUMINT_DateTo";

Parameter SQLDESCRIPTION = "HUMINT_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((HUMINT_DateFrom <= CURRENT_DATE OR HUMINT_DateFrom IS NULL) AND (HUMINT_DateTo >= CURRENT_DATE OR HUMINT_DateTo IS NULL))";

Parameter SQLROWID = "HUMINT_RowId";

}
