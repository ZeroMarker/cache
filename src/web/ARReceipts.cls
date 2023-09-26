Include webimport

IncludeGenerator webimport

Class web.ARReceipts Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1883;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ARRCP_RowId";

Parameter SQLDESCRIPTION = "ARRCP_RowId";

Parameter SQLROWID = "ARRCP_RowId";

Property dummy As %String(TRUNCATE = 1);

/**
 * Called from ARReceipts.EditMultiPay "Add" click
 */
ClassMethod AddPaymentDetail(compref As %Library.String, id As %Library.String, PayAmt As %Library.String, PayMethod As %Library.String, CMCBankDesc As %Library.String, PAYMCardChequeNo As %Library.String, Date As %Library.String, AuthCode As %Library.String, Branch As %Library.String, Drawer As %Library.String, CARDDesc As %Library.String, PAYMCardExpiryDate As %Library.String, Currency As %Library.String = "", CurrencyAmt As %Library.String = "")
{
}

ClassMethod CancelReceipt()
{
}

/**
 * This method is called from component ARReceipt.Edit upon loading, via ID field's ValueGet. 
 * Also from ARReceipts.EditMultiPay "DeleteAll" click
 */
ClassMethod ClearAllPaymentDetail()
{
}

/**
 * This method is called from component ARReceipt.Edit upon loading, via ID field's ValueGet. 
 * And from ARReceipts.EditMultiPay "DeleteAll" click
 */
ClassMethod ClearBatchTotals()
{
}

/**
 *  This method is called from ARReceipts.EditMultiPay table "Delete" click
 */
ClassMethod DeletePaymentDetail(RowNumber As %Library.String)
{
}

ClassMethod FindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFetch ]
{
}

ClassMethod FindExecute(ByRef QHandle As %Library.Binary, PatientIDParam As %Library.String, EpisodeIDParam As %Library.String, BillRowIDParam As %Library.String) As %Library.Status
{
}

ClassMethod FindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExecute ]
{
}

ClassMethod FindPaymentDetailsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPaymentDetailsFetch ]
{
}

ClassMethod FindPaymentDetailsExecute(ByRef QHandle As %Library.Binary) As %Library.Status
{
}

ClassMethod FindPaymentDetailsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPaymentDetailsExecute ]
{
}

ClassMethod FindReceiptPayorClose(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindReceiptPayorFetch ]
{
}

ClassMethod FindReceiptPayorExecute(ByRef QHandle As %Library.Binary, DateFrom As %Library.Date = "", DateTo As %Library.Date = "", Payor As %String = "", RecNumber As %String = "", InqTypeInvoice As %String = "", InqTypeReceipt As %String = "", Hospital As %String = "") As %Library.Status
{
}

ClassMethod FindReceiptPayorFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindReceiptPayorExecute ]
{
}

ClassMethod FindReceiptsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindReceiptsFetch ]
{
}

ClassMethod FindReceiptsExecute(ByRef QHandle As %Library.Binary, Cashier As %String = "", Location As %String = "", Date As %Library.Date, TimeFrom As %Library.Time = "", TimeTo As %Library.Time = "", DateTo As %Library.Date = "") As %Library.Status
{
}

ClassMethod FindReceiptsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindReceiptsExecute ]
{
}

ClassMethod FindInvoicePayorClose(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindInvoicePayorFetch ]
{
}

ClassMethod FindInvoicePayorExecute(ByRef QHandle As %Library.Binary, DateFrom As %Library.Date = "", DateTo As %Library.Date = "", Payor As %String = "", RecNumber As %String = "", InqTypeInvoice As %String = "", InqTypeReceipt As %String = "", EDI As %String = "", Printed As %String = "") As %Library.Status
{
}

ClassMethod FindInvoicePayorFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindInvoicePayorExecute ]
{
}

ClassMethod FindBatchInvNumBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", payor As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod FindBatchInvNumClose(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindBatchInvNumFetch ]
{
}

ClassMethod FindBatchInvNumExecute(ByRef QHandle As %Library.Binary, Payor As %String = "", RecNumber As %String = "") As %Library.Status
{
}

ClassMethod FindBatchInvNumFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindBatchInvNumExecute ]
{
}

ClassMethod GetDefaultPayMode()
{
}

/**
 * KK 9/May/2003 Log 32820 - To get the Full Name of the Patient from the PatientIds(same ids)  passed.
 *
 */
ClassMethod GetPatientFullName(PatientID As %Library.String = "") As %Library.String
{
}

/**
 * This method called upon loading ARReceipts.EditMultiPay
 *
 */
ClassMethod GetPaymentDetail()
{
}

/** 
  * Called by the web broker.
  * The main purpose is to convert from code to description dynamically.
  * itmjs - javascript function e.g. Location_lookupsel
  * itmjsex - extended javascript function
  */
ClassMethod LookUpUnusedPayorDepositBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", Payor As %Library.String = "", val As %Library.String = "", Hospital As %Library.String = "", PatSpecificDeposit As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpUnusedPayorDepositClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpUnusedPayorDepositFetch ]
{
}

