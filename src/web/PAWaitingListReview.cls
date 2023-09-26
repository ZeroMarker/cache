Class web.PAWaitingListReview Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 210;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "REV_RowId";

Parameter SQLDESCRIPTION = "REV_RowId";

Parameter SQLROWID = "REV_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod GetLastUpdateDetails(WaitingListID As %String)
{
}

ClassMethod GetPreviousEpisodeDetails(PatientID As %Library.String, EpisodeID As %Library.String)
{
}

ClassMethod LetterSent(ids As %Library.String, type As %Library.String)
{
}

/// KK 30/May/2002 Log 24241 - To add new records to PAWaitingListReview. Called from all print events.
ClassMethod SavetoReviewonPrint(WaitingListIDs As %Library.String, StatusCode As %Library.String)
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String)
{
}

/// SA 27.11.01: Used to retrieve ID and Date for subsequent sorting and full 
/// record retrieval by PAWaitingList.WaitListHostory
/// RQG Log22955/26.02.02: Changed to include time
Query GetIDDateByParent(WaitingListID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Date,Time")
{
SELECT REV_RowId, REV_Date, REV_Time
FROM SQLUser.PA_WaitingListReview
WHERE REV_ParRef = :WaitingListID
}

}
