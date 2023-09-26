Class web.ARCSundryDebtor Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1262;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "DEB_Code";

Parameter SQLDESCRIPTION = "DEB_Desc";

Parameter SQLROWID = "DEB_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GenerateSundryCode() As %Library.String
{
}

ClassMethod GetSundryDetails(SundryID As %Library.String = "") As %Library.String
{
}

ClassMethod LookUpCareProvExecute(ByRef QHandle As %Library.Binary, Desc As %String = "") As %Library.Status
{
}

ClassMethod LookUpCareProvFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpCareProvExecute ]
{
}

ClassMethod LookUpCareProvClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpCareProvFetch ]
{
}

Query LookUpCareProv(Desc As %String) As %Query(CONTAINID = 0, ROWSPEC = "CTPCPDesc,CTPCPCode,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

/// Copy this method from CTCareProv and modify it to include address and contact details. Don't wanna mess around there.
/// 
ClassMethod LookUpCareProvBroker(itmjs As %String = "", itmjsex As %String = "", desc As %String = "", date As %Date = "", type As %String = "", flags As %String = "", cpt As %String = "", loc As %String = "") As %Library.Boolean
{
}

ClassMethod GetOutstandingAmount(SundryID As %Library.String = "") As %Library.String
{
}

ClassMethod CancelBill(compref As %Library.String = "", id As %Library.String = "", BillRowID As %Library.String = "")
{
}

ClassMethod DiscontinueOrderItemRebill(compref As %String = "", OEOrdItemID As %String = "")
{
}

ClassMethod FindOrderBillClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindOrderBillFetch ]
{
}

ClassMethod FindOrderBillExecute(ByRef QHandle As %Library.Binary, SundryID As %Library.String, BillRowID As %Library.String) As %Library.Status
{
}

ClassMethod FindOrderBillFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindOrderBillExecute ]
{
}

/// StartDate As %Library.String, OEStatus As %Library.String, BillGroupID As %Library.String
Query FindOrderBill(SundryID As %Library.String, BillRowID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "InvNum,TransDate,TransDateTo,TransType,Details,Qty,Price,OrdTotal,GST,ReturnedBillRowID,RecNum,ARChOverrideID,OEOrderItemID,OEOrderID,OEOrderItemCode,BillGroup,OrderCat,ReceivingLoc,OrderLoc,OrderStatus,ServTaxCode,ServTaxDesc")
{
}

ClassMethod FindSundryChargesClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindSundryChargesFetch ]
{
}

/// Used in component ARCSundryDebtor.ListCharges   
/// 
ClassMethod FindSundryChargesExecute(ByRef QHandle As %Library.Binary, OrderID As %Library.String = "") As %Library.Status
{
}

ClassMethod FindSundryChargesFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindSundryChargesExecute ]
{
}

Query FindSundryCharges(OrderID) As %Library.Query(CONTAINID = 0, ROWSPEC = "id,tdate,enddate,desc,price,qty,total,user,update,uptime,remarks,status,reason,reasondiscon,OEORIUserUpdate,OEORIUserUpdateID,OEORIUserAddHospDR,OEORIUpdateDate,OEORIUpdateTime")
{
}

ClassMethod FindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFetch ]
{
}

ClassMethod FindExecute(ByRef QHandle As %Library.Binary, Code As %Library.String, InvNumber As %Library.String, Desc As %Library.String, AltName As %Library.String, CareProvID As %Library.String, StartDate As %Library.Date, EndDate As %Library.Date, OutAmount As %Library.String, AgePeriod As %Library.String, SelHospital As %Library.String) As %Library.Status
{
}

ClassMethod FindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExecute ]
{
}

Query Find(Code As %Library.String, InvNumber As %Library.String, Desc As %Library.String, AltName As %Library.String, CareProvID As %Library.String, StartDate As %Library.String, EndDate As %Library.String, IsOutstanding As %Library.String, AgePeriod As %Library.String, SelHospital As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "SundryID,Code,Desc,Outstanding,AltName,CareProv,Address,AltAddress,Suburb,PostCode,Phone,Email,Fax,Hospital")
{
}

