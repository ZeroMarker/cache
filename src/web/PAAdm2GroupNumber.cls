Class web.PAAdm2GroupNumber Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 81;

Parameter SQLCODE = "GRP_RowId";

Parameter SQLDATEFROM = "GRP_DateFrom";

Parameter SQLDATETO = "GRP_DateTo";

Parameter SQLDESCRIPTION = "GRP_RowId";

Parameter SQLROWID = "GRP_RowId";

ClassMethod ListGroupNumbersClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListGroupNumbersFetch ]
{
}

ClassMethod ListGroupNumbersExecute(ByRef QHandle As %Library.Binary, EpisodeID As %Library.String = "") As %Library.Status
{
}

ClassMethod ListGroupNumbersFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListGroupNumbersExecute ]
{
}

Query ListGroupNumbers(EpisodeID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "GRPRowID:%Library.String,GRPDateFrom:%Library.String,GRPDateTo:%Library.String,GRPNumber:%Library.String,GRPExemptionReason:%Library.String")
{
}

ClassMethod GroupNumberLookupBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "", EpisodeID As %Library.String = "", date As %Date = "", PatientID As %Library.String = "")
{
}

ClassMethod GroupNumberLookupClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GroupNumberLookupFetch ]
{
}

ClassMethod GroupNumberLookupExecute(ByRef QHandle As %Library.Binary, val As %String = "", EpisodeID As %Library.String = "", date As %Date = "") As %Library.Status
{
}

ClassMethod GroupNumberLookupFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GroupNumberLookupExecute ]
{
}

Query GroupNumberLookup(val As %String, EpisodeID As %Library.String, date As %Date) As %Library.Query(CONTAINID = 0, ROWSPEC = "GRPNumber:%Library.String,HIDDEN:%Library.String,HIDDEN:%String,HIDDEN:%String")
{
}

ClassMethod GetGroupNumbers(EpisodeID As %Library.String = "", valdate As %Date = "") As %Library.String
{
}

/// log60873 TedT
ClassMethod SaveGroupNumber(groupnum As %String, parref As %String, id As %String)
{
}

/// log61362 TedT
ClassMethod GroupNumberExist(EpisodeID As %String) As %String
{
}

}
