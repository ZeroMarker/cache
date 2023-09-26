Class web.ARPatBillPaymAlloc Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 401;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PAYM_RowId";

Parameter SQLDESCRIPTION = "PAYM_RowId";

Parameter SQLROWID = "PAYM_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod AutoAlloc(BillRowId As %String, PayAmt As %String = "", Mode As %String = "")
{
}

/** 
 * SA 20.3.03 - log 32817: This method is specific to functionality for QH only. 
 * - It will check the number of order items against the bill, where an amount is still owing on the item.
 * - If more than one item has an amount outstanding, it will return "Y"; otherwise "N"
 * - It will be used to determine whether the popup window for "item based receipt allocation" should appear,
 *   when a partial payment is being made against the bill.
 */
ClassMethod CheckOutstandingItemCount(BillRowID As %Library.String = "") As %Library.String
{
}

/// SA 20.3.03 - log 32817: This method will clear any payment allocations made against
/// the bill which have not yet been receipted (temporary globals). Existing payment allocations saved against a
/// receipt will remain in the DB.
ClassMethod ClearBillPaymAlloc(BillRowID As %Library.String = "") As %Library.String
{
}

/// SA 20.3.03 - log 32817: This method will clear any adjustment allocations made against
/// the bill which have not yet been saved (temporary globals). 
/// - Existing payment / adjustment allocations saved against a receipt will remain in the DB. 
/// - If a ^TMP global exists for that bill with Payment Allocations (ie. NOT adjustment allocations), it will NOT be cleared.
ClassMethod ClearBillAdjAlloc(BillRowID As %Library.String = "") As %Library.String
{
}

ClassMethod CreateBillPaymAlloc(BillRowID As %Library.String = "", GroupType As %Library.String = "") As %Library.Binary
{
}

ClassMethod FindForBillClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindForBillFetch ]
{
}

ClassMethod FindForBillExecute(ByRef QHandle As %Library.Binary, BillRowID As %Library.String = "", GroupType As %Library.String = "", Mode As %Library.String = "") As %Library.Status
{
}

ClassMethod FindForBillFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindForBillExecute ]
{
}

/// SA 11.7.01: Used by component ARPAtientill.ListAll
/// This query call one of two queries MVBARPB9 (which gets the list of bills/receipts 
/// for ONE patient) or MVBARPB11 (which gets a list associated with the selected Payor)
Query FindForBill(BillRowID, GroupType, Mode) As %Library.Query(CONTAINID = 0, ROWSPEC = "PayAllocID,ListDescription,ListBilledAmt,ListPrevAllocAmt,ListAmtAlloc,ListAmtRem,BillNumber,EpisodeNumber,RunningTotalAllocated,ListBillRowID")
{
}

ClassMethod websysSavePaymAlloc(compref As %Library.String, id As %Library.String = "")
{
}

/// SA 20.3.03 - log 32817: Method  to determine the bill group type for a bill
/// The bill group type is saved, when a previous partial payment receipt has been allocated to
/// the bill against this bill group type.
/// Bills can be grouped by (B-Billgroup, S-Bill Subgroup, I-Order Item)
/// 
ClassMethod GetBillGroupType(BillRowID As %Library.String = "", bGroupTypeChange As %Library.String = "") As %Library.String
{
}

/**
 * SA 20.3.03 - log 32817: Method called from ARReceipts.ListPayAlloc field "ID"
 * Sets amounts field on component
 */
ClassMethod GetPaymAlloc(BillRowID As %Library.String = "", PayAllocID As %Library.String = "", Mode As %Library.String = "") As %Library.String
{
}

/**
 * SA 20.3.03 - log 32817: Method called from ARReceipts.ListPayAlloc field "ID"
 * Sets amounts field on component
 */
ClassMethod GetTotalPaymAlloc(BillRowID As %Library.String = "", Mode As %Library.String = "", GroupType As %Library.String = "I") As %Library.String
{
}

ClassMethod XXXFindForBillClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = XXXFindForBillFetch ]
{
}

ClassMethod XXXFindForBillExecute(ByRef QHandle As %Library.Binary, BillRowID As %Library.String = "", GroupType As %Library.String = "", bGroupTypeChange As %Library.String = "") As %Library.Status
{
}

ClassMethod XXXFindForBillFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = XXXFindForBillExecute ]
{
}

/// SA 1.7.01 - To be called instead of websysSave to update total Write Off Amount from
/// ARPatbill (Parent table) as well as this child table. This function will then call the websysSave
ClassMethod XXXwebsysSavePaymAlloc(compref As %Library.String, id As %Library.String = "")
{
}

/// not completed. Please do not use
Query LookUpBillGrpByBillingGrp(BillItemDRs As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Amount:%Float,AmountPaid:%Float,BillingGroupDR")
{
 SELECT SUM(PAYM_BillAmount), SUM(PAYM_PaidSoFar), PAYM_BillGrp_DR
 FROM SQLUser.AR_PatBillPaymAlloc
 WHERE (PAYM_BillItem_DR = :BillItemDRs)
 GROUP BY PAYM_BillGrp_DR
}

/// SA 11.7.01: Used by component ARPAtientill.ListAll
/// This query call one of two queries MVBARPB9 (which gets the list of bills/receipts 
/// for ONE patient) or MVBARPB11 (which gets a list associated with the selected Payor)
Query XXXFindForBill(BillRowID, GroupType, bGroupTypeChange) As %Library.Query(CONTAINID = 0, ROWSPEC = "PayAllocID,ListDescription,ListBilledAmt,ListPrevAllocAmt,ListAmtAlloc,ListAmtRem")
{
}

}
