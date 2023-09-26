Class web.PACIsolation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 23;

Property dummy As %Library.String(TRUNCATE = 1);

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "ISOL_Code";

Parameter SQLDATEFROM = "ISOL_DateFrom";

Parameter SQLDATETO = "ISOL_DateTo";

Parameter SQLDESCRIPTION = "ISOL_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((ISOL_DateFrom <= CURRENT_DATE OR ISOL_DateFrom IS NULL) AND (ISOL_DateTo >= CURRENT_DATE OR ISOL_DateTo IS NULL))";

Parameter SQLROWID = "ISOL_RowId";

}
