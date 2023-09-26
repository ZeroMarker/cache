Include webimport

IncludeGenerator webimport

Class web.PAAdm2QualStatHistory Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 23;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "QUAL_RowId";

Parameter SQLDESCRIPTION = "QUAL_RowId";

Parameter SQLROWID = "QUAL_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// ab 9.06.04 - 38153
ClassMethod AddNew(EpisodeID As %String = "", QualStat As %String = "")
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

}
