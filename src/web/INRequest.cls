Class web.INRequest Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 91;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "INRQ_RowId";

Parameter SQLDESCRIPTION = "INRQ_RowId";

Parameter SQLROWID = "INRQ_RowId";

ClassMethod UpdateRequest(reqID As %String)
{
}

ClassMethod GetReqItems(reqID As %String = "") As %String
{
}

ClassMethod GetTotalPrice(reqID As %String = "") As %String
{
}

ClassMethod GetLocFromReqID(type As %String = "", reqId As %String = "") As %String
{
}

ClassMethod FindRequestClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindRequestFetch ]
{
}

ClassMethod FindRequestExecute(ByRef QHandle As %Binary, dateFrom As %Date = "", dateTo As %Date = "", requestID As %String = "", recLoc As %String = "", supLoc As %String = "", complete As %String = "") As %Status
{
}

ClassMethod FindRequestFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRequestExecute ]
{
}

Query FindRequest(dateFrom As %Date, dateTo As %Date, requestID As %String, recLoc As %String, supLoc As %String, complete As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "HIDDEN:%String,INRQNo:%String,INRQDate:%Date,INRQRecLocDR:%String,INRQReqLocDR:%String,INRQUserCompleted:%String,items:%String")
{
}

}
