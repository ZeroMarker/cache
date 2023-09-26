Class web.INCItm Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 181;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "INCI_Code";

Parameter SQLDESCRIPTION = "INCI_Desc";

Parameter SQLROWID = "INCI_RowId";

/// PC 7.07.06 59835
ClassMethod IsRecipeModified(OrderItem As %String = "") As %String
{
}

/// ab 22.02.06 56083
/// Log 55195 BoC 06-09-2006: lookup broker restricted by sterile
ClassMethod FindItemByLocBroker(itmjs As %String = "", itmjsex As %String = "", item As %String = "", CTLOC As %String, sterile As %String) As %Library.Boolean
{
}

/// Log 55195 BoC 06-09-2006: lookup restricted by sterile
Query FindItemByLoc(desc As %String, CTLOC As %String, sterile As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,Quantity:%String")
{
SELECT DISTINCT (INCLB_INCIB_DR->INCIB_INCI_ParRef->INCI_Desc),
INCLB_INCIB_DR->INCIB_INCI_ParRef->INCI_RowId,
INCLB_INCIB_DR->INCIB_INCI_ParRef->INCI_Code,
INCLB_PhyQty
FROM SQLUser.INC_ItmLcBt
WHERE (( INCLB_INCIL_ParRef->INCIL_CTLOC_DR =  :CTLOC )
AND	((%ALPHAUP INCLB_INCIB_DR->INCIB_INCI_ParRef->INCI_Desc %STARTSWITH %ALPHAUP :desc ) OR (:desc Is NULL))
AND (INCLB_PhyQty > 0)
AND ((INCLB_INCIL_ParRef->INCIL_INCI_ParRef->INCI_Sterile=:sterile) OR (:sterile IS NULL))
)
ORDER BY (INCLB_INCIB_DR->INCIB_INCI_ParRef->INCI_Desc) ASC
}

/// log59784 2006 TedT
/// 
ClassMethod GetReplenishOption(itemID As %String, loc As %String) As %String
{
}

ClassMethod RemoveItem(itemID As %String)
{
}

ClassMethod AddBelowLevel(reqId As %String)
{
}

ClassMethod GetItemIdFromGRFId(GRFId As %String) As %String
{
}

ClassMethod ItemLookupBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "", stockTakeGroup As %String = "", category As %String = "", reqId As %String = "", all As %String = "")
{
}

ClassMethod ItemLookupClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = ItemLookupFetch ]
{
}

ClassMethod ItemLookupExecute(ByRef QHandle As %Binary, val As %String = "", stockTakeGroup As %String = "", category As %String = "", reqId As %String = "", all As %String = "") As %Status
{
}

ClassMethod ItemLookupFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ItemLookupExecute ]
{
}

Query ItemLookup(val As %String, stockTakeGroup As %String, category As %String, reqId As %String, all As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "Desc:%String,HIDDEN:%String,Code:%String,BarCode:%String")
{
}

}
