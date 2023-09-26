Include webimport

IncludeGenerator webimport

Class web.PASocHist Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 210;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SCH_RowId";

Parameter SQLDESCRIPTION = "SCH_Desc";

Parameter SQLROWID = "SCH_RowId";

Property dummy As %String(TRUNCATE = 1);

/// Author - John Hart
/// Purpose - Saves PatientSocial History Details
/// Used By - EPR page
/// Log 58610 - GC - 26-04-2006 : Add new argument DSReportFlag
ClassMethod HistoryInsert(compref As %Library.String, pid As %String, habit As %String, qtyDesc As %String, onsetDate As %String, comments As %String, hid As %String, chkInActive As %Library.String, DSReportFlag As %Library.String, Duration As %Library.String, DurationDesc As %Library.String, ApproxOnset As %Library.String)
{
}

ClassMethod HistoryClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = HistoryFetch ]
{
}

ClassMethod HistoryExecute(ByRef QHandle As %Library.Binary, PatientID As %String) As %Library.Status
{
}

ClassMethod HistoryFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = HistoryExecute ]
{
}

/// Query to retrieve data from multiple tables:
/// PADesease (!),PAPastHistCondition,PAOperation,PAAllergy,PASocHist,PAFamily
/// ;
/// This query requires that the 'Find' queries are consistent.
/// Log 32090 - AI - 17-04-2003 : Add Last Update fields - Date, Time, Hospital.
/// Log 42561 - AI - 27-02-2004 : Now add Last Update User Code.
/// Log 58610 - GC - 26-04-2006 : Add DSReportFlag to ROWSPEC
Query History(PatientID As %String) As %Query(CONTAINID = 1, ROWSPEC = "ID,Type:%String,Desc:%String,OnsetDate:%Date,Years,Months,Days,Comments:%List,CareProvider:%String,UpdateUser:%String,HistoryType:%String,HistoryDesc:%String,CommentsDisplay:%String,chkInActive:%String,UpdateDate:%Date,UpdateTime:%Time,UpdateHospitalDesc:%String,UpdateUserCode:%String,HiddenFields:%String,Quantity:%String,DSReportFlag:%String,Duration:%String,DurationDesc:%String,ApproxOnsetDate:%String")
{
}

Query Edit(ID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,HABDesc:%String,QTYDesc:%String,SCHOnsetDate:%Date,SCHDuratYear:%Float,SCHDuratMonth:%Float,SCHDuratDays:%Float,SCHDesc:%List,PID:%String,SCHHabitsDR:%String,SCHHabitsQtyDR:%String")
{
SELECT SCH_RowID, SCH_Habits_DR->HAB_Desc, SCH_HabitsQty_DR->QTY_Desc, SCH_OnsetDate, SCH_DuratYear, SCH_DuratMonth, SCH_DuratDays, SCH_Desc, SCH_PAPMI_ParRef, SCH_Habits_DR, SCH_HabitsQty_DR
FROM PA_SocHist
WHERE (SCH_RowID = :ID)
}

Query Find(PatientID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,QTYDesc:%String,SCHOnsetDate:%Date,SCHDuratYear:%String,SCHDuratMonth:%String,SCHDuratDays:%String,SCHDesc:%List,SCHCareProv:%String,QTYDesc:%String,UpdateUser:%String")
{
SELECT SCH_RowID, SCH_Habits_DR->HAB_Desc, 
 SCH_OnsetDate, SCH_DuratYear, 
 SCH_DuratMonth, SCH_DuratDays, SCH_Desc, 
 SCH_CTCP_DR->CTPCP_Desc,
 SCH_UpdateUser_DR->SSUSR_Name,
 SCH_HabitsQty_DR->QTY_Desc
FROM PA_SocHist
WHERE (SCH_PAPMI_ParRef = :PatientID)
}

/// Called by web.PAPatMas.HistoryExecute
/// Used in EPR Chart, Patient History, History.
/// LOG 26677 - AI - 25-07-2002 : Find With InActive checkbox value.
/// Log 32090 - AI - 17-04-2003 : Add Last Update fields - Date, Time, Hospital.
/// Log 42561 - AI - 27-02-2004 : Now add Last Update User Code (Initials).
/// Log 58610 - GC - 26-04-2006 : Add SCH_DSReportFlag to the SELECT list.
Query FindWithInActive(PatientID As %String, InActive As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,QTYDesc:%String,SCHOnsetDate:%Date,SCHDuratYear:%String,SCHDuratMonth:%String,SCHDuratDays:%String,SCHDesc:%List,SCHCareProv:%String,UpdateUser:%String,SCHInActive:%String,UpdateDate:%Date,UpdateTime:%Time,UpdateHospitalDesc:%String,QTYDesc:%String,UpdateUserCode:%String,DSReportFlag:%String,Duration:%String,DurationDesc:%String,ApproxOnsetDate:%String")
{
SELECT SCH_RowID,
 SCH_Habits_DR->HAB_Desc,
 SCH_OnsetDate,
 SCH_DuratYear,
 SCH_DuratMonth,
 SCH_DuratDays,
 SCH_Desc,
 SCH_CTCP_DR->CTPCP_Desc,
 SCH_UpdateUser_DR->SSUSR_Name,
 SCH_InActive,
 SCH_UpdateDate,
 SCH_UpdateTime,
 SCH_UpdateHospital_DR->HOSP_Desc,
 SCH_HabitsQty_DR->QTY_Desc,
 SCH_UpdateUser_DR->SSUSR_Initials,
 SCH_DSReportFlag,
 SCH_Duration,
 SCH_DurationDesc,
 SCH_ApproxOnsetDate
FROM PA_SocHist
WHERE ((SCH_PAPMI_ParRef = :PatientID) AND ((SCH_InActive = :InActive) OR (:InActive = 'Y' AND SCH_InActive IS NULL)))
}

/// Log 58610 - GC 26/04/2006 : Save the DS Report Flag.
ClassMethod websysUpdateDSReportFlag(id As %Library.String = "") As %Boolean
{
}

}
