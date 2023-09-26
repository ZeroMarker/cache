Class web.RBResEffDateSession Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1867;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

/// Returns the first session for a give resource and date
ClassMethod FirstSession(res As %String = "", date As %String = "") As %Library.String
{
}

/// This returns the next and previous session id and appropriate dates in the form
/// 
/// prevsessionID^prevDate^nextsessionID^nextDate
ClassMethod NextPrevSessions(SessionID As %String = "", Date As %String = "", res As %String = "") As %String
{
}

/// Log 41687: This function converts minutes to Hours and Minutes
ClassMethod ConvertMinsToHM(minutes As %Integer = 0)
{
}

/// This function brings back the amoutn of time in minute for
/// an operating theatre.  Note that a session for an operating theatre
/// normally consists of one slot that can be book multiple time
/// and hence the sum of the appointment durations will represent
/// the amount of time used in a session. Have to allow for unavailable time
/// for the operating theatre.
/// scEndTime - used to check schedule duration before updating. Prevents shortening schedule when appts are fully booked.
ClassMethod TimeLeftInOTSession(SessionID As %String = "", date As %String = "", ScheduleID As %String = "", scEndTime As %String = "")
{
}

Parameter SQLCODE = "SESS_RowId";

Parameter SQLDESCRIPTION = "SESS_Desc";

Parameter SQLROWID = "SESS_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod FindSessByRSDateClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindSessByRSDateFetch ]
{
}

/// KM: Oct 2001: Called from component RBResEffDateSession.List
ClassMethod FindSessByRSDateExecute(ByRef QHandle As %Library.Binary, RescID As %Library.String, date As %Library.Date) As %Library.Status
{
}

ClassMethod FindSessByRSDateFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindSessByRSDateExecute ]
{
}

ClassMethod FindSessionDetailsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindSessionDetailsFetch ]
{
}

/// KM: Oct 2001: Called from component RBResEffDateSession.List
ClassMethod FindSessionDetailsExecute(ByRef QHandle As %Library.Binary, RBSessIDs As %Library.String, eDate As %Library.String = "", allsess As %Library.String, showbuttons As %Library.String = 0) As %Library.Status
{
}

ClassMethod FindSessionDetailsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindSessionDetailsExecute ]
{
}

ClassMethod GetSessDetails(sID, eDate) As %Library.String
{
}

ClassMethod ConvertSessType(cSessID, cdate, csesstype)
{
}

ClassMethod BookingDetails(sRescID, sdate)
{
}

ClassMethod GetSessMessages(ResID As %Library.String, Date As %Library.String = "", SessTypeId As %Library.String = "", SessId As %Library.String = "") As %Library.String
{
}

/// Log 58895 - GC - 17-05-2006: This method returns list of Session Descriptions for a particular resource, date, session type and session id (if provided)
ClassMethod GetSessDesForDate(ResID As %Library.String, Date As %Library.String = "", SessTypeId As %Library.String = "", SessId As %Library.String = "") As %Library.String
{
}

ClassMethod GetSessionType(Location As %Library.String = "", Resource As %Library.String = "", Date As %Library.String = "", Time As %Library.String = "") As %Library.String
{
}

ClassMethod GetSchedsForSession(Date As %Library.String = "", ResId As %Library.String = "", SessRow As %Library.String = "") As %Library.String
{
}

/// This finds all the sessions on a given date independent of resource (limits by any location lists).
ClassMethod GetSessionsForDate(Date As %Library.String = "") As %Library.String
{
}

ClassMethod GetSessionTimesforDate(Date As %Library.String = "", Res As %Library.String = "") As %Library.String
{
}

ClassMethod RetainValue()
{
}

