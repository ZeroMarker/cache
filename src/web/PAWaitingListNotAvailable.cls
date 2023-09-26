Class web.PAWaitingListNotAvailable Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 438;

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "NA_RowId";

Parameter SQLDATEFROM = "NA_DateFrom";

Parameter SQLDESCRIPTION = "NA_RowId";

Parameter SQLDATETO = "NA_DateTo";

Parameter SQLROWID = "NA_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

ClassMethod CheckSuspensionsForDate(WaitingListID As %Library.String, Date As %Library.Date) As %Library.Boolean
{
}

ClassMethod CheckPriorSuspensions(WaitingListID As %Library.String, Date As %Library.Date) As %Library.Boolean
{
}

ClassMethod FindSuspensionsByIDClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindSuspensionsByIDFetch ]
{
}

ClassMethod FindSuspensionsByIDExecute(ByRef QHandle As %Library.Binary, WaitingListID As %String) As %Library.Status
{
}

ClassMethod FindSuspensionsByIDFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindSuspensionsByIDExecute ]
{
}

ClassMethod GetCurrentSuspensionDetails(WaitingListID As %Library.String)
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod GetLastUpdateDetails(WaitingListID As %String)
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysDeleteLastSuspension(compref As %String, id As %String)
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSaveWithNoOverlap(compref As %String, id As %String, prioritychanged As %String = "")
{
}

Query FindSuspensionsByID(WaitingListID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,udate:%Library.Date,fdate:%Library.Date,tdate:%Library.Date,reason:%String,reasongroup:%String,user:%String,PARREF:%String,comments,WLType:%String,RFLDesc:%String")
{
SELECT  NA_RowId, NA_Date, NA_DateFrom, NA_DateTo, NA_Reason_DR->REA_Desc, NA_Reason_DR->REA_ReasonGroup_DR->WLRG_Desc, NA_User_DR->SSUSR_Name, NA_ParRef, NA_Comments, NA_ParRef->WL_WaitListType_DR->WLT_Desc, NA_ParRef->WL_ReasonForList_DR->RFL_Desc
FROM SQLUser.PA_WaitingListNotAvailable
WHERE (NA_ParRef = :WaitingListID) and (NA_DateDelete='')
ORDER BY  NA_DateFrom DESC
}

/// SA 27.11.01: Used to retrieve ID and Date for subsequent sorting and full 
/// record retrieval by PAWaitingList.WaitListHostory
/// RQG 25.02.02: Revised copy of 'GetIDByParent' To retrieve effective 
/// date(NA_DateFrom), NA_date (NA_DateTo) and time (NA_Time).
Query GetIDDateByParent(WaitingListID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Date,Time,DateFrom,DateTo")
{
SELECT NA_RowId, NA_Date, NA_Time, NA_DateFrom, NA_DateTo
FROM SQLUser.PA_WaitingListNotAvailable
WHERE NA_ParRef = :WaitingListID
}

ClassMethod GetReviewDateX(WaitingListId As %Library.String) As %Library.String
{
}

}
