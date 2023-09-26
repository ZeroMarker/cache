Include webimport

IncludeGenerator webimport

Class web.PAPersonPatMas Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 29;

Parameter SQLCODE = "PAPER_BillCode";

Parameter SQLDATEFROM = "PAPER_DiscDateFrom";

Parameter SQLDATETO = "PAPER_DiscDateTo";

Parameter SQLDESCRIPTION = "PAPMI_EPRDescription";

Parameter SQLROWID = "PAPER_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod InsertUpdate(EpisodeID As %Library.String) As %Library.String
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Library.Boolean
{
}

}
