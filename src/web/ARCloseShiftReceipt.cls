Class web.ARCloseShiftReceipt Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 114;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "REC_RowId";

Parameter SQLDESCRIPTION = "REC_RowId";

Parameter SQLROWID = "REC_RowId";

ClassMethod GetTotalAdjsutments(ShiftId As %Library.String) As %Library.Float
{
}

ClassMethod FindTransactionsClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindTransactionsFetch ]
{
}

ClassMethod FindTransactionsExecute(ByRef QHandle As %Binary, PARREF As %String, USER As %String) As %Status
{
}

ClassMethod FindTransactionsFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTransactionsExecute ]
{
}

Query FindTransactions(PARREF As %String, USER As %String) As %Query(ROWSPEC = "RowId:%String,ShftNo:%String,RcptId:%String,RcptNo:%String,RcptDate:%String,Loc:%String,UsrCode:%String,UsrName:%String,TOT:%String,Cash:%String,Cheque:%String,Card:%String,DirectAmt:%String,TransType:%String")
{
}

}
