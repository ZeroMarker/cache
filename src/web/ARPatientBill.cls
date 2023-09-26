Include webimport

IncludeGenerator webimport

Class web.ARPatientBill Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 3244;

Parameter SQLCODE = "ARPBL_RowId";

Parameter SQLDATEFROM = "ARPBL_BillDateFrom";

Parameter SQLDESCRIPTION = "ARPBL_RowId";

Parameter SQLDATETO = "ARPBL_BillDateTo";

Parameter SQLROWID = "ARPBL_RowId";

Property dummy As %String(TRUNCATE = 1);

/*Log 48371 jpd*/
ClassMethod PrintBatchLetters()
{
}

/**
 * created for 46810, function to get the latest interim bill dates, as in VB log.28424
 *
 * Admission date must always be entered as the Date-From because backdated orders 
 * will never be billed if order dates are before the bill date. 
 */
ClassMethod GetInterimBillDefaultDates(EpisodeID As %Library.String)
{
}

/// Log 61793 - 08.01.2007 - 08.01.2007 - Remove selected bills/invoices from a batch
ClassMethod RemoveFromBatch(BillRowIDs As %Library.String = "")
{
}

/// Log 63664 - gets the TransType of a given BILL
ClassMethod GetBillTransType(BillRowId As %Library.String = "")
{
}

ClassMethod BillAdmission(PatientIDs As %Library.String = "", EpisodeIDs As %Library.String = "", BillRowIDs As %Library.String = "", BillType As %Library.String = "", DateFrom As %Library.Date = "", DateTo As %Library.Date = "")
{
}

ClassMethod CheckBeforeUnlink(EpisodeID As %Library.String = "", MasterID As %Library.String = "")
{
}

/**
 * SA 5.6.03 - log 35377: This method will automatically discontinue an item and rebill.
 * When discontinuing, no "Variance Reason" or "Reason for Discontinue" will be added 
 * (as entered in the OEOrder.ChangeStatus), as suggested by AW.
 */
ClassMethod DiscontOrdItemRebill(compref As %String = "", OEOrdItemID As %String = "", PatientID As %String = "", EpisodeID As %String = "", BillRowID As %String = "")
{
}

ClassMethod DiscontOrdItemRebillNew(compref As %String = "", OEOrdItemID As %String = "", PatientID As %String = "", EpisodeID As %String = "", BillRowID As %String = "")
{
}

ClassMethod HasPaymentTransaction(EpisodeID As %String = "") As %String
{
 q ""
}

ClassMethod DiscontCharges(compref As %String = "", OEOrdItemID As %String = "", VarReason As %String = "")
{
}

/// 64703 - Check if patbill has other bills linked (Split invoicing functionality). Return the linked invoice list.
ClassMethod CheckLinkedBills(patbill As %Library.String) As %Library.Integer
{
}

/// Log 64703 - 01.11.2007 - check if the order items belong to linked bills.
ClassMethod getBillsForOrders(OrdItemIds As %Library.String) As %Library.String
{
}

/// Log 64703 - 01.11.2007 - return a string with unique values
ClassMethod ReturnUnique(inStr As %Library.String) As %Library.String
{
}

ClassMethod CancelBill(compref As %Library.String = "", id As %Library.String = "", PatientID As %Library.String = "", EpisodeID As %Library.String = "", BillRowID As %Library.String = "", BillType As %Library.String = "", BillPrintDate As %Library.String = "")
{
}

ClassMethod CreateBatchBills(BillRowIDs As %Library.String)
{
}

ClassMethod FindAllClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAllFetch ]
{
}

/**
 * MVBARPB11 has a parameter which accepts ^ delimited values.
 * most of the request variables are coming from ARPatientBill.Find component.
 */
ClassMethod ConstructParam11() As %String
{
}

ClassMethod IncludeUnselectedBills(BillRowIDs As %Library.String = "", UnselBillRowIDs As %Library.String = "") As %String
{
}

ClassMethod IncludeUnselectedDeposits(DepositRowIDs As %Library.String = "", UnselDepositRowIDs As %Library.String = "") As %String
{
}

ClassMethod GetParams() As %String
{
}

/// Log 61623 - 24.11.2006 - Passed GroupType,SelAdmissionType,BillStatus and RegistrationNo as new parameters
ClassMethod FindAllExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String = "", Hospital As %Library.String = "", GroupType As %Library.String = "", SelAdmissionType As %Library.String = "", BillStatus As %Library.String = "", RegistrationNo As %Library.String = "") As %Library.Status
{
}