ClassMethod LookUpBrokerSessDesc(itmjs As %Library.String = "", itmjsex As %Library.String = "", ClinDesc As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpBrokerSessDescParam(itmjs As %Library.String = "", itmjsex As %Library.String = "", ClinDesc As %Library.String = "") As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerSessType(itmjs As %Library.String = "", itmjsex As %Library.String = "", ClinDesc As %Library.String = "", CTLOCDesc As %Library.String = "", RESDesc As %Library.String = "", DOW As %Library.String = "", GroupID As %Library.String) As %Library.Boolean
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpCPActivityClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpCPActivityFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpCPActivityExecute(ByRef QHandle As %Library.Binary, CareProvID As %Library.String = "", datefrom As %Library.Date = "", dateto As %Library.Date = "", types As %Library.String = "", blankcare As %Library.String = "", LocationID As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpCPActivityFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpCPActivityExecute ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpOperSessClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpOperSessFetch ]
{
}

/// Default implementation of LookUp Query.
/// Log 41687 - add code to include timeleft in hours and mins
ClassMethod LookUpOperSessExecute(ByRef QHandle As %Library.Binary, date As %Library.Date = {+$h}, Resource As %Library.String = "", Location As %Library.String = "", Surgeon As %Library.String = "", Anaeth As %Library.String = "", ignore As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpOperSessFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpOperSessExecute ]
{
}

ClassMethod LookUpSessByResClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpSessByResFetch ]
{
}

ClassMethod LookUpSessByResExecute(ByRef QHandle As %Library.Binary, CTLOCDesc As %Library.String = "", RESDesc As %Library.String = "", SessDesc As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpSessByResFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpSessByResExecute ]
{
}

ClassMethod LookUpSessDescClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpSessDescFetch ]
{
}

/// TP: Dec 2001: Called from component webcommon.DateFromTo.Custom
ClassMethod LookUpSessDescExecute(ByRef QHandle As %Library.Binary, ClinDesc As %Library.String) As %Library.Status
{
}

ClassMethod LookUpSessDescFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpSessDescExecute ]
{
}

ClassMethod LookUpSessionClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpSessionFetch ]
{
}

/// TP: Dec 2001: Called from component webcommon.DateFromTo.Custom
ClassMethod LookUpSessionExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, dfrom As %Library.String, dto As %Library.String, resdesc As %Library.String, locdesc As %Library.String) As %Library.Status
{
}

ClassMethod LookUpSessionFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpSessionExecute ]
{
}

ClassMethod LookUpBySessTypeDescAClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpBySessTypeDescAFetch ]
{
}

/// TP: Dec 2001: Called from component webcommon.DateFromTo.Custom
ClassMethod LookUpBySessTypeDescAExecute(ByRef QHandle As %Library.Binary, ClinDesc As %Library.String, CTLOCDesc As %Library.String, RESDesc As %Library.String, DOW As %Library.String, GroupID As %Library.String) As %Library.Status
{
}

ClassMethod LookUpBySessTypeDescAFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpBySessTypeDescAExecute ]
{
}

ClassMethod LookUpBySessTypeDescBClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpBySessTypeDescBFetch ]
{
}

/// TP: Dec 2001: Called from component webcommon.DateFromTo.Custom
ClassMethod LookUpBySessTypeDescBExecute(ByRef QHandle As %Library.Binary, ClinDesc As %Library.String, LocId As %Library.String, ResId As %Library.String, DOW As %Library.String, Date As %Library.String) As %Library.Status
{
}

ClassMethod LookUpBySessTypeDescBFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpBySessTypeDescBExecute ]
{
}

/// A method for changing a string of Session IDs into a string of session ID that only start in AM or end in the PM
ClassMethod ModifySessionList(RBSessIDs As %Library.String = "", Pref As %Library.String = 4) As %Library.String
{
}

/// This function returns the next days date for the next sessions
/// for a give resource.
ClassMethod NextDay(res As %String = "", date As %String = {+$h}) As %String
{
}

