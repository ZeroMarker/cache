Class web.SSGroupStockTakeGroup Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 10;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "STG_RowId";

Parameter SQLDESCRIPTION = "STG_RowId";

Parameter SQLROWID = "STG_RowId";

ClassMethod StockTakeGroupLookupBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "")
{
}

ClassMethod StockTakeGroupLookupClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = StockTakeGroupLookupFetch ]
{
}

ClassMethod StockTakeGroupLookupExecute(ByRef QHandle As %Binary, val As %String = "") As %Status
{
}

ClassMethod StockTakeGroupLookupFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StockTakeGroupLookupExecute ]
{
}

Query StockTakeGroupLookup(val As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "Desc:%String,HIDDEN:%String,Code:%String")
{
}

}
