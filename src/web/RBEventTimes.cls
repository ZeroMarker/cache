Class web.RBEventTimes Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 397;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "TIME_RowId";

Parameter SQLDESCRIPTION = "TIME_RowId";

Parameter SQLROWID = "TIME_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod CancelAttAppts(compref As %Library.String, id As %Library.String = "")
{
}

ClassMethod CancelEventTime(compref As %Library.String, id As %Library.String, cancelDr As %Library.String = "", transDr As %Library.String = "")
{
}

/// SB: Creates Event Appointments for CP's & Patients
/// Logs: 23945 - initial devs
///          28389 - Codetables
///          28801 - Date/Time table
///          28802 - Create Appointment functionality
ClassMethod CreateAppt(compref As %Library.String, id As %Library.String = "")
{
}

/// log 61289 TedT get appt id of arrived patients
ClassMethod GetApptIDs(EventID As %Library.String = "", EventDate As %Library.Date = "", EventTime As %Library.Time = "") As %Library.String
{
}

/// ab 20.01.03 - called from icon definition 'patient type - outpatient'
/// ab 20.10.03 - to speed up, use adm index when possible - also called from valadm1^CPAPerson
/// returns if any appts found for a patient/date/time and their ids
ClassMethod GetPatAppts(pat As %String = "", date As %String = "", stime As %String = "", etime As %String = "", resource As %String = "", eps As %String = "", dateto As %String = "") As %Library.String
{
}

ClassMethod Reschedule(compref As %Library.String, id As %Library.String, parref As %Library.String, mode As %Library.String = "")
{
}

ClassMethod UpdateAttendees(compref As %Library.String, id As %Library.String, rsvp As %Library.String = "", arrive As %Library.String = "")
{
}

ClassMethod ValResultsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ValResultsFetch ]
{
}

ClassMethod ValResultsExecute(ByRef QHandle As %Library.Binary, id As %Library.String) As %Library.Status
{
}

ClassMethod ValResultsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ValResultsExecute ]
{
}

ClassMethod checkOverlapTimes(date As %Library.String = "", stime As %Library.String = "", parref As %Library.String = "", id As %Library.String = "") As %Library.String
{
}

/// ; SB: Copied from MVBRBAS1... need to passback param in evId
ClassMethod isblocked(RESrow As %Library.String = "", Date As %Library.String = "", Time As %Library.String = "") As %Library.String
{
}

Query ValResults(id As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "name,date,time,reason,pat,episode")
{
}

}
