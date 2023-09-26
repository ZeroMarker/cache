Include webimport

IncludeGenerator webimport

Class web.RBApptSchedule Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 452;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetSurgOrAna(SessId As %Library.String, Type As %Library.String = "") As %Library.String
{
}

ClassMethod GetMainSchedFromFO(SchedID As %Library.String) As %Library.String
{
}

ClassMethod GetDateAndTime(ID As %Library.String, ByRef date As %Library.String = "", ByRef starttime As %Library.String = "")
{
}

/// A function that returns 1 if a Resource has a schedule in the date range from the date past 
/// to the Sudnay of that week.
ClassMethod ResSchedPresent(RescID As %Library.String = "", sDate As %Library.String = "", eDate As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "AS_RowId";

Parameter SQLDESCRIPTION = "AS_RowId";

Parameter SQLROWID = "AS_RowId";

Query Find(resc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ASDate:%Date,ASSession:%String,ASSessStartTime:%Time,ASSessEndTime:%Time")
{
SELECT AS_RowID, AS_Date, AS_Session, AS_SessStartTime, AS_SessEndTime
FROM RB_ApptSchedule
WHERE (AS_RES_ParRef->RES_RowID = :resc)
ORDER BY AS_SessStartTime
}

Query FindScheduleByDateRes(resId As %String = "", locId As %String = "", sDate As %Date = "", resList As %String = "", locDesc As %Library.String = "", RetainValues As %Library.String = "", OPStatus As %Library.String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,ASDate:%Date,ASSession:%String,ASSessStartTime:%Time,ASSessEndTime:%Time,CTLocId:%String,ResId:%String,SessId:%String,SessDesc:%String,SessType:%String,ASSessType:%String,ASRemarks:%String")
{
}

ClassMethod FindScheduleByDateResClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindScheduleByDateResFetch ]
{
}

ClassMethod FindScheduleByDateResExecute(ByRef QHandle As %Library.Binary, resId As %String = "", locId As %String = "", sDate As %Date = "", resList As %String = "", locDesc As %Library.String = "", RetainValues As %Library.String = "", OPStatus As %Library.String = "") As %Library.Status
{
}

ClassMethod FindScheduleByDateResFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindScheduleByDateResExecute ]
{
}

ClassMethod GetSessDesc(SchedID As %Library.String) As %Library.String
{
}

ClassMethod GetSessType(SchedID As %Library.String) As %Library.String
{
}

ClassMethod SwapSchedules(compref As %Library.String, SchedID1 As %Library.String, SchedID2 As %Library.String) As %Library.String
{
}

/// Log 56831 - 22.12.2006 - Return Clinic Type - will get from session level if blank
ClassMethod getClinicType(SessID As %String = "", Date As %String = "", flag As %String = "")
{
}

/// Log 56831 - 10.01.2007 - Return OPD Room
ClassMethod getOPDRoom(SessID As %String = "", Date As %String = "")
{
}

/// Log 56831 - 22.12.2006 - Save OPD Room/Clinic Details
ClassMethod websysSaveClinicDayDefaults(compref As %String, ID As %String, Date As %String, ClinicType As %String = "")
{
}

Query ListDiaryView(ResId As %Library.String = "", StartDate As %Library.String = "", EndDate As %Library.String = "", StartTime As %Library.String = "", EndTime As %Library.String = "", DaysOfWeek As %Library.String = "", Book As %Library.String = "", LocId As %Library.String = "", ServId As %Library.String = "", InsTypeDr As %Library.String = "", HospIDs As %Library.String = "", CareProvId As %Library.String = "", Params As %Library.String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,StartTime:%String,Service:%String,Duration:%String,ServId:%String,chk:%String,SessionType:%String,Load:%String,Price:%String")
{
}

ClassMethod ListDiaryViewClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListOfServicesFetch ]
{
}

ClassMethod ListDiaryViewExecute(ByRef QHandle As %Library.Binary, ResId As %Library.String = "", StartDate As %Library.String = "", EndDate As %Library.String = "", StartTime As %Library.String = "", EndTime As %Library.String = "", DaysOfWeek As %Library.String = "", Book As %Library.String = "", LocId As %Library.String = "", ServId As %Library.String = "", InsTypeDr As %Library.String = "", HospIDs As %Library.String = "", CareProvId As %Library.String = "", Params As %Library.String = "") As %Library.Status
{
}

ClassMethod ListDiaryViewFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListOfServicesExecute ]
{
}

ClassMethod GetServiceRowStr(chk, schedID, servID, params)
{
}

ClassMethod IsServiceData(servID) As %Library.Boolean
{
}

ClassMethod repeat(xstr, xno)
{
}

ClassMethod KillSessVars()
{
}

ClassMethod ConvertSessDesc(SessDesc)
{
}

ClassMethod GetSlotServices(SchedID) As %Library.String
{
}

}
