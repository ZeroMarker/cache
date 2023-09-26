Class web.RTMasVolAdm Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 123;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetDetails(PARREF As %Library.String)
{
}

ClassMethod websysInsert(ParRef As %Library.String, EpisodeID As %Library.String)
{
}

Parameter SQLCODE = "ADM_RowId";

Parameter SQLDESCRIPTION = "ADM_RowId";

Parameter SQLROWID = "ADM_RowId";

}
