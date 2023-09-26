Class web.PACSeparationReferral Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 33;

Property Dummy As %Library.String(TRUNCATE = 1);

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "SEPREF_Code";

Parameter SQLDATEFROM = "SEPREF_DateFrom";

Parameter SQLDATETO = "SEPREF_DateTo";

Parameter SQLDESCRIPTION = "SEPREF_Desc";

Parameter SQLROWID = "SEPREF_RowId";

}
