Class web.CTCareProvGroup Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 23;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property Dummy As %Library.String(TRUNCATE = 1);

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "CPG_Code";

Parameter SQLDESCRIPTION = "CPG_Desc";

Parameter SQLROWID = "CPG_RowId";

}
