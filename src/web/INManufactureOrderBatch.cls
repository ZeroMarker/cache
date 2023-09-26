Class web.INManufactureOrderBatch Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 95;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MOBAT_RowId";

Parameter SQLDESCRIPTION = "MOBAT_RowId";

Parameter SQLROWID = "MOBAT_RowId";

ClassMethod websysDeleteItem(ROW As %String = "")
{
}

ClassMethod websysAddAll()
{
}

ClassMethod websysAddItem() As %Library.Status
{
}

ClassMethod TakeBatch(BatchID, Quantity, ManufactureID)
{
}

ClassMethod FindBatchesByLocClose(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindBatchesByLocFetch ]
{
}

ClassMethod FindBatchesByLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Library.Status [ PlaceAfter = FindBatchesByLocExecute ]
{
}

ClassMethod FindBatchesByLocExecute(ByRef QHandle As %Library.Binary, ManufactureID As %String, RecItmID As %String) As %Library.Status
{
}

ClassMethod FindBatchesClose(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindBatchesFetch ]
{
}

ClassMethod FindBatchesFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Library.Status [ PlaceAfter = FindBatchesExecute ]
{
}

ClassMethod FindBatchesExecute(ByRef QHandle As %Library.Binary, ManufactureID As %String, RecItmID As %String) As %Library.Status
{
}

ClassMethod UpdateQuantityBroker(itmjs As %Library.String, itmjsex As %Library.String = "", Quantity, row) As %Library.Boolean
{
}

Query FindBatches(ManufactureID, RecItmID As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "RowID,ItemCode,BatchNum,ExpDt,avail,Qty")
{
}

Query FindBatchesByLoc(ManufactureID, RecItmID As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "HIDDEN,Batch,Exp,Avail")
{
}

}
