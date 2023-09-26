Class web.PAAdmWardAttend Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 87;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "WAT_RowId";

Parameter SQLDESCRIPTION = "WAT_RowId";

Parameter SQLROWID = "WAT_RowId";

/// ab 23.06.03 - called from transition expression in Trak.Ward Attendance
/// creates the first ward attender dummy episode to attach ward attender records to
ClassMethod CreateInitialEpisode(PatientID As %String = "") As %String
{
}

/// Creates the parent episode for multiple ward attendances
ClassMethod CreateWAEpisode(compref As %Library.String, PatientID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod FindWAClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindWAFetch ]
{
}

ClassMethod FindWAExecute(ByRef QHandle As %Library.Binary, EpisodeID As %Library.String = "", PatientID As %Library.String = "", WardID As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "") As %Library.Status
{
}

/// ab 12.01.03
/// used by paadmwardattend.list
/// uses 3 different indexes depending on what searched by
ClassMethod FindWAFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindWAExecute ]
{
}

/// ab 11.07.03 37308
/// returns the first ward attendance (if any) of an episode
/// used on PAAdmWardAttend.Edit to determine whether to tick first attendance box
ClassMethod GetFirstWA(EpisodeID As %String = "") As %String
{
}

/// check no existing episode for ward attendances exists
ClassMethod GetWAEpisode(PatientID As %String = "") As %Library.String
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %Library.String)
{
}

ClassMethod ValidateCodeTableDates(compref As %String, id As %String = "") As %String
{
}

Query FindWA(EpisodeID, PatientID, WardID, datefrom, dateto) As %Library.Query(CONTAINID = 0, ROWSPEC = "WAT_ParRef,WAT_RowId,WAT_Date,WAT_Time,WARD_Desc,CTLOC_Desc,CTPCP_Desc,INST_Desc,PAPMI_Name,PAPMI_Name2,PAPMI_Name3,PAPMI_DOB,CTSEX_Desc,PAADM_PAPMI_DR,PAPMI_No,VIPStatus")
{
}

}
