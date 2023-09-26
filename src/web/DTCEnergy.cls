/// For Order Entry Diet Orders
Class web.DTCEnergy Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 311;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ENE_Code";

Parameter SQLDESCRIPTION = "ENE_Desc";

Parameter SQLROWID = "ENE_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod OrdItemPriceClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = OrdItemPriceFetch ]
{
}

ClassMethod OrdItemPriceExecute(ByRef QHandle As %Library.Binary, EpisodeID As %String, itemstr As %String, qtystr As %String, ordsetidstr As %String, billpricestr As %Library.String = "", uomstr As %Library.String = "", drugformstr As %Library.String = "") As %Library.Status
{
}

ClassMethod OrdItemPriceFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = OrdItemPriceExecute ]
{
}

ClassMethod GetMRHomeLoc(MRType As %Library.String = "") As %Library.String
{
}

Query LookUpEnergy(desc As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "ENEDesc:%String")
{
SELECT ENE_Desc
FROM SQLUser.DTC_Energy
WHERE ENE_Desc  %STARTSWITH  :desc
ORDER BY ENE_Desc
}

Query OrdItemPrice(EpisodeID As %String, itemstr As %String, qtystr As %String, ordsetidstr As %String, billpricestr As %String, uomstr As %String, drugformstr As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,Item:%String,Qty:%String,Price:%Library.Currency,Total:%Library.Currency")
{
}

}