ClassMethod FindAllFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindAllExecute ]
{
}

ClassMethod CheckIfPaymAllocExists(BillRowID As %Library.String = "") As %Library.String
{
}

ClassMethod GetImageForPaymAlloc(BillRowID As %Library.String = "") As %Library.String
{
}

ClassMethod GetComment(EpisodeID As %Library.String = "") As %Library.String
{
}

ClassMethod GetImageForComment(EpisodeID As %Library.String = "", BillType As %Library.String = "") As %Library.String
{
}

ClassMethod GetImageForAppliedShare(PAAdmInsID As %Library.String = "") As %Library.String
{
}

ClassMethod FindChargesClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindChargesFetch ]
{
}

/// KK 7/Apr/2003 Log 32814
/// 
ClassMethod FindChargesExecute(ByRef QHandle As %Library.Binary, EpisodeID As %Library.String = "") As %Library.Status
{
}

ClassMethod FindChargesFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindChargesExecute ]
{
}

ClassMethod FindDebtorClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindDebtorFetch ]
{
}

ClassMethod FindDebtorExecute(ByRef QHandle As %Library.Binary, datefrom As %Library.Date = "", dateto As %Library.Date = "", surname As %Library.String = "") As %Library.Status
{
}

ClassMethod FindDebtorFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindDebtorExecute ]
{
}

ClassMethod FindAccomOrderClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAccomOrderFetch ]
{
}

ClassMethod FindAccomOrderExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String, EpisodeID As %Library.String, BillRowID As %Library.String, OrderItemID As %Library.String, BillOrdID As %Library.String, ARChOverrideID As %Library.String) As %Library.Status
{
}

ClassMethod FindAccomOrderFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindAccomOrderExecute ]
{
}

ClassMethod GetTranslationForTransType(TransType As %Library.String, ByRef t As %Library.String) As %Library.String
{
}

ClassMethod FindOrderBillClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindOrderBillFetch ]
{
}

/// Log 51144 - 01.09.2006 - added two in parameters 'EndDate' and 'BillSubGrpID'
ClassMethod FindOrderBillExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String, EpisodeID As %Library.String, BillRowID As %Library.String, StartDate As %Library.String, OEStatus As %Library.String, BillGroupID As %Library.String, EndDate As %Library.String, BillSubGrpID As %Library.String) As %Library.Status
{
}

ClassMethod FindOrderBillFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindOrderBillExecute ]
{
}

/// Log 55780 - 16.11.2006 - Get Bill Description according to setting in Order Item Details
ClassMethod GetBillDescription(OEOrdItemID As %Library.String = "") As %String
{
}

/// 44252
ClassMethod GetBatchDepositAndBillTotal(DepositRowIDs As %Library.String = "", BillRowIDs As %Library.String = "")
{
}

ClassMethod GetBatchDepositTotal(DepositRowIDs As %Library.String = "")
{
}

/**
 * New method created for 46940 which returns a pipe delimited bill row ids if a batch number is given
 * This method also gets called from web.ARReceipts.websysSaveBatch() method
 */
ClassMethod GetBillsWithBatchNumber(BatchNum As %Library.String) As %String
{
}

/**
 * Method created to retrieve the total bills or total bills by a batch no.
 * Used by :
 *   - ARPatientBill.FindBatch -> field CalculateTotal
 *   - ARReceipt.Edit -> ExistOutstandAmt
 */
ClassMethod GetBatchTotal(BillRowIDs As %Library.String, BatchNum As %Library.String)
{
}

/// Log 63534 - 09.05.2007 - Return allocated amounts for given bills
ClassMethod GetAllocBatchTotal(BillRowIDs As %Library.String, BatchNum As %Library.String)
{
}

ClassMethod GetEpisodeDischargeType(EpisodeID As %String = "") As %String
{
}

/// Log 59697 - 15.06.2006 - Check if the Manual Batch Number already exists
ClassMethod CheckBatchNumber(ManuBatchNum As %String = "") As %String
{
}

/**
 * Log 61117 - 29/11/2006 - Method created to chk whether to give warning if episode has an 
 * outstanding amount. 
 */
ClassMethod OutstandingAmtWarning(EpisodeID As %String = "") As %String
{
}

