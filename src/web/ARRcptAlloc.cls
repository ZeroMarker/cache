Include webimport

IncludeGenerator webimport

Class web.ARRcptAlloc Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 117;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "ARRAL_AllocCode_DR";

Parameter SQLDESCRIPTION = "ARRAL_RowId";

Parameter SQLROWID = "ARRAL_RowId";

ClassMethod FindPaymAllocClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPaymAllocFetch ]
{
}

ClassMethod FindPaymAllocExecute(ByRef QHandle As %Library.Binary, ReceiptID As %String, BillRowID As %String = "") As %Library.Status
{
}

ClassMethod FindPaymAllocFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPaymAllocExecute ]
{
}

Query FindPaymAlloc(ReceiptID As %String, BillRowID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "RecRowId,RecNumber,PaymentAmt,UpdateDate,UpdateTime,UpdateUser,UpdateUserCode,AdmNo,RefundNo")
{
}

}
