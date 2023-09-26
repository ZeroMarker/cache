Class web.PACACPSource Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 29;

Property dummy As %Library.String(TRUNCATE = 1);

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "ACPSRC_Code";

Parameter SQLDATEFROM = "ACPSRC_DateFrom";

Parameter SQLDATETO = "ACPSRC_DateTo";

Parameter SQLDESCRIPTION = "ACPSRC_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((ACPSRC_DateFrom <= CURRENT_DATE OR ACPSRC_DateFrom IS NULL) AND (ACPSRC_DateTo >= CURRENT_DATE OR ACPSRC_DateTo IS NULL))";

Parameter SQLROWID = "ACPSRC_RowId";

}