/**
 * Log 60876 - 06/10/2006 - Method created to retrieve the total outstanding amount 
 * against an episode. Used in DisplayOutstIcon().
 */
ClassMethod GetEpisodeOutstandAmt(EpisodeID As %String = "") As %String
{
}

/**
 * Log 60876 - 06/10/2006 - Method created to check whether to display Icon indicating
 * there is an oustanding amount against an episode. 
 */
ClassMethod DisplayOutstIcon(EpisodeID As %String = "") As %String
{
}

/**
 * Log 60876 - 24/10/2006 - Method created to retrieve the total outstanding amount 
 * against a patient. Used in DisplayOutstIcon().
 */
ClassMethod GetPatientOutstandAmt(PatientID As %String = "") As %String
{
}

/**
 * Log 60876 - 06/10/2006 - Method created to check whether to display Icon indicating
 * there is an oustanding amount against a patient. 
 */
ClassMethod DisplayPatOutstIcon(PatientID As %String = "") As %String
{
}

/**
 * Method created to retrieve the total previous outstanding amount against a patient.
 * Invoked by "ID" field on ARReceipt.Edit
 * Results displayed on fields: "ExistOutstandAmt", "TotalBillAmt", "RemainPayAmt", "DepositAmountTotal"
 */
ClassMethod GetExistingOutstanding(PatientID As %Library.String, EpisodeID As %Library.String, BillRowIDs As %Library.String, BillType As %Library.String, DepositIDs As %Library.String)
{
}

ClassMethod RoundNumber(x As %Library.String) As %Library.Float
{
}

/// Log 65095
ClassMethod CheckBill(Bill As %Library.String) As %Library.Integer
{
}

ClassMethod GetTotalsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetTotalsFetch ]
{
}

ClassMethod GetTotalsExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String = "", BillRowIDs As %Library.String = "", Hospital As %Library.String = "") As %Library.Status
{
}

ClassMethod GetTotalsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetTotalsExecute ]
{
}

ClassMethod LookUpBillNoBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", Payor As %Library.String, Hospital As %Library.String = "", IncludePaidInvoice As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpBillNoClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpBillNoFetch ]
{
}

ClassMethod LookUpBillNoExecute(ByRef QHandle As %Library.Binary, BillNo As %Library.String = "", Payor As %Library.String = "", Hospital As %Library.String = "", IncludePaidInvoice As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpBillNoFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpBillNoExecute ]
{
}

/** 
 * AJI - 28.01.04 log36748 - with the introduction of Sundry Debtors, 
 * we must differentiate method call
 */
ClassMethod websysSaveAddCharges(compref As %Library.String = "", id As %Library.String = "")
{
}

/**
 * KK 4/Apr/2003 Log 32814 - QH - ARPatientBill.EditCharges - Update
 */
ClassMethod addCharges(compref As %Library.String = "", id As %Library.String = "")
{
}

ClassMethod GetOrdItemReceivingLocation(OrdItemID As %Library.String = "", EpisodeID As %Library.String = "") As %Library.String
{
}

ClassMethod OrdItemReadyToBill(OrdItemID As %Library.String) As %Library.String
{
}

ClassMethod AllOrdItemReadyToBill(EpisodeID As %Library.String) As %Library.String
{
}

ClassMethod addSundryCharges(compref As %Library.String = "", id As %Library.String = "")
{
}

ClassMethod MultiPatBillFindAllClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = MultiPatBillFindAllFetch ]
{
}

ClassMethod MultiPatBillFindAllExecute(ByRef QHandle As %Library.Binary, RegistrationNo As %String, SelAdmissionType As %String, AdmDateFrom As %String, AdmDateTo As %String, AdmLocID As %String, BillStatus As %String) As %Library.Status
{
}

ClassMethod MultiPatBillFindAllFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = MultiPatBillFindAllExecute ]
{
}

/// 50856
/// Log 60884 - 13/10/2006 - New parameters AdmDateFrom and AdmDateTo
ClassMethod GetBillAmountsExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String = "", Hospital As %Library.String = "", AdmDateFrom As %Library.String = "", AdmDateTo As %Library.String = "") As %Library.Status
{
}

ClassMethod GetBillAmountsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetBillAmountsExecute ]
{
}

ClassMethod GetBillAmountsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetBillAmountsFetch ]
{
}

