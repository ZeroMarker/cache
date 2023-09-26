Class web.PACResidenceStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 27;

Property dummy As %Library.String(TRUNCATE = 1);

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "RESID_Code";

Parameter SQLDATEFROM = "RESID_DateFrom";

Parameter SQLDATETO = "RESID_DateTo";

Parameter SQLDESCRIPTION = "RESID_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((RESID_DateFrom <= CURRENT_DATE OR RESID_DateFrom IS NULL) AND (RESID_DateTo >= CURRENT_DATE OR RESID_DateTo IS NULL))";

Parameter SQLROWID = "RESID_RowId";

}
