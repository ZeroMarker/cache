Class web.PACReferralPriority Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 81;

Parameter SQLDATEFROM = "REFPRI_DateFrom";

Parameter SQLDATETO = "REFPRI_DateTo";

Parameter SQLCODE = "REFPRI_Code";

Parameter SQLDESCRIPTION = "REFPRI_Desc";

Parameter SQLROWID = "REFPRI_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

/// This function shows if a warning is required when making an appointment 
/// that is outside of the maximum waiting time based on the Hospital and
/// Referral Priority.  The Hospital has flagged if any warning is to be
/// given.  The referral priority has the number of days after which
/// the user must be warned.
ClassMethod ReferralPriorWarning(EpisodeID As %String = "", ScheduleIDs As %String = "", TransAppt As %String = "") As %Boolean
{
}

}
