Class web.RBApptOutcome Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 60;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "OUTC_RowId";

Parameter SQLDESCRIPTION = "OUTC_RowId";

Parameter SQLROWID = "OUTC_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

ClassMethod ApptHasOutcome(AppointmentID As %Library.String = "", OutcomeID As %Library.String = "") As %Library.Boolean
{
}

/// Returns the most recent appointment outcome ID
ClassMethod GetLatestOutcome(ApptID As %Library.String) As %Library.String
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysDelete(id As %String = "")
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

Query FindOutcomesForAppointment(ApptID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "OutcomeID,OutcomeDesc, OutcomeUser,OutcomeDate,OutcomeTime")
{
Select OUTC_RowId,OUTC_ApOutcome_DR->OUTC_Desc,OUTC_User_DR->SSUSR_Name,OUTC_Date,OUTC_Time
From SQLUser.RB_ApptOutcome
Where OUTC_ParRef=:ApptID
Order by OUTC_Date DESC, OUTC_Time DESC
}

}
