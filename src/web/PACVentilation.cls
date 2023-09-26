Class web.PACVentilation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 23;

Property dummy As %Library.String(TRUNCATE = 1);

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "VENT_Code";

Parameter SQLDATEFROM = "VENT_DateFrom";

Parameter SQLDATETO = "VENT_DateTo";

Parameter SQLDESCRIPTION = "VENT_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((VENT_DateFrom <= CURRENT_DATE OR VENT_DateFrom IS NULL) AND (VENT_DateTo >= CURRENT_DATE OR VENT_DateTo IS NULL))";

Parameter SQLROWID = "VENT_RowId";

}
