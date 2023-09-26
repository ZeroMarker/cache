Class web.PAWaitingListScore Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right ]
{

Parameter BUILD = 5;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SC_RowId";

Parameter SQLDESCRIPTION = "SC_RowId";

Parameter SQLROWID = "SC_RowId";

ClassMethod GetLatestScore(wlid As %String) As %String
{
}

ClassMethod websysSaveScore(compref As %Library.String, ID As %String, PARREF As %String, score As %String)
{
}

ClassMethod websysDeleteScore(ID As %String)
{
}

ClassMethod ListWLScoreExecute(ByRef QHandle As %Binary, PARREF As %String = "") As %Status
{
}

ClassMethod ListWLScoreFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListWLScoreExecute ]
{
}

ClassMethod ListWLScoreClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = ListWLScoreFetch ]
{
}

Query ListWLScore(PARREF As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,SCScore,SCAssignmentDate,SCAssignmentTime,SCUpdateDate,SCUpdateTime,SCDeleteDate")
{
}

}
