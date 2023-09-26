Include webimport

IncludeGenerator webimport

Class web.MRCBodyAreaProblemsSubp Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 98;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "SUBP_Code";

Parameter SQLDESCRIPTION = "SUBP_Desc";

Parameter SQLROWID = "SUBP_RowId";

ClassMethod LookUpByBodyAreaProblemsBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", val2 As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpByBodyAreaProblemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByBodyAreaProblemsFetch ]
{
}

ClassMethod LookUpByBodyAreaProblemsExecute(ByRef QHandle As %Library.Binary, Desc As %Library.String = "", Bodyareaproblem As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpByBodyAreaProblemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByBodyAreaProblemsExecute ]
{
}

Query LookUpByBodyAreaProblems(Desc As %Library.String = "", Bodyareaproblem As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "SubProblem:%String,Problem:%String,BodyArea:%String,HIDDEN:%String")
{
}

}
