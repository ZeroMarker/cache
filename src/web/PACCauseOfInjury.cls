Include webimport

IncludeGenerator webimport

Class web.PACCauseOfInjury Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 92;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "INJU_Code";

Parameter SQLDATEFROM = "INJU_DateFrom";

Parameter SQLDATETO = "INJU_DateTo";

Parameter SQLDESCRIPTION = "INJU_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((INJU_DateFrom <= CURRENT_DATE OR INJU_DateFrom IS NULL) AND (INJU_DateTo >= CURRENT_DATE OR INJU_DateTo IS NULL))";

Parameter SQLROWID = "INJU_RowId";

}
