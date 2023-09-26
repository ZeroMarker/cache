/// Pension Type CT
Class web.PACPensionType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 23;

Parameter SQLDATEFROM = "PENSTYPE_DateFrom";

Parameter SQLDATETO = "PENSTYPE_DateTo";

Parameter SQLCODE = "PENSTYPE_Code";

Parameter SQLDESCRIPTION = "PENSTYPE_Desc";

Parameter SQLROWID = "PENSTYPE_RowId";

Property dummy As %String(TRUNCATE = 1);

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((PENSTYPE_DateFrom <= CURRENT_DATE OR PENSTYPE_DateFrom IS NULL) AND (PENSTYPE_DateTo >= CURRENT_DATE OR PENSTYPE_DateTo IS NULL))";

}
