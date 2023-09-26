Class web.PACWardTransaction Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 75;

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetCommentsByWard(WardID As %Library.String = "")
{
}

ClassMethod websysSaveComments(compref As %Library.String, ID As %Library.String, BMComments As %Library.String, Comments As %Library.String)
{
}

Parameter SQLCODE = "TRANS_RowId";

Parameter SQLDATEFROM = "TRANS_DateFrom";

Parameter SQLDATETO = "TRANS_DateTo";

Parameter SQLDESCRIPTION = "TRANS_RowId";

Parameter SQLROWID = "TRANS_RowId";

}