/// Default implementation of LookUp Query.
ClassMethod getTotalCPActivity(CareProvID As %Library.String = "", datefrom As %Library.Date = "", dateto As %Library.Date = "") As %Library.String [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

//CS Log 43778 18/05/04

//Finds totals of bookings by CareProvider in the specified date range.

//If type of bookings specified, then bookings are filtered by the types.  

//Types could be S (Surgeon), A (Anaesthetist) and R (Radiology).

ClassMethod getTotalCPActivityByType(CareProvID As %Library.String = "", datefrom As %Library.Date = "", dateto As %Library.Date = "", types As %Library.String = "") As %Library.String [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Returns the previous date on which the resource has the current session
ClassMethod PrevDay(res As %String = "", date As %String = {+$h}) As %String
{
}

ClassMethod IsIrregInSess(SchedID As %Library.String = "") As %Library.String
{
}

ClassMethod otsessionbookings(sess As %Library.String = "", dt As %Library.String = {+$h}, res As %Library.String = "", surg As %Library.String = "") As %Library.String
{
}

ClassMethod OTSessionInProgress(SchedID As %Library.String) As %Library.Integer
{
}

ClassMethod OTProcedureChanged(SchedID As %Library.String, Status As %Library.String) As %Library.Integer
{
}

ClassMethod OTSessionProgressOnTime(SchedID As %Library.String) As %Library.Integer
{
}

ClassMethod GetNAPeriod(sess As %Library.String = "", fdate As %Library.String = {+$h}, resId As %Library.String = "") As %Library.Integer
{
}

/// KM 12-Sept-2001: Called From Component RBResEffDateSession.List
Query FindSessByRSDate(RescID As %Library.String, date As %Library.Date) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,TimeStart,TimeEnd,SessionType,messageID")
{
}

/// KM 12-Sept-2001: Called From Component RBResEffDateSession.List
Query FindSessionDetails(RBSessIDs As %Library.String, eDate As %Date, allsess As %Library.String, showbuttons As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,ParRef,CareProv,Clinic,DateLogical,DayNum,Day,DateFrom,DateTo,TimeFrom,TimeTo,Booked,SlotLength,ApptsPerSlot,Description,Message,MsgID,Hospital,Room,SessType,Overbookings,ClinicMax,VarID,Vacant,varCode,CareProvId,apptsBooked,AllSessForDay,OPDRoom")
{
}

Query LookUpBySessTypeDesc(ClinDesc As %Library.String, CTLOCDesc As %Library.String, RESDesc As %Library.String, DOW As %Library.String, Date As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "SESSDesc,CTLOCDesc,RESDesc,HIDDEN")
{
SELECT DISTINCT BY (SESS_SessionType_DR->SESS_Desc) SESS_SessionType_DR->SESS_Desc,SESS_ParRef->DATE_ParRef->RES_CTLOC_DR->CTLOC_Desc,SESS_ParRef->DATE_ParRef->RES_Desc,SESS_RowId
FROM SQLUser.RB_ResEffDateSession
WHERE ((%ALPHAUP(SESS_SessionType_DR->SESS_Desc) [%ALPHAUP(:ClinDesc)) OR ((:ClinDesc IS NULL) AND (SESS_SessionType_DR->SESS_Desc IS NULL)))
AND (%ALPHAUP(SESS_ParRef->DATE_ParRef->RES_CTLOC_DR->CTLOC_Desc) = %ALPHAUP(:CTLOCDesc) OR (:CTLOCDesc IS NULL))
AND (%ALPHAUP(SESS_ParRef->DATE_ParRef->RES_Desc) = %ALPHAUP(:RESDesc) OR (:RESDesc IS NULL))
AND ((:Date <= SESS_ScheduleGeneratedUntil) OR (:Date IS NULL))
AND ((SESS_DOW_DR = :DOW) OR (:DOW IS NULL))
ORDER BY SESS_SessionType_DR->SESS_Desc,SESS_ParRef->DATE_ParRef->RES_CTLOC_DR->CTLOC_Desc,SESS_ParRef->DATE_ParRef->RES_Desc
}

Query LookUpBySessList(SessList As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Day,SessType,HIDDEN")
{
}

ClassMethod LookUpBySessListExecute(ByRef QHandle As %Library.Binary, SessList As %Library.String) As %Library.Status
{
}

ClassMethod LookUpBySessListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpBySessListExecute ]
{
}

ClassMethod LookUpBySessListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpBySessListFetch ]
{
}

Query LookUpBySessTypeDescA(ClinDesc As %Library.String, CTLOCDesc As %Library.String, RESDesc As %Library.String, DOW As %Library.String, GroupID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "SESSDesc,HIDDEN,HIDDEN,HIDDEN")
{
}

Query LookUpBySessTypeDescB(ClinDesc As %Library.String, LocId As %Library.String, ResId As %Library.String, DOW As %Library.String, Date As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "SESSDesc,CTLOCDesc,RESDesc,HIDDEN")
{
}

/// A query to find information about a resource 
/// to make a booking for an operation
Query LookUpCPActivity(CareProvID As %Library.String, datefrom As %Library.Date, dateto As %Library.Date, types As %Library.String, blankcare As %Library.String, LocationID As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "CareProvID:%String,RescDesc:%String,RescID:%String,LocDesc:%String,LocationID:%String,sessid:%String,date:%Date,starttime:%Time,endtime:%Time,booked:%String,Anaest:%String,anabooked:%String,surg:%String,surbooked:%String,rad:%String,rdbooked:%String,anothercp:%String")
{
SELECT ID
FROM RBResEffDateSession
}

Query LookUpDesc(ClinDesc As %Library.String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "SESSDesc,CTLOCDesc,RESDesc,hidden")
{
SELECT SESS_Desc,
SESS_ParRef->DATE_ParRef->RES_CTLOC_DR->CTLOC_Desc,
SESS_ParRef->DATE_ParRef->RES_Desc,
SESS_RowId
FROM SQLUser.RB_ResEffDateSession
WHERE (SESS_Desc %STARTSWITH :ClinDesc) AND (SESS_Desc IS NOT NULL)
}

/// A query to find information about a resource 
/// to make a booking for an operation
Query LookUpOperSess(Date As %Library.Date, Resource As %Library.String, Location As %Library.String, Surgeon As %Library.String, Anaeth As %Library.String, ignore As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "date:%String,starttime:%String,Resource:%String,Location:%String,Booked:%String,Vacant:%String,hidden,hidden,hidden,hidden,timeleft:%Integer,hidden,timeleftHHMM:%String,EstTime:%String,hidden:%String,Surgeon:%String,Anaesthetist:%String,hidden:%String")
{
}

Query LookUpSessByRes(CTLOCDesc As %Library.String, RESDesc As %Library.String, SessDesc As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "dow,HIDDEN,stime,etime,sessTypeDesc,resEffDate")
{
}

Query LookUpSessDesc(ClinDesc As %Library.String) As %Library.Query(CONTAINID = "", ROWSPEC = "SESSDesc,CTLOCDesc,RESDesc,hidden")
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpSession(desc As %String, dfrom As %String, dto As %String, resdesc As %String, locdesc As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "SESSDesc:%String,HIDDEN:%String,RESDesc:%String,HIDDEN:%String")
{
}

Query LookUpSessionsbyRescID(RescID As %Library.String, Date As %Library.Date) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "ID,TimeStart,TimeEnd,SessionType,DOW,ScheduleGeneratedUntil,ScheduleStartDate")
{
select SESS_RowId,SESS_TimeStart,SESS_TimeEnd,SESS_SessionType_DR->SESS_Desc,SESS_DOW_DR,SESS_ScheduleGeneratedUntil,SESS_ScheduleStartDate
from SQLUser.RB_ResEffDateSession
where SESS_ParRef->DATE_ParRef=:RescID
and (SESS_ScheduleStartDate<=:Date)
and (:Date <= SESS_ScheduleGeneratedUntil)
order by SESS_DOW_DR
}

}
