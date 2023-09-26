Class web.PACSourceOfIncome Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 27;

Property dummy As %Library.String(TRUNCATE = 1);

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "SRCINC_Code";

Parameter SQLDATEFROM = "SRCINC_DateFrom";

Parameter SQLDATETO = "SRCINC_DateTo";

Parameter SQLDESCRIPTION = "SRCINC_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((SRCINC_DateFrom <= CURRENT_DATE OR SRCINC_DateFrom IS NULL) AND (SRCINC_DateTo >= CURRENT_DATE OR SRCINC_DateTo IS NULL))";

Parameter SQLROWID = "SRCINC_RowId";

}
