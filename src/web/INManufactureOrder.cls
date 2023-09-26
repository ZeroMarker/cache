Include webimport

IncludeGenerator webimport

Class web.INManufactureOrder Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 197;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "INMAN_RowId";

Parameter SQLROWID = "INMAN_RowId";

Parameter SQLCODE = "INMAN_RowId";

Query zManufactureOrder(TSRTITM, TSRTORD, Transaction As %String, StockItem As %String, User As %String, Location As %String, UOM As %String, DateFrom As %Date, DateTo As %Date, ShowCompleted As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "INMANRowId,INMANNo,INMANDate,INMANINCIDR,INMANUOMDR,INMANQty,INMANCTLOCDR,INMANUserDR,INMANStatus,INMANRecNumber")
{
 SELECT INMAN_RowId, INMAN_No, INMAN_Date, 
 		INMAN_INCI_DR->INCI_Desc, 
 		INMAN_UOM_DR->CTUOM_Desc, INMAN_Qty,
 		INMAN_CTLOC_DR->CTLOC_Desc,
 		INMAN_User_DR->SSUSR_Name,
 		INMAN_Status, INMAN_RecNumber
 FROM	SQLUser.IN_Manufacture_Order
 WHERE	(( INMAN_No = :Transaction ) OR (:Transaction Is NULL))
 AND	(( INMAN_INCI_DR->INCI_Desc = :StockItem ) OR (:StockItem Is NULL))
 AND	(( INMAN_Date >= :DateFrom ) OR (:DateFrom Is NULL))
 AND	(( INMAN_Date <= :DateTo ) OR (:DateTo Is NULL))
 AND	(( INMAN_CTLOC_DR->CTLOC_Desc = :Location ) OR (:Location Is NULL))
 AND	(( INMAN_UOM_DR->CTUOM_Desc = :UOM ) OR (:UOM Is NULL))
 AND	(( INMAN_User_DR->SSUSR_Name = :User ) OR (:User Is NULL))
 AND	((:ShowCompleted = 'on') OR NOT (INMAN_Status = 'C') OR (INMAN_Status Is NULL))
}

/// new query to get patient info for linked manufactureIDs
Query ManufactureOrder(TSRTITM, TSRTORD, Transaction As %String, StockItem As %String, User As %String, Location As %String, UOM As %String, DateFrom As %Date, DateTo As %Date, ShowCompleted As %String, catID As %String, subCatID As %String, OEORIItmMastDR As %String, sterile As %String, WardManuf As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "INMANRowId,INMANNo,INMANDate,INMANINCIDR,INMANUOMDR,INMANQty,INMANCTLOCDR,INMANUserDR,INMANStatus,INMANRecNumber,Rego,PAPMISurname,PAPMIGivenName,OrderItem,OrderSubcategory,OrderCategory")
{
}

ClassMethod ManufactureOrderExecute(ByRef QHandle As %Library.Binary, TSRTITM, TSRTORD, Transaction As %String, StockItem As %String, User As %String, Location As %String, UOM As %String, DateFrom As %Date, DateTo As %Date, ShowCompleted As %String, catID As %String, subCatID As %String, OEORIItmMastDR As %String, sterile As %String, WardManuf As %String) As %Library.Status
{
}

ClassMethod ManufactureOrderFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ManufactureOrderExecute ]
{
}

ClassMethod ManufactureOrderClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ManufactureOrderFetch ]
{
}

Query FindUOM(UOM As %String, StockItem As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "INMANUOMDR")
{

SELECT DISTINCT INREC_CTUOM_DR->CTUOM_Desc 
FROM SQLUser.INC_ItmRcp
WHERE INREC_ParRef = :StockItem
AND	(( INREC_CTUOM_DR->CTUOM_Desc %StartsWith :UOM ) OR (:UOM Is NULL))
}

ClassMethod DefQuan(ManufactureID As %String) As %String
{
}

ClassMethod CanModifyRecipe(ManufactureID As %String) As %Library.String
{
}

ClassMethod GetInstruction(ManufactureID As %String) As %Library.String
{
}

ClassMethod CheckRecipe(ManufactureID As %String, qtyRequired As %String = "")
{
}

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysSave(compref As %String, id As %String)
{
}

ClassMethod GetItmLocBatch(stockDR, loc, batch, expDate)
{
}

}
