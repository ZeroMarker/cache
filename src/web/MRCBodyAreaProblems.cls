Include webimport

IncludeGenerator webimport

Class web.MRCBodyAreaProblems Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 99;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "PROB_Code";

Parameter SQLDESCRIPTION = "PROB_Desc";

Parameter SQLROWID = "PROB_RowId";

ClassMethod LookUpByBodyAreaBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", val2 As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpByBodyAreaClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByBodyAreaFetch ]
{
}

ClassMethod LookUpByBodyAreaExecute(ByRef QHandle As %Library.Binary, Desc As %Library.String = "", BodyArea As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpByBodyAreaFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByBodyAreaExecute ]
{
}

Query LookUpByBodyArea(Desc As %Library.String = "", BodyArea As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "Problem:%String,BodyArea:%String,HIDDEN:%String")
{
}

}
