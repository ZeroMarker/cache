Class web.RBCSessionType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 39;

Parameter SQLDATEFROM = "SESS_DateFrom";

Parameter SQLDATETO = "SESS_DateTo";

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "SESS_Code";

Parameter SQLDESCRIPTION = "SESS_Desc";

Parameter SQLROWID = "SESS_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

ClassMethod SessionTypes() As %String
{
}

}
