Class web.RBEventTimesFacilitators Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 42;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod websysSave(compref As %String, id As %String = "", parref As %Library.String = "")
{
}

Parameter SQLCODE = "TF_RowId";

Parameter SQLDESCRIPTION = "TF_RowId";

Parameter SQLROWID = "TF_RowId";

}
