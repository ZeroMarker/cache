Class web.INCItmRcp Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 80;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "INREC_RowId";

Parameter SQLDESCRIPTION = "INREC_Desc";

Parameter SQLROWID = "INREC_RowId";

ClassMethod LookUpRecipesBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", ItemID As %String = "", locID As %String = "", Cat As %String = "", SubCat As %String = "", sterile As %String = "") As %Library.Boolean
{
}

Query LookUpRecipes(Item As %String, locID As %String, Cat As %String, SubCat As %String, sterile As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ItemDesc,HIDDEN, ItemCode")
{
	SELECT	DISTINCT INREC_ParRef->INCI_Desc, INREC_ParRef, INREC_ParRef->INCI_Code
	FROM	SQLUser.INC_ItmRcp,SQLUser.INC_ItmLoc
	WHERE (((%ALPHAUP INREC_Desc %STARTSWITH %ALPHAUP :Item)OR(:Item Is NULL))
	AND ((INREC_ParRef->INCI_ARCIM_DR->ARCIM_ItemCat_DR=:SubCat) OR (:SubCat is NULL))
    AND ((INREC_ParRef->INCI_ARCIM_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR=:Cat) OR (:Cat is NULL))
	AND ((INREC_ParRef->INCI_Sterile=:sterile) OR ((INREC_ParRef->INCI_Sterile IS NULL) AND (:sterile='N')) OR (:sterile IS NULL))
	AND ((:locID Is NULL) OR (INREC_ParRef->INCI_CTLOC_DR=:locID) OR (INREC_ParRef=INCIL_INCI_ParRef AND :locID=INCIL_CTLOC_DR))
	)
}

ClassMethod FindRecipesForStockClose(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindRecipesForStockFetch ]
{
}

ClassMethod FindRecipesForStockFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Library.Status [ PlaceAfter = FindRecipesForStockExecute ]
{
}

ClassMethod FindRecipesForStockExecute(ByRef QHandle As %Library.Binary, StockItem As %String, Rec As %String = "") As %Library.Status
{
}

Query FindRecipesForStock(StockItem As %String, Rec As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "HIDDEN,RecUOM,RecQty,RecDesc,ItemDesc,UOM,Quantity,ItemCode,AddCost,rcpingrestr")
{
}

}
