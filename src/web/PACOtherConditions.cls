Class web.PACOtherConditions Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 24;

Property dummy As %Library.String(TRUNCATE = 1);

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "OTHCON_Code";

Parameter SQLDATEFROM = "OTHCON_DateFrom";

Parameter SQLDATETO = "OTHCON_DateTo";

Parameter SQLDESCRIPTION = "OTHCON_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((OTHCON_DateFrom <= CURRENT_DATE OR OTHCON_DateFrom IS NULL) AND (OTHCON_DateTo >= CURRENT_DATE OR OTHCON_DateTo IS NULL))";

Parameter SQLROWID = "OTHCON_RowId";

}
