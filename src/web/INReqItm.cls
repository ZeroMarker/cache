Class web.INReqItm Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 148;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "INRQI_RowId";

Parameter SQLDESCRIPTION = "INRQI_RowId";

Parameter SQLROWID = "INRQI_RowId";

ClassMethod GetConFac(UOM As %String = "", purchUOM As %String = "") As %String
{
}

ClassMethod AddItem(reqId As %String = "", itemId As %String = "", qty As %String = "")
{
}

ClassMethod Rounding(num As %String, decimal As %String) As %String
{
}

ClassMethod FindRequestItemClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindRequestItemFetch ]
{
}

ClassMethod FindRequestItemExecute(ByRef QHandle As %Binary, requestID As %String = "") As %Status
{
}

ClassMethod FindRequestItemFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRequestItemExecute ]
{
}

Query FindRequestItem(requestID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "HIDDEN:%String,INCICode:%String,INCIDesc:%String,INRQIReqQty:%String,INRQICTUOMDR:%String,INCIUnitCost:%String,PhyQty:%String,LogQty:%String,MaxMin:%String,repLevQty:%String,itemUOM:%String,purUOM:%String,Position:%String,GenericRouteForm:%String,Sequence:%String,supLogQty:%String")
{
}

}
