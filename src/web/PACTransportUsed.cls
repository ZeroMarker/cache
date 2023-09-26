Class web.PACTransportUsed Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 27;

Property dummy As %Library.String(TRUNCATE = 1);

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "TRU_Code";

Parameter SQLDATEFROM = "TRU_DateFrom";

Parameter SQLDATETO = "TRU_DateTo";

Parameter SQLDESCRIPTION = "TRU_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((TRU_DateFrom <= CURRENT_DATE OR TRU_DateFrom IS NULL) AND (TRU_DateTo >= CURRENT_DATE OR TRU_DateTo IS NULL))";

Parameter SQLROWID = "TRU_RowId";

}