ClassMethod GetBillAmountsByBillIDsExecute(ByRef QHandle As %Library.Binary, BillRowIDs As %Library.String = "") As %Library.Status
{
}

ClassMethod GetBillAmountsByBillIDsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetBillAmountsByBillIDsExecute ]
{
}

ClassMethod GetBillAmountsByBillIDsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetBillAmountsFetch ]
{
}

ClassMethod OIReadyForBilling(EpisodeID As %Library.String = "") As %Library.Integer
{
}

ClassMethod WTReadyForBilling(EpisodeID As %Library.String = "") As %Library.Integer
{
}

ClassMethod FindBillsByBatchNoExecute(ByRef QHandle As %Library.Binary, BatchNo As %Library.String = "") As %Library.Status
{
}

ClassMethod FindBillsByBatchNoFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindBillsByBatchNoExecute ]
{
}

ClassMethod FindBillsByBatchNoClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindBillsByBatchNoFetch ]
{
}

ClassMethod GetSurmountCoPayment(BillRowID As %Library.String = "")
{
}

Query FindBillsByBatchNo(BatchNo As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "BillRowID")
{
}

/// /Log 60884 - 13/10/2006 - Added parameters AdmDateFrom and AdmDateTo
Query GetBillAmounts(PatientID As %String, Hospital As %String, AdmDateFrom As %String, AdmDateTo As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "InvTotal,RecDepTot,AdjTotal,DiscTotal,PayorID,BillType,current,day30,day60,day90,day120,OutstandAmt,TransType")
{
}

Query GetBillAmountsByBillIDs(BillRowIDs As %String, Hospital As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "InvTotal,RecDepTot,AdjTotal,DiscTotal,PayorID,BillType,current,day30,day60,day90,day120,OutstandAmt,TransType")
{
}

