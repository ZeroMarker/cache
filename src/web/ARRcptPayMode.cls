Include webimport

IncludeGenerator webimport

Class web.ARRcptPayMode Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 237;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PAYM_AuthorCode";

Parameter SQLDESCRIPTION = "PAYM_RowId";

Parameter SQLROWID = "PAYM_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod FindPaymentDetailsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPaymentDetailsFetch ]
{
}

ClassMethod FindPaymentDetailsExecute(ByRef QHandle As %Library.Binary, ReceiptID As %String) As %Library.Status
{
}

ClassMethod FindPaymentDetailsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPaymentDetailsExecute ]
{
}

/// Log 59963 - 18.12.2007 - called in ARReceipts.Edit.js
ClassMethod GetPaymentDetails(PaymRowId As %Library.String, BillRowId As %Library.String = "") As %Library.String
{
}

Query FindPaymentDetails(ReceiptID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "PAYMAmt:%String,PAYMCardChequeNo:%String,PAYMAuthorCode:%String,CTPMDesc:%String,PAYMChequeDate:%Library.Date,CMCBMDesc:%String,ReceiptRowID,ReceiptNumber,PAYMBranch,PAYMDrawer,PAYMInvDate,PAYMInvTime,PAYMInvHospital,PAYMInvUser,CARDDesc,ReceiptDate,PAYMCardExpiryDate,AddUser:%String,AddHospital:%String,AddDate:%Date,AddTime:%Time,IncludedInBankRun:%String,InvReason:%String,Comments,RefundComments,CancelComments,PAYMInvUserCode,AddUserCode,AcctPeriodClosed,Currency,CurrencyAmt,PAYMRowId,ChangeAmt,TenderPay,RefundNo,ShiftStat,Hosp")
{
}

}
