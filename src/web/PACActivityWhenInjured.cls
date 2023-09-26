Include webimport

IncludeGenerator webimport

Class web.PACActivityWhenInjured Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 92;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "ACTINJ_Code";

Parameter SQLDATEFROM = "ACTINJ_DateFrom";

Parameter SQLDATETO = "ACTINJ_DateTo";

Parameter SQLDESCRIPTION = "ACTINJ_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((ACTINJ_DateFrom <= CURRENT_DATE OR ACTINJ_DateFrom IS NULL) AND (ACTINJ_DateTo >= CURRENT_DATE OR ACTINJ_DateTo IS NULL))";

Parameter SQLROWID = "ACTINJ_RowId";

}
