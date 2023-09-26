Class web.PACSnomedTerms Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 96;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "SNOT_LanguageCode";

Parameter SQLDESCRIPTION = "SNOT_RowId";

Parameter SQLROWID = "SNOT_RowId";

ClassMethod LookUpDescExecute(ByRef QHandle As %Library.Binary, val As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpDescFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpDescExecute ]
{
}

ClassMethod LookUpDescClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpDescFetch ]
{
}

ClassMethod LookUpDescBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
}

Query LookUpDesc(val) As %Library.Query(ROWSPEC = "Description,HIDDEN,Code,HIDDEN,HIDDEN,Type")
{
}

}
