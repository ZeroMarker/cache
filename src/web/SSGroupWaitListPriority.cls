Class web.SSGroupWaitListPriority Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right ]
{

Parameter BUILD = 12;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "WLP_RowId";

Parameter SQLDESCRIPTION = "WLP_RowId";

Parameter SQLROWID = "WLP_RowId";

ClassMethod GroupWLPLookupBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "")
{
}

ClassMethod GroupWLPLookupClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GroupWLPLookupFetch ]
{
}

ClassMethod GroupWLPLookupExecute(ByRef QHandle As %Library.Binary, val As %String = "") As %Library.Status
{
}

ClassMethod GroupWLPLookupFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GroupWLPLookupExecute ]
{
}

Query GroupWLPLookup(val As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "PriorityDesc:%Library.String,HIDDEN:%String,PriorityCode:%String")
{
}

}
