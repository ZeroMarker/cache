Class web.SSGroupStockLocations Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 21;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ST_RowId";

Parameter SQLDESCRIPTION = "ST_RowId";

Parameter SQLROWID = "ST_RowId";

ClassMethod StockLocLookupBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "")
{
}

ClassMethod StockLocLookupClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = StockLocLookupFetch ]
{
}

ClassMethod StockLocLookupExecute(ByRef QHandle As %Binary, val As %String = "") As %Status
{
}

ClassMethod StockLocLookupFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StockLocLookupExecute ]
{
}

Query StockLocLookup(val As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "Desc:%String,HIDDEN:%String,Code:%String")
{
}

}
