Class web.MRCContractFlag Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 53;

Parameter SQLDATEFROM = "CONTFL_DateFrom";

Parameter SQLDATETO = "CONTFL_DateTo";

Parameter SQLCODE = "CONTFL_Code";

Parameter SQLDESCRIPTION = "CONTFL_Desc";

Parameter SQLROWID = "CONTFL_RowId";

ClassMethod LookUpCFBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", EpisodeID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpCFClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpCFFetch ]
{
}

/// KK 15/Apr/2003 Log 33703 - Modified SQL Query - date checks added.
ClassMethod LookUpCFExecute(ByRef QHandle As %Library.Binary, val As %Library.String = "", EpisodeID As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpCFFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpCFExecute ]
{
}

Query LookUpCF(val, EpisodeID) As %Library.Query(CONTAINID = 0, ROWSPEC = "Desc,HIDDEN,Code")
{
}

}
