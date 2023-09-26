Class web.PACACPDisposal Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 43;

Property dummy As %Library.String(TRUNCATE = 1);

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "ACPDSP_Code";

Parameter SQLDATEFROM = "ACPDSP_DateFrom";

Parameter SQLDATETO = "ACPDSP_DateTo";

Parameter SQLDESCRIPTION = "ACPDSP_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((ACPDSP_DateFrom <= CURRENT_DATE OR ACPDSP_DateFrom IS NULL) AND (ACPDSP_DateTo >= CURRENT_DATE OR ACPDSP_DateTo IS NULL))";

Parameter SQLROWID = "ACPDSP_RowId";

}
