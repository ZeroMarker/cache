Class web.PACAccountClass Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 31;

Parameter SQLDATEFROM = "ACCL_DateFrom";

Parameter SQLDATETO = "ACCL_DateTo";

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "ACCL_Code";

Parameter SQLDESCRIPTION = "ACCL_Desc";

Parameter SQLROWID = "ACCL_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

}
