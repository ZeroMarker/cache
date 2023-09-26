Class web.MRCEmergencyCondition Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 97;

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpActiveBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "EMC_Code";

Parameter SQLDATEFROM = "EMC_DateFrom";

Parameter SQLDATETO = "EMC_DateTo";

Parameter SQLDESCRIPTION = "EMC_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((EMC_DateFrom <= CURRENT_DATE OR EMC_DateFrom IS NULL) AND (EMC_DateTo >= CURRENT_DATE OR EMC_DateTo IS NULL))";

Parameter SQLROWID = "EMC_RowId";

}
