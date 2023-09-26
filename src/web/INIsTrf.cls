Class web.INIsTrf Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 126;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "INIT_RowId";

Parameter SQLDESCRIPTION = "INIT_RowId";

Parameter SQLROWID = "INIT_RowId";

ClassMethod TransferAckSave(trfID As %String) As %String
{
}

ClassMethod UpdateStockQty(trfRowId As %String, itemid As %String, reqLoc As %String, diffqty As %String)
{
}

ClassMethod trfStatus(trfID As %String) As %String
{
}

ClassMethod TransferAckFindClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = TransferAckFindFetch ]
{
}

ClassMethod TransferAckFindExecute(ByRef QHandle As %Binary, reqDateFrom As %Date = "", reqDateTo As %Date = "", requestID As %String = "", trDateFrom As %Date = "", trDateTo As %Date = "", transferID As %String = "", complete As %String = "", undelivered As %String = "", partDelivered As %String = "", reqLoc As %String = "", supLoc As %String = "", find As %String = "") As %Status
{
}

ClassMethod TransferAckFindFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TransferAckFindExecute ]
{
}

ClassMethod TransferItmListClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = TransferItmListFetch ]
{
}

ClassMethod TransferItmListExecute(ByRef QHandle As %Binary, ID As %String = "") As %Status
{
}

ClassMethod TransferItmListFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TransferItmListExecute ]
{
}

Query TransferAckFind(reqDateFrom As %Date, reqDateTo As %Date, requestID As %String, trDateFrom As %Date, trDateTo As %Date, transferID As %String, complete As %String, undelivered As %String, partDelivered As %String, reqLoc As %String, supLoc As %String, find As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "HIDDEN:%String,INITNo:%String,INRQNo:%String,INRQDate:%Date,INITDate:%Date,INITToLocDR:%String,INITFrLocDR:%String,INITAcknowCompleted:%String,status:%String")
{
}

Query TransferItmList(ID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "HIDDEN:%String,code:%String,desc:%String,reqQty:%String,trfQty:%String,ackQty:%String,uom:%String")
{
}

}
