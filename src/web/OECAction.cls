Class web.OECAction Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 30;

Parameter SQLDATEFROM = "ACT_DateFrom";

Parameter SQLDATETO = "ACT_DateTo";

Property dummy As %Library.String(TRUNCATE = 1);

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "ACT_Code";

Parameter SQLDESCRIPTION = "ACT_Desc";

Parameter SQLROWID = "ACT_RowId";

}
