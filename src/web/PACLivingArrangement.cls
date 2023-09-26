Class web.PACLivingArrangement Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

Property dummy As %Library.String(TRUNCATE = 1);

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "LIVARR_Code";

Parameter SQLDATEFROM = "LIVARR_DateFrom";

Parameter SQLDATETO = "LIVARR_DateTo";

Parameter SQLDESCRIPTION = "LIVARR_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((LIVARR_DateFrom <= CURRENT_DATE OR LIVARR_DateFrom IS NULL) AND (LIVARR_DateTo >= CURRENT_DATE OR LIVARR_DateTo IS NULL))";

Parameter SQLROWID = "LIVARR_RowId";

}
