Class web.INCItmRecIngr Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 217;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "INRIN_RowId";

Parameter SQLDESCRIPTION = "INRIN_RowId";

Parameter SQLROWID = "INRIN_RowId";

ClassMethod UpdateQuantityBroker(itmjs As %Library.String, itmjsex As %Library.String = "", Quantity, row) As %Library.Boolean
{
}

ClassMethod websysAddItem(compref As %String)
{
}

/// ab 22.02.06 47755
/// checks if there are any interactions (drug-drug, generic and generic routed) between the NewItem and the
/// existing items in the recipe, and creates warning message
ClassMethod CheckInteractions(compref As %String, ManufactureID As %String, NewItem As %String, ErrorFlag As %String) As %String
{
}

ClassMethod websysDeleteItem()
{
}

ClassMethod getTotalVolume(ordid)
{
}

ClassMethod FindRecipeItemsForStockClose(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindRecipeItemsForStockFetch ]
{
}

ClassMethod FindRecipeItemsForStockFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Library.Status [ PlaceAfter = FindRecipeItemsForStockExecute ]
{
}

ClassMethod FindRecipeItemsForStockExecute(ByRef QHandle As %Library.Binary, ManufactureID As %String) As %Library.Status
{
}

/// ab 9.03.06 47755 - show the colonel's original recipe...
ClassMethod ShowRecipeList(StockID)
{
}

ClassMethod ShowRecipeListBUOM(StockID)
{
}

Query FindRecipeItemsForStock(ManufactureID As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "RowID,ItemCode,ItemDesc,Qty,AllPicked,DoseQty,DoseUom,Volume,UomQuan,Cost")
{
}

}
