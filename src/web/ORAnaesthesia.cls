Class web.ORAnaesthesia Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 377;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ANA_RowId";

Parameter SQLDESCRIPTION = "ANA_RowId";

Parameter SQLROWID = "ANA_RowId";

ClassMethod addorder(id As %String = "", meth As %String = "", date As %String = "", stime As %String = "", etime As %String = "", ana As %String = "", rbopid As %String = "")
{
}

ClassMethod GetAnaPref(id As %Library.String) As %Boolean
{
}

ClassMethod GetRecPref(id As %Library.String) As %Boolean
{
}

ClassMethod ReverseStatus(id As %Library.String)
{
}

ClassMethod DiscontinueOrder(id As %String = "")
{
}

/// Returns a 0 or 1 depending on if there is data in the child tables
ClassMethod FindLinksStatus(id As %Library.String)
{
}

ClassMethod GetAgents(id As %Library.String = "") As %Library.String
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
/// Chandana Log 41693 19/1/04 - Add additional fields to the save method.
ClassMethod websysSave(compref As %String = "", id As %String = "")
{
}

ClassMethod GetAnaesthesiaDetailsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetAnaesthesiaDetailsFetch ]
{
}

ClassMethod GetAnaesthesiaDetailsExecute(ByRef QHandle As %Library.Binary, PatientID As %String, EpisodeID As %Library.String, EpisodesAll As %Library.String) As %Library.Status
{
}

ClassMethod GetAnaesthesiaDetailsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetAnaesthesiaDetailsExecute ]
{
}

/// Log 55973 - PC - 06-12-2005 : Save the selected rows as either "Include in DS Report" or "Exclude From DS Report".
ClassMethod IncludeExcludeDSReport(action As %Library.String = "E", RowIDs As %Library.String = "")
{
}

/// Log 41303 - AI - 15-12-2003 : Call relevant Query based on EpisodesAll (defined in Chart setup).
Query GetAnaesthesiaDetails(PatientID, EpisodeID, EpisodesAll = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,ANAPAADMParRef,ORAnaDate,ORAnaNo,ORAnaAnaesthetist,ORAnaTheatreInDate,ORAnaTheatreOutDate,ORAnaTheatreInTime,ORAnaTheatreOutTime,ORAnaConsultant,ORAnaMethod,ANAStatus,ANARBOPId,ANADSReportFlag,ANAPostOperInstructions")
{
}

}
