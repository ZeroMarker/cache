Class web.PHCSkinTestOutcome Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 42;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SKTO_Code";

Parameter SQLDESCRIPTION = "SKTO_Desc";

Parameter SQLROWID = "SKTO_RowId";

ClassMethod GetDescriptionFromId(id As %Library.String) As %Library.String
{
}

ClassMethod LookUpTestExecute(ByRef QHandle As %Binary, val As %String = "", date As %Date = "") As %Status
{
}

ClassMethod LookUpTestFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpTestExecute ]
{
}

ClassMethod LookUpTestClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpTestFetch ]
{
}

ClassMethod LookUpTestBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Library.Boolean
{
}

Query LookUpTest(val As %String, date As %Date) As %Query(CONTAINID = 2, ROWSPEC = "Description:%String,Code:%String,HIDDEN:%String,HIDDEN:%String")
{
}

}
