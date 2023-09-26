Include webimport

IncludeGenerator webimport

Class web.PACPlaceOfInjury Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 92;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "PLINJ_Code";

Parameter SQLDATEFROM = "PLINJ_DateFrom";

Parameter SQLDATETO = "PLINJ_DateTo";

Parameter SQLDESCRIPTION = "PLINJ_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((PLINJ_DateFrom <= CURRENT_DATE OR PLINJ_DateFrom IS NULL) AND (PLINJ_DateTo >= CURRENT_DATE OR PLINJ_DateTo IS NULL))";

Parameter SQLROWID = "PLINJ_RowId";

}
