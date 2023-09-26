Class web.RBAttendance Extends (%RegisteredObject, websys.Abstract) [ Inheritance = right ]
{

Parameter BUILD = 88;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ATT_RowId";

Parameter SQLDESCRIPTION = "ATT_RowId";

Parameter SQLROWID = "ATT_RowId";

ClassMethod GetOutcome(attID As %String) As %String
{
}

ClassMethod GetComment(attID As %String) As %String
{
}

ClassMethod GetTriageDetails(EpisodeID As %String) As %String
{
}

ClassMethod GetWaitingTimeSinceTriage(triageDate As %Date, triageTime As %Time) As %String
{
}

ClassMethod LinkAttendance(attendID As %String, EpisodeID As %String)
{
}

ClassMethod SaveAttendance(compref As %String, ID As %String)
{
}

ClassMethod FindAttendanceClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindAttendanceFetch ]
{
}

ClassMethod FindAttendanceExecute(ByRef QHandle As %Binary, PatientID As %String = "", DateFrom As %Date = "", DateTo As %Date = "", hidOutcome As %String = "", lock As %String = "") As %Status
{
}

ClassMethod FindAttendanceFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAttendanceExecute ]
{
}

Query FindAttendance(PatientID As %String, DateFrom As %Date, DateTo As %Date, hidOutcome As %String, lock As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,patientID,attDate,attTime,triageDate,triageTime,triageLoc,triageServ,triageCat,outcome,booking,triageCP,triageCPRole,payer,plan,surname,forename,midname,dob,gender,walkins,comments,first,cancelReason,EpisodeID,icon,rego,priority")
{
}

}
