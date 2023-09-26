Include webimport

IncludeGenerator webimport

Class web.PACEscortSource Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 89;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "ESCS_Code";

Parameter SQLDATEFROM = "ESCS_DateFrom";

Parameter SQLDATETO = "ESCS_DateTo";

Parameter SQLDESCRIPTION = "ESCS_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((ESCS_DateFrom <= CURRENT_DATE OR ESCS_DateFrom IS NULL) AND (ESCS_DateTo >= CURRENT_DATE OR ESCS_DateTo IS NULL))";

Parameter SQLROWID = "ESCS_RowId";

}