ClassMethod GetTotalsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetTotalsFetch ]
{
}

ClassMethod GetTotalsExecute(ByRef QHandle As %Library.Binary, SundryID As %Library.String = "", BillRowIDs As %Library.String = "") As %Library.Status
{
}

ClassMethod GetTotalsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetTotalsExecute ]
{
}

/// 23.01.04:: Used by component ARCSundryTotals.List
/// 
Query GetTotals(SundryID As %String, BillRowIDs As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "AllInvTot,DiscTot,DepRecTot,AdjTot,OutStdTot,current,day30,day60,day90,day120,Desc,AllocRecTot,UnallocDepTot")
{
}

/// Log 60693 - 29.08.2006 - Added new in parameter "BTCHLTTR"
ClassMethod GetBillsExecute(ByRef QHandle As %Library.Binary, SundryID As %Library.String = "", CareProvDesc As %Library.String = "", BatchNum As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", BillRowIDs As %Library.String = "", DepositRowIDs As %Library.String = "", Hospital As %Library.String = "", HiddenParams As %Library.String = "") As %Library.Status
{
}

ClassMethod GetBillsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetBillsExecute ]
{
}

ClassMethod GetBillsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetBillsFetch ]
{
}

/// component ARCSundryDebtor.ListBills
/// Log 60693 - 29.08.2006 - Added new in parameter "BTCHLTTR"
Query GetBills(SundryID As %String, CareProvDesc As %String, BatchNum As %String, DateFrom As %String, DateTo As %String, BillRowIDs As %String, DepositRowIDs As %String, Hospital As %String, HiddenParams As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "BillRowID,BillNo,SundryRowID,ARPBLDatePrinted,BillPrinted,InvTotal,OutstandAmt,RecDepTot,ReceiptID,RefundDate,AdjTotal,DiscTotal,TransType,TransTypeCode,BillType,Current,day30,day60,day90,day120,AcctPeriodClosed,ARPBLNotesExist,FollowUpIdent,SundryName,SundryCode,CareProv,AltName,DebRef")
{
}

ClassMethod GetTranslationForTransType(TransType As %Library.String, ByRef t As %Library.String) As %Library.String
{
}

ClassMethod LookUpBillNoClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpBillNoFetch ]
{
}

ClassMethod LookUpBillNoExecute(ByRef QHandle As %Library.Binary, BillNo As %Library.String = "", Hospital As %Library.String = "", CareProv As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpBillNoFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpBillNoExecute ]
{
}

Query LookUpBillNo(BillNo As %String, Hospital As %String, CareProv As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "Invoice Number:%String,HIDDEN,Date Bill Printed,Outstanding Amount,Sundry Debtor Name")
{
}

ClassMethod LookUpBillNoBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", BillNo As %Library.String = "", Hospital As %Library.String = "", CareProv As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpDepositClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpDepositFetch ]
{
}

/// WILL NEED TO CHANGE THIS AFTER  MVBARPB12S is ready
ClassMethod LookUpDepositExecute(ByRef QHandle As %Library.Binary, CareProv As %Library.String = "", RecNum As %Library.String = "", Hospital As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpDepositFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpDepositExecute ]
{
}

Query LookUpDeposit(CareProv, RecNum, Hospital) As %Library.Query(CONTAINID = 2, ROWSPEC = "Receipt Number,HIDDEN,Receip Date:%Library.Date,Amount,Sundry Debtor Name")
{
}

ClassMethod CreateBatchBills(BillRowIDs As %Library.String)
{
}

/// Method implemented to retrieve the total deposit 
/// amount of selected deposit ids passed.
ClassMethod GetBatchDepositTotal(DepositRowIDs As %Library.String = "")
{
}

ClassMethod GetBatchTotal(BillRowIDs As %Library.String)
{
}

ClassMethod websysDelete(id As %Library.String)
{
}

}
