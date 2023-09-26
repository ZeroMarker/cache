Class web.PAWaitingListTransaction Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 243;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "TRANS_RowId";

Parameter SQLDESCRIPTION = "TRANS_RowId";

Parameter SQLROWID = "TRANS_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

/// for log 22761 GR. 
///  this is going to get the last transaction that changed the status of a waiting list entry.  
/// This is for the remove/reinstate screen within waiting list.  if it turns out they want the last time the item was 
/// removed or reinstated then it is just a matter of selecting items with a status of initial or removed, 
/// whatever the case may be
/// 
ClassMethod GetLastTransaction(id As %Library.String) As %Library.Boolean
{
}

/// rqg,Log28457: Update TRANS_PriorityChanged if passed param "PriorityChanged" is equal to "Y"
ClassMethod RecordHistory(id As %Library.String, PAWLAdmID As %Library.String = "", EffectiveDate As %Library.String = "", ReasonCode As %Library.String = "", TransactionFlag As %Library.String = "", BookingNumber As %Library.String = "", TCIStatus As %Library.String = "", WLStatus As %Library.String = "", RemovalDesc As %Library.String = "", PriorityChanged As %Library.String = "", NotAvailDR As %Library.String = "", onewl As %Library.String = "") As %Library.Boolean
{
}

/// SA 27.11.01: Used to retrieve ID and Date for subsequent sorting and full 
/// record retrieval by PAWaitingList.WaitListHostory
/// RQG Log22955/26.02.02: Changed to retrieve time as well
Query GetIDDateByParent(WaitingListID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Date,Time")
{
SELECT TRANS_RowId, TRANS_Date, TRANS_Time
FROM SQLUser.PA_WaitingListTransaction
WHERE TRANS_ParRef = :WaitingListID
}

/// Looks up the history for a waiting list entry
Query LookUpByWaitingListID(WaitingListID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID, TRANS_Date, TRANS_DateEffective, PARREF, TRANS_Time, WLS_Desc,SSUSR_Name, WLT_Desc, WLRC_Desc")
{
SELECT TRANS_RowId, TRANS_Date, TRANS_DateEffective, TRANS_ParRef, TRANS_Time, TRANS_Status_DR->WLS_Desc, TRANS_User_DR->SSUSR_Name, TRANS_WaitListType_DR->WLT_Desc, TRANS_ReasonForChange_DR->WLRC_Desc
FROM SQLUser.PA_WaitingListTransaction
WHERE (TRANS_ParRef = :WaitingListID)
ORDER BY TRANS_DateEffective DESC
}

}
