Include webimport

IncludeGenerator webimport

Class web.MREvolution Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 145;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "EVO_RowId";

Parameter SQLDESCRIPTION = "EVO_RowId";

Parameter SQLROWID = "EVO_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetFirstRecord(mradm As %Library.String)
{
}

ClassMethod GetLastRecord(mradm As %Library.String)
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// update comment field of first record or new record
/// used from Order Entry update
ClassMethod websysSaveComment(mradm As %Library.String = "", txt As %Library.String = "")
{
}

ClassMethod websysSaveNew(compref As %String, ByRef id As %String) As %Boolean
{
}

}