ClassMethod LookUpUnusedPayorDepositExecute(ByRef QHandle As %Library.Binary, Payor As %Library.String = "", RecNum As %Library.String = "", Hospital As %Library.String = "", PatSpecificDeposit As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpUnusedPayorDepositFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpUnusedPayorDepositExecute ]
{
}

ClassMethod CalculateDirectCurrency(Currency As %Library.String = "", Amount As %Library.String = "") As %Library.String
{
}

ClassMethod CalculateIndirectCurrency(Currency As %Library.String = "", Amount As %Library.String = "") As %Library.Float
{
}

/// 44252
ClassMethod RecoupInvoice(BillRowID As %Library.String = "", RecoupedAmt As %Library.String = "")
{
}

/// 44252
ClassMethod GetRecoupAmtSoFar()
{
}

ClassMethod GetTotalAmountOfSelectedBills(BillRowIDs As %Library.String)
{
}

/// Log 63534
ClassMethod GetAllocAmtOfSelectedBills(BillRowIDs As %Library.String)
{
}

ClassMethod AllocatePayment(BillRowID As %Library.String = "", OutsAmt As %Library.String = "", BillsAmtTot As %Library.String = "", ReqdAmt As %Library.String = "", ReceiptAmt As %Library.String = "")
{
}

/// Log 59979 - 04/10/2006 - Create adjustment record automatically
ClassMethod DoAutoAdjust(BillRowID As %Library.String = "", OutsAmt As %Library.String = "", RoundReason As %Library.String = "") As %Library.String
{
}

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod ValidatePIN(UserCode As %Library.String = "", PIN As %Library.String = "") As %Library.String
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSaveBatch(compref As %Library.String, id As %Library.String, BillRowIDs As %Library.String = "", DepositRowIDs As %Library.String = "", BatchNum As %Library.String = "")
{
}

/// Log 59963
ClassMethod websysSavePaymDetails(compref As %Library.String, id As %Library.String)
{
}

/**
 *  This method gets called when making payments
 *
 *  Note:
 *  - All the dates parameter are converted in ARInsert^CPaymentUpdate
 *  
 *  Log 59360 - GC - 25-05-2006: Replaced all hardcoded messages with translatable constants
 */
ClassMethod websysSave(compref As %Library.String, id As %Library.String)
{
}

Query Edit(ID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ARRCPDiscAmt:%Float,ARCDIDesc:%String,ARRCPDiscRate:%Float,ARRCPRemarks:%List")
{
 SELECT ARRCP_RowID, ARRCP_DiscAmt, ARRCP_Discount_DR->ARCDI_Desc, ARRCP_DiscRate, ARRCP_Remarks
 FROM SQLUser.AR_Receipts
 WHERE ARRCP_RowID = :ID
}

Query Find(PatientIDParam As %Library.String, EpisodeIDParam As %Library.String, BillRowIDParam As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "InvNum,TransDate,TransType,Details,Qty,PatRate,PayorRate,GST,PatTotal,PayorTotal,EpisodeID,BillRowID")
{
}

Query FindPaymentDetails() As %Library.Query(CONTAINID = 0, ROWSPEC = "ListPayAmt,ListPayMethod,ListCMCBankDesc,ListPAYMCardChequeNo,ListDate,ListAuthCode,RecordCount,ListBranch,ListDrawer,ListCARDDesc,ListPAYMCardExpiryDate,ListCurrency,ListCurrencyAmt")
{
}

Query FindReceiptPayor(DateFrom As %Library.Date, DateTo As %Library.Date, Payor As %String, RecNumber As %String, InqTypeInvoice As %String, InqTypeReceipt As %String, Hospital As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "RecRowID,Payor,BatchRecDate,BatchRecNumber,BatchRecTotal,BatchRecDesc,Hospital")
{
}

Query FindReceipts(Cashier As %String, Location As %String, Date As %Library.Date, TimeFrom As %Library.Time, TimeTo As %Library.Time, DateTo As %Library.Date) As %Library.Query(CONTAINID = 0, ROWSPEC = "ReceiptID,ShiftNo,User,BillNo,ReceiptNo,RegNo,Surname,GivenName,OtherName,PaidAmt,RefundAmt,Hospital,InvalidPaym,InvalidAmt,RcptDate,Loc")
{
}

Query FindInvoicePayor(DateFrom As %Library.Date, DateTo As %Library.Date, Payor As %String, RecNumber As %String, InqTypeInvoice As %String, InqTypeReceipt As %String, EDI As %String, Printed As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "BatchRowID,Payor,PayorDesc,InvPrintDate,BatchInvNumber,DateCreated")
{
}

/// SA 11.7.01: Used by component ARPAtientill.ListAll
/// This query call one of two queries MVBARPB9 (which gets the list of bills/receipts 
/// for ONE patient) or MVBARPB11 (which gets a list associated with the selected Payor)
Query LookUpUnusedPayorDeposit(Payor, RecNum, Hospital, PatSpecificDeposit) As %Library.Query(CONTAINID = 0, ROWSPEC = "ReceiptNumber,HIDDEN,ReceiptDate:%Library.Date,Amount,PayorDesc")
{
}

Query FindBatchInvNum(Payor As %String, RecNumber As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Batch Invoice Number,Payor,Date Created,HIDDEN")
{
}

}
