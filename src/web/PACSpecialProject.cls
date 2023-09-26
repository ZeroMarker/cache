Class web.PACSpecialProject Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 66;

Parameter SQLDATEFROM = "SPECPRO_DateFrom";

Parameter SQLDATETO = "SPECPRO_DateTo";

Parameter SQLCODE = "SPECPRO_Code";

Parameter SQLDESCRIPTION = "SPECPRO_Desc";

Parameter SQLROWID = "SPECPRO_RowId";

/// AJI 18.09.03 Log37966 - needs to filter based on hospital of user logon as well as activedate
Query LookUpWLSpecProject(desc As %String, hospDesc As %String, activeDate As %Library.Date) As %Library.Query(ROWSPEC = "Desc:%String,Code:%String,HIDDEN:%String")
{
}

ClassMethod LookUpWLSpecProjectExecute(ByRef QHandle As %Library.Binary, desc As %String = "", hospDesc As %String = "", activeDate As %Library.Date = "") As %Library.Status
{
}

ClassMethod LookUpWLSpecProjectFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpWLSpecProjectExecute ]
{
}

ClassMethod LookUpWLSpecProjectClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpWLSpecProjectFetch ]
{
}

ClassMethod LookUpWLSpecProjectBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", hospDesc As %Library.String = "", activeDate As %Library.Date = "") As %Library.Boolean
{
}

}
