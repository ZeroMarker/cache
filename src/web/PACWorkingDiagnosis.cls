Class web.PACWorkingDiagnosis Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 23;

Property dummy As %Library.String(TRUNCATE = 1);

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "WORKDIA_Code";

Parameter SQLDATEFROM = "WORKDIA_DateFrom";

Parameter SQLDATETO = "WORKDIA_DateTo";

Parameter SQLDESCRIPTION = "WORKDIA_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((WORKDIA_DateFrom <= CURRENT_DATE OR WORKDIA_DateFrom IS NULL) AND (WORKDIA_DateTo >= CURRENT_DATE OR WORKDIA_DateTo IS NULL))";

Parameter SQLROWID = "WORKDIA_RowId";

}
