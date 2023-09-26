Class web.PACDrainTubes Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 23;

Property dummy As %Library.String(TRUNCATE = 1);

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "DRT_Code";

Parameter SQLDATEFROM = "DRT_DateFrom";

Parameter SQLDATETO = "DRT_DateTo";

Parameter SQLDESCRIPTION = "DRT_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((DRT_DateFrom <= CURRENT_DATE OR DRT_DateFrom IS NULL) AND (DRT_DateTo >= CURRENT_DATE OR DRT_DateTo IS NULL))";

Parameter SQLROWID = "DRT_RowId";

}
