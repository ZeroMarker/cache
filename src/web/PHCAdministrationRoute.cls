Class web.PHCAdministrationRoute Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 42;

Parameter SQLCODE = "ADMR_Code";

Parameter SQLDATEFROM = "ADMR_DateFrom";

Parameter SQLDATETO = "ADMR_DateTo";

Parameter SQLDESCRIPTION = "ADMR_Desc";

Parameter SQLFILTER = "((ADMR_DateFrom <=  CURRENT_DATE) OR (ADMR_DateFrom IS NULL)) AND ((ADMR_DateTo IS NULL) OR (ADMR_DateTo >=  CURRENT_DATE))";

Parameter SQLROWID = "ADMR_RowId";

Property dummy As %String(TRUNCATE = 1);

// JPD LOG 51878 

Query LookUpByRoute(val As %Library.String, Route As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "desc:%String,code:%String,HIDDEN:%String,type:%String,HIDDEN:%String")
{
}

ClassMethod LookUpByRouteExecute(ByRef QHandle As %Library.Binary, val As %Library.String, Route As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpByRouteFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByRouteExecute ]
{
}

ClassMethod LookUpByRouteClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByRouteFetch ]
{
}

ClassMethod LookUpByRouteBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", Route As %Library.String = "") As %Library.Boolean
{
}

}
