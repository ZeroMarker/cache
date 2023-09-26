Include webimport

IncludeGenerator webimport

Class web.CTReligion Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 94;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "CTRLG_Code";

Parameter SQLDATEFROM = "CTRLG_DateFrom";

Parameter SQLDATETO = "CTRLG_DateTo";

Parameter SQLDESCRIPTION = "CTRLG_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((CTRLG_DateFrom <= CURRENT_DATE OR CTRLG_DateFrom IS NULL) AND (CTRLG_DateTo >= CURRENT_DATE OR CTRLG_DateTo IS NULL))";

Parameter SQLROWID = "CTRLG_RowId";

}
