Include webimport

IncludeGenerator webimport

Class web.CTTitle Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 104;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "TTL_Code";

Parameter SQLDATEFROM = "TTL_DateFrom";

Parameter SQLDATETO = "TTL_DateTo";

Parameter SQLDESCRIPTION = "TTL_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((TTL_DateFrom <= CURRENT_DATE OR TTL_DateFrom IS NULL) AND (TTL_DateTo >= CURRENT_DATE OR TTL_DateTo IS NULL))";

Parameter SQLROWID = "TTL_RowId";

}