Query Find(PatientID As %String, EpisodeID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ARPBLBillNo:%String,ARPBLAmountToPay:%Float,PAADMADMNo:%String,PAADMAdmDate:%Date,INSTDesc:%String")
{
SELECT ARPBL_RowID, ARPBL_BillNo, ARPBL_AmountToPay, ARPBL_PAADM_DR->PAADM_ADMNo, ARPBL_PAADM_DR->PAADM_AdmDate, ARPBL_InsuranceType_DR->INST_Desc
FROM AR_PatientBill, PA_Adm, PA_PatMas
WHERE AR_PatientBill.ARPBL_PAADM_DR = PA_Adm.PAADM_RowId
AND PA_PatMas.PAPMI_RowId = PA_Adm.PAADM_PAPMI_DR
AND PA_PatMas.PAPMI_RowId = :PatientID
AND AR_PatientBill.ARPBL_PayorType = 'P'
AND ARPBL_AmountToPay > 0
}

Query MultiPatBillFindAll(RegistrationNo As %String, SelAdmissionType As %String, AdmDateFrom As %String, AdmDateTo As %String, AdmLocID As %String, BillStatus As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "PAADMRemark,ARPBLDatePrinted,PAADMADMNo,INSTDesc,ARPBLAdmDate,ARPBLDischDate,EpInvTot,InvTotal,OutstandAmt,PatientBillNo,PatInvTot,PayorBillNo,PayorInvTot,RecDepTot,AdjTotal,DiscTotal,EpisodeID,BillRowID,RecAllocID,TransType,PatientID,PayorID,PAPMINo,PAPERName,PAPERName2,PAPERName3,ReceiptID,BillType,DepositDate,BillStatus,INSExcess,INSMaxCoPaymentAmt,INSDailyCoPaymentAmt,INSSharedRoomCoPaymentAmt,DRGCode,CaseMixAdj,ARPBLNotesExist,BillPrinted,RefundDate:%String,current,day30,day60,day90,day120,AcctPeriodID,AcctPeriodClosed,PaymentClass,AccountClass,FollowUpIdent,EpisType,PayorCategory,EpisPayorCategory,ARBatchID,ARBatchNo,EpisodeOnHold,EDISentDate,EDI,InvNumber")
{
}

/// Log 61623 - 24.11.2006 - Passed GroupType,SelAdmissionType,BillStatus and RegistrationNo as new parameters
Query FindAll(PatientID As %String, Hospital As %String, GroupType As %String, SelAdmissionType As %String, BillStatus As %String, RegistrationNo As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "PAADMRemark,ARPBLDatePrinted,PAADMADMNo,INSTDesc,ARPBLAdmDate,ARPBLDischDate,EpInvTot,InvTotal,OutstandAmt,PatientBillNo,PatInvTot,PayorBillNo,PayorInvTot,RecDepTot,AdjTotal,DiscTotal,EpisodeID,BillRowID,RecAllocID,TransType,PatientID,PayorID,PAPMINo,PAPERName,PAPERName2,PAPERName3,ReceiptID,BillType,DepositDate,BillStatus,INSExcess,INSMaxCoPaymentAmt,INSDailyCoPaymentAmt,INSSharedRoomCoPaymentAmt,DRGCode,CaseMixAdj,ARPBLNotesExist,BillPrinted,RefundDate:%String,current,day30,day60,day90,day120,AcctPeriodID,AcctPeriodClosed,PaymentClass,AccountClass,FollowUpIdent,EpisType,PayorCategory,EpisPayorCategory,ARBatchID,ARBatchNo,EpisodeOnHold,EDISentDate,EDI,InvNumber,INSPayFrom,INSPayUntill,PAAdmInsID,PAPERName4,PAPERName5,PAPERName6,PAPERName7,PAPERName8,EDIOverriden,timeprinted,PatOutstandAmt,PayorOutstandAmt,PatPaidAmt,PayorPaidAmt,CapAdjustment,BillUpdateDate,PayorRef,LinkedToId,AmtPaid,Hosp")
{
}

Query FindCharges(EpisodeID) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,tdate,arcim,desc,price,qty,total,user,update,uptime,remarks,status,reason,reasondiscon,billstatus,OEORIUserUpdate,OEORIUserUpdateID,OEORIUserAddHospDR,OEORIUpdateDate,OEORIUpdateTime,ReadyForBilling,CTLocDesc")
{
}

Query FindDebtor(datefrom As %Library.Date, dateto As %Library.Date, surname As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "BillAmt,Surname,Givenname,Adminno,Registration,Admindate,Dischdate,Instype,OSAmount,PatientID")
{
}

/// Log 51144 - 01.09.2006 - added two in parameters 'EndDate' and 'BillSubGrpID'
Query FindOrderBill(PatientID As %Library.String, EpisodeID As %Library.String, BillRowID As %Library.String, StartDate As %Library.String, OEStatus As %Library.String, BillGroupID As %Library.String, EndDate As %Library.String, BillSubGrpID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "InvNum,TransDate,TransDateTo,TransType,Details,Qty,Price,GST,PatTotal,PayorTotal,BillRowID,RecNum,ARChOverrideID,OEOrderItemID,OEOrderItemCode,BillGroup,OrderCat,ReceivingLoc,OrderLoc,OrderStatus,ServTaxCode,ServTaxDesc,IsAccomOrder,IsNested,BillOrdID,ARPBLDateCancelled,ARPBLTimeCancelled,ARPBLUserCancelBillDRName,ARPBLUserCancelBillDRCode,ARPBLCancelHospitalDR,ARPBLReasonCancelDR,ARPBLCancelComments,InvNumOrig,priceb4,LEpisode,BillDesc")
{
}

Query FindAccomOrder(PatientID As %Library.String, EpisodeID As %Library.String, BillRowID As %Library.String, OrderItemID As %Library.String, BillOrdID As %Library.String, ARChOverrideID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "InvNum,TransDate,TransDateTo,TransType,Details,Qty,Price,GST,PatTotal,PayorTotal,BillRowID,RecNum,ARChOverrideID,OEOrderItemID,OEOrderItemCode,BillGroup,OrderCat,ReceivingLoc,OrderLoc,OrderStatus,ServTaxCode,ServTaxDesc")
{
}

/// Used by component ARPAtientill.ListTotals
Query GetTotals(PatientID As %String, BillRowIDs As %String, Hospital As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "PAPERName,PAPERName2,PAPERName3,PAPERRemark,PAPMINo,AllEpInvTot,DiscTot,DepRecTot,AdjTot,OutStdTot,current,day30,day60,day90,day120,Desc,UnallocDepTot,AllocRecTot")
{
}

Query LookUpBillNo(BillNo As %String, Payor As %String, Hospital As %String, IncludePaidInvoice As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ARPBLBillNo:%String,HIDDEN,INSTDesc,ARPBLDatePrinted,ARPBLAmountToPay,HIDDEN")
{
}

}
