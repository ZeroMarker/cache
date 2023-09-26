Class web.CTLocStockFavourites Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 35;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "STF_RowId";

Parameter SQLDESCRIPTION = "STF_RowId";

Parameter SQLROWID = "STF_RowId";

ClassMethod GetFavData(loc As %String, itemId As %String, grfID As %String) As %String
{
}

ClassMethod GetDefaultQty(favdata As %String = "", locdata As %String = "", itemdata As %String = "") As %String
{
}

ClassMethod AddFavourites(reqId As %String = "", replenish As %Boolean = 0, reqLoc As %String = "", supLoc As %String = "") As %String
{
}

}
